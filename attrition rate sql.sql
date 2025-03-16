-- see the total data --
select * from employee ;

-- count the total number of rows --
select count(*) from employee ;

-- check if there is any null values present --
select * from employee
where employeeid is null 
    or joindate is null
	or department is null
	or jobrole is null
	or gender is null
	or salary is null
	or status is null ;

-- how many unique job roles that we have -- 
select jobrole from employee
group by jobrole;

-- how many unique department we have --
select department from employee
group by department ;

-- data anlaysis and business key problems --
-- 1) Finding the number of employees who left -- 

select count(employeeid) from employee 
where exitdate is not null;

-- 2) The number of employees who join each year --

select count(employeeid) as no_of_employee, extract(year from joindate) as year from employee
group by year
order by year;

-- 3) The number of employees who left each year -- 
select count(employeeid) as no_of_employee, extract(year from exitdate) as year from employee
where exitdate is not null
group by year
order by year;

-- 4) Finding the Average number of employees --

select 
   extract(year from joindate) as year,
   (count(case when exitdate is null then employeeid end)+
   count(case when exitdate is not null then employeeid end)) / 2  as avgEmployees

from employee
group by year ;

-- 5) What is the overall attrition rate for the company by year ?
-- Attrition Rate =( Average Number of Employees /Number of Employees Who Left)×100 --

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

-- 6) What is the monthly attrition trend? Are there seasonal patterns? -- 

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

-- 7) Which departments have the highest attrition rate? --

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

-- 8) Which job roles experience the most attrition?

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


-- 9) Do employees in certain departments or job roles leave sooner than others?

select department , extract(months from joindate)-extract(months from exitdate) 
from employee
where exitdate is not null 
group by department ;

-- 10) Does age impact attrition? Are younger or older employees leaving more?

select age,count(employeeid) as employeeleft from employee
where exitdate is not null
group by age
order by employeeleft desc;

-- 11) Do employees with lower salaries leave more frequently?

with a as
(select * , 
 case when salary<50000 then "Low Salary"
 case when salary between 50000 and 100000 then "Medium Salary"
 else "High Salary" end 
 from employee)

 select 

















