-- Trigger de auditoría para la tabla clase (UPDATE para cancelación)
CREATE TRIGGER trg_auditoria_clase_update
ON clase
AFTER UPDATE
AS
BEGIN
    INSERT INTO auditoria (tabla_afectada, operacion, id_registro, fecha_operacion, datos_anteriores, datos_nuevos)
    SELECT
        'clase',
        'UPDATE',
        i.id_clase,
        GETDATE(),
        CONCAT('Descripcion: ', d.descripcion_clase, ', Fecha Fin: ', CONVERT(NVARCHAR, d.fecha_hora_fin, 120)),
        CONCAT('Descripcion: ', i.descripcion_clase, ', Fecha Fin: ', CONVERT(NVARCHAR, i.fecha_hora_fin, 120))
    FROM inserted i
    INNER JOIN deleted d ON i.id_clase = d.id_clase;
END;
GO
