/*                      SIMA - MATRICULA ACADEMICA
		     DETALLES DE INSTALACION DE EmpresaS

**************************************************************************
* NOMBRE DEL PROGRAMA......: INSTALL.DAT                                 *
* TITULO DEL PROGRAMA......: DETALLES DE INSTALACION                     *
* PROGRAMAS QUE LO INVOCAN.: El programa principal                       *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 27/96 MAR A
       Colombia, Bucaramanga        INICIO: 03:45 PM   FEB 27/96 MAR

REQUERIMIENTOS:

1- Para que el programa funcione se debe invocar utilizando la clausula
   #INCLUDE dentro de la funcion que lo va a utilizar.

OBJETIVOS:

1- Declara todas las variables que contiene los detalles de instalaci¢n
   de cada una de las Empresas a las cuales se le ha instalado el sistema.

2- El objetivo principal es controlar los detalles de instalaci¢n de
   cada Empresa.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/
* LUIS ALBERTO MORA (091)3331702-3335529-3465749-5617470
* INTERAMERICANA DE IMPRESOS GRAFICOS
* TELEFONO DE LA BIBLIOTECA 6572560

*>>>>DECLARACION DE EMPRESAS INSTALADAS
/*
*      FECHA DE ENTREGA: JUL 04/2001 HORA:04:30
*      ENTREGADO: ING. NESTOR ALEJANDRO PINZON
       LOCAL cEmpPal := 'SIMASOFT'
       LOCAL cNitEmp := '999999999'
       LOCAL cNomEmp := 'SIMASOFT'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .T.                 // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;    // 151146918
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*                                                                |         |
*      FECHA DE ENTREGA: JUL 04/2001 HORA:04:30
*      ENTREGADO: ING. NESTOR ALEJANDRO PINZON
       LOCAL cEmpPal := 'COLEGIO ABC'
       LOCAL cNitEmp := '99999999999'
       LOCAL cNomEmp := 'COLEGIO ABC'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados OJO JAR
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
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
*/

/*
*                                                                |         |
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO LA SALLE. BUCARAMANGA'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
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
*/


       LOCAL cEmpPal := 'COMUNIDAD FRANCISCANA'
       LOCAL cNitEmp := '860020342-1'
       LOCAL cNomEmp := 'COLEGIO VIRREY SOLIS. BUCARAMANGA'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'REYSOL'            // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendiente Salas 1 y 2
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}


/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'LICEO HERMANO MIGUEL LA SALLE'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'INSTITUTO SAN BERNARDO LA SALLE'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'DN'                // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      ENTREGADO: NOV 20/2001
       LOCAL cEmpPal := 'ASOPAF-INSTITUTO SAN BERNARDO LA SALLE'
       LOCAL cNitEmp := '800056408-4'
       LOCAL cNomEmp := 'ASOPAF-INSTITUTO SAN BERNARDO LA SALLE'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'DN'                // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'LICEO LA SALLE - ZIPAQUIRA'
       LOCAL cMaeAlu := 'PRI'               // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO LA SALLE. VILLAVICENCIO'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'DN'                // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      FELIPE CELULAR: 0933859469 - COLEGIO: 0975752220
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO LA SALLE. CUCUTA'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 1                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE - CARTAGENA'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE - CARTAGENA'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'A'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      VLADIMIR CELULAR: 0933859469 - COLEGIO: 0975752220
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE BOGOTA'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      FECHA DE ENTREGA: ENE 27/98
*      ENTREGADO      A: "MARIA EUGENIA"
       LOCAL cEmpPal := 'HERMANAS BETHLEMITAS - BUCARAMANGA'
       LOCAL cNitEmp := '800020449-0'
       LOCAL cNomEmp := 'COLEGIO DEL SAGRADO CORAZON DE JESUS'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
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
*/

/*
*      FECHA DE ENTREGA: OCT 23/98
*      ENTREGADO      A: "GLORIA LUZ PUENTES"
       LOCAL cEmpPal := 'HERMANAS BETHLEMITAS - BARRANCABERMEJA'
       LOCAL cNitEmp := '800020449-0'
       LOCAL cNomEmp := 'COLEGIO SAGRADO CORAZON DE JESUS'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
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
*/

/*
*      FECHA DE ENTREGA: MAY 14/98
*      ENTREGADO      A: "HNO SILVIO"
       LOCAL cEmpPal := 'INSTITUTO SAN JOSE. BUCARAMANGA'
       LOCAL cNitEmp := 'XXXXXXXXX-X'
       LOCAL cNomEmp := 'INSTITUTO SAN JOSE. BUCARAMANGA'
       LOCAL cMaeAlu := 'PRI'               // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
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
*/

/*
*      FECHA DE ENTREGA: SEP 05/2000
*      RECIBO: ING NESTOR ALEJANDRO PINZON

       LOCAL cEmpPal := 'NUESTRA SE¥ORA DE LA PRESENTACION. CENTRO'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'NUESTRA SE¥ORA DE LA PRESENTACION. CENTRO'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      FECHA DE ENTREGA: AGO 28/2002
*      RECIBO: ING NESTOR ALEJANDRO PINZON

       LOCAL cEmpPal := 'NUESTRA SE¥ORA DE LA PRESENTACION. ZIPAQUIRA'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'NUESTRA SE¥ORA DE LA PRESENTACION. ZIPAQUIRA'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      FECHA DE ENTREGA    : ENE 08/2002 HORA: 08:00 AM
*      RECIBO Y VISTO BUENO: ING NESTOR ALEJANDRO PINZON. SISTEMAS

       LOCAL cEmpPal := 'COLEGIO PARROQUIAL SAN CARLOS. BOGOTA'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'COLEGIO PARROQUIAL SAN CARLOS. BOGOTA'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lCodEst := .T.                 // .T. Codigo Generado por el Sistema .F. C¢digo Generado Externamente
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;   // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/
*>>>>FIN DECLARACION DE EMPRESAS INSTALADAS