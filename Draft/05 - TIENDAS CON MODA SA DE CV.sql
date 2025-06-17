
-- BASE DE BUSQUEDA

select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'TIENDAS CON MODA SA DE CV'


-- PRUEBA

select Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'TIENDAS CON MODA SA DE CV'
and Anio = 2025
and code = '3332702'


--output:
-- Code	Cantidad	ValorUnitario	ImporteSnIVA	FechaRegistro	Folio	FormaPago	Anio	Cliente	CostoFca
-- 3332702	14.00	249.50	3493.00	2025-02-27	51699	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	10.00	249.50	2495.00	2025-02-27	51700	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	14.00	249.50	3493.00	2025-02-27	51701	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	10.00	249.50	2495.00	2025-02-27	51702	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	10.00	249.50	2495.00	2025-02-27	51703	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	10.00	249.50	2495.00	2025-02-27	51704	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	10.00	249.50	2495.00	2025-02-27	51705	99	2025	TIENDAS CON MODA SA DE CV	166.87
-- 3332702	10.00	249.50	2495.00	2025-02-27	51706	99	2025	TIENDAS CON MODA SA DE CV	166.87

-- total cantidad: 88.00


SELECT prdCode, talClave, sum(moaPares) --A.fecClave, b.prdCode, b.prdPorcentajeDescuento, a.moaPrecioVenta, sum(moaPares) -- A.fecClave, A.prdClave, A.talClave, SUM(A.moaPares) unidades  -- COSTOS Y PRECIOS NO CUADRAN CON EL FACTURADO
FROM  BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.hisProducto as B on B.prdClave = A.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
WHERE 
	A.fecClave between 20250201 and 20250227
    AND A.prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('3332702'))
    AND movClave = 6
    and moaUbicacionOrigen = 60
    and moaUbicacionDestino = 0
    and sucClave = 111
    and usoClaveAplica = 36030
GROUP BY prdCode, talClave
ORDER BY prdCode, talClave

--18 + 26 + 26 + 18 = 88.00

-- CUADRA PERO ES LA MISMA CONSULTA QUE GENOVA!



prdClave	talClave	Ventas	CAMBIOS	UnidadesNetas	Importes	Inventario	Negados
846075092	29	0	0	0	0.000000	6	0

SELECT * FROM Temporales_RESP.dbo.OperacionPromLocal























