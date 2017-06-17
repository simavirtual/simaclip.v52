/* SIMA - CONTABILIDAD PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR. RECALCULAR

**************************************************************************
* TITULO..: RECALCULA LAS NOTAS DE LAS RECUPERACIONES                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2007 LUN A
       Colombia, Bucaramanga        INICIO: 01:20 PM   NOV 19/2007 LUN

OBJETIVOS:

1- Caso No.1 San Bernardo. Error no se actualizo la nota de las
   recuperaciones.

2- Permite calcular la nota definitiva de la recuperaciones y actualiza
   en simaprof y simacont.

3- La nota de la recuperaci¢n de calcula de la nota de recuperaci¢n
   de cada indicador.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_743(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL lTodos  := .F.                 // .T. Procesar todos

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nNroPer := 0                   // N£mero del periodo

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el Indicador
       LOCAL cEvaInd := ''                  // Evaluar el Indicador
       LOCAL lNotNum := .F.                 // .T. Nota N£merica .F. Nota Cualitativa
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL lRecNot := .F.                 // .T. Recuperar Nota

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura

       LOCAL cLogNot := ''                  // Logros de Notas
       LOCAL cNotInd := ''                  // Nota de los Indicadores
       LOCAL cNotDef := ''                  // Nota Definitiva en Notas
       LOCAL cNotRec := ''                  // Nota Recuperaci¢n en Notas

       LOCAL cLogNoP := ''                  // Logros de Notas del Profesor
       LOCAL cNtINoP := ''                  // Nota de los Indicadores en Profesor
       LOCAL cNoPDef := ''                  // Nota Definitiva en Profesor
       LOCAL cNoPRec := ''                  // Nota Recuperaci¢n en Notas

       LOCAL cCodNtI := ''                  // C¢digo Nota de Indicadores
       LOCAL cRecNtI := ''                  // Nota de recuperaci¢n del Indicador
       LOCAL nTotNot := 0                   // Total notas
       LOCAL nNroInd := 0                   // N£mero de Indicadores

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo

       LOCAL lMatSelTma := .F.              // .T. Materia Selectiva
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL nTipCarTca := 0                // Tipo de carga

       LOCAL cCamIndNot := ''               // Campo Indicadores en Notas
       LOCAL cCamNtINot := ''               // Campo de Nota de Indicadores
       LOCAL cCamNotDef := ''               // Campo Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo Notas de Recuperaci¢n

       LOCAL cCamIndNoP := ''               // Campo Indicadores en Notas Profesor
       LOCAL cCamNtINop := ''               // Campo de Nota de Indicadores
       LOCAL cCamNoPDef := ''               // Campo Nota Definitvia en Notas Profesor
       LOCAL cCamNoPRec := ''               // Campo Nota Recuperaci¢n en Notas Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // .T. SimaProf en Usb. .F. SimaProf en la Red
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)              .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FProTbl+cMaeAct+ExtFile,'TPR',NIL,lShared)
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
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES DE LA CONTABILIDAD')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE LOGROS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>LECTURA DEL USUARIO PROFESOR
       cSavPan := SAVESCREEN(0,0,24,79)
       cPatPro := cUsrPro(lShared,cNomSis,cPatSis,cNomUsr,cAnoUsr,cMaeAct,;
			  lMemUsb,@cCodigoTpr,@cNomPro,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       lTodos := .F.
       IF EMPTY(cPatPro)
	  lTodos := lPregunta('DESEA CORREGIR TODOS LOS PROFESORES? No Si')
	  IF !lTodos
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL USUARIO PROFESOR

*>>>>ACTUALIZACION DEL REGISTRO
       SELECT PRO
       IF lTodos
	  PRO->(DBGOTOP())
       ENDIF
*>>>>FIN ACTUALIZACION DEL REGISTRO

*>>>>RECORRIDO POR PROFESORES
       DO WHILE .T.

**********LINEA DE ESTADO
	    LineaEstado('CODIGO:'+PRO->cCodigoPro+;
			'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				STR(PRO->(RECCOUNT()),4),cNomSis)
**********FIN LINEA DE ESTADO

**********LECTURA DEL PATH DEL PROFESOR
	    IF lTodos
	       cPatPro := cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
	    ENDIF
**********FIN LECTURA DEL PATH DEL PROFESOR

**********VALIDACION DE EXISTENCIA
	    IF !FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE EXISTENCIA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO CARGAS DEL PROFESOR')
	       CloseAll()
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAP->(RECCOUNT()) == 0
		 cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR '+;
			'CODIGO: '+PRO->cCodigoPro)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CAP')
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********ACTUALIZACION DE LOS ARCHIVOS DE LA CARGA ACADEMICA
	    SELECT CAP
	    GO TOP
	    DO WHILE .NOT. CAP->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('CODIGO:'+PRO->cCodigoPro+;
			     'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				     STR(PRO->(RECCOUNT()),4)+;
			     'ºARCHIVO:'+CAP->cCodigoCar+ExtFile+;
			     'ºNo. '+STR(CAP->(RECNO()),4)+'/'+;
				     STR(CAP->(RECCOUNT()),4),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------LOCALIZACION DE LA MATERIA
		 lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))

		 lMatSelTma := MAT->lMatSelMat
		 cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
		 cCodigoTni := SUBS(cCodigoTgr,1,2)
		 cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
		 nTipCarTca := CAP->nTipCarCar
*--------------FIN LOCALIZACION DE LA MATERIA

*--------------CALCULO DEL CAMPO DE INDICADORES DE NOTAS
		 IF !lMatSelTma
		    cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
					     PathUno+'\'+cPatSis,nNroPer,;
					     cCodigoTgr,cCodigoTma,NIL,;
					     @cCamNotDef,@cCamNotRec,;
					     @cCamNtINot)

		    IF EMPTY(cCamIndNot) .OR.;
		       EMPTY(cCamNotDef) .OR. EMPTY(cCamNotRec)
		       CloseAll()
		       RETURN NIL
		    ENDIF

		 ENDIF
		 cCamIndNoP := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
		 cCamNtINoP := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
		 cCamNoPDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
		 cCamNoPRec := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
*--------------FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,cPatPro+'\'+;
				 CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

		    cError('ABRIENDO EL ARCHIVO DE NOTAS DEL DEL PROFESOR '+;
			   CAP->cCodigoCar)
		    CloseAll()
		    RETURN NIL
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------IMPRESION DE LOS ENCABEZADOS
		 nNroFil := nMarco(nFilPal+1,;
				   ALLTRIM(MAT->cNombreMat),22,'°')
		 @ nNroFil,01 SAY 'CODIGO'
		 @ nNroFil,08 SAY 'NOMBRE'
*--------------FIN IMPRESION DE LOS ENCABEZADOS

*--------------LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
		 lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
		 lIndNiv := TCO->lIndNivTbl
		 lRecNot := TCO->lRecNotTbl
		 IF lNotNum
		    cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
		 ELSE
		    cValNot := ALLTRIM(TCO->cValNotTbl)+SPACE(01)
		 ENDIF
*--------------FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*--------------RECORRIDO POR ESTUDIANTES
		 SELECT NOP
		 NOP->(DBGOTOP())
		 DO WHILE .NOT. NOP->(EOF())

*:::::::::::::::::::IMPRESION DE LA LINEA DE ESTADO
		      LineaEstado('PROFE:'+PRO->cCodigoPro+;
				  'ºCODEST:'+NOP->cCodigoEst+;
				  'ºNo. '+STR(NOP->(RECNO()),4)+'/'+;
					  STR(NOP->(RECCOUNT()),4)+;
				  'ºARCHIVO:'+CAP->cCodigoCar+ExtFile+;
				  'ºNo. '+STR(CAP->(RECNO()),4)+'/'+;
					  STR(CAP->(RECCOUNT()),4),cNomSis)
*:::::::::::::::::::FIN IMPRESION DE LA LINEA DE ESTADO

*:::::::::::::::::::BUSQUEDA DEL ESTUDIANTE
		      cCodigoTes := NOP->cCodigoEst
		      IF !lSekCodigo(cCodigoTes,cMaeAct)
			 cNombreTes := 'Estudiante No Existe'
		      ENDIF
		      cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
				   RTRIM(&cMaeAct->cNombreEst)
		      lRetiroTno := NOP->lRetiroNoP
*:::::::::::::::::::FIN BUSQUEDA DEL ESTUDIANTE

*:::::::::::::::::::ANALISIS DEL PERIODO DEL RETIRO
		      lRetiroTes := &cMaeAct->lRetiroEst
		      IF lRetiroTes
			 IF nNroPer <= &cMaeAct->nPerRetEst
			    lRetiroTes := .F.
			 ENDIF
		      ENDIF

		      IF lRetiroTes
			 NOP->(DBSKIP())
			 LOOP
		      ENDIF
*:::::::::::::::::::FIN ANALISIS DEL PERIODO DEL RETIRO

*:::::::::::::::::::CALCULO DEL CAMPO DE INDICADORES DE NOTAS
		      IF lMatSelTma
			 CloseDbf('PLA')
			 CloseDbf('NOT')

			 cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
						  PathUno+'\'+cPatSis,;
						  nNroPer,;
						  &cMaeAct->cCodigoGru,;
						  cCodigoTma,lMatSelTma,;
						  @cCamNotDef,@cCamNotRec,;
						  @cCamNtINot)

			 IF EMPTY(cCamIndNot)
			    LOOP
			 ENDIF

		      ENDIF
*:::::::::::::::::::FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

*:::::::::::::::::::LOCALIZACION DEL ESTUDIANTE EN NOTAS
		      cLogNot := ''
		      cNotInd := ''
		      cNotDef := ''
		      cNotRec := ''

		      IF lLocCodigo('cCodigoEst','NOT',cCodigoTes)

			 cLogNot := &cCamIndNot

			 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			 IF !EMPTY(cNotRec)
			    cNotDef := cNotRec
			 ENDIF

			 IF SUBS(TCO->cEvaIndTbl,nNroPer,1) == '2'
			    cNotInd := &cCamNtINot
			 ENDIF

		      ENDIF
		      IF EMPTY(cLogNot)
*			 cError('NO APARECEN INDICADORES EN NOTAS')
*			 LOOP
		      ENDIF
*:::::::::::::::::::FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

*:::::::::::::::::::LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR
		      cLogNoP := ''
		      cNtINoP := ''
		      cNoPDef := ''
		      cNoPRec := ''

		      IF lLocCodigo('cCodigoEst','NOP',cCodigoTes)

			 cLogNoP := &cCamIndNoP
			 cNtINoP := &cCamNtINoP

			 cNoPDef := &cCamNoPDef
			 cNoPRec := &cCamNoPRec
			 IF !EMPTY(cNoPRec)
			    cNoPDef := cNoPRec
			 ENDIF

		      ENDIF

		      IF EMPTY(cLogNoP)
			 IF lMatSelTma
*			    cError('NO EXISTEN INDICADORES VERIFIQUE '+;
*				   'SI EL ESTUDIANTE FUE TRASLADADO')
			 ELSE
*			    cError('NO EXISTEN INDICADORES APLICADOS PARA EL '+;
*				   'PERIODO No. '+STR(nNroPer,1))
			 ENDIF
*			 LOOP
		      ENDIF
*:::::::::::::::::::FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR

*:::::::::::::::::::CALCULO DE LA NOTA DE RECUPERACION
		      nNroInd := 0
		      nTotNot := 0
		      FOR i := 1 TO 20
			  cCodNtI := SUBS(cNotInd,8*i-7,8)
			  cRecNtI := SUBS(cCodNtI,5,4)
			  IF VAL(cRecNtI) > 0
			     nNroInd++
			     nTotNot += VAL(cRecNtI)
			  ENDIF
		      ENDFOR
		      IF nTotNot > 0
			 cNotDef := STR(nTotNot/nNroInd,4,1)
		      ELSE
			 cNotDef := SPACE(04)
		      ENDIF
*:::::::::::::::::::FIN CALCULO DE LA NOTA DE RECUPERACION

*:::::::::::::::::::GRABACION DE LAS RECUPERACIONES EN NOTAS DEL PROFESOR
IF VAL(cNotDef) > 0
		      SELECT NOP
		      IF NOP->(lRegLock(lShared,.F.))

			 REPLACE &cCamNoPRec WITH cNotDef
			*Grabaci¢n de la nota de Recuperaci¢n

			 NOP->(DBCOMMIT())

		      ELSE
			 cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		      ENDIF
		      IF lShared
			 NOP->(DBUNLOCK())
		      ENDIF
ENDIF
*:::::::::::::::::::FIN GRABACION DE LAS RECUPERACIONES EN NOTAS DEL PROFESOR

*:::::::::::::::::::GRABACION DE LAS RECUPERACIONES EN NOTAS
IF VAL(cNotDef) > 0
		      cNotDef := IF(VAL(cNotDef)==0,SPACE(04),cNotDef)

		      SELECT NOT
		      IF NOT->(lRegLock(lShared,.F.))

			 REPL &cCamNotRec WITH STUFF(&cCamNotRec,nNroPer*4-3,4,cNotDef)
			*Grabaci¢n de la nota de Recuperaci¢n.

			 NOT->(DBCOMMIT())
		      ELSE
			 cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		      ENDIF
		      IF lShared
			 NOT->(DBUNLOCK())
		      ENDIF
ENDIF
*:::::::::::::::::::FIN GRABACION DE LAS RECUPERACIONES EN NOTAS


		    NOP->(DBSKIP())

		 ENDDO
*--------------FIN RECORRIDO POR ESTUDIANTES


	       CAP->(DBSKIP())

	    ENDDO
	    CloseDbf('CAP')
**********FIN ACTUALIZACION DE LOS ARCHIVOS DE LA CARGA ACADEMICA

**********ANALISIS DE DECISION
	    IF !lTodos
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

**********AVANCE DEL REGISTRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       EXIT
	    ENDIF
**********AVANCE DEL REGISTRO

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR PROFESORES