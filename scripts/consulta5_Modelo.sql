SELECT 
    dt.Ano,
    SUM(DISTINCT fv.Valor) AS VentasTotales
FROM adventureWorksDW.Fact_Ventas fv
JOIN adventureWorksDW.Dim_Tiempo dt ON fv.Tiempo_key = dt.Tiempo_key
GROUP BY dt.Ano;
