CREATE PROCEDURE sp_registrar_oferta
    @nombre_oferta NVARCHAR(100),
    @descripcion_oferta NVARCHAR(200),
    @tipo_oferta NVARCHAR(50),
    @valor_descuento DECIMAL(10,2),
    @fecha_inicio DATE,
    @fecha_cierre DATE,
    @estado_oferta NVARCHAR(20)
AS
BEGIN
    INSERT INTO oferta (nombre_oferta, descripcion_oferta, tipo_oferta, valor_descuento, fecha_inicio, fecha_cierre, estado_oferta)
    VALUES (@nombre_oferta, @descripcion_oferta, @tipo_oferta, @valor_descuento, @fecha_inicio, @fecha_cierre, @estado_oferta);
END;
