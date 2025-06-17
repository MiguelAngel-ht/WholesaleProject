
-- BASE DE BUSQUEDA

select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'GENOVA'

-- output:
-- Minimos	Maximos
-- 2018-10-18	2025-02-11




select Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'GENOVA'
and Anio = 2024
and code = '2975122'

-- output:
-- Code	Cantidad	ValorUnitario	ImporteSnIVA	FechaRegistro	Folio	FormaPago	Anio	Cliente	CostoFca
-- 2975122	18.00	284.43	5119.74	2024-10-10	50462	99	2024	GENOVA	218.00
-- 2975122	7.00	284.43	1991.01	2024-04-16	48419	99	2024	GENOVA	218.00
-- 2975122	7.00	284.43	1991.01	2024-04-16	48420	99	2024	GENOVA	218.00
-- 2975122	7.00	284.43	1991.01	2024-04-16	48421	99	2024	GENOVA	218.00
-- 2975122	3.00	284.43	853.29	2024-04-16	48422	99	2024	GENOVA	218.00
-- 2975122	3.00	284.431	853.2931	2024-04-16	48423	99	2024	GENOVA	218.00
-- 2975122	7.00	284.43	1991.01	2024-04-16	48424	99	2024	GENOVA	218.00
-- 2975122	5.00	284.43	1422.15	2024-06-26	48719	99	2024	GENOVA	218.00

-- output:
-- Code	Cantidad	ValorUnitario	ImporteSnIVA	FechaRegistro	Folio	FormaPago	Anio	Cliente	CostoFca
-- 2944968	6.00	362.02	2172.12	2025-02-11	51546	99	2025	GENOVA	273.00




/*  ---------------------------------------------------------------------------------------------------------------------

            C O N S U L T A S       F I N A L 

----------------------------------------------------------------------------------------------------------------------  */

-- NOTA: No se tiene la forma de identificar qué producto es de GENOVA ya que con los filtros aparecen de más


SELECT  a.* --A.fecClave, b.prdCode, b.prdPorcentajeDescuento, a.moaPrecioVenta, sum(moaPares) -- A.fecClave, A.prdClave, A.talClave, SUM(A.moaPares) unidades  -- COSTOS Y PRECIOS NO CUADRAN CON EL FACTURADO
FROM  BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.hisProducto as B on B.prdClave = A.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
WHERE 
	A.fecClave between 20241001 and 20241010
    --AND A.prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('2944968'))
    AND movClave = 6
    and moaUbicacionOrigen = 60
    and moaUbicacionDestino = 0
    and sucClave = 111
    and usoClaveAplica = 36030
--    and moaFolio = 938765
-- Group by A.fecClave, b.prdCode, b.prdPorcentajeDescuento, a.moaPrecioVenta


select * from bdc.dbo.catMovimientoAlmacen
where movClave = 6
and sucClave = 111

select * from bdc.dbo.catUbicacion
where ubiClave = 60
and sucClave = 111

-- select mCFDReferencia as mCFDFolioVta, mCFDClaveReceptor, mCFDImporte
-- from [10.16.32.33].SIA0111.dbo.CFD_mComprobantesFiscales 





