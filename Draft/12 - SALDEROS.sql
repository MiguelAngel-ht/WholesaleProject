
-- UBICAR SALDEROS

SELECT * FROM VFC.dbo.uvwfacturasporPeriodo
WHERE KUDN = 617


/*
-- SALDEROS DE DAVID
SELECT * FROM VFC.dbo.uvwfacturasporPeriodo
WHERE RIGHT(NOFACTURA, 5) IN ('50923', '51315', '52362', '52363', '52869', '52870', '52452', '52451')
	-- DeudorId IN ('0003002235', '0001000182')  -- SEGUNDA OPCIÓN

*/


-- UBICACION DE SALDOS
SELECT * FROM BDC.dbo.catUbicacion WHERE ubiClave = 44 and sucClave = 111
SELECT * FROM BDC.dbo.catMovimientoAlmacen WHERE movClave = 6 and sucClave = 111
SELECT * FROM BDC.dbo.catUbicacion WHERE ubiClave = 18 and sucClave = 111




/* 
UBICACIONES DE SALDOS 
sucClave 111 SI 44
sucClave 928 SI 18
*/

-- PONERR EN EL WHERE LAS UBICACIONES DE SALDOS
SELECT 
	prdClave, sucClave, moaUbicacionOrigen, sum(moaPares) as Unidades
FROM BDC.dbo.opeMovimientosAlmacen 
WHERE
	movClave = 6 
	and fecClave >= 20250401
	and fecClave <= 20250601
	and ((moaUbicacionOrigen = 44  and sucClave = 111)
		OR (moaUbicacionOrigen = 18 and sucClave = 928)) 
GROUP BY prdClave, sucClave, moaUbicacionOrigen
ORDER BY 1 desc


SELECT prdClave, COUNT(distinct fecClave) as Dias
FROM BDC.dbo.opeMovimientosAlmacen 
WHERE
	movClave = 6 
	and sucClave = 111 
	and fecClave >= 20250401
	and fecClave <= 20250501
	and moaUbicacionOrigen = 44 -- SALDOS
GROUP BY prdClave
ORDER BY 2 DESC


--AJUSTE DE SALDOS
SELECT prdClave, COUNT(distinct fecClave) as Dias
FROM BDC.dbo.opeMovimientosAlmacen 
WHERE
	movClave = 9
	and sucClave = 111 
	and fecClave >= 20250401
	and moaUbicacionOrigen = 44 -- SALDOS
GROUP BY prdClave
ORDER BY 2 DESC


-- CAMBI0S DE SALDOS
SELECT moaUbicacionOrigen, fecClave, sum(moaPares) as Unidades
FROM BDC.dbo.opeMovimientosAlmacen 
WHERE
	movClave = 6
	and sucClave = 111
	and fecClave >= 20250401
	and moaUbicacionOrigen = 60
GROUP BY moaUbicacionOrigen, fecClave
ORDER BY 2 DESC


SELECT * 
FROM BDC.dbo.catUbicacion 
WHERE ubiClave IN (44, 46, 52, 54, 60, 64, 66, 67, 70)
and sucClave = 111




