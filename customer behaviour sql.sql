use mohan;
show databases;
select * from customer limit 20;

#Q1.what is the total revenue generate by male vs female customer
select gender,sum(purchase_amount) as revenue from customer group by gender;

#Q2. which customer used a discount but still spent more than the average purchase amount
select customer_id,purchase_amount from customer where discount_applied="Yes"
and purchase_amount >= (select AVG(purchase_amount) from customer);

#Q3.Which are the top 5 product with the highest average review rating
select item_purchased,round(avg(review_rating),2)as "Average Product Rating" from
customer group by item_purchased order by avg(review_rating)desc limit 5;

#Q4. Compare the average Purched Amount between Standard and Express Shipping
select shipping_type,round(avg(purchase_amount),2)from customer where
 shipping_type in('Standard','Express')
group by shipping_type;

#Q5.Do subcribed customer spend more? compare average spend and total revenue 
#between subscribers and non--subscribers.alter
select subscription_status,count(customer_id)as total_customer, round(avg(purchase_amount),2)
as avg_spend, round(sum(purchase_amount),2)as total_revenue from customer
group by subscription_status
order by total_revenue,avg_spend desc;

#Q6. which 5 product have the highest percentage of purchase with discount applied

select item_purchased,round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2)
as discount_rate from customer group by item_purchased order by discount_rate desc limit 5;

#Q7.segment customer into new,returning, and loyal based on their total
#number of previous purchase, and show the count of each segment
with customer_type as(select customer_id,previous_purchases,case 
when previous_purchases between 2 and 10 then 'returning'
else 'loyal' end as customer_segment from customer)
select customer_segment,count(*) as "number of customer" from customer_type
group by customer_segment 

#Q8.what are the top 3 most purchased product within each category?

with item_counts as (select category, item_purchased, count(customer_id)as total_orders
row_number() over(partition by category order by count(customer_id)desc) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders from item_counts where item_rank<=3

#q9.are customer who are repeat buyers(more than 5 previous purchase) also
#likely to subcribe
select subscription_status,count(customer_id)as repeat_buyers from customer 
where previous_purchases>5
group by subscription_status

#Q10.what is the revenue contribution of each age group?
select age_group,sum(purchase_amount)as total_revenue
from customer group by age_group
order by total_revenue desc;