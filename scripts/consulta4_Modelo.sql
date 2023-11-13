SELECT 
    pc.Name AS ProductCategoryName,
    SUM(DISTINCT fv.Ganancia) AS GananciaTotal
FROM adventureWorksDW.Fact_Ventas fv
JOIN adventureWorksDW.Dim_Product dp ON fv.Producto_key = dp.Product_key
JOIN adw.Production_Product pp ON dp.Product_id = pp.ProductID
JOIN adw.Production_ProductSubcategory psc ON pp.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN adw.Production_ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name;
