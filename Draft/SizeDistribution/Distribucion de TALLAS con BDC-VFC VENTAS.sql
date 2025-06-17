
/*

SELECT DISTINCT DeudorId, Cliente 
FROM VFC.dbo.uvwfacturasporPeriodo 
WHERE YEAR(FECHAFACT) >= 2024
AND KUDN = 617

DeudorId
0001000182
0003002235

SELECT *
FROM VFC.dbo.uvwfacturasporPeriodo 
WHERE YEAR(FECHAFACT) >= 2024
AND KUDN = 617
AND DeudorId = '0003002235'


SELECT DeudorId, FECHAFACT, 
SUM(UNIDADES) UNIDADES,
SUM(UNIDADES-UNIDADESCAMBIO) NETOS
FROM VFC.dbo.uvwfacturasporPeriodo 
WHERE YEAR(FECHAFACT) >= 2024
AND KUDN = 617
GROUP BY DeudorId, FECHAFACT

FECHAFACT	CTIPNOMBRE	DESCRIPCION	cGeneroId	Alternativa	Modelo	Color	Material	VIGENCIA	VigenciaNombre	UNIDADES
2025-06-10 00:00:00.000	CALZADO	INFANTIL	3	58522BLSLI	58522	BL	SLI	1	V	124



SELECT DeudorId, FECHAFACT, 
SUM(UNIDADES) UNIDADES,
SUM(UNIDADES-UNIDADESCAMBIO) NETOS
FROM VFC.dbo.uvwfacturasporPeriodo 
WHERE WHERE RIGHT(NOFACTURA, 5) IN ('50923', '51315', '52362', '52363', '52869', '52870', '52452', '52451')
GROUP BY DeudorId, FECHAFACT


*/
-- LLENADO VFC

IF OBJECT_ID('Tempdb..#UUIDCanceladas') IS NOT NULL DROP TABLE #UUIDCanceladas;

SELECT DISTINCT
	UUID,
	SUM(CASE WHEN OPERACION = 'EMISIÓN' THEN UNIDADES ELSE 0 END) EMI,
	SUM(CASE WHEN OPERACION = 'CANCELACIÓN' THEN UNIDADESCAMBIO ELSE 0 END) CAN
INTO #UUIDCanceladas
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Anio >= 2023
GROUP BY UUID
HAVING
    (SUM(CASE WHEN MOVIMIENTO IN ('VENTA', 'CAMBIO CANCELADO', 'CANCELACIÓN') THEN UNIDADES ELSE 0 END)
    = SUM(CASE WHEN MOVIMIENTO IN ('CAMBIO', 'CANCELACIÓN', 'VENTA CANCELADA')  THEN UNIDADESCAMBIO ELSE 0 END))
	
-- (1480 rows affected)

IF OBJECT_ID('Tempdb..#ParejasCancelacion') IS NOT NULL DROP TABLE #ParejasCancelacion;

SELECT DISTINCT
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

-- (586 rows affected)


/* borrar

IF OBJECT_ID('Tempdb..#PREV') IS NOT NULL DROP TABLE #PREV;

SELECT * 
INTO #PREV
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Anio	 >= 2024 
	AND UUID NOT IN (SELECT DISTINCT UUID        FROM #UUIDCanceladas)
    AND UUID NOT IN (SELECT DISTINCT VentaUUID   FROM #ParejasCancelacion)
    AND UUID NOT IN (SELECT DISTINCT CancelUUID  FROM #ParejasCancelacion)

*/


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
		WHEN DeudorId IN ('0001000182','0003002235') THEN 'SALDOS'   -- AGRUPANDO
        ELSE 'OTROS'
    END AS Cliente
INTO #BaseClientes_PREV
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Anio >= 2024
    -- excluimos UUIDs de ambos tipos de cancelaciones
    AND UUID NOT IN (SELECT DISTINCT UUID        FROM #UUIDCanceladas)
    AND UUID NOT IN (SELECT DISTINCT VentaUUID   FROM #ParejasCancelacion)
    AND UUID NOT IN (SELECT DISTINCT CancelUUID  FROM #ParejasCancelacion)



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



-- SELECT * FROM #BASE_VFC  WHERE cam > 0




-- LLENADO BDC


If OBJECT_ID('Tempdb..#opeMovimientosAlmacen') IS NOT NULL Drop Table #opeMovimientosAlmacen

-- VENTAS DEPARTAMENTALES
SELECT * 
INTO #opeMovimientosAlmacen
FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen
WHERE sucClave = 111
and moaUbicacionOrigen IN (66, 54, 67, 68, 69, 70, 71, 60, 44) -- COPPEL, SEARS, INTEGRA, TIENDAS CON MODA, GENOVA, MORELOS, GARDINI, GENÉRICO
and fecClave >= 20240101
and movClave = 6

-- VENTAS DE SEDUCTA
INSERT INTO #opeMovimientosAlmacen
SELECT * FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen
Where sucClave = 111
and moaFolio in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%') -- SEDUCTA
and moaUbicacionOrigen NOT IN (66, 54, 67, 68, 69, 70, 71, 60, 44)
and movClave = 6

-- AJUSTES DE ALMACEN
INSERT INTO #opeMovimientosAlmacen
SELECT * FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen
Where movClave = 9
and sucClave = 111
and moaUbicacionDestino IN (66, 54, 67, 68, 69, 70, 71, 60, 44)


-- FORZAR CLIENTE POR UNIDADES SEPARADAS O MEZCLADAS
UPDATE #opeMovimientosAlmacen
SET moaUbicacionOrigen = 68
WHERE (moaFolio in (908621,908623,908626,908628,908634,908637,908640,908649,908621,908626,908634)
AND prdClave in ('666624803', '870551903')
AND fecClave IN (20240401, 20240410)
)
OR 
(prdClave = '889514803' AND fecClave IN (20240401, 20240410) and moaFolio in (908621,908623,908626,908628,908634,908637,908640,908649)
)



--GROUP BY PRDCLAVE
If OBJECT_ID('Tempdb..#BASE_BDC_PREV') IS NOT NULL Drop Table #BASE_BDC_PREV

SELECT *
INTO #BASE_BDC_PREV
FROM (

	SELECT	
		fecAnio, fecMes, A.fecClave, 'SEDUCTA' Cliente, prdClave, talClave, sum(moaPares) as uni --) as Unidades
	FROM 
		#opeMovimientosAlmacen as A
	LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave
	WHERE 
		A.fecClave > 20240101
		AND movClave = 6
		AND sucClave = 111
		AND moaUbicacionDestino = 0
		AND moaFolio in (select distinct mMvAFolio from [10.16.32.33].SIA0111.dbo.mMovAlmacen WHERE mMvAObservaciones LIKE '%SEDUCTA%' AND mMvAObservaciones NOT LIKE '%DEVOL%')   -- SEDUCTA
	Group by 
		fecAnio, fecMes, A.fecClave, prdClave, talClave


	UNION ALL

	SELECT 
		fecAnio, 
		fecMes, 
		A.fecClave,
		CASE 
			WHEN moaUbicacionOrigen = 44 THEN 'SALDOS'
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


-- FORZAR CLIENTES
UPDATE #BASE_BDC_PREV
SET Cliente = 'ZAPATERIA MORELOS'
where fecClave in (20241213, 20241214)

UPDATE #BASE_BDC_PREV
SET Cliente = 'TIENDAS CON MODA'
WHERE prdClave in (SELECT DISTINCT PrdClave FROM #BASE_VFC WHERE Cliente = 'TIENDAS CON MODA' AND ANIO = 2024AND uni > 0 AND MES = 3)
	AND FECCLAVE IN (20240316, 20240318)

UPDATE #BASE_BDC_PREV   -- MOVIMIENTOS CON DESFASE
set fecClave = 20241106, fecMes = 11 -- SELECT SUM(UNI) FROM #BASE_BDC_PREV
WHERE fecAnio = 2024
and Cliente = 'INTEGRA'
and fecClave = 20241023


-- AGRUPAR CLIENTES
If OBJECT_ID('Tempdb..#BASE_BDC') IS NOT NULL Drop Table #BASE_BDC

SELECT *
INTO #BASE_BDC
FROM (
	SELECT fecAnio,	fecMes,	MIN(fecClave) fecClave,	Cliente,	prdClave,	talClave,	SUM(uni) uni
	FROM #BASE_BDC_PREV
	WHERE Cliente <> 'OTROS'
	GROUP BY fecAnio, fecMes, Cliente,	prdClave,	talClave

	UNION ALL 

	SELECT *
	FROM #BASE_BDC_PREV
	WHERE Cliente = 'OTROS'


) AS A

-- obtener ajustes de BDC
If OBJECT_ID('Tempdb..#BASE_BDC_AJUSTE') IS NOT NULL Drop Table #BASE_BDC_AJUSTE
SELECT 
	fecAnio, 
	fecMes, 
	A.fecClave,
	CASE 
		WHEN moaUbicacionDestino = 44 THEN 'SALDOS'
		WHEN moaUbicacionDestino = 66 THEN 'COPPEL'
		WHEN moaUbicacionDestino = 54 THEN 'SEARS'
		WHEN moaUbicacionDestino = 67 THEN 'INTEGRA'
		WHEN moaUbicacionDestino = 68 THEN 'TIENDAS CON MODA'
		WHEN moaUbicacionDestino = 69 THEN 'GENOVA'
		WHEN moaUbicacionDestino = 70 THEN 'ZAPATERIA MORELOS'
		WHEN moaUbicacionDestino = 71 THEN 'GARDINI'
		WHEN moaUbicacionDestino = 60 THEN 'OTROS'
	ELSE
		''
	END as Cliente, 
	A.prdClave, 
	talClave, 
	sum(moaPares) as uni
INTO #BASE_BDC_AJUSTE
FROM 
	#opeMovimientosAlmacen as A
LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave
Where 
	movClave = 9
	and sucClave = 111
group by 
	fecAnio, fecMes, A.fecClave, A.prdClave, moaUbicacionDestino, talClave


-- FORZAR CLIENTES
UPDATE #BASE_BDC_AJUSTE
SET Cliente = 'ZAPATERIA MORELOS'
where fecClave in (20241213)
and Cliente = 'OTROS'


--select * from #BASE_BDC_AJUSTE where fecClave = 20241213

-- REALIZAR AJUSTES
UPDATE A
SET A.uni = A.uni - ISNULL(B.uni, 0)
--SELECT SUM(A.uni), SUM(ISNULL(B.uni, 0)), SUM( A.uni - ISNULL(B.uni, 0))
FROM #BASE_BDC AS A
INNER JOIN #BASE_BDC_AJUSTE AS B
    ON B.prdClave = A.prdClave
   AND B.fecAnio  = A.fecAnio
   AND B.fecMes = A.fecMes
   AND B.Cliente = A.Cliente
   AND B.talClave = A.talClave
WHERE A.Cliente <> 'SEARS' and A.Cliente <> 'OTROS'


UPDATE A
SET A.uni = A.uni - ISNULL(B.uni, 0)
--SELECT SUM(A.uni), SUM(ISNULL(B.uni, 0)), SUM( A.uni - ISNULL(B.uni, 0))
FROM #BASE_BDC AS A
LEFT JOIN #BASE_BDC_AJUSTE AS B
    ON B.prdClave = A.prdClave
   AND B.fecAnio  = A.fecAnio
   AND B.fecMes = A.fecMes
   AND B.Cliente = A.Cliente
   AND B.talClave = A.talClave
   AND B.uni = A.uni
WHERE A.Cliente = 'OTROS'


--SELECT fecClave, prdClave, sum(uni) FROM #BASE_BDC WHERE CLIENTE = 'OTROS' AND FECCLAVE IN (20241213, 20241214) group by fecClave, prdClave order by prdClave
--SELECT prdClave, sum(uni) FROM #BASE_VFC WHERE Cliente = 'ZAPATERIA MORELOS' AND ANIO = 2024 AND MES = 12 group by  prdClave order by prdClave

--  VALIDACIONES
SELECT SUM(UNI) FROM #BASE_BDC_AJUSTE WHERE Cliente = 'ZAPATERIA MORELOS' AND FECANIO = 2024
SELECT SUM(UNI) FROM #BASE_BDC WHERE Cliente = 'OTROS' AND FECANIO = 2024
SELECT SUM(UNI) FROM #BASE_BDC_PREV WHERE Cliente = 'SEDUCTA' AND FECANIO = 2024

SELECT SUM(UNI) FROM #BASE_BDC_AJUSTE WHERE Cliente = 'OTROS' AND FECANIO = 2024 AND FECMES = 12
SELECT SUM(UNI), SUM(CAM) FROM #BASE_VFC WHERE Cliente = 'ZAPATERIA MORELOS' AND ANIO = 2024 AND MES = 12




/*   ********************************************************************************************************

				CCCCC   OOOOO	DDD		EEEEE
				C		O	O	D	D	E___
				C		O	O	D	D	E
				CCCCC	OOOOO	DDD		EEEEE

*************************************************************************************************************	*/



-- DISTRIBUCIÓN INTELIGENTE PARA LAS TALLAS+

If OBJECT_ID('VFC.dbo.tmpVFCxTalla') IS NOT NULL Drop Table VFC.dbo.tmpVFCxTalla;

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
)
,
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
            ELSE CAST(1.0 * B.uni / NULLIF(A.total_uni, 0) AS decimal(10,6))
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
        and (B.mes = A.mes) --  or B.mes = A.mes + 1
        and B.prdclave  = A.prdclave
    LEFT JOIN clientes_directos as C
        on C.cliente   = B.cliente
        and C.anio      = B.anio
        and C.mes       = B.mes
        and C.prdclave  = B.prdclave
    WHERE C.cliente is NULL
)
,
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
	INTO VFC.dbo.tmpVFCxTalla
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


-- (12214 rows affected) sin ajustes
-- (11395 rows affected) con ajustes




-- HOJA 'GENERAL ANUAL'

SELECT fecAnio, Cliente, sum(UnidadesAjustado) UnidadesAjustado
FROM VFC.dbo.tmpVFCxTalla
WHERE 
	not (fecAnio = 2025 and fecMes = 6)
GROUP BY fecAnio, Cliente
ORDER BY fecAnio, Cliente


SELECT Anio, Cliente, sum(uni) uni, sum(cam) cam
FROM #BASE_VFC
WHERE 
	not (Anio = 2025 and Mes = 6)
GROUP BY Anio, Cliente
ORDER BY Anio, Cliente




/*   ********************************************************************************************************

				CCCCC   OOOOO	DDD		EEEEE
				C		O	O	D	D	E___
				C		O	O	D	D	E
				CCCCC	OOOOO	DDD		EEEEE

*************************************************************************************************************	*/

--		 C A M B I O S


SELECT Anio, Cliente, prdClave, sum(uni) uni, sum(cam) cam
FROM #BASE_VFC
WHERE 
	Anio = 2025 
	and Mes = 1
	and cam > 0
GROUP BY Anio, Cliente, prdClave
ORDER BY Anio, Cliente

-- TOTAL
SELECT sum(cam) cam FROM #BASE_VFC WHERE Anio = 2025 


-- CALIZ 2025
If OBJECT_ID('Tempdb..#BASE_BDC_CAM', 'U') IS NOT NULL Drop Table #BASE_BDC_CAM

SELECT B.fecAnio, B.fecMes, A.fecClave, A.prdClave, A.talClave, A.moaPares
INTO #BASE_BDC_CAM
FROM [10.16.26.3].BDC.dbo.opeMovimientosAlmacen as A
LEFT JOIN [10.16.26.3].BDC.dbo.catFechas as B on B.fecClave = A.fecClave
WHERE 
	movClave = 9
	--and prdClave in ('346361903','346364803','680890326','833801044','889514803','894910201','630596398')  -- '680890326' IGUAL DOBLE PERO EN DIFERENTE DÍA
	and prdClave in (SELECT distinct prdClave FROM #BASE_VFC WHERE Anio = 2025 and cam > 0)
	and sucClave = 639
	and moaUbicacionDestino = 18
	and A.fecClave >= 20250101
	

SELECT distinct * 
FROM #BASE_BDC_CAM AS A
LEFT JOIN #BASE_VFC AS B ON B.prdClave = A.prdClave and B.Anio = A.fecAnio and B.Mes = A.fecMes and A.moaPares = B.cam and B.cam > 0
Where cam is not null


SELECT *
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE Anio = 2025 and Mes IN (1, 2) and Alternativa = '68089CATLI' and DeudorId = '0003002222'


SELECT *
FROM VFC.dbo.uvwfacturasporPeriodo
WHERE UUID = 'd88a8d15-0096-4689-8456-ac4aac183442'

680890326


SELECT sucClave, sucSucursal
FROM [10.16.26.3].BDC.dbo.catSucursal 
where sucClave in (590, 694, 695, 888, 617)























