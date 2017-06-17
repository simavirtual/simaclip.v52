/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: ESTUDIANTES MOROSOS    MODULO No. 401

**************************************************************************
* TITULO.: ESTUDIANTES MOROSOS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/2003 VIE A
       Bucaramanga, Colombia	    INICIO: 04:00 PM   OCT 10/2003 VIE

OBJETIVOS:

1- Permite imprimir los estudiantes morosos

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_411(aParam1,aParam2,aParam3)

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
     *ÀVariables generales

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
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nOpcion := 0                   // Opci¢n de selecci¢n
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL nTipPrn := 0                   // Tipo de Impresi¢n

       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
       LOCAL nDeuGru := 0                   // Deuda del Grupo
       LOCAL nDeuNiv := 0                   // Deuda del Nivel
       LOCAL nTotDeu := 0                   // Total de la deuda
       LOCAL nNroAlu := 0                   // N£mero de Alumnos
       LOCAL aConGru := {}                  // Conceptos por Grupos
       LOCAL aConNiv := {}                  // Conceptos por Niveles
       LOCAL aTotCon := {}                  // Total Conceptos
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registros de Impresion
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aTotDia := {}                  // Total por edades
       LOCAL GetList := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

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
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis)
	      cError('ABRIENDO ARCHIVOS')
	      CloseAll()
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN NIL
	   ENDIF

	   SELECT GRU
	   GO TOP
	   DO WHILE .NOT. (GRU->(EOF()))

	      IF FUE->(lRegLock(lShared,.T.))
		 REPL FUE->cCodigoGru WITH GRU->cCodigoGru
		 FUE->(DBCOMMIT())
	      ELSE
		 cError('NO SE GRABA LA FORMA DE PAGO')
	      ENDIF
	      IF lShared
		 FUE->(DBUNLOCK())
	      ENDIF

	      SELECT GRU
	      SKIP

	   ENDDO

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis)    .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared).OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
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

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN TARIFAS CREADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
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

       nNroIso := 411
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<INFORMES><ALUMNOS MOROSOS><RELACION MOROSOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'ESTUDIANTES MOROSOS. A¥O: <cAnoUsr> JORNADA: <cJorTxt>') // T¡tulo Uno
       AADD(aTitIso,'')                                                       // T¡tulo Dos
       AADD(aTitIso,'')                                                       // T¡tulo Tres
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

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIniTpa == 0
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)) == -3
	    DIRMAKE(cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3))
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       IF CAA->lPrnConCaA
	  nTipPrn := nLeeOpcion('TIPO: 1<POR ESTUDIANTE> '+;
				      '2<POR GRUPO> '+;
				      '3<POR NIVELES>?',3,'0')
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO


*>>>>SELECION DEL TIPO DE INFORME
       nOpcion := 1
       IF CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA
	  nOpcion := nLeeOpcion('TIPO DE INFORME?: '+;
		    '1<SIN FECHA DE CORTE> 2<CON FECHA DE CORTE?',2,'0')
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECION DEL TIPO DE INFORME

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')
       lPrnFec := IF(nOpcion == 1,.F.,.T.)
       IF lPrnFec

	  RESTSCREEN(0,0,24,79,cSavPan)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	  @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(dFecPrn)
	     CloseAll(aUseDbf)
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(SCA->cSerFacCar,1,1)+'mor'+cAnoUsr
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.F.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
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

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecPrn)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       aCabeza := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   IF(!EMPTY(nMesIniTpa),'RECIBOS MES DE '+cMes(nMesIniTpa),''),;
		   IF(lPrnFec,' A '+cFecha(dFecPrn),'SIN FECHA DE CORTE'),;
		   nNroPag++,NIL,lTamAnc}

       IF CAA->lPrnConCaA
	  cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       ELSE
	  cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       ENDIF
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF nTipPrn == 0 .OR. nTipPrn == 1
	  IF nTipPrn == 0
	     aNroCol := {04,06,08,42,12}
	     aTitulo := {'No.','CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
			 'SALDO ACTUAL'}
	  ELSE
	     aNroCol := {04,06,08,30,12}
	     aTitulo := {'No.','CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
			 'SALDO ACTUAL'}
	  ENDIF
       ENDIF

       DO CASE
       CASE nTipPrn = 0

	    AADD(aNroCol,04) // Mora
	    AADD(aNroCol,60)
/*
	    AADD(aNroCol,18)
	    AADD(aNroCol,14)
	    AADD(aNroCol,14)
*/

/*
	    AADD(aNroCol,14)
	    AADD(aNroCol,14)
*/

	    AADD(aTitulo,'MORA')
	    AADD(aTitulo,'CONTACTO')

/*
	    AADD(aTitulo,'NOMBRE DEL PADRE')
	    AADD(aTitulo,'TELPADRE')
	    AADD(aTitulo,'NOMBRE DE LA MADRE')
	    AADD(aTitulo,'TELMADRE')
*/
/*
	    AADD(aTitulo,'TELEACUD')
	    AADD(aTitulo,'TELECASA')
*/

	    aCamXml := aTitulo

       CASE nTipPrn = 1

	     AADD(aNroCol,16)
	     AADD(aNroCol,12)
	     AADD(aTitulo,'CONCEPTO')
	     AADD(aTitulo,'VALOR')
	     aCamXml := aTitulo

       CASE nTipPrn == 2 .OR. nTipPrn == 3

	  AADD(aNroCol,06)
	  AADD(aNroCol,12)
	  AADD(aNroCol,16)
	  AADD(aNroCol,12)

	  AADD(aTitulo,IF(nTipPrn == 2,'GRUPO','NIVEL'))
	  AADD(aTitulo,'SALDO ACTUAL')
	  AADD(aTitulo,'CONCEPTO')
	  AADD(aTitulo,'VALOR')
	  aCamXml := aTitulo

       ENDCASE
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
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

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT

       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       VerPrn(nOpcPrn,FilePrn)
	       SET DEVICE TO SCREEN
	       cError('ABRIENDO DE CLIENTES Y PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       SET DEVICE TO SCREEN
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))

	    aConGru := {}
	    nDeuGru := nMorosos(aParam1,aParam2,aParam3,;
				GRU->cCodigoGru,nColCab,;
				aTitulo,aNroCol,bPagina,bDerAut,;
				bCabeza,nMesIniTpa,dFecPrn,lPrnFec,;
				@nNroAlu,aConGru,nTipPrn,aRegXml,aTotDia)

	    nTotDeu += nDeuGru
	    nDeuNiv += nDeuGru

	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL INFORME

**********IMPRESION DE LOS CONCEPTOS DEL GRUPO
	    SumArrCon(aTotCon,aConGru)

	    IF nTipPrn == 2 .AND. LEN(aConGru) # 0

	       aTitulo := {}
	       AADD(aTitulo,GRU->cCodigoGru)
	       AADD(aTitulo,TRANS(nDeuGru,'@Z ####,###,###'))
	       AADD(aTitulo,aConGru[1,2])
	       AADD(aTitulo,TRANS(aConGru[1,3],'@Z ####,###,###'))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
			  IF(nDeuGru # nSuma(aConGru,3),'?REVISAR','')
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	       IF LEN(aConGru) > 1

		  FOR i := 2 TO LEN(aConGru)
		      aTitulo := {'','',;
				  aConGru[i,2],;
				  TRANS(aConGru[i,3],'@Z ####,###,###')}

		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		  ENDFOR

	       ENDIF

	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS POR GRUPOS

**********AVANCE DEL SIGUIENTE GRUPO
	    SumArrCon(aConNiv,aConGru)
	    cNivAnt := SUBS(GRU->cCodigoGru,1,2)
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct

	       IF nTipPrn == 3

		  aTitulo := {}
		  AADD(aTitulo,cNivAnt)
		  AADD(aTitulo,TRANS(nDeuNiv,'@Z ####,###,###'))
		  AADD(aTitulo,aConNiv[1,2])
		  AADD(aTitulo,TRANS(aConNiv[1,3],'@Z ####,###,###'))

		  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
			     IF(nDeuNiv # nSuma(aConNiv,3),'?REVISAR','')
		  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		  IF LEN(aConGru) > 1

		     FOR i := 2 TO LEN(aConNiv)
			 aTitulo := {'','',;
				     aConNiv[i,2],;
				     TRANS(aConNiv[i,3],'@Z ####,###,###')}

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		     ENDFOR

		  ENDIF
	       ENDIF

	       nDeuNiv := 0
	       aConNiv := {}
	       cNivAnt := cNivAct
	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

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

*>>>>IMPRESION DEL ULTIMO NIVEL
       IF nTipPrn == 3 .AND. !EMPTY(aConNiv)

	  aTitulo := {}
	  AADD(aTitulo,cNivAnt)
	  AADD(aTitulo,TRANS(nDeuNiv,'@Z ####,###,###'))
	  AADD(aTitulo,aConNiv[1,2])
	  AADD(aTitulo,TRANS(aConNiv[1,3],'@Z ####,###,###'))
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		     IF(nDeuNiv # nSuma(aConNiv,3),'?REVISAR','')
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)


	  IF LEN(aConGru) > 1
	     FOR i := 2 TO LEN(aConNiv)
		 aTitulo := {'','',;
			     aConNiv[i,2],;
			     TRANS(aConNiv[i,3],'@Z ####,###,###')}

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF
       ENDIF
*>>>>FIN IMPRESION DEL ULTIMO NIVEL

*>>>>IMPRESION DE LOS TOTALES
       IF nTotDeu # 0
	  IF nTipPrn == 0 .OR. nTipPrn == 1

	     @ PROW()+1,nColCab+nColTxt(aNroCol,05);
			SAY REPL('-',aNroCol[05])

	     @ PROW()+1,nColCab+nColTxt(aNroCol,01);
			SAY 'GRAN TOTAL ... '+;
			IF(nTotDeu # nSuma(aTotCon,3),;
			   '','')
/*
	     @ PROW()+1,nColCab+nColTxt(aNroCol,01);
			SAY 'GRAN TOTAL ... '+;
			IF(nTotDeu # nSuma(aTotCon,3),;
			   '?REVISAR','')
*/

	     @ PROW()  ,nColCab+nColTxt(aNroCol,05);
			SAY TRANS(nTotDeu,"####,###,###")
	  ELSE

	     @ PROW()+1,nColCab+nColTxt(aNroCol,02);
			SAY REPL('-',aNroCol[02])

	     @ PROW()  ,nColCab+nColTxt(aNroCol,04);
			SAY REPL('-',aNroCol[04])

	     @ PROW()+1,nColCab+nColTxt(aNroCol,02);
			SAY TRANS(nTotDeu,"####,###,###")

	     @ PROW(),nColCab+nColTxt(aNroCol,04);
		      SAY TRANS(nSuma(aTotCon,3),"####,###,###")+;
		      IF(nTotDeu # nSuma(aTotCon,3),'?REVISAR','')

	  ENDIF
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>ENCABEZADOS DE TOTALES
       IF nTipPrn == 0 .OR. nTipPrn == 1

	  aNroCol := {04,14,14,14}
	  aTitulo := {'EDAD',;
		      'SALDO',;
		      'DEUDA',;
		      'MORA'}
	  cCabCol := cRegPrint(aTitulo,aNroCol)

	  lPrnReg(02,nColCab,REPL('=',LEN(cCabCol)),bPagina,bDerAut,bCabeza)
	  lPrnReg(01,nColCab,cCabCol,bPagina,bDerAut,bCabeza)
	  lPrnReg(01,nColCab,REPL('=',LEN(cCabCol)),bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN ENCABEZADOS DE TOTALES

*>>>>CARTERA POR EDADES
       IF nTipPrn == 0 .OR. nTipPrn == 1

	  aTotDia := ASORT(aTotDia,,,{|x,y|x[1] < y[1]})
	  FOR i := 1 TO LEN(aTotDia)

	      aTitulo := {}
	      AADD(aTitulo,STR(aTotDia[i,1],4))
	      AADD(aTitulo,TRANS(aTotDia[i,2]+;
				 aTotDia[i,3],'####,###,###'))
	      AADD(aTitulo,TRANS(aTotDia[i,2],'####,###,###'))
	      AADD(aTitulo,TRANS(aTotDia[i,3],'####,###,###'))

	      cTxtPrn := cRegPrint(aTitulo,aNroCol)
	      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	  ENDFOR

       ENDIF
*>>>>FIN CARTERA POR EDADES

*>>>>TOTALES
       IF nTipPrn == 0 .OR. nTipPrn == 1

	  aTitulo := {}
	  AADD(aTitulo,REPL('-',aNroCol[1]))
	  AADD(aTitulo,REPL('-',aNroCol[2]))
	  AADD(aTitulo,REPL('-',aNroCol[3]))
	  AADD(aTitulo,REPL('-',aNroCol[4]))

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	  aTitulo := {}
	  AADD(aTitulo,'TOT.')
	  AADD(aTitulo,TRANS(nSuma(aTotDia,2)+;
			     nSuma(aTotDia,3),'####,###,###'))
	  AADD(aTitulo,TRANS(nSuma(aTotDia,2),'####,###,###'))
	  AADD(aTitulo,TRANS(nSuma(aTotDia,3),'####,###,###'))

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN TOTALES


*>>>>IMPRESION DEL PAGO POR CONCEPTOS
       IF .NOT. EMPTY(aTotCon)

	  @ PROW()+1,nColCab+nColTxt(aNroCol,01);
		     SAY 'GRAN TOTAL ... '+;
		     IF(nTotDeu # nSuma(aTotCon,3),;
			'?REVISAR','')

	  PrnConVlr(01,bPagina,bDerAut,bCabeza,aTotCon,3)
       ENDIF
*>>>>FIN IMPRESION DEL PAGO POR CONCEPTOS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DERECHOS

*>>>>IMPRESION DE LOS TOTALES
       IF nTotDeu # 0
	  IF nTipPrn == 0

	     aTitulo := {}
	     aTitulo := {'','','',REPL('*',30),REPL('=',14)}

	     AADD(aTitulo,REPL('*',30))
	     AADD(aTitulo,REPL('*',30))
	     AADD(aTitulo,REPL('*',10))
	     AADD(aTitulo,REPL('*',10))
	     AADD(aTitulo,REPL('*',10))
	     AADD(aTitulo,REPL('*',10))

	     AADD(aTitulo,'') // Url
	     AADD(aRegXml,aTitulo)

	     aTitulo := {}
	     aTitulo := {'RESUMEN','','','SALDO ACTUAL',TRANS(nTotDeu,"####,###,###")}
	     AADD(aTitulo,'')
	     AADD(aTitulo,'')
	     AADD(aTitulo,'')
	     AADD(aTitulo,'')
	     AADD(aTitulo,'')
	     AADD(aTitulo,'')

	     AADD(aTitulo,'RSF'+cMes(nMesIniTpa,3)+cAnoSis+'.XML') // Url
	     AADD(aRegXml,aTitulo)

	  ENDIF
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>EXPORTACION AL ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{INFORMES}{ALUMNOS MOROSOS}{RELACION MOROSOS}')
      *Nombre del Sistema

       AADD(aCabXml,'ESTUDIANTES MOROSOS.'+;
		   ' A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt)
      *Titulo No. 1

       AADD(aCabXml,IF(!EMPTY(nMesIniTpa),;
		    'RECIBOS MES DE '+cMes(nMesIniTpa),''))
      *Titulo No. 2

       AADD(aCabXml,IF(lPrnFec,' A '+cFecha(dFecPrn),'SIN FECHA DE CORTE'))
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       IF nTotDeu # 0 .AND. nTipPrn == 0

	  FileXml(PathW01+'\'+'FACT'+cMes(nMesIniTpa,3)+'\'+;
		  'MOR'+cMes(nMesIniTpa,3)+cAnoSis+'.XML',;
		  aRegXml,aCamXml,aCabXml)
	*ÀCreaci¢n del Archivo

       ENDIF
       RETURN NIL
*>>>>FIN EXPORTACION AL ARCHIVO

/*************************************************************************
* TITULO..: MOROSOS                                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/2003 VIE A
       Bucaramanga, Colombia	    INICIO: 05:00 PM   OCT 10/2003 VIE

OBJETIVOS:

1- Imprime los estudiantes morosos del grupo

2- Return el total de la deuda del grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMorosos(aParam1,aParam2,aParam3,;
		  cCodGru,nColCab,aTitulo,aNroCol,bPagina,bDerAut,;
		  bCabeza,nMesIni,dFecPrn,lPrnFec,nNroAlu,aConGru,;
		  nTipPrn,aRegXml,aTotDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cCodGru                              // C¢digo del grupo
       nColCab                              // Columna del encabezado
       aTitulo                              // T¡tulos para impresi¢n
       aNroCol                              // Columnas de impresi¢n
       bPagina                              // Block de P gina
       bDerAut                              // Block Derechos de Autor
       bCabeza                              // Block de Encabezado
       dFecPrn                              // Fecha de Impresi¢n de Corte
       lPrnFec                              // .T. Imprimir por Fechas
       nNroAlu                              // N£mero de Alumnos
       nTipPrn			            // Tipo de Informe
       aRegXml                              // Registro de Impresi¢n
       aTotDia                              // Total por edades */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nMesFac := 0                   // Mes Facturado
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrAbo := 0                   // Valor del Abono
       LOCAL aConAlu := {}                  // Conceptos por Estudiante
       LOCAL nDiaMor := 0                   // Dias en Mora
       LOCAL nMesSdo := 0                   // Mes del saldo
       LOCAL cTxtTem := ''                  // Texto temporal

       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lMesAct := .T.                 // .T. Mes Actual
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL lDeudor := .T.                 // .T. Deudor
       LOCAL nSdoAct := 0                   // Saldo Actual
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nSdoActTcl := 0                // Deuda Actual
       LOCAL nSdoMorTcl := 0                // Mora Actual
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL nMesIniTpa := 0                // Mes Inicial del Pago
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

*>>>>IMPRESION DEL TERMOMETRO
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       CLI->(DBGOTOP())
       nMesIniTpa := nMesIni
       DO WHILE .NOT. CLI->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('CODIGO: '+CLI->cCodigoEst+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'º'+;
			STR(CLI->(RECNO()),3)+'/'+;
			STR(CLI->(RECCOUNT()),3),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetGruCli
	       SELECT CLI
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lRetadoTes := .T.
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cNalias,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)

	       IF &cNalias->lRetiroEst
		  lRetadoTes := .T.
	       ENDIF
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF

	    IF nTipPrn == 0
	       cNombreTes := SUBS(cNombreTes+SPACE(20),1,42)
	    ELSE
	       cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********CALCULO DEL SALDO ACTUAL
	    nSdoAct := nSdoActEst(CLI->cCodigoEst,lRetadoTes,;
				  cMaeAlu,nMesIniTpa,lPrnFec,;
				  dFecPrn)
**********FIN CALCULO DEL SALDO ACTUAL

**********ANALISIS SI ES EL MES ACTUAL
	    nMesIni := nMesIniTpa

	    nMesFac := LEN(RTRIM(CLI->cMesPagCli))
	    IF nMesIni < nMesFac
	       lMesAct := .F.
	       nMesIni := nMesIniTpa
	    ELSE
	       IF CAA->nMtdSdoCaA # 98 // No se acumula saldos
		  nMesIni := nMesFac
	       ENDIF
	       lMesAct := .T.
	    ENDIF
**********FIN ANALISIS SI ES EL MES ACTUAL


**********ANALSISIS DE DECISION
	    IF CAA->nMtdSdoCaA == 98 // No se acumula saldos
	       lMesAct := .F.
	    ENDIF
**********FIN ANALSISIS DE DECISION

**********ANALISIS SI EL ESTUDIANTE ES MOROSO
	       aConAlu := {}
	       lDeudor := .F.
	    nSdoActTcl := 0                // Deuda Actual
	    nSdoMorTcl := 0                // Mora Actual

	    IF .NOT. lPrnFec
	       IF lMesAct .AND. CLI->nSdoActCli+CLI->nSdoMorCli # 0
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
		  nTotSdo += nSdoActTcl+nSdoMorTcl
		  lDeudor := .T.
	       ENDIF
	    ELSE
	       lMesAct := .F.
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ES MOROSO

**********LOCALIZACION DEL PAGO
	    SELECT PAG
	    SET FILTER TO
	    PAG->(DBGOTOP())
	    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
**********FIN LOCALIZACION DEL PAGO

**********ANALISIS DE LA FECHA DE PAGO
	    lFechOk := .T.
	    IF lPrnFec .AND. lHayPag
	       IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
		  IF PAG->dFecPagPag > dFecPrn
		     lFechOk := .F.
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA FECHA DE PAGO

**********ANALISIS DEL PAGO
	    IF !lMesAct .AND. lHayAlu .AND. lHayPag

*--------------CALCULO DE LOS INTERESES

		 DO CASE
		 CASE PAG->cEstadoPag = 'D'

		      nVlrInt := nVlrIntNoP(CAA->lIntPenCaA,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)

		 CASE PAG->cEstadoPag == 'A'

		      nVlrInt := nIntMesPag(CAA->lIntPenCaA,;
					    PAG->nSdoAntPag,;
					    PAG->nVlrMesPag,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)
		 OTHERWISE
		      nVlrInt := 0
		 ENDCASE
*--------------FIN CALCULO DE LOS INTERESES

*--------------ANALISIS DE LA FORMA DE PAGO
		 lDeudor := .F.
		 IF PAG->cEstadoPag = 'D' .OR. !lFechOk

*...................ANALISIS DEL RECIBO POR ADELANTADO
		      IF PAG->nMesIniPag == PAG->nMesFinPag
			 nVlrPag := PAG->nSdoAntPag+PAG->nVlrMesPag
		      ELSE
			 IF CAA->nMesAmnCaA == nMesIni
			    nVlrPag := PAG->nVlrMesPag
			 ELSE
			    nVlrPag := PAG->nSdoAntPag+PAG->nVlrMesPag
			 ENDIF
		      ENDIF
*...................FIN ANALISIS DEL RECIBO POR ADELANTADO

*...................ANALISIS DE LA AMNISTIA
		      IF CAA->nMesAmnCaA # nMesIni
			 nSdoActTcl := nVlrPag
			 nSdoMorTcl := PAG->nMorAntPag+nVlrInt
		      ELSE
			 nSdoActTcl := PAG->nSdoAntPag+nVlrPag
			 nSdoMorTcl := PAG->nMorAntPag+nVlrInt
		      ENDIF
		      IF nSdoActTcl+nSdoMorTcl == 0
			 lDeudor := .F.
		      ELSE
			 lDeudor := .T.
		      ENDIF
		      nTotSdo += nSdoActTcl+nSdoMorTcl
*...................FIN ANALISIS DE LA AMNISTIA

		 ENDIF
*--------------FIN ANALISIS DE LA FORMA DE PAGO

	    ELSE

*..............SALDO DEL ESTUDIANTE RETIRADO
		 IF !lMesAct .AND. lRetadoTes .AND.;
		    CLI->nSdoActCli+CLI->nSdoMorCli # 0 .AND. lHayPag

		    nSdoActTcl := CLI->nSdoActCli
		    nSdoMorTcl := CLI->nSdoMorCli
		   *Saldo Anterior

		    nTotSdo += nSdoActTcl+nSdoMorTcl
		    lDeudor := .T.
		 ENDIF
*..............FIN SALDO DEL ESTUDIANTE RETIRADO

	    ENDIF
**********FIN ANALISIS DEL PAGO


**********DESCRIMIMACION DEL SALDO
	    IF CAA->lPrnConCaA .AND. nSdoActTcl+nSdoMorTcl # 0
	       lHayErr := !lVlrConSdo(nSdoActTcl,nSdoMorTcl,aConAlu,;
				      @nDiaMor,@nMesSdo)
	    ENDIF
**********FIN DESCRIMIMACION DEL SALDO

**********FILTRACION DEL ARCHIVO DE DESCUENTOS
	    IF lPrnFec
	       SELECT DES
	       SET FILTER TO DES->cCodigoEst == CLI->cCodigoEst .AND.;
			     DES->nTipDesDes == 3               .AND.;
			     (DES->nNroMesDes == nMesIni .OR.;
			      DES->nMesModDes == nMesIni)
	       GO TOP

	       IF DES->(EOF())
		  SET FILTER TO
	       ENDIF
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO DE DESCUENTOS

**********ANALISIS DEL ABONO
	    IF lPrnFec

*--------------ANALISIS DE LOS ABONOS
		 DO WHILE .NOT. DES->(EOF())

*...................ANALISIS DE LA FECHA DE PAGO
		      nVlrAbo := 0
		      IF DES->dFechaDes > dFecPrn

			 IF DES->nNroMesDes == nMesIni
			    nVlrAbo := DES->nValorDes
			 ELSE
			    nVlrAbo := DES->nAboOtrDes
			 ENDIF

			    nTotSdo += nVlrAbo
			 nSdoActTcl += nVlrAbo

			 IF CAA->lPrnConCaA
			    lHayErr := !lVlrConAbo(aConAlu)
			 ENDIF
		       * Descriminaci¢n del Abono

		      ENDIF
		      DES->(DBSKIP())
*...................FIN ANALISIS DE LA FECHA DE PAGO

		 ENDDO
*--------------FIN ANALISIS DE LOS ABONOS

	    ENDIF
	    SET FILTER TO
**********FIN ANALISIS DEL ABONO

**********ANALISIS DEL SALDO
	    IF nSdoActTcl+nSdoMorTcl == 0
	       IF .NOT. lDeudor
		  lDeudor := .F.
	       ENDIF
	    ELSE
	       lDeudor := .T.
	       nNroAlu++
	    ENDIF
**********FIN ANALISIS DEL SALDO

**********ANALISIS DEL SALDO
	    IF nSdoActTcl+nSdoMorTcl # nSdoAct
	       SET DEVICE TO SCREEN
*	       cError('SALDOS DIFERENTES:'+CLI->cCodigoEst)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN ANALISIS DEL SALDO

**********AVANCE DEL SIGUIENTE CLIENTE
	    SELECT CLI
	    IF !lDeudor
	       CLI->(DBSKIP())
	       IF CLI->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE CLIENTE

**********DESCRIMIMACION DEL SALDO
	    IF !CAA->lPrnConCaA

	       nDiaMor := 0
	       IF nSdoActTcl+nSdoMorTcl # 0

		  lHayErr := !lVlrConSdo(nSdoActTcl,nSdoMorTcl,aConAlu,;
					 @nDiaMor,@nMesSdo)

	       ENDIF

	       aConAlu := {}  // Borra la descriminaci¢n de los conceptos

	    ENDIF
**********FIN DESCRIMIMACION DEL SALDO

**********LOCALIZACION DE LOS DIAS EN MORA
	    IF !CAA->lPrnConCaA

	       IF EMPTY(aTotDia)
		  AADD(aTotDia,{nDiaMor,;          // 1. Dias en mora
				     0,;           // 2. Deuda
				     0})           // 3. Mora
		  i := LEN(aTotDia)
	       ELSE
		  i := ASCAN(aTotDia,{|aArr|aArr[1] == nDiaMor})
		  IF i == 0
		     AADD(aTotDia,{nDiaMor,;       // 1. Dias en mora
					0,;        // 2. Deuda
					0})        // 3. Mora
		      i := LEN(aTotDia)
		  ENDIF
	       ENDIF

	       aTotDia[i,2] += nSdoActTcl	        // 2. Deuda
	       aTotDia[i,3] += nSdoMorTcl	        // 3. Mora

	    ENDIF
**********FIN LOCALIZACION DE LOS DIAS EN MORA

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF nTipPrn == 0 .OR. nTipPrn == 1

	       aTitulo := {}
	       AADD(aTitulo,STR(nNroAlu,4))
	       AADD(aTitulo,CLI->cCodigoEst)
	       AADD(aTitulo,GRU->cCodigoGru+'-'+STR(CLI->(RECNO()),2))
	       IF lHayErr
		  IF nTipPrn == 0
		     AADD(aTitulo,SPACE(01)+SUBS(cNombreTes,1,40)+'.')
		  ELSE
		     AADD(aTitulo,SPACE(01)+SUBS(cNombreTes,1,18)+'.')
		  ENDIF
	       ELSE
		  IF nTipPrn == 0
		     AADD(aTitulo,SPACE(01)+SUBS(cNombreTes,1,41))
		  ELSE
		     AADD(aTitulo,SPACE(01)+SUBS(cNombreTes,1,19))
		  ENDIF
	       ENDIF
	       AADD(aTitulo,TRANS(nSdoActTcl+nSdoMorTcl,'####,###,###'))

	    ENDIF

	    DO CASE
	    CASE nTipPrn == 0

		 AADD(aTitulo,STR(nDiaMor,3)) // EDAD DE LA CARTERA

		 cTxtTem := ALLTRIM(&cNalias->cNomPadEst)+':'+;
			    ALLTRIM(&cNalias->cTelPadEst)+','+;
			    ALLTRIM(&cNalias->cNomMadEst)+':'+;
			    ALLTRIM(&cNalias->cTelMadEst)
		 cTxtTem := SUBS(cTxtTem+SPACE(60),1,60)
		 AADD(aTitulo,cTxtTem)

/*
		 AADD(aTitulo,SUBS(&cNalias->cNomPadEst,1,18))
		 AADD(aTitulo,&cNalias->cTelPadEst)
		 AADD(aTitulo,SUBS(&cNalias->cNomMadEst,1,18))
		 AADD(aTitulo,&cNalias->cTelMadEst)

		 AADD(aTitulo,&cNalias->cTe1AcuEst)
		 AADD(aTitulo,&cNalias->cTelefnEst)
*/

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		 AADD(aTitulo,'')  // Url
		 AADD(aRegXml,aTitulo)

	    CASE nTipPrn == 1

		 IF LEN(aConAlu) >= 1
		    AADD(aTitulo,aConAlu[1,2])
		    AADD(aTitulo,TRANS(aConAlu[1,3],'@Z ####,###,###'))
		 ELSE
		    IF EMPTY(aConAlu)
		       AADD(aTitulo,'?')
		       AADD(aTitulo,'?')
		    ELSE
		       AADD(aTitulo,'error')
		       AADD(aTitulo,'error')
		    ENDIF
		 ENDIF
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
			    IF(nSdoActTcl+nSdoMorTcl # nSuma(aConAlu,3),;
			       '?REVISAR','')
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		 IF LEN(aConAlu) > 1
		    FOR i := 2 TO LEN(aConAlu)
			aTitulo := {'','','','','',;
				    aConAlu[i,2],;
				    TRANS(aConAlu[i,3],'@Z ####,###,###')}

			cTxtPrn := cRegPrint(aTitulo,aNroCol)
			lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		    ENDFOR
		 ENDIF

	    ENDCASE
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********SUMA DE LOS CONCEPTOS DEL GRUPO
	    SumArrCon(aConGru,aConAlu)
**********FIN SUMA DE LOS CONCEPTOS DEL GRUPO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
	    IF CLI->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
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
       IF nTotSdo # 0 .AND. (nTipPrn == 0 .OR. nTipPrn == 1)

	  @ PROW()+1,nColCab+nColTxt(aNroCol,05);
		     SAY REPL('-',aNroCol[05])

	  IF nTipPrn == 1
	     @ PROW(),nColCab+nColTxt(aNroCol,07);
		      SAY REPL('-',aNroCol[05])
	  ENDIF

	  @ PROW()+1,nColCab+nColTxt(aNroCol,01);
		     SAY 'TOTAL GRUPO: '+cCodGru

	  @ PROW()  ,nColCab+nColTxt(aNroCol,05);
		     SAY TRANS(nTotSdo,"####,###,###")

	  IF nTipPrn == 1
	     @ PROW(),nColCab+nColTxt(aNroCol,07);
		      SAY TRANS(nSuma(aConGru,3),"####,###,###")+;
		      IF(nTotSdo # nSuma(aConGru,3),'','')
	  ENDIF

       ENDIF

       RETURN nTotSdo
*>>>>FIN IMPRESION DE LOS TOTALES
