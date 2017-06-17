/*                       SIMA - CARTERA ACADEMICA
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CARTBTO

REQUERIMIENTOS:

- Compilar: clipper FCartTbl /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:55 PM   SEP 26/96 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaCarTbl(lShared,nModCry,PathTbl,fCarTbl,lIntUno,fNtxTbl)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathTbl				    // Path del Archivo
       fCarTbl				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxTbl				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfTbl := {{"Pendiente","Character",10,2}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathTbl) == 0
	    DBCREATE(fCarTbl,aDbfTbl,"DBFNTX")

       CASE DIRCHANGE(PathTbl) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathTbl)

       CASE DIRCHANGE(PathTbl) == -5
	    cError('NO TIENE DERECHOS EN: '+PathTbl)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathTbl+'\'+fCarTbl,'TBL',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE NIVEL')
	  CloseDbf('TBL',PathTbl+'\'+fCarTbl,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF TBL->(lRegLock(lShared,.T.))
	  REPL TBL->Pendiente WITH 'PENDIENTE'
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA TABLA')
       ENDIF
       TBL->(DBCOMMIT())
       IF lShared
	  TBL->(DBUNLOCK())
       ENDIF
       CloseDbf('TBL',PathTbl+'\'+fCarTbl,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 02:10 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuCarTbl(lShared,nModCry,PathTbl,fCarTbl,lIntUno,fNtxTbl)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathTbl			      // Path del Archivo
       fCarTbl			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxTbl			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathTbl+'\'+fCarTbl,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DEL NIVEL")
       Termometro(100)

       CreaCarTbl(lShared,nModCry,PathTbl,fCarTbl,lIntUno,fNtxTbl)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO