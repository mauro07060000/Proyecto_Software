SELECT 
    Status AS Estado, 
    SUM(TaxAmt) AS Total_Impuestos_Generados
FROM 
    Sales_SalesOrderHeader
GROUP BY 
    Status
ORDER BY 
    Total_Impuestos_Generados DESC;
