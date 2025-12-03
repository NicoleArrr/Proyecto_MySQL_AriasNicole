CREATE DATABASE IF NOT EXISTS Don_Piccolo;
USE Don_Piccolo;

DROP TABLE Persona;
CREATE TABLE Persona (
id_persona int not null primary key auto_increment,
nombre_completo varchar(50) not null,
correo_electronico varchar(50),
direccion varchar(50) not null,
telefono varchar(50) not null);

DROP TABLE Cliente;
CREATE TABLE Cliente(
id_cliente int not null primary key auto_increment,
id_persona int not null,
foreign key (id_persona) references persona (id_persona));

DROP TABLE Empleado;
CREATE TABLE Empleado(
id_empleado int not null primary key auto_increment,
id_persona int not null,
cargo enum('vendedor','cajero','cocina','aseo'));

DROP TABLE Pedido;
CREATE TABLE Pedido(
id_pedido int not null primary key auto_increment,
id_cliente int not null,
id_empleado int not null,
id_pago int not null,
fecha datetime,
entrega enum ('tienda', 'domicilio'),
estado enum ('',''),
foreign key (id_cliente) references Cliente(id_cliente),
foreign key (id_empleado) references Vendedor(id_empleado));

 DROP TABLE Pago;
 CREATE TABLE Pago(
 id_pago int not null primary key auto_increment,
 id_pedido int not null,
 metodo_pago enum ('efectivo','tarjeta_credito'),
 fecha timestamp,
 estado enum ('',''),
 total_pago double not null);

DROP TABLE Repartidor;
CREATE TABLE Repartidor(
id_repartidor int not null auto_increment primary key,
id_persona int not null,
zona varchar(50)not null,
foreign key (id_persona) references Persona(id_persona));

DROP TABLE Zona
CREATE TABLE Zona(
id_zona int not null primary key auto_increment,
id_repartidor int not null,
foreign key (id_repartidor) references Repartidor(id_repartidor));

DROP TABLE Domicilio;
CREATE TABLE Domicilio(
id_domicilio in not null primary key auto_increment,
id_repartidor int not null,
id_pedido int not null,
costo double not null,
fecha timestamp,
foreign key (id_repartidor) references Repartidor(id_repartidor),
foreign key (id_pedido) references Pedido(id_pedido));

DROP TABLE Ingrediente;
CREATE TABLE Ingrediente (
id_ingrediente int not null primary key auto_increment,
ingrediente varchar(50),
cantidad int);

DROP TABLE Producto;
CREATE TABLE Producto(
id_producto int not null primary key auto_increment,
producto varchar(50),
precio double default 0);

DROP TABLE DetalleIngrediente;
CREATE TABLE DetalleProducto(
id_detalleproducto int not null primary key auto_increment,
id_ingrediente int not null,
id_producto int not null,
stock int,
precio int default 0);

DROP TABLE DetallePedido;
CREATE TABLE DetallePedido(
id_detallepedido int not null primary key auto_increment,
id_pedido int not null,
id_producto int not null,
fecha datetime,
cantidad int not null,
subtotal double,
foreign key (id_pedido) references Pedido(id_pedido),
foreign key (id_producto) references Producto(id_producto));