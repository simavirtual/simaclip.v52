/* SIMA - CUENTAS POR PAGAR

MODULO: PRINCIPAL DEL SISTEMA

**************************************************************************
* TITULO..: MENU PRINCIPAL CUENTAS POR PAGAR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 23/2004 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   AGO 23/2004 LUN

OBJETIVOS:

1- Visualiza todos los men£s de la aplicacion

2- Ejecuta cada una de las funciones de la aplicaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-PAGO.PRG"       // Archivos del Sistema
       #INCLUDE "CAMPOS\VER-PAGO.PRG"       // Detalles del N£mero de Versi¢n

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
       LOCAL cPatDat := ''                  // Path datos del Sistema
       LOCAL cPatSys := ''                  // Path del Sistema
       LOCAL cPatSis := ''                  // Path del sistema

       LOCAL       i := 0                   // Contador
       LOCAL cJorTxt := ''                  // Jornada escogida
       LOCAL cMaeHab := ''                  // Maestros Habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cIniJor := ''                  // Iniciales de la jornada
       LOCAL cNivTxt := ''                  // Maestro escogido
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL cTitSup := ''                  // T¡tulo Superior para el men£
       LOCAL cTitInf := ''                  // T¡tulo Inferior para el men£
       LOCAL cModem  := ''                  // Banco de la Gerencia Electr¢nica
       LOCAL cEmpCob := ''                  // Empresa para Cobro de la Cartera
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL lHayFec := .T.                 // .T. Hay Fecha del Sistema

       LOCAL GetList := {}                  // Variable para el sistema
       MEMVA xClrSys			    // Color del Sistema
       CloseAll()                           // Cierre de las Bases de Datos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA LICENCIA
*       BLICPUREL(50)

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
*>>>>FIN LECTURA DE LA LICENCIA

*>>>>LECTURAS PARA PRUEBA DE PARAMETROS GENERALES
       CLEAR
       IF nPrueba == 1

	  IF lPregunta('Realizar pruebas parametros generales? Si No')

	     lShared := lPregunta('Sistema en Red? Si No')

	     cNomEmp := SPACE(50)
	     @ 20,01 SAY 'EMPRESA:' GET cNomEmp PICT '@!'
	     READ
	     cNomEmp := ALLTRIM(cNomEmp)
	   *ÀNombre de la Empresa

	     nModCry := 0
	     @ 22,01 SAY 'MODO DE PROTECION:' GET nModCry PICT '9'
	     READ
	   *ÀModo de Protecci¢n

	  ENDIF

       ENDIF
*>>>>FIN LECTURAS PARA PRUEBA DE PARAMETROS GENERALES

*>>>>ANALISIS DEL TIPO DE SISTEMA
       lNovell := IF(nSysOpe==1,.T.,.F.)
       cTipSis += 'VERSION:'+cVerSis+;
		  IF(lShared,' RED '+cNomSysOpe(nSysOpe)+;
			     IF(nSysOpe==1,' V'+NNETVER(),''),;
		     ' MONO-')+' USUARIO: '
*>>>>FIN ANALISIS DEL TIPO DE SISTEMA

*>>>>LICENCIA DE USO A FAVOR
       cNomSis := 'SISTEMA DE CUENTAS POR PAGAR'

*       KeySistema(lShared,cNomSis,aKeySis)
      *Control del sistema

       IniSistema(nModCry,lShared)
      *Inicializaci¢n del sistema
*>>>>FIN LICENCIA DE USO A FAVOR

*>>>>DISE¥O PUBLICITARIO
       xClrSys := xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
			     PathSis,FileClr,PathSis,fSimCxP)
       LogoSys(cNomSis,cNomEmp)

       cSavPan := SAVESCREEN(0,0,24,79)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cVerSis+'.'+cNomSis)
*>>>>FIN DISE¥O PUBLICITARIO

*>>>>LECTURA DEL USUARIO
       cDerech := cUsuario(lShared,PathSis,FileAaa,@cNomUsr,cPwdSis,lHayFec)
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

*>>>>LECTURA DEL A¥O DEL USUARIO
       cAnoUsr := STR(YEAR(DATE()),4)
       @ 14,34 SAY "A¥O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
       LicAnoMes(cAnoHab,cAnoUsr,cMesHab)
       PathSysCxP(lShared,nModCry,cDirEmp,@cPatDat,@cPatSys)
*>>>>FIN LECTURA DEL A¥O DEL USUARIO

*>>>>CREACION DEL PATH DEL SISTEMA
       cPatSis := cAnoUsr
       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN CREACION DEL PATH DEL SISTEMA

*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		  cNomEmp,cNomSec,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
		  cPatSis,cSavPan)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := aMenusSys(0,SUBS(cDerech,101,10),@aHelp)
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
	    cTitInf := 'HOY ES: '+cFecha(DATE())+' A¥O: '+;
		       cAnoUsr+' '+cNivTxt+' JORNADA: '+cJorTxt
	  *ÀT¡tulos para el menu

	    nColAno := AT("A¥O: ",cTitInf)+15

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
	    SubMenus(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		     cNomEmp,cNomSec,nOpcion,nOpcPal,nFilSup+2,xColSup,;
		     cNomUsr,cDerech,cAnoUsr,nColAno,cPatDat,cPatSys,;
		     cPatSis,cSavPan)
	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       SET COLOR TO
       CLEAR
       QUIT
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA