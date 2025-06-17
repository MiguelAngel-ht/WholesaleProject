

SELECT 
	CASE 
		WHEN IDCliente = 47 THEN 695
		WHEN IDCliente = 8 THEN 694
		ELSE 590
	END as sucClave,
	'99' + CONVERT(VARCHAR, NoCliente) as cliClave,
	Nombre as cliNombre,
	0 as cliPorcentajeDescuento,
	IDPais as paiClave,
	IDEstado as edoClave,
	0 as ciuClave,
	Calle + ' ' + NoExt + ', ' + Colonia  as cliDireccion,
	CP as cliCodigoPostal,
	'ESTRELLA' as cliProteccionMarca,
	0 as cliLimitarCambios,
	0 as cliSexo,
	'' as cliEstadoCivil,
	1 as regVigente,	
	FechaIngreso as cliFechaAfiliacion,
	FechaIngreso as cliFechaNacimiento,
	0 as mcespID,
	9 as cTiCClave,
	Email as cliEmail,
	0 as menClave,
	3 as mafClave,
	Observaciones as cliObservaciones,
	0 as cliPromocionesSMS,
	0 as colClave,
	Nombre as cliApellidoPaterno,
	Nombre as cliApellidoMaternos,
	Nombre as cliNombreSolo,
	1 as estClave,
	0 as cliEstatusReactivado,
	CONVERT(DATETIME, 0) as cliFechaReactivacion,
	0 as cliAndreaContacta,
	1 as empClave,
	Calle as cliCalle,
	NoExt as cliNumeroExterior,
	NoInt as cliNumeroInterior,
	0 as cliSugar,
	0 as fpcClave,
	0 as cliFolioPrimeraVenta,
	0 as zocClave, -- 				
	'0000000000' as cliClavePadre,
	CASE 
		WHEN IDCliente = 47 THEN 0001000695
		WHEN IDCliente = 8 THEN 0001000694
		ELSE 0001000590
	END as ccvClave,
	'' as secClave,
	0 as stcClave, 
	'CONSUMIDOR FINAL' as cliClasificacion,
	RFC as cliRFC,
	0 as usuClaveATP,
	0 as cliCapacitacion,
	'' as cliClienteReferido,
	'99' + CONVERT(VARCHAR, NoCliente) as cliClaveUnica
INTO #catCliente
FROM [10.16.32.112].NuevosCanalesVenta.[dbo].[Cliente]
where IDCliente in (47, 8, 35, 9, 46, 7, 49, 39, 19, 12, 13) -- IN (47, 8)


-- DEPARTAMENTALES en UDNs

SELECT * FROM CONSOL2012.dbo.Sucursal where clave_suc  in (590, 694, 695, 888)
SELECT * FROM BDC.dbo.catSucursal where sucClave in (590, 694, 695, 888)


-- OPEUNIDADESXCLIENTE

SELECT
    651367805     AS uniClave,          
    10            AS opeClave,           
    fecFecha AS uniFecha,
    sucClave,
    cliClave,
    prdClave,
    talClave,
    1             AS ttrClave,           
    uniUnidades,
    0             AS motClave,           
    '00:00:00'    AS uniHora,           
    fecClave,
    0             AS defClave,         
    0			 AS uniFolio,           
    1            AS empClave,         
    ccvClave,
    genClave    AS genClave,          
    acuVigencia AS acuVigencia,       
    0			AS uniFolioVenta,      
    0           AS fisClave,          
    0           AS prdConsignacion     
FROM (

    SELECT 
      A.sucClave,
      A.prdClave,
      A.cliClave,
      A.talClave,
      A.uniUnidades,
      A.fecClave,
	  E.acuVigencia,
	  D.genClave,
	  C.fecFecha,
      B.ccvClave
    FROM LINK_IN_VFC.VFC.dbo.tmpVFCxTalla as A
	LEFT JOIN BDC.dbo.catSucursal as B on B.sucClave = A.sucClave
	LEFT JOIN BDC.dbo.catFechas as C on C.fecClave = A.fecClave
	LEFT JOIN BDC.dbo.hisProducto as D on D.prdClave = A.prdClave and A.fecClave between D.fecInicialSubrogada and D.fecFinalSubrogada
	LEFT JOIN BDC.dbo.catAcuerdos as E on E.acuClave = D.prdAcuerdo
	
) AS A;


SELECT TOP 3 * FROM BDC.dbo.opeUnidadesXClienteXProducto
where opeClave = 10



SELECT DISTINCT 
    v.Cliente,
    c.cliClave,
    c.cliNombre
FROM LINK_IN_VFC.VFC.dbo.tmpVFCxTalla AS v
LEFT JOIN #catCliente AS c
    ON c.cliNombre COLLATE Latin1_General_CI_AI 
         LIKE '%' + v.Cliente COLLATE Latin1_General_CI_AI + '%'
ORDER BY v.Cliente;


COPPEL	9900000047
GARDINI	9900000039
GENOVA	9900000019
INTEGRA	9900000049
NUEVO MUNDO	9900000007
SEARS	9900000008
SEDUCTA	0
TIENDAS CON MODA	9900000046
ZAPATERIA MORELOS	9900000012

SELECT * FROM #catCliente
