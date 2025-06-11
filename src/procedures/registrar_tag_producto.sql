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