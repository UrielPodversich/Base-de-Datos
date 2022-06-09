USE sakila;

-- Mostrar todos los clientes que hayan alquilado una pelicula pero que todavia no fueron devueltas
SELECT
	c.first_name,
	c.last_name,
	r.return_date
FROM
	customer c
JOIN rental r ON
	c.customer_id = r.customer_id
WHERE
	r.return_date IS NULL;

-- Obtener todos los rental cuyo precio de alquiler este entre 2 y 7
SELECT
	r.rental_id,
	p.amount
FROM
	rental r
JOIN payment p ON
	r.rental_id = p.rental_id
WHERE
	p.amount BETWEEN 2 AND 7;

-- Mostrar el pago mayor y menor de cada cliente, resolver con subqueries. En una columna separada, listar sus pagos separados por comas
SELECT p2.amount FROM payment p2 WHERE p2.amount = (SELECT MIN(p.amount), MAX(p.amount) FROM payment p);

-- Obtener el precio de reemplazo mayor y menor de cada pelicula, si se repite no mostrar el valor Opcional (debera mostrar los nombres de las peliculas que comparten el valor)

-- Obtener los pares de clientes que comparten el mismo nombre
SELECT
	c.first_name,
	c.last_name
FROM
	customer c 
WHERE
	EXISTS (
	SELECT
		*
	FROM
		customer c2 
	WHERE
		c.first_name = c2.first_name);

-- Listar todos los actores que actuaron en 'BETRAYED REAR' y 'CATCH AMISTAD' pero no en 'ACE GOLDFINGER'
SELECT
	a.first_name,
	a.last_name
FROM
	actor a
WHERE
	actor_id IN (
	SELECT
		a.actor_id
	FROM
		film_actor fa
	WHERE
		fa.film_id IN(
		SELECT
			f.film_id
		FROM
			film f
		WHERE
			f.title LIKE 'BETRAYED REAR'
			AND f.title LIKE 'CATCH AMISTAD'
			AND f.title NOT LIKE 'ACE GOLDFINGER'));

-- Mostrar las peliculas que tienen mas de 4 actores
SELECT
	f.title
FROM
	film f
WHERE
	4 < (
	SELECT
		COUNT(*)
	WHERE
		film_id IN(
		SELECT
			film_id
		FROM
			film_actor fa));















