/* SIMA - CONTABILIDAD PROFESORES

MODULO      : CONSULTAS
SUBMODULO...: CARGA ACADEMICA

**************************************************************************
* TITULO..: CONSULTA DE LA CARGA ACADEMICA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/1996 MAR
       Colombia, Bucaramanga        INICIO: 03:00 AM   ABR 22/1996 MAR

OBJETIVOS:

1- Consulta la carga acad‚mica del profesor.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_601(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroFil := 0                   // N£mero de la fila
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
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeACt+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)               .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO APARECEN LAS CARGAS ACADEMICAS DE LOS PROFESORES')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CONSULTA DE LA CARGA ACADEMICA
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilPal+1,cNomPro+' POR FAVOR REVISE SU CARGA '+;
					   'ACADEMICA')
       SELECT CAP
       GO TOP
       DO WHILE .NOT. CAP->(EOF())

**********VISUALIZACION DE LA MATERIA
	    nNroFil++
	    @ nNroFil,01 SAY 'GRUPO '+SUBS(CAP->cCodigoCar,5,4)+;
			     '->'+ALLTRIM(CAP->cNombreMat)+' '+;
			     IF(CAP->nTipCarCar==0,'',;
				IF(CAP->nTipCarCar==1,': POR GRUPO',;
				   IF(CAP->nTipCarCar==2,': POR NIVEL',;
				      IF(CAP->nTipCarCar==3,': POR NIVELES',;
							    ': ERROR'))));
			 PICT "@S77"

	    IF nNroFil == 21
	       cPausa()
	       nNroFil := nMarco(nFilPal+1,cNomPro+;
				 ' POR FAVOR REVISE SU CARGA ACADEMICA')
	    ENDIF
**********FIN VISUALIZACION DE LA MATERIA

	  SELECT CAP
	  CAP->(DBSKIP())

       ENDDO
*>>>>FIN CONSULTA DE LA CARGA ACADEMICA

*>>>>VERIFICACION DE LA CARGA ACADEMICA
       IF lPregunta(cNomPro+' DESEA VERIFICAR LA CARGA ACADEMICA? No Si')

	  IF lCargaOk(lShared,nFilPal,cPatPro,cNomPro)

	     cError('LA CARGA CARGA ACADEMICA'+;
		    ' ESTA CORRECTA DE ACUERDO AL SISTEMA')

	     IF lPregunta('DESEA VALIDAR LOS ESTUDIANTES? No Si')
		RESTSCREEN(0,0,24,79,cSavPan)
		ValCarEst(lShared,nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			  cMaeAct,cPatPro,cNomPro,PathUno+'\'+cPatSis)
	     ENDIF

	  ELSE
	     cError('LA CARGA ACADEMICA ESTA INCORRECTA','POR FAVOR INFORME')
	  ENDIF
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>FIN VERIFICACION DE LA CARGA ACADEMICA

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: VERIFICACION DE LA CARGA ACADEMICA             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/96 MAR
       Colombia, Bucaramanga        INICIO: 03:40 AM   ABR 22/96 MAR

OBJETIVOS:

1- Verifica la carga acad‚mica del profesor con la contabilidad acad‚mica.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lCargaOk(lShared,nFilPal,cPatPro,cNomPro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilPal                              // Fila Inferior Men£ principal
       cPatPro                              // Path del Profesor
       cNomPro                              // Nombre del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL cCodigoTpr := ''               // Codigo del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DE LA CARGA ACADEMICA
       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       SELECT CAR
       SET FILTER TO CAR->cCodigoPro = cCodigoTpr
       GO TOP
       IF EOF()
	  cError('PARA '+cNomPro+' NO EXISTE CARGA ACADEMICA')
	  RETURN .F.
       ENDIF
*>>>>FIN FILTRACION DE LA CARGA ACADEMICA

*>>>>VALIDACION DE LA CARGA ACADEMICA
       nNroFil := nMarco(nFilPal+1,cNomPro+' VERIFICANDO LA CARGA '+;
					   'ACADEMICA')
       DO WHILE .NOT. CAR->(EOF())

**********LOCALIZACION DE LA CARGA EN EL PROFESOR
	    IF !lLocCodigo('cCodigoCar','CAP',CAR->cCodigoCar)
	       RETURN .F.
	    ENDIF
	    FNotPro := CAP->cCodigoCar+ExtFile
**********FIN LOCALIZACION DE LA CARGA EN EL PROFESOR

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+FNotPro,'NOP',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS '+FNotPro)
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DEL CONTENIDO
	    IF NOP->(RECCOUNT()) == 0
	       cError('NO EXISTEN ALUMNOS PARA '+FNotPro)
	       RETURN .F.
	    ENDIF
	    CloseDbf('NOP')
**********FIN VALIDACION DEL CONTENIDO

**********VISUALIZACION DE LA MATERIA
	    nNroFil++
	    @ nNroFil,01 SAY 'GRUPO '+SUBS(CAP->cCodigoCar,5,4)+;
			     '->'+CAP->cNombreMat+'À' PICT "@S77"
	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,cNomPro+;
				 ' VERIFICANDO LA CARGA ACADEMICA')
	    ENDIF
**********FIN VISUALIZACION DE LA MATERIA

	  SELECT CAR
	  SKIP

       ENDDO
       RETURN .T.
*>>>>FIN VALIDACION DE LA CARGA ACADEMICA

/*************************************************************************
* TITULO..: VALIDACION DE LA CARGA POR ESTUDIANTES                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/2003 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 31/2003 VIE

OBJETIVOS:

1- Valida la carga acad‚mica por estudiante

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValCarEst(lShared,nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cMaeAct,;
		   cPatPro,cNomPro,cPatCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor
       cNomPro                              // Nombre del Profesor
       cPatCon			            // Path de Contabilidad */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroPer := 0                   // N£mero de Periodos
       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer)
       IF nNroPer == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervCaP(nFilInf+1,1,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO DE LOS REGISTROS
       SELECT CAP
       GO nRegIni
       DO WHILE CAP->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+;
		      SUBS(CAP->cCodigoCar,5,4))

	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE NOP->(RECCOUNT()) == 0
		 cError('NO EXISTEN ESTUDIANTES DEL GRUPO: '+cCodigoTgr)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********VALIDACION DE LA MATERIA
	    ValidaMat(lShared,cNomUsr,cAnoUsr,nFilPal,cMaeAct,cPatCon,;
		      nNroPer)
**********FIN VALIDACION DE LA MATERIA

	  CAP->(DBSKIP())
	  CloseDbf('NOP')

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS REGISTROS

/*************************************************************************
* TITULO..: VALIDACION DE LA MATERIA NORMAL                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/2003 VIE A
       Colombia, Bucaramanga        INICIO: 09:00 PM   OCT 31/2003 VIE

OBJETIVOS:

1- Valida los estudiantes de la materia normal

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValidaMat(lShared,cNomUsr,cAnoUsr,nFilPal,cMaeAct,cPatCon,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       nFilPal                              // Fila Principal
       cMaeAct                              // Maestro Actual
       cPatCon			            // Path de Contabilidad
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nFilIni := 6                   // Fila Inicial
       LOCAL nNroCol := 8                   // N£mero de la Columna

       LOCAL cIndNot := ''                  // Indicadores en Contabilida
       LOCAL cDefNot := ''                  // Juicio Valorativo en Contabilidad
       LOCAL cRecNot := ''                  // Juicios Valorativo Recuperaci¢n en Contabilidad

       LOCAL cIndNoP := ''                  // Indicadores en Profesor
       LOCAL cDefNoP := ''                  // Juicio Valorativo en Profesor
       LOCAL cRecNoP := ''                  // Juicio Valorativo Recuperacion en Profesor
       LOCAL nTipNov := 0                   // Tipo de Novedad
       LOCAL nGrabar := 0                   // Opci¢n de Grabaci¢n
       LOCAL cOpcAct := ''                  // Opci¢n de Actualizaci¢n

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL lMatSelTma := .F.              // .T. Materia Selectiva

       LOCAL cCamIndNot := ''               // Campo Indicadore en Notas
       LOCAL cCamDefNot := ''               // Campo Nota Definitiva en Notas
       LOCAL cCamRecNot := ''               // Campo Recuperaci¢n en Notas

       LOCAL cCamIndNoP := ''               // Campo Indicadores profesor
       LOCAL cCamDefNoP := ''               // Campo Definitiva profesor
       LOCAL cCamRecNoP := ''               // Campo Recuperaci¢n profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DE LA MATERIA
       cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	  CloseDbf('NOT')
	  RETURN NIL
       ENDIF
       cNombreTma := ALLTRIM(MAT->cNombreMat)
       lMatSelTma := MAT->lMatSelMat
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'GRUPO:'+cCodigoTgr+' '+cNombreTma,22,'°')
       @ nNroFil,01 SAY 'CODIGO'
       @ nNroFil,08 SAY 'GRUPO'
       @ nNroFil,14 SAY 'No.'
       @ nNroFil,18 SAY 'ESTADO'
       @ nNroFil,25 SAY 'NOMBRE'
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>RECORRIDO DE LOS REGISTROS
       SELECT NOP
       NOP->(RECNO())
       DO WHILE .NOT. NOP->(EOF())

**********RETIRO DEL ESTUDIANTE
	   IF NOP->lRetiroNoP
	      SELECT NOP
	      NOP->(DBSKIP())
	   ENDIF
**********FIN RETIRO DEL ESTUDIANTE

**********LECTURA DE LOS CAMPOS
	    cCamIndNot := ''
	    cCamDefNot := ''
	    cCamRecNot := ''

	    cCamIndNoP := ''
	    cCamDefNoP := ''
	    cCamRecNoP := ''

	    IF !lCmpNoPNot(lShared,cAnoUsr,cMaeAct,cPatCon,;
			   NOP->cCodigoEst,nNroPer,cCodigoTma,lMatSelTma,;
			   @cCamIndNot,@cCamDefNot,@cCamRecNot,;
			   @cCamIndNoP,@cCamDefNoP,@cCamRecNoP)
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LECTURA DE LOS CAMPOS

**********VALIDACION DE LOS REGISTROS
	    IF NOT->cCodigoEst # NOP->cCodigoEst
	       cError('LOS CODIGOS:'+NOT->cCodigoEst+':'+NOP->cCodigoEst+' '+;
		      'DEL ESTUDIANTE NO SON IGUALES')
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS REGISTROS

**********LECTURA DE LOS REGISTROS
	    cIndNot := &cCamIndNot

	    cDefNot := &cCamDefNot
	    cDefNot := SUBS(cDefNot,nNroPer*4-3,4)

	    cRecNot := &cCamRecNot
	    cRecNot := SUBS(cRecNot,nNroPer*4-3,4)

	    cIndNoP := &cCamIndNoP
	    cDefNoP := &cCamDefNoP
	    cRecNoP := &cCamRecNoP
**********FIN LECTURA DE LOS REGISTROS

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********VALIDACION DE LOS INDICADORES
	    nTipNov := 0
	    lHayErr := .T.
	    DO CASE
	    CASE (!EMPTY(cIndNot) .AND. EMPTY(cIndNoP)) .OR.;
		 (!EMPTY(cDefNot) .AND. EMPTY(cDefNoP)) .OR.;
		 (!EMPTY(cRecNot) .AND. EMPTY(cRecNoP)) .AND.;
		 !lRetiroTes .AND. !NOP->lRetiroNoP

		 IF !PRA->lValNovAno
		    cError('NO EXISTEN INDICADORES APLICADOS EN EL PROFESOR '+;
			   'PERIODO No. '+STR(nNroPer,1))
		 ENDIF

		 nTipNov := 1

	    CASE (EMPTY(cIndNot) .AND. !EMPTY(cIndNoP)) .OR.;
		 (EMPTY(cDefNot) .AND. !EMPTY(cDefNoP)) .OR.;
		 (EMPTY(cRecNot) .AND. !EMPTY(cRecNoP)) .AND.;
		 !lRetiroTes .AND. !NOP->lRetiroNoP

		 IF !PRA->lValNovAno
		    cError('NO EXISTEN INDICADORES EN LA CONTABILIDAD '+;
			   'PERIODO No. '+STR(nNroPer,1))
		 ENDIF

		 nTipNov := 2

	    CASE (cIndNot # cIndNoP) .OR.  (cDefNot # cDefNoP) .OR.;
		 (cRecNot # cRecNoP) .AND. !lRetiroTes .AND.;
		 !NOP->lRetiroNoP

		 cError('EXISTE INCONSISTENCIA EN LOS INDICADORES '+;
			 'PERIODO No. '+STR(nNroPer,1))

		 nTipNov := 3

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       IF lMatSelTma
		  cError('VERIFIQUE SI EL ESTUDIANTE FUE TRASLADADO')
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE LOS INDICADORES

**********VISUALIZACION DEL ESTUDIANTE
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)

	    @ nNroFil,01 SAY NOP->cCodigoEst
	    @ nNroFil,08 SAY &cMaeAct->cCodigoGru
	    @ nNroFil,14 SAY ALLTRIM(STR(NOP->(RECNO()),3))
	    @ nNroFil,25 SAY cNombreTes+;
			     IF(lRetiroTes,;
				'. '+cFecha(&cMaeAct->dFecRetEst),'')
**********FIN VISUALIZACION DEL ESTUDIANTE

**********ANALISIS DE LA INCONSISTENCIA
	    nGrabar := 0
	    IF lHayErr .AND. !lRetiroTes

*--------------VISUALIZACION DEL ESTADO
		 @ nNroFil,18 SAY 'ERROR'
*--------------FIN VISUALIZACION DEL ESTADO

*--------------VISUALIZACION DE LA INCONSISTENCIA
		 cSavPan := SAVESCREEN(0,0,24,79)
		 RegNotNoP(NOP->cCodigoEst,&cMaeAct->cCodigoGru,;
			   NOP->(RECNO()),cNombreTes,lRetiroTes,;
			   &cMaeAct->dFecRetEst,cNombreTma,nNroPer,cIndNot,;
			   cDefNot,cRecNot,cIndNoP,cDefNoP,cRecNoP)
*--------------FIN VISUALIZACION DE LA INCONSISTENCIA

*--------------LECTURA DE LA OPCION DE ACTUALIZACION
		 cOpcAct := SUBS(PRA->cGraNovAno,nTipNov,1)
		 nGrabar := 0
		 DO CASE
		 CASE cOpcAct == '1' .AND. nTipNov == 1

		      nGrabar := 1
		      IF !PRA->lValNovAno .AND.;
			 !lPregunta('DESEA GRABAR DE LA CONTABILIDAD AL '+;
				    'PROFESOR? Si No')
			 nGrabar := 0
		      ENDIF

		 CASE cOpcAct == '1' .AND. nTipNov == 2

		      nGrabar := 2
		      IF !PRA->lValNovAno .AND.;
			 !lPregunta('DESEA GRABAR DEL PROFESOR A LA '+;
				    'CONTABILIDAD? Si No')
			 nGrabar := 0
		      ENDIF

		 CASE cOpcAct == '2'

		      nGrabar := nLeeOpcion('ACTUALIZAR: '+;
				'1<CONTABILIDAD=>PROFESOR> '+;
				'2<PROFESOR=>CONTABILIDAD> '+;
				'3<ABANDONAR>?',3,'0')

		      IF nGrabar == 3
			 nGrabar := 0
		      ENDIF

		 OTHERWISE
		      nGrabar := 0
		      cPausa()
		 ENDCASE
		 RESTSCREEN(0,0,24,79,cSavPan)
*--------------FIN LECTURA DE LA OPCION DE ACTUALIZACION

	    ELSE
	       @ nNroFil,18 SAY 'OK'
	    ENDIF
**********FIN ANALISIS DE LA INCONSISTENCIA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

	       nNroFil := nMarco(nFilPal+1,;
				 'GRUPO:'+cCodigoTgr+' '+;
				 ALLTRIM(cNombreTma),22,'°')
	       @ nNroFil,01 SAY 'CODIGO'
	       @ nNroFil,08 SAY 'GRUPO'
	       @ nNroFil,14 SAY 'No.'
	       @ nNroFil,18 SAY 'ESTADO'
	       @ nNroFil,25 SAY 'NOMBRE'
	       nNroFil++
	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

**********ANALISIS DE DECISION
	    IF lRetiroTes
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********VALIDACION DE LA GRABACION
	    IF lHayErr .AND. nGrabar == 0

	       cError('POR FAVOR TENGA EN CUENTA LA INCONSISTENCIA')
	       IF !lPregunta('DESEA CONTINUAR? Si No')
		  EXIT
	       ENDIF

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA GRABACION

**********GRABACION ACTUALIZACION DE LAS INCONSISTENCIAS
	    IF nGrabar # 0

	       DO CASE
	       CASE nGrabar == 1
		    SELECT NOP
		    IF NOP->(lRegLock(lShared,.F.))

		       REPL &cCamIndNoP WITH cIndNot
		       REPL &cCamDefNoP WITH cDefNot
		       REPL &cCamRecNoP WITH cRecNot
		       NOP->(DBCOMMIT())

		       @ nNroFil,18 SAY 'OK='+STR(nGrabar,1)
		    ELSE
		       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		    ENDIF
		    IF lShared
		       NOP->(DBUNLOCK())
		    ENDIF

	       CASE nGrabar == 2
		    SELECT NOT
		    IF NOT->(lRegLock(lShared,.F.))

		       REPL &cCamIndNot WITH cIndNoP
		       REPL &cCamDefNot WITH STUFF(&cCamDefNot,nNroPer*4-3,4,cDefNoP)
		       REPL &cCamRecNot WITH STUFF(&cCamRecNot,nNroPer*4-3,4,cRecNoP)
		       NOT->(DBCOMMIT())

		       @ nNroFil,18 SAY 'OK='+STR(nGrabar,1)
		    ELSE
		       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		    ENDIF
		    IF lShared
		       NOT->(DBUNLOCK())
		    ENDIF

	       ENDCASE

	    ENDIF
**********FIN GRABACION ACTUALIZACION DE LAS INCONSISTENCIAS

	  SELECT NOP
	  NOP->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS REGISTROS

/*************************************************************************
* TITULO..: LECTURA DE CAMPOS DE LAS NOTAS DEL PROFESOR Y CONTABILIDAD   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/2003 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   OCT 31/2003 VIE

OBJETIVOS:

1- Lee los Campos de las notas del Profesor y de la Contabilidad

2- Se ubica en el registro del Archivo de Notas de la Contabilidad
   seg£n el C¢digo del Estudiante.

3- Se ubica en el registro del Archivo de Notas de Profesor
   seg£n el C¢digo del Estudiante.

4- Retorna .T. Si NO se presentaron problemas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lCmpNoPNot(lShared,cAnoUsr,cMaeAct,cPatCon,cCodEst,nNroPer,cCodMat,;
		    lMatSel,cIndNot,cDefNot,cRecNot,cIndNoP,cDefNoP,cRecNoP)

*>>>>DESCRIPCION DE VARIABLES
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cPatCon			            // Path de Integraci¢n Uno
       cCodEst                              // C¢digo del Estudiante
       nNroPer                              // N£mero del Periodo
       cCodMat                              // Codigo de la Materia
       lMatSel                              // .T. Materia Selectiva
       cIndNot                              // @Campo de Indicadores  NOT
       cDefNot                              // @Campo de Definitiva   NOT
       cRecNot                              // @Campo de Recuperaci¢n NOT
       cIndNoP                              // @Campo de Indicadores  NOP
       cDefNoP                              // @Campo de Definitiva   NOP
       cRecNoP                              // @Campo de Recuperaci¢n NOP */
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CODIGO DEL ESTUDIANTE
       IF !lSekCodigo(cCodEst,cMaeAct)
	  RETURN !lHayErr
       ENDIF
*>>>>FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*>>>>LECTURA CAMPOS EN NOTAS CONTABILIDAD
       cIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,cPatCon,;
			     nNroPer,&cMaeAct->cCodigoGru,;
			     cCodMat,lMatSel,@cDefNot,@cRecNot)

       IF EMPTY(cIndNot)
	  RETURN !lHayErr
       ENDIF
*>>>>FIN LECTURA CAMPOS EN NOTAS CONTABILIDAD

*>>>>LECTURA CAMPOS EN NOTAS PROFESOR
       cIndNoP := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cDefNoP := 'NOP->cDefin'+STR(nNroPer,1)+'NoP'
       cRecNoP := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

*>>>>LOCALIZACION DEL ESTUDIANTE EN NOTAS
       IF !lLocCodigo('cCodigoEst','NOT',cCodEst)
	  cError('EL ESTUDIANTE NO EXISTE EN NOTAS DEL GRUPO '+;
		 &cMaeAct->cCodigoGru)
	  RETURN !lHayErr
       ENDIF
*>>>>FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

*>>>>LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR
       IF !lLocCodigo('cCodigoEst','NOP',cCodEst)
	  cError('EL ESTUDIANTE NO EXISTE EN LA MATERIA DEL PROFESOR')
	  RETURN !lHayErr
       ENDIF
       RETURN lHayErr
*>>>>FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR

/*************************************************************************
* TITULO..: CONSULTA DE VALIDACION DE REGISTROS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/2003 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   OCT 31/2003 VIE

OBJETIVOS:

1- Visualiza los registro de notas de la Contabilidad

2- Visualiza los registro de notas del Profesor

3- La Consulta se puede utilizar como validaci¢n

5- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RegNotNoP(cCodEst,cCodGru,nNroLis,cNomEst,lRetEst,dFecRet,cNomMat,;
		   nNroPer,cIndNot,cDefNot,cRecNot,cIndNoP,cDefNoP,cRecNoP)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cCodGru                              // C¢digo del Grupo
       cNomEst                              // Nombre del Estudiante
       lRetEst                              // .T. Retiro del Estudiante
       dFecRet                              // Fecha del Retiro
       cNomMat                              // Nombre de la Materia
       nNroPer                              // N£mero del Periodo
       cIndNot                              // Indicadores Contabilidad
       cDefNot                              // Definitivas Contabilidad
       cRecNot                              // Recuperaciones Contabilidad
       cIndNoP                              // Indicadores Profesor
       cDefNoP                              // Definitivas Profesor
       cRecNoP                              // Recuperaciones Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nColIni := 8                   // Columna Inicial
       LOCAL nNroCol := nColIni             // N£mero de la Columna
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(3,ALLTRIM(cNomMat),22,'°')

       @ nNroFil,01 SAY 'CODIGO'
       @ nNroFil,08 SAY 'GRUPO'
       @ nNroFil,14 SAY 'No.'
       @ nNroFil,18 SAY 'NOMBRE'
       nNroFil++

       @ nNroFil,01 SAY cCodEst
       @ nNroFil,08 SAY cCodGru
       @ nNroFil,14 SAY ALLTRIM(STR(nNroLis,3))
       @ nNroFil,18 SAY cNomEst+IF(lRetEst,;
				   '. RETIRADO '+cFecha(dFecRet),'')
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS
       @ nNroFil+2,01 SAY 'INDICADORES EN CONTABILIDAD:'
       i := 1
       DO WHILE i <= 10
	  @ nNroFil+3,nNroCol SAY (i<10,'INDI','IND')+LTRIM(STR(i))
	  i++
	  nNroCol := nNroCol + 7
       ENDDO

       nNroCol = nNroCol - (i-1)*7
       nNroFil = nNroFil + 1
      *Ubica la fila primera de grabacion
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS

*>>>>CONSULTA DE LOS INDICADORES EN CONTABILIDAD
       DispLogRec(nNroFil+3,nColIni,cIndNot)
*>>>>FIN CONSULTA DE LOS INDICADORES EN CONTABILIDAD

*>>>>IMPRESION DE LOS ENCABEZADOS DEL PROFESOR
       @ nNroFil+5,01 SAY 'INDICADORES EN EL PROFESOR:'
       i := 1
       DO WHILE i <= 10
	  @ nNroFil+6,nNroCol SAY (i<10,'INDI','IND')+LTRIM(STR(i))
	  i++
	  nNroCol := nNroCol + 7
       ENDDO
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DEL PROFESOR

*>>>>CONSULTA DE LOS INDICADORES DEL PROFESOR
       DispLogRec(nNroFil+7,nColIni,cIndNoP)
*>>>>FIN CONSULTA DE LOS INDICADORES DEL PROFESOR

*>>>>CONSULTA DE JUICIOS VALORATIVOS
       cSay(nNroFil+10,01,'JUICIOS VALORATIVOS EN SIMACONT:')
       SET COLOR TO I
       cSay(nNroFil+10,33,cDefNot)
       SET COLOR TO

       cSay(nNroFil+11,01,'JUICIOS VALORATIVOS EN SIMAPROF:')
       SET COLOR TO I
       cSay(nNroFil+11,33,cDefNoP)
       SET COLOR TO
       cSay(nNroFil+11,42,'Periodo No.',STR(nNroPer,1))

       IF !EMPTY(cRecNot) .OR. !EMPTY(cRecNoP)
	  cSay(nNroFil+12,01,'JUICIOS RECUPERADOS EN SIMACONT:')
	  SET COLOR TO I
	  cSay(nNroFil+12,33,cRecNot)
	  SET COLOR TO
       ENDIF

       IF !EMPTY(cRecNot) .OR. !EMPTY(cRecNoP)
	  cSay(nNroFil+13,01,'JUICIOS RECUPERADOS EN SIMAPROF:')
	  SET COLOR TO I
	  cSay(nNroFil+13,33,cRecNoP)
	  SET COLOR TO
	  cSay(nNroFil+13,42,'Periodo No.',STR(nNroPer,1))
       ENDIF
       RETURN NIL
*>>>>FIN CONSULTA DE JUICIOS VALORATIVOS

