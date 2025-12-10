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

--Control de ingredientes disponibles--
DELIMITER $$
CREATE PROCEDURE producto_disponible(
    IN v_id_producto INT,
    IN v_cantidad_producto INT,
    OUT p_disponible BOOLEAN)    
BEGIN
    DECLARE v_ingredientes INT;

    /*Se hace un conteo de los ingredientes para saber si se cuenta con la cantidad
    necesaria contenida en la existencia del producto*/
    SELECT COUNT(*) INTO v_ingredientes
    FROM DetalleProducto dp
    LEFT JOIN Ingrediente i ON dp.id_ingrediente = i.id_ingrediente
    WHERE dp.id_producto = v_id_producto AND dp.stock < (i.cantidad * v_cantidad_producto);
    
    IF v_ingredientes = 0 THEN
        SET p_disponible = TRUE;
        signal sqlstate '45000' set message_text='producto disponible, insumos suficientes';
    ELSE IF v_ingredientes <= 5 THEN
        SET p_disponible = TRUE;
        signal sqlstate '45000' set message_text ='producto limitado, insumos por agotarse';
    ELSE
        SET p_disponible = FALSE;
        signal sqlstate '45000' set message_text='producto no disponible, insumos agotados';
    END IF;
END $$
DELIMITER ;

--Registro del pedido
DELIMITER $$
CREATE PROCEDURE nuevo_pedido(IN v_id_cliente INT, IN v_id_empleado INT, IN v_entrega ENUM('tienda', 'domicilio'))
BEGIN
    INSERT INTO Pedido(id_cliente, id_empleado, fecha, entrega, estado)
    VALUES (v_id_cliente, v_id_empleado, NOW(), v_entrega, 'pendiente');
END $$
DELIMITER ;

INSERT INTO Persona (nombre_completo, correo_electronico, direccion, telefono) VALUES
('Juan Pérez', 'juan1@gmail.com', 'Calle 1', '1111111'),
('María Gómez', 'maria2@gmail.com', 'Calle 2', '2222222'),
('Carlos Ruiz', 'carlos3@gmail.com', 'Calle 3', '3333333'),
('Ana Torres', 'ana4@gmail.com', 'Calle 4', '4444444'),
('Pedro Morales', 'pedro5@gmail.com', 'Calle 5', '5555555'),
('Lucía Fernández', 'lucia6@gmail.com', 'Calle 6', '6666666'),
('Roberto Díaz', 'roberto7@gmail.com', 'Calle 7', '7777777'),
('Sofía Herrera', 'sofia8@gmail.com', 'Calle 8', '8888888'),
('Miguel Rojas', 'miguel9@gmail.com', 'Calle 9', '9999999'),
('Elena López', 'elena10@gmail.com', 'Calle 10', '10101010');

-- CLIENTE
INSERT INTO Cliente (id_persona) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

-- EMPLEADO
INSERT INTO Empleado (id_persona, cargo) VALUES
(1,'vendedor'),
(2,'cajero'),
(3,'cocina'),
(4,'aseo'),
(5,'vendedor'),
(6,'cajero'),
(7,'cocina'),
(8,'aseo'),
(9,'vendedor'),
(10,'cajero');

-- ZONA
INSERT INTO Zona (zona) VALUES
('Norte'),('Sur'),('Este'),('Oeste'),('Centro'),
('Noroeste'),('Suroeste'),('Noreste'),('Sureste'),('Industrial');

-- REPARTIDOR
INSERT INTO Repartidor (id_persona, id_zona, disponibilidad) VALUES
(1,1,'SI'),
(2,2,'NO'),
(3,3,'SI'),
(4,4,'SI'),
(5,5,'NO'),
(6,6,'SI'),
(7,7,'SI'),
(8,8,'NO'),
(9,9,'SI'),
(10,10,'SI');

-- PEDIDO
INSERT INTO Pedido (id_cliente, id_empleado, fecha, entrega, estado) VALUES
(1,1,NOW(),'tienda','pendiente'),
(2,2,NOW(),'domicilio','en proceso'),
(3,3,NOW(),'tienda','finalizado'),
(4,4,NOW(),'domicilio','pendiente'),
(5,5,NOW(),'tienda','en proceso'),
(6,6,NOW(),'domicilio','finalizado'),
(7,7,NOW(),'tienda','pendiente'),
(8,8,NOW(),'domicilio','en proceso'),
(9,9,NOW(),'tienda','finalizado'),
(10,10,NOW(),'domicilio','pendiente');

-- PAGO
INSERT INTO Pago (id_pedido, metodo_pago, fecha, estado, total_pago) VALUES
(1,'efectivo',NOW(),'en curso',20.50),
(2,'tarjeta',NOW(),'cancelado',0),
(3,'app',NOW(),'en curso',15.75),
(4,'efectivo',NOW(),'en curso',30.00),
(5,'tarjeta',NOW(),'cancelado',0),
(6,'app',NOW(),'en curso',42.00),
(7,'efectivo',NOW(),'en curso',18.50),
(8,'tarjeta',NOW(),'cancelado',0),
(9,'app',NOW(),'en curso',27.90),
(10,'efectivo',NOW(),'en curso',33.40);

-- DOMICILIO
INSERT INTO Domicilio (id_repartidor, id_pedido, hora_salida, hora_llegada, costo) VALUES
(1,2,NOW(),DATE_ADD(NOW(),INTERVAL 25 MINUTE),5.0),
(2,4,NOW(),DATE_ADD(NOW(),INTERVAL 30 MINUTE),4.5),
(3,6,NOW(),DATE_ADD(NOW(),INTERVAL 20 MINUTE),6.0),
(4,8,NOW(),DATE_ADD(NOW(),INTERVAL 28 MINUTE),5.5),
(5,10,NOW(),DATE_ADD(NOW(),INTERVAL 35 MINUTE),7.0),
(6,1,NOW(),DATE_ADD(NOW(),INTERVAL 18 MINUTE),4.0),
(7,3,NOW(),DATE_ADD(NOW(),INTERVAL 22 MINUTE),6.2),
(8,5,NOW(),DATE_ADD(NOW(),INTERVAL 24 MINUTE),5.8),
(9,7,NOW(),DATE_ADD(NOW(),INTERVAL 26 MINUTE),6.5),
(10,9,NOW(),DATE_ADD(NOW(),INTERVAL 27 MINUTE),7.2);

-- INGREDIENTE
INSERT INTO Ingrediente (ingrediente, cantidad) VALUES
('Harina', 50),('Queso', 30),('Jamón', 25),('Carne', 40),('Tomate', 60),
('Lechuga', 20),('Pan', 80),('Cebolla', 35),('Salsa', 50),('Pepinillo', 15);

-- PRODUCTO
INSERT INTO Producto (producto, precio) VALUES
('Pizza Margarita', 8.00),
('Hamburguesa', 6.50),
('Sandwich Jamón', 4.00),
('Pizza Carne', 10.00),
('Hot Dog', 3.50),
('Pizza Queso', 7.50),
('Ensalada', 5.00),
('Wrap Pollo', 6.00),
('Empanada', 2.50),
('Papas Fritas', 2.00);

-- DETALLE PRODUCTO
INSERT INTO DetalleProducto (id_ingrediente, id_producto, stock, precio) VALUES
(1,1,10,1),
(2,1,5,1),
(3,3,12,1),
(4,4,8,2),
(5,1,7,1),
(6,7,15,1),
(7,2,20,1),
(8,4,10,1),
(9,1,12,1),
(10,2,8,1);

-- DETALLE PEDIDO
INSERT INTO DetallePedido (id_pedido, id_producto, fecha, cantidad, subtotal) VALUES
(1,1,NOW(),2,16),
(2,2,NOW(),1,6.5),
(3,3,NOW(),3,12),
(4,4,NOW(),1,10),
(5,5,NOW(),2,7),
(6,6,NOW(),1,7.5),
(7,7,NOW(),1,5),
(8,8,NOW(),2,12),
(9,9,NOW(),4,10),
(10,10,NOW(),3,6);
