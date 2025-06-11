-- Vista: Historial de clases de un estudiante
CREATE VIEW vw_historial_clases_estudiante AS
SELECT
    es.id_estudiante,
    pe.nombre_usuario AS nombre_estudiante,
    c.id_clase,
    c.nombre_clase,
    c.descripcion_clase,
    c.fecha_hora_inicio,
    c.fecha_hora_fin,
    c.precio_clase
FROM clase c
INNER JOIN matricula m ON c.id_clase = m.id_clase
INNER JOIN estudiante es ON m.id_estudiante = es.id_estudiante
INNER JOIN persona pe ON es.id_persona = pe.id_persona;
GO