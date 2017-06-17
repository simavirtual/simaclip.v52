
/*                    SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO EMPRESA

REQUERIMIENTOS:

- Compilar: clipper FuncsEmp /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de empresa

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:47 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo empresa

2)- Retorna NIL

SINTAXIS:

   CreaDbfEmp(PathEmp,FileEmp,lSisInt,fNtxEmp)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfEmp(lShared,PathEmp,FileEmp,lIntUno,fNtxEmp)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathEmp				    // Path del Archivo
       FileEmp				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxEmp				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION


*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfEmp := {{"cNombreEmp","Character",40,0},;
			 {"cNroNitEmp","Character",10,0},;
			 {"cDireccEmp","Character",40,0},;
			 {"cTelef1Emp","Character",10,0},;
			 {"cTelef2Emp","Character",10,0},;
			 {"cNroFaxEmp","Character",10,0},;
			 {"cGerentEmp","Character",50,0},;
			 {"cNitGerEmp","Character",40,0},;
			 {"cPasGerEmp","Character",08,0},;
			 {"cSecretEmp","Character",50,0},;
			 {"cNitSecEmp","Character",40,0},;
			 {"cPasSecEmp","Character",08,0},;
			 {"cIntUnoEmp","Character",70,0},;
			 {"cIntDosEmp","Character",70,0},;
			 {"cIntTreEmp","Character",70,0},;
			 {"cIntCuaEmp","Character",70,0},;
			 {"cPorcenEmp","Character",08,0},;
			 {"nProMinEmp","Numeric"  ,04,1},;
			 {"nMinHabEmp","Numeric"  ,04,1},;
			 {"nTipBolEmp","Numeric"  ,01,0},;
			 {"nLinEspEmp","Numeric"  ,01,0},;
			 {"cPatIntEmp","Character",99,0},;
			 {"cUnidadSpr","Character",01,0},;
			 {"lIndNivSpr","Logical"  ,01,0},;
			 {"nTipIndSpr","Numeric"  ,01,0},;
			 {"cIndUnoSpr","Character",04,0},;
			 {"cIndDosSpr","Character",04,0},;
			 {"cIndTreSpr","Character",04,0},;
			 {"cIndCuaSpr","Character",04,0},;
			 {"cIndCinSpr","Character",04,0}}

       LOCAL cPatInt := ''               // Path de la contabilidad
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathEmp) == 0
	    DBCREATE(FileEmp,aDbfEmp,"DBFNTX")

       CASE DIRCHANGE(PathEmp) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathEmp)

       CASE DIRCHANGE(PathEmp) == -5
	    cError('NO TIENE DERECHOS EN: '+PathEmp)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathEmp+'\'+FileEmp,'EMP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO EMPRESAS EN CREACION DE ESTRUCTURAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF EMP->(lRegLock(lShared,.T.))
	  REPL EMP->cPorcenEmp WITH '10203040'
	  REPL EMP->nLinEspEmp WITH 7
	  REPL EMP->nTipBolEmp WITH 3
	  REPL EMP->cIntUnoEmp WITH '\Sima\SimaProf'
	  REPL EMP->cIntDosEmp WITH ''
	  REPL EMP->cIntTreEmp WITH ''
	  REPL EMP->cIntCuaEmp WITH ''
	  EMP->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA LOS DATOS DE LA EMPRESA')
       ENDIF
       IF lShared
	  EMP->(DBUNLOCK())
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:50 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo de Empresa

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfEmp(lShared,PathEmp,FileEmp,lIntUno,fNtxEmp)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathEmp			      // Path del Archivo
       FileEmp			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxEmp			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathEmp+'\'+FileEmp,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE EMPRESA")
       Termometro(100)

       CreaDbfEmp(lShared,PathEmp,FileEmp,lIntUno,fNtxEmp)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURAS PATHS DE INTEGRACION                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:23 AM   MAR 11/96 LUN

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*FUNCTION LeePathInt(lShared,cPatSis,cIntUno,cIntDos,cIntTre,cIntCua,lPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       cIntUno                              // @Path de Integraci¢n uno
       cIntDos                              // @Path de Integraci¢n dos
       cIntTre                              // @Path de Integraci¢n tres
       cIntCua                              // @Path de Integraci¢n cuatro
       lPatSis                              // .T. Incluir Path del sistema*/
*>>>>FIN PARAMETROS DE LA FUNCION
/*
*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileEmp,'EMP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO EMPRESAS EN REVISION')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT EMP
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(EMP->cIntUnoEmp)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(EMP->cIntDosEmp)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(EMP->cIntTreEmp)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(EMP->cIntCuaEmp)+IF(lPatSis,'\'+cPatSis,'')
       CLOSE EMP
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION
*/