CREATE TABLE cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);