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