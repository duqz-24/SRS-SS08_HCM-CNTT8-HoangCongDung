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

INSERT INTO Customer(full_name, email, gender, birth_date)
VALUES
('Nguyen Van A', 'a@gmail.com', 'M', '2002-05-10'),
('Tran Thi B', 'b@gmail.com', 'F', '2001-03-15'),
('Le Van C', 'c@gmail.com', 'M', '1999-11-20'),
('Pham Thi D', 'd@gmail.com', 'F', '2004-07-01'),
('Hoang Van E', 'e@gmail.com', 'M', '2003-09-12');

INSERT INTO Category(category_name)
VALUES
('Electronics'),
('Fashion'),
('Food'),
('Books'),
('Furniture');

INSERT INTO Product(product_name, price, category_id)
VALUES
('Laptop', 1500, 1),
('Smartphone', 800, 1),
('T-Shirt', 20, 2),
('Pizza', 15, 3),
('Bookshelf', 120, 5);

INSERT INTO Orders(customer_id, order_date)
VALUES
(1, '2025-01-10'),
(2, '2025-01-11'),
(1, '2025-01-15'),
(3, '2025-02-01'),
(4, '2025-02-05');

INSERT INTO Order_Detail(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 1500),
(1, 3, 2, 20),
(2, 2, 1, 800),
(3, 4, 3, 15),
(4, 5, 1, 120);

UPDATE Product
SET price = 1700
WHERE product_name = 'Laptop';

UPDATE Customer
SET email = 'newemail@gmail.com'
WHERE customer_id = 1;

DELETE FROM Order_Detail
WHERE order_id = 3
AND product_id = 4;

SELECT
    full_name AS FullName,
    email AS Email,

    CASE
        WHEN gender = 'M' THEN 'Nam'
        WHEN gender = 'F' THEN 'Nu'
        ELSE 'Khac'
    END AS GenderText

FROM Customer;

SELECT
    full_name,
    YEAR(NOW()) - YEAR(birth_date) AS Age
FROM Customer
ORDER BY Age ASC
LIMIT 3;

SELECT
    o.order_id,
    o.order_date,
    c.full_name
FROM Orders o
INNER JOIN Customer c
ON o.customer_id = c.customer_id;

SELECT
    c.category_name,
    COUNT(p.product_id) AS TotalProducts
FROM Category c
JOIN Product p
ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) >= 2;

SELECT *
FROM Product
WHERE price > (
    SELECT AVG(price)
    FROM Product
);

SELECT *
FROM Customer
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM Orders
);

SELECT
    c.category_name,
    SUM(od.quantity * od.unit_price) AS Revenue
FROM Category c
JOIN Product p
ON c.category_id = p.category_id
JOIN Order_Detail od
ON p.product_id = od.product_id
GROUP BY c.category_name
HAVING Revenue > (
    SELECT AVG(TotalRevenue) * 1.2
    FROM (
        SELECT
            SUM(od.quantity * od.unit_price) AS TotalRevenue
        FROM Category c
        JOIN Product p
        ON c.category_id = p.category_id
        JOIN Order_Detail od
        ON p.product_id = od.product_id
        GROUP BY c.category_name
    ) AS Temp
);

SELECT *
FROM Product p1
WHERE price = (
    SELECT MAX(price)
    FROM Product p2
    WHERE p1.category_id = p2.category_id
);

SELECT full_name
FROM Customer
WHERE customer_id IN (

    SELECT customer_id
    FROM Orders
    WHERE order_id IN (

        SELECT order_id
        FROM Order_Detail
        WHERE product_id IN (

            SELECT product_id
            FROM Product
            WHERE category_id IN (

                SELECT category_id
                FROM Category
                WHERE category_name = 'Electronics'
            )
        )
    )
);