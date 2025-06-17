
-- CANTIDAD / CORTE
-- 2866 / 12/05/2025 3:06

--SELECT TOP 3 * FROM VFC.dbo.uvwfacturasporPeriodo
--WHERE DeudorId =  '0003026382' 

-- LLENAR VCF

IF OBJECT_ID('Tempdb..#UUIDCanceladas') IS NOT NULL DROP TABLE #UUIDCanceladas;

SELECT DISTINCT
	UUID,
	SUM(CASE WHEN OPERACION = 'EMISIÓN' THEN UNIDADES ELSE 0 END) EMI,
	SUM(CASE WHEN OPERACION = 'CANCELACIÓN' THEN UNIDADESCAMBIO ELSE 0 END) CAN
INTO #UUIDCanceladas
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Anio >= 2023
	--AND Alternativa = '36959NETEX'
	--AND Cliente LIKE '%NUEVO MUNDO%'
GROUP BY UUID
HAVING
    (SUM(CASE WHEN MOVIMIENTO IN ('VENTA', 'CAMBIO CANCELADO') THEN UNIDADES ELSE 0 END)
    = SUM(CASE WHEN MOVIMIENTO IN ('CAMBIO', 'CANCELACIÓN', 'VENTA CANCELADA')  THEN UNIDADESCAMBIO ELSE 0 END))

-- SELECT DISTINCT MOVIMIENTO FROM VFC.dbo.uvwfacturasporPeriodo

-- SELECT * FROM VFC.dbo.uvwfacturasporPeriodo WHERE UUID = '7ab52d1a-7003-45ff-9e4c-582b61b25dad'
-- SELECT * FROM #ParejasCancelacion WHERE VentaUUID <> CancelUUID

IF OBJECT_ID('Tempdb..#ParejasCancelacion') IS NOT NULL DROP TABLE #ParejasCancelacion;

SELECT DISTINCT
	/*
	V.Alternativa,
	V.DeudorId,
	V.UNIDADES,
	C.UNIDADESCAMBIO,
	*/
    V.UUID      AS VentaUUID,
    C.UUID      AS CancelUUID
INTO #ParejasCancelacion
FROM VFC.dbo.uvwfacturasporPeriodo AS V
JOIN VFC.dbo.uvwfacturasporPeriodo AS C
    ON V.Alternativa  = C.Alternativa      -- misma alternativa
    AND V.DeudorId     = C.DeudorId         -- mismo cliente
    AND V.UNIDADES     = C.UNIDADESCAMBIO   -- mismo número de unidades canceladas
	AND V.UUID			= C.UUID
	AND V.Anio			= C.Anio
WHERE ((V.MOVIMIENTO = 'VENTA' AND C.MOVIMIENTO IN ('VENTA CANCELADA','CANCELACIÓN'))
	OR (V.MOVIMIENTO = 'CAMBIO' AND C.MOVIMIENTO IN ('CAMBIO CANCELADO')))
	AND V.Anio >= 2023
	--AND V.Alternativa = '36959NETEX'
	--AND V.Cliente LIKE '%NUEVO MUNDO%'

	/*  VALIDACIÓN
SELECT SUM(Unidades), SUM(UNIDADESCAMBIO) FROM VFC.dbo.uvwfacturasporPeriodo
WHERE UUID IN (SELECT DISTINCT VentaUUID  FROM #ParejasCancelacion)
      AND UUID IN (SELECT DISTINCT CancelUUID  FROM #ParejasCancelacion)
	  */
--SELECT * FROM #ParejasCancelacion WHERE VentaUUID = CancelUUID
	  

IF OBJECT_ID('Tempdb..#BaseClientes_PREV') IS NOT NULL DROP TABLE #BaseClientes_PREV;

SELECT 
    Anio,
    Mes,
    Modelo,
    Color, 
    Material,
    PrecioVenta,
    --  
    (CASE WHEN MOVIMIENTO = 'VENTA'             THEN UNIDADES      ELSE 0 END)
    - (CASE WHEN MOVIMIENTO = 'CANCELACIÓN'      THEN UNIDADESCAMBIO ELSE 0 END)
    - (CASE WHEN MOVIMIENTO = 'VENTA CANCELADA'  THEN UNIDADESCAMBIO ELSE 0 END)
    AS UNIDADES,
	UNIDADES AS UNIDADESBRUTAS,
    (CASE WHEN MOVIMIENTO = 'CAMBIO' THEN UNIDADESCAMBIO ELSE 0 END) 
	- (CASE WHEN MOVIMIENTO = 'CAMBIO CANCELADO' THEN UNIDADES ELSE 0 END) AS UNIDADESCAMBIO,
    IMPORTE,
    IMPORTECAMBIO,
    CASE
        WHEN DeudorId = '0003002169' THEN 'COPPEL'
        WHEN Cliente LIKE '%SEARS%'  THEN 'SEARS'
        WHEN Cliente LIKE '%DEPOT%'  THEN 'FASHION DEPOT'
        WHEN Cliente LIKE '%COCARO%' THEN 'COCARO'
        WHEN DeudorId = '0003002227' THEN 'TIENDAS CON MODA'
        WHEN Cliente LIKE '%NUEVO MUNDO%' THEN 'NUEVO MUNDO'
        WHEN DeudorId = '0002000040' THEN 'INTEGRA'
        WHEN DeudorId = '0003002222' THEN 'GARDINI'
        WHEN DeudorId = '0003026382' THEN 'SEDUCTA'
        WHEN DeudorId IN ('0003002200','0003002201','0003002211','0003002202','0003002193') THEN 'GENOVA'
        WHEN DeudorId IN (
                '0003002186','0003002187','0003002188','0003002194','0003002195',
                '0003002196','0003002197','0003002198','0003002204','0003002205',
                '0003002206','0003002207','0003002208','0003002209','0003002210',
                '0003002220','0003028866'
        ) THEN 'ZAPATERIA MORELOS'
        ELSE 'OTROS'
    END AS Cliente
INTO #BaseClientes_PREV
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Anio >= 2024
    -- excluimos UUIDs de ambos tipos de cancelaciones
    AND UUID NOT IN (SELECT DISTINCT UUID        FROM #UUIDCanceladas)
    AND UUID NOT IN (SELECT DISTINCT VentaUUID   FROM #ParejasCancelacion)
    AND UUID NOT IN (SELECT DISTINCT CancelUUID  FROM #ParejasCancelacion)
	--AND Alternativa = '36959NETEX'
	--AND Cliente LIKE '%NUEVO MUNDO%'



SELECT SUM(VtaNeta) 
FROM VFC.dbo.FacturasPuenteDepv2
where YEAR(FechaFactura) = 2024

IF OBJECT_ID('Tempdb..#BASE_VFC') IS NOT NULL DROP TABLE #BASE_VFC;

SELECT 
    A.Anio,
    A.Mes,
    A.Cliente,
    B.prdClave,
    SUM(A.UNIDADES)            AS uni,
    SUM(A.UNIDADESBRUTAS)      AS unibru,
    SUM(A.UNIDADESCAMBIO)      AS cam,
    SUM(A.UNIDADES - A.UNIDADESCAMBIO) AS uninet,
    AVG(A.PrecioVenta)         AS preuni,
    SUM(A.IMPORTE)             AS imp
INTO #BASE_VFC
FROM #BaseClientes_PREV AS A
LEFT JOIN [10.16.26.3].BDC.dbo.catProducto AS B
    ON B.prdModelo   = LTRIM(RTRIM(A.Modelo))
   AND B.prdColor    COLLATE SQL_Latin1_General_CP1_CI_AS 
                     = LTRIM(RTRIM(A.Color)) COLLATE SQL_Latin1_General_CP1_CI_AS
   AND B.prdMaterial COLLATE SQL_Latin1_General_CP1_CI_AS 
                     = LTRIM(RTRIM(A.Material)) COLLATE SQL_Latin1_General_CP1_CI_AS
   AND B.regVigente = 1
WHERE A.Cliente <> 'OTROS'
GROUP BY A.Anio, A.Cliente, A.Mes, B.prdClave
ORDER BY A.Anio, A.Mes, A.Cliente, B.prdClave;


SELECT Mes, SUM(uni), sum(cam) FROM #BASE_VFC where cliente = 'COPPEL'
and Anio = 2024
group by Mes
order by Mes

SELECT * FROM #BaseClientes_PREV
WHERE Cliente = 'COPPEL'

-- 140,768 BDC
-- 140,673 VFC
-- 140,642



select * from bdc.dbo.catOperativa 
select top 4 * from bdc.dbo.opeunidadesxclientexproducto






SELECT * FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Cliente LIKE '%NUEVO MUNDO%'
AND ANIO = 2024
AND MES = 1

SELECT *
	--ANIO, UUID, MES, REFERENCIA, NOFACTURA, SUM(UNIDADES), SUM(UNIDADESCAMBIO) 
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Alternativa = '36959NETEX'
	AND Cliente LIKE '%NUEVO MUNDO%'
	AND LEFT(NOFACTURA, 2) = 'AF'
	--AND ANIO >= 2023
GROUP BY ANIO, UUID, MES, REFERENCIA, NOFACTURA
ORDER BY 1

UUID = '65f286cf-108d-4d2e-aba2-e718c94c55b7'



SELECT * FROM #BASE_VFC
WHERE CAM > 0



SELECT * FROM  VFC.dbo.uvwfacturasporPeriodo
WHERE DeudorId = '0003002227'
--AND UNIDADESCAMBIO > 0
--AND ANIO = 2024
--AND MES = 1
AND Referencia = 'ANCORP-11978'

ANCORP-11976
ANCORP-11977
ANCORP-11977
ANCORP-11978
ANCORP-11978
ANCORP-11980
ANCORP-11980

SELECT * FROM #BASE_VFC



-- VALIDACIÓN GENERAL
select ---Cliente, 
sum(uni)
from (
	SELECT Anio, Mes, Cliente, sum(uni) uni 
	FROM #BASE_VFC
	wHERE aNIO * 100 + mes < 202505
	GROUP BY Anio, Mes, Cliente -- ORDER BY Anio, Mes, Cliente
) as a
GROUP BY Cliente

-- 344409 - 171252   -- 155220  -- 326472 -- 326466 - 326497
-- 328740 - 171151   -- 155192  -- 326343 -- 326343 - 

select DeudorId, sum(uni)
from (
SELECT YEAR(FechaFactura) año, MONTH(FechaFactura) mes, DeudorId, sum(Ventas-Cambios) uni --SELECT * 
from VFC.dbo.[FacturasPuenteDepv2]
wHERE YEAR(FechaFactura) * 100 + MONTH(FechaFactura) < 202505
GROUP BY DeudorId, YEAR(FechaFactura), MONTH(FechaFactura) 
--ORDER BY  YEAR(FechaFactura), MONTH(FechaFactura), DeudorId
) as a
GROUP BY DeudorId









-- LLENAR BDC

If OBJECT_ID('Tempdb..#opeMovimientosAlmacen') IS NOT NULL Drop Table #opeMovimientosAlmacen

SELECT * 
INTO #opeMovimientosAlmacen
FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen
WHERE sucCLave = 111
and moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71, 60) -- COPPEL, SEARS, INTEGRA, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI, GENÉRICO
--and moaFolio not in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
and fecClave >= 20240101
and movClave = 6


If OBJECT_ID('Tempdb..#BASE_BDC') IS NOT NULL Drop Table #BASE_BDC

SELECT *
INTO #BASE_BDC
FROM (

	SELECT	
		fecAnio, fecMes, A.fecClave, 'SEDUCTA' Cliente, A.prdClave, talClave, sum(moaPares) as uni --) as Unidades
	FROM 
		[10.16.26.3].BDC.dbo.opeMovimientosAlmacen as A
	LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave
	WHERE 
		A.fecClave > 20240101 --and (select fecClave from BDC.dbo.catFechas where fecFecha =  CONVERT(DATE, GETDATE()))
		AND movClave = 6
		AND sucClave = 111
		AND moaUbicacionDestino = 0
		AND moaFolio in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
		--and fecMes = 10 --	and prdClave = '008624803'
		and fecAnio >= 2024
	Group by fecAnio, fecMes, A.fecClave, A.prdClave, talClave

	UNION ALL

	SELECT 
		fecAnio, 
		fecMes, 
		A.fecClave,
		CASE 
			WHEN moaUbicacionOrigen = 66 THEN 'COPPEL'
			WHEN moaUbicacionOrigen = 54 THEN 'SEARS'
			WHEN moaUbicacionOrigen = 67 THEN 'INTEGRA'
			WHEN moaUbicacionOrigen = 68 THEN 'TIENDAS CON MODA'
			WHEN moaUbicacionOrigen = 69 THEN 'GENOVA'
			WHEN moaUbicacionOrigen = 70 THEN 'ZAPATERIA MORELOS'
			WHEN moaUbicacionOrigen = 71 THEN 'GARDINI'
			WHEN moaUbicacionOrigen = 60 THEN 'OTROS'
		ELSE
			''
		END as Cliente, 
		A.prdClave, 
		talClave, 
		sum(moaPares) as uni
	FROM 
		#opeMovimientosAlmacen as A
	LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave
	WHERE 
		sucCLave = 111
		and moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71, 60) -- COPPEL, SEARS, INTEGRA, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI, GENÉRICO
		and moaFolio not in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
		and fecAnio >= 2024
		and movClave = 6
	group by 
		fecAnio, fecMes, A.fecClave, A.prdClave, moaUbicacionOrigen, talClave
) AS A







/*  **************************************************************************************************************************************

	C O N S U L T A S		D E			C O M P A R A C I Ó N

    ************************************************************************************************************************************** */


-- GLOBAL  VFC 


SELECT *
FROM (
	SELECT Anio,	Mes,	Cliente,	SUM(uni) uni, SUM(uninet) uninet
	FROM #BASE_VFC 
	WHERE 
	GROUP BY  Anio,	Mes,	Cliente
) AS A 
ORDER BY  Anio,	Mes,	Cliente 





/*		DISTRIBUCIÓN INTELIGENTE		*/

WITH totales_bdc_otros as (
    SELECT
        A.fecanio    as anio,
        A.fecmes     as mes,
        A.fecclave   as fecclave,
        A.prdclave   as prdclave,
        SUM(A.uni)   as total_uni
    FROM #base_bdc as A
    WHERE A.cliente = 'OTROS'
    GROUP by A.fecanio, A.fecmes, A.fecclave, A.prdclave
),
clientes_directos as (
    SELECT DISTINCT
        A.cliente    as cliente,
        A.fecanio    as anio,
        A.fecmes     as mes,
        A.prdclave   as prdclave
    FROM #base_bdc as A
    WHERE A.cliente <> 'OTROS'
),
candidatos_asignacion as (
    SELECT
        A.anio      as anio,
        A.mes       as mes,
        A.fecclave  as fecclave,
        A.prdclave  as prdclave,
        B.cliente   as cliente,
        B.uni       as uni_vfc,
        A.total_uni as total_uni,
        CASE
            WHEN B.uni = A.total_uni THEN 1.0
            ELSE CAST(1.0 * B.uni / A.total_uni AS decimal(10,6))
        END          AS factor,
        CASE
            WHEN B.uni = A.total_uni THEN 'EXACTO'
            ELSE 'AJUSTADO'
        END          AS tipo_asignacion,
        ROW_NUMBER() OVER (
            partition by B.anio, B.mes, B.prdclave, B.cliente
            order by
                CASE WHEN B.uni = A.total_uni THEN 1 ELSE 2 END,
                ABS(B.uni - A.total_uni)
        )             AS rn
    FROM totales_bdc_otros as A
    JOIN #base_vfc as B
        on B.anio      = A.anio
        and B.mes       = A.mes
        and B.prdclave  = A.prdclave
    LEFT JOIN clientes_directos as C
        on C.cliente   = B.cliente
        and C.anio      = B.anio
        and C.mes       = B.mes
        and C.prdclave  = B.prdclave
    WHERE C.cliente is NULL
),
seleccion_asignacion as (
    SELECT *
    FROM candidatos_asignacion as A
    WHERE A.rn = 1
),
detalle_asignacion as (
    SELECT
        B.fecanio           as fecanio,
        B.fecmes            as fecmes,
        COALESCE(A.cliente, B.cliente) as clientefinal,
        B.cliente           as clienteoriginal,
        B.fecclave          as fecclave,
        B.prdclave          as prdclave,
        B.talclave          as talclave,
        B.uni               as uni,
        COALESCE(A.factor, 1.0)       as factor,
        ISNULL(A.tipo_asignacion, 'NATURAL') as tipo_asignacion
    FROM #base_bdc as B
    LEFT JOIN seleccion_asignacion as A
        on B.cliente   = 'OTROS'
        and B.fecanio  = A.anio
        and B.fecmes   = A.mes
        and B.fecclave = A.fecclave
        and B.prdclave = A.prdclave
),
vfc_unicos as (
    SELECT *
    FROM (
        SELECT
            B.*,
            ROW_NUMBER() OVER (
                partition by B.anio, B.mes, B.prdclave, B.cliente
                order by B.cliente
            ) AS rn
        FROM #base_vfc as B
    ) as A
    WHERE A.rn = 1
)

/*  CONSULTA FINAL RESUMEN
select Año, Mes, Cliente, sum(UnidadesAjustado) as uni_ajustada, sum(Unidades) as uni
from (
*/

/*
SELECT
    X.cliente,
    SUM(CASE WHEN X.TipoAsignacion = 'NATURAL'  THEN X.UnidadesAjustado ELSE 0 END) as Naturales,
    SUM(CASE WHEN X.TipoAsignacion = 'EXACTO'   THEN X.UnidadesAjustado ELSE 0 END) as Exactos,
    SUM(CASE WHEN X.TipoAsignacion = 'AJUSTADO' THEN X.UnidadesAjustado ELSE 0 END) as Ajustados
FROM (
*/
    SELECT
        D.fecanio          as fecAnio,
        D.fecmes           as fecMes,
        D.clientefinal     as Cliente,
        D.clienteoriginal  as ClienteBDC,
        D.fecclave         as fecclave,
        D.prdclave         as prdclave,
        D.talclave         as talclave,
        D.uni              as uniUnidades,
        CONVERT(int, ROUND(D.uni * D.factor, 0)) as UnidadesAjustado,
        V.uni              as UnidadesVFC,
        V.preuni           as PrecioUnitario,
        CAST(D.uni * D.factor * V.preuni as decimal(18,2)) as impImportes,
        D.tipo_asignacion  as TipoAsignacion
	-- INTO VFC.dbo.tmpVFCxTalla
    FROM detalle_asignacion as D
    JOIN vfc_unicos as V
        on V.anio		= D.fecanio
        and V.mes		= D.fecmes
        and V.cliente	= D.clientefinal
        and V.prdclave	= D.prdclave



	--Order by D.fecAnio, D.fecMes, D.clientefinal, D.prdClave, D.talclave
    --where d.fecanio = 2024 and d.fecmes = 9

/*
) as X
GROUP BY X.cliente;
*/



-- FINAL


-- LLENAR CLICLAVE
ALTER TABLE VFC.dbo.tmpVFCxTalla
ADD cliClave VARCHAR(10);

UPDATE VFC.dbo.tmpVFCxTalla
SET cliClave = CASE Cliente
    WHEN 'COPPEL'               THEN '9900000047'
    WHEN 'GARDINI'              THEN '9900000039'
    WHEN 'GENOVA'               THEN '9900000019'
    WHEN 'INTEGRA'              THEN '9900000049'
    WHEN 'NUEVO MUNDO'          THEN '9900000007'
    WHEN 'SEARS'                THEN '9900000008'
    WHEN 'SEDUCTA'              THEN '0'
    WHEN 'TIENDAS CON MODA'     THEN '9900000046'
    WHEN 'ZAPATERIA MORELOS'    THEN '9900000012'
    ELSE NULL
END;


-- LLENAR SUCCLAVE
ALTER TABLE VFC.dbo.tmpVFCxTalla
ADD sucClave int;

UPDATE VFC.dbo.tmpVFCxTalla
SET sucClave = CASE Cliente
    WHEN 'COPPEL'               THEN 695
    WHEN 'SEARS'                THEN 694
    ELSE 590
END;

590	MEXICO	NACIONAL MEXICO	DEPARTAMENTALES	DEPARTAMENTALES	DEPARTAMENTALES
694	MEXICO	NACIONAL MEXICO	DEPARTAMENTALES	DEPARTAMENTALES	SEARS
695	MEXICO	NACIONAL MEXICO	DEPARTAMENTALES	DEPARTAMENTALES	COPPEL


SELECT * FROM CONSOL2012.dbo.Sucursal where clave_suc  in (590, 694, 695, 888)
SELECT * FROM BDC.dbo.catSucursal where sucClave in (590, 694, 695, 888)



















-- SIN SALIDA EN EL MES

-- 666311043
-- 689021000


-- BUSCAR POR PRDCLAVE
Declare @alternativa varchar(20), @prdClave varchar(20);
set @prdClave = '689021000'
set @alternativa = (SELECT CONCAT(CONVERT(VARCHAR, prdModelo), prdColor, prdMaterial) as Alternativa FROM [10.16.26.3].BDC.dbo.catProducto where prdClave = @prdClave)
select @prdClave, @alternativa

SELECT fechafact, SUM(UNIDADES) UNIDADES FROM VFC.dbo.uvwfacturasporPeriodo 
where Alternativa = @alternativa
group by fechafact order by 1

--SELECT SUM(UNIDADES) FROM VFC.dbo.uvwfacturasporPeriodo WHERE UUID = '8f2c27de-1cc6-445e-8cfe-0ecab22b16d4'

SELECT fecClave, sum(moaPares) FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen 
where prdClave = @prdClave and sucClave = 111 and movClave = 6
group by fecClave order by 1


SELECT * FROM #BASE_BDC
WHERE fecAnio = 2025
and fecMes = 5


SELECT local_tcp_port
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;



-- PRUEBA

VALIDACION_BDC as (

        SELECT 
			fecanio as año,
			fecmes as mes,
			clientefinal as cliente,
			prdclave as claveproducto,
			SUM(ROUND(uni * factor, 0)) as unidades
		FROM 
			detalle_asignacion
		GROUP BY fecanio, fecmes, clientefinal, prdclave
),
VALIDACION_VFC as (

        SELECT 
			Anio as año,
			Mes as mes,
			Cliente as cliente,
			prdclave as claveproducto,
			uni as unidades
		FROM 
			#BASE_VFC
)

-- VALDIACION VFC vs BDC
SELECT
    COALESCE(A.Año, B.Año) as Año,
    COALESCE(A.Mes, B.Mes) as Mes,
    COALESCE(B.Cliente, A.Cliente) as Cliente,
    COALESCE(A.ClaveProducto, B.ClaveProducto) as ClaveProducto,
    CONVERT(INT, A.unidades) as UnidadesBDC,
    B.unidades as UnidadesVFC
FROM 
	VALIDACION_BDC as A
FULL OUTER JOIN VALIDACION_VFC as B
    on A.Año = B.Año
    and A.Mes = B.Mes
    and A.Cliente = B.Cliente
    and A.ClaveProducto = B.ClaveProducto
WHERE (A.Mes <> 5 and A.Año <> 2025)
and B.unidades is not null
Order by 
	Año, Mes, Cliente, ClaveProducto;


SELECT
    R.clientefinal   AS Cliente,
    SUM(CASE WHEN R.tipo_asignacion = 'NATURAL'  THEN ROUND(R.uni * R.factor,0) ELSE 0 END) AS Naturales,
    SUM(CASE WHEN R.tipo_asignacion = 'EXACTO'   THEN ROUND(R.uni * R.factor,0) ELSE 0 END) AS Exactos,
    SUM(CASE WHEN R.tipo_asignacion = 'AJUSTADO' THEN ROUND(R.uni * R.factor,0) ELSE 0 END) AS Ajustados
FROM detalle_asignacion AS R
GROUP BY R.clientefinal
ORDER BY R.clientefinal;


-- PRUEBA

SELECT * FROM #BASE_VFC
WHERE prdClave = '686172555'
and Mes = 3

SELECT fecAnio, fecMes, fecClave, SUM(uni) FROM #BASE_BDC
WHERE prdClave = '686172555'
and fecMes = 3
group by  fecAnio, fecMes, fecClave












SELECT ANIO, MES, SUM(UNI) UNI 
FROM #BASE_VFC
WHERE Cliente = 'COCARO'
GROUP BY  ANIO, MES
ORDER BY ANIO, MES


-- BUSCAR POR PRDCLAVE
Declare @alternativa varchar(20);

SELECT @alternativa = CONCAT(CONVERT(VARCHAR, prdModelo), prdColor, prdMaterial) 
FROM [10.16.26.3].BDC.dbo.catProducto where prdClave = '666311043'

SELECT *--SUM(UNIDADES)
FROM VFC.dbo.uvwfacturasporPeriodo 
where Alternativa = @alternativa
and Anio = 2024
and Mes = 7

AFCORP-50079
-- 57  MES 7
-- 23  MES 9

SELECT fecAnio, fecmes, fecClave, Cliente, prdClave, sum(uni) FROM #BASE_BDC 
WHERE prdClave = '666311043'
group by  fecAnio, fecmes, fecClave, Cliente, prdClave

SELECT Anio, Mes, Cliente, prdClave, uni FROM #BASE_VFC 
WHERE prdClave = '666311043'

-- 80

SELECT B.fecAnio, B.fecMes, A.fecClave, A.prdClave, sum(A.moaPares) moaPares	
FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
		A.movClave = 9
--		and A.sucClave = 1
		and B.fecAnio = 2024
		and B.fecMes in (6,7,8)
		and prdClave = '666311043'
GROUP BY B.fecAnio, B.fecMes, A.fecClave, A.prdClave



SELECT * --B.fecAnio, B.fecMes, A.fecClave, A.prdClave, sum(A.moaPares) moaPares	
FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave 
WHERE 
		A.movClave = 6
		and A.sucClave = 111
		and B.fecAnio = 2024
		and B.fecMes in (6,7,8)
		and prdClave = '666311043'
GROUP BY B.fecAnio, B.fecMes, A.fecClave, A.prdClave









SELECT * FROM [10.16.26.3].BDC.dbo.catProducto where prdClave = '030324803'
-- 3032	NE	TEX

SELECT * FROM VFC.dbo.uvwfacturasporPeriodo 
where Modelo = 3032 and Color = 'NE' and Material = 'TEX'
and Mes = 11
and Anio = 2024

SELECT * FROM VFC.dbo.uvwfacturasporPeriodo 
WHERE UUID = '8f2c27de-1cc6-445e-8cfe-0ecab22b16d4'

SELECT * FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen 
where prdClave = '689021000' and sucClave = 111 and movClave = 6


SELECT * FROM [10.16.26.3].BDC.dbo.catProducto where prdClave = '689021000'




SELECT TOP 4 * FROM CONSOL2012.[dbo].[CONALT]  -- NIVEL MODELO COLOR MATERIAL
SELECT TOP 4 * FROM CONSOL2012.[dbo].[CONALL]  -- NIVEL MODELO COLOR MATERIAL
SELECT TOP 4 * FROM CONSOL2012.DBO.CONSOL  -- NIVEL MODELO COLOR MATERIAL
SELECT TOP 4 * FROM CONSOL2012.[dbo].[CONSOT] -- NIVEL MODELO COLOR MATERIAL

SELECT * FROM CONSOLIDADO_DIARIO.dbo.DIARIO_ALTERNATIVA

SELECT TOP 4 * FROM DWH.dbo.Historico
SELECT TOP 4 * FROM DWH.dbo.HistoricoImportes
SELECT TOP 4 * FROM DWH.dbo.HistoricoxSuc
SELECT TOP 4 * FROM DWH.dbo.HistoricoxCCImportes

