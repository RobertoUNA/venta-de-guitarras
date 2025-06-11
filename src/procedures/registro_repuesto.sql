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