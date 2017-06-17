/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: CLASIFICACION                            MODULO No. 4

**************************************************************************
* TITULO..: CLASIFICACION DE LOS MOROSOS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2000 LUN A
       Bucaramanga, Colombia	    INICIO: 12:15 PM   SEP 04/2000 LUN

OBJETIVOS:

1- Permite grabar e imprimir la clasificaci¢n de los estudiantes en mora.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_415(aParam1,aParam2,aParam3)

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
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL       i := 0                   // Contador
       LOCAL nOpcion := 0                   // N£mero de Opci¢n
       LOCAL nNroCla := 0                   // N£mero de Clasificaci¢n
       LOCAL cMsgTxt := ''                  // Texto

       LOCAL GetList := {}                  // Variable del Sistema
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

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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

*>>>>ANALISIS DE DECISION
       nOpcion := nLeeOpcion('OPCION: '+;
		 '1<GRABAR> 2<IMPRIMIR> 3<BORRAR TODOS 4<ABANDONAR>?',4,'0')
       *Lee la forma de pago

       IF nOpcion == 4
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DEL NUMERO DE LA CLASIFICACION
       IF nOpcion == 1 .OR. nOpcion == 2
	  nNroCla := 0
	  IF nOpcion == 1
	     @ nFilInf+1,nColInf SAY 'CLASIFICACION' GET nNroCla PICT '99'
	  ELSE
	     @ nFilInf+1,nColInf SAY 'CLASIFICACION' GET nNroCla PICT '99';
						     VALID nNroCla > 0
	  ENDIF
	  READ
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE LA CLASIFICACION

*>>>>SELECION DE LA IMPRESION
       IF nOpcion == 2
	  ActivaPrn(lSiRed,cNomSis,PathSis,;
		    fSimCar,'cColaAcCar','Car',,nModCry)
       ENDIF
*>>>>FIN SELECION DE LA IMPRESION

*>>>>PREGUNTA DE DECISION
       IF nOpcion == 1 .OR. nOpcion == 2
	  cMsgTxt := 'ESCOGIO LA CLASIFICACION No.'+ALLTRIM(STR(nNroCla,2))+;
		     ' DESEA CONTINUAR? No Si'
       ELSE
	  cError('SE VAN A BORRAR TODAS LAS CLASIFICACIONES DIGITADAS')
	  cMsgTxt := 'DESEA CONTINUAR? No Si'
       ENDIF
       IF !lPregunta(cMsgTxt)
	  cError('SE ABANDONA EL PROCESO. DECIDIO NO CONTINUAR')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF nOpcion == 2
	  IF !Printer_on()
	      CloseAll()
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE LA OPCION
       cSavPan := SAVESCREEN(0,0,24,79)
       DO CASE
       CASE nOpcion == 1
	    ClaMoroso(aParam1,aParam2,aParam3,;
		      nNroCla)
	   *Grabaci¢n de la Clasificaci¢n

       CASE nOpcion == 2
	    PrnClasif(aParam1,aParam2,aParam3,;
		      nNroCla)
	   *Impresi¢n de la Clasificaci¢n

       CASE nOpcion == 3
	    DelClaMor(aParam1,aParam2,aParam3)
	   *Borrado de todas las Clasificaciones

       ENDCASE
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseAll()
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN ANALISIS DE LA OPCION

/*************************************************************************
* TITULO..: GRABACION DE LA CLASIFICACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2000 LUN A
       Bucaramanga, Colombia	    INICIO: 12:30 PM   SEP 04/2000 LUN

OBJETIVOS:

1- Permite grabar la clasificaci¢n de los estudiantes en mora.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION ClaMoroso(aParam1,aParam2,aParam3,;
		   nNroCla)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       nNroCla                              // N£mero de la Clasificaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL GetList := {}                  // Variable del Sistema
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES A CLASIFICAR',22,'°')
       aTamCol := {06,06,50}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(50),1,50))
	    @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********GRABACION DE LA CLASIFICACION
	    SELECT &cMaeAct
	    IF lRegLock(lSiRed,.F.)
	       REPL &cMaeAct->nMorosoEst WITH nNroCla
	       DBCOMMIT()
	    ELSE
	       cError('NO SE GRABA LA BECA PARA EL ESTUDIANTE')
	    ENDIF
	    IF lSiRed
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DE LA CLASIFICACION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO '+;
			    'DE LOS ESTUDIANTES A CLASIFICAR',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS

/*************************************************************************
* TITULO..: IMPRESION DE LA CLASIFICACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2000 LUN A
       Bucaramanga, Colombia	    INICIO: 12:30 PM   SEP 04/2000 LUN

OBJETIVOS:

1- Permite imprimir la clasificaci¢n de los estudiantes en mora.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION PrnClasif(aParam1,aParam2,aParam3,;
		   nNroCla)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       nNroCla                              // N£mero de la Clasificaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

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
     *ÀVariables de informe

       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL cTitulo := ''                  // T¡tulo del Informe

       LOCAL GetList := {}                  // Variable del Sistema
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       SET DEVICE TO SCREEN
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  RETURN NIL
       ENDIF
       cTitulo := SPACE(40)
       @ nFilInf+3,nColInf SAY 'TITULO' GET cTitulo PICT '@!S30'
       READ
       cTitulo := ALLTRIM(cTitulo)
       SET DEVICE TO PRINT
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0
       aCabeza := {cNomEmp,cNomSis,;
		   'ESTUDIANTES CLASIFICACION No. '+;
		   STR(nNroCla,2,0),;
		   IF(EMPTY(cTitulo),'TITULO: '+REPL('_',30),cTitulo),;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}

       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,26,26,50}
       aTitulo := {'CODIGO',;
		   'GRUPO',;
		   'APELLIDOS',;
		   'NOMBRES',;
		   'OBSERVACIONES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>INICIALIACION DE LA IMPRESORA
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN INICIALIACION DE LA IMPRESORA

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********FILTRACION DEL ARCHIVO DE ALUMNOS
	    cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
	    DO CASE
	    CASE cMaeAct == 'JAR'
	       SELECT JAR
	       SET FILTER TO JAR->cCodigoGru == GRU->cCodigoGru

	    CASE cMaeAct == 'PRI'
	       SELECT PRI
	       SET FILTER TO PRI->cCodigoGru == GRU->cCodigoGru

	    CASE cMaeAct == 'BTO'
	       SELECT BTO
	       SET FILTER TO BTO->cCodigoGru == GRU->cCodigoGru
	    ENDCASE
	    GO TOP
**********FIN FILTRACION DEL ARCHIVO DE ALUMNOS

**********GRABACION IMPRESION DE LOS ESTUDIANTES
	    DO WHILE .NOT. EOF()

*--------------ANALISIS DE LA CLASIFICACION
		 IF nNroCla # &cMaeAct->nMorosoEst
		    SELECT &cMaeAct
		    SKIP
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA CLASIFICACION

*--------------IMPRESION DEL REGISTRO
		 aTitulo := {&cMaeAct->cCodigoEst,;
			     &cMaeAct->cCodigoGru,;
			     &cMaeAct->cApelliEst,;
			     &cMaeAct->cNombreEst,;
			     ''}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DEL REGISTRO

	       SELECT &cMaeAct
	       SKIP

	    ENDDO
	    SET FILTER TO
**********FIN GRABACION IMPRESION DE LOS ESTUDIANTES

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: BORRADO DE TODAS LAS CLASIFICACIONES                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2000 LUN A
       Bucaramanga, Colombia	    INICIO: 12:30 PM   SEP 04/2000 LUN

OBJETIVOS:

1- Permite Borrar todas las Clasificaciones

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION DelClaMor(aParam1,aParam2,aParam3)

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
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL GetList := {}                  // Variable del Sistema
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'BORRADO DE LAS CLASIFICACIONES',22,'°')
       aTamCol := {06,06,50}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     lHayErr := .T.
	     SELECT &cMaeAct
	     DO CASE
	     CASE RECCOUNT() == 0
		  cError('NO EXISTE ESTUDIANTES GRABADOS')
	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********IMPRESION DEL INFORME PARA CADA GRUPO
	     SELECT &cMaeAct
	     GO TOP
	     DO WHILE .NOT. EOF()

*---------------ANALISIS DEL ESTUDIANTE
		  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				RTRIM(&cMaeAct->cNombreEst)
		  cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
		  @ nNroFil,aNroCol[1] SAY &cMaeAct->cCodigoEst
		  @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		  @ nNroFil,aNroCol[3] SAY cNombreTes+' '+;
			    ALLTRIM(STR(&cMaeAct->nMorosoEst,2,0))+"=>"+'0'
*---------------FIN ANALISIS DEL ESTUDIANTE

*---------------GRABACION DE LA CLASIFICACION
		  SELECT &cMaeAct
		  IF lRegLock(lSiRed,.F.)
		     REPL &cMaeAct->nMorosoEst WITH 0
		     DBCOMMIT()
		  ELSE
		     cError('NO SE GRABA LA BECA PARA EL ESTUDIANTE')
		  ENDIF
		  IF lSiRed
		     DBUNLOCK()
		  ENDIF
*---------------FIN GRABACION DE LA CLASIFICACION

*---------------AVANCE DEL SIGUIENTE GRUPO
		  SELECT &cMaeAct
		  DBSKIP()
*---------------FIN AVANCE DEL SIGUIENTE GRUPO

*---------------INCREMENTO DE LAS FILAS
		  nNroFil++
		  IF nNroFil > 19

*....................IMPRESION DEL ULTIMO REGISITRO
		       nNroFil := nMarco(nFilPal+1,'BORRADO DE LAS '+;
						   'CLASIFICACIONES',22,'°')
		       @ nNroFil,nNroCol SAY cMsgTxt
		       nNroFil++
*....................FIN IMPRESION DEL ULTIMO REGISITRO

		  ENDIF
*---------------FIN INCREMENTO DE LAS FILAS

	     ENDDO
***********FIN IMPRESION DEL INFORME PARA CADA GRUPO

       ENDFOR
       RETURN NIL
*>>>>FIN ANALISIS PARA CADA NIVEL

