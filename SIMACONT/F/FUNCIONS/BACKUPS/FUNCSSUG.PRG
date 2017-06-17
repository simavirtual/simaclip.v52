/*                    SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO SUBNIVEL

REQUERIMIENTOS:

- Compilar: clipper FuncsSuG /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo SubNivel

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   MAR 06/98 VIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSuG(lShared,PathSuG,FileSuG,lIntUno,fNtxSuG,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathSuG				    // Path del Archivo
       FileSuG				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxSuG				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfSuG := {{"cCodigoGru","Character",04,0},; // C¢digo del Grupo
			 {"cCodigoMat","Character",04,0},; // C¢digo de la Materia
			 {"cIntHorSuG","Character",02,0},; // Intensidad Horaria
			 {"cCodigoPro","Character",06,0}}  // Codigo del Profesor que dicta
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfSuG
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathSuG) == 0
	    DBCREATE(FileSuG,aDbfSuG,"DBFNTX")

       CASE DIRCHANGE(PathSuG) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathSuG)

       CASE DIRCHANGE(PathSuG) == -5
	    cError('NO TIENE DERECHOS EN: '+PathSuG)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 02:20 PM   MAR 06/98 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfSuG(lShared,PathSuG,FileSuG,lIntUno,fNtxSuG)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathSuG				    // Path del Archivo
       FileSuG				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxSuG				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathSuG+'\'+FileSuG,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE MATERIAS")
       Termometro(100)
       CreaDbfSuG(lShared,PathSuG,FileSuG,lIntUno,fNtxSuG)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 04/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 04/99 JUE

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrSuG(lShared,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'SUG',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE SUBDIVISION POR GRUPO')
	  CloseDbf('SUG')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := SUG->(DBSTRUCT())
       CloseDbf('SUG')
       CreaDbfSuG(lShared,PathArc,cNomArc,,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio .AND. lShared
	  cError('El Archivo SUB DIVISION POR GRUPO su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfSuG(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE          	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   MAR 06/98 VIE


OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwSuG(lShared,nFilSup,nColSup,nFilInf,;
		    nColInf,cNroNiv,cCodMat,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNroNiv                              // N£mero del nivel
       cCodMat                              // Codigo de la materia
       cTitulo                              // T¡tulo del Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Objeto Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       cTitulo := IF(cTitulo == NIL,;
		     'SUB DIVISION DE LA MATERIA',cTitulo)
       oBrowse:Cargo := {'<<'+cTitulo+' '+cNomNiv+' >>',;
			 '<INS>Incluir <DEL>Borrar <ESC>Abandonar',;
			 {||IncluirSuG(lShared,cNroNiv,cCodMat)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT SUN
       oColumn	     := TBCOLUMNNEW('GRUPO',{||SUG->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',{||SUG->cCodigoMat})
       IF SCO->lModPlaCon
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SUG'},;
			    {'FIELD','cCodigoMat'},{'PICTURE','9999'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MATERIAS',;
			     {||cSekNomMat(SUG->cCodigoMat,'SUG')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 32
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 3
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('INTENSIDAD',{||SUG->cIntHorSuG})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SUG'},{'FIELD','cIntHorSuG'},;
			 {'PICTURE','@!'}}
       oColumn:Picture := "@!"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO', {||SUG->cCodigoPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SUG'},{'FIELD','cCodigoPro'},;
			 {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PROFESOR',{||cSekNomPro(SUG->cCodigoPro,'SUG')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 51
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: VISUALIZACION DEL SUB PLAN            	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 04:50 PM   MAR 06/98 VIE


OBJETIVOS:

1- Visualiza la Subdivision de una materia variable

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerSuGPlan(lShared,cCodGru,cCodMat)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cCodGru                              // N£mero del nivel
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNroNiv := ''                  // N£mero del Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL SUBNIVEL POR GRUPOS
       cNroNiv := SUBS(cCodGru,1,2)

       SELECT SUG
       IF LEN(cCodGru) == 4
	  SET FILTER TO SUBS(SUG->cCodigoMat,1,2) == SUBS(cCodMat,1,2) .AND.;
			SUG->cCodigoGru == cCodGru
       ELSE
	  SET FILTER TO SUBS(SUG->cCodigoMat,1,2) == SUBS(cCodMat,1,2) .AND.;
			SUBS(SUG->cCodigoGru,1,2) == cNroNiv
       ENDIF
       GO TOP
*>>>>FIN FILTRACION DEL SUBNIVEL POR GRUPOS

*>>>>VISUALIZACION DEL BROWSE
       SUG->(CtrlBrw(lShared,oDefBrwSuG(lShared,05,01,22,78,;
		     cNroNiv,cCodMat,;
		     'SUBDIVISION DE '+ALLTRIM(MAT->cNombreMat))))
       SUG->(DBCLEARFILTER())
       SELECT PLA
       RETURN NIL
*>>>>FIN VISUALIZACION DEL BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 AM   MAY 12/95 VIE

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirSuG(lShared,cNroNiv,cCodMat)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cCodGru                              // C¢digo del Grupo
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cIntHorTsu := ''               // Intensidad horaria
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       lLocCodigo('cCodigoMat','MAT',cCodMat)
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LA SUBDIVISION DE '+;
				 ALLTRIM(MAT->cNombreMat),22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTgr := cSpaces('GRU','cCodigoGru')
	       cCodigoTma := cSpaces('SUG','cCodigoMat')
	       cIntHorTsu := cSpaces('SUG','cIntHorSuG')
	       cCodigoTpr := SPACE(06)
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL GRUPO    :';
				GET cCodigoTgr PICT '9999';
				VALID lValGrupo(ROW(),COL()-4,@cCodigoTgr)

	    @ nNroFil+1,nNroCol SAY 'CODIGO DE LA MATERIA:';
				GET cCodigoTma PICT '9999';
				VALID lValCodSuG(ROW(),COL()-4,;
				      @cCodigoTma,cCodigoTgr,cCodMat)


	    @ nNroFil+2,nNroCol SAY 'INTENSIDAD          :';
				GET cIntHorTsu PICT '@!'

	    @ nNroFil+3,nNroCol SAY 'CODIGO DEL PROFESOR :';
				GET cCodigoTpr PICT '999999'
			      * VALID lValProfes(ROW(),COL()-6,@cCodigoTpr)

	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cCodigoTma == cSpaces('SUG','cCodigoMat')

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')
	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA CONTINUAR? Si No')
		  IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		     EXIT
		  ENDIF
	       ELSE
		  lGrabar := .F.
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT SUN
       IF lGrabar
	  IF SUG->(lRegLock(lShared,.T.))
	     REPL SUG->cCodigoGru WITH cCodigoTgr
	     REPL SUG->cCodigoMat WITH cCodigoTma
	     REPL SUG->cIntHorSuG WITH cIntHorTsu
	     SUG->(DBCOMMIT())
	  ENDIF
	  IF lShared
	     SUG->(DBUNLOCK())
	  ENDIF
       ENDIF
       SELECT SUN
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 12/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodSuG(nNroFil,nNroCol,cCodigo,cCodGru,cCodMat)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO DE MATERIAS
       SELECT MAT
       SET FILTER TO SUBS(MAT->cCodigoMat,1,2) == SUBS(cCodMat,1,2) .AND.;
		     MAT->cCodigoMat # SUBS(cCodMat,1,2)+'00' .AND.;
		     MAT->nMatVarMat == 0
       GO TOP
*>>>>FIN FILTRACION DEL ARCHIVO DE MATERIAS

*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodigo)

**********SELECCION DE LA MATERIA
	    lSelMateria(nNroFil,nNroCol,@nNroReg)
	    IF nNroReg == 0
	       cCodigo := cSpaField('SUG','cCodigoMat')
	    ELSE
	       GO nNroReg
	       cCodigo := MAT->cCodigoMat
	    ENDIF
**********FIN SELECCION DE LA MATERIA

       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>VALIDACION DE EXISTENCIA
       SELECT SUG
/*
       IF lLocMatSuG(cCodigo,cCodGru,.F.)
	  cError('MATERIA YA APLICADA AL GRUPO')
	  lHayErr := .T.
       ENDIF
*/
*>>>>FIN VALIDACION DE EXISTENCIA

*>>>>VALIDACION DE LA MISMA AREA
       IF SUBS(cCodMat,1,2) # SUBS(cCodigo,1,2)
	 lLocCodigo('cCodigoMat','MAT',SUBS(cCodMat,1,2)+'00')
	 cError('LA MATERIA DEBE SER DEL AREA '+ALLTRIM(MAT->cNombreMat))
	 lHayErr := .T.
       ENDIF
       SELECT MAT
       MAT->(DBCLEARFILTER())
       SELECT SUN
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LA MISMA AREA

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR MATERIA EN EL NIVEL         	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Bucaramanga, Colombia        INICIO: 10:20 AM   MAY 09/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de Grupo

2- Verifica la existencia del c¢digo del Grupo.

3- Deja el archivo en el registro del c¢digo del Grupo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocMatSuG(cCodMat,cCodGru,lMensaj,cCodPro)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodMat				    // C¢digo de la materia
       cCodGru                              // C¢digo del Grupo
       lMensaj                              // .T. Mostrar mensaje error
       cCodPro                              // C¢digo del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT SUG
       GO TOP
       IF EMPTY(cCodPro)
	  LOCATE FOR SUG->cCodigoMat == cCodMat .AND.;
		     SUG->cCodigoGru == cCodGru
       ELSE
	  LOCATE FOR SUG->cCodigoMat == cCodMat .AND.;
		     SUG->cCodigoGru == cCodGru .AND.;
		     SUG->cCodigoPro == cCodPro
       ENDIF
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('LA MATERIA: '+cCodMat+' NO EXISTE EN LA SUBDIVISION '+;
		    'DEL GRUPO '+cCodGru)
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO