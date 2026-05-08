-- SQL Retail Sales Analysis - P1
create database retail;
use retail;
show tables;
select * from retail;
alter table retail
rename column ï»¿transactions_id to id,
rename column quantiy to quantity;

-- Data Cleaning
select * from retail where id is null ;

select * from retail where sale_date is null;

select * from retail where sale_time is null;

select * from retail where id is null
or sale_date is null or sale_time is null
or gender is null or category is null
or quantity is null or cogs is null
or total_sale is null;
    
-- 
DELETE from retail where id is null
or sale_date is null or sale_time is null
or gender is null or category is null
or quantity is null or cogs is null
or total_sale is null;
    
-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail;

-- How many uniuque customers we have ?
select count(distinct customer_id) as total_sale from retail;

select distinct category from retail;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail where category = 'Clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) as net_sale,
count(*) as total_orders from retail group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select ROUND(AVG(age), 2) as avg_age 
from retail where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (id) made by each gender in each category.

select category, gender, count(*) as total_trans
from retail GROUP BY category, gender order  by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
       year,
       month,
    avg_sale
from 
(    
select 
    EXTRACT(YEAR from sale_date) as year,
    EXTRACT(MONTH from sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) order  by AVG(total_sale) DESC) as rnk
from retail
group by 1, 2
) as t1
where rnk = 1;
    
-- order  by 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(total_sale) as total_sales
from retail group by 1 order by 2 DESC limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category, count(distinct customer_id) as cnt_unique_cs
from retail group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
    case
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
    end as shift
from retail
)
select 
    shift,
    count(*) as total_orders    
from hourly_sale
group by shift;

-- End of project