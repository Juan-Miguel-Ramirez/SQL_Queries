-- 2.Muestra los nombres de todas las películas con una clasificación por edades de ‘R’
select title as film_name, rating as film_rating 
from film
where rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
select actor_id, concat (first_name,' ',last_name) as Actor_Name
from actor
where actor_id between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select title
from film
where language_id = original_language_id;

	-- La consulta 4 no devuelve nada por que todos lo valores de original_language_id son NULL

-- 5. Ordena las películas por duración de forma ascendente.
select title as Filem_Name, length as Film_Duration_In_Minutes
from film
order by film_duration_in_minutes asc;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
select concat(first_name,' ',last_name) as Actor_Name
from actor a 
where last_name = 'ALLEN';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
select rating, count(film_id) as amount_films
from film 
group by rating;

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
select  title, rating, length -- Además del título muestra las otras dos condiciones para ver cual cumple
from film 
where rating = 'PG-13'
or length > 180; 

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select 
	max(replacement_cost) as max_value,
	min(replacement_cost) as min_value,
	max(replacement_cost) - min(replacement_cost) as value_range,
	variance(replacement_cost) as value_variance,
	stddev(replacement_cost) as standard_value_variance
from film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
	-- Película más corta
	select title, length as duration
	from film
	where length = (select MIN(length) from film);
	-- Película más larga
	select title, length as duration
	from film
	where length = (select max(length) from film);

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
	select 
		rental.rental_id,
		rental.rental_date as date, 
		payment.amount
	from rental
	join payment
		on rental.rental_id = payment.rental_id
	order by date desc 
	limit 3;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
select title, rating 
from film
where rating <> 'NC-17' and rating <> 'G';

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
select rating, round(avg(length), 2) as average_duration -- con avg saco la media de duración y con round la redondeo a dos decimales
from film
group by rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select title, length as duration_in_min
from film
where length > 180
order by length desc;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select sum(amount) as total_gains
from payment;

-- 16. Muestra los 10 clientes con mayor valor de id.
select customer_id as id, concat(first_name,' ',last_name) as client
from customer
order by customer_id desc
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select film.title as film, concat(actor.first_name,' ',actor.last_name) as actor_name
from film
join film_actor
	on film.film_id = film_actor.film_id
join actor
	on actor.actor_id = film_actor.actor_id
where film.title = 'EGG IGBY'
-- 18. Selecciona todos los nombres de las películas únicos.
select distinct title
from film
order by title asc;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
select film.title, category.name, film.length
from film
join film_category
	on film.film_id = film_category.film_id
join category
	on film_category.category_id = category.category_id
where category.name = 'Comedy'
and film.length > 180
order by film.title asc;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select category.name as category_name, round(avg(film.length), 2) as average_duration 
from category
join film_category
	on category.category_id = film_category.category_id
join film
	on film_category.film_id = film.film_id
group by category.name
having avg(film.length) > 110
order by average_duration asc;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select avg(return_date - rental_date) as average_rental_duration
from rental;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(first_name,' ', last_name) as actor_name
from actor
order by actor_name asc;

-- 23. Cantidad de alquileres por día, ordenados por cantidad de alquiler de forma descendente.
select  rental_date, count(rental_id) as total_rentals
from rental
group by rental_date
order by total_rentals desc;
	-- en el San Valentin de 2006 debió llover o hacer muy mal tiempo.
-- 24. Encuentra las películas con una duración superior al promedio.
select title, length as duration_in_minutes
from film
where length > (select avg(length) from film); -- establece que la duración de cada película debe ser superior al promedio de la duración de todas las películas

-- 25. Averigua el número de alquileres registrados por mes.
select to_char(rental_date, 'YYYY-MM') AS month,
       count(*) as total_rentals
from rental
group by month
order by month;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select 
	round(avg(amount), 2) as average, 
	round(stddev(amount), 2) as standard_deviation, 
	round(variance(amount), 2) as variance
from payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
select film.title as film_title, payment.amount as rental_price
from film
join inventory
	on film.film_id = inventory.film_id
join rental
	on inventory.inventory_id = rental.inventory_id
join payment
	on rental.rental_id = payment.rental_id
where payment.amount > (select avg(payment.amount) from payment)
order by payment.amount asc;

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select 
	actor.actor_id as actor_id,
	concat(actor.first_name,' ',last_name) as Actor_Name,
	count(film.film_id) as total_films
from actor
join film_actor
	on actor.actor_id = film_actor.actor_id
join film
	on film_actor.film_id = film.film_id
group by actor.actor_id
having count(film.film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select 
	film.title,
	count(inventory.film_id) as total_stock
from film
join inventory
	on film.film_id = inventory.film_id
group by film.title
order by total_stock asc;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
select 
	concat(actor.first_name,' ',actor.last_name) as actor_name,
	count(film_actor.film_id) as total_films
from actor
inner join film_actor
	on actor.actor_id = film_actor.actor_id
group by actor_name
order by total_films desc;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select 
	film.title,
	concat(actor.first_name,' ',actor.last_name) as actor_name
from film
left join film_actor
	on film.film_id = film_actor.film_id
left join actor
	on film_actor.film_id = actor.actor_id;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select 
	concat(actor.first_name,' ',actor.last_name) as actor_name,
	film.title
from actor
left join film_actor
	on actor.actor_id = film_actor.actor_id
left join film
	on film_actor.film_id = film.film_id;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select
	film.film_id,
	film.title as film_title,
	rental.rental_id
from film
full join inventory
	on film.film_id = inventory.film_id
full join rental
	on inventory.inventory_id = rental.inventory_id;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select 
	customer.customer_id,
	concat(customer.first_name,' ',customer.last_name) as customer_name,
	sum(payment.amount) as total_spent
from customer
inner join rental
	on customer.customer_id = rental.customer_id
inner join payment
	on rental.rental_id = payment.rental_id
group by customer.customer_id
order by total_spent desc;

-- 35. Selecciona todos los actores cuyo primer nombre es ' Johnny'.
select concat(first_name,' ',last_name) as actor_name
from actor
where first_name = 'JOHNNY';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select
	first_name as Nombre,
	last_name as Apellido
from actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
	--Actor con el id mas bajo
	select
		min(actor_id) as id,
		concat(first_name,' ',last_name) as actor_name
	from actor
	group by actor_name
	order by id asc
	limit 1;
	--Actor con el id mas alto
	select
		max(actor_id) as id,
		concat(first_name,' ',last_name) as actor_name
	from actor
	group by actor_name
	order by id desc
	limit 1;

-- 38. Cuenta cuántos actores hay en la tabla “actor”
select
	count(actor_id) as amount_actors
from actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select
	concat(first_name,' ',last_name) as actor_name
from actor
order by last_name asc;

-- 40. Selecciona las primeras 5 películas de la tabla “film”
select 
	film_id,
	title
from film
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select 
	first_name as actor_name,
	count(actor_id) as total_actors_with_same_name
from actor
group by actor_name
order by total_actors_with_same_name desc;

-- Los nombres mas repetidos son Kenneth, Penelope y Julia
-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select
	rental.rental_id,
	concat(customer.first_name,' ',customer.last_name) as customer_name
from rental
inner join customer
	on rental.customer_id = customer.customer_id;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select
	rental.rental_id,
	concat(customer.first_name,' ',customer.last_name) as customer_name
from customer
left join rental
	on rental.customer_id = customer.customer_id;

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select 
	concat(actor.first_name,' ',last_name) as actor_name,
	film.title as film,
	category.name
from actor
inner join film_actor
	on actor.actor_id = film_actor.actor_id
inner join film
	on film_actor.film_id = film.film_id
inner join film_category
	on film.film_id = film_category.film_id
inner join category
	on film_category.category_id = category.category_id
where category.name = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.
select 
	concat(first_name,' ', last_name) as actor_name
from actor
left join film_actor
	on actor.actor_id = film_actor.actor_id
left join film
	on film_actor.film_id = film.film_id
where film.film_id is NULL;
-- Todos los actores tienen registrada al menos una participación en una película.

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select 
	concat(first_name,' ', last_name) as actor_name,
	count(film.film_id) as total_films
from actor
left join film_actor
	on actor.actor_id = film_actor.actor_id
left join film
	on film_actor.film_id = film.film_id
group by actor_name
order by total_films desc;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
create view actor_num_peliculas as
select 
	concat(first_name,' ', last_name) as actor_name,
	count(film.film_id) as total_films
from actor
left join film_actor
	on actor.actor_id = film_actor.actor_id
left join film
	on film_actor.film_id = film.film_id
group by actor_name
order by total_films desc;

-- Consulta a la vista "actor_num_peliculas"
select * 
from actor_num_peliculas;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select 
	concat(customer.first_name,' ',customer.last_name) as customer_name,
	count(rental.rental_id) as total_rentals
from customer
inner join rental
	on rental.customer_id = customer.customer_id
group by customer_name
order by total_rentals desc;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select
	category.name as category_name,
	sum(film.length) as total_duration_in_minutes
from film
inner join film_category
	on film.film_id = film_category.film_id
inner join category
	on film_category.category_id = category.category_id
where category.name = 'Action'
group by category_name;

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create temporary table cliente_rentas_temporal as
	select 
	concat(customer.first_name,' ',customer.last_name) as customer_name,
	count(rental.rental_id) as total_rentals
	from customer
	inner join rental
		on rental.customer_id = customer.customer_id
	group by customer_name
	order by total_rentals desc;
-- Consulta a la tabla temporal cliente_rentas_temporal
select *
from cliente_rentas_temporal;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table peliculas_alquiladas as	
	select
		film.title as film_name,
		count(rental.rental_id) as total_rentals
	from film
	inner join inventory
		on film.film_id = inventory.film_id
	inner join rental
		on inventory.inventory_id = rental.inventory_id
	group by film_name
	having count(rental.rental_id) > 10
	order by total_rentals desc;
-- Consulta a la tabla temporal peliculas_alquiladas.
select * 
from peliculas_alquiladas;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
select 
	concat(customer.first_name,' ',customer.last_name) as customer_name,
	film.title,
	rental.rental_date,
	rental.return_date
from film
left join inventory
	on film.film_id = inventory.film_id
left join rental
	on inventory.inventory_id = rental.inventory_id
left join customer
	on rental.customer_id = customer.customer_id
where 
	customer.first_name = 'TAMMY' 
	and customer.last_name = 'SANDERS'
	and rental.return_date is null
order by film.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
select
	concat(actor.first_name,' ',actor.last_name) as actor_name,
	count(category.category_id) as total_sci_fi_fimls
from actor
inner join film_actor
	on actor.actor_id = film_actor.actor_id
inner join film
	on film_actor.film_id = film.film_id
inner join film_category
	on film.film_id = film_category.film_id
inner join category
	on film_category.category_id = category.category_id
where category.name = 'Sci-Fi'
group by actor_name
order by total_sci_fi_fimls;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
-- Este CTE obtiene la fecha en la que se alquiló por primera vez "Spartacus Cheaper"
with first_rental as (
	select 
	min(rental.rental_date) as first_rental_date
	from rental
	inner join inventory
		on rental.inventory_id = inventory.inventory_id
	inner join film
		on inventory.film_id = film.film_id
	where film.title = 'SPARTACUS CHEAPER'
),
-- Este CTE obtiene las fechas de alquiler de las películas
film_rental as (
	select 
		film.title,
		rental.rental_date,
		film.film_id
	from film
	inner join inventory
		on film.film_id = inventory.film_id
	inner join rental
		on inventory.inventory_id = rental.inventory_id
	
)
-- Con este select se obtienen los nombres de los actores de las peliculas alquiladas despues de que se alquilase por primera vez "Spartacus Cheaper", usando los anteriores CTEs para filtrar.
select 
	concat(actor.first_name,' ',actor.last_name) as actor_name,
	film_rental.rental_date
from actor
inner join film_actor
	on actor.actor_id = film_actor.actor_id
inner join film_rental
	on film_actor.film_id = film_rental.film_id
cross join first_rental
where film_rental.rental_date > first_rental.first_rental_date
order by actor.last_name asc;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
-- Este CTE obtiene las peliculas ocn la categoria "Music"
with music_films as (
	select 
		film.film_id,
		film.title,
		category.name
	from film
	inner join film_category
		on film.film_id = film_category.film_id
	inner join category
		on film_category.category_id = category.category_id
	where category.name = 'Music'
)
-- Con este select obtenemos el nombre de los actores que no estan en la categoría "Music", uso distinct para que los nombres no se repitan.
select
	distinct(concat(actor.first_name,' ',actor.last_name)) as actor_name
from actor
inner join film_actor
	on actor.actor_id = film_actor.actor_id
inner join film
	on film_actor.film_id = film.film_id
where film.film_id not in (select film_id from music_films);

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días
select 
	film.title as fiml_title,
	rental.return_date - rental.rental_date as rental_duration
from film
inner join inventory
	on film.film_id = inventory.film_id
inner join rental
	on inventory.inventory_id = rental.inventory_id
where (rental.return_date - rental.rental_date) > interval '8 days'
order by rental_duration asc;	

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’
select
	film.title as film_title,
	category.name as category
from film
inner join film_category
	on film.film_id = film_category.film_id
inner join category
	on film_category.category_id = category.category_id
where category.name = 'Animation'
order by film_title asc;

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
select
	title,
	length
from film
where (select length from film where title = 'DANCING FEVER') = length
order by title asc;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido. 
select
	concat ( customer.first_name,' ',customer.last_name) as customer_name,
	count (distinct inventory.film_id) as total_films_rented
from customer
inner join rental
	on customer.customer_id = rental.customer_id
inner join inventory
	on rental.inventory_id = inventory.inventory_id
group by customer.first_name, customer.last_name
having count (distinct inventory.film_id) >= 7
order by customer.last_name asc;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select
	category.name as category,
	count(rental.rental_id) as total_rents
from category
inner join film_category
	on category.category_id = film_category.category_id
inner join film
	on film_category.film_id = film.film_id
inner join inventory
	on film.film_id = inventory.film_id
inner join rental
	on inventory.inventory_id = rental.inventory_id
group by category
order by total_rents desc;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select
	category.name as category,
	count(film.film_id) as total_2006_releases
from category
inner join film_category
	on category.category_id = film_category.category_id
inner join film
	on film_category.film_id = film.film_id
inner join inventory
	on film.film_id = inventory.film_id
where film.release_year = 2006
group by category.name
order by total_2006_releases desc;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select 
	store.store_id,
	staff.staff_id
from store
cross join staff;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select 
	customer.customer_id,
	concat(customer.first_name,' ',customer.last_name) as customer_name,
	count(inventory.film_id) as total_films_rented
from customer
inner join rental
	on customer.customer_id = rental.customer_id
inner join inventory
	on rental.inventory_id = inventory.inventory_id
group by customer.customer_id, customer_name
order by total_films_rented desc;
