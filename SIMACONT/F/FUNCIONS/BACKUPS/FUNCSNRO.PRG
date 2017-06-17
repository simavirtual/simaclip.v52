/*                       SIMA - CONTABILIDAD PROFESORES
	  BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO NUMERO DE INDICADORES

REQUERIMIENTOS:

- Compilar: clipper FuncsNro /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo N£mero de Indicadores

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 10:42 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfNro(lShared,PathNro,FileNro,lIntUno,fNtxNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathNro				    // Path del Archivo
       FileNro				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxNro				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfNro := {{"cCodigoNiv","Character",02,0},;
			 {"cCodigoMat","Character",04,0},;
			 {"cCodigoCla","Character",01,0},;
			 {"nTotIndNro","Numeric"  ,03,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathNro) == 0
	    DBCREATE(FileNro,aDbfNro,"DBFNTX")

       CASE DIRCHANGE(PathNro) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathNro)

       CASE DIRCHANGE(PathNro) == -5
	    cError('NO TIENE DERECHOS EN: '+PathNro)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 10:54 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfNro(lShared,PathNro,FileNro,lIntUno,fNtxNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathNro			      // Path del Archivo
       FileNro			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxNro			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathNro+'\'+FileNro,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE NUMERO")
       Termometro(100)

       CreaDbfNro(lShared,PathNro,FileNro,lIntUno,fNtxNro)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO