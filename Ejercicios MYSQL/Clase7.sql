USE sakila;
-- Find the films with less duration, show the title and rating.
SELECT
	title,
	rating
FROM
	film f
WHERE
	`length` <= ALL (
	SELECT
		`length`
	FROM
		film f2);
	
-- Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
SELECT
	f2.title,
	f2.`length`
FROM
	film f2
WHERE
	f2.`length` < ALL(
	SELECT
		MIN(`length`)
	FROM
		film f);

-- Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.

-- option result with ALL
SELECT
	first_name,
	last_name,
	(
	SELECT
		DISTINCT amount
	FROM
		payment p
	WHERE
		c.customer_id = p.customer_id
		AND p.amount <= ALL (
		SELECT
			p2.amount
		FROM
			payment p2
		WHERE
			c.customer_id = p2.customer_id)) AS min_amount,
	(
	SELECT
		a.address
	FROM
		address a
	WHERE
		c.customer_id = a.address_id) AS address
FROM
	customer c;
-- option result with ANY
SELECT
	first_name,
	last_name,
	(
	SELECT
		DISTINCT amount
	FROM
		payment p
	WHERE
		c.customer_id = p.customer_id
		AND p.amount <= ANY (
		SELECT
			p2.amount
		FROM
			payment p2
		WHERE
			c.customer_id = p2.customer_id)) AS min_amount,
	(
	SELECT
		a.address
	FROM
		address a
	WHERE
		c.customer_id = a.address_id) AS address
FROM
	customer c;
-- option result with MIN
SELECT
	c.first_name,
	c.last_name,
	(
	SELECT
		MIN(p.amount)
	FROM
		payment p
	WHERE
		c.customer_id = p.customer_id) AS min_amount,
	(
	SELECT
		a.address
	FROM
		address a
	WHERE
		c.customer_id = a.address_id) AS address
FROM
	customer c;


-- Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
SELECT
	c.first_name,
	c.last_name,
	(
	SELECT
		MAX(amount)
	FROM
		payment p
	WHERE
		c.customer_id = p.customer_id) AS max_amount,
	(
	SELECT
		MIN(amount)
	FROM
		payment p2
	WHERE
		c.customer_id = p2.customer_id) AS min_amount
FROM
	customer c;


