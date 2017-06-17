/* SIMA - CUENTAS POR PAGAR

MODULO      : FACTURAS
SUBMODULO...: GRABAR                                     MODULO No. 101

**************************************************************************
* TITULO..: FACTURAS                                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 10/2004 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 10/2004 VIE

OBJETIVOS:

1- Permite ..

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pagos_101(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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

       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL aColFac := {}                  // Columnas de la Fila
       LOCAL nFilSup := 0                   // Fila superior de lectura
       LOCAL lAnexar := .T.                 // .T. Anexar ?Verificar
       LOCAL lGrabar := .F.                 // .T. Grabar el Registro

       LOCAL cDocNit := ''                  // Documento de Identificaci¢n
       LOCAL cTipDoc := ''                  // Tipo de Documento
       LOCAL cCodFac := ''                  // C¢digo de la Factura
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL aFecUsr := {}                  // Fecha del Usuario
       LOCAL dFecUsr := CTOD('00/00/00')    // Fecha del Usuario

       LOCAL dFecFac := CTOD('00/00/00')    // Fecha de la Factura
       LOCAL dFecOpo := CTOD('00/00/00')    // Fecha Pago Oportuno
       LOCAL dFecVto := CTOD('00/00/00')    // Fecha de Vencimiento

       LOCAL cDescri := ''                  // Descripci¢n.
       LOCAL nBasRtf := 0                   // Valor Base para Retenci¢n
       LOCAL nVlrIva := 0                   // Valor del Iva
       LOCAL lHayArt := .F.                 // .T. Grabar Articulos
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecUsr := DATE()
       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,15 SAY 'INGRESE LA FECHA DEL CODIGO DE LA FACTURA: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE RECEPCION:' GET dFecUsr PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecUsr)
	  RETURN NIL
       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 fPers00,'P00',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 Ntx2P00,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileEmp,'EMP',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxEmp,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FilePrv,'PRV',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxPrv,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileFac,'FAC',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxFac,lShared,nModCry})

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

*>>>>LECTURA DE LA FACTURA
       aNroCol := aFormatFac(nFilPal+1,dFecUsr,cNomUsr,@aColFac,lHayArt)
      *Formato de lectura de la transaccion

       aFecUsr := aFecha(dFecUsr)
       cDocNit := SPACE(16)
       cTipDoc := SPACE(01)
       cCodFac := aFecUsr[2]+aFecUsr[1]+aFecUsr[3]+SPACE(02)
       cNroFac := SPACE(10)
       dFecFac := CTOD('00/00/00')
       dFecOpo := CTOD('00/00/00')
       dFecVto := CTOD('00/00/00')
       cDescri := SPACE(60)
       nBasRtf := 0
       nVlrIva := 0

       lGrabar := lleerFac(lShared,cNomUsr,@cDocNit,@cTipDoc,@cCodFac,;
			   @cNroFac,@dFecFac,@dFecOpo,@dFecVto,@cDescri,;
			   @nBasRtf,@nVlrIva,lAnexar,aColFac,lHayArt)
       IF !lGrabar
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA FACTURA

*>>>>GRABACION DE LA FACTURA
       IF lGrabar

	  IF FAC->(lRegLock(lShared,.T.))

	     REPL FAC->cCodigoFac WITH cCodFac
	     REPL FAC->cNumeroFac WITH cNroFac
	     REPL FAC->cDocNitFac WITH cDocNit
	     REPL FAC->cTipNitFac WITH cTipDoc
	     REPL FAC->dFecFacFac WITH dFecFac
	     REPL FAC->dFecOpoFac WITH dFecOpo
	     REPL FAC->dFecVtoFac WITH dFecVto
	     REPL FAC->cDescriFac WITH cDescri

	     REPL FAC->nBasRtfFac WITH nBasRtf
	     REPL FAC->nVlrIvaFac WITH nVlrIva

	     REPL FAC->cNomUsrFac WITH cNomUsr
	     REPL FAC->dFecUsrFac WITH DATE()
	     REPL FAC->cHorUsrFac WITH TIME()

	     FAC->(DBCOMMIT())
	  ENDIF

	  IF lShared
	     FAC->(DBUNLOCK())
	  ENDIF

       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LA FACTURA

/*************************************************************************
* TITULO..: FORMATO DE CAPTURA DE LA FACTURA                             *
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

FUNCTION aFormatFac(nFilSup,dFecUsr,cNomUsr,aColFac,lHayArt)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup                              // Fila Superior
       dFecUsr                              // Fecha del Usuario
       cNomUsr                              // Nombre del usuario
       cNomUsr			            // Nombre del Usuario
       aColFac                              // @Columnas de la Factura
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
       cMsgTxt := 'GRABACION DE LAS FACTURAS DE '+cFecha(dFecUsr)
       nNroFil := nMarco(nFilSup,cMsgTxt,09,'°',cClrMar+','+cClrTit)
*>>>>FIN IMPRESION DE LA FECHA Y CAJA

*>>>>DIBUJO DEL MARCO
       nNroCol := 01
       nNroCol := nSay(nNroFil,nNroCol,"C¢digo:"   ,10,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"N£mero:"   ,10,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"Documento:",16,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"tipo:"     ,01,@aColFac)

       nNroCol := 01
       nNroFil += 01
       nNroCol := nSay(nNroFil,nNroCol,"Fecha Factura:",10,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"Pago oportuno:",10,@aColFac)
       nNroCol := nSay(nNroFil,nNroCol,"fecha Vencimiento:",10,@aColFac)

       nNroCol := 01
       nNroFil += 01
       nNroCol := nSay(nNroFil,nNroCol,"deScripci¢n:",40,@aColFac)
*>>>>FIN DIBUJO DEL MARCO

*>>>>DIBUJO DEL MARCO PARA MOVIMIENTOS
       lHayArt := IF(lHayArt == NIL,.T.,lHayArt)
       IF lHayArt
	  aCabeza := {'item',;
		      'Factura',;
		      'Descripcion',;
		      'Valor',;
		      'CORR'}

	  cMsgTxt := cRegPrint(aCabeza,;
			       {04,20,40,12,04},@aNroCol)

	  nFilSup := nMarco(10,cMsgTxt,22,'°','BG')
       ELSE
	  cMsgTxt := 'INGRESE EL TOTAL DE LA FACTURA'
          nFilSup := nMarco(10,cMsgTxt,22,'°','BG')

	  nNroFil := nFilSup+1
	  nNroCol := 01
	  nSay(nNroFil  ,nNroCol,'VALOR ANTES DE IVA$',10,@aColFac)
	  nSay(nNroFil+1,nNroCol,'VALOR DEL IVA ....$',10,@aColFac)
	  @ nNroFil+2,nNroCol+20 SAY REPL('=',10)
	  nSay(nNroFil+3,nNroCol,'VALOR TOVAL.......$',10,@aColFac)

       ENDIF

       RETURN aNroCol
*>>>>FIN DIBUJO DEL MARCO PARA MOVIMIENTOS

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

FUNCTION lleerFac(lShared,cNomUsr,cDocNit,cTipDoc,cCodFac,cNroFac,dFecFac,;
		  dFecOpo,dFecVto,cDescri,nBasRtf,nVlrIva,lAnexar,aColFac,;
		  lHayArt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cDocNit			            // @Documento de Identificaci¢n
       cTipDoc                              // @Tipo de Documento
       cCodFac                              // @C¢digo de la factura
       cNroFac                              // @N£mero de la factura
       dFecFac                              // @Fecha de Factura
       dFecOpo                              // @Fecha pago Oportuno
       dFecVto                              // @Fecha de Vencimiento
       cDescri                              // @Descripci¢n
       nBasRtf                              // @Valor Base para Retenci¢n
       nVlrIva                              // @Valor del Iva
       lAnexar			            // .F. Corrige Transaci¢n
       aColFac                              // Columnas de la Fila
       lHayArt                              // .T. Hay Articulos */
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
       LOCAL cCodFec := ''                  // C¢digo de la Fecha
       LOCAL cSecFac := ''                  // Secuencial de la Factura
       LOCAL cNalias := ''                  // Alias del Archivo

       LOCAL GetList := {}                  // Variable del Sistema
       SET CONFIRM    OFF                   // Confirmaci¢n salida Gets
       SET ESCAPE     OFF                   // Activa <ESC> salida GETS
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y VALIDACION DE LA TRANSACCION
       DO WHILE .T.

**********CAPTURA DEL CODIGO DE LA FACTURA
	    nNroFil := 06
	    DO WHILE cOpcLec == '-' .OR. cOpcLec == 'C'

	       IF cOpcLec == '-' .OR. cOpcLec == 'C'

		  cCodFec := SUBS(cCodFac,1,8)
		  cSecFac := SUBS(cCodFac,9,2)
		  cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA FACTURA'

		  @ nNroFil,aColFac[1] SAY cCodFec COLOR('I')
		  @ nNroFil,aColFac[1]+08 GET cSecFac PICT "99";
					  VALID lCorrecion(@cSecFac) .AND.;
						!lValCodFac(cCodFec+cSecFac);
					  WHEN {||HelpRead(cTxtHlp)}
		  READ

		  IF EMPTY(cSecFac) .OR. VAL(cSecFac) == 0
		     IF lPregunta('DESEA ABANDONAR? No Si')
			cCodFac := SPACE(10)
			RETURN .F.
		     ELSE
			LOOP
		     ENDIF
		  ENDIF
		  cCodFac := cCodFec+cSecFac
		  EXIT
	       ENDIF

	    ENDDO
**********FIN CAPTURA DEL CODIGO DE LA FACTURA

**********CAPTURA DEL NUMERO DE LA FACTURA
	    IF cOpcLec == '-' .OR. cOpcLec == 'N'

	       cTxtHlp := 'POR FAVOR DIGITE EL NUMERO DE LA FACTURA'
	       @ nNroFil,aColFac[2] GET cNroFac PICT "@!";
				    VALID !EMPTY(cNroFac);
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DEL NUMERO DE LA FACTURA

**********VALIDACION DEL DOCUMENTO DE IDENTIDAD
	    DO WHILE cOpcLec == '-' .OR. cOpcLec == 'D'

*==============CAPTURA DEL DOCUMENTO
		 IF cOpcLec == '-' .OR. cOpcLec == 'D'
		    cTxtHlp := 'POR FAVOR DIGITE EL NIT O DOCUMENTO DE IDENTIDAD'
		    @ nNroFil,aColFac[3] GET cDocNit PICT "9999999999999999";
					 VALID !EMPTY(cDocNit);
					 WHEN {||HelpRead(cTxtHlp)}
		    READ
		 ENDIF
*==============FIN CAPTURA DEL DOCUMENTO

*==============CAPTURA DEL TIPO DE DOCUMENTO
		 IF cOpcLec == '-' .OR. cOpcLec == 'D'

		    cTxtHlp := 'POR FAVOR DIGITE EL TIPO DE DOCUMENTO'
		    @ nNroFil,aColFac[4] GET cTipDoc PICT "9";
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
**********VALIDACION DEL DOCUMENTO DE IDENTIDAD

**********ANALISIS DE DECISION
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********CAPTURA DE LA FECHA DE FACTURA
	    nNroFil += 1
	    IF (cOpcLec == '-' .OR. cOpcLec == 'F')

	       @ nNroFil,aColFac[5] GET dFecFac PICT "@D";
				    VALID !EMPTY(dFecFac);
				    WHEN {||HelpRead('FECHA')}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA FECHA DE FACTURA

**********CAPTURA DE LA FECHA PAGO OPORTUNO
	    IF (cOpcLec == '-' .OR. cOpcLec == 'P')

	       cTxtHlp := 'POR FAVOR LA FECHA PARA EL PAGO OPORTUNO. '+;
			  'FORMATO: MM/DD/AAAA'
	       @ nNroFil,aColFac[6] GET dFecOpo PICT "@D";
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA FECHA PAGO OPORTUNO

**********CAPTURA DE LA FECHA DE VENCIMIENTO
	    IF (cOpcLec == '-' .OR. cOpcLec == 'V')

	       @ nNroFil,aColFac[7] GET dFecVto PICT "@D";
				    WHEN {||HelpRead('FECHA')}

	       READ
	    ENDIF
**********FIN CAPTURA DE LA FECHA DE VENCIMIENTO

**********CAPTURA DE LA DESCRIPCION
	    nNroFil += 01
	    IF (cOpcLec == '-' .OR. cOpcLec == 'S')

	       cTxtHlp := 'POR FAVOR DIGITE LA DESCRIPCION DE LA FACTURA'
	       @ nNroFil,aColFac[8] GET cDescri PICT "@!";
				    VALID HelpRead();
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA DESCRIPCION

**********CAPTURA DE LA OPCION DE LECTURA
	    cValLec := '+-CNDFPVS'
	    cOpcLec := cOpcionLec(nNroFil,77,cValLec)
	    IF cOpcLec # '+'
	       LOOP
	    ENDIF
**********FIN CAPTURA DE LA OPCION DE LECTURA

**********CAPTURA DEL TOTAL DE LA FACTURA
	    IF !lHayArt
	       nNroFil += 06

	       cTxtHlp := 'POR FAVOR DIGITE EL VALOR DE LA FACTURA ANTES DE IVA'
	       @ nNroFil+0,aColFac[09] GET nBasRtf PICT "999999999.99";
						   WHEN {||HelpRead(cTxtHlp)}
	       READ
	       @ nNroFil+3,aColFac[11] SAY nBasRtf PICT "999999999.99" COLOR('I')

	       cTxtHlp := 'POR FAVOR DIGITE EL VALOR DEL IVA DE LA FACTURA'
	       @ nNroFil+1,aColFac[10] GET nVlrIva PICT "999999999.99";
						   VALID HelpRead();
						   WHEN {||HelpRead(cTxtHlp)}
	       READ
	       @ nNroFil+3,aColFac[11] SAY nBasRtf+nVlrIva;
				       PICT "999999999.99" COLOR('I')
	    ENDIF
**********FIN CAPTURA DEL TOTAL DE LA FACTURA

**********ANALISIS DE GRABACION
	    nOpcion := nLeeOpcion('OPCION: '+;
		      '1<GRABAR> 2<CORREGIR> 3<ABANDONAR>?',3,'0')

	    IF nOpcion == 2
	       cOpcLec := '-'
	       LOOP
	    ENDIF
	    EXIT
**********FIN ANALISIS DE GRABACION

       ENDDO
       SET CONFIRM    ON                    // Confirmaci¢n salida Gets
       SET ESCAPE     OFF                    // Activa <ESC> salida GETS
       RETURN IF(nOpcion==1,lGrabar,!lGrabar)
*>>>>FIN LECTURA Y VALIDACION DE LA TRANSACCION

/*************************************************************************
* TITULO..: TITULO PARA EL SAY                                           *
**************************************************************************

AUTOR: Nelson Fernández Gómez       FECHA DE CREACION: SEP 10/2004 VIE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   SEP 10/2004 VIE

OBJETIVOS:

1- Calcula la columna para la lectura con el GET

2- Retorna las columnas para lectura

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSay(nNroFil,nNroCol,cSayTxt,nLenGet,aNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la Fila
       nNroCol                              // N£mero de la Columna
       cSayTxt                              // Texto fijo
       nLenGet                              // Len de lectura
       aNroCol                              // Columnas para lectura */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>IMPRESION DEL TITULO DEL SAY
       @ nNroFil,nNroCol SAY cSayTxt
       AADD(aNroCol,nNroCol+LEN(cSayTxt))
       RETURN aNroCol[LEN(aNroCol)]+nLenGet+1
*>>>>FIN IMPRESION DEL TITULO DEL SAY

/*************************************************************************
* TITULO..: GRABACION DE LOS DATOS DEL ESTUDIANTE           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 05:20 PM   DIC 02/96 MAR

OBJETIVOS:

1- Permite la incluir o actualizar registros.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirP00(lShared,cDocNit,cTipNit,lInsReg,nNroOpc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cDocNit                              // N£mero del Documento
       cTipNit                              // Tipo de Documento
       lInsReg                              // .T. Insertar el Registro
       nNroOpc                              // N£mero de Opci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 1                   // N£mero de la Columna
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL lGrabar := .T.                 // .T. Grabar el registro

       LOCAL cLugNit := ''                  // Lugar del Documento
       LOCAL lFotNit := .F.                 // .T. Hay Fotocopia
       LOCAL cFotNit := SPACE(01)           // S=> Hay Fotocopia
     *ÀIdentificaci¢n

       LOCAL cNombre := ''                  // Nombres
       LOCAL cApelli := ''                  // Apellidos
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Apellido Dos
     *ÀNombres y Apellidos

       LOCAL cSexFem := ''                  // Sexo de la Persona
       LOCAL lSexFem := .F.                 // Sexo de la Persona
       LOCAL cSiQepd := ''                  // Fallecido
       LOCAL lSiQepd := .F.                 // Fallecido
       LOCAL cEstrat := ''                  // Estrato

       LOCAL dFecNac := CTOD('00/00/00')    // Fecha de Nacimiento
       LOCAL cLugNac := ''                  // Lugar de Nacimiento
       LOCAL lExtran := .F.                 // .T. Extranjero
     *ÀLugar de Nacimiento

       LOCAL cEstCiv := ''                  // Estado Civil
       LOCAL cNitCmp := ''                  // Documento de Compa¤era(o)
       LOCAL cTntCmp := ''                  // Tipo de Documento de la Compa¤era(o)
     *ÀEstado Civil

       LOCAL cDirecc := ''                  // Direccion de la casa
       LOCAL cBarrio := ''                  // Barrio de la direcci¢n
       LOCAL cCiudad := ''                  // Ciudad
     *ÀDireccion de Residencia

       LOCAL cTelefn := ''                  // Telefono Casa
       LOCAL cTelFax := ''                  // Telefono Fax de la Casa
       LOCAL cTelCel := ''                  // Telefono celular
       LOCAL cBipper := ''                  // Biper de la Persona
       LOCAL cTelOtr := ''                  // Otros telefonos de la Persona
     *ÀTelefono Personales

       LOCAL cUrlWww := ''                  // Sitio de Internet
       LOCAL cMaiUno := ''                  // E-MAIL del padre
       LOCAL cMaiDos := ''                  // E-MAIL del padre
       LOCAL cMaiTre := ''                  // E-MAIL del padre
     *ÀContacto en Internet

       LOCAL lDirEnv := .F.                 // .T. Enviar a la Direcci¢n .F. Enviar a la Casa.
       LOCAL cEnvDir := ''                  // .T. Enviar a la Direcci¢n .F. Enviar a la Casa.
       LOCAL cDirEnv := ''                  // Direccion de Envio de Correspondencia
       LOCAL cBarEnv := ''                  // Barrio de Envio de Correspondencia
       LOCAL cCiuEnv := ''                  // Ciudad de Envio de la Correspondencia
       LOCAL cTelEnv := ''                  // Telefono Direccion de Correspondencia
       LOCAL cFaxEnv := ''                  // Fax Direcci¢n de Correspondencia
     *ÀDireccion de Envio de Correspondencia

       LOCAL cEmpTra := ''                  // Empresa del Trabajo
       LOCAL cCarTra := ''                  // Cargo de la Empresa
       LOCAL cDirTra := ''                  // Direccion del Trabajo
       LOCAL cBarTra := ''                  // Barrio del Trabajo
       LOCAL cCiuTra := ''                  // Ciudad del Trabajo
       LOCAL cTelTra := ''                  // Telefono del Trabajo
       LOCAL cFaxTra := ''                  // Fax del Trabajo
     *ÀInformaci¢n laboral

       LOCAL cProfes := ''
     *ÀEstudios

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENU
       IF EMPTY(nNroOpc)
	  AADD(aMenus,'1<INFORMACION BASICA    >')
	  AADD(aMenus,'2<ENVIO CORRESPONDIENCIA>')
	  AADD(aMenus,'3<INFORMACION LABORAL   >')
	  AADD(aMenus,'4<INFORMACION FAMILIAR  >')
	  AADD(aMenus,'5<INFORMACION ACADEMICA >')

	  AADD(aAyuda,'Actualiza la Informaci¢n B sica de la Personal')
	  AADD(aAyuda,'Actualiza la Direcci¢n para Envio de Correspondencia')
	  AADD(aAyuda,'Actualiza la Informaci¢n Laboral')
	  AADD(aAyuda,'Actualiza la Informaci¢n Familiar')
	  AADD(aAyuda,'Actualiza la Informaci¢n Acad‚mica')

	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := 1
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,'ACTUALIZAR',NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN DECLARACION DEL MENU

*>>>>CONSULTA DEL DOCUMENTO
       cSavPan := SAVESCREEN(0,0,24,79)
       lInsReg := IF(lInsReg==NIL,.T.,lInsReg)

       nFilIni := nMarco(03,'POR FAVOR '+IF(lInsReg,'INGRESE',;
			    'ACTUALICE')+' LOS DATOS DE LA PERSONA',22,'°')

       IF !EMPTY(cDocNit)
	  @ nFilIni,nNroCol+00 SAY 'DOCUMENTO: '+cDocNit COLOR('I')

	  @ nFilIni,nNroCol+30 SAY 'TIPO:' +cTipNit COLOR('I')
       ENDIF
*>>>>FIN CONSULTA DEL DOCUMENTO

*>>>>LECTURA DEL DOCUMENTO DE IDENTIFICACION
       IF EMPTY(cDocNit)
	  DO WHILE .T.

	     cDocNit := IF(EMPTY(cDocNit),;
			   cSpaces('P00','cDocNitPer'),cDocNit)

	     @ nFilIni,nNroCol+00 SAY 'DOCUMENTO: ';
				  GET  cDocNit PICT "@!";
		       WHEN {||HelpRead('DIGITE EL DOCUMENTO DE IDENTIDAD')}
	     READ

	     IF EMPTY(cDocNit)
		RETURN cDocNit
	     ENDIF

	     IF LEN(ALLTRIM(cDocNit)) <= 4
		LOOP
	     ENDIF
	     EXIT
	  ENDDO

	  cTipNit := IF(EMPTY(cTipNit),;
			cSpaces('P00','cTipNitPer'),cTipNit)

	  @ nFilIni,nNroCol+30 SAY 'TIPO:';
			      GET cTipNit PICT "@!";
			      VALID lValTipDoc(ROW(),COL()-1,@cTipNit,'145') .AND.;
				    !EMPTY(cTipNit);
			      WHEN {||HelpRead('DIGITE EL TIPO DE DOCUMENTO')}
	  READ
       ENDIF
*>>>>FIN LECTURA DEL DOCUMENTO DE IDENTIFICACION

*>>>>VALIDACION DE LA INFORMACION BASICA
       IF nNroOpc # 1
	  IF EMPTY(cLugNit) .OR. EMPTY(cApeUno) .OR.;
	     EMPTY(cNomDos)
	     cError('PRIMERO DEBE ESTAR ACTUALIZADA LA INFORMACION BASICA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA INFORMACION BASICA

*>>>>CONSULTA DEL NOMBRE DE LA PERSONA
       IF nNroOpc # 1

**********LUGAR DEL DOCUMENTO
	    nNroFil := nFilIni
	    @ nNroFil,nNroCol+40 SAY 'DE:'+;
				     cLugNit COLOR('I')
**********FIN LUGAR DEL DOCUMENTO

**********NOMBRE DE LA PERSONA
	    nNroFil += 2

	    @nNroFil,nNroCol+0 SAY 'PRIMER APELLIDO:'+;
				   cApeUno COLOR('I')

	    @nNroFil,nNroCol+38 SAY 'SEGUNDO APELLIDO:'+;
				    cApeDos COLOR('I')

	    nNroFil++
	    @nNroFil,nNroCol+0 SAY 'PRIMER NOMBRE:'+;
			       cNomUno COLOR('I')

	    @nNroFil,nNroCol+38 SAY 'SEGUNDO NOMBRE:'+;
				cNomDos COLOR('I')
**********FIN NOMBRE DE LA PERSONA

       ENDIF
*>>>>FIN CONSULTA DEL NOMBRE DE LA PERSONA

*>>>>LECTURA Y GRABACION DE LOS DATOS
       SET ESCAPE ON
       SELECT P00
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF lGrabar

	       cLugNit := P00->cLugNitPer
	       lFotNit := P00->lFotNitPer
	       cFotNit := IF(lFotNit,'S','N')
	     *ÀIdentificaci¢n

	       cNomUno := P00->cNomUnoPer
	       cNomDos := P00->cNomDosPer
	       cApeUno := P00->cApeUnoPer
	       cApeDos := P00->cApeDosPer
	     *ÀNombres y Apellidos

	       lSexFem := P00->lSexFemPer
	       cSexFem := IF(lSexFem,'F','M')

	       lSiQepd := P00->lSiQepdPer
	       cSiQepd := IF(lSiQepd,'S','N')

	       cEstrat := P00->cEstratPer

	       dFecNac := P00->dFecNacPer
	       cLugNac := P00->cLugNacPer
	       lExtran := P00->lExtranPer
	     *ÀLugar de Nacimiento

	       cEstCiv := P00->cEstCivPer
	       cNitCmp := P00->cNitCmpPer
	       cTntCmp := P00->cTntCmpPer
	     *ÀEstado Civil

	       cDirecc := P00->cDireccPer
	       cBarrio := P00->cBarrioPer
	       cCiudad := P00->cCiudadPer
	     *ÀDireccion de ResidenciaP00

	       cTelefn := P00->cTelefnPer
	       cTelCel := P00->cTelCelPer
	       cTelFax := P00->cTelFaxPer
	       cBipper := P00->cBipperPer
	       cTelOtr := P00->cTelOtrPer
	     *ÀTelefonos Personales

	       cUrlWww := P00->cUrlWwwPer
	       cMaiUno := P00->cMaiUnoPer
	       cMaiDos := P00->cMaiDosPer
	       cMaiTre := P00->cMaiTrePer
	     *ÀContacto en Internet

	       lDirEnv := P00->lDirEnvPer
	       cDirEnv := P00->cDirEnvPer
	       cBarEnv := P00->cBarEnvPer
	       cCiuEnv := P00->cCiuEnvPer
	       cTelEnv := P00->cTelEnvPer
	       cFaxEnv := P00->cFaxEnvPer
	     *ÀDireccion de Envio de Correspondencia

	       cEmpTra := P00->cEmpTraPer
	       cCarTra := P00->cCarTraPer
	       cDirTra := P00->cDirTraPer
	       cBarTra := P00->cBarTraPer
	       cCiuTra := P00->cCiuTraPer
	       cTelTra := P00->cTelTraPer
	       cFaxTra := P00->cFaxTraPer
	     *ÀInformaci¢n laboral

	       cProfes := P00->cProfesPer
	     *ÀEstudios

	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DE LOS DATOS
	    nNroFil := nFilIni
	    DO CASE
	    CASE nNroOpc == 1 // Informaci¢n Personal

*----------------FOTOCOPIA DEL DOCUMENTO
		   @ nNroFil,nNroCol+40 SAY 'DE:';
					GET cLugNit PICT "@!"

		   @ nNroFil-1,nNroCol+66 SAY 'FOTOCOPIA?'
		   @ nNroFil,nNroCol+66 GET cFotNit ;
					VALID lValSiNo(ROW(),COL()-1,;
					      @cFotNit,@lFotNit)
*----------------FIN FOTOCOPIA DEL DOCUMENTO

*----------------NOMBRES
		  nNroFil += 2

		  @nNroFil,nNroCol+0 SAY 'PRIMER APELLIDO:';
				     GET cApeUno PICT "@!" ;
				     VALID !EMPTY(cApeUno);
				     WHEN {||HelpRead('DIGITE EL '+;
						      'PRIMER APELLIDO')}

		  @nNroFil,nNroCol+38 SAY 'SEGUNDO APELLIDO:';
				      GET cApeDos PICT "@!" ;
				      WHEN {||HelpRead('DIGITE EL '+;
						      'SEGUNDO APELLIDO')}

		  nNroFil++
		  @nNroFil,nNroCol+0 SAY 'PRIMER NOMBRE:';
				     GET cNomUno PICT "@!" ;
				     VALID !EMPTY(cNomUno);
				     WHEN {||HelpRead('DIGITE EL '+;
						      'PRIMER NOMBRE')}

		  @nNroFil,nNroCol+38 SAY 'SEGUNDO NOMBRE:';
				      GET cNomDos PICT "@!" ;
				      WHEN {||HelpRead('DIGITE EL '+;
						      'SEGUNDO NOMBRE')}
*----------------FIN NOMBRES

*----------------FECHA DE NACIMIENTO
		   nNroFil += 2
		   @nNroFil,nNroCol+00 SAY 'FECHA DE NACIMIENTO:';
					 GET dFecNac PICT "@!" ;
					 VALID HelpRead();
					 WHEN {||HelpRead('FECHA')}
*----------------FIN FECHA DE NACIMIENTO

*----------------SEXO DE LA PERSONA
		   @ nNroFil,nNroCol+33 SAY 'SEXO:';
					GET cSexFem;
					VALID lValSexo(ROW(),COL()-1,;
					      @cSexFem,@lSexFem)
*----------------FIN SEXO DE LA PERSONA

*----------------PERSONA FALLECIDA
		   @ nNroFil,nNroCol+42 SAY 'FALLECIDO:';
					GET cSiQepd;
					VALID lValSiNo(ROW(),COL()-1,;
					      @cSiQepd,@lSiQepd)
*----------------FIN PERSONA FALLECIDA

*----------------ESTRATO DE LA PERSONA
		   @nNroFil,nNroCol+56 SAY 'ESTRATO:';
				       GET cEstrat PICT "9";
		     WHEN {||HelpRead('INGRESE EL NUMERO DEL ESTRATO')}
*----------------FIN ESTRATO DE LA PERSONA

*----------------DIRECCION DE LA CASA
		   nNroFil++
		   @++nNroFil,nNroCol+00 SAY 'DIRECCION CASA:';
					 GET cDirecc PICT "@!40";
		     WHEN {||HelpRead('INGRESE LA DIRECCION DE LA CASA')}
*----------------FIN DIRECCION DE LA CASA

*----------------BARRIO DE LA CASA
		   @++nNroFil,nNroCol+00 SAY 'BARRIO:';
					 GET cBarrio PICT "@!S30";
		     WHEN {||HelpRead('INGRESE EL BARRIO DE LA DIRECCION DE LA CASA')}
*----------------FIN BARRIO DE LA CASA

*----------------CIUDAD DE LA CASA
		   @nNroFil,nNroCol+39 SAY 'CIUDAD:';
					 GET cCiudad PICT "@!S30";
		     WHEN {||HelpRead('INGRESE LA CIUDAD DE LA DIRECCION DE LA CASA')}
*----------------FIN CIUDAD DE LA CASA

*----------------TELEFONO DE LA CASA
		   nNroFil++
		   @nNroFil,nNroCol+00 SAY 'TEL CASA:';
					 GET cTelefn PICT "99999999999999";
		     WHEN {||HelpRead('INGRESE EL TELEFONO DE LA CASA')}
*----------------FIN TELEFONO DE LA CASA

*----------------FAX DE LA CASA
		   @nNroFil,nNroCol+26 SAY 'FAX CASA:';
					 GET cTelFax PICT "99999999999999";
		     WHEN {||HelpRead('INGRESE EL FAX DE LA CASA')}
*----------------FIN FAX DE LA CASA

*----------------CELULAR
		   @nNroFil,nNroCol+51 SAY 'CELULAR:';
					 GET cTelCel PICT "99999999999999";
		     WHEN {||HelpRead('INGRESE EL TELEFONO CELULAR')}
*----------------FIN CELULAR

*----------------BIPEER
		   nNroFil++
		   @nNroFil,nNroCol+00 SAY 'BIPPER:';
					 GET cBipper PICT "@!S16";
		     WHEN {||HelpRead('INGRESE EL BIPPER DE LA PERSONA')}
*----------------FIN BIPEER

*----------------OTROS TELEFONOS DE LA PERSONA
		   @nNroFil,nNroCol+26 SAY 'OTROS TELS:';
					 GET cTelOtr PICT "@!S30";
		     WHEN {||HelpRead('INGRESE OTROS TELESONOS DE LA PERSONA')}
*----------------FIN OTROS TELEFONOS DE LA PERSONA

*----------------DIRECCION EN INTERNET
		   nNroFil += 2
		   @nNroFil,nNroCol+00 SAY 'DIRECCION EN INTERNET:';
				       GET cUrlWww PICT "@XS40";
		     WHEN {||HelpRead('INGRESE EL TELEFONO CELULAR')}
*----------------FIN DIRECCION EN INTERNET

*----------------EMAIL No. 1
		   nNroFil++
		   @nNroFil,nNroCol+00 SAY 'EMAIL No. 1:';
				       GET cMaiUno PICT "@XS40";
		     WHEN {||HelpRead('INGRESE EL EMAIL No. 1 DE LA PERSONA')}
*----------------FIN EMAIL No. 1

*----------------EMAIL No. 2
		   nNroFil++
		   @nNroFil,nNroCol+00 SAY 'EMAIL No. 2:';
				       GET cMaiDos PICT "@XS40";
		     WHEN {||HelpRead('INGRESE EL EMAIL No. 2 DE LA PERSONA')}
*----------------FIN EMAIL No. 2

*----------------EMAIL No. 3
		   nNroFil++
		   @nNroFil,nNroCol+00 SAY 'EMAIL No. 3:';
				       GET cMaiDos PICT "@XS40";
		     WHEN {||HelpRead('INGRESE EL EMAIL No. 3 DE LA PERSONA')}
*----------------FIN EMAIL No. 3

	    CASE nNroOpc == 2   // Envio de Correspondencia

*----------------DIRECCION DE LA CASA
		   nNroFil += 4
		   @++nNroFil,nNroCol+00 SAY 'DIRECCION CASA:';
					 GET cDirecc PICT "!40";
		     WHEN {||HelpRead('INGRESE LA DIRECCION DE LA CASA')}
*----------------FIN DIRECCION DE LA CASA

*----------------BARRIO DE LA CASA
		   @++nNroFil,nNroCol+00 SAY 'BARRIO:';
					 GET cBarrio PICT "@!S30";
		     WHEN {||HelpRead('INGRESE EL BARRIO DE LA DIRECCION DE LA CASA')}
*----------------FIN BARRIO DE LA CASA

*----------------CIUDAD DE LA CASA
		   @nNroFil,nNroCol+39 SAY 'CIUDAD:';
					 GET cCiudad PICT "@!S30";
		     WHEN {||HelpRead('INGRESE LA CIUDAD DE LA DIRECCION DE LA CASA')}
*----------------FIN CIUDAD DE LA CASA


	    CASE nNroOpc == 3

	    ENDCASE
	    READ
**********LECTURA DE LOS DATOS

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		    EXIT
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
		 EXIT
	    ENDCASE
**********FIN PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y GRABACION DE LOS DATOS

*>>>>GRABACION O ACTUALIZACION DEL REGISTRO
       IF lGrabar

	  IF P00->(lRegLock(lShared,.T.))

	     REPL P00->nCodigoPer WITH P00->(RECNO())
	     REPL P00->cDocNitPer WITH cDocNit
	     REPL P00->cTipNitPer WITH cTipNit
	     REPL P00->cLugNitPer WITH cLugNit
	     REPL P00->lFotNitPer WITH lFotNit
	   *ÀIdentificaci¢n

	     REPL P00->cNomUnoPer WITH cNomUno
	     REPL P00->cNomDosPer WITH cNomDos
	     REPL P00->cApeUnoPer WITH cApeUno
	     REPL P00->cApeDosPer WITH cApeDos
	   *ÀNombres y Apellidos

	     REPL P00->lSexFemPer WITH lSexFem

	     REPL P00->lSiQepdPer WITH lSiQepd

	     REPL P00->cEstratPer WITH cEstrat

	     REPL P00->dFecNacPer WITH dFecNac
	     REPL P00->cLugNacPer WITH cLugNac
	     REPL P00->lExtranPer WITH lExtran
	   *ÀLugar de Nacimiento

	     REPL P00->cEstCivPer WITH cEstCiv
	     REPL P00->cNitCmpPer WITH cNitCmp
	     REPL P00->cTntCmpPer WITH cTntCmp
	   *ÀEstado Civil

	     REPL P00->cDireccPer WITH cDirecc
	     REPL P00->cBarrioPer WITH cBarrio
	     REPL P00->cCiudadPer WITH cCiudad
	   *ÀDireccion de ResidenciaP00

	     REPL P00->cTelefnPer WITH cTelefn
	     REPL P00->cTelCelPer WITH cTelCel
	     REPL P00->cTelFaxPer WITH cTelFax
	     REPL P00->cBipperPer WITH cBipper
	     REPL P00->cTelOtrPer WITH cTelOtr
	   *ÀTelefonos Personales

	     REPL P00->cUrlWwwPer WITH cUrlWww
	     REPL P00->cMaiUnoPer WITH cMaiUno
	     REPL P00->cMaiDosPer WITH cMaiDos
	     REPL P00->cMaiTrePer WITH cMaiTre
	   *ÀContacto en Internet

	     REPL P00->lDirEnvPer WITH lDirEnv
	     REPL P00->cDirEnvPer WITH cDirEnv
	     REPL P00->cBarEnvPer WITH cBarEnv
	     REPL P00->cCiuEnvPer WITH cCiuEnv
	     REPL P00->cTelEnvPer WITH cTelEnv
	     REPL P00->cFaxEnvPer WITH cFaxEnv
	   *ÀDireccion de Envio de Correspondencia

	     REPL P00->cEmpTraPer WITH cEmpTra
	     REPL P00->cCarTraPer WITH cCarTra
	     REPL P00->cDirTraPer WITH cDirTra
	     REPL P00->cBarTraPer WITH cBarTra
	     REPL P00->cCiuTraPer WITH cCiuTra
	     REPL P00->cTelTraPer WITH cTelTra
	     REPL P00->cFaxTraPer WITH cFaxTra
	   *ÀInformaci¢n laboral

	     REPL P00->cProfesPer WITH cProfes
	   *ÀEstudios

	  ELSE
	     cError('NO SE GRABA EL REGISTRO DE PERSONAS')
	  ENDIF

	  IF lShared
	     P00->(DBUNLOCK())
	  ENDIF

       ENDIF
       SET ESCAPE OFF
       RETURN lGrabar
*>>>>FIN GRABACION O ACTUALIZACION DEL REGISTRO



