





-- IF OBJECT_ID('') IS NOT NULL Drop Table ;


Declare @sem1 as varchar(5), @sem2 as varchar(5), @sem3 as varchar(5), @sem4 as varchar(5), 
    --@semDemanda as varchar(150), @semNegados as nvarchar(150), @CDR as nvarchar(3), @semOrden as varchar(100), @fecMaxInvCDR as int,
	@AnioSemana as varchar(6), @semDemandaInsert as nvarchar(150), @fecInicial as int

Select @sem4 = 'sem' + (select RIGHT('0' + CAST(semana as varchar),2)
    from Consol2012.dbo.vwFecha)
Select @sem3 = 'sem' + (select RIGHT('0' + CAST(semana as varchar),2)
    from Consol2012.dbo.semanas
    where cast(GETDATE()-14 as date) between desde and hasta)
Select @sem2 = 'sem' + (select RIGHT('0' + CAST(semana as varchar),2)
    from Consol2012.dbo.semanas
    where cast(GETDATE()-21 as date) between desde and hasta)
Select @sem1 = 'sem' + (select RIGHT('0' + CAST(semana as varchar),2)
    from Consol2012.dbo.semanas
    where cast(GETDATE()-28 as date) between desde and hasta)
select @AnioSemana = aniosem, @fecInicial = convert(varchar, desde, 112)
from Consol2012.dbo.semanas
where cast(GETDATE()-28 as date) between desde and hasta

Set @semDemandaInsert = 'isnull('+@sem1+',0) DemSem1, isnull('+@sem2+',0) DemSem2, isnull('+@sem3+',0) DemSem3, isnull('+@sem4+',0) DemSem4'

-- verifica variables
Select @sem1, @sem2, @sem3, @sem4, @AnioSemana, @fecInicial, @semDemandaInsert


IF OBJECT_ID('Temporales.dbo.tb_Stock_Negados') IS NOT NULL Drop Table Temporales.dbo.tb_Stock_Negados;

select *
into Temporales.dbo.tb_Stock_Negados
from
    BDC.dbo.opeAtencionPedidosXCliente A
where  atnEstatus = 'NEGADO' and atnTipoNegado = 'PRIMARIO' and fecClave >= @fecInicial





If exists (select *
from temporales.sys.objects
where name = 'sas_DemandaReal_Calzado') 
Drop Table Temporales.dbo.sas_DemandaReal_Calzado

exec('select Origen, paiClave, prdClave, talClave,   
'+@semDemandaInsert+'
into Temporales.dbo.sas_DemandaReal_Calzado
	from 
		(select Origen, paiClave, ''sem'' + Right(''0'' + cast(fecSemanaAndrea as varchar),2) Semana,  prdClave, talClave, Ventas + Negados Demanda from 
			(select Origen, paiclave, fecAnioAndrea, fecSemanaAndrea, A.prdClave, talClave, SUM(uniUnidades) Ventas, 0 Negados from 
				BDC.dbo.opeUnidadesXClienteXProducto A
			inner join 
				BDC.dbo.catProducto B
			on A.prdclave = B.prdClave 
			inner join 
				BDC.dbo.catAcuerdos C
			on B.prdAcuerdo = C.acuClave 
			inner join 
				BDC.dbo.catFechas D
			on A.fecClave = D.fecClave 
			inner join 
				Operacion.dbo.tb_OrigenesCDR E
			on A.sucClave = E.cUDNSolicitante
			inner join 
				BDC.dbo.catSucursal F
			on A.sucClave = F.sucClave 
			where A.opeClave = 10 and B.tprClave = 1 and fecAnioSemAndrea >= '+@AnioSemana+' and sucTerceros = 0
			--cliClave not in (''0200058740'',''1044545460'',''0200284730'',''1044544870'',''1045300260'') 
			group by Origen, paiClave, fecAnioAndrea, fecSemanaAndrea, A.prdClave, talClave

			UNION ALL

			select Origen, paiclave, fecAnioAndrea, fecSemanaAndrea, A.prdClave, talClave, 0 Venta, SUM(atnUnidades) Negados from 
				Temporales.dbo.tb_Stock_Negados A
			inner join 
				BDC.dbo.catProducto B
			on A.prdclave = B.prdClave 
			inner join 
				BDC.dbo.catAcuerdos C
			on B.prdAcuerdo = C.acuClave 
			inner join 
				BDC.dbo.catFechas D
			on A.fecClave = D.fecClave 
			inner join 
				Operacion.dbo.tb_OrigenesCDR E
			on A.sucPide = E.cUDNSolicitante
			inner join 
				BDC.dbo.catSucursal F
			on A.sucPide = F.sucClave
			where B.tprClave = 1 and fecAnioSemAndrea >= '+@AnioSemana+' and atnEstatus = ''NEGADO'' and atnTipoNegado = ''PRIMARIO''
			group by Origen, paiclave, fecAnioAndrea, fecSemanaAndrea, A.prdClave, talClave
			
			UNION ALL

			--NEGADOS DE CLIENTES DE CALL CENTER INTERNACIONAL QUE PIDE A BAJIO
			select 926 Origen, 1 paiclave, fecAnioAndrea, fecSemanaAndrea, A.prdClave, talClave, 0 Venta, SUM(atnUnidades) Negados from 
				Temporales.dbo.tb_Stock_Negados A
			inner join 
				BDC.dbo.catProducto B
			on A.prdclave = B.prdClave 
			inner join 
				BDC.dbo.catAcuerdos C
			on B.prdAcuerdo = C.acuClave 
			inner join 
				BDC.dbo.catFechas D
			on A.fecClave = D.fecClave 
			inner join 
				[10.16.32.33].SIA0413.dbo.cClientes E
			on A.cliClave = E.cCliClave
			where A.sucClave = 413 and E.cCliOrigen = 926 and B.tprClave = 1 and fecAnioSemAndrea >= '+@AnioSemana+' and atnEstatus = ''NEGADO'' and atnTipoNegado = ''PRIMARIO''
			group by fecAnioAndrea, fecSemanaAndrea, A.prdClave, talClave
			
			) as A) as A
		PIVOT
			(sum(Demanda) for Semana in (['+@sem1+'],['+@sem2+'],['+@sem3+'],['+@sem4+'])) B')
















--Sureste
select proAlias2,    Origen,    CodBarras,    TipoProducto,    Genero,    Marca,    cltLineaSEC,    cltProductoSEC,    cltSegmentoSEc,    cltForma,
    A.prdAcuerdo,    MedPromo,    A.prdClave,    A.talClave,    Code,    Talla,    Alternativa,    Exporta,    Visibilidad,    prdPrecioCosto,
    Round(prdPrecioVenta / 1.16, 2) PreVentaSIVA,    prdPorcentajeDescuento,
    Round(
        (
            (prdPrecioVenta / 1.16) - (prdPrecioVenta / 1.16) * (prdPorcentajeDescuento / 100.0)
        ) - prdPrecioCosto,
        2
    ) Margen,
    isnull(Multi.mulCantidad, 0) Multiplo,
    isnull(Multi.mulMinimo, 0) Minimo,
    '925' UDN,
    'SURESTE' CDR,
    DemSurSem1,    DemSurSem2,    DemSurSem3,    DemSurSem4,    DemSurSem5,    NegSurSem1,    NegSurSem2,    NegSurSem3,    NegSurSem4,
    NegSurSem5,    PedSurSem4,    PedSurSem5,    isnull(CSur.Clasificacion, 'C') ClasSureste,    SatSurSem1,    SatSurSem2,    SatSurSem3,
    SatSurSem4,    SatSurSem5,    StSureste,
    Round(
        Case
            when round(isnull(ProySureste, 0), 0) = 0 Then StSureste
            Else StSureste / round(isnull(ProySureste * 1.0, 0), 0)
        End * 4,
        0
    ) SemanasStkSur,
    Case
        when Round(
            Case
                when round(isnull(ProySureste, 0), 0) = 0 Then StSureste
                Else StSureste / round(isnull(ProySureste * 1.0, 0), 0)
            End * 4,
            0
        ) between (
            Select Minimo
            from Operacion.dbo.tb_FactoresStock
            where sucOrigen = 111
                and sucDestino = 925
        )
        and (
            Select Maximo
            from Operacion.dbo.tb_FactoresStock
            where sucOrigen = 111
                and sucDestino = 925
        ) Then 'Dentro'
        Else Case
            when Round(
                Case
                    when round(isnull(ProySureste, 0), 0) = 0 Then StSureste
                    Else StSureste / round(isnull(ProySureste * 1.0, 0), 0)
                End * 4,
                0
            ) < (
                Select Minimo
                from Operacion.dbo.tb_FactoresStock AA
                where Case
                        when CD like '%Alpha%' Then 111
                        Else 81
                    End = AA.sucOrigen
                    and sucDestino = 925
            ) Then 'Fuera-'
            Else 'Fuera+'
        End
    End EstatusStkSur,
    Round(
        round(isnull(ProySureste * 1.0, 0), 0) * (
            Select Minimo
            from Operacion.dbo.tb_FactoresStock AA
            where Case
                    when CD like '%Alpha%' Then 111
                    Else 81
                End = AA.sucOrigen
                and sucDestino = 925
        ) / 4,
        0
    ) SurMin,
    Round(
        round(isnull(ProySureste * 1.0, 0), 0) * (
            Select Maximo
            from Operacion.dbo.tb_FactoresStock AA
            where Case
                    when CD like '%Alpha%' Then 111
                    Else 81
                End = AA.sucOrigen
                and sucDestino = 925
        ) / 4,
        0
    ) SurMax,
    InvSureste,
    TranSureste,
    ProySureste ProySur,
    Round(
        Case
            when round(isnull(ProySureste, 0), 0) = 0 Then (InvSureste + TranSureste)
            Else (InvSureste + TranSureste) / round(isnull(ProySureste * 1.0, 0), 0)
        End * 4,
        0
    ) SemanasSur,
    Case
        when Round(
            Case
                when round(isnull(ProySureste, 0), 0) = 0 Then (InvSureste + TranSureste)
                Else (InvSureste + TranSureste) / round(isnull(ProySureste * 1.0, 0), 0)
            End * 4,
            0
        ) between (
            Select Minimo
            from Operacion.dbo.tb_FactoresStock
            where sucOrigen = 111
                and sucDestino = 925
        )
        and (
            Select Maximo
            from Operacion.dbo.tb_FactoresStock
            where sucOrigen = 111
                and sucDestino = 925
        ) Then 'Dentro'
        Else Case
            when Round(
                Case
                    when round(isnull(ProySureste, 0), 0) = 0 Then (InvSureste + TranSureste)
                    Else (InvSureste + TranSureste) / round(isnull(ProySureste * 1.0, 0), 0)
                End * 4,
                0
            ) < (
                Select Minimo
                from Operacion.dbo.tb_FactoresStock AA
                where Case
                        when CD like '%Alpha%' Then 111
                        Else 81
                    End = AA.sucOrigen
                    and sucDestino = 925
            ) Then 'Fuera-'
            Else 'Fuera+'
        End
    End EstatusSur,
    OtrasSureste,
    ReservadoSureste
from Temporales.dbo.asignacion_stock A
    left join BDC.dbo.catClasificacionTecnica B on a.prdclave = B.prdClave
    inner join BDC.dbo.catProducto C on A.prdclave = c.prdClave
    left join Temporales.dbo.tb_ClasificacionABCDemanda CSur on CSur.sucClave = 925 and A.prdClave = CSur.prdClave and A.talClave = CSur.talClave
    left join BDC.dbo.catMultiplo Multi on C.prdClave = Multi.prdClave
where proAlias2 <> 'MUESTRa' --and A.prdAcuerdo <> 'PR'



















