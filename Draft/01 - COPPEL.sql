

-- select * from bdc.dbo.opeMovimientosAlmacen where moaUbicacionOrigen = 66 



select a.sucClave,D.sucSucursal,c.movDescripcion,sucOrigenDestino,E.sucSucursal, fecCLave,moaUbicacionOrigen,B.ubiDescripcion,moaUbicacionDestino,
A.estClave,F.estDescripcion,moaFolio,moaReferencia, sum(moaPares)moaPares from bdc.dbo.opeMovimientosAlmacen as A
Inner Join
	bdc.dbo.catUbicacion as B
On A.sucCLave = B.sucCLave and A.moaUbicacionOrigen = b.ubiCLave
Inner Join
	bdc.[dbo].[catMovimientoAlmacen] as c
On A.sucCLave = C.sucCLave and A.movClave = C.movClave
Left Join	
	bdc.dbo.catSucursal as D
On A.sucClave = D.sucClave
Left Join	
	bdc.dbo.catSucursal as E
On A.sucOrigenDestino = e.sucClave
Left Join
	bdc.[dbo].[catEstatusMovimientoAlmacen] as F
On A.sucCLave = F.sucCLave and A.estClave = F.estClave
where A.sucCLave=111 and moaUbicacionOrigen=66 and fecCLave >= 20230101 and A.movCLave=6
group by a.sucClave,D.sucSucursal,c.movDescripcion,sucOrigenDestino,E.sucSucursal, fecCLave,moaUbicacionOrigen,B.ubiDescripcion,moaUbicacionDestino,
a.estClave,F.estDescripcion,moaFolio,moaReferencia



/*

select * from bdc.[dbo].[catEstatusMovimientoAlmacen]
select * from CONSOL2012.dbo.SUCURSAL order by 1

select I.fecAnio,I.fecMes,i.FecFecha,I.fecAnioSemandrea,a.sucClave,D.sucSucursal,c.movDescripcion,sucOrigenDestino,E.sucSucursal,moaUbicacionOrigen,B.ubiDescripcion,
F.estDescripcion,moaFolio,moaReferencia,a.prdClave,H.prdModelo,H.prdColor,H.prdMaterial,a.TalClave,talDescripcion, sum(moaPares)moaPares from bdc.dbo.opeMovimientosAlmacen as A
Inner Join
	bdc.dbo.catUbicacion as B
On A.sucCLave = B.sucCLave and A.moaUbicacionOrigen = b.ubiCLave
Inner Join
	bdc.[dbo].[catMovimientoAlmacen] as c
On A.sucCLave = C.sucCLave and A.movClave = C.movClave
Left Join	
	bdc.dbo.catSucursal as D
On A.sucClave = D.sucClave
Left Join	
	bdc.dbo.catSucursal as E
On A.sucOrigenDestino = e.sucClave
Left Join
	bdc.[dbo].[catEstatusMovimientoAlmacen] as F
On A.sucCLave = F.sucCLave and A.estClave = F.estClave
Left Join
	bdc.dbo.catTallas as G
On A.talCLave = G.talcLave
Left Join
	bdc.dbo.catProducto as H
On A.prdCLave = H.prdCLave
Left Join
	bdc.dbo.catFechas as I
On A.fecCLave = I.fecCLave
where A.sucCLave=111 and moaUbicacionOrigen=66 and a.fecCLave>=20240901 and A.movCLave=6
group by I.fecAnio,I.fecMes,i.FecFecha,I.fecAnioSemandrea,a.sucClave,D.sucSucursal,c.movDescripcion,sucOrigenDestino,E.sucSucursal,moaUbicacionOrigen,B.ubiDescripcion
,F.estDescripcion,moaFolio,moaReferencia,a.prdClave,H.prdModelo,H.prdColor,H.prdMaterial,A.TalClave,talDescripcion

*/







-- ope = 42
SELECT * FROM BDC.dbo.catOperativa
where opeTablaInterna = 'opeMovimientosAlmacen'



/*COSMOS_Para SCI, SSI, Call Center y USA*/  
select a.mVtaFecha as vtaFecha, CLAVE_SUCURSAL as sucClave, a.cCliClave as cliClave, b.cPrdClave as prdClave, b.cTalClave as talClave,
	a.cTraClave, b.dVtaPares as vtaUnidades, 0 as cMotClave, a.mVtaHora as uniHora, CONVERT(VARCHAR, mVtaFecha, 112) fecClave --cast((cast(YEAR(a.mVtaFecha) as VARCHAR(4)) + stuff('00',3-len(cast(MONTH(a.mVtaFecha) as VARCHAR(2))),2,cast(MONTH(a.mVtaFecha) as VARCHAR(2))) + stuff('00',3-len(cast(DAY(a.mVtaFecha) as VARCHAR(2))),2,cast(DAY(a.mVtaFecha) as VARCHAR(2)))) as int) as fecClave
	,0 as defClave, a.mVtaFolio as uniFolio, a.cEmpClave as empClave, a.CentroCosto as ccvClave, b.cGenId as genClave, 
	b.cAcuVigencia as acuVigencia, 0 as uniFolioVenta, isnull(cIdFClave,0) as fisClave, isnull(cPrdConsignacion,0) as prdConsignacion   
	
from 
	([SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.mventas as a 
inner join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.dventas as b on a.mVtaFolio = b.mVtaFolio 
left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.dventasImpuestos as c on b.mVtaFolio=c.mVtaFolio and b.cPrdClave = c.cPrdClave and b.cTalClave = c.cTalClave and b.rCodClave = c.rCodClave and b.cPrmClave = c.cPrmClave)   
inner join (select empClave from BDC.dbo.catEmpresas where empConsolida=1) as z on a.cEmpClave=z.empClave  
where 
	a.mVtaFecha between 'FECHA_INICIAL' and 'FECHA_FINAL'  
	and a.mVtaActivo=1  

-- 33 Y 130

SELECT TOP 3 CONVERT(INT, CONVERT(varchar, mVtaFecha, 112)) fecClave
FROM [10.16.32.33].SIA0100.dbo.mventas


/*
sucClave	sucSucursal	movDescripcion	sucOrigenDestino	sucSucursal	moaUbicacionOrigen	ubiDescripcion	moaUbicacionDestino	estClave	estDescripcion	moaFolio	moaReferencia	moaPares
111	CENTRO DISTRIBUCI�N ALPHA	SALIDA CONSUMO INTERNO	111	CENTRO DISTRIBUCI�N ALPHA	66	COPPEL	0	3	RECIBIDA	921910		2122
111	CENTRO DISTRIBUCI�N ALPHA	SALIDA CONSUMO INTERNO	111	CENTRO DISTRIBUCI�N ALPHA	66	COPPEL	0	3	RECIBIDA	921911		546
111	CENTRO DISTRIBUCI�N ALPHA	SALIDA CONSUMO INTERNO	111	CENTRO DISTRIBUCI�N ALPHA	66	COPPEL	0	3	RECIBIDA	921912		857
*/




select IP_SERVIDOR, clave_suc from CONSOL2012.dbo.Sucursal where clave_suc = 111





select 
	a.mMvAFechaAplica as moaFecha,
    111 as sucClave,
    a.cMovClave as movClave,
    cast(a.cUdnClaveOriDes as int) as sucOrigenDestino,
    0 as almOrigenDestino,
    a.cUbiClaveOrigen as moaUbicacionOrigen,
    a.cUbiClaveDestino as moaUbicacionDestino,
	a.mMvAEstatus as mMvAEstatus,
    b.cPrdClave as prdClave,
    b.ctalClave as talClave,
    b.dMvAPares as moaPares,
    b.dMvAPrecioCompra as moaPrecioCompra,
    b.dMvAPrecioVenta as moaPrecioVenta,
    a.mMvAReferencia as moaReferencia,
    a.mMvAHoraAplica as moaHora,
	CONVERT(INT, CONVERT(varchar, a.mMvAFechaAplica, 112)) as fecClave,
    a.mMvAFolio as moaFolio,
    a.cUsuClaveAplica as usoClaveAplica,
    --isnull(A.mMvAProductoExcedente, 0) moaProductoExcedente,
	0 as moaProductoExcedente,
    A.mMvAObservaciones as moaObservaciones
from 
	[10.16.32.33].SIA0111.dbo.mMovAlmacen as a
inner join 
	[10.16.32.33].SIA0111.dbo.dMovAlmacen as b on a.mMvAFolio = b.mMvAFolio
where 
	a.mMvAFechaAplica between CONVERT(DATE, '2024-09-05') and CONVERT(DATE, '2024-09-05')
	and a.cUbiClaveOrigen = 66
	and cMovClave = 6


A.sucCLave=111 and moaUbicacionOrigen=66 and fecCLave>=20240901 and A.movCLave=6



20240905
SELECT TOP 3 * FROM [10.16.32.33].SIA0111.dbo.mMovAlmacen
where mMvAFechaAplica between '2020-12-17 00:00:00' AndreaPremiaETL 
	between CONVERT(DATE, '2020-06-29') and CONVERT(DATE, '2020-07-01')












/*

		C O N S U L T A    D E     C E R T I F I C A C I O N

*/



-- toma solo lo necesario de A

SELECT fecAnio, fecMes, 'COPPEL' Cliente, sum(Unidades) Unidades
FROM (
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
from BDC.dbo.opeMovimientosAlmacen
where 
	fecClave >= 20230101
	and sucCLave = 111
	and moaUbicacionOrigen IN (66)
	and movClave = 6
group by moaUbicacionOrigen, movClave, sucClave, 
	moaUbicacionDestino, estClave, fecClave,
	moaFolio, moaReferencia, prdClave, talClave,
	sucOrigenDestino
) AS A
LEFT JOIN BDC.dbo.catFechas 	as B on A.fecClave = B.fecClave
LEFT JOIN BDC.dbo.catProducto 	as C on A.prdClave = C.prdClave
LEFT JOIN BDC.dbo.catTallas 	as D on A.talClave = D.talClave
LEFT JOIN BDC.dbo.catMovimientoAlmacen as E on A.movClave = E.movClave and A.sucClave = E.sucClave
LEFT JOIN BDC.dbo.catSucursal 	as F on A.sucClave = F.sucClave
LEFT JOIN BDC.dbo.catSucursal 	as FF on A.sucOrigenDestino = FF.sucClave
LEFT JOIN BDC.dbo.catEstatusMovimientoAlmacen as G on A.estClave = G.estClave and A.sucClave = G.sucClave
LEFT JOIN BDC.dbo.catUbicacion 	as H on A.moaUbicacionOrigen = H.ubiClave and A.sucClave = H.sucClave
order by A.fecClave, A.prdClave, A.talClave

) as A
GROUP BY fecAnio, fecMes










-- 2025-01-21
-- 2025-02-17
-- 2025-01-20

--24,142
--140,801

-- select sum(Cantidad) as Cantidad
-- from NuevosCanales.dbo.HistClientesOCV_P
-- where Cliente = 'COPPEL'
-- and Anio = 2024
-- and FechaRegistro >= '2024-08-01'







