SELECT 
    PC.Name AS 'Categoría de Producto',
    SUM(SOD.LineTotal) AS 'Ventas Totales'
FROM 
    Sales_SalesOrderDetail SOD
JOIN 
    Production_Product P ON SOD.ProductID = P.ProductID
JOIN 
    Production_ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN 
    Production_ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY 
    PC.Name
ORDER BY 
    'Ventas Totales' DESC;
