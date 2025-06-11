CREATE TABLE guitarra (
    id_producto INT PRIMARY KEY,
    id_tipo_guitarra INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_tipo_guitarra) REFERENCES tipo_guitarra(id_tipo_guitarra)
);