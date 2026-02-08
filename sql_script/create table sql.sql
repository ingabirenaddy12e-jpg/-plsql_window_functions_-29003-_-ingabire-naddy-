create table customers (
  customer_id number primary key,
  name varchar2(50),
  region varchar2(50)
);

create table products (
  product_id number primary key,
  product_name varchar2(50)
);

create table sales (
  sale_id number primary key,
  customer_id number references customers(customer_id),
  product_id number references products(product_id),
  sale_date date,
  amount number
);
