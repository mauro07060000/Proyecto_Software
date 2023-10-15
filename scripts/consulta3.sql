SELECT 
    SM.Name AS MetodoEnvio,
    SUM(SOH.TaxAmt) AS ImpuestoTotal
FROM 
    Sales_SalesOrderHeader AS SOH
JOIN 
    Purchasing_ShipMethod AS SM ON SOH.ShipMethodID = SM.ShipMethodID
GROUP BY 
    SM.Name
ORDER BY 
    ImpuestoTotal DESC;
