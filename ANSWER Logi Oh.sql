-- 1.	Display CustomerName, CustomerGender, CustomerPhone, CustomerAddress, and CustomerDOB data on Customer table for every Customer whose name contains letter ‘l’.
--(like)

SELECT CustomerName, CustomerGender, CustomerPhone, CustomerAddress, CustomerDOB
FROM Customer
WHERE CustomerName LIKE '%l%'

-- 2.	Display CustomerName, CustomerGender, CustomerPhone, CustomerAddress, and Transaction Month (obtained from the name of the month of TransactionDate).
--(datename, month)

SELECT CustomerName, CustomerGender, CustomerAddress, DATENAME(MONTH, TH.TransactionDate) AS [Transaction Month]
FROM Customer C
JOIN HeaderTransaction TH ON C.CustomerID = TH.CustomerID

--  3.	Display CardName (obtained from CardName in lowercase format), CardElement, CardLevel, CardAttack, CardDefense, and Total Transaction (obtained by adding ‘ times’ after the total of transaction that was already done) for every transaction which CardElement is ‘Dark’.
--(lower, cast, count, group by)

SELECT LOWER(CR.CardName) AS [CardName], CR.CardElement, CR.CardLevel, CR.CardAttack, CR.CardDefense, CAST(COUNT(TD.TransactionID) AS varchar) + ' times' AS [Total Transaction]
FROM DetailTransaction TD 
JOIN Cards CR ON TD.CardsID = CR.CardsID
WHERE CR.CardElement LIKE 'Dark'
GROUP BY LOWER(CR.CardName), CR.CardElement, CR.CardLevel, CR.CardAttack, CR.CardDefense

-- 4.	Display CardName, CardElement, Total Price (obtained from the sum of CardPrice), and Total Transaction (obtained by adding ‘ times’ after the total of transaction that was already done) for every transaction that held more than 8 months before 31 December 2017. Then, combine it with CardName, CardElement, Total Price (obtained from the sum of CardPrice), and Total Transaction (obtained by adding ‘ times’ after the total of transaction that was already done) for every transaction which CardPrice is more than 500000.
--(sum, cast, count, datediff, month, group by)

-- 5.	Display CustomerName, CustomerGender, and CustomerDOB (obtained from CustomerDOB in ‘Mon dd, yyyy’ format) for every customer who buys card on Friday.
--(convert, in, day)

-- 6.	Display CardName, Type (obtained from CardTypeName in uppercase format), CardElement, Total Card (obtained by adding ‘ Cards’ after Quantity), and Total Price (obtained from multiplying CardPrice and Quantity) for every Card which CardPrice is lower than the average price of all cards and the CardElement is ‘Dark’. Then, sort the data in ascending order based on Quantity.
--(upper, cast, alias subquery, avg, order by)

-- 7.	Create a view named ‘DragonDeck’ to display Monster Card (obtained from the first word of CardName), CardTypeName, CardElement, CardLevel, CardAttack, and CardDefense for every card which CardTypeName is ‘Dragon’.
--(create view, substring, charindex)

-- 8.	Create a view named ‘MayTransaction’ to display CustomerName, CustomerPhone (obtained by replacing ‘8’ with ‘x’), StaffName, StaffPhone, TransactionDate, and Sold Card (obtained from the sum of quantity) for every transaction that occurs in May and the CustomerGender is ‘Female’.
--(create view, replace, sum, month, group by)






