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






