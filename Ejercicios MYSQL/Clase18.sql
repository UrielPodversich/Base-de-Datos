-- Active: 1664921352992@@127.0.0.1@3306@sakila

USE sakila;

-- 1- Write a function that returns the amount of copies of a film in a store in sakila-db.
-- Pass either the film id or the film name and the store id.

CREATE FUNCTION AMOUNT(f_id INT, s_id INT
) RETURNS INT DETERMINISTIC 
    BEGIN 
        DECLARE amount INT;
        SELECT
            f.film_id,
            COUNT(i.inventory_id) INTO amount
        FROM film f
            JOIN inventory i ON f.film_id = i.film_id
            JOIN store s ON i.store_id = s.store_id
        WHERE
            f.film_id = f_id
            AND s.store_id = s_id;
        RETURN (amount);
    END;

SELECT GET_AMOUNT(2,2);
-- 2- Write a stored procedure with an output parameter that contains a list of customer first and last 
-- names separated by ";", that live in a certain country. You pass the country it gives you the list of 
-- people living there. USE A CURSOR, do not use any aggregation function (Like CONTCAT_WS.
DROP PROCEDURE IF EXISTS list_customer;

CREATE PROCEDURE list_customers(
    IN c_name VARCHAR(100), OUT list VARCHAR (300)
)
    BEGIN 
        DECLARE finished INT DEFAULT 0;
        DECLARE f_name VARCHAR(250) DEFAULT ''; 
        DECLARE l_name VARCHAR(250) DEFAULT '';
        DECLARE coun VARCHAR(250) DEFAULT '';

        DECLARE listaCursor CURSOR FOR
        SELECT
	    co.country,
	    c.first_name,
	    c.last_name
	    FROM customer c
	    JOIN address a ON c. a.address_id
	    JOIN city c2 ON a.city_id = c2.city_id
	    JOIN country c3 ON c2.country_id = c3.country_id;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN listaCursor;

	looplabel: LOOP
		FETCH listaCursor INTO coun, f_name, l_name;
		IF finished = 1 THEN
			LEAVE looplabel;
		END IF;

		IF coun = c_name THEN
			SET list = CONCAT(f_name,';',l_name);
		END IF;
		
	END LOOP looplabel;
	CLOSE listaCursor;
END;

SET @list = '';
CALL list_procedure('Brasil',@list);
SELECT @list;

-- 3- Review the function inventory_in_stock and the procedure film_in_stock explain the code, write
-- usage examples.

-- INVENTORY_IN_STOCK
/*
CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1) -- Se coloca el nombre de funcion y tipo de dato que quiere que se devuelva
BEGIN
    DECLARE v_rentals INT; -- Declara variable
    DECLARE v_out     INT; -- Declara varible
    SELECT COUNT(*) INTO v_rentals -- Busca cantidad de ventas en rental y lo coloca en una variable.
    FROM rental
    WHERE inventory_id = p_inventory_id;
    IF v_rentals = 0 THEN -- Condicional que devuelve True si la variable anterior es 0
      RETURN TRUE;
    END IF;
    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;
    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
*/

-- Esta funcion buscara el stock que tengas dentro de tu inventario, esta contiene 2 clausulas que la 
-- primera verifica si las v_rental es 0, quiere decir que si las ventas fueron 0 devuelta TRUE.
-- Y la otra que retorne Falso o True dependiendo de si v_out sea mayor a 0 o no.

-- Resumiendo esta funcion controla el stock de inventario y la cantidad de rentals. 
Ej:
SELECT inventory_in_stock(1120);

-- FILM_IN_STOCK
/*
CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);
     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
*/

-- Este procedure tiene 2 clausulas, una busca los inventarios que contiene inventario donde el 
-- film_id el igual al parametro pedido en cuestion, lo mismo con el store_id. Luego llama a la FUNCTION
-- inventory_in_stock pidiendo inventory_id como parametro.
-- Luego la otra clausula busca lo mismo que la anterior nada mas que esta lo convierte todo a cantidad
-- y lo coloca como variable utilizando INTO p_film_count

-- Resumiendo, este procedimiento muestra la cantidad de peliculas que hay en determinada store.

Ej:
set @thing = '';
CALL film_in_stock(4,4,@thing);
SELECT @thing;