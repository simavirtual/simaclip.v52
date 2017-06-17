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

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna

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
       LOCAL cCodRtf := ''                  // C¢digo de la Retenci¢n
       LOCAL nPorRtf := 0                   // Porcentaje de la Retenci¢n
       LOCAL nVlrRtf := 0                   // Valor de la Retenci¢n
       LOCAL nVlrPag := 0                   // Valor a Pagar
       LOCAL lHayArt := .F.                 // .T. Grabar Articulos
       LOCAL lPagCou := .F.                 // .T. Pago por Coutas
       LOCAL cCodPuc := ''                  // C¢digo del Puc
       LOCAL nMesReq := 0                   // Mes del Requerimiento

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
			 FilePer,'PER',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 Ntx1Per,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat,PathSis)+'\'+;
			 FileEmp,'EMP',;
			 PathSis(cPatDat,PathSis)+'\'+;
			 fNtxEmp,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FilePrv+cAnoUsr+ExtFile,'PRV',;
			 cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 fNtxPrv,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FilePrS+cAnoUsr+ExtFile,'PRS',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileFac+cAnoUsr+ExtFile,'FAC',;
			 cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 fNtxFac,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
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

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRABACION DE FACTURAS',22,'°')
       cCabeza := cRegPrint({'FACTURA',;
			     'NUMERO',;
			     'VLR ANTES IVA',;
			     'VALOR IVAL',;
			     'TOTAL'},;
			    {12,10,14,14,14},@aNroCol)
       @ nNroFil++,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS FACTURAS
       DO WHILE .T.

**********LECTURA DE LA FACTURA
	    cSavPan := SAVESCREEN(0,0,24,79)
	    aFormatFac(nFilPal+1,dFecUsr,cNomUsr,@aColFac,lHayArt)
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
	    cCodRtf := SPACE(04)
	    nPorRtf := 0
	    nVlrRtf := 0
	    nVlrPag := 0
	    lPagCou := .F.

	    cCodPuc := SPACE(20)
	    nMesReq := 0

	    lGrabar := lleerFac(lShared,cNomUsr,@cDocNit,@cTipDoc,@cCodFac,;
				@cNroFac,@dFecFac,@dFecOpo,@dFecVto,@cDescri,;
				@nBasRtf,@nVlrIva,@cCodRtf,@nVlrRtf,@nPorRtf,;
				@nVlrPag,@lPagCou,@cCodPuc,@nMesReq,@lAnexar,;
				aColFac,lHayArt)
**********FIN LECTURA DE LA FACTURA

**********GRABACION DE LA FACTURA
	    IF lGrabar

	       IF FAC->(lRegLock(lShared,.T.))

		  REPL FAC->nIdeCodFac WITH FAC->(RECNO())

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

		  REPL FAC->cCodRtfFac WITH cCodRtf
		  REPL FAC->nPorRtfFac WITH nPorRtf
		  REPL FAC->nVlrRtfFac WITH nVlrRtf
		  REPL FAC->nVlrPagFac WITH nVlrPag
		  REPL FAC->lPagCouFac WITH lPagCou
		  REPL FAC->cCodigoPuc WITH cCodPuc
		  REPL FAC->nMesReqFac WITH nMesReq

		  REPL FAC->cNomUsrFac WITH cNomUsr
		  REPL FAC->dFecUsrFac WITH DATE()
		  REPL FAC->cHorUsrFac WITH TIME()

		  FAC->(DBCOMMIT())
	       ENDIF

	       IF lShared
		  FAC->(DBUNLOCK())
	       ENDIF

	    ENDIF
**********FIN GRABACION DE LA FACTURA

**********GRABACION DEL PROVEEDOR
	    IF lGrabar .AND. !lLocDocPrv(cDocNit,cTipDoc)

***************INCLUSION O MODIFACION DEL REGISTRO
		 IF PRV->(lRegLock(lShared,.T.))

		    REPL PRV->cDocNitPrv WITH cDocNit
		    REPL PRV->cTipNitPrv WITH cTipDoc

		    PRV->(DBCOMMIT())
		 ENDIF

		 IF lShared
		    PRV->(DBUNLOCK())
		 ENDIF
***************FIN INCLUSION O MODIFACION DEL REGISTRO

	    ENDIF
**********FIN GRABACION DEL PROVEEDOR

**********ANALISIS DE DECISION
	    RESTSCREEN(0,0,24,79,cSavPan)

	    IF lGrabar
	       @ nNroFil,aNroCol[1] SAY cCodFac COLOR('I')
	       @ nNroFil,aNroCol[2] SAY cNroFac COLOR('I')
	       @ nNroFil,aNroCol[3] SAY nBasRtf COLOR('I')
	       @ nNroFil,aNroCol[4] SAY nVlrIva COLOR('I')
	       @ nNroFil,aNroCol[5] SAY nBasRtf+nVlrIva COLOR('I')

	       nNroFil++
	       IF nNroFil > 20
		  nNroFil := nMarco(03,'GRABACION DE FACTURAS',22,'°')
		  @ nNroFil++,01 SAY cCabeza
	       ENDIF

	    ENDIF

	    IF !lPregunta('DESEA GRABAR OTRA FACTURA? Si No')
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

       ENDDO
       RETURN NIL
*>>>>FIN GRABACION DE LAS FACTURAS

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

	  nNroFil := nFilSup
	  nNroCol := 01
	  nSay(nNroFil  ,nNroCol,'VALOR ANTES DE IVA$',10,@aColFac)
	  nSay(nNroFil+1,nNroCol,'VALOR DEL IVA ....$',10,@aColFac)
	  @ nNroFil+2,nNroCol+20 SAY REPL('=',10)
	  nSay(nNroFil+3,nNroCol,'VALOR TOTAL.......$',10,@aColFac)
	  @ nNroFil+2,nNroCol+20 SAY REPL('=',10)
	  nSay(nNroFil+4,nNroCol,'CODIGO RETENCION..:',04,@aColFac)
	  nSay(nNroFil+5,nNroCol,'VALOR RETENCION...$',04,@aColFac)
	  nSay(nNroFil+6,nNroCol,'VALOR A PAGAR.....$',04,@aColFac)
	  nSay(nNroFil+7,nNroCol,'CUENTA DEL PUC....:',04,@aColFac)

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
		  dFecOpo,dFecVto,cDescri,nBasRtf,nVlrIva,cCodRtf,nVlrRtf,;
		  nPorRtf,nVlrPag,lPagCou,cCodPuc,nMesReq,lAnexar,aColFac,;
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
       cCodRtf                              // C¢digo de la Retenci¢n
       nPorRtf                              // Porcentaje de la Retenci¢n
       nVlrRtf			            // Valor de la Retenci¢n
       nVlrPag                              // Valor a Pagar
       lPagCou                              // .T. Pago por Coutas
       cCodPuc                              // C¢digo del Puc
       nMesReq                              // Mes del Requerimiento
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
       LOCAL lHayRtf := .T.                 // Hay Retenci¢n

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
		      CASE cNalias == 'PER'
			   lManRegPer(lShared,cNomUsr,1,NIL,cDocNit)

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

*-------------------NOMBRE DEL PROVEEDOR
		      DO CASE
		      CASE cNalias == 'PER'
			   lHayRtf := .T.

		      CASE cNalias == 'EMP'
			   lHayRtf := EMP->lHayRtfEmp

		      ENDCASE
*-------------------FIN NOMBRE DEL PROVEEDOR

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
				    VALID !EMPTY(dFecVto);
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
	       nNroFil += 05

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

*==============LECTURA CODIGO DE LA RETENCION
		 IF lHayRtf

		    cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA RETENCION'
		    @ nNroFil+4,aColFac[12] GET cCodRtf PICT "@!";
					 VALID lValRtf(ROW()+1,COL()-20,@cCodRtf) .AND.;
					       !EMPTY(cCodRtf);
					 WHEN {||HelpRead(cTxtHlp)}
		    READ

		    @ nNroFil+4,aColFac[12]+10 SAY ALLTRIM(RTF->cNombreRtf)+SPACE(40);
					     PICT "@S41" COLOR('I')
		 ELSE
		    @ nNroFil+4,aColFac[12]+10 SAY 'NO SE LE APLICA RETENCION' COLOR('I')
		 ENDIF
*==============FIN LECTURA CODIGO DE LA RETENCION

*==============CALCULO DE LA RETENCION
		 nPorRtf := 0
		 nVlrRtf := 0
		 IF lHayRtf .AND. nBasRtf >= RTF->nVlrBasRtf
		    nPorRtf := RTF->nPorcenRtf
		    nVlrRtf := ROUND((nBasRtf*nPorRtf)/100,0)
		 ENDIF
		 @ nNroFil+5,aColFac[13] SAY STR(nVlrRtf,12,2) COLOR('I')
*==============FIN CALCULO DE LA RETENCION

*==============CALCULO DEL VALOR A PAGAR
		 nVlrPag := nBasRtf+nVlrIva-nVlrRtf
		 @ nNroFil+6,aColFac[14] SAY STR(nVlrPag,12,2) COLOR('I')
*==============FIN CALCULO DEL VALOR A PAGAR

*==============PAGO POR COUTAS
		 lPagCou := lPregunta('SE VA A PAGAR LA FACTURA POR CUOTAS? No Si',;
				      nNroFil+6,aColFac[14]+14)
		 @ nNroFil+6,aColFac[14]+14 SAY 'PAGO POR COUTAS:'
		 @ nNroFil+6,aColFac[14]+31 SAY IF(lPagCou,'SI','NO') COLOR('I*')
*==============FIN PAGO POR COUTAS

*==============CUENTA DEL PUC
		 cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA CUENTA'

		 @ nNroFil+7,aColFac[15] GET cCodPuc PICT "99999999999999999999";
				      VALID lValPrS(ROW()-10,COL(),@cCodPuc) .AND.;
					    !EMPTY(cCodPuc);
				      WHEN {||HelpRead(cTxtHlp)}
		 READ
*==============FIN CUENTA DEL PUC

*==============MES DE LA REQUISICION
		 cTxtHlp := 'POR FAVOR DIGITE EL MES PARA LA REQUISICION'

		 nMesReq := MONTH(DATE())
		 @ nNroFil+7,aColFac[15]+31 SAY 'MES DE LA REQUISION';
					    GET nMesReq PICT '99';
			     VALID lnValMes(ROW()-10,COL()-2,@nMesReq);
			     WHEN {||HelpRead(cTxtHlp)}
		 READ
*==============FIN MES DE LA REQUISICION

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



