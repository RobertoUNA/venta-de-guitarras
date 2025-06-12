-- 1. TABLAS BASE SIN DEPENDENCIAS
INSERT INTO categoria (nombre_categoria, descripcion_categoria) VALUES
('Guitarras Eléctricas', 'Guitarras eléctricas de alta calidad'),
('Guitarras Acústicas', 'Guitarras acústicas para todos los niveles'),
('Repuestos', 'Partes y accesorios para guitarras'),
('Accesorios', 'Accesorios varios para guitarristas');

INSERT INTO tipo_guitarra (nombre, descripcion) VALUES
('Stratocaster', 'Guitarra eléctrica tipo Stratocaster'),
('Les Paul', 'Guitarra eléctrica tipo Les Paul'),
('Acústica Clásica', 'Guitarra acústica de cuerdas de nylon'),
('Acústica Folk', 'Guitarra acústica de cuerdas de acero');

INSERT INTO tag (nombre_tag, descripcion_tag) VALUES
('Principiante', 'Ideal para principiantes'),
('Profesional', 'Para músicos profesionales'),
('Oferta', 'Producto en oferta'),
('Nuevo', 'Producto recién llegado');

-- 2. TABLAS DE PERSONAS Y USUARIOS
INSERT INTO persona (nombre_usuario, primer_apellido, segundo_apellido, correo_electronico, telefono, tipo_usuario) VALUES
('Juan', 'Pérez', 'García', 'juan.perez@email.com', '555-0101', 'Cliente'),
('María', 'López', 'Martínez', 'maria.lopez@email.com', '555-0102', 'Cliente'),
('Carlos', 'González', 'Rodríguez', 'carlos.gonzalez@email.com', '555-0103', 'Profesor'),
('Ana', 'Martínez', 'Sánchez', 'ana.martinez@email.com', '555-0104', 'Profesor'),
('Pedro', 'Sánchez', 'Díaz', 'pedro.sanchez@email.com', '555-0105', 'Estudiante'),
('Laura', 'Díaz', 'Fernández', 'laura.diaz@email.com', '555-0106', 'Estudiante');

INSERT INTO cliente (id_persona) VALUES
(1), 
(2); 

INSERT INTO profesor (id_persona, especialidad, experiencia_anhos, tarifa_hora) VALUES
(3, 'Guitarra Clásica', 10, 25.00), 
(4, 'Guitarra Eléctrica', 8, 30.00); 

INSERT INTO estudiante (id_persona) VALUES
(5), 
(6); 

-- 3. TABLAS DE PRODUCTOS Y SUS RELACIONES
INSERT INTO producto (nombre_producto, descripcion_producto, marca_producto, modelo_producto, precio_producto, id_categoria) VALUES
('Fender Stratocaster', 'Guitarra eléctrica profesional', 'Fender', 'Stratocaster', 899.99, 1),
('Gibson Les Paul', 'Guitarra eléctrica de alta gama', 'Gibson', 'Les Paul', 1299.99, 1),
('Yamaha C40', 'Guitarra clásica para principiantes', 'Yamaha', 'C40', 199.99, 2),
('Cuerdas Elixir', 'Cuerdas de guitarra eléctrica', 'Elixir', 'Nanoweb', 19.99, 3),
('Cable de Guitarra', 'Cable de 3 metros', 'Fender', 'Deluxe', 24.99, 4);

INSERT INTO guitarra (id_producto, id_tipo_guitarra) VALUES
(1, 1), 
(2, 2), 
(3, 3); 

INSERT INTO repuesto (id_producto, tipo_repuesto) VALUES
(4, 'Cuerdas'),
(5, 'Cable');

INSERT INTO inventario (id_producto, cantidad) VALUES
(1, 5),  
(2, 3),  
(3, 10), 
(4, 50), 
(5, 20); 

INSERT INTO producto_tag (id_tag, id_producto) VALUES
(1, 3), 
(2, 1), 
(2, 2), 
(3, 4); 

-- 4. TABLAS DE OFERTAS Y PRECIOS
INSERT INTO oferta (nombre_oferta, descripcion_oferta, tipo_oferta, valor_descuento, fecha_inicio, fecha_cierre, estado_oferta) VALUES
('Oferta de Verano', 'Descuentos en guitarras acústicas', 'Porcentaje', 15.00, '2024-06-01', '2024-08-31', 'Activa'),
('Pack Principiante', 'Kit completo para principiantes', 'Fijo', 50.00, '2024-01-01', '2024-12-31', 'Activa');

INSERT INTO producto_oferta (id_producto, id_oferta) VALUES
(3, 1), 
(4, 2); 

INSERT INTO historial_precios (id_producto, precio_anterior, precio_nuevo) VALUES
(1, 849.99, 899.99), 
(2, 1199.99, 1299.99); 

-- 5. TABLAS DE PEDIDOS
INSERT INTO pedido (id_cliente, direccion_pedido, estado_pedido, metodo_pago) VALUES
(1, 'Calle Principal 123', 'Completado', 'Tarjeta'),
(2, 'Avenida Central 456', 'En Proceso', 'PayPal');

INSERT INTO detalle_pedido (id_pedido, id_producto, precio_unitario, cantidad, subtotal) VALUES
(1, 1, 899.99, 1, 899.99), 
(1, 4, 19.99, 2, 39.98),  
(2, 3, 199.99, 1, 199.99); 

-- 6. TABLAS DE CLASES
INSERT INTO clase (id_profesor, nombre_clase, descripcion_clase, fecha_hora_inicio, fecha_hora_fin) VALUES
(1, 'Introducción a la Guitarra', 'Clase para principiantes', '2024-03-01 10:00:00', '2024-03-01 11:30:00'),
(2, 'Técnicas Avanzadas', 'Clase para nivel intermedio', '2024-03-02 15:00:00', '2024-03-02 16:30:00');

INSERT INTO matricula (id_clase, id_estudiante) VALUES
(1, 1), 
(2, 2);

-- 7. TABLA DE AUDITORÍA
INSERT INTO auditoria (tabla_afectada, operacion, id_registro, datos_anteriores, datos_nuevos) VALUES
('producto', 'INSERT', 1, NULL, 'Nombre: Fender Stratocaster, Precio: 899.99'),
('producto', 'UPDATE', 1, 'Nombre: Fender Stratocaster, Precio: 849.99', 'Nombre: Fender Stratocaster, Precio: 899.99'); 