

SELECT * FROM [LINK_IN_PES].Inventario.dbo.conciliacion

-- FORMULA PARA OBTENCI�N DE CAMBIOS

SELECT B.fecAnio, B.fecMes, A.fecClave, A.prdClave, sum(A.moaPares) moaPares	
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
		A.movClave = 9
		and A.sucClave = 1
		--and B.fecAnio = 2024
		--and B.fecMes <= 8
		and A.fecClave < 20240901
		and A.prdClave = '711441043'
GROUP BY B.fecAnio, B.fecMes, A.fecClave, A.prdClave

-- revisar
--and sucClave = 639



SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
--LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
	movClave = 9
	and sucOrigenDestino = 111
	--and prdClave = '711441043'
	and fecClave > 20240901
	and moaUbicacionDestino = 67
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave



SELECT * FROM BDC.dbo.catUbicacion Where sucClave = 111 and ubiClave = 18

SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and sucClave = 111
	and fecClave > 20250301
	and moaUbicacionDestino = 70  -- MORELOS
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave







/* ********************************************************************************************************
					
					C A M B I O S 

*********************************************************************************************************** */

-- 2025 MAYO

SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and prdClave = '833801044'
	and sucClave = 639
	and fecClave > 20250401
	--and moaUbicacionDestino = 18
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave
	
-- 2025 ABRIL

SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and prdClave = '870551903'
	and sucClave = 639
	and fecClave between 20250401 and 20250430
	--and moaUbicacionDestino = 18
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave

	
-- 2025 MARZO

SELECT sucClave, movClave, fecClave, prdClave, talClave, moaPares 
FROM BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and prdClave in ('579652147','666571903','760021043','844923085','849723085','857531043','882161394','896144803',
		'084901001','242080201','631530337','666421475','700555154','837490201','856550654','889524803','891061043','896144803')  -- '891061043' se repite hay 1 de más (INVESTIGAR SI HAY AJUSTES DE CAMBIOS)
	and sucClave = 639
	and moaUbicacionDestino = 18
	and fecClave between 20250301 and 20250340



-- 2025 FEBRERO NO HAY

-- 2025 ENERO

SELECT sucClave, movClave, fecClave, prdClave, talClave, moaPares 
FROM BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and prdClave in ('346361903','346364803','680890326','833801044','889514803','894910201','630596398')  -- '680890326' IGUAL DOBLE PERO EN DIFERENTE DÍA
	and sucClave = 639
	and moaUbicacionDestino = 18
	and fecClave between 20250101 and 20250140

-- BUSCAR AJUSTE DE ACTITUD JEJE
select * from BDC.dbo.catProducto where prdClave = '680890326'

SELECT * -- sucClave, movClave, fecClave, prdClave, talClave, moaPares 
FROM BDC.dbo.opeMovimientosAlmacen
WHERE 
	--movClave = 9
	 prdClave in ('346364803')  -- '680890326' IGUAL DOBLE PERO EN DIFERENTE DÍA
	and sucClave = 639
	and moaUbicacionOrigen = 18
	and moaUbicacionDestino = 56
	and fecClave between 20250101 and 20250140
	--and talClave in (27, 29)
	--and moaReferencia in (978591, 980302)


	sucClave	movClave	sucOrigenDestino	almOrigenDestino	moaUbicacionOrigen	moaUbicacionDestino
639	1	639	0	18	56


/*

		A J U S T E S	   D E		S A L I D A S

*/


-- AÑO 2025

-- MORELOS ANIO 2025 MES 3 (ÚNICO)


SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and sucClave = 111
	--and fecClave > 20250301
	and moaUbicacionDestino = 70  -- MORELOS
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave


-- AÑO 2024 

-- MES 12 DIFERENCIA MORELOS
SELECT SUM(moaPares)
FROM (
SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and sucClave = 111
	and fecClave between 20241201 and 20241231
	and moaUbicacionDestino = 60  -- OTROS (MORELOS)
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave
) AS A
-- MES 10 - DIFERENCIA INTEGRA ( SELECT 2381 + (2561 - 2450) )

SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and sucClave = 111
	and moaUbicacionDestino = 67  -- INTEGRA
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave


-- MES 10 - TIENDAS CON MODA

SELECT 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and sucClave = 111
	and moaUbicacionDestino = 60  -- (TIENDAS CON MODA)
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave



SELECT SUM(moaPares) moaPares
FROM (

SELECT *
	/*sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave, sum(moaPares) moaPares*/
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
	movClave = 9
	and sucClave = 111
	and fecClave between 20240401 and 20240531
	and moaUbicacionDestino = 60  -- (TIENDAS CON MODA)
	and prdClave = '870551903'
GROUP BY 
	sucClave, movClave, sucOrigenDestino, almOrigenDestino, 
	moaUbicacionOrigen, moaUbicacionDestino, prdClave, fecClave

) AS A

-- 76
in  ('666624803') 





/*

		S A L D O S

*/


FECHAFACT	CTIPNOMBRE	DESCRIPCION	cGeneroId	Alternativa	Modelo	Color	Material	VIGENCIA	VigenciaNombre	UNIDADES
2025-06-10 00:00:00.000	CALZADO	INFANTIL	3	58522BLSLI	58522	BL	SLI	1	V	124

SELECT * FROM BDC.dbo.catProducto WHERE prdModelo = 58522 and prdColor = 'BL' and prdMaterial = 'SLI'




select * from ML.dbo.tmpFARAtributosProductos

















