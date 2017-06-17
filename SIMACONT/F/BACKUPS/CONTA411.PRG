/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR ESTUDIANTE                            MODULO No. 401

**************************************************************************
* TITULO..: ESTADISTICAS POR ESTUDIANTE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 16/2002 MAR A
       Colombia, Bucaramanga        INICIO: 03:45 PM   JUL 16/2002 MAR


OBJETIVOS:

1- Imprime las estad¡sticas por estudiante.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_411(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                 // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nNroPer := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lPorcen := .F.                 // .T. Imprimir Porcentajes
       LOCAL lStdAcu := .T.                 // .T. Estadisticas Acumuladas
       LOCAL lOrdena := .F.                 // .T. Ordenar el informe
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lPrnNum := .F.                 // .T. Imprimir las notas n£mericas.

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       cGruIni := GRU->cCodigoGru

       IF CON->lPrnArcCon
	  SET PRINTER TO &(PathPrn+'\'+cGruIni+cGruFin+'.401')
       ENDIF
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       lPrnNum := .F.
       IF lNotNum
	  lPrnNum := lPregunta('DESEA IMPRIMIR LAS NOTAS NUMERICAS? No Si')
       ENDIF

       lPorcen := .F.
       lStdAcu := .F.
       IF !lPrnNum
	  lPorcen := lPregunta('DESEA IMPRIMIR LOS TOTALES COMO PORCENTAJES? No Si')
	  lStdAcu := lPregunta('DESEA IMPRIMIR LOS INDICADORES ACUMULADOS? Si No')
       ENDIF

       lOrdena := lPregunta('DESEA ORDENAR EL INFORME? Si No')
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  IF nRegIni == nRegFin
	     FilePrn := STR(nNroPer,1)+'stM'+GRU->cCodigoGru
	  ELSE
	     FilePrn := STR(nNroPer,1)+'stM'+cMaeAct
	  ENDIF
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.,2,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","ProporOf","CondenOn"})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LAS ESTADISTICAS
	    cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)

	    DO CASE
	    CASE cJvfCal == '103'  // Indice de Cumplimiento. Variable

		 EstaEst01(lShared,cNomEmp,cCodEmp,cNomSis,cAnoUsr,cNomUsr,;
			   nNroPer,cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,;
			   lPorcen,lStdAcu,lOrdena,lPrnNum,;
			   FilePrn,nOpcPrn,@nHanXml)
	    OTHERWISE
		 EstaEst00(lShared,cNomEmp,cCodEmp,cNomSis,cAnoUsr,cNomUsr,;
			   nNroPer,cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,;
			   lPorcen,lStdAcu,lOrdena,lPrnNum,;
			   FilePrn,nOpcPrn,@nHanXml)
	    ENDCASE
**********FIN IMPRESION DEL RESUMEN

**********AVANCE AL SIGUIENTE REGISTRO
	    nNroIni := 1
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: CUADRO DE RESUMEN DE LOGROS DE LOS ESTUDIANTES               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 23/2002 MAR A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUL 23/2002 MAR

OBJETIVOS:

1- Imprime las Estadisticas por Estudiante

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstaEst00(lShared,cNomEmp,cCodEmp,cNomSis,cAnoUsr,cNomUsr,;
		   nNroPer,cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,;
		   lPorcen,lStdAcu,lOrdena,lPrnNum,FilePrn,nOpcPrn,;
		   nHanXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomEmp                              // Nombre de la Empresa
       cCodEmp                              // C¢digo de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroPer				    // N£mero del bimestre
       cMaeAct                              // Maestro Actual
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cNotDef                              // Nota Definitiva de Selecci¢n
       cJorTxt                              // Jornada escogida
       cGruFin                              // Grupo Final
       lPorcen                              // .T. Imprimir Porcentajes
       lStdAcu                              // .T. Estadisticas Acumuladas
       lOrdena                              // .T. Ordenar el informe
       lPrnNum                              // .T. Imprimir las notas n£mericas.
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n
       nHanXml                              // Manejador del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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
       LOCAL aTitReg := {}                  // Registros para los T¡tulos
     *ÀVariables de informe

       LOCAL i,j,k,y,x := 0                 // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aStdJui := {}                  // Estadisticas de Juicios Valorativos
       LOCAL aStdMat := {}                  // Estadisticas de las Materias
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos
       LOCAL nNroLen := 0                   // N£mero de longitud

       LOCAL aTotNot := {}                  // Total de Notas
       LOCAL aNroEst := {}                  // N£mero de Estudiantes
       LOCAL nTotNot := 0                   // Total de Notas
       LOCAL nNroMat := 0                   // N£mero de Materias
       LOCAL nProEst := 0                   // Promedio del Estudiante
       LOCAL nProMat := 0                   // Promedio de la Materia
       LOCAL nProGru := 0                   // Promedio del Grupo
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'PERIODO No.'+STR(nNroPer,2),;
		   'ESTADISTICAS DE ASIGNATURAS POR ESTUDIANTES',;
		   IF(lStdAcu,'INDICADORES ACUMULADOS.','')+;
		   'GRUPO: '+GRU->cCodigoGru}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,NIL,lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO


*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}
       aStdJui := {}

       AADD(aNroCol,4)
       AADD(aTitPrn,'No.')
       AADD(aStdJui,'')

       AADD(aNroCol,30)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')
       AADD(aStdJui,'')

       FOR i:=1 TO LEN(aNotAre)

**********ANALISIS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	       AADD(aNroCol,4)
	       AADD(aTitPrn,SUBS(aNotAre[i,7],1,4))
	       AADD(aStdJui,0)
	    ENDIF
**********FIN ANALISIS DEL AREA

**********ANALISIS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*=================ANALISIS DE LA MATERIA NO IMPRIMIR
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
		       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
		       LOOP
		    ENDIF
*=================FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*=================ANALISIS DE DECISION
		    IF cCodEmp == 'COLSAN001001' // Colegio La Salle. Bucaramanaga
		       IF SUBS(cCodigoTma,3,2) == '00'
			  LOOP
		       ENDIF
		     *ÀDescarta la area promediables
		    ENDIF
*=================FIN ANALISIS DE DECISION

		  AADD(aNroCol,4)
		  AADD(aTitPrn,SUBS(aNotMat[j,7],1,4))
		  AADD(aStdJui,0)

	       ENDIF
	    ENDFOR
**********FIN ANALISIS DE LA MATERIA

       ENDFOR

       IF lPrnNum
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'PROM')
       ELSE
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'TDIF')
       ENDIF

       IF TCO->nTotPerTbl == nNroPer
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'APR.')
       ENDIF
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)

       cCabCol := cRegPrint(aTitPrn,@aNroCol)
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
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       lHayItv := lHayItvJvf()
       lNotNum := IF(lNotNum,lNotNum,lHayItv)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LECTURA DE LOS JUICIOS VALORATIVOS
       aStdMat := {}

       IF !lPrnNum

	  SELECT JVF
	  JVF->(DBGOTOP())
	  DO WHILE .NOT. JVF->(EOF())
	     aStdJui[1] := JVF->cCodigoJvf
	     aStdJui[2] := JVF->cNombreJvf
	     AADD(aStdMat,ACLONE(aStdJui))
	     JVF->(DBSKIP())
	  ENDDO
	  aStdJui[1] := ''
	  aStdJui[2] := 'SIN JUICIO'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

	  aStdJui[1] := '?'
	  aStdJui[2] := 'OTRO'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

       ELSE

	  aStdJui[1] := ''
	  aStdJui[2] := 'PROMEDIO'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

	  aStdJui[1] := ''
	  aStdJui[2] := 'TOTALES'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

       ENDIF
*>>>>FIN LECTURA DE LOS JUICIOS VALORATIVOS

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroPer,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)

	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DEL REGISTRO
	    y := 0
	    nTotDif := 0
	    aTitReg := {}
	    AADD(aTitReg,STR(NOT->(RECNO()),2)+IF(lRetiroTes,' R',''))
	    AADD(aTitReg,cNombreTes)

	    nTotNot := 0
	    nNroMat := 0

	    FOR i:=1 TO LEN(aNotAre)

*--------------ESTADISTICA DE LOS INDICADORES DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*...................NOTA DEFINITIVA DEL AREA
		      cCamNotDef := aNotAre[i,4]
			 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			 IF lPrnNum
			    IF VAL(cNotDef) > 0
			       nTotNot += VAL(cNotDef)
			       nNroMat++
			    ENDIF
			 ELSE
			    cNotDef := cNotDef(cNotDef,lNotNum)
			 ENDIF
*...................FIN NOTA DEFINITIVA DEL AREA

*...................NOTA DE LA RECUPERACION DEL AREA
		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			 IF !lPrnNum
			    cNotRec := cNotDef(cNotRec,lNotNum)
			 ENDIF
*...................FIN NOTA DE LA RECUPERACION DEL AREA

*...................INDICADORES POR RECUPERAR DEL AREA
		      nNroDif := 0
		      cCamInd := aNotAre[i,6]
		      FOR k := IF(lStdAcu,1,nNroPer) TO nNroPer
			  cCamInd := STUFF(cCamInd,8,1,STR(k,1))
			  cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
			  cSiRecu := ''
			  cNoRecu := ''
			  IF !aNotAre[i,15]   // Recuperable
			     IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)
			  ENDIF
			  aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
			  nNroDif += LEN(aJuicio)
			  nTotDif += LEN(aJuicio)
		      ENDFOR
*...................FIN INDICADORES POR RECUPERAR DEL AREA

*...................CAMPOS DEL REGISTRO DE IMPRESION
		      IF TCO->lRecNotTbl
			 cTxtPrn := ALLTRIM(cNotDef)+LOWER(ALLTRIM(cNotRec))
		      ELSE
			 cTxtPrn := ALLTRIM(cNotDef)
		      ENDIF
		      IF !EMPTY(nNroDif) .AND. !lPrnNum
			 cTxtPrn := cTxtPrn+STR(nNroDif,2)
		      ENDIF
		      AADD(aNroCol,4)
		      AADD(aTitReg,cTxtPrn)
*...................FIN CAMPOS DEL REGISTRO DE IMPRESION

		 ENDIF
*--------------FIN ESTADISTICA DE LOS INDICADORES DEL AREA

*--------------ESTADISTICA DE LOS JUICIOS VALORATIVOS DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		    y++
		    IF !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF
		    k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
		    IF k # 0
		       aStdMat[k,y+2]++
		    ELSE
		       aStdMat[LEN(aStdMat),y+2]++
		    ENDIF
		 ENDIF
*--------------FIN ESTADISTICA DE LOS JUICIOS VALORATIVOS DEL AREA

*==============ANALISIS DE LA MATERIA
		 FOR j:=1 TO LEN(aNotMat)

*-------------------ESTADISTICA DE LOS INDICADORES DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

*........................ANALISIS DE LA MATERIA NO IMPRIMIR
			    cCodigoTma := SUBS(aNotMat[j,5],9,4)
			    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
			       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
			       LOOP
			    ENDIF
*........................FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*........................ANALISIS DE DECISION
			   IF cCodEmp == 'COLSAN001001' // Colegio La Salle. Bucaramanaga
			      IF SUBS(cCodigoTma,3,2) == '00'
				 LOOP
			      ENDIF
			    *ÀDescarta la area promediables
			   ENDIF
*........................FIN ANALISIS DE DECISION

*........................NOTA DEFINITIVA DE LA MATERIA
			   cCamNotDef := aNotMat[j,4]
			      cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)

			      IF lPrnNum
				 IF VAL(cNotDef) > 0
				    IF SUBS(cCodigoTma,3,2) == '00'
				       nTotNot += VAL(cNotDef)
				       nNroMat++
				     *ÀAreas // Modificado
				    ELSE
				     * Materias
				    ENDIF
				 ENDIF
			      ELSE
				 cNotDef := cNotDef(cNotDef,lNotNum)
			      ENDIF
*........................FIN NOTA DEFINITIVA DE LA MATERIA

*........................NOTA DE LA RECUPERACION DE LA MATERIA
			   IF TCO->nTotPerTbl == nNroPer .AND.;
			      SUBS(cCodigoTma,3,2) # '00'

			      cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
				 cNotRec := SUBS(&cCamNotRec,1,4)

			   ELSE
			      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
				 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			   ENDIF
			   IF !lPrnNum
			      cNotRec := cNotDef(cNotRec,lNotNum)
			   ENDIF
*........................FIN NOTA DE LA RECUPERACION DE LA MATERIA

*........................INDICADORES POR RECUPERAR DE LA MATERIA
			   nNroDif := 0
			   cCamInd := aNotMat[j,5]

			   FOR k := IF(lStdAcu,1,nNroPer) TO nNroPer
			      cCamInd := STUFF(cCamInd,8,1,STR(k,1))
			      cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
			      cSiRecu := ''
			      cNoRecu := ''
			      IF !aNotMat[j,15]  // No Recuperable
				 IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)
			      ENDIF
			      aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
			      nNroDif += LEN(aJuicio)
			      nTotDif += LEN(aJuicio)
			   ENDFOR
*........................FIN INDICADORES POR RECUPERAR DE LA MATERIA

*........................CAMPOS DEL REGISTRO DE IMPRESION
			   IF TCO->lRecNotTbl
			      cTxtPrn := ALLTRIM(cNotDef)+LOWER(ALLTRIM(cNotRec))
			   ELSE
			      cTxtPrn := ALLTRIM(cNotDef)
			   ENDIF

			   IF !EMPTY(nNroDif) .AND. !lPrnNum
			      cTxtPrn := cTxtPrn+STR(nNroDif,2)
			   ENDIF

			   AADD(aNroCol,4)
			   AADD(aTitReg,cTxtPrn)
*........................FIN CAMPOS DEL REGISTRO DE IMPRESION

		      ENDIF
*-------------------FIN ESTADISTICA DE LOS INDICADORES DE LA MATERIA

*-------------------ESTADISISTICA DE LOS JUICIOS VALORATIVOS DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

			 y++
			 IF !EMPTY(cNotRec)
			    cNotDef := cNotRec
			 ENDIF

			 IF lPrnNum

			    IF VAL(cNotDef) > 0
			       aStdMat[1,y+2] += VAL(cNotDef)
			       aStdMat[LEN(aStdMat),y+2] += 1
			    ENDIF

			 ELSE

			    k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
			    IF k # 0
			       aStdMat[k,y+2]++
			    ELSE
			       aStdMat[LEN(aStdMat),y+2]++
			    ENDIF

			 ENDIF
		      ENDIF
*-------------------FIN ESTADISISTICA DE LOS JUICIOS VALORATIVOS DE LA MATERIA

		 ENDFOR
*==============FIN ANALISIS DE LA MATERIA

	    ENDFOR
**********IMPRESION DEL REGISTRO

**********PROMEDIO DEL ESTUDIANTE
	    IF lPrnNum

	       nProEst := nTotNot/nNroMat
*	       AADD(aTitReg,STR(nProEst,4,1))
	       AADD(aTitReg,SUBS(NOT->cProMedNot,nNroPer*4-3,4)) // Corregido para ColSalle

	    ELSE
	       AADD(aTitReg,STR(nTotDif,4))
	    ENDIF

	    IF TCO->nTotPerTbl == nNroPer
	       AADD(aTitReg,STR(NOT->nAproboNot,2))
	    ENDIF

	    AADD(aRegPrn,aTitReg)
**********FIN PROMEDIO DEL ESTUDIANTE

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DEL INFORME ORDENADO
       nNroLen := LEN(aRegPrn[1])
       IF lOrdena
	  IF lPrnNum
	     aRegPrn := ASORT(aRegPrn,,,{|x,y|x[nNroLen] > y[nNroLen]})
	  ELSE
	     aRegPrn := ASORT(aRegPrn,,,{|x,y|x[nNroLen] < y[nNroLen]})
	  ENDIF
       ENDIF

       FOR i := 1 TO LEN(aRegPrn)
	   aTitReg := {}
	   FOR j := 1 TO LEN(aRegPrn[i])
	       AADD(aTitReg,aRegPrn[i,j])
	   ENDFOR

	   cTxtPrn := cRegPrint(aTitReg,aNroCol)
	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aTitReg,aNroCol,bPagina,bDerAut,;
		   bCabeza)

       ENDFOR
*>>>>FIN IMPRESION DEL INFORME ORDENADO

/*

wait 'ojo'

SET DEVICE TO SCREEN
FOR i := 1 TO LEN(aRegPrn)
wait aRegPrn[i,1]
wait aRegPrn[i,LEN(aRegPrn[i])]
ENDFOR
SET DEVICE TO PRINT
*/

*>>>>IMPRESION DE LAS ESTADISTICAS TOTALES
       IF lPrnNum

	  aTitPrn[1] := ''
	  aTitPrn[2] := 'TOTALES'

	  cTxtPrn := cRegPrint(aTitPrn,aNroCol)
	  lPrnReg(02,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  aTotNot := ACLONE(aStdMat[1])
	  aNroEst := ACLONE(aStdMat[2])

	  nTotNot := 0
	  nNroMat := 0
	  FOR k := 3 TO LEN(aTotNot)

	      IF aNroEst[k] > 0

		    nProMat := aTotNot[k]/aNroEst[k]
		 aTotNot[k] := STR(nProMat,4,1)

		 IF SUBS(aTitPrn[k],1,2) == 'A.'
		    nTotNot += nProMat
		    IF nProMat > 0
		       nNroMat++
		    ENDIF
		 ENDIF

	      ELSE
		 aTotNot[k] := ''
	      ENDIF

	  ENDFOR

	  nProGru := nTotNot/nNroMat

	  AADD(aTotNot,STR(nProGru,4,1))

	  cTxtPrn := cRegPrint(aTotNot,aNroCol)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

       ELSE

	  aTitPrn[1] := 'JUI'
	  aTitPrn[2] := 'JUICIOS VALORATIVOS'
	  cTxtPrn := cRegPrint(aTitPrn,aNroCol)
	  lPrnReg(02,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	  FOR k := 1 TO LEN(aStdMat)
	      aStdJui := ACLONE(aStdMat[k])
	      FOR y := 3 TO LEN(aStdJui)
		  NOT->(RECCOUNT())
		  IF lPorcen
		     aStdJui[y] := STR((aStdJui[y]*100)/NOT->(RECCOUNT()),3)+'%'
		  ELSE
		     aStdJui[y] := STR(aStdJui[y],4)
		  ENDIF
	      ENDFOR
	      cTxtPrn := cRegPrint(aStdJui,aNroCol)
	      lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	  ENDFOR

       ENDIF
       CloseDbf('NOT')
*>>>>FIN IMPRESION DE LAS ESTADISTICAS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: CUADRO DE RESUMEN DE LOGROS INDICE DE CUMPLIENTO.            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/2009 LUN A
       Colombia, Bucaramanga        INICIO: 01:15 PM   MAY 18/2009 LUN

OBJETIVOS:

1- Imprime las Estadisticas por Estudiante

2- Calcula el ¡ndice de cumpliemto variable actualizadon teniendo en cuenta
   las recuperaciones.

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstaEst01(lShared,cNomEmp,cCodEmp,cNomSis,cAnoUsr,cNomUsr,;
		   nNroPer,cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,;
		   lPorcen,lStdAcu,lOrdena,lPrnNum,FilePrn,nOpcPrn,;
		   nHanXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomEmp                              // Nombre de la Empresa
       cCodEmp                              // C¢digo de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroPer				    // N£mero del bimestre
       cMaeAct                              // Maestro Actual
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cNotDef                              // Nota Definitiva de Selecci¢n
       cJorTxt                              // Jornada escogida
       cGruFin                              // Grupo Final
       lPorcen                              // .T. Imprimir Porcentajes
       lStdAcu                              // .T. Estadisticas Acumuladas
       lOrdena                              // .T. Ordenar el informe
       lPrnNum                              // .T. Imprimir las notas n£mericas.
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n
       nHanXml                              // Manejador del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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
       LOCAL aTitReg := {}                  // Registros para los T¡tulos
     *ÀVariables de informe

       LOCAL i,j,k,y,x := 0                 // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aStdJui := {}                  // Estadisticas de Juicios Valorativos
       LOCAL aStdMat := {}                  // Estadisticas de las Materias
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos
       LOCAL nNroLen := 0                   // N£mero de longitud

       LOCAL aTotNot := {}                  // Total de Notas
       LOCAL aNroEst := {}                  // N£mero de Estudiantes
       LOCAL nTotNot := 0                   // Total de Notas
       LOCAL nNroMat := 0                   // N£mero de Materias
       LOCAL nProEst := 0                   // Promedio del Estudiante
       LOCAL nProMat := 0                   // Promedio de la Materia
       LOCAL nProGru := 0                   // Promedio del Grupo

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
       LOCAL cIndic1 := ''                  // Indicadores del Periodo No.1
       LOCAL cIndic2 := ''                  // Indicadores del Periodo No.2
       LOCAL cIndic3 := ''                  // Indicadores del Periodo No.3
       LOCAL cIndic4 := ''                  // Indicadores del Periodo No.4
       LOCAL cIndic5 := ''                  // Indicadores del Periodo No.5
       LOCAL nIndice := 0                   // Indice de Cumplimiento
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL lJvfCalTma := .F.              // .F. Calcula el Juicio Valorativo .T. No Calcula el Juicio Valorativo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'PERIODO No.'+STR(nNroPer,2),;
		   'ESTADISTICAS DE INDICES DE CUMPLIMIENTO',;
		   IF(lStdAcu,'INDICADORES ACUMULADOS.','')+;
		   'GRUPO: '+GRU->cCodigoGru}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,NIL,lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}
       aStdJui := {}

       AADD(aNroCol,4)
       AADD(aTitPrn,'No.')
       AADD(aStdJui,'')

       AADD(aNroCol,30)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')
       AADD(aStdJui,'')

       FOR i:=1 TO LEN(aNotAre)

**********ANALISIS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	       AADD(aNroCol,4)
	       AADD(aTitPrn,SUBS(aNotAre[i,7],1,4))
	       AADD(aStdJui,0)
	    ENDIF
**********FIN ANALISIS DEL AREA

**********ANALISIS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*=================ANALISIS DE LA MATERIA NO IMPRIMIR
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
		       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
		       LOOP
		    ENDIF
*=================FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*=================ANALISIS DE DECISION
		    IF cCodEmp == 'COLSAN001001' // Colegio La Salle. Bucaramanaga
		       IF SUBS(cCodigoTma,3,2) == '00'
			  LOOP
		       ENDIF
		     *ÀDescarta la area promediables
		    ENDIF
*=================FIN ANALISIS DE DECISION

		  AADD(aNroCol,4)
		  AADD(aTitPrn,SUBS(aNotMat[j,7],1,4))
		  AADD(aStdJui,0)

	       ENDIF
	    ENDFOR
**********FIN ANALISIS DE LA MATERIA

       ENDFOR

       IF lPrnNum
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'PROM')
       ELSE
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'TDIF')
       ENDIF

       IF TCO->nTotPerTbl == nNroPer
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'APR.')
       ENDIF
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)

       cCabCol := cRegPrint(aTitPrn,@aNroCol)
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
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       lHayItv := lHayItvJvf()
       lNotNum := IF(lNotNum,lNotNum,lHayItv)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LECTURA DE LOS JUICIOS VALORATIVOS
       aStdMat := {}

       IF !lPrnNum

	  SELECT JVF
	  JVF->(DBGOTOP())
	  DO WHILE .NOT. JVF->(EOF())
	     aStdJui[1] := JVF->cCodigoJvf
	     aStdJui[2] := JVF->cNombreJvf
	     AADD(aStdMat,ACLONE(aStdJui))
	     JVF->(DBSKIP())
	  ENDDO
	  aStdJui[1] := ''
	  aStdJui[2] := 'SIN JUICIO'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

	  aStdJui[1] := '?'
	  aStdJui[2] := 'OTRO'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

       ELSE

	  aStdJui[1] := ''
	  aStdJui[2] := 'PROMEDIO'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

	  aStdJui[1] := ''
	  aStdJui[2] := 'TOTALES'
	  aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
	  AADD(aStdMat,ACLONE(aStdJui))

       ENDIF
*>>>>FIN LECTURA DE LOS JUICIOS VALORATIVOS

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroPer,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)

	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DEL REGISTRO
	    y := 0
	    nTotDif := 0
	    aTitReg := {}
	    AADD(aTitReg,STR(NOT->(RECNO()),2)+IF(lRetiroTes,' R',''))
	    AADD(aTitReg,cNombreTes)

	    nTotNot := 0
	    nNroMat := 0

	    FOR i:=1 TO LEN(aNotAre)

*--------------ESTADISTICA DE LOS INDICADORES DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*...................CALCULO DE LA NOTA
		      lJvfCalTma := !aNotAre[i,19]
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)
		      cCamNotDef := aNotAre[i,4]

		      IF lJvfCalTma

			 cIndic1 := &('NOT->cJ1'+cCodigoTma+'Not')
			 cIndic2 := &('NOT->cJ2'+cCodigoTma+'Not')
			 cIndic3 := &('NOT->cJ3'+cCodigoTma+'Not')
			 cIndic4 := &('NOT->cJ4'+cCodigoTma+'Not')
			 cIndic5 := &('NOT->cJ5'+cCodigoTma+'Not')

			 cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)
			 DO CASE
			 CASE cJvfCal == '103'  // Indice de Cumplimiento. Variable

			      cNotDef := cJvfCal103(cIndic1,;
						    cIndic2,;
						    cIndic3,;
						    cIndic4,;
						    cIndic5,;
						    nNroPer,nNroPer,;
						    @nIndice,cCodigoTma)+SPACE(03)

			 ENDCASE


		      ELSE
			  cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		      ENDIF
*...................FIN CALCULO DE LA NOTA

*...................NOTA DEFINITIVA DEL AREA
		      IF lPrnNum
			 IF VAL(cNotDef) > 0
			    nTotNot += VAL(cNotDef)
			    nNroMat++
			 ENDIF
		      ELSE
			 cNotDef := cNotDef(cNotDef,lNotNum)
		      ENDIF
*...................FIN NOTA DEFINITIVA DEL AREA

*...................NOTA DE LA RECUPERACION DEL AREA
		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			 IF !lPrnNum
			    cNotRec := cNotDef(cNotRec,lNotNum)
			 ENDIF
*...................FIN NOTA DE LA RECUPERACION DEL AREA

*...................INDICADORES POR RECUPERAR DEL AREA
		      nNroDif := 0
		      cCamInd := aNotAre[i,6]
		      FOR k := IF(lStdAcu,1,nNroPer) TO nNroPer
			  cCamInd := STUFF(cCamInd,8,1,STR(k,1))
			  cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
			  cSiRecu := ''
			  cNoRecu := ''
			  IF !aNotAre[i,15]   // Recuperable
			     IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)
			  ENDIF
			  aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
			  nNroDif += LEN(aJuicio)
			  nTotDif += LEN(aJuicio)
		      ENDFOR
*...................FIN INDICADORES POR RECUPERAR DEL AREA

*...................CAMPOS DEL REGISTRO DE IMPRESION
		      IF TCO->lRecNotTbl
			 cTxtPrn := ALLTRIM(cNotDef)+LOWER(ALLTRIM(cNotRec))
		      ELSE
			 cTxtPrn := ALLTRIM(cNotDef)
		      ENDIF
		      IF !EMPTY(nNroDif) .AND. !lPrnNum
			 cTxtPrn := cTxtPrn+STR(nNroDif,2)
		      ENDIF
		      AADD(aNroCol,4)
		      AADD(aTitReg,cTxtPrn)
*...................FIN CAMPOS DEL REGISTRO DE IMPRESION

		 ENDIF
*--------------FIN ESTADISTICA DE LOS INDICADORES DEL AREA

*--------------ESTADISTICA DE LOS JUICIOS VALORATIVOS DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		    y++
		    IF !EMPTY(cNotRec)
*		       cNotDef := cNotRec
		    ENDIF
		    k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
		    IF k # 0
		       aStdMat[k,y+2]++
		    ELSE
		       aStdMat[LEN(aStdMat),y+2]++
		    ENDIF
		 ENDIF
*--------------FIN ESTADISTICA DE LOS JUICIOS VALORATIVOS DEL AREA

*==============ANALISIS DE LA MATERIA
		 FOR j:=1 TO LEN(aNotMat)

*-------------------ESTADISTICA DE LOS INDICADORES DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

*........................ANALISIS DE LA MATERIA NO IMPRIMIR
			    cCodigoTma := SUBS(aNotMat[j,5],9,4)
			    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
			       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
			       LOOP
			    ENDIF
*........................FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*........................ANALISIS DE DECISION
			   IF cCodEmp == 'COLSAN001001' // Colegio La Salle. Bucaramanaga
			      IF SUBS(cCodigoTma,3,2) == '00'
				 LOOP
			      ENDIF
			    *ÀDescarta la area promediables
			   ENDIF
*........................FIN ANALISIS DE DECISION

*........................CALCULO DE LA NOTA
			   lJvfCalTma := !aNotMat[j,19]
			   cCamNotDef := aNotMat[j,4]

			   IF lJvfCalTma

			      cIndic1 := &('NOT->cJ1'+cCodigoTma+'Not')
			      cIndic2 := &('NOT->cJ2'+cCodigoTma+'Not')
			      cIndic3 := &('NOT->cJ3'+cCodigoTma+'Not')
			      cIndic4 := &('NOT->cJ4'+cCodigoTma+'Not')
			      cIndic5 := &('NOT->cJ5'+cCodigoTma+'Not')

			      cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)
			      DO CASE
			      CASE cJvfCal == '103'  // Indice de Cumplimiento. Variable

				   cNotDef := cJvfCal103(cIndic1,;
							 cIndic2,;
							 cIndic3,;
							 cIndic4,;
							 cIndic5,;
							 nNroPer,nNroPer,;
							 @nIndice,cCodigoTma)+SPACE(03)

			      ENDCASE

			   ELSE
			       cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			   ENDIF
*........................FIN CALCULO DE LA NOTA

*........................NOTA DEFINITIVA DE LA MATERIA
			   IF lPrnNum
			      IF VAL(cNotDef) > 0
				 nTotNot += VAL(cNotDef)
				 nNroMat++
			      ENDIF
			   ELSE
			      cNotDef := cNotDef(cNotDef,lNotNum)
			   ENDIF
*........................FIN NOTA DEFINITIVA DE LA MATERIA

*........................NOTA DE LA RECUPERACION DE LA MATERIA
			   IF TCO->nTotPerTbl == nNroPer .AND.;
			      SUBS(cCodigoTma,3,2) # '00'

			      cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
				 cNotRec := SUBS(&cCamNotRec,1,4)

			   ELSE
			      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
				 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			   ENDIF
			   IF !lPrnNum
			      cNotRec := cNotDef(cNotRec,lNotNum)
			   ENDIF
*........................FIN NOTA DE LA RECUPERACION DE LA MATERIA

*........................INDICADORES POR RECUPERAR DE LA MATERIA
			   nNroDif := 0
			   cCamInd := aNotMat[j,5]

			   FOR k := IF(lStdAcu,1,nNroPer) TO nNroPer
			      cCamInd := STUFF(cCamInd,8,1,STR(k,1))
			      cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
			      cSiRecu := ''
			      cNoRecu := ''
			      IF !aNotMat[j,15]  // No Recuperable
				 IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)
			      ENDIF

			      aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
			      nNroDif += LEN(aJuicio)
			      nTotDif += LEN(aJuicio)
			   ENDFOR
*........................FIN INDICADORES POR RECUPERAR DE LA MATERIA

*........................CAMPOS DEL REGISTRO DE IMPRESION
			   IF TCO->lRecNotTbl
			      cTxtPrn := ALLTRIM(cNotDef)+LOWER(ALLTRIM(cNotRec))
			   ELSE
			      cTxtPrn := ALLTRIM(cNotDef)
			   ENDIF

			   IF !EMPTY(nNroDif) .AND. !lPrnNum
			      cTxtPrn := cTxtPrn+STR(nNroDif,2)
			   ENDIF

			   AADD(aNroCol,4)
			   AADD(aTitReg,cTxtPrn)
*........................FIN CAMPOS DEL REGISTRO DE IMPRESION

		      ENDIF
*-------------------FIN ESTADISTICA DE LOS INDICADORES DE LA MATERIA

*-------------------ESTADISISTICA DE LOS JUICIOS VALORATIVOS DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

			 y++
			 IF !EMPTY(cNotRec)
*			    cNotDef := cNotRec
			 ENDIF

			 IF lPrnNum

			    IF VAL(cNotDef) > 0
			       aStdMat[1,y+2] += VAL(cNotDef)
			       aStdMat[LEN(aStdMat),y+2] += 1
			    ENDIF

			 ELSE

			    k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})

			    IF k # 0
			       aStdMat[k,y+2]++
			    ELSE
			       aStdMat[LEN(aStdMat),y+2]++
			    ENDIF

			 ENDIF
		      ENDIF
*-------------------FIN ESTADISISTICA DE LOS JUICIOS VALORATIVOS DE LA MATERIA

		 ENDFOR
*==============FIN ANALISIS DE LA MATERIA

	    ENDFOR

	    IF lPrnNum
	       nProEst := nTotNot/nNroMat
	       AADD(aTitReg,STR(nProEst,4,1))
	    ELSE
	       AADD(aTitReg,STR(nTotDif,4))
	    ENDIF

	    IF TCO->nTotPerTbl == nNroPer
	       AADD(aTitReg,STR(NOT->nAproboNot,2))
	    ENDIF

/*
	    cTxtPrn := cRegPrint(aTitReg,aNroCol)
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aTitReg,aNroCol,bPagina,bDerAut,;
		    bCabeza)
*/
**********IMPRESION DEL REGISTRO

AADD(aRegPrn,aTitReg)

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DEL INFORME ORDENADO
       nNroLen := LEN(aRegPrn[1])
       IF lOrdena
	  IF lPrnNum
	     aRegPrn := ASORT(aRegPrn,,,{|x,y|x[nNroLen] > y[nNroLen]})
	  ELSE
	     aRegPrn := ASORT(aRegPrn,,,{|x,y|x[nNroLen] < y[nNroLen]})
	  ENDIF
       ENDIF

       FOR i := 1 TO LEN(aRegPrn)
	   aTitReg := {}
	   FOR j := 1 TO LEN(aRegPrn[i])
	       AADD(aTitReg,aRegPrn[i,j])
	   ENDFOR

	   cTxtPrn := cRegPrint(aTitReg,aNroCol)
	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aTitReg,aNroCol,bPagina,bDerAut,;
		   bCabeza)

       ENDFOR
*>>>>FIN IMPRESION DEL INFORME ORDENADO

/*

SET DEVICE TO SCREEN
FOR i := 1 TO LEN(aRegPrn)
wait aRegPrn[i,1]
wait aRegPrn[i,LEN(aRegPrn[i])]
ENDFOR
SET DEVICE TO PRINT
*/

*>>>>IMPRESION DE LAS ESTADISTICAS TOTALES
       IF lPrnNum


	  aTitPrn[1] := ''
	  aTitPrn[2] := 'TOTALES'

	  cTxtPrn := cRegPrint(aTitPrn,aNroCol)
	  lPrnReg(02,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  aTotNot := ACLONE(aStdMat[1])
	  aNroEst := ACLONE(aStdMat[2])

	  nTotNot := 0
	  nNroMat := 0
	  FOR k := 3 TO LEN(aTotNot)

	      IF aNroEst[k] > 0

		    nProMat := aTotNot[k]/aNroEst[k]
		 aTotNot[k] := STR(nProEst,4,1)

		    nTotNot += nProMat
		    nNroMat++

	      ELSE
		 aTotNot[k] := ''
	      ENDIF

	  ENDFOR

	  nProGru := nTotNot/nNroMat
	  AADD(aTotNot,STR(nProGru,4,1))

	  cTxtPrn := cRegPrint(aTotNot,aNroCol)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

       ELSE

	  aTitPrn[1] := 'JUI'
	  aTitPrn[2] := 'JUICIOS VALORATIVOS'
	  cTxtPrn := cRegPrint(aTitPrn,aNroCol)
	  lPrnReg(02,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	  FOR k := 1 TO LEN(aStdMat)
	      aStdJui := ACLONE(aStdMat[k])
	      FOR y := 3 TO LEN(aStdJui)
		  NOT->(RECCOUNT())
		  IF lPorcen
		     aStdJui[y] := STR((aStdJui[y]*100)/NOT->(RECCOUNT()),3)+'%'
		  ELSE
		     aStdJui[y] := STR(aStdJui[y],4)
		  ENDIF
	      ENDFOR
	      cTxtPrn := cRegPrint(aStdJui,aNroCol)
	      lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	  ENDFOR

       ENDIF
       CloseDbf('NOT')
*>>>>FIN IMPRESION DE LAS ESTADISTICAS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS