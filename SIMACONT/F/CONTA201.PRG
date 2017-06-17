/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: LECTURA DE NOTAS

**************************************************************************
* TITULO..: LECTURA DE NOTAS                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 22/1995 LUN A
       Colombia, Bucaramanga        INICIO: 09:15 PM   MAY 25/1995 JUE


OBJETIVOS:

1- Permite leer las notas de los profesores de los discos de la contabilidad
   acad‚mica de los profesores.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_201(aParam1,aParam2,aParam3)

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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseXYZ(lShared,cPatSis,cMaeAct,cAnoSis,lAnoAct) .OR.;
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
		       FileSuG,'SUG',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)
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

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE NIVEL PARA '+cMaeAct)

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       lHayErr := .T.
       DO CASE
       CASE EMPTY(TCO->nPerActTbl)
	    cError('DEBE HABILITAR EL PERIODO ACTUAL')

       CASE TCO->nPerActTbl > TCO->nTotPerTbl
	    cError('EL PERIODO ACTUAL NO DEBE SER MAYOR AL TOTAL DE PERIODOS')
       OTHERWISE
	   lHayErr := .F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF

       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)

       lHayErr := .T.
       DO CASE
       CASE nNroBis == 0
       CASE nNroBis # TCO->nPerActTbl
	    cError('DEBE DIGITAR EL PERIODO ACTUAL HABILITADO')
       OTHERWISE
	   lHayErr := .F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathLog+'\',;
			     'LON'+STR(nNroBis,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>REGISTRO DEL LOG
       AADD(aGenLog,{'cOpcionLog','<LECTURA DE NOTAS >'})
       AADD(aGenLog,{'cMaeActLog',cMaeAct})
       AADD(aGenLog,{'nNroPerLog',nNroBis})
       AADD(aGenLog,{'cNomUsrLog',cNomUsr})

       cHorIni := TIME()
       cTxtLog := 'Inicio de la Lectura. Inicio a las: '+cHorIni
       AADD(aCamLog,{'cObservLog',cTxtLog})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*>>>>FIN REGISTRO DEL LOG

*>>>>ANALISIS DE LA LECTURA POR DISKETTE
       cPatPro := TCO->cUnidadTbl+':'
       lDisket := .T.
       IF cPatPro # 'A:' .AND. cPatPro # 'B:'
	  lDisket := .F.
	  IF !lUseDbf(.T.,cPatSis+'\'+;
		      FilePro+cAnoSis+ExtFile,'DOC',NIL,lShared)

	     cTxtLog := 'ABRIENDO ARCHIVOS'
	     cError(cTxtLog)
	     AADD(aCamLog,{'cObservLog',cTxtLog})
	     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	     CLOSE ALL
	     RETURN NIL
	  ENDIF
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
       IF !lDisKet

	  IF !lIntervPro(nFilInf+1,nColInf,@nRegIni,@nRegFin,'DOC')

	     cTxtLog := 'Se Abandono el Proceso. No se realiz¢ la lectura'
	     AADD(aCamLog,{'cObservLog',cTxtLog})
	     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	     CLOSE ALL
	     RETURN NIL
	  ENDIF

	  cTxtLog := 'DESEA CONTINUAR? No Si'
	  IF !lPregunta(cTxtLog)
	     AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
	     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
	  AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       ENDIF
*>>>>FIN CAPTURA DEL INTERVALO DE PROFESORES

*>>>>ANALISIS PARA LA VALIDACION
       cTxtLog := 'DESEA VALIDAR SI EXISTEN NOTAS GRABADAS? No Si'
       lValNot := lPregunta(cTxtLog)
       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: '+IF(lValNot,'Si','No')})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       cTxtLog := 'DESEA VISUALIZAR LA VALIDACION '+;
		  'DE LA LECTURA DE LAS NOTAS? No Si'
       lValida := lPregunta(cTxtLog)
       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: '+IF(lValida,'Si','No')})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*>>>>FIN ANALISIS PARA LA VALIDACION

/*
*>>>>ANALISIS DE LA GRABACION DEL LOG
       cTxtLog := 'DESEA GRABAR EL LOG DETALLADO DEL PROCESO? Si No'
       lGraLog := lPregunta(cTxtLog)
       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: '+IF(lGraLog,'Si','No')})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*>>>>FIN ANALISIS DE LA GRABACION DEL LOG
*/

*>>>>LECTURA DE LA NOTAS DEL PROFESOR
       SELECT DOC
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lDisket
	  GO nRegIni
       ENDIF
       DO WHILE IF(lDisket,.T.,DOC->(RECNO()) <= nRegFin)

**********GRABACION DEL LOG
	    cTxtLog := 'PROFESOR:'+ALLTRIM(DOC->cNombrePro)+;
		       '. Inicio a las: '+TIME()
	    AADD(aCamLog,{'cObservLog',cTxtLog})
	    AADD(aCamLog,{'cCodigoPro',DOC->cCodigoPro})
	    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
**********FIN GRABACION DEL LOG

**********ASIGNANCION DEL PATH DEL PROFESOR
	    IF !lDisket
	       cPatPro := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+DOC->cCodigoPro
	    ENDIF
**********FIN ASIGNANCION DEL PATH DEL PROFESOR

**********ESPERA PARA LA ESTRADA DEL DISCO
	    IF lDisket
	       RESTSCREEN(0,0,24,79,cSavPan)
	       @ nFilInf+3,20 PROMPT  'POR FAVOR ENTRE EL DISKETTE DEL PROFESOR';
			      MESSAGE 'Presione <ENTER> para empezar la lectura'+;
				      ' o <ESC> para REGRESAR'
	       MENU TO nNroOpc

	       IF nNroOpc == 0
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ESPERA PARA LA ESTRADA DEL DISCO

**********DETERMINACION DEL DISKETTE CORRECTO
	    IF .NOT. FILE(cPatPro+'\'+FilePro+ExtFile) .OR.;
	       .NOT. FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)

	       IF lDisket
		  cError('POR FAVOR VERIFIQUE SI ES EL DISCO DE NOTAS')
	       ELSE

		 cTxtLog := 'PARA '+ALLTRIM(DOC->cNombrePro)+;
			    ' NO APARECEN LOS ARCHIVOS DE LA CARGA ACADEMICA'
		 cError(cTxtLog)
		 AADD(aCamLog,{'cObservLog',cTxtLog})
		 aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	       *ÀRegistro del Log


*-----------------PREGUNTA DE DECISION
		    cTxtLog := 'DESEA CONTINUAR? Si No'
		    IF !lPregunta(cTxtLog)
		       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
		       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		       EXIT
		    ENDIF
		    AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
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
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

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
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       CloseDbf('CAP')
	       CloseDbf('PRO')

	       cTxtLog := 'DESEA CONTINUAR? Si No'
	       IF !lPregunta(cTxtLog)
		  AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		  EXIT
	       ENDIF
	       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       DOC->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA CARGA DEL PROFESOR

**********VISUALIZACION DE LA CARGA ACADEMICA
	    IF !lVerCarga(lShared,nFilPal+1,.T.,.T.,aGenLog,cAliasL)
	       CloseDbf('CAP')
	       CloseDbf('PRO')

	       cTxtLog := 'DESEA CONTINUAR? Si No'
	       IF lPregunta(cTxtLog)
		  AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		  DOC->(DBSKIP())
		  LOOP
	       ELSE
		  AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		  EXIT
	       ENDIF
	    ENDIF
**********FIN VISUALIZACION DE LA CARGA ACADEMICA

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

		    cTxtLog := 'MATERIA NO EXISTE'
		    AADD(aCamLog,{'cObservLog',cTxtLog})
		    AADD(aCamLog,{'cCodigoGru',cCodigoTgr})
		    AADD(aCamLog,{'cMatNoPLog',cCodigoTma})
		    AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		    cTxtLog := 'DESEA CONTINUAR? Si No'
		    IF !lPregunta(cTxtLog)
		       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
		       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		       lSiSiga := .F.
		       EXIT
		    ENDIF
		    AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		    SELECT CAP
		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIA

*--------------GRABACION DEL LOG
		 cTxtLog := 'MATERIA:'+ALLTRIM(MAT->cNombreMat)+;
			    '. Inicio a las: '+TIME()
		 AADD(aCamLog,{'cObservLog',cTxtLog})
		 AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		 AADD(aCamLog,{'cCodigoGru',cCodigoTgr})
		 AADD(aCamLog,{'cMatNoPLog',cCodigoTma})
		 aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*--------------FIN GRABACION DEL LOG

*--------------LECTURA DE LAS NOTAS
		 IF CAP->nTipCarCar == 0
		    lLeerxNot(lShared,cNomSis,nFilPal,;
			      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,;
			      cMaeAct,cCodigoTgr,cCodigoTma,;
			      nNroBis,cPatPro,lValNot,lValida,;
			      aGenLog,cAliasL,lGraLog)
		 ELSE
		    lLeerxNoP(lShared,cNomSis,nFilPal,;
			      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,;
			      cMaeAct,cCodigoTgr,cCodigoTma,;
			      nNroBis,cPatPro,lValNot,lValida,;
			      aGenLog,cAliasL,lGraLog)
		 ENDIF
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
       cTxtLog := 'Fin de la Lectura. '+;
		  'Inicio a las: '+cHorIni+' y termino a las: '+TIME()
       AADD(aCamLog,{'cObservLog',cTxtLog})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
       SELECT &cAliasL
       BROWSE()
       CLOSE ALL
       RETURN NIL
*>>>>FIN LECTURA DE LA NOTAS DEL PROFESOR


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: VISUALIZAR CARGA ACADEMICA DEL PROFESOR        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:20 AM   MAY 23/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de archivos y profesor del disco del
   profesor

2- Debe estar en uso el archivo de errores si se activa la opci¢n de
   grabar el error.

2- Visualiza la carga acad‚mica del profesor

3- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVerCarga(lShared,nFilPal,lValida,lGraErr,aGenLog,cAliasL)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilPal                              // Fila principal de impresi¢n
       lValida                              // .T. Validar la lectura
       lGraErr                              // .T. Grabar el error
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL aCamLog := {}                  // Campos del Log

       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL nNroFil := 0                   // N£mero de la fila

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONSULTA DE LA CARGA ACADEMICA DEL PROFESOR
       nNroFil := nMarco(nFilPal,'CARGA ACADEMICA. PROFESOR(A): '+;
				  RTRIM(PRO->cApelliPro)+' '+;
				  RTRIM(PRO->cNombrePro))
       SELECT CAP
       GO TOP
       DO WHILE .NOT. EOF()

**********LECTURA DEL CODIGO DEL GRUPO Y MATERIA
	    cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
	    cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
**********FIN LECTURA DEL CODIGO DEL GRUPO Y MATERIA

**********LOCALIZACION DE LA MATERIA QUE DICTA
	    lHayErr := .F.
	    IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)

*--------------REGISTRO DE ERROR POR NO EXISTIR LA MATERIA
		 lHayErr := .T.
		 cMenTxt := 'LA MATERIA: '+cCodigoTma+' NO EXISTE '+;
			    'PROFESOR: '+PRO->cCodigoPro+' '+;
			    ALLTRIM(PRO->cNombrePro)

		 cError(cMenTxt)
		 lGraErr := IIF(lGraErr == NIL,.F.,lGraErr)
		 IF lGraErr
		    cTxtLog := 'LA MATERIA NO EXISTE DEL PROFESOR'+;
				ALLTRIM(PRO->cNombrePro)
		    AADD(aCamLog,{'cObservLog',cTxtLog})
		    AADD(aCamLog,{'cCodigoGru',cCodigoTgr})
		    AADD(aCamLog,{'cMatNoPLog',cCodigoTma})
		    AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		 ENDIF
*--------------FIN REGISTRO DE ERROR POR NO EXISTIR LA MATERIA

	       EXIT

	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA QUE DICTA

**********VISUALIZACION DE LA CARGA
	    @ nNroFil,01 SAY 'CURSO: '+cCodigoTgr
	    @ nNroFil,13 SAY MAT->cNombreMat

	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal,'CARGA ACADEMICA. PROFESOR(A): '+;
					 RTRIM(PRO->cApelliPro)+' '+;
					 RTRIM(PRO->cNombrePro))
	    ENDIF
**********FIN VISUALIZACION DE LA CARGA

	  SELECT CAP
	  SKIP

       ENDDO
       RETURN !lHayErr
*>>>>FIN CONSULTA DE LA CARGA ACADEMICA DEL PROFESOR

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION SI EL PROFESOR DICTA LA MATERIA     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAY 23/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo del Plan Academico del respectivo nivel

2- Debe estar en uso el archivo de errores si se activa la opci¢n de
   grabar el error.

3- Retorna .T. si el profesor dicta la materia


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDictada(lShared,cCodPro,cNomPro,cCodMat,cNomMat,;
		  cCodGru,lGraErr,nTipMat,aGenLog,cAliasL)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodPro                              // C¢digo del profesor
       cNomPro                              // Nombre del profesor
       cCodMat                              // C¢digo de la materia
       cNomMat                              // Nombre de la materia
       cCodGru                              // C¢digo del grupo
       lGraErr                              // .T. Grabar el error
       nTipMat                              // @Tipo de Materia
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log

       LOCAL lMatVar := .F.                 // .T. La materia es Variable
       LOCAL lMatSuN := .F.                 // .T. Hay Materia por Nivel
       LOCAL lMatSuG := .F.                 // .T. Hay Materia por Grupo
       LOCAL cCodigo := ''                  // C¢digo del Profesor

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL PROFESOR POR NIVELES
	  cCodigo := cCodPro
       cCodigoTpr := MAT->cCodigoPro
       IF .NOT. EMPTY(MAT->cCodigoPro)
	  cCodPro := ''
       ENDIF
*>>>>FIN LECTURA DEL PROFESOR POR NIVELES

*>>>>LOCALIZACION DE LA MATERIA VARIABLE
       lMatSuN := .F.
       lMatSuG := .F.
       lMatVar := lMatVarMat(cCodMat,.F.)

       IF lMatVar
	  IF MAT->nMatVarMat == 1   // Variable por Nivel
	     lMatSuN := lLocMatSuN(cCodMat,SUBS(cCodGru,1,2),.F.,cCodigo)
	  ELSE
	     lMatSuG := lLocMatSuG(cCodMat,cCodGru,.F.)
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA VARIABLE

*>>>>ANALISIS DE LA MATERIA
       DO CASE
       CASE !lMatVar .AND. MAT->nMatVarMat == 0

	    nTipMat := 1  // Materia Fija

       CASE lMatSuN .AND. SUN->lPorNivSuN

	    nTipMat := 2  // Variable por nivel

       CASE lMatSuN .AND. !SUN->lPorNivSuN    

	    nTipMat := 3 // Variable por Niveles

       CASE lMatSuG

	    nTipMat := 4 // Variable por Grupo

       OTHERWISE
	    nTipMat := 0
       ENDCASE
*>>>>FIN ANALISIS DE LA MATERIA

*>>>>VALIDACION SI EL PROFESOR DICTA LA MATERIA
       DO CASE
       CASE !lMatVar             .AND.;             // Materia Fija
	    MAT->nMatVarMat == 0 .AND.;
	    &('PLA->cPr'+cCodGru+"Pla") # cCodPro

       CASE lMatSuN .AND. SUN->lPorNivSuN  .AND.;   // Variable por nivel
	    SUN->cCodigoPro # cCodPro

       CASE lMatSuN .AND. !SUN->lPorNivSuN .AND.;   // Variable por Niveles
	    cCodigoTpr # cCodPro

       CASE lMatSuG .AND. SUG->cCodigoPro # cCodPro // Variable por Grupo

       OTHERWISE
	    lHayErr := .F.
       ENDCASE

       IF lHayErr
	  cTxtLog := 'La materia '+cCodMat+' '+ALLTRIM(cNomMat)+;
		     ' NO la dicta el profesor '+;
		     cCodPro+' '+ALLTRIM(cNomPro)

	  cError(cTxtLog)
	  lGraErr := IIF(lGraErr == NIL,.F.,lGraErr)
	  IF lGraErr
	     AADD(aCamLog,{'cObservLog',cTxtLog})
	     AADD(aCamLog,{'cCodigoGru',cCodGru})
	     AADD(aCamLog,{'cMatNoPLog',cCodMat})
	     AADD(aCamLog,{'cCodigoPro',cCodPro})
	     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	  ENDIF
       ENDIF
       RETURN !lHayErr
*>>>>FIN VALIDACION SI EL PROFESOR DICTA LA MATERIA

/*************************************************************************
* TITULO..: VALIDACION DE LA EXISTENCIA DE NOTAS GRABADAS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:40 AM   MAY 23/95 MAR

OBJETIVOS:

1- Valida si existen notas grabadas para la materia y bimestre especificado

2- Si se pasa el nombre de la materia se valida el reemplazo de las notas

3- Debe estar en uso el archivo de errores si se activa la opci¢n de
   grabar el error.

4- Retorna .T. si existen notas grabadas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHayNot(lShared,cCamNot,cCamJui,nNroBis,;
		 cNomMat,lValida,aGenLog,cAliasL)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cCamNot                              // Campo de las notas
       cCamJui                              // Campo de Juicios
       nNroBis                              // N£mero del bimestre
       cNomMat                              // Nombre de la materia
       lValida                              // .T. Visualiza la Validaci¢n
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log

       LOCAL cNotDef := ''                  // Nota Definitiva del Periodo
       LOCAL cJuicio := ''                  // Indicadores del Periodo
       LOCAL lHayNot := .F.                 // .T. Hay Notas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION SI EXISTEN NOTAS GRABADAS
       cNotDef := &cCamNot
       cJuicio := &cCamJui

       IF !EMPTY(cJuicio) .OR. !EMPTY(cNotDef)
	  lHayNot := .T.
	  IF !EMPTY(cJuicio)
	     cTxtLog := 'YA ESTAN GRABADOS LOS INDICADORES DE '+ALLTRIM(cNomMat)
	     cError(cTxtLog)
	  ELSE
	     cTxtLog := 'YA ESTAN GRABADAS LAS NOTAS DE '+ALLTRIM(cNomMat)
	     cError(cTxtLog)
	  ENDIF
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
       ENDIF
*>>>>FIN VALIDACION SI EXISTEN NOTAS GRABADAS

*>>>>ANALISIS PARA REEMPLAZAR LAS NOTAS
       IF lHayNot

	  cTxtLog := 'DESEA REEMPLAZAR O LEER DE NUEVO? No Si'
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	  IF lPregunta(cTxtLog)
	     lHayNot := .F.
	  ENDIF

	  cTxtLog := IIF(lHayNot,'SI','NO')+' '+;
		     'SE REEMPLAZORON LAS NOTAS DE LA MATERIA '+;
		     ALLTRIM(cNomMat)+' '+'PARA EL BIMESTRE '+;
		     STR(nNroBis,1)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       ENDIF
       RETURN lHayNot
*>>>>FIN VALIDACION SI EXISTEN NOTAS GRABADAS

/*************************************************************************
* TITULO DE LA FUNCION..: LEER NOTAS CON BASE EN CONTABILIDAD            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/98 MIE A
       Colombia, Bucaramanga        INICIO: 09:40 AM   MAR 11/98 MIE

OBJETIVOS:

1- Leer las notas del profesor con base en el archivo de notas de la
   contabilidad.

2- Retorna .F. si se presentaron problemas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeerxNot(lShared,cNomSis,nFilPal,cNomUsr,cAnoUsr,;
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
		      cFilePlan(cAnoUsr,cCodGru),'PLA',NIL,lShared)

	  cTxtLog := 'NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		      cNomNiv(SUBS(cCodGru,1,2))

	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

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

*>>>>VALIDACION SI EL PROFESOR DICTA LA MATERIA
       IF !lDictada(lShared,PRO->cCodigoPro,PRO->cNombrePro,;
		    MAT->cCodigoMat,MAT->cNombreMat,;
		    cCodGru,.T.,NIL,aGenLog,cAliasL)

	  cTxtLog := 'LA MATERIA ESTA CORRECTA?. '+;
		     'DESEA GRABAR SUS NOTAS? No Si'
	  IF !lPregunta(cTxtLog)
	     AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
	     AADD(aCamLog,{'cCodigoGru',cCodGru})
	     AADD(aCamLog,{'cMatNoPLog',cCodMat})
	     AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	     CloseDbf('PLA')
	     RETURN .F.
	  ENDIF
	  AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
	  AADD(aCamLog,{'cCodigoGru',cCodGru})
	  AADD(aCamLog,{'cMatNoPLog',cCodMat})
	  AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
       ENDIF
*>>>>FIN VALIDACION SI EL PROFESOR DICTA LA MATERIA

*>>>>ASIGNACION DE LA MATERIA A GRABAR
       IF PLA->cTipArePla == 'N'
	  cCamDefNot := 'cAreN'+SUBS(cCodMat,1,2)+"Not"
	  cCamJuiNot := 'cJ'+STR(nNroBis,1)+cCodMat+"Not"
	  cCamFalNot := 'cFa'+cCodMat+"Not"

	  IF lHayJnt(TCO->cEvaIndTbl)
	     cCamJntNot := 'cN'+STR(nNroBis,1)+cCodMat+"Not"
	  ENDIF
       ELSE
	  cPorcen := IF(PLA->nPorcenPla == 0,;
			'100','0'+STR(PLA->nPorcenPla,2))
	  cCamDefNot := 'cNt'+cCodMat+cPorcen
	  cCamJuiNot := 'cJ'+STR(nNroBis,1)+cCodMat+"Not"
	  cCamFalNot := 'cFa'+cCodMat+"Not"

	  IF lHayJnt(TCO->cEvaIndTbl)
	     cCamJntNot := 'cN'+STR(nNroBis,1)+cCodMat+"Not"
	  ENDIF
       ENDIF

       cCamJuiNoP := 'cIndic'+STR(nNroBis,1)+'NoP'
       cCamDefNoP := 'cDefin'+STR(nNroBis,1)+'NoP'

       IF lHayJnt(TCO->cEvaIndTbl)
	  cCamJntNoP := 'cIndnt'+STR(nNroBis,1)+'NoP'
       ENDIF
*>>>>FIN ASIGNACION DE LA MATERIA A GRABAR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		   'NT'+cCodGru+cAnoSis+ExtFile,'NOT',NIL,lShared)

	  cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION SI EXISTEN NOTAS GRABADAS
       IF lValNot
	  IF lHayNot(lShared,cCamDefNot,cCamJuiNot,nNroBis,;
		     MAT->cNombreMat,lValida,aGenLog,cAliasL)
	     CloseDbf('PLA')
	     CloseDbf('NOT')
	     RETURN .F.
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION SI EXISTEN NOTAS GRABADAS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		   CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

	  cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL PROFESOR '+;
		     'CON CODIGO '+CAP->cCodigoCar
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  CloseDbf('NOT')
	  CloseDbf('NOP')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LAS NOTAS
       lCuadre := .T.

       cTxtLog := 'GRABANDO LAS NOTAS DE '+ALLTRIM(CAP->cNombreMat)
       nNroFil := nMarco(nFilPal+1,cTxtLog)
       AADD(aCamLog,{'cObservLog',cTxtLog})
       AADD(aCamLog,{'cCodigoGru',cCodGru})
       AADD(aCamLog,{'cMatNoPLog',cCodMat})
       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot

	       cTxtLog := 'PERTENECE A OTRO GRUPO DIFERENTE AL GRUPO:'+cCodGru
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',NOT->cCodigoEst})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

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

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cCodigoTes := NOT->cCodigoEst

	    SELECT &cMaeAct
	    IF lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cTxtLog := 'EL ESTUDIANTE CODIGO: '+cCodigoTes+;
			  'NO EXISTE EN EL MAESTRO'
	       IF lValida
		  cError(cTxtLog)
	       ENDIF
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF lRetiroTes

	       cTxtLog := cNombreTes+'. Retirado. No se leen sus Notas'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       IF lCuadre
		  SELECT NOP
		  SKIP
		 *ÀAvanza por no haber descuadre
	       ENDIF
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********ANALISIS DEL CUADRE DE LOS ALUMNOS
	    IF lCuadre

*--------------VALIDACION DEL CUADRE
		 lCuadre := .T.
		 IF NOT->cCodigoEst # NOP->cCodigoEst
		    lCuadre := .F.
		    cTxtLog := 'DESCUADRE DE ALUMNOS EN EL GRUPO '+cCodGru
		    IF lValida
		       cError(cTxtLog)
		    ENDIF
		    AADD(aCamLog,{'cObservLog',cTxtLog})
		    AADD(aCamLog,{'cCodigoEst',cCodigoTes})
		    AADD(aCamLog,{'cCodigoGru',cCodGru})
		    AADD(aCamLog,{'cMatNoPLog',cCodMat})
		    AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
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
		  cTxtLog := cNombreTes+'. NO SE ENCUENTRA EN NOTAS DEL PROFESOR'
		  AADD(aCamLog,{'cObservLog',cTxtLog})
		  AADD(aCamLog,{'cCodigoEst',cCodigoTes})
		  AADD(aCamLog,{'cCodigoGru',cCodGru})
		  AADD(aCamLog,{'cMatNoPLog',cCodMat})
		  AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       ENDIF
	    ENDIF
**********FIN BUSQUEDA DEL ALUMNO POR DESCUADRE

**********LECTURA DE LA NOTA A GRABAR
	    SELECT NOP
	    cNotDef := &cCamDefNoP
	    cFallas := SUBS(NOP->cFallasNoP,nNroBis*2-1,2)

	    cJuicio := &cCamJuiNoP
	    cModNot := SUBS(cJuicio,121,5)
	    cJuicio := SUBS(cJuicio,1,120)

	    cJuicio := cJuicio+cModNot

	    IF lHayJnt(TCO->cEvaIndTbl)
	       cNotInd := &cCamJntNoP
	    ENDIF
**********FIN LECTURA DE LA NOTA A GRABAR

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('PROFESOR: '+ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)+;
			 'ºGRUPO: '+cCodGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			  NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DE JUICIOS VACIOS
	    lGrabar := .T.
	    SELECT NOT
	    IF EMPTY(cJuicio) .AND. EMPTY(cNotDef)

	       cTxtLog := 'No Procesado. INDICADORES Y NOTA VACIOS'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog,lGraLog)

	       lGrabar := .F.
	    ENDIF
**********FIN VALIDACION DE JUICIOS VACIOS

**********ANALISIS DE LA GRABACION
	    IF lValida .AND. !lGrabar
	       cError('NO SE GRABAN LAS NOTAS DE '+cNombreTes+' '+;
		      'CODIGO: '+cCodigoTes)
	    ENDIF
**********FIN ANALISIS DE LA GRABACION

**********GRABACION DE LA NOTA DEFINITIVA
	    SELECT NOT
	    IF lGrabar
	       IF NOT->(lRegLock(lShared,.F.))

		  AADD(aCamLog,{'cCodigoEst',NOP->cCodigoEst})
		  AADD(aCamLog,{'cCodigoGru',&cMaeAct->cCodigoGru})
		  AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		  AADD(aCamLog,{'cMatNotLog',SUBS(cCamJuiNot,4,4)})

		  AADD(aCamLog,{'cIndNotLog',&cCamJuiNot})
		  IF !EMPTY(cJuicio)
		     REPL &cCamJuiNot WITH cJuicio

		     IF lHayJnt(TCO->cEvaIndTbl)
			REPL &cCamJntNot WITH cNotInd
		     ENDIF
		  ENDIF
		 *Grabaci¢n de los juicios

		  AADD(aCamLog,{'cIndGraLog',&cCamJuiNot})
		  AADD(aCamLog,{'cMatNoPLog',cCodMat})
		  AADD(aCamLog,{'cIndNoPLog',cJuicio})
		  AADD(aCamLog,{'cDefNotLog',&cCamDefNot})
		  REPL &cCamDefNot WITH;
		       STUFF(&cCamDefNot,nNroBis*4-3,4,cNotDef)
		 *Grabaci¢n de la nota
		  AADD(aCamLog,{'cDefGraLog',&cCamDefNot})
		  AADD(aCamLog,{'cDefNoPLog',cNotDef})

		  REPL &cCamFalNot WITH;
		       STUFF(&cCamFalNot,nNroBis*2-1,2,cFallas)
		 *Grabaci¢n de las fallas

		  NOT->(DBCOMMIT())
		  cTxtLog := 'Si Procesado'
		  AADD(aCamLog,{'cObservLog',cTxtLog})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog,lGraLog)

	       ELSE
		  cError('NO SE PUEDE GRABAR LAS NOTAS')
	       ENDIF

	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF
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

/*************************************************************************
* TITULO DE LA FUNCION..: LEER NOTAS CON BASE EN EL PROFESOR             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/98 MIE A
       Colombia, Bucaramanga        INICIO: 09:40 AM   MAR 11/98 MIE

OBJETIVOS:

1- Leer las notas del profesor con base en el archivo de notas del
   profesor

2- Retorna .F. si se presentaron problemas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeerxNoP(lShared,cNomSis,nFilPal,cNomUsr,cAnoUsr,;
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
       cCodMat		                    // C¢digo de la Materia
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
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL cMenTxt := ''                  // Texto variable

       LOCAL cPorcen := ''                  // Porcentaje de la materia
       LOCAL cNotDef := ''                  // Nota definitiva a grabar
       LOCAL cFallas := ''                  // Fallas a grabar
       LOCAL cJuicio := ''                  // Juicios a grabar
       LOCAL cNotInd := ''                  //*Notas del Indicador a grabar
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL cModNot := ''                  // Modificaci¢n de las Notas
       LOCAL nLenCod := 6                   // Longitud del C¢digo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodAreTse := ''               // C¢digo del Area de la Selecion
       LOCAL cSecMatTse := ''               // Secuencial de la materia

       LOCAL cCamBimDef := ''               // Campo fuente notas parciales
       LOCAL cCamDefDef := ''               // Campo fuente nota definitiva
       LOCAL cCamJuiDef := ''               // Campo fuente Juicios
       LOCAL cCamFalDef := ''               // Campo fuente fallas

       LOCAL cCamDefNot := ''               // Campo destino notas definitiva
       LOCAL cCamJuiNot := ''               // Campo destino Juicios
       LOCAL cCamJntNot := ''               //*Campo destino notas de los Juicios
       LOCAL cCamFalNot := ''               // Campo destino fallas

       LOCAL cCamJuiNoP := ''               // Campo Juicio de simaprof
       LOCAL cCamJntNoP := ''               //*Campo notas de los Juicios de simaprof
       LOCAL cCamDefNoP := ''               // Campo Definitiva de simaprof
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		   CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

	  cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL PROFESOR '+;
		     'CON CODIGO '+CAP->cCodigoCar
	  cError(cTxtLog)
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	  CloseDbf('NOT')
	  CloseDbf('NOP')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>REEMPLAZO DE LA MATERIA VARIABLE
       cCodAreTse := SUBS(cCodMat,1,2)
       cSecMatTse := SUBS(cCodMat,3,2)
       IF lMatVarMat(cCodMat,.F.)
	  cCodMat := MAT->cCodigoMat
       ENDIF
*>>>>FIN REEMPLAZO DE LA MATERIA VARIABLE

*>>>>GRABACION DE LAS NOTAS
       cTxtLog := 'GRABANDO LAS NOTAS DE '+ALLTRIM(CAP->cNombreMat)
       nNroFil := nMarco(nFilPal+1,cTxtLog)
       AADD(aCamLog,{'cObservLog',cTxtLog})
       AADD(aCamLog,{'cCodigoGru',cCodGru})
       AADD(aCamLog,{'cMatNoPLog',cCodMat})
       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       SELECT NOP
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    lGrabar := .T.
	    cCodigoTes := NOP->cCodigoEst

	    SELECT &cMaeAct
	    IF lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cTxtLog := 'EL ESTUDIANTE CODIGO: '+cCodigoTes+;
			  'NO EXISTE EN EL MAESTRO'
	       IF lValida
		  cError(cTxtLog)
	       ENDIF
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF lRetiroTes

	       cTxtLog := cNombreTes+'. Retirado. No se leen sus Notas'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			    cFilePlan(cAnoUsr,&cMaeAct->cCodigoGru),;
			    'PLA',NIL,lShared)

	       cTxtLog := 'NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			  cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))
	       cError(cTxtLog)
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       CloseDbf('PLA')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO
	    IF !lMatPlan(lShared,CAP->nTipCarCar,cCodMat,;
			 cCodAreTse+cSecMatTse,cCodGru,.T.,;
			 aGenLog,cAliasL)

	       CloseDbf('PLA')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO

**********VALIDACION SI EL PROFESOR DICTA LA MATERIA
	    IF !lDictada(lShared,PRO->cCodigoPro,PRO->cNombrePro,;
			 MAT->cCodigoMat,MAT->cNombreMat,;
			 cCodGru,.T.,NIL,aGenLog,cAliasL)


	       cTxtLog := 'LA MATERIA ESTA CORRECTA?. '+;
			  'DESEA GRABAR SUS NOTAS? No Si'
	       IF !lPregunta(cTxtLog)
		  AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: No'})
		  AADD(aCamLog,{'cCodigoEst',cCodigoTes})
		  AADD(aCamLog,{'cCodigoGru',cCodGru})
		  AADD(aCamLog,{'cMatNoPLog',cCodMat})
		  AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		  CloseDbf('PLA')
		  SELECT NOP
		  NOP->(DBSKIP())
		  LOOP
	       ENDIF
	       AADD(aCamLog,{'cObservLog',cTxtLog+' Rta: Si'})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDIF
**********FIN VALIDACION SI EL PROFESOR DICTA LA MATERIA

**********ASIGNACION DE LA MATERIA A GRABAR
	    IF PLA->cTipArePla == 'N'
	       cCamDefNot := 'cAreN'+SUBS(cCodMat,1,2)+"Not"
	       cCamJuiNot := 'cJ'+STR(nNroBis,1)+cCodMat+"Not"
	       cCamFalNot := 'cFa'+cCodMat+"Not"

	       IF lHayJnt(TCO->cEvaIndTbl)
		  cCamJntNot := 'cN'+STR(nNroBis,1)+cCodMat+"Not"
	       ENDIF
	    ELSE
	       cPorcen := IF(PLA->nPorcenPla == 0,;
			     '100','0'+STR(PLA->nPorcenPla,2))
	       cCamDefNot := 'cNt'+cCodMat+cPorcen
	       cCamJuiNot := 'cJ'+STR(nNroBis,1)+cCodMat+"Not"
	       cCamFalNot := 'cFa'+cCodMat+"Not"

	       IF lHayJnt(TCO->cEvaIndTbl)
		  cCamJntNot := 'cN'+STR(nNroBis,1)+cCodMat+"Not"
	       ENDIF
	    ENDIF

	    cCamJuiNoP := 'cIndic'+STR(nNroBis,1)+'NoP'
	    cCamDefNoP := 'cDefin'+STR(nNroBis,1)+'NoP'

	    IF lHayJnt(TCO->cEvaIndTbl)
	       cCamJntNoP := 'cIndnt'+STR(nNroBis,1)+'NoP'
	    ENDIF
**********FIN ASIGNACION DE LA MATERIA A GRABAR

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			'NT'+&cMaeAct->cCodigoGru+cAnoSis+ExtFile,;
			'NOT',NIL,lShared)

	       cTxtLog := 'ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
			   &cMaeAct->cCodigoGru
	       cError(cTxtLog)
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       CloseDbf('NOP')
	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION SI EXISTEN NOTAS GRABADAS
	    IF lValNot
	       IF lHayNot(lShared,cCamDefNot,cCamJuiNot,nNroBis,;
			  MAT->cNombreMat,lValida,aGenLog,cAliasL)
		  CloseDbf('NOP')
		  CloseDbf('PLA')
		  CloseDbf('NOT')
		  RETURN .F.
	       ENDIF
	    ENDIF
**********FIN VALIDACION SI EXISTEN NOTAS GRABADAS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('PROFESOR: '+ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)+;
			 'ºGRUPO: '+&cMaeAct->cCodigoGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			  NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LECTURA DE LA NOTA A GRABAR
	    SELECT NOP
	    cNotDef := &cCamDefNoP
	    cFallas := SUBS(NOP->cFallasNoP,nNroBis*2-1,2)

	    cJuicio := &cCamJuiNoP
	    cModNot := SUBS(cJuicio,121,5)
	    cJuicio := SUBS(cJuicio,1,120)

	    cJuicio := cJuicio+cModNot

	    IF lHayJnt(TCO->cEvaIndTbl)
	       cNotInd := &cCamJntNoP
	    ENDIF
**********FIN LECTURA DE LA NOTA A GRABAR

**********VALIDACION DEL RETIRO DE LA LISTA
	    IF NOP->lRetiroNop .AND. EMPTY(cJuicio)

	       cTxtLog := cNombreTes+'. Retirado de Lista. '+;
			  'No tienen indicadores'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL RETIRO DE LA LISTA



**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)

	       cTxtLog := 'ESTUDIANTE:'+NOP->cCodigoEst+' '+;
			  'GRUPO:'+&cMaeAct->cCodigoGru+' '+;
			  'PROFE: '+PRO->cCodigoPro+' '+PRO->cNombrePro
	       IF lValida
		  cError(cTxtLog)
	       ENDIF
	       cTxtLog := cNombreTes+'. NO EXISTE EN NOTAS'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********BUSQUEDA DE LA PRIMERA SELECCION
	    IF !lSekCodigo(NOP->cCodigoEst+cCodAreTse,'SEL')

	       cTxtLog := 'COD:'+NOP->cCodigoEst+' '+;
			  'GRUPO: '+&cMaeAct->cCodigoGru+' '+;
			  'PROF: '+PRO->cCodigoPro+' '+;
			  'NO APARECE CLASIFICADO. AREA: '+cCodAreTse

	       IF lValida
		  cError(cTxtLog)
	       ENDIF
	       cTxtLog := cNombreTes+'. NO APARECE CLASIFICADO'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDIF
**********FIN BUSQUEDA DE LA PRIMERA SELECCION

**********ANALISIS DE LA SELECCION PARA MATERIAS FIJAS
	    IF MAT->nMatVarMat == 0
	       IF !EMPTY(SUBS(SEL->cSecMatSel,nNroBis*2-1,2))

		  IF SUBS(SEL->cSecMatSel,nNroBis*2-1,2) # cSecMatTse

		     cTxtLog := 'PARA '+cNombreTes+ ' APARECE OTRA SELECCION'
		     cError(cTxtLog)
		     AADD(aCamLog,{'cObservLog',cTxtLog})
		     AADD(aCamLog,{'cCodigoEst',cCodigoTes})
		     AADD(aCamLog,{'cCodigoGru',cCodGru})
		     AADD(aCamLog,{'cMatNoPLog',cCodMat})
		     AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		     AADD(aCamLog,{'cMatNotLog',SEL->cCodAreSel+;
				   SUBS(SEL->cSecMatSel,nNroBis*2-1,2)})
		     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		     cTxtLog := 'DESEA REEMPLAZAR LA SELECCION? No Si'
		     IF lPregunta(cTxtLog)

			cTxtLog := cTxtLog+'SI REEMPLAZO LA SELECCION'
			AADD(aCamLog,{'cObservLog',cTxtLog})
			AADD(aCamLog,{'cCodigoEst',cCodigoTes})
			AADD(aCamLog,{'cCodigoGru',cCodGru})
			AADD(aCamLog,{'cMatNoPLog',cCodMat})
			AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
			aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		     ELSE
			cTxtLog := cTxtLog+'NO REEMPLAZO LA SELECCION'
			AADD(aCamLog,{'cObservLog',cTxtLog})
			AADD(aCamLog,{'cCodigoEst',cCodigoTes})
			AADD(aCamLog,{'cCodigoGru',cCodGru})
			AADD(aCamLog,{'cMatNoPLog',cCodMat})
			AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
			aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
			lGrabar := .F.
		     ENDIF
		  ENDIF

	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA SELECCION PARA MATERIAS FIJAS

**********LOCALIZACION DE LA SELECION DE LA MATERIA SELECTIVA
	    IF MAT->nMatVarMat == 1
	       IF SEL->cSecProSel # cSecMatTse

		  SELECT SEL
		  LOCATE FOR SEL->cCodigoEst == NOP->cCodigoEst .AND.;
			     SEL->cSecProSel == cSecMatTse

		  DO WHILE .T.
		     IF .NOT. SEL->(EOF())
			IF SEL->(FOUND())
			   EXIT
			ELSE
			   CONTINUE
			ENDIF
		     ELSE
			cMenTxt := 'ESTUDIANTE:'+NOP->cCodigoEst+' '+;
				   'GRUPO: '+&cMaeAct->cCodigoGru+' '+;
				   'PROF: '+PRO->cCodigoPro+' '+;
				   'NO APARECE CLASIFICADO'
			IF lValida
			   cError(cMenTxt)
			ENDIF

			cTxtLog := 'No Procesado. NO APARECE CLASIFICADO'
			AADD(aCamLog,{'cObservLog',cTxtLog})
			AADD(aCamLog,{'cCodigoEst',cCodigoTes})
			AADD(aCamLog,{'cCodigoGru',cCodGru})
			AADD(aCamLog,{'cMatNoPLog',cCodMat})
			AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})

			aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog,lGraLog)
			lGrabar := .F.
			EXIT
		     ENDIF
		  ENDDO
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DE LA SELECION DE LA MATERIA SELECTIVA

**********VALIDACION DE JUICIOS VACIOS
	    SELECT NOT
	    IF !NOP->lRetiroNop .AND. EMPTY(cJuicio) .AND. EMPTY(cNotDef)

	       cTxtLog := 'No Procesado. INDICADORES Y NOTA VACIOS'
	       AADD(aCamLog,{'cObservLog',cTxtLog})
	       AADD(aCamLog,{'cCodigoEst',cCodigoTes})
	       AADD(aCamLog,{'cCodigoGru',cCodGru})
	       AADD(aCamLog,{'cMatNoPLog',cCodMat})
	       AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
	       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog,lGraLog)

	       lGrabar := .F.
	    ENDIF
**********FIN VALIDACION DE JUICIOS VACIOS

**********ANALISIS DE LA GRABACION
	    IF lValida .AND. !lGrabar
	       cError('NO SE GRABAN LAS NOTAS DE '+cNombreTes+' '+;
		      'CODIGO: '+cCodigoTes)
	    ENDIF
**********FIN ANALISIS DE LA GRABACION

**********GRABACION DE LA SELECCION
	    IF lGrabar
	       IF SEL->(lRegLock(lShared,.F.))
		  REPL SEL->cCodAreSel WITH cCodAreTse
		  REPL SEL->cSecMatSel WITH;
		       STUFF(SEL->cSecMatSel,nNroBis*2-1,2,cSecMatTse)
		  SEL->(DBCOMMIT())

		  AADD(aCamLog,{'cCodigoEst',NOP->cCodigoEst})
		  AADD(aCamLog,{'cCodigoGru',&cMaeAct->cCodigoGru})
		  AADD(aCamLog,{'cCodAreSel',SEL->cCodAreSel})
		  AADD(aCamLog,{'cSecMatSel',SEL->cSecMatSel})
		  AADD(aCamLog,{'cSecProSel',SEL->cSecProSel})

	       ELSE
		  cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	       ENDIF
	       IF lShared
		  SEL->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DE LA SELECCION

**********GRABACION DE LA NOTA DEFINITIVA
	    SELECT NOT
	    IF lGrabar
	       IF NOT->(lRegLock(lShared,.F.))

		  AADD(aCamLog,{'cCodigoPro',PRO->cCodigoPro})
		  AADD(aCamLog,{'cMatNotLog',SUBS(cCamJuiNot,4,4)})

		  AADD(aCamLog,{'cIndNotLog',&cCamJuiNot})
		  REPL &cCamJuiNot WITH cJuicio
		 *Grabaci¢n de los juicios

		  IF lHayJnt(TCO->cEvaIndTbl)
		     REPL &cCamJntNot WITH cNotInd
		  ENDIF
		 *Grabaci¢n de las notas de los indicadores.

		  AADD(aCamLog,{'cIndGraLog',&cCamJuiNot})
		  AADD(aCamLog,{'cMatNoPLog',cCodMat})
		  AADD(aCamLog,{'cIndNoPLog',cJuicio})

		  AADD(aCamLog,{'cDefNotLog',&cCamDefNot})
		  REPL &cCamDefNot WITH;
		       STUFF(&cCamDefNot,nNroBis*4-3,4,cNotDef)
		 *Grabaci¢n de la nota
		  AADD(aCamLog,{'cDefGraLog',&cCamDefNot})
		  AADD(aCamLog,{'cDefNoPLog',cNotDef})

		  REPL &cCamFalNot WITH;
		       STUFF(&cCamFalNot,nNroBis*2-1,2,cFallas)
		 *Grabaci¢n de las fallas

		  NOT->(DBCOMMIT())

		  cTxtLog := 'Si Procesado'
		  AADD(aCamLog,{'cObservLog',cTxtLog})
		  aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog,lGraLog)

	       ELSE
		  cError('NO SE PUEDE GRABAR LAS NOTAS')
	       ENDIF

	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF
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
	    SELECT NOP
	    SKIP
	    CloseDbf('NOT')
	    CloseDbf('PLA')
**********FIN AVANCE AL SIGUIENTE ALUMNO

       ENDDO
       CloseDbf('NOP')
       CloseDbf('NOT')
       CloseDbf('PLA')
       RETURN .T.
*>>>>FIN GRABACION DE LAS NOTAS