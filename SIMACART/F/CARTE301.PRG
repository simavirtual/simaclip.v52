/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : CONSULTAS
SUBMODULO...: SITUACION CLIENTE   MODULO No. 301

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE301.PRG                                    *
* TITULO DEL PROGRAMA..: MENU DE SITUACION DEL CLIENTE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 10/95 VIE A
       Bucaramanga, Colombia        INICIO: 08:00 PM   MAR 10/95 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ de los niveles para la consulta de la situaci¢n
   de los clientes.

2- Ejecuta las diferentes funciones de consulta


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_301(aParam1,aParam2,aParam3,;
		   lModReg)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lModReg                              // .T. Modificar Registros */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,;
		  @PathUno,@PathDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			fSimaCo,'SCO',NIL,lShared,0})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CMT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN DE AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO '+cIntUno)
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

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
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
		   {{"GRUPO ANTERIOR","cGruAntGru"},{NIL}},;
		   {{"MES PARA EL;ULTIMO RECIBO","nUltRecEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','nUltRecEst'},{'PICTURE','99'}}},;
		   {{"NOMBRE PARA;EL RECIBO","nNomFacEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','nNomFacEst'},{'PICTURE','9'}}},;
		   {{"CLASIFICACION;DEL ESTUDIANTE","nMorosoEst"},{NIL}},;
		   {{"CONCEPTOS","cConcepEst"},{NIL}},;
		   {{"RUTAS","cCodigoRut"},{NIL}},;
		   {{"PAZ Y SALVO","cPazSdoEst"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','cPazSdoEst'},{'PICTURE','@!'}}},;
		   {{"ESTRATO","nEstratEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','nEstratEst'},{'PICTURE','99'}}},;
		   {{"TOTAL FACTURADO","nTotFacEst"},{NIL}},;
		   {{"TOTAL PAGADO","nTotPagEst"},{NIL}},;
		   {{"FECHA MATRICULA","dFecMatEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','dFecMatEst'},{'PICTURE','@D!'}}},;
		   {{"HORA","cHorMatEst"},;
		    {{'MODI',.T.},{'ALIAS',cMaeAct},;
		     {'FIELD','cHorMatEst'},{'PICTURE','@X!'}}},;
		   {{"OBS RETIRO","cObsRetEst"},{NIL}},;
		   {{"CONTRATANTE No. 1","cNitCo1Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo1Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 1","lNoRCo1Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo1Est'},{'PICTURE','@!'}}},;
		   {{"CONTRATANTE No. 2","cNitCo2Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo2Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 2","lNoRCo2Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo2Est'},{'PICTURE','@!'}}},;
		   {{"CONTRATANTE No. 3","cNitCo3Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo3Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 3","lNoRCo3Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo3Est'},{'PICTURE','@!'}}},;
		   {{"CONTRATANTE No. 4","cNitCo4Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','cNitCo4Est'},{'PICTURE','@9'}}},;
		   {{"NO REPORTAR No. 4","lNoRCo4Est"},;
		    {{'MODI',.F.},{'ALIAS',cMaeAct},;
		     {'FIELD','lNoRCo4Est'},{'PICTURE','@!'}}},;
		   {{"No;LISTA","nNroLisEst"},{NIL}}}
     *ÀDefinici¢n de Campos

       cTitInf := '<F2>Personal <F3>Pagos <F4>Descuentos '+;
		  '<F5>Buscar <F6>Recibos <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINCION DEL BROWSE

*>>>>BROWSE DE CLIENTES
       lModReg := IF(lModReg==NIL,.F.,lModReg)
       SELECT &cMaeAct

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cMaeAct,cNomEmp,cNomSis)})

       SETKEY(K_F3,{||EstadoCta(lShared,nModCry,cNomSis,cNomEmp,;
				cNomUsr,cAnoUsr,cPatSis,cJorTxt,;
				nFilPal,1,cMaeAct,,lModReg)})

       SETKEY(K_F4,{||RelDesEst(lShared,nModCry,cNomSis,cNomEmp,;
				nFilPal,1,cMaeAct,cPatSis,lModReg)})

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cMaeAct,;
				SUBS(cAnoUsr,3,2),cIntUno)})

       SETKEY(K_F6,{||RelRecibo(lShared,nModCry,cNomUsr,cAnoUsr,;
				PathUno,nFilPal,1,cMaeAct)})

       SETKEY(K_F7,{||SaldosCli(lShared,nModCry,nFilPal,1,;
				cMaeAct,cPatSis,cAnoSis)})

       DO CASE
       CASE cMaeAct == 'JAR'
	    JAR->(CtrlBrw(lSiRed,oBrowse))

       CASE cMaeAct == 'PRI'
	    PRI->(CtrlBrw(lSiRed,oBrowse))

       CASE cMaeAct == 'BTO'
	    BTO->(CtrlBrw(lSiRed,oBrowse))

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
* TITULO DE LA FUNCION..: SALDOS ACTUALES DEL CLIENTE                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/95 MAR A
       Colombia,Bucaramanga         INICIO: 11:00 AM   MAR 14/95 MAR

OBJETIVOS:

1)- Debe estar en uso el maestro de alumnos habilitado

2)- Debe estar en uso el archivo el archivo de clientes

3)- Visualiza los Saldos Actuales del Cliente

4)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SaldosCli(lShared,nModCry,nFilInf,nColInf,;
		   cNalias,cPatSis,cAnoSis,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cNalias                              // Alias del Maestro
       cPatSis                              // Path del sistema
       cAnoSis                              // A¤o del sistema
       cTitulo                              // T¡tulo de la Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cCodigo := ''                  // Codigo del cliente
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PREPARACION DE LAS VARIABLES DE ARCHIVO
       FileCli := cPatSis+'\CLIENTES\CL'+;
		  &cNalias->cCodigoGru+cAnoSis+ExtFile

       FilePag := cPatSis+'\PAGOS\PA'+;
		  &cNalias->cCodigoGru+cAnoSis+ExtFile
*>>>>FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	  cError('POSIBLEMENTE NO ESTAN CREADOS LOS CLIENTES',;
		 'ERROR. ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)
	  SELECT &cNalias
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DEL CLIENTE
       IF !lLocCodigo('cCodigoEst','CLI',&cNalias->cCodigoEst)
	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)
	  SELECT &cNalias
	  cError('NO EXISTE EL ESTUDIATE EN EL GRUPO DE CLIENTES')
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL CLIENTE

*>>>>CONSULTA DE LOS SALDOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cTitulo := IF(cTitulo == NIL,'SALDOS DEL ESTUDIANTE',cTitulo)
       nNroFil := nMarco(nFilInf+1,cTitulo,22,'°')
       nNroCol := nColInf

       nNroFil += 1
       @nNroFil++,nNroCol+00 SAY 'SALDOS teniendo en cuenta TODAS '+;
				 'LAS NOVEDADES:'
       @nNroFil++,nNroCol+00 SAY '(BECAS,DESCUENTOS,RECARGOS,ABONOS,ETC):'

       @++nNroFil,nNroCol+00 SAY 'SALDO ACTUAL: '+STR(CLI->nSdoActCli+;
						      CLI->nSdoMorCli,10,2)
       @nNroFil,nNroCol+26 SAY 'DEUDA: '+STR(CLI->nSdoActCli,10,2)
       @nNroFil,nNroCol+45 SAY 'MORA: ' +STR(CLI->nSdoMorCli,10,2)

       nNroFil += 4
       @nNroFil++,nNroCol+00 SAY 'SALDOS sin tener en cuenta TODAS '+;
				 'LAS NOVEDADES:'
       @nNroFil++,nNroCol+00 SAY '(BECAS,DESCUENTOS,RECARGOS,ABONOS,ETC):'

       @++nNroFil,nNroCol+00 SAY 'SALDO ACTUAL: '+STR(CLI->nSdAbonCli+;
						      CLI->nMoAbonCli,10,2)
       @nNroFil,nNroCol+26 SAY 'DEUDA: '+STR(CLI->nSdAbonCli,10,2)
       @nNroFil,nNroCol+45 SAY 'MORA: ' +STR(CLI->nMoAbonCli,10,2)

       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       SELECT &cNalias
       RETURN NIL
*>>>>FIN CONSULTA DE LOS SALDOS

