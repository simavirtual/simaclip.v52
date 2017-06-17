/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: FACTURACION            MODULO No. 105

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE108.PRG                                    *
* TITULO DEL PROGRAMA..: FACTURACION DE UN SOLO RECIBO                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 12:40 AM   JUN 19/96 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite facturar por cualquier concepto sin afectar el saldo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_182(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
       #DEFINE  TAMPA22 CHR(27)+'C'+CHR(22) // P gina de 22 l¡neas
       #DEFINE  TAMPA34 CHR(27)+'C'+CHR(34) // P gina de 34 l¡neas
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lGrabar := .F.                 // .T. Grabar el pago

       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL cNroFac := ''                  // N£mero de la factura. Consecutivo
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nRegPag := 0                   // Registro del pago

       LOCAL nVlrCo1 := 0                   // Valor del Concepto No. 1
       LOCAL nVlrCo2 := 0                   // Valor del Concepto No. 2
       LOCAL nVlrCo3 := 0                   // Valor del Concepto No. 3
       LOCAL nVlrCo4 := 0                   // Valor del Concepto No. 4
       LOCAL nVlrCo5 := 0                   // Valor del Concepto No. 5
       LOCAL nVlrCo6 := 0                   // Valor del Concepto No. 6
       LOCAL nVlrCo7 := 0                   // Valor del Concepto No. 7
       LOCAL nVlrCo8 := 0                   // Valor del Concepto No. 8
       LOCAL lHayBec := .F.                 // .T. Se aplico la beca
       LOCAL nVlrBec := 0                   // Valor de la Beca
       LOCAL nDescue := 0                   // Valor del Descuento
       LOCAL nPagPar := 0                   // Valor Pago Parcial
       LOCAL nRecarg := 0                   // Valor del Recargo
       LOCAL nDesGen := 0                   // Descuento General
       LOCAL nRecGen := 0                   // Recargo General
       LOCAL cConGen := ''                  // Concepto General
       LOCAL nFavDes := 0                   // Saldo a Favor Descontado.
       LOCAL nSdoFav := 0                   // Saldo a Favor

       LOCAL nVlrTot := 0                   // Valor total del recibo
       LOCAL lPrnGru := .T.                 // Impresi¢n por grupos
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL cEstadoTpa := ''               // Estado del pago
       LOCAL nVlrMesTpa := 0                // Valor recibo para un mes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes del recibo para la facturaci¢n',.T.)
       RESTORE SCREEN
       IF nMesIniTpa == 0
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nOtrRecCaA == 0 .OR. CAA->nOtrRecCaA > 8
	    cError('EL RECIBO No.'+STR(CAA->nOtrRecCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO
       IF CAA->cCodigoBan == cSpaces('BAN','cCodigoBan')
	  cError('A CONTINUACION ESCOJA EL BANCO',;
		 'NO SE HA DEFINIDO EL BANCO DONDE SE DEBE PAGAR')
	  CambiaBan(lShared,nFilInf+1,nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO

*>>>>LECTURA DE LOS DETALLES DEL BANCO
       IF !lLocCodBan(CAA->cCodigoBan)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LOS DETALLES DEL BANCO

*>>>>CONSULTA DE LOS DETALLES PARA LA FACTURACION
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,BAN->cNroctaBan,;
		   nMesIniTpa,nMesIniTpa,cAnoUsr)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nMesIniTpa,;
				nMesIniTpa,cAnoUsr)})

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN PREGUNTA DE DECISION

*>>>>IMPRESION DE LA LINEA DE ESTADO
       LineaEstado('FACTURACION DE '+cMes(nMesIniTpa,3)+;
		   ' A '+cMes(nMesIniTpa,3),cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       DO WHILE .T.

**********CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR
	    SET DEVICE TO SCREEN
	    IF SCO->lHayNroCon
	       cNroFac := STR(SCO->nNroFacCon+1,9)
	       lCorrecion(@cNroFac,.T.)

	       @ nFilInf+1,nColInf+7 SAY 'RECIBO No.'
	       SET COLOR TO G*
	       @ nFilInf+1,nColInf+18 SAY SCO->cCodEmpCon+'-'+cNroFac
	       SET COLOR TO
	    ENDIF
**********FIN CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst
	       cError(cNombreTes+' DEL GRUPO '+&cNalias->cCodigoGru+;
		     ' ESTA RETIRADO')

	       IF nMesIniTpa > &cNalias->nUltRecEst
		  cError('EL ULTIMO RECIBO AUTORIZADO PARA IMPRIMIR ES EL '+;
			 'DEL MES DE '+cMes(&cNalias->nUltRecEst))
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('DE '+cMes(nMesIniTpa,3)+;
			' A '+cMes(nMesIniTpa,3)+;
			'ºGRUPO: '+&cNalias->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30),;
			cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACTIVACION DE LA IMPRESORA
	    IF SCA->lPrnArcCar
	       SET DEVICE TO PRINT
	    ELSE
	       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcRecCar,.F.)
	       IF EMPTY(nOpcPrn)
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF
	    ENDIF
	    IF CAA->nRecNroCaA < 5
	       SendCodes(INICIALIZA+PROPOR_OF+CONDEN_ON+DRAFT_ON)
	    ENDIF
**********FIN ACTIVACION DE LA IMPRESORA

**********CONFIGURACION DEL TAMA¥O DEL PAPEL
	    DO CASE
	    CASE CAA->nOtrRecCaA == 1
		 SendCodes(IF(CAA->lPrePrnCaA,LINESP1_8+TAMPA34,TAMPA22))
		 SendCodes(CONDEN_ON)

	    CASE CAA->nOtrRecCaA == 2
		 SendCodes(TAMPA22)
		 SendCodes(CONDEN_ON)

	    CASE CAA->nOtrRecCaA == 3 .OR. CAA->nOtrRecCaA == 4
		 SendCodes(LINESP1_8+TAMPA34)
		 SendCodes(CONDEN_ON)
	    ENDCASE
	    lPrnGru := .F.
**********FIN CONFIGURACION DEL TAMA¥O DEL PAPEL

**********IMPRISION DEL RECIBO DE PAGO
	    DO CASE
	    CASE CAA->nOtrRecCaA == 1
		      nVlrTot := nRecOtr01(lShared,nModCry,cEmpPal,cNitEmp,;
					   cNomEmp,cJorTxt,@nNroFac,;
					   &cNalias->cCodigoEst,cNombreTes,;
					   &cNalias->cCodigoGru,0,;
					   BAN->cNombreBan,BAN->cNroCtaBan,;
					   BAN->cLugarBan,CAA->cConPenCaA,;
					   CAA->nIntPenCaA,;
					   IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							      CAA->dFecRecCaA),;
					   CAA->dExtPenCaA,CAA->cMensajCaA,;
					   @nVlrMesTpa,nMesIniTpa,;
					   CAA->lPrePrnCaA,lPrnGru)
		     *Recibo dise¤o Colegio la Salle.

	    CASE CAA->nOtrRecCaA == 2

		 nVlrTot := nRecibo02(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,0,;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,CAA->cConPenCaA,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes)
		*Recibo dise¤o Colegio la Merced y Bethlemitas

	    CASE CAA->nOtrRecCaA == 3 .OR. CAA->nOtrRecCaA == 4

		 nVlrTot := nRecibo03(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,0,;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,CAA->cConPenCaA,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nOtrRecCaA)
		*Recibo dise¤o Colegio la Salle con Colilla

	    CASE CAA->nRecNroCaA == 5 .OR. CAA->nRecNroCaA == 6

		 nVlrTot := nRecibo05(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,0,;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,CAA->cConPenCaA,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nOtrRecCaA)
		*Recibo c¢digo de Barras la Kiosera

	    CASE CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9

		 nVlrTot := nRecibo07(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,0,;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,CAA->cConPenCaA,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nOtrRecCaA)
		*Recibo c¢digo de Barras la Kiosera. La Salle

	    ENDCASE

	    IF VALTYPE(nVlrTot) == 'C'
	       cError('Hay Problemas en los valores o los Nombres',;
		      'Por Favor Revise las Tarifas o Conceptos')
	       VerPrn(nOpcPrn,FilePrn)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
	    lPrnGru := .T.
	    EJECT
	    VerPrn(nOpcPrn,FilePrn)
**********FIN IMPRISION DEL RECIBO DE PAGO

       ENDDO
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION