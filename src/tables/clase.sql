CREATE TABLE clase (
    id_clase INT IDENTITY(1,1) PRIMARY KEY,
    id_profesor INT NOT NULL,
    nombre_clase NVARCHAR(100),
    descripcion_clase NVARCHAR(200),
    fecha_hora_inicio DATETIME,
    fecha_hora_fin DATETIME,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
);