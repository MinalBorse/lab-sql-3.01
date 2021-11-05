#Activity 1
#Drop column picture from staff.
ALTER TABLE staff DROP picture;

#A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

INSERT INTO customer (customer_id, store_id, first_name,last_name) 
VALUES
('1t5kj6','245.Praha','TAMMY','SANDERS');

#Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
#You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and 
#see what information you would need to add there. You can query those pieces of information. 
#For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

SELECT * FROM rental;

SELECT * FROM film
WHERE title = "Academy Dinosaur";

SELECT * FROM customer
WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER';
SELECT * 
FROM inventory
WHERE film_id = '1';
-- inventory_id =1, Customer_id =130, film_id=1, staff_id=1
INSERT INTO sakila.rental(rental_date, inventory_id, customer_id, staff_id)
VALUES (curdate(), 1, 130, 1);
SELECT *
FROM rental
WHERE customer_id = '130' AND inventory_id ='1';

#Lab | SQL Subqueries 3.03

#How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";


#List all films whose length is longer than the average of all the films.
SELECT AVG (length) FROM film; 
SELECT AVG (length) AS average, SUM(length)/COUNT(length) 
AS sum
FROM film
Group By  film;


#Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));
#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));


#Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT c.first_name, c.last_name, c.email 
FROM customer c
JOIN address a 
ON (c.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT first_name, last_name, count(*) films
FROM actor AS a
JOIN film_actor AS fa USING (actor_id)
GROUP BY actor_id, first_name, last_name
ORDER BY films DESC
LIMIT 1;

#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT customer.customer_id, customer.last_name, customer.first_name,
       customer.email, AVG(payment.amount) "Average Rental",
       max(rental.rental_date) as "Recent Rental Date", 
       max(rental.return_date) as "Recent Return Date"
FROM customer INNER JOIN
     rental
     ON customer.customer_id = rental.customer_id INNER JOIN
     payment
     ON payment.rental_id = rental.rental_id AND
        payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

#actor in most film
SELECT ac.actor_id, count(*) AS total_films_appeared FROM sakila.actor ac
JOIN sakila.film_actor fa
ON ac.actor_id = fa.actor_id
GROUP BY ac.actor_id
order by total_films_appeared desc;

#Customers who spent more than the average payment

SELECT a. customer_id, a.first_name, a.last_name, b.total 
FROM customer a 
INNER JOIN (SELECT customer_id, SUM(amount) 
as total 
FROM payment GROUP BY customer_id 
ORDER BY total desc LIMIT 10) b 
ON a.customer_id=b.customer_id;
