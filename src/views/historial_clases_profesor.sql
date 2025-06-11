-- Vista: Historial de clases de un profesor
CREATE VIEW vw_historial_clases_profesor AS
SELECT
    pr.id_profesor,
    pe.nombre_usuario AS nombre_profesor,
    c.id_clase,
    c.nombre_clase,
    c.descripcion_clase,
    c.fecha_hora_inicio,
    c.fecha_hora_fin,
    c.precio_clase
FROM clase c
INNER JOIN profesor pr ON c.id_profesor = pr.id_profesor
INNER JOIN persona pe ON pr.id_persona = pe.id_persona;
GO