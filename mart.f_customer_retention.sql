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

from staging.user_order_log
group by extract(week from date_time)