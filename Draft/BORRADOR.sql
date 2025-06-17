

/*	    C A M B I O S 		*/

-- If exists (select * from Temporales_RESP.sys.objects where name = 'TempOperacion')  drop table Temporales_RESP.dbo.TempOperacion
If OBJECT_ID('Temporales_RESP.dbo.TempOperacion') IS NOT NULL Drop Table Temporales_RESP.dbo.TempOperacion
	

SELECT 
	A.fecCLave,	A.sucCLave, A.prdCLave,	A.talCLave, C.prdPrecioCosto, C.prdPrecioVenta,
	C.prdPorcentajeDescuento, C.prdAcuerdo,	0 as Ventas, sum(A.uniUnidades) as Cambios, 0 as Negados
INTO 
	Temporales_RESP.dbo.TempOperacion	
FROM 
	BDC.dbo.opeUnidadesxClientexProducto as A
Inner join BDC.dbo.hisSucursal as B on A.sucClave = B.sucClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada 
Left join BDC.dbo.hisProductoInternacional as C on A.prdClave = C.prdClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada and C.paiClave = B.paiClave --and  C.tprClave in (1,11,4,14,7,18,8,26,29,32)
Left Join BDC.dbo.catTipoProducto as D on D.tprClave = C.tprClave
WHERE 
	A.opeClave = 13
	and A.motClave <> 5
	and B.sucCD = 0
	and B.sucCDR = 0
	and D.tprGenero = 1
	and A.fecClave between (select desde from Temporales_RESP.dbo.ORA_FechaProcesoInsumos) 
		and (select hasta from Temporales_RESP.dbo.ORA_FechaProcesoInsumos)
	and A.cliClave not in (select * from Consol2012.dbo.tb_ClavesRCs)  ------ se quitan claves de mayoristas y RCS

	and A.sucClave in (100, 240, 300, 520, 625, 700) -- PRUEBA

GROUP BY 
	A.fecCLave,	A.sucCLave, A.prdCLave,	A.talCLave, C.prdPrecioCosto, C.prdPrecioVenta,	C.prdPorcentajeDescuento, C.prdAcuerdo



/*	    P E D I D O S		*/

If OBJECT_ID('Temporales_RESP.dbo.TempPedidos') IS NOT NULL Drop Table Temporales_RESP.dbo.TempPedidos


SELECT A.fecClave, A.sucPide as sucClave,  A.prdClave, A.talClave, C.prdPrecioCosto, C.prdPrecioVenta, C.prdPorcentajeDescuento, C.prdAcuerdo,  -- A.cliClave,
        SUM(A.pedUnidades) AS VENTAS, 0 AS Cambios, 0 AS Negados
FROM
    BDC.dbo.opePedidosXCliente as A
INNER JOIN BDC.dbo.hisSucursal as B on A.sucPide = B.sucClave and A.fecClave between B.fecInicialSubrogada and B.fecFinalSubrogada
LEFT JOIN BDC.dbo.hisProductoInternacional as C on C.prdClave = A.prdClave and A.fecClave between C.fecInicialSubrogada and C.fecFinalSubrogada and C.paiClave = B.paiClave --and  C.tprClave in (1,11,4,14,7,18,8,26,29,32)
LEFT JOIN BDC.dbo.catTipoProducto as D on D.tprClave = C.tprClave
WHERE 
    A.opeClave = 10
    and A.pedEstatus not in ('EN BUSQUED', 'RECHAZADA', 'RESURTIDA', 'RESURTIDO')
    and B.sucCD = 0
    and B.sucCDR = 0
    and D.tprGenero = 1
    and A.fecClave between (SELECT desde FROM Temporales_RESP.dbo.ORA_FechaProcesoInsumos) 
        and (SELECT hasta FROM Temporales_RESP.dbo.ORA_FechaProcesoInsumos)
    and A.cliClave not in (SELECT * FROM Consol2012.dbo.tb_ClavesRCs)  -- se quitan claves de mayoristas y RCS
    and not (A.sucPide = 375 and A.pedReferencia = 'AB' and A.pedEstatus = 'CANCELADA')

    and A.sucPide in (100, 240, 300, 520, 625, 700) -- PRUEBA

GROUP BY 
    A.fecClave, A.sucPide, A.prdClave, A.talClave, B.prdPrecioCosto, B.prdPrecioVenta, B.prdPorcentajeDescuento, B.prdAcuerdo  --  A.cliClave,





/*  N E G A D O S   */

IF OBJECT_ID('Temporales_RESP.dbo.TempNegados') IS NOT NULL DROP TABLE Temporales_RESP.dbo.TempNegados

SELECT A.fecClave, A.sucPide as sucClave, A.prdClave, A.talClave, C.prdPrecioCosto, C.prdPrecioVenta, C.prdPorcentajeDescuento, C.prdAcuerdo,
    0 as Ventas, 0 as Cambios, SUM(A.atnUnidades) AS Negados
INTO Temporales_RESP.dbo.TempNegados
FROM BDC.dbo.opeAtencionPedidosXCliente AS A
INNER JOIN BDC.dbo.hisSucursal AS B ON A.sucPide = B.sucClave AND A.fecClave BETWEEN B.fecInicialSubrogada AND B.fecFinalSubrogada
LEFT JOIN BDC.dbo.hisProductoInternacional AS C ON C.prdClave = A.prdClave AND A.fecClave BETWEEN C.fecInicialSubrogada AND C.fecFinalSubrogada AND C.paiClave = B.paiClave --and  C.tprClave in (1,11,4,14,7,18,8,26,29,32)
LEFT JOIN BDC.dbo.catTipoProducto AS D ON D.tprClave = C.tprClave
WHERE 
    A.opeClave = 68
    and A.atnEstatus = 'NEGADO'
    and A.atnTipoNegado = 'PRIMARIO'
    and B.sucCD = 0
    and B.sucCDR = 0
    and D.tprGenero = 1
    and A.fecClave BETWEEN (SELECT desde FROM Temporales_RESP.dbo.ORA_FechaProcesoInsumos) 
        and (SELECT hasta FROM Temporales_RESP.dbo.ORA_FechaProcesoInsumos)
    and A.cliClave NOT IN (SELECT * FROM Consol2012.dbo.tb_ClavesRCs)  -- se quitan claves de mayoristas y RCS

    and A.sucClave in (100, 240, 300, 520, 625, 700) -- PRUEBA

GROUP BY
    A.fecClave, A.sucPide, A.prdClave, A.talClave, C.prdPrecioCosto, C.prdPrecioVenta, C.prdPorcentajeDescuento, C.prdAcuerdo




--  CONSOLIDACIÓN

IF OBJECT_ID('Temporales_RESP.dbo.TempOperacioDemanda') IS NOT NULL Drop Table Temporales_RESP.dbo.TempOperacioDemanda

SELECT 
    A.fecClave, A.sucClave, A.prdClave, A.talClave, A.prdPrecioCosto, A.prdPrecioVenta, A.prdPorcentajeDescuento, A.prdAcuerdo,
    SUM(A.Ventas) AS Ventas, SUM(A.Cambios) AS Cambios, SUM(A.Negados) AS Negados
INTO Temporales_RESP.dbo.TempOperacioDemanda
FROM (
    ---Operacion
	 SELECT * FROM  Temporales_RESP.dbo.TempOperacion 
     
     Union all
	---Pedidos
	 SELECT * FROM Temporales_RESP.dbo.TempPedidos 
     
     union all
	---Negados
	 SELECT * FROM Temporales_RESP.dbo.TempNegados

) AS A
GROUP BY 
    A.fecClave, A.sucClave, A.prdClave, A.talClave, A.prdPrecioCosto, A.prdPrecioVenta, A.prdPorcentajeDescuento, A.prdAcuerdo;





--------------Crea estructura INSUMO

IF OBJECT_ID('Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_PEDIDOS', 'U') IS NOT NULL
    DROP TABLE Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_PEDIDOS;
GO

SELECT
    A.fecClave                          AS FECHA_INICIO_PERIODO,
    A.sucClave                          AS ID_SUCURSAL,
    A.cliClave                          AS ID_CLIENTE,
    A.prdClave                          AS ID_PRODUCTO,
    A.talClave                          AS ID_TALLA,
    A.prdPrecioCosto                    AS PRODUCTO_COSTO, 
    A.prdPrecioVenta                    AS PRODUCTO_PREVENTA,
    A.prdPorcentajeDescuento            AS PRODUCTO_PCTDESC,
    A.prdAcuerdo                        AS INDICADOR_ESTATUS_PRODUCTO,
    A.Ventas                            AS VENTAS,
    A.Cambios                           AS CAMBIOS,
    A.Negados                           AS NEGADOS,
    D.CANTIDAD_DEMANDADA                AS CANTIDAD_DEMANDADA
INTO Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_PEDIDOS
FROM Temporales_RESP.dbo.TempOperacioDemanda AS A
CROSS APPLY (           -- PARA CALCULAR CANTIDAD_DEMANDADA UNA SOLA VEZ
    SELECT SEGUIMIENTO_CATALOGOS.dbo.fn_DemandaAjustada(
               A.Ventas - A.Cambios,
               A.Negados
           )
) AS D(CANTIDAD_DEMANDADA)
WHERE 
    A.Ventas <> 0
    OR A.Cambios <> 0
    OR A.Negados <> 0
    OR D.CANTIDAD_DEMANDADA <> 0;


-- borrado de tablas temporales

-- mejora

IF OBJECT_ID('Temporales_resp.dbo.TempOperacion') IS NOT NULL DROP TABLE Temporales_resp.dbo.TempOperacion;
IF OBJECT_ID('Temporales_resp.dbo.TempPedidos') IS NOT NULL DROP TABLE Temporales_resp.dbo.TempPedidos;
IF OBJECT_ID('Temporales_resp.dbo.TempNegados') IS NOT NULL DROP TABLE Temporales_resp.dbo.TempNegados;
IF OBJECT_ID('Temporales_resp.dbo.TempOperacioDemanda') IS NOT NULL DROP TABLE Temporales_resp.dbo.TempOperacioDemanda;


-- AGRUPADO

If exists (select * from Temporales_resp.sys.objects where name = 'ORA_DEMANDA_FACT_ULTSEM_CDR')  drop table Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_CDR

select a.FECHA_INICIO_PERIODO,case when a.id_sucursal in (96,408,412,413) then 413 else b.origen end as ID_SUCURSAL,
a.ID_CLIENTE,a.ID_PRODUCTO,a.ID_TALLA,a.PRODUCTO_COSTO,a.PRODUCTO_PREVENTA,a.PRODUCTO_PCTDESC,
a.INDICADOR_ESTATUS_PRODUCTO,a.VENTAS,a.CAMBIOS,a.NEGADOS,a.CANTIDAD_DEMANDADA 
into Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_CDR 
from Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_PEDIDOS as a
inner join 
	temporales_resp.[dbo].[tb_origenesCDR] as b
	on a.id_sucursal= b.UDNSolicitante


-- mejoras

IF OBJECT_ID('Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_CDR', 'U') IS NOT NULL
    DROP TABLE Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_CDR;

SELECT A.FECHA_INICIO_PERIODO,
       A.ID_SUCURSAL,
       -- case when a.id_sucursal in (96,408,412,413) then 413 else b.origen end as ID_SUCURSAL,
       A.ID_CLIENTE,
       A.ID_PRODUCTO,
       A.ID_TALLA,
       A.PRODUCTO_COSTO,
       A.PRODUCTO_PREVENTA,
       A.PRODUCTO_PCTDESC,
       A.INDICADOR_ESTATUS_PRODUCTO,
       A.VENTAS,
       A.CAMBIOS,
       A.NEGADOS,
       A.CANTIDAD_DEMANDADA
INTO Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_CDR
FROM Temporales_resp.dbo.ORA_DEMANDA_FACT_ULTSEM_PEDIDOS AS A

-- agrupar por cdr
-- inner join temporales_resp.[dbo].[tb_origenesCDR] as b	on a.id_sucursal= b.UDNSolicitante



-- LLENADO DE TABLA ORA_DEMANDA_FACT_ULTSEM_CDR_2

TRUNCATE TABLE temporales_resp.dbo.ora_demanda_fact_ultsem_cdr_2


INSERT INTO temporales_resp.dbo.ora_demanda_fact_ultsem_cdr_2

SELECT 
    FECHA_INICIO_PERIODO, ID_SUCURSAL, '0092029270' as ID_CLIENTE, ID_PRODUCTO, ID_TALLA,
    PRODUCTO_COSTO, PRODUCTO_PREVENTA, PRODUCTO_PCTDESC, INDICADOR_ESTATUS_PRODUCTO, 
    sum(VENTAS) as VENTAS, sum(CAMBIOS) as CAMBIOS, sum(NEGADOS) as NEGADOS, sum(CANTIDAD_DEMANDADA) as  CANTIDAD_DEMANDA, 'TC' as TABLA
FROM 
    temporales_resp.dbo.ora_demanda_fact_ultsem_cdr  
GROUP BY 
    FECHA_INICIO_PERIODO, ID_SUCURSAL, ID_PRODUCTO, ID_TALLA, PRODUCTO_COSTO, PRODUCTO_PREVENTA, PRODUCTO_PCTDESC, INDICADOR_ESTATUS_PRODUCTO



-- update temporales_resp.dbo.ora_demanda_fact_ultsem_cdr_2 set ID_SUCURSAL = 625 WHERE ID_SUCURSAL=926
-- update temporales_resp.dbo.ora_demanda_fact_ultsem_cdr_2 set ID_SUCURSAL = 100 WHERE ID_SUCURSAL=928
-- update temporales_resp.dbo.ora_demanda_fact_ultsem_cdr_2 set ID_SUCURSAL = 350 WHERE ID_SUCURSAL=925
-- update temporales_resp.dbo.ora_demanda_fact_ultsem_cdr_2 set ID_SUCURSAL = 520 WHERE ID_SUCURSAL=458



/*  FECHAS */

If OBJECT_ID('Temporales_RESP.dbo.ORA_FechaProcesoInsumos', 'U') IS NOT NULL 
    DROP TABLE Temporales_RESP.dbo.ORA_FechaProcesoInsumos;


DECLARE @Desde varchar(8), @Hasta  varchar(8), @DomingoProx  varchar(8);
set @Desde = 20210101 --(select cast(fecClave as varchar) from bdc.dbo.catFechas where cast(fecFecha as date) = cast(cast(getdate() as datetime) - 7 as date))
set @Hasta = 20250523 --(select cast(fecClave as varchar) from bdc.dbo.catFechas where cast(fecFecha as date) = cast(cast(getdate() as datetime) - 1 as date))
set @DomingoProx = 20250525 --(select cast(fecClave as varchar) from bdc.dbo.catFechas where cast(fecFecha as date) = cast(cast(getdate() as datetime) + 1 as date))
--select @Desde, @Hasta, @DomingoProx

select @Desde as desde, @Hasta as hasta, @DomingoProx as DomingoUniversoAlternativas
into Temporales_RESP.dbo.ORA_FechaProcesoInsumos 
from Operacion.dbo.vwFecha 

