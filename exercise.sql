-- 1. CREATE DATABASE SYNTAX
CREATE DATABASE Exercise;

-- 2. CREATE SCHEMA SYNTAX
CREATE SCHEMA temp;

-- 3."create table name test and test1 (with column id,  first_name, last_name, school, percentage, status (pass or fail),pin, created_date, updated_date)
-- define constraints in it such as Primary Key, Foreign Key, Noit Null...
-- apart from this take default value for some column such as cretaed_date"

CREATE TABLE temp.test(
	id serial PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	school VARCHAR(100) NOT NULL,
	percentage NUMERIC(5,2) NOT NULL,
	status VARCHAR(4) NOT NULL CHECK(status in ('pass','fail')),
	pin INTEGER,
	created_date DATE DEFAULT CURRENT_DATE,
	updated_date DATE DEFAULT CURRENT_DATE 	
);

CREATE TABLE temp.test1
AS SELECT * FROM temp.test;

-- 4.Create film_cast table with film_id,title,first_name and last_name of the actor.. (create table from other table)
CREATE TABLE temp.film_cast
AS
SELECT 
	f.film_id,
	f.title,
	a.first_name,
	a.last_name
FROM
	film f
JOIN
	film_actor fa 
	USING(film_id)
JOIN 
	actor a 
	USING(actor_id);
	
-- Test area
SELECT * FROM temp.film_cast;

SELECT 
	*	
FROM
	film f
JOIN
	film_actor fa 
	USING(film_id)
JOIN 
	actor a 
	USING(actor_id);
	
select distinct film_id from film order by 1;

-- 5. drop table test1
DROP TABLE temp.test1;

-- 6. what is temproray table ? what is the purpose of temp table ? create one temp table 
-- Temporary table are only available for particular session in which it is created.
CREATE TEMP TABLE customers(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	phone BIGINT,
	city VARCHAR(20)
);
SELECT * FROM customers;

-- 7. difference between delete and truncate ? 

-- truncate will free the memory at storage level and only log one entry.
TRUNCATE TABLE temp.test;

-- delete, traverse through the whole table and maintain log of each record deleted.
DELETE FROM temp.test where 1=1;

-- 8. rename test table to student table
ALTER TABLE temp.test 
RENAME TO student;

-- 9. add column in test table named city 
ALTER TABLE temp.student
ADD COLUMN city VARCHAR(40) NOT NULL;

-- 10. change data type of one of the column of test table
ALTER TABLE temp.student
ALTER COLUMN city TYPE VARCHAR(20);

-- 11. drop column pin from test table 
ALTER TABLE temp.student
DROP COLUMN pin;

-- 12. rename column city to location in test table
ALTER TABLE temp.student
RENAME COLUMN city to location;

-- 13. Create a Role with read only rights on the database.
CREATE ROLE role1;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role1;
-- DROPPED user1
-- REASSIGN OWNED BY user1 TO postgres;
-- DROP OWNED BY user1;
-- DROP ROLE user1;

-- 14. Create a role with all the write permission on the database.
-- REASSIGN OWNED BY user2 TO postgres;
-- DROP OWNED BY user2;
-- DROP ROLE user2;

CREATE ROLE role2;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO role2; 
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA temp TO role2; 

-- 15. Create a database user who can only read the data from the database.
REASSIGN OWNED BY user4 TO postgres;
DROP OWNED BY user4;
DROP ROLE user4;

CREATE USER user3 login PASSWORD 'user3';
GRANT role1 TO user3;

-- 16. Create a database user who can read as well as write data into database.
CREATE ROLE user4 login password 'user4';
GRANT role2 to user4;

-- 17. Create an admin role who is not superuser but can create database and  manage roles.
CREATE ROLE admin_role
WITH CREATEDB CREATEROLE;

-- 18. Create user whoes login credentials can last until 1st June 2023
CREATE ROLE user5 
LOGIN 
PASSWORD 'user5'
VALID UNTIL '2023-06-01';

-- 19. List all unique film’s name. 
SELECT DISTINCT(title) FROM film;

-- 20. List top 100 customers details.
SELECT * FROM customer LIMIT 100;

-- 21. List top 10 inventory details starting from the 5th one.
SELECT 
	* 
FROM 
	inventory 
LIMIT 10 
OFFSET 5;
-- SELECT * FROM inventory

-- 22. find the customer's name who paid an amount between 1.99 and 5.99.
SELECT 
	DISTINCT first_name || ' ' || last_name as customer_name 
FROM
	customer
JOIN 
	payment 
	USING(customer_id)
WHERE 
	amount BETWEEN 1.99 AND 5.99;
-- select * from payment;

-- 23. List film's name which is staring from the A.
SELECT 
	title 
FROM 
	film
WHERE 
	title like 'A%';
	
-- 24. List film's name which is end with "a"
SELECT 
	title 
FROM 
	film
WHERE 
	title like '%a';
	
-- 25. List film's name which is start with "M" and ends with "a"
SELECT 
	title 
FROM 
	film
WHERE 
	title like 'M%a';

-- 26. List all customer details which payment amount is greater than 40. (USING EXISTs)
SELECT 
	customer_id, 
	first_name || ' ' || last_name as customer_name
FROM 
	customer c
WHERE 
	EXISTS(
		SELECT 
			1
		FROM 
			payment p 
		WHERE 
			p.customer_id = c.customer_id AND
			amount > 40
			
	);

-- SELECT 
-- 	max(amount)
-- FROM 
-- 	payment;



-- 27. List Staff details order by first_name.
SELECT 
	*
FROM 
	staff
ORDER BY
	first_name;
	
-- 28. List customer's payment details (customer_id,payment_id,first_name,last_name,payment_date)
SELECT 
	c.customer_id,
	payment_id,
	first_name,
	last_name, 
	payment_date
FROM
	customer c
JOIN 
	payment p
	USING(customer_id);

-- 29. Display title and it's actor name.
SELECT 
	title,
	first_name,
	last_name
FROM
	film f
JOIN 
	film_actor fa 
	ON fa.film_id = f.film_id
JOIN 
	actor a 
	ON a.actor_id = fa.actor_id
ORDER BY 
	title;
	
-- 30. List all actor name and find corresponding film id
SELECT 
	first_name,
	last_name,
	f.film_id
FROM
	actor a
LEFT JOIN
	film_actor fa 
	ON fa.actor_id = a.actor_id
LEFT JOIN
	film f
	ON fa.film_id = f.film_id;

-- 31. List all addresses and find corresponding customer's name and phone.
SELECT
	first_name,
	last_name,
	phone,
	address,
	address2,
	district
FROM
	address
LEFT JOIN 
	customer
	USING(address_id);
	
-- 32. Find Customer's payment (include null values if not matched from both tables)(customer_id,payment_id,first_name,last_name,payment_date)
SELECT
	c.customer_id,
	payment_id,
	first_name,
	last_name,
	payment_date
FROM
	customer c
FULL JOIN 
	payment p USING(customer_id);
	
-- 33    List customer's address_id. (Not include duplicate id )
SELECT
	DISTINCT address_id
FROM
	customer;

-- 34    List customer's address_id. (Include duplicate id ) 
SELECT 
	address_id
FROM
	customer;

-- 35    List Individual Customers' Payment total. 
SELECT
	customer_id,
	SUM(amount) as payment_total
FROM
	payment
GROUP BY
	customer_id;

-- 36    List Customer whose payment is greater than 80. 
SELECT 
	customer_id,
	amount
FROM
  	payment
WHERE
	amount > 80;
	
-- 37    Shop owners decided to give  5 extra days to keep  their dvds to all the rentees who rent the movie before June 15th 2005 make according changes in db 
-- SELECT 
-- 	customer_id,
-- 	return_date, 	
-- 	return_date + interval '5 days'
-- FROM
-- 	rental
-- WHERE
-- 	rental_date < '2005-06-15';
UPDATE
	rental
SET
	return_date = return_date + interval '5 days'
WHERE 
	rental_date < '2005-06-15';

-- 38    Remove the records of all the inactive customers from the Database 
-- SELECT
-- 	*
-- FROM
-- 	customer
-- WHERE
-- 	active = 0;
-- (above query returns the number of inactive customers which is equal to 0)
ALTER TABLE payment
   DROP CONSTRAINT payment_customer_id_fkey;
ALTER TABLE payment
   ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;
   
ALTER TABLE rental
   DROP CONSTRAINT rental_customer_id_fkey;
ALTER TABLE rental
   ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;

DELETE FROM customer
WHERE active = 0;

-- 39    count the number of special_features category wise.... total no.of deleted scenes, Trailers etc.... 
SELECT
	c.name, 
	UNNEST(special_features),
	count(*)
FROM
	film f
LEFT JOIN
	film_category fc on fc.film_id = f.film_id
LEFT JOIN
	category c on c.category_id = fc.category_id
GROUP BY 
	c.name, UNNEST(special_features)
ORDER BY c.name;
	

-- 40    count the numbers of records in film table 
SELECT
	COUNT(*)
FROM
	film;
	
-- 41    count the no.of special fetures which have Trailers alone, Trailers and Deleted Scened both etc.... 
SELECT
	special_features,
	count(*)
FROM
	film
GROUP BY 
	special_features;
	
-- 42    use CASE expression with the SUM function to calculate the number of films in each rating: 
SELECT 
	SUM(CASE WHEN rating='NC-17' THEN 1 ELSE 0 END) AS "NC-17",
	SUM(CASE WHEN rating='R' THEN 1 ELSE 0 END) AS "R",
	SUM(CASE WHEN rating='PG-13' THEN 1 ELSE 0 END) AS "PG-13",
	SUM(CASE WHEN rating='PG' THEN 1 ELSE 0 END) AS "PG",
	SUM(CASE WHEN rating='G' THEN 1 ELSE 0 END) AS "G"
FROM
	film;
-- SELECT DISTINCT rating FROM film;

-- 43    Display the discount on each product, if there is no discount on product Return 0 
SELECT 
	product,
	COALESCE(discount,0)
FROM
	items;
	
-- 44    Return title and it's excerpt, if excerpt is empty or null display last 6 letters of respective body from posts table 

SELECT	
	title,
	COALESCE(nullif(excerpt, ''), RIGHT(body,6)) as "excerpt"
FROM
	posts;
	
-- select nullif(excerpt, '') from posts
-- select * from posts;

-- 45    Can we know how many distinct users have rented each genre? if yes, name a category with highest and lowest rented number  .. 
WITH cte_category_rental_user
AS(
	SELECT 
		c.name,
		count(DISTINCT r.customer_id) AS "Distinct customer",
		ROW_NUMBER() OVER(ORDER BY count(DISTINCT r.customer_id) DESC) AS rn
	FROM
		rental r
	JOIN 
		inventory i USING(inventory_id)
	JOIN 
		film_category fg USING(film_id)
	JOIN 
		category c USING(category_id)
	GROUP BY 
		c.name
)
SELECT 
	name,
	rn
FROM 
	cte_category_rental_user
WHERE rn IN (
	SELECT 
		MIN(rn)
	FROM
		cte_category_rental_user
	UNION
	SELECT 
		MAX(rn)
	FROM
		cte_category_rental_user
	)	


-- 46    "Return film_id,title,rental_date and rental_duration
    -- according to rental_rate need to define rental_duration 
    -- such as 
    -- rental rate  = 0.99 --> rental_duration = 3
    -- rental rate  = 2.99 --> rental_duration = 4
    -- rental rate  = 4.99 --> rental_duration = 5
    -- otherwise  6" 
	
SELECT
	f.film_id,
	f.title,
	r.rental_date,
	CASE rental_rate
		WHEN 0.99 THEN 3
		WHEN 2.99 THEN 4
		WHEN 4.99 THEN 5
		ELSE 6
		END "rental_duration"
FROM
	film f
JOIN
	inventory i USING (film_id)
JOIN 
	rental r USING(inventory_id);
	
-- 47    Find customers and their email that have rented movies at priced $9.99. 
SELECT
	customer_id,
	email
FROM
	customer
JOIN 
	payment USING(customer_id)
WHERE
	amount = 9.99;
	
-- 48    Find customers in store #1 that spent less than $2.99 on individual rentals, but have spent a total higher than $5. 

SELECT
	p.customer_id
FROM 
	customer c
JOIN
	payment p ON c.customer_id = p.customer_id	 
WHERE 
	store_id = 1 AND
	amount < 2.99 
GROUP BY 
	p.customer_id
HAVING
	SUM(amount) > 5
ORDER BY
	customer_id;

	
-- SELECT customer_id, sum(amount)
-- FROM
-- 	(SELECT p.customer_id, p.amount
-- 	FROM payment p
-- 	 join 
-- 	-- JOIN store st USING(store_id)
-- 	WHERE store_id = 1) AS x
-- WHERE amount < 2.99
-- GROUP BY customer_id
-- HAVING SUM(amount) > 5
-- ORDER BY customer_id;


-- 49    Select the titles of the movies that have the highest replacement cost. 
WITH cte_max_replacement_cost
AS
(
	SELECT
		title,
		replacement_cost,
		DENSE_RANK() OVER(ORDER BY replacement_cost DESC) AS rn
	FROM
		film
)
SELECT *
FROM cte_max_replacement_cost
WHERE rn = 1
	


-- 50    list the cutomer who have rented maximum time movie and also display the count of that... (we can add limit here too---> list top 5 customer who rented maximum time) 
SELECT
	customer_id,
	film_id,
	count(*)
FROM
	rental
JOIN
	inventory USING(inventory_id)
GROUP BY 
	customer_id,
	film_id
order by 
	count(*) desc
LIMIT 5;

-- 51    Display the max salary for each department
SELECT
	dept_name,
	MAX(salary)
FROM
	employee
GROUP BY 
	dept_name

-- 52    "Display all the details of employee and add one extra column name max_salary (which shows max_salary dept wise) 
    -- /*
    -- emp_id     emp_name   dept_name    salary   max_salary
    -- 120         ""Monica""    ""Admin""        5000     5000
    -- 101         ""Mohan""    ""Admin""        4000     5000
    -- 116         ""Satya""    ""Finance""    6500     6500
    -- 118         ""Tejaswi""    ""Finance""    5500     6500     -- --> like this way if emp is from admin dept then , max salary of admin dept is 5000, then in the max salary column 5000 will be shown for dept admin
    -- */"
SELECT * 
FROM
	(SELECT * FROM employee) t1
JOIN
	(SELECT dept_name,MAX(salary) AS max_salary FROM employee
	GROUP BY dept_name) t2
USING (dept_name)
ORDER BY dept_name;

-- 53    "Assign a number to the all the employee department wise  
    -- such as if admin dept have 8 emp then no. goes from 1 to 8, then if finance have 3 then it goes to 1 to 3    
	-- emp_id   emp_name       dept_name   salary  no_of_emp_dept_wsie
    -- 120        ""Monica""        ""Admin""        5000    1
    -- 101        ""Mohan""            ""Admin""        4000    2
    -- 113        ""Gautham""        ""Admin""        2000    3
    -- 108        ""Maryam""        ""Admin""        4000    4
    -- 113        ""Gautham""        ""Admin""        2000    5
    -- 120        ""Monica""        ""Admin""        5000    6
    -- 101        ""Mohan""            ""Admin""        4000    7
    -- 108        ""Maryam""        ""Admin""        4000    8
    -- 116        ""Satya""              ""Finance""    6500    1
    -- 118        ""Tejaswi""        ""Finance""    5500    2
    -- 104        ""Dorvin""        ""Finance""    6500    3
    -- 106        ""Rajesh""        ""Finance""    5000    4
    -- 104        ""Dorvin""        ""Finance""    6500    5
    -- 118        ""Tejaswi""        ""Finance""    5500    6" 
	
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY dept_name)
FROM 
employee;

-- 54    Fetch the first 2 employees from each department to join the company. (assume that emp_id assign in the order of joining) 
WITH cte_1
AS
(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY emp_id) AS rn
	FROM 
	employee
)
SELECT 
	emp_id,
	emp_name,
	dept_name,
	rn
FROM
	cte_1
WHERE 
	rn < 3;

-- 55    Fetch the top 3 employees in each department earning the max salary.
WITH cte
AS (
	SELECT 
		emp_id,
		emp_name,
		dept_name,
		salary,
		DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary) rn
	FROM employee)

SELECT * FROM cte
WHERE rn < 4;	

-- 56    write a query to display if the salary of an employee is higher, lower or equal to the previous employee.
WITH cte
AS (
	SELECT 
		emp_id,
		emp_name,
		dept_name,
		salary,
		LAG(salary) OVER() prev_salary
	FROM employee)
SELECT 
	*,
	(CASE
		WHEN prev_salary < salary THEN 'Higher'
		WHEN prev_salary > salary THEN 'Lower'
	 	WHEN prev_salary = salary THEN 'Equal'
		ELSE 'NULL'
	END) SAL_HLE
FROM cte;

-- 57    Get all title names those are released on may DATE 
SELECT 
	title
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
WHERE EXTRACT(MONTH FROM return_date) = 5;


-- 58    get all Payments Related Details from Previous week 
SELECT * FROM payment
WHERE EXTRACT(WEEK FROM payment_date) = (
	SELECT EXTRACT(WEEK FROM max(payment_date)) - 2 week_num FROM payment)

-- 59    Get all customer related Information from Previous Year
SELECT * FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = (
	SELECT EXTRACT(YEAR FROM max(payment_date)) - 1 week_num FROM payment);
	
-- 60    What is the number of rentals per month for each store? 
SELECT
	staff_id,
	EXTRACT(MONTH FROM rental_date) "month",
	COUNT(*)
FROM rental
GROUP BY staff_id, EXTRACT(MONTH FROM rental_date)
ORDER BY staff_id, EXTRACT(MONTH FROM rental_date);

-- 61    Replace Title 'Date speed' to 'Data speed' whose Language 'English' 
Update film
SET title = 'Data Speed'
WHERE 
	title = 'Date Speed' AND
	language_id = 1;

SELECT * FROM film
WHERE title = 'Data Speed';

-- 62    Remove Starting Character "A" from Description Of film 
UPDATE film
SET description = RIGHT(description, LENGTH(description)-2)
WHERE description LIKE 'A%';

SELECT * FROM film;

-- 63     if end Of string is 'Italian' then Remove word from Description of Title 
UPDATE film
SET description = overlay(description placing '' from 1 for 1)
WHERE description LIKE '%Italian';

-- 64    Who are the top 5 customers with email details per total sales
SELECT 
	c.customer_id, 
	email,
	SUM(amount)
FROM payment p
JOIN customer c USING(customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC LIMIT 5;

-- 65    Display the movie titles of those movies offered in both stores at the same time. 
SELECT film_id, title, rental_date
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
WHERE staff_id = 1

INTERSECT

SELECT film_id, title, rental_date
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
WHERE staff_id = 2;

-- 66    Display the movies offered for rent in store_id 1 and not offered in store_id 2. 
SELECT title
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
WHERE staff_id = 1

EXCEPT

SELECT title
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
WHERE staff_id = 2;

-- 67    Show the number of movies each actor acted in 
SELECT actor_id, COUNT(*)
FROM film_actor
GROUP BY actor_id
ORDER BY actor_id;

-- 68    Find all customers with at least three payments whose amount is greater than 9 dollars
WITH cte
AS (
	SELECT 
		customer_id
	FROM payment
	WHERE amount > 9
	)

SELECT 
	customer_id
FROM cte
GROUP BY customer_id
HAVING COUNT(*) > 2
ORDER BY customer_id;

-- 69    find out the lastest payment date of each customer 
WITH cte
AS 
	(SELECT 
		customer_id,
	 	payment_date,
		ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY payment_date DESC) lp
	FROM payment)

SELECT 
	customer_id,
	payment_date
FROM cte
WHERE lp = 1;

-- 70    Create a trigger that will delete a customer’s reservation record once the customer’s rents the DVD 
CREATE OR REPLACE FUNCTION del_reservation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$ 

BEGIN
	DELETE FROM reservation r
	WHERE NEW.inventory_id = r.inventory_id AND
	NEW.customer_id = r.customer_id;
	RETURN NULL;
END $$;


CREATE TRIGGER res_del
AFTER INSERT
ON rental
FOR EACH ROW
EXECUTE PROCEDURE del_reservation();

INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES('2022-06-12'::DATE ,12, 1, NOW(), 1);

-- 71    Create a trigger that will help me keep track of all operations performed on the reservation table. I want to record whether an insert, delete or update occurred on the reservation table and store that log in reservation_audit table. 
CREATE OR REPLACE FUNCTION res_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$

BEGIN
	IF TG_OP = 'INSERT' THEN
		INSERT INTO reservation_audit
		VALUES('I', NOW(), NEW.customer_id, NEW.inventory_id, CURRENT_DATE);
		RETURN NULL;
		
	ELSIF TG_OP = 'UPDATE' THEN
		INSERT INTO reservation_audit
		VALUES('U', NOW(), NEW.customer_id, NEW.inventory_id, CURRENT_DATE);
		RETURN NULL;
		
	ELSIF TG_OP = 'DELETE' THEN
		INSERT INTO reservation_audit
		VALUES('D', NOW(), OLD.customer_id, OLD.inventory_id, CURRENT_DATE);
		RETURN NULL;
		
	END IF;
END $$;

CREATE TRIGGER res_log
AFTER INSERT OR UPDATE OR DELETE
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE res_audit();


INSERT INTO reservation(customer_id, inventory_id, reserve_date)
VALUES(7, 14, CURRENT_DATE);

DELETE FROM reservation
WHERE customer_id = 6;

-- 72    Create trigger to prevent a customer for reserving more than 3 DVD’s. 
CREATE OR REPLACE FUNCTION dvd_max()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$ 

BEGIN
	IF (
		SELECT COUNT(customer_id)
	   	FROM reservation
		WHERE NEW.customer_id = reservation.customer_id
		) = 3
	THEN
		RAISE NOTICE 'Customer Can''t Rent More Than 3 DVD''s At a Time';
	ELSE
		RETURN NEW;
	END IF;
END $$;

CREATE TRIGGER max_dvd
BEFORE INSERT
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE dvd_max();

INSERT INTO reservation(customer_id, inventory_id, reserve_date)
VALUES(6, 15, CURRENT_DATE);

-- 73    create a function which takes year as a argument and return the concatenated result of title which contain 'ful' in it and release year like this (title:release_year) --> use cursor in function 
CREATE OR REPLACE FUNCTION get_film_titles(p_year INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
	titles TEXT DEFAULT '';
	rec record;
	cur_films CURSOR(p_year INT)
			FOR SELECT title, release_year
				FROM film
				WHERE release_year = p_year;
BEGIN
	OPEN cur_films(p_year);
	
	LOOP
		FETCH cur_films into rec;
		
		EXIT WHEN NOT FOUND;
		
		IF rec.title ILIKE '%ful%' THEN 
			IF titles != '' THEN
				titles = titles || ', ' || rec.title || ' - ' || rec.release_year;
			ELSE
				titles = rec.title || ' - ' || rec.release_year;
			END IF;
		END IF;
	END LOOP;
	
	CLOSE cur_films;
	
	RETURN titles;
END $$;

SELECT get_film_titles(2006) AS films;

-- 74    Find top 10 shortest movies using for loop 
DO
$$
DECLARE
    f record;
BEGIN
    FOR f IN SELECT title, length 
	       FROM film 
	       ORDER BY length
	       LIMIT 10 
    LOOP
	RAISE NOTICE '% - % mins', f.title, f.length;
    END LOOP;
END $$;

-- 75    Write a function using for loop to derive value of 6th field in fibonacci series (fibonacci starts like this --> 1,1,.....)	
CREATE OR REPLACE FUNCTION fibonaci(n integer)
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE
	a INT = 0;
	b INT = 1;
	temp INT;
	n INT = n;
	i INT;
BEGIN
	FOR i IN 2..n
	LOOP
		temp:= a + b;
		a := b;
		b := temp;
	END LOOP;
	RETURN b;
END $$;
 
SELECT fibonaci(6);

	
	