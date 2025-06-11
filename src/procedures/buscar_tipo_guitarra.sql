CREATE PROCEDURE sp_buscar_guitarras_por_tipo 
    @nombre_tipo NVARCHAR(50) = NULL 
AS 
BEGIN 
    SELECT 
        p.id_producto, 
        p.nombre_producto, 
        p.descripcion_producto, 
        p.marca_producto, 
        p.modelo_producto, 
        p.precio_producto, 
        tg.nombre AS tipo_guitarra, 
        c.nombre_categoria, 
        ISNULL(i.cantidad, 0) AS stock_disponible 
    FROM producto p 
        INNER JOIN guitarra g ON p.id_producto = g.id_producto 
        INNER JOIN tipo_guitarra tg ON g.id_tipo_guitarra = tg.id_tipo_guitarra 
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria 
        LEFT JOIN inventario i ON p.id_producto = i.id_producto 
    WHERE 
        (@nombre_tipo IS NULL OR tg.nombre LIKE '%' + @nombre_tipo + '%') 
    ORDER BY 
        tg.nombre, p.precio_producto; 
END; 