CREATE TABLE producto_tag (
    id_tag INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_tag, id_producto),
    FOREIGN KEY (id_tag) REFERENCES tag(id_tag),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);