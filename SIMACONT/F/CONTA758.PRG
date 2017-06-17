/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : MANTENIMIENTOS
SUBMODULO...: PRUEBA - LECTURA DE NOTAS DE SIMACONT A SIMAPROF

**************************************************************************
* TITULO..: PRUEBAS                                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/2006 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   FEB 16/2006 JUE


OBJETIVOS:

1- Permite pasar las notas de simacont a simaprof

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_758(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LON'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior

       LOCAL nNroOpc := 0                   // N£mero de la opci¢n
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL cHorIni := ''                  // Hora Inicial

       LOCAL lSiSiga := .T.                 // .T. Seguir el proceso
       LOCAL lDisket := .F.                 // .T. Lectura por Diskette
       LOCAL lCuadre := .T.                 // .T. Hay cuadre en alumnos
       LOCAL lValNot := .F.                 // .T. Validar notas leidas
       LOCAL lValida := .F.                 // .T. Validar la lectura

       LOCAL cPatPro := ''                  // Path del Profesor
       LOCAL cNroNiv := ''                  // N£mero de nivel
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTma := ''               // C¢digo de la materia
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+FileMat,'MAT',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE LA LECTURA POR DISKETTE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)

       IF !lUseDbf(.T.,cPatSis+'\'+;
		   FilePro+cAnoSis+ExtFile,'DOC',NIL,lShared)

	  cTxtLog := 'ABRIENDO ARCHIVOS'
	  cError(cTxtLog)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE LA LECTURA POR DISKETTE

*>>>>FILTRACION DE LOS PROFESORES
       SELECT DOC
       SET FILTER TO cMaeAct $ DOC->cMaeAluPro .AND.;
		     DOC->lCargasPro .AND. !DOC->lRetiroPro
       GO TOP
       IF EOF()

	  cTxtLog := 'NO EXISTEN PROFESORES PARA '+cMaeAct
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  SET FILTER TO
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>CAPTURA DEL INTERVALO DE PROFESORES
       SELECT DOC

       IF !lIntervPro(nFilInf+1,nColInf,@nRegIni,@nRegFin,'DOC')

	  cTxtLog := 'Se Abandono el Proceso. No se realiz¢ la lectura'
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  CLOSE ALL
	  RETURN NIL
       ENDIF

       cTxtLog := 'DESEA CONTINUAR? No Si'
       IF !lPregunta(cTxtLog)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL INTERVALO DE PROFESORES

*>>>>LECTURA DE LA NOTAS DEL PROFESOR
       SELECT DOC
       cSavPan := SAVESCREEN(0,0,24,79)
       GO nRegIni
       DO WHILE IF(lDisket,.T.,DOC->(RECNO()) <= nRegFin)

**********ASIGNANCION DEL PATH DEL PROFESOR
	    cPatPro := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+DOC->cCodigoPro
**********FIN ASIGNANCION DEL PATH DEL PROFESOR

**********DETERMINACION DEL DISKETTE CORRECTO
	    IF .NOT. FILE(cPatPro+'\'+FilePro+ExtFile) .OR.;
	       .NOT. FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)

	       IF lDisket
		  cError('POR FAVOR VERIFIQUE SI ES EL DISCO DE NOTAS')
	       ELSE

		 cTxtLog := 'PARA '+ALLTRIM(DOC->cNombrePro)+;
			    ' NO APARECEN LOS ARCHIVOS DE LA CARGA ACADEMICA'
		 cError(cTxtLog)
	       *ÀRegistro del Log


*-----------------PREGUNTA DE DECISION
		    cTxtLog := 'DESEA CONTINUAR? Si No'
		    IF !lPregunta(cTxtLog)
		       EXIT
		    ENDIF
*-----------------FIN PREGUNTA DE DECISION

	       ENDIF
	       DOC->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN DETERMINACION DEL DISKETTE CORRECTO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
	       !lUseDbf(.T.,cPatPro+'\'+;
			FilePro+ExtFile,'PRO',NIL,lShared)

	       cTxtLog := 'ABRIENDO ARCHIVOS PRINCIPALES EN DISCO DE NOTAS'
	       cError(cTxtLog)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE LA CARGA DEL PROFESOR
	    lHayErr := .T.
	    DO CASE
	    CASE CAP->(RECCOUNT()) == 0
		 cTxtLog := 'NO APARECE DATOS DE CARGA ACADEMICA DE '+;
			    ALLTRIM(DOC->cNombrePro)

	    CASE PRO->(RECCOUNT()) == 0
		 cTxtLog := 'NO APARECE INFORMACION DEL PROFESOR '+;
			    ALLTRIM(DOC->cNombrePro)+' EN SU CARGA '+;
			    'ACADEMICA'

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr

	       cError(cMenTxt)

	       CloseDbf('CAP')
	       CloseDbf('PRO')

	       cTxtLog := 'DESEA CONTINUAR? Si No'
	       IF !lPregunta(cTxtLog)
		  EXIT
	       ENDIF
	       DOC->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA CARGA DEL PROFESOR

**********LECTURA DE LOS GRUPOS Y MATERIAS A GRABAR
	    SELECT CAP
	    GO TOP
	    DO WHILE .NOT. CAP->(EOF())

*--------------LECTURA DEL CODIGO DEL GRUPO Y MATERIA
		 cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
		 cCodigoTma := SUBS(CAP->cCodigoCar,1,4)

		    cNroNiv := SUBS(cCodigoTgr,1,2)
		    lSiSiga := .T.
*--------------FIN LECTURA DEL CODIGO DEL GRUPO Y MATERIA

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstados('PROFESOR: '+ALLTRIM(PRO->cApelliPro)+' '+;
			       ALLTRIM(PRO->cNombrePro)+;
			      'ºGRUPO: '+cCodigoTgr,cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------LOCALIZACION DE LA MATERIA
		 IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)

		    cMenTxt := 'LA MATERIA CODIGO: '+cCodigoTma+'NO EXISTE'
		    cError(cMenTxt)

		    cTxtLog := 'DESEA CONTINUAR? Si No'
		    IF !lPregunta(cTxtLog)
		       lSiSiga := .F.
		       EXIT
		    ENDIF
		    SELECT CAP
		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIA

*--------------LECTURA DE LAS NOTAS
		 lLeerNot(lShared,cNomSis,nFilPal,;
			  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,;
			  cMaeAct,cCodigoTgr,cCodigoTma,;
			  nNroBis,cPatPro,lValNot,lValida,;
			  aGenLog,cAliasL,lGraLog)
		 CloseDbf('PLA')
*--------------FIN LECTURA DE LAS NOTAS

	       SELECT CAP
	       SKIP

	    ENDDO
**********FIN LECTURA DE LOS GRUPOS Y MATERIAS A GRABAR

**********ANALISIS PARA CONTINUAR EL PROCESO
	    IF !lSiSiga
	       EXIT
	    ENDIF
	    CloseDbf('CAP')
	    CloseDbf('PRO')
	    IF !lDisket
	       SELECT DOC
	       DOC->(DBSKIP())
	    ENDIF
**********FIN ANALISIS PARA CONTINUAR EL PROCESO

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN LECTURA DE LA NOTAS DEL PROFESOR

/*************************************************************************
* TITULO..: LEER NOTAS CON BASE EN CONTABILIDAD                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/2006 JUE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   FEB 16/2006 JUE

OBJETIVOS:

1- Leer las notas del profesor con base en el archivo de notas de la
   contabilidad.

2- Retorna .F. si se presentaron problemas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeerNot(lShared,cNomSis,nFilPal,cNomUsr,cAnoUsr,;
		  cPatSis,cMaeAlu,cMaeAct,cCodGru,cCodMat,nNroBis,;
		  cPatPro,lValNot,lValida,aGenLog,cAliasL,lGraLog)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cCodGru                              // C¢digo del Grupo
       cCodMat                              // C¢digo de la materia
       nNroBis                              // N£mero del Periodo
       cPatPro                              // Path del Profesor
       lValNot                              // .T. Validar notas leidas
       lValida                              // .T. Validar la lectura
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log
       lGraLog                              // .T. Grabar el Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL aCamLog := {}                  // Campos del Log

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL lCuadre := .T.                 // .T. Hay cuadre en alumnos
       LOCAL lGrabar := .T.                 // .T. Grabar el registro

       LOCAL cPorcen := ''                  // Porcentaje de la materia
       LOCAL cNotDef := ''                  // Nota definitiva a grabar
       LOCAL cFallas := ''                  // Fallas a grabar
       LOCAL cJuicio := ''                  // Juicios a grabar
       LOCAL cNotInd := ''                  //*Notas del Indicador a grabar
       LOCAL cModNot := ''                  // Modificaci¢n de las Notas
       LOCAL nLenCod := 6                   // Longitud del C¢digo
       LOCAL cDefNot := ''                  // Nota

       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL cCamBimDef := ''               // Campo fuente notas parciales
       LOCAL cCamDefDef := ''               // Campo fuente nota definitiva
       LOCAL cCamJuiDef := ''               // Campo fuente Juicios
       LOCAL cCamFalDef := ''               // Campo fuente fallas

       LOCAL cCamDefNot := ''               // Campo destino notas definitiva
       LOCAL cCamJuiNot := ''               // Campo destino Juicios
       LOCAL cCamJntNot := ''               //*Campo destino notas de los Juicios
       LOCAL cCamFalNot := ''               // Campo destino fallas

       LOCAL cCamJuiNoP := ''               // Campo Juicio notas profesor
       LOCAL cCamJntNoP := ''               //*Campo notas de los Juicios de simaprof
       LOCAL cCamDefNoP := ''               // Campo Definitiva profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      'PLAN'+SUBS(cCodGru,1,2)+cAnoSis+ExtFile,;
		      'PLA',NIL,lShared)

	  cTxtLog := 'NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		      cNomNiv(SUBS(cCodGru,1,2))

	  cError(cTxtLog)
	  CloseDbf('PLA')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO
       IF !lMatPlan(lShared,CAP->nTipCarCar,cCodMat,cCodMat,;
		    cCodGru,.T.,aGenLog,cAliasL)
	  CloseDbf('PLA')
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO

*>>>>ASIGNACION DE LA MATERIA A GRABAR
       IF PLA->cTipArePla == 'N'
	  cCamDefNot := 'NOT->cAreN'+SUBS(cCodMat,1,2)+"Not"
	  cCamJuiNot := 'NOT->cJ'+STR(nNroBis,1)+cCodMat+"Not"
	  cCamJntNot := 'NOT->cN'+STR(nNroBis,1)+cCodMat+"Not"
	  cCamFalNot := 'NOT->cFa'+cCodMat+"Not"
       ELSE
	  cPorcen := IF(PLA->nPorcenPla == 0,;
			'100','0'+STR(PLA->nPorcenPla,2))
	  cCamDefNot := 'NOT->cNt'+cCodMat+cPorcen
	  cCamJuiNot := 'NOT->cJ'+STR(nNroBis,1)+cCodMat+"Not"
	  cCamJntNot := 'NOT->cN'+STR(nNroBis,1)+cCodMat+"Not"
	  cCamFalNot := 'NOT->cFa'+cCodMat+"Not"
       ENDIF

       cCamJuiNoP := 'NOP->cIndic'+STR(nNroBis,1)+'NoP'
       cCamJntNoP := 'NOP->cIndnt'+STR(nNroBis,1)+'NoP'
       cCamDefNoP := 'NOP->cDefin'+STR(nNroBis,1)+'NoP'
*>>>>FIN ASIGNACION DE LA MATERIA A GRABAR

   a := '1995.DIU'+'\'+cMaeAct+'\NOTAS\'+'NT'+cCodGru+'95'+ExtFile

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,a,'NOT',NIL,lShared)

	  cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru
	  cError(cTxtLog)

	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		   CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

	  cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL PROFESOR '+;
		     'CON CODIGO '+CAP->cCodigoCar
	  cError(cTxtLog)

	  CloseDbf('NOT')
	  CloseDbf('NOP')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LAS NOTAS
       lCuadre := .T.

       cTxtLog := 'GRABANDO LAS NOTAS DE '+ALLTRIM(CAP->cNombreMat)
       nNroFil := nMarco(nFilPal+1,cTxtLog)
       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot

	       IF lCuadre
		  SELECT NOP
		  SKIP
		 *ÀAvanza por no haber descuadre
	       ENDIF
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********ANALISIS DEL CUADRE DE LOS ALUMNOS
	    IF lCuadre

*--------------VALIDACION DEL CUADRE
		 lCuadre := .T.
		 IF NOT->cCodigoEst # NOP->cCodigoEst
		    lCuadre := .F.
		    SELECT NOT
		 ENDIF
*--------------FIN VALIDACION DEL CUADRE

*--------------INDEXACION POR DESCUADRE
		 IF !lCuadre
		    SELECT NOP
		    fNtxNot := "DEF"+cMaeAct+SUBS(cNomUsr,1,3)+'.NEL'
		    INDEX ON NOP->cCodigoEst TO &fNtxNot
		    DBSETINDEX(fNtxNot)
		 ENDIF
*--------------FIN INDEXACION POR DESCUADRE

	    ENDIF
**********FIN ANALISIS DEL CUADRE DE LOS ALUMNOS

**********BUSQUEDA DEL ALUMNO POR DESCUADRE
	    IF !lCuadre
	       IF !lLocCodigo('cCodigoEst','NOP',NOT->cCodigoEst)

		  cMenTxt := 'EL ALUMNO CODIGO:'+NOT->cCodigoEst+;
			     ' NO SE ENCUENTRA EN GRUPO '+;
			     cCodGru+' DEL PROF: '+;
			      PRO->cCodigoPro+' '+PRO->cNombrePro
		  IF lValida
		     cError(cMenTxt)
		  ENDIF

	       ENDIF
	    ENDIF
**********FIN BUSQUEDA DEL ALUMNO POR DESCUADRE

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('PROFESOR: '+ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)+;
			 'ºGRUPO: '+cCodGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			  NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DE LA NOTA DEFINITIVA
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,.F.))

	       cDefNot := &cCamDefNot
	       cNotDef := SUBS(cDefNot,nNroBis*4-3,4)
	       REPL &cCamDefNoP WITH cNotDef

	       NOP->(DBCOMMIT())

	    ELSE
	       cError('NO SE PUEDE GRABAR LAS NOTAS')
	    ENDIF

	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA NOTA DEFINITIVA

**********VISUALIZACION DEL ESTUDIANTE GRABADO
	    nNroFil++
	    @ nNroFil,01 SAY STR(NOT->(RECNO()),2)+;
			     ' '+cCodigoTes+IF(lGrabar,' si ',' no ')+;
			     ' '+SUBS(cNombreTes,1,20)+' ... '+cNotDef+;
			     ' '+SUBS(cJuicio,01,6)+;
			     ' '+SUBS(cJuicio,07,6)+;
			     ' '+SUBS(cJuicio,12,6)+;
			     ' '+SUBS(cJuicio,17,6)+;
			     ' '+cFallas
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,;
			   'GRABANDO LAS NOTAS DE '+;
			   ALLTRIM(CAP->cNombreMat))
	    ENDIF
**********FIN VISUALIZACION DEL ESTUDIANTE GRABADO

**********AVANCE AL SIGUIENTE ALUMNO
	    SELECT NOT
	    SKIP
	    IF lCuadre
	       SELECT NOP
	       SKIP
	      *ÀAvanza por no haber descuadre
	    ENDIF
**********FIN AVANCE AL SIGUIENTE ALUMNO

       ENDDO
       CloseDbf('PLA')
       CloseDbf('NOT')
       CloseDbf('NOP')
       IF !lCuadre
	 lFileDelete(fNtxNot)
       ENDIF
       RETURN .T.
*>>>>FIN GRABACION DE LAS NOTAS