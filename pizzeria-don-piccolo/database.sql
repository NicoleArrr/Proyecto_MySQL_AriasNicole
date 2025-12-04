--Creacción de la db--
DROP DATABASE IF EXISTS Don_Piccolo;
CREATE DATABASE IF NOT EXISTS Don_Piccolo;
USE Don_Piccolo;

--Creación de tablas--
CREATE TABLE IF NOT EXISTS Persona(
id_persona int not null primary key auto_increment,
nombre_completo varchar(50) not null,
correo_electronico varchar(50),
direccion varchar(50) not null,
telefono varchar(50) not null);

CREATE TABLE IF NOT EXISTS Cliente(
id_cliente int not null primary key auto_increment,
id_persona int not null,
foreign key (id_persona) references Persona(id_persona));

CREATE TABLE IF NOT EXISTS Empleado(
id_empleado int not null primary key auto_increment,
id_persona int not null,
cargo enum('vendedor','cajero','cocina','aseo'),
foreign key (id_persona) references Persona(id_persona));

CREATE TABLE IF NOT EXISTS Pedido(
id_pedido int not null primary key auto_increment,
id_cliente int not null,
id_empleado int not null,
fecha datetime,
entrega enum ('tienda', 'domicilio'),
estado enum ('pendiente','en proceso','finalizado'),
foreign key (id_cliente) references Cliente(id_cliente),
foreign key (id_empleado) references Empleado(id_empleado));

 CREATE TABLE IF NOT EXISTS Pago(
 id_pago int not null primary key auto_increment,
 id_pedido int not null,
 metodo_pago enum ('efectivo','tarjeta','app'),
 fecha timestamp,
 estado enum ('en curso','cancelado'),
 total_pago double not null,
 foreign key (id_pedido) references Pedido(id_pedido));

CREATE TABLE IF NOT EXISTS Repartidor(
id_repartidor int not null auto_increment primary key,
id_persona int not null,
zona varchar(50)not null,
disponibilidad enum ('NO','SI'),
foreign key (id_persona) references Persona(id_persona));

CREATE TABLE IF NOT EXISTS Zona(
id_zona int not null primary key auto_increment,
id_repartidor int not null,
foreign key (id_repartidor) references Repartidor(id_repartidor));

CREATE TABLE IF NOT EXISTS Domicilio(
id_domicilio int not null primary key auto_increment,
id_repartidor int not null,
id_pedido int not null,
hora_salida timestamp,
hora_llegada timestamp,
costo double not null,
foreign key (id_repartidor) references Repartidor(id_repartidor),
foreign key (id_pedido) references Pedido(id_pedido));

CREATE TABLE IF NOT EXISTS Ingrediente (
id_ingrediente int not null primary key auto_increment,
ingrediente varchar(50),
cantidad int);

CREATE TABLE IF NOT EXISTS Producto(
id_producto int not null primary key auto_increment,
producto varchar(50),
precio double default 0);

CREATE TABLE IF NOT EXISTS DetalleProducto(
id_detalleproducto int not null primary key auto_increment,
id_ingrediente int not null,
id_producto int not null,
stock int,
precio int default 0,
foreign key (id_ingrediente) references Ingrediente(id_ingrediente),
foreign key (id_producto) references Producto(id_producto));

CREATE TABLE IF NOT EXISTS DetallePedido(
id_detallepedido int not null primary key auto_increment,
id_pedido int not null,
id_producto int not null,
fecha datetime,
cantidad int not null,
subtotal double,
foreign key (id_pedido) references Pedido(id_pedido),
foreign key (id_producto) references Producto(id_producto));