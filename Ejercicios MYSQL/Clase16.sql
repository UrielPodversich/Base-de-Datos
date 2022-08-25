USE imdb;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedata DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);


CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
     employeeNumber = OLD.employeeNumber,
        lastname = OLD.lastname,
        changedata = NOW(); 
END

CREATE TRIGGER before_employee_update 
    BEFORE INSERT ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'insert',
     employeeNumber = NEW.employeeNumber,
        lastname = NEW.lastname,
        changedata = NOW(); 
END

SELECT * FROM employees_audit ea;



-- 1- Insert a new employee to , but with an null email. Explain what happens.
INSERT INTO employees
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES(2, 'Perez', 'Juan', 'x6800', NULL, '1', 1203, 'VP Sales');

-- La columna email, no acepta NULL. 
-- SQL Error [1048] [23000]: Column 'email' cannot be null

-- 2- Run the first the query
UPDATE employees SET employeeNumber = employeeNumber - 20;
-- What did happen? Explain. Then run this other
-- Me pregunta si estoy seguro de querer modificarlo, ya que termina modificando a todos los empleados
-- de la tabla y es posible que se pierdan datos. 
UPDATE employees SET employeeNumber = employeeNumber + 20;
-- Explain this case also.
-- Aparece un error que indica que no se puede ejecutar la query por que duplicaria la primary key.
-- SQL Error [1062] [23000]: Duplicate entry '1056' for key 'PRIMARY'

-- 3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
-- ALTER TABLE employees
-- ADD age INT;
-- ALTER TABLE employees 
-- ADD CONSTRAINT CHK_EmployeeAge CHECK (age>=16 AND age<=18);
ALTER TABLE employees
ADD age INT,
ADD CONSTRAINT CHK_EmployeeAge CHECK (age>=16 AND age<=18);

-- 4- Describe the referential integrity between tables film, actor and film_actor in sakila db.
-- La tabla film actor funciona como una tabla intermedia entre la relacion muchos a muchos de film y actor,
-- esta sirve en cierta forma para contener los id de actor y film. 


-- 5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time
-- updated on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective 
-- trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other
-- than root, can connect to MySQL and change this table).
ALTER TABLE employees
	ADD lastUpdate DATETIME;

DELIMITER $$
CREATE TRIGGER before_employees_update
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    SET NEW.lastUpdate=NOW();
END
DELIMITER ;

DELIMITER $$
CREATE TRIGGER before_employees_insert
    BEFORE INSERT ON employees
    FOR EACH ROW 
BEGIN
	SET NEW.lastUpdate=NOW();
END
DELIMITER ;


-- 6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

-- Triggers, este trigger es de DELETE
CREATE DEFINER=`user`@`%` TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
-- Se crea un trigger en la cual se define que cuenta va a tener acceso al momento de la
-- ejecucion del Trigger. El trigger tiene colocado el tiempo despues de que se delete una 
-- fila en la cual un id, va a ser igual a un id viejo o pasado, y se encuentre en al tabla film_text.
 
-- Trigger de UPDATE 
CREATE DEFINER=`user`@`%` TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
-- Este crea su Trigger y al igual que la anterior define el usuario que tendra acceso.
-- Una vez creado el Trigger le coloca una condicion con un if que toma parametos de la tabla y
-- que el viejo atributo sea distinto del nuevo.
-- Si pasa, que actualize la tabla film_text y coloque el nuevo titulo, descripcion, film_id.
-- Donde film_id es igual a el film_id viejo.
  
  
 -- Trigger de INSERT 
 CREATE DEFINER=`user`@`%` TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
  
-- Lo mismo que los anteriores, pero esta vez con  un INSERT. Luego de un INSERT, se inserten
-- los datos que se encuentran dentro de la tabla, con sus paremetros y con los valores nuevos. 