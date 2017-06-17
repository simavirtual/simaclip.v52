/*            BIBLIOTECAS DE FUNCIONES PARA EL MANEJO DE ERRORES

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/96 MIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   MAY 15/96 MIE

REQUERIMIENTOS

- Compilar: clipper funcions /w/m

OBJETIVOS

- Son independientes de cualquier programa

FUNCIONES

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES GENERALES
       #INCLUDE "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/96 MIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   MAY 15/96 MIE

OBJETIVOS:

1)- Crea la estructura del archivo de errores del sistema

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaErrSys(lShared,nModCry,PathErr,fErrSys,fNtxErr,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathErr				    // Path del Archivo
       fErrSys				    // Nombre del Archivo
       fNtxErr				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aErrSys := {{"cCodigoEst","Character",06,0},; // C¢digo del Estudiante
			 {"cObsUnoErr","Character",60,0},; // Observaci¢n No. 1
			 {"cObsDosErr","Character",60,0},; // Observaci¢n No. 2
			 {"cObsTreErr","Character",60,0},; // Observaci¢n No. 3
			 {"cNomUsrErr","Character",10,0},; // Nombre del Usuario
			 {"cFecUsrErr","Character",08,0},; // Fecha del Usuario
			 {"cHorUsrErr","Character",10,0}}  // Hora del Usuario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aErrSys
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathErr) == 0
	    DBCREATE(fErrSys,aErrSys,"DBFNTX")
	    Proteger(fErrSys,nModCry)

       CASE DIRCHANGE(PathErr) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathErr)

       CASE DIRCHANGE(PathErr) == -5
	    cError('NO TIENE DERECHOS EN: '+PathErr)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/96 MIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   MAY 15/96 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo de errores del sistema

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuErrSys(lShared,nModCry,PathErr,fErrSys,fNtxErr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathErr			      // Path del Archivo
       fErrSys			      // Nombre del Archivo
       fNtxErr			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathErr+'\'+fErrSys,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DEL SISTEMA DE ERRORES")
       Termometro(100)

       CreaErrSys(lShared,nModCry,PathErr,fErrSys,fNtxErr)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 26/99 JUE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   AGO 26/99 JUE

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrErr(lShared,nModCry,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ERR',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE ERRORES DEL SISTEMA')
	  CloseDbf('ERR',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ERR->(DBSTRUCT())
       CloseDbf('ERR',PathArc+'\'+cNomArc,nModCry)
       CreaErrSys(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio .AND. lShared
	  cError('El Archivo ERRORES DEL SISTEMA su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaErrSys(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: GRABACION ERRORORES DEL SISTEMA                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/96 MIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   MAY 15/96 MIE

OBJETIVOS:

1)- Graba el tipo de error que se ha presentado en el sistema

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GrabErrSys(lShared,cNomUsr,cCodEst,cObsUno,cObsDos,cObsTre)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cCodEst                              // C¢digo del Estudiante
       cObsUno			            // Observaci¢n Uno
       cObsDos			            // Observaci¢n Dos
       cObsTre                              // Observaci¢n Tres */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DE LOS PARAMETROS
       lShared := IF(EMPTY(lShared),.T.,lShared)
       cNomUsr := IF(EMPTY(cNomUsr),'',cNomUsr)
       cCodEst := IF(EMPTY(cCodEst),'',cCodEst)
       cObsUno := IF(EMPTY(cObsUno),'',cObsUno)
       cObsDos := IF(EMPTY(cObsDos),'',cObsDos)
       cObsTre := IF(EMPTY(cObsTre),'',cObsTre)
*>>>>FIN VALIDACION DE LOS PARAMETROS

*>>>>GRABACION DEL ERROR PRESENTADO
       IF ERR->(lRegLock(lShared,.T.))
	  REPL ERR->cCodigoEst WITH cCodEst
	  REPL ERR->cCodigoEst WITH CRYPT(ERR->cCodigoEst,'ERRSYS')

	  REPL ERR->cObsUnoErr WITH cObsUno
	  REPL ERR->cObsUnoErr WITH CRYPT(ERR->cObsUnoErr,'ERRSYS')

	  REPL ERR->cObsDosErr WITH cObsDos
	  REPL ERR->cObsDosErr WITH CRYPT(ERR->cObsDosErr,'ERRSYS')

	  REPL ERR->cObsTreErr WITH cObsTre
	  REPL ERR->cObsTreErr WITH CRYPT(ERR->cObsTreErr,'ERRSYS')

	  REPL ERR->cNomUsrErr WITH cNomUsr
	  REPL ERR->cNomUsrErr WITH CRYPT(ERR->cNomUsrErr,'ERRSYS')

	  REPL ERR->cFecUsrErr WITH DTOC(DATE())
	  REPL ERR->cFecUsrErr WITH CRYPT(ERR->cFecUsrErr,'ERRSYS')

	  REPL ERR->cHorUsrErr WITH cHoraSys()
	  REPL ERR->cHorUsrErr WITH CRYPT(ERR->cHorUsrErr,'ERRSYS')

	  ERR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL ERROR DEL SISTEMA')
       ENDIF
       IF lShared
	  ERR->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL ERROR PRESENTADO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO 		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/99 JUE A
       Colombia, Bucaramanga        INICIO: 07:35 PM   AGO 05/99 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenErr(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,fErrSys,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
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
       fErrSys                              // Error del Sistema
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL PathSis := ''                  // Path del Sistema
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       nModCry := IF(nModCry==NIL,0,nModCry)
       PathSis := cPatSis
       IF !lUseDbf(.T.,fErrSys,'ERR',NIL,lShared,nModCry)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseDbf('ERR',fErrSys,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF !lFileLock()
	  oBrowse := oDefBrwErr(nFilPal+1,00,22,79)
	  SETKEY(K_F5,{||BuscarErr(oBrowse)})
	  SETKEY(K_F9,{||MenuOtrErr(lShared,cNomSis,cEmpPal,cNitEmp,;
				    cNomEmp,cNomSec,nFilInf,nColInf,;
				    nFilPal,cNomUsr,cAnoUsr,cPatSis,;
				    oBrowse)})
	  ERR->(CtrlBrw(lShared,oBrowse))
	  SETKEY(K_F5,NIL)
	  SETKEY(K_F9,NIL)
       ENDIF
       DBUNLOCKALL()
       CloseDbf('ERR',fErrSys,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE 		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/99 JUE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   AGO 05/99 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwErr(nFilSup,nColSup,nFilInf,nColInf,cTitSup,cTitInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cTitSup                              // T¡tulo Superior
       cTitInf                              // T¡tulo Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas


       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       cTitSup := IF(EMPTY(cTitSup),;
		  '<< RELACION DE ERRORES >>',cTitSup)

       cTitInf := IF(EMPTY(cTitInf),;
		  '<F5>Buscar <F9>Otros <ESC>Abandonar',cTitInf)

       oBrowse:Cargo     := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ERR
       oColumn	     := TBCOLUMNNEW('No.',{||ERR->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA',;
				   {||CRYPT(ERR->cFecUsrErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA',;
				   {||CRYPT(ERR->cHorUsrErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||CRYPT(ERR->cCodigoEst,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION No. 1',;
				    {||CRYPT(ERR->cObsUnoErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION No. 2',;
				    {||CRYPT(ERR->cObsDosErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION No. 3',;
				    {||CRYPT(ERR->cObsTreErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION No. 3',;
				    {||CRYPT(ERR->cObsTreErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('USUARIO',;
				    {||CRYPT(ERR->cNomUsrErr,"ERRSYS")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: BUSQUEDA DEL CODIGO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/99 JUE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   AGO 05/99 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Busca el c¢digo

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarErr(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse				    // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTes := cSpaces('ERR','cCodigoEst')
       TitBuscar(LEN(cCodigoTes)+3,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lCorrecion(@cCodigoTes)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE VAL(cCodigoTes) == 0

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT ERR
       IF lBuscar .AND. lLocCodigo('cCodigoEst','ERR',;
				   CRYPT(cCodigoTes,'ERRSYS'))
	  nRegAct := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegAct
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE OTROS PARA EL ARCHIVO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/99 JUE A
       Colombia, Bucaramanga        INICIO: 08:05 PM   AGO 05/99 JUE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrErr(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		    cAnoUsr,cPatSis,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
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
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

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
       aMenus := {'1<INFORME DE ERRORES >'}

       aAyuda := {'Imprime el informe de Errores'}

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
	    OtrErr011(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		      cAnoUsr,cPatSis,oBrowse)
	   *Informe de Errores

       ENDCASE

       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA