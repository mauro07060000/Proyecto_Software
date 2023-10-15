SELECT 
    st.Name AS 'Región', 
    SUM(soh.TotalDue) AS Total_Ventas
FROM 
    Sales_SalesOrderHeader soh
JOIN 
    Sales_Customer sc ON soh.CustomerID = sc.CustomerID
JOIN 
    Person_BusinessEntityAddress bea ON sc.CustomerID = bea.BusinessEntityID
JOIN 
    Person_Address pa ON bea.AddressID = pa.AddressID
JOIN 
    Person_StateProvince sp ON pa.StateProvinceID = sp.StateProvinceID
JOIN 
    Sales_SalesTerritory st ON sp.TerritoryID = st.TerritoryID
GROUP BY 
    st.Name
ORDER BY 
    Total_Ventas DESC;
