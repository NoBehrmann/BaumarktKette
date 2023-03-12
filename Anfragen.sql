-- Thema:
-- Projektion
--

-- Aufgabe:
-- Ermittle Vor- und Nachnamen sowie die E-Mail-Adressen aller Kunden (<i>customer</i>).

Select first_name, last_name, email from customer;

-- ------------
-- Aufgabe:
-- Zeige alle Distrikte zu gespeicherten Adressen (<i>address</i>). Eliminiere dabei Duplikate.

select distinct district from address;

-- ------------
-- Aufgabe:
-- Ermittle zu allen Zahlungen (<i>payment</i>) die Kunden-Id, die gezahlte Menge und finde heraus, vor wie vielen Tagen gezahlt wurde.

select customer_id, amount, datediff(curdate(), payment_date) from payment;

-- ------------
-- Aufgabe:
-- Gebe zu allen Filmen (<i>film</i>) den Titel und die ersten 10 Zeichen der Beschreibung, gefolgt von "etc." an. Gebe der Spalte den Titel "Kurzbeschreibung".

select title, concat(substring(description, 1,10), " etc.") as Kurzbeschreibung from film;

-- ------------
-- ------------------------------------
-- Thema:
-- Selektion
--

-- Aufgabe:
-- Ermittle alle Adressdaten aus dem Distrikt "Ohio".

select * from address 
where district like "Ohio";

-- ------------
-- Aufgabe:
-- Zeige alle Filme, die länger als 2 Stunden dauern.

select *from film 
where length > 120;

-- ------------
-- Aufgabe:
-- Finde alle Filme ohne Altersfreigabe (Rating G) mit "Deleted Scenes" als Special Feature.

select * from film 
where rating like "g" 
and special_features like "%deleted scenes%";

-- ------------
-- Aufgabe:
-- Zeige alle Zahlungseinträge (<i>payment</i>), bei denen die Kunden zwischen 10 EUR und 15 EUR gezahlt haben.

select * from payment 
where amount >= 10 
and amount <= 15;

-- ------------
-- Aufgabe:
-- Finde die Zahlungen, bei denen mehr als 11,50 EUR im Monat August gezahlt worden ist.

select * from payment 
where amount >11.5 
and month(payment_date) = 8;

-- ------------
-- Aufgabe:
-- Ermittle alle Adressen, bei denen der Distrikt ähnlich wie "Chicago" klingt.

select * from address 
where district sounds like "chicago";

-- ------------
-- ------------------------------------
-- Thema:
-- Projektion und Selektion
--

-- Aufgabe:
-- Zeige die Titel der Filme, die das Wort "Hollywood" im Namen haben und für die weniger als 1 EUR bei der Ausleihe auszugeben sind.

select title from film 
where title like "%hollywood%" 
and rental_rate < 1;

-- ------------
-- Aufgabe:
-- Ermittle die Vor- und Nachnamen aller Schauspieler, die Ray, Rip, Tim oder Tom mit Vornamen heißen.

select first_name, last_name from actor 
where first_name in ("ray","rip","tim","tom");

-- ------------
-- Aufgabe:
-- Gebe Adressdaten aller Distrikte, die mit dem Buchstaben Y beginnen in der Form "address (district)" aus.

Select  concat(address, " (", district, ")") from address 
where district like "y%";

-- ------------
-- Aufgabe:
-- Zeige Titel, Länge und Rating aller Filme, in denen es um Datenbankadministratoren (Database Administrator) und verrückte Wissenschaftler (Mad Scientist) geht.

select title, length, rating from film 
where description like "%database administrator%" 
and description like "%mad scientist%";

-- ------------
-- Aufgabe:
-- Finde alle Filmtitel, die nur die Vokale I <ins>und</ins> U enthalten.

select title from film 
where title not like "%a%" 
and title not like "%e%" 
and title not like "%o%" 
and title like "%i%" 
and title like "%u%";

-- ------------
-- Aufgabe:
-- Gebe die Namen aller Schauspieler, deren Nachname auf "son" endet, in der Form "V. Nachname" (V = 1. Buchstabe des Vornamens) an.

select concat(substring(first_name,1,1), ". ", last_name) from actor 
where last_name like "%son";

-- ------------
-- Aufgabe:
-- Ermittle die Kunden-Id und den Nachnamen aller inaktiven Kunden und die Läden (<i>store_id</i>), in denen sie Kunde waren, wobei die Region des Ladens wie folgt auszugeben ist: Store-Id 1 ist "Nord",Store-Id 2 ist "Süd", andere Werte sind „Unbekannt".

select customer_id, last_name,
case 
when store_id = 1 then "Nord"
when store_id = 2 then "Süd"
else "Unbekannt"
end as store_id
from customer where active = false;

-- ------------
-- Aufgabe:
-- Ermittle den prozentualen Anteil der Ausleihkosten an den Wiederbeschaffungskosten von "Charakterstudien"-Filmen. Runde die Prozente auf 2 Nachkommastellen.

select concat(round(rental_rate /replacement_cost,2)) as anteil from film 
where description like "%Character Study%";

-- ------------
-- ------------------------------------
-- Thema:
-- Verbund-Operationen (Joins)
--

-- Aufgabe:
-- Ermittle die vollständigen Adressdaten (inkl. Stadt, Distrikt, Land) der Kunden.

Select country_id, city_id, address_id, customer.*, address.*, city.*, country.* from customer 
join address using (address_id) 
join city using (city_id) 
join country using (country_id) 
order by country.country_id asc;

-- ------------
-- Aufgabe:
-- Was kosten die einzelnen Action-Filme in der Ausleihe?

select title, rental_rate from film 
join film_category using (film_id)
join category using (category_id) 
where category.name like "action";

-- ------------
-- Aufgabe:
-- Zeige Filmtitel und die Nachnamen der Schauspieler aller Filme mit einer maximalen Länge von 60 Minuten – sortiert nach Filmtitel.

select title, last_name from film 
join film_actor using (film_id) 
join actor using (actor_id) 
where length <= 60 
order by title asc;

-- ------------
-- Aufgabe:
-- Ermittle Titel und Beschreibung aller Kinderfilme, die kurioserweise nicht für Kinder geeignet sind (Rating NC-17).

select title, description from film 
join film_category using (film_id) 
join category using (category_id) 
where category.name like "children" and rating like "nc-17";

-- ------------
-- Aufgabe:
-- Welche Filme hat Beatrice Arnold im August nach 20 Uhr ausgeliehen?

select title from film join inventory using (film_id) 
join rental using (inventory_id)
 join customer using (customer_id) 
where first_name like "Beatrice" 
and last_name like "arnold" 
and month(rental_date) = 8 
and hour(rental_date) >= 20;

-- ------------
-- Aufgabe:
-- Erzeuge eine Liste neuer E-Mail-Adressen für alle Kanadier im Format „vorname.nachname@stadt.com“. Leerzeichen im Stadtnamen sind durch einen Bindestrich zu ersetzen.

select concat(first_name,".",last_name,"@",replace(city," ","-"),".com") as email from customer 
join address using (address_id)
join city using (city_id) 
join country using (country_id) where country like "canada";

-- ------------
-- Aufgabe:
-- Welche Kunden haben Filmtitel mit erstem Buchstaben A ausgeliehen, in denen Schauspieler mitspielen, die den gleichen Vornamen wie der Kunde haben? Es sollen der Filmtitel sowie Vor- und Nachname des Kunden (in einer Spalte zusammengefasst) und des Schauspielers (ebenso) ausgegeben werden.

select title, concat(c.first_name, " ", c.last_name) as customer, concat(a.first_name, " ", a.last_name) as actor from film 
join film_actor using (film_id) 
join actor a using (actor_id) 
join inventory using (film_id) 
join rental using (inventory_id) 
join customer c using (customer_id) 
where title like "a%" 
and a.first_name like c.first_name
group by title, customer, actor;

-- ------------
-- Aufgabe:
-- Welche Schauspieler haben in Filmen mitgespielt, die China oder Indien (India) im Titel haben und in China oder Indien spielen?

select first_name, last_name, title, description from actor 
join film_actor using (actor_id) 
join film using (film_id) 
where (title like "%china%" 
or title like"%india%") 
and (description like "%china%" 
or description like "%india%");

-- ------------
-- ------------------------------------
-- Thema:
-- Gruppierung und Aggregation
--

-- Aufgabe:
-- Ermittle die Summe aller Zahlungen (<i>payment</i>) und das Datum der letzten Zahlung pro Kunde.

select c.customer_id, sum(amount), max(p.payment_date)
from payment p 
join customer c 
on p.customer_id = c.customer_id
group by c.customer_id;

-- ------------
-- Aufgabe:
-- Ermittle die Gesamtausgaben deutscher Kunden für Ausleihen im 2. Quartal 2005.

select sum(amount) from payment 
join customer using (customer_id)
join address using (address_id)
join city using (city_id)
join country using (country_id)
where country like "germany"
and year(payment_date) = 2005
and month(payment_date) in (4,5,6);

-- ------------
-- Aufgabe:
-- Zeige die Umsätze pro Mitarbeiter (<i>staff</i>) und Jahr.

select staff_id, year(payment_date) as year, sum(amount) from payment 
join staff using (staff_id)
group by staff_id, year
order by staff_id, year;

-- ------------
-- Aufgabe:
-- Ermittle die Anzahl der Ausleihen, die Anzahl der Kunden und die mittlere Anzahl an Ausleihen je Kunde pro Land – absteigend sortiert nach der Anzahl der Kunden, nachrangig sortiert nach dem Land.

select count(distinct customer_id) as customerCount, count(rental_id) as rentalCount, count(distinct customer_id) / count(rental_id) as avg, country from customer
join rental using (customer_id)
join address using (address_id)
join city using (city_id)
join country using (country_id)
group by country
order by customerCount desc, country desc;

-- ------------
-- Aufgabe:
-- Ermittle die Top 15 der ausgeliehenen Filme – absteigend sortiert nach Ausleihen, nachrangig nach Filmtitel.

select title, count(rental_id) as ausleihe from film
join inventory using (film_id)
join rental using (inventory_id)
group by title
order by ausleihe desc, title asc
limit 15;

-- ------------
-- Aufgabe:
-- Zeige Minimum und Maximum für Filmersatzkosten pro Kategorie.

select name, min(replacement_cost), max(replacement_cost) from film
join film_category using (film_id)
join category using (category_id)
group by category_id;

-- ------------
-- Aufgabe:
-- Welche Horror-Filme wurden mehr als 20x ausgeliehen?

select title, count(title) as anzahl from film
join film_category using (film_id)
join category using (category_id)
join inventory using (film_id)
join rental using (inventory_id)
where name like "horror"
group by film_id
having anzahl > 20
order by title asc;

-- ------------
-- ------------------------------------
-- Thema:
-- Mengen-Operationen und Unterabfragen (Subselects)
--

-- Aufgabe:
-- Ermittle, ob es Schauspieler gleichen Vornamens gibt, die im selben Film mitgespielt haben. Das Ergebnis soll zunächst nach Filmtitel, dann nach Vorname und Nachname sortiert werden. Es sollen nur Filmtitel mit weniger als 12 Zeichen ausgegeben werden.

select f.title, a.first_name, a.last_name 
from film f
join film_actor using (film_id)
join actor a using (actor_id)
join (select title , first_name from film
	join film_actor using (film_id)
	join actor using (actor_id)
	group by title, first_name
	having count(title) > 1
	and count(first_name) > 1
	and length(title) < 12) as dupe        
where a.first_name like dupe.first_name
and f.title like dupe.title
order by title, first_name, last_name;

-- ------------
-- Aufgabe:
-- Welche deutschen Kunden haben die gleichen Filme ausgeliehen wie Kunden aus Frankreich?

select g.first_name, f.first_name from
(select first_name, film.title from film
 join inventory using (film_id)
 join rental using (inventory_id)
 join customer using (customer_id)
 join address using (address_id)
 join city using (city_id)
 join country using (country_id)
where country like "germany") as g
join
(select first_name, film.title from film
 join inventory using (film_id)
 join rental using (inventory_id)
 join customer using (customer_id)
 join address using (address_id)
 join city using (city_id)
 join country using (country_id)
where country like "france") as f
where g.title like f.title
group by g.first_name
order by g.title asc;

-- ------------
-- Aufgabe:
-- Zeige alle Filme (Id und Beschreibung), in denen das Thema 'MySQL' eine Rolle spielt sowie, falls vorhanden, Kunden aus Japan, die diese Filme ausgeliehen haben. Die japanischen Kunden sollen komma-separiert und nach Nachname sortiert in einer Spalte ausgegeben werden.

select film_id, description, 
group_concat(case when country like "japan"  
then concat(first_name, " ", last_name) 
else null end
order by last_name asc 
separator "," ) 
from film
join inventory using (film_id)
join rental using (inventory_id)
join customer using (customer_id)
join address using (address_id)
join city using (city_id)
join country using (country_id)
where description like "%mysql%"
group by film_id;

-- ------------
-- Aufgabe:
-- Welcher Film wurde noch nie ausgeliehen?

select title from film
where film_id not in (
select film_id from rental
join inventory using (inventory_id)
group by film_id);

-- ------------
-- Aufgabe:
-- Ermittle, welcher Kunde in 2005 zuletzt etwas ausgeliehen hat (Vor- und Nachname, Ausleihdatum).

select first_name, last_name, max(rental_date) as date from customer
join rental using (customer_id)
where year(rental_date) = 2005
group by customer_id
order by date desc
limit 1;

-- ------------
-- Aufgabe:
-- Ermittle, welcher Film pro Kategorie am häufigsten ausgeliehen wurde – sortiert nach Kategorie und Filmtitel.

select title, max(count), name from

(select title, count(title) as count, name from film
join inventory using (film_id)
join rental using (inventory_id)
join film_category using (film_id)
join category using (category_id)
group by film_id
order by count desc) as counts
group by name;

-- ------------
-- Aufgabe:
-- Ermittle, welche Kunden aus Kanada weder Action-Filme noch Komödien ausgeliehen haben. 

select first_name, last_name from customer c
join address using (address_id)
join city using (city_id)
join country using (country_id)
where country like "Canada"
and customer_id not in 
(select distinct customer_id from rental
join inventory using (inventory_id)
join film_category using (film_id)
join category using (category_id)
where name in ("comedy", "action"));

-- ------------
-- ------------------------------------
-- Thema:
-- Einfügen, Ändern und Löschen von Datensätzen
--

-- Aufgabe:
-- Füge den Schauspieler (<i>actor</i>) Harrison Fjord ein.

insert into actor (first_name, last_name)
values ("Harrison", "Fjord");

-- ------------
-- Aufgabe:
-- Füge die deutschen Städte Kiel, Lübeck und Flensburg in einer Anweisung ein.

insert into city (city, country_id)
values ("Kiel", 38),
	("Lübeck", 38),
        ("Flensburg", 38);

-- ------------
-- Aufgabe:
-- Füge alle Kunden, die mit Vornamen Jamie oder Tracy heißen, in den Bestand der Schauspieler ein.

insert into actor (first_name, last_name)
select first_name, last_name from customer
where first_name in ("Jamie", "Tracy");

-- ------------
-- Aufgabe:
-- Ändere den Vornamen aller Schauspieler mit den Nachnamen Grant und Jackman auf Hugh.

update actor
set first_name = "Hugh"
where last_name in ("Grant", "Jackman");

-- ------------
-- Aufgabe:
-- Der Mitarbeiter Jon Stephens hat nach seiner Eheschließung seinen Nachnamen in Meyer geändert. Aktualisiere Nachname und E-Mail-Adresse des Mitarbeiters.

update staff
set last_name = "Meyer",
email = concat(first_name, ".", last_name, "@sakilastaff.com")
where staff_id = (select staff_id from staff
where first_name like "Jon" 
and last_name like "Stephens");

-- ------------
-- Aufgabe:
-- Lösche alle Städte außer Kiel, Lübeck und Hamburg, die in keiner Adresse referenziert werden.

delete from city
where city_id not in
(select city_id from address
join city using (city_id)
where city not in ("Kiel", "Lübeck", "Hamburg"));

-- ------------
-- ------------------------------------
-- Download 08.11.2022 10:48:42 SQL-Learning Lounge v2.0.1
-- User: Bin Bin Maico Wu, Gruppe: INF1_Gruppe02; Termin A
-- 