/*                   SISTEMA DE CONTABILIDAD ACADEMICA
	     BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO JUICIOS

REQUERIMIENTOS:

- Compilar: clipper FuncsJui /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Juicios

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 03:57 PM   FEB 18/95 SAB

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfJui(lShared,nModCry,PathArc,fArchvo,FileNtx,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoNiv","Character",002,0}) // C¢digo del Nivel
       AADD(aDbfStr,{"cCodigoJui","Character",008,0}) // C¢digo del Indicador
       AADD(aDbfStr,{"cCodLogJui","Character",008,0}) // C¢digo del Indicador del logro
       AADD(aDbfStr,{"cCodigoPro","Character",006,0}) // C¢digo del Profesor
       AADD(aDbfStr,{"nNroPerJui","Numeric"  ,001,0}) // N£mero del Periodo
       AADD(aDbfStr,{"cNombreJui","Character",106,0}) // Nombre del Indicador
       AADD(aDbfStr,{"cExtra1Jui","Character",106,0}) // Continuaci¢n del Indicador
/*
       AADD(aDbfStr,{"lSiSendJui","Logical"  ,001,0}) // .T. Indicador Transferido .F. Indicador NO Transferido
       AADD(aDbfStr,{"cNewIndJui","Character",008,0}) // Indicador traslado
       AADD(aDbfStr,{"cNewNivJui","Character",002,0}) // Nivel traslado
       AADD(aDbfStr,{"cNewProJui","Character",006,0}) // Profesor que traslador el indicador
*/
       AADD(aDbfStr,{"cNomUsrJui","Character",010,0}) // Nombre del Usuario
       AADD(aDbfStr,{"dFecUsrJui","Date"     ,008,0}) // Fecha del Usuario
       AADD(aDbfStr,{"cHorUsrJui","Character",010,0}) // Hora del Usuario
*>>>>FIN DECLARACION DE LA ESTRUCTURA

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
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 18/95 SAB A
       Bucaramanga,Colombia         INICIO: 04:00 PM   FEB 18/95 SAB

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfJui(lShared,nModCry,PathArc,fArchvo,FileNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE CUENTAS")
       Termometro(100)
       CreaDbfJui(lShared,nModCry,PathArc,fArchvo,FileNtx)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/2003 DOM A
       Colombia, Bucaramanga        INICIO: 11:00 PM   FEB 02/2003 DOM

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

FUNCTION nActStrJui(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo */
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
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'JUI',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE JUICIOS')
	  CloseDbf('JUI',PathArc+'\'+fArchvo,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := JUI->(DBSTRUCT())
       CloseDbf('JUI',PathArc+'\'+fArchvo,nModCry)
       CreaDbfJui(lShared,nModCry,PathArc,fArchvo,,@aStrNew)
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
	  cError('El Archivo JUICIOS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfJui(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: NOMBRE DEL INDICADOR                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 13/2002 SAB A
       Bucaramanga,Colombia         INICIO: 12:00 AM   ABR 13/2002 SAB

OBJETIVOS:

1- Convierte el nombre del Indicador en May£sculas o Min£sculas

2- Retorna el nombre del Indicador

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomInd(cNomInd,lIndMin,cTipPrn,lMayUno)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomInd                              // Nombre del Indicador
       lIndMin                              // Indicador en Min£scula
       cTipPrn                              // Tipo de Impresi¢n 0=>Normal 1=>Min£cula 2=>May£scula
       lMayUno                              // .T. Primera Letra en May£scula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>NOMBRE DEL INDICADOR
       DO CASE
       CASE !lIndMin .AND. cTipPrn == '1'
	    IF lMayUno
	       cNomInd := SUBS(cNomInd,1,1)+LOWER(SUBS(cNomInd,2,106))
	    ELSE
	       cNomInd := LOWER(cNomInd)
	    ENDIF

       CASE lIndMin .AND. cTipPrn == '2'
	    cNomInd := UPPER(cNomInd)
       ENDCASE

       RETURN cNomInd
*>>>>FIN NOMBRE DEL INDICADOR

