CREATE DATABASE SalesManagementSystem;
USE SalesManagementSystem;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    gender VARCHAR(10),
    birth_date DATE
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK(price > 0),
    category_id INT,
    
    FOREIGN KEY (category_id)
    REFERENCES Category(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE NOT NULL,
    
    FOREIGN KEY (customer_id)
    REFERENCES Customer(customer_id)
);

CREATE TABLE Order_Detail (
    order_id INT,
    product_id INT,
    quantity INT CHECK(quantity > 0),
    unit_price DECIMAL(10,2) CHECK(unit_price > 0),

    PRIMARY KEY(order_id, product_id),

    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES Product(product_id)
);