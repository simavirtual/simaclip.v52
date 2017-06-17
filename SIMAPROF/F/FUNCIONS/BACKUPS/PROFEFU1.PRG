/*                      SIMA - SISTEMA DE CONTABILIDAD PARA PROFESORES.USB
		     BIBLIOTECAS DE FUNCIONES GENERALES

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO..: GRUPOS. INSERTAR REGISTROS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  05:00 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsGruUsb(lShared,cNomSis,aCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       aCodGru                              // C¢digos de Grupos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cCodGru := ''                  // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DE LOS GRUPOS
       SELECT GRU
       ZAP
     *ÀBorrado de los registros

       aStrDbf := GRU->(DBSTRUCT())
       FOR i := 1 TO LEN(aCodGru)

	   cCodGru := aCodGru[i,1]

***********LOCALIZACION DEL ARCHIVO
	     IF !lLocCodigo('cCodigoGru','GR1',cCodGru)
		cError('NO EXISTE EL GRUPO:'+cCodGru)
		lHayErr := .T.
		EXIT
	     ENDIF
***********FIN LOCALIZACION DEL ARCHIVO

***********GRABACION DEL REGISTRO
	     SELECT GRU
	     IF GRU->(lRegLock(lShared,.T.))

		FOR j := 1 TO LEN(aStrDbf)
		    cCampo := aStrDbf[j,1]
		    REPL &('GRU->'+cCampo) WITH &('GR1->'+cCampo)
		ENDFOR

		GRU->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABO EL REGISTRO DE GRUPOS')
		lHayErr := .T.
		EXIT
	     ENDIF
	     IF lShared
		GRU->(DBUNLOCK())
	     ENDIF
***********FIN GRABACION DEL REGISTRO

       ENDFOR
       RETURN !lHayErr
*>>>>FIN GRABACION DE LOS GRUPOS

/*************************************************************************
* TITULO..: NIVELES. INSERTAR REGISTROS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  05:30 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsNivUsb(lShared,cNomSis,aCodNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       aCodNiv			            // C¢digos de Niveles */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cCodNiv := ''                  // C¢digo del Grado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DE LOS NIVELES
       SELECT NIV
       ZAP
     *ÀBorrado de los registros

       aStrDbf := NIV->(DBSTRUCT())
       FOR i := 1 TO LEN(aCodNiv)

	   cCodNiv := aCodNiv[i,1]

***********LOCALIZACION DEL ARCHIVO
	     IF !lLocCodigo('cCodigoNiv','NI1',cCodNiv)
		cError('NO EXISTE EL GRADO:'+cCodNiv)
		lHayErr := .T.
		EXIT
	     ENDIF
***********FIN LOCALIZACION DEL ARCHIVO

***********GRABACION DEL REGISTRO
	     SELECT NIV
	     IF NIV->(lRegLock(lShared,.T.))

		FOR j := 1 TO LEN(aStrDbf)
		    cCampo := aStrDbf[j,1]
		    REPL &('NIV->'+cCampo) WITH &('NI1->'+cCampo)
		ENDFOR

		NIV->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABO EL REGISTRO DEL NIVEL')
		lHayErr := .T.
		EXIT
	     ENDIF
	     IF lShared
		NIV->(DBUNLOCK())
	     ENDIF
***********FIN GRABACION DEL REGISTRO

       ENDFOR
       RETURN !lHayErr
*>>>>FIN GRABACION DE LOS NIVELES

/*************************************************************************
* TITULO..: MATERIAS. INSERTAR REGISTROS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  06:00 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsMatUsb(lShared,cNomSis,aCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       aCodMat			            // C¢digos de Materias */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cCodMat := ''                  // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DE LAS MATERIAS
       SELECT MAT
       ZAP
     *ÀBorrado de los registros

       aStrDbf := MAT->(DBSTRUCT())
       FOR i := 1 TO LEN(aCodMat)

	   cCodMat := aCodMat[i,1]

***********LOCALIZACION DEL ARCHIVO
	     IF !lLocCodigo('cCodigoMat','MA1',cCodMat)
		cError('NO EXISTE LA MATERIA:'+cCodMat)
		lHayErr := .T.
		EXIT
	     ENDIF
***********FIN LOCALIZACION DEL ARCHIVO

***********GRABACION DEL REGISTRO
	     SELECT MAT
	     IF MAT->(lRegLock(lShared,.T.))

		FOR j := 1 TO LEN(aStrDbf)
		    cCampo := aStrDbf[j,1]
		    REPL &('MAT->'+cCampo) WITH &('MA1->'+cCampo)
		ENDFOR

		MAT->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABO EL REGISTRO DE LA MATERIA')
		lHayErr := .T.
		EXIT
	     ENDIF
	     IF lShared
		MAT->(DBUNLOCK())
	     ENDIF
***********FIN GRABACION DEL REGISTRO

       ENDFOR
       RETURN !lHayErr
*>>>>FIN GRABACION DE LAS MATERIAS

/*************************************************************************
* TITULO..: ESTUDIANTES. INSERTAR REGISTROS                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  06:30 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsMaeUsb(lShared,cNomSis,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cMaeAct			            // Maestro Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL aCampos := {}                  // Campos a grabar

       LOCAL nNroFil := 0                   // N£mero de la Fila
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS AUTORIAZADOS
       AADD(aCampos,'cCodigoEst')
       AADD(aCampos,'lRetiroEst')
       AADD(aCampos,'dFecRetEst')
       AADD(aCampos,'nPerRetEst')
       AADD(aCampos,'nAproboNot')
       AADD(aCampos,'nAprAntNot')
       AADD(aCampos,'lRepiteEst')
       AADD(aCampos,'lSiCupoEst')
       AADD(aCampos,'lSiMatrEst')
       AADD(aCampos,'dFecMatEst')
       AADD(aCampos,'cHorMatEst')
       AADD(aCampos,'lEstNewEst')
       AADD(aCampos,'cGruAntGru')
       AADD(aCampos,'cCodigoGru')
       AADD(aCampos,'cAnoIngEst')
       AADD(aCampos,'nNroLisEst')

       AADD(aCampos,'cApelliEst')
       AADD(aCampos,'cNombreEst')
       AADD(aCampos,'lSexFemEst')
*>>>>FIN CAMPOS AUTORIAZADOS

*>>>>RECORRIDO POR GRUPOS
       SELECT &cMaeAct
       ZAP
     *ÀBorrado de registros

       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********FILTRACION DEL ARCHIVO
	    SELECT ALU
	    SET FILTER TO ALU->cCodigoGru == GRU->cCodigoGru
	    ALU->(DBGOTOP())
	    IF ALU->(EOF())

	       cError('NO EXISTEN ESTUDIANTES '+;
		      'DEL GRUPO '+GRU->cCodigoGru)
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********GRABACION DE LOS ESTUDIANTES
	    nNroFil := nMarco(01,'ACTUALIZANDO LOS ESTUDIANTES '+;
				 'DEL GRUPO '+GRU->cCodigoGru)

	    SELECT ALU
	    ALU->(DBGOTOP())
	    DO WHILE .NOT. ALU->(EOF())

*==============VISUALIZACION DEL ESTUDIANTE
		 nNroFil++
		 @ nNroFil,01 SAY ALU->cApelliEst
		 IF nNroFil == 21
		    nNroFil := nMarco(01,'ACTUALIZANDO LOS ESTUDIANTES '+;
					 'DEL GRUPO '+GRU->cCodigoGru)
		 ENDIF
*==============FIN VISUALIZACION DEL ESTUDIANTE

*==============GRABACION DEL REGISTRO
		 SELECT &cMaeAct
		 IF lRegLock(lShared,.T.)

		    FOR i := 1 TO LEN(aCampos)
			cCampo := aCampos[i]
			REPL &(cMaeAct+'->'+cCampo) WITH &('ALU->'+cCampo)
		    ENDFOR

		    DBCOMMIT()
		 ELSE
		    cError('NO SE GRABO EL REGISTRO DE ESTUDIANTES')
		    lHayErr := .T.
		    EXIT
		 ENDIF
		 IF lShared
		    DBUNLOCK()
		 ENDIF
*==============FIN GRABACION DEL REGISTRO

	       ALU->(DBSKIP())

	    ENDDO
	    IF lHayErr
	       EXIT
	    ENDIF
**********FIN GRABACION DE LOS ESTUDIANTES

	  GRU->(DBSKIP())

       ENDDO
       RETURN !lHayErr
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: CLASE DE INDICADORES. INSERTAR REGISTROS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  07:00 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros de la Clase de Indicadores

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsClaUsb(lShared,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DE LAS CLASE DE INDICADORES
       SELECT CLA
       ZAP
     *ÀBorrado de los registros

       aStrDbf := CLA->(DBSTRUCT())

       SELECT CL1
       CL1->(DBGOTOP())
       DO WHILE .NOT. CL1->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('CLASE DE INDICADORESº'+;
			 ALLTRIM(CL1->(STR(RECNO(),7)))+'/'+;
			 ALLTRIM(CL1->(STR(RECCOUNT(),7))),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL REGISTRO
	    IF CLA->(lRegLock(lShared,.T.))

	       FOR i := 1 TO LEN(aStrDbf)
		   cCampo := aStrDbf[i,1]
		   REPL &('CLA->'+cCampo) WITH &('CL1->'+cCampo)
	       ENDFOR

	       CL1->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABO EL REGISTRO DE CLASE DE INDICADORES')
	       lHayErr := .T.
	    ENDIF
	    IF lShared
	       CL1->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  CL1->(DBSKIP())

       ENDDO
       RETURN !lHayErr
*>>>>FIN GRABACION DE LAS CLASE DE INDICADORES

/*************************************************************************
* TITULO..: TABLA DE EVALUACION. INSERTAR REGISTROS                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  07:30 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsEvaUsb(lShared,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE REGISTROS
       SELECT EVA
       ZAP
     *ÀBorrado de los registros

       aStrDbf := EVA->(DBSTRUCT())

       SELECT EV1
       EV1->(DBGOTOP())
       DO WHILE .NOT. EV1->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('TABAL DE EVALUACIONº'+;
			 ALLTRIM(EV1->(STR(RECNO(),7)))+'/'+;
			 ALLTRIM(EV1->(STR(RECCOUNT(),7))),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL REGISTRO
	    IF EVA->(lRegLock(lShared,.T.))

	       FOR i := 1 TO LEN(aStrDbf)
		   cCampo := aStrDbf[i,1]
		   REPL &('EVA->'+cCampo) WITH &('EV1->'+cCampo)
	       ENDFOR

	       EV1->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABO EL REGISTRO. TABLA DE EVALUACION')
	       lHayErr := .T.
	    ENDIF
	    IF lShared
	       EV1->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  EV1->(DBSKIP())

       ENDDO
       RETURN !lHayErr
*>>>>FIN RECORRIDO DE REGISTROS

/*************************************************************************
* TITULO..: JUICIO VALORATIVO FINAL. INSERTAR REGISTROS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  08:00 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsJvfUsb(lShared,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE REGISTROS
       SELECT JVF
       ZAP
     *ÀBorrado de los registros

       aStrDbf := JVF->(DBSTRUCT())

       SELECT JV1
       JV1->(DBGOTOP())
       DO WHILE .NOT. JV1->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('JUICIO VALORATIVO FINALº'+;
			 ALLTRIM(JV1->(STR(RECNO(),7)))+'/'+;
			 ALLTRIM(JV1->(STR(RECCOUNT(),7))),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL REGISTRO
	    IF JVF->(lRegLock(lShared,.T.))

	       FOR i := 1 TO LEN(aStrDbf)
		   cCampo := aStrDbf[i,1]
		   REPL &('JVF->'+cCampo) WITH &('JV1->'+cCampo)
	       ENDFOR

	       JV1->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABO EL REGISTRO. TABLA DE EVALUACION')
	       lHayErr := .T.
	    ENDIF
	    IF lShared
	       JV1->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  JV1->(DBSKIP())

       ENDDO
       RETURN !lHayErr
*>>>>FIN RECORRIDO DE REGISTROS

/*************************************************************************
* TITULO..: CONFIGURACION DE NIVEL. INSERTAR REGISTROS                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  08:30 PM  MAY 26/2008 LUN

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsTcoUsb(lShared,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE REGISTROS
       SELECT TCO
       ZAP
     *ÀBorrado de los registros

       aStrDbf := TCO->(DBSTRUCT())

       SELECT TC1
       TC1->(DBGOTOP())
       DO WHILE .NOT. TC1->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('CONFIGURACION DE NIVELº'+;
			 ALLTRIM(TC1->(STR(RECNO(),7)))+'/'+;
			 ALLTRIM(TC1->(STR(RECCOUNT(),7))),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL REGISTRO
	    IF TCO->(lRegLock(lShared,.T.))

	       FOR i := 1 TO LEN(aStrDbf)
		   cCampo := aStrDbf[i,1]
		   REPL &('TCO->'+cCampo) WITH &('TC1->'+cCampo)
	       ENDFOR

	       TC1->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABO EL REGISTRO. TABLA DE EVALUACION')
	       lHayErr := .T.
	    ENDIF
	    IF lShared
	       TC1->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  TC1->(DBSKIP())

       ENDDO
       RETURN !lHayErr
*>>>>FIN RECORRIDO DE REGISTROS

/*************************************************************************
* TITULO..: PROFESORES. INSERTAR REGISTROS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2008 MIE A
       Colombia, Bucaramanga        INICIO:  11:30 PM  MAY 28/2008 MIE

OBJETIVOS:

1- Inserta los registros.

2- Retorna .T. Si no se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnsProUsb(lShared,cNomSis,cCodPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cCodPro                              // C¢digo del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BORRADO DE REGISTROS
       SELECT PRO
       ZAP
     *ÀBorrado de los registros

       aStrDbf := PRO->(DBSTRUCT())
*>>>>FIN BORRADO DE REGISTROS

*>>>>LOCALIZACION DEL ARCHIVO
       IF !lLocCodigo('cCodigoPro','PR1',cCodPro)
	  cError('EL CODIGO:'+cCodPro+' DEL PROFESOR NO EXISTE')
	  RETURN .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL ARCHIVO

*>>>>GRABACION DEL REGISTRO
       IF PRO->(lRegLock(lShared,.T.))

	  FOR i := 1 TO LEN(aStrDbf)
	      cCampo := aStrDbf[i,1]
	      REPL &('PRO->'+cCampo) WITH &('PR1->'+cCampo)
	  ENDFOR

	  PR1->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABO EL REGISTRO. TABLA DE PROFESORES')
	  lHayErr := .T.
       ENDIF
       IF lShared
	  PR1->(DBUNLOCK())
       ENDIF
       RETURN !lHayErr
*>>>>FIN GRABACION DEL REGISTRO

