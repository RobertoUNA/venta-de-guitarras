CREATE PROCEDURE sp_registrar_profesor
    @id_persona INT,
    @especialidad NVARCHAR(100),
    @experiencia_anhos INT,
    @tarifa_hora DECIMAL(10,2)
AS
BEGIN
    INSERT INTO profesor (id_persona, especialidad, experiencia_anhos, tarifa_hora)
    VALUES (@id_persona, @especialidad, @experiencia_anhos, @tarifa_hora);
END;