CREATE TABLE grades (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- Adding a primary key column, often good practice
    course_id INT,
    student_id INT,
    grade INT
);

INSERT INTO grades (course_id, student_id, grade) VALUES
(1, 5, 57),
(1, 6, 55),
(1, 7, 42),
(1, 8, 70),
(1, 9, 93),
(2, 5, 37),
(2, 6, 57),
(2, 7, 86),
(2, 8, 50),
(2, 9, 23),
(3, 5, 45),
(3, 6, 84),
(3, 7, 79),
(3, 8, 35),
(3, 9, 31);

CREATE TABLE students (
    sn INTEGER PRIMARY KEY AUTOINCREMENT,
    id INTEGER NOT NULL, -- Adding a primary key column, often good practice
    name TEXT NOT NULL
);

INSERT INTO students (id, name) VALUES
(5, 'luturna'),
(6, 'Hildingr'),
(7, 'Antiocho'),
(8, 'Agathe'),
(9, 'Helena');

SELECT
    s.name AS student,
    AVG(g.grade) AS average_grade
FROM
    students s
JOIN
    grades g ON g.student_id = s.id
GROUP BY
    s.name;
