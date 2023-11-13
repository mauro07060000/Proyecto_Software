SELECT 
    c.CustomerID,
    SUM(DISTINCT fv.Valor) AS TotalVentas
FROM adventureWorksDW.Fact_Ventas fv
JOIN adventureWorksDW.Dim_Cliente dc ON fv.Cliente_key = dc.Cliente_key
JOIN adw.Sales_Customer c ON dc.Customer_ID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalVentas DESC;
