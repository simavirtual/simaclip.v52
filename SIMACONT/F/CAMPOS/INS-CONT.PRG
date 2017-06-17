/*                      SIMA - CONTABILIDAD ACADEMICA
		     DETALLES DE INSTALACION DE EMPRESAS

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
   de cada una de las empresas a las cuales se le ha instalado el sistema.

2- El objetivo principal es controlar los detalles de instalaci¢n de
   cada empresa.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE EMPRESAS INSTALADAS
/*
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'SIMA. PRUEBA GENERAL'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BUCARAMANGA'       // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'DNMT'              // Jornadas habilitadas
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'SIMAMATR'          // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .T.                 // Tercera Integraci¢n
       LOCAL lIntCua := .T.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .T.                 // Prueba de Paramentros
*/

/*
*      FECHA DE ENTREGA: JUL 04/2001 HORA:04:30
*      ENTREGADO: ING. NESTOR ALEJANDRO PINZON
       LOCAL cEmpPal := 'COLEGIO ABC'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'COLEGIO ABC'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BUCARAMANGA'       // Nombre del Municipio
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}
*/


*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO LA SALLE. BUCARAMANGA'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BUCARAMANGA'       // Nombre del Municipio
       LOCAL cMaeAlu := 'PRIBTO'            // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}


/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO VIRREY SOLIS. BUCARAMANGA'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BUCARAMANGA'       // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'            // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;    // Pendiente Salas 1 y 2
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'cNomSis',470225506}}
*/

/*
*      FECHA DE ENTREGA: ABR 13/98 "XXXXXX. Tel: XXXXXXX"
*      ADMINISTRADOR: GREGORI BUSTOS CASA TEL: 2036259
*      LICEO TEL: 6302373
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'LICEO HERMANO MIGUEL LA SALLE'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'CUNDINAMARCA'           // Nombre del Departamento
       LOCAL cNomMun := 'SANTAFE DE BOGOTA D.C'  // Nombre del Municipio
       LOCAL cMaeAlu := 'PRIBTO'                 // Maestros habilitados
       LOCAL cJornad := 'D'                     // Jornadas habilitadas
       LOCAL lShared := .T.                      // .T. Sistema Compartido
       LOCAL lNovell := .T.                      // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'                  // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                      // Primera Integraci¢n
       LOCAL lIntDos := .T.                      // Segunda Integraci¢n
       LOCAL lIntTre := .F.                      // Tercera Integraci¢n
       LOCAL lIntCua := .F.                      // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                      // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;        // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'INSTITUTO SAN BERNARDO LA SALLE'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'CUNDINAMARCA'           // Nombre del Departamento
       LOCAL cNomMun := 'SANTAFE DE BOGOTA D.C'  // Nombre del Municipio
       LOCAL cMaeAlu := 'PRIBTO'                 // Maestros habilitados
       LOCAL cJornad := 'DN'                     // Jornadas habilitadas
       LOCAL lShared := .T.                      // .T. Sistema Compartido
       LOCAL lNovell := .T.                      // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'                  // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                      // Primera Integraci¢n
       LOCAL lIntDos := .T.                      // Segunda Integraci¢n
       LOCAL lIntTre := .F.                      // Tercera Integraci¢n
       LOCAL lIntCua := .F.                      // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                      // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;        // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE BOGOTA'
       LOCAL cNomSec := ''                       // Nombre Secundario
       LOCAL cNomDpt := 'CUNDINAMARCA'           // Nombre del Departamento
       LOCAL cNomMun := 'SANTAFE DE BOGOTA D.C'  // Nombre del Municipio
       LOCAL cMaeAlu := 'PRIBTO'                 // Maestros habilitados
       LOCAL cJornad := 'D'                      // Jornadas habilitadas
       LOCAL lShared := .T.                      // .T. Sistema Compartido
       LOCAL lNovell := .F.                      // .T. Red Novell .F. Red Win
       LOCAL cPasSis := 'ELLAS'                  // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                      // Primera Integraci¢n
       LOCAL lIntDos := .T.                      // Segunda Integraci¢n
       LOCAL lIntTre := .F.                      // Tercera Integraci¢n
       LOCAL lIntCua := .F.                      // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                      // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;        // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

*      FECHA DE ENTREGA: AGO 28/2002
*      ADMINISTRADOR: NESTOR ALEJANDRO PINZON
*      LICEO TEL:
/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'LICEO LA SALLE - ZIPAQUIRA'
       LOCAL cNomSec := ''                       // Nombre Secundario
       LOCAL cNomDpt := 'CUNDINAMARCA'           // Nombre del Departamento
       LOCAL cNomMun := 'SANTAFE DE BOGOTA D.C'  // Nombre del Municipio
       LOCAL cMaeAlu := 'PRI'                    // Maestros habilitados
       LOCAL cJornad := 'D'                      // Jornadas habilitadas
       LOCAL lShared := .F.                      // .T. Sistema Compartido
       LOCAL lNovell := .F.                      // .T. Red Novell .F. Red Win
       LOCAL cPasSis := 'ELLAS'                  // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                      // Primera Integraci¢n
       LOCAL lIntDos := .T.                      // Segunda Integraci¢n
       LOCAL lIntTre := .F.                      // Tercera Integraci¢n
       LOCAL lIntCua := .F.                      // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                      // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;        // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/


*      FECHA DE INSTALACION: FEB 14/2002 JUE EN CARTAGENA
*      RECIBO Y VISTO BUENO: HNO MIGUEL O HNO JAVIER
*      DIRECCION: TORICES PASEO BOLIVAR
*      TEL: 6661173 - 6664758
*      Email:
/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE - CARTAGENA'
       LOCAL cNomSec := ''                       // Nombre Secundario
       LOCAL cNomDpt := 'BOLIVAR'                // Nombre del Departamento
       LOCAL cNomMun := 'CARTAGENA DE INDIAS'    // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'              // Maestros habilitados
       LOCAL cJornad := 'D'                      // Jornadas habilitadas
       LOCAL lShared := .T.                      // .T. Sistema Compartido
       LOCAL lNovell := .F.                      // .T. Red Novell .F. Red Win
       LOCAL cPasSis := 'ELLAS'                  // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                      // Primera Integraci¢n
       LOCAL lIntDos := .T.                      // Segunda Integraci¢n
       LOCAL lIntTre := .F.                      // Tercera Integraci¢n
       LOCAL lIntCua := .F.                      // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                      // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;        // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

*      FECHA DE INSTALACION: FEB 14/2002 JUE EN CARTAGENA
*      RECIBO Y VISTO BUENO: HNO MIGUEL O HNO JAVIER
*      DIRECCION: TORICES PASEO BOLIVAR
*      TEL: 6661173 - 6664758 Ext 111 Cuarto Hno Javier Ext 106 Pasillo
*      Email: Rafael_mejia@hotmail.com
/*
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'CONGREGACION DE LOS HNOS DE LAS ESCUELAS CRISTIANAS'
       LOCAL cNitEmp := '860009985-0'
       LOCAL cNomEmp := 'COLEGIO DE LA SALLE - CARTAGENA'
       LOCAL cNomSec := ''                       // Nombre Secundario
       LOCAL cNomDpt := 'BOLIVAR'                // Nombre del Departamento
       LOCAL cNomMun := 'CARTAGENA DE INDIAS'    // Nombre del Municipio
       LOCAL cMaeAlu := 'PRIBTO'                 // Maestros habilitados
       LOCAL cJornad := 'A'                      // Jornadas habilitadas
       LOCAL lShared := .T.                      // .T. Sistema Compartido
       LOCAL lNovell := .F.                      // .T. Red Novell .F. Red Win
       LOCAL cPasSis := 'ELLAS'                  // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                      // Primera Integraci¢n
       LOCAL lIntDos := .T.                      // Segunda Integraci¢n
       LOCAL lIntTre := .F.                      // Tercera Integraci¢n
       LOCAL lIntCua := .F.                      // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                      // Prueba de Paramentros
       LOCAL aKeySis := {{201553870,23},;        // Pendientes las claves
			 {cNomEmp,554226449},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*/

/*
*      FECHA DE ENTREGA: ENE 27/98
*      ENTREGADO      A: "MARIA EUGENIA"
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'HERMANAS BETHLEMITAS - BUCARAMANGA'
       LOCAL cNitEmp := '800020449-0'
       LOCAL cNomEmp := 'COLEGIO DEL SAGRADO CORAZON DE JESUS'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BUCARAMANGA'       // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}
*/


/*
*      FECHA DE ENTREGA: OCT 24/98
*      ENTREGADO      A: "HNA RECTOR GLORIA LUZ PUENTES"
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'HERMANAS BETHLEMITAS-BARRANCABERMEJA'
       LOCAL cNitEmp := '800020449-0'
       LOCAL cNomEmp := 'COLEGIO SAGRADO CORAZON DE JESUS'
       LOCAL cNomSec := 'HERMANAS BETHLEMITAS-BARRANCABERMEJA' // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BARRANCA'          // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: MAY 14/98
*      ENTREGADO      A: "HNO SILVIO"
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'INSTITUTO SAN JOSE'
       LOCAL cNitEmp := 'XXXXXXXXX-X'
       LOCAL cNomEmp := 'INSTITUTO SAN JOSE. BUCARAMANGA'
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL cNomDpt := 'SANTANDER'         // Nombre del Departamento
       LOCAL cNomMun := 'BUCARAMANGA'       // Nombre del Municipio
       LOCAL cMaeAlu := 'PRI'               // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .T.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: AGO 28/2002
*      ENTREGADO      A: "ING NESTOR ALEJANDRO"
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'NUESTRA SE¥ORA DE LA PRESENTACION. CENTRO'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'NUESTRA SE¥ORA DE LA PRESENTACION. CENTRO'
       LOCAL cNomSec := 'NUESTRA SE¥ORA DE LA PRESENTACION. CENTRO'
       LOCAL cNomDpt := 'CUNDINAMARCA'                 // Nombre del Departamento
       LOCAL cNomMun := 'BOGOTA'            // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}
*/

/*
*      FECHA DE ENTREGA: ENE 08/2002
*      ENTREGADO      A: "ING NESTOR ALEJANDRO"
*                       '123456789012345678901234567890123456789012'
       LOCAL cEmpPal := 'COLEGIO PARROQUIAL SAN CARLOS. BOGOTA'
       LOCAL cNitEmp := '999999999-9'
       LOCAL cNomEmp := 'COLEGIO PARROQUIAL SAN CARLOS. BOGOTA'
       LOCAL cNomSec := 'COLEGIO PARROQUIAL SAN CARLOS. BOGOTA' // Nombre Secundario
       LOCAL cNomDpt := 'CUNDINAMARCA'                 // Nombre del Departamento
       LOCAL cNomMun := 'BOGOTA'            // Nombre del Municipio
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'D'                 // Jornadas habilitadas
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{151146918,23},;    // Adm->151146918 S2->83951702
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',487043842}}
*/
*>>>>FIN DECLARACION DE EMPRESAS INSTALADAS