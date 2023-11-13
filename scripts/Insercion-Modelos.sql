use adw;

INSERT INTO adventureWorksDW.Dim_Product (
    Product_id,
    Product_Name,
    ProductCategory_Name,
    ProductSubcategory_Name
)
SELECT 
    p.ProductID,
    p.Name,
    COALESCE(pc.Name, 'No Category') AS ProductCategory_Name,
    COALESCE(psc.Name, 'No Subcategory') AS ProductSubcategory_Name
FROM adw.Production_Product p
LEFT JOIN adw.Production_ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN adw.Production_ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID;



INSERT INTO adventureWorksDW.Dim_Tiempo (
    OrderDate,
    Dia,
    Mes,
    Ano
)
SELECT 
    CAST(OrderDate AS DATE) AS OrderDate,
    EXTRACT(DAY FROM OrderDate) AS Dia,
    EXTRACT(MONTH FROM OrderDate) AS Mes,
    EXTRACT(YEAR FROM OrderDate) AS Ano
FROM adw.Sales_SalesOrderHeader;



INSERT INTO adventureWorksDW.Dim_Cliente (
    Customer_ID,
    City,
    Store_name
)
SELECT 
    c.CustomerID,
    COALESCE(a.City, 'Desconocido') AS City, -- Proporciona 'Desconocido' si la ciudad es NULL
    COALESCE(s.Name, 'Sin Tienda') AS Store_name -- Proporciona 'Sin Tienda' si no hay tienda asociada
FROM adw.Sales_Customer c
LEFT JOIN Person_BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
LEFT JOIN Person_Address a ON bea.AddressID = a.AddressID
LEFT JOIN Sales_Store s ON c.StoreID = s.BusinessEntityID;


INSERT INTO adventureWorksDW.Dim_Territory (
    Territory_ID,
    CountryRegionName,
    StateProvinceName
)
SELECT 
    st.TerritoryID,
    cr.Name AS CountryRegionName,
    sp.Name AS StateProvinceName
FROM adw.Sales_SalesTerritory st
LEFT JOIN Person_StateProvince sp ON st.TerritoryID = sp.TerritoryID
LEFT JOIN Person_CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode;


-- Proceso para fact ventas --

CREATE TEMPORARY TABLE adw.Temp_Ventas AS
SELECT 
    sod.SalesOrderID,
    sod.ProductID,
    soh.OrderDate,
    soh.CustomerID,
    soh.TerritoryID,
    (sod.UnitPrice - sod.UnitPriceDiscount) * sod.OrderQty AS Valor,
    sod.OrderQty * pp.StandardCost AS Costo,
    (sod.UnitPrice - pp.StandardCost) * sod.OrderQty AS Ganancia,
    sod.UnitPriceDiscount,
    sod.OrderQty
FROM adw.Sales_SalesOrderDetail sod
JOIN adw.Sales_SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN adw.Production_ProductCostHistory pp ON sod.ProductID = pp.ProductID AND (pp.EndDate IS NULL OR pp.EndDate > soh.OrderDate);

CREATE TEMPORARY TABLE adventureWorksDW.Temp_Cliente AS
SELECT 
    dc.Cliente_key,
    SUM(tv.Valor) AS Valor,
    SUM(tv.Costo) AS Costo,
    SUM(tv.Ganancia) AS Ganancia,
    AVG(tv.UnitPriceDiscount) AS Descuentos,
    SUM(tv.OrderQty) AS Cantidad
FROM adw.Temp_Ventas tv
JOIN adventureWorksDW.Dim_Cliente dc ON tv.CustomerID = dc.Customer_ID
GROUP BY dc.Cliente_key;

INSERT INTO adventureWorksDW.Fact_Ventas (
    Cliente_key,
    Producto_key,
    Tiempo_key,
    Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
)
SELECT 
    Cliente_key,
    NULL AS Producto_key,
    NULL AS Tiempo_key,
    NULL AS Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
FROM adventureWorksDW.Temp_Cliente;

CREATE TEMPORARY TABLE adventureWorksDW.Temp_Producto AS
SELECT 
    dp.Product_key,
    SUM(tv.Valor) AS Valor,
    SUM(tv.Costo) AS Costo,
    SUM(tv.Ganancia) AS Ganancia,
    AVG(tv.UnitPriceDiscount) AS Descuentos,
    SUM(tv.OrderQty) AS Cantidad
FROM Temp_Ventas tv
JOIN adventureWorksDW.Dim_Product dp ON tv.ProductID = dp.Product_id
GROUP BY dp.Product_key;

INSERT INTO adventureWorksDW.Fact_Ventas (
    Cliente_key,
    Producto_key,
    Tiempo_key,
    Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
)
SELECT 
    NULL AS Cliente_key,
    Product_key,
    NULL AS Tiempo_key,
    NULL AS Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
FROM adventureWorksDW.Temp_Producto;

CREATE TEMPORARY TABLE adventureWorksDW.Temp_Tiempo AS
SELECT 
    dt.Tiempo_key,
    SUM(tv.Valor) AS Valor,
    SUM(tv.Costo) AS Costo,
    SUM(tv.Ganancia) AS Ganancia,
    AVG(tv.UnitPriceDiscount) AS Descuentos,
    SUM(tv.OrderQty) AS Cantidad
FROM Temp_Ventas tv
JOIN adventureWorksDW.Dim_Tiempo dt ON CAST(tv.OrderDate AS DATE) = dt.OrderDate
GROUP BY dt.Tiempo_key;

INSERT INTO adventureWorksDW.Fact_Ventas (
    Cliente_key,
    Producto_key,
    Tiempo_key,
    Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
)
SELECT 
    NULL AS Cliente_key,
    NULL AS Producto_key,
    Tiempo_key,
    NULL AS Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
FROM adventureWorksDW.Temp_Tiempo;


CREATE TEMPORARY TABLE adventureWorksDW.Temp_Territory AS
SELECT 
    dtr.Territory_key,
    SUM(tv.Valor) AS Valor,
    SUM(tv.Costo) AS Costo,
    SUM(tv.Ganancia) AS Ganancia,
    AVG(tv.UnitPriceDiscount) AS Descuentos,
    SUM(tv.OrderQty) AS Cantidad
FROM Temp_Ventas tv
JOIN adventureWorksDW.Dim_Territory dtr ON tv.TerritoryID = dtr.Territory_ID
GROUP BY dtr.Territory_key;

INSERT INTO adventureWorksDW.Fact_Ventas (
    Cliente_key,
    Producto_key,
    Tiempo_key,
    Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
)
SELECT 
    NULL AS Cliente_key,
    NULL AS Producto_key,
    NULL AS Tiempo_key,
    Territory_key,
    Valor,
    Costo,
    Ganancia,
    Descuentos,
    Cantidad
FROM adventureWorksDW.Temp_Territory;

DROP TEMPORARY TABLE adventureWorksDW.Temp_Producto;
DROP TEMPORARY TABLE adventureWorksDW.Temp_Tiempo;
DROP TEMPORARY TABLE adventureWorksDW.Temp_Territory;
DROP TEMPORARY TABLE adventureWorksDW.Temp_Cliente;
DROP TEMPORARY TABLE adw.Temp_Ventas;