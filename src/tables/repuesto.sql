CREATE TABLE repuesto (
    id_repuesto INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    tipo_repuesto NVARCHAR(50),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
