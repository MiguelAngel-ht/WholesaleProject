

SELECT* FROM [10.16.32.149].[mvi_ip].dbo.Mvi_cProveedores
WHERE cPrvNombre LIKE '%INTEGRA%'

--cPrvRFC	cPrvClaveFab	cPrvNombre	cPrvAlias
--IGP100211IP7 	P04-000080	INTEGRA GLOBAL PACKAGING S.A. DE C.V.	INTEGRA                     


select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'INTEGRA'

--Minimos	Maximos
--2024-09-10	2024-12-17

select distinct FechaRegistro from NuevosCanales.dbo.HistClientesOCV_P where Cliente = 'INTEGRA'

select sum(Cantidad)
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'INTEGRA'
AND FechaRegistro = '2024-12-17'
AND Code = '2679761'



-- UBICACION
SELECT * FROM BDC.dbo.catUbicacion
where ubiClave = 67 and sucClave = 111

-- BUSCAR ESTOS AQUI

SELECT prdCode, sum(moaPares) Cantidad
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catProducto as B on A.prdClave = B.prdClave
WHERE 
	fecClave between 20240901 and 20241231
	and fecClave <> 20241023
    --AND prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('2679761'))
	and sucClave = 111
	and movClave = 6
	and moaUbicacionOrigen = 67
    and tprClave = 1
    and prdCode in (Select distinct Code from NuevosCanales.dbo.HistClientesOCV_P where Cliente = 'INTEGRA')
GROUP BY prdCode


select Code, CONVERT(INT, sum(Cantidad)) Cantidad
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'INTEGRA'
group by Code




-- DEFINITIVOOO  ----------------------------

SELECT prdCode,
	--	Salidas menos Ajustes
	SUM((CASE WHEN movClave = 6 and moaUbicacionOrigen = 67 THEN moaPares ELSE 0 END) - (CASE WHEN movClave = 9 and moaUbicacionDestino = 67 THEN moaPares ELSE 0 END))
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catProducto as B on A.prdClave = B.prdClave
WHERE 
	fecClave between 20240901 and 20241231
	and fecClave <> 20241023
    --AND prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('2679761'))
	and sucClave = 111
	and movClave in (9, 6)
	and (moaUbicacionDestino = 67 or moaUbicacionOrigen = 67)
	--and moaUbicacionDestino = 67
	and prdCode = '3592342'
    --and prdCode in (Select distinct Code from NuevosCanales.dbo.HistClientesOCV_P where Cliente = 'INTEGRA')
GROUP BY prdCode--, movClave, moaFolio
Order by 1

