use adw;

SELECT 
    psc.ProductSubcategoryID AS 'ID_Producto_Subcategoria',
    psc.Name AS 'Subcategoria',
    SUM(soh.TaxAmt) AS 'Impuesto Total'
FROM Production_Product p
JOIN Production_ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Sales_SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales_SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY psc.ProductSubcategoryID, psc.Name
ORDER BY SUM(soh.TaxAmt) DESC;

