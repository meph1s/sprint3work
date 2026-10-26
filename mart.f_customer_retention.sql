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
        count(customer_id) as count_customers,
        item_id,
        extract(week from date_time)::integer,
        sum(case when status = 'shipped' then payment_amount else 0 end),
        count(case when status = 'refunded' then 1 end)
    from staging.user_order_log
    group by extract(week from date_time), item_id
)
