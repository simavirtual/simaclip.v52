/*                       SIMA - CONTABILIDAD PROFESORES
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CLASEIND

REQUERIMIENTOS:

- Compilar: clipper FuncsCla /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Clase de Indicadores

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:14 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCla(lShared,PathCla,FileCla,fNtxCla)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCla				    // Path del Archivo
       FileCla				    // Nombre del Archivo
       fNtxCla				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfCla := {{"cCodigoCla","Character",01,0},;
			 {"cNombreCla","Character",20,0},;
			 {"cCodigoMat","Character",04,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCla) == 0
	    DBCREATE(FileCla,aDbfCla,"DBFNTX")

       CASE DIRCHANGE(PathCla) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCla)

       CASE DIRCHANGE(PathCla) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCla)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:16 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCla(lShared,PathCla,FileCla,fNtxCla)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathCla			      // Path del Archivo
       FileCla			      // Nombre del Archivo
       fNtxCla			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCla+'\'+FileCla,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CLASES")
       Termometro(100)

       CreaDbfCla(lShared,PathCla,FileCla,fNtxCla)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO