CREATE TABLE oferta (
    id_oferta INT IDENTITY(1,1) PRIMARY KEY,
    nombre_oferta NVARCHAR(100) NOT NULL,
    descripcion_oferta NVARCHAR(200),
    tipo_oferta NVARCHAR(50),
    valor_descuento DECIMAL(10,2),
    fecha_inicio DATE,
    fecha_cierre DATE,
    estado_oferta NVARCHAR(20)
);