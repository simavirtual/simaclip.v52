/* SIMA - CONTABILIDAD PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: INDICE

**************************************************************************
* TITULO..: VALIDA LOS INDICES DE CUMPLIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 29/2002 LUN A
       Colombia, Bucaramanga        INICIO: 06:00 PM   ABR 29/2002 LUN

OBJETIVOS:

1- Actualiza la ubicaci¢n de los c¢digos de los indicadores para permitir
   el control de las recuperaciones.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_747(aP1,aP2,aP3)

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

       LOCAL nTotPer := 0                   // Total de Periodos
       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL lTodos  := .F.                 // .T. Procesar todos

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor

       LOCAL GetList := {}                  // Variable del sistema
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
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // C¢digo del Profesor
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
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeact+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE LOGOS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nTotPer := TCO->nTotPerTbl
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,5)
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
	  lTodos := lPregunta('DESEA ACTUALIZAR TODOS LOS PROFESORES? No Si')
	  IF !lTodos
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       CloseDbf('TCO')
*>>>>FIN LECTURA DEL USUARIO PROFESOR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis+'\',cMaeAct,cAnoSis)
	  cError('ABRIENDO ARCHIVO MAESTRO DE ALUMNOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ACTUALIZACION DEL REGISTRO
       SELECT PRO
       IF lTodos
	  PRO->(DBGOTOP())
       ENDIF
*>>>>FIN ACTUALIZACION DEL REGISTRO

*>>>>ACTUALIZACION DE LAS ESTRUCTURAS
       SET PRINTER  TO &cMaeAct             // Archivo salida impresora
       DO WHILE .T.

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PROF:'+ALLTRIM(PRO->cApelliPro)+;
			'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				STR(PRO->(RECCOUNT()),4),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LECTURA DEL PATH DEL PROFESOR
	    IF lTodos
*	       cPatPro := 'c:\'+cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
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

/*
**********REVISION DE LOS ESTUDIANTES
	    RevisarEst(lShared,cNomSis,cAnoUsr,;
		       cPatPro,PathUno+'\'+cPatSis,cMaeAct)
**********FIN REVISION DE LOS ESTUDIANTES
*/

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO CARGAS DEL PROFESOR')
	       CLOSE ALL
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
		 LineaEstado('PROF:'+PRO->cApelliPro+;
			     'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				     STR(PRO->(RECCOUNT()),4)+;
			     'ºGRUPO:'+SUBS(CAP->cCodigoCar,5,4)+;
			     'ºNo. '+STR(CAP->(RECNO()),4)+'/'+;
				     STR(CAP->(RECCOUNT()),4),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ACTUALIZACION DE LA ESTRUCTURA
		 IF FILE(cPatPro+'\'+CAP->cCodigoCar+ExtFile) .AND.;
		    SUBS(CAP->cCodigoCar,1,4) # '4000'
		    ValIndCum(lShared,cAnoUsr,cPatSis,;
			      PathUno,cPatPro,nNroPer,nTotPer,cMaeAct)
		 ENDIF
*--------------FIN ACTUALIZACION DE LA ESTRUCTURA

	       SELECT CAP
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
       CLOSE ALL
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LAS ESTRUCTURAS

/*************************************************************************
* TITULO..: ACTUALIZACION DE CODIGOS APLICADOS                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 29/2002 LUN A
       Colombia, Bucaramanga        INICIO: 06:15 PM   ABR 29/2002 LUN

OBJETIVOS:

1- Actualiza los c¢digos aplicados para permitir el control de las
   recuperaciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValIndCum(lShared,cAnoUsr,cPatSis,PathUno,;
		   cPatPro,nNroPer,nTotPer,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       PathUno                              // Path Integraci¢n Uno
       cPatPro                              // Path del Profesor
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodos
       cMaeAct                              // Maestro Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL cCamDef := ''                  // Campo de definitivas
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cLogros := ''                  // Logros
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cCodRec := ''                  // C¢digo de la Recuperaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL nTipPla := 0                   // Tipo del Plan
       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
       LOCAL lJvfCal := .F.                 // .T. Juicio Valorativo Calculado

       LOCAL lMatVar := .F.                 // .T. Materia Variable
       LOCAL lEstNot := .F.                 // .T. Estudiante en Notas
       LOCAL cIndic1 := ''                  // Indicadores del Periodo No.1
       LOCAL cIndic2 := ''                  // Indicadores del Periodo No.2
       LOCAL cIndic3 := ''                  // Indicadores del Periodo No.3
       LOCAL cIndic4 := ''                  // Indicadores del Periodo No.4
       LOCAL cIndic5 := ''                  // Indicadores del Periodo No.5
       LOCAL aCodInd := {}                  // C¢digos de Indicadores

       LOCAL cCamIndNot := ''               // Campo Indicadores en Notas
       LOCAL cCamNtINot := ''               // Campo de Nota de Indicadores
       LOCAL cCamNotDef := ''               // Campo Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo Notas de Recuperaci¢n
     *ÀVariables de Campos de Notas en Contabilidad

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL TIPO DE PLAN ACADEMICO
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTma := MAT->cCodigoMat
       nTipPla := 0
       IF !('XXXX' $ cCodigoTgr)
	  nTipPla := nTipoPlan(SUBS(cCodigoTgr,1,2))
	  IF nTipPla == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
	  IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)
	     cError('ABRIENDO ARCHIVO DEL PLAN DE ESTUDIOS')
	     CloseDbf('PLA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS DE DECISION
       lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))

       cCodigoTma := MAT->cCodigoMat
       lMatVar := lMatVarMat(cCodigoTma,.F.)
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO '+cPatPro)
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NOP->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRUPO.:'+SUBS(CAP->cCodigoCar,5,4)+' '+;
				     ALLTRIM(CAP->cNombreMat),22)
       @ nNroFil,01 SAY 'No.'
       @ nNroFil,04 SAY 'CODIGO'
       @ nNroFil,11 SAY 'JVF'
       @ nNroFil,15 SAY 'VAL'
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ACTUALIZACION DE LOS CODIGOS
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'

       SELECT NOP
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********VISUALIZACION DEL CODIGO DEL ESTUDIANTE
	    @ nNroFil,01 SAY STR(NOP->(RECNO()),2,0)
	    @ nNroFil,04 SAY NOP->cCodigoEst
**********FIN VISUALIZACION DEL CODIGO DEL ESTUDIANTE

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)

	       SET DEVICE TO PRINT
	       @ PROW()+1,00 SAY PRO->cCodigoPro+' '+CAP->cCodigoCar+' '+;
				 NOP->cCodigoEst+'-'+;
				 ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
				 'NO EXISTE EL CODIGO EN EL MAE'
	       SET DEVICE TO SCREEN

	    ENDIF
	    lRetiroTno := NOP->lRetiroNoP
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
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
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS DE FUERA DE LISTA
	    IF lRetiroTno
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********LOCALIZACION DEL GRUPO
	    IF !lLocCodigo('cCodigoGru','GRU',&cMaeAct->cCodigoGru)
	       cError('EL GRUPO '+&cMaeAct->cCodigoGru+' NO EXISTE')
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
	    cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)
	    cJvfCal := IF(MAT->lJvfCalMat,SPACE(03),cJvfCal)
	    lJvfCal := IF(EMPTY(cJvfCal),.F.,.T.)
**********FIN LOCALIZACION DEL GRUPO

**********CAMPO DE INDICADORES EN NOTAS
	    cIndic1 := NOP->cIndic1NoP
	    cIndic2 := NOP->cIndic2NoP
	    cIndic3 := NOP->cIndic3NoP
	    cIndic4 := NOP->cIndic4NoP
	    cIndic5 := NOP->cIndic5NoP

	    // Indice de Cumplimiento
	    IF lJvfCal .AND. (cJvfCal == '102' .OR. cJvfCal == '103')

*==============LECTURA DE LOS CAMPOS DE NOTAS
		 cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
					  PathUno+'\'+cPatSis,nNroPer,;
					  &cMaeAct->cCodigoGru,;
					  cCodigoTma,lMatVar,;
					  @cCamNotDef,@cCamNotRec,;
					  @cCamNtINot)
*==============FIN LECTURA DE LOS CAMPOS DE NOTAS

*===============LOCALIZACION DEL ESTUDIANTE EN NOTAS
		  lEstNot := lLocCodigo('cCodigoEst','NOT',cCodigoTes)
		  IF !lEstNot
		     cError('EL CODIGO:'+cCodigoTes+' NO EXISTE EN '+;
			    'NOTAS DEL GRUPO:'+&cMaeAct->cCodigoGru)
		  ENDIF
*===============FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

*===============CAMPO DE INDICADORES
		  IF lEstNot

		     FOR j := 1 TO 5

			 cCamIndNot := STUFF(cCamIndNot,8,1,STR(j,1))
			*Campo para cade periodo

			 DO CASE
			 CASE j == 1

			      IF nNroPer == 1
				 cIndic1 := &cCamInd
			      ELSE
                                 cIndic1 := &cCamIndNot
			      ENDIF

			 CASE j == 2

			      IF nNroPer == 2
				 cIndic2 := &cCamInd
			      ELSE
				 cIndic2 := &cCamIndNot
			      ENDIF

			 CASE j == 3

			      IF nNroPer == 3
				 cIndic3 := &cCamInd
			      ELSE
				 cIndic3 := &cCamIndNot
			      ENDIF

			 CASE j == 4

			      IF nNroPer == 4
				 cIndic4 := &cCamInd
			      ELSE
				 cIndic4 := &cCamIndNot
			      ENDIF

			 CASE j == 5

			      IF nNroPer == 5
				 cIndic5 := &cCamInd
			      ELSE
				 cIndic5 := &cCamIndNot
			      ENDIF

			 ENDCASE

		     ENDFOR

		  ENDIF
		  CloseDbf('NOT')
*===============FIN CAMPO DE INDICADORES

	    ENDIF
**********FIN CAMPO DE INDICADORES EN NOTAS

**********INDICADORES DUPLICADOS
	    aCodInd := {}
	    IF lndDuplica(cIndic1,cIndic2,cIndic3,cIndic4,cIndic5,aCodInd)
	       FOR i := 1 TO LEN(aCodInd)

		   IF aCodInd[i,4] == nNroPer .AND. aCodInd[i,3] > 1

		      SET DEVICE TO PRINT
		      @ PROW()+1,00 SAY STR(aCodInd[i,4],1)+':: '+PRO->cCodigoPro+' '+;
					CAP->cCodigoCar+' '+;
					aCodInd[i,2]+' '+;
					NOP->cCodigoEst+'-'+;
					ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
					CAP->cNombreMat
		      SET DEVICE TO SCREEN

		   ENDIF

	       ENDFOR
	    ENDIF
**********FIN INDICADORES DUPLICADOS

**********VALIDACION DEL INDICE DE CUMPLIMIENTO
	    cNotDef := cJvfCal103(cIndic1,;
				  cIndic2,;
				  cIndic3,;
				  cIndic4,;
				  cIndic5,;
				  nNroPer,nTotPer)+SPACE(03)
	  *ÀIndice de Cumplimiento. La Salle Bucaramaga. Variable
**********FIN VALIDACION DEL INDICE DE CUMPLIMIENTO

**********VALIDACION DEL JVF
	    IF ALLTRIM(cNotDef) == ALLTRIM(&cCamDef)
	       @ nNroFil,11 SAY cNotDef
	       @ nNroFil,15 SAY ALLTRIM(&cCamDef)
	    ELSE
	       SET DEVICE TO PRINT
	       @ PROW()+1,00 SAY PRO->cCodigoPro+' '+CAP->cCodigoCar+' '+;
			       ALLTRIM(&cCamDef)+' '+;
			       ALLTRIM(cNotDef)+' '+;
			       NOP->cCodigoEst+'-'+ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
			       CAP->cNombreMat
	       SET DEVICE TO SCREEN
	    ENDIF
**********FIN VALIDACION DEL JVF

**********VALIDACION DE LOS INDICADORES
	    cLogros := &cCamInd

	    FOR i := 1 TO 20

*===============LECTURA DE LOS INDICADORES
		  cCodLog := SUBS(cLogros,i*6-5,6)
		  cCodCla := SUBS(cCodLog,1,1)
		  cCodEva := SUBS(cCodLog,5,1)
		  cCodRec := SUBS(cCodLog,6,1)

		  IF EMPTY(SUBS(cCodLog,1,4))
		     LOOP
		  ENDIF
*===============FIN LECTURA DE LOS INDICADORES

*===============VALIDACION CLASE DE INDICADORES
		  IF !lLocCodigo('cCodigoCla','CLA',cCodCla)

		     @ nNroFil,25 SAY cCodLog
		     SET DEVICE TO PRINT
		     @ PROW()+1,00 SAY PRO->cCodigoPro+' '+;
				       CAP->cCodigoCar+' '+;
				       cCodLog+' '+;
				       NOP->cCodigoEst+'-'+;
				       'CLASE DE INDICADOR NO EXISTE'+' '+;
				       CAP->cNombreMat

		  ENDIF
		  IF UPPER(CLA->cFormulCla) # 'I'  // Indicador
		     LOOP
		  ENDIF
*===============FIN VALIDACION CLASE DE INDICADORES

*===============VALIDACION DE LOS INDICADORES
		  IF nNroPer # 5
		     lHayErr := .T.
		     DO CASE
*		     CASE cCodCla == '6' // Borrar

		     CASE cCodEva == SPACE(01)

		     OTHERWISE
			  lHayErr :=.F.
		     ENDCASE
		  ENDIF

		  IF lHayErr
		     @ nNroFil,25 SAY cCodLog
		     SET DEVICE TO PRINT
		     @ PROW()+1,00 SAY PRO->cCodigoPro+' '+;
				       CAP->cCodigoCar+' '+;
				       cCodLog+' '+;
				       NOP->cCodigoEst+'-'+;
				       ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
				       CAP->cNombreMat
		     SET DEVICE TO SCREEN
		     EXIT
		  ENDIF
*===============FIN VALIDACION DE LOS INDICADORES

	    ENDFOR
**********FIN VALIDACION DE LOS INDICADORES

**********INCREMENTO DE LAS FILAS
	    @ nNroFil,11 SAY cNotDef
	    nNroFil++
	    IF nNroFil > 21
	       nNroFil := nMarco(03,'GRUPO:'+SUBS(CAP->cCodigoCar,5,4)+' '+;
				      ALLTRIM(CAP->cNombreMat),22)
	       @ nNroFil,01 SAY 'No.'
	       @ nNroFil,04 SAY 'CODIGO'
	       @ nNroFil,11 SAY 'ESTADO'
	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

	  NOP->(DBSKIP())

       ENDDO
       CloseDbf('NOP')
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS CODIGOS

/*************************************************************************
* TITULO..: CODIGOS DUPLICADOS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 01/2009 MAR A
       Colombia, Bucaramanga        INICIO: 08:30 AM   SEP 01/2009 MAR

OBJETIVOS:

1- Valida los c¢digos de la estructura de logros e indicadores que se
   encuentran duplicados.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lndDuplica(cIndic1,cIndic2,cIndic3,cIndic4,cIndic5,aCodInd)

*>>>>DESCRIPCION DE PARAMETROS
/*     cIndic1                              // Indicadores del periodo No.1
       cIndic2                              // Indicadores del periodo No.2
       cIndic3                              // Indicadores del periodo No.3
       cIndic4                              // Indicadores del periodo No.4
       cIndic5                              // Indicadores del periodo No.5
       aCodInd                              // C¢digos de Indicadores */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL   i,j,k := 0                   // Contador
       LOCAL cIndica := ''                  // Indicadores
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cCodInd := ''                  // C¢digo del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS CODIGOS
       FOR j := 1 TO 5

	   DO CASE
	   CASE j == 1
		cIndica := cIndic1

	   CASE j == 2
		cIndica := cIndic2

	   CASE j == 3
		cIndica := cIndic3

	   CASE j == 4
		cIndica := cIndic4

	   CASE j == 5
		cIndica := cIndic5

	   ENDCASE

	   IF EMPTY(cIndica)
	      LOOP
	   ENDIF

	   FOR i := 1 TO 20

	       cCodLog := SUBS(cIndica,i*6-5,6)
	       cCodInd := SUBS(cCodLog,1,4)

	       IF EMPTY(cCodLog)
		  LOOP
	       ENDIF

	       IF SUBS(cCodLog,1,1) == 'R' .OR.;
		  SUBS(cCodLog,1,1) == '4' .OR.;
		  SUBS(cCodLog,1,1) == '7' .OR.;
		  SUBS(cCodLog,1,1) == '8' .OR.;
		  SUBS(cCodLog,1,1) == '9'
		  LOOP
	       ENDIF

	       k := ASCAN(aCodInd,{|aArr|aArr[1] == cCodInd})
	       IF k == 0
		  AADD(aCodInd,{cCodInd,STR(j,1)+':'+cCodLog,1,j})
	       ELSE
		  lHayErr := .T.
		  aCodInd[k,2] += STR(j,1)+':'+cCodLog
		  aCodInd[k,3]++
		  IF j > aCodInd[k,4]
		     aCodInd[k,4] := j
		  ENDIF
	       ENDIF
	     *ÀIndicadores duplicados

	   ENDFOR

       ENDFOR
       RETURN lHayErr
*>>>>FIN LECTURA DE LOS CODIGOS

