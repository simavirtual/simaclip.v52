/*                    SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO SELECCION

REQUERIMIENTOS:

- Compilar: clipper FuncsSel /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo SeleBto.dat que contiene
  las asignaturas escogidas por los estudiantes o la clasificaci¢n de los
  estudiantes.

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/98 MIE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   MAR 11/98 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSel(lShared,nModCry,PathArc,fArchvo,FileNtx,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       AADD(aDbfStr,{"cCodigoEst","Character",06,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{"cCodAreSel","Character",02,0}) // C¢digo del Area de la Selecci¢n.
       AADD(aDbfStr,{"cSecMatSel","Character",10,0}) // Secuencial final de la Materia
       AADD(aDbfStr,{"cSecProSel","Character",02,0}) // Secuencial de la Materia del profesor
       AADD(aDbfStr,{"cCodigoPro","Character",06,0}) // C¢digo del Profesor
       AADD(aDbfStr,{"nNroLisEst","Numeric"  ,03,0}) // N£mero de lista.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'SEL',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO SELECCION')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE INDICES
       SELECT SEL
       INDEX ON SEL->cCodigoEst+SEL->cCodAreSel TO &(PathArc+'\'+FileNtx)
       CloseAll()
       RETURN NIL
*>>>>FIN CREACION DE INDICES

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/98 MIE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   MAR 11/98 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfSel(lShared,nModCry,PathArc,fArchvo,FileNtx)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx				    // Archivo de Indices */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE MATERIAS")
       Termometro(100)
       CreaDbfSel(lShared,nModCry,PathArc,fArchvo,FileNtx)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/2003 MAR A
       Colombia, Bucaramanga        INICIO: 12:08 PM   FEB 11/2003 MAR

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

FUNCTION nActStrSel(lShared,nModCry,PathArc,fArchvo,FileNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx                              // Archivo Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('JUI')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'SEL',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE SELECCION')
	  CloseDbf('SEL',PathArc+'\'+fArchvo,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := SEL->(DBSTRUCT())
       CloseDbf('SEL',PathArc+'\'+fArchvo,nModCry)
       CreaDbfSel(lShared,nModCry,PathArc,fArchvo,,@aStrNew)
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
       IF lCambio
	  cError('El Archivo SELECCION su Estructura Esta DesActualizada.',;
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
	  nNroErr := 0
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfSel(lShared,nModCry,PathArc,;
				       FileTem,FileNtx)},nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: VECTOR DE LA ESTRUCTURA                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/2008 VIE A
       Colombia, Bucaramanga        INICIO:  10:20 AM  SEP 12/2008 VIE

OBJETIVOS:

1- Crea para accesar todos los campos de la tabla

2- Debe estar en uso el archivo

3- Retorna el vector

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aArrStrSel(cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo del Campo
       LOCAL cCampos := ''                  // Campo de la Tabla
       LOCAL aCampos := {}                  // Campos de la Tabla
       LOCAL aStrDbf := {'1'}               // Estructura de la Tabla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS DE LA TABLA
       cNalias := IF(EMPTY(cNalias),'SEL',cNalias)
       CreaDbfSel(,,,,,@aStrDbf)
       FOR i := 1 TO LEN(aStrDbf)

	   cCampos := aStrDbf[i,1]
	   DO CASE
	   CASE cCampos == 'cCodigoEst'
		cCodigo := 'cCodEst'

	   CASE cCampos == 'cCodigoPro'
		cCodigo := 'cCodPro'
	   OTHERWISE
		DO CASE
		CASE LEN(cCampos) == 10
		     cCodigo := SUBS(cCampos,1,7)
		CASE LEN(cCampos) == 9
		     cCodigo := SUBS(cCampos,1,7)
		OTHERWISE
		     cCodigo := 'Err'
		     cError('EL CAMPO '+cCampos+' '+;
			    'NO CUMPLE LA NORMA DEL NOMBRE')
		ENDCASE
	   ENDCASE

	   AADD(aCampos,{cCodigo,&(cNalias+'->'+cCampos)})

       ENDFOR
       RETURN aCampos
*>>>>FIN CAMPOS DE LA TABLA

/*************************************************************************
* TITULO..: MATERIA SELECTIVA DEL ESTUDIANTE                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2000 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAY 19/2000 VIE

OBJETIVOS:

1- De acuerdo a la materia variable retorna la materia selectiva del
   estudiante.

2- Retorna .T. Si la Materia es variable

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMatSelEst(cCodEst,nNroBis,cCodMat,cNomMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nNroBis                              // N£mero del Bismestre
       cCodMat                              // @C¢digo de la Materia
       cNomMat                              // @Nombre de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nMatVar := 0                   // Materia Variable
       LOCAL cCodAre := ''                  // C¢digo del Area
       LOCAL cSecMat := ''                  // Secuencial de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA MATERIA VARIABLE
       IF lMatVarMat(cCodMat,.F.)

**********BUSQUEDA DE LA SELECION DEL ESTUDIANTE
	    nMatVar := MAT->nMatVarMat
	    cCodAre := SUBS(cCodMat,1,2)
	    IF lSekCodigo(cCodEst+cCodAre,'SEL')

*--------------ANALISIS DE LA SELECCION
		 cSecMat := SUBS(SEL->cSecMatSel,nNroBis*2-1,2)
		 IF .NOT. EMPTY(cSecMat)

*...................LOCALIZACION DE LA MATERIA
		      IF lLocCodigo('cCodigoMat','MAT',cCodAre+cSecMat)
			 cCodMat := MAT->cCodigoMat
			 cNomMat := MAT->cNombreMat
		      ENDIF
*...................FIN LOCALIZACION DE LA MATERIA

		 ENDIF
*--------------FIN ANALISIS DE LA SELECCION

	    ENDIF
**********FIN BUSQUEDA DE LA SELECION DEL ESTUDIANTE

       ENDIF
       RETURN nMatVar
*>>>>FIN ANALISIS DE LA MATERIA VARIABLE