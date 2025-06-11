CREATE PROCEDURE sp_registrar_clase
    @id_profesor INT,
    @nombre_clase NVARCHAR(100),
    @descripcion_clase NVARCHAR(200),
    @fecha_hora_inicio DATETIME,
    @fecha_hora_fin DATETIME,
    @precio_clase DECIMAL(10,2)
AS
BEGIN
    INSERT INTO clase (id_profesor, nombre_clase, descripcion_clase, fecha_hora_inicio, fecha_hora_fin, precio_clase)
    VALUES (@id_profesor, @nombre_clase, @descripcion_clase, @fecha_hora_inicio, @fecha_hora_fin, @precio_clase);
END;