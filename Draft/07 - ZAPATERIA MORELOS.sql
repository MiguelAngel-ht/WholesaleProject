
-- BASE DE BUSQUEDA

select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'ZAPATERIA MORELOS'

-- Minimos	Maximos
-- 2018-05-28	2024-12-17




SELECT Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'ZAPATERIA MORELOS'
    and Anio = 2024
    and code = '2943329'
    and FechaRegistro = '2024-05-14'



DROP TABLE #temp

SELECT FechaRegistro, Code, sum(Cantidad) cantidad 
into #temp
FROM NuevosCanales.dbo.HistClientesOCV_P
WHERE Cliente = 'ZAPATERIA MORELOS'
and Anio = 2024
GROUP BY FechaRegistro, Code
ORDER BY 1, 2

SELECT DISTINCT FechaRegistro FROM NuevosCanales.dbo.HistClientesOCV_P
WHERE Cliente = 'ZAPATERIA MORELOS'
and Anio = 2024


325.00

SELECT SUM(Cantidad) as cantidad FROM #temp
where FechaRegistro in ('2024-02-27', '2024-02-28')

3618.00
FechaRegistro
2024-01-17
2024-02-27
2024-02-28
2024-04-17
2024-05-14
2024-09-10
2024-10-30
2024-11-11
2024-12-16
2024-12-17


-- 248

SELECT SUM(Cantidad) as cantidad FROM #temp

-- 248

SELECT moaFolio, prdClave, sum(moaPares)
FROM  BDC.dbo.opeMovimientosAlmacen
WHERE 
	fecClave between 20240224 and 20240228
    AND prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in (select code from #temp))
    and sucClave = 111
    and movClave = 6
    and moaUbicacionOrigen = 60
group by moaFolio, prdClave

    and usoClaveAplica = 11024



usoClaveAplica
11024

/*  ---------------------------------------------------------------------------------------------------------------------

            C O N S U L T A S       F I N A L 

----------------------------------------------------------------------------------------------------------------------  */

-- NOTA: 


SELECT SUM(pares) as pares
FROM (
SELECT A.fecClave, A.movClave, C.movDescripcion, sum(moaPares) pares-- a.* --A.fecClave, b.prdCode, b.prdPorcentajeDescuento, a.moaPrecioVenta, sum(moaPares) -- A.fecClave, A.prdClave, A.talClave, SUM(A.moaPares) unidades  -- COSTOS Y PRECIOS NO CUADRAN CON EL FACTURADO
FROM  BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.hisProducto as B on B.prdClave = A.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
LEFT JOIN BDC.dbo.catMovimientoAlmacen as C on C.movClave = A.movClave and C.sucClave = A.sucClave
WHERE 
	A.fecClave between 20241215 and 20241217
    AND A.prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('2947242'))
    --and moaUbicacionOrigen = 60
    --and moaUbicacionDestino = 0
    --and sucClave = 111
    --and usoClaveAplica = 36030
GROUP by A.fecClave, A.movClave, C.movDescripcion
) as A

-- A.fecClavefecClave	movClave	movDescripcion	pares
-- 20240401	6	SALIDA CONSUMO INTERNO	4
-- 20240415	6	SALIDA CONSUMO INTERNO	15
-- 20240503	6	SALIDA CONSUMO INTERNO	4
-- 20240507	13	ENTRADA COMPRA PROVEEDOR	450
-- 20240513	6	SALIDA CONSUMO INTERNO	22

