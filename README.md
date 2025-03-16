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










