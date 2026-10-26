/*добавление колонки статус в слой stage и витрину продаж*/
alter table staging.user_order_log add column status varchar(10)
check (status in ('shipped', 'refunded')) DEFAULT 'shipped';

alter table mart.f_sales add column status varchar(10);

/*DDL витрины mart.f_customer_retention*/
create table mart.f_customer_retention (
    id serial primary key,
    new_customers_count integer,
    returning_customers_count integer,
    refunded_customer_count integer,
    period_name date,
    period_id integer,
    item_id integer,
    new_customers_revenue numeric(10, 2),
    returning_customers_revenue numeric(10, 2),
    customers_refunded integer,
    constraint fk_item
        foreign key (item_id)
        references mart.d_item(item_id)
);