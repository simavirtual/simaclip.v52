/*               SIMASOFT - SISTEMAS INTEGRADOS MULTIUSUARIO
	BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CONFIGURACION DEL COLOR

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:00 PM   JUL 07/2001 SAB

OBJETIVOS:

1)- Crea la estructura del archivo.

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfClr(lShared,nModCry,PathClr,FileClr,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathClr				    // Path del Archivo
       FileClr				    // Nombre del Archivo
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL       i := 0                   // Contador

       LOCAL aDbfClr := {{"nCodigoClr","Numeric"  ,02,0},;  // Codigo Del Color
			 {"cSetGetClr","Character",60,0},;  // Fondo,GetsSi,GetsNo,cMarGen
			 {"cMnuPalClr","Character",60,0},;  // Menu Principal
			 {"cSubPalClr","Character",60,0},;  // Sub Menu Principal
			 {"cSubMnuClr","Character",60,0},;  // Sub Menus Secundarios
			 {"cOtrMnuClr","Character",60,0},;  // Otros Menus
			 {"cClrBrwClr","Character",60,0},;  // Color para los Browse
			 {"cSetSayClr","Character",60,0}}   // SayTxt,SayDat,cClrMar,cClrTit,cClrMsg,cClrErr
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfClr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathClr) == 0
	    DBCREATE(FileClr,aDbfClr,"DBFNTX")
	    Proteger(FileClr,nModCry)

       CASE DIRCHANGE(PathClr) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathClr)

       CASE DIRCHANGE(PathClr) == -5
	    cError('NO TIENE DERECHOS EN: '+PathClr)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathClr+'\'+FileClr,'CLR',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL COLOR')
	  CloseDbf('CLR',PathClr+'\'+FileClr,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF CLR->(lRegLock(lShared,.T.))
	  REPL CLR->nCodigoClr WITH 1
	  REPL CLR->cSetGetClr WITH 'G/B,B/W,B/BG,W/B'
	  REPL CLR->cMnuPalClr WITH 'BG+/B,G/B,W/B'
	  REPL CLR->cSubPalClr WITH 'W/B,BG/B,BG/B'
	  REPL CLR->cSubMnuClr WITH 'W+/B,G/B'
	  REPL CLR->cOtrMnuClr WITH 'W/B,W/B,GR/W'
	  REPL CLR->cClrBrwClr WITH 'B/BG,GR+/B,GR/W'
	  REPL CLR->cSetSayClr WITH 'GR/W,W+/G,W+/GR,GR/W,N+/B,N+/B'
	  CLR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  CLR->(DBUNLOCK())
       ENDIF

       IF CLR->(lRegLock(lShared,.T.))
	  REPL CLR->nCodigoClr WITH 2
	  REPL CLR->cSetGetClr WITH 'W/B,B/W,B/BG,W/B'
	  REPL CLR->cMnuPalClr WITH 'BG+/B,G/B,W/B'
	  REPL CLR->cSubPalClr WITH 'W/B,BG/B,BG/B'
	  REPL CLR->cSubMnuClr WITH 'W+/B,G/B'
	  REPL CLR->cOtrMnuClr WITH 'W/B,W/B,GR/W'
	  REPL CLR->cClrBrwClr WITH 'B/BG,GR+/B,GR/W'
	  REPL CLR->cSetSayClr WITH 'GR/W,W+/G,W+/GR,GR/W,N+/B,N+/B'
	  CLR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  CLR->(DBUNLOCK())
       ENDIF

       IF CLR->(lRegLock(lShared,.T.))
	  REPL CLR->nCodigoClr WITH 3
	  REPL CLR->cSetGetClr WITH 'B,B/W,B,W/B'
	  REPL CLR->cMnuPalClr WITH 'B,W,W'
	  REPL CLR->cSubPalClr WITH 'WB/B,BG/B,BG/B'
	  REPL CLR->cSubMnuClr WITH 'W+/B,G/B'
	  REPL CLR->cOtrMnuClr WITH 'W/B,W/B,GR/W'
	  REPL CLR->cClrBrwClr WITH 'B/BG,GR+/B,GR/W'
	  REPL CLR->cSetSayClr WITH 'GR/W,W+/G,W+/GR,GR/W,N+/B,N+/B'
	  CLR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  CLR->(DBUNLOCK())
       ENDIF

       CloseDbf('CLR',PathClr+'\'+FileClr,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:05 PM   JUL 07/2001 SAB

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfClr(lShared,nModCry,PathClr,FileClr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathClr			      // Path del Archivo
       FileClr			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       wait "SE BORRO EL ARCHIVO "+PathClr+'\'+FileClr

       Termometro(0,"CREANDO LA ESTRUCTURA DEL COLOR")
       Termometro(100)

       CreaDbfClr(lShared,nModCry,PathClr,FileClr)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:07 PM   JUL 07/2001 SAB

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

FUNCTION nActStrClr(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'CLR',NIL,lShared,nModCry)
	  Wait 'ABRIENDO EL ARCHIVO DE CONFIGURACION DEL COLOR'
	  CloseDbf('CLR',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CLR->(DBSTRUCT())
       CloseDbf('CLR',PathArc+'\'+cNomArc,nModCry)
       CreaDbfClr(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
       IF lCambio
	  Wait 'El Archivo CONFIG COLOR su Estructura Esta DesActualizada'

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
			 {||CreaDbfClr(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     Wait 'NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO'
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO 		                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:10 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Permite el mantenimiento del archivo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenClr(lShared,nModCry,PathClr,FileClr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Proctecci¢n
       FileClr			            // Archivo de Usuarios */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL cAyuUno := ''                  // Ayuda para el Color
       LOCAL cAyuDos := ''                  // Ayuda para el Color
       LOCAL oBrowse := NIL                 // Browse de Transaciones
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathClr+'\'+FileClr,'CLR',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('CLR',PathClr+'\'+FileClr,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>ACTIVACION DE LA AYUDA PARA LA EDICION
       cAyuUno := 'COLOR PARA LECTURAS'+;
		  CHR(13)+CHR(10)+;
		  '1=>Color Fondo'+;
		  CHR(13)+CHR(10)+;
		  '2=>Gets Selecionados y Barra en los Menus'+;
		  CHR(13)+CHR(10)+;
		  '3=>Gets No Selecionados'+;
		  CHR(13)+CHR(10)+;
		  '4=>Marco General en Color'+;
		  CHR(13)+CHR(10)+;
		  'Ejemplo: W/B,B/W,B/BG,W/B'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'COLOR PARA LOS MENUS'+;
		  CHR(13)+CHR(10)+;
		  '1=>Color de las Opciones'+;
		  CHR(13)+CHR(10)+;
		  '2=>Color para el Marco del Men£'+;
		  CHR(13)+CHR(10)+;
		  '3=>Color para el T¡tulo del Menu'+;
		  CHR(13)+CHR(10)+;
		  'Ejemplo: BG+/B,G/B,GR+/N'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'COLOR PARA LOS BROWSES'+;
		  CHR(13)+CHR(10)+;
		  '1=>Color General del Browse'+;
		  CHR(13)+CHR(10)+;
		  '2=>Color para el Marco del Browse'+;
		  CHR(13)+CHR(10)+;
		  '3=>Color para los Encabezados del Browse'+;
		  CHR(13)+CHR(10)+;
		  'Ejemplo: B/BG,GR+/B,GR/W'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'COLOR PARA VISUALIZACION'+;
		  CHR(13)+CHR(10)+;
		  '1=>Color Para el Texto Fijo'+;
		  CHR(13)+CHR(10)+;
		  '2=>Color para el Texto de Variable. Ej: Datos'+;
		  CHR(13)+CHR(10)+;
		  '3=>Color para los Marcos Generales'+;
		  CHR(13)+CHR(10)+;
		  '4=>Color para el T¡tulo de los Marcos Generales'+;
		  CHR(13)+CHR(10)+;
		  '5=>Color para la Caja de Mensajes'+;
		  CHR(13)+CHR(10)+;
		  '5=>Color para los Mensajes Generales del Sistema'+;
		  CHR(13)+CHR(10)+;
		  'Ejemplo: Pendiente'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)

       cAyuDos := 'TABLA DE COLORES'+;
		  CHR(13)+CHR(10)+;
		  'N =>Negro'+;
		  CHR(13)+CHR(10)+;
		  'B =>Azul'+;
		  CHR(13)+CHR(10)+;
		  'G =>Verde'+;
		  CHR(13)+CHR(10)+;
		  'BG=>CYAN'+;
		  CHR(13)+CHR(10)+;
		  'R =>Rojo'+;
		  CHR(13)+CHR(10)+;
		  'RB=>Magenta'+;
		  CHR(13)+CHR(10)+;
		  'GR=>Marron'+;
		  CHR(13)+CHR(10)+;
		  'W =>Blanco'+;
		  CHR(13)+CHR(10)+;
		  'N+=>Gris'+;
		  CHR(13)+CHR(10)+;
		  'GR+=>Amarillo'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Nota:'+;
		  CHR(13)+CHR(10)+;
		  '* Los colores se deben definir en parejas de '+;
		     'Primer y Segundo plano separados por un / Ej: W/B=>Blanco/Azul'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  '* Si se definen varios colores se deben separar por comas Ej: W/B,R/G'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  '* A los Colores se le puende incrementar el Brillo '+;
		     'anteponiendo el Signo +'+;
		     'Ej: W+/B =>Blanco Brillante/Azul'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  '* El Color Amarillo GR+ solo se activa en primer plano'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'ACTIVACION DE LA CONFIGURACION DEL COLOR'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Para Activar la Configuraci¢n del Color se debe realizar'+;
		  ' en la opci¢n <CONFIGURACION SISTEMA> seg£n '+;
		  'las sgtes opciones:'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  '<UTILIDADES><CONFIGURACION><CONFIGURACION SISTEMA>'+;
		  CHR(13)+CHR(10)+;
		  'CONFIGURACION DEL COLOR = 1'+;
		  CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  '* Se pueden definir 99 configuraciones diferentes del color'+;
		  CHR(13)+CHR(10)

	  SETKEY(K_F1,{||AyudaTxt(cAyuUno+cAyuDos,;
				  'AYUDA PARA CONFIGURACION DEL COLOR',;
				  '<ESC>Abandona la Ayuda')})
*>>>>FIN ACTIVACION DE LA AYUDA PARA LA EDICION

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT CLR
       IF !lFileLock()
	  oBrowse := oDefBrwClr(lShared,03,00,22,79)

	  SETKEY(K_F5,{||BuscarClr(oBrowse)})
	  CLR->(CtrlBrw(lShared,oBrowse))
	  SETKEY(K_F5,NIL)
       ENDIF
       SETKEY(K_F1,NIL)
       DBUNLOCKALL()
       CloseDbf('CLR',PathClr+'\'+FileClr,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:20 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Define el objeto Browse del archivo.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwClr(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Transaciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo := {'<< CONFIGURACION DEL COLOR >>',;
			 '<INS>Incluir <F5>Buscar  <DEL>Borrar  '+;
			 '<F9>Imprimir <ESC>Abandonar',{||IncluirClr(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CLR
       oColumn	     := TBCOLUMNNEW('COLOR', {||CLR->nCodigoClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','nCodigoClr'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLOR PARA LECTURAS No. 1',;
				    {||CLR->cSetGetClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cSetGetClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MENU PRINCIPAL No. 2', {||CLR->cMnuPalClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cMnuPalClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SUBMENU PRINCIPAL No. 3', {||CLR->cSubPalClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cSubPalClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SUBMENUS SECUNDARIOS No. 4',;
				    {||CLR->cSubMnuClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cSubMnuClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OTROS MENUS No. 5',{||CLR->cOtrMnuClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cOtrMnuClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BROWSES No. 6',;
				    {||CLR->cClrBrwClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cClrBrwClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLOR PARA VISUALIZACION No. 7',;
				    {||CLR->cSetSayClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLR'},{'FIELD','cSetSayClr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO          	                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:25 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirClr(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nCodigoTcl := ''               // C¢digo del Color
       LOCAL cSetGetTcl := ''               // Fondo,GetsSi,GetsNo,cMarGen
       LOCAL cMnuPalTcl := ''               // Color Men£ Principal
       LOCAL cSubPalTcl := ''               // Color SubMenu Principal
       LOCAL cSubMnuTcl := ''               // Color SubMenus Secundarios
       LOCAL cOtrMnuTcl := ''               // Color para Otros Menus
       LOCAL cClrBrwTcl := ''               // Color para los Browse
       LOCAL cSetSayTcl := ''               // SayTxt,SayDat,cClrMar,cClrTit,cClrMsg,cClrErr
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR DIGITE LA CONFIGURACION '+;
			 'DEL COLOR',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       nCodigoTcl := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL COLOR:';
				GET nCodigoTcl PICT '9999';
				VALID !lValCodClr(nCodigoTcl)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(nCodigoTcl)

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')
	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>LECTURA DE LA CONFIGURACION POR DEFECTO
       SELECT CLR
       GO TOP
       cSetGetTcl := CLR->cSetGetClr
       cMnuPalTcl := CLR->cMnuPalClr
       cSubPalTcl := CLR->cSubPalClr
       cSubMnuTcl := CLR->cSubMnuClr
       cOtrMnuTcl := CLR->cOtrMnuClr
       cClrBrwTcl := CLR->cClrBrwClr
       cSetSayTcl := CLR->cSetSayClr
*>>>>FIN LECTURA DE LA CONFIGURACION POR DEFECTO

*>>>>GRABACION DEL REGISTRO
       SELECT CLR
       IF lGrabar
	  IF CLR->(lRegLock(lShared,.T.))
	     REPL CLR->nCodigoClr WITH nCodigoTcl
	     REPL CLR->cSetGetClr WITH cSetGetTcl
	     REPL CLR->cMnuPalClr WITH cMnuPalTcl
	     REPL CLR->cSubPalClr WITH cSubPalTcl
	     REPL CLR->cSubMnuClr WITH cSubMnuTcl
	     REPL CLR->cOtrMnuClr WITH cOtrMnuTcl
	     REPL CLR->cClrBrwClr WITH cClrBrwTcl
	     REPL CLR->cSetSayClr WITH cSetSayTcl
	     CLR->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  CLR->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:30 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodClr(nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('nCodigoClr','CLR',nCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: BUSCAR EL CODIGO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:35 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso los archivo.

2- Busca el c¢digo.

3- Retorna NIL

SINTAXIS:

  BuscarClr(oBrowse,cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarClr(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			            // Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nCodigo := ''                  // C¢digo de Buscar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       nCodigo := 0
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET nCodigo PICT '99';
			 VALID lValidaClr(ROW(),COL()-1,@nCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(nCodigo)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT CLR
       IF lBuscar .AND. lLocCodigo('nCodigoClr','CLR',nCodigo)
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
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:45 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValidaClr(nNroFil,nNroCol,nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodigo				    // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('nCodigoClr','CLR',nCodigo)
	  nNroReg := nSelCodClr(nNroFil,nNroCol)
	  IF nNroReg == 0
	     nCodigo := 0
	  ELSE
	     GO nNroReg
	     nCodigo := CLR->nCodigoClr
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:50 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger el registro del archivo de acuerdo al nombre.

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodClr(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF CLR->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CLR
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL REGISTRO
       CLR->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||CLR->cNombreClr})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 06:50 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xColorSys(nCodClr)

*>>>>DESCRIPCION DE PARAMETROS
/*     nCodClr                              // C¢digo del Color */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL COLOR
       IF !EMPTY(nCodClr)
	  IF lLocCodigo('nCodigoClr','CLR',nCodClr)
	     xClrSys := {}
	     AADD(xClrSys,ALLTRIM(CLR->cSetGetClr))
	     AADD(xClrSys,ALLTRIM(CLR->cMnuPalClr))
	     AADD(xClrSys,ALLTRIM(CLR->cSubPalClr))
	     AADD(xClrSys,ALLTRIM(CLR->cSubMnuClr))
	     AADD(xClrSys,ALLTRIM(CLR->cOtrMnuClr))
	     AADD(xClrSys,ALLTRIM(CLR->cClrBrwClr))
	     AADD(xClrSys,ALLTRIM(CLR->cSetSayClr))
	  ENDIF
       ENDIF
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR

/*************************************************************************
* TITULO..: POSICION DEL COLOR                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 13/2001 VIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   JUL 13/2001 VIE

OBJETIVOS:

1- Permite escoger las definiciones del Color del Sistema

3- Retorna el Color de acuerdo a la posici¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xColores(cColors)

*>>>>DESCRIPCION DE PARAMETROS
/*     cColors                              // Colores */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPos := 0                   // Posici¢n antes de la coma
       LOCAL nTotClr := 0                   // Total de Colores
       LOCAL aColors := {}                  // Colores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF EMPTY(cColors)
	  RETURN ''
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>CALCULO DEL TOTAL DE COLORES
       FOR i := 1 TO LEN(cColors)
	   IF SUBS(cColors,i,1) == ','
	      nTotClr++
	   ENDIF
       ENDFOR
       nTotClr++
*>>>>FIN CALCULO DEL TOTAL DE COLORES

*>>>>SEPARACION DE LOS COLORES
       FOR i := 1 TO nTotClr
	   nNroPos := AT(',',cColors) - 1
	   IF nNroPos > 0
	      AADD(aColors,LEFT(cColors,nNroPos))
	      cColors := SUBS(cColors,nNroPos+2)
	   ELSE
	      AADD(aColors,cColors)
	   ENDIF
       ENDFOR
       RETURN aColors
*>>>>FIN SEPARACION DE LOS COLORES

/*************************************************************************
* TITULO..: ACTIVACION DEL COLOR                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 13/2001 VIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   JUL 13/2001 VIE

OBJETIVOS:

1- Permite Activar los Colores especificados

2- Retorna el Color Anterior a la Activaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSetColor(cColors)

*>>>>DESCRIPCION DE PARAMETROS
/*     cColors                              // Colores a Activar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cColAnt := ''                  // Color Anterior a la Activaci¢n
       LOCAL cClrFnd := ''                  // Color del Fondo
       LOCAL cGetsSi := ''                  // Color del Get Selecionados
       LOCAL cGetsNo := ''                  // Color del Get No Seleccionados
       LOCAL cMarGen := ''                  // Color Marco General
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[1],'')),,;
	       @cGetsSi,@cGetsNo,@cMarGen)
       Colores(xColores(IF(!EMPTY(cColors),cColors,'')),@cClrFnd)
*>>>>IF ANALISIS DEL COLOR

*>>>>ACTIVACION DEL COLOR
       IF ISCOLOR()
	  IF !EMPTY(cColors)
	     cColAnt := SETCOLOR(cClrFnd+','+cGetsSi+','+;
				 cMarGen+',,'+cGetsNo)
	  ENDIF
       ENDIF
       RETURN cColAnt
*>>>>FIN ACTIVACION DEL COLOR

/*************************************************************************
* TITULO..: DESACTIVACION DEL COLOR                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/2001 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   JUL 27/2001 VIE

OBJETIVOS:

1- DesActiva el Color

2- Activa el Color para los Gets y el marco de Color General

2- Retorna el Color Anterior a la Activaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SetClrTo()

*>>>>DESACTIVACION DEL COLOR
       IF ISCOLOR()
	  cSetColor('W/N')
       ELSE
	  SET COLOR TO
       ENDIF
       RETURN NIL
*>>>>DESACTIVACION DEL COLOR

/*************************************************************************
* TITULO ..: SEPARACION DE COLORES                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/2001 SAB A
       Colombia, Bucaramanga        INICIO: 05:00 PM   JUL 27/2001 SAB

OBJETIVOS:

1- De un vector de colores separa los colores individuales

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Colores(aColors,cColor1,cColor2,cColor3,cColor4,;
		 cColor5,cColor6,cColor7,cColor8,cColor9)

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SEPARACION DE LOS COLORES
       IF !EMPTY(aColors)
	  FOR i := 1 TO LEN(aColors)
	    DO CASE
	    CASE i == 1 .AND. cColor1 # NIL
		 cColor1 := aColors[1]

	    CASE i == 2 .AND. cColor2 # NIL
		 cColor2 := aColors[2]

	    CASE i == 3 .AND. cColor3 # NIL
		 cColor3 := aColors[3]

	    CASE i == 4 .AND. cColor4 # NIL
		 cColor4 := aColors[4]

	    CASE i == 5 .AND. cColor5 # NIL
		 cColor5 := aColors[5]

	    CASE i == 6 .AND. cColor6 # NIL
		 cColor6 := aColors[6]

	    CASE i == 7 .AND. cColor7 # NIL
		 cColor7 := aColors[7]

	    CASE i == 8 .AND. cColor8 # NIL
		 cColor8 := aColors[8]

	    CASE i == 9 .AND. cColor9 # NIL
		 cColor9 := aColors[9]
	    ENDCASE
	  ENDFOR
       ENDIF
       RETURN NIL
*>>>>FIN SEPARACION DE LOS COLORES


/*************************************************************************
* TITULO..: SAY DE TEXTO Y DATOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/2001 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   JUL 27/2001 VIE

OBJETIVOS:

1- Permite Activar los Colores para visualizar texto fijo y texto de datos

2- Retorna '' para facilitar la concatenaci¢n de cadenas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSay(nNroFil,nNroCol,cSayTxt,cSayDat)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la Fila
       nNroCol                              // N£mero de la Columna
       cSayTxt                              // Texto fijo
       cSayDat                              // Texto de Datos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cClrTxt := ''                  // Color para el Texto
       LOCAL cClrDat := ''                  // Color para los Datos
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[7],'')),;
	       @cClrTxt,@cClrDat)
*>>>>IF ANALISIS DEL COLOR

*>>>>IMPRESION DEL TEXTO
       cSetColor(cClrTxt)
       @ nNroFil,nNroCol SAY cSayTxt
      *Texto

       IF !EMPTY(cSayDat)
	  cSetColor(cClrDat)
	  @ nNroFil,nNroCol+LEN(cSayTxt) SAY +SPACE(01)+cSayDat
       ENDIF
     *ÀDatos

       SetClrTo()
       RETURN NIL
*>>>>FIN IMPRESION DEL TEXTO FIJO