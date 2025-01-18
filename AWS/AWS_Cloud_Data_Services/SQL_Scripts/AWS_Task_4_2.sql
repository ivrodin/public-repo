select 
CONCAT_WS(' ', a.first_name, a.last_name) as actor_full_name, sum(p.amount) as total_sales
from sakila.actor a
inner join sakila.film_actor fa on a.actor_id = fa.actor_id
Inner join sakila.film f on fa.film_id = f.film_id
inner join sakila.inventory i on i.film_id = f.film_id
inner join sakila.store s on i.store_id = s.store_id
inner join sakila.rental r on i.inventory_id = r.inventory_id
inner join sakila.payment p on p.rental_id = r.rental_id
Where s.store_id = 1
Group by a.actor_id
Order by sum(p.amount) desc
Limit 3;