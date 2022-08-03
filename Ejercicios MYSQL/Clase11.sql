USE sakila;

-- 1- Find all the film titles that are not in the inventory.
SELECT
	f.title
FROM
	film f
LEFT JOIN inventory i ON
	f.film_id = i.film_id
WHERE
	i.film_id IS NULL;

-- 2- Find all the films that are in the inventory but were never rented.
-- Show title and inventory_id.
-- This exercise is complicated.
-- hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null
SELECT
	f.title,
	r.rental_date,
	i.inventory_id
FROM
	film f
LEFT JOIN inventory i ON
	f.film_id = i.film_id
LEFT JOIN rental r ON
	i.inventory_id = r.inventory_id
WHERE
	r.rental_date IS NULL;

-- 3- Generate a report with:
-- customer (first, last) name, store id, film title,
-- when the film was rented and returned for each of these customers
-- order by store_id, customer last_name
SELECT
	c.first_name,
	c.last_name,
	s.store_id,
	f.title,
	r.rental_date,
	r.return_date
FROM
	rental r
INNER JOIN customer c
		USING(customer_id)
INNER JOIN store s
		USING(store_id)
INNER JOIN inventory i
		USING(inventory_id)
INNER JOIN film f
		USING(film_id)
ORDER BY
	s.store_id,
	c.last_name;

-- 4- Show sales per store (money of rented films)
-- show store's city, country, manager info and total sales (money)
-- (optional) Use concat to show city and country and manager first and last name
SELECT
	s2.store_id,
	CONCAT(c2.country, ' ', c.city) AS 'Contry and City',
	CONCAT(s.first_name, ' ', s.last_name) AS 'FirstName and LastName',
	(
	SELECT
		SUM(p.amount)
	FROM
		payment p
	WHERE
		p.staff_id = s.staff_id) AS 'Total Sales'
FROM
	staff s
INNER JOIN store s2 ON
	s.store_id = s2.store_id
INNER JOIN address a ON
	a.address_id = s.address_id
INNER JOIN city c
		USING(city_id)
INNER JOIN country c2
		USING(country_id);

-- 5- Which actor has appeared in the most films?
SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS 'FirsName and LastName',
	COUNT(fa.film_id) AS 'Total Films'
FROM
	actor a
INNER JOIN film_actor fa
		USING (actor_id)
GROUP BY
	fa.actor_id
ORDER BY
	'Total Films';