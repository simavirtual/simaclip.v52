/*                       SIMA - CONTABILIDAD PROFESORES
       BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE MATERIAS PROFESOR

REQUERIMIENTOS:

- Compilar: clipper FuncsMaP /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Cargas

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/


/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAR 12/96 MAR

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfMaP(lShared,PathMaP,FileMaP,fNtxMaP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathMaP				    // Path del Archivo
       FileMaP				    // Nombre del Archivo
       fNtxMaP				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cUnidad := ''                  // Unidad de Disco
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfMaP := {{"cCodigoNiv","Character",02,0},;
			 {"cCodigoMat","Character",04,0},;
			 {"cNombreMat","Character",80,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMBIO A LA UNIDAD DE DISKETTE
       PathAct := cPathAct()
       IF PathMaP == 'A:' .OR. PathMaP == 'B:'
	  cUnidad := DISKNAME()
	  IF !DISKCHANGE(PathMaP)
	     cError('NO SE CAMBIO A LA UNIDAD '+PathMaP)
	  ENDIF
       ENDIF
*>>>>FIN CAMBIO A LA UNIDAD DE DISKETTE

*>>>>CREACION DE LA ESTRUCTURA
       DO CASE
       CASE DIRCHANGE(PathMaP) == 0 .OR. PathMaP == 'A:' .OR. PathMaP == 'B:'
	    DBCREATE(FileMaP,aDbfMaP,"DBFNTX")

       CASE DIRCHANGE(PathMaP) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathMaP)

       CASE DIRCHANGE(PathMaP) == -5
	    cError('NO TIENE DERECHOS EN: '+PathMaP)
       ENDCASE
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>CAMBIO A LA UNIDAD DEL DISCO DURO
       IF PathMaP == 'A:' .OR. PathMaP == 'B:'
	  IF !DISKCHANGE(cUnidad)
	     cError('NO SE CAMBIO A LA UNIDAD '+cUnidad)
	  ENDIF
       ENDIF
       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CAMBIO A LA UNIDAD DEL DISCO DURO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:03 AM   MAR 12/96 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfMaP(lShared,PathMaP,FileMaP,fNtxMaP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathMaP			      // Path del Archivo
       FileMaP			      // Nombre del Archivo
       fNtxMaP			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathMaP+'\'+FileMaP,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE PROFESOR")
       Termometro(100)

       CreaDbfMaP(lShared,PathMaP,FileMaP,fNtxMaP)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV  3/2006 VIE A
       Colombia, Bucaramanga        INICIO:  5:17 PM   NOV  3/2006 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelMap(nNroFil,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF MAP->(RECCOUNT()) == 0
          cError('NO EXISTEN REGISTROS GRABADOS')
          RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
       SELECT MAP
       nFilSup := nNroFil+1
       nColSup := nNroCol+2
       IF nFilSup+RECCOUNT() > 22
          nFilInf := 22
       ELSE
          nFilInf := nFilSup + RECCOUNT()
       ENDIF
       nColInf := 78
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO
       MAP->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||MAP->cCodigoNiv+' '+MAP->cNombreMat})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO
