----##1)Users------------------------------------------------------------
CREATE TABLE Users(
user_id integer not null,
username varchar2(50) not null UNIQUE,
email varchar2(100) UNIQUE ,
password_hash varchar2(50) not null,
first_name  varchar2(50),
last_name  varchar2(50),
date_of_birth DATE ,
registration_date DATE DEFAULT SYSDATE,
profile_picture_url varchar2(255),
user_role varchar2(10) check ( user_role IN ('Admin', 'Seller', 'Buyer')),
constraint PK_Users primary key (user_id)
);
------2)Products---------------------------------------------------------------------------

CREATE TABLE Products(
product_id integer not null,
seller_id integer not null,
product_name  varchar2(50),
description  varchar2(255),
price NUMBER(10,2),
stock_quantity integer,
category_id integer not null,
created_at DATE,
constraint PK_Products Primary KEY (product_id),
constraint FK_Products_Users foreign key (seller_id)  REFERENCES Users(user_id) ,
constraint FK_Products_Categories foreign key (category_id) references Categories(category_id) 
);
------------3--------------------------------------------------------------------------
CREATE TABLE Categories (
category_id integer not null,
category_name varchar2(50),
constraint PK_Categories Primary KEY (category_id)
);
------------------4---------------------------------------------------------------
CREATE TABLE Orders (
order_id integer not null,
buyer_id integer not null,
total_price NUMBER(10,2),
order_date DATE,
status varchar2(10) check ( status IN ('Pending', 'Shipped', 'Delivered','Canceled')),
constraint PK_Orders Primary KEY (order_id) ,
constraint FK_Orders_Users Foreign KEY (buyer_id) REFERENCES Users(user_id)
);
----------------------------------------------------------------------------------

CREATE TABLE Order_Items (
order_item_id integer not null,
order_id integer not null,
product_id integer not null,
quantity INTEGER,
price_at_purchase INTEGER,
constraint PK_Order_Items Primary Key (order_item_id),
constraint FK_Order_Items_Orders Foreign KEY (order_id) REFERENCES Orders(order_id),
constraint FK_Order_Items_Products Foreign KEY (product_id) REFERENCES Products(product_id)
);
-----------------------------------------------------------------------------

CREATE TABLE Payments (
payment_id integer not null, 
order_id integer not null,
user_id integer not null,
amount_paid NUMBER(10,2),
 payment_date  DATE DEFAULT SYSDATE,
payment_method varchar2(20) check ( payment_method IN ('Credit Card', 'PayPal', 'Bank Transfer')),
CONSTRAINT PK_Payments primary key (payment_id),
constraint FK_Payments_Orders Foreign KEY (order_id) REFERENCES Orders(order_id),
constraint FK_Payments_Users Foreign KEY (user_id) REFERENCES Users(user_id)
);
-------------------------------------------------------
CREATE TABLE Reviews (
review_id integer not null,
user_id integer not null,
product_id integer not null,
rating VARCHAR2(1) check (rating in ('1','2','3','4','5')),
review_text varchar2(255),
review_date  DATE DEFAULT SYSDATE,
constraint PK_Reviews Primary KEY (review_id) ,
constraint FK_Reviews_Users foreign key (user_id) REFERENCES Users(user_id),
constraint FK_Reviews_Products Foreign key (product_id) REFERENCES Products(product_id)
);
---------------------------------------------------------------------------
CREATE TABLE Wishlist (
wishlist_id integer not null,
user_id integer not null,
product_id integer not null,
added_date DATE,
constraint PK_Wishlist Primary KEY (wishlist_id),
constraint FK_Wishlist_Users foreign key (user_id) REFERENCES Users(user_id),
constraint FK_Wishlist_Products Foreign key (product_id) REFERENCES Products(product_id)
);
----------------------------------------------------------------------
CREATE TABLE Messages (
message_id integer not null,
sender_id integer not null,
receiver_id integer not null,
message_text varchar2(255),
sent_at  DATE DEFAULT SYSDATE,
status Varchar2(10) check (status IN ('Read','Unread')),
constraint PK_Messages Primary key (message_id),
constraint FK_Messages_Users Foreign key (sender_id)  REFERENCES Users(user_id),
constraint FK_Messages_Users_Receiver Foreign key (receiver_id)  REFERENCES Users(user_id)
);
------------------------------------------------------------------------------
CREATE TABLE Followers (
follower_id integer not null,
following_id integer not null,
follow_date  DATE DEFAULT SYSDATE,
constraint PK_Followers primary key (follower_id, following_id),
constraint FK_Followers_Users foreign key (follower_id)  REFERENCES Users(user_id),
constraint FK_Followers_Following foreign key (following_id)  REFERENCES Users(user_id),
);
------------------------------------------------------------------------------
CREATE TABLE Shopping_Cart(
 cart_id integer not null,
 user_id integer not null,
 product_id integer not null,
 quantity INTEGER,
constraint PK_Shopping_Cart Primary key (cart_id),
constraint FK_Shopping_Cart_Users foreign key (user_id)  REFERENCES Users(user_id),
constraint FK_Shopping_Cart_Products foreign key (product_id) REFERENCES Products(product_id)
);
-------------------------------------------------------------------------
CREATE TABLE Shipping_Addresses(
address_id integer not null,
 user_id integer not null,
street Varchar2(100),
city  Varchar2(50),
state Varchar2(50),
zip_code VARCHAR2(10) NOT NULL,
country Varchar2(50),
constraint PK_Shipping_Addresses primary key (address_id),
constraint FK_Shipping_Addresses_Users foreign key (user_id)  REFERENCES Users(user_id)
);


CREATE TABLE Admin_Logs (
log_id integer not null,
admin_id integer not null,
action varchar2(50),
timestamp   DATE DEFAULT SYSDATE,
constraint PK_Admin_Logs primary key (log_id),
constraint FK_Admin_Logs_Users foreign key (admin_id)  REFERENCES Users(user_id)
);
