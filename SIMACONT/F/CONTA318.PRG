/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: POR PROFESOR. VALIDACION

**************************************************************************
* TITULO..: VALIDACION                                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 07/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   NOV 07/2002 JUE

OBJETIVOS:

1- Permite validar las notas que aparecen en el profesor contra las que
   aparecen leidas en la contabilidad acad‚mica.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_318(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'TEM'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
       LOCAL nTipNov := 1                   // Tipo de Novedad 1=>Por Profesor 2=>Materia 3=>Por Estudiante

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nIniPro := 0                   // Registro Inicial del Profesor
       LOCAL nFinPro := 0                   // Registro Final del Profesor
       LOCAL nIniCaP := 0                   // Registro Inicial Carga Profesor
       LOCAL nFinCaP := 0                   // Registro Final Carga Profesor
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL cSecArc := ''                  // Secuencial de Archivos

       LOCAL cPatPro := ''                  // Path del Profesor
       LOCAL nCarAca := 0                   // N£mero de Cargas Acad‚micas
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTpr := ''               // Nombre del Profesor
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
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuN,'SUN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuG,'SUG',NIL,lShared)
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

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LOS PROFESORES
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro .AND.;
		     PRO->lCargasPro
       GO TOP
       IF EOF()
	  cError('NO EXISTEN PROFESORES PARA '+cMaeAct)
	  SET FILTER TO
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>LECTURA DEL PERIODO
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL PERIODO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervPro(nFilInf+1,nColInf,@nIniPro,@nFinPro)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathOtr+'\',;
			     'VAN'+STR(nNroPer,1,0),ExtFile,.F.)

       CreaConLog(lShared,nModCry,cPatSis+'\'+PathOtr,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathOtr+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DE SEGUIMIENTO')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>LECTURA DEL TIPO DE NOVEDAD
       nTipNov := nLeeOpcion('NOVEDAD: '+;
		 '1<POR PROFESOR> 2<POR MATERIAS> 3<POR ESTUDIANTE> 4<ABANDONAR>?',4,'0')
       IF EMPTY(nTipNov)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE NOVEDAD

*>>>>REGISTRO DEL LOG GENERAL
       AADD(aGenLog,{'cMaeActLog',cMaeAct})
       AADD(aGenLog,{'nNroPerLog',nNroPer})
       AADD(aGenLog,{'cNomUsrLog',cNomUsr})
*>>>>FIN REGISTRO DEL LOG GENERAL

*>>>>IMPRESION POR PROFESOR
       SELECT PRO
       GO nIniPro
       DO WHILE PRO->(RECNO()) <= nFinPro

**********VALIDACION DE LA CARGA ACADEMICA
	    DO CASE
	    CASE !PRO->lCargasPro
		 cTxtLog := 'NO TIENE CARGA ACADEMICA'

	    CASE !(cMaeAct $ PRO->cMaeAluPro)
		 cTxtLog := 'NO TIENE CARGA ACADEMICA'

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)
**********FIN VALIDACION DE LA CARGA ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   'CARGA'+cMaeAct+ExtFile,'CAR',NIL,lShared) .OR.;
	       !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    PRO->cCodigoPro+'\'+;
			   'CARPRO'+cAnoSis+ExtFile,'CAP',NIL,lShared)

	       cTxtLog := 'ABRIENDO EL ARCHIVO DE CARGA ACADEMICA'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********FILTRACION DE LA CARGA ACADEMICA
	    SELECT CAR
	    GO TOP
	    SET FILTER TO CAR->cCodigoPro == PRO->cCodigoPro
	    GO TOP
	    IF EOF()

	       cTxtLog := 'NO EXISTE CARGA PARA EL PROFESOR'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       SET FILTER TO
	       SELECT PRO
	       PRO->(DBSKIP())
	    ENDIF
**********FIN FILTRACION DE LA CARGA ACADEMICA

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAR->(RECCOUNT()) == 0
		 cTxtLog := 'NO EXISTEN REGISTROS DE CARGA ACADEMICA'

	    CASE CAP->(RECCOUNT()) == 0
		 cTxtLog := 'NO EXISTEN REGISTROS DE CARGA ACADEMICA DEL PROFESOR'

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr

	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********CAPTURA DE LOS GRUPOS POR INTERVALO
	    IF nIniPro == nFinPro
	       IF !lIntervCaP(nFilInf+1,nColInf,@nIniCaP,@nFinCaP)
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ELSE
	       nIniCaP := 1
	       nFinCaP := CAP->(RECCOUNT())
	    ENDIF
**********FIN CAPTURA DE LOS GRUPOS POR INTERVALO

**********VALIDACION DE LA CARGA
	    nCarAca := 0
	    nNroFil := nMarco(nFilPal+1,'VALIDANDO ASIGNACION ACADEMICA DE '+;
					cMaeAct+' PROFESOR: '+cNombreTpr)
	    SELECT CAR
	    DO WHILE .NOT. CAR->(EOF())

	       nCarAca++

*--------------VISUALIZACION DE LA CARGA
		 @ nNroFil,01 SAY 'CARGA: '+CAR->cCodigoCar
		 nNroFil++
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,'VALIDANDO ASIGNACION '+;
						'ACADEMICA DE '+cMaeAct+;
						' PROFESOR: '+cNombreTpr)
		 ENDIF
*--------------FIN VISUALIZACION DE LA CARGA

*--------------LOCALIZACION DE LA CARGA EN EL PROFESOR
		 IF !lLocCodigo('cCodigoCar','CAP',CAR->cCodigoCar)

		    cTxtLog :='NO EXISTE LA CARGA EN EL PROFESOR:'+;
			       PRO->cCodigoPro
		    AADD(aCamLog,{'cObservLog',cTxtLog})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		 ENDIF
*--------------FIN LOCALIZACION DE LA CARGA EN EL PROFESOR

*--------------VALIDACION DEL ARCHIVO DE LA CARGA EN EL PROFESOR
		 cPatPro := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    PRO->cCodigoPro
		 IF !FILE(cPatPro+'\'+CAR->cCodigoCar+ExtFile)
		    cTxtLog := 'NO EXISTE EL ARCHIVO '+;
			       CAR->cCodigoCar+ExtFile+' DEL PROFESOR'+;
			       PRO->cCodigoPro
		    AADD(aCamLog,{'cObservLog',cTxtLog})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		 ENDIF
		 CAR->(DBSKIP())
*--------------FIN VALIDACION DEL ARCHIVO DE LA CARGA EN EL PROFESOR

	    ENDDO

	    IF CAP->(RECCOUNT()) # nCarAca

	       cTxtLog := 'LA CARGA ACADEMICA DEL PROFESOR: '+;
			  PRO->cCodigoPro+' ESTA DIFERENTE'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	    ENDIF
	    lHayErr := .F.
**********FIN VALIDACION DE LA CARGA

**********RECORRIDO DE LA CARGA ACADEMICA
	    nNroFil := nMarco(nFilPal+1,'PROFESOR: '+;
					PRO->cCodigoPro+':'+cNombreTpr)
	    SELECT CAP
	    CAP->(DBGOTO(nIniCaP))
	    DO WHILE CAP->(RECNO()) <= nFinCaP

*--------------INICIALIZACION DEL PATH DE NOTAS
		 cPatPro := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
		 cCodGru := SUBS(CAP->cCodigoCar,5,4)
*--------------FIN INICIALIZACION DEL PATH DE NOTAS

*--------------SELECION DE LAS AREAS DE TRABAJO
		 FNotPro := cPatPro+'\'+CAP->cCodigoCar+ExtFile
		 IF !lUseDbf(.T.,FNotPro,'NOP',NIL,lShared)

		    cTxtLog := 'ABRIENDO EL ARCHIVO '+FNotPro
		    AADD(aCamLog,{'cObservLog',cTxtLog})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		    IF lPregunta('DESEA CONTINUAR? Si No')
		       EXIT
		    ENDIF
		    CloseAll()
		    RETURN NIL
		 ENDIF
		 lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------VISUALIZACION DE LA CARGA
		 @ nNroFil,01 SAY 'CURSO: '+cCodGru+' '+;
				  ALLTRIM(MAT->cNombreMat)
		 nNroFil++
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,'PROFESOR: '+;
				      PRO->cCodigoPro+':'+cNombreTpr)
		 ENDIF
*--------------FIN VISUALIZACION DE LA CARGA

*--------------VALIDACION DE LAS NOTAS
		 IF CAP->nTipCarCar == 0

		    IF lValNotPro(lShared,cNomSis,cNomUsr,cAnoUsr,cPatSis,;
				  nNroPer,PRO->cCodigoPro,cNombreTpr,;
				  CAP->cCodigoCar,MAT->cNombreMat,;
				  cMaeAct,nFilPal,aGenLog,cAliasL,;
				  lGraLog,FNotPro,nTipNov)
		       lHayErr := .T.
		    ENDIF

		 ELSE

		    ValNoPPro(lShared,cNomSis,cNomUsr,cAnoUsr,cPatSis,;
			      nNroPer,PRO->cCodigoPro,cNombreTpr,;
			      CAP->cCodigoCar,MAT->cNombreMat,;
			      cMaeAct,nFilPal,aGenLog,cAliasL,;
			      lGraLog,FNotPro,nTipNov)

		 ENDIF
*--------------FIN VALIDACION DE LAS NOTAS

*--------------ANALISIS DE DECISION
		 IF lHayErr .AND. nTipNov == 1
		    EXIT
		 ENDIF
*--------------FIN ANALISIS DE DECISION

	       CloseDbf('NOT')
	       CloseDbf('NOP')
	       CAP->(DBSKIP())

	    ENDDO
	    CloseDbf('NOT')
**********FIN RECORRIDO DE LA CARGA ACADEMICA

**********GRABACION DE LA NOVEDAD
	    IF lHayErr .AND. nTipNov == 1
	       AADD(aCamLog,{'cObservLog',cNombreTpr})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDIF
**********FIN GRABACION DE LA NOVEDAD

	  SELECT CAR
	  SET FILTER TO
	  CloseDbf('CAR')

	  SELECT PRO
	  PRO->(DBSKIP())

       ENDDO

       IF TEM->(RECCOUNT()) == 0
	  cError('NO EXISTEN INCONSISTENCIAS')
       ELSE
	  cSecArc := SUBS(FileLog,RAT('.',FileLog)-4,4)
	  cError('EXISTEN '+ALLTRIM(STR(TEM->(RECCOUNT()),9999))+' '+;
		 'REGISTROS INCONSISTENTES','Archivo No.'+cSecArc)
       ENDIF
       SELECT TEM
       BROWSE()
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION POR PROFESOR


/*************************************************************************
* TITULO..: RESUMEN JUICIOS VALORATIVOS POR PROFESOR                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2002 DOM A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 20/2002 DOM

OBJETIVOS:

1- Imprime el resumen de los juicios valorativos de cada periodo y el total
   de dificultades por recuperar.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNotPro(lShared,cNomSis,cNomUsr,cAnoUsr,cPatSis,nNroPer,;
		    cCodPro,cNomPro,cCodCar,cNomMat,cMaeAct,nFilPal,;
		    aGenLog,cAliasL,lGraLog,FileNoP,nTipNov)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       nNroPer                              // N£mero del Periodo
       cCodPro                              // C¢digo del Profesor
       cNomPro                              // Nombre del Profesor
       cCodCar                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       nFilPal                              // Fila Principal
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log
       lGraLog                              // .T. Grabar el Log
       FileNoP			            // Archivo Notas del Profesor
       nTipNov			            // Tipo de Novedad 1=>Por Profesor 2=>Por Materia 3=>Por Estudiante */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL aCamLog := {}                  // Campos del Log

       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lCuadre := .T.                 // .T. Hay cuadre en alumnos
       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL cCodMat := ''                  // C¢digo de la Materia
       LOCAL cPorcen := ''                  // Porcentaje de la materia

       LOCAL cDefNot := ''                  // Juicio Valorativo en Notas
       LOCAL cRecNot := ''                  // Recuperaci¢n Valorativo en Notas
       LOCAL cIndNot := ''                  // Indicadores en Notas

       LOCAL cDefNoP := ''                  // Juicio Valorativo en Profesor
       LOCAL cRecNoP := ''                  // Recuperaci¢n Valorativo en Profesor
       LOCAL cIndNoP := ''                  // Indicadores en Profesor

       LOCAL cCamDefNot := ''               // Campo Nota Definitiva en Nota
       LOCAL cCamRecNot := ''               // Campo Recuperaci¢n en Nota
       LOCAL cCamIndNot := ''               // Campo destino Juicios

       LOCAL cCamDefNoP := ''               // Campo Definitiva profesor
       LOCAL cCamRecNoP := ''               // Campo Recuperaci¢n profesor
       LOCAL cCamIndNoP := ''               // Campo Indicadores profesor

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Profesor
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cCodMat := SUBS(cCodCar,1,4)
       cCodGru := SUBS(cCodCar,5,4)
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      cFilePlan(cAnoUsr,cCodGru),'PLA',NIL,lShared)

	  cTxtLog := 'NO EXISTE PLAN ACADEMICO. NIVEL:'+;
		     cNomNiv(SUBS(cCodGru,1,2))

	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  CloseDbf('PLA')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       FileNot := cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		  'NT'+cCodGru+cAnoSis+ExtFile
       IF !lUseDbf(.T.,FileNot,'NOT',NIL,lShared)

	  cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS '+FileNot
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  CloseDbf('NOT')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO
       IF !lMatPlan(lShared,CAP->nTipCarCar,cCodMat,cCodMat,cCodGru)
	  CloseDbf('PLA')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO

*>>>>ASIGNACION DE VARIABLES DE CAMPO
       IF PLA->cTipArePla == 'N'
	  cCamDefNot := 'NOT->cAreN'+SUBS(cCodMat,1,2)+"Not"
	  cCamRecNot := 'NOT->cAreN'+SUBS(cCodMat,1,2)+'Rec'
	  cCamIndNot := 'NOT->cJ'+STR(nNroPer,1)+cCodMat+"Not"
       ELSE
	  cPorcen := IF(PLA->nPorcenPla == 0,;
			'100','0'+STR(PLA->nPorcenPla,2))
	  cCamDefNot := 'NOT->cNt'+cCodMat+cPorcen
	  cCamRecNot := 'NOT->cNt'+cCodMat+'Rec'
	  cCamIndNot := 'NOT->cJ'+STR(nNroPer,1)+cCodMat+"Not"

       ENDIF

       cCamIndNoP := 'NOP->cIndic'+STR(nNroPer,1)+'NoP'
       cCamDefNoP := 'NOP->cDefin'+STR(nNroPer,1)+'NoP'
       cCamRecNoP := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN ASIGNACION DE VARIABLES DE CAMPO

*>>>>LINEA DE ESTADO
       LineaEstado('ºCARGA:'+cCodCar+'ºMATERIA:'+cNomMat,cNomSis)
       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
				   cCodPro+':'+cNomPro)
*>>>>FIN LINEA DE ESTADO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       lCuadre := .T.
       SELECT NOT
       NOT->(DBGOTOP())
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

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOT->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,44)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********VALIDACION SI ESTA RETIRADO
	    IF lRetiroTes
	       IF lCuadre
		  SELECT NOP
		  SKIP
		 *ÀAvanza por no haber descuadre
	       ENDIF
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION SI ESTA RETIRADO

**********ANALISIS DEL CUADRE DE LOS ALUMNOS
	    IF lCuadre

*--------------VALIDACION DEL CUADRE
		 lCuadre := .T.
		 IF NOT->cCodigoEst # NOP->cCodigoEst
		    lCuadre := .F.
		    SELECT NOT
		 ENDIF
*--------------FIN VALIDACION DEL CUADRE

	    ENDIF
**********FIN ANALISIS DEL CUADRE DE LOS ALUMNOS

**********BUSQUEDA DEL ALUMNO POR DESCUADRE
	    IF !lCuadre
	       IF !lLocCodigo('cCodigoEst','NOP',NOT->cCodigoEst)

		  cTxtLog := 'CODEST:'+NOT->cCodigoEst+;
			     ' NO SE ENCUENTRA EN GRUPO '+;
			     cCodGru+' PROF: '+PRO->cCodigoPro
		  AADD(aCamLog,{'cObservLog',cTxtLog})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       ENDIF
	    ENDIF
**********FIN BUSQUEDA DEL ALUMNO POR DESCUADRE

**********LECTURA DE LOS INDICADORES Y LA NOTA
	    cDefNot := &cCamDefNot
	    cRecNot := &cCamRecNot
	    cRecNot := SUBS(cRecNot,nNroPer*4-3,4)
	    cIndNot := &cCamIndNot

	    cDefNoP := &cCamDefNoP
	    cRecNoP := &cCamRecNoP
	    cIndNoP := &cCamIndNoP
**********FIN LECTURA DE LOS INDICADORES Y LA NOTA

**********VISUALIZACION DE LA CARGA
	    @ nNroFil,01 SAY STR(NOT->(RECNO()),2)
	    @ nNroFil,04 SAY NOT->cCodigoEst

	    @ nNroFil,11 SAY ALLTRIM(cIndNot)
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					   cCodPro+':'+cNomPro)
	    ENDIF

	    @ nNroFil,11 SAY ALLTRIM(cIndNoP)
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					   cCodPro+':'+cNomPro)
	    ENDIF

	    cTxtTem := ''
	    IF cIndNot # cIndNoP
	       cTxtTem += 'Indicadores,'
	    ENDIF
	    IF SUBS(cDefNot,nNroPer*4-3,4) # cDefNoP
	       cTxtTem += 'Juicio Valorativo,'
	    ENDIF
	    IF cRecNot # cRecNoP
	       cTxtTem += 'Juicio de Recuperaci¢n,'
	    ENDIF
**********FIN VISUALIZACION DE LA CARGA

**********GRABACION DEL LOG
	    IF (cIndNot # cIndNoP  .OR.;
		SUBS(cDefNot,nNroPer*4-3,4) # cDefNoP  .OR.;
		cRecNot # cRecNoP)

*--------------DATOS DEL ESTUDIANTE
		 lHayErr := .T.
		 cTxtLog := 'Diferencia en:'+cTxtTem
		 AADD(aCamLog,{'cObservLog',cTxtLog})

		 AADD(aCamLog,{'cCodigoEst',cCodigoTes})
		 AADD(aCamLog,{'cCodigoGru',cCodGru})
		 AADD(aCamLog,{'nNroRegEst',NOT->(RECNO())})
		 AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
*--------------FIN DATOS DEL ESTUDIANTE

*--------------CONTENIDO DE CAMPOS
		 AADD(aCamLog,{'cMatNoPLog',cCodMat})
		 AADD(aCamLog,{'cMatNotLog',cCodMat})

		 AADD(aCamLog,{'cIndNotLog',cIndNot})
		 AADD(aCamLog,{'cIndNoPLog',cIndNoP})

		 AADD(aCamLog,{'cDefNotLog',cDefNot})
		 AADD(aCamLog,{'cDefNoPLog',cDefNoP})

		 AADD(aCamLog,{'cRecNotLog',cRecNot})
		 AADD(aCamLog,{'cRecNoPLog',cRecNoP})
*--------------FIN CONTENIDO DE CAMPOS

*--------------ARCHIVO Y CAMPOS INVOLUCRADOS
		 AADD(aCamLog,{'cNomArcNot',FileNot})
		 AADD(aCamLog,{'cNomArcNop',FileNoP})

		 AADD(aCamLog,{'cCamDefNot',cCamDefNot})
		 AADD(aCamLog,{'cCamDefNoP',cCamDefNoP})
		 AADD(aCamLog,{'cCamRecNot',cCamRecNot})
		 AADD(aCamLog,{'cCamRecNoP',cCamRecNoP})
		 AADD(aCamLog,{'cCamIndNot',cCamIndNot})
		 AADD(aCamLog,{'cCamIndNoP',cCamIndNoP})
*--------------FIN ARCHIVO Y CAMPOS INVOLUCRADOS

*--------------ACTUALIZACION SIMACONT A SIMAPROF
		 IF !EMPTY(cIndNot) .AND. EMPTY(cIndNoP)
		    AADD(aCamLog,{'cActIndLog','X'})
		 ENDIF

		 IF !EMPTY(cDefNot) .AND. EMPTY(cDefNoP)
		    AADD(aCamLog,{'cActDefLog','X'})
		 ENDIF

		 IF !EMPTY(cRecNot) .AND. EMPTY(cRecNoP)
		    AADD(aCamLog,{'cActRecLog','X'})
		 ENDIF
*--------------FIN ACTUALIZACION SIMACONT A SIMAPROF

*--------------ACTUALIZACION SIMAPROF A SIMACONT
		 IF EMPTY(cIndNot) .AND. !EMPTY(cIndNoP)
		    AADD(aCamLog,{'cActIndLog','Y'})
		 ENDIF

		 IF EMPTY(cDefNot) .AND. !EMPTY(cDefNoP)
		    AADD(aCamLog,{'cActDefLog','Y'})
		 ENDIF

		 IF EMPTY(cRecNot) .AND. !EMPTY(cRecNoP)
		    AADD(aCamLog,{'cActRecLog','Y'})
		 ENDIF

		 IF nTipNov == 3
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		 ENDIF
*--------------FIN ACTUALIZACION SIMAPROF A SIMACONT

	    ENDIF
**********GRABACION DEL LOG

**********ANALISIS DE DECISION
	    IF lHayErr .AND. nTipNov # 3
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

**********AVANCE AL SIGUIENTE ALUMNO
	    SELECT NOT
	    NOT->(DBSKIP())
	    IF lCuadre
	       SELECT NOP
	       NOT->(DBSKIP())
	      *ÀAvanza por no haber descuadre
	    ENDIF
**********FIN AVANCE AL SIGUIENTE ALUMNO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>GRABACION DE LA NOVEDAD DE LA MATERIA
       IF nTipNov == 2 .AND. lHayErr
	  AADD(aCamLog,{'cObservLog',ALLTRIM(MAT->cNombreMat)})

	  AADD(aCamLog,{'cCodigoGru',cCodGru})
	  AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})

	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
       ENDIF
       CloseDbf('PLA')
       CloseDbf('NOT')
       IF !EMPTY(fNtxNot)
	  lFileDelete(fNtxNot)
       ENDIF
       RETURN lHayErr
*>>>>FIN GRABACION DE LA NOVEDAD DE LA MATERIA


/*************************************************************************
* TITULO..: RESUMEN JUICIOS VALORATIVOS POR PROFESOR                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2002 DOM A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 20/2002 DOM

OBJETIVOS:

1- Imprime el resumen de los juicios valorativos de cada periodo y el total
   de dificultades por recuperar.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValNoPPro(lShared,cNomSis,cNomUsr,cAnoUsr,cPatSis,nNroPer,;
		   cCodPro,cNomPro,cCodCar,cNomMat,cMaeAct,nFilPal,;
		   aGenLog,cAliasL,lGraLog,FileNoP,nTipNov)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       nNroPer                              // N£mero del Periodo
       cCodPro                              // C¢digo del Profesor
       cNomPro                              // Nombre del Profesor
       cCodCar                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       nFilPal                              // Fila Principal
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log
       lGraLog                              // .T. Grabar el Log
       FileNoP			            // Archivo Notas del Profesor
       nTipNov			            // Tipo de Novedad 1=>Por Profesor 2=>Por Materia 3=>Por Estudiante */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL aCamLog := {}                  // Campos del Log

       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lCuadre := .T.                 // .T. Hay cuadre en alumnos
       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL cCodMat := ''                  // C¢digo de la Materia
       LOCAL cMatSel := ''                  // Materia Selectiva
       LOCAL cPorcen := ''                  // Porcentaje de la materia

       LOCAL cDefNot := ''                  // Juicio Valorativo en Notas
       LOCAL cRecNot := ''                  // Recuperaci¢n Valorativo en Notas
       LOCAL cIndNot := ''                  // Indicadores en Notas

       LOCAL cDefNoP := ''                  // Juicio Valorativo en Profesor
       LOCAL cRecNoP := ''                  // Recuperaci¢n Valorativo en Profesor
       LOCAL cIndNoP := ''                  // Indicadores en Profesor

       LOCAL cCamDefNot := ''               // Campo Nota Definitiva en Nota
       LOCAL cCamRecNot := ''               // Campo Recuperaci¢n en Nota
       LOCAL cCamIndNot := ''               // Campo destino Juicios

       LOCAL cCamDefNoP := ''               // Campo Definitiva profesor
       LOCAL cCamRecNoP := ''               // Campo Recuperaci¢n profesor
       LOCAL cCamIndNoP := ''               // Campo Indicadores profesor

       LOCAL cCodAreTse := ''               // C¢digo del Area de la Selecion
       LOCAL cSecMatTse := ''               // Secuencial de la materia
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REEMPLAZO DE LA MATERIA VARIABLE
       cCodMat := SUBS(cCodCar,1,4)
       cCodGru := SUBS(cCodCar,5,4)

       cCodAreTse := SUBS(cCodMat,1,2)
       cSecMatTse := SUBS(cCodMat,3,2)
       IF lMatVarMat(cCodMat,.F.)
	  cCodMat := MAT->cCodigoMat
       ENDIF
*>>>>FIN REEMPLAZO DE LA MATERIA VARIABLE

*>>>>LINEA DE ESTADO
       LineaEstado('ºCARGA:'+cCodCar+'ºMATERIA:'+cNomMat,cNomSis)
       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
				   cCodPro+':'+cNomPro)
*>>>>FIN LINEA DE ESTADO

*>>>>RECORRIDO DE LAS NOTAS DEL PROFESOR
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst

	    SELECT &cMaeAct
	    IF lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cTxtLog := 'CODEST: '+cCodigoTes+;
			  'NO EXISTE EN EL MAESTRO'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
	    @ nNroFil,01 SAY STR(NOP->(RECNO()),2)
	    @ nNroFil,04 SAY NOP->cCodigoEst
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE



**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			    cFilePlan(cAnoUsr,cCodGru),'PLA',NIL,lShared)

	       cTxtLog := 'NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			  cNomNiv(SUBS(cCodGru,1,2))
	       AADD(aCamLog,{'cObservLog',cTxtLog})

	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			    cFilePlan(cAnoUsr,&cMaeAct->cCodigoGru),;
			    'PLA',NIL,lShared)

	       cTxtLog := 'NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			  cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))

	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO
	    IF !lMatPlan(lShared,CAP->nTipCarCar,cCodMat,;
			 cCodAreTse+cSecMatTse,cCodGru)

	       cTxtLog := 'MATERIA NO EXISTE EN EL PLAN'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       AADD(aCamLog,{'cMatNotLog',cCodMat})
	       AADD(aCamLog,{'cMatNoPLog',SUBS(cCodCar,1,4)})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO

**********ASIGNACION DE VARIABLES DE CAMPO
	    IF PLA->cTipArePla == 'N'
	       cCamDefNot := 'NOT->cAreN'+SUBS(cCodMat,1,2)+"Not"
	       cCamRecNot := 'NOT->cAreN'+SUBS(cCodMat,1,2)+'Rec'
	       cCamIndNot := 'NOT->cJ'+STR(nNroPer,1)+cCodMat+"Not"
	    ELSE
	       cPorcen := IF(PLA->nPorcenPla == 0,;
			     '100','0'+STR(PLA->nPorcenPla,2))
	       cCamDefNot := 'NOT->cNt'+cCodMat+cPorcen
	       cCamRecNot := 'NOT->cNt'+cCodMat+'Rec'
	       cCamIndNot := 'NOT->cJ'+STR(nNroPer,1)+cCodMat+"Not"

	    ENDIF

	    cCamDefNoP := 'NOP->cDefin'+STR(nNroPer,1)+'NoP'
	    cCamRecNoP := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
	    cCamIndNoP := 'NOP->cIndic'+STR(nNroPer,1)+'NoP'
**********FIN ASIGNACION DE VARIABLES DE CAMPO

**********SELECION DE LAS AREAS DE TRABAJO
	    FileNot := cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		       'NT'+&cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    IF !lUseDbf(.T.,FileNot,'NOT',NIL,lShared)

	       cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
			  &cMaeAct->cCodigoGru
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)

	       cTxtLog := 'CODEST:'+NOP->cCodigoEst+' NO EXISTE '+;
			  'GRUPO:'+&cMaeAct->cCodigoGru
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       AADD(aCamLog,{'cMatNotLog',cCodMat})
	       AADD(aCamLog,{'cMatNoPLog',SUBS(cCodCar,1,4)})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********BUSQUEDA DE LA PRIMERA SELECCION
	    IF !lSekCodigo(NOP->cCodigoEst+cCodAreTse,'SEL')

	       cTxtLog := 'CODEST:'+NOP->cCodigoEst+' '+;
			  'GRUPO: '+&cMaeAct->cCodigoGru+' '+;
			  'NO CLASIFICADO'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       AADD(aCamLog,{'cMatNotLog',cCodMat})
	       AADD(aCamLog,{'cMatNoPLog',SUBS(cCodCar,1,4)})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN BUSQUEDA DE LA PRIMERA SELECCION

**********VALIDACION DE LA MATERIA SELECTIVA
	    cMatSel := SEL->cCodAreSel+SUBS(SEL->cSecMatSel,nNroPer*2-1,2)
	    IF SUBS(cCodCar,1,4) # cMatSel

	       cTxtLog := 'COD:'+NOP->cCodigoEst+' '+;
			  'GRUPO: '+&cMaeAct->cCodigoGru+' '+;
			  'PROF: '+PRO->cCodigoPro+' '+;
			  'SELECTIV DIFERENTE AREA: '+cCodAreTse

	       @ nNroFil,11 SAY cTxtLog

	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA MATERIA SELECTIVA

**********LECTURA DE LOS INDICADORES Y LA NOTA
	    cDefNot := &cCamDefNot
	    cRecNot := &cCamRecNot
	    cRecNot := SUBS(cRecNot,nNroPer*4-3,4)
	    cIndNot := &cCamIndNot

	    cDefNoP := &cCamDefNoP
	    cRecNoP := &cCamRecNoP
	    cIndNoP := &cCamIndNoP
**********FIN LECTURA DE LOS INDICADORES Y LA NOTA

**********VALIDACION DEL RETIRO DE LA LISTA
	    IF NOP->lRetiroNop .AND. EMPTY(cIndNoP)

	       cTxtLog := cNombreTes+'. Retirado de Lista. '+;
			  'No tienen indicadores'

*	       cError(cTxtLog)
	       @ nNroFil,11 SAY cTxtLog
	       nNroFil++
	       IF nNroFil == 21
		  nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					      cCodPro+':'+cNomPro)
	       ENDIF

	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL RETIRO DE LA LISTA

**********VISUALIZACION DE LA CARGA
	    @ nNroFil,11 SAY ALLTRIM(cIndNot)
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					   cCodPro+':'+cNomPro)
	    ENDIF

	    @ nNroFil,11 SAY ALLTRIM(cIndNoP)
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
					   cCodPro+':'+cNomPro)
	    ENDIF

	    cTxtTem := ''
	    IF cIndNot # cIndNoP
	       cTxtTem += 'Indicadores,'
	    ENDIF
	    IF SUBS(cDefNot,nNroPer*4-3,4) # cDefNoP
	       cTxtTem += 'Juicio Valorativo,'
	    ENDIF
	    IF cRecNot # cRecNoP
	       cTxtTem += 'Juicio de Recuperaci¢n,'
	    ENDIF
**********FIN VISUALIZACION DE LA CARGA

**********GRABACION DEL LOG
	    IF (cIndNot # cIndNoP  .OR.;
		SUBS(cDefNot,nNroPer*4-3,4) # cDefNoP  .OR.;
		cRecNot # cRecNoP)

*--------------DATOS DEL ESTUDIANTE
		 cTxtLog := 'DIFERENCIA EN:'+cTxtTem
		 AADD(aCamLog,{'cObservLog',cTxtLog})

		 AADD(aCamLog,{'cCodigoEst',cCodigoTes})
		 AADD(aCamLog,{'cCodigoGru',&cMaeAct->cCodigoGru})
		 AADD(aCamLog,{'nNroRegEst',NOP->(RECNO())})
*--------------FIN DATOS DEL ESTUDIANTE

*--------------MATERIA SELECTIVA DEL ESTUDIANTE
		 AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		 AADD(aCamLog,{'cMatNotLog',cCodMat})
		 AADD(aCamLog,{'cMatNoPLog',SUBS(cCodCar,1,4)})

		 AADD(aCamLog,{'cCodAreSel',SEL->cCodAreSel})
		 AADD(aCamLog,{'cSecMatSel',SEL->cSecMatSel})
		 AADD(aCamLog,{'cSecProSel',SEL->cSecProSel})
*--------------FIN MATERIA SELECTIVA DEL ESTUDIANTE

*--------------CONTENIDO DE CAMPOS
		 AADD(aCamLog,{'cIndNotLog',cIndNot})
		 AADD(aCamLog,{'cIndNoPLog',cIndNoP})

		 AADD(aCamLog,{'cDefNotLog',cDefNot})
		 AADD(aCamLog,{'cDefNoPLog',cDefNoP})

		 AADD(aCamLog,{'cRecNotLog',cRecNot})
		 AADD(aCamLog,{'cRecNoPLog',cRecNoP})
*--------------FIN CONTENIDO DE CAMPOS

*--------------ARCHIVO Y CAMPOS INVOLUCRADOS
		 AADD(aCamLog,{'cNomArcNot',FileNot})
		 AADD(aCamLog,{'cNomArcNop',FileNoP})

		 AADD(aCamLog,{'cCamDefNot',cCamDefNot})
		 AADD(aCamLog,{'cCamDefNoP',cCamDefNoP})
		 AADD(aCamLog,{'cCamRecNot',cCamRecNot})
		 AADD(aCamLog,{'cCamRecNoP',cCamRecNoP})
		 AADD(aCamLog,{'cCamIndNot',cCamIndNot})
		 AADD(aCamLog,{'cCamIndNoP',cCamIndNoP})
*--------------FIN ARCHIVO Y CAMPOS INVOLUCRADOS

*--------------ACTUALIZACION SIMACONT A SIMAPROF
		 IF !EMPTY(cIndNot) .AND. EMPTY(cIndNoP)
		    AADD(aCamLog,{'cActIndLog','X'})
		 ENDIF

		 IF !EMPTY(cDefNot) .AND. EMPTY(cDefNoP)
		    AADD(aCamLog,{'cActDefLog','X'})
		 ENDIF

		 IF !EMPTY(cRecNot) .AND. EMPTY(cRecNoP)
		    AADD(aCamLog,{'cActRecLog','X'})
		 ENDIF
*--------------FIN ACTUALIZACION SIMACONT A SIMAPROF

*--------------ACTUALIZACION SIMAPROF A SIMACONT
		 IF EMPTY(cIndNot) .AND. !EMPTY(cIndNoP)
		    AADD(aCamLog,{'cActIndLog','Y'})
		 ENDIF

		 IF EMPTY(cDefNot) .AND. !EMPTY(cDefNoP)
		    AADD(aCamLog,{'cActDefLog','Y'})
		 ENDIF

		 IF EMPTY(cRecNot) .AND. !EMPTY(cRecNoP)
		    AADD(aCamLog,{'cActRecLog','Y'})
		 ENDIF

		 aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*--------------FIN ACTUALIZACION SIMAPROF A SIMACONT

	    ELSE

*--------------VALIDACION DE REGISTROS VACIOS
		 IF EMPTY(cIndNot) .AND. EMPTY(cIndNoP) .AND.;
		    EMPTY(cDefNot) .AND. EMPTY(cDefNoP) .AND.;
		    EMPTY(cRecNot) .AND. EMPTY(cRecNoP)

		    cTxtLog := 'VACIO. CODIGO:'+cCodigoTes+;
				SUBS(cNombreTes,1,40)

		    AADD(aCamLog,{'cObservLog',cTxtLog})

		    AADD(aCamLog,{'cCodigoGru',cCodGru})
		    AADD(aCamLog,{'nNroRegEst',NOT->(RECNO())})
		    AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})

		    AADD(aCamLog,{'cMatNoPLog',cCodMat})
		    AADD(aCamLog,{'cMatNotLog',cCodMat})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		    @ nNroFil,11 SAY SPACE(124)
		    @ nNroFil,11 SAY 'Registros Vacios'
		    nNroFil++
		    IF nNroFil == 21
		       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
						   cCodPro+':'+cNomPro)
		    ENDIF

		 ELSE

		    @ nNroFil,11 SAY SPACE(124)
		    @ nNroFil,11 SAY 'OK'
		    nNroFil++
		    IF nNroFil == 21
		       nNroFil := nMarco(nFilPal+1,'PROFESOR DE '+cMaeAct+':'+;
						   cCodPro+':'+cNomPro)
		    ENDIF

		 ENDIF
*--------------FIN VALIDACION DE REGISTROS VACIOS

	    ENDIF
**********GRABACION DEL LOG

**********AVANCE AL SIGUIENTE ALUMNO
	    SELECT NOP
	    NOP->(DBSKIP())
	    CloseDbf('NOT')
	    CloseDbf('PLA')
**********FIN AVANCE AL SIGUIENTE ALUMNO

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO DE LAS NOTAS DEL PROFESOR