---------------CREACIÓN DE LA BASE DE DATOS---------------
CREATE DATABASE proyecto_ventaguitarras;
GO
---------------CAMBIO DEL CONTEXTO PARA TRABAJAR DENTRO DE ESA BASE DE DATOS---------------
USE proyecto_ventaguitarras;
GO

---------------TABLAS---------------
CREATE TABLE persona (
    id_persona INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario NVARCHAR(50) NOT NULL,
    primer_apellido NVARCHAR(50) NOT NULL,
    segundo_apellido NVARCHAR(50),
    correo_electronico NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    fecha_registro DATE NOT NULL DEFAULT GETDATE(),
    tipo_usuario NVARCHAR(20) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

CREATE TABLE profesor (
    id_profesor INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    especialidad NVARCHAR(100),
    experiencia_anhos INT,
    tarifa_hora DECIMAL(10,2),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

CREATE TABLE estudiante (
    id_estudiante INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(50) NOT NULL,
    descripcion_categoria NVARCHAR(200)
);

CREATE TABLE producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto NVARCHAR(100) NOT NULL,
    descripcion_producto NVARCHAR(200),
    marca_producto NVARCHAR(50),
    modelo_producto NVARCHAR(50),
    precio_producto DECIMAL(10,2) NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE tipo_guitarra (
    id_tipo_guitarra INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(200)
);

CREATE TABLE guitarra (
    id_producto INT PRIMARY KEY,
    id_tipo_guitarra INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_tipo_guitarra) REFERENCES tipo_guitarra(id_tipo_guitarra)
);

CREATE TABLE repuesto (
    id_repuesto INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    tipo_repuesto NVARCHAR(50),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE inventario (
    id_inventario INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_actualizacion DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE tag (
    id_tag INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tag NVARCHAR(50) NOT NULL,
    descripcion_tag NVARCHAR(200)
);

CREATE TABLE producto_tag (
    id_tag INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_tag, id_producto),
    FOREIGN KEY (id_tag) REFERENCES tag(id_tag),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE oferta (
    id_oferta INT IDENTITY(1,1) PRIMARY KEY,
    nombre_oferta NVARCHAR(100) NOT NULL,
    descripcion_oferta NVARCHAR(200),
    tipo_oferta NVARCHAR(50),
    valor_descuento DECIMAL(10,2),
    fecha_inicio DATE,
    fecha_cierre DATE,
    estado_oferta NVARCHAR(20)
);

CREATE TABLE producto_oferta (
    id_producto_oferta INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    id_oferta INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_oferta) REFERENCES oferta(id_oferta)
);

CREATE TABLE historial_precios (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    direccion_pedido NVARCHAR(200),
    estado_pedido NVARCHAR(20),
    metodo_pago NVARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_pedido (
    id_detalle_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE clase (
    id_clase INT IDENTITY(1,1) PRIMARY KEY,
    id_profesor INT NOT NULL,
    nombre_clase NVARCHAR(100),
    descripcion_clase NVARCHAR(200),
    fecha_hora_inicio DATETIME,
    fecha_hora_fin DATETIME,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
);

CREATE TABLE matricula (
    id_matricula INT IDENTITY(1,1) PRIMARY KEY,
    id_clase INT NOT NULL,
    id_estudiante INT NOT NULL,
    FOREIGN KEY (id_clase) REFERENCES clase(id_clase),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

CREATE TABLE auditoria (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada NVARCHAR(50),
    operacion NVARCHAR(20),
    id_registro INT,
    fecha_operacion DATETIME NOT NULL DEFAULT GETDATE(),
    datos_anteriores NVARCHAR(MAX),
    datos_nuevos NVARCHAR(MAX)
);
GO
---------------TABLAS---------------

---------------VISTAS---------------
-- Vista: Guitarras más vendidas en el último mes
CREATE VIEW vw_guitarras_mas_vendidas_ultimo_mes AS
SELECT TOP 10
    p.id_producto,
    p.nombre_producto,
    SUM(dp.cantidad) AS total_vendidas
FROM producto p
INNER JOIN guitarra g ON p.id_producto = g.id_producto
INNER JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
INNER JOIN pedido pe ON dp.id_pedido = pe.id_pedido
WHERE pe.fecha_pedido >= DATEADD(MONTH, -1, GETDATE())
GROUP BY p.id_producto, p.nombre_producto
ORDER BY total_vendidas DESC;
GO

-- Vista: Buscar guitarras por tipo, marca, nombre
CREATE VIEW vw_buscar_guitarras AS
SELECT
    p.id_producto,
    p.nombre_producto,
    p.marca_producto,
    p.modelo_producto,
    g.id_tipo_guitarra,
    tg.nombre AS tipo_guitarra,
    p.precio_producto,
    i.cantidad AS stock_producto
FROM producto p
INNER JOIN guitarra g ON p.id_producto = g.id_producto
INNER JOIN tipo_guitarra tg ON g.id_tipo_guitarra = tg.id_tipo_guitarra
LEFT JOIN inventario i ON p.id_producto = i.id_producto;
GO

-- Vista: Historial de clases de un profesor
CREATE VIEW vw_historial_clases_profesor AS
SELECT
    pr.id_profesor,
    pe.nombre_usuario AS nombre_profesor,
    c.id_clase,
    c.nombre_clase,
    c.descripcion_clase,
    c.fecha_hora_inicio,
    c.fecha_hora_fin,
    (pr.tarifa_hora * DATEDIFF(HOUR, c.fecha_hora_inicio, c.fecha_hora_fin)) AS precio_clase -- Campo calculado
FROM clase c
INNER JOIN profesor pr ON c.id_profesor = pr.id_profesor
INNER JOIN persona pe ON pr.id_persona = pe.id_persona;
GO

-- Vista: Historial de clases de un estudiante
CREATE VIEW vw_historial_clases_estudiante AS
SELECT
    es.id_estudiante,
    pe.nombre_usuario AS nombre_estudiante,
    c.id_clase,
    c.nombre_clase,
    c.descripcion_clase,
    c.fecha_hora_inicio,
    c.fecha_hora_fin,
    (pr.tarifa_hora * DATEDIFF(HOUR, c.fecha_hora_inicio, c.fecha_hora_fin)) AS precio_clase -- Campo calculado
FROM clase c
INNER JOIN matricula m ON c.id_clase = m.id_clase
INNER JOIN estudiante es ON m.id_estudiante = es.id_estudiante
INNER JOIN persona pe ON es.id_persona = pe.id_persona
INNER JOIN profesor pr ON c.id_profesor = pr.id_profesor; 
GO

-- Vista: Historial de precios de un producto
CREATE VIEW vw_historial_precios_producto AS
SELECT
    p.id_producto,
    p.nombre_producto,
    hp.precio_anterior,
    hp.precio_nuevo,
    hp.fecha_cambio
FROM producto p
INNER JOIN historial_precios hp ON p.id_producto = hp.id_producto;
GO

-- Vista: Pedidos (como "carrito de compra" local)
-- En un sistema local, el pedido cumple la función de carrito, mostrando los productos agregados antes de finalizar la compra.
CREATE VIEW vw_pedidos_abiertos AS
SELECT
    pe.id_pedido,
    pe.id_cliente,
    pe.fecha_pedido,
    pe.estado_pedido,
    dp.id_producto,
    p.nombre_producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal
FROM pedido pe
INNER JOIN detalle_pedido dp ON pe.id_pedido = dp.id_pedido
INNER JOIN producto p ON dp.id_producto = p.id_producto
WHERE pe.estado_pedido = 'Abierto';
GO
---------------VISTAS---------------

---------------TRIGGERS---------------
-- Trigger de auditoría para la tabla producto (INSERT y UPDATE)

CREATE TRIGGER trg_auditoria_producto
ON producto
AFTER INSERT, UPDATE
AS
BEGIN
    -- Para INSERT
    INSERT INTO auditoria (tabla_afectada, operacion, id_registro, fecha_operacion, datos_anteriores, datos_nuevos)
    SELECT
        'producto',
        'INSERT',
        i.id_producto,
        GETDATE(),
        NULL,
        CONCAT('Nombre: ', i.nombre_producto, ', Precio: ', i.precio_producto)
    FROM inserted i
    LEFT JOIN deleted d ON i.id_producto = d.id_producto
    WHERE d.id_producto IS NULL;

    -- Para UPDATE
    INSERT INTO auditoria (tabla_afectada, operacion, id_registro, fecha_operacion, datos_anteriores, datos_nuevos)
    SELECT
        'producto',
        'UPDATE',
        i.id_producto,
        GETDATE(),
        CONCAT('Nombre: ', d.nombre_producto, ', Precio: ', d.precio_producto),
        CONCAT('Nombre: ', i.nombre_producto, ', Precio: ', i.precio_producto)
    FROM inserted i
    INNER JOIN deleted d ON i.id_producto = d.id_producto;
END;
GO

-- Trigger de auditoría para la tabla clase (UPDATE para cancelación)

CREATE TRIGGER trg_auditoria_clase_update
ON clase
AFTER UPDATE
AS
BEGIN
    INSERT INTO auditoria (tabla_afectada, operacion, id_registro, fecha_operacion, datos_anteriores, datos_nuevos)
    SELECT
        'clase',
        'UPDATE',
        i.id_clase,
        GETDATE(),
        CONCAT('Descripcion: ', d.descripcion_clase, ', Fecha Fin: ', CONVERT(NVARCHAR, d.fecha_hora_fin, 120)),
        CONCAT('Descripcion: ', i.descripcion_clase, ', Fecha Fin: ', CONVERT(NVARCHAR, i.fecha_hora_fin, 120))
    FROM inserted i
    INNER JOIN deleted d ON i.id_clase = d.id_clase;
END;
GO
---------------TRIGGERS---------------

---------------PROCEDIMIENTOS-ALMACENADOS---------------

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
    SET QUOTED_IDENTIFIER ON;
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
    SET QUOTED_IDENTIFIER ON;
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
    @fecha_hora_fin DATETIME
AS
BEGIN
    INSERT INTO clase (id_profesor, nombre_clase, descripcion_clase, fecha_hora_inicio, fecha_hora_fin)
    VALUES (@id_profesor, @nombre_clase, @descripcion_clase, @fecha_hora_inicio, @fecha_hora_fin);
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
GO
---------------PROCEDIMIENTOS-ALMACENADOS---------------