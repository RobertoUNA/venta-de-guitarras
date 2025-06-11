CREATE TABLE persona (
    id_persona INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario NVARCHAR(50) NOT NULL,
    primer_apellido NVARCHAR(50) NOT NULL,
    segundo_apellido NVARCHAR(50),
    correo_electronico NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    fecha_registro DATE NOT NULL DEFAULT GETDATE(),
    tipo_usuario NVARCHAR(20) NOT NULL
);