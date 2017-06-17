/* SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PRINCIPAL DE PLUSCONT
SUBMODULO...: PRINCIPAL

**************************************************************************
* TITULO..: MENU PRINCIPAL DE LA CONTABILIDAD ACADEMICA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 17/2006 ABR A
       Colombia, Bucaramanga        INICIO: 01:45 AM   MAR 17/2006 ABR

REQUERIMIENTOS:

1- Para que el programa funcione es necesario que esten presentes los
   programas que invoca. NO REQUIERE DE MODULO DE REQUERIMIENTOS

OBJETIVOS:

1- Visualiza todos los men£s de la aplicacion

2- Ejecuta cada una de las funciones de la aplicaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*       #INCLUDE "CAMPOS\INS-CONT.PRG"       // Detalles de Instalaci¢n
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #INCLUDE "CAMPOS\VER-CONT.PRG"       // Detalles del N£mero de Versi¢n

       LOCAL cEmpPal := ''                  // Nombre de la Comunidad
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cPaises := ''                  // Nombre del Pais
       LOCAL cNomDpt := ''                  // Nombre del Departamento
       LOCAL cNomMun := ''                  // Nombre del Municipio
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL nSysOpe := 0                   // Sistema Operativo 0=>Windows 1=>Novell 2=>Linux
       LOCAL cDerSys := ''                  // Derechos del Sistema
       LOCAL cPwdSis := ''                  // PassWord Creaci¢n usuarios
       LOCAL nPrueba := 0                   // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
       LOCAL cAnoHab := ''                  // A¤o Habilitado
       LOCAL cMesHab := ''                  // Mes Habilitado
       LOCAL cPwdHar := ''                  // Serial del HardWare
       LOCAL lPiePag := .T.                 // .T. Impresi¢n Pie de P gina
       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cJornad := ''                  // Jornadas habilitadas
       LOCAL nPerHab := 0                   // Periodo Habilitado
       LOCAL cPwdIns := ''                  // Serial de Instalaci¢n
       LOCAL cDirEmp := ''                  // Directorio de la Empresa
     *ÀDetalles de Instalaci¢n.

       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n
       LOCAL lNovell := .F.                 // .T. Red Novell .F. Red Win NT

       LOCAL cTipSis := ''                  // Tipo de Sistema

       LOCAL nOpcion := 1                   // Opci¢n del SubMen£
       LOCAL nOpcPal := 0                   // Opci¢n principal
       LOCAL nFilSup := 0                   // Fila Superior del men£
       LOCAL xColSup := NIL                 // Columna(s) para el men£
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cDerech := ''                  // Derechos del usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL nColAno := NIL                 // Columna del A¤o
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cPatSis := ''                  // Path del sistema

       LOCAL cJorTxt := ''                  // Jornada escogida
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cIniJor := ''                  // Iniciales de la jornada
       LOCAL cNivTxt := ''                  // Maestro escogido
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior para el men£
       LOCAL cTitInf := ''                  // T¡tulo Inferior para el men£
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£

       LOCAL GetList := {}                  // Variable para el sistema
       MEMVA xClrSys			    // Color del Sistema
       CLOSE ALL                            // Cierre de las Bases de Datos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA LICENCIA
       xClrSys := ''
       IF !lLicencia(PathSis+'\'+FileDat,;
		     @cEmpPal,@cNitEmp,@cNomEmp,@cCodEmp,@cPaises,@cNomDpt,;
		     @cNomMun,@cNomSec,@lShared,@nModCry,@nSysOpe,@cDerSys,;
		     @cPwdSis,@nPrueba,@cAnoHab,@cMesHab,@cPwdHar,@lPiePag,;
		     @cMaeAlu,@cJornad,@nPerHab,@cPwdIns,@cDirEmp)
	  cError('ERROR No.'+cVerSis)
	  CloseAll()
	  CLEAR
	  QUIT
       ENDIF
       CLEAR
*>>>>FIN LECTURA DE LA LICENCIA

*>>>>ANALISIS DEL TIPO DE SISTEMA
       lNovell := IF(nSysOpe==1,.T.,.F.)
       cTipSis += 'VERSION:'+cVerSis+' DEPURACION. USUARIO: '
*>>>>FIN ANALISIS DEL TIPO DE SISTEMA

*>>>>LICENCIA DE USO A FAVOR
       cNomSis := 'SISTEMA DE CONTABILIDAD ACADEMICA'

*       IniConta(cNomEmp,cNomSis,lIntUno,cTipSis)
      *Inicializaci¢n del sistema
*>>>>FIN LICENCIA DE USO A FAVOR

*>>>>DISE¥O PUBLICITARIO
       xClrSys := xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
			     PathSis,FileClr,PathSis,fSimaCo)

       LogoSys(cNomSis,cNomEmp)

       cSavPan := SAVESCREEN(0,0,24,79)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cVerSis+'.'+cNomSis)
*>>>>FIN DISE¥O PUBLICITARIO

*>>>>LECTURA DEL USUARIO
       cDerech := cUsuario(lShared,PathSis,FileAaa,@cNomUsr,cPwdSis)
       IF cDerech == NIL .OR. !('1' $ SUBS(cDerech,1,100))
	  CloseAll()
	  QUIT
       ENDIF
*      cDerech := REPL('1',111)
*>>>>FIN LECTURA DEL USUARIO

*>>>>CERTIFICACION DE LOS DERECHOS
       cDerech := cDerechSys(cDerSys,cDerech)
       IF VAL(cDerech) == 0
	  CloseAll()
	  cError('EL USUARIO '+ALLTRIM(cNomUsr)+' NO TIENE ACCESO AL SISTEMA')
	  QUIT
       ENDIF
*>>>>FIN CERTIFICACION DE LOS DERECHOS

*>>>>LECTURA DEL A¥O DE LA APLICACION
       cAnoUsr := STR(YEAR(DATE()),4)
       @14,34 SAY "A¥O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
       LicAnoMes(cAnoHab,cAnoUsr,cMesHab)
*>>>>FIN LECTURA DEL A¥O DE LA APLICACION

*>>>>MAESTROS Y JORNADAS HABILITADAS
       IF FILE(cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
	       FConAno+cAnoUsr+ExtFile)

	  MaeHab(lShared,nModCry,;
		 cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
		 FConAno+cAnoUsr+ExtFile,;
		 @cMaeAlu,@cJornad,'ANO->cMaeHabCoA','ANO->cJorHabCoA')

       ENDIF
*>>>>FIN MAESTROS Y JORNADAS HABILITADAS

*>>>>LECTURA DE LAS JORNADAS DE ESTUDIO
       cMaeAct := cNivelEst(16,30,cMaeAlu,@cNivTxt)
       cIniJor := cJornada(16,30,cJornad,@cJorTxt)
       cPatSis := cAnoUsr+'.'+cIniJor

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LAS JORNADAS DE ESTUDIO

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := aMenusCont(0,SUBS(cDerech,101,10),@aHelp)
	      aMenu := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenu,i)
		aMenu[i] := SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
**********FIN SELEECION DEL MENU PRINCIPAL

**********CAMBIO DEL A¥O DEL SISTEMA
	    LineaEstado('<F2>CAMBIA A¥O. '+;
			'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)

	    cTitSup := cTipSis+ALLTRIM(cNomUsr)
	    cTitInf := 'A¥O: '+cAnoUsr+' '+cNivTxt+' JORNADA: '+cJorTxt
	  *ÀT¡tulos para el menu

	    nColAno := AT("A¥O: ",cTitInf)

	    SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
				     @cPatSis,cNomEmp,cNomSis)})
**********FIN CAMBIO DEL A¥O DEL SISTEMA

**********EJECUCION DEL MENU PRINCIPAL
	    nFilSup := 00
	    xColSup := aColOpc(aMenu,NIL,.T.)
	  *ÀCalculo coordenadas del men£

	    nOpcion := nMenu(aMenu,aHelp,nFilSup,xColSup,;
			     cTitSup,cTitInf,nOpcion,,;
			     IF(!EMPTY(xClrSys),xClrSys[2],''))

	    cSavPan := SAVESCREEN(0,0,24,79)
**********FIN EJECUCION DEL MENU PRINCIPAL

**********ANALISIS PARA LA TERMINACION DEL PROGRAMA
	    IF nOpcion = 0
	       CLEAR
	       EXIT
	    ENDIF
	    nOpcPal := VAL(SUBS(aDeMenu[nOpcion],1,1))
	   *Opci¢n del men£ principal
**********FIN ANALISIS PARA LA TERMINACION DEL PROGRAMA

**********EJECUCION DE LAS OPCIONES
	    Depura(lShared,lNovell,cNomSis,cEmpPal,cCodEmp,;
		   cNitEmp,cNomEmp,cNomDpt,cNomMun,nFilSup+2,;
		   xColSup,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
		   lIntUno,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
		   cJorTxt,cJornad,nColAno,nOpcion,nOpcPal,;
		   cDerech,cSavPan)

	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       QUIT
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA

/*************************************************************************
* TITULO...: EJECUCION MENUS PRIMER NIVEL                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 19/94 LUN A
						       DIC 19/94 LUN
OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Depura(lShared,lNovell,cNomSis,cEmpPal,cCodEmp,cNitEmp,;
		cNomEmp,cNomDpt,cNomMun,nFilPal,aColSup,cNomUsr,;
		cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		cMaeAlu,cMaeAct,cJorTxt,cJornad,nColAno,nOpcion,;
		nOpcPal,cDerech,cSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       lNovell                              // .T. Red Novell .F. Red Win NT
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cCodEmp                              // C¢digo de la Empresa
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
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
       cJornad                              // Jornadas habilitadas
       nColAno                              // Columna A¤o del sistema
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       cDerech                              // Derechos del Usuario
       cSavPan                              // Salvar Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL cPatInt := ''                  // Path de Integraci¢n
       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL nFilInf := 0                   // Fila Inferior del Sub_men£
       LOCAL nColInf := 0                   // Columna Inferior del Sub_men£
       LOCAL       i := 0                   // Contador
       LOCAL cOrden  := ''                  // Orden para Ejecutar

       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSec := ''                  // Nombre secundario

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL lPrueba := .F.                 // .T. Activar Modificaciones

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>OPCIONES A DEPURAR

/*

	       MantenHab(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
			 nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
			 lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
			 cJorTxt,cJornad)
	      *Mantenimiento de Habilitaciones


		      Conta_205(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomDpt,cNomMun,nFilPal,nFilInf,;
				nColInf,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				cJorTxt,cJornad)
*/

	    Conta_411(lShared,lNovell,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      cNomDpt,cNomMun,nFilPal,nFilInf,nColInf,cNomUsr,;
		      cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		      cMaeAlu,cMaeAct,cJorTxt,cJornad)
	   *Juicios Valorativos


      CloseAll()
      RETURN NIL
*>>>>FIN OPCIONES A DEPURAR




