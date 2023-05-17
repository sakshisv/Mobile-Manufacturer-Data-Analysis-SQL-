-------- MOBILE MANUFACTURER CASE STUDY --------

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

With cte as (
select top 5 x.Manufacturer_Name from (
select a.Manufacturer_Name, b.Model_Name, sum(c.Quantity)SalesQuantity, avg(c.TotalPrice)AveragePrice,
DENSE_RANK() over (partition by a.Manufacturer_Name order by sum(c.Quantity) desc) as Rank
from DIM_MANUFACTURER a
left join DIM_MODEL b on a.IDManufacturer = b.IDManufacturer
left join FACT_TRANSACTIONS c on b.IDModel = c.IDModel
group by a.Manufacturer_Name, b.Model_Name) x
where rank = 1)

select b.Model_Name, avg(b.Unit_price) Average_Price from DIM_MANUFACTURER a
left join DIM_MODEL b
on a.IDManufacturer = b.IDManufacturer
where b.Model_Name in (select Model_Name from cte)
group by b.Model_Name

--Q6. List the names of the customers and the average amount spent in 2009, where the average is higher than 500.

select a.Customer_Name, avg(b.TotalPrice) Average_Amount, year(b.Date) Year from DIM_CUSTOMER a
left join FACT_TRANSACTIONS b on a.IDCustomer = b.IDCustomer
where year(b.Date) = 2009
group by a.Customer_Name, b.TotalPrice, b.Date
having avg(b.TotalPrice) > 500

--Q7. List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010

select x.Model_Name from (
select top 5 a.Model_Name, sum(b.Quantity) Quantity from DIM_MODEL a
left join FACT_TRANSACTIONS b on a.IDModel = b.IDModel
where year(b.Date) = 2008
group by a.Model_Name
order by 2 desc) x
INTERSECT
select y.Model_Name from (
select top 5 a.Model_Name, sum(b.Quantity) Quantity from DIM_MODEL a
left join FACT_TRANSACTIONS b on a.IDModel = b.IDModel
where year(b.Date) = 2009
group by a.Model_Name
order by 2 desc) y
INTERSECT
select z.Model_Name from (
select top 5 a.Model_Name, sum(b.Quantity) Quantity from DIM_MODEL a
left join FACT_TRANSACTIONS b on a.IDModel = b.IDModel
where year(b.Date) = 2010
group by a.Model_Name
order by 2 desc) z

--Q8. Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.

select Manufacturer_Name, Second_Top_Sales from
(select top 1 Manufacturer_Name, Second_Top_Sales from (
select top 2 a.Manufacturer_Name, sum(c.TotalPrice) Second_Top_Sales from DIM_MANUFACTURER a
left join DIM_MODEL b on a.IDManufacturer = b.IDManufacturer
left join FACT_TRANSACTIONS c on b.IDModel = c.IDModel
left join DIM_DATE d on c.Date = d.DATE
where d.YEAR = 2009
group by a.Manufacturer_Name
order by 2 desc) x
order by 2 asc
UNION
select top 1 Manufacturer_Name, Second_Top_Sales from (
select top 2 a.Manufacturer_Name, sum(c.TotalPrice) Second_Top_Sales from DIM_MANUFACTURER a
left join DIM_MODEL b on a.IDManufacturer = b.IDManufacturer
left join FACT_TRANSACTIONS c on b.IDModel = c.IDModel
left join DIM_DATE d on c.Date = d.DATE
where d.YEAR = 2010
group by a.Manufacturer_Name
order by 2 desc) y
order by 2 asc) z

--Q9. Show the manufacturers that sold cellphone in 2010 but didn’t in 2009.

select a.Manufacturer_Name from DIM_MANUFACTURER a
left join DIM_MODEL b on a.IDManufacturer = b.IDManufacturer
left join FACT_TRANSACTIONS c on b.IDModel = c.IDModel
left join DIM_DATE d on c.Date = d.DATE
where d.YEAR = 2010 and d.YEAR <> 2009
group by a.Manufacturer_Name

--Q10. Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend.

select a.*, round(((lag(a.AvgSpend,1,0) over (order by a.AvgSpend)- a.AvgSpend)/a.AvgSpend)*100,2) [% Change] from
(select top 100 a.Customer_Name, avg(b.TotalPrice)AvgSpend, avg(b.Quantity)AvgQuantity, c.YEAR from DIM_CUSTOMER a
left join FACT_TRANSACTIONS b
on a.IDCustomer = b.IDCustomer
left join DIM_DATE c
on b.Date = c.DATE
where b.Quantity<>0
group by a.Customer_Name, c.YEAR)a
order by 1

--------------------------------------------------------------------------------------------------------------------------------------------
