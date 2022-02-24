/* table consists of description of all the products present in the inventory*/
create table inventory(
	pid SERIAL PRIMARY KEY,
	name VARCHAR(50),
	qty INT,
	MRP INT
);

/* table consists of order details*/
create table manage_orders(
	oid SERIAL PRIMARY KEY,
	product_name VARCHAR(50),
	order_qty INT,
	customer_name VARCHAR(50),
	order_date DATE
);

/* table consists of invoices generated to the customer on every purchase*/
create table invoice(
	invoice_id SERIAL PRIMARY KEY,
	is_placed BOOLEAN,
	order_id INT ,
	customer_name VARCHAR(50),
	order_date DATE,
	product_name VARCHAR(50),
	order_qty INT,
	MRP INT
);
/* table for internal reports*/
create table report(
    sales INT,
    lost_orders INT
);


/* filling up the inventory*/

insert into inventory(name , qty , MRP) values ('Dell Vostro' , 7 , 45999);
insert into inventory(name , qty , MRP) values ('HP Pavilion' , 29 , 90000);
insert into inventory(name , qty , MRP) values ('Dell Latitude' , 90 , 74999);
insert into inventory(name , qty , MRP) values ('MacBook Air' , 55 , 89999);
insert into inventory(name , qty , MRP) values ('MacBook Pro' , 55, 150000);

/*initializing sales and lost_order revenue with 0 , in order to do arithmetic operations*/

insert into report (sales , lost_orders) values(0 , 0);



/* function which will get triggered before handling a new order*/

CREATE OR REPLACE FUNCTION fn_order_placed_log()
RETURNS TRIGGER
LANGUAGE PLPGSQL
as 
$$
BEGIN
    IF NEW.order_qty > (select qty from inventory where name = NEW.product_name) THEN
        insert into invoice(is_placed) 
        values(FALSE);
        update report set lost_orders = lost_orders + NEW.order_qty * (select MRP from inventory where name = NEW.product_name); 
        
    ELSE 
        update inventory set qty = qty - NEW.order_qty where name = NEW.product_name;
        insert into invoice (is_placed , order_id , customer_name , order_date , product_name , order_qty , MRP) 
        values(TRUE , NEW.oid , NEW.customer_name , now() , NEW.product_name , NEW.order_qty , (select MRP from inventory where name = NEW.product_name));
        update report set sales = sales + NEW.order_qty * (select MRP from inventory where name = NEW.product_name); 
    END IF;
    RETURN NEW;
END;
$$;

/* trigger which will trigger before INSERTION in manage_orders table*/

CREATE TRIGGER trigger_build_invoice
BEFORE INSERT
ON manage_orders
FOR EACH ROW 
EXECUTE PROCEDURE fn_order_placed_log();


/* some insertion queries in manage_orders table*/

insert into manage_orders (product_name , order_qty , customer_name , order_date)
values('MacBook Pro' , 1 , 'Naveen Jain' , now());

insert into manage_orders (product_name , order_qty , customer_name , order_date)
values('MacBook Pro' , 1 , 'Rahul Khandelwal' , now());

/* failed order*/
insert into manage_orders (product_name , order_qty , customer_name , order_date)
values('Dell Vostro' , 10 , 'Innovaccer Analytics Pvt. Ltd.' , now());

/* refilling inventory */
update inventory set qty = qty + 100 where name = 'Dell Vostro';


