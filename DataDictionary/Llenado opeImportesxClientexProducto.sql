





SELECT
    0 AS impClave,
    11 AS opeClave,
    fecFecha AS impFecha,
    sucClave,
    cliClave,
    prdClave,
    talClave,
    1 AS ttrClave,
    impImporte,
    0.000000 AS impImpuesto,
    0 AS impTasa,
    3 AS motClave,
    0.000000 AS vtaImporteSinDP,
    fecClave,
    0 AS impFolio,
    1 AS empClave,
    ccvClave,
    0.00 AS impImporteNetoMenudeo,
    genClave AS genClave,
    acuVigencia AS acuVigencia,
    0 AS impFolioVenta,
    0 AS prdConsignacion,
    0.000000 AS impIVA,
    0.000000 AS impIEPS,
    '' AS impTipoIEPS,
    0.00 AS impTasaIEPS
FROM (

    -- <<< CONSULTA
    SELECT 
      A.sucClave,
      A.prdClave,
      A.cliClave,
      A.talClave,
      A.impImportes as impImporte,
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


) AS A




