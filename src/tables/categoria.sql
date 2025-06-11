CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(50) NOT NULL,
    descripcion_categoria NVARCHAR(200)
);