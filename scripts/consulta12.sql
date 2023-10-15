SELECT 
    soh.SalesOrderID,
    so.Description AS 'Descripción de la Promoción',
    SUM(sod.OrderQty * sod.UnitPrice) AS 'Monto de Venta Total',
    COUNT(DISTINCT sod.ProductID) AS 'Número de Productos Vendidos'
FROM 
    Sales_SalesOrderHeader AS soh
JOIN 
    Sales_SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Sales_SpecialOfferProduct AS sop ON sod.ProductID = sop.ProductID
JOIN 
    Sales_SpecialOffer AS so ON sop.SpecialOfferID = so.SpecialOfferID
GROUP BY 
    soh.SalesOrderID, 
    so.Description
    limit 10;
