CREATE TABLE customers (
    customer_id              VARCHAR(50),
    customer_unique_id       VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city            VARCHAR(100),
    customer_state           VARCHAR(5)
);
select * from customers;

CREATE TABLE orders (
    order_id                       VARCHAR(50),
    customer_id                    VARCHAR(50),
    order_status                   VARCHAR(20),
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);
select * from orders;

CREATE TABLE order_items (
    order_id            VARCHAR(50),
    order_item_id       INT,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2),
    freight_value       NUMERIC(10,2)
);
select * from order_items;

CREATE TABLE order_payments (
    order_id             VARCHAR(50),
    payment_sequential   INT,
    payment_type         VARCHAR(30),
    payment_installments INT,
    payment_value        NUMERIC(10,2)
);
select * from order_payments;

CREATE TABLE order_reviews (
    review_id               VARCHAR(50),
    order_id                VARCHAR(50),
    review_score            INT,
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE products (
    product_id                 VARCHAR(50),
    product_category_name      VARCHAR(100),
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);
CREATE TABLE sellers (
    seller_id              VARCHAR(50),
    seller_zip_code_prefix VARCHAR(10),
    seller_city            VARCHAR(100),
    seller_state           VARCHAR(5)
);

CREATE TABLE category_translation (
    product_category_name         VARCHAR(100),
    product_category_name_english VARCHAR(100)
);


--q1)What is total revenue by month, and what is the month-over-month growth?

select * from orders
select * from order_items


with monthly as(
        select date_trunc('month',o.order_purchase_timestamp):: date as months,
            sum(i.price)as revenue
             from orders o
             join order_items i
              on o.order_id=i.order_id
         where o.order_status = 'delivered'
            group by  1
)
select months,
round(revenue,0)AS revenue,
round(100.0*(revenue-LAG(revenue)over (order by months ))/LAG(revenue)over (order by months ),1) as month_by_month_growth 
from monthly
order by months;

---Q2) What are the top 10 product categories by revenue?

select * from order_items
select * from orders
select * from category_translation
select * from products

select  coalesce(t.product_category_name_english,p.product_category_name,'unkown') as category,
round(sum(oi.price))as revenue
from order_items oi
join orders o on oi.order_id= o.order_id
join products p on p.product_id=oi.product_id
left join category_translation t on t.product_category_name=p.product_category_name
where o.order_status = 'delivered'
group by 1
order by revenue desc 
limit 10;

---Q3) Which states generate the most revenue and orders?

select * from customers
select * from order_items
select * from orders

select c.customer_state,c.customer_city,
count(distinct o.order_id)as no_orders,
round(sum(oi.price))AS revenue
from orders o
join order_items oi on o.order_id=oi.order_id
join customers c on o.customer_id=c.customer_id
where o.order_status ='delivered'
group by 1,2
order by revenue DESC
limit 10;

---Q4) What percentage of orders were delivered late?

select * from orders

select count(*) as delivered_order,
      sum(case when order_delivered_customer_date:: date>order_estimated_delivery_date::date then 1 else 0 end) AS late_delivery,
	  round(100.0*sum(case when order_delivered_customer_date:: date>order_estimated_delivery_date::date then 1 else 0 end)/count(*),1)AS late_pct
	  from orders
	  where order_status='delivered'AND
	  order_delivered_customer_date IS NOT NULL;

---Q5) What is the average delivery time by state?


select * from orders
select * from customers


select c.customer_state,count(*)as order,
round(AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date),1)AS avg_time_delivery 
from orders o
join customers c on o.customer_id=c.customer_id
where o.order_status= 'delivered'AND o.order_delivered_customer_date IS NOT NULL
group by 1
order by avg_time_delivery DESC;


-- Q6) Who are the top 20 customers by lifetime spend?

select * from customers
select * from order_items
select * from orders

select c.customer_unique_id,
count(distinct o.order_id)AS no_order,
round(sum(oi.price),0)AS liftime_spent
from orders o
join order_items oi on o.order_id=o.order_id
join customers c on o.customer_id=c.customer_id
where o.order_status ='delivered'
group by 1
order by liftime_spent DESC
limit 20;
