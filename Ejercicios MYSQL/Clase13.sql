-- Active: 1661259821598@@127.0.0.1@3306@sakila

USE sakila;

/* 
 Actividad 1:
 Add a new customer
 - To store 1
 - For address use an existing address. The one that has the biggest address_id in 'United States'
 */

INSERT INTO
    customer (
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        active
    )
SELECT
    1,
    'Juan',
    'Perez',
    'juanperez@email.com',
    MAX(a.address_id),
    1
FROM address a
WHERE (
        SELECT c.country_id
        FROM country c, city c1
        WHERE
            c.country = "United States"
            AND c.country_id = c1.country_id
            AND c1.city_id = a.city_id
    );

/*
 Actividad 2:
 Add a rental
 - Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
 - Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
 - Select any staff_id from Store 2.
 */

INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        return_date,
        staff_id
    )
SELECT CURRENT_TIMESTAMP, (
        SELECT
            MAX(r.inventory_id)
        FROM inventory r
            INNER JOIN film USING(film_id)
        WHERE
            film.title = "Jurassic Park"
        LIMIT
            1
    ), 300, NULL, (
        SELECT staff_id
        FROM staff
            INNER JOIN store USING(store_id)
        WHERE
            store.store_id = 2
        LIMIT 1
    );

/*
 Actividad 3:
 Update film year based on the rating
 - For example if rating is 'G' release date will be '2001'
 - You can choose the mapping between rating and year.
 - Write as many statements are needed.
 */

UPDATE sakila.film SET release_year='2001' WHERE rating = "G";

UPDATE sakila.film SET release_year='2009' WHERE rating = "R";

UPDATE sakila.film SET release_year='2015' WHERE rating = "PG-13";

UPDATE sakila.film SET release_year='2018' WHERE rating = "NC-17";

/*
 Actividad 4:
 Return a film
 - Write the necessary statements and queries for the following steps.
 - Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
 - Use the id to return the film.
 */

SELECT
    rental_id,
    rental_rate,
    customer_id,
    staff_id
FROM film
    INNER JOIN inventory USING(film_id)
    INNER JOIN rental USING(inventory_id)
WHERE
    rental.return_date IS NULL
LIMIT 1;

UPDATE rental
SET
    return_date = CURRENT_TIMESTAMP
WHERE rental_id = 10597;

/*
 Actividad 5:
 Try to delete a film
 - Check what happens, describe what to do.
 - Write all the necessary delete statements to entirely remove the film from the DB.
 */

DELETE FROM film WHERE title = 'ARABIA DOGMA';
-- Se muestra el siguiente error: 
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE)

-- Esto se debe a que esta relacionada con el metodo cascade, por lo que si se elimina un atributo de esa fila puede a llegar a influir en las demas tablas. 
-- Esto se podria solucionar eliminando los primeros registros que tenga con las otras tablas que no dependan de otras.
-- Como es el caso de payment y rental.  

DELETE FROM payment
WHERE rental_id IN (
        SELECT rental_id
        FROM rental
            INNER JOIN inventory USING (inventory_id)
        WHERE film_id = 1
    );

DELETE FROM rental
WHERE inventory_id IN (
        SELECT inventory_id
        FROM inventory
        WHERE film_id = 1
    );

-- Borramos los lugares donde llegue a estar esa pelicula. 
DELETE FROM inventory WHERE film_id = 1;

DELETE film_actor FROM film_actor WHERE film_id = 1;

DELETE film_category FROM film_category WHERE film_id = 1;

DELETE film FROM film WHERE film_id = 1;

-- Corraboramos si se encuentra en nuestra base de datos. 
SELECT title
FROM film
WHERE film_id = 1;
/*
 Actividad 6:
 Rent a film
 - Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
 - Add a rental entry
 - Add a payment entry
 - Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
 */

SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (
        SELECT inventory_id
        FROM inventory
            INNER JOIN rental USING (inventory_id)
        WHERE
            return_date IS NULL
    )
INSERT INTO
    sakila.rental (
        rental_date,
        inventory_id,
        customer_id,
        staff_id
    )
VALUES (
        CURRENT_DATE(),
        250, (
            SELECT
                customer_id
            FROM customer
            ORDER BY
                customer_id DESC
            LIMIT 1
        ), (
            SELECT staff_id
            FROM staff
            WHERE store_id = (
                    SELECT
                        store_id
                    FROM
                        inventory
                    WHERE
                        inventory_id = 250
                )
        )
    );

INSERT INTO
    sakila.payment (
        customer_id,
        staff_id,
        rental_id,
        amount,
        payment_date
    )
VALUES( (
            SELECT
                customer_id
            FROM customer
            ORDER BY
                customer_id DESC
            LIMIT 1
        ), (
            SELECT staff_id
            FROM staff
            LIMIT 1
        ), (
            SELECT rental_id
            FROM rental
            ORDER BY
                rental_id DESC
            LIMIT 1
        ), (
            SELECT
                rental_rate
            FROM film
            WHERE
                film_id = 2
        ),
        CURRENT_DATE()
    );

/*
 Once you're done. Restore the database data using the populate script from class 3. 
 */