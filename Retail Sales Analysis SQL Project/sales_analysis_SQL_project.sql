-- Create Table
CREATE TABLE retail_sales(
    transctions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(35),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT ,
	total_sale FLOAT
);

select * from retail_sales
limit 10;

select count(*) from retail_sales;

--
select * from retail_sales
where transctions_id is NULL;

-- Data Cleaning	
select * from retail_sales
where 
transctions_id is NULL 
or sale_date is null
or sale_time is null
or customer_id is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

--

DELETE FROM retail_sales
where 
transctions_id is NULL 
or sale_date is null
or sale_time is null
or customer_id is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- Data exploaration
-- How many sales we have
select count(*) as total_sales from retail_sales

-- How many unique customer we have 
select  count(distinct(customer_id)) from retail_sales

-- How many unique category we have 
select  count(distinct(category)) from retail_sales

-- From here we are solving bussiness proble
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date ='2022-11-05'

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales 
where 
  category = 'Clothing'
  AND
  quantity >= 4
  AND
  TO_CHAR(sale_date,'YYYY-MM') ='2022-11'

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select 
  category,
  sum(total_sale) as net_sales,
  COUNT(*) as total_orders
from retail_sales
group by category

select * from retail_sales
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age 
from retail_sales
where category ='Beauty'

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(transctions_id) as total_transactions 
 from retail_sales
 group by gender,category
 order by 1 

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select year,month,avg_sale
from
(select 
   Extract(YEAR from sale_date) as year,
   Extract(MONTH from sale_date) as month,
   AVG(total_sale) as avg_sale,
   RANK() OVER(PARTITION BY Extract(YEAR from sale_date) order by AVG(total_sale) DESC) as rank
   from retail_sales
   group by 1,2) as t1
   where rank = 1

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 DESC
limit 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct(customer_id)) as Unique_customer
from retail_sales
group by 1;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
 ( select *,
      CASE 
	     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		 ELSE 'EVENING'
	  END AS Shift
 FROM retail_sales)
 select Shift,count(*) as total_orders
 from hourly_sale
 group by Shift