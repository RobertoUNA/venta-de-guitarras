-- Actualizar un pedido existente:
CREATE PROCEDURE sp_actualizar_pedido
    @id_pedido INT,
    @direccion_pedido NVARCHAR(200) = NULL,
    @estado_pedido NVARCHAR(20) = NULL,
    @metodo_pago NVARCHAR(50) = NULL,
    @productos XML = NULL -- Ejemplo: <productos><item id_producto="1" cantidad="2" precio_unitario="150.00" /></productos>
AS
BEGIN
    SET QUOTED_IDENTIFIER ON;
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Actualizar información básica del pedido
        UPDATE pedido
        SET direccion_pedido = ISNULL(@direccion_pedido, direccion_pedido),
            estado_pedido = ISNULL(@estado_pedido, estado_pedido),
            metodo_pago = ISNULL(@metodo_pago, metodo_pago)
        WHERE id_pedido = @id_pedido;

        -- Si se proporcionaron nuevos productos, actualizar los detalles
        IF @productos IS NOT NULL
        BEGIN
            -- Eliminar detalles existentes
            DELETE FROM detalle_pedido
            WHERE id_pedido = @id_pedido;

            -- Insertar nuevos detalles
            INSERT INTO detalle_pedido (id_pedido, id_producto, precio_unitario, cantidad, subtotal)
            SELECT 
                @id_pedido,
                T.Item.value('@id_producto', 'INT'),
                T.Item.value('@precio_unitario', 'DECIMAL(10,2)'),
                T.Item.value('@cantidad', 'INT'),
                T.Item.value('@precio_unitario', 'DECIMAL(10,2)') * T.Item.value('@cantidad', 'INT')
            FROM @productos.nodes('/productos/item') AS T(Item);
        END

        COMMIT TRANSACTION;
        
        -- Retornar el pedido actualizado
        SELECT 
            p.id_pedido,
            p.id_cliente,
            p.fecha_pedido,
            p.direccion_pedido,
            p.estado_pedido,
            p.metodo_pago,
            dp.id_producto,
            pr.nombre_producto,
            dp.cantidad,
            dp.precio_unitario,
            dp.subtotal
        FROM pedido p
        LEFT JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
        LEFT JOIN producto pr ON dp.id_producto = pr.id_producto
        WHERE p.id_pedido = @id_pedido;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO