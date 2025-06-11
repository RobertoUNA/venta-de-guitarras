CREATE TABLE tipo_guitarra (
    id_tipo_guitarra INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(200)
);