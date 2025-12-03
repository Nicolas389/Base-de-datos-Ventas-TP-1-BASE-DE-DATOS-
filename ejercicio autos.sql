/*Trabajo Practico Subconsultas – ALQUILER DE AUTOS.

Dado el siguiente MR de una empresa de alquiler de autos, realice las operaciones indicadas

	Marca (idMarca, Descripcion)
	Vehiculo (Patente, Color, Año, Capacidad, Puertas, IdMarca)
	Localidad (IdLocalidad, Descripcion)
	Cliente (Legajo, Nombre, Apellido, Telefono, IdLocalidad)
	Alquiler (Id, Patente, legCliente, FechaAlquiler, Importe, CantDias)

	Vehiculo.IdMarca à Marca.idMarca
	Cliente.IdLocalidad à Localidad.IdLocalidad
	Alquiler.Patente à Vehiculo.Patente
	Alquiler.LegCliente à Cliente.Legajo

*/

# 1- generar el script para crear la base de datos
CREATE DATABASE autos;
USE autos;

-- MARCA
CREATE TABLE Marca (
    idMarca INT PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL
);

-- VEHICULO
CREATE TABLE Vehiculo (
    Patente VARCHAR(10) PRIMARY KEY,
    Color VARCHAR(20),
    Año INT,
    Capacidad INT,
    Puertas INT,
    IdMarca INT,
    FOREIGN KEY (IdMarca) REFERENCES Marca(idMarca)
);

-- LOCALIDAD
CREATE TABLE Localidad (
    IdLocalidad INT PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL
);

-- CLIENTE
CREATE TABLE Cliente (
    Legajo INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Telefono VARCHAR(20),
    IdLocalidad INT,
    FOREIGN KEY (IdLocalidad) REFERENCES Localidad(IdLocalidad)
);

-- ALQUILER
CREATE TABLE Alquiler (
    Id INT PRIMARY KEY,
    Patente VARCHAR(10),
    LegCliente INT,
    FechaAlquiler DATE,
    Importe DECIMAL(10,2),
    CantDias INT,
    FOREIGN KEY (Patente) REFERENCES Vehiculo(Patente),
    FOREIGN KEY (LegCliente) REFERENCES Cliente(Legajo)
);

-- MARCAS
INSERT INTO Marca (idMarca, Descripcion) VALUES
	(1, 'Toyota'),
	(2, 'Ford'),
	(3, 'Chevrolet')
   (4, 'Pollito'),
	(5, 'Perrito');


-- VEHICULOS
INSERT INTO Vehiculo (Patente, Color, Año, Capacidad, Puertas, IdMarca) VALUES
('AAA111', 'Rojo', 2020, 5, 4, 1),
('BBB222', 'Azul', 2018, 7, 5, 2),
('CCC333', 'Negro', 2021, 5, 4, 3),
('DDD444', 'Blanco', 2019, 5, 4, 1),
('EEE555', 'Gris', 2022, 5, 2, 2);

-- LOCALIDADES
INSERT INTO Localidad (IdLocalidad, Descripcion) VALUES
(1, 'Centro'),
(2, 'Norte'),
(3, 'Sur');

-- CLIENTES
INSERT INTO Cliente (Legajo, Nombre, Apellido, Telefono, IdLocalidad) VALUES
(1001, 'Martin', 'Perez', '12345678', 1),
(1002, 'Laura', 'Gomez', '87654321', 2),
(1003, 'Cristian', 'Lopez', '11223344', 3),
(1004, 'Ana', 'Martinez', '44332211', 1);

-- ALQUILERES
INSERT INTO Alquiler (Id, Patente, LegCliente, FechaAlquiler, Importe, CantDias) VALUES
--	(1, 'AAA111', 1001, '2025-03-01', 5000, 3),
--	(2, 'BBB222', 1002, '2025-03-02', 3000, 2),
--	(3, 'CCC333', 1003, '2025-03-03', 7000, 5),
--	(4, 'DDD444', 1001, '2025-03-04', 4500, 2),
--	(5, 'EEE555', 1004, '2025-03-05', 6000, 4);
--	(6, 'EEE555', 1001, '2025-03-05', 3000, 2),
(8, 'AAA111', 1002, '2025-03-05', 2500, 1);


# 2. Obtener los datos de todos los vehículos, ordenados por marca (descripción) y patente.

SELECT v.Patente,v.Color,v.`Año`,v.Capacidad,v.Puertas,m.Descripcion FROM vehiculo v
JOIN marca m ON m.idMarca = v.IdMarca
ORDER BY m.Descripcion, v.Patente;

# 3. Para cada marca, informar la cantidad de vehículos total y máxima capacidad,únicamente para aquellos 
#  vehículos con más de 4 puertas.

SELECT m.Descripcion, COUNT(v.Patente) AS total_vehiculos, MAX(v.Capacidad) FROM marca m
JOIN vehiculo v ON v.IdMarca = m.idMarca 
WHERE v.Puertas > 4
GROUP BY	 m.Descripcion;

# 4. 4. Informar: Legajo, Nombre y apellido del cliente, patente, color del auto, fecha de
# alquiler, importe, impuestos (15% del importe del alquiler), de todos los alquileres
# registrados en el mes de marzo entre el dia 01 al 03.

SELECT c.Legajo,c.Nombre,c.Apellido, v.Patente,v.Color,a.FechaAlquiler,a.Importe, a.Importe*0.15 AS impuesto FROM cliente c
JOIN alquiler a on a.LegCliente = c.Legajo
JOIN vehiculo v on v.Patente = a.Patente
WHERE a.FechaAlquiler BETWEEN '2025-03-01' AND '2025-03-03';


# 5. Generar el script para agregar el siguiente Auto: ABC234, Rojo, 2021, 5, 4, 5.


INSERT INTO vehiculo(Patente,Color,Año,Capacidad,Puertas,idMarca)
VALUES ('ABC234','Rojo',2021,5,4,5);

# 6 - Escribir la sentencia para modificar el color del auto CCC333 ya que el mismo es gris.


update vehiculo SET Color='Gris' WHERE Patente LIKE 'CCC333'; 

SELECT * FROM vehiculo;

INSERT INTO vehiculo (Patente,Color,Año,Capacidad,Puertas,IdMarca)
VALUES ('CAS213','Verde',2021,7,3,1)

# 7. Detallar la patente de todos los autos que tienen la máxima capacidad

SELECT v.Patente FROM vehiculo v
WHERE v.Capacidad = (SELECT MAX(v2.capacidad) FROM vehiculo v2)

# 8. Mostrar los datos de los clientes que han alquilado algún vehículo de Marca Toyota
# pero nunca han alquilado un Ford.

# con in

SELECT c.Legajo,c.Nombre,c.Apellido,c.Telefono, l.Descripcion AS localidad FROM cliente c
JOIN localidad l ON l.IdLocalidad = c.IdLocalidad
WHERE c.Legajo IN ( SELECT a.LegCliente FROM alquiler a
							JOIN vehiculo v ON v.Patente = a.Patente
							JOIN marca m ON m.idMarca = v.IdMarca
							WHERE m.Descripcion LIKE 'Toyota')
					AND c.Legajo NOT IN ( SELECT a.LegCliente FROM alquiler a
							JOIN vehiculo v ON v.Patente = a.Patente
							JOIN marca m ON m.idMarca = v.IdMarca
							WHERE m.Descripcion LIKE 'Ford');
		
# con exists
SELECT c.Legajo,c.Nombre,c.Apellido,c.Telefono, l.Descripcion AS localidad FROM cliente c
JOIN localidad l ON l.IdLocalidad = c.IdLocalidad
WHERE EXISTS (SELECT a.LegCliente FROM alquiler a
					JOIN vehiculo v ON v.Patente = a.Patente
					JOIN marca m ON m.idMarca = v.IdMarca
					WHERE m.Descripcion LIKE 'Toyota'
					AND a.LegCliente = c.Legajo)
AND NOT EXISTS	(SELECT a.LegCliente FROM alquiler a
					JOIN vehiculo v ON v.Patente = a.Patente
					JOIN marca m ON m.idMarca = v.IdMarca
					WHERE m.Descripcion LIKE 'Ford'
					AND a.LegCliente = c.Legajo)

# 9. Listar la patente, importe total de alquiler, cantidad de alquiler por auto, únicamente
# para los vehículos que hayan sido alquilados más de una vez



SELECT  a.Patente, SUM(a.Importe) AS importe_total,COUNT(a.Patente) AS cantidad_alquileres FROM alquiler a
GROUP BY a.Patente
HAVING COUNT(a.Patente) > 1;


SELECT A.Patente, SUM(A.Importe) Importe_Total, Count(Id) Cant_Alquileres
FROM Alquiler A
WHERE A.Patente IN
(SELECT A.Patente
FROM Alquiler A
GROUP BY A.Patente
HAVING count(A.Id) > 1)
GROUP BY A.Patente;


# 10. Informar los datos de los clientes que han alquilado más de una vez en la agencia en el
# último trimestre (enero, febrero y marzo 2020)

SELECT c.Legajo,c.Nombre,c.Apellido,c.Telefono,l.Descripcion FROM cliente c
JOIN localidad l ON l.IdLocalidad = c.IdLocalidad
WHERE c.Legajo IN 
	(SELECT a.LegCliente FROM alquiler a
	 WHERE MONTH(a.FechaAlquiler) IN (01,02,03) AND YEAR(a.FechaAlquiler) = 2025 
	 GROUP BY a.LegCliente
	  HAVING COUNT(a.Id) > 1)


SELECT C.Legajo, C.Nombre, C.Apellido FROM Cliente C WHERE Legajo IN (SELECT legCliente FROM
Alquiler WHERE FechaAlquiler BETWEEN ‘20240101’ AND ‘20240331’ GROUP BY legCliente HAVING
COUNT (c.Nombre) > 1)
