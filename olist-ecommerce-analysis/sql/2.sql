---Q6)  Who are the top 20 customers by lifetime spend?

SELECT c.customer_unique_id,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oi.price), 0)    AS lifetime_spend
FROM orders o
JOIN customers c    ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY lifetime_spend DESC
LIMIT 20;

---Q7) What percentage of customers placed more than one order?
WITH per_customer AS (
    SELECT c.customer_unique_id,
           COUNT(DISTINCT o.order_id) AS orders
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT COUNT(*) AS customers,
       SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
       ROUND(100.0 * SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS repeat_pct
FROM per_customer;

---Q8)Rank sellers by revenue within each state (window function).
WITH seller_rev AS (
    SELECT s.seller_state,
           s.seller_id,
           SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN orders o  ON o.order_id = oi.order_id
    JOIN sellers s ON s.seller_id = oi.seller_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1, 2
)
SELECT seller_state,
       seller_id,
       ROUND(revenue, 0) AS revenue,
       RANK() OVER (PARTITION BY seller_state ORDER BY revenue DESC) AS rnk
FROM seller_rev
ORDER BY seller_state, rnk
limit 10;



---Q9)What is the average review score for late vs. on-time orders?

SELECT CASE WHEN o.order_delivered_customer_date::date
                 > o.order_estimated_delivery_date::date THEN 'late'
            ELSE 'on time' END AS delivery_status,
       COUNT(*) AS reviews,
       ROUND(AVG(r.review_score), 2) AS avg_score
FROM orders o
JOIN order_reviews r ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1;

---Q10)Which payment methods are most used, and how do they affect order value?
SELECT payment_type,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(100.0 * COUNT(DISTINCT order_id)
             / SUM(COUNT(DISTINCT order_id)) OVER (), 1) AS pct_of_orders,
       ROUND(AVG(payment_value), 1) AS avg_payment
FROM order_payments
WHERE payment_type <> 'not_defined'
GROUP BY 1
ORDER BY orders DESC;
















