/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGO
SUBMODULO...: PAGOS POR ALUMNOS      MODULO No. 201

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE201.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE PAGOS EFECTUADOS                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/94 JUE
						       JUN 09/94 JUE
REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los detalles de los pagos efectuados

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_201(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL     i,j := 0                   // Contadores
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀVariables Gestion Documental

       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha Inicial
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL nMesIniTpa := 0                // Mes inicial del pago
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIniTpa == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis)   .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis)   .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

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

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 201
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<PAGOS><PAGOS POR ALUMNOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'RELACION DE PAGOS FACTURADOS')     // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCA->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecPrn := CTOD('00/00/00')
       lPrnFec := CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA

       IF lPrnFec
	  IF lPregunta('DESEA EL INFORME POR FECHA DE CORTE? No Si')

	     RESTSCREEN(0,0,24,79,cSavPan)
	     cSavPan := SAVESCREEN(0,0,24,79)
	     @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	     @ nFilInf+1,nColInf SAY 'FECHA DE CORTE :' GET dFecPrn PICT '@D'
	     READ
	     RESTSCREEN(0,0,24,79,cSavPan)

	     IF EMPTY(dFecPrn)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF

	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecPrn)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Pagos'+cMaeAct
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.F.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
	    SET DEVICE TO SCREEN
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO


**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 IF AT('PENSIONES',cNomSis) # 0
		    cError('NO EXISTEN CLIENTES GRABADOS')
		 ENDIF
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr

	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)

	       IF AT('PENSIONES',cNomSis) # 0
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ELSE
		  GRU->(DBSKIP())
		  LOOP
	       ENDIF

	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('MES DE PROCESO: '+cMes(nMesIniTpa)+'º'+;
			'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    PagosGru(aParam1,aParam2,aParam3,;
		     nMesIniTpa,dFecPrn,lPrnFec,GRU->cCodigoGru,;
		     cCodIso,aTitIso,aPieIso)

	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************


/*************************************************************************
* TITULO DEL PROGRAMA..: INFORME DE PAGOS EFECTUADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/94 JUE
						       JUN 09/94 JUE
OBJETIVOS:

1- Imprime la relaci¢n de pagos efectuados de un grupo en un mes espec¡fico

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagosGru(aParam1,aParam2,aParam3,;
		  nMesIni,dFecPrn,lPrnFec,cCodGru,;
		  cCodIso,aTitIso,aPieIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       nMesIni                              // Mes inicial del pago
       dFecPrn                              // Fecha de Corte
       lPrnFec                              // .T. Impresi¢n por fechas
       cCodGru                              // C¢digo del grupo
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso       	                    // Textos del pie de p gina */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registros de Impresion
     *ÀVariables de informe

       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL cTipDes := ''                  // Tipo de descuento
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL nVlrTar := 0                   // Valor de las tarifas
       LOCAL nFacMes := 0                   // Valor Facturado para el mes
       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nIntNoP := 0                   // Valor de los intereses no pago
       LOCAL nIntMor := 0                   // Valor de los intereses por no pago
       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nTotMes := 0                   // Total Facturaci¢n del mes
       LOCAL nTotDeu := 0                   // Total deuda sin intereses
       LOCAL nTotInt := 0                   // Total de intereses
       LOCAL nSdoInt := 0                   // Intereses por cobrar
       LOCAL nTotPag := 0                   // Total de pagos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lMesAct := .T.                 // Mes Actual
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL nMesAmn := 0                   // Mes de Anmistia
       LOCAL nDiaPag := 0                   // D¡a del Pago
       LOCAL cDiaPag := ''                  // D¡a del Pago
       LOCAL cPazSdo := ''                  // Paz y Salvo
       LOCAL cCodBan := ''                  // C¢digo del Banco
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Saldo de la Mora
       LOCAL cConcepTpa := ''               // Conceptos pagados
       LOCAL cEstadoTpa := ''               // Estado del pago
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
     *ÀVariables temporales de campos
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DEFINCION DEL ENCABEZADO
       cNroMes := STR(nMesIni,2)
       lCorrecion(@cNroMes)
       nMesAmn := CAA->nMesAmnCaA

       nNroPag := 0
       lTamAnc := .F.

       nTotReg := CLI->(RECCOUNT())+nLinTot

       aCabeza := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1]+;
		   IF(lPrnFec,' A '+cFecha(dFecPrn,3),''),;
		   'CORRESPONDIENTE AL MES DE '+cMes(nMesIni,10)+;
		    IF(CAA->nMesAmnCaA == nMesIni,' CON AMNISTIA',''),;
		   'GRUPO: '+cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
				       SUBS(GRU->cCodigoGru,3,2)+;
			   ' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

/*
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*/

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,18,22,12,10,10,12,08,10,16,02,06}
       aTitulo := {'No',;
		   'APELLIDOS Y NOMBRES ',;
		   'CONCEPTOS       ',;
		   'SALDO ACTUAL',;
		   'FACT MES',;
		   'INTxCOBMes',;
		   'TOTAL DEUDA ',;
		   'MESES.FA',;
		   'INT PAGMes',;
		   'PAGOS ',;
		   'BA',;
		   'CODIGO'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
       aCamXml := aTitulo
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(18),1,18)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    nSdoActTcl := 0
	    lRetadoTes := .F.
	    cPazSdo := ''
	    cCodBan := ''
	    IF lHayAlu
	       IF &cNalias->lRetiroEst
		  lRetadoTes := .T.
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
	       ENDIF
	       cPazSdo := &cNalias->cPazSdoEst
	       cPazSdo := SUBS(cPazSdo,1,1)
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********ANALISIS DE LA FORMA DE PAGO
	    IF lHayAlu

	       lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
	      *Localizaci¢n del c¢digo del pago


	       IF lHayPag
		  DO CASE
		  CASE PAG->cEstadoPag = 'P'
		       IF CAA->lLeeFecCaA

			  cEstadoTpa := IF(EMPTY(PAG->dFecPagPag),;
					    '   ??   ',;
					    cFecha(PAG->dFecPagPag)+':O')

			  cEstadoTpa += PAG->cCodigoFpg

			  IF !EMPTY(PAG->dFecPagPag)
			     cCodBan := IF(EMPTY(PAG->cCodigoBan),;
					 '??',;
					 PAG->cCodigoBan)
			  ENDIF

		       ELSE
			  cEstadoTpa := SPACE(10)
			     cCodBan := PAG->cCodigoBan
		       ENDIF

		  CASE PAG->cEstadoPag = 'A'

		       IF CAA->lLeeFecCaA

			  cEstadoTpa = IF(EMPTY(PAG->dFecPagPag),;
					    '   ????   ',;
					    cFecha(PAG->dFecPagPag)+':E')

			  cEstadoTpa += PAG->cCodigoFpg

			  IF !EMPTY(PAG->dFecPagPag)
			     cCodBan := IF(EMPTY(PAG->cCodigoBan),;
					 '??',;
					 PAG->cCodigoBan)
			  ENDIF

		       ELSE
			  cEstadoTpa := 'PAGO EXT'
			     cCodBan := PAG->cCodigoBan
		       ENDIF

		  CASE PAG->cEstadoPag = 'D'
		       cEstadoTpa = IF(CAA->lLeeFecCaA,;
					    SPACE(10),'NO PAGO ')
			 cCodBan := PAG->cCodigoBan

		  CASE PAG->cEstadoPag = '*'
		       cEstadoTpa = 'DEUDOR  '
			 cCodBan := PAG->cCodigoBan
		  OTHERWISE
		       cEstadoTpa = 'ERROR   '
			  cCodBan := PAG->cCodigoBan
		  ENDCASE
	       ENDIF

	    ENDIF
**********FIN ANALISIS DE LA FORMA DE PAGO

**********ANALISIS SI ES EL MES ACTUAL
	    lMesAct := .T.
	    IF nMesIni < LEN(RTRIM(CLI->cMesPagCli))
	       lMesAct := .F.
	    ENDIF
**********FIN ANALISIS SI ES EL MES ACTUAL

**********CALCULO DE LOS INTERESES ACUMULACION DE PAGOS
	    nFacMes := 0
	    nIntMor := 0
	    nIntPag := 0
	    nSdoActTcl := 0
	    nSdoMorTcl := 0

	    IF lHayAlu .AND. lHayPag

*--------------FACTURACION DEL MES
		 nFacMes := 0
		 FOR i := 1 TO LEN(PAG->cConcepPag)/2

*....................LOCALIZACION DEL VALOR DEL CONCEPTO
		       cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)
		       IF cCodigoTco $ PAG->cConcepPag
			  nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
			  nVlrTar := &('nVlrCo'+STR(nNroPos,1)+'Pag')
		       ELSE
			  nVlrTar := 0
		       ENDIF
		       nFacMes  += nVlrTar
*....................FIN LOCALIZACION DEL VALOR DEL CONCEPTO

		 ENDFOR
*--------------FIN FACTURACION DEL MES

*--------------CALCULO DE LOS INTERESES
		 nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				       PAG->nMesIniPag,;
				       CAA->nMesAmnCaA)

		 nIntNoP := nVlrIntNoP(CAA->lIntPenCaA,;
				       PAG->nMesIniPag,;
				       CAA->nMesAmnCaA)
*--------------FIN CALCULO DE LOS INTERESES

*--------------ANALISIS DE LA FORMA DE PAGO
		 lFechOk := .T.
		 DO CASE
		 CASE PAG->cEstadoPag == 'P' .OR.;
		      PAG->cEstadoPag == 'A'

*.....................ANALISIS DE LA FECHA DE PAGO
			IF lPrnFec
			   IF PAG->dFecPagPag > dFecPrn
			      lFechOk := .F.
			   ENDIF
			ENDIF
*.....................FIN ANALISIS DE LA FECHA DE PAGO

*.....................FACTURACION DEL MES
			nFacMes := nFacMes*;
				   nNroMesFac(PAG->nMesIniPag,;
					      PAG->nMesFinPag)
*.....................FIN FACTURACION DEL MES

*.....................ANALISIS DEL PAGO. FECHA DENTRO DEL INTERVALO
			IF lFechOk

*                          TOTALIZACION DEL PAGO
			     nVlrPag := PAG->nVlrPagPag
			     nTotPag += nVlrPag
*                          FIN TOTALIZACION DEL PAGO

*                          INTERESES POR PAGO EXTEMPORANEO
			     IF PAG->cEstadoPag == 'A'
				nIntPag := nVlrInt
				nTotInt += nIntPag
			     ENDIF
*                          FIN INTERESES POR PAGO EXTEMPORANEO

*                          ANALISIS DE LA AMNISTIA
			     IF CAA->nMesAmnCaA == nMesIni
				nSdoActTcl += IF(lMesAct,CLI->nSdoActCli,;
							 PAG->nSdoAntPag)
				nSdoMorTcl += IF(lMesAct,CLI->nSdoMorCli,;
							 PAG->nMorAntPag)
				nTotSdo += nSdoActTcl+nSdoMorTcl
			     ENDIF
*                          FIN ANALISIS DE LA AMNISTIA

			ENDIF
*.....................FIN ANALISIS DEL PAGO. FECHA DENTRO DEL INTERVALO

*.....................ANALISIS DE LA DEUDA. FECHA FUERA DE RANGO
			IF !lFechOk

*                          INTERESES POR COBRAR DEL MES
			     cEstadoTpa += '*'    // Fecha fuera de rango

			     nIntMor := 0
			     IF PAG->cEstadoPag == 'A'
				nIntMor := nVlrInt
				nSdoInt += nIntMor
			     ENDIF
*                          FIN INTERESES POR COBRAR DEL MES

*                          ANALISIS DEL RECIBO POR ADELANTADO
			     nVlrPag := PAG->nVlrPagPag
			     nTotDeu += nVlrPag
*                          FIN ANALISIS DEL RECIBO POR ADELANTADO

*                          ANALISIS DE LA AMNISTIA
			     IF CAA->nMesAmnCaA # nMesIni
				nSdoActTcl := nVlrPag
				nSdoMorTcl := nIntNoP
				nTotSdo += nSdoActTcl+nSdoMorTcl
			     ELSE
				nSdoActTcl += IF(lMesAct,CLI->nSdoActCli,;
							 PAG->nSdoAntPag)
				nSdoMorTcl += IF(lMesAct,CLI->nSdoMorCli,;
							 PAG->nMorAntPag)
				nTotSdo += nSdoActTcl+nSdoMorTcl
			     ENDIF
*                          FIN ANALISIS DE LA AMNISTIA

			ENDIF
*.....................FIN ANALISIS DE LA DEUDA. FECHA FUERA DE RANGO

		 CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

		      IF PAG->cEstadoPag = 'D'

*........................ACUMULACION DE LOS INTERESES
			   nIntMor := nIntNoP
			   nSdoInt += nIntMor
*........................FIN ACUMULACION DE LOS INTERESES

*........................ANALISIS DEL RECIBO POR ADELANTADO
			   IF PAG->nMesIniPag == PAG->nMesFinPag
			      nVlrPag := PAG->nVlrPagPag
			   ELSE
			      nVlrPag := PAG->nSdoAntPag+PAG->nMorAntPag+;
					 PAG->nVlrMesPag
			   ENDIF
			   nTotDeu += nVlrPag
*........................FIN ANALISIS DEL RECIBO POR ADELANTADO

*........................ANALISIS DE LA AMNISTIA
			   IF CAA->nMesAmnCaA # nMesIni
			      nSdoActTcl := nVlrPag
			      nSdoMorTcl := nIntNoP

			      nTotSdo += nSdoActTcl+nSdoMorTcl
			   ELSE
			      IF lMesAct
				 nSdoActTcl := CLI->nSdoActCli
				 nSdoMorTcl := CLI->nSdoMorCli
			      ELSE
				 nSdoActTcl := PAG->nSdoAntPag+nVlrPag
				 nSdoMorTcl := PAG->nMorAntPag+nIntNoP
			      ENDIF
			      nTotSdo += nSdoActTcl+nSdoMorTcl
			   ENDIF
*........................FIN ANALISIS DE LA AMNISTIA

		      ELSE

*........................ANALISIS DEL DEUDOR
			   nSdoActTcl += IF(lMesAct,CLI->nSdoActCli,;
						    PAG->nSdoAntPag)
			   nSdoMorTcl += IF(lMesAct,CLI->nSdoMorCli,;
						    PAG->nMorAntPag)
			   nTotSdo += nSdoActTcl+nSdoMorTcl
			   nVlrPag := PAG->nVlrPagPag
*........................FIN ANALISIS DEL DEUDOR

		      ENDIF

		 ENDCASE
*--------------FIN ANALISIS DE LA FORMA DE PAGO

	       nTotMes += nFacMes

	    ENDIF
**********FIN CALCULO DE LOS INTERESES ACUMULACION DE PAGOS

**********LECTURA DEL NOMBRE DEL CONCEPTO
	    IF lHayAlu
	       DO CASE
	       CASE lHayAlu .AND. !lRetadoTes .AND.;
		    CLI->lRetGruCli .AND. !lHayPag
		    cConcepTpa := 'OTRO GRUPO'

	       CASE lHayPag
		    cConcepTpa := PAG->cConcepPag
		    IF LEN(RTRIM(cConcepTpa)) == 2
		       IF lLocCodCon(SUBS(PAG->cConcepPag,1,2))
			  cConcepTpa := CON->cNombreCon
		       ELSE
			  cConcepTpa := 'NO EXISTE '+SUBS(PAG->cConcepPag,1,2)
		       ENDIF
		    ENDIF

	       CASE lHayAlu .AND. !lRetadoTes .AND. !lHayPag
		    cConcepTpa := 'NO FACTURADO'

	       CASE lHayAlu .AND. lRetadoTes .AND. !CLI->lRetGruCli
		    cConcepTpa := 'R E T I R A D O '

		    nSdoActTcl := CLI->nSdoActCli
		    nSdoMorTcl := CLI->nSdoMorCli
		    nTotSdo += nSdoActTcl+nSdoMorTcl

	       CASE !lHayAlu .AND. !lHayPag
		    cConcepTpa := SPACE(22)
	       ENDCASE
	    ELSE
		cConcepTpa := SPACE(22)
	    ENDIF
**********FIN LECTURA DEL NOMBRE DEL CONCEPTO

**********ANALISIS SI TIENE BECA
	    IF lHayAlu
	       IF lTieneBeca(nMesIni,nMesIni)
		  IF cConcepTpa # 'NF PAGO ANTI'
		     cConcepTpa = RTRIM(cConcepTpa)+'->BECA '+cIntBeca()
		  ELSE
		     cConcepTpa += '>BECA'+cIntBeca()
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI TIENE BECA

**********ANALISIS SI TIENE DESCUENTO INDIVIDUAL
	    cTipDes := SPACE(01)
	    IF lHayAlu
	       IF lSekCodDes(CLI->cCodigoEst,nMesIni,.F.)
		  DO CASE
		  CASE DES->nTipDesDes == 1
		       cTipDes := '-'
		  CASE DES->nTipDesDes == 2
		       cTipDes := '+'
		  CASE DES->nTipDesDes == 3
		       cTipDes := 'a'
		  ENDCASE
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI TIENE DESCUENTO INDIVIDUAL

**********ANALISIS SI TIENE DESCUENTO GENERAL
	    IF lHayAlu .AND. lHayPag
	       DO CASE
	       CASE !EMPTY(PAG->nDesGenPag)
		    cTipDes += '-'
	       CASE !EMPTY(PAG->nRecGenPag)
		    cTipDes += '+'
	       ENDCASE
	    ENDIF
**********FIN ANALISIS SI TIENE DESCUENTO GENERAL

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cConcepTpa = cConcepTpa+SPACE(22-LEN(cConcepTpa))
	    aTitulo := {STR(CLI->(RECNO()),2),;
			SPACE(01)+cNombreTes,;
			cConcepTpa,;
			TRANS(nSdoActTcl+nSdoMorTcl,"####,###,###"),;
			IF(lHayPag .AND. lHayAlu,;
			   TRANS(nFacMes,"##,###,###"),SPACE(10)),;
			IF(lHayPag .AND. lHayAlu,;
			   TRANS(nIntMor,"@Z ##,###,###"),SPACE(10)),;
			IF(lHayPag .AND. lHayAlu,;
			       TRANS(nVlrPag,"####,###,###"),SPACE(12)),;
			IF(lHayPag .AND. lHayAlu,;
			   cMes(PAG->nMesIniPag,3)+;
			   cMes(PAG->nMesFinPag,3)+cTipDes,;
			   SPACE(07)+cTipDes),;
			IF(lHayPag .AND. lHayAlu,;
			   TRANS(nIntPag,"@Z ##,###,###"),SPACE(10)),;
			IF(lHayPag .AND. lHayAlu ,cEstadoTpa,SPACE(12)),;
			cCodBan,CLI->cCodigoEst}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	    IF lHayPag .AND. (PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A')

	       nDiaPag := DAY(PAG->dFecPagPag)
	       cDiaPag := STR(nDiaPag,2)
	       lCorrecion(@cDiaPag)

	       AADD(aTitulo,'MV'+cNroMes+cDiaPag+cAnoSis+'.XML') // Campo Url

	    ELSE
	       AADD(aTitulo,'') // Campo Url
	    ENDIF
	    AADD(aRegXml,aTitulo)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT CLI
	    CLI->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       @ PROW()  ,nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       @ PROW()  ,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,09) SAY REPL('-',aNroCol[09])
       @ PROW()  ,nColTxt(aNroCol,10) SAY REPL('-',aNroCol[10])

       aTitulo := {'','','',;
		   REPL('=',aNroCol[04]),;
		   REPL('=',aNroCol[05]),;
		   REPL('=',aNroCol[06]),;
		   REPL('=',aNroCol[07]),'',;
		   REPL('=',aNroCol[09]),;
		   REPL('=',aNroCol[10]),''}

       AADD(aTitulo,'') // Campo Url
       AADD(aRegXml,aTitulo)

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,04) SAY TRANS(nTotSdo,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotMes,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nSdoInt,"##,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotDeu,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,09) SAY TRANS(nTotInt,"##,###,###")
       @ PROW()  ,nColTxt(aNroCol,10) SAY TRANS(nTotPag,"####,###,###")

       aTitulo := {'TOTALES',REPL('*',30),'',;
		   TRANS(nTotSdo,"####,###,###"),;
		   TRANS(nTotMes,"####,###,###"),;
		   TRANS(nSdoInt,"##,###,###"),;
		   TRANS(nTotDeu,"####,###,###"),'',;
		   TRANS(nTotInt,"##,###,###"),;
		   TRANS(nTotPag,"####,###,###"),''}

       AADD(aTitulo,'FAC'+cMes(nMesIni,3)+cAnoSis+'.XML') // Campo Url
       AADD(aRegXml,aTitulo)
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DERECHOS

*>>>>EXPORTACION AL ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{PAGOS}{PAGOS POR ALUMNOS}')
      *Nombre del Sistema

       AADD(aCabXml,'RELACION DE PAGOS FACTURADOS'+;
		    IF(lPrnFec,' A '+cFecha(dFecPrn,3),''))
      *Titulo No. 1

       AADD(aCabXml,'CORRESPONDIENTE AL MES DE '+cMes(nMesIni,10)+;
		    IF(nMesAmn == nMesIni,' CON AMNISTIA',''))
      *Titulo No. 2

       AADD(aCabXml,'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
			      SUBS(cCodGru,3,2)+;
			    ' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr)
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       FileXml(PathW01+'\'+'FACT'+cMes(nMesIni,3)+'\'+;
	       cCodGru+cNroMes+cAnoSis+'.XML',;
	       aRegXml,aCamXml,aCabXml)
     *ÀCreaci¢n del Archivo

       RETURN NIL
*>>>>FIN EXPORTACION AL ARCHIVO
