USE sakila;

-- 1. Create a view named list_of_customers, it should contain the following columns:
-- customer id
-- customer full name,
-- address
-- zip code
-- phone
-- city
-- country
-- status (when active column is 1 show it as 'active', otherwise is 'inactive')
-- store id
CREATE OR REPLACE
VIEW list_of_customers AS
    SELECT
	c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS 'Full name',
	a.address,
	a.postal_code,
	a.phone,
	ci.city,
	co.country,
	CASE
		WHEN active = 1 THEN 'active'
		ELSE 'inactive'
	END AS status,
		store_id
FROM
	customer c
INNER JOIN address a
		USING(address_id)
INNER JOIN city ci
		USING(city_id)
INNER JOIN country co
		USING(country_id)
INNER JOIN store s
		USING(store_id);

SELECT * FROM list_of_customers;

-- 2. Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
CREATE OR REPLACE
VIEW film_details AS
    SELECT
	f.film_id,
	f.title,
	f.description,
	f.rental_rate,
	f.length,
	f.rating,
	GROUP_CONCAT(CONCAT_WS(" ", a.first_name, a.last_name) SEPARATOR ",") AS actors
FROM
	film f
INNER JOIN film_category
		USING(film_id)
INNER JOIN category c
		USING(category_id)
INNER JOIN film_actor
		USING(film_id)
INNER JOIN actor a
		USING(actor_id)
GROUP BY
	film_id;

SELECT * FROM film_details;

-- 3. Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE OR REPLACE VIEW sales_by_film_category AS
	SELECT c.name, SUM(amount) AS total_rental FROM category c 
	INNER JOIN film_category fc USING(category_id) 
	INNER JOIN film f USING(film_id) 
	INNER JOIN inventory i  USING(film_id)
	INNER JOIN rental r USING(inventory_id)
	INNER JOIN payment p  USING(rental_id) GROUP BY 1;

SELECT * FROM sales_by_film_category;

-- 4. Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE OR REPLACE VIEW actor_information AS
SELECT	
	a.actor_id,
	a.first_name,
	a.last_name,
	COUNT(fa.actor_id) AS 'cantidad peliculas'
FROM
	actor a
JOIN film_actor fa ON
	a.actor_id = fa.actor_id
GROUP BY
	actor_id;
	  
SELECT * FROM actor_information;

-- 5. Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
-- Esta vista muestra los datos de actor en 4 columnas distintas, actor_id, first_name, last_name.
-- La ultima columna muestra todas las peliculas en las que actuo actor, agrupadas por categoria.
-- Esto se puede debido a que se concatena cada categoria con un grupo de peliculas y despues concatenando
-- los grupos de categorias con sus peliculas. 
-- Como dato, la vista contiene valores de la tabla actor, y unidas por un join por las tablas film_actor,
-- film_category y category. 

-- Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
-- Son una forma para almacenar en cache los resultados de las consultas. La principal diferencia 
-- con este tipo de views con las comunes es que las materialized views son tablas concretas que almacenan
-- los resultados de una consulta.
-- Se utilizan principalmente para mejorar el rendimiento y existe una variedad de DBMS, pero no en MYSQL
-- Para esto se pueden llegar a implementar algunas soluciones con triggers.