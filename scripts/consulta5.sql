SELECT 
    pc.Name AS 'Categoría de Producto',
    COUNT(DISTINCT soh.SalesOrderID) AS Total_Pedidos
FROM 
    Sales_SalesOrderDetail sod
JOIN 
    Production_Product p ON sod.ProductID = p.ProductID
JOIN 
    Production_ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production_ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN 
    Sales_SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY 
    pc.Name
ORDER BY 
    COUNT(DISTINCT soh.SalesOrderID) DESC;
