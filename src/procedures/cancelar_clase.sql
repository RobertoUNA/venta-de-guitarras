CREATE PROCEDURE sp_cancelar_clase
    @id_clase INT
AS
BEGIN
    UPDATE clase
    SET descripcion_clase = CONCAT(descripcion_clase, ' (CANCELADA)'),
        fecha_hora_fin = GETDATE()
    WHERE id_clase = @id_clase;
END;