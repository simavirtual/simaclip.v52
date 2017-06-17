/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : PRINCIPAL
SUBMODULO...: PRINCIPAL

**************************************************************************
* TITULO..: SISTEMA CONTABILIDAD ACADEMICA PARA PROFESORES               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/1996 MAR A
       Colombia, Bucaramanga        INICIO: 11:55 AM   MAR 04/1996 MAR

OBJETIVOS:

1- Visualiza todos los men£s de la aplicacion

2- Ejecuta cada una de las funciones de la aplicaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema
       #INCLUDE "CAMPOS\VER-PROF.PRG"       // Detalles del N£mero de Versi¢n

       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL aP1 := {}                  // Parametros Generales

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
       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior para el men£
       LOCAL cTitInf := ''                  // T¡tulo Inferior para el men£
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£

       LOCAL PathAct := ''                  // Path Actual
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := ''                  // Hora de Inicio
     *ÀVariables del Log


       LOCAL lMemUsb := .F.                 // .T. SimaProf en Usb. .F. SimaProf en la Red
       LOCAL cUnidad := ''                  // Unidad del Sima
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
*>>>>FIN LECTURA DE LA LICENCIA

*>>>>LECTURAS PARA PRUEBA DE PARAMETROS GENERALES
       CLEAR
       IF nPrueba == 1

	  IF lPregunta('Realizar pruebas parametros generales? Si No')
	     lShared := lPregunta('Sistema en Red? Si No')

	     cJornad := 'DNMT'
	     @ 21,01 SAY 'JORNADAS:' GET cJornad PICT '@!'
	     READ
	     cJornad := ALLTRIM(cJornad)
	   *ÀJornadas de Estudio

	     cMaeAlu := 'GUAJARPRIBTO'
	     @ 21,01 SAY 'MAESTROS:' GET cMaeAlu PICT '@!'
	     READ
	     cMaeAlu := ALLTRIM(cMaeAlu)
	   *ÀMaestros habilitados
	  ENDIF

       ENDIF
*>>>>FIN LECTURAS PARA PRUEBA DE PARAMETROS GENERALES

*>>>>VALIDACION DE ESTRUCTURAS
       IF !FILE(PathSis+'\'+fSimSpr)
	  RecuSimSpr(lShared,nModCry,PathSis,fSimSpr)
       ENDIF
       nActSimSpr(lShared,nModCry,PathSis,fSimSpr)
*>>>>FIN VALIDACION DE ESTRUCTURAS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  QUIT
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  QUIT
       ENDIF

       lMemUsb := SPR->lMemUsbSpr
       cUnidad := SPR->cUnidadSpr
       cCodPro := SPR->cCodProSpr

       CloseAll(aUseDbf)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DEL TIPO DE SISTEMA
       lNovell := IF(nSysOpe==1,.T.,.F.)
       cTipSis += 'VERSION:'+cVerSis+;
		  IF(lShared,' RED '+cNomSysOpe(nSysOpe)+;
			     IF(nSysOpe==1,' V'+NNETVER(),''),;
		     ' MONO-')+' USUARIO: '
*>>>>FIN ANALISIS DEL TIPO DE SISTEMA

*>>>>LICENCIA DE USO A FAVOR
       cNomSis := 'SISTEMA DE CONTABILIDAD PARA PROFESORES.'+;
		  IF(lMemUsb,'USB','')

*      KeySistema(lShared,cNomSis,aKeySis)
      *Control del sistema

       IniSistema()
      *Inicializaci¢n del sistema
*>>>>FIN LICENCIA DE USO A FAVOR

*>>>>DISE¥O PUBLICITARIO
       xClrSys := xLeeClrSys(lShared,nModCry,cNomSis,;
			     cNomEmp,PathSis,FileClr,PathSis,fSimSpr)
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

*>>>>CREACION CONFIGURACION DEL A¥O
       cPatSis := cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))

       IF !FILE(cPatSis+'\'+fSprAno+cAnoUsr+ExtFile)

	  PathAct := cPathAct()
	  Mdir(cPatSis,PathAct)

	  CreaSprAno(lShared,nModCry,cPatSis,;
		     fSprAno+cAnoUsr+ExtFile)
       ENDIF
*>>>>FIN CREACION CONFIGURACION DEL A¥O

*>>>>MAESTROS Y JORNADAS HABILITADAS
       IF FILE(cPatSis+'\'+fSprAno+cAnoUsr+ExtFile)

	  nActSprAno(lShared,nModCry,cPatSis,;
		     fSprAno+cAnoUsr+ExtFile)

	  MaeHab(lShared,nModCry,;
		 cPatSis+'\'+;
		 fSprAno+cAnoUsr+ExtFile,;
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  QUIT
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

/*
       CASE !lngresoSys(SPR->cAnoIniSpr,;
			SPR->cAnoFinSpr,;
			SPR->cAnoHabSpr,;
			cNomUsr,cAnoUsr,;
			SPR->cSysHabSpr,;
			SPR->dFecHabSpr,;
			SPR->cHorHabSpr,;
			PRA->cSysHabAno)
*/

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       CloseAll()

       IF lHayErr
	  QUIT
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE PATHS
       IF !PathSprAno(lShared,nModCry,cAnoUsr,cPatSis,;
		      @PathUno,@PathDos,@PathTre,@PathCua)
	  CloseAll()
	  QUIT
       ENDIF
       PathUno := IF(lMemUsb,PathSCO,PathUno)
*>>>>FIN LECTURA DE PATHS

*>>>>PARAMETROS GENERALES No.1
       aP1 := {}
       AADD(aP1,{'lShared',lShared})
       AADD(aP1,{'nModCry',nModCry})
       AADD(aP1,{'cCodSui',cCodSui})
       AADD(aP1,{'cNomSis',cNomSis})
       AADD(aP1,{'cCodEmp',cCodEmp})
       AADD(aP1,{'cLogEmp',cLogEmp})
     *ÀDetalles del Sistema

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

       AADD(aP1,{'cEmpPal',cEmpPal})
       AADD(aP1,{'cNitEmp',cNitEmp})
       AADD(aP1,{'cNomEmp',cNomEmp})
       AADD(aP1,{'cNomSec',cNomSec})
       AADD(aP1,{'cCodEmp',cCodEmp})
     *ÀDetalles de la Empresa

       AADD(aP1,{'cNomUsr',cNomUsr})
       AADD(aP1,{'cAnoUsr',cAnoUsr})
       AADD(aP1,{'cAnoSis',SUBS(cAnoUsr,3,2)})
       AADD(aP1,{'cPatSis',cPatSis})
     *ÀDetalles del Usuario

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

       AADD(aP1,{'lMemUsb',lMemUsb})
       AADD(aP1,{'cUnidad',cUnidad})
       AADD(aP1,{'cCodPro',cCodPro})
       AADD(aP1,{'cPatPro',cPatPro})
       AADD(aP1,{'cNomPro',cNomPro})
*>>>>FIN PARAMETROS GENERALES No.1

*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(aP1,cSavPan)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA

*>>>>LECTURA DEL USUARIO PROFESOR
       cSavPan := SAVESCREEN(0,0,24,79)

       cPatPro := cUsrPro(lShared,cNomSis,cPatSis,cNomUsr,cAnoUsr,cMaeAct,;
			  lMemUsb,@cCodPro,@cNomPro)

       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(cPatPro)
	  CLOSE ALL
	  CLEAR
	  QUIT
       ENDIF
       cHorIni := TIME()

       nParameSet(aP1,'cCodPro',cCodPro)
       nParameSet(aP1,'cPatPro',cPatPro)
       nParameSet(aP1,'cNomPro',cNomPro)
*>>>>FIN LECTURA DEL USUARIO PROFESOR

*>>>>ALTERACION DE LOS DERECHOS DEL USUARIO
       IF '999999' $ cPatPro

	  cDerech := cCambiaDer('0101',cDerech)

	  IF ALIAS(SELECT('PRO')) == 'PRO' .AND.;
	     !EMPTY(PRO->cCodPazPro)
	     cDerech := cCambiaDer('01010108',cDerech)
	  ENDIF

       ENDIF
*>>>>FIN ALTERACION DE LOS DERECHOS DEL USUARIO

*>>>>CREACION DE ARCHIVO DEL LOG DEL PROFESOR
       IF !FILE(cPatPro+'\'+FileLog)
	  CreaProLog(lShared,nModCry,cPatPro,FileLog)
       ENDIF
       nActStrLog(lShared,nModCry,cPatPro,FileLog)
*>>>>FIN CREACION DE ARCHIVO DEL LOG DEL PROFESOR

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := aMenusProf(0,SUBS(cDerech,101,10),@aHelp)
	      aMenu := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenu,i)
		aMenu[i] := SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
**********FIN SELEECION DEL MENU PRINCIPAL

**********CAMBIO DEL A¥O DEL SISTEMA
*	    LineaEstado('<F2>CAMBIA A¥O. '+;
*			'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)

*	    cTitSup := cTipSis+ALLTRIM(cNomUsr)
	    cTitSup := cTipSis+ALLTRIM(cNomUsr)+;
		       '. PROFESOR: '+ALLTRIM(cNomPro)
	    cTitInf := 'A¥O: '+cAnoUsr+' '+cNivTxt+' JORNADA: '+cJorTxt
	  *ÀT¡tulos para el menu

	    nColAno := AT("A¥O: ",cTitInf)

*	    SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
*				     @cPatSis,cNomEmp,cNomSis)})
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
		     nColAno,cSavPan,lMemUsb,cCodPro,cPatPro,;
		     cNomPro)
	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       CLEAR
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA

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


/*************************************************************************
* TITULO..: VALIDACION DEL INGRESO AL SISTEMA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 04/2009 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   FEB 04/2009 MIE

OBJETIVOS:

1- Crea la estructura del archivo Profesor

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lngresoSys(cAnoIni,cAnoFin,cAnoHab,cNomUsr,cAnoUsr,;
		    cSysHab,dFecHab,cHorHab,cSysAno)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoIni                              // A¤o Inicial del Sistema
       cAnoFin                              // A¤o Final del Sistema
       cAnoHab                              // A¤o Habilitado
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cSysHab                              // Ingreso Habilitado al Sistema
       dFecHab                              // Fecha de Cierre del Sistema
       cHorHab                              // Hora de Cierre del Sistema
       cSysAno                              // Ingreso al A¤o Habilitado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL INGRESO AL SISTEMA
       lHayErr := .T.
       DO CASE

       CASE UPPER(ALLTRIM(cNomUsr)) # 'SUPER' .AND.;
	    !EMPTY(cSysHab)

*	    cError('NO ESTA HABILITADO EL INGRESO AL SISTEMA')

       CASE UPPER(ALLTRIM(cNomUsr)) # 'SUPER' .AND.;
	    DATE() == dFecHab	 .AND.;
	    EMPTY(cHorHab)

	    cError('EL INGRESO AL SISTEMA SE CERRO HOY '+cFecha(dFecHab))

       CASE UPPER(ALLTRIM(cNomUsr)) # 'SUPER' .AND.;
	    !EMPTY(dFecHab)           .AND.;
	    DATE() > dFecHab

	    cError('EL INGRESO AL SISTEMA SE CERRO EN '+cFecha(dFecHab))

       CASE UPPER(ALLTRIM(cNomUsr)) # 'SUPER' .AND.;
	    DATE() == dFecHab	 .AND.;
	    nHoraSeg(TIME()) > nHoraSeg(cHorHab)

	    cError('EL INGRESO AL SISTEMA SE CERRO A LAS '+cHorHab)

       CASE UPPER(ALLTRIM(cNomUsr)) # 'SUPER' .AND. !EMPTY(cSysAno) .AND.;
	    cAnoFin # cSysAno

	    cError('NO ESTA HABILITADO EL INGRESO AL A¥O:'+cAnoUsr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       RETURN !lHayErr
*>>>>FIN VALIDACION DEL INGRESO AL SISTEMA
