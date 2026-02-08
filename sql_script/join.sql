select c.name, p.product_name, s.amount
from sales s
inner join customers c on s.customer_id = c.customer_id
inner join products p on s.product_id = p.product_id;
