-- 1.	Create a view named ‘ViewMilkTea' to display MilkTeaId, MilkTeaName, MilkTeaPrice for every service which name has more than 15 characters
--(create view, len)

 CREATE VIEW ViewMilkTea AS

 SELECT MM.MilkTeaId, MM.MilkTeaName, MM.MilkTeaPrice
 FROM MsMilkTea MM
 WHERE LEN(MM.MilkTeaName) > 15

--2.	Display MilkTeaId and BestMilkTea (obtained by displaying MilkTeaName in capital letters) for every milk tea which quantity is above 8
--(upper, in)

--SALAH
SELECT MM.MilkTeaId, UPPER(MM.MilkTeaName) AS [MilkTeaName]
FROM TransactionDetail TD
JOIN MsMilkTea MM ON TD.MilkTeaId = MM.MilkTeaId
WHERE TD.MilkTeaQuantity > 8

--BENAR
SELECT MM.MilkTeaId, UPPER(MM.MilkTeaName) AS [MilkTeaName]
FROM MsMilkTea MM
WHERE MM.MilkTeaId IN (
	SELECT MilkTeaId
	FROM TransactionDetail TD
	WHERE MilkTeaQuantity > 8
)


-- 3.	Display StaffId, StaffName, TotalTransaction (obtained from the total of transaction that is being held by the staff then add ‘transaction(s)’ after) for every Male Staff and have a salary greater than 5000000. 
--Then combine it with a display of StaffId, StaffName, TotalTransaction (obtained from the total of transaction that is being held by the staff then add ‘transaction(s)’ after) for every Male Staff and has a transaction on the first quarter
--(cast, count, union, group by, datepart, quarter)

SELECT MS.StaffId, MS.StaffName, CAST(COUNT(TH.StaffId) AS varchar) + ' transaction(s)' AS [TotalTransaction]
FROM TransactionHeader TH
JOIN MsStaff MS ON TH.StaffId = MS.StaffId
WHERE MS.StaffGender LIKE 'MALE' AND MS.StaffSalary > 5000000
GROUP BY MS.StaffId, MS.StaffName
UNION
SELECT MS.StaffId, MS.StaffName, CAST(COUNT(TH.StaffId) AS varchar) + ' transaction(s)' AS [TotalTransaction]
FROM TransactionHeader TH
JOIN MsStaff MS ON TH.StaffId = MS.StaffId
WHERE MS.StaffGender LIKE 'MALE' AND DATEPART(QUARTER, TH.TransactionDate) = 1
GROUP BY MS.StaffId, MS.StaffName

-- 4.	Display CustomerId (obtained by replacing the first 5 character with ‘Customer’), CustomerName, CustomerGender, CustomerAddress, and Quantity in Storage Left (obtained by subtracting the sum of quantity with 30) for every Male customer whose name has 2 words
--(replace, join, like, sum, group by)

	SELECT REPLACE(MC.CustomerId, 'CUS00', 'Customer ') AS [CustomerId], MC.CustomerName, MC.CustomerGender, MC.CustomerAddress, 30 - SUM(TD.MilkTeaQuantity) AS [Quantity in Storage Left]
	FROM MsCustomer MC
	JOIN TransactionHeader TH ON MC.CustomerId = TH.CustomerId
	JOIN TransactionDetail TD ON TH.TransactionId = TD.TransactionId
	WHERE MC.CustomerGender LIKE 'MALE' AND MC.CustomerName LIKE '% %'
	GROUP BY MC.CustomerId, MC.CustomerName, MC.CustomerGender, MC.CustomerAddress

-- 5.	Display Customer’s First Name (obtained from the first word of CustomerName), CustomerGender, CustomerAddress, CustomerPhone, TransactionDate for every milk tea which quantity is greater than the average price (obtained by calculating the average of milk tea quantity) and for all customers which phone number starts with ‘0817’
--(substring, charindex, convert, avg, like)

SELECT SUBSTRING(MC.CustomerName, 1, CHARINDEX(' ',MC.CustomerName)) AS [Customer's First Name], MC.CustomerGender, MC.CustomerAddress,  MC.CustomerPhone, CONVERT(varchar, TH.TransactionDate, 106) AS [TransactioDate], MM.MilkTeaName, MM.MilkTeaPrice
FROM MsCustomer MC
JOIN TransactionHeader TH ON MC.CustomerId = TH.CustomerId
JOIN TransactionDetail TD ON TH.TransactionId = TD.TransactionId
JOIN MsMilkTea MM ON TD.MilkTeaId = MM.MilkTeaId
WHERE MC.CustomerPhone LIKE '0817%' AND TD.MilkTeaQuantity > (
	SELECT AVG(MilkTeaQuantity)
	FROM TransactionDetail
)
