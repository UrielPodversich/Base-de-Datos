USE sakila;
-- Obtener el mayor precio de reemplazo(replacement_cost), si este se repite mostrar nada, en 
-- una columna separada mostrar los titulos de las peliculas con este precio de reemplazo. En 
-- otra columna mostrar la pelicula con menor duracion(duracion) siempre y cuando esta no sea 
-- una de las que tienen el mayor precio de reemplazo obtenidas anteriormente.


-- Obtener las peliculas cuyas duraciones son mayores a la duracion(length) minima
SELECT
	f.title,
	f.`length`
FROM
	film f
WHERE
	`length` > (
	SELECT
		MIN(f2.`length`)
	FROM
		film f2)
GROUP BY
	f.`length`,
	f.title;

-- Obtener los pares de payments que comparten un monto(amount)
SELECT
	p.amount,
	p.payment_id,
	p2.payment_id 
FROM
	payment p,
	payment p2
WHERE
	p.payment_id  = p2.payment_id;
	
-- Obtener la variacion(max-min) de la duracion por rating(rating) y caracteristicas especiales
-- (special_features), pista usar agregaciones(max,min,group by,avg,etc.) y subqueries
SELECT
	f3.rating,
	f3.`length`,
	f3.special_features
FROM
	film f3 WHERE
	(
	SELECT
		MIN(f.`length`)
	FROM
		film f) 
	(
	SELECT
		MAX(f2.`length`)
	FROM
		film f2)
GROUP BY f3.rating, f3.`length`, f3.special_features;



SELECT f2.rating, f2.special_features, f2.`length` FROM film f2 WHERE f2.`length` =(SELECT MAX(f.`length`) - MIN(f.`length`) FROM film f) GROUP BY f2.rating,f2.special_features; 

-- Obtener las peliculas cuyas duraciones son mayores a la duracion(length) minima
SELECT
	f.title,
	f.`length`
FROM
	film f
WHERE
	`length` > (
	SELECT
		MIN(f2.`length`)
	FROM
		film f2)
GROUP BY
	f.`length`,
	f.title;


-- Obtener la venta maxima, minima, la venta cuyo monto es igual al promedio, la cantidad de 
-- ventas y el monto recaudado por cada staff
SELECT
	AVG(p.amount),
	(
	SELECT
		MIN(p.amount)
	FROM
		payment p2) AS min_amount,
	(
	SELECT
		MAX(p3.amount)
	FROM
		payment p3) AS max_amount 
FROM payment p JOIN staff s ON p.staff_id = s.staff_id;

SELECT FROM payment p 

-- Obtener las peliculas cuya descripcion contenga un caracter que no sea una letra, es decir 
-- caracteres especiales, numeros,etc.
SELECT
	f.title,
	description
FROM
	film f
WHERE
	f.description NOT LIKE '%[A-Za-z]%'
	AND f.description NOT LIKE '%[0-9]%';

-- Obtener las peliculas que tienen los actors, PENELOPE GUINESS, NICK	WAHLBERG pero cuya 
-- categoria no es Documentary

SELECT
	f.title
FROM
	film f
WHERE
	ANY(
	SELECT
		a2.actor_id
	FROM
		actor a
	WHERE
		a.first_name LIKE '%PENELOPE%'
		AND a.last_name LIKE '%GUINESS%'
		OR a.first_name LIKE '%NICK%'
		AND a.last_name LIKE '%WAHLBERG%') ;
	
-- Mostrar los datos del cliente, la cantidad de peliculas que alquilo y en una columna 
-- separado por comas el nombre de las peliculas que alguna vez alquilo. Ademas debera 
-- mostrar su compra maxima y minima y el promedio del monto de sus compras
SELECT c.first_name, c.last_name FROM customer c;

SELECT MIN(p.amount) FROM payment p;
SELECT MAX(p.amount) FROM payment p;

SELECT GROUP_CONCAT( f.title SEPARATOR ', ') FROM film f;
-- Obtener los pares de actores que comparten nombre, luego obtener los pares de clientes 
-- que comparten nombres. Mostrar ambos resultados, es posible mostrar los valores que se 
-- comparten? No por que no se acepta en la version de mysql que se esta usando, pero si existe. 
	
SELECT CONCAT(a.first_name, ' ',a.last_name)AS Actor_1, CONCAT(a2.first_name, ' ',a2.last_name)AS Actor_2 FROM actor a, actor a2 WHERE a.first_name = a2.first_name 
UNION 
SELECT CONCAT(c.first_name,' ',c.last_name)AS Customer_1 , CONCAT(c2.first_name, ' ',c2.last_name) AS Customer_2  FROM customer c, customer c2 WHERE c.first_name = c2.first_name;


