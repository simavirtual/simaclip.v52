/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: POR ADELANTADO         MODULO No. 102

**************************************************************************
* TITULO..: FACTURACION RECIBOS POR ADELANTADO POR CONCEPTOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 10/2005 LUN A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 10/2005 LUN

OBJETIVOS:

1- Imprime el un recibo de pago con meses por adelantado por conceptos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_193(aParam1,aParam2,aParam3)

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
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL lGrabar := .F.                 // .T. Grabar el pago
       LOCAL lExiste := .F.                 // Existe el estudiante

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL nVlrTot := 0                   // Valor total del recibo
       LOCAL       i := 0                   // Contador
       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL cNroFac := ''                  // N£mero de la factura. Consecutivo
       LOCAL lPrnGru := .T.                 // Impresi¢n por grupos
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
       LOCAL lDesGen := .F.                 // .T. Autorizar Descuento General
       LOCAL nVlrGen := 0                   // Descuento o Recargo General
       LOCAL cMsgTxt := ''                  // Texto temporal
       LOCAL cConcep := ''                  // Conceptos por cobrar
       LOCAL aConcep := {}                  // Conceptos por cobrar
       LOCAL nSdoFav := 0                   // Saldo a Favor
       LOCAL nFavDes := 0                   // Saldo a Favor a Descontar.
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL lHayCoE := .F.                 // .T. Hay Concptos Individuales
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL nMesFinTpa := 0                // Mes Final del pago
       LOCAL cEstadoTpa := ''               // Estado del pago
       LOCAL nVlrMesTpa := 0                // Valor recibo para un mes
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
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
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct)   .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nMesFinCaA == 0
	    cError('SE DEBE DEFINIR EL MES FINAL DE LA FACTURACION')


       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA > 9
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE CAA->nDesGenCaA # 0 .AND. CAA->nRecGenCaA # 0
	    cError('NO SE PUEDE APLICAR DESCUENTOS Y RECARGOS A LA VEZ')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ANALISIS DE DECISION DEL DESCUENTO GENERAL
       IF !EMPTY(CAA->nDesGenCaA) .OR. !EMPTY(CAA->nRecGenCaA)

**********ANALISIS DE DESCUENTO O RECARGO
	    DO CASE
	    CASE !EMPTY(CAA->nDesGenCaA)
		 cMsgTxt := 'DESCUENTO'
		 nVlrGen := CAA->nDesGenCaA

	    CASE !EMPTY(CAA->nRecGenCaA)
		 cMsgTxt := 'RECARGO'
		 nVlrGen := CAA->nRecGenCaA
	    ENDCASE
**********FIN ANALISIS DE DESCUENTO O RECARGO

**********PREGUNTA DE DECISION
	    lDesGen := .T.
	    IF !lPregunta('VA APLICAR UN '+cMsgTxt+' GENERAL DE '+;
			  TRANS(nVlrGen,'$999999.99')+' PESOS? Si No')

	       IF CAA->(lRegLock(lShared,.F.))
		  REPL CAA->nDesGenCaA WITH 0
		  REPL CAA->nRecGenCaA WITH 0
		  REPL CAA->cConGenCaA WITH ''
	       ENDIF
	     *ÀBorrado de los datos del descuento o recargo general

	       lDesGen:= .F.
	    ENDIF

	    IF !lPregunta('DESEA CONTINUAR? Si No')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN PREGUNTA DE DECISION

       ENDIF
*>>>>FIN ANALISIS DE DECISION DEL DESCUENTO GENERAL

*>>>>VALIDACION DEL CONCEPTO GENERAL
       IF lDesGen
	  IF !lLocCodigo('cCodigoCon','CON',CAA->cConGenCaA)
	     cError('NO EXISTE EL CONCEPTO GENERAL '+CAA->cConGenCaA)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL CONCEPTO GENERAL

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
		   nMesIniTpa,nMesFinTpa,cAnoUsr)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nMesIniTpa,;
				nMesFinTpa,cAnoUsr)})

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN PREGUNTA DE DECISION

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       cSavLin := SAVESCREEN(nFilInf+1,nColInf+09,nFilInf+1,79)
       DO WHILE .T.

**********CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR
	    SET DEVICE TO SCREEN
	    RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
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
				     cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI TIENE CONCEPTOS INDIVIDUALES
	    IF EMPTY(&cMaeAct->cConcepEst)
	       cError(cNombreTes+' NO TIENE CONCEPTOS INDIVIDUALES')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI TIENE CONCEPTOS INDIVIDUALES

**********VALIDACION DE LOS CONCEPTOS INDIVIDUALES
	    lHayCoE := lHayConCoE(cCodigoTes,&cMaeAct->cConcepEst)
	    IF !lHayCoE
	       cError(cNombreTes+' NO TIENE CONCEPTOS INDIVIDUALES HABILITADOS')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS CONCEPTOS INDIVIDUALES

**********LECTURA Y VALIDACION DE LA FECHA DEL ABONO
	    nSdoFav := 0
	    cSavlin := SAVESCREEN(nFilInf+1,nColInf+09,nFilInf+1,79)
/*	    IF lPregunta('DESEA APLICAR UN SALDO A FAVOR? No Si')
	       @nFilInf+1,nColInf+09 SAY "SALDO A FAVOR:";
				     GET nSdoFav PICT '9999999'
	       READ
	    ENDIF */
**********FIN LECTURA Y VALIDACION DE LA FECHA DEL ABONO

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(RTRIM(cNombreTes)+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cMaeAct->cCodigoGru)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********CAPTURA DE LOS MESES A FACTURAR
	    cSavPan := SAVESCREEN(0,0,24,79)
	    nMesIniTpa := 0 ; nMesFinTpa := 0
	    nMesIniTpa := nMesano(nFilInf+3,IF(nColInf+49>80,31,nColInf),;
				  'Mes del Recibo a Facturar',.T.)
	    nMesFinTpa := nMesIniTpa
	    RESTSCREEN(0,0,24,79,cSavPan)

	    IF nMesIniTpa == 0 .OR. nMesFinTpa == 0
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN CAPTURA DE LOS MESES A FACTURAR

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cMaeAct->lRetiroEst
	       cError(cNombreTes+' DEL GRUPO '+&cMaeAct->cCodigoGru+;
		     ' ESTA RETIRADO')

	       IF nMesIniTpa > &cMaeAct->nUltRecEst
		  cError('EL ULTIMO RECIBO AUTORIZADO PARA IMPRIMIR ES EL '+;
			 'DEL MES DE '+cMes(&cMaeAct->nUltRecEst))
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       cError('NO SE IMPRIME EL RECIBO. DECIDIO NO CONTINUAR')
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ANALISIS PARA LA IMPRESION DEL RECIBO
	    nRegPag := 0
	    IF !lDobleFac(CLI->cCodigoEst,nMesIniTpa,nMesFinTpa,;
			  CLI->cMesPagCli,@nRegPag,cNombreTes,;
			  &cMaeAct->nUltRecEst,lHayCoE)

	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
	    SELECT CLI
**********FIN ANALISIS PARA LA IMPRESION DEL RECIBO

**********GRABACION DEL CONTROL CONCEPTOS INDIVIDUALES
	    SaveConCoE(lShared,cNomUsr,cCodigoTes,;
		       nMesIniTpa,CAA->nMesFinCaA,;
		       ALLTRIM(CAA->cConPenCaA),;
		       CLI->cMesPagCli)
	  *ÀConceptos Generales

	    SaveConCoE(lShared,cNomUsr,cCodigoTes,;
		       nMesIniTpa,CAA->nMesFinCaA,;
		       ALLTRIM(&cMaeAct->cConcepEst),;
		       '')
	  *ÀConceptos Individuales
**********FIN GRABACION DEL CONTROL CONCEPTOS INDIVIDUALES

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('DE '+cMes(nMesIniTpa,3)+;
			' A '+cMes(nMesFinTpa,3)+;
			'ºGRUPO: '+&cMaeAct->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			'ºNo. '+STR(CLI->(RECCOUNT()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********INICIALIZACION DE LOS CONCEPTOS
	    aConcep := aConEst(CLI->cCodigoEst,;
			       CAA->cConPenCaA,;
			       &cMaeAct->cConcepEst,;
			       &cMaeAct->cCodigoGru,;
			       nMesIniTpa,;
			       nMesFinTpa,;
			       &cMaeAct->nUltRecEst,.T.)

	    cConcep := cConcep(aConcep)
	    cConcep := SUBS(cConcep+SPACE(14),1,14)

	    IF LEN(aConcep) == 0
	       cError('NO TIENE CONCEPTOS POR FACTURAR')
	       LOOP
	    ENDIF

	    IF !lLeeMesCon(CLI->cCodigoEst,cNombreTes,;
			   aConcep,nMesIniTpa,;
			   &cMaeAct->nUltRecEst)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
	    SELECT CLI
**********FIN INICIALIZACION DE LOS CONCEPTOS

**********ACTIVACION DE LA IMPRESORA
	    IF CAR->lPrnArcCar
	       SET DEVICE TO PRINT
	    ELSE
	       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcRecCar,.F.)
	       IF EMPTY(nOpcPrn)
		  CloseDbf('CLI',FileCli,nModCry)
		  CloseDbf('PAG',FilePag,nModCry)
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF
	    ENDIF
	    IF CAA->nRecNroCaA < 5
	       SendCodes(INICIALIZA+PROPOR_OF+DRAFT_ON)
	    ENDIF
**********FIN ACTIVACION DE LA IMPRESORA

**********CONFIGURACION DEL TAMA¥O DEL PAPEL
	    DO CASE
	    CASE CAA->nRecNroCaA == 1
		 SendCodes(IF(CAA->lPrePrnCaA,LINESP1_8+TAMPA34,TAMPA22))
		 SendCodes(CONDEN_ON)

	    CASE CAA->nRecNroCaA == 2
		 SendCodes(TAMPA22)
		 SendCodes(CONDEN_ON)

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4
		 SendCodes(LINESP1_8+TAMPA34)
		 SendCodes(CONDEN_ON)

	    ENDCASE
	    lPrnGru := .F.
**********FIN CONFIGURACION DEL TAMA¥O DEL PAPEL

**********IMPRISION DEL RECIBO DE PAGO
	    lHayBec := .F.
	    DO CASE
	    CASE CAA->nRecNroCaA == 1

	    CASE CAA->nRecNroCaA == 2

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4

		 nVlrTot := nRecibo06(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,aConcep,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
			   *Recibo dise¤o Colegio la Salle con Colilla

	    CASE CAA->nRecNroCaA == 5 .OR. CAA->nRecNroCaA == 6

		 nVlrTot := nRecibo07(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,aConcep,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo c¢digo de Barras la Kiosera

	    CASE CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9

		 nVlrTot := nRecibo10(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,aConcep,;
				      CAA->nIntPenCaA,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo c¢digo de Barras la Kiosera. La Salle

	    ENDCASE

	    IF VALTYPE(nVlrTot) == 'C'
	       cError('Hay Problemas en los valores o los Nombres',;
		      'Por Favor Revise las Tarifas o Conceptos')
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
	    lPrnGru := .T.
**********FIN IMPRISION DEL RECIBO DE PAGO

**********ANALISIS DEL SALDO PARA EL ESTADO DEL PAGO
	    IF CLI->nSdoActCli = 0
	       cEstadoTpa := 'P'
	    ELSE
	       cEstadoTpa := '*'
	      *Marca por deuda pendiente
	    ENDIF
**********FIN ANALISIS DEL SALDO PARA EL ESTADO DEL PAGO

**********GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES
	    IF CLI->(lRegLock(lShared,.F.))

*--------------GRABA LA FORMA DE PAGO POR DEFECTO
		 REPL CLI->cNrocopCli WITH STUFF(CLI->cNroCopCli,;
				      nMesIniTpa*2-1,2,cCopias(nMesIniTpa))

		 REPL CLI->cMesPagCli WITH STUFF(CLI->cMespagCli,;
				      nMesIniTpa,1,cEstadoTpa)
*--------------FIN GRABA LA FORMA DE PAGO POR DEFECTO

*--------------BORRA CONTROL DE MESES ADELANTADOS POR ANULACION DEL RECIBO
		 IF nRegPag # 0  //Ya existe un recibo

		    PAG->(DBGOTO(nRegPag))
		   *Se ubica en registro del recibo a anular

		    FOR i := IF(PAG->nMesIniPag==12,12,PAG->nMesIniPag+1);
			TO PAG->nMesFinPag
			REPL CLI->cMesPagCli;
			     WITH STUFF(CLI->cMesPagCli,i,1,SPACE(01))
		    NEXT
		  *ÀBorra control de los meses adelantados

		 ENDIF
*--------------FIN BORRA CONTROL DE MESES ADELANTADOS POR ANULACION DEL RECIBO

	       CLI->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES

**********ANALISIS PARA LA GRABACION DEL PAGO
	    SELECT PAG
	    IF nRegPag # 0
	       GO nRegPag
	       lGrabar := PAG->(lRegLock(lShared,.F.))
	    ELSE
	       lGrabar := PAG->(lRegLock(lShared,.T.))
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION DEL PAGO

**********GRABACION DE LOS DETALLES DEL PAGO
	    IF lGrabar
	       REPL PAG->cCodigoEst WITH CLI->cCodigoEst
	       REPL PAG->nNroFacCaA WITH nNroFac
	       IF BAN->(RECCOUNT()) == 1
		  REPL PAG->cCodigoBan WITH CAA->cCodigoBan
	       ENDIF

	       IF CAA->lIntPenCaA
		  REPL PAG->lIntPenPag WITH .T.  //m
		  REPL PAG->nIntMorPag WITH CAA->nIntPenCaA
		  REPL PAG->nVlrMorPag WITH 0
	       ELSE
		  REPL PAG->lIntPenPag WITH .F.  //m
		  REPL PAG->nVlrMorPag WITH IF(nVlrTot==0,0,CAA->nVlrMorCaA)
		  REPL PAG->nIntMorPag WITH 0
	       ENDIF

	       REPL PAG->nMesIniPag WITH nMesIniTpa
	       REPL PAG->nMesFinPag WITH nMesFinTpa
	       REPL PAG->nMesAmnPag WITH CAA->nMesAmnCaA //m
	       REPL PAG->cAtrasoPag WITH cAtrasos()
	       REPL PAG->nSdoAntPag WITH CLI->nSdoActCli
	       REPL PAG->nMorAntPag WITH CLI->nSdoMorCli
	       REPL PAG->nSdoAnoPag WITH CLI->nSdoAnoCli
	       REPL PAG->nMorAnoPag WITH CLI->nMorAnoCli
	       REPL PAG->nVlrCo1Pag WITH nVlrCo1
	       REPL PAG->nVlrCo2Pag WITH nVlrCo2
	       REPL PAG->nVlrCo3Pag WITH nVlrCo3
	       REPL PAG->nVlrCo4Pag WITH nVlrCo4
	       REPL PAG->nVlrCo5Pag WITH nVlrCo5
	       REPL PAG->nVlrCo6Pag WITH nVlrCo6
	       REPL PAG->nVlrCo7Pag WITH nVlrCo7
	       REPL PAG->nVlrCo8Pag WITH nVlrCo8
	       REPL PAG->cIniFinPag WITH cIniFin(aConcep)
	       REPL PAG->nVlrMesPag WITH nVlrMesTpa
	       REPL PAG->nVlrpagPag WITH nVlrTot
	       REPL PAG->nSdoFavPag WITH nSdoFav
	       REPL PAG->nFavDesPag WITH nFavDes
	       REPL PAG->cConcepPag WITH cConcep
	       REPL PAG->lHayBecPag WITH lHayBec
	       REPL PAG->nPorBecPag WITH CLI->nPorBecCli
	       REPL PAG->nVlrBecPag WITH nVlrBec
	       REPL PAG->nVlrDesPag WITH nDescue
	       REPL PAG->nPagParPag WITH nPagPar
	       REPL PAG->nVlrRecPag WITH nRecarg
	       REPL PAG->nDesGenPag WITH nDesGen
	       REPL PAG->nRecGenPag WITH nRecGen
	       REPL PAG->cConGenPag WITH cConGen
	       REPL PAG->dFecFacPag WITH DATE()
	       REPL PAG->dPagopoPag WITH CAA->dOpoPenCaA
	       REPL PAG->dPagextPag WITH CAA->dExtPenCaA
	       REPL PAG->dFecPagPag WITH CTOD("00/00/00")
	       REPL PAG->cEstadoPag WITH cEstadoTpa
	       REPL PAG->cNomUsrPag WITH cNomUsr
	       REPL PAG->dFecUsrPag WITH DATE()
	       REPL PAG->cHorUsrPag WITH TIME()
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO

***********GRABACION DE LA FORMA DE PAGO
	     cMesPagCoE(lShared,;
			CLI->cCodigoEst,;
			ALLTRIM(PAG->cConcepPag)+;
			ALLTRIM(CLI->cConSdoCli),;
			PAG->nMesIniPag,;
			PAG->cIniFinPag,;
			IF(cEstadoTpa=='P','F',cEstadoTpa))
***********FIN GRABACION DE LA FORMA DE PAGO

***********BORRA CONTROL DE MESES ADELANTADOS POR ANULACION DEL RECIBO
	     IF nRegPag # 0  //Ya existe un recibo

*===============ANALISIS DE LOS MESES A BORRAR
		  PAG->(DBGOTO(nRegPag))
		 *Se ubica en registro del recibo a anular

		  FOR i := 1 TO LEN(aConcep)

		      nMesFin := aConcep[i,3]
		      nMesIni := IF(nMesFin==12,12,nMesFin+1)
		      nMesFin := 12

		      aConcep[i,2] := nMesIni
		      aConcep[i,3] := nMesFin

		  ENDFOR
*===============FIN ANALISIS DE LOS MESES A BORRAR

*===============BORRAR CONTROL DE LOS MESES POR ADELANTADO
		  cMesPagCoE(lShared,;
			     CLI->cCodigoEst,;
			     PAG->cConcepPag,;
			     PAG->nMesIniPag,;
			     cIniFin(aConcep),;
			     ' ')
		*ÀBorra control de los meses adelantados
*===============FIN BORRAR CONTROL DE LOS MESES POR ADELANTADO

	     ENDIF
	     EJECT
	     CloseDbf('CLI',FileCli,nModCry)
	     CloseDbf('PAG',FilePag,nModCry)
***********FIN BORRA CONTROL DE MESES ADELANTADOS POR ANULACION DEL RECIBO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION

