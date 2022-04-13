USE sakila;

-- 1) Show title and special_features of films that are PG-13
SELECT
	title,
	special_features,
	rating
FROM
	film f
WHERE
	f.rating = 'PG-13';

-- 2) Get a list of all the different films duration.
SELECT
	title,
	`length`
FROM
	film f
ORDER BY
	f.`length`;

-- 3) Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
SELECT
	title,
	rental_rate,
	replacement_cost
FROM
	film f
WHERE
	replacement_cost BETWEEN 20 AND 24
ORDER BY
	replacement_cost;

-- 4) Show title, category and rating of films that have 'Behind the Scenes' as special_features
SELECT
	f.title,
	f.rating,
	c.name
FROM
	film f
JOIN film_category fc ON
	f.film_id = fc.film_id
JOIN category c ON
	fc.category_id = c.category_id
WHERE
	f.special_features LIKE '%Behind the Scenes%';

-- 5) Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
SELECT
	a.first_name,
	a.last_name,
	f.title
FROM
	actor a
JOIN film_actor fa ON
	a.actor_id = fa.actor_id
JOIN film f ON
	fa.film_id = f.film_id
WHERE
	f.title LIKE '%ZOOLANDER FICTION%';

-- 6) Show the address, city and country of the store with id 1
SELECT
	a.address ,
	c.city,
	c2.country
FROM
	store s
JOIN address a ON
	s.address_id = a.address_id
JOIN city c ON
	a.city_id = c.city_id
JOIN country c2 ON
	c.country_id = c2.country_id
WHERE
	s.store_id = '1';

-- 7) Show pair of film titles and rating of films that have the same rating.
SELECT
	f1.title,
	f2.title,
	f1.rating
FROM
	film f1,
	film f2
WHERE
	f1.rating = f2.rating;

-- 8) Get all the films that are available in store id 2 and the manager 
-- first/last name of this store (the manager will appear in all the rows).
SELECT
	s.first_name AS "Nombre",
	s.last_name AS "Apellido",
	f.title AS "Titulo de Pelicula"
FROM
	staff s
JOIN store st ON
	s.staff_id = st.store_id
JOIN inventory i ON
	st.store_id = i.store_id
JOIN film f ON
	i.film_id = f.film_id
WHERE
	st.store_id = 2;



