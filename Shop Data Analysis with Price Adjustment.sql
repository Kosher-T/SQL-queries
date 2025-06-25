CREATE TABLE shop (
    price INT,
    quantity INT,
    category VARCHAR(255),
    list_date TIMESTAMP
);

INSERT INTO shop (price, quantity, category, list_date) VALUES
    (35, 1, 'garden', '2015-03-06T22:00:00Z'),
    (24, 2, 'food', '2015-04-10T21:00:00Z'),
    (61, 5, 'plants', '2015-04-12T21:00:00Z'),
    (51, 2, 'garden', '2015-01-15T22:00:00Z'),
    (66, 4, 'school', '2015-03-19T22:00:00Z'),
    (47, 7, 'garden', '2015-01-10T22:00:00Z'),
    (62, 4, 'school', '2015-03-01T22:00:00Z'),
    (30, 7, 'school', '2015-01-03T22:00:00Z'),
    (51, 6, 'food', '2015-02-14T22:00:00Z'),
    (59, 1, 'plants', '2015-01-14T22:00:00Z'),
    (50, 7, 'plants', '2015-02-04T22:00:00Z'),
    (42, 3, 'school', '2015-01-02T22:00:00Z'),
    (48, 6, 'plants', '2015-03-07T22:00:00Z'),
    (68, 7, 'food', '2015-01-18T22:00:00Z'),
    (12, 3, 'garden', '2015-04-17T21:00:00Z');

SELECT category, SUM(price * quantity) AS total_gain
FROM (
    SELECT price + (SELECT AVG(price) FROM shop WHERE list_date BETWEEN '2015-01-01' AND '2015-03-18') AS price, quantity, category, list_date
    FROM shop
    WHERE list_date BETWEEN '2015-01-01' AND '2015-03-18'
)
GROUP BY category
ORDER BY total_gain DESC;
