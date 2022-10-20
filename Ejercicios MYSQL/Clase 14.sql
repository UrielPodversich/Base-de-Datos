-- Active: 1664921352992@@127.0.0.1@3306@sakila

USE sakila;

/*
 1.
 Write a query that gets all the customers that live in Argentina. Show the first and last name in one
 column, the address and the city.
 */

SELECT
    CONCAT(" ", c.first_name, c.last_name) AS full_name,
    a.address,
    ci.city
FROM customer c
    INNER JOIN address a USING(address_id)
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
WHERE
    co.country LIKE "Argentina";

/*
 2.
 Write a query that shows the film title, language and rating. Rating shall be shown as the full text 
 described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#Unixxxxxxxted_States.
 Hint: use case.
 */

SELECT
    f.title,
    la.name,
    CASE
        WHEN rating = 'G' THEN 'All Ages Are Admitted.'
        WHEN rating = 'PG' THEN 'Some Material May Not Be Suitable For Children.'
        WHEN rating = 'PG-13' THEN 'Some Material May Be Inappropriate For Children Under 13.'
        WHEN rating = 'R' THEN 'Under 17 Requires Accompanying Parent Or Adult Guardian.'
        WHEN rating = 'NC-17' THEN 'No One 17 and Under Admitted.'
        ELSE "Dont have rating"
    END AS rating_description
FROM film f
    INNER JOIN language la USING(language_id);

/*/
 3.
 Write a search query that shows all the films (title and release year) an actor was part of. Assume the 
 actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to 
 try to find the films as effectively as you think is possible.
 /*/

SELECT title, release_year
FROM film f
    INNER JOIN film_actor USING(film_id)
    INNER JOIN actor USING(actor_id)
WHERE
    CONCAT_WS(" ", first_name, last_name) LIKE TRIM(UCASE(" HeLeN vOiGhT "));

/*/
 4.
 Find all the rentals done in the months of May and June. Show the film title, customer name and if it 
 was returned or not. There should be returned column with two possible values 'Yes' and 'No'.
 /*/

SELECT
    CONCAT_WS(" ", c.first_name, c.last_name) AS full_name,
    CASE
        WHEN r.return_date IS NOT NULL THEN "YES"
        ELSE "NO"
    END AS returned,
    MONTHNAME(r.rental_date) AS month
FROM film f
    INNER JOIN inventory i USING(film_id)
    INNER JOIN rental r USING (inventory_id)
    INNER JOIN customer c USING(customer_id)
WHERE
    MONTHNAME(r.rental_date) LIKE "May"
    OR MONTHNAME(r.rental_date) LIKE "June";

/*/
 5.
 Investigate CAST and CONVERT functions. Explain the differences if any,
 write examples based on sakila DB.
 /*/

--La funcion CAST() convierte un valor en un tipo de dato especifico por ejemplo:

SELECT CAST(rental_date AS DATE) FROM rental r;

SELECT CAST(rental_date AS DATETIME) FROM rental r;

-- La funcon CONVERT() realiza lo mismo, ni tienen la misma funcion solo que con algunos pequeños detalles.

-- Simplemente la unica direncia seria que CAST es puramente un estándar ANSI-SQL.

-- Pero, CONVERT es función específica de SQL Server del mismo modo que tenemos en to_char o to_date

-- en Oracle. Ejemplo de CONVERT

SELECT CONVERT("2004-04-24", DATETIME);

/*/
 6.
 Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. 
 Which ones are not in MySql and write usage examples.
 /*/

/*/
 IFNULL() devuelve un valor o expresion especifica o una segunda expresion si la expression is NULL.
 Una expresión NVL checkea que la si la expresion es NULL, si lo es, devuelve una segunda expresion
 Asi como IFNULL.
 NVL() es una funcion de ORACLE, asi que IFNULL vendria siendo un NVL pero en SQL.
 /*/

SELECT
    rental_id,
    IFNULL(
        return_date,
        'Las peliculas no fueron devueltas aun'
    ) as fecha_devolucion
FROM rental
WHERE
    rental_id BETWEEN 50 AND 100;

-- ISNULL() devuelve 1 o 0 dependiendo de si la expresion es nula. si es NULL devuelve 1 sino 0.

SELECT
    rental_id,
    ISNULL(return_date) as return_film
FROM rental
WHERE
    rental_id BETWEEN 50 AND 100;

-- COALESCE devuelve el valor de la primera expresión en la lista que no sea nulo.

SELECT COALESCE(
        NULL, NULL, (
            SELECT
                return_date
            FROM rental
            WHERE
                rental_id = 12610
        ),
        -- fecha null  (
            SELECT return_date
            FROM rental
            WHERE
                rental_id = 12611
        )
    ) as primer_valor_no_nulo;