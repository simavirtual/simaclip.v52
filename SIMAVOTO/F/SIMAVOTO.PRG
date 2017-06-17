/* SIMA - SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR

MODULO      : PRINCIPAL
SUBMODULO...: PRINCIPAL

**************************************************************************
* TITULO..: SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR                                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Visualiza todos los men£s de la aplicacion

2- Ejecuta cada una de las funciones de la aplicaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

PROCEDURE SimaVoto(param1)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cVerSis := ' XML209.02'        // Versi¢n Actual
       LOCAL aP1 := {}                      // Parametros Generales

       LOCAL cLogEmp := ''                  // Logo de la Empresa
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
       LOCAL cCodSui := ''                  // C¢digo del Sistema
     *ÀDetalles de Instalaci¢n.

       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

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

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := ''                  // Hora de Inicio
     *ÀVariables del Log

       LOCAL cPatPro := ''                  // Path del Profesor
       LOCAL cNomPro := ''                  // Nombre del Profesor
       LOCAL cCodPro := ''                  // C¢digo del Profesor

       LOCAL GetList := {}                  // Variable para el sistema
       MEMVA xClrSys			    // Color del Sistema
       CloseAll()                           // Cierre de las Bases de Datos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA LICENCIA
       BLICPUREL(50)

       xClrSys := ''
       IF !lLicencia(PathSis+'\'+FileDat,;
		     @cEmpPal,@cNitEmp,@cNomEmp,@cCodEmp,@cPaises,@cNomDpt,;
		     @cNomMun,@cNomSec,@lShared,@nModCry,@nSysOpe,@cDerSys,;
		     @cPwdSis,@nPrueba,@cAnoHab,@cMesHab,@cPwdHar,@lPiePag,;
		     @cMaeAlu,@cJornad,@nPerHab,@cPwdIns,@cDirEmp,@cCodSui)
	  cError('ERROR No.'+cVerSis)
	  CloseAll()
	  CLEAR
	  QUIT
       ENDIF
       CLEAR
       xClrSys := xLeeClrSys(lShared,nModCry,cNomSis,;
			     cNomEmp,PathSis,FileClr,PathSis,fSimVot)
*>>>>FIN LECTURA DE LA LICENCIA

*>>>>ANALISIS DEL TIPO DE SISTEMA
       cTipSis += 'VERSION:'+cVerSis+IF(lShared,' MULTI-',' MONO-')+;
		  'USUARIO: '
*>>>>FIN ANALISIS DEL TIPO DE SISTEMA

*>>>>LICENCIA DE USO A FAVOR
       cNomSis := 'SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR'

*      KeySistema(lShared,cNomSis,aKeySis)
      *Control del sistema

       IniSistema()
      *Inicializaci¢n del sistema
*>>>>FIN LICENCIA DE USO A FAVOR

*>>>>DISE¥O PUBLICITARIO
       LogoSys(cNomSis,cNomEmp)
       cSavPan := SAVESCREEN(0,0,24,79)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cVerSis+'.'+cNomSis)
*>>>>FIN DISE¥O PUBLICITARIO

*>>>>LECTURA DEL USUARIO
       cDerech := cUsuario(lShared,PathSis,FileAaa,@cNomUsr,cPwdSis)
       IF cDerech == NIL .OR. !('1' $ SUBS(cDerech,1,100))
	  CLOSE ALL
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
       @14,34 SAY "A¥O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
       LicAnoMes(cAnoHab,cAnoUsr,cMesHab)
*>>>>FIN LECTURA DEL A¥O DEL USUARIO

*>>>>MAESTROS Y JORNADAS HABILITADAS
       IF FILE(cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
	       fVotAno+cAnoUsr+ExtFile)

	  nActVotAno(lShared,nModCry,;
		     cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1)),;
		     fVotAno+cAnoUsr+ExtFile)
	*ÀActualizaci¢n. Configuraci¢n del A¤o

	  MaeHab(lShared,nModCry,;
		 cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
		 fVotAno+cAnoUsr+ExtFile,;
		 @cMaeAlu,@cJornad,'ANO->cMaeHabAno','ANO->cJorHabAno')

       ENDIF
*>>>>FIN MAESTROS Y JORNADAS HABILITADAS

*>>>>CREACION DEL PATH DEL SISTEMA
       cMaeAct := cNivelEst(16,30,cMaeAlu,@cNivTxt)
       cIniJor := cJornada(16,30,cJornad,@cJorTxt)
     *ÀLectura de las jornadas de estudio

       cPatSis := cAnoUsr+'.'+cIniJor

       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN CREACION DEL PATH DEL SISTEMA

*>>>>LECTURA DE PATHS
       IF !PathVotAno(lShared,nModCry,cAnoUsr,cPatSis,;
		      @PathUno,@PathDos,@PathTre,@PathCua)
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>PARAMETROS GENERALES No.1
       aP1 := {}
       AADD(aP1,{'lShared',lShared})
       AADD(aP1,{'nModCry',nModCry})
       AADD(aP1,{'cCodSui',cCodSui})
       AADD(aP1,{'cNomSis',cNomSis})
     *ÀDetalles del Sistema

       AADD(aP1,{'cEmpPal',cEmpPal})
       AADD(aP1,{'cNitEmp',cNitEmp})
       AADD(aP1,{'cNomEmp',cNomEmp})
       AADD(aP1,{'cNomSec',cNomSec})
       AADD(aP1,{'cCodEmp',cCodEmp})
       AADD(aP1,{'cLogEmp',cLogEmp})
     *ÀDetalles de la Empresa

       AADD(aP1,{'cNomUsr',cNomUsr})
       AADD(aP1,{'cAnoUsr',cAnoUsr})
       AADD(aP1,{'cAnoSis',SUBS(cAnoUsr,3,2)})
       AADD(aP1,{'cPatSis',cPatSis})
     *ÀDetalles del Usuario

       AADD(aP1,{'PathW01',cPatSis+'\sitios\sitio01'})
       AADD(aP1,{'PathW02',cPatSis+'\sitios\sitio02'})
       AADD(aP1,{'PathW03',cPatSis+'\sitios\sitio03'})
       AADD(aP1,{'PathW04',cPatSis+'\sitios\sitio04'})
       AADD(aP1,{'PathW05',cPatSis+'\sitios\sitio05'})
       AADD(aP1,{'PathW06',cPatSis+'\sitios\sitio06'})
       AADD(aP1,{'PathW07',cPatSis+'\sitios\sitio07'})
       AADD(aP1,{'PathW08',cPatSis+'\sitios\sitio08'})
       AADD(aP1,{'PathW09',cPatSis+'\sitios\sitio09'})
       AADD(aP1,{'PathW10',cPatSis+'\sitios\sitio10'})
     *ÀSitios del Sistema

       AADD(aP1,{'PathUno',PathUno})
       AADD(aP1,{'PathDos',PathDos})
       AADD(aP1,{'PathTre',PathTre})
       AADD(aP1,{'PathCua',PathCua})
     *ÀPath de Integraci¢n

       AADD(aP1,{'nFilPal',nFilSup+2})
       AADD(aP1,{'nFilInf',0})
       AADD(aP1,{'nColInf',0})
     *ÀDetalles Tecnicos

       AADD(aP1,{'cMaeAlu',cMaeAlu})
       AADD(aP1,{'cMaeAct',cMaeAct})
       AADD(aP1,{'cJornad',cJornad})
       AADD(aP1,{'cJorTxt',cJorTxt})
     *ÀDetalles Acad‚micos
*>>>>FIN PARAMETROS GENERALES No.1

*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(aP1,cSavPan)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA

*>>>>SELECION DEL MODO DE EJECUCION
       DO CASE
       CASE param1 == '01'
	    Voto01(aP1)
	  *ÀElecci¢n consejo estudiantil

       CASE param1 == '02'
	    Voto02(aP1)
	  *ÀElecci¢n consejo directivo

       ENDCASE
*>>>>FIN SELECION DEL MODO DE EJECUCION

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0 .AND. EMPTY(param1)

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

	    SETKEY(K_F10,{||LeerFecHora(cNomSis)})

	    nParameSet(aP1,'cPatSis',cPatSis)
	    nParameSet(aP1,'cAnoUsr',cAnoUsr)
	    nParameSet(aP1,'cAnoSis',SUBS(cAnoUsr,3,2))
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
	    nParameSet(aP1,'cMaeAct',cMaeAct)
	  *ÀRestuara el maestro actual

	    SubMenus(aP1,;
		     nOpcion,nOpcPal,xColSup,cDerech,;
		     nColAno,cSavPan)
	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       CLEAR
       QUIT
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA

/* Modificar
*>>>>GRABACION SALIDA DEL INGRESO AL SISTEMA
       AADD(aGenLog,{'nCodigoLog',99})
       AADD(aGenLog,{'cOpcionLog','<INGRESO AL SISTEMA>'})
       AADD(aGenLog,{'cMaeActLog',cMaeAct})

       AADD(aGenLog,{'cNomUsrLog',cNomUsr})
       AADD(aGenLog,{'cHorIniLog',cHorIni})
       AADD(aGenLog,{'cHorFinLog',TIME()})

       AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)})

       AADD(aCamLog,{'cObservLog','DURACION: '+;
		      ALLTRIM(STR(nDifTiempo(DATE(),cHorIni,;
					     DATE(),TIME()),4))+' MIN'})
       GraProLog(lShared,cAnoUsr,cPatSis,cMaeAct,cPatPro,aCamLog,aGenLog)
       QUIT
*>>>>FIN GRABACION SALIDA DEL INGRESO AL SISTEMA
*/