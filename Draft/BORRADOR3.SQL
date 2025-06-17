


	--	1:26 MIN
	select  sucPais, sucRegion, sucTerritorio, sucSucursal, 0 VtaCat, 0 ClientesCat,
	SUM(case when opeclave = 10 then uniUnidades else 0 end) Ventas, sum(case when opeclave = 13 then uniUnidades * -1 else uniUnidades end) VtaNet,
	COUNT(distinct A.cliClave) Clientes, cliPorcentajeDescuento,fecAnioAndrea, fecSemanaAndrea, fecAnioSemAndrea
	from 
			BDC.dbo.opeUnidadesXClienteXProducto A
		inner join  BDC.dbo.catProducto B on A.prdclave = B.prdClave
		inner join  BDC.dbo.catAcuerdos C on B.prdAcuerdo = C.acuClave 
		inner join  BDC.dbo.catFechas D on A.fecClave = D.fecClave 
		inner join  BDC.dbo.catSucursal F on A.ccvClave = F.ccvClave
		inner join  Temporales.dbo.tb_Alternativas_Out3 G on a.prdClave = G.cPrdClave
		inner join  Operacion.dbo.tb_OrigenesCDR2_TOTALCDs H on A.sucClave = H.cUDNSolicitante
		inner join BDC.dbo.catCliente I on A.sucClave = I.sucClave and A.cliClave = I.cliClave
		where A.opeClave in (10,13) and motClave not in (5) and fecAnioSemAndrea >= (select aniosem from consol2012.dbo.SEMANAS where cast(GETDATE() - 28 as date) between desde and hasta) 
		and F.sucTerceros = 0  and A.sucClave in (375,413)
		and uniUnidades > 0 and F.paiClave = 1
		group by  sucPais, sucRegion, sucTerritorio, sucSucursal, cliPorcentajeDescuento,fecAnioAndrea, fecSemanaAndrea, fecAnioSemAndrea


	SELECT TOP 3 * FROM [CONSOLIDADO_DIARIO].[dbo].[DIARIO_CLIENTE]

SELECT  sucPais, sucRegion, sucTerritorio, sucSucursal, 0 VtaCat, 0 ClientesCat,
	SUM(VENTAS) Ventas, sum(VENTAS - CAMBIOS) VtaNet,
	COUNT(distinct A.cliClave) Clientes, cliPorcentajeDescuento, 
	fecAnioAndrea, fecSemanaAndrea, (fecAnioAndrea * 100 + fecSemanaAndrea) as fecAnioSemAndrea
FROM [CONSOLIDADO_DIARIO].[dbo].[DIARIO_CLIENTE] as A
LEFT JOIN BDC.dbo.catSucursal as B on B.sucClave = A.sucClave
LEFT JOIN BDC.dbo.catCliente as C on C.cliClave = A.cliClave and C.sucClave = A.sucClave
WHERE
	fecAnioSemAndrea >= (SELECT aniosem FROM consol2012.dbo.SEMANAS WHERE CAST(GETDATE() - 28 AS DATE) BETWEEN desde AND hasta)
	AND B.sucTerceros = 0
	AND A.sucClave IN (375, 413)
	AND VENTAS > 0
	AND B.paiClave = 1
	AND A.prdClave IN (SELECT cPrdClave	FROM Temporales.dbo.tb_Alternativas_Out3)
	AND A.sucClave IN (SELECT cUDNSolicitante FROM Operacion.dbo.tb_OrigenesCDR2_TOTALCDs)
GROUP BY
	sucPais, sucRegion, sucTerritorio, sucSucursal, cliPorcentajeDescuento, 
	fecAnioAndrea, fecSemanaAndrea




select I.sucSucursal CDR, F.sucPais, fecAnioAndrea, fecSemanaAndrea, D.fecClave, B.prdCode, D.fecPrefijoDiaSEmana, SUM(atnUnidades) Negados 
from BDC.dbo.opeAtencionPedidosXCliente A 
inner join BDC.dbo.catProducto B on A.prdclave = B.prdClave 
inner join 
	BDC.dbo.catAcuerdos C
on B.prdAcuerdo = C.acuClave 
inner join 
	BDC.dbo.catFechas D
on A.fecClave = D.fecClave 
inner join 
	BDC.dbo.catSucursal F
on A.sucPide = F.sucClave
inner join 
	Temporales.dbo.tb_Alternativas_Out3 G
on a.prdClave = G.cPrdClave
inner join 
	Temporales.dbo.tb_OrigenesCDR2 H
on A.sucPide = H.cUDNSolicitante
inner join 
	BDC.dbo.catSucursal I
on H.Origen = I.sucClave 
where fecAnioSemAndrea >= (select aniosem from consol2012.dbo.vwFecha) and atnEstatus = 'NEGADO' and atnTipoNegado = 'PRIMARIO'  and F.paiClave = 1
group by I.sucSucursal, F.sucPais, fecAnioAndrea, fecSemanaAndrea, D.fecClave, B.prdCode, D.fecPrefijoDiaSEmana


select I.sucSucursal CDR, F.sucPais, fecAnioAndrea, fecSemanaAndrea, D.fecClave, B.prdCode, D.fecPrefijoDiaSEmana, SUM(atnUnidades) Negados 
from BDC.dbo.opeAtencionPedidosXCliente A 
inner join BDC.dbo.catProducto B on A.prdclave = B.prdClave 
inner join BDC.dbo.catAcuerdos C on B.prdAcuerdo = C.acuClave
inner join BDC.dbo.catFechas D on A.fecClave = D.fecClave
inner join BDC.dbo.catSucursal F on A.sucPide = F.sucClave
inner join Temporales.dbo.tb_Alternativas_Out3 G on a.prdClave = G.cPrdClave
inner join Temporales.dbo.tb_OrigenesCDR2 H on A.sucPide = H.cUDNSolicitante
inner join BDC.dbo.catSucursal I on H.Origen = I.sucClave
where fecAnioSemAndrea >= (select aniosem from consol2012.dbo.vwFecha)
and atnEstatus = 'NEGADO' and atnTipoNegado = 'PRIMARIO' and F.paiClave = 1
group by I.sucSucursal, F.sucPais, fecAnioAndrea, fecSemanaAndrea, D.fecClave, B.prdCode, D.fecPrefijoDiaSEmana;