/*                    SISTEMA CONTABILIDAD PROFESORES
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO LOG


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 25/2003 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   JUL 25/2003 VIE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaProLog(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'nCodigoLog','Numeric',02,0}) // C¢digo del Log

/*     C¢digos para el Log:
       01 => Creaci¢n de Indicadores
       02 => Modificaci¢n de Indicadores
       03 => Grabaci¢n de Recuperaciones
       04 => Modificaci¢n de Recuperaciones
       05 => Impresi¢n de Listados
       06 => Opciones Varias  */

       AADD(aDbfStr,{'cOpcionLog','Character',40,0}) // Opci¢n del Log
       AADD(aDbfStr,{'cObsMatLog','Character',76,0}) // Observaci¢n de la Materia
       AADD(aDbfStr,{'cObservLog','Character',76,0}) // Observaci¢n del Log
       AADD(aDbfStr,{'cMaeActLog','Character',03,0}) // Maestro Actual
       AADD(aDbfStr,{'nNroPerLog','Numeric'  ,01,0}) // N£mero del Periodo

       AADD(aDbfStr,{'nPrnLisLog','Numeric'  ,01,0}) // Contador de Listas de Clase
       AADD(aDbfStr,{'nPrnParLog','Numeric'  ,01,0}) // Contador de Indicadores parciales
       AADD(aDbfStr,{'nPrnIndLog','Numeric'  ,01,0}) // Contador de Indicadores
       AADD(aDbfStr,{'nPrnPlaLog','Numeric'  ,01,0}) // Contador de Planillas Finales
       AADD(aDbfStr,{'nPrnResLog','Numeric'  ,01,0}) // Contador de Resumenes
       AADD(aDbfStr,{'nPrnOtrLog','Numeric'  ,01,0}) // Contador de Otras Impresiones

       AADD(aDbfStr,{'cCodigoPro','Character',06,0})  // Codigo del Profesor
       AADD(aDbfStr,{'cCodigoEst','Character',06,0})  // Codigo del Estudiante
       AADD(aDbfStr,{'cIndic1Log','Character',125,0}) // Indicadores Antes
       AADD(aDbfStr,{'cDefin1Log','Character', 04,0}) // Definitiva Antes
       AADD(aDbfStr,{'cDefRe1Log','Character', 04,0}) // Recuperaci¢n Antes
       AADD(aDbfStr,{'cIndic2Log','Character',125,0}) // Indicadores Despues
       AADD(aDbfStr,{'cDefin2Log','Character', 04,0}) // Definitiva Despu‚s
       AADD(aDbfStr,{'cDefRe2Log','Character', 04,0}) // Recuperaci¢n Despues

       AADD(aDbfStr,{'cNomUsrLog','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrLog','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorIniLog','Character',10,0}) // Hora de Inicio
       AADD(aDbfStr,{'cHorFinLog','Character',10,0}) // Hora de Final
       AADD(aDbfStr,{'cHorUsrLog','Character',10,0}) // Hora del Usuario
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>VERIFICACION O CREACION DEL DIRECTORIO
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (PathArc) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (PathArc) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathArc)
	    QUIT

       CASE DIRCHANGE(PathArc) == -3
	    DIRMAKE(PathArc)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO

*>>>>CREACION DE LA ESTRUCTURA
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
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/2003 DOM A
       Colombia, Bucaramanga        INICIO: 11:00 PM   FEB 02/2003 DOM

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

FUNCTION nActStrLog(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('LOG')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'LOG',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DEL LOG')
	  CloseDbf('LOG',PathArc+'\'+fArchvo,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := LOG->(DBSTRUCT())
       CloseDbf('LOG',PathArc+'\'+fArchvo,nModCry)
       CreaProLog(lShared,nModCry,PathArc,fArchvo,,@aStrNew)
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
	  cError('El Archivo del LOG su Estructura Esta DesActualizada.',;
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
	  nNroErr := 0
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaProLog(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: GRABACION DEL LOG                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:15 AM   SEP 26/2002 JUE

OBJETIVOS:

1- Permite grabar log de actividades

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aGraProLog(lShared,cNalias,aCamLog,aGenLog,lGraLog)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNalias                              // Alias del Archivo Log
       aCamLog                              // Campos del Log
       aGenLog			            // Campos Generales
       lGraLog                              // .T. Grabar el Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                         // Contador
       LOCAL cCamLog := ''                        // Campo del Log
       LOCAL cAliasA := ''                        // Alias Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA GRABACION
       lGraLog := IF(lGraLog == NIL,.T.,lGraLog)
       IF !lGraLog
	  aCamLog := {}
	  RETURN aCamLog
       ENDIF
*>>>>FIN ANALISIS DE LA GRABACION

*>>>>ADICION DE LOS CAMPOS GENERALES
       IF aGenLog # NIL
	  FOR i := 1 TO LEN(aGenLog)
	      AADD(aCamLog,{aGenLog[i,1],aGenLog[i,2]})
	  ENDFOR
       ENDIF
*>>>>FIN ADICION DE LOS CAMPOS GENERALES

*>>>>REGISTRO DE LA FECHA Y HORA
       AADD(aCamLog,{'dFecUsrLog',DATE()})
       AADD(aCamLog,{'cHorUsrLog',TIME()})
*>>>>FIN REGISTRO DE LA FECHA Y HORA

*>>>>GRABACION DEL LOG
       cAliasA := ALIAS(SELECT())
       SELECT &cNalias
       IF lRegLock(lShared,.T.)
	  FOR i := 1 TO LEN(aCamLog)
	      cCamLog := cNalias+'->'+aCamLog[i,1]
	      REPL &cCamLog WITH aCamLog[i,2]
	  ENDFOR
	  DBCOMMIT()
       ELSE
	  cError('NO SE PUEDE GRABAR EL REGISTRO DEL LOG')
       ENDIF
       DBCOMMIT()
       IF lShared
	  DBUNLOCK()
       ENDIF
       aCamLog := {}
       SELECT &cNalias
       RETURN aCamLog
*>>>>FIN GRABACION DEL LOG

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO 		                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 25/2003 VIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   JUL 25/2003 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManProLog(aP1,aP2,aP3,fArchvo)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       fArchvo				    // Archivo de Usuarios */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL nNroPer := 0                   // N£mero de Periodos
       LOCAL oBrowse := NIL                 // Browse de Transaciones
       LOCAL cFilter := ''                  // Condici¢n del Filtro

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+fArchvo,'LOG',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('LOG',cPatPro+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DEL PERIODO
       nNroPer := TCO->nPerActTbl
       @ nFilInf+1,nColInf GET nNroPer;
			   PICT '9';
			   VALID nNroPer <= TCO->nTotPerTbl
       READ
       IF nNroPer <> 0
	  @ nFilPal,65 SAY 'Peri¢do No. '+STR(nNroPer,1)
       ENDIF
*>>>>FIN LECTURA DEL PERIODO

*>>>>FILTRACION DEL LOG
       IF EMPTY(nNroPer)
	  SET FILTER TO LOG->nCodigoLog == 99
       ELSE
	  SET FILTER TO LOG->nCodigoLog == 99 .AND.;
			LOG->nNroPerLog == nNroPer
       ENDIF
       LOG->(DBGOTOP())
       IF LOG->(EOF())
	  IF EMPTY(nNroPer)
	     cError('NO APARECEN REGISTROS DE INGRESO AL SISTEMA')
	  ELSE
	     cError('NO APARECEN REGISTROS DE INGRESO AL SISTEMA '+;
		    'DEL PERIODO '+STR(nNroPer,1))
	  ENDIF
       ENDIF
*>>>>FIN FILTRACION DEL LOG

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT LOG
       oBrowse := oDefBrwLog(lShared,03,00,22,79,99)
       SETKEY(K_F9,{||MenuOtrLog(lShared,nNroPer,oBrowse)})
       LOG->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F1,NIL)
       SELECT LOG
       SET FILTER TO
       CloseDbf('LOG',cPatPro+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 28/2003 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUL 28/2003 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwLog(lShared,nFilSup,nColSup,nFilInf,nColInf,nCodLog,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nCodLog                              // C¢digo del Log */
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
       IF EMPTY(cTitulo)
	  oBrowse:Cargo := {'<< INGRESOS AL SISTEMA >>',;
			    '<ESC>Abandonar <F9>Consultas'}
       ELSE
	  oBrowse:Cargo := {'<< ACTIVADAD EN EL SISTEMA >>',;
			    '<ESC>Abandonar'}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT LOG
       oColumn := TBCOLUMNNEW('FECHA',{||cFecha(LOG->dFecUsrLog)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OPCION', {||LOG->cOpcionLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INICIO:',;
				    {||cHoraSys(LOG->cHorIniLog)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FINAL:',;
				   {||cHoraSys(LOG->cHorFinLog)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PERIODO', {||LOG->nNroPerLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF nCodLog # 99
	  oColumn := TBCOLUMNNEW('MATERIA', {||LOG->cObsMatLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('OBSERVACION', {||LOG->cObservLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NIVEL', {||LOG->cMaeActLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PROFESOR', {||LOG->cCodigoPro})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF (EMPTY(nCodLog) .OR. nCodLog == 5) .AND. nCodLog # 99
	  oColumn := TBCOLUMNNEW('TOTAL HOJAS DE;LISTAS CLASE',;
				 {||LOG->nPrnLisLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog ==  5) .AND. nCodLog # 99
	  oColumn := TBCOLUMNNEW('TOTAL HOJAS DE;INDICADORES PARCIALES',;
				 {||LOG->nPrnParLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 5) .AND. nCodLog # 99
	  oColumn := TBCOLUMNNEW('TOTAL HOJAS DE;INDICADORES FINALES',;
				 {||LOG->nPrnIndLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 5) .AND. nCodLog # 99
	  oColumn := TBCOLUMNNEW('TOTAL HOJAS DE;PLANILLAS FINALES',;
				 {||LOG->nPrnPlaLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 5) .AND. nCodLog # 99
	  oColumn := TBCOLUMNNEW('TOTAL HOJAS DE;RESUMENES',;
				 {||LOG->nPrnResLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 5) .AND. nCodLog # 99
	  oColumn := TBCOLUMNNEW('TOTAL HOJAS;OTRAS IMPRESIONES',;
		     {||LOG->nPrnOtrLog})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('ESTUDIANTE', {||LOG->cCodigoEst})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('INDICADORES ANTES', {||LOG->cIndic1Log})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('INDICADORES DESPUES', {||LOG->cIndic2Log})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('DEFINITIVA ANTES', {||LOG->cDefin1Log})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('DEFINITIVA DESPUES', {||LOG->cDefin2Log})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('RECUPERACION ANTES', {||LOG->cDefRe1Log})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF (EMPTY(nCodLog) .OR. nCodLog == 3 .OR. nCodLog == 4) .AND.;
	  nCodLog # 99
	  oColumn := TBCOLUMNNEW('RECUPERACION DESPUES', {||LOG->cDefRe2Log})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF


       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||LOG->cNomUsrLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA',;
				    {||cHoraSys(LOG->cHorUsrLog)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('COD',{||LOG->nCodigoLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: TIPO DE LOG 		                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2003 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   OCT 08/2003 VIE

OBJETIVOS:

1- Visualiza un men£ con los diferentes tipos de Actualizaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCodigoLog(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la Fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION Y EJECUCION DEL MENU
       AADD(aMenus,'1<CRECION DE INDICADORES     >')
       AADD(aMenus,'2<MODIFICACION INDICADORES   >')
       AADD(aMenus,'3<GRABACION RECUPERACIONES   >')
       AADD(aMenus,'4<MODIFICACION RECUPERACIONES>')
       AADD(aMenus,'5<IMPRESION DE LISTADOS      >')
       AADD(aMenus,'6<OPCIONES VARIAS            >')

       AADD(aAyuda,'Visualiza el Log de la Creaci¢n de los Indicadores')
       AADD(aAyuda,'Visualiza el Log de la Modificaci¢n de los Indicadores')
       AADD(aAyuda,'Visualiza el Log de la Grabaci¢n de las Recuperaciones')
       AADD(aAyuda,'Visualiza el Log de la Modificaci¢n de las Recuperaciones')
       AADD(aAyuda,'Visualiza el Log de la Impresi¢n de Listados')
       AADD(aAyuda,'Visualiza el Log de Opciones Varias')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nNroFil,nNroCol,NIL,NIL,nNroOpc)
       RESTSCREEN(0,0,24,79,cSavPan)

       RETURN nNroOpc
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

/*************************************************************************
* TITULO..: GRABACION DEL LOG                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/2003 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 AM   OCT 15/2003 MIE

OBJETIVOS:

1- Permite grabar log de actividades

2- No debe estar en uso el archivo del Log

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraProLog(lShared,cAnoUsr,cPatSis,cMaeAct,cPatPro,aCamLog,aGenLog)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del Sistema
       cMaeAct                              // Maestro Actual
       cPatPro                              // Path del Profesor
       aCamLog                              // Campos del Log
       aGenLog			            // Campos Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL nModCry := 0                   // Modo de Protecci¢n
     *ÀVariables generales
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       IF !PathSprAno(lShared,nModCry,cAnoUsr,cPatSis,;
		      @PathUno,@PathDos,@PathTre,@PathCua)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		   FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('TCO')
	  CloseDbf('LOG')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DEL LOG
       AADD(aGenLog,{'nNroPerLog',TCO->nPerActTbl})
       aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       CloseDbf('TCO')
       CloseDbf('LOG')
       RETURN NIL
*>>>>FIN GRABACION DEL LOG

/*************************************************************************
* TITULO..: MENU PARA EL ARCHIVO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/2003 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   OCT 15/2003 MAR

OBJETIVOS:

1- Menu del Archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrLog(lShared,nNroPer,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nNroPer                              // N£mero de Periodos
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<ACTIVIDAD REALIZADA   >')
       AADD(aMenus,'2<ACTIVIDAD POR OPCIONES>')
       AADD(aMenus,'3<TODAS LAS ACTIVIDADES >')
       AADD(aMenus,'4<POR CODIGO ESTUDIANTE >')

       AADD(aAyuda,'Visualiza las actividades realizadas del Ingreso')
       AADD(aAyuda,'Visualiza las actividades por las Opciones Realizadas')
       AADD(aAyuda,'Visualiza todas las actividades realizadas')
       AADD(aAyuda,'Visualiza las actividades para un estudiante')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>CONSULTA DEL LOG
       cSavPan := SAVESCREEN(0,0,24,79)
       ActiviLog(lShared,oBrowse,nNroPer,nNroOpc)
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN CONSULTA DEL LOG

/*************************************************************************
* TITULO..: CONSULTA DE LA ACTIVIDAD DEL LOG                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/2003 MAR A
       Colombia, Bucaramanga        INICIO: 06:10 PM   OCT 15/2003 MAR

OBJETIVOS:

1- Visualiza los procesos realizados del ingreso al Sistema.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActiviLog(lShared,oBrowse,nNroPer,nNroOpc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroPer                              // N£mero del Periodo
       oBrowse                              // Browse del Archivo
       nNroOpc                              // Opci¢n de Consulta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cHorFin := ''                  // Hora Final
       LOCAL cFilter := ''                  // Filter para el Archivo
       LOCAL dFecLog := CTOD('00/00/00')    // Fecha del Log

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL nCodigoTlo := 0                // C¢digo del Log
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LAS OPCIONES
       IF nNroOpc == 2
	  nCodigoTlo := nCodigoLog(10,25)
	  IF EMPTY(nCodigoTlo)
	     cError('NO SELECCIONO NINGUNA OPCION')
	     LOG->(DBGOTOP())
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DE LAS OPCIONES

*>>>>LECTURA DEL CODIGO DEL ESTUDIANTE
       IF nNroOpc == 4
	  SETCURSOR(1)
	  TitBuscar(6,@nNroFil,@nNroCol)
	  cCodigoTes := SPACE(06)
	  @ nNroFil,nNroCol SAY 'CODIGO:' GET cCodigoTes PICT '999999'
	  READ
	  SETCURSOR(0)

	  DO CASE
	  CASE EMPTY(cCodigoTes)
	       cError('NO DIGITO EL CODIGO')

	  CASE LEN(cCodigoTes) # 6
	       cError('EL CODIGO DEBE SER DE SEIS(6) DIGITOS')
	  OTHERWISE
	       lHayErr := .F.
	  ENDCASE

	  IF lHayErr
	     LOG->(DBGOTOP())
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL CODIGO DEL ESTUDIANTE

*>>>>FILTRACION DEL ARCHIVO
       cHorIni := LOG->cHorIniLog
       cHorFin := LOG->cHorFinLog
       dFecLog := LOG->dFecUsrLog

       SET FILTER TO
       DO CASE
       CASE nNroOpc == 1
	    SET FILTER TO LOG->cHorIniLog >= cHorIni .AND.;
			  LOG->cHorIniLog <= cHorFin .AND.;
			  dFecLog == LOG->dFecUsrLog .AND.;
			  LOG->nCodigoLog # 99

       CASE nNroOpc == 2
	    IF EMPTY(nNroPer)
	       SET FILTER TO LOG->nCodigoLog == nCodigoTlo .AND.;
			     LOG->nCodigoLog # 99
	    ELSE
	       SET FILTER TO LOG->nCodigoLog == nCodigoTlo .AND.;
			     LOG->nNroPerLog == nNroPer    .AND.;
			     LOG->nCodigoLog # 99
	    ENDIF

       CASE nNroOpc == 3
	    IF EMPTY(nNroPer)
	       SET FILTER TO LOG->nCodigoLog # 99
	    ELSE
	       SET FILTER TO LOG->nNroPerLog == nNroPer .AND.;
			     LOG->nCodigoLog # 99
	    ENDIF

       CASE nNroOpc == 4
	    IF EMPTY(nNroPer)
	       SET FILTER TO LOG->cCodigoEst == cCodigoTes
	    ELSE
	       SET FILTER TO LOG->cCodigoEst == cCodigoTes .AND.;
			     LOG->nNroPerLog == nNroPer
	    ENDIF
       ENDCASE
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>BROWSE DEL DEL ARCHIVO
       LOG->(DBGOTOP())
       IF .NOT. LOG->(EOF())
	  oBrowse := oDefBrwLog(lShared,03,00,22,79,nCodigoTlo,'ACTIVIDAD')
	  LOG->(CtrlBrw(lShared,oBrowse))
       ELSE
	  cError('NO APARECE ACTIVIDAD PARA LOS PROCESOS CONTROLADOS')
       ENDIF
*>>>>FIN BROWSE DEL DEL ARCHIVO

*>>>>FILTRACION DEL ARCHIVO
       SET FILTER TO
       IF EMPTY(nNroPer)
	  SET FILTER TO LOG->nCodigoLog == 99
       ELSE
	  SET FILTER TO LOG->nCodigoLog == 99 .AND.;
			LOG->nNroPerLog == nNroPer
       ENDIF
       LOG->(DBGOTOP())
       RETURN NIL
*>>>>FIN FILTRACION DEL ARCHIVO