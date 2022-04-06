CREATE DATABASE imdb;

USE imdb;

CREATE TABLE film (
film_id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(30),
descripcion VARCHAR(30),
release_year DATE
);

CREATE TABLE actor (
actor_id INT PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(30),
last_name VARCHAR(30) 
);

CREATE TABLE film_actor (
film_actor_id INT PRIMARY KEY AUTO_INCREMENT,
actor_id INT,
film_id INT
);

ALTER TABLE film ADD last_update DATE;

ALTER TABLE actor ADD last_update DATE;

ALTER TABLE film_actor ADD FOREIGN KEY (film_id) REFERENCES film(film_id);

ALTER TABLE film_actor ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id);
