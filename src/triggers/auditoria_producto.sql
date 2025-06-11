-- Trigger de auditoría para la tabla producto (INSERT y UPDATE)
CREATE TRIGGER trg_auditoria_producto
ON producto
AFTER INSERT, UPDATE
AS
BEGIN
    -- Para INSERT
    INSERT INTO auditoria (tabla_afectada, operacion, id_registro, fecha_operacion, datos_anteriores, datos_nuevos)
    SELECT
        'producto',
        'INSERT',
        i.id_producto,
        GETDATE(),
        NULL,
        CONCAT('Nombre: ', i.nombre_producto, ', Precio: ', i.precio_producto)
    FROM inserted i
    LEFT JOIN deleted d ON i.id_producto = d.id_producto
    WHERE d.id_producto IS NULL;

    -- Para UPDATE
    INSERT INTO auditoria (tabla_afectada, operacion, id_registro, fecha_operacion, datos_anteriores, datos_nuevos)
    SELECT
        'producto',
        'UPDATE',
        i.id_producto,
        GETDATE(),
        CONCAT('Nombre: ', d.nombre_producto, ', Precio: ', d.precio_producto),
        CONCAT('Nombre: ', i.nombre_producto, ', Precio: ', i.precio_producto)
    FROM inserted i
    INNER JOIN deleted d ON i.id_producto = d.id_producto;
END;
GO