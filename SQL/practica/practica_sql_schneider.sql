
--DROP TABLE IF DROP bc_module;
--DROP TABLE IF EXISTS inscription;
--DROP TABLE IF EXISTS module;
--DROP TABLE IF EXISTS professor;
--DROP TABLE IF EXISTS bootcamp;
--DROP TABLE IF EXISTS student;


-- Se crea la tabla student
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(20)
);

ALTER TABLE student
ADD CONSTRAINT unique_email UNIQUE (email);

ALTER TABLE student
ALTER COLUMN email SET NOT NULL;

-- Se crea la tabla bootcamp
CREATE TABLE bootcamp (
    bootcamp_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(1000),
    start_date DATE,
    end_date DATE
);



--Se crea la tabla professor

CREATE TABLE professor (
    professor_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50)
);


-- Se crea la tabla Module
CREATE TABLE module (
    module_id SERIAL PRIMARY KEY,
    professor_id INT,
    name VARCHAR(50),
    description VARCHAR(1000),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (professor_id) REFERENCES professor(professor_id));

-- Se crea la tabla Inscription (relación muchos a muchos entre student y bootcamp)
CREATE TABLE inscription (
    inscription_id SERIAL PRIMARY KEY,
    student_id INT,
    bootcamp_id INT,
    inscription_date DATE,
    has_finished BOOLEAN,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id));

CREATE INDEX idx_start_date ON inscription (inscription_date);


-- Crear la tabla Bc_module (relación muchos a muchos entre bootcamp y module)
CREATE TABLE bc_module (
    bc_module_id SERIAL PRIMARY KEY,
    bootcamp_id INT,
    module_id INT,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id),
    FOREIGN KEY (module_id) REFERENCES module(module_id),
    UNIQUE (bootcamp_id, module_id)
);

INSERT INTO student (name, surname, email, phone) VALUES
('Ana', 'González', 'ana.gonzalez@email.com', '912-222333'),
('Juan', 'Martínez', 'juan.martinez@email.com', '944-555666'),
('Laura', 'Hernández', 'laura.hernandez@email.com', '977-888999'),
('Pedro', 'López', 'pedro.lopez@email.com', '910-112131'),
('María', 'Rodríguez', 'maria.rodriguez@email.com', '915-161718'),
('Javier', 'Sánchez', 'javier.sanchez@email.com', '919-021222'),
('Carmen', 'Pérez', 'carmen.perez@email.com', '924-252627'),
('Antonio', 'García', 'antonio.garcia@email.com', '928-293031'),
('Isabel', 'Fernández', 'isabel.fernandez@email.com', '932-333435'),
('Sergio', 'Martín', 'sergio.martin@email.com', '936-373839'
);


INSERT INTO professor (name, surname, email, phone) VALUES
('Carlos', 'Gómez', 'carlos.gomez@email.com', '123-456-7890'),
('Elena', 'Rodríguez', 'elena.rodriguez@email.com', '987-654-3210'),
('Antonio', 'López', 'antonio.lopez@email.com', '555-123-4567'),
('María', 'Fernández', 'maria.fernandez@email.com', '789-456-1230'),
('Javier', 'Sánchez', 'javier.sanchez@email.com', '111-222-3333'),
('Ana', 'Pérez', 'ana.perez@email.com', '444-555-6666'
);

INSERT INTO bootcamp (name, description, start_date, end_date) VALUES
('Full Stack Jr.', 'You will learn computational thinking while(...)', DATE '2024-09-09', DATE '2025-01-09'),
('Java Full Stack','Master Java and Springboot from scratch, creating(...)', DATE '2024-11-04', DATE '2025-04-04'),
('Big Data, AI & Machine Learning Full Stack','With this Bootcamp you will master the necessary cloud architecture(...)', DATE '2024-11-04', DATE '2025-08-04'),
('Blockchain Full Stack', 'A bootcamp updated to the latest needs of the technological market(...)', DATE '2024-11-04', DATE '2025-06-04'),
('Cybersecurity Full Stack', 'The objective of this Bootcamp is to train any type of technological(...)', DATE '2024-11-04', DATE '2025-06-04'),
('Mobile Apps Development Full Stack', 'A bootcamp focused on iOS and Android app development, tailored to(...)', DATE '2024-11-04', DATE '2025-09-04'),
('Web Development Full Stack', 'This Bootcamp has been designed to provide our students with complete(...)', DATE '2024-11-04', DATE '2025-09-04'),
('DevOps & Cloud Computing Full Stack', 'Train yourself in one of the highest-paying trends in the sector(...)', DATE '2024-11-04', DATE '2025-05-04'),
('AI Full Stack', 'We prepare you to apply AI in all your projects.(...)', DATE '2024-11-04', DATE '2025-07-04'),
('UX/UI AI Driven Full Stack', 'The UX/UI bootcamp teaches, through real projects, how to improve (...)', DATE '2024-11-04', DATE '2025-05-04'

);


INSERT INTO inscription (student_id , bootcamp_id, inscription_date, has_finished)
VALUES
  (1, 4, DATE '2024-07-01', FALSE),
  (2, 6, DATE '2024-09-04', FALSE),
  (3, 2, DATE '2024-09-04', FALSE),
  (4, 1, DATE '2024-05-10', FALSE),
  (5, 8, DATE '2024-10-13', FALSE),
  (6, 5, DATE '2024-06-16', FALSE),
  (7, 7, DATE '2024-07-19', FALSE),
  (8, 1, DATE '2024-06-22', FALSE),
  (9, 2, DATE '2024-07-25', FALSE),
  (10, 1, DATE '2024-07-28', FALSE
  );
  
INSERT INTO module (professor_id, name, description, start_date, end_date)
VALUES
  (1,'Advanced SQL', 'Acquire skills in database design, modeling and management(...)', DATE '2024-09-15', DATE '2024-10-02'),
  (2,'Statistics and Data Mining', 'Provide mathematical skills to develop and improve(...)',DATE '2024-11-11', DATE '2024-11-29'),
  (3,'Deep Learning','Master deep neural networks to solve(...)',DATE '2024-02-11', DATE '2025-02-25'),
  (4,'Git', 'Learn to manage and integrate into our Git and Github workflow to(...)' ,DATE '2025-01-09', DATE '2025-01-30'),
  (5,'Math','Provide mathematical skills to develop and improve algorithms in Big Data, AI and ML, (...)', DATE '2024-12-02', DATE '2024-12-24'),
  (6,'Programming 101', 'Fundamentals of programming, logic and types of functions(...)',DATE '2024-10-04', DATE '2024-10-31');
  

INSERT INTO bc_module (bootcamp_id, module_id)
VALUES(1, 4), (1, 6), (2, 6), (2, 4), (3,1), (3, 2), (3, 3), (3, 4), (3, 5),(3, 6), (4, 4), (4,6), (5, 6), (5, 4), (5,5), (6,4), (6,6), (7,4), (7,6), (8,1), (8,2),(8,4), (8,6), (9, 1), (9,2), (9,3), (9,4), (9,5), (9,6), (10, 3), (10,4) ;


