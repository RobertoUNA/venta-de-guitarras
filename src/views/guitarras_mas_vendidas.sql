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