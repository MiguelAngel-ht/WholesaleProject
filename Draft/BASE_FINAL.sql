
/* ---------------------------------------------------------------------------------

                    C O P P E L

*/----------------------------------------------------------------------------------


SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
        sucCLave = 111
        and moaUbicacionOrigen IN (66) -- COPPEL
        and movClave = 6
	group by 
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




/* ---------------------------------------------------------------------------------

                    S E A R S

*/----------------------------------------------------------------------------------



SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
        sucCLave = 111
        and moaUbicacionOrigen IN (54)  -- SEARS
	    and movClave = 6
	group by 
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




/* ---------------------------------------------------------------------------------

                    F A S H I O N     D E P O T

*/----------------------------------------------------------------------------------







/* ---------------------------------------------------------------------------------

                    G E N O V A

*/----------------------------------------------------------------------------------



SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
		movClave = 6
		AND sucClave = 111
		AND moaUbicacionOrigen = 69  -- GENOVA
	group by 
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







/* ---------------------------------------------------------------------------------

                    T I E N D A S    C O N     M O D A

*/----------------------------------------------------------------------------------



SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
		movClave = 6
		AND sucClave = 111
		AND moaUbicacionOrigen = 68  -- TIENDAS CON MODA
	group by 
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




/* ---------------------------------------------------------------------------------

                    C O C A R O

*/----------------------------------------------------------------------------------













/* ---------------------------------------------------------------------------------

                    M O R E L O S

*/----------------------------------------------------------------------------------




SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
		movClave = 6
		AND sucClave = 111
		AND moaUbicacionOrigen = 70  -- MORELOS
	group by 
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







/* ---------------------------------------------------------------------------------

                    G A R D I N I

*/----------------------------------------------------------------------------------



SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
	SELECT	
        moaUbicacionOrigen, movClave, sucClave, sucOrigenDestino, estClave, fecClave, moaUbicacionDestino,
		moaFolio, moaReferencia, prdClave, talClave, SUM(moaPares) as Unidades
	FROM 
		BDC.dbo.opeMovimientosAlmacen
	WHERE 
		movClave = 6
		AND sucClave = 111
		AND moaUbicacionOrigen = 71  -- GARDINI
	group by 
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
order by 
    A.fecClave, A.prdClave, A.talClave



/* ---------------------------------------------------------------------------------

                    I N T E G R A 

*/----------------------------------------------------------------------------------





SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
	SELECT	
        moaUbicacionOrigen, movClave, sucClave, sucOrigenDestino, estClave, fecClave, moaUbicacionDestino,
		moaFolio, moaReferencia, prdClave, talClave, SUM(moaPares) as Unidades
	FROM 
		BDC.dbo.opeMovimientosAlmacen
	WHERE 
		movClave = 6
		AND sucClave = 111
		AND moaUbicacionOrigen = 67  -- INTEGRA (MACY)
	group by 
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
order by 
    A.fecClave, A.prdClave, A.talClave





/* ---------------------------------------------------------------------------------

                    N U E V O    M U N D O

*/----------------------------------------------------------------------------------










/* ---------------------------------------------------------------------------------

                    S E D U C T A

*/----------------------------------------------------------------------------------



If OBJECT_ID('Tempdb..#TMPfOLIOS') IS NOT NULL Drop Table #TMPfOLIOS

select distinct mMvAFolio 
INTO #TMPfOLIOS
from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%'


SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
		fecClave between 20240101 and  20250101
		AND movClave = 6
		AND sucClave = 111
		AND moaUbicacionDestino = 0
		AND moaFolio in (select distinct mMvAFolio from #TMPfOLIOS)  -- SEDUCTA
	group by 
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















-- TODOS UNIDOS

SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  
    A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, 
    A.moaUbicacionOrigen as nUbicacion,
	H.ubiDescripcion as Ubicacion, 
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
        sucCLave = 111
        and moaUbicacionOrigen IN (66, 54, 68, 69, 70, 71) -- COPPEL, SEARS, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI
        and movClave = 6
	group by 
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


