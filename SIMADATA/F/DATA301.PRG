/* SIMA - CENTRAL DE RIESGOS

MODULO      : CONSULTAS
SUBMODULO...: SITUACION CLIENTE

**************************************************************************
* TITULO..: SITUACION DEL CLIENTE                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 04/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   AGO 04/2004 MIE

OBJETIVOS:

1- Permite crear el archivo para realizar el reporte mensual a DataCredito

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL PathTre := ''                  // Path de integraci¢n Tres
       LOCAL PathCua := ''                  // Path de integraci¢n Cuatro

       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

/*
*>>>>LECTURA DEL VALOR
       dFecPrn := 0

       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilInf+1,nColInf SAY 'VALOR CHEQUE:' GET dFecPrn PICT '9999999.99'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecPrn)
	  RETURN NIL
       ENDIF
       cError(UPPER(Letras(dFecPrn,'M'))+'PESOS MCTE.')
       RETURN NIL
*>>>>FIN LECTURA DEL VALOR
*/

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+PathSis+'\'+;
			 FSimCar,'SCA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathTre+'\'+cPatSis+'\'+;
			 FileCnt+ExtFile,'CNT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN DE AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO '+PathUno+'\'+cPatSis)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SELECT &cMaeAct
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ALUMNOS GRABADOS')

       CASE PER->(RECCOUNT()) == 0
	    cError('NO EXISTEN PERSONAS GRABADAS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE SIMACART')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMACART')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SDA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DEFINCION DEL BROWSE
       SELECT &cMaeAct
       cTitSup := '<< CONSULTA DE ESTUDIANTE DE '+cMaeAct+;
		  ' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
      *ÀT¡tulo Superior del Browse

       aCampos := {{{"CODIGO","cCodigoEst"},{NIL}},;
		   {{"GRUPO","cCodigoGru"},{NIL}},;
		   {{"APELLIDOS;DEL ESTUDIANTE","cApelliEst"},{NIL}},;
		   {{"NOMBRES;DEL ESTUDIANTE","cNombreEst"},{NIL}},;
		   {{"FECHA MATRICULA","dFecMatEst"},{NIL}},;
		   {{"HORA","cHorMatEst"},{NIL}},;
		   {{"RETIRADO","lRetiroEst"},{NIL}},;
		   {{"FECHA","dFecRetEst"},{NIL}},;
		   {{"MES PARA EL;ULTIMO RECIBO","nUltRecEst"},{NIL}},;
		   {{"NOMBRE PARA;EL RECIBO","nNomFacEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','nNomFacEst'},{'PICTURE','9'}}},;
		   {{"CLASIFICACION;DEL ESTUDIANTE","nMorosoEst"},{NIL}},;
		   {{"CONCEPTOS","cConcepEst"},{NIL}},;
		   {{"RUTAS","cCodigoRut"},{NIL}},;
		   {{"PAZ Y SALVO","cPazSdoEst"},{NIL}},;
		   {{"ACUDIENTE C.C. No.","cAcuNitEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cAcuNitEst'},{'PICTURE','@9'}}},;
		   {{"APELLIDOS PADRE","cApePadEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cApePadEst'},{'PICTURE','@!X'}}},;
		   {{"NOMBRES PADRE","cNomPadEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNomPadEst'},{'PICTURE','@!X'}}},;
		   {{"PADRE C.C. No.","cPadNitEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cPadNitEst'},{'PICTURE','@9'}}},;
		   {{"APELLIDOS MADRE","cApeMadEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cApeMadEst'},{'PICTURE','@!X'}}},;
		   {{"NOMBRES MADRE","cNomMadEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNomMadEst'},{'PICTURE','@!X'}}},;
		   {{"MADRE C.C. No.","cMadNitEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cMadNitEst'},{'PICTURE','@9'}}},;
		   {{"CONTRATANTE No. 1","cNitCo1Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo1Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 1","lNoRCo1Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo1Est'},{'PICTURE','@!'}}},;
		   {{"CONTRATANTE No. 2","cNitCo2Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo2Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 2","lNoRCo2Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo2Est'},{'PICTURE','@!'}}},;
		   {{"CONTRATANTE No. 3","cNitCo3Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo3Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 3","lNoRCo3Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo3Est'},{'PICTURE','@!'}}},;
		   {{"CONTRATANTE No. 4","cNitCo4Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo4Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 4","lNoRCo4Est"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo4Est'},{'PICTURE','@!'}}},;
		   {{"No;LISTA","nNroLisEst"},{NIL}}}
     *ÀDefinici¢n de Campos


       cTitInf := '<F2>Personal <F3>Pagos <F4>Descuentos '+;
		  '<F5>Buscar <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINCION DEL BROWSE

*>>>>BROWSE DE CLIENTES
       SELECT &cMaeAct

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cMaeAct,cNomEmp,cNomSis)})

       SETKEY(K_F3,{||EstadoCta(lShared,nModCry,cNomSis,cNomEmp,;
				cNomUsr,cAnoUsr,PathDos+'\'+cPatSis,;
				cJorTxt,nFilPal,1,cMaeAct)})

       SETKEY(K_F4,{||RelDesEst(lShared,nModCry,cNomSis,cNomEmp,;
				nFilPal,1,cMaeAct,PathDos+'\'+cPatSis)})

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cMaeAct,;
				SUBS(cAnoUsr,3,2),PathUno+'\'+cPatSis)})

/*
       SETKEY(K_F9,{||MenuOtr301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				 cJorTxt,oBrowse)})
*/

       DO CASE
       CASE cMaeAct == 'JAR'
	    JAR->(CtrlBrw(lShared,oBrowse))

       CASE cMaeAct == 'PRI'
	    PRI->(CtrlBrw(lShared,oBrowse))

       CASE cMaeAct == 'BTO'
	    BTO->(CtrlBrw(lShared,oBrowse))

       ENDCASE
       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F6,NIL)
       SETKEY(K_F7,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DE CLIENTES

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtr301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<ACTUALIZACION DE CONTRATANTES>')

       AADD(aAyuda,'Permite Actualizar los Contratantes')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1

	    Otr301011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,oBrowse)
	   *Creaci¢n de Registros


       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: CREACION DEL REGISTRO A REPORTAR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 22/2004 ABR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 22/2004 ABR

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Otr301011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL aDatCnt := {}                  // Datos del Contratante
       LOCAL nNroReg := 0                   // N£mero de Registros
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR ESTUDIANTES
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(03,'CONTRATANTES')
       SELECT &cMaeAct
       DBGOTOP()
       DO WHILE .NOT. EOF()

**********IMPRESION DE LA LINEA DE ESTADO
	    nNroReg++
	    LineaEstado('ºNo. '+STR(nNroReg,4)+'/'+;
				STR(RECCOUNT(),4),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DE LOS CONTRATANTES
	    aDatCnt := {}
	    aDatCnt := aLocAllCnt(cMaeAct)
	    IF LEN(aDatCnt) == 0
	       cError(&cMaeAct->cCodigoEst+;
		     ': NO TIENE CONTRATANTES GRABADOS')
	    ENDIF
**********FIN VALIDACION DE LOS CONTRATANTES

**********VISUALIZACION DE CONTROL
	    nNroFil++

	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,30)

	    @ nNroFil,01 SAY &cMaeAct->cCodigoEst+' '+;
			     &cMaeAct->cCodigoGru+' '+;
			     ALLTRIM(&cMaeAct->cNitCo1Est)+' '+;
			     ALLTRIM(&cMaeAct->cNitCo2Est)+' '+;
			     ALLTRIM(&cMaeAct->cNitCo3Est)+' '+;
			     ALLTRIM(&cMaeAct->cNitCo4Est)+':'+;
			     cLocateCnt(cMaeAct,'C1DOC',aDatCnt)+' '+;
			     cLocateCnt(cMaeAct,'C2DOC',aDatCnt)+' '+;
			     cLocateCnt(cMaeAct,'C3DOC',aDatCnt)+' '+;
			     cLocateCnt(cMaeAct,'C4DOC',aDatCnt)


	    IF nNroFil == 21
	       nNroFil := nMarco(03,'CONTRATANTES')
	    ENDIF
**********FIN VISUALIZACION DE CONTROL

**********ACTUALIZACION DE LOS CONTRATANTES
	  SELECT &cMaeAct
	  IF lRegLock(lShared,.F.)

	     REPL &cMaeAct->cNitCo1Est WITH ''
	     REPL &cMaeAct->cTipCo1Est WITH ''
	     REPL &cMaeAct->cNitCo2Est WITH ''
	     REPL &cMaeAct->cTipCo2Est WITH ''
	     REPL &cMaeAct->cNitCo3Est WITH ''
	     REPL &cMaeAct->cTipCo3Est WITH ''
	     REPL &cMaeAct->cNitCo4Est WITH ''
	     REPL &cMaeAct->cTipCo4Est WITH ''
	   *ÀDatos de los Contrantes 1,2,3,4

	     REPL &cMaeAct->cNitCo1Est WITH cLocateCnt(cMaeAct,'C1DOC',aDatCnt)
	     REPL &cMaeAct->cTipCo1Est WITH cLocateCnt(cMaeAct,'C1TIP',aDatCnt)
	     REPL &cMaeAct->cNitCo2Est WITH cLocateCnt(cMaeAct,'C2DOC',aDatCnt)
	     REPL &cMaeAct->cTipCo2Est WITH cLocateCnt(cMaeAct,'C2TIP',aDatCnt)
	     REPL &cMaeAct->cNitCo3Est WITH cLocateCnt(cMaeAct,'C3DOC',aDatCnt)
	     REPL &cMaeAct->cTipCo3Est WITH cLocateCnt(cMaeAct,'C3TIP',aDatCnt)
	     REPL &cMaeAct->cNitCo4Est WITH cLocateCnt(cMaeAct,'C4DOC',aDatCnt)
	     REPL &cMaeAct->cTipCo4Est WITH cLocateCnt(cMaeAct,'C4TIP',aDatCnt)
	   *ÀDatos de los Contrantes 1,2,3,4

	     DBCOMMIT()
	     IF lShared
		DBUNLOCK()
	     ENDIF

	  ELSE
	     cError('NO SE GRABA EL REGISTRO')
	  ENDIF
**********FIN ACTUALIZACION DE LOS CONTRATANTES

	  SELECT &cMaeAct
	  DBSKIP()

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO POR ESTUDIANTES
