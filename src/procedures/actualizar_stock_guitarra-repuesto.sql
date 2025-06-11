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
