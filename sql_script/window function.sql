select
  c.name,
  sum(s.amount) total_sales,
  rank() over (order by sum(s.amount) desc) sales_rank
from sales s
join customers c on s.customer_id = c.customer_id
group by c.name;
