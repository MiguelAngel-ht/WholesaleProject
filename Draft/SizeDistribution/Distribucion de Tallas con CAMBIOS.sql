





-- sucClave = 639  -- para cambios 


SELECT * FROM 
(
SELECT sucClave, sucOrigenDestino, moaUbicacionOrigen, movClave, sum(moaPares) moaPares
FROM BDC.dbo.opeMovimientosAlmacen 
WHERE
prdClave = '627480001'
and fecClave between 20241001 and 20241031
and sucOrigenDestino = 590       
--and moaUbicacionOrigen = 17
GROUP BY sucClave, sucOrigenDestino, moaUbicacionOrigen, movClave
) AS A
WHERE moaPares = 10

627480001
627491359




	SELECT * --fecClave, prdClave, moaFolio, sum(moaPares) cam
	FROM BDC.dbo.opeMovimientosAlmacen
	WHERE 
		fecClave between 20241101 and 20241131 --between 20240101 and  (select fecClave from BDC.dbo.catFechas where fecFecha =  CONVERT(DATE, GETDATE()))
		--and prdClave in ('061980171','627431043')
	--GROUP BY fecClave, movClave, prdClave, sucClave,moaUbicacionDestino

		AND movClave = 9
		AND sucClave = 111
		AND moaUbicacionDestino = 67
		AND moaFolio not in (926766, 927182, 927184, 927197, 934335, 941505)   -- SEDUCTA
	GROUP BY fecClave, prdClave, moaFolio





SELECT * FROM BDC.dbo.catUbicacion
where sucClave = 111
and ubiClave  = 70




-- INTEGRA

	-- CAMBIOS 
	SELECT fecClave, moaUbicacionDestino, SUM(moaPares) moaPares
	FROM BDC.dbo.opeMovimientosAlmacen
	WHERE 
		fecClave >= 20240101
		AND movClave = 9
		AND sucClave = 111
		AND moaUbicacionDestino  IN (66, 54, 67, 68, 69, 70, 71, 60)
	GROUP BY fecClave, moaUbicacionDestino
	ORDER BY fecClave, moaUbicacionDestino

	-- VENTAS BRUTAS
	SELECT SUM(moaPares)
	FROM BDC.dbo.opeMovimientosAlmacen
	WHERE 
		fecClave between 20241101 and 20241131 
		AND movClave = 6
		AND sucClave = 111
		AND moaUbicacionOrigen = 67 --67


-- MORELOS

SELECT * 
FROM (
	-- VENTAS BRUTAS
	SELECT 'CENTRO DISTRIBUCI�N ALPHA' UDN, fecClave, CONVERT(VARCHAR, B.prdModelo) + prdColor + prdMaterial as Alternativa,
		moaFolio FolioAlmacen, moaPares, movDescripcion TipoMov		--SUM(moaPares)
	FROM BDC.dbo.opeMovimientosAlmacen as A
	LEFT JOIN BDC.dbo.catProducto as B on B.prdClave = A.prdClave
	LEFT JOIN BDC.dbo.catMovimientoAlmacen as C on C.sucClave = A.sucClave and C.movClave = A.movClave
	WHERE 
		fecClave between 20250301 and 20250331 
		AND A.movClave = 6
		AND A.sucClave = 111
		AND moaUbicacionOrigen = 70			--67

	UNION ALL

	-- CAMBIOS
	SELECT 'CENTRO DISTRIBUCI�N ALPHA' UDN, fecClave, CONVERT(VARCHAR, B.prdModelo) + prdColor + prdMaterial as Alternativa,
		moaFolio FolioAlmacen, moaPares, movDescripcion TipoMov		--SUM(moaPares)
	FROM BDC.dbo.opeMovimientosAlmacen as A
	LEFT JOIN BDC.dbo.catProducto as B on B.prdClave = A.prdClave
	LEFT JOIN BDC.dbo.catMovimientoAlmacen as C on C.sucClave = A.sucClave and C.movClave = A.movClave
	WHERE 
		fecClave between 20250301 and 20250331 
		AND A.movClave = 9
		AND A.sucClave = 111
		AND moaUbicacionDestino = 70	--67

) AS A
ORDER BY fecClave, Alternativa




SELECT * FROM OPERACION.dbo.catContenedor
where id_contenedor = 'TEMU3265499'

-- TABLAS PARA EL HIST�RICO SEM 2

SELECT top 3 * FROM OPERACION.dbo.HistoricoSem2 where tipo = 7
SELECT MAX(FechaFactura) FROM OPERACION.dbo.[FacturasPuenteDepv2]

-- META DATOS CONSOL2012 SUCURSAL


SELECT * FROM CONSOL2012.dbo.Sucursal where clave_suc  in (590, 694, 695, 888)
SELECT * FROM BDC.dbo.catSucursal where sucClave in (590, 694, 695, 888)



-- SEARS, COPPEL, SEDUCTA E INTEGRA NO APLICAN
-- 

-- CAMBIOS COCARO COMPLETOS

SELECT --A.sucClave, SUM(moaPares)
	A.sucClave UDN, fecClave, CONVERT(VARCHAR, B.prdModelo) + prdColor + prdMaterial as Alternativa,
	moaFolio FolioAlmacen, talClave, moaPares, movDescripcion TipoMov		
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catProducto as B on B.prdClave = A.prdClave
LEFT JOIN BDC.dbo.catMovimientoAlmacen as C on C.sucClave = A.sucClave and C.movClave = A.movClave
WHERE 
	fecClave between 20240301 and 20240331 
		AND A.movClave = 9
		AND A.sucClave = 1
		and A.prdClave = '380761487'


-- A�ADIR M�S CAMBIOS


-- GARDINI, GENOVA, INTEGRA, MORELOS, EL NUEVO MUNDO Y TIENDAS CON MODA

SELECT --A.sucClave, SUM(moaPares)
	A.sucClave UDN, fecClave, A.prdClave, --, CONVERT(VARCHAR, B.prdModelo) + prdColor + prdMaterial as Alternativa,
	moaFolio FolioAlmacen, talClave, moaPares, movDescripcion TipoMov		
FROM BDC.dbo.opeMovimientosAlmacen as A
--LEFT JOIN BDC.dbo.catProducto as B on B.prdClave = A.prdClave
LEFT JOIN BDC.dbo.catMovimientoAlmacen as C on C.sucClave = A.sucClave and C.movClave = A.movClave
WHERE 
		A.movClave = 9
		AND A.sucClave = 1
		 



-- HASTA EL MES 9 DEL 2024

SELECT B.fecAnio, B.fecMes, A.fecClave, A.prdClave, sum(A.moaPares) moaPares	
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
		A.movClave = 9
		and A.sucClave = 1
		and B.fecAnio = 2024
		and B.fecMes = 9
GROUP BY B.fecAnio, B.fecMes, A.fecClave, A.prdClave







-- FORMULA PARA OBTENCI�N DE CAMBIOS

SELECT B.fecAnio, B.fecMes, A.fecClave, A.prdClave, sum(A.moaPares) moaPares	
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
		A.movClave = 9
		and A.sucClave = 1
		and B.fecAnio = 2024
		and B.fecMes = 9
GROUP BY B.fecAnio, B.fecMes, A.fecClave, A.prdClave


SELECT sucClave,	movClave,	sucOrigenDestino,	almOrigenDestino,	moaUbicacionOrigen,	moaUbicacionDestino, prdClave, A.fecClave, sum(moaPares) moaPares
FROM BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
		--A.prdClave in ('700555154', '837490201') and 
		B.fecAnioMes = 202409
		and movClave = 9
		and sucClave = 639
GROUP BY sucClave,	movClave,	sucOrigenDestino,	almOrigenDestino,	moaUbicacionOrigen,	moaUbicacionDestino, prdClave, A.fecClave







SELECT distinct tprClave FROM BDC.dbo.catProducto as A
Inner join BDC.dbo.catProveedor as B on B.proClave = A.proClave
Where B.proClave = '0003034925'

SELECT TOP 10 * FROM OPERACION.dbo.HistoricoSem2_linea

SELECT TOP 3 * FROM  LINK_IN_SIACDS.SIACDS.dbo.mOrdenesCompra
SELECT * FROM  LINK_IN_SIACDS.SIACDS.dbo.mOrdenesCompraDetalle 
WHERE mOrDLote = 120 and cprdClave = '639882383'

SELECT * FROM BDC.dbo.catProducto 
where prdModelo = 63988 
and prdColor = 'NE'
and prdMaterial = 'ALE'



SELECT prdClave, prdCode FROM BDC.dbo.catProducto
where prdClave in ('907518449')

SELECT prdClave, prdCode FROM BDC.dbo.catProducto
WHERE PRDCODE IN ('2732947','3587768')

371031487	2732947
847191719	3587768

select min(fecClave) from CONSOLIDADO_DIARIO.dbo.Diario_cliente
where prdClave = '847191719'


With catFechas as (

	SELECT * FROM  BDC.dbo.catFechas
	WHERE fecAnio >= 2018
)


SELECT	
	fecAnio, fecMes, A.fecClave, 'SEDUCTA' Cliente, A.prdClave, talClave, sum(moaPares) as uni --) as Unidades
FROM 
	BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN catFechas as B on B.fecClave = A.fecClave
WHERE 
	A.fecClave > 20240101 --and (select fecClave from BDC.dbo.catFechas where fecFecha =  CONVERT(DATE, GETDATE()))
	AND movClave = 6
	AND sucClave = 111
	AND moaUbicacionDestino = 0
	AND moaUbicacionOrigen <> 72
	AND moaFolio in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
	--and fecMes = 10 --	and prdClave = '008624803' and fecAnio >= 2024
Group by fecAnio, fecMes, A.fecClave, A.prdClave, talClave

UNION ALL

SELECT 
	fecAnio, 
	fecMes, 
	A.fecClave,
	CASE 
		WHEN moaUbicacionOrigen = 66 THEN 'COPPEL'
		WHEN moaUbicacionOrigen = 54 THEN 'SEARS'
		WHEN moaUbicacionOrigen = 67 THEN 'INTEGRA'
		WHEN moaUbicacionOrigen = 68 THEN 'TIENDAS CON MODA'
		WHEN moaUbicacionOrigen = 69 THEN 'GENOVA'
		WHEN moaUbicacionOrigen = 70 THEN 'ZAPATERIA MORELOS'
		WHEN moaUbicacionOrigen = 71 THEN 'GARDINI'
		WHEN moaUbicacionOrigen = 72 THEN 'SEDUCTA'
		WHEN moaUbicacionOrigen = 60 THEN 'OTROS'
	ELSE
		''
	END as Cliente, 
	A.prdClave, 
	talClave, 
	sum(moaPares) as uni
FROM 
	Temporales.dbo.MIGUEL_opeMovimientosAlmacenMov6 as A
LEFT JOIN catFechas as B on B.fecClave = A.fecClave
WHERE 
	sucCLave = 111
	and movClave = 6
	and A.fecClave > 20240101
	and moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71, 72, 60) -- COPPEL, SEARS, INTEGRA, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI, SEDUCTA, GEN�RICO
	and moaFolio not in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
	--and fecAnio >= 2024
group by 
	fecAnio, fecMes, A.fecClave, A.prdClave, moaUbicacionOrigen, talClave





