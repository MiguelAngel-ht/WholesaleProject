
-- BASE DE BUSQUEDA

select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'COCARO'

--DE 2018 HASTA 2023


-- PRUEBA

select Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'COCARO'
and Anio = 2023
and code = '2760087'
and FechaRegistro = '2023-08-18'

--202

/*  ---------------------------------------------------------------------------------------------------------------------

            C O N S U L T A S       F I N A L 

----------------------------------------------------------------------------------------------------------------------  */

-- NOTA: LOS FILTROS SON LOS MISMOS QUE GENOVA Y TIENDAS CON MODA SA DE CV

--202

SELECT fecClave, sum(moaPares) pares-- a.* --A.fecClave, b.prdCode, b.prdPorcentajeDescuento, a.moaPrecioVenta, sum(moaPares) -- A.fecClave, A.prdClave, A.talClave, SUM(A.moaPares) unidades  -- COSTOS Y PRECIOS NO CUADRAN CON EL FACTURADO
FROM  BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN BDC.dbo.hisProducto as B on B.prdClave = A.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
WHERE 
	A.fecClave between 20230801 and 20230818
    AND A.prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('2760087'))
    AND movClave = 6
    and moaUbicacionOrigen = 60
    and moaUbicacionDestino = 0
    and sucClave = 111
    and usoClaveAplica = 36030
GROUP by fecClave


-- EMBONA CON LA DE