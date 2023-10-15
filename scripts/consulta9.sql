SELECT 
    YEAR(OrderDate) AS 'Año', 
    SUM(TotalDue) AS 'Ventas Totales'
FROM 
    Sales_SalesOrderHeader
GROUP BY 
    YEAR(OrderDate)
ORDER BY 
    'Año';
