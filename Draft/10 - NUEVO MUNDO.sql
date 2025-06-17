





select MIN(FechaRegistro) as Minimos, MAX(FechaRegistro) as Maximos
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'EL NUEVO MUNDO'
and FechaRegistro = '2024-02-27'


select distinct FechaRegistro
from NuevosCanales.dbo.HistClientesOCV_P
where Cliente = 'EL NUEVO MUNDO'



If OBJECT_ID('Tempdb..#VentaNuevoMundo') IS NOT NULL Drop Table #VentaNuevoMundo

select B.fecClave, C.prdClave, SUM(A.Cantidad) Cantidad
--into #VentaNuevoMundo
from NuevosCanales.dbo.HistClientesOCV_P as A
left join BDC.dbo.catFechas as B on A.FechaRegistro = B.fecFecha
left join BDC.dbo.catProducto as C on C.prdCode = A.CODE and C.regVigente = 1
where A.Cliente = 'EL NUEVO MUNDO'
and fecClave > 20230101
--and A.FechaRegistro = '2024-02-27'
group by  B.fecClave, C.prdClave



SELECT * FROM #VentaNuevoMundo
order by fecClave asc, prdClave desc

If OBJECT_ID('Tempdb..#TemporalVentasInter') IS NOT NULL Drop Table #TemporalVentasInter

SELECT A.fecClave, A.prdClave, SUM(moaPares) as Unidades
INTO #TemporalVentasInter
FROM 
    BDC.dbo.opeMovimientosAlmacen as A
WHERE 
    movClave = 6
    AND sucClave = 111
    --AND A.fecClave = 20240227
    AND moaUbicacionOrigen = 60
    --AND A.prdClave in (Select prdClave from BDC.dbo.catProducto where prdCode in ('2733302', '3033920'))
GROUP BY A.fecClave, A.prdClave


SELECT A.fecClave, A.prdClave, A.Unidades
FROM #TemporalVentasInter AS A
INNER JOIN #VentaNuevoMundo as B on A.prdClave = B.prdClave AND A.fecClave between B.fecClave - 4 and B.fecClave
ORDER BY A.fecClave asc, A.prdClave desc
