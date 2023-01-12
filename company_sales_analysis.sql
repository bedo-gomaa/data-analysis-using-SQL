use sales_portfolio 

select *from sales_data

-- find the unique data in our data set 
 select distinct status from sales_data
 select distinct YEAR_ID from sales_data
select distinct PRODUCTLINE from sales_data
 select distinct COUNTRY from sales_data
 select distinct DEALSIZE from sales_data
  select distinct TERRITORY from sales_data

  --analysis 


  --group by sales with productline
  select   PRODUCTLINE , sum(sales) as revenue  from sales_data group by PRODUCTLINE order by 2 desc  -- order by 2 mean order by revenue or sum because it tin the second position 

  -- which year has the largest sales 
    select   YEAR_ID , sum(sales) as revenue  from sales_data group by YEAR_ID order by 2 desc 


	--which size has the largest sales 
select   DEALSIZE, sum(sales) as revenue  from sales_data group by DEALSIZE order by 2 desc 

 -- what was the best month  for sales in a spesific year 

select MONTH_ID , SUM(sales)  as revenue  , count (ORDERLINENUMBER)  as frequncy 
from  sales_data
where YEAR_ID = 2003 -- we can change the year to show the result 
group by MONTH_ID order by 2 desc


 --  november is the best month in most of the years sales  so we have to know wich product they sell 

 select MONTH_ID , PRODUCTLINE, sum (sales)  as revenue  , count(ORDERNUMBER) as frequncy
from  sales_data
where YEAR_ID = 2003 and  MONTH_ID = 11  -- we can change the month  to show the result 
group by MONTH_ID  , PRODUCTLINE
order by 3 desc

 -- who is the best customer  ====>  in this case we will use ( RFM) method   Recency-Frequency-Monetary (RFM) analysis is a indexing technique that uses past purchase behavior to segment customers.
 drop table if exists #rfm ;

 with rfm  as (
 select CUSTOMERNAME, 
 sum(sales)  as monetaryvalue ,
 AVG(sales) as avgmonetaryvalue ,
 count (ORDERLINENUMBER) as frequncy  , 
 max(ORDERDATE) as last_order_date ,
 (select  max (ORDERDATE)   from sales_data )  as  max_order_date,
 DATEDIFF(DD,max(ORDERDATE),(select  max (ORDERDATE)   from sales_data ) ) as recency  ---  ===> this is last_order_date - max_order_date 
 
 from sales_data 
 group by  CUSTOMERNAME),

  rfm_calc as 
 ( select r.* ,
    NTILE (4) over (order by recency ) as rfm_recency,
    NTILE (4) over (order by frequncy ) as rfm_frequncy ,
    NTILE (4) over (order by avgmonetaryvalue ) as rfm_monetary 
from rfm r )

 select c.* , rfm_recency + rfm_frequncy+rfm_monetary as rfm_cell ,
   cast(rfm_recency as varchar)+  cast (rfm_frequncy as varchar)+ cast(rfm_monetary as varchar) as rfm_cell_string
 into #rfm -- save the code in new table called #rfm  witin the select statment 
 from rfm_calc c

 select CUSTOMERNAME ,  rfm_recency , rfm_frequncy ,rfm_monetary
 from #rfm


-- what is best products  most often sold together 

 select   ORDERNUMBER , count(*) as num

 from sales_data where STATUS= 'shipped' group by ORDERNUMBER