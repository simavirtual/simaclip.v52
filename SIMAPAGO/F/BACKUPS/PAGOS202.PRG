/* SIMA - CUENTAS POR PAGAR

MODULO      : FACTURAS
SUBMODULO...: GRABAR                                     MODULO No. 101

**************************************************************************
* TITULO..: PAGO DE FACTURAS                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/2004 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   OCT 15/2004 VIE

OBJETIVOS:

1- Permite ..

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pagos_202(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatDat,cPatSys,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PAGOS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL aColFac := {}                  // Columnas de la Fila
       LOCAL nFilSup := 0                   // Fila superior de lectura
       LOCAL lAnexar := .T.                 // .T. Anexar ?Verificar
       LOCAL lGrabar := .F.                 // .T. Grabar el Registro
       LOCAL aRegCpI := {}                  // Registros Comprobantes Items

       LOCAL cDocNit := ''                  // Documento de Identificaci¢n
       LOCAL cTipDoc := ''                  // Tipo de Documento

       LOCAL dFecChe := CTOD('00/00/00')    // Fecha del Cheque
       LOCAL nVlrChe := 0                   // Valor del Cheque
       LOCAL cDocChe := ''                  // Documento para el Cheque
       LOCAL cTntChe := ''                  // Tipo de Documento para el Cheque

       LOCAL nNroCpb := 0                   // N£mero del Comprobante
       LOCAL nNroChe := 0                   // C¢digo de la Fecha
       LOCAL cCodFac := ''                  // C¢digo de la Factura
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL aFecUsr := {}                  // Fecha del Usuario
       LOCAL dFecUsr := CTOD('00/00/00')    // Fecha del Usuario

       LOCAL dFecFac := CTOD('00/00/00')    // Fecha de la Factura
       LOCAL dFecVto := CTOD('00/00/00')    // Fecha de Vencimiento

       LOCAL nVlrRtf := 0                   // Valor de la Retenci¢n
       LOCAL cDescri := ''                  // Descripci¢n.
       LOCAL nBasRtf := 0                   // Valor Base para Retenci¢n
       LOCAL nVlrIva := 0                   // Valor del Iva
       LOCAL lHayArt := .T.                 // .T. Grabar Articulos
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCxP,'CXP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 fPers00,'P00',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 Ntx2P00,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileEmp,'EMP',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxEmp,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FilePuc,'PUC',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FilePrv,'PRV',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxPrv,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileFac,'FAC',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxFac,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileCpb,'CPB',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxCpb,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileCpI,'CPI',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileRtf,'RTF',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CXP->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE RTF->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE RETENCION GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CXP->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CXP->lPrnArcCxP
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'empresas'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CXP->cOpcPrnCxp,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>LECTURA DE LA FACTURA
       aNroCol := aFormatCpb(nFilPal+1,dFecUsr,cNomUsr,@aColFac,lHayArt)
      *Formato de lectura de la transaccion

       nNroCpb := nNroChe
       nNroChe := 9995

       cDocNit := SPACE(16)
       cTipDoc := SPACE(01)

       cDocChe := SPACE(16)
       cTntChe := SPACE(01)
       dFecChe := CTOD('00/00/00')
       nVlrChe := 0

       aRegCpI := {}

       lGrabar := lLeerCpb(lShared,cNomUsr,nNroCpb,nNroChe,@cDocNit,@cTipDoc,;
			   @dFecChe,@nVlrChe,@cDocChe,@cTntChe,aColFac,;
			   aNroCol,@aRegCpI)
*>>>>FIN LECTURA DE LA FACTURA

*>>>>IMPRESION DEL COMPROBANTE
       IF lGrabar
	  lPrnCpb01(lShared,cNomUsr,nNroCpb,nNroChe,cDocNit,cTipDoc,;
		    cDocChe,cTntChe,dFecChe,nVlrChe,aRegCpI)
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL COMPROBANTE