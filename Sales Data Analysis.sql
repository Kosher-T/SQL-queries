CREATE TABLE orders (
    sn INTEGER PRIMARY KEY AUTOINCREMENT,
    id INT,
    customer_id INT
);

-- Populate the 'orders' table with the data
INSERT INTO orders (id, customer_id) VALUES
(9, 115),
(11, 116),
(12, 117),
(13, 118),
(14, 119),
(15, 120),
(16, 121),
(17, 122),
(18, 123),
(19, 124),
(20, 125),
(21, 126),
(22, 127),
(23, 128),
(24, 129);

-- Create the 'products' table
CREATE TABLE products (
    id INT,
    price DECIMAL(10, 2), -- Assuming price can have decimals, adjust precision as needed
    units_in_stock INT
);

-- Populate the 'products' table with the data
INSERT INTO products (id, price, units_in_stock) VALUES
(5, 13, 154),
(6, 15, 124),
(7, 11, 111),
(8, 18, 79),
(9, 16, 98),
(10, 9, 146),
(29, 14, 85),
(12, 9, 95);

-- Create the 'order_items' table
CREATE TABLE order_items (
    id INT PRIMARY KEY, -- Assuming 'id' is the primary key for this table
    order_id INT,
    product_id INT,
    quantity INT
);

-- Populate the 'order_items' table with the data
INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
(1, 10, 8, 5),
(2, 10, 10, 2),
(3, 11, 5, 3),
(4, 12, 12, 2),
(5, 13, 11, 4),
(6, 13, 8, 3),
(7, 13, 5, 2),
(8, 14, 10, 1),
(9, 14, 8, 3),
(10, 14, 11, 4),
(11, 14, 7, 2),
(12, 15, 12, 5),
(13, 16, 6, 1),
(14, 16, 7, 5),
(15, 17, 11, 1),
(16, 17, 6, 5),
(17, 18, 7, 2),
(18, 18, 9, 3),
(19, 18, 8, 4),
(20, 19, 11, 2);

/*
Return the top 5 customers who have spent the most on all of their orders.

The total spending should be calculated by multiplying the unit price and quantity for each item in each order, and then summing up all the products.

The result should consist of two columns: customer_id and total_spending, and should be sorted in descending order based on the total_spending column.
*/

SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM order_items;


SELECT
    orders.customer_id,
    SUM(order_items.quantity * products.price) AS total_spending
FROM
    order_items
LEFT JOIN
    orders ON orders.id = order_items.order_id 
JOIN
    products ON order_items.product_id = products.id
GROUP BY
    order_id
ORDER BY
    total_spending DESC
LIMIT
    5;
