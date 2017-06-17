/* SIMA - CUENTAS POR PAGAR

MODULO      : FACTURAS
SUBMODULO...: COUTAS                                     MODULO No. 101

**************************************************************************
* TITULO..: COUTAS DE LAS FACTURAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 11/2005 LUN A
       Colombia, Bucaramanga        INICIO: 02:50 PM   ABR 11/2005 LUN

OBJETIVOS:

1- Permite grabagar las cuotas de las facturas a pagar.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pagos_102(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
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
       LOCAL cCodCoF := ''                  // C¢digo de la Factura
       LOCAL cCodFac := ''                  // C¢digo de la Factura
       LOCAL aFecUsr := {}                  // Fecha del Usuario
       LOCAL dFecUsr := CTOD('00/00/00')    // Fecha del Usuario

       LOCAL dFecFac := CTOD('00/00/00')    // Fecha de la Factura
       LOCAL dFecOpo := CTOD('00/00/00')    // Fecha Pago Oportuno
       LOCAL dFecVto := CTOD('00/00/00')    // Fecha de Vencimiento

       LOCAL cDescri := ''                  // Descripci¢n.
       LOCAL nVlrPag := 0                   // Valor a Pagar
       LOCAL lHayArt := .F.                 // .T. Grabar Articulos
       LOCAL lPagCou := .F.                 // .T. Pago por Coutas
       LOCAL nMesReq := 0                   // Mes del Requerimiento

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecUsr := DATE()
       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,07 SAY 'INGRESE LA FECHA DEL CODIGO '+;
		   'DE LA COUTA DE LA FACTURA: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE RECEPCION:' GET dFecUsr PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecUsr)
	  RETURN NIL
       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileFac+cAnoUsr+ExtFile,'FAC',;
			 cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 fNtxFac,lShared,nModCry})
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
       CASE FAC->(RECCOUNT()) == 0
	    cError('NO EXISTEN FACTURAS REGISTRADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LAS FACTURAS
       SELECT FAC
       SET FILTER TO FAC->lPagCouFac .AND.;
		     FAC->nVlrCanFac < FAC->nVlrPagFac

       FAC->(DBGOTOP())
       IF FAC->(EOF())
	  SET FILTER TO
	  cError('NO EXISTEN FACTURAS POR PAGAR POR COUTAS')
	  CloseAll()
	  RETURN Nil
       ENDIF
*>>>>FIN FILTRACION DE LAS FACTURAS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRABACION DE FACTURAS',22,'°')
       cCabeza := cRegPrint({'CUENTA',;
			     'FACTURA',;
			     'VLR A PAGAR'},;
			    {12,10,14,14,14},@aNroCol)
       @ nNroFil++,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS FACTURAS
       DO WHILE .T.

**********LECTURA DE LA FACTURA
	    cSavPan := SAVESCREEN(0,0,24,79)
	    aFormatCoF(nFilPal+1,dFecUsr,cNomUsr,@aColFac,lHayArt)
	   *Formato de lectura de la transaccion

	    aFecUsr := aFecha(dFecUsr)
	    cDocNit := SPACE(16)
	    cTipDoc := SPACE(01)
	    cCodCoF := aFecUsr[2]+aFecUsr[1]+aFecUsr[3]+SPACE(02)
	    cCodFac := SPACE(10)
	    dFecFac := CTOD('00/00/00')
	    dFecOpo := CTOD('00/00/00')
	    dFecVto := CTOD('00/00/00')
	    cDescri := SPACE(60)
	    nVlrPag := 0
	    lPagCou := .F.
	    nMesReq := 0

	    lGrabar := lleerCoF(lShared,cNomUsr,@cDocNit,@cTipDoc,@cCodCoF,;
				@cCodFac,@dFecFac,@dFecOpo,@dFecVto,@cDescri,;
				@nVlrPag,@lPagCou,@nMesReq,@lAnexar,aColFac,;
				lHayArt)
**********FIN LECTURA DE LA FACTURA

**********GRABACION DE LA FACTURA
	    IF lGrabar

	       IF FAC->(lRegLock(lShared,.T.))

		  REPL FAC->nIdeCodFac WITH FAC->(RECNO())

		  REPL FAC->cCodigoFac WITH cCodCoF
		  REPL FAC->cCodFacFac WITH cCodFac

		  REPL FAC->cDocNitFac WITH cDocNit
		  REPL FAC->cTipNitFac WITH cTipDoc

		  REPL FAC->dFecFacFac WITH dFecFac
		  REPL FAC->dFecOpoFac WITH dFecOpo
		  REPL FAC->dFecVtoFac WITH dFecVto
		  REPL FAC->cDescriFac WITH cDescri

		  REPL FAC->nVlrPagFac WITH nVlrPag
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

**********ANALISIS DE DECISION
	    RESTSCREEN(0,0,24,79,cSavPan)

	    IF lGrabar
	       @ nNroFil,aNroCol[1] SAY cCodCoF COLOR('I')
	       @ nNroFil,aNroCol[2] SAY cCodFac COLOR('I')
	       @ nNroFil,aNroCol[3] SAY nVlrPag COLOR('I')

	       nNroFil++
	       IF nNroFil > 20
		  nNroFil := nMarco(03,'GRABACION DE FACTURAS',22,'°')
		  @ nNroFil++,01 SAY cCabeza
	       ENDIF

	    ENDIF

	    IF !lPregunta('DESEA GRABAR OTRA COUTA? Si No')
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

       ENDDO
       SELECT FAC
       SET FILTER TO
       CloseAll()
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

FUNCTION aFormatCoF(nFilSup,dFecUsr,cNomUsr,aColFac,lHayArt)

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
       nNroCol := nSay(nNroFil,nNroCol,"Factura:"  ,10,@aColFac)

       nNroCol := 01
       nNroFil += 01
       nNroCol := nSay(nNroFil,nNroCol,"fecha cuenTa:",10,@aColFac)
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
	  cMsgTxt := 'INGRESE EL VALOR DE LA COUTA A PAGAR DE LA FACTURA'
	  nFilSup := nMarco(10,cMsgTxt,22,'°','BG')

	  nNroFil := nFilSup
	  nNroCol := 01
	  nSay(nNroFil  ,nNroCol,'VALOR POR PAGAR..$',10,@aColFac)
	  nSay(nNroFil+1,nNroCol,'VALOR PAGADO.....$',10,@aColFac)
	  @ nNroFil+2,nNroCol+20 SAY REPL('=',10)
	  nSay(nNroFil+3,nNroCol,'SALDO POR PAGAR..$',10,@aColFac)
	  nSay(nNroFil+4,nNroCol,'VALOR A PAGAR....$',04,@aColFac)
	  nSay(nNroFil+5,nNroCol,'CUENTA DEL PUC...:',04,@aColFac)

       ENDIF

       RETURN aNroCol
*>>>>FIN DIBUJO DEL MARCO PARA MOVIMIENTOS

/*************************************************************************
* TITULO..: LECTURA DE LAS COUTAS A PAGAR                                *
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

FUNCTION lleerCoF(lShared,cNomUsr,cDocNit,cTipDoc,cCodCoF,cCodFac,dFecFac,;
		  dFecOpo,dFecVto,cDescri,nVlrPag,lPagCou,nMesReq,lAnexar,;
		  aColFac,lHayArt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cDocNit			            // @Documento de Identificaci¢n
       cTipDoc                              // @Tipo de Documento
       cCodCoF			            // @C¢digo de la couta de la factura
       cCodFac			            // @C¢digo de la Factura
       dFecFac                              // @Fecha de Factura
       dFecOpo                              // @Fecha pago Oportuno
       dFecVto                              // @Fecha de Vencimiento
       cDescri                              // @Descripci¢n
       nVlrPag                              // Valor a Pagar
       lPagCou                              // .T. Pago por Coutas
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

		  cCodFec := SUBS(cCodCoF,1,8)
		  cSecFac := SUBS(cCodCoF,9,2)
		  cTxtHlp := 'POR FAVOR DIGITE EL CODIGO DE LA COUTA DE LA FACTURA'

		  @ nNroFil,aColFac[1] SAY cCodFec COLOR('I')
		  @ nNroFil,aColFac[1]+08 GET cSecFac PICT "99";
					  VALID lCorrecion(@cSecFac) .AND.;
						!lValCodFac(cCodFec+cSecFac);
					  WHEN {||HelpRead(cTxtHlp)}
		  READ

		  IF EMPTY(cSecFac) .OR. VAL(cSecFac) == 0
		     IF lPregunta('DESEA ABANDONAR? No Si')
			cCodCoF := SPACE(10)
			RETURN .F.
		     ELSE
			LOOP
		     ENDIF
		  ENDIF
		  cCodCoF := cCodFec+cSecFac
		  EXIT
	       ENDIF

	    ENDDO
**********FIN CAPTURA DEL CODIGO DE LA FACTURA

**********LECTURA CODIGO FACTURA
	    IF cOpcLec == '-' .OR. cOpcLec == 'F'
	       @ nNroFil,aColFac[2] GET cCodFac PICT "9999999999";
			 VALID EMPTY(cCodFac) .OR.;
			       (lValFac(ROW(),COL(),@cCodFac) .AND.;
				HelpRead());
			 WHEN {||HelpRead(cTxtHlp)}
	       READ

	       IF EMPTY(cCodFac)
		  cError('DEBE ESCOGER EL CODIGO DE LA FACTURA')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN LECTURA CODIGO FACTURA

**********CAPTURA DE LA FECHA DE FACTURA
	    nNroFil += 1
	    IF (cOpcLec == '-' .OR. cOpcLec == 'T')

	       @ nNroFil,aColFac[3] GET dFecFac PICT "@D";
				    VALID !EMPTY(dFecFac);
				    WHEN {||HelpRead('FECHA')}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA FECHA DE FACTURA

**********CAPTURA DE LA FECHA PAGO OPORTUNO
	    IF (cOpcLec == '-' .OR. cOpcLec == 'P')

	       cTxtHlp := 'POR FAVOR LA FECHA PARA EL PAGO OPORTUNO. '+;
			  'FORMATO: MM/DD/AAAA'
	       @ nNroFil,aColFac[4] GET dFecOpo PICT "@D";
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA FECHA PAGO OPORTUNO

**********CAPTURA DE LA FECHA DE VENCIMIENTO
	    IF (cOpcLec == '-' .OR. cOpcLec == 'V')

	       @ nNroFil,aColFac[5] GET dFecVto PICT "@D";
				    VALID !EMPTY(dFecVto);
				    WHEN {||HelpRead('FECHA')}

	       READ
	    ENDIF
**********FIN CAPTURA DE LA FECHA DE VENCIMIENTO

**********CAPTURA DE LA DESCRIPCION
	    nNroFil += 01
	    IF (cOpcLec == '-' .OR. cOpcLec == 'S')

	       cTxtHlp := 'POR FAVOR DIGITE LA DESCRIPCION DE LA FACTURA'
	       @ nNroFil,aColFac[6] GET cDescri PICT "@!";
				    VALID HelpRead();
				    WHEN {||HelpRead(cTxtHlp)}
	       READ
	    ENDIF
**********FIN CAPTURA DE LA DESCRIPCION

**********CAPTURA DE LA OPCION DE LECTURA
	    cValLec := '+-CFTPVS'
	    cOpcLec := cOpcionLec(nNroFil,77,cValLec)
	    IF cOpcLec # '+'
	       LOOP
	    ENDIF
**********FIN CAPTURA DE LA OPCION DE LECTURA

**********CAPTURA DEL TOTAL DE LA FACTURA
	    IF !lHayArt
	       nNroFil += 05

	       @ nNroFil+0,aColFac[07] SAY FAC->nVlrPagFac;
				       PICT "999999999.99"

	       @ nNroFil+1,aColFac[08] SAY FAC->nVlrCanFac;
				       PICT "999999999.99"

	       @ nNroFil+3,aColFac[09] SAY FAC->nVlrPagFac-FAC->nVlrCanFac;
				       PICT "999999999.99" COLOR('I')

	       cTxtHlp := 'POR FAVOR DIGITE EL VALOR DE LA COUTA DE LA FACTURA A PAGAR'
	       @ nNroFil+4,aColFac[10] GET nVlrPag PICT "999999999.99";
				       VALID nVlrPag <= (FAC->nVlrPagFac-;
							 FAC->nVlrCanFac);
				       WHEN {||HelpRead(cTxtHlp)}
	       READ

*==============CUENTA DEL PUC
		 @ nNroFil+5,aColFac[11] SAY FAC->cCodigoPuc COLOR('I')
*==============FIN CUENTA DEL PUC

*==============MES DE LA REQUISICION
		 cTxtHlp := 'POR FAVOR DIGITE EL MES PARA LA REQUISICION'

		 nMesReq := MONTH(DATE())
		 @ nNroFil+5,aColFac[11]+31 SAY 'MES DE LA REQUISION';
					    GET nMesReq PICT '99';
			     VALID lnValMes(ROW()-10,COL()-2,@nMesReq);
			     WHEN {||HelpRead(cTxtHlp)}
		 READ
*==============FIN MES DE LA REQUISICION

*==============DOCUMENTO DEL PROVEEDOR
		 cDocNit := FAC->cDocNitFac
		 cTipDoc := FAC->cTipNitFac
*==============FIN DOCUMENTO DEL PROVEEDOR

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

