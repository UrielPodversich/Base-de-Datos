-- Active: 1664921352992@@127.0.0.1@3306

USE sakila;
-- 1- Create a user data_analyst
CREATE USER data_analyst IDENTIFIED BY 'password';

-- Este comando muestra todos los usuarios que hay creados junto con el host:
-- SELECT user, host FROM mysql.user;

-- 2- Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
SHOW GRANTS FOR 'data_analyst'@'%';
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'%';

-- 3- Login with this user and try to create a table. Show the result of that operation.
CREATE TABLE test(
    test_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY
);
-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'test'

-- 4- Try to update a title of a film. Write the update script.
SELECT * f.title FROM film f;

UPDATE film SET title = 'Huevo Africano' WHERE film_id = 5;

-- 5- With root or any admin user revoke the UPDATE permission. Write the command
SHOW GRANTS FOR 'data_analyst'@'%';
REVOKE UPDATE ON sakila.* FROM data_analyst;

-- 6- Login again with data_analyst and try again the update done in step 4. Show the result.

UPDATE film SET title = 'Agente Nisman' WHERE film_id = 6;
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'