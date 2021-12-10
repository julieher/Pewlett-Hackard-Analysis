
-- DELIVERABLE 1: The Number of Retiring Employees by Title
-- Export as retirement_titles.csv
SELECT  e.emp_no, 
		e.first_name, 
		e.last_name,
    	title.title,
    	title.from_date,
    	title.to_date
INTO retirement_titles
FROM employees as e
    INNER JOIN title
    ON (e.emp_no = title.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
-- Export as unique_titles.csv
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no ASC, rt.to_date DESC;

SELECT * FROM unique_titles;

-- retrieve the number of employees by their most recent job title who are about to retire
SELECT title, COUNT(title) as count
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- DELIVERABLE 2: The Employees Eligible for the Mentorship Program
-- Export as mentorship_eligibilty.csv

SELECT DISTINCT ON (e.emp_no) e.emp_no, 
		e.first_name, 
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		ti.title
INTO mentorship_eligibilty
FROM employees as e
	INNER JOIN dept_emp as de
    ON (e.emp_no = de.emp_no)
	INNER JOIN title as ti
	ON (e.emp_no = ti.emp_no)
  	WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibilty;