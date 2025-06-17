
-- BASE DE BUSQUEDA

select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'SEARS'

-- Minimos	Maximos
-- 2018-01-23	2025-02-17


-- CONSULTA DE PRUEBA

select Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'SEARS'
and Anio = 2025
and code = '3351345'
and FechaRegistro = '2025-02-17'







-- 6 


-- UNIDADES SEARS OFICIAL  (POR OPE INVENTARIOS)  - [INVENTARIO SEARS]


SELECT prdClave, talClave, ANTES-DESPUES as venta
FROM (
SELECT 
	prdClave,
	talClave,
	SUM(CASE WHEN fecClave = 20250201 THEN invUnidades ELSE 0 END) ANTES,
	SUM(CASE WHEN fecClave = 20250217 THEN invUnidades ELSE 0 END) DESPUES
FROM BDC.dbo.opeInventarioxProducto
where ubiClave = 54
	and fecClave IN (20250201, 20250217)
	AND prdClave in (select prdClave from BDC.dbo.catProducto where prdCode = '3351345')
GROUP BY prdClave,	talClave
) AS A




-- UNIDADES SEARS OFICIAL  (POR OPE MOVIMIENTOS ALMACEN) - [Venta en Unidades SEARS]

DECLARE @prdCode VARCHAR(7), @fecClave int, @desfase int;
set @prdCode = '3577646'
set @fecClave = 20250319
set @desfase = 1

-- IMPORTANTE !!
-- 	Code		FechaRegistro		Cantidad
-- '3350966' - 20250120 - 4		hasta 4 dIas despues se facturaron
-- '3577646' - 20250319 - 1		al siguiente dia se facturaron
-- '3351345' - 20250217 - 4		hasta 4 dIas despues se facturaron


SELECT A.fecClave, A.prdClave, A.talClave, SUM(A.moaPares) unidades  -- COSTOS Y PRECIOS NO CUADRAN CON EL FACTURADO
FROM  BDC.dbo.opeMovimientosAlmacen as A
--LEFT JOIN BDC.dbo.hisProducto as B on B.prdClave = A.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
WHERE 
	A.moaUbicacionOrigen IN (51, 54)
	AND A.fecClave = (select CONVERT(INT, convert(VARCHAR, fecFecha, 112)) as fecClave from BDC.dbo.catFechas where fecClave = @fecClave-@desfase)
	AND A.prdClave in (select prdClave from BDC.dbo.catProducto where prdCode = @prdCode)
group by A.fecClave, A.prdClave, A.talClave
order by A.prdClave, A.talClave






/*
		C O N S U L T A    D E     C E R T I F I C A C I O N

*/



-- toma solo lo necesario de A

SELECT 
	B.fecAnio, B.fecMes, B.fecFecha, B.fecAnioSemAndrea, 
	A.sucClave as UDNOrigen,
	F.sucSucursal as Origen,
	E.movDescripcion as TipoMovimiento,  A.sucOrigenDestino as UDNDestino,
	FF.sucSucursal as Destino, A.moaUbicacionDestino as nUbicacion,
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
from BDC.dbo.opeMovimientosAlmacen
where 
	fecClave >= 20230101
	and moaUbicacionOrigen IN (51, 54)
	and movClave = 6
group by moaUbicacionOrigen, movClave, sucClave, 
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
LEFT JOIN BDC.dbo.catUbicacion as H on A.moaUbicacionDestino = H.ubiClave and A.sucClave = H.sucClave
order by A.fecClave, A.prdClave, A.talClave


