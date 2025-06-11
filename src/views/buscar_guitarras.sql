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