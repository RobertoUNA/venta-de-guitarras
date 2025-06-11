CREATE TABLE profesor (
    id_profesor INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    especialidad NVARCHAR(100),
    experiencia_anhos INT,
    tarifa_hora DECIMAL(10,2),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);