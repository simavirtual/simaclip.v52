/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INICIO DE A¥O
SUBMODULO...: MATRICULA DE ALUMNOS   MODULO No. 101

**************************************************************************
* NOMBRE DEL PROGRAMA..: CONTA101.PRG                                    *
* TITULO DEL PROGRAMA..: FACTURACION DE UN SOLO RECIBO                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/95 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   MAY 08/95 LUN


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite la matr¡cula de los estudiantes manual o autom tica si la
   contabilidad es de tipo integrada.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_101(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,cNomDpt,;
		   cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,cAnoUsr,cPatSis,;
		   lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   cJornad)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cJornad                              // Jornadas habilitadas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar el pago
       LOCAL Getlist := {}                  // Variable del sistema
       RETURN NIL
*>>>>FIN DECLARACION DE VARIABLES


