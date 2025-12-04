--Inserciones mediante procedimientos--
DELIMITER $$
CREATE PROCEDURE nueva_persona(in v_nombre_completo varchar(50), in v_correo_electronico varchar(50), v_direccion varchar(50), in v_telefono varchar(50))
BEGIN
    INSERT INTO Persona(nombre_completo,correo_electronico,direccion,telefono) VALUES (v_nombre_completo, v_correo_electronico, v_direccion, v_telefono);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE nuevo_cliente(in v_nombre_completo varchar(50), in v_correo_electronico varchar(50), v_direccion varchar(50), in v_telefono varchar(50))
BEGIN
    DECLARE v_id_nuevapersona int;
    call nueva_persona(v_nombre_completo, v_correo_electronico, v_direccion, v_telefono);

    set v_id_nuevapersona = MAX(id_persona) FROM Persona;
    INSERT INTO Cliente(id_persona) VALUES (v_id_nuevapersona);
END $$
DELIMITER ;

--Identificación de clientes con más de cinco pedidos realizados en el mes--
DELIMITER $$
CREATE PROCEDURE clientes_frecuentes()
BEGIN
    SELECT * 
    FROM Pedido ped 
    LEFT JOIN Cliente cl ON ped.id_cliente = cl.id_cliente 
    LEFT JOIN Persona per ON cl.id_persona = per.id_persona
    WHERE ped.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    GROUP BY ped.id_cliente HAVING COUNT(ped.id_cliente)>5;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE nuevo_pedido(IN v_id_cliente INT, IN v_id_empleado INT, IN v_entrega ENUM('tienda', 'domicilio'))
BEGIN
    INSERT INTO Pedido(id_cliente, id_empleado, fecha, entrega, estado)
    VALUES ( v_id_cliente, v_id_empleado, NOW(), v_entrega, 'pendiente');
END $$
DELIMITER ;

----