/* SIMA - CARTERA ACADEMICA

MODULO      : PRINCIPAL DE SIMACART
SUBMODULO...: PRINCIPAL

**************************************************************************
* NOMBRE DEL PROGRAMA......: SIMACART.PRG                                *
* TITULO DEL PROGRAMA......: MENU PRINCIPAL DE LA MATRICULA ACADEMICA    *
* PROGRAMAS QUE LO INVOCAN.: Ninguno                                     *
* PROGRAMAS QUE INVOCA.....: Todas las funciones principales del sistema *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 15/96 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   FEB 15/96 JUE

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
*       #INCLUDE "CAMPOS\INS-CART.PRG"       // Detalles de Instalaci¢n
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       #INCLUDE "CAMPOS\VER-CART.PRG"       // Detalles del N£mero de Versi¢n

       LOCAL aP1 := {}                  // Parametros Generales

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
       LOCAL nLicAct := 0                   // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
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
       LOCAL cSerFac := ''                  // Servicio facturado
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL aPosDer := {}                  // Posiciones de derechos de opci¢n
       LOCAL nPosDer := 0                   // Posici¢n del Derecho
       LOCAL lHayFec := .T.                 // .T. Hay Fecha del Sistema
       LOCAL nMesVal := 0                   // Ultimo mes conciliado con la  Contabilidad

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
		     @cPwdSis,@nLicAct,@cAnoHab,@cMesHab,@cPwdHar,@lPiePag,;
		     @cMaeAlu,@cJornad,@nPerHab,@cPwdIns,@cDirEmp,@cCodSui)
	  cError('ERROR No.'+cVerSis)
	  CloseAll()
	  CLEAR
	  QUIT
       ENDIF

*>>>>FIN LECTURA DE LA LICENCIA

*>>>>LECTURAS PARA PRUEBA DE PARAMETROS GENERALES
       CLEAR
       IF nLicAct == 1

	  IF lPregunta('Realizar pruebas parametros generales? Si No')

	     lShared := lPregunta('Sistema en Red? Si No')

*	     lIntUno := lPregunta('Sistema Integrado1? No Si')
*	     lIntDos := lPregunta('Sistema Integrado2? No Si')
*	     lIntTre := lPregunta('Sistema Integrado3? No Si')
*	     lIntCua := lPregunta('Sistema Integrado4? No Si')

	     cNomEmp := SPACE(50)
	     @ 20,01 SAY 'EMPRESA:' GET cNomEmp PICT '@!'
	     READ
	     cNomEmp := ALLTRIM(cNomEmp)
	   *ÀNombre de la Empresa

	     cJornad := 'DNMT'
	     @ 21,01 SAY 'JORNADAS:' GET cJornad PICT '@!'
	     READ
	     cJornad := ALLTRIM(cJornad)
	   *ÀJornadas de Estudio

	     cMaeAlu := 'JARPRIBTO'
	     @ 21,01 SAY 'MAESTROS:' GET cMaeAlu PICT '@!'
	     READ
	     cMaeAlu := ALLTRIM(cMaeAlu)
	   *ÀMaestros habilitados

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
       cNomSis := 'SISTEMA DE CARTERA ACADEMICA'

*       KeySistema(lShared,cNomSis,aKeySis)
      *Control del sistema

       IniSistema(nModCry,lShared)
      *Inicializaci¢n del sistema
*>>>>FIN LICENCIA DE USO A FAVOR

*>>>>DISE¥O PUBLICITARIO
       xClrSys := xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
			     PathSis,FileClr,PathSis,fSimCar)
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
*>>>>FIN LECTURA DEL A¥O DEL USUARIO

*>>>>MAESTROS Y JORNADAS HABILITADAS
*       nLicAct := nDatCar(cCodEmp,nLicAct,cAnoUsr) // Validaci¢n soporte
       IF FILE(cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
	       fCarAno+cAnoUsr+ExtFile)

	  MaeHab(lShared,nModCry,;
		 cAnoUsr+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
		 fCarAno+cAnoUsr+ExtFile,;
		 @cMaeAlu,@cJornad,'ANO->cMaeHabCaA','ANO->cJorHabCaA')

       ENDIF
*>>>>FIN MAESTROS Y JORNADAS HABILITADAS

*>>>>CREACION DEL PATH DEL SISTEMA
       cIniJor := cJornada(16,30,cJornad,@cJorTxt)
      *Lectura de las jornadas de estudio

       cPatSis := cAnoUsr+'.'+cIniJor
       cAnoSis := SUBS(cAnoUsr,3,2)

       cMaeAct := cNivelEst(16,30,cMaeAlu,@cNivTxt)
      *Lectura de los niveles de Estudio
*>>>>FIN CREACION DEL PATH DEL SISTEMA

*>>>>PARAMETROS GENERALES No.1
       aP1 := {}
       AADD(aP1,{'lShared',lShared})
       AADD(aP1,{'nModCry',nModCry})
       AADD(aP1,{'cCodSui',cCodSui})
       AADD(aP1,{'cNomSis',cNomSis})
       AADD(aP1,{'nLicAct',nLicAct})
     *ÀDetalles del Sistema

       AADD(aP1,{'PathW01',cPatSis+'\sitios\facturar'})
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
       AADD(aP1,{'cJorTxt',cJorTxt})
     *ÀDetalles Acad‚micos
*>>>>FIN PARAMETROS GENERALES No.1

*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(aP1,cSavPan,@cModem,@cEmpCob,@cSerFac,@nMesVal)

       cNomSis += ' '+ALLTRIM(cSerFac)
       cNomSis := ALLTRIM(cNomSis)
       nParameSet(aP1,'cNomSis',cNomSis)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA

*>>>>ELIMINACION DE OPCIONES PARA A¥OS ANTERIORES
       IF nMesVal == 12

	  aPosDer := {}
	  AADD(aPosDer,1)  // Solo un recibo
	  AADD(aPosDer,2)  // Todos los Recibos
	  AADD(aPosDer,3)  // Por Adelantado
	  AADD(aPosDer,6)  // Eliminar Recibos
	  AADD(aPosDer,7)  // Eliminar Novedades
	  AADD(aPosDer,8)  // Facturaci¢n
	  AADD(aPosDer,9)  // Facturar Conceptos
	*ÀFacturaci¢n

	  AADD(aPosDer,12)  // Registrar recibos
	*ÀPagos

	  AADD(aPosDer,45)  // Alumnos Becados
	*ÀActualizar

	  FOR i := 1 TO LEN(aPosDer)
	      nPosDer := aPosDer[i]
	      cDerech := STUFF(cDerech,nPosDer,1,'0')
	  ENDFOR
       ENDIF
*>>>>FIN ELIMINACION DE OPCIONES PARA A¥OS ANTERIORES

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := aMenusCart(0,SUBS(cDerech,101,10),@aHelp)
	      aMenu := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenu,i)
		aMenu[i] := SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
**********FIN SELEECION DEL MENU PRINCIPAL

**********CAMBIO DEL A¥O DEL SISTEMA
	    LineaEstado('<F2>CAMBIA A¥O. '+;
			'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)

	    cTitSup := cTipSis+ALLTRIM(cNomUsr)+'.'+cSerFac
	    cTitInf := 'HOY ES: '+cFecha(DATE())+' A¥O: '+;
		       cAnoUsr+' '+cNivTxt+' JORNADA: '+cJorTxt
	  *ÀT¡tulos para el menu

	    nColAno := AT("A¥O: ",cTitInf)+15

	    SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
				     @cPatSis,cNomEmp,cNomSis)})

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
	    SubMenus(aP1,lShared,nModCry,cNomSis,cEmpPal,;
		     cNitEmp,cNomEmp,cNomSec,cCodEmp,nOpcion,;
		     nOpcPal,nFilSup+2,xColSup,cNomUsr,cDerech,;
		     cAnoUsr,nColAno,cPatSis,cSavPan,cMaeAlu,;
		     cMaeAct,cJorTxt,cModem,cEmpCob)
	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       SET COLOR TO
       CLEAR
       QUIT
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/98 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   OCT 15/98 MIE

OBJETIVOS:

2- Retorna los Maestros Habilitados

SINTAXIS:

   CreaDbfBan(PathBan,FileBan,lIntUno,fNtxBan)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cMaeHab(lShared,cAnoUsr,cPatSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL cMaeHab := ''                  // Maestros Habilitados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared) .OR.;
	  CloseDbf('CAA')
	  RETURN cMaeAlu
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE MAESTROS HABILITADOS
       IF ASCAN(DBSTRUCT(),{|aArray|aArray[1] == 'CMAEHABCAA'}) # 0 .AND.;
	  LEN(ALLTRIM(CAA->cMaeHabCaA)) # LEN(cMaeAlu) .AND.;
	  !EMPTY(CAA->cMaeHabCaA)

***********ANALISIS DE MAESTROS HABILITADOS
	     cMaeHab := ''
	     FOR i := 1 TO LEN(cMaeAlu)/3
		 IF SUBS(cMaeAlu,i*3-2,3) $ ALLTRIM(CAA->cMaeHabCaA)
		    cMaeHab += SUBS(cMaeAlu,i*3-2,3)
		 ENDIF
	     ENDFOR
***********FIN ANALISIS DE MAESTROS HABILITADOS

***********MAESTROS HABILITADOS
	     IF !EMPTY(cMaeHab)
		cMaeAlu := cMaeHab
	     ENDIF
***********FIN MAESTROS HABILITADOS

       ENDIF
       CloseDbf('CAA')
       RETURN cMaeAlu
*>>>>FIN VALIDACION DE MAESTROS HABILITADOS

