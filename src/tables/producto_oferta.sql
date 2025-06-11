CREATE TABLE producto_oferta (
    id_producto_oferta INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    id_oferta INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_oferta) REFERENCES oferta(id_oferta)
);