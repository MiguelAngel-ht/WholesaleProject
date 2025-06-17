

-- CONSULTA DE CERTIFICACIÓN

SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	(CASE WHEN A.moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71) THEN H.ubiDescripcion ELSE 'SEDUCTA' END) as Ubicacion, 
    G.estDescripcion as Estatus,
	A.moaFolio, A.moaReferencia,
    A.prdClave as Producto,
	C.prdModelo as Modelo,
    C.prdColor as Color,
	C.prdMaterial as Material,
    D.talClave as ClaveTalla,
	D.talDescripcion as Talla,
    A.Unidades as Unidades
FROM (

	SELECT	moaUbicacionOrigen, movClave, sucClave, sucOrigenDestino, estClave, fecClave, moaUbicacionDestino,
			moaFolio, moaReferencia, prdClave, talClave, SUM(moaPares) as Unidades
	FROM
		BDC.dbo.opeMovimientosAlmacen
	WHERE
		fecClave between 20240101 and (select fecClave from BDC.dbo.catFechas where fecFecha =  CONVERT(DATE, GETDATE()))
		AND movClave = 6
		AND sucClave = 111
		AND moaUbicacionDestino = 0
		AND moaFolio in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')  -- SEDUCTA
	GROUP BY
		moaUbicacionOrigen, movClave, sucClave, moaUbicacionDestino, estClave, fecClave,
		moaFolio, moaReferencia, prdClave, talClave, sucOrigenDestino

	UNION ALL


	SELECT	moaUbicacionOrigen, movClave, sucClave, sucOrigenDestino, estClave, fecClave, moaUbicacionDestino,
			moaFolio, moaReferencia, prdClave, talClave, SUM(moaPares) as Unidades
	FROM 
		BDC.dbo.opeMovimientosAlmacen
	WHERE 
        sucCLave = 111
        and moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71) -- COPPEL, SEARS, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI
        and movClave = 6
	GROUP BY
		moaUbicacionOrigen, movClave, sucClave, moaUbicacionDestino, estClave, fecClave,
		moaFolio, moaReferencia, prdClave, talClave, sucOrigenDestino

) AS A
LEFT JOIN BDC.dbo.catFechas 	                as B on A.fecClave = B.fecClave
LEFT JOIN BDC.dbo.catProducto 	                as C on A.prdClave = C.prdClave
LEFT JOIN BDC.dbo.catTallas 	                as D on A.talClave = D.talClave
LEFT JOIN BDC.dbo.catMovimientoAlmacen          as E on A.movClave = E.movClave and A.sucClave = E.sucClave
LEFT JOIN BDC.dbo.catSucursal 	                as F on A.sucClave = F.sucClave
LEFT JOIN BDC.dbo.catSucursal 	                as FF on A.sucOrigenDestino = FF.sucClave
LEFT JOIN BDC.dbo.catEstatusMovimientoAlmacen   as G on A.estClave = G.estClave and A.sucClave = G.sucClave
LEFT JOIN BDC.dbo.catUbicacion 	                as H on A.moaUbicacionOrigen = H.ubiClave and A.sucClave = H.sucClave
order by A.fecClave, A.prdClave, A.talClave





-- CONSULTA DE CERTIFICACIÓN

SELECT	B.fecAnio,
		B.fecMes,
		(CASE WHEN A.moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71) THEN H.ubiDescripcion ELSE 'SEDUCTA' END) as Cliente, 
		SUM(Unidades) Unidades

FROM (
	SELECT	moaUbicacionOrigen, fecClave, sucClave, SUM(moaPares) as Unidades
	FROM 
		BDC.dbo.opeMovimientosAlmacen
	WHERE 
		fecClave between 20240101 and (select fecClave from BDC.dbo.catFechas where fecFecha =  CONVERT(DATE, GETDATE()))
		AND movClave = 6
		AND sucClave = 111
		AND moaUbicacionDestino = 0
		AND moaFolio in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
	group by 
		moaUbicacionOrigen, fecClave, sucClave

	UNION ALL


	SELECT moaUbicacionOrigen, fecClave, sucClave, SUM(moaPares) as Unidades
	FROM 
		BDC.dbo.opeMovimientosAlmacen
	WHERE 
        sucCLave = 111
        and moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71) -- COPPEL, SEARS, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI
        and movClave = 6
	group by 
		moaUbicacionOrigen, fecClave, sucClave


) as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave
LEFT JOIN BDC.dbo.catUbicacion as H on A.moaUbicacionOrigen = H.ubiClave and A.sucClave = H.sucClave
GROUP BY B.fecAnio, B.fecMes, A.moaUbicacionOrigen, H.ubiDescripcion





-- SOLO SALE (SEARS (ME ENTIENDE))

SELECT fecAnio, fecMes, SUM(Unidades) Unidades
FROM (
SELECT fecClave, SUM(moaPares) Unidades FROM BDC.[dbo].[opeMovimientosAlmacenHis]
WHERE 
    sucCLave = 111
    and moaUbicacionOrigen IN (54) -- COPPEL, SEARS, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI
    and movClave = 6
group by fecClave
) AS A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave
GROUP BY fecAnio, fecMes
ORDER BY fecAnio, fecMes


--COMPARACIÓN CON CONCENTRADO VOC

SELECT Anio, Mes, prdCode, prdModelo, sum(Cantidad) Cantidad
FROM NuevosCanales.dbo.HistClientesOCV_P as A
LEFT JOIN BDC.dbo.catProducto as B on B.prdCode = A.Code
where Cliente = 'GENOVA'
and Anio = 2024
and Mes = 4
and prdModelo = 63381

GROUP BY Anio, Mes, prdCode, prdModelo
ORDER BY Anio, Mes, prdModelo

SELECT * FROM BDC.dbo.catProducto
where prdCode in ('3288344','3288368')


SELECT * FROM [LINK_IN_VARIOS].VFC.dbo.uvwfacturasporPeriodo

SELECT TOP 3 * FROM LINK_IN_WCADMIN.wcAdmin.[dbo].[ProductosXTemporada_ACCESORIOS]

SELECT TOP 3 * FROM LINK_IN_WCADMIN.wcAdmin.[dbo].[ProductosXTemporadaACCESORIO]
SELECT distinct temporada FROM link_in_wcadmin.wcadmin.[dbo].[ProductosXTemporada_Belleza]
select distinct temporada from link_in_wcadmin.wcadmin.dbo.ProductosXTemporada_LentesRelojes_Zona

SELECT TOP 3 * FROM link_in_wcadmin.wcadmin.[dbo].[ProductosXTemporada_LentesRelojes]

SELECT TOP 3 * FROM link_in_wcadmin.wcadmin.[dbo].[vw_InformacionBasica_Accesorios]

-- DIFERENCIA EN ESE MES PORQUE NO CONSIDERA 1 DÍA QUE TUVO MOVIMIENTO 

SELECT fecClave, sum(moaPares) pares FROM BDC.[dbo].[opeMovimientosAlmacenHis]
WHERE 
    sucCLave = 111
    and moaUbicacionOrigen IN (54) -- COPPEL, SEARS, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI
    and movClave = 6
	and fecClave between 20190401 and 20190431
group by fecClave


-- CONSULTA APUNTADA A RESPALDOS

SELECT 
	B.fecAnio, B.fecMes, (CASE WHEN A.cUbiClaveOrigen IN (66, 54, 67, 68, 69, 70, 71) THEN H.ubiDescripcion ELSE 'SEDUCTA' END) as Cliente, SUM(Unidades) as Unidades
FROM (
	SELECT 111 sucClave, cUbiClaveOrigen, CONVERT(VARCHAR, mMvAFechaAplica, 112) fecClave, SUM(mMvAPares) Unidades
	FROM [10.16.32.33].SIA0111.dbo.mMovAlmacen
	WHERE
		cMovClave = 6
		and (cUbiClaveOrigen IN (66, 54, 67, 68, 69, 70, 71)
		or (mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%'))
	GROUP BY cUbiClaveOrigen, mMvAFechaAplica
) AS A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave
LEFT JOIN BDC.dbo.catUbicacion as H on A.cUbiClaveOrigen = H.ubiClave and A.sucClave = H.sucClave
GROUP BY   B.fecAnio, B.fecMes, A.cUbiClaveOrigen, H.ubiDescripcion








/*

	TRATAMIENTO A LOS DEMÁS CANALES ubiClave = 60

*/



SELECT	B.fecAnio,
		B.fecMes,
		H.ubiDescripcion  as Cliente, 
		SUM(Unidades) Unidades

FROM (

	SELECT moaUbicacionOrigen, fecClave, sucClave, SUM(moaPares) as Unidades
	FROM 
		BDC.dbo.opeMovimientosAlmacen
	WHERE 
        sucCLave = 111
        and moaUbicacionOrigen IN (60) -- OTROS

        and movClave = 6
		and fecClave between 20241201 and 20241231
		and moaFolio not in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%') 
	group by 
		moaUbicacionOrigen, fecClave, sucClave


) as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecClave = A.fecClave
LEFT JOIN BDC.dbo.catUbicacion as H on A.moaUbicacionOrigen = H.ubiClave and A.sucClave = H.sucClave
GROUP BY B.fecAnio, B.fecMes, H.ubiDescripcion


If OBJECT_ID('Temporales.dbo.OrdenCompraDetallexxFabricante') IS NOT NULL Drop Table Temporales.dbo.OrdenCompraDetallexxFabricante



select GETDATE() - 10
If OBJECT_ID('Temporales.dbo.tmpPedVigen') IS NOT NULL Drop Table Temporales.dbo.tmpPedVigen

SELECT 
	A.Alternativa, C.prdCode, A.Ref_And, Contenedor, Estatus, B.fecAnioSemAndrea, B.fecFecha, BB.fecFecha as fecFechaZarpe,
	A.proAlias, A.TipoProducto, A.cltMarca, A.Acuerdo, SUM(A.PiezasPedidas) PiezasPedidas
INTO 
	Temporales.dbo.tmpPedVigen
FROM 
	Temporales.dbo.OrdenCompraDetallexxFabricante as A
LEFT JOIN BDC.dbo.catFechas as B on B.fecFecha = CONVERT(DATE, Fec_Arri)
LEFT JOIN BDC.dbo.catFechas as BB on BB.fecFecha = CONVERT(DATE, Fec_Zarpe)
LEFT JOIN BDC.dbo.catProducto as C on CONVERT(VARCHAR, C.prdModelo) + C.prdColor + C.prdMaterial = A.Alternativa
WHERE 
	A.Ref_And <> ''
	and A.Fec_Arri >= GETDATE() - 10
GROUP BY 
	A.Alternativa, C.prdCode, A.Ref_And, Contenedor, Estatus, B.fecAnioSemAndrea, B.fecFecha, BB.fecFecha,
	A.proAlias, A.TipoProducto, A.cltMarca, A.Acuerdo
ORDER BY 
	B.fecFecha, A.Alternativa


If OBJECT_ID('Temporales.dbo.OrdenCompraDetallexxFabricante') IS NOT NULL Drop Table Temporales.dbo.OrdenCompraDetallexxFabricante



SELECT * FROM Temporales.dbo.tmpPedVigen
SELECT top 3 * FROM Temporales.dbo.OrdenCompraDetallexxFabricante

Fec_Zarpe
1900-01-01 00:00:00.000

Rango1	Fraccion1	Rango2	Fraccion2 TipoProducto proAlias
20.0-21	6404119902	17.0-19.5	6404119903


SELECT top 3 * FROM [LINK_IN_SIOS].SIOS.dbo.cProductos
WHERE 






PiezasPedidas
1488

-- NO CUADRA

SELECT Anio, Mes, Cliente, sum(Cantidad) Cantidad
FROM NuevosCanales.dbo.HistClientesOCV_P
where Cliente not in ('SEARS', 'COPPEL', 'INTEGRA', 'SEDUCTA')
and Anio = 2024
and Mes = 12
GROUP BY Anio, Mes, Cliente
ORDER BY Anio, Mes, Cliente


SELECT moaUbicacionOrigen, fecClave, sucClave, SUM(moaPares) as Unidades
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
    sucCLave = 111
    and moaUbicacionOrigen IN (60) -- OTROS

    and movClave = 6
	and fecClave between 20241201 and 20241231
	and moaFolio not in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%') 
group by 
	moaUbicacionOrigen, fecClave, sucClave




SELECT *
FROM 
	BDC.dbo.opeMovimientosAlmacen
WHERE 
    sucCLave = 111
    and moaUbicacionOrigen IN (60) -- OTROS

    and movClave = 6
	and fecClave between 20241201 and 20241231
	and moaFolio not in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%') 


