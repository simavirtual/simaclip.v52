/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR ESTUDIANTE

**************************************************************************
* TITULO..: MENU ESTADITICAS POR ESTUDIANTE                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2002 MAR A
       Colombia, Bucaramanga        INICIO: 12:30 PM   NOV 19/2002 MAR


OBJETIVOS:

1- Visualiza el men£ de las estad¡sticas por estudiantes.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_401(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<JUICIOS VALORATIVOS   >')
       AADD(aMenus,'2<INDICADORES PENDIENTES>')
       AADD(aMenus,'3<CUADRO EXCELENCIAS    >')
       AADD(aMenus,'4<POR INDICADORES       >')
       AADD(aMenus,'5<ASIGNATURAS I o D     >')
       AADD(aMenus,'6<POR AREAS             >')

       AADD(aAyuda,'Resumen de Juicios Valorativos e Indicadores')
       AADD(aAyuda,'Imprime el total de indicadores pendiente de los estudiantes')
       AADD(aAyuda,'Imprime el Total de Excelentes,SobreSalientes,Aceptables, etc')
       AADD(aAyuda,'Imprime los Estudiante con todos los Indicadores Aprobados')
       AADD(aAyuda,'Imprime las Asignaturas con Insuficiente o Deficiente')
       AADD(aAyuda,'Resumen de Juicios Valorativos por Areas')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilPal+3,nColInf+2,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Conta_411(aParam1,aParam2,aParam3)
	   *Juicios Valorativos por asignatura

       CASE nNroOpc == 2
	    Conta_412(aParam1,aParam2,aParam3)
	   *Asignturas I o D

       CASE nNroOpc == 3
	    Conta_413(aParam1,aParam2,aParam3)
	   *Cuadro de Excelencias.

       CASE nNroOpc == 4
	    Conta_414(aParam1,aParam2,aParam3)
	   *Juicios Valorativos

       CASE nNroOpc == 5
	    Conta_415(aParam1,aParam2,aParam3)
	   *Asignturas I o D

       CASE nNroOpc == 6
	    Conta_416(aParam1,aParam2,aParam3)
	   *Juicios valorativos por  reas

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: CUADRO DE EXCELENCIAS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 26/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 PM   NOV 26/2002 MAR


OBJETIVOS:

1- Imprime el total de Excelentes, SobreSalientes, Aceptables, Insuficientes,
   Deficientes por Estudiantes.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_413(aParam1,aParam2,aParam3)

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

       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
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

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

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

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRABADOS PARA '+cMaeAct)

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
	  SET PRINTER TO &(PathPrn+'\'+cGruIni+cGruFin+'.413')
       ENDIF
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'stdJvf'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.,,,PathDoc)
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
	    ExceleEst(cNomEmp,cNomSis,cAnoUsr,nNroPer,;
		      cMaeAct,cJorTxt,nNroIni,nNroFin,;
		      cGruFin)
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
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

/*************************************************************************
* TITULO..: CUADRO DE EXCELENTES POR ESTUDIANTE                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 26/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:45 PM   NOV 26/2002 MAR

OBJETIVOS:

1- Imprime la Cantidad de Excelentes, SobreSalientes,Aceptables,Insuficientes
   y Deficientes por Estudiante.

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ExceleEst(cNomEmp,cNomSis,cAnoUsr,nNroPer,cMaeAct,cJorTxt,nNroIni,;
		    nNroFin,cGruFin)


*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroPer				    // N£mero del Periodo
       cMaeAct                              // Maestro Actual
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cNotDef                              // Nota Definitiva de Selecci¢n
       cJorTxt                              // Jornada escogida
       cGruFin                              // Grupo Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL aTitReg := {}                  // Registros para los T¡tulos
       LOCAL aRegPrn := {}                  // Registros de Impresi¢n
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

       LOCAL   i,j,k := 0                   // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aJuiVal := {}                  // Juicios Valorativos
       LOCAL aFacJvF := {}                  // Factor del Juicio Valorativo
       LOCAL nPosFac := 0                   // Posici¢n del factor
       LOCAL nFacJvf := 0                   // Factor del Juicio Valorativo
       LOCAL nTotJvf := 0                   // Total juicios valorativos
       LOCAL nFacAnt := 0                   // Factor anterior para ordenamiento
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos
       LOCAL nTotPro := 0                   // Total Promedio
       LOCAL nTotEst := 0                   // Total Estudiantes
     *ÀVariables Espec¡ficas

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       aCabeza := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'PERIODO No.'+STR(nNroPer,2),;
		   'CUADRO DE EXCELENTES POR ESTUDIANTES',;
		   'GRUPO: '+GRU->cCodigoGru,;
		   nNroPag,NIL,lTamAnc}

       cCodIni := PCL({"DraftOn","CondenOn"})
       cCodFin := PCL({"DraftOn","CondenOn"})
*>>>>FIN DEFINCION DEL ENCABEZADO

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
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitulo := {}

       AADD(aNroCol,4)
       AADD(aTitulo,'No.')

       AADD(aNroCol,6)
       AADD(aTitulo,'PUESTO')

       AADD(aNroCol,6)
       AADD(aTitulo,'CODIGO')

       AADD(aNroCol,30)
       AADD(aTitulo,'NOMBRE DEL ESTUDIANTE')

       SELECT JVF
       JVF->(DBGOTOP())
       DO WHILE .NOT. JVF->(EOF())

	  AADD(aNroCol,2)
	  AADD(aTitulo,JVF->cCodigoJvf)

	  SELECT JVF
	  JVF->(DBSKIP())
       ENDDO
       AADD(aNroCol,2)
       AADD(aTitulo,'SN')

       AADD(aNroCol,2)
       AADD(aTitulo,'OT')

       AADD(aNroCol,6)
       IF lNotNum
	  AADD(aTitulo,'PROMED')
       ELSE
	  AADD(aTitulo,'FACTOR')
       ENDIF

       cCabCol := cRegPrint(aTitulo,@aNroCol)
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

*>>>>RECORRIDO POR ESTUDIANTE
       lHayItv := lHayItvJvf()
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

**********INICIALIZACION JUICIOS VALORATIVOS
	    aJuiVal := {}
	    SELECT JVF
	    JVF->(DBGOTOP())
	    DO WHILE .NOT. JVF->(EOF())

	       AADD(aJuiVal,{JVF->cCodigoJvf,0})

	       SELECT JVF
	       JVF->(DBSKIP())
	    ENDDO
	    AADD(aJuiVal,{'',0})   // Sin Nota
	    AADD(aJuiVal,{'OT',0})        // Otro
**********FIN INICIALIZACION JUICIOS VALORATIVOS

**********ANALISIS DE LAS MATERIAS DEL PLAN ACADEMICO
	    FOR i:=1 TO LEN(aNotAre)

*--------------ANALISIS DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*:::::::::::::::::::LECTURA DE LA NOTA
		      cCamNotDef := aNotAre[i,4]
		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		      cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		      cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		      IF lHayItv
			 cNotDef := cNotDefJvf(VAL(cNotDef))
			 cNotRec := cNotDefJvf(VAL(cNotRec))
		      ENDIF

		      IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			 cNotDef := cNotRec
		      ENDIF
*:::::::::::::::::::FIN LECTURA DE LA NOTA

*:::::::::::::::::::CONTADOR DE LA NOTA
		      k := ASCAN(aJuiVal,{|aJvf|aJvf[1] == ALLTRIM(cNotDef)})
		      IF k # 0
			 aJuiVal[k,2]++
		      ELSE
			 IF EMPTY(cNotDef)
			    aJuiVal[LEN(aJuiVal)-2,2]++  // Sin Nota
			 ELSE
			    aJuiVal[LEN(aJuiVal)-1,2]++  // Otro
			 ENDIF
		      ENDIF
*:::::::::::::::::::FIN CONTADOR DE LA NOTA

		 ENDIF
*--------------FIN ANALISIS DEL AREA

*--------------ANALISIS DE LA MATERIA
		 FOR j:=1 TO LEN(aNotMat)

*...................ANALISIS DE LOS JUICIOS VALORATIVOS DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

*::::::::::::::::::::::::LECTURA DE LA NOTA
			   cCamNotDef := aNotMat[j,4]
			   cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			   cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
			   cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
			   IF lHayItv
			      cNotDef := cNotDefJvf(VAL(cNotDef))
			      cNotRec := cNotDefJvf(VAL(cNotRec))
			   ENDIF

			   IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			      cNotDef := cNotRec
			   ENDIF
*::::::::::::::::::::::::FIN LECTURA DE LA NOTA

*::::::::::::::::::::::::CONTADOR DE LA NOTA
			   k := ASCAN(aJuiVal,{|aJvf|aJvf[1] == ALLTRIM(cNotDef)})
			   IF k # 0
			      aJuiVal[k,2]++
			   ELSE
			      IF EMPTY(cNotDef)
				 aJuiVal[LEN(aJuiVal)-2,2]++  // Sin Nota
			      ELSE
				 aJuiVal[LEN(aJuiVal)-1,2]++  // Otro
			      ENDIF
			   ENDIF
*::::::::::::::::::::::::FIN CONTADOR DE LA NOTA

		      ENDIF
*...................FIN ANALISIS DE LOS JUICIOS VALORATIVOS DE LA MATERIA

		 ENDFOR
*--------------FIN ANALISIS DE LA MATERIA

	    ENDFOR
**********FIN ANALISIS DE LAS MATERIAS DEL PLAN ACADEMICO

**********IMPRESION DEL REGISTRO
	    aTitulo := {}
	    AADD(aTitulo,SPACE(2))   // No.

	    IF lNotNum
	       AADD(aTitulo,SUBS(NOT->cPuestoNot,nNroPer*2-1,2))
	    ELSE
	       AADD(aTitulo,SPACE(02))
	    ENDIF
	  *ÀPuesto

	    AADD(aTitulo,NOT->cCodigoEst)
	    AADD(aTitulo,cNombreTes)

	    nTotJvf := 0
	    FOR i := 1 TO LEN(aJuiVal)

		AADD(aTitulo,STR(aJuiVal[i,2],2))

		IF i < LEN(aJuiVal)-2
		   nFacJvf := nFactorJvf(aJuiVal[i,1])
		   nTotJvf += aJuiVal[i,2] * nFacJvf
		ENDIF

	    ENDFOR

	    IF lNotNum

	       AADD(aTitulo,SUBS(NOT->cProMedNot,nNroPer*4-3,4))

	       IF VAL(SUBS(NOT->cProMedNot,nNroPer*4-3,4)) # 0
		  nTotPro += VAL(SUBS(NOT->cProMedNot,nNroPer*4-3,4))
		  nTotEst++
	       ENDIF

	    ELSE
	       AADD(aTitulo,STR(nTotJvf,5,2))
	    ENDIF
	    AADD(aRegPrn,aTitulo)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>ASINGNACION DE LOS PUESTOS
       nPosFac := LEN(aRegPrn[1])
       aRegPrn := ASORT(aRegPrn,,,{|x,y|x[nPosFac]>y[nPosFac]})
       IF .NOT. lNotNum
	  j := 1
	  nFacAnt := VAL(aRegPrn[1,nPosFac])
	  FOR i := 1 TO LEN(aRegPrn)

	       nFacJvf := VAL(aRegPrn[i,nPosFac])

	       IF nFacAnt # nFacJvf
		  nFacAnt := nFacJvf
		  j++
	       ENDIF
	       aRegPrn[i,2] := STR(j,2)  // Puesto
	  ENDFOR

	  FOR i := 1 TO LEN(aRegPrn)
	      aRegPrn[i,2] := aRegPrn[i,2]+'/'+ALLTRIM(STR(j,2))
	  ENDFOR
       ENDIF
*>>>>FIN ASINGNACION DE LOS PUESTOS

*>>>>IMPRESION DE LOS REGISTROS
       FOR i := 1 TO LEN(aRegPrn)
	   aRegPrn[i,1] := STR(i,2)  // No.
	   cTxtPrn := cRegPrint(aRegPrn[i],aNroCol)
	   lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDFOR
*>>>>FIN IMPRESION DE LOS REGISTROS

*>>>>PROMEDIO DEL CURSO
       IF lNotNum
	  cTxtPrn := 'PROMEDIO DEL CURSO:'+STR(nTotPro/nTotEst,4,2)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF
*>>>>FIN PROMEDIO DEL CURSO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS