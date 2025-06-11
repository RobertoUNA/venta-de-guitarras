CREATE TABLE historial_precios (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);