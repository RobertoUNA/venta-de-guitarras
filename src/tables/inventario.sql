CREATE TABLE inventario (
    id_inventario INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_actualizacion DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);