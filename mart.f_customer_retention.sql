delete from mart.f_customer_retention;

INSERT INTO mart.f_customer_retention (
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    period_id,
    item_id,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded
)
WITH t1 AS (
    SELECT 
        COUNT(CASE WHEN status = 'shipped' THEN 1 END) AS count_orders,
        customer_id,
        item_id,
        EXTRACT(WEEK FROM date_time)::INTEGER AS period_id,
        SUM(CASE WHEN status = 'shipped' THEN payment_amount ELSE 0 END) AS weekly_revenue,
        COUNT(CASE WHEN status = 'refunded' THEN 1 END) AS count_orders_refunded
    FROM staging.user_order_log
    GROUP BY EXTRACT(WEEK FROM date_time), item_id, customer_id
)
SELECT
    COUNT(CASE WHEN t1.count_orders = 1 THEN 1 END) AS new_customers_count,
    COUNT(CASE WHEN t1.count_orders > 1 THEN 1 END) AS returning_customers_count,
    COUNT(CASE WHEN t1.count_orders_refunded > 0 THEN 1 END) AS refunded_customer_count,
    period_id,
    item_id,
    SUM(CASE WHEN t1.count_orders = 1 THEN t1.weekly_revenue ELSE 0 END) AS new_customers_revenue,
    SUM(CASE WHEN t1.count_orders > 1 THEN t1.weekly_revenue ELSE 0 END) AS returning_customers_revenue,
    SUM(count_orders_refunded) AS customers_refunded
FROM t1
GROUP BY period_id, item_id;