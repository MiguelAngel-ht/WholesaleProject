
-- BASE DE BUSQUEDA

select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'GARDINI'

-- Minimos	Maximos
-- 2021-08-20	2024-12-10

-- PRUEBA

--  94

SELECT SUM(Cantidad) as Cantidad
--select Code, Cantidad, ValorUnitario, ImporteSnIVA, FechaRegistro, Folio, FormaPago, Anio, Cliente, CostoFca
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'GARDINI'
and Anio = 2024
and code = '2943329'
and FechaRegistro = '2024-05-14'




-- 94



/*  ---------------------------------------------------------------------------------------------------------------------

            C O N S U L T A S       F I N A L 

----------------------------------------------------------------------------------------------------------------------  */


SELECT movClave, sum(moaPares)
FROM BDC.dbo.opeMovimientosAlmacen as A
WHERE 
	fecClave = 20240513  -- between 20240501 and 20240514
    AND prdClave in (select prdClave from BDC.dbo.catProducto where prdCode in ('2943329'))
group by movClave
    
    and movClave = 6
    and sucClave = 111


SELECT * FROM BDC.dbo.catCliente
where cliNombre like '%GARDINI%'





