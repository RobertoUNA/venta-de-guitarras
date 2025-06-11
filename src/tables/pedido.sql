CREATE TABLE pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    direccion_pedido NVARCHAR(200),
    estado_pedido NVARCHAR(20),
    metodo_pago NVARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);