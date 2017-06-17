/*                       SIMA - CONTABILIDAD PROFESORES
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO TABLAEVA

REQUERIMIENTOS:

- Compilar: clipper FuncsEva /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo Tabla de Evaluaci¢n

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:19 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfEva(lShared,PathEva,FileEva,fNtxEva)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathEva				    // Path del Archivo
       FileEva				    // Nombre del Archivo
       fNtxEva				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfEva := {{"cCodigoEva","Character",01,0},;
			 {"cNombreEva","Character",20,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathEva) == 0
	    DBCREATE(FileEva,aDbfEva,"DBFNTX")

       CASE DIRCHANGE(PathEva) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathEva)

       CASE DIRCHANGE(PathEva) == -5
	    cError('NO TIENE DERECHOS EN: '+PathEva)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:21 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfEva(lShared,PathEva,FileEva,fNtxEva)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathEva			      // Path del Archivo
       FileEva			      // Nombre del Archivo
       fNtxEva			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathEva+'\'+FileEva,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE EVALUACION")
       Termometro(100)

       CreaDbfEva(lShared,PathEva,FileEva,fNtxEva)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO