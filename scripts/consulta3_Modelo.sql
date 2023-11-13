SELECT 
    dt.Mes,
    COUNT(DISTINCT fv.Ventas_key) AS NumeroDeVentas
FROM adventureWorksDW.Fact_Ventas fv
JOIN adventureWorksDW.Dim_Tiempo dt ON fv.Tiempo_key = dt.Tiempo_key
GROUP BY dt.Mes;
