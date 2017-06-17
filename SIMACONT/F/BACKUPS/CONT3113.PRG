/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : LISTADOS
SUBMODULO...: LISTAS PROVISIONALES                     MODULO No. 312

**************************************************************************
* TITULO..: LISTAS DE CLASE POR GRUPO SOLO NOMBRES                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2007 LUN A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   ABR 23/2007 LUN

OBJETIVOS:

1- Permite imprimir las listas de clase por grupos con solo los nombres

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_3113(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL PathNot := ''                  // Path de Notas
       LOCAL nNroPer := 0                   // N£mero del peri¢do
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL nTipBol := 0                   // Tipo de Boletin
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL lProfes := .F.                 // .T. Si SimaProf

       STATIC nNroArc

       LOCAL GetList := {}                  // Variable del Sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
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

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := GRU->cCodigoGru+'list'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.,2)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********INICIALIZACION DEL PATH DE NOTAS
	    cCodGru := GRU->cCodigoGru
	    PathNot := cPatSis+'\'+cMaeAct+'\NOTAS\'
	    FileNot := 'NT'+cCodGru+cAnoSis+ExtFile
**********FIN INICIALIZACION DEL PATH DE NOTAS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathNot+FileNot,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS')

	       IF lPregunta('DESEA CONTINUAR? Si No')
		  EXIT
	       ENDIF

	       CloseAll()
	       RETURN NIL

	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LISTA
	    ListaNot(lShared,cNomEmp,cNomSis,cAnoUsr,nNroPer,;
		     GRU->cCodigoGru,cMaeAct,cJorTxt,FilePrn,;
		     nOpcPrn,@nNroArc)
**********FIN IMPRESION DE LA LISTA

	  CloseDbf('NOT')
	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nNroArc)
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: LA LISTA DEL ARCHIVO NOTAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2007 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   ABR 23/2007 LUN

OBJETIVOS:

1- Imprime una lista de clase para el grupo determinado

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListaNot(lShared,cNomEmp,cNomSis,cAnoUsr,nNroPer,;
		  cCodGru,cMaeAct,cJorTxt,FilePrn,nOpcPrn,;
		  nHanXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del grupo
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n
       nHanXml                              // Manejador del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales


       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'GRUPO: '+cCodGru+' PERIODO No. '+STR(nNroPer,1),;
		   'LISTA DE CLASE',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,4)
       AADD(aTitPrn,'No.')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'APELLIDOS Y NOMBRES')

       AADD(aNroCol,22)
       AADD(aTitPrn,'OBSERVACION')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
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
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOT->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(60),1,60)
	    lRetiroTno := NOT->lRetGruNot
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    AADD(aRegPrn,STR(NOT->(RECNO()),2))
	    AADD(aRegPrn,NOT->cCodigoEst)
	    AADD(aRegPrn,cNombreTes)

	    DO CASE
	    CASE lRetiroTes
		 AADD(aRegPrn,'RETIRADO')

	    CASE lRetiroTno
		 AADD(aRegPrn,'PERTENECE A OTRO GRUPO')

	    CASE !lRetiroTes .AND. !lRetiroTno
		 AADD(aRegPrn,' ')
	    ENDCASE
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

	  NOT->(DBSKIP())

       ENDDO

       EVAL(bDerAut)
      *Impresi¢n de Derechos

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       EJECT

       SET DEVICE TO SCREEN
*       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME
