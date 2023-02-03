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

select top 1 a.State, sum(b.TotalPrice) Price
from DIM_LOCATION a
left join FACT_TRANSACTIONS b
on a.IDLocation = b.IDLocation
left join DIM_MODEL c
on b.IDModel = c.IDModel
left join DIM_MANUFACTURER d
on c.IDManufacturer = d.IDManufacturer
where a.Country = 'US' and d.Manufacturer_Name = 'Samsung'
group by a.State, b.TotalPrice
order by b.TotalPrice desc

--Q3. Show the number of transactions for each model per zip code per state.




 
