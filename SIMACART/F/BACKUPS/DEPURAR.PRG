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
	SET CENTURY     ON                   // OFF = 99 ON = 9999
*       BLICPUREL(50)

       xClrSys := ''
       IF !lLicencia(PathSis+'\'+FileDat,;
		     @cEmpPal,@cNitEmp,@cNomEmp,@cCodEmp,@cPaises,@cNomDpt,;
		     @cNomMun,@cNomSec,@lShared,@nModCry,@nSysOpe,@cDerSys,;
		     @cPwdSis,@nPrueba,@cAnoHab,@cMesHab,@cPwdHar,@lPiePag,;
		     @cMaeAlu,@cJornad,@nPerHab,@cPwdIns)
	  cError('ERROR(L) INTERNO DEL SISTEMA')
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

*>>>>CREACION DEL PATH DEL SISTEMA
       cIniJor := cJornada(16,30,cJornad,@cJorTxt)
      *Lectura de las jornadas de estudio

       cPatSis := cAnoUsr+'.'+cIniJor
       cAnoSis := SUBS(cAnoUsr,3,2)

       cMaeAct := cNivelEst(16,30,cMaeAlu,@cNivTxt)
      *Lectura de los niveles de Estudio
*>>>>FIN CREACION DEL PATH DEL SISTEMA

/*
*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,cNomUsr,cAnoUsr,cPatSis,;
		  lIntUno,lIntDos,lIntTre,lIntCua,cSavPan,;
		  cMaeAlu,cMaeAct,cIniJor,@cModem,@cEmpCob)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA
*/

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
	    Depura(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,cCodEmp,nOpcion,nOpcPal,;
		   nFilSup+2,xColSup,cNomUsr,cDerech,cAnoUsr,;
		   nColAno,cPatSis,lIntUno,lIntDos,lIntTre,;
		   lIntCua,cSavPan,cMaeAlu,cMaeAct,cJorTxt,;
		   cModem,cEmpCob)
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

/*************************************************************************
* TITULO DE LA FUNCION......: EJECUCION MENUS PRIMER NIVEL               *
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

FUNCTION Depura(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		 cNomSec,cCodCol,nOpcion,nOpcPal,nFilPal,aColSup,;
		 cNomUsr,cDerech,cAnoUsr,nColAno,cPatSis,lIntUno,;
		 lIntDos,lIntTre,lIntCua,cSavPan,cMaeAlu,cMaeAct,;
		 cJorTxt,cModem,cEmpCob)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa Principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodCol                              // C¢digo del Colegio
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
       cNomUsr                              // Nombre del Usuario
       cDerech                              // Derechos en el sistema
       cAnoUsr				    // A¤o del Sistema
       nColAno                              // Columna A¤o del sistema
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cModem                               // Banco para la Gerencia Electronica
       cEmpCob                              // Empresa de Cobro de la Cartera */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

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

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo

       MEMVA xClrSys			    // Color del Sistema

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aArchvo := {}
       AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FileFam,NIL,'FAM'})
       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
*>>>>FIN AREAS DE TRABAJO

/*

		      Carte_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Impresi¢n recibos por grupos

		      Carte_203(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
				cModem)

		      Carte_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta situaci¢n del cliente

	       MantenExt(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	     *Mantenimiento del Extracto

		      Carte_102(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Impresi¢n recibos por grupos

     Carte_193(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
	       cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
	       cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,;
	       cMaeAct,cJorTxt)

	       Carte_251(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 cNomSec,cCodCol,nFilInf,nColInf,nFilPal,cNomUsr,;
			 cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			 cMaeAlu,cMaeAct,cJorTxt)
	      *Facturaci¢n del Mes.

	       Carte_411(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	      *Relaci¢n de morosos


	     Carte_151(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		       cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		       lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	    *Aplicaci¢n del Abono por Intereses por mora

*>>>>MANTENIMIENTO DEL ARCHIVO
       lModReg := .T.
       lDelReg := .F.
       lInsReg := .T.
       lHaySql := .F.

       MantenFam(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
		 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
		 aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
		 lModReg,lDelReg,lInsReg,lHaySql,;
		 nFilInf,nColInf,cPatSis,cMaeAlu,;
		 cJorTxt,PathUno)
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

		      Carte_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta situaci¢n del cliente

		      MantenMor(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
				cEmpCob,.T.)
		     *Morosos a la Fecha

	       Carte_411(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	      *Relaci¢n de morosos


		      Carte_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Consulta situaci¢n del cliente

	       Carte_253(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	      *Pagos del Mes.


	       MantenDes(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	      *Descuentos Individuales

		      Carte_408(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
				nFilPal,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
				lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
				cJorTxt)
		     *Relaci¢n detallada por Estudiantes






*==============AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{cPatSis+'\'+FileCoE,NIL,'COE'})
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{cPatSis+'\'+FileCon,NIL,'CON'})

		 IF 'JAR' $ cMaeAlu
		    cNalias := 'JAR'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF

		 IF 'PRI' $ cMaeAlu
		    cNalias := 'PRI'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF

		 IF 'BTO' $ cMaeAlu
		    cNalias := 'BTO'
		    AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  FileAlu+cNalias+cAnoSis+ExtFile,;
				  PathUno+'\'+cPatSis+'\'+cNalias+'\'+;
				  fNtxAlu+cNalias+cAnoSis+cExtNtx,;
				  cNalias})
		 ENDIF
*==============FIN AREAS DE TRABAJO

*==============MANTENIMIENTO DEL ARCHIVO
		 lModReg := .T.
		 lDelReg := .T.
		 lInsReg := .T.
		 lHaySql := .F.

		 MantenCoE(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
			   cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
			   aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
			   lModReg,lDelReg,lInsReg,lHaySql,cMaeAlu)
*==============FIN MANTENIMIENTO DEL ARCHIVO


*>>>>PRUEBA DE LA OPCION


	       Carte_109(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
			 nFilPal,cNomUsr,cAnoUsr,cPatSis,lIntUno,;
			 lIntDos,lIntTre,lIntCua,cMaeAlu,cMaeAct,;
			 cJorTxt)
	      *Facturar Conceptos


		     Carte_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			       cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			       lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		    *Impresi¢n recibos por alumno


		      Carte_102(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Impresi¢n recibos por grupos


	     Carte_151(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		       cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		       cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		       lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	    *Aplicaci¢n del Abono por Intereses por mora

		      Carte_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
		     *Cancelaci¢n de recibos

*/

	       Carte_255(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
			 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)
	      *Control total de Estudiantes


       RESTSCREEN(0,0,24,79,cSavPan)
       CloseAll()
       RETURN NIL
*>>>>FIN PRUEBA DE LA OPCION
