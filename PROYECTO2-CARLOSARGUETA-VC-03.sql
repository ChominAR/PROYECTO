create database proyecto2;
use proyecto2;
drop table empresa;
create table empresa(
id_empresa int primary key,
nombre varchar(50),
id_empleadosfk int,
foreign key empresa(id_empleadosfk) references empleados(id_empleados)
);
create table empleados(
id_empleados int primary key,
nombre varchar(50),
apellido varchar(50),
puesto varchar(50),
salario int(50)
);

create table clientes (
id_cliente int primary key,
    nombre varchar(50),
    direccion varchar(50),
    telefono varchar(12)
);
create table facturas (
id_factura int primary key,
    fecha varchar(15),
    id_cliente_fk int,
    foreign key (id_cliente_fk) references clientes(id_cliente)
);

create table proveedores (
id_proveedor int primary key,
    nombre varchar(50),
    direccion varchar(50),
    telefono varchar(12)
);

create table categoria(
id_categoria int primary key,
    descripcion varchar(50)
);

create table productos(
id_producto int primary key,
    descripcion varchar(50),
    precio varchar(20),
    id_categoria_fk int,
    id_proveedor_fk int,
    foreign key (id_categoria_fk) references categoria(id_categoria),
    foreign key (id_proveedor_fk) references proveedores(id_proveedor)
);
ALTER TABLE productos ADD stock INT;

create table ventas(
id_venta int primary key,
    id_factura_fk int,
    id_producto_fk int,
    cantidad int,
    foreign key (id_factura_fk) references facturas(id_factura),
    foreign key (id_producto_fk) references productos(id_producto)
);

create table metodopago(
id_metodopago int primary key,
metodo varchar(50),
id_metodoproveedores int,
foreign key metodopago(id_metodopago) references clientes(id_cliente)
);
drop table pago_factura;
ALTER TABLE facturas ADD COLUMN id_metodopago_fk INT;

CREATE TABLE pago_proveedores (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT, -- código de la compra (puede ser id de factura o similar)
    id_proveedor INT,
    monto DECIMAL(10,2),
    fecha_max_pago DATE,
    estado_pago VARCHAR(20) DEFAULT 'Pendiente', -- opcional: Pendiente, Pagado, etc.
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);
/*CONSULTA A*/
SELECT id_producto,descripcion,precio,stock
FROM productos;
/*CONSULTA B*/
SELECT v.id_venta,f.fecha,cl.nombre AS cliente,p.descripcion AS producto,v.cantidad,v.cantidad * p.precio AS total
FROM ventas v
INNER JOIN facturas f ON v.id_factura_fk = f.id_factura
INNER JOIN clientes cl ON f.id_cliente_fk = cl.id_cliente
INNER JOIN productos p ON v.id_producto_fk = p.id_producto
WHERE f.fecha BETWEEN '24/04/25' AND '8/05/25';
/*CONSULTA B*/
SELECT f.id_factura,f.fecha,cl.nombre AS cliente,p.descripcion AS producto,v.cantidad,v.cantidad * p.precio AS total
FROM ventas v
INNER JOIN facturas f ON v.id_factura_fk = f.id_factura
INNER JOIN clientes cl ON f.id_cliente_fk = cl.id_cliente
INNER JOIN productos p ON v.id_producto_fk = p.id_producto
WHERE cl.nombre = 'WASA';
/*CONSULTA B*/
SELECT f.id_factura,f.fecha,cl.nombre AS cliente,mp.metodo AS metodo_pago,p.descripcion AS producto,v.cantidad,v.cantidad * p.precio AS total
FROM ventas v
INNER JOIN facturas f ON v.id_factura_fk = f.id_factura
INNER JOIN clientes cl ON f.id_cliente_fk = cl.id_cliente
INNER JOIN productos p ON v.id_producto_fk = p.id_producto
INNER JOIN metodopago mp ON f.id_metodopago_fk = mp.id_metodopago
WHERE mp.metodo = 'CHEQUE';
/*CONSULTA C*/
SELECT pr.id_proveedor,pr.nombre AS proveedor,p.descripcion AS producto,v.cantidad,v.cantidad * p.precio AS total,f.fecha
FROM ventas v
INNER JOIN facturas f ON v.id_factura_fk = f.id_factura
INNER JOIN productos p ON v.id_producto_fk = p.id_producto
INNER JOIN proveedores pr ON p.id_proveedor_fk = pr.id_proveedor
ORDER BY pr.nombre, f.fecha;
/*CONSULTA D*/
SELECT p.id_producto,p.descripcion AS articulo,p.precio,pr.id_proveedor AS codigo_proveedor,pr.nombre AS proveedor
FROM productos p
INNER JOIN proveedores pr ON p.id_proveedor_fk = pr.id_proveedor
ORDER BY p.id_producto;
/*CONSULTA E*/
SELECT p.id_producto AS codigo_articulo,p.descripcion AS articulo,p.precio,pr.id_proveedor AS codigo_proveedor,pr.nombre AS proveedor
FROM productos p
INNER JOIN proveedores pr ON p.id_proveedor_fk = pr.id_proveedor
ORDER BY p.id_producto;
/*CONSULTA F*/
SELECT pp.id_pago,pp.id_compra,pr.nombre AS proveedor,pp.monto,pp.fecha_max_pago,pp.estado_pago
FROM pago_proveedores pp
INNER JOIN proveedores pr ON pp.id_proveedor = pr.id_proveedor
WHERE pp.estado_pago = 'FALTA'
ORDER BY pp.fecha_max_pago;
/*CONSULTA G*/
SELECT * FROM empleados;
/*SACADO DE UN USUARIO EN REDDIT/*ALTER TABLE;
https://www.reddit.com/r/mysql/comments/1k5jyen/modifying_a_field_named_table/?tl=es-419*/