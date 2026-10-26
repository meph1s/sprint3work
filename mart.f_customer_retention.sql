delete from mart.f_customer_retention;

insert into mart.f_customer_retention (
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    period_id,
    item_id,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded
    )
select 
    
    extract(week from date_time)::integer

from t1 as(
    select 
        count(uniq_id) as count_orders,
        customer_id,
        item_id,
        extract(week from date_time)::integer as period_id,
        sum(case when status = 'shipped' then payment_amount else 0 end) as weekly_revenue,
        count(case when status = 'refunded' then 1 end) as customers_refunded
    from staging.user_order_log
    group by extract(week from date_time), item_id, customer_id;
)
