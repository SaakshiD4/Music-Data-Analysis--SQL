-- senior most employee based on job title
select * from employee;


select employee_id,last_name,first_name,levels
from employee
order by levels desc
limit 1;

 --  Which countries have the most Invoices? 

 select* from invoice;

 select billing_country , count(invoice_id) as no_of_invoice
 from invoice
 group by billing_country
 order by count(invoice_id) desc;


  -- What are top 3 values of total invoice? 
select * from 
invoice 
order by total desc
limit 3;

--  Top 3 invoices in each city based on total.
SELECT *
FROM (
    SELECT *,
           row_number() OVER (partition by billing_city ORDER BY total DESC) as rn
    FROM invoice
) sub
WHERE rn <= 3;


-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals 

select billing_city ,sum(total) as total_inovoice
from invoice
group by billing_city
order by total_inovoice  desc
limit  1;


/*  Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select*from customer;

select*from invoice;

select i.customer_id,sum(total) as total_spent,c.first_name
from invoice i 
join customer c on
c.customer_id=i.customer_id
group by i.customer_id,c.first_name
order by sum(total) desc
limit 1;


-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A. 

select*from genre;
select*from customer;
 select*from album;
select*from invoice_line;
select*from artist;
select*from track;
select*From invoice;

select email,first_name,last_name,genre.name
from
invoice join
invoice_line on invoice.invoice_id=invoice.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on invoice_line.track_id=track.track_id
join genre on genre.genre_id=track.genre_id
where genre.name like '%Rock%'
order by email ;

/* Let's invite the artists who have written 
the most rock music in our dataset. 
Write a query that returns the Artist
name and total track count of the top 10 rock 
bands. */
select*from artist;
select*from track;
select * from genre;

select artist_id,count()


select artist.name,artist.artist_id,
count(artist.artist_id) as total_track
from track join genre
on track.genre_id=genre.genre_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id

where genre.name like '%Rock%'
group by artist.name,artist.artist_id
order by total_track desc
limit 10;

/*  Return all the track names that have a 
song length longer than the average song length. 
Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs
listed first. */

select*from track;

select name, milliseconds from track where milliseconds
> (select avg(milliseconds)
    from track)
	order by milliseconds desc;


 -- Find how much amount spent by each customer on artists? 


select c.customer_id,ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) as total_spent,art.name
from customer c join invoice i on
c.customer_id=i.customer_id join
invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album a on a.album_id=t.album_id
join artist art on art.artist_id= a.artist_id
group by c.customer_id ,art.name
order by total_spent desc;

-- Finds total spent by each customer on only the top artist

SELECT c.customer_id,
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_spent,
       art.name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album a ON a.album_id = t.album_id
JOIN artist art ON art.artist_id = a.artist_id
GROUP BY c.customer_id, art.name
ORDER BY total_spent DESC;

-- * We want to find out the most
-- popular music Genre for each country

with popular_genre as
(select c.country ,g.name ,count(il.Quantity) as total_genre,
row_number() over (partition by c.country order by count(il.Quantity) Desc ) as rn
from invoice_line il join track t on
il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
join invoice i on i.invoice_id=il.invoice_id
join customer c on c.customer_id=i.customer_id
group by 1,2 
order by total_genre desc)

select * from popular_genre where rn=1;


-- Write a query that determines the customer
-- that has spent the most 
-- on music for each country. 
-- Write a query that returns the country
-- along with the top customer and how much they spent.


with top_customer as
(select c.customer_id,c.first_name,c.country,count(il.unit_price*il.quantity) as total_spent,
row_number() over(partition by c.country order by count(unit_price*quantity) ) as rn
from customer c join invoice i on
c.customer_id =i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
group by c.customer_id,c.country,c.first_name
order by total_spent desc)

select * from top_customer where rn<=1;















 