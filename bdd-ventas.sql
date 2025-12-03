CREATE DATABASE IF NOT EXISTS Ejercicio2; 

USE Ejercicio2;


# Creo las tablas
CREATE TABLE PROVEEDOR(
	ID_PROVEEDOR INT(5) PRIMARY KEY AUTO_INCREMENT,
	NOMBRE VARCHAR(20) NOT NULL,
	CUIT VARCHAR(11) NOT NULL, 
	CIUDAD VARCHAR(20) NOT NULL);
	
CREATE TABLE PRODUCTO(
	ID_PRODUCTO INT(5) PRIMARY KEY AUTO_INCREMENT,
	DESCRIPCION VARCHAR(50) NOT NULL,
	ESTADO VARCHAR(30) NOT NULL,
	ID_PROVEEDOR INT(5), 
	FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR(ID_PROVEEDOR));

CREATE TABLE CLIENTE(
	ID_CLIENTE INT(5) PRIMARY KEY AUTO_INCREMENT,
	NOMBRE VARCHAR (50) NOT NULL);

CREATE TABLE VENDEDOR(
	ID_EMPLEADO INT(6) PRIMARY KEY AUTO_INCREMENT,
	NOMBRE VARCHAR(50) NOT NULL,
	APELLIDO VARCHAR(50) NOT NULL,
	DNI INT(15) NOT NULL,
	CIUDAD VARCHAR(20) NOT NULL);
	
CREATE TABLE VENTA(
	NRO_FACTURA INT(5) PRIMARY KEY AUTO_INCREMENT,
	ID_CLIENTE INT(5) NOT NULL,
	FECHA DATE NOT NULL, 
	ID_VENDEDOR INT(6) NOT NULL, 
	FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE (ID_CLIENTE), 
	FOREIGN KEY (ID_VENDEDOR) REFERENCES VENDEDOR(ID_EMPLEADO));
	
CREATE TABLE DETALLE_VENTA(
	NRO_FACTURA INT(5) NOT NULL, 
	NRO_DETALLE INT(10) NOT NULL,
	ID_PRODUCTO INT(5) NOT NULL, 
	CANTIDAD INT(5) NOT NULL, 
	PRECIO_UNITARIO DOUBLE NOT NULL, 
	PRIMARY KEY (NRO_FACTURA, NRO_DETALLE), 
	FOREIGN KEY (NRO_FACTURA) REFERENCES VENTA (NRO_FACTURA), 
	FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO(ID_PRODUCTO));
	
#INSERTO DATOS
INSERT INTO PROVEEDOR (NOMBRE, CUIT, CIUDAD) VALUES
('ARCOR', '30111222339', 'San Luis'),
('Molinos', '30222333448', 'Cordoba'),
('Marolio', '30333444557', 'San Luis'),
 ('Ledesma', '30444555666', 'Capital Federal'),
 ('Johnson', '30555666775', 'Ramos Mejia');
 
INSERT INTO PRODUCTO(DESCRIPCION, ESTADO, ID_PROVEEDOR) VALUES ('Harina', 'En Stock', 2),
('Arroz', 'En Stock', 1),
('Jabon liquido', 'Sin Stock', 5),
('Azucar','En Stock', 4),
('Aceite', 'En Stock', 3);

INSERT INTO CLIENTE (NOMBRE) VALUES 
	('Juan Carlos Altamirano'), 
	('Pepe Silla'),
 	('Esteban Quito'), 
	('Laura Noveas'), 
	('Alejandra Hola');
	
INSERT INTO VENDEDOR (NOMBRE, APELLIDO, DNI, CIUDAD) VALUES 
	('Ambar', 'Paredes', 33444555, 'San Pedro'),
	('Federico', 'Tedin', 34555666, 'Mar del Plata'), 
	('Gaston', 'Salvatierra', 35666777, 'Buenos Aires'),
	('Florencia', 'Luque', 36777888, 'Bariloche'),
	('Leandro', 'Fido', 37888999, 'San Luis');

INSERT INTO VENTA(ID_CLIENTE, FECHA, ID_VENDEDOR) VALUES
(1, '1998-05-01', 3),
(4, '2015-02-24', 5),
(2, '2015-03-31', 2),
(3, '2020-04-12', 2),
(4, '2021-10-02', 1),
(5, '2021-11-06', 1),
(3, '2022-02-16', 4),
(5, '2022-03-07', 1),
(1, '2022-03-15', 2),
(5, '1998-05-15', 5),
(1, '2022-11-03', 2);

INSERT INTO DETALLE_VENTA (NRO_FACTURA, NRO_DETALLE, ID_PRODUCTO, CANTIDAD, PRECIO_UNITARIO) VALUES
(1, 1, 1, 4, 100.80),
(2, 1, 2, 8, 80.50),
(3, 1, 4, 10, 100.35),
(4, 1, 3, 23, 89.99),
(5, 1, 3, 54, 154.87),
(6, 1, 2, 19, 321.56),
(7, 1, 2, 11, 452.84),
(8, 1, 4, 5, 163.12),
(9, 1, 4, 3, 186.77),
(10, 1, 3, 15, 79.66),
(11, 1, 4, 5, 256.77);


#1) Listar los productos (id_producto y descripcion) que tiene la empresa, donde el
# proveedor que los provee es de la ciudad de San Luis, ordenado por la descripción
# del producto de mayor a menor.

SELECT * FROM producto;
SELECT * FROM proveedor;

SELECT p.ID_PRODUCTO,p.DESCRIPCION FROM producto p
JOIN proveedor r ON r.ID_PROVEEDOR = p.ID_PROVEEDOR
WHERE r.CIUDAD LIKE 'San Luis' 
ORDER BY p.DESCRIPCION DESC;


#2) Listar la descripción de productos en estado 'en stock' que tiene la empresay
# que los mismos no hayan sido vendidos nunca a fin de hacer un análisis de por qué
# no tienen salida.

SELECT * FROM producto;
SELECT * from detalle_venta;

SELECT distinct p.DESCRIPCION FROM producto p
JOIN detalle_venta d ON d.ID_PRODUCTO = p.ID_PRODUCTO
WHERE p.ESTADO LIKE 'En Stock' and p.ID_PRODUCTO  IN (select d.ID_PRODUCTO FROM detalle_venta);


#3) Listar cantidad de unidades que fueron vendidas de cada producto (id y
# descripción) y que vendedor (nombre completo) las llevo a cabo en la ciudad de
# Mar del Plata.

SELECT * FROM producto;
SELECT * from detalle_venta;
SELECT * FROM vendedor;
SELECT * FROM venta;


SELECT  p.ID_PRODUCTO,p.DESCRIPCION, 
Sum(d.CANTIDAD) AS cantidad_vendida,
CONCAT( e.NOMBRE, ' ' ,e.APELLIDO ) AS vendedor
FROM detalle_venta d
JOIN  producto p ON p.ID_PRODUCTO = d.ID_PRODUCTO
JOIN venta v ON v.NRO_FACTURA = d.NRO_FACTURA
JOIN vendedor e ON e.ID_EMPLEADO = v.ID_VENDEDOR
WHERE e.CIUDAD LIKE 'Mar del Plata'
GROUP BY p.ID_PRODUCTO, p.DESCRIPCION, e.NOMBRE, e.APELLIDO;


#4) Listar el nombre de cada vendedor y las ventas realizadas en el año 2015,
# ordenados de mayor a menor por apellido y nombre de cada vendedor

SELECT * FROM producto;
SELECT * from detalle_venta;
SELECT * FROM vendedor;
SELECT * FROM venta;

SELECT v.NOMBRE, e.NRO_FACTURA FROM vendedor v
JOIN venta e ON e.ID_VENDEDOR = v.ID_EMPLEADO
WHERE e.FECHA BETWEEN '2014-12-31' AND '2015-12-31'
ORDER BY CONCAT (v.NOMBRE, ' ', v.APELLIDO) DESC;

#5) Listar los clientes y las ventas realizadas de los productos 001 y 007
# llevadas a cabo en el mes de Mayo de 1998.

SELECT * FROM producto;
SELECT * FROM venta;
SELECT * FROM detalle_venta;
SELECT * FROM cliente;

SELECT c.NOMBRE,v.NRO_FACTURA FROM cliente c
JOIN venta v ON v.ID_CLIENTE = c.ID_CLIENTE
JOIN detalle_venta d ON d.NRO_FACTURA = v.NRO_FACTURA
WHERE d.ID_PRODUCTO IN (1,7)
AND v.FECHA BETWEEN '1998-05-01' AND '1998-05-31' ;

#6) Listar las ventas realizadas con el nro de detalle y el id producto, en el mes de
# Marzo de 2022, detallando quien fue el vendedor y los clientes involucrados en
# cada operación.

SELECT d.NRO_DETALLE,d.ID_PRODUCTO, CONCAT (e.NOMBRE, ' ',e.APELLIDO) AS vendedor 
,c.NOMBRE AS nombre_cliente FROM detalle_venta d 
JOIN venta v ON v.NRO_FACTURA = d.NRO_FACTURA
JOIN vendedor e ON e.ID_EMPLEADO = v.ID_VENDEDOR
JOIN cliente c ON c.ID_CLIENTE = v.ID_CLIENTE
WHERE v.FECHA BETWEEN '2022-03-01' AND '2022-03-31' ;


# listar el id y detalle del producto y el total vendido por producto separado por el vendedor que hizo la venta


SELECT p.ID_PRODUCTO,p.DESCRIPCION,SUM(d.CANTIDAD * d.PRECIO_UNITARIO) AS total_vendido,
CONCAT( ve.NOMBRE, ' ',ve.APELLIDO) AS vendedor
FROM producto p
JOIN detalle_venta d ON d.ID_PRODUCTO = p.ID_PRODUCTO
JOIN venta v ON v.NRO_FACTURA = d.NRO_FACTURA
JOIN vendedor ve ON ve.ID_EMPLEADO = v.ID_VENDEDOR
GROUP BY p.ID_PRODUCTO, p.DESCRIPCION, ve.NOMBRE, ve.APELLIDO
HAVING SUM(d.CANTIDAD * d.PRECIO_UNITARIO) > 1000
;





