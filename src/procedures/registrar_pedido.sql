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

