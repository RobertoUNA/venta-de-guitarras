-- Vista: Historial de precios de un producto
CREATE VIEW vw_historial_precios_producto AS
SELECT
    p.id_producto,
    p.nombre_producto,
    hp.precio_anterior,
    hp.precio_nuevo,
    hp.fecha_cambio
FROM producto p
INNER JOIN historial_precios hp ON p.id_producto = hp.id_producto;
GO