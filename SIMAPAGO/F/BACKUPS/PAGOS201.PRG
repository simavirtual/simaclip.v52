/* SIMA - CUENTAS POR PAGAR

MODULO      : FACTURAS
SUBMODULO...: GRABAR                                     MODULO No. 101

**************************************************************************
* TITULO..: PAGOS                                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 10/2004 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 10/2004 VIE

OBJETIVOS:

1- Permite ..

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pagos_201(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL aColFac := {}                  // Columnas de la Fila
       LOCAL aFacCol := {}                  // Columnas de la Fila
       LOCAL nFilSup := 0                   // Fila superior de lectura
       LOCAL lAnexar := .T.                 // .T. Anexar ?Verificar
       LOCAL lGrabar := .F.                 // .T. Grabar el Registro
       LOCAL aRegCpI := {}                  // Registros Comprobantes Items
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL cPagLen := ''                  // L¡neas por P ginas

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
       LOCAL lUnaCta := .T.                 // .T. Una cuenta Puc .F. Varias Cuentas

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

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FCxPAno+cAnoUsr+ExtFile,'CXA',NIL,lShared,nModCry})

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

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileCuC,'CUC',NIL,lShared,nModCry})
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

       CASE EMPTY(CXP->cTitEmpCxP)
	    cError('NO SE HA DEFINIDO EL ID DE LA EMPRESA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CXA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE CXA->nRecCpbCaA == 0 .OR. CXA->nRecCpbCaA > 1
	    cError('EL RECIBO No.'+STR(CXA->nRecCpbCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE CUC->(RECCOUNT()) == 0
	    cError('NO EXISTEN CUENTAS CORRIENTES GRABADAS')

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
	  FilePrn := 'cmp'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CXP->cOpcPrnCxp,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>LOCALIZACION DE LA CUENTA CORRIENTE
       SET DEVICE TO SCREEN
       IF !lLocCodigo('cNumeroCuC','CUC',CUC->cNumeroCuC)
	  cError('NO EXISTE LA CUENTA CORRIENTE CONFIGURADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA CUENTA CORRIENTE

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'ELABORACION DE COMPROBANTES',22,'°')
       cCabeza := cRegPrint({'BANCO',;
			     'CUENTA CORRIENTE',;
			     'CHEQUE No.'},;
			    {06,20,10},@aNroCol)
       @ nNroFil++,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ELABORACION DE LOS COMPROBANTES
       nNroChe := CUC->nNumeroChe+1
       nNroCpb := nNroChe
       DO WHILE .T.

**********ANALISIS DE DECISION
	    cSavPan := SAVESCREEN(0,0,24,79)

	    @ nNroFil,aNroCol[1] SAY CUC->cCodBanCuC COLOR('I')
	    @ nNroFil,aNroCol[2] SAY CUC->cNumeroCuC COLOR('I')
	    @ nNroFil,aNroCol[3] SAY STR(nNroChe,9)  COLOR('I')

	    IF !lPregunta('DESEA ELABORAR EL COMPROBANTE CON CHEQUE No. '+;
			  ALLTRIM(STR(nNroChe,9))+'? No Si')
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DEL COMPROBANTE
	    cDocNit := cSpaces('FAC','cDocNitFac')
	    cTipDoc := cSpaces('FAC','cTipNitFac')

	    cDocChe := cSpaces('FAC','cDocNitFac')
	    cTntChe := cSpaces('FAC','cTipNitFac')
	    dFecChe := CTOD('00/00/00')
	    nVlrChe := 0

	    cDescri := cSpaces('CPB','cDescriCpb')
	    aRegCpI := {}

	    aFilCol := aFormatCpb(nFilPal+1,dFecUsr,cNomUsr,@aColFac,;
				  lUnaCta,lHayArt)
	   *Formato de lectura de la transaccion

	    lGrabar := lLeerCpb(lShared,cNomUsr,lUnaCta,nNroCpb,nNroChe,;
				@cDocNit,@cTipDoc,@dFecChe,@nVlrChe,;
				@cDocChe,@cTntChe,@cDescri,aColFac,;
				aFilCol,@aRegCpI)
**********FIN LECTURA DEL COMPROBANTE

**********IMPRESION DEL COMPROBANTE
	    IF lGrabar

	       SET DEVICE TO PRINT
	       DO CASE
	       CASE CXA->nRecCpbCaA == 1
		    lPrnCpb01(lShared,cNomUsr,lUnaCta,nNroCpb,nNroChe,;
			      cDocNit,cTipDoc,cDocChe,cTntChe,cDescri,;
			      dFecChe,nVlrChe,aRegCpI)
	       ENDCASE
	       SET DEVICE TO SCREEN

	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN IMPRESION DEL COMPROBANTE

       ENDDO
       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN ELABORACION DE LOS COMPROBANTES

/*************************************************************************
* TITULO..: LECTURA DE LAS TRANSACCIONES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 29/95 SAB A
       Colombia, Bucaramanga        INICIO: 07:27 PM   JUL 29/95 SAB

OBJETIVOS:

1- Permite leer los datos del encabezado de la trasacci¢n.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna .T. si leyo los datos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeerCpb(lShared,cNomUsr,lUnaCta,nNroCpb,nNroChe,cDocNit,cTipDoc,;
		  dFecChe,nVlrChe,cDocChe,cTntChe,cDescri,aColFac,aNroCol,;
		  aRegCpI)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       lUnaCta                              // .T. Una cuenta Puc .F. Varias Cuentas
       nNroCpb                              // N£mero del Comprobante
       nNroChe                              // N£mero del Cheque
       cDocNit			            // @Documento de Identificaci¢n
       cTipDoc                              // @Tipo de Documento
       dFecChe                              // @Fecha del Cheque
       nVlrChe                              // @Valor del Cheque
       cDocChe                              // @Documento para el Cheque
       cTntChe                              // @Tipo de Documento para el Cheque
       cDescri                              // @Descripci¢n
       aColFac                              // Columnas de la Fila
       aNroCol                              // Columnas de los Items */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .T.                 // .T. Hay Error

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cOpcLec := '-'                 // Opci¢n de lectura
       LOCAL cValLec := ''                  // Caracteres a validar
       LOCAL nOpcion := 0                   // Opci¢n
       LOCAL cTxtHlp := ''                  // Texto de Ayuda

       LOCAL cCodPuc := SPACE(20)           // C¢digo del Puc
       LOCAL cCodRtf := SPACE(04)           // C¢digo de la Retenci¢n
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL cNombre := ''                  // Nombre del Proveerdor

       LOCAL GetList := {}                  // Variable del Sistema
       SET CONFIRM    OFF                   // Confirmaci¢n salida Gets
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NUMERO DEL CHEQUE
       @ 06,aColFac[1] SAY nNroChe PICT "999999999" COLOR('I*')
*>>>>FIN NUMERO DEL CHEQUE

*>>>>LECTURA Y VALIDACION DE LA TRANSACCION
       DO WHILE .T.

**********CAPTURA DE LA FECHA DEL CHEQUE
	    SET ESCAPE     ON               // Activa <ESC> salida GETS
	    nNroFil := 06
	    IF (cOpcLec == '-' .OR. cOpcLec == 'F')

	       cTxtHlp := '<ESC>ABANDONA. POR FAVOR DIGITE LA FECHA '+;
			  'DEL CHEQUE: MM/DD/AAAA'
	       @ nNroFil,aColFac[2] GET dFecChe PICT "@D";
				    VALID !EMPTY(dFecChe);
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF

	    IF LASTKEY() == 27
	       IF !lPregunta('DESEA CONTINUAR? No Si')
		  nOpcion := 3
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
	    SET ESCAPE     OFF              // DesActiva <ESC> salida GETS
**********FIN CAPTURA DE LA FECHA DEL CHEQUE

**********CAPTURA DEL VALOR DEL CHEQUE
	    nNroFil := 06
	    IF cOpcLec == '-' .OR. cOpcLec == 'V'

	       cTxtHlp := 'POR FAVOR DIGITE EL VALOR DEL CHEQUE'
	       @ nNroFil,aColFac[3] GET nVlrChe PICT "@!";
				    VALID !EMPTY(nVlrChe);
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DEL VALOR DEL CHEQUE

**********DOCUMENTO DEL PROVEEDOR
	    nNroFil += 01
	    DO WHILE cOpcLec == '-' .OR. cOpcLec == 'D'

*==============CAPTURA DEL DOCUMENTO DEL PROVEEDOR
		 IF cOpcLec == '-' .OR. cOpcLec == 'D'
		    cTxtHlp := 'POR FAVOR DIGITE EL NIT O DOCUMENTO DE IDENTIDAD'
		    @ nNroFil,aColFac[4] GET cDocNit PICT "9999999999999999";
					 VALID !EMPTY(cDocNit);
					 WHEN {||HelpRead(cTxtHlp)}
		    READ
		 ENDIF
*==============FIN CAPTURA DEL DOCUMENTO DEL PROVEEDOR

*==============CAPTURA DEL TIPO DE DOCUMENTO DEL PROVEEDOR
		 IF cOpcLec == '-' .OR. cOpcLec == 'D'

		    cTxtHlp := 'POR FAVOR DIGITE EL TIPO DE DOCUMENTO'
		    @ nNroFil,aColFac[5] GET cTipDoc PICT "9";
					 VALID lValTipDoc(ROW()+1,COL()-18,;
					       @cTipDoc,'12')  .AND.;
					       !EMPTY(cTipDoc) .AND.;
					       HelpRead();
					 WHEN {||HelpRead(cTxtHlp)}
		    READ
		 ENDIF
*==============FIN CAPTURA DEL TIPO DE DOCUMENTO DEL PROVEEDOR

*==============VALIDACION DE EXISTENCIA DEL PROVEEDOR
		 lHayErr := .F.
		 cNalias := ''
		 IF !lValDoc(cDocNit,cTipDoc,@cNalias)

*-------------------ANALISIS DE DECISION
		      lHayErr := .T.
		      cError('EL PROVEEDOR NO EXISTE')

		      IF !lPregunta('DESEA GRABAR LOS DATOS '+;
				    'DEL PROVEEDOR? Si No')
			 EXIT
		      ENDIF
		      cSavPan := SAVESCREEN(0,0,24,79)
*-------------------FIN ANALISIS DE DECISION

*-------------------GRABACION DEL PROVEEDOR
		      DO CASE
		      CASE cNalias == 'P00'
			   IncluirP00(lShared,cDocNit,cTipDoc)

		      CASE cNalias == 'EMP'
			   lManRegEmp(lShared,cNomUsr,1,NIL,cDocNit,cTipDoc)

		      ENDCASE
		      RESTSCREEN(0,0,24,79,cSavPan)
*-------------------FIN GRABACION DEL PROVEEDOR

*-------------------VALIDACION DE EXISTENCIA DEL PROVEEDOR
		      IF lValDoc(cDocNit,cTipDoc)
			 lHayErr := .F.
			 EXIT
		      ELSE
			 lHayErr := .T.
		      ENDIF
*-------------------FIN VALIDACION DE EXISTENCIA DEL PROVEEDOR

		 ENDIF
*==============FIN VALIDACION DE EXISTENCIA DEL PROVEEDOR

*==============ANALISIS DE DECISION
		 IF .NOT. lHayErr
		    EXIT
		 ENDIF
*==============FIN ANALISIS DE DECISION

	    ENDDO
**********FIN DOCUMENTO DEL PROVEEDOR

**********ANALISIS DE DECISION
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********NOMBRE DEL PROVEEDOR
	    DO CASE
	    CASE cNalias == 'P00'
		 cNombre := cNomApePer()

	    CASE cNalias == 'EMP'
		 cNombre := ALLTRIM(EMP->cNombreEmp)

	    ENDCASE
	    @ nNroFil+1,aColFac[9]+2 SAY cNombre+SPACE(40);
				     PICT "@S41" COLOR('I')
**********FIN NOMBRE DEL PROVEEDOR

**********FILTRACION DE LAS FACTURAS
	    SELECT FAC
	    SET FILTER TO FAC->cDocNitFac == cDocNit .AND.;
			  FAC->cTipNitFac == cTipDoc .AND.;
			  FAC->nNumeroChe == 0

	    FAC->(DBGOTOP())
	    IF FAC->(EOF())
	       SET FILTER TO
	       cError('NO EXISTEN FACTURAS POR PAGAR A ESTE PROVEEDOR')
	       EXIT
	    ENDIF
**********FIN FILTRACION DE LAS FACTURAS

**********LECTURA CODIGO DE LA RETENCION
	    IF (cOpcLec == '-' .OR. cOpcLec == 'R')

	       cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA RETENCION'
	       @ nNroFil,aColFac[6] GET cCodRtf PICT "@!";
				    VALID lValRtf(ROW()+1,COL()-20,@cCodRtf);
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
	    @ nNroFil+1,aColFac[9]+2 SAY ALLTRIM(RTF->cNombreRtf)+SPACE(40);
				     PICT "@S41" COLOR('I')
**********FIN LECTURA CODIGO DE LA RETENCION

**********CAPTURA DE LA CUENTA PUC
	    IF lUnaCta
	       IF (cOpcLec == '-' .OR. cOpcLec == 'C')

		  cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA CUENTA'

		  @ nNroFil,aColFac[7] GET cCodPuc;
				       PICT "@S18 99999999999999999999";
				       VALID lValPuc(ROW()+1,COL()-23,@cCodPuc) .AND.;
					     !EMPTY(cCodPuc);
				       WHEN {||HelpRead(cTxtHlp)}
		  READ
	       ENDIF
	    ENDIF
**********FIN CAPTURA DE LA CUENTA PUC

**********CONSULTA DEL NOMBRE DE LA CUENTA
	    IF lUnaCta
	       @ nNroFil+1,aColFac[9]+2 SAY ALLTRIM(PUC->cNombrePuc)+SPACE(40);
					PICT "@S41" COLOR('I')
	    ENDIF
**********FIN CONSULTA DEL NOMBRE DE LA CUENTA

**********DOCUMENTO PARA GIRAR EL CHEQUE
	    IF EMPTY(cDocChe)
	       cDocChe := cDocNit
	       cTntChe := cTipDoc
	    ENDIF
**********FIN DOCUMENTO PARA GIRAR EL CHEQUE

**********DOCUMENTO PARA GIRAR EL CHEQUE
	    nNroFil += 01
	    DO WHILE cOpcLec == '-' .OR. cOpcLec == 'D'

*==============CAPTURA DEL DOCUMENTO
		 IF cOpcLec == '-' .OR. cOpcLec == 'D'
		    cTxtHlp := 'POR FAVOR DIGITE EL NIT O DOCUMENTO DE IDENTIDAD'
		    @ nNroFil,aColFac[8] GET cDocChe PICT "9999999999999999";
					 VALID !EMPTY(cDocChe);
					 WHEN {||HelpRead(cTxtHlp)}
		    READ
		 ENDIF
*==============FIN CAPTURA DEL DOCUMENTO

*==============CAPTURA DEL TIPO DE DOCUMENTO
		 IF cOpcLec == '-' .OR. cOpcLec == 'D'

		    cTxtHlp := 'POR FAVOR DIGITE EL TIPO DE DOCUMENTO'
		    @ nNroFil,aColFac[9] GET cTipDoc PICT "9";
					 VALID lValTipDoc(ROW()+1,COL()-18,;
					       @cTipDoc,'12')  .AND.;
					       !EMPTY(cTipDoc) .AND.;
					       HelpRead();
					 WHEN {||HelpRead(cTxtHlp)}
		    READ
		 ENDIF
*==============FIN CAPTURA DEL TIPO DE DOCUMENTO

*==============VALIDACION DE EXISTENCIA DEL PROVEEDOR
		 lHayErr := .F.
		 cNalias := ''
		 IF !lValDoc(cDocChe,cTipDoc,@cNalias)

*-------------------ANALISIS DE DECISION
		      lHayErr := .T.
		      cError('EL PROVEEDOR NO EXISTE')

		      IF !lPregunta('DESEA GRABAR LOS DATOS '+;
				    'DEL PROVEEDOR? Si No')
			 EXIT
		      ENDIF
		      cSavPan := SAVESCREEN(0,0,24,79)
*-------------------FIN ANALISIS DE DECISION

*-------------------GRABACION DEL PROVEEDOR
		      DO CASE
		      CASE cNalias == 'P00'
			   IncluirP00(lShared,cDocChe,cTipDoc)

		      CASE cNalias == 'EMP'
			   lManRegEmp(lShared,cNomUsr,1,NIL,cDocChe,cTipDoc)

		      ENDCASE
		      RESTSCREEN(0,0,24,79,cSavPan)
*-------------------FIN GRABACION DEL PROVEEDOR

*-------------------VALIDACION DE EXISTENCIA DEL PROVEEDOR
		      IF lValDoc(cDocChe,cTipDoc)
			 lHayErr := .F.
			 EXIT
		      ELSE
			 lHayErr := .T.
		      ENDIF
*-------------------FIN VALIDACION DE EXISTENCIA DEL PROVEEDOR

		 ENDIF
*==============FIN VALIDACION DE EXISTENCIA DEL PROVEEDOR

*==============ANALISIS DE DECISION
		 IF .NOT. lHayErr
		    EXIT
		 ENDIF
*==============FIN ANALISIS DE DECISION

	    ENDDO
**********FIN DOCUMENTO PARA GIRAR EL CHEQUE

**********ANALISIS DE DECISION
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********PAGUESE A
	    DO CASE
	    CASE cNalias == 'P00'
		 cNombre := cNomApePer()

	    CASE cNalias == 'EMP'
		 cNombre := ALLTRIM(EMP->cNombreEmp)

	    ENDCASE
	    @ nNroFil,aColFac[9]+2 SAY cNombre+SPACE(40);
				     PICT "@S41" COLOR('I')
**********FIN PAGUESE A

**********CAPTURA DE LA DESCRIPCION
	    nNroFil += 01
	    IF (cOpcLec == '-' .OR. cOpcLec == 'P')

	       cTxtHlp := 'POR FAVOR DIGITE LA DESCRIPCION'
	       @ nNroFil,aColFac[10] GET cDescri PICT "@!";
				     VALID !EMPTY(cDescri);
				     WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA DESCRIPCION

**********CAPTURA DE LA OPCION DE LECTURA
	    cValLec := '+-FVDV'
	    cOpcLec := cOpcionLec(nNroFil,77,cValLec)
	    IF cOpcLec # '+'
	       LOOP
	    ENDIF
**********FIN CAPTURA DE LA OPCION DE LECTURA

**********LECTURA ITEMS DE LOS COMPROBANTES
	    leerMovi(lShared,cNomUsr,nNroFil+5,;
		     lUnaCta,cCodPuc,aNroCol,@aRegCpI)
**********FIN LECTURA ITEMS DE LOS COMPROBANTES

**********ANALISIS DE GRABACION
	    nOpcion := nLeeOpcion('OPCION: '+;
		      '1<IMPRIMIR> 2<CORREGIR> 3<ABANDONAR>?',3,'0',22)

	    IF nOpcion == 2
	       cOpcLec := '-'
	       LOOP
	    ENDIF
	    EXIT
**********FIN ANALISIS DE GRABACION

       ENDDO
       SELECT FAC
       SET FILTER TO
       SET CONFIRM    ON                    // Confirmaci¢n salida Gets
       RETURN IF(nOpcion==1,lGrabar,!lGrabar)
*>>>>FIN LECTURA Y VALIDACION DE LA TRANSACCION

/*************************************************************************
* TITULO..: LECTURA DE LOS ITEM DE LOS COMPROBANTES                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 12/2004 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   OCT 12/2004 MAR

OBJETIVOS:

1- Permite leer los items de los comprobantes

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna .T. si leyo los datos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION leerMovi(lShared,cNomUsr,nFilSup,lUnaCta,cCodPuc,aNroCol,aRegCpI)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       nFilSup                              // Fila de lectura
       lUnaCta                              // .T. Una cuenta Puc .F. Varias Cuentas
       cCodPuc                              // C¢digo del Puc
       aNroCol                              // Colemnas de lectura
       aRegCpI                              // Registros Comprobantes Items */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cSavLin := ''                  // .T. Salvar l¡nea
       LOCAL cSavLi1 := ''                  // .T. Salvar l¡nea

       LOCAL       i := 1                   // Indice
       LOCAL cOpcLec := ''                  // Opci¢n de lectura
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aCabeza := {}                  // Encabezados de columna
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cTxtHlp := ''                  // Texto de Ayuda

       LOCAL nNroReg := 0                   // N£mero del registro
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cDescri := 0                   // Descripci¢n
       LOCAL nTotTra := 0                   // Valor de la Transacci¢n
       LOCAL lInsReg := .T.                 // .T. Inserta .F. Correge
       LOCAL GetList := {}                  // Variable del Sistema

       SET CONFIRM    OFF                   // Confirmaci¢n salida Gets
       SET ESCAPE     OFF                   // DesActiva <ESC> salida GETS
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA GRABACION O CORRECION
       nNroFil := nFilSup
       IF !lInsReg

	  DO WHILE .T.
	     cOpcLec := cOpcionLec(nFilSup,aNroCol[6],'1234567890','9999')
	    *Captura de la opci¢n

	     i := VAL(cOpcLec)
	    *Indice a Corregir

	    IF i > LEN(aRegCpI)
	       LOOP
	    ENDIF
	    EXIT
	  ENDDO
       ENDIF
*>>>>CAPTURA DEL REGISTRO A CORREGIR

*>>>>CONSULTA DE LOS ITEMS GRABADOS
       cOpcLec := '+'

       cSavLin := SAVESCREEN(21,00,21,58)
       @ 21,60 SAY nTotTra PICT "@B 9999999,999,999.99" COLOR("I")
*>>>>FIN CONSULTA DE LOS ITEMS GRABADOS

*>>>>LECTURA Y VALIDACION DE LOS MOVIMIENTOS
       DO WHILE .T.

**********ANALISIS PARA LA CORRECION
	    IF i <= LEN(aRegCpI)

*--------------INICIALIZACION ARTICULO A CORREGIR
		 cCodFac := aRegCpI[i,1]
		 cCodPuc := aRegCpI[i,2]
		 cDescri := aRegCpI[i,3]
*--------------FIN INICIALIZACION ARTICULO A CORREGIR

	    ELSE

*--------------INICIALIZACION PARA GRABACION
		 IF cOpcLec = '+'

		    cCodFac := '*'+SPACE(19)
		    IF !lUnaCta
		       cCodPuc := SPACE(20)
		    ENDIF
		    cDescri := SPACE(40)

		 ENDIF
*--------------FIN INICIALIZACION PARA GRABACION

	    ENDIF
	    @ nNroFil,aNroCol[1] SAY i PICT '9999' COLOR("I")
**********FIN ANALISIS PARA LA CORRECION

**********CAPTURA Y VALIDACION CODIGO FACTURA
	    IF cOpcLec = '+' .OR. cOpcLec == '-' .OR. cOpcLec = 'F'

	       cSavLi1 := SAVESCREEN(nNroFil,00,nNroFil,79)
	       cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA FACTURA'

	       DO WHILE .T.

*=================LECTURA CODIGO FACTURA
		    @ nNroFil,aNroCol[2] GET cCodFac PICT "9999999999";
			      VALID EMPTY(cCodFac) .OR.;
				    lValFac(ROW(),COL(),@cCodFac) .AND.;
				    HelpRead();
			      WHEN {||HelpRead(cTxtHlp)}
		    READ
*=================FIN LECTURA CODIGO FACTURA

*=================VALIDACION DEL CODIGO
		    lHayErr := .T.
		    DO CASE
		    CASE ASCAN(aRegCpI,{|aArray|aArray[1] == cCodFac}) # 0 .AND.;
			 i > LEN(aRegCpI)
			 cError('YA SE SELECCIONO ESTA FACTURA')

		    CASE !EMPTY(FAC->nNumeroChe)
			 cError('ESTA FACTURA YA FUE PAGADA')

		    OTHERWISE
			 lHayErr := .F.
		    ENDCASE
		    IF lHayErr
		       LOOP
		    ENDIF
		    EXIT
*=================FIN VALIDACION DEL CODIGO

	       ENDDO
*--------------FIN CAPTURA DEL CODIGO

*--------------VALOR DE LA FACTURA
		 @ 21,02 SAY 'DESCRIPCION: FACTURA No. '+;
			     ALLTRIM(FAC->cNumeroFac) COLOR("I")
		*Visualizacion del nombre

		 @ nNroFil,aNroCol[IF(lUnaCta,3,5)] SAY FAC->nVlrTotFac PICT "9999999999"
*--------------FIN VALOR DE LA FACTURA

*--------------ANALISIS PARA LA SALIDA
		 IF LASTKEY() = 27
		    nFilSup := nNroFil
		    RETURN .F.
		 ENDIF

		 IF EMPTY(cCodFac)
		    nFilSup := nNroFil
		    RETURN .T.
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA

	    ENDIF
**********FIN CAPTURA Y VALIDACION CODIGO FACTURA

**********CAPTURA DE LA CUENTA PUC
	    IF .NOT. lUnaCta
	       IF cOpcLec = '+' .OR. cOpcLec == '-' .OR. cOpcLec = 'C'

		  cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA CUENTA'

		  @ nNroFil,aNroCol[3] GET cCodPuc PICT "99999999999999999999";
				       VALID lValPuc(ROW(),COL(),@cCodPuc) .AND.;
					     !EMPTY(cCodPuc);
				       WHEN {||HelpRead(cTxtHlp)}
		  READ
	       ENDIF
	    ENDIF
**********FIN CAPTURA DE LA CUENTA PUC

**********CAPTURA DE LA DESCRIPCION
	    IF .NOT. lUnaCta
	       IF cOpcLec = '+' .OR. cOpcLec == '-' .OR. cOpcLec = 'D'

		  cTxtHlp := 'POR FAVOR DIGITE LA DESCRIPCION'
		  cDescri := 'Pago Factura No. '+FAC->cNumeroFac
		  @ nNroFil,aNroCol[4] GET cDescri PICT '@XS20';
				       VALID HelpRead();
				       WHEN {||HelpRead(cTxtHlp)}
		  READ
	       ENDIF
	    ENDIF
**********FIN CAPTURA DE LA DESCRIPCION

***********LECTURA POR CORRECION SECUENCIAL
	     IF cOpcLec == '+' .OR. cOpcLec == '-'
		READ
	     ENDIF
***********FIN LECTURA POR CORRECION SECUENCIAL

***********CAPTURA Y VALIDACION DE LA OPCION DE LECTURA
	     DO WHILE .T.
		cOpcLec := cOpcionLec(nNroFil,;
				      aNroCol[IF(lUnaCta,4,6)],;
				      '+-FC','@!XXXX')
	       *Captura de la opci¢n

*---------------VALIDACION DEL REGISTRO A CORREGIR
		  nNroReg := 0
		  IF SUBS(cOpcLec,1,1) $ '123456789'

		      i := VAL(cOpcLec)
		     *Registro a corregir

		      IF i > LEN(aRegCpI)
			 LOOP
		      ENDIF
		    *ÀValidaci¢n del registro

		      cOpcLec := '-'
		    *ÀCorreci¢n del Registro

		  ENDIF
		  EXIT
*---------------FIN VALIDACION DEL REGISTRO A CORREGIR

	     ENDDO
***********FIN CAPTURA Y VALIDACION DE LA OPCION DE LECTURA

***********ANALISIS PARA LA CORRECCION
	     IF !(cOpcLec == CHR(27) .OR. cOpcLec == '+')
		IF cOpcLec == '-'
		   RESTSCREEN(nNroFil,00,nNroFil,79,cSavLi1)
		  *Borra l¡nea a corregir
		ENDIF
		LOOP
	     ENDIF
***********FIN ANALISIS PARA LA CORRECCION

***********ANALISIS PARA LA SALIDA
	     IF cOpcLec == CHR(27)
		EXIT
	     ENDIF
***********FIN ANALISIS PARA LA SALIDA

***********GRABACION DEL MOVIMIENTO
	     IF cOpcLec == '+'
		IF i > LEN(aRegCpi)
		   AADD(aRegCpI,{cCodFac,cCodPuc,cDescri,FAC->nBasRtfFac})
		ELSE
		   aRegCpI[i,1] := cCodFac
		   aRegCpI[i,2] := cCodPuc
		   aRegCpI[i,3] := cDescri
		   aRegCpI[i,4] := FAC->nBasRtfFac
		ENDIF
		i := LEN(aRegCpi)+1
	     ENDIF
***********FIN GRABACION DEL MOVIMIENTO

***********ACTUALIZACION DEL TOTAL DE LA TRANSACION
	     IF cOpcLec == '+'
		nTotTra += 0
	     ELSE
		nTotTra := nTotTra - 0
	     ENDIF
	     @ 21,60 SAY nTotTra PICT "@B 9999999999999999.99" COLOR("I")
***********FIN ACTUALIZACION DEL TOTAL DE LA TRANSACION

***********CONTROL DE LA FILA DE VISUALIZACION
	     nNroFil++
	     IF nNroFil > 19

*---------------VISUALIZACION DEL ULTIMO REGISTRO
		  nNroFil := nMarco(11,'',22,'°')

		  aCabeza := {'No.',;
			      'Factura',;
			      'Cuenta',;
			      'Descripcion',;
			      'Valor',;
			      'CORR'}

		  cMsgTxt := cRegPrint(aCabeza,;
				       {04,10,20,20,12,04},@aNroCol)

		  @ nNroFil-2,01 SAY cMsgTxt
		  @ 20,00 TO 20,79
		  @ 01,00 TO 22,79 DOUBLE
		  @ 21,02 SAY 'DESCRIPCION: ' COLOR("I")
		  @ 21,54 SAY 'TOTAL: ' COLOR("I")
*---------------FIN VISUALIZACION DEL ULTIMO REGISTRO

	     ENDIF
	     RESTSCREEN(21,00,21,58,cSavLin)
	    *Borra el nombre del art¡culo
***********CONTROL DE LA FILA DE VISUALIZACION

       ENDDO
       nFilSup := nNroFil

       SET CONFIRM ON
      *Confirmaci¢n salida Gets

       SET ESCAPE     ON                    // Activa <ESC> salida GETS

       RETURN IF(cOpcLec == '+',.T.,.F.)
*>>>>FIN LECTURA Y VALIDACION DE LOS MOVIMIENTOS

/*************************************************************************
* TITULO..: FORMATO DE CAPTURA DEL COMPROBANTE                           *
**************************************************************************

AUTOR: Nelson Fernández Gómez       FECHA DE CREACION: SEP 10/2004 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 10/2004 VIE

OBJETIVOS:

1- Imprime el formato de captura para la recepci¢n de las facturas

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aFormatCpb(nFilSup,dFecUsr,cNomUsr,aColFac,lUnaCta,lHayArt)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup                              // Fila Superior
       dFecUsr                              // Fecha del Usuario
       cNomUsr                              // Nombre del usuario
       cNomUsr			            // Nombre del Usuario
       aColFac                              // @Columnas de la Factura
       lUnaCta                              // .T. Una Cuenta Puc .F. Varias cuentas Puc
       lHayArt                              // .T. Hay Articulos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL aCabeza := {}                  // Encabezados de columna
       LOCAL aNroCol := {}                  // N£mero de columnas

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cSayTxt := ''                  // Color del Texto fijo
       LOCAL cSayDat := ''                  // Color para los datos
       LOCAL cClrMar := ''                  // Color del Marco y Fondo
       LOCAL cClrTit := ''                  // Color T¡tulo del Marco

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[7],'')),;
	       @cSayTxt,@cSayDat,@cClrMar,@cClrTit)
*>>>>IF ANALISIS DEL COLOR

*>>>>IMPRESION DE LA FECHA Y CAJA
       cMsgTxt := 'GRABACION DE LOS COMPROBANTES. '+;
		  'BANCO:'+ALLTRIM(CUC->cCodBanCuC)+' '+;
		  'CUENTA:'+ALLTRIM(CUC->cNumeroCuC)

       nNroFil := nMarco(nFilSup,cMsgTxt,10,'°',cClrMar+','+cClrTit)
       lUnaCta := IF(lUnaCta == NIL,.T.,lUnaCta)
*>>>>FIN IMPRESION DE LA FECHA Y CAJA

*>>>>DIBUJO DEL MARCO
       nNroCol := 01
       nNroCol := nSay(nNroFil,nNroCol,"Cheque No.:",10,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"Fecha:",10,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"La Suma de $",12,@aColFac)

       nNroCol := 01
       nNroFil += 01
       nNroCol := nSay(nNroFil,nNroCol,"Documento:",16,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"Tipo:",01,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"Retenci¢n:",06,@aColFac)

       IF lUnaCta
	  nNroCol := nSay(nNroFil,nNroCol,"Cuenta:",20,@aColFac)
       ENDIF

       nNroCol := 01
       nNroFil += 01
       nNroCol := nSay(nNroFil,nNroCol,"Paguese a:",16,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"Tipo:",01,@aColFac)

       nNroCol := 01
       nNroFil += 01
       nNroCol := nSay(nNroFil,nNroCol,"Descripci¢n:",16,@aColFac)
*>>>>FIN DIBUJO DEL MARCO

*>>>>DIBUJO DEL MARCO PARA MOVIMIENTOS
       lHayArt := IF(lHayArt == NIL,.T.,lHayArt)
       IF lHayArt
	  IF lUnaCta
	     aCabeza := {'No.',;
			 'Factura',;
			 'Valor',;
			 'CORR'}

	     cMsgTxt := cRegPrint(aCabeza,;
				  {04,10,20,04},@aNroCol)
	  ELSE
	     aCabeza := {'No.',;
			 'Factura',;
			 'Cuenta',;
			 'Descripcion',;
			 'Valor',;
			 'CORR'}

	     cMsgTxt := cRegPrint(aCabeza,;
				  {04,10,20,20,12,04},@aNroCol)
	  ENDIF

	  nFilSup := nMarco(11,'',22,'°','BG')
	  @ nFilSup-2,01 SAY cMsgTxt
       ENDIF
       RETURN aNroCol
*>>>>FIN DIBUJO DEL MARCO PARA MOVIMIENTOS

/*************************************************************************
* TITULO..: IMPRESION DEL COMPROBANTE No. 1                              *
**************************************************************************

AUTOR: Nelson Fernández Gómez       FECHA DE CREACION: OCT 14/2004 JUE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   SEP 14/2004 JUE

OBJETIVOS:

1- Imprime el comprobante junto con el cheque seg£n formato de la Salle.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnCpb01(lShared,cNomUsr,lUnaCta,nNroCpb,nNroChe,cDocNit,cTipDoc,;
		   cDocChe,cTntChe,cDescri,dFecChe,nVlrChe,aRegCpI)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       lUnaCta                              // .T. Una cuenta Puc .F. Varias Cuentas
       nNroCpb                              // N£mero del Comprobante
       nNroChe                              // N£mero del Cheque
       cDocNit			            // @Documento de Identificaci¢n
       cTipDoc                              // @Tipo de Documento
       dFecChe                              // @Fecha del Cheque
       nVlrChe                              // @Valor del Cheque
       cDocChe                              // @Documento para el Cheque
       cTntChe                              // @Tipo de Documento para el Cheque
       cDescri                              // Descripci¢n
       dFecChe                              // Fecha del Cheque
       nVlrChe                              // Valor del Cheque
       aRegCpI                              // Columnas de los Items */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL aFecChe := {}                  // Fecha del Cheque
       LOCAL cLasuma := ''                  // Valor a Pagar
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL cNombre := ''                  // Nombre del Beneficiario
       LOCAL cVlrTxt := ''                  // Valor en Texto
       LOCAL aNroLin := {}                  // N£mero de l¡neas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       SendCodes(cPageLen(CHR(22)))
     *ÀTama¤o del Papel

       SendCodes(PCL({'CondenOf','Pica'}))
       SETPRC(0,0)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>LOCALIZACION DEL BENEFICIARIO
       lValDoc(cDocChe,cTntChe,@cNalias)

       DO CASE
       CASE cNalias == 'P00'
	    cNombre := cNomApePer()+' C.C No.'+cDocChe

       CASE cNalias == 'EMP'
	    cNombre := ALLTRIM(EMP->cNombreEmp)+' NIT No.'+cDocChe
       ENDCASE
*>>>>FIN LOCALIZACION DEL BENEFICIARIO

*>>>>IMPRESION DE LA FECHA
       aFecChe := aFecha(dFecChe)
       @ PROW()+3,35 SAY aFecChe[3]
       @ PROW()  ,41 SAY aFecChe[1]
       @ PROW()  ,44 SAY aFecChe[2]
*>>>>FIN IMPRESION DE LA FECHA

*>>>>IMPRESION DEL VALOR
       @ PROW(),50 SAY TRANS(nVlrChe,"$$$$,$$$,###")
*>>>>FIN IMPRESION DEL VALOR

*>>>>IMPRESION DEL BENEFICIARIO
       @ PROW()+2,01 SAY cNombre
*>>>>FIN IMPRESION DEL BENEFICIARIO

*>>>>IMPRESION VALOR EN LETRAS
       cVlrTxt := ALLTRIM(UPPER(Letras(nVlrChe,'M')))+' PESOS MCTE. XXXXX'
       aNroLin := aDivLin(cVlrTxt,60)
       @ PROW()+2,06 SAY aNroLin[1]
       IF !EMPTY(aNroLin[2])
	  @ PROW()+2,01 SAY aNroLin[2]
       ELSE
	  @ PROW()+2,01 SAY REPL('X',20)
       ENDIF
*>>>>FIN IMPRESION VALOR EN LETRAS

*>>>>FECHA Y BENEFICIARIO
       SendCodes(PCL('CondenOn'))
       @ PROW()+11,50 SAY CXP->cTitEmpCxP
       @ PROW()+01,36 SAY cFecha(dFecChe)+' '+cNombre
*>>>>FIN FECHA Y BENEFICIARIO

*>>>>IMPRESION DEL TITULO
       @ PROW()+02,002 SAY 'C U E N T A'
       @ PROW()   ,024 SAY 'D E S C R I P C I O N'
       @ PROW()   ,086 SAY 'D E B I T O'
       @ PROW()   ,104 SAY 'C R E D I T O'
*>>>>FIN IMPRESION DEL TITULO

*>>>>IMPRESION DEL MOVIMIENTO
       IF lUnaCta
	  @ PROW()+2,02 SAY ALLTRIM(aRegCpI[1,2])+REPL('x',12)
	  @ PROW()  ,024 SAY cDescri
	  @ PROW()  ,086 SAY TRANS(nVlrChe,"$$$$,$$$,###")
*	  @ PROW()  ,104 SAY TRANS(nVlrChe,"$$$$,$$$,###")
       ENDIF
*>>>>FIN IMPRESION DEL MOVIMIENTO

*>>>>VALOR NETO PAGADO
       @ PROW()+12,94 SAY '1320050200'
       @ PROW()+1 ,94 SAY TRANS(nVlrChe,"$$$$,$$$,###")
       EJECT
       RETURN NIL
*>>>>FIN VALOR NETO PAGADO

/*************************************************************************
* TITULO..: LINEAS POR PAGINA                                            *
**************************************************************************

AUTOR: Nelson Fernández Gómez       FECHA DE CREACION: OCT 15/2004 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   OCT 15/2004 VIE

OBJETIVOS:

1- Detemina el tama¤o del papel de acuerdo al n£mero de l¡neas.

2- Retorna el c¢digo PCL del tama¤o del papel.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPageLen(cNroLin)

*>>>DECLARACION DE VARIABLES
      LOCAL nLenTxt := 0                    // Longitud del N£mero de l¡neas
      LOCAL nNroPos := 0                    // N£mero de la posici¢n
      LOCAL cPagLen := ''                   // Tama¤o del Papel en lineas
*>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL TAMA¥O DEL PAPEL
       nLenTxt := LEN(cNroLin)
       cPagLen := PCL('PageLen')

       nNroPos := AT('#',cPagLen)
       cPagLen := STUFF(cPagLen,nNroPos,nLenTxt,cNroLin)

       RETURN cPagLen
*>>>>FIN ANALISIS DEL TAMA¥O DEL PAPEL

