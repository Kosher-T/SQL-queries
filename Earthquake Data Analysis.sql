CREATE TABLE earthquakes (
    location TEXT NOT NULL,
    amplitude REAL NOT NULL,
    period REAL NOT NULL
);

INSERT INTO earthquakes (location, amplitude, period) VALUES
    ('Stonebri', 0.01, 1),
    ('Readat', 0.003, 24),
    ('Chelten', 5, 0.2),
    ('Stonebri', 74, 49),
    ('Stonebri', 11, 62),
    ('Readat', 0.008, 0.34),
    ('Chelten', 73, 13),
    ('Hamwyawi', 68, 72),
    ('Chelten', 3, 1.2),
    ('Hamwyawi', 64, 45),
    ('Hamwyawi', 0.0005, 1.2),
    ('Stonebri', 13, 1.6);

SELECT location, ROUND(AVG(((amplitude/period) * (amplitude/period))/period), 2) AS avg_magnitude FROM earthquakes
WHERE amplitude >= 1 AND period >= 1
GROUP BY location
HAVING avg_magnitude > 1;
