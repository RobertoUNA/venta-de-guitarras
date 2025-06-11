USE proyecto_ventaguitarras
GO 

-- Registrar una nueva guitarra
CREATE PROCEDURE sp_registrar_guitarra
    @nombre_producto NVARCHAR(100),
    @descripcion_producto NVARCHAR(200),
    @marca_producto NVARCHAR(50),
    @modelo_producto NVARCHAR(50),
    @precio_producto DECIMAL(10,2),
    @id_categoria INT,
    @id_tipo_guitarra INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO producto (nombre_producto, descripcion_producto, marca_producto, modelo_producto, precio_producto, id_categoria)
        VALUES (@nombre_producto, @descripcion_producto, @marca_producto, @modelo_producto, @precio_producto, @id_categoria);

        DECLARE @id_producto INT = SCOPE_IDENTITY();

        INSERT INTO guitarra (id_producto, id_tipo_guitarra)
        VALUES (@id_producto, @id_tipo_guitarra);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Buscar guitarras por nombre (búsqueda parcial)
CREATE PROCEDURE sp_buscar_guitarras_por_nombre
    @nombre NVARCHAR(100)
AS
BEGIN
    SELECT
        p.id_producto,
        p.nombre_producto,
        p.descripcion_producto,
        p.marca_producto,
        p.modelo_producto,
        p.precio_producto,
        tg.nombre AS tipo_guitarra,
        c.nombre_categoria,
        ISNULL(i.cantidad, 0) AS stock_disponible
    FROM producto p
    INNER JOIN guitarra g ON p.id_producto = g.id_producto
    INNER JOIN tipo_guitarra tg ON g.id_tipo_guitarra = tg.id_tipo_guitarra
    INNER JOIN categoria c ON p.id_categoria = c.id_categoria
    LEFT JOIN inventario i ON p.id_producto = i.id_producto
    WHERE p.nombre_producto LIKE '%' + @nombre + '%'
    ORDER BY p.nombre_producto;
END;
GO

-- Buscar guitarras por marca
CREATE PROCEDURE sp_buscar_guitarras_por_marca
    @marca NVARCHAR(50)
AS
BEGIN
    SELECT
        p.id_producto,
        p.nombre_producto,
        p.descripcion_producto,
        p.marca_producto,
        p.modelo_producto,
        p.precio_producto,
        tg.nombre AS tipo_guitarra,
        c.nombre_categoria,
        ISNULL(i.cantidad, 0) AS stock_disponible
    FROM producto p
    INNER JOIN guitarra g ON p.id_producto = g.id_producto
    INNER JOIN tipo_guitarra tg ON g.id_tipo_guitarra = tg.id_tipo_guitarra
    INNER JOIN categoria c ON p.id_categoria = c.id_categoria
    LEFT JOIN inventario i ON p.id_producto = i.id_producto
    WHERE p.marca_producto LIKE '%' + @marca + '%'
    ORDER BY p.marca_producto, p.modelo_producto;
END;
GO

-- Buscar guitarras por nombre de tipo
CREATE PROCEDURE sp_buscar_guitarras_por_tipo 
    @nombre_tipo NVARCHAR(50) = NULL 
AS 
BEGIN 
    SELECT 
        p.id_producto, 
        p.nombre_producto, 
        p.descripcion_producto, 
        p.marca_producto, 
        p.modelo_producto, 
        p.precio_producto, 
        tg.nombre AS tipo_guitarra, 
        c.nombre_categoria, 
        ISNULL(i.cantidad, 0) AS stock_disponible 
    FROM producto p 
        INNER JOIN guitarra g ON p.id_producto = g.id_producto 
        INNER JOIN tipo_guitarra tg ON g.id_tipo_guitarra = tg.id_tipo_guitarra 
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria 
        LEFT JOIN inventario i ON p.id_producto = i.id_producto 
    WHERE 
        (@nombre_tipo IS NULL OR tg.nombre LIKE '%' + @nombre_tipo + '%') 
    ORDER BY 
        tg.nombre, p.precio_producto; 
END; 
GO

-- Registrar un nuevo repuesto:
CREATE PROCEDURE sp_registrar_repuesto
    @nombre_producto NVARCHAR(100),
    @descripcion_producto NVARCHAR(200),
    @marca_producto NVARCHAR(50),
    @modelo_producto NVARCHAR(50),
    @precio_producto DECIMAL(10,2),
    @id_categoria INT,
    @tipo_repuesto NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO producto (nombre_producto, descripcion_producto, marca_producto, modelo_producto, precio_producto, id_categoria)
        VALUES (@nombre_producto, @descripcion_producto, @marca_producto, @modelo_producto, @precio_producto, @id_categoria);

        DECLARE @id_producto INT = SCOPE_IDENTITY();

        INSERT INTO repuesto (id_producto, tipo_repuesto)
        VALUES (@id_producto, @tipo_repuesto);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Registrar un producto general con tags opcionales
CREATE PROCEDURE sp_registrar_producto
    @nombre_producto NVARCHAR(100),
    @descripcion_producto NVARCHAR(200),
    @marca_producto NVARCHAR(50),
    @modelo_producto NVARCHAR(50),
    @precio_producto DECIMAL(10,2),
    @id_categoria INT,
    @tags XML = NULL -- Ejemplo: <tags><tag id="1" /><tag id="2" /></tags>
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO producto (nombre_producto, descripcion_producto, marca_producto, modelo_producto, precio_producto, id_categoria)
        VALUES (@nombre_producto, @descripcion_producto, @marca_producto, @modelo_producto, @precio_producto, @id_categoria);

        DECLARE @id_producto INT = SCOPE_IDENTITY();

        -- Agregar tags si se proporcionaron
        IF @tags IS NOT NULL
        BEGIN
            INSERT INTO producto_tag (id_producto, id_tag)
            SELECT 
                @id_producto,
                T.Item.value('@id', 'INT')
            FROM @tags.nodes('/tags/tag') AS T(Item);
        END

        COMMIT TRANSACTION;
        SELECT @id_producto AS id_producto_creado;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

--Actualizar una guitarra o repuesto:
CREATE PROCEDURE sp_actualizar_producto
    @id_producto INT,
    @nombre_producto NVARCHAR(100),
    @descripcion_producto NVARCHAR(200),
    @marca_producto NVARCHAR(50),
    @modelo_producto NVARCHAR(50),
    @precio_producto DECIMAL(10,2),
    @id_categoria INT = NULL
AS
BEGIN
    UPDATE producto
    SET nombre_producto = @nombre_producto,
        descripcion_producto = @descripcion_producto,
        marca_producto = @marca_producto,
        modelo_producto = @modelo_producto,
        precio_producto = @precio_producto,
        id_categoria = ISNULL(@id_categoria, id_categoria)
    WHERE id_producto = @id_producto;
END;
GO 

--Actualizar la cantidad disponible de una guitarra o repuesto:
CREATE PROCEDURE sp_actualizar_stock
    @id_producto INT,
    @cantidad INT
AS
BEGIN
    UPDATE inventario
    SET cantidad = @cantidad,
        fecha_actualizacion = GETDATE()
    WHERE id_producto = @id_producto;
END;
GO 

-- Agregar o quitar tags de un producto
CREATE PROCEDURE sp_gestionar_tags_producto
    @id_producto INT,
    @id_tag INT,
    @accion NVARCHAR(10) -- 'AGREGAR' o 'QUITAR'
AS
BEGIN
    IF @accion = 'AGREGAR'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM producto_tag WHERE id_producto = @id_producto AND id_tag = @id_tag)
        BEGIN
            INSERT INTO producto_tag (id_producto, id_tag)
            VALUES (@id_producto, @id_tag);
        END
    END
    ELSE IF @accion = 'QUITAR'
    BEGIN
        DELETE FROM producto_tag 
        WHERE id_producto = @id_producto AND id_tag = @id_tag;
    END
END;
GO

-- Registrar/actualizar un pedido:
CREATE PROCEDURE sp_registrar_pedido
    @id_cliente INT,
    @direccion_pedido NVARCHAR(200),
    @estado_pedido NVARCHAR(20),
    @metodo_pago NVARCHAR(50),
    @productos XML -- Ejemplo: <productos><item id_producto="1" cantidad="2" precio_unitario="150.00" /></productos>
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO pedido (id_cliente, direccion_pedido, estado_pedido, metodo_pago)
        VALUES (@id_cliente, @direccion_pedido, @estado_pedido, @metodo_pago);

        DECLARE @id_pedido INT = SCOPE_IDENTITY();

        INSERT INTO detalle_pedido (id_pedido, id_producto, precio_unitario, cantidad, subtotal)
        SELECT 
            @id_pedido,
            T.Item.value('@id_producto', 'INT'),
            T.Item.value('@precio_unitario', 'DECIMAL(10,2)'),
            T.Item.value('@cantidad', 'INT'),
            T.Item.value('@precio_unitario', 'DECIMAL(10,2)') * T.Item.value('@cantidad', 'INT')
        FROM @productos.nodes('/productos/item') AS T(Item);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO 

-- Registrar un profesor:
CREATE PROCEDURE sp_registrar_profesor
    @id_persona INT,
    @especialidad NVARCHAR(100),
    @experiencia_anhos INT,
    @tarifa_hora DECIMAL(10,2)
AS
BEGIN
    INSERT INTO profesor (id_persona, especialidad, experiencia_anhos, tarifa_hora)
    VALUES (@id_persona, @especialidad, @experiencia_anhos, @tarifa_hora);
END;
GO 

-- Registrar una clase:
CREATE PROCEDURE sp_registrar_clase
    @id_profesor INT,
    @nombre_clase NVARCHAR(100),
    @descripcion_clase NVARCHAR(200),
    @fecha_hora_inicio DATETIME,
    @fecha_hora_fin DATETIME,
    @precio_clase DECIMAL(10,2)
AS
BEGIN
    INSERT INTO clase (id_profesor, nombre_clase, descripcion_clase, fecha_hora_inicio, fecha_hora_fin, precio_clase)
    VALUES (@id_profesor, @nombre_clase, @descripcion_clase, @fecha_hora_inicio, @fecha_hora_fin, @precio_clase);
END;
GO

--Registrar una oferta:
CREATE PROCEDURE sp_registrar_oferta
    @nombre_oferta NVARCHAR(100),
    @descripcion_oferta NVARCHAR(200),
    @tipo_oferta NVARCHAR(50),
    @valor_descuento DECIMAL(10,2),
    @fecha_inicio DATE,
    @fecha_cierre DATE,
    @estado_oferta NVARCHAR(20)
AS
BEGIN
    INSERT INTO oferta (nombre_oferta, descripcion_oferta, tipo_oferta, valor_descuento, fecha_inicio, fecha_cierre, estado_oferta)
    VALUES (@nombre_oferta, @descripcion_oferta, @tipo_oferta, @valor_descuento, @fecha_inicio, @fecha_cierre, @estado_oferta);
END;
GO 

 -- Cancelar una clase:
 CREATE PROCEDURE sp_cancelar_clase
    @id_clase INT
AS
BEGIN
    UPDATE clase
    SET descripcion_clase = CONCAT(descripcion_clase, ' (CANCELADA)'),
        fecha_hora_fin = GETDATE()
    WHERE id_clase = @id_clase;
END;