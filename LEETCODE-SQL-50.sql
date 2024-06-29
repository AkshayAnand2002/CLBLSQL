LEETCODE SQL
Second Highest Salary
select(
select distinct salary as SecondHighestSalary from Employee e1 where
2=(select count(distinct salary) from Employee e2 where e1.salary<=e2.salary order by e1.salary)
) as SecondHighestSalary;

Employees Whose Manager Left the company
SELECT employee_id FROM Employees
WHERE manager_id NOT IN (SELECT employee_id FROM Employees) AND salary<30000
ORDER BY employee_id;

Exchange Seats
CASE WHEN id%2=1 AND id != (SELECT COUNT(id) FROM Seat) THEN id+1
WHEN id%2=0 THEN id-1
ELSE id
END AS id, student
FROM Seat
ORDER BY id;

Movie Rating
# Write your MySQL query statement below
(select name as results from movierating join users on users.user_id=movierating.user_id
group by users.user_id
order by count(rating) desc, name limit 1)
union all
(select title as results from movierating join movies on movierating.movie_id=movies.movie_id
where year(created_at)=2020 and month(created_at)=2
group by title
order by avg(rating) desc, title limit 1)

Recyclable and Low Fat products
SELECT product_id FROM Products WHERE low_fats='Y' AND recyclable='Y';

Managers With Atleast 5 Direct Reports
select A.name from Employee A join Employee B
ON A.id=B.managerId
GROUP BY A.id
HAVING COUNT(*)>=5;

Find Customer Referee
SELECT name from Customer WHERE referee_id != 2 OR referee_id IS NULL;

Confirmation Rate
SELECT Signups.user_id,ROUND(AVG(IF(Confirmations.action="confirmed",1,0)),2) AS confirmation_rate
FROM Signups LEFT JOIN Confirmations ON Signups.user_id=Confirmations.user_id
GROUP BY signups.user_id;

Students And Examinations
SELECT students.student_id,students.student_name,subjects.subject_name,count(examinations.subject_name) AS attended_exams
from Students JOIN Subjects LEFT JOIN Examinations
ON students.student_id=examinations.student_id and subjects.subject_name=examinations.subject_name
GROUP BY students.student_id,subjects.subject_name
ORDER BY student_id ASC,subjects.subject_name ASC;

Not Boring Movies
SELECT * FROM Cinema
WHERE id%2=1 AND description != 'boring'
ORDER BY Rating DESC;

Big Countries
SELECT name,population,area FROM World
WHERE area>=3000000 OR population>=25000000
ORDER BY name ASC;

Employee Bonus
select name,bonus from Employee LEFT JOIN Bonus
ON Employee.empId=Bonus.empId
WHERE bonus<1000 OR bonus IS NULL; 

Average Time Of Process Per Machine
SELECT a1.machine_id,ROUND(AVG(a2.timestamp-a1.timestamp),3) AS processing_time
FROM Activity a1 JOIN Activity a2
ON a1.machine_id=a2.machine_id AND a1.process_id=a2.process_id
AND a1.activity_type='start' AND a2.activity_type='end'
GROUP BY a1.machine_id;


Average Selling Price
select Prices.product_id,IFNULL(ROUND(SUM(units*price)/SUM(units),2),0) AS average_price
FROM Prices LEFT JOIN UnitsSold
ON Prices.product_id=UnitsSold.product_id AND UnitsSold.purchase_date BETWEEN start_date AND end_date
GROUP BY product_id;

Project Employees I
select project_id,round(avg(experience_years),2) as average_years from
Project JOIN Employee On Project.employee_id=employee.employee_id
GROUP BY project_id;

Percentage Of Users Attended A Contest:
Select contest_id, 
round(count(distinct user_id) * 100 / (Select count(distinct user_id) from Users), 2) as percentage 
from Register group by contest_id order by percentage desc, contest_id;

Article Views I
select distinct author_id as id FROM Views
WHERE author_id=viewer_id
ORDER BY 1;

Invalid Tweets
select tweet_id from Tweets
where char_length(content)>15;

Replace Employee ID with the unique identifier
SELECT CASE WHEN unique_id IS NULL THEN NULL ELSE unique_id END as unique_id,name
FROM Employees LEFT JOIN EmployeeUNI
ON Employees.id=EmployeeUNI.id

Product Sales Analysis I
SELECT product_name,year,price
FROM Sales JOIN Product
ON Sales.product_id=Product.product_id;

Customer Who Visited But Did Not Make Any Transactions
SELECT v.customer_id,COUNT(v.visit_id) AS count_no_trans
FROM Visits v LEFT JOIN Transactions t
ON v.visit_id=t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;

Rising Temperature
SELECT B.id FROM Weather A JOIN Weather B On DATEDIFF(B.recordDate,A.recordDate)=1
WHERE B.temperature>A.temperature;

Queries Quality And Percentages
select query_name,
    round(avg(rating/position), 2) as quality,
    round(sum(if(rating < 3,1,0)) * 100 / count(*), 2) as poor_query_percentage
from Queries
where query_name is not null
group by query_name;

Find Users With Valid Emails
SELECT * FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode[.]com$';

List The Products Ordered In A Period
select product_name,sum(unit)  AS unit FROM
Products JOIN Orders 
ON Products.product_id=Orders.product_id
WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY product_name
HAVING SUM(unit)>=100;

Group Sold Products By The Date
select sell_date,count(distinct product) as num_sold,
group_concat(distinct product order by product) as products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

Delete Duplicate Emails
delete p1 from Person p1 join Person p2 on p1.email=p2.email
where p1.id>p2.id;

Patients With A Condition
SELECT patient_id,patient_name,conditions FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%';
Fix Names In A Table
SELECT user_id,CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name,2))) AS name
FROM Users
ORDER BY user_id;

Department Top Three Salaries
select d.name as Department, e.name as Employee, e.salary as Salary
FROM Employee e JOIN Department d ON e.departmentId=d.id
WHERE (SELECT COUNT(DISTINCT salary) FROM Employee e2 WHERE e2.departmentId=e.departmentId
AND e2.salary>=e.salary)<=3
ORDER BY Department,Salary DESC;

Investments In 2016
SELECT ROUND(SUM(TIV_2016),2) AS tiv_2016
FROM Insurance WHERE
tiv_2015 IN (SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(pid)>1)
AND
(lat,lon) IN (SELECT lat,lon FROM Insurance GROUP BY lat,lon HAVING COUNT(pid)=1);

Friend Requests II
# Write your MySQL query statement below
WITH CTE AS(
    (select accepter_id as id,count(accepter_id) as num from RequestAccepted group by id)
    UNION ALL
    (select requester_id as id,count(requester_id) as num from RequestAccepted group by id)
)
SELECT id,sum(num) as num from CTE group by id order by num desc limit 1;

Restaurant Growth
SELECT visited_on,
(
    SELECT SUM(amount) FROM customer WHERE visited_on BETWEEN
    DATE_SUB(c.visited_on,INTERVAL 6 DAY) AND c.visited_on
) AS amount,
ROUND(
    (SELECT SUM(amount)/7 FROM Customer WHERE visited_on BETWEEN
    DATE_SUB(c.visited_on, INTERVAL 6 DAY)  AND c.visited_on
    ),2
) AS average_amount
FROM customer c
WHERE visited_on >= (SELECT DATE_ADD(MIN(visited_on),INTERVAL 6 DAY) FROM customer)
GROUP BY visited_on;

Count Salary Categories
SELECT 'Low Salary' AS category,COUNT(account_id) AS accounts_count
FROM Accounts WHERE income<20000
UNION
SELECT 'Average Salary' AS category,COUNT(account_id) AS accounts_count
FROM Accounts WHERE income<=50000 AND income>=20000
UNION
SELECT 'High Salary' AS category,COUNT(account_id) AS accounts_count
FROM Accounts WHERE income>50000

Last Person To Fit In The Bus
SELECT person_name FROM
(
    SELECT person_name,turn,sum(weight) OVER (ORDER BY turn) AS cum FROM Queue
) AS T
where cum<=1000 ORDER BY turn DESC limit 1;

Product Price At A Given Date
SELECT DISTINCT product_id, 10 AS price
FROM products
GROUP BY product_id
HAVING min(change_date)>"2019-08-16"
UNION
SELECT product_id,new_price FROM Products
WHERE (product_id,change_date) IN (SELECT product_id,MAX(change_date) AS recent_date
FROM Products WHERE change_date<="2019-08-16" GROUP BY product_id);

Consecutive Numbers
SELECT DISTINCT l1.num as ConsecutiveNums
FROM Logs l1 JOIN Logs l2 ON l1.id=l2.id-1
JOIN Logs l3 On l3.id-1=l2.id
WHERE l1.num=l2.num AND l2.num=l3.num;

Triangle Judgement
SELECT x,y,z,
CASE WHEN (x+y>z AND x+z>y AND y+z>x) THEN "Yes" ELSE "No" END AS triangle
FROM Triangle

Primary Department For Each Employee
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag='Y' 
OR 
employee_id in
    (SELECT employee_id
    FROM Employee
    Group by employee_id
    having count(employee_id)=1)

The Number Of Employees Which Report To Each Employee
WITH CTE AS(
    Select reports_to,COUNT(employee_id) AS reports_count, ROUND(AVG(age),0) AS average_age FROM Employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
)
SELECT CTE.reports_to as employee_id,Employees.name, CTE.reports_count,CTE.average_age
FROM CTE LEFT JOIN Employees
ON CTE.reports_to=Employees.employee_id
ORDER BY employee_id;

Customers Who Bought All Products
select customer_id from customer group by customer_id
having count(distinct product_key)=(select count(*) from product);

Biggest Single Number
with cte as(
    select num,count(*) as cnt
    from Mynumbers group by num having cnt=1
)
select max(num) as num from cte;

Queries Quality And Percentages
select query_name,
    round(avg(rating/position), 2) as quality,
    round(sum(if(rating < 3,1,0)) * 100 / count(*), 2) as poor_query_percentage
from Queries
where query_name is not null
group by query_name;

Game Play Analysis IV
SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id
  )

