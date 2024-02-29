-- -- For this challenge I created a local POSTGRESQL database with the following tables and values


CREATE TABLE aerolineas (
    id_aerolinea SERIAL PRIMARY KEY,
    nombre_aerolinea VARCHAR(255) NOT NULL
);

INSERT INTO aerolineas (id_aerolinea, nombre_aerolinea) VALUES
(1, 'Volaris'),
(2, 'Aeromar'),
(3, 'Interjet'),
(4, 'Aeromexico');

create table aeropuertos (
	id_aeropuerto SERIAL primary key, 
	nombre_aeropuerto varchar(255) not NULL
);

insert into aeropuertos (id_aeropuerto, nombre_aeropuerto) values
(1, 'Benito Juarez'),
(2, 'Guanajuato'),
(3, 'La paz'),
(4, 'Oaxaca');

create table movimientos (
	id_movimiento SERIAL primary key, 
	descripcion varchar(255) not null
);

insert into movimientos (id_movimiento, descripcion) values
(1, 'Salida'),
(2, 'Llegada');

CREATE TABLE vuelos (
    id_aerolinea INTEGER NOT NULL,
    id_aeropuerto INTEGER NOT NULL,
    id_movimiento INTEGER NOT NULL,
    dia DATE NOT NULL
);

INSERT INTO vuelos (id_aerolinea, id_aeropuerto, id_movimiento, dia) VALUES
(1, 1, 1, '2021-05-02'),
(2, 1, 1, '2021-05-02'),
(3, 2, 2, '2021-05-02'),
(4, 3, 2, '2021-05-02'),
(1, 3, 2, '2021-05-02'),
(2, 1, 1, '2021-05-02'),
(2, 3, 1, '2021-05-04'),
(3, 4, 1, '2021-05-04'),
(3, 4, 1, '2021-05-04');

------

-- The queries use to answer are the following

-- Q1

SELECT a.nombre_aeropuerto, COUNT(*) AS total_movimientos
FROM vuelos v
JOIN aeropuertos a ON v.id_aeropuerto = a.id_aeropuerto
GROUP BY a.nombre_aeropuerto
ORDER BY total_movimientos DESC

-- ANSWER
-- nombre_aeropuerto	total_movimientos
-- Benito Juarez	            3
-- La paz	                    3
-- Oaxaca	                    2
-- Guanajuato	                1


-- Q2

SELECT a.nombre_aerolinea, COUNT(*) AS total_vuelos
FROM vuelos v
JOIN aerolineas a ON v.id_aerolinea = a.id_aerolinea
GROUP BY a.nombre_aerolinea
ORDER BY total_vuelos DESC

-- ANSWER

-- nombre_aerolinea	total_vuelos
-- Aeromar	            3
-- Interjet	            3
-- Volaris	            2
-- Aeromexico	        1

-- Q3

SELECT dia, COUNT(*) AS total_vuelos
FROM vuelos
GROUP BY dia
ORDER BY total_vuelos DESC

-- ANSWER
-- dia          total_vuelos
-- 2021-05-02	    6
-- 2021-05-04	    3

-- Q4

SELECT a.nombre_aerolinea, v.dia, COUNT(*) AS total_vuelos
FROM vuelos v
JOIN aerolineas a ON v.id_aerolinea = a.id_aerolinea
GROUP BY a.nombre_aerolinea, v.dia
HAVING COUNT(*) >= 2 -- As a note this is done only to show flights that happened twice in a day, there are no flights from any airlines that occur more than 2 times per day if the question
ORDER BY a.nombre_aerolinea, total_vuelos DESC;

-- ANSWER
-- nombre_aerolinea	    dia	        total_vuelos
-- Aeromar	          2021-05-02	    2
-- Interjet	          2021-05-04	    2
-- Volaris	          2021-05-02	    2

-- Q4 FINAL ANSWER

SELECT a.nombre_aerolinea, v.dia, COUNT(*) AS total_vuelos
FROM vuelos v
JOIN aerolineas a ON v.id_aerolinea = a.id_aerolinea
GROUP BY a.nombre_aerolinea, v.dia
HAVING COUNT(*) > 2
ORDER BY a.nombre_aerolinea, total_vuelos DESC;

-- ANSWER
-- THIS IS EMPTY