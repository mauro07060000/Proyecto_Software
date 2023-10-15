SELECT 
    P.ProductID AS ID_Producto, 
    P.Name AS Nombre_producto,
    SUM(SOD.OrderQty) AS Numero_Total_Pedidos
FROM 
    Sales_SalesOrderDetail SOD
JOIN 
    Production_Product P ON SOD.ProductID = P.ProductID
GROUP BY 
    P.ProductID, P.Name
ORDER BY 
    Numero_Total_Pedidos DESC;
