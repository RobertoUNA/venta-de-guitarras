CREATE TABLE tag (
    id_tag INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tag NVARCHAR(50) NOT NULL,
    descripcion_tag NVARCHAR(200)
);