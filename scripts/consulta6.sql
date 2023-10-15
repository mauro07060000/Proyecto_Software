SELECT 
    PSC.Name AS Subcategoria_Producto, 
    P.Name AS Nombre_producto, 
    SUM(SOD.OrderQty) AS Total_Pedidos
FROM 
    Sales_SalesOrderDetail SOD
JOIN 
    Production_Product P ON SOD.ProductID = P.ProductID
JOIN 
    Production_ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
GROUP BY 
    PSC.Name, P.Name
ORDER BY 
    PSC.Name, SUM(SOD.OrderQty) DESC;
