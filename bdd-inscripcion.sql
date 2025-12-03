-- ============================================
-- SCRIPT DE PRACTICA SQL (Nico Gonzalez)
-- ============================================

-- =============================
-- CREACION DE TABLAS
-- =============================

CREATE TABLE Profesor (
  id_profesor INT PRIMARY KEY,
  nombre VARCHAR(50),
  departamento VARCHAR(50)
);

CREATE TABLE Alumno (
  id_alumno INT PRIMARY KEY,
  nombre VARCHAR(50),
  carrera VARCHAR(50),
  promedio DECIMAL(3,1)
);

CREATE TABLE Materia (
  id_materia INT PRIMARY KEY,
  nombre VARCHAR(50),
  creditos INT,
  id_profesor INT,
  FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor)
);

CREATE TABLE Inscripcion (
  id_inscripcion INT PRIMARY KEY,
  id_alumno INT,
  id_materia INT,
  nota_final DECIMAL(3,1),
  fecha_inscripcion DATE,
  FOREIGN KEY (id_alumno) REFERENCES Alumno(id_alumno),
  FOREIGN KEY (id_materia) REFERENCES Materia(id_materia)
);

-- =============================
-- INSERCION DE DATOS
-- =============================

INSERT INTO Profesor (id_profesor, nombre, departamento)
VALUES
(1, 'Pablo Perez', 'Informatica'),
(2, 'Maria Estevez', 'Biologia'),
(3, 'Sandra Sanchez', 'Matematica'),
(4, 'Laura Gómez', 'Informatica');

INSERT INTO Alumno (id_alumno, nombre, carrera, promedio)
VALUES 
(1, 'Martin Sanchez', 'Informatica', 5.4),
(2, 'Laura Gomez', 'Ingenieria', 6.3),
(3, 'Cristian Sancho', 'Biologia', 7.4),
(4, 'Cristian Castro', 'Informatica', 5.4),
(5, 'Martin Sanchez', 'Ingenieria', 2.1);

INSERT INTO Materia (id_materia, nombre, creditos, id_profesor) 
VALUES 
(1, 'Base de datos', 2, 4),
(2, 'Algebra lineal', 1, 3),
(3, 'Quimica', 2, 2),
(4, 'Ingles 2', 2, 1);

INSERT INTO Inscripcion (id_inscripcion, id_alumno, id_materia, nota_final, fecha_inscripcion)
VALUES 
(2, 2, 4, 8.5, '2025-03-14'),
(3, 2, 2, 9.0, '2025-03-14'),
(4, 1, 3, 8.0, '2025-03-15'),
(5, 3, 4, 7.0, '2025-03-16'),
(6, 3, 3, 4.0, '2025-03-16'),
(7, 3, 2, 5.0, '2025-03-16'),
(8, 4, 4, 10.0, '2025-03-12');

-- =============================
-- ACTUALIZACIONES
-- =============================

UPDATE Alumno 
SET promedio = promedio + 0.5 
WHERE carrera = 'Ingenieria' AND promedio < 7;

UPDATE Materia 
SET id_profesor = 3 
WHERE nombre = 'Base de datos';

UPDATE Inscripcion 
SET nota_final = 7 
WHERE id_inscripcion = 6;

-- =============================
-- CONSULTAS CON GROUP BY / HAVING
-- =============================

SELECT m.nombre, AVG(i.nota_final) AS promedio_general
FROM Inscripcion i
JOIN Materia m ON m.id_materia = i.id_materia
GROUP BY m.nombre;

SELECT m.nombre, AVG(i.nota_final) AS promedio_general
FROM Inscripcion i
JOIN Materia m ON m.id_materia = i.id_materia
GROUP BY m.nombre
HAVING AVG(i.nota_final) >= 8;

SELECT p.nombre, COUNT(i.id_alumno) AS alumnosX_profesor
FROM Inscripcion i
JOIN Materia m ON m.id_materia = i.id_materia
JOIN Profesor p ON p.id_profesor = m.id_profesor
GROUP BY p.nombre;

-- =============================
-- CONSULTAS CON IN / EXISTS / NOT EXISTS
-- =============================

-- Alumnos inscritos en materias de Sandra Sanchez
SELECT a.nombre
FROM Alumno a
WHERE a.id_alumno IN (
  SELECT i.id_alumno
  FROM Inscripcion i
  JOIN Materia m ON m.id_materia = i.id_materia
  JOIN Profesor p ON p.id_profesor = m.id_profesor
  WHERE p.nombre = 'Sandra Sanchez'
);

SELECT a.nombre
FROM Alumno a
WHERE EXISTS (
  SELECT 1
  FROM Inscripcion i
  JOIN Materia m ON m.id_materia = i.id_materia
  JOIN Profesor p ON p.id_profesor = m.id_profesor
  WHERE p.nombre = 'Sandra Sanchez'
  AND a.id_alumno = i.id_alumno
);

-- Materias con alumnos de Informatica
SELECT m.nombre
FROM Materia m
WHERE m.id_materia IN (
  SELECT i.id_materia
  FROM Inscripcion i
  JOIN Alumno a ON a.id_alumno = i.id_alumno
  WHERE a.carrera = 'Informatica'
);

SELECT m.nombre
FROM Materia m
WHERE EXISTS (
  SELECT 1
  FROM Inscripcion i
  JOIN Alumno a ON a.id_alumno = i.id_alumno
  WHERE a.carrera = 'Informatica'
  AND m.id_materia = i.id_materia
);

-- Alumnos inscritos en materias de su mismo departamento
SELECT DISTINCT a.nombre
FROM Alumno a
WHERE a.id_alumno IN (
  SELECT i.id_alumno
  FROM Inscripcion i
  JOIN Materia m ON m.id_materia = i.id_materia
  JOIN Profesor p ON p.id_profesor = m.id_profesor
  WHERE p.departamento = a.carrera
);

SELECT a.nombre
FROM Alumno a
WHERE EXISTS (
  SELECT 1
  FROM Inscripcion i
  JOIN Materia m ON m.id_materia = i.id_materia
  JOIN Profesor p ON p.id_profesor = m.id_profesor
  WHERE p.departamento = a.carrera
  AND a.id_alumno = i.id_alumno
);

-- Alumnos no inscritos en ninguna materia
SELECT a.nombre
FROM Alumno a
WHERE NOT EXISTS (
  SELECT 1
  FROM Inscripcion i
  WHERE a.id_alumno = i.id_alumno
);


# Listar los alumnos que no están inscritos en ninguna materia del departamento "Informatica".


SELECT a.nombre FROM alumno a
WHERE a.id_alumno NOT IN ( 
						SELECT i.id_alumno FROM inscripcion i
						JOIN materia m ON m.id_materia = i.id_materia
						JOIN profesor p ON p.id_profesor = m.id_profesor
						WHERE p.departamento = 'Informatica');
	
# con no exists 

SELECT a.nombre FROM alumno a
WHERE NOT EXISTS ( SELECT 1 FROM inscripcion i 
						JOIN materia m ON m.id_materia = i.id_materia
						JOIN profesor p ON p.id_profesor = m.id_profesor
						WHERE p.departamento LIKE 'Informatica'
						AND a.id_alumno = i.id_alumno);

SELECT * FROM alumno;

UPDATE alumno SET nombre = 'Carla Pons' WHERE id_alumno = 5;

# Mostrar las materias que no tienen alumnos de la carrera "Ingeniería".

# con not in

SELECT m.id_materia,m.nombre FROM materia m
WHERE m.id_materia NOT IN ( SELECT i.id_materia FROM inscripcion i
									JOIN alumno a ON a.id_alumno = i.id_alumno
									WHERE a.carrera LIKE 'Ingenieria');

# con not exists

SELECT m.id_materia,m.nombre FROM materia m
WHERE NOT EXISTS ( SELECT 1 FROM inscripcion i
						JOIN alumno a ON a.id_alumno = i.id_alumno
						WHERE i.id_materia = m.id_materia and
						a.carrera LIKE 'Ingenieria');

# Listar los profesores que no dictan materias en las que haya alumnos con promedio menor a 6.

# con not in



SELECT p.id_profesor,p.nombre FROM profesor p
WHERE p.id_profesor NOT IN ( 
									SELECT m.id_profesor FROM materia m
									JOIN inscripcion i ON i.id_materia = m.id_materia
									JOIN alumno a ON a.id_alumno = i.id_alumno
									WHERE a.promedio < 6);


# con not exists

SELECT p.id_profesor,p.nombre FROM profesor p
WHERE NOT EXISTS ( SELECT 1 FROM materia m 
						JOIN inscripcion i ON i.id_materia = m.id_materia
						JOIN alumno a ON a.id_alumno = i.id_alumno
						WHERE p.id_profesor = m.id_profesor
						AND a.promedio < 6);
						
						
# Mostrar los nombres de los profesores que dictan materias donde el promedio general de
#  notas de los alumnos supera el  promedio general de todas las materias.

SELECT * FROM materia;
SELECT * FROM inscripcion;
SELECT * FROM alumno;

SELECT p.id_profesor,p.nombre FROM profesor p
WHERE p.id_profesor IN (SELECT m.id_profesor FROM materia m
								JOIN inscripcion i ON i.id_materia = m.id_materia
								 )
								 
								 
SELECT DISTINCT p.id_profesor, p.nombre
FROM profesor p
WHERE p.id_profesor IN (
    SELECT m.id_profesor
    FROM materia m
    JOIN inscripcion i ON i.id_materia = m.id_materia
    GROUP BY m.id_materia, m.id_profesor
    HAVING AVG(i.nota_final) > (
        SELECT AVG(nota_final) FROM inscripcion
    )
);


# Mostrar los alumnos que están inscritos en al menos una materia cuyo promedio de notas (de todos los alumnos que la cursan) es mayor que el promedio general de notas de los alumnos de la carrera del propio alumno.


SELECT * FROM materia;
SELECT * FROM inscripcion;
SELECT * FROM alumno;


SELECT a.id_alumno, a.nombre FROM alumno a
WHERE a.id_alumno IN ( SELECT i.id_alumno FROM inscripcion i
								GROUP BY i.id_alumno, i.id_materia
								HAVING AVG(i.nota_final) > ( SELECT AVG(a2.promedio) FROM alumno a2
																		WHERE a.carrera = a2.carrera) );
SELECT DISTINCT a.id_alumno, a.nombre 
FROM alumno a
JOIN inscripcion i ON a.id_alumno = i.id_alumno
JOIN materia m ON i.id_materia = m.id_materia
WHERE (
    SELECT AVG(i2.nota_final)
    FROM inscripcion i2
    JOIN alumno a2 ON a2.id_alumno = i2.id_alumno
    WHERE a2.carrera = a.carrera
) < (
    SELECT AVG(i3.nota_final)
    FROM inscripcion i3
    WHERE i3.id_materia = i.id_materia
)
;
								