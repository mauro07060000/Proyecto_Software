SELECT 
    ST.Name AS Nombre_Territorio, 
    YEAR(SOH.OrderDate) AS 'Año', 
    SUM(SOH.TaxAmt) AS Total_Impuestos
FROM 
    Sales_SalesOrderHeader AS SOH
JOIN 
    Sales_SalesTerritory AS ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY 
    ST.Name, YEAR(SOH.OrderDate)
ORDER BY 
    ST.Name, YEAR(SOH.OrderDate);
