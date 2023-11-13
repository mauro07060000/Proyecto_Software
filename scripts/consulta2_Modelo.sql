SELECT 
    st.TerritoryID,
    cr.Name AS CountryRegionName,
    SUM(DISTINCT fv.Valor) AS ValorTotalVentas
FROM adventureWorksDW.Fact_Ventas fv
JOIN adventureWorksDW.Dim_Territory dt ON fv.Territory_key = dt.Territory_key
JOIN adw.Sales_SalesTerritory st ON dt.Territory_ID = st.TerritoryID
JOIN adw.Person_CountryRegion cr ON st.CountryRegionCode = cr.CountryRegionCode
GROUP BY st.TerritoryID, cr.Name
ORDER BY ValorTotalVentas DESC;
