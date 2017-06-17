/*               	   SIMA - SISTEMA DE CAFETERIA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE BOLETAS

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   OCT 03/2002 JUE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfBol(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoBol","Character", 07,0}) // C¢digo del Personal
       AADD(aDbfStr,{"cCodigoTip","Character", 01,0}) // C¢digo del Tipo de Personal
     *ÀInformaci¢n t‚cnica

       AADD(aDbfStr,{"dFecVenBol","Date"     , 08,0}) // Fecha de Venta
       AADD(aDbfStr,{"dFecCnsBol","Date"     , 08,0}) // Fecha de Consumo
       AADD(aDbfStr,{"nVlrBolBol","Numeric"  , 07,0}) // Valor de la Boleta
       AADD(aDbfStr,{"lImpPrnBol","Logical"  , 01,0}) // .T. Impresa la Boleta
     *ÀInformaci¢n de N¢mina
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 JUE A
       Colombia, Bucaramanga        INICIO: 05:35 PM   OCT 03/2002 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfBol(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo
       fNtxArc			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfBol(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 JUE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   OCT 03/2002 JUE

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrBol(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ARC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('ARC')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ARC->(DBSTRUCT())
       CloseDbf('ARC')
       CreaDbfBol(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo BOLETAS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfBol(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 JUE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   OCT 03/2002 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenBol(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,lVentas)

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
       cJorTxt                              // Jornada escogida
       lVentas                              // .T. Boletas Vendidas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL aCamLoc := {}                  // Campos a Localizar
       LOCAL cTitCam := ''                  // T¡tulo del Campo
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse del Browse
       LOCAL bCodIns := NIL                 // CodeBlock de Inserci¢n
       LOCAL bCodBlo := NIL                 // CodeBlock

       LOCAL GetList := {}                  // Variable del Sistema

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       lVentas := IF(lVentas==NIL,.F.,lVentas)

       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaf,'CAF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
       IF lVentas
	  AADD(aUseDbf,{.T.,cPatSis+'\'+;
			    FileVbo+cAnoSis+ExtFile,'BOL',NIL,lShared,nModCry})
       ELSE
	  AADD(aUseDbf,{.T.,PathSis+'\'+FileBol,'BOL',;
			    PathSis+'\'+fNtxBol,lShared,nModCry})
       ENDIF
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O DE LA CONTABILIDAD')

       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TIP->(RECCOUNT()) == 0
	    cError('NO EXISTEN TIPOS DE PERSONAL GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>BROWSE DEL ARCHIVO
       SELECT BOL
       IF !lFileLock()
	  oBrowse := oDefBrwBol(lShared,nFilPal+1,00,22,79,lVentas)
	  SETKEY(K_F5,{||BuscarBol(oBrowse)})
	  SETKEY(K_F9,{||MenuBol01(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				   cJorTxt,oBrowse)})
	  BOL->(CtrlBrw(lShared,oBrowse))
	  SETKEY(K_F5,NIL)
	  SETKEY(K_F9,NIL)
       ENDIF
       DBUNLOCKALL()
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 JUE A
       Colombia, Bucaramanga        INICIO: 05:50 PM   OCT 03/2002 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwBol(lShared,nFilSup,nColSup,nFilInf,nColInf,lVentas)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lVentas                              // .T. Boletas Vendidas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCampos := ''                  // Campos

       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Transaciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       IF lVentas
	  oBrowse:Cargo := {'<< BOLETAS CONSUMIDAS DE CAFETERIA'+' .'+;
			    'TOTAL ='+STR(RECCOUNT(),4)+' >>',;
			    '<ESC>Abandonar',{||IncluirBol(lShared)}}
       ELSE
	  oBrowse:Cargo := {'<< BOLETAS EMITIDAS DE CAFETERIA'+' .'+;
			    'TOTAL ='+STR(RECCOUNT(),4)+' >>',;
			    '<INS>Incluir <ESC>Abandonar',;
			    {||IncluirBol(lShared)}}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT BOL
       oColumn	     := TBCOLUMNNEW('BOLETA;NUMERO', {||BOL->cCodigoBol})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO', {||BOL->cCodigoTip})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION;DEL TIPO',;
				    {||cNomTipPer(BOL->cCodigoTip,'BOL')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;DE VENTA', {||BOL->dFecVenBol})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;DE CONSUMO', {||BOL->dFecCnsBol})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DE;LA BOLETA',{||BOL->nVlrBolBol})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('BOLETA;IMPRESA',{||BOL->lImpPrnBol})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BOL'},;
			 {'FIELD','lImpPrnBol'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 JUE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   OCT 03/2002 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Inserta un registro al archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirBol(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL cSavLin := ''
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nNroIni := 0                   // N£mero de Boleta Inicial
       LOCAL nNroFin := 0                   // N£mero de Boleta Final
       LOCAL nNroBol := 0                   // N£mero de Boleta
       LOCAL cNroBol := ''                  // N£mero de Boleta
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTbo := ''               // C¢digo de la Boleta
       LOCAL cCodigoTtp := ''               // C¢digo del Tipo
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>FILTRACION DEL ARCHIVO
       SELECT TIP
       SET FILTER TO TIP->lBoletaTip
       GO TOP
       IF EOF()
	  SET FILTER TO
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>INICIALIZACION DE LAS VARIABLES
       SET CURSOR ON
       nNroFil := nMarco(nNroFil+3,'POR FAVOR ENTRE LOS DATOS DE LAS BOLETAS',22,'°')
       cCodigoTbo := cSpaces('BOL','cCodigoBol')
       cCodigoTtp := cSpaces('TIP','cCodigoTip')
*>>>>FIN INICIALIZACION DE LAS VARIABLES

*>>>>LECTURA DEL REGISTRO
       cSavLin := SAVESCREEN(22,00,22,79)

       @ nNroFil+00,nNroCol SAY 'TIPO PERSONAL        :';
			    GET cCodigoTtp PICT '9';
			    VALID lValTipo(ROW(),COL()-2,@cCodigoTtp) .AND.;
				  cCodigoTtp # '1' .AND. cCodigoTtp # '2'

       @ nNroFil+01,nNroCol SAY 'NRO DE BOLETA INICIAL:';
			    GET nNroIni PICT '999999'

       @ nNroFil+02,nNroCol SAY 'NRO DE BOLETA FINAL  :';
			    GET nNroFin PICT '999999'
       READ
       RESTSCREEN(22,00,22,79,cSavLin)
*>>>>FIN LECTURA DEL REGISTRO

*>>>>VALIDACION DEL REGISTRO
       lHayErr := .T.
       DO CASE
       CASE EMPTY(cCodigoTtp) .OR.;
	    EMPTY(nNroIni)    .OR. EMPTY(nNroFin)
	    cError('DEBE SUMINISTRARLOS DATOS COMPLETOS. '+;
		   'NO SE GRABA EL REGISTRO')

       CASE TIP->nTotBolTip+(nNroFin - nNroIni) > 9999999
	    cError('EL NUMERO DE BOLETAS EXCEDE LAS 999.999 PERMITIDAS')

       CASE EMPTY(TIP->nVlrBolTip)
	    cError('DEBE ESPECIFICAR EL VALOR DE LA BOLETA')

       CASE nNroIni > nNroFin
	    cError('EL NUMERO INICIAL NO PUEDE SER MAYOR AL NUMERO FINAL')

       OTHERWISE
	    lHayErr := .F.
       ENDCASE
       IF lHayErr
	  SET FILTER TO
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL REGISTRO

*>>>>VALIDACION DE LOS NUMEROS
       FOR i := nNroIni TO nNroFin
	   cNroBol := STR(i,6)
	   lCorrecion(@cNroBol)
	   cCodigoTbo := cCodigoTtp+cNroBol

	   IF lSekCodigo(cCodigoTbo,'BOL')
	      cError('LA BOLETA No. '+cCodigoTbo+' YA FUE EMITIDA')
	      SET FILTER TO
	      RETURN NIL
	   ENDIF
       ENDFOR
*>>>>FIN VALIDACION DE LOS NUMEROS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA GRABAR EL REGISTRO? Si No')
	  SET FILTER TO
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>GRABACION DEL REGISTRO
       nNroBol := TIP->nTotBolTip
       FOR i := nNroIni TO nNroFin

	   IF BOL->(lRegLock(lShared,.T.))

	      nNroBol++
	      cNroBol := STR(i,6)
	      lCorrecion(@cNroBol)
	      cCodigoTbo := cCodigoTtp+cNroBol

	      REPL BOL->cCodigoBol WITH cCodigoTbo
	      REPL BOL->cCodigoTip WITH cCodigoTtp
	      REPL BOL->nVlrBolBol WITH TIP->nVlrBolTip
	      BOL->(DBCOMMIT())
	      IF lShared
		 BOL->(DBUNLOCK())
	      ENDIF
	    *ÀGrabaci¢n c¢digo de la Boleta

	   ENDIF

       ENDFOR
*>>>>FIN GRABACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT TIP
       IF TIP->(lRegLock(lShared,.F.))
	  REPL TIP->nTotBolTip WITH nNroBol
	  TIP->(DBCOMMIT())
       ENDIF
       IF lShared
	  TIP->(DBUNLOCK())
       ENDIF
       SET FILTER TO
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2002 MAR A
       Colombia, Bucaramanga        INICIO: 07:45 AM   OCT 08/2002 MAR

OBJETIVOS:

1- Localiza el c¢digo dentro del Browse

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarBol(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse				    // Browse de Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // Registro del Concepto
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTbo := ''               // Codigo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTbo := SPACE(14)
       TitBuscar(LEN(cCodigoTbo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTbo PICT '@! X9999999999999';
			 VALID lValCodBol(@cCodigoTbo,2)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(cCodigoTbo)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT BOL
       IF lBuscar .AND. lSekCodigo(cCodigoTbo,'BOL')
	   nNroReg := RECNO()
	   GO TOP
	   oBrowse:GOTOP()
	   GO nNroReg
	   oBrowse:FORCESTABLE()
       ELSE
	   oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: CORRECION DEL CODIGO DE LA BOLETA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 07/2002 LUN A
       Colombia, Bucaramanga        INICIO: 12:45 PM   OCT 07/2002 LUN

OBJETIVOS:

1- Permite adecuar el c¢digo de la boleta

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el c¢digo de la boleta corregido.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodBol(cCodigo,nColIni)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // @C¢digo a Validar
       nColIni			            // Columna Inicial */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL CODIGO
       cCodigo := SUBS(cCodigo,1,7)
       lInsCeros(@cCodigo,2)
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS No. 1 PARA EL ARCHIVO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 07/2002 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 AM   OCT 07/2002 LUN

OBJETIVOS:

1- Menu de Otros No. 1 para el archivo.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuBol01(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL nOpcion := 0                   // Opci¢n del Menu

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LAS OPCIONES
*       AADD(aMenus,'1<BOLETAS VENDIDAS>')

*       AADD(aAyuda,'Imprime el Total de Boletas Vendidas por D¡a')

       cSavPan := SAVESCREEN(0,0,24,79)
       nOpcion := nMenu(aMenus,aAyuda,09,25,'<OPCIONES>',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nOpcion == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION DE LAS OPCIONES

*>>>>ANALISIS DE LAS OPCIONES
       DO CASE
       CASE nOpcion == 1
	    M01Bol01(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt)
       ENDCASE
       SELECT BOL
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ANALISIS DE LAS OPCIONES

/*************************************************************************
* TITULO..: OPCION No. 1 DEL MENU 01                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2002 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   OCT 08/2002 MAR

OBJETIVOS:

1- Imprime el total de voletas vendidas por d¡a

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION M01Bol01(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe


       LOCAL dFecVen := CTOD('00/00/00')    // Fecha del Informe
       LOCAL nCantid := 0                   // Cantidad
       LOCAL nVlrTot := 0                   // Valor Total
       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas


       LOCAL cNombreTpe := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

cError('PENDIENTE')
RETURN NIL

*>>>>VALIDACION DEL CONTENIDO
       IF BOL->(RECCOUNT()) == 0
	  cError('NO EXISTEN BOLETAS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LECTURA DE LA FECHA DE VENTA
       SET CURSOR ON
       dFecVen := DATE()
       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA DE VENTA: (MM/DD/AA)';
	       GET dFecVen PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(dFecVen)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA FECHA DE VENTA

*>>>>FILTRACION DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'LOCALIZANDO LAS BOLETAS DE '+cFecha(dFecVen))
       Termometro(25)
       SELECT BOL
       SET FILTER TO BOL->dFecVenBol == dFecVen
       Termometro(50)
       GO TOP
       IF EOF()
	  cError('NO EXISTEN BOLETAS VENDIDAS PARA '+cFecha(dFecVen))
	  SET FILTER TO
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0
       aCabeza := {cNomEmp,cNomSis,;
		   'A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'BOLETAS VENDIDAS DE '+cFecha(dFecVen),;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {30,08,14,20,20}
       aTitulo := {'TIPO',;
		   'CANTIDAD',;
		   'VALOR',;
		   'ENTREGADO',;
		   'RECIBIDO'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       ActivaPrn(lShared,cNomSis,PathSis,fSimCaF,'cColaAcCaF','CaF')
       IF !Printer_on(CAF->lPrnArcCaF)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PERSONAL
       cSavPan := SAVESCREEN(0,0,24,79)
       SELECT TIP
       GO TOP
       DO WHILE .NOT. TIP->(EOF())

**********VALIDACION DE LA BOLETA
	    IF .NOT. TIP->lBoletaTip
		TIP->(DBSKIP())
		LOOP
	    ENDIF
**********FIN VALIDACION DE LA BOLETA

**********RECORRIDO DE LAS BOLETAS VENDIDAS
	    nCantid := 0
	    nVlrTot := 0
	    SELECT BOL
	    DO WHILE .NOT. BOL->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('TIPO:'+TIP->cNombreTip+;
			     'ºNo. '+TIP->(STR(RECNO(),2))+'/'+;
				     TIP->(STR(RECCOUNT(),2))+;
			     'ºBOLETA No.'+BOL->cCodigoBol,cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DE LA FECHA DE VENTA
		 IF TIP->cCodigoTip == SUBS(BOL->cCodigoBol,1,1) .AND.;
		    BOL->dFecVenBol == dFecVen
		    nCantid++
		    nVlrTot += BOL->nVlrBolBol
		 ENDIF
*--------------FIN ANALISIS DE LA FECHA DE VENTA

	       SELECT BOL
	       BOL->(DBSKIP())

	    ENDDO
**********FIN FIN RECORRIDO DE LAS BOLETAS VENDIDAS

**********IMPRESION DEL REGISTRO
	    aTitulo := {TIP->cNombreTip,;
			STR(nCantid,4),;
			STR(nVlrTot,12,0),;
			SPACE(20),;
			SPACE(20)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT TIP
	    TIP->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PERSONAL

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS