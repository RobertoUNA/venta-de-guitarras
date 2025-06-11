USE proyecto_ventaguitarras;
GO

CREATE TABLE persona (
    id_persona INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario NVARCHAR(50) NOT NULL,
    primer_apellido NVARCHAR(50) NOT NULL,
    segundo_apellido NVARCHAR(50),
    correo_electronico NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    fecha_registro DATE NOT NULL DEFAULT GETDATE(),
    tipo_usuario NVARCHAR(20) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

CREATE TABLE profesor (
    id_profesor INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    especialidad NVARCHAR(100),
    experiencia_anhos INT,
    tarifa_hora DECIMAL(10,2),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

CREATE TABLE estudiante (
    id_estudiante INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(50) NOT NULL,
    descripcion_categoria NVARCHAR(200)
);

CREATE TABLE producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto NVARCHAR(100) NOT NULL,
    descripcion_producto NVARCHAR(200),
    marca_producto NVARCHAR(50),
    modelo_producto NVARCHAR(50),
    precio_producto DECIMAL(10,2) NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- ELIMINADA: categoria_producto (ya no es necesaria)

CREATE TABLE tipo_guitarra (
    id_tipo_guitarra INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(200)
);

CREATE TABLE guitarra (
    id_producto INT PRIMARY KEY,
    id_tipo_guitarra INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_tipo_guitarra) REFERENCES tipo_guitarra(id_tipo_guitarra)
);

CREATE TABLE repuesto (
    id_repuesto INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    tipo_repuesto NVARCHAR(50),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE inventario (
    id_inventario INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_actualizacion DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE tag (
    id_tag INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tag NVARCHAR(50) NOT NULL,
    descripcion_tag NVARCHAR(200)
);

CREATE TABLE producto_tag (
    id_tag INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_tag, id_producto),
    FOREIGN KEY (id_tag) REFERENCES tag(id_tag),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE oferta (
    id_oferta INT IDENTITY(1,1) PRIMARY KEY,
    nombre_oferta NVARCHAR(100) NOT NULL,
    descripcion_oferta NVARCHAR(200),
    tipo_oferta NVARCHAR(50),
    valor_descuento DECIMAL(10,2),
    fecha_inicio DATE,
    fecha_cierre DATE,
    estado_oferta NVARCHAR(20)
);

CREATE TABLE producto_oferta (
    id_producto_oferta INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    id_oferta INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_oferta) REFERENCES oferta(id_oferta)
);

CREATE TABLE historial_precios (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    direccion_pedido NVARCHAR(200),
    estado_pedido NVARCHAR(20),
    metodo_pago NVARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_pedido (
    id_detalle_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE clase (
    id_clase INT IDENTITY(1,1) PRIMARY KEY,
    id_profesor INT NOT NULL,
    nombre_clase NVARCHAR(100),
    descripcion_clase NVARCHAR(200),
    fecha_hora_inicio DATETIME,
    fecha_hora_fin DATETIME,
    precio_clase DECIMAL(10,2),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
);

CREATE TABLE matricula (
    id_matricula INT IDENTITY(1,1) PRIMARY KEY,
    id_clase INT NOT NULL,
    id_profesor INT NOT NULL,
    id_estudiante INT NOT NULL,
    FOREIGN KEY (id_clase) REFERENCES clase(id_clase),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

CREATE TABLE auditoria (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada NVARCHAR(50),
    operacion NVARCHAR(20),
    id_registro INT,
    fecha_operacion DATETIME NOT NULL DEFAULT GETDATE(),
    datos_anteriores NVARCHAR(MAX),
    datos_nuevos NVARCHAR(MAX)
);