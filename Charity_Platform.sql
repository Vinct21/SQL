USE charity_platform

/*
1.	Create a view named "UserWithReminders" to display UserName, UserPhoneNumber, and UserEmail for
every user which has their UserReminder value set to �Yes�
(CREATE VIEW, LIKE)
*/
GO
CREATE VIEW UserWithReminders
AS
SELECT UserName, UserPhoneNumber, UserEmail 
FROM MsUser
WHERE UserReminder LIKE 'Yes'
GO

SELECT*FROM UserWithReminders

/*
2.	Display OrganizationName, CampaignName, and EndDate for every organization that has a campaign EndDate on 2020.
(IN, YEAR)
*/
SELECT MO.OrganizationName, TH.CampaignName, TH.EndDate 
FROM MsCharityOrganization MO
JOIN TrCharityHeader TH ON MO.OrganizationId = TH.OrganizationId
WHERE MO.OrganizationId IN (
	SELECT OrganizationId 
	FROM TrCharityHeader
	WHERE YEAR (EndDate) = 2020
)


/*
3.	Display CampaignName, EndYear (obtained from year of EndDate),
EndQuarter (obtained from quarter of EndDate), and HighestDonation (Obtained from the maximum of DonationAmount)
for every campaign that ended in the first quarter. Then combine it with CampaignName,
EndYear (obtained from year of EndDate), EndQuarter (obtained from quarter of EndDate),
and HighestDonation (Obtained from the maximum of DonationAmount) for campaign that ended in the fourth quarter.
(YEAR, DATENAME, QUARTER, MAX, GROUP BY, UNION)
*/
SELECT TH.CampaignName, YEAR(TH.EndDate) AS [EndYear], DATENAME(QUARTER, TH.EndDate) AS [EndQuarter],
MAX(TD.DonationAmount) AS [HighestDonation]
FROM TrCharityHeader TH
JOIN TrCharityDetail TD ON TH.CampaignId = TD.CampaignId
WHERE DATENAME (QUARTER, TH.EndDate) = 1
GROUP BY TH.CampaignName, TH.EndDate
UNION
SELECT TH.CampaignName, YEAR(TH.EndDate) AS [EndYear], DATENAME(QUARTER, TH.EndDate) AS [EndQuarter],
MAX(TD.DonationAmount) AS [HighestDonation]
FROM TrCharityHeader TH
JOIN TrCharityDetail TD ON TH.CampaignId = TD.CampaignId
WHERE DATENAME (QUARTER, TH.EndDate) = 4
GROUP BY TH.CampaignName, TH.EndDate

/*
4.	Display OrganizationId, OrganizationName, CampaignName, EndDate,
and TotalReceived (obtained from the sum of DonationAmount) for every campaign that set to end later than the 20th of the week and TotalReceived is greater than 10000000.
(SUM, JOIN, DATEPART, WEEK, GROUP BY, HAVING)
*/
SELECT MO.OrganizationId, MO.OrganizationName, TH.CampaignName, TH.EndDate,
SUM (TD.DonationAmount) AS [TotalReceived] 
FROM MsCharityOrganization MO
JOIN TrCharityHeader TH ON MO.OrganizationId = TH.OrganizationId 
JOIN TrCharityDetail TD ON TH.CampaignId = TD.CampaignId
WHERE DATEPART(WEEK,TH.EndDate) > 20 
GROUP BY MO.OrganizationId, MO.OrganizationName, TH.CampaignName, TH.EndDate
HAVING SUM (TD.DonationAmount) > 10000000

/*
5.	Display UserName, DonationAmount (obtained by adding �Rp. � in front of DonationAmount [include space in the end of Rp. word]), and DayOfTheWeek (obtained from the EndDate of weekday of the campaign) for every user who donated more than the all of average Donation Amount and the campaign category is �Environment�
(CAST, DATENAME, WEEKDAY, AVG, LIKE, alias subquery)
*/
SELECT UserName, 'Rp. ' + CAST (DonationAmount AS varchar) AS [DonationAmount], DATENAME(WEEKDAY, EndDate) AS [DayofTheWeek]
FROM MsUser MU
JOIN TrCharityDetail TD ON MU.UserId = TD.UserId 
JOIN TrCharityHeader TH ON TD.CampaignId = TH.CampaignId 
JOIN MsCharityCategory MC ON TH.CharityCategoryId = MC.CharityCategoryId,
	(
	SELECT AVG(DonationAmount) AS AvgDonationAmount 
	FROM TrCharityDetail
	) AS sub
WHERE TD.DonationAmount > sub.AvgDonationAmount AND MC.CharityCategoryName LIKE 'Environment'
