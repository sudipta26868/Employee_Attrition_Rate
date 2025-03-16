# Employee Attrition Rate Analysis SQL Project
## Project Overview
### Project Title : Employee Attrition Rate Analysis
Here, I have created the SQL project to demonstrate SQL skills and techniques. The project involves setting up an employee database of a company , performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

### Objectives
**1.Set up a retail sales database:** Create and populate an employee database with the provided data.
**2.Data Cleaning:** Identify and remove any records with missing or null values.
**3.Exploratory Data Analysis (EDA):** Perform basic exploratory data analysis to understand the dataset.
**4.Business Analysis:** Use SQL to answer specific business questions and derive insights from the dataset.

## Project Structure
### 1. Database Setup 
-**Database Creation:** At first I create a database named sql_project_p2.
-**Table Creation:** After the database creation create a table named employee to store employee data . The table structure includes columns for employeeid,joindate,exitdate, department , jobrole, gender , age , salary , status. 

```sql
create database sql_project_p2;
create table employee
(
    employeeid int,
    joindate date,
    exitdate date ,
    department varchar(10),
    jobrole varchar(20),
    gender varchar(10),
    age int,
    salary float ,
    status varchar(10)
);
```

### 2. Data Exploration & Cleaning 
-- see the total data --
```sql
select * from employee ;
```
-- Determine the total number of records in the dataset --
```sql
select count(*) from employee ;
```
-- check if there is any null values present --
```sql
select * from employee
where employeeid is null 
    or joindate is null
	or department is null
	or jobrole is null
	or gender is null
	or salary is null
	or status is null ;
```
-- how many unique job roles that we have -- 
```sql
select jobrole from employee
group by jobrole;
```
-- how many unique department we have --
```sql
select department from employee
group by department ;
```

### 3.Data Analysis & Business Key Problems

**1) Finding the number of employees who left**
```sql
select count(employeeid) from employee 
where exitdate is not null;
```

**2) The number of employees who join each year**
```sql
select count(employeeid) as no_of_employee, extract(year from joindate) as year from employee
group by year
order by year;
```

**3) The number of employees who left each year**
```sql
select count(employeeid) as no_of_employee, extract(year from exitdate) as year from employee
where exitdate is not null
group by year
order by year;
```

**4) Finding the Average number of employees**
```sql
select 
   extract(year from joindate) as year,
   (count(case when exitdate is null then employeeid end)+
   count(case when exitdate is not null then employeeid end)) / 2  as avgEmployees

from employee
group by year ;
```

**5) What is the overall attrition rate for the company by year ?**
-- Attrition Rate =( Average Number of Employees /Number of Employees Who Left)×100 --
```sql
WITH EmployeesLeft AS (
    SELECT extract(year from ExitDate) AS Year, COUNT(EmployeeID) AS EmployeesLeft
    FROM employee
    WHERE ExitDate IS NOT NULL
    GROUP BY Year
),
AvgEmployees AS (
    SELECT extract(year from JoinDate) AS Year,
           (COUNT(CASE WHEN ExitDate IS NULL THEN EmployeeID END) + 
            COUNT(CASE WHEN ExitDate IS NOT NULL THEN EmployeeID END)) / 2 AS AvgEmployees
    FROM employee
    GROUP BY Year
)
SELECT 
    e.Year,
    a.AvgEmployees,
	e.EmployeesLeft,
    (e.EmployeesLeft * 100.0) / NULLIF(a.AvgEmployees, 0) AS AttritionRate
FROM EmployeesLeft e
JOIN AvgEmployees a ON e.Year = a.Year
ORDER BY e.Year;
```

**6) What is the monthly attrition trend? Are there seasonal patterns?** 
```sql
with EmployeesLeft as 
   (SELECT to_char(ExitDate,'Month') AS month, COUNT(EmployeeID) AS EmployeesLeft
    FROM employee
    WHERE ExitDate IS NOT NULL
    GROUP BY month
),
AvgEmployees AS (
    SELECT to_char(joindate,'Month') AS month,
           (COUNT(CASE WHEN ExitDate IS NULL THEN EmployeeID END) + 
            COUNT(CASE WHEN ExitDate IS NOT NULL THEN EmployeeID END)) / 2 AS AvgEmployees
    FROM employee
    GROUP BY month
)
SELECT 
    e.month,
    a.AvgEmployees,
	e.EmployeesLeft,
    (e.EmployeesLeft * 100.0) / NULLIF(a.AvgEmployees, 0) AS AttritionRate
FROM EmployeesLeft e
JOIN AvgEmployees a ON e.month = a.month
ORDER BY attritionrate desc;
```

**7) Which departments have the highest attrition rate?**
```sql
WITH department AS (
    SELECT 
        department, 
        COUNT(employeeid) AS employeeleft
    FROM employee
    WHERE exitdate IS NOT NULL
    GROUP BY department
),
avgemployee AS (
    SELECT 
        department, 
        (COUNT(*) / 2) AS AvgEmployees -- Simplified calculation
    FROM employee
    GROUP BY department
)
SELECT 
    e.department, 
    a.AvgEmployees, 
    e.employeeleft,
    (e.employeeleft * 100.0) / NULLIF(a.AvgEmployees, 0) AS AttritionRate
FROM department e
JOIN avgemployee a ON e.department = a.department
order by attritionrate desc;
```

**8) Which job roles experience the most attrition?**
```sql
with jobroleleft as ( select jobrole ,count(employeeid) as employeeleft  from employee
	where exitdate is not null 
	group by jobrole ),
    avgemployee AS (
    SELECT 
        jobrole, 
        (COUNT(*) / 2) AS AvgEmployees -- Simplified calculation
    FROM employee
    GROUP BY jobrole)
	
select 
    e.jobrole, 
    a.AvgEmployees, 
    e.employeeleft,
    (e.employeeleft * 100.0) / NULLIF(a.AvgEmployees, 0) AS AttritionRate
FROM jobroleleft e
JOIN avgemployee a ON e.jobrole = a.jobrole
order by attritionrate desc;
```

**9) Do employees in certain departments or job roles leave sooner than others?**
```sql
select department , extract(months from joindate)-extract(months from exitdate) 
from employee
where exitdate is not null 
group by department ;
```

**10) Does age impact attrition? Are younger or older employees leaving more?**
```sql
select age,count(employeeid) as employeeleft from employee
where exitdate is not null
group by age
order by employeeleft desc;
```



















