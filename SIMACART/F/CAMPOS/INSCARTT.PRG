/*                  SIMA - CARTERA ACADEMICA "HERRAMIENTA"
		     DETALLES DE INSTALACION DE EMPRESAS

**************************************************************************
* NOMBRE DEL PROGRAMA......: INSTALL.DAT                                 *
* TITULO DEL PROGRAMA......: DETALLES DE INSTALACION                     *
* PROGRAMAS QUE LO INVOCAN.: El programa principal                       *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 24/98 LUN A
       Colombia, Bucaramanga        INICIO: 05:10 PM   FEB 24/98 LUN

REQUERIMIENTOS:

1- Para que el programa funcione se debe invocar utilizando la clausula
   #INCLUDE dentro de la funcion que lo va a utilizar.

OBJETIVOS:

1- Declara todas las variables que contiene los detalles de instalaci¢n
   de cada una de las empresas a las cuales se le ha instalado el sistema.

2- El objetivo principal es controlar los detalles de instalaci¢n de
   cada empresa.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE EMPRESAS INSTALADAS

*      FECHA DE INSTALACION: FEB 24/98 HORA: 05:10 PM
*      RECIBO Y VISTO BUENO: NELSON. AUTOR
*                                                                |         |
       LOCAL cEmpPal := 'SIMASOFT. BUCARAMANGA'
       LOCAL cNitEmp := '91229913'
       LOCAL cNomEmp := 'SIMASOFT. BUCARAMANGA'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'DNMT'              // Jornadas habilitadas
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;    // 151146918
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*>>>>FIN DECLARACION DE EMPRESAS INSTALADAS