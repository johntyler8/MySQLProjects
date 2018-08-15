/*
1. Write a query to display the name, product line, and buy price of all products. 
The output columns should display as “Name”, “Product Line”, and “Buy Price”. 
The output should display the most expensive items first.
*/
SELECT 
    productName AS 'Name',
    productLine AS 'Product Line',
    buyPrice AS 'Buy Price'
FROM
    classicmodels.products
ORDER BY buyPrice DESC;


/*
2. Write a query to display the first name, last name, and city for all customers from Germany. 
Columns should display as “First Name”, “Last Name”, and “City”. 
The output should be sorted by the customer’s last name (ascending).
*/
SELECT 
    contactFirstName AS 'First Name',
    contactLastName AS 'Last Name',
    city AS 'City'
FROM
    classicmodels.customers
WHERE
    country = 'Germany'
ORDER BY contactLastName ASC;


/*
3. Write a query to display each of the unique values of the status field in the orders table. 
The output should be sorted alphabetically increasing. Hint: the output should show exactly 6 rows.
*/
SELECT DISTINCT
    (status)
FROM
    classicmodels.orders
ORDER BY status;



/*
4. Select all fields from the payments table for payments made on or after January 1, 2005. 
Output should be sorted by increasing payment date.
*/
SELECT 
    *
FROM
    classicmodels.payments
WHERE
    paymentDate >= '2005-01-01'
ORDER BY paymentDate;



/*
5. Write a query to display all Last Name, First Name, Email and Job Title of all employees working out of the San Francisco office. 
Output should be sorted by last name.
*/
SELECT 
    e.lastName AS 'Last Name',
    e.firstName AS 'First Name',
    e.email AS 'Email',
    e.jobTitle AS 'Job Title'
FROM
    classicmodels.employees AS e
        LEFT JOIN
    classicmodels.offices AS o ON e.officecode = o.officecode
WHERE
    city = 'San Francisco'
ORDER BY lastname;



/*
6. Write a query to display the Name, Product Line, Scale, and Vendor of all of the car products – both classical and vintage. 
The output should display all vintage cars first (sorted alphabetically by name), and all classical cars last (also sorted alphabetically by name).
*/
SELECT 
    productName AS 'Name',
    productLine AS 'Product Line',
    productScale AS 'Scale',
    productVendor AS 'Vendor'
FROM
    classicmodels.products
WHERE
    productLine IN ('vintage cars' , 'classic cars')
GROUP BY productName , productLine , productScale , productVendor
ORDER BY productLine DESC , SUBSTRING(productName, 6, 10);



USE classicmodels;

/*
1. Write a query to display each customer’s name (as “Customer Name”) alongside the name of the employee who is responsible for that customer’s orders. 
The employee name should be in a single “Sales Rep” column formatted as “lastName, firstName”. 
The output should be sorted alphabetically by customer name.
*/
SELECT 
    c.customerName AS 'Customer Name',
    CONCAT(e.lastName, ' ', e.firstName) AS 'Sales Rep'
FROM
    customers AS c
        INNER JOIN
    employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber
ORDER BY c.customerName



/*
2. Determine which products are most popular with our customers. 
For each product, list the total quantity ordered along with the total sale generated (total quantity ordered * buyPrice) for that product. 
The column headers should be “Product Name”, “Total # Ordered” and “Total Sale”. List the products by Total Sale descending.
*/
SELECT 
    p.productName AS 'Product Name',
    SUM(o.quantityOrdered) AS 'Total # Ordered',
    SUM(o.quantityOrdered * p.buyPrice) AS 'Total Sale'
FROM
    products AS p
        LEFT JOIN
    orderdetails AS o ON p.productCode = o.productCode
GROUP BY productname
ORDER BY 3 DESC;



/*
3. Write a query which lists order status and the # of orders with that status. 
Column headers should be “Order Status” and “# Orders”. Sort alphabetically by status.
*/
SELECT 
    status AS 'Order Status', COUNT(orderNumber) AS '#Orders'
FROM
    orders
GROUP BY status ASC;



/*
4. Write a query to list, for each product line, the total # of products sold from that product line. 
The first column should be “Product Line” and the second should be “# Sold”. Order by the second column descending.
*/
SELECT 
    p.productLine AS 'Product Line',
    SUM(od.quantityOrdered) AS '# Sold'
FROM
    products AS p
        LEFT JOIN
    orderdetails AS od ON p.productcode = od.productcode
GROUP BY productLine
ORDER BY 2 DESC;



/*
5. For each employee who represents customers, output the total # of orders that employee’s customers have placed alongside the total sale amount of those orders. 
The employee name should be output as a single column named “Sales Rep” formatted as “lastName, firstName”. 
The second column should be titled “# Orders” and the third should be “Total Sales”. 
Sort the output by Total Sales descending. 
Only (and all) employees with the job title ‘Sales Rep’ should be included in the output, and if the employee made no sales the Total Sales should display as “0.00”.
*/
SELECT 
    CONCAT(employees.lastName,
            ' ',
            employees.firstName) AS 'Sales Rep',
    COUNT(orders.orderNumber) AS '# Orders',
    IF(COUNT(orders.orderNumber) = 0,
        0.00,
        SUM(orderdetails.quantityOrdered * orderdetails.priceEach)) AS 'Total Sales'
FROM
    customers
        RIGHT JOIN
    employees ON (customers.salesRepEmployeeNumber = employees.employeeNumber)
        LEFT JOIN
    orders ON (customers.customerNumber = orders.customerNumber)
        LEFT JOIN
    orderdetails ON (orders.orderNumber = orderdetails.orderNumber)
WHERE
    jobTitle = 'Sales Rep'
GROUP BY 1 ASC
ORDER BY 3 DESC;


/*
6. Your product team is requesting data to help them create a bar-chart of monthly sales since the company’s inception. 
Write a query to output the month (January, February, etc.), 4-digit year, and total sales for that month. 
The first column should be labeled ‘Month’, the second ‘Year’, and the third should be ‘Payments Received’. 
Values in the third column should be formatted as numbers with two decimals – for example: 694,292.68.
*/
SELECT 
    MONTHNAME(paymentDate) AS `Month`,
    YEAR(paymentDate) AS `Year`,
    FORMAT(SUM(amount), 2) AS `Payments Received`
FROM
    payments
GROUP BY `Month` , `Year`
ORDER BY paymentdate;