

--47, 8, 35, 9, 46, 7, 49, 39, 19, 12, 13

-- IDCliente	NoCliente	Nombre
-- 47	00000047	COPPEL
-- 8	00000008	SEARS
-- 35	00000035	FASHION DEPOT
-- 9	00000009	COCARO
-- 46	00000046	TIENDAS CON MODA SA DE CV
-- 7	00000007	NUEVO MUNDO
-- 49	00000049	INTREGRA TRADE SOLUTIONS 
-- 39	00000039	COMERCIAL GARDINI S.A. de C.V.
-- NO ESTÁ SEDUCTA
-- 19	00000019	GENOVA
-- 12	00000012	ZAPATERÍAS MORELOS 1
-- 13	00000013	ZAPATERÍAS MORELOS



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
FROM NuevosCanalesVenta.[dbo].[Cliente]
where IDCliente in (47, 8, 35, 9, 46, 7, 49, 39, 19, 12, 13) -- IN (47, 8)

SELECT cliClave, cliNombre, cliFechaAfiliacion FROM #catCliente


SELECT * FROM NuevosCanalesVenta.[dbo].[Cliente]
where IDCliente IN (47, 8)


IDCliente	NoCliente	Nombre	RFC	Calle	NoExt	NoInt	Colonia	CP	Referencia	Localidad	Ciudad	IDEstado	Telefono1	Telefono2	Movil	Email	Observaciones	ContactoNombre	ContactoCargo	ContactoTelefono	FechaIngreso	IDTipoCliente	IDPais	Estatus	IDPersonal	RazonSocial	CalleE	NoExtE	NoIntE	ColoniaE	CPE	ReferenciaE	LocalidadE	CiudadE	IDEstadoE	MismaDireccion	Categoria	PermiteCredito	ClaveCliente	IDCatalogoUsoCfdi	IDCatalogoRegimenFiscal	Adenda	Texto1	IDDeudor	TipoDescuento	IDDescuento	ValorDescuentoComercial	DiasFactura	LimiteCredito	Credito
3	00000003	DR SUPPLY	DPB0806309B2	FRACC. ABRAHAM LINCOLN	3767		ABRAHAM LINCOLN 2 SECTOR 2	64310	na	MONTERREY	MONTERREY	19	8146370260		(81) 4737 0260 	hector@drsupply.com.mx 	VENTA DE PRODUCTOS MARCA DR SCHOLLS  PAGO COMPLETO ANTES DE ENTREGA ENTREGA: RECOLECTA EL CLIENTE EN CDR NORTE CADA COLECCION SE LES ENVIA LISTA DE PRECIOS Y CATALOGOS   	GUADALUPE VAZQUEZ (COMPRADORA)		(81) 4737 0261	2018-07-25 00:00:00.000	4	1	1	6	DISTRIBUIDORA DE PRODUCTOS PARA EL BIENESTAR CORPORAL S.A. DE C.V.	FRACC. ABRAHAM LINCOLN	3767		ABRAHAM LINCOLN 2 SECTOR 2	64310	NA	MONTERREY	MONTERREY	19	0	1	0	3	20	1	1		0	2	NULL	0.00	30	1000.00	0.00

-------------------------------------------------------------------

sucClave	cliClave	cliNombre	cliPorcentajeDescuento	paiClave	edoClave	ciuClave	cliDireccion	cliCodigoPostal	cliProteccionMarca	cliLimitarCambios	cliSexo	cliEstadoCivil	regVigente	cliFechaAfiliacion	cliFechaNacimiento	mcespID	cTiCClave	cliEmail	menClave	mafClave	cliObservaciones	cliPromocionesSMS	colClave	cliApellidoPaterno	cliApellidoMaterno	cliNombreSolo	estClave	cliEstatusReactivado	cliFechaReactivacion	cliAndreaContacta	empClave	cliCalle	cliNumeroExterior	cliNumeroInterior	cliSugar	fpcClave	cliFolioPrimeraVenta	zocClave	cliClavePadre	ccvClave	secClave	stcClave	cliClasificacion	cliRFC	usuClaveATP	cliCapacitacion	cliClienteReferido	cliClaveUnica
71	0000000000	SUCURSAL	10	2	45	3066	S PULASKI 4304  REF:	60632	INTERNO	0	M	So	1	2008-07-26 00:00:00.000	2008-07-26 00:00:00.000	1	1	tali10_posadas@hotmail.com	4	0		1	78698			SUCURSAL	1	0	1900-01-01 00:00:00.000	0	1	S PULASKI	4304		0	0	0	0	0000000000	0001000071		0	ESTRELLA	XXXXXXX	0	1		







/*Nueva Consulta de Clientes sin campos COSMOS*/
select CLAVE_SUCURSAL as sucursal,
	a.cCliClave as clave,
(
		rtrim(a.cCliApellidoPaterno) + space(1) + rtrim(a.cCliApellidoMaterno) + space(1) + rtrim(a.cCliNombre)
	) as nombre,
	a.cDesClave as descuento,
	f.cPaiID as cvepai,
	e.cEdoID as cveedo,
	d.cCiuID as cvepob,
	b.direccion as direccion,
	rtrim(c.cColCodPostal) as codpostal,
	case
		when a.cCliPPM = 0 then 'INTERNO'
		when a.cCliPPM = 1 then 'ESTRELLA'
		when a.cCliPPM = 2 then 'MULTIMARCA'
		when a.cCliPPM = 3 then 'CERTIFICADO'
	end as cliPPM,
	a.cCliLimitarCambios as cliLimitarCambios,
	a.cCliSexo as cliSexo,
	a.cCliEstadoCivil as cliEstadoCivil,
	convert(
		datetime,
		CONVERT(varchar(10), a.cCliFechaAfiliacion, 103),
		103
	) as cliFechaAfiliacion,
	convert(
		datetime,
		CONVERT(varchar(10), a.cCliFechaNacimiento, 103),
		103
	) as cliFechaNacimiento,
	a.cMCEID as mcespId,
	a.cTiCClave,
	case
		when isnull(x.cCLiEmailValido, 0) = 1 then a.cCliEmail
		else ''
	end as cliEmail,
	a.csamclave as menClave,
	aMAfClave as mafClave,
	cCliObservaciones as cliObservaciones,
	cCliSMSPromociones as cliPromocionesSMS,
	c.cColID as colClave,
	rtrim(a.cCliApellidoPaterno) as apepat,
	rtrim(a.cCliApellidoMaterno) as apemat,
	rtrim(a.cCliNombre) as nombre_solo,
	a.cStCClave as estClave,
	case
		when g.cCliClave is not null then 1
		else 0
	end as cliEstatusReactivado,
	cast(g.Fecha as DATE) as cliFechaReactivacion,
	x.cCliestrategiaAndreaContacta as cliAndreaContacta,
	a.aTCoClave as empClave,
	b.cliCalle,
	b.cliNumeroExterior,
	b.cliNumeroInterior,
case
		when LEFT(a.cCliClave, 1) = '1' then 1
		else 0
	end as cliSugar,
	0 as fpcClave,
	0 as cliFolioPrimeraVenta,
	0 as zocClave,
	'0000000000' as cliClavePadre,
	'0000000000' as ccvClave,
	'00' as secClave,
	0 as stcClave,
	case
		when j.fecFecha <=(
			select cast(GETDATE() as date)
		) then
		/*Con precio único */
		case
			when CLAVE_SUCURSAL in (375, 413) then
			/*Proceso para Call Center*/
			case
				when a.aTCoClave in (1, 46) then case
					when a.cTiCClave in (9) then case
						when a.cDesClave = 10 then 'CLIENTE PREFERENTE'
						else 'CONSUMIDOR FINAL'
					end
					else case
						when a.cTiCClave in (6) then 'COLABORADOR'
						else case
							when a.cTiCClave in(7, 8) then 'CUENTA GENÉRICA'
							else case
								when a.cTiCClave in (1, 2, 3, 5, 10, 12) then 'ESTRELLA'
								else i.cTiCNombre
							end
						end
					end
				end
				else case
					when a.cCliClave = '0375966960' then 'ESTRELLA'
					ELSE 'CLIENTE OTRA EMPRESA'
				end
			end
			else
			/*Proceso Sucursales*/
			case
				when a.cTiCClave in (9) then case
					when a.cDesClave = 10 then 'CLIENTE PREFERENTE'
					else 'CONSUMIDOR FINAL'
				end
				else case
					when a.cTiCClave in (6) then 'COLABORADOR'
					else case
						when a.cTiCClave in(7, 8) then 'CUENTA GENÉRICA'
						else case
							when a.cTiCClave in (1, 2, 3, 5, 10, 12) then 'ESTRELLA'
							else i.cTiCNombre
						end
					end
				end
			end
		end
		else
		/*Antes de Precio único*/
		case
			when CLAVE_SUCURSAL in (375, 413) then
			/*Proceso para Call Center*/
			case
				when a.aTCoClave in (1, 46) then case
					when a.cTiCClave in (9) then 'CONSUMIDOR FINAL'
					else case
						when a.cTiCClave in (6) then 'COLABORADOR'
						else case
							when a.cTiCClave in(7, 8) then 'CUENTA GENÉRICA'
							else case
								when a.cTiCClave in (1, 2, 3, 5, 10, 12) then 'ESTRELLA'
								else i.cTiCNombre
							end
						end
					end
				end
				else case
					when a.cCliClave = '0375966960' then 'ESTRELLA'
					ELSE 'CLIENTE OTRA EMPRESA'
				end
			end
			else
			/*Proceso Sucursales*/
			case
				when a.cTiCClave in (9) then 'CONSUMIDOR FINAL'
				else case
					when a.cTiCClave in (6) then 'COLABORADOR'
					else case
						when a.cTiCClave in(7, 8) then 'CUENTA GENÉRICA'
						else case
							when a.cTiCClave in (1, 2, 3, 5, 10, 12) then 'ESTRELLA'
							else i.cTiCNombre
						end
					end
				end
			end
		end
	end [cliClasificacion],
	a.cCliRFC as cliRFC,
	a.cUsuClaveATP as usuClaveATP,
	a.cCliCapacitacion as cliCapacitacion,
	a.cCliClienteReferido as cliClienteReferido,
	claveUnicaCliente cliClaveUnica
from (
		[SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cclientes as a
		left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cClientesOtrosDatos as x on a.cCliClave = x.cCliClave
	)
	left join (
		select a.cCliClave,
			a.cPaiClave,
			a.cEdoClave,
			a.cCiuClave,
			a.cColClave,
			LEFT(
				rtrim(isnull(a.rDxCCalle, '')) + ' ' + rtrim(isnull(a.rDxCNumero, '')) + ' ' + rtrim(isnull(a.rDxCNumeroInterior, '')) + ' REF:' + rtrim(isnull(a.rDxCReferencia, '')),
				65
			) as direccion,
			a.cColID,
			a.rDxCCalle as cliCalle,
			a.rDxCNumero as cliNumeroExterior,
			a.rDxCNumeroInterior as cliNumeroInterior
		from [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.rDireccionesxCliente as a
			inner join (
				select b.cCliClave,
					min(b.aTDiClave) as aTDiClave
				from [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.rDireccionesxCliente as b
				group by b.cCliClave
			) as b on a.cCliClave = b.cCliClave
			and a.aTDiClave = b.aTDiClave
	) as b on a.cCliClave = b.cCliClave
	left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cColonias as c ON (b.cColID = c.cColID)
	left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cCiudades as d ON (c.cCiuID = d.cCiuID)
	left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cEstados as e ON (d.cEdoID = e.cEdoID)
	left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cPaises as f ON (e.cPaiID = f.cPaiID)
	left join (
		select ccliClave,
			MAX(lAcCFechaHora) Fecha
		from [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.lAccionesCliente
		where cAccClave = 4
			and lAcCValorAnterior = 6
			and lAcCValorNuevo = 1
		group by ccliClave
	) as g on A.cCliClave = g.cCliClave
	left join CatPuntosVta.dbo.datoptovta as h on CLAVE_SUCURSAL = h.noCveSuc
	left join BDC.dbo.catFechas as j on h.fecClavePrecioUnico = j.fecClave
	left join [SERVIDOR_IP].SIACLAVE_SUCURSAL.dbo.cTiposCliente as i on a.cTiCClave = i.cTiCClave







