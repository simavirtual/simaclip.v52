/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR                               MODULO No. 706

**************************************************************************
* TITULO..: MENU DE ACTUALIZAR                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_706(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       AADD(aMenus,"1<CLIENTES>")
       AADD(aMenus,"2<PAGOS   >")

IF 'VIRREY SOLIS' $ cNomEmp
       AADD(aMenus,"3<AJUSTAR >")
ENDIF

       AADD(aAyuda,'Permite Actualizar la Estructura de Clientes.')
       AADD(aAyuda,'Permite Actualizar la Estructura de Pagos.')

IF 'VIRREY SOLIS' $ cNomEmp
       AADD(aAyuda,'Permite realizar ajustes a la Cartera.')
ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-3,nColInf,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1 .OR. nNroOpc == 2

***************ACTUALIZACION DE CLIENTES Y PAGOS
		 ActCliPag(lShared,nModCry,nFilPal,cAnoUsr,cPatSis,cMaeAlu,;
			   nNroOpc)
		 RESTSCREEN(0,0,24,79,cSavPan)
***************FIN ACTUALIZACION DE PAGOS

	  CASE nNroOpc == 3

***************AJUSTES A LA CARTERA
		 Carte_763(aParam1,aParam2,aParam3)
***************FIN AJUSTES A LA CARTERA

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: ACTUALIZA LOS CLIENTES POR NIVELES DE ESTUDIO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 01/2003 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ABR 01/2003 MAR

OBJETIVOS:

1- Permite actualizar los archivos de clientes de todos los maestros
   habilitados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActCliPag(lShared,nModCry,nFilPal,cAnoUsr,cPatSis,cMaeAlu,nNroOpc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       nFilPal                              // Fila Inferior Men£ principal
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaealu                              // Maestros Habilidados
       nNroOpc                              // 1=>Clientes, 2=>Pagos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nOpcion := 0                   // Opcion de Seleccion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       nOpcion := nLeeOpcion('ACTUALIZAR: 1<SOLO EL A¥O:'+cAnoUsr+' '+;
			     '2<TODOS LOS A¥OS> 3<ABANDONAR>?',3,'0')

       IF nOpcion == 3
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF

       IF !lPregunta('REALIZO COPIA DE SEGURIDAD? No Si')
	  cError('DEBE SACAR COPIA DE TODOS LOS A¥OS A ACTUALIZAR')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTUALIZACION DE LA ESTRUCTURAS DE CLIENTES Y PAGOS
       IF 'JAR' $ cMaeAlu
	   CliPagJor(lShared,nModCry,nFilPal,cAnoUsr,;
		     cPatSis,'JAR',nOpcion,nNroOpc)
       ENDIF

       IF 'PRI' $ cMaeAlu
	  CliPagJor(lShared,nModCry,nFilPal,cAnoUsr,;
		    cPatSis,'PRI',nOpcion,nNroOpc)
       ENDIF

       IF 'BTO' $ cMaeAlu
	  CliPagJor(lShared,nModCry,nFilPal,cAnoUsr,;
		    cPatSis,'BTO',nOpcion,nNroOpc)
       ENDIF
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURAS DE CLIENTES Y PAGOS

/*************************************************************************
* TITULO..: ACTUALIZA LOS CLIENTES POR JORNADA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 01/2003 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   ABR 01/2003 MAR

OBJETIVOS:

1- Permite actualizar los archivos de clientes de la maestro actual.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CliPagJor(lShared,nModCry,nFilPal,cAnoUsr,;
		   cPatSis,cMaeAct,nOpcion,nNroOpc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       nFilPal                              // Fila Inferior Men£ principal
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Activo
       nOpcion                              // 1=>A¤o Actual 2=>All a¤os
       nNroOpc                              // 1=>Clientes, 2=>Pagos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL       i := 0                   // Contador
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nNroPos := 0                   // N£mero de Posici¢n
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nAnoIni := 0                   // A¤o Inicial
       LOCAL nAnoFin := 0                   // A¤o Final
       LOCAL cMsgAct := ''                  // Mensaje de Error
       LOCAL cGruFin := ''                  // C¢digo del grupo final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+FSimCar,'CAR',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO GRUPOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(CAR->nAnoIniCar)
	    cError('NO SE HA ESPECIFICADO EL A¥O INICIAL DE LA CARTERA')

       CASE EMPTY(CAR->nAnoFinCar)
	    cError('NO SE HA ESPECIFICADO EL A¥O FIN DE LA CARTERA')

       CASE CAR->nAnoIniCar > CAR->nAnoFinCar
	    cError('EL A¥O INICIAL NO PUEDE SER MAYOR AL A¥O FINAL')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CALCULO DE LA POSICION DEL A¥O
       nNroPos := AT(cAnoUsr,cPatSis)
       IF nNroPos == 0
	  cError('EL A¥O '+cAnoUsr+' '+;
		 'NO SE ENCUENTRAN DENTRO DEL PATH DEL SISTEMA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CALCULO DE LA POSICION DEL A¥O

*>>>>ANALISIS DE DECISION
       DO CASE
       CASE nOpcion == 1
	    nAnoIni := VAL(cAnoUsr)
	    nAnoFin := VAL(cAnoUsr)

       CASE nOpcion == 2
	    nAnoIni := CAR->nAnoIniCar
	    nAnoFin := CAR->nAnoFinCar

       OTHERWISE
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDCASE
*>>>>FIN ANALISIS DE DECISION

*>>>>RECORRIDO POR A¥OS
       PathAct := cPathAct()
       FOR i := nAnoIni TO nAnoFin

***********CALCULO DEL A¥O DEL USUARIO
	     cAnoUsr := STR(i,4)
	     lCorrecion(@cAnoUsr,.T.)
	     cPatSis := STUFF(cPatSis,nNroPos,4,cAnoUsr)
	     cAnoSis := SUBS(cAnoUsr,3,2)
***********FIN CALCULO DEL A¥O DEL USUARIO

***********VALIDACION DEL DIRECTIOR DEL SISTEMA
	     IF DIRCHANGE (cPatSis) # 0
		cError('NO EXISTE INFORMACION DEL A¥O '+cAnoUsr)
		LOOP
	     ENDIF
	     DIRCHANGE(PathAct)
***********FIN VALIDACION DEL DIRECTIOR DEL SISTEMA

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+'GRU'+;
			 cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry)

		cError('ABRIENDO EL ARCHIVO GRUPOS')
		CloseDbf('GRU')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('GRU')
		LOOP
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR GRUPOS
	     nNroFil := nMarco(nFilPal,'ACTUALIZANDO '+;
			       IF(nNroOpc==1,'CLIENTES','PAGOS')+' '+;
			       'A¥O: '+cAnoUsr+' '+;
			       'GRUPO: '+GRU->cCodigoGru)
	     SELECT GRU
	     GRU->(DBGOBOTTOM())
	     cGruFin := GRU->cCodigoGru

	     GRU->(DBGOTOP())
	     DO WHILE .NOT. GRU->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin,'')
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*---------------ACTUALIZACION DE LA ESTRUCTURA
		  cMsgAct := ''
		  DO CASE
		  CASE nNroOpc == 1
		       nActStrCli(lShared,nModCry,;
				  cPatSis+'\CLIENTES',;
				  'Cl'+GRU->cCodigoGru+cAnoSis+ExtFile,;
				  @cMsgAct)

		  CASE nNroOpc == 2
		       nActStrPag(lShared,nModCry,;
				  cPatSis+'\PAGOS',;
				  'Pa'+GRU->cCodigoGru+cAnoSis+ExtFile,;
				  @cMsgAct)
		  ENDCASE
*---------------FIN ACTUALIZACION DE LA ESTRUCTURA

*---------------VISUALIZACION DEL REGISTRO
		  @ nNroFil,01 SAY 'GRUPO: '+GRU->cCodigoGru+' '+cMsgAct

		  nNroFil++
		  IF nNroFil == 21
*		     cPausa()
		     nNroFil := nMarco(nFilPal,'ACTUALIZANDO '+;
				       IF(nNroOpc==1,'CLIENTES','PAGOS')+' '+;
				       'A¥O: '+cAnoUsr+' '+;
				       'GRUPO: '+GRU->cCodigoGru)
		  ENDIF
*---------------FIN VISUALIZACION DEL REGISTRO

		GRU->(DBSKIP())

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
       CloseAll(aUseDbf)
*       cPausa()
       RETURN NIL
*>>>>FIN RECORRIDO POR A¥OS

/*************************************************************************
* TITULO..: AJUSTES A LA CARTERA.                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2010 LUN A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   MAR 01/2010 LUN

OBJETIVOS:

1- Permite hacer ajustes de la Cartera para casos muy espec¡ficos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_763(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nMesIniTpa := 2                // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')

	    CASE PAG->(RECCOUNT()) == 0
		 cError('NO EXISTEN PAGOS GRABADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********RECORRIDO POR PAGOS
	    SELECT PAG
	    PAG->(DBGOTOP())
	    DO WHILE .NOT. PAG->(EOF())

/*
*==============ANALISIS DE DECISION
		 IF PAG->nMesIniPag > 3 .AND.;
		    PAG->nMesIniPag # 3
		    PAG->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS DE DECISION
*/

*==============LINEA DE ESTADO
		 LineaEstado('MES: '+cMes(PAG->nMesIniPag)+'º'+;
			     'GRUPO: '+GRU->cCodigoGru+'º'+;
			     'No : '+STR(PAG->(RECNO()),2)+'/'+;
				     STR(PAG->(RECCOUNT()),2),cNomSis)
*==============FIN LINEA DE ESTADO

*==============AJUSTE EN PAGOS
		 IF PAG->(lRegLock(lShared,.F.))

		    REPL PAG->nIntMorPag WITH 0
		    REPL PAG->nIntDeuPag WITH 2.0

		    REPL PAG->nVlrMorPag WITH 0
		    REPL PAG->nVlrDeuPag WITH 0

		    PAG->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO')
		 ENDIF
		 IF lShared
		    PAG->(DBUNLOCK())
		 ENDIF
*==============AJUSTE EN PAGOS

	       PAG->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR PAGOS

	  GRU->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>RECORRIDO POR GRUPOS