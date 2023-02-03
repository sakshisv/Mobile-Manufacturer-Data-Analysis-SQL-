use MOBILE_MANUFACTURER

select * from DIM_CUSTOMER
select * from DIM_DATE
select * from DIM_LOCATION
select * from DIM_MANUFACTURER
select * from DIM_MODEL
select * from FACT_TRANSACTIONS


--Q1. List all the states in which we have customers who have bought cellphones from 2005 till today.

select distinct a.State
from DIM_LOCATION a
left join FACT_TRANSACTIONS b
on a.IDLocation = b.IDLocation
where year(b.Date)>= 2005

--Q2. What state in the US is buying more 'Samsung' cell phones?

select top 1 a.State, count(*) Cell_Phones_Count from DIM_LOCATION a
left join FACT_TRANSACTIONS b on a.IDLocation = b.IDLocation
left join DIM_MODEL c on b.IDModel = c.IDModel
left join DIM_MANUFACTURER d on c.IDManufacturer = d.IDManufacturer
where a.Country = 'US' and d.Manufacturer_Name = 'Samsung'
group by a.State, b.TotalPrice
order by 2 desc

--Q3. Show the number of transactions for each model per zip code per state.

select c.Model_Name, count(*) No_of_Transaction, a.ZipCode, a.State
from DIM_LOCATION a
left join FACT_TRANSACTIONS b on a.IDLocation = b.IDLocation
left join DIM_MODEL c on b.IDModel = c.IDModel
group by  c.Model_Name, a.ZipCode, a.State


--Q4. Show the cheapest cellphone.
 
select top 1 Model_Name, Unit_price
from DIM_MODEL
order by Unit_price asc

--Q5. Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.

select * from DIM_MANUFACTURER
select * from DIM_MODEL
select * from FACT_TRANSACTIONS

select o.Manufacturer_Name, q.Model_Name, avg(r.TotalPrice) Average_Price from
(select top 5 c.Manufacturer_Name, sum(a.Quantity) Quantity
from FACT_TRANSACTIONS a
left join DIM_MODEL b on a.IDModel = b.IDModel
left join DIM_MANUFACTURER c on b.IDManufacturer = c.IDManufacturer
group by c.Manufacturer_Name, a.Quantity
order by Quantity desc) o
left join DIM_MANUFACTURER p
on o.Manufacturer_Name = p.Manufacturer_Name
left join DIM_MODEL q on p.IDManufacturer = q.IDManufacturer
left join FACT_TRANSACTIONS r on q.IDModel = r.IDModel
group by o.Manufacturer_Name, q.Model_Name, r.TotalPrice
order by Average_Price

