-- Holiday Tour

-- 1.	Display All Staff Information for every staff whose email contains word ‘@gmail’.
--(LIKE)

SELECT *
FROM MsStaff
WHERE StaffEmail LIKE '%@gmail%'

-- 2.	Display CustomerID, CustomerName, CustomerEmail, CustomerPhone, and PurchaseDate for every ticket which purchased in April.
-- (JOIN, DATENAME, MONTH)

SELECT MC.CustomerID, MC.CustomerName, MC.CustomerEmail, MC.CustomerPhone
FROM MsCustomer MC
JOIN Ticket TK ON MC.CustomerID = TK.TicketID

-- 3.	Display DestinationID, DestinationName, DestinationLocation, and Total Visit (obtained from total destinations is visited then add the word ‘ Times’ after it) for every destination which Total Visit is greater than or equals three times and sort by Total Visit descendingly.
--(CAST, COUNT, JOIN, GROUP BY, HAVING, ORDER BY)

SELECT MD.DestinationID, MD.DestinationName, MD.DestinationLocation, CAST(COUNT(MD.DestinationID) AS varchar) + ' Times' AS [Total Visit]
FROM MsDestination MD
JOIN TicketDetail TD ON MD.DestinationID = TD.DestinationID
GROUP BY MD.DestinationID, MD.DestinationName, MD.DestinationLocation
HAVING COUNT(MD.DestinationID) >= 3
ORDER BY CAST(COUNT(MD.DestinationID) AS varchar) + ' Times' DESC 

-- 4.	Display TicketID, CustomerID, CustomerName, StaffID, StaffName, PurchaseDate, Total Destination (obtained from total destinations the customer visited), and Total Days (obtained from calculating day from start date to end date of all destination customer visited) for every ticket that purchased in 4th of month (April). Then, combine it with TicketID, CustomerID, CustomerName, StaffID, StaffName, PurchaseDate, Total Destination (obtained from total  destinations the customer visited), and Total Days (obtained from calculating day from start date to end date of all destination customer visited) for every ticket that purchased in 6th of month (June).
--(COUNT, SUM, DATEDIFF, DAY, DATEPART, MONTH, GROUP BY, UNION)

SELECT DISTINCT TK.TicketID, MC.CustomerID, MC.CustomerName, MS.StaffID, MS.StaffName, TK.PurchaseDate, COUNT(TD.DestinationID) AS [Total Destination], SUM(DATEDIFF(DAY, TD.StartDate, TD.EndDate)) +1  AS [Total Days]
FROM Ticket TK
JOIN MsCustomer MC ON TK.CustomerID = MC.CustomerID
JOIN MsStaff MS ON TK.StaffID = MS.StaffID
JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
WHERE DATEPART (MONTH,TK.PurchaseDate) = 4 
GROUP BY TK.TicketID, MC.CustomerID, MC.CustomerName, MS.StaffID, MS.StaffName, TK.PurchaseDate
UNION 
SELECT DISTINCT TK.TicketID, MC.CustomerID, MC.CustomerName, MS.StaffID, MS.StaffName, TK.PurchaseDate, COUNT(TD.DestinationID) AS [Total Destination], SUM(DATEDIFF(DAY, TD.StartDate, TD.EndDate)) +1  AS [Total Days]
FROM Ticket TK
JOIN MsCustomer MC ON TK.CustomerID = MC.CustomerID
JOIN MsStaff MS ON TK.StaffID = MS.StaffID
JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
WHERE DATEPART (MONTH,TK.PurchaseDate) = 6 
GROUP BY TK.TicketID, MC.CustomerID, MC.CustomerName, MS.StaffID, MS.StaffName, TK.PurchaseDate


--5.	Display CustomerID, CustomerName, CustomerEmail, Phone Number (Obtained from CustomerPhone replacing ‘+62’ with ‘0’), DestinationID, and DestinationName for every customer who never visit the destination and customer whose email contains word ‘yahoo’.
--(STUFF, NOT EXISTS, LIKE)

SELECT MC.CustomerID, MC.CustomerName, MC.CustomerEmail, STUFF(MC.CustomerPhone, 1,3,'0') AS [Phone Number], MD.DestinationID, MD.DestinationName, MD.DestinationPrice
FROM MsCustomer MC
JOIN Ticket TK ON MC.CustomerID = TK.CustomerID
JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
JOIN MsDestination MD ON TD.DestinationID = MD.DestinationID
WHERE NOT EXISTS (
	SELECT *
	FROM Ticket TK
	JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
	JOIN MsDestination MD ON TD.DestinationID = MD.DestinationID
	JOIN MsCustomer MC ON TK.CustomerID = MC.CustomerID
	WHERE TK.CustomerID = MC.CustomerID
	AND TD.DestinationID = MD.DestinationID
) 
AND MC.CustomerEmail LIKE '%yahoo%'

--6.	Display CustomerID, CustomerName, CustomerEmail, CustomerDOB, CustomerPhone, and Total Spending (obtained from summing each destination price multiplied with calculating days from start date to end date the customer in that destination) for every ticket which Total Spending between 1500000 and 5000000 and CustomerID ends with odd number.
--(SUM, DATEDIFF, DAY, BETWEEN, RIGHT, GROUP BY, alias subquery)

SELECT MC.CustomerID, MC.CustomerName, MC.CustomerEmail, MC.CusomerDOB, MC.CustomerPhone, SUM(SUB2.KONTOL) AS [Total Spending]
FROM Ticket TK
JOIN MsCustomer MC ON TK.CustomerID = MC.CustomerID
JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
JOIN MsDestination MD ON TD.DestinationID = MD.DestinationID,
	(
	SELECT MC.CustomerID,TK.TicketID, SUM(MD.DestinationPrice*DATEDIFF(DAY, TD.StartDate, TD.EndDate)) AS [KONTOL]
	FROM Ticket TK
	JOIN MsCustomer MC ON TK.CustomerID = MC.CustomerID
	JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
	JOIN MsDestination MD ON TD.DestinationID = MD.DestinationID
	GROUP BY MC.CustomerID, TK.TicketID
	) SUB2

WHERE RIGHT (MC.CustomerID,1)%2 = 1
GROUP BY MC.CustomerID, MC.CustomerName, MC.CustomerEmail, MC.CusomerDOB, MC.CustomerPhone, SUB2.KONTOL

--7.	Display a view named ‘Yogyakarta_Vacation_List’ to display DestinationTypeName (Obtained from lowering all character in DestinationTypeName), DestinationName, DestinationPrice, DestinationLocation, and DestinationDescription for every destination which contains word ‘Yogyakarta’.
--(CREATE VIEW, LOWER, LIKE)

CREATE VIEW Yogyakarta_Vacation_List AS 
SELECT LOWER(MT.DestinationTypeName) AS [DestinationTypeName], MD.DestinationName, MD.DestinationPrice, MD.DestinationLocation, MD.DestinationDescription
FROM MsDestination MD
JOIN MsDestinationType MT ON MD.DestinationTypeID = MT.DestinationTypeID
WHERE MD.DestinationLocation LIKE '%Yogyakarta%'



--8.	Create a view named ‘economic_customer’ to display CustomerID, CustomerPhone, CustomerEmail, and CustomerName for every customer who did visit a destination which price is above the average all of destination price and purchased the ticket in even month. For final output, the is no duplicate row.
--(CREATE VIEW,  DISTINCT, AVG, MONTH)

CREATE VIEW economic_customer AS

SELECT DISTINCT MC.CustomerID, MC.CustomerPhone, MC.CustomerEmail, MC.CustomerName
FROM MsCustomer MC
JOIN Ticket TK ON TK.CustomerID = MC.CustomerID
JOIN TicketDetail TD ON TK.TicketID = TD.TicketID
JOIN MsDestination MD ON TD.DestinationID = MD.DestinationID,
	(
		SELECT AVG(DestinationPrice) AS [AVERAGE]
		FROM MsDestination
	) sub1
WHERE MONTH(TK.PurchaseDate) % 2 = 0 AND MD.DestinationPrice >= 183125
GROUP BY MC.CustomerID, MC.CustomerPhone, MC.CustomerEmail, MC.CustomerName




