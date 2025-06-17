

-- 0.504  posible factor de precio

select Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'SEDUCTA'
and Anio = 2024
--and code = '2571348'
and code = '3348208'
and FechaRegistro = '2024-10-24'

/*  Fecha en el momento de 2024-10-22   */
SELECT * FROM BDC.dbo.hisProducto
WHERE prdCode = '3348208'
and 20241022 between fecInicialSubrogada and fecFinalSubrogada



/*       CONSULTA DE OBTENCIÓN     */


select distinct mMvAFolio 
INTO #TMPfOLIOS
from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%'

SELECT 
    SUM(moaPares) as Unidades
FROM BDC.dbo.opeMovimientosAlmacen
WHERE 
    fecClave between 20250101 and 20250430
    AND movClave = 6
    AND sucClave = 111
    AND moaUbicacionDestino = 0
	AND moaFolio in (select distinct mMvAFolio from #TMPfOLIOS)

-- VALIDACION VERSUS
-- 2024 - 2025
-- 2231 - 684
-- 2231 - 684

SELECT SUM(Cantidad) as Cantidad
FROM NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'SEDUCTA'
and Anio = 2024






/*
		C O N S U L T A    D E     C E R T I F I C A C I O N

*/



SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, G.estDescripcion as Estatus,
	A.moaFolio, A.moaReferencia, A.prdClave as Producto, 
	C.prdModelo as Modelo, C.prdColor as Color, 
	C.prdMaterial as Material, D.talClave as ClaveTalla,
	D.talDescripcion as Talla, A.Unidades as Unidades

FROM (

SELECT moaUbicacionOrigen, movClave, sucClave, 
    sucOrigenDestino, estClave, fecClave, moaUbicacionDestino,
    moaFolio, moaReferencia, prdClave, talClave, 
    SUM(moaPares) as Unidades
FROM BDC.dbo.opeMovimientosAlmacen
WHERE 
    fecClave between 20241001 and 20250131
    AND movClave = 6
    AND sucClave = 111
    AND moaUbicacionDestino = 0
    AND moaUbicacionOrigen in (18, 39)
GROUP BY 
    moaUbicacionOrigen, movClave, sucClave, 
    moaUbicacionDestino, estClave, fecClave,
    moaFolio, moaReferencia, prdClave, talClave,
    sucOrigenDestino

) AS A
LEFT JOIN BDC.dbo.catFechas as B on A.fecClave = B.fecClave
LEFT JOIN BDC.dbo.catProducto as C on A.prdClave = C.prdClave
LEFT JOIN BDC.dbo.catTallas as D on A.talClave = D.talClave
LEFT JOIN BDC.dbo.catMovimientoAlmacen as E on A.movClave = E.movClave and A.sucClave = E.sucClave
LEFT JOIN BDC.dbo.catSucursal as F on A.sucClave = F.sucClave
LEFT JOIN BDC.dbo.catSucursal as FF on A.sucOrigenDestino = FF.sucClave
LEFT JOIN BDC.dbo.catEstatusMovimientoAlmacen as G on A.estClave = G.estClave and A.sucClave = G.sucClave
LEFT JOIN BDC.dbo.catUbicacion as H on A.moaUbicacionOrigen = H.ubiClave and A.sucClave = H.sucClave
order by A.fecClave, A.prdClave, A.talClave


union all


-- OCACION ESPECIAL

SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, G.estDescripcion as Estatus,
	A.moaFolio, A.moaReferencia, A.prdClave as Producto, 
	C.prdModelo as Modelo, C.prdColor as Color, 
	C.prdMaterial as Material, D.talClave as ClaveTalla,
	D.talDescripcion as Talla, A.Unidades as Unidades

FROM (

SELECT moaUbicacionOrigen, movClave, sucClave, 
    sucOrigenDestino, estClave, fecClave, moaUbicacionDestino,
    moaFolio, moaReferencia, prdClave, talClave, 
    SUM(moaPares) as Unidades
FROM BDC.dbo.opeMovimientosAlmacen
WHERE 
    fecClave = 20241218 
	and moaReferencia = ''
	and movClave = 6
	and sucOrigenDestino = 111
	and moaUbicacionOrigen = 60
	and estClave = 3
	and LEFT(moaHora,2) = 14
GROUP BY 
    moaUbicacionOrigen, movClave, sucClave, 
    moaUbicacionDestino, estClave, fecClave,
    moaFolio, moaReferencia, prdClave, talClave,
    sucOrigenDestino

) AS A
LEFT JOIN BDC.dbo.catFechas as B on A.fecClave = B.fecClave
LEFT JOIN BDC.dbo.catProducto as C on A.prdClave = C.prdClave
LEFT JOIN BDC.dbo.catTallas as D on A.talClave = D.talClave
LEFT JOIN BDC.dbo.catMovimientoAlmacen as E on A.movClave = E.movClave and A.sucClave = E.sucClave
LEFT JOIN BDC.dbo.catSucursal as F on A.sucClave = F.sucClave
LEFT JOIN BDC.dbo.catSucursal as FF on A.sucOrigenDestino = FF.sucClave
LEFT JOIN BDC.dbo.catEstatusMovimientoAlmacen as G on A.estClave = G.estClave and A.sucClave = G.sucClave
LEFT JOIN BDC.dbo.catUbicacion as H on A.moaUbicacionOrigen = H.ubiClave and A.sucClave = H.sucClave
order by A.fecClave, A.prdClave, A.talClave



