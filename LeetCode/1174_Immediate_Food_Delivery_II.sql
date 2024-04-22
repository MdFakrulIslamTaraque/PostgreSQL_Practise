select
    ROUND(cast((sum(CASE WHEN order_date=customer_pref_delivery_date THEN 1 ELSE 0 END)*100.00 / count(*)*1.00)as float8)::numeric, 2) as immediate_percentage
from
    Delivery
where
    (customer_id, order_date) in (select customer_id, min(order_date) from Delivery group by customer_id);