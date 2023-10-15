SELECT 
    ST.Name AS Nombre_Territorio,
    COUNT(SOH.SalesOrderID) AS Total_Pedidos
FROM 
    Sales_SalesOrderHeader SOH
JOIN 
    Sales_Customer SC ON SOH.CustomerID = SC.CustomerID
JOIN 
    Sales_SalesTerritory ST ON SC.TerritoryID = ST.TerritoryID
GROUP BY 
    ST.Name
ORDER BY 
    Total_Pedidos DESC;
