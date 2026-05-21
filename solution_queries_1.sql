-- INSERT INTO book_issued in last 30 days
SELECT * from employees;
 SELECT * from books;
SELECT * from members;
SELECT * from issued_status;
SELECT * FROM return_status;
SELECT * FROM branch ;

INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 day,  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 day,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 day,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 day,  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
    
SELECT * FROM return_status;


-- Project TASK


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES
		('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.') ;
        
SELECT * FROM books 
WHERE isbn = '978-1-60129-456-2' ;

-- Task 2: Update an Existing Member's Address

SELECT * from members ;

UPDATE members
SET member_address = '221B Baker Street'
WHERE member_id = 'C119' ;

SELECT * FROM members
WHERE member_id = 'C119' ;

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS107' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS107' ;

SELECT * FROM issued_status ;

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101' ;

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT * FROM issued_status ;

SELECT 
	issued_emp_id, 
	COUNT(issued_id) AS total_books_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING total_books_issued > 1 ;

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

CREATE TABLE book_issued_cnt
AS
SELECT 
	b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS no_bk_issued
FROM books AS b
JOIN issued_status AS ist
ON B.isbn = ist.issued_book_isbn
GROUP BY 1,2
;

SELECT * FROM book_issued_cnt ;


-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:

SELECT * FROM books 
WHERE category = 'Classic' ;


-- Task 8: Find Total Rental Income by Category:

SELECT 
	category, 
	SUM(rental_price) AS toatal_rental_income,
    COUNT(*)
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY category;


-- Task 9. **List Members Who Registered in the Last 180 Days**:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY ;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:

SELECT
	e1.*,
    b.branch_address,
    e2.emp_name AS manager_name
FROM employees AS e1
JOIN branch AS b
ON 
e1.branch_id = b.branch_id
JOIN employees AS e2
ON
e2.emp_id = b.manager_id
;

SELECT * FROM employees ;
SELECT * FROM branch ;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold

CREATE TABLE premium_books
AS
SELECT * FROM books 
WHERE rental_price >= 5;

SELECT * FROM premium_books ;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
	DISTINCT ist.issued_book_name,
	ist.issued_date
FROM issued_status AS ist
LEFT JOIN return_status AS rst
ON ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL;
    

-- 