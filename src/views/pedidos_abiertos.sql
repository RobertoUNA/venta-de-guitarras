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