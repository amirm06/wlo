-- 1) Users Table
CREATE TABLE Users (
    user_id INTEGER NOT NULL,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) UNIQUE,
    password_hash VARCHAR2(50) NOT NULL,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    date_of_birth DATE,
    registration_date DATE DEFAULT SYSDATE,
    profile_picture_url VARCHAR2(255),
    user_role VARCHAR2(10) CHECK (user_role IN ('Admin', 'Seller', 'Buyer')),
    CONSTRAINT PK_Users PRIMARY KEY (user_id)
);

-- 2) Categories Table
CREATE TABLE Categories (
    category_id INTEGER NOT NULL,
    category_name VARCHAR2(50),
    CONSTRAINT PK_Categories PRIMARY KEY (category_id)
);

-- 3) Products Table (References Users & Categories)
CREATE TABLE Products (
    product_id INTEGER NOT NULL,
    seller_id INTEGER NOT NULL,
    product_name VARCHAR2(50),
    description VARCHAR2(255),
    price NUMBER(10,2),
    stock_quantity INTEGER,
    category_id INTEGER NOT NULL,
    created_at DATE,
    CONSTRAINT PK_Products PRIMARY KEY (product_id),
    CONSTRAINT FK_Products_Users FOREIGN KEY (seller_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 4) Orders Table (References Users)
CREATE TABLE Orders (
    order_id INTEGER NOT NULL,
    buyer_id INTEGER NOT NULL,
    total_price NUMBER(10,2),
    order_date DATE,
    status VARCHAR2(10) CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Canceled')),
    CONSTRAINT PK_Orders PRIMARY KEY (order_id),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (buyer_id) REFERENCES Users(user_id)
);

-- 5) Order_Items Table (References Orders & Products)
CREATE TABLE Order_Items (
    order_item_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER,
    price_at_purchase NUMBER(10,2),
    CONSTRAINT PK_Order_Items PRIMARY KEY (order_item_id),
    CONSTRAINT FK_Order_Items_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_Order_Items_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 6) Payments Table (References Orders & Users)
CREATE TABLE Payments (
    payment_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    amount_paid NUMBER(10,2),
    payment_date DATE DEFAULT SYSDATE,
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    CONSTRAINT PK_Payments PRIMARY KEY (payment_id),
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_Payments_Users FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 7) Reviews Table (References Users & Products)
CREATE TABLE Reviews (
    review_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    rating VARCHAR2(1) CHECK (rating IN ('1', '2', '3', '4', '5')),
    review_text VARCHAR2(255),
    review_date DATE DEFAULT SYSDATE,
    CONSTRAINT PK_Reviews PRIMARY KEY (review_id),
    CONSTRAINT FK_Reviews_Users FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 8) Wishlist Table (References Users & Products)
CREATE TABLE Wishlist (
    wishlist_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    added_date DATE,
    CONSTRAINT PK_Wishlist PRIMARY KEY (wishlist_id),
    CONSTRAINT FK_Wishlist_Users FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Wishlist_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 9) Messages Table (References Users for Sender & Receiver)
CREATE TABLE Messages (
    message_id INTEGER NOT NULL,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    message_text VARCHAR2(255),
    sent_at DATE DEFAULT SYSDATE,
    status VARCHAR2(10) CHECK (status IN ('Read', 'Unread')),
    CONSTRAINT PK_Messages PRIMARY KEY (message_id),
    CONSTRAINT FK_Messages_Users FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Messages_Users_Receiver FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

-- 10) Followers Table (Self-referencing Users)
CREATE TABLE Followers (
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    follow_date DATE DEFAULT SYSDATE,
    CONSTRAINT PK_Followers PRIMARY KEY (follower_id, following_id),
    CONSTRAINT FK_Followers_Users FOREIGN KEY (follower_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Followers_Following FOREIGN KEY (following_id) REFERENCES Users(user_id)
);

-- 11) Shopping Cart Table (References Users & Products)
CREATE TABLE Shopping_Cart (
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER,
    CONSTRAINT PK_Shopping_Cart PRIMARY KEY (user_id, product_id),
    CONSTRAINT FK_Shopping_Cart_Users FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Shopping_Cart_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 12) Shipping Addresses Table (References Users)
CREATE TABLE Shipping_Addresses (
    address_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    street VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    zip_code VARCHAR2(10) NOT NULL,
    country VARCHAR2(50),
    CONSTRAINT PK_Shipping_Addresses PRIMARY KEY (address_id),
    CONSTRAINT FK_Shipping_Addresses_Users FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 13) Admin Logs Table (References Users)
CREATE TABLE Admin_Logs (
    log_id INTEGER NOT NULL,
    admin_id INTEGER NOT NULL,
    action VARCHAR2(50),
    timestamp DATE DEFAULT SYSDATE,
    CONSTRAINT PK_Admin_Logs PRIMARY KEY (log_id),
    CONSTRAINT FK_Admin_Logs_Users FOREIGN KEY (admin_id) REFERENCES Users(user_id)
);



