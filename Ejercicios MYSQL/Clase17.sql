USE sakila;

-- Create two or three queries using address table in sakila db:
-- include postal_code in where (try with in/not it operator)
-- eventually join the table with city/country tables.
-- measure execution time.
-- Then create an index for postal_code on address table.
-- measure execution time again and compare with the previous ones.
-- Explain the results.

SELECT
	a.postal_code
FROM
	address a
WHERE
	a.postal_code IN(
	SELECT
		a2.address_id
	FROM
		address a2
	INNER JOIN city c
			USING(city_id))
ORDER BY
	postal_code;
-- 0.15 sec

SELECT a.postal_code, c.city, co.country
FROM address a
INNER JOIN city c USING(city_id)
INNER JOIN country co USING(country_id) ORDER BY a.postal_code;
-- 0.18 sec

CREATE INDEX postalCode on address(postal_code);
-- despues de hacer el indice
-- primera query 0.10 sec
-- segunda query 0.11 sec

-- Esto ocurre por que MYSQL busca si existe un indice, por lo que si esto se cumple MYSQL usa este indice
-- correspondiente a la fila en la que la tabla esta siendo seleccionada. 

-- This is because MySQL checks if the indexes exist, then MySQL uses 
-- the indexes to select exact physical corresponding rows of the table instead of scanning 
-- the whole table.

-- Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
SELECT a.first_name FROM actor a;

SELECT a.last_name FROM actor a;

-- Cuando ejecuto las querys de first_name y last_name, por momentos la query de last_name tiene menor tiempo de ejecucion.
-- Esto se debe a que actor last_name tiene un indice creado. Llamado "idx_actor_last_name"

-- Compare results finding text in the description on table film with LIKE and in the film_text using
-- MATCH ... AGAINST. Explain the results.
ALTER TABLE film_text 
ADD FULLTEXT(description);

SELECT f.description FROM film f WHERE f.description LIKE '%Action%';
-- 0.06 sec
-- 0.18 sec
-- 0.20 sec

SELECT description
FROM film_text
WHERE MATCH(description) AGAINST("Action");
-- 0.09 sec
-- 0.18 sec
-- 0.10 sec

-- Pense que la query con film_text iba a ser mas rapido, aunque depende el momento llega a ser mas rapida que la anterior.
-- Pero puede llegar a ser logico ya que la segunda query esta buscando una plabra especifica mientras que la otra solo busca un caracter,
-- Pero si intento ejecutar la primer query diciendo que busque Action esta tiene una demora mayor mientras que la segunda es mas rapida.

