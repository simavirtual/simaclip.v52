/*                      SIMA - CONTABILIDAD PROFESORES
		     DETALLES DE INSTALACION DE EMPRESAS

**************************************************************************
* NOMBRE DEL PROGRAMA......: INSTALL.DAT                                 *
* TITULO DEL PROGRAMA......: DETALLES DE INSTALACION                     *
* PROGRAMAS QUE LO INVOCAN.: El programa principal                       *
* PROGRAMAS QUE INVOCA.....: Ninguno                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   MAR 08/96 VIE

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
/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'SIMA. PRUEBA GENERAL'
       LOCAL cMaeAlu := 'GUAJARPRIBTO'      // Maestros habilitados
       LOCAL cJornad := 'DNMT'              // Jornadas habilitadas
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'SIMAMATR'          // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                 // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .T.                 // Tercera Integraci¢n
       LOCAL lIntCua := .T.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .T.                 // Prueba de Paramentros
*/

/*
*                       '123456789012345678901234567890123456789012'
       LOCAL lShared := .F.                    // .T. Sistema Compartido
       LOCAL cNomEmp := 'COLEGIO ABC'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;       // SALLE_ADM => 151146918
			 {cNomEmp,487023780},; // SALA1     => 83951702
			 {cMaeAlu,151152049},; // SALA2     => 83951959
			 {'System',487043842}}
*/

/*
*                       '123456789012345678901234567890123456789012'
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL cNomEmp := 'COLEGIO LA SALLE. BUCARAMANGA'
       LOCAL cMaeAlu := 'PRIBTO'               // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;       // SALLE_ADM => 151146918
			 {cNomEmp,487023780},; // SALA1     => 83951702
			 {cMaeAlu,151152049},; // SALA2     => 83951959
			 {'System',487043842}}
*/


*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'COLEGIO VIRREY SOLIS. BUCARAMANGA'
       LOCAL cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{218343936,23},;      // VIRREY_SOLIS =>201553870
			 {cNomEmp,554226449},; // VIRREY_SOLIS1=>?
			 {cMaeAlu,151152049},; // VIRREY_SOLIS2=>218343936
			 {'System',487043842}}


/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'LICEO HERMANO MIGUEL LA SALLE'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
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
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'INSTITUTO SAN BERNARDO LA SALLE'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'DN'                // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
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
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE BOGOTA'
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
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
*      ENTREGADO      A: ING NESTRO ALEJANDRO PINZON
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'LICEO LA SALLE - ZIPAQUIRA'
       LOCAL cMaeAlu := 'PRI'               // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
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
*                       '123456789012345678901234567890123456789012'
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE - CARTAGENA'
       LOCAL cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;       // SALLE_ADM => 151146918
			 {cNomEmp,487023780},; // SALA1     => 83951702
			 {cMaeAlu,151152049},; // SALA2     => 83951959
			 {'System',487043842}}
*/

/*
*                       '123456789012345678901234567890123456789012'
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE - CARTAGENA'
       LOCAL cMaeAlu := 'PRIBTO'               // Maestros habilitados
       LOCAL cJornad := 'A'                    // Jornadas habilitadas
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;       // SALLE_ADM => 151146918
			 {cNomEmp,487023780},; // SALA1     => 83951702
			 {cMaeAlu,151152049},; // SALA2     => 83951959
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: ENE 27/98
*      ENTREGADO      A: "MARIA EUGENIA"
*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'COLEGIO DEL SAGRADO CORAZON DE JESUS'
       LOCAL cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{218343936,23},;      // VIRREY_SOLIS =>201553870
			 {cNomEmp,554226449},; // VIRREY_SOLIS1=>?
			 {cMaeAlu,151152049},; // VIRREY_SOLIS2=>218343936
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: MAY 14/98
*      ENTREGADO      A: "HNO SILVIO"
*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'INSTITUTO SAN JOSE'
       LOCAL cMaeAlu := 'PRI'                  // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL lShared := .F.                    // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{218343936,23},;      // VIRREY_SOLIS =>201553870
			 {cNomEmp,554226449},; // VIRREY_SOLIS1=>?
			 {cMaeAlu,151152049},; // VIRREY_SOLIS2=>218343936
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: FEB 06/99
*      ENTREGADO      A: "BEN HUR. BARRANCA"
*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'COLEGIO DEL SAGRADO CORAZON DE JESUS'
       LOCAL cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{218343936,23},;      // VIRREY_SOLIS =>201553870
			 {cNomEmp,554226449},; // VIRREY_SOLIS1=>?
			 {cMaeAlu,151152049},; // VIRREY_SOLIS2=>218343936
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: AGO 28/2002
*      ENTREGADO      A: ING NESTRO ALEJANDRO PINZON
*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'NUESTRA SE¥ORA DE LA PRESENTACION. CENTRO'
       LOCAL cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL lShared := .F.                    // .T. Sistema Compartido
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{218343936,23},;      // VIRREY_SOLIS =>201553870
			 {cNomEmp,554226449},; // VIRREY_SOLIS1=>?
			 {cMaeAlu,151152049},; // VIRREY_SOLIS2=>218343936
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: ENE 08/2002
*      ENTREGADO      A: ING NESTRO ALEJANDRO PINZON
*                       '123456789012345678901234567890123456789012'
       LOCAL cNomEmp := 'COLEGIO PARROQUIAL SAN CARLOS. BOGOTA'
       LOCAL cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                    // Jornadas habilitadas
       LOCAL lShared := .T.                    // .T. Sistema Compartido
       LOCAL nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'                // PassWord Creaci¢n usuarios
       LOCAL lUseCry := .F.                    // Bases de datos Incryptadas
       LOCAL lIntUno := .T.                    // Primera Integraci¢n
       LOCAL lIntDos := .T.                    // Segunda Integraci¢n
       LOCAL lIntTre := .F.                    // Tercera Integraci¢n
       LOCAL lIntCua := .F.                    // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                    // Prueba de Paramentros
       LOCAL aKeySis := {{218343936,23},;      // VIRREY_SOLIS =>201553870
			 {cNomEmp,554226449},; // VIRREY_SOLIS1=>?
			 {cMaeAlu,151152049},; // VIRREY_SOLIS2=>218343936
			 {'System',487043842}}
*/
*>>>>FIN DECLARACION DE EMPRESAS INSTALADAS