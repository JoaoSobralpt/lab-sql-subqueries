USE sakila;

-- 1-Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
(SELECT COUNT(i.inventory_id)
FROM inventory i
WHERE i.film_id = (SELECT f.film_id FROM sakila.film f WHERE f.title = 'Hunchback Impossible')) AS number_of_copies;

-- 2-List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT film.title, film.length
FROM sakila.film
WHERE film.length > (
SELECT AVG(f.length)
FROM film f
);

-- 3-Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM sakila.actor
WHERE actor.actor_id IN (
SELECT fa.actor_id
FROM sakila.film
JOIN film_actor fa
USING (film_id)
WHERE film.title = 'Alone Trip'
);



-- 4-Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT film.title FROM sakila.film
JOIN sakila.film_category
USING (film_id)
JOIN sakila.category
USING (category_id) 
WHERE category.name IN(
SELECT category.name FROM category c WHERE NAME = 'Family');
-- 5-Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email, co.country
FROM customer c
JOIN address a 
USING(address_id)
JOIN city ci 
USING( city_id)
JOIN country co 
USING(country_id)
WHERE country_id = (
SELECT country_id
FROM country
WHERE country = 'Canada'
);

-- 6-Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films.
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT f.title
FROM sakila.film f
JOIN sakila.film_actor fa 
USING (film_id)
WHERE fa.actor_id = (
SELECT fa.actor_id
FROM sakila.film_actor fa
GROUP BY fa.actor_id
ORDER BY COUNT(*) DESC
LIMIT 1
);


-- 7-Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT f.title
FROM sakila.film f
JOIN sakila.inventory i ON f.film_id = i.film_id
JOIN sakila.rental r ON i.inventory_id = r.inventory_id
JOIN sakila.payment p ON r.rental_id = p.rental_id
WHERE p.customer_id = (
SELECT p.customer_id
FROM sakila.payment p
GROUP BY p.customer_id
ORDER BY SUM(p.amount) DESC
LIMIT 1
)
GROUP BY f.title, p.customer_id
ORDER BY SUM(p.amount) DESC;


-- 8-Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
WHERE customer_id IN (
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
SELECT AVG(total_amount_spent)
FROM (
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
) AS customer_spending
)
)
GROUP BY customer_id
ORDER BY total_amount_spent DESC;

