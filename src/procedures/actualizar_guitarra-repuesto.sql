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