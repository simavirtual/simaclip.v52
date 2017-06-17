/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE COBROS

REQUERIMIENTOS:

- Compilar: clipper FuncsCob /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Cobros

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/99 JUE A
       Colombia, Bucaramanga        INICIO: 07:20 PM   AGO 05/99 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfCob(PathCob,FileCob,fNtxCob)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCob(lShared,nModCry,PathCob,FileCob,fNtxCob,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCob				    // Path del Archivo
       FileCob				    // Nombre del Archivo
       fNtxCob				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfCob := {{"cCodigoEst","Character",006,0},; // C¢digo del Estudiante
			 {"nMesIniPag","Numeric"  ,002,0},; // Mes Inicial de pago
			 {"nMesFinPag","Numeric"  ,002,0},; // Mes Final del pago
			 {"nSdoAntPag","Numeric"  ,010,2},; // Saldo Anterior
			 {"nMorAntPag","Numeric"  ,010,2},; // Valor Mora Anterior
			 {"nVlrMesPag","Numeric"  ,010,2},; // Valor del Mes
			 {"nVlrPagPag","Numeric"  ,010,2},; // Valor a pagar
			 {"nVlrComPag","Numeric"  ,010,2},; // Valor de la Comisi¢n
			 {"dFecPagPag","Date"     ,008,0},; // Fecha de pago
			 {"lInfActCob","Logical"  ,001,0},; // .T. Registro grabado en ASCII
			 {"lRegGraCob","Logical"  ,001,0},; // .T. Registro grabado en ASCII
			 {"cRegTxtCob","Character",500,0}}  // Registro para Exportar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCob
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCob) == 0
	    DBCREATE(FileCob,aDbfCob,"DBFNTX")
	    Proteger(FileCob,nModCry)

       CASE DIRCHANGE(PathCob) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCob)

       CASE DIRCHANGE(PathCob) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCob)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/99 JUE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   AGO 05/99 JUE

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

FUNCTION nActStrCob(lShared,nModCry,PathCob,FileCob)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       FileCob				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('COB')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCob+'\'+FileCob,'COB',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE COBROS')
	  CloseDbf('COB',PathCob+'\'+FileCob,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := COB->(DBSTRUCT())
       CloseDbf('COB',PathCob+'\'+FileCob,nModCry)
       CreaDbfCob(lShared,nModCry,PathCob,FileCob,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
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
       IF lCambio
	  cError('El Archivo COBRO su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(FileCob,1,AT('.',FileCob))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathCob+'\'+FileCob,;
			 PathCob+'\'+FileTem,;
			 {||CreaDbfCob(lShared,nModCry,PathCob,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

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

FUNCTION MantenCob(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nMesIni := 0                   // Mes Inicial del pago
       LOCAL cMesIni := ''                  // Mes Inicial del pago
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // Codigo del grupo
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
       SET DECIMAL TO
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Por Favor Seleccione el Mes',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nMesIni == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       fSimaCo,'SCO',NIL,lSiRed,0) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DEL SISTEMA.')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DEL COLEGIO')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
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

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       FileCob := FileCob+cMesIni+ExtFile
       fNtxCob := fNtxCob+cMesIni+cExtNtx
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>LECTURA DEL ARCHIVO DEL EXTRACTO
       IF !FILE(cPatSis+'\COBROS\'+FileCob)

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA RELACIONAR LOS MOROSOS? Si No')
	       CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DEL ARCHIVO
	    OtrCob055(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni)
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA DEL ARCHIVO

       ENDIF
*>>>>FIN LECTURA DEL ARCHIVO DEL EXTRACTO

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatSis+'\COBROS\'+FileCob)
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF nActStrCob(lShared,nModCry,cPatSis+'\COBROS',FileCob) == 1
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>VALIDACION DEL ARCHIVO INDICE
       IF !FILE(cPatSis+'\COBROS'+fNtxCob)

***********SELECCION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\COBROS\'+FileCob,'COB',NIL,lShared,nModCry)
		cError('ABRIENDO EL ARCHIVO DE COBROS')
		CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
		CloseDbf('COB',cPatSis+'\COBROS\'+FileCob,nModCry)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECCION DE LAS AREAS DE TRABAJO

************INDEXACION DEL ARCHIVO
	      SELECT COB
	      INDEX ON COB->cCodigoEst;
		    TO &(cPatSis+'\COBROS\'+fNtxCob)
	      CloseDbf('COB',cPatSis+'\COBROS\'+FileCob,nModCry)
************FIN INDEXACION DEL ARCHIVO

       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO INDICE

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\COBROS\'+FileCob,'COB',;
		       cPatSis+'\COBROS\'+fNtxCob,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE COBROS')
	  CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
	  CloseDbf('COB',cPatSis+'\COBROS\'+FileCob,nModCry)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT COB

       oBrowse := oDefBrwCob(nFilPal+1,00,22,79,cMaeAlu,nMesIni)

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,'COB',cNomEmp,cNomSis)})

       SETKEY(K_F4,{||lDatosEst(lShared,nFilPal,1,;
				COB->cCodigoEst,cMaeAlu)})
       SETKEY(K_F5,{||BuscarCob(oBrowse,cMaeAlu)})
       SETKEY(K_F9,{||MenuOtrCob(aParam1,aParam2,aParam3,;
				 oBrowse,cMesIni)})
       COB->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       SET DECIMAL TO 2
       CloseDbf('SCO',PathUno+'\'+PathSis+'\'+fSimaCo)
       CloseDbf('COB',cPatSis+'\COBROS\'+FileCob,nModCry)
       CloseAll(aUseDbf)
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

 oBrowse := oDefBrwCob(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCob(nFilSup,nColSup,nFilInf,nColInf,;
		    cMaeAlu,nMesIni,cTitSup,cTitInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros habilitados
       nMesIni			            // Mes Inicial del pago
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
		  '<<RELACION DE MOROSOS PARA COBRO. MES '+;
		  cMes(nMesIni,10)+' >>',cTitSup)

       cTitInf := IF(EMPTY(cTitInf),;
		  '<F2>Personal <F4>Actualizar <F5>Buscar <F9>Otros <ESC>Abandonar',cTitInf)

       oBrowse:Cargo     := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT COB
       oColumn	     := TBCOLUMNNEW('CODIGO DEL;ESTUDIANTE', {||COB->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(COB->nMesIniPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(COB->nMesFinPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEUDA ANTERIOR', {||COB->nSdoAntPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA ANTERIOR', {||COB->nMorAntPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MES', {||COB->nVlrMesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POR PAGAR', {||COB->nVlrPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;DE PAGO',{||cFecha(COB->dFecPagPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;COMISION', {||COB->nVlrComPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
			       {||cSekNomAlu(COB->cCodigoEst,cMaeAlu,'COB')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRABADO',;
				   {||IF(COB->lRegGraCob,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REGISTRO TEXTO', {||COB->cRegTxtCob})
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

  BuscarCob(oBrowse,cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCob(oBrowse,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse				    // Browse del Archivo
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegCob := 0                   // Registro del Trao
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL nMesIniTpa := 0                // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTes := cSpaces('COB','cCodigoEst')
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

*>>>>BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
       IF lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct)
	  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	  cNombreTes := SUBS(cNombreTes,1,25)
	  cMsgTxt := cNombreTes+'. GRUPO: '+&cMaeAct->cCodigoGru+;
		     ' NO FIGURA.'
       ELSE
	  cMsgTxt := ' NO FIGURA.'
       ENDIF
*>>>>FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

*>>>>BUSQUEDA DEL CODIGO
       SELECT COB
       IF lBuscar .AND. lSekCodigo(cCodigoTes,'COB',cMsgTxt)
	  nRegCob := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegCob
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

FUNCTION MenuOtrCob(aParam1,aParam2,aParam3,;
		    oBrowse,cMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       cMesIni				    // Mes Inicial */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {'1<INFORME DE LOS MOROSOS >',;
		  '2<CREAR ARCHIVO ASCII    >',;
		  '3<COPIA DEL ARCHIVO ASCII>',;
		  '4<PARAMETROS DEL ARCHIVO >',;
		  '5<LEER ALUMNOS MOROSOS   >'}

       aAyuda := {'Imprime la relaci¢n de los morosos para cobro.',;
		  'Crea el Archivo ASCII',;
		  'Copia del Archivo ASCII',;
		  'Imprime los par metros del archivo',;
		  'Lee Nuevamente los morosos'}

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
	    OtrCob011(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni)
	   *Informe de los morosos


       CASE nNroOpc == 2
	    OtrCob022(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni)
	   *Creaci¢n del archivo ASCII

       CASE nNroOpc == 3
	    OtrCob033(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni)
	   *Copia el Archivo a la Unidad A

       CASE nNroOpc == 4
	    OtrCob044(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni)
	   *Parametros del Archivo

       CASE nNroOpc == 5
	    OtrCob055(aParam1,aParam2,aParam3,;
		      oBrowse,cMesIni)
	   *Lectura de los morosos

       ENDCASE

       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: VALIDA LOS DATOS DE LOS ESTUDIANTES A REPORTAR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 23/2000 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   FEB 23/2000 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lInfActCob(lShared)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aCampos := {}                  // Descripci¢n del Campo
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL nPosFin := 0                   // Posici¢n Final
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lInfAct := .F.                 // .T.Informaci¢n Actualizada
       LOCAL nRegAct := 0                   // Registro Actual
*>>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIPCION DE CAMPOS
       AADD(aCampos,{'CODIGO DEL COLEGIO       ',001,002})
       AADD(aCampos,{'CODIGO DEL ESTUDIANTE    ',003,008})
       AADD(aCampos,{'MES DE LA FACTURACION    ',009,010})
       AADD(aCampos,{'DEUDA SIN INTERESES      ',011,020})
       AADD(aCampos,{'INTERESES EN MORA        ',021,030})
       AADD(aCampos,{'NUMERO DE MESES EN MORA  ',031,032})
       AADD(aCampos,{'NOMBRE DEL ESTUDIANTE    ',033,058})
       AADD(aCampos,{'APELLIDO DEL ESTUDIANTE  ',059,084})
       AADD(aCampos,{'DIRECCION DE LA CASA     ',085,124})
       AADD(aCampos,{'BARRIO                   ',125,140})
       AADD(aCampos,{'TELEFONO DE LA CASA      ',141,150})
       AADD(aCampos,{'NOMBRE DEL PADRE         ',151,190})
       AADD(aCampos,{'CEDULA DEL PADRE         ',191,206})
       AADD(aCampos,{'LUGAR DE LA CEDULA       ',207,222})
       AADD(aCampos,{'TELEFONO DEL PADRE       ',223,232})
       AADD(aCampos,{'NOMBRE DE LA MADRE       ',233,272})
       AADD(aCampos,{'CEDULA DE LA MADRE       ',273,288})
       AADD(aCampos,{'LUGAR DE LA CEDULA       ',289,304})
       AADD(aCampos,{'TELEFONO DE LA MADRE     ',305,314})
       AADD(aCampos,{'NOMBRE DEL ACUDIENTE     ',315,354})
       AADD(aCampos,{'CEDULA DEL ACUDIENTE     ',355,370})
       AADD(aCampos,{'LUGAR DE LA CEDULA       ',371,386})
       AADD(aCampos,{'TEL No. 1 DEL ACUDIENTE  ',387,396})
       AADD(aCampos,{'TEL No. 2 DEL ACUDIENTE  ',397,406})
*>>>>FIN DESCRIPCION DE CAMPOS

*>>>>VALIDACION DEL CONTENIDO
       lInfAct := .T.
       nRegAct := COB->(RECNO())
       SELECT COB
       GO TOP
       DO WHILE .NOT. COB->(EOF())

**********VERIFICACION DE LOS CAMPOS
	    lHayErr := .F.
	    FOR i := 1 TO LEN(aCampos)

		nPosIni := aCampos[i,2]
		nPosFin := aCampos[i,3]
		nLenTxt := nPosFin-nPosIni+1

		IF EMPTY(SUBS(COB->cRegTxtCob,nPosIni,nLenTxt))
		   lHayErr := .T.
		   lInfAct := .F.
		ENDIF

	    NEXT
**********FIN VERIFICACION DE LOS CAMPOS

**********GRABACION DE LA ACTUALIZACION DE LA INFORMACION
	    IF COB->(lRegLock(lShared,.F.))
	       REPL COB->lInfActCob WITH !lHayErr
	       COB->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       COB->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA ACTUALIZACION DE LA INFORMACION

	  COB->(DBSKIP())

       ENDDO
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LA INFORMACION ACTUALIZADA
       IF .NOT. lInfAct
/*
	  cError('LA INFORMACION DE LOS MOROSOS ESTA DESACTUALIZADA',;
		 'FAVOR ACTUALIZAR LOS DATOS DE LOS ESTUDIANTES')
*/
       ENDIF
       nRegAct := COB->(DBGOTO(nRegAct))
       RETURN lInfAct
*>>>>FIN VALIDACION DE LA INFORMACION ACTUALIZADA