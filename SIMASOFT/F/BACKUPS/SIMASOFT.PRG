/*                      SIMASOFT - SISTEMA ADMINISTRADOR
			    PROGRAMA PRINCIPAL

**************************************************************************
* TITULO..: SIMASOFT - SISTEMA ADMINISTRADOR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 10:45 AM   SEP 04/2002 MIE

OBJETIVOS:

1- Visualiza todos los men£s de la aplicacion

2- Ejecuta cada una de las funciones de la aplicaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\INS-SOFT.PRG"       // Detalles de Instalaci¢n
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema
       #INCLUDE "CAMPOS\VER-SOFT.PRG"       // Detalles del N£mero de Versi¢n

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cTipSis := ''                  // Tipo de Sistema

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cDerech := ''                  // Derechos del usuario
       LOCAL lHayFec := .T.                 // .T. Hay Fecha del Sistema

       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL nColAno := NIL                 // Columna del A¤o

       LOCAL cPatSis := ''                  // Path del sistema


       LOCAL       i := 0                   // Contador
       LOCAL nOpcion := 1                   // Opci¢n del SubMen£
       LOCAL nOpcPal := 0                   // Opci¢n principal
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL cTitSup := ''                  // T¡tulo Superior para el men£
       LOCAL cTitInf := ''                  // T¡tulo Inferior para el men£
       LOCAL nFilSup := 0                   // Fila Superior del men£
       LOCAL xColSup := NIL                 // Columna(s) para el men£

       LOCAL GetList := {}                  // Variable para el sistema
       MEMVA xClrSys			    // Color del Sistema
       CloseAll()                           // Cierre de las Bases de Datos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL SISTEMA
       CLEAR
       xClrSys := ''

       cNomSis := 'SIMASOFT. SISTEMA ADMINISTRADOR'
       cTipSis := cVerSis+;
		  IF(lShared,' RED V'+NNETVER()+;
			     ' MULTI-',' MONO-')+'USUARIO: '
     *ÀVersi¢n del Sistema

       IniSistema(nModCry,lShared)
      *Inicializaci¢n del sistema
*>>>>FIN NOMBRE DEL SISTEMA

*>>>>DISE¥O PUBLICITARIO
       xClrSys := ''
       xClrSys := xLeeClrSys(lShared,nModCry,cNomSis,cNomEmp,;
			     PathSis,FileClr,PathSis,fSimSof)
       LogoSys(cNomSis,cNomEmp)
*>>>>FIN DISE¥O PUBLICITARIO

*>>>>LECTURA DEL USUARIO
       cSavPan := SAVESCREEN(0,0,24,79)
       cDerech := cUsuario(lShared,PathSis,FileAaa,@cNomUsr,cPasSis,lHayFec)
       IF cDerech == NIL .OR. !('1' $ SUBS(cDerech,1,100))
	  CloseAll()
	  QUIT
       ENDIF
*      cDerech := REPL('1',111)
*>>>>FIN LECTURA DEL USUARIO

*>>>>LECTURA DEL A¥O DEL USUARIO
       cAnoUsr := STR(YEAR(DATE()),4)
       @14,34 SAY "A¥O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
*>>>>FIN LECTURA DEL A¥O DEL USUARIO

*>>>>CREACION DEL PATH DEL SISTEMA
       cPatSis := cAnoUsr
       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN CREACION DEL PATH DEL SISTEMA

*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(lShared,nModCry,cAnoUsr,cPatSis,cSavPan)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := aMenuSoft(0,SUBS(cDerech,101,10),@aHelp)
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
	    cTitInf := 'A¥O: '+cAnoUsr
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
			     cTitSup,cTitInf,nOpcion)

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
	    MenusSoft(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,nOpcion,nOpcPal,nFilSup+2,xColSup,;
		      cNomUsr,cDerech,cAnoUsr,nColAno,cPatSis,;
		      cSavPan)

	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       CLEAR
       QUIT
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA