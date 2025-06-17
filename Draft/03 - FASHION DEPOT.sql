

select distinct Cliente from NuevosCanales.dbo.HistClientesOCV_P

-- COCARO
-- COPPEL
-- EL NUEVO MUNDO
-- FASHION DEPOT
-- GARDINI
-- GENOVA
-- INTEGRA
-- SEARS
-- SEDUCTA
-- TIENDAS CON MODA SA DE CV
-- ZAPATERIA MORELOS


select * from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'FASHION DEPOT'
and CODE = '2869728'
and Anio = 2022



select distinct Cliente, Anio from NuevosCanales.dbo.HistClientesOCV_P
order by Cliente, Anio


SELECT A.fecClave, A.prdClave, A.talClave, SUM(A.moaPares) unidades  -- COSTOS Y PRECIOS NO CUADRAN CON EL FACTURADO
FROM  BDC.dbo.opeMovimientosAlmacen as A
--LEFT JOIN BDC.dbo.hisProducto as B on B.prdClave = A.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
WHERE 
	A.moaUbicacionOrigen IN (51, 54)
	AND A.fecClave between 202101 and 20220201
	AND A.prdClave in (select prdClave from BDC.dbo.catProducto where prdCode =  '2869728')
group by A.fecClave, A.prdClave, A.talClave
order by A.prdClave, A.talClave


-- 20230102

select distinct sucClave from BDC.dbo.opeMovimientosAlmacen 

select min(fecClave) from BDC.dbo.hisMovimientosAlmacen 


SELECT * FROM BDC.dbo.catOperativa 
where opeTablaInterna = 'opeMovimientosAlmacen'


select a.mMvAFechaAplica as moaFecha,CLAVE_SUCURSAL as sucClave,a.cMovClave as movClave,cast(a.cUdnClaveOriDes as int) as sucOrigenDestino,0 as almOrigenDestino,
a.cUbiClaveOrigen as moaUbicacionOrigen,  a.cUbiClaveDestino as moaUbicacionDestino,case when CLAVE_SUCURSAL in (128,129,304) then 3 else a.mMvAEstatus end as mMvAEstatus,b.cPrdClave as prdClave,b.ctalClave as talClave,b.dMvAPares as moaPares,  b.dMvAPrecioCompra as moaPrecioCompra,b.dMvAPrecioVenta as moaPrecioVenta,a.mMvAReferencia as moaReferencia,a.mMvAHoraAplica as moaHora,  cast((cast(YEAR(a.mMvAFechaAplica) as VARCHAR(4)) + stuff('00',3-len(cast(MONTH(a.mMvAFechaAplica) as VARCHAR(2))),2,cast(MONTH(a.mMvAFechaAplica) as VARCHAR(2))) + stuff('00',3-len(cast(DAY(a.mMvAFechaAplica) as VARCHAR(2))),2,cast(DAY(a.mMvAFechaAplica) as VARCHAR(2)))) as int) as fecClave,  a.mMvAFolio as moaFolio,a.cUsuClaveAplica as usoClaveAplica,isnull(A.mMvAProductoExcedente,0)moaProductoExcedente, A.mMvAObservaciones as moaObservaciones  from    [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.mMovAlmacen as a   
inner join    [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.dMovAlmacen as b   on (a.mMvAFolio=b.mMvAFolio)  where a.mMvAFechaAplica between 'FECHA_INICIAL' and 'FECHA_FINAL'


select  min(mMvAFechaAplica) from [10.16.32.33].SIA0111.dbo.mMovAlmacen



select * from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'SEDUCTA'
and Anio = 2024


SELECT* FROM [10.16.32.149].[mvi_ip].dbo.Mvi_cProveedores
WHERE cPrvNombre LIKE '%DEPOT%'
-- cPrvRFC	cPrvClaveFab	cPrvNombre
-- FDE070316AS9 	P04-000110	FASHION DEPOT S.A DE C.V.






