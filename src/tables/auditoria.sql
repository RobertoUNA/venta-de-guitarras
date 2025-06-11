CREATE TABLE auditoria (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada NVARCHAR(50),
    operacion NVARCHAR(20),
    id_registro INT,
    fecha_operacion DATETIME NOT NULL DEFAULT GETDATE(),
    datos_anteriores NVARCHAR(MAX),
    datos_nuevos NVARCHAR(MAX)
);