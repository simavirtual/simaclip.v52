/*                       SIMA - SISTEMA DE CAFETERIA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION DEL A¥O

REQUERIMIENTOS:

- Compilar: clipper FCafeAno /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:00 PM   MAY 20/2002 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaCaFAno(lShared,nModCry,PathCfA,FileCfA,fNtxCfA,lGrabar,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCfA				    // Path del Archivo
       FileCfA				    // Nombre del Archivo
       fNtxCfA				    // Archivo de Indices
       lGrabar                              // Grabar parametros
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfCfA := {{"cIntUnoCfA","Character",70,0},; // Path de Integraci¢n No. 1
			 {"cIntDosCfA","Character",70,0},; // Path de Integraci¢n No. 2
			 {"cIntTreCfA","Character",70,0},; // Path de Integraci¢n No. 3
			 {"cIntCuaCfA","Character",70,0},; // Path de Integraci¢n No. 4
			 {"cMaeHabCfA","Character",09,0},; // Maestros Habilitados para el A¤o
			 {"cJorHabCfA","Character",04,0},; // Jornadas Habilitadas
			 {"lHayNovCfA","Logical"  ,01,0},; // .T. Novedades en la Cafeteria
			 {"nSerEstCfA","Numeric"  ,01,0},; // N£mero de Ingresos para Estudiantes
			 {"nSerProCfA","Numeric"  ,01,0},; // N£mero de Ingresos para Profesores
			 {"nSerPerCfA","Numeric"  ,01,0},; // N£mero de Ingresos para Personal
			 {"cAutIngCfA","Character",09,0},; // Autorizaci¢n de Ingresos
			 {"cMesSerCfA","Character",12,0},; // Meses de Servicio de la Cafeteria
			 {"cCodPazCfA","Character",40,0}}  // C¢digo de Item de Paz y Salvo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCfA
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCfA) == 0
	    DBCREATE(FileCfA,aDbfCfA,"DBFNTX")
	    Proteger(FileCfA,nModCry)

       CASE DIRCHANGE(PathCfA) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCfA)

       CASE DIRCHANGE(PathCfA) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCfA)
       ENDCASE

       DIRCHANGE(PathAct)
       lGrabar := IF(lGrabar == NIL,.T.,lGrabar)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF lGrabar
	  IF !lUseDbf(.T.,PathCfA+'\'+FileCfA,'CfA',NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf('CfA',PathCfA+'\'+FileCfA,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF lGrabar
	  IF CfA->(lRegLock(lShared,.T.))
	     REPL CfA->cIntUnoCfA WITH '\Sima\SimaCont'
	     REPL CfA->cIntDosCfA WITH '\Sima\SimaCart'
	     REPL CfA->cIntTreCfA WITH ''
	     REPL CfA->cIntCuaCfA WITH ''
	     REPL CfA->lHayNovCfA WITH .T.
	     REPL CfA->nSerEstCfA WITH 1   // Ingresos a la Cafeteria Estudiantes
	     REPL CfA->nSerProCfA WITH 1   // Ingresos a la Cafeteria Profesores
	     REPL CfA->nSerPerCfA WITH 1   // Ingresos a la Cafereria Personal
	     CfA->(DBCOMMIT())
	     IF lShared
		CfA->(DBUNLOCK())
	     ENDIF
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF
       ENDIF
       CloseDbf('CfA',PathCfA+'\'+FileCfA,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:05 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuCaFAno(lShared,nModCry,PathCfA,FileCfA,fNtxCfA)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathCfA			      // Path del Archivo
       FileCfA			      // Nombre del Archivo
       fNtxCfA			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCfA+'\'+FileCfA,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DEL A¥O")
       Termometro(100)

       CreaCaFAno(lShared,nModCry,PathCfA,FileCfA,fNtxCfA)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:05 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrAno(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ANO',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL')
	  CloseDbf('ANO',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ANO->(DBSTRUCT())
       CloseDbf('ANO',PathArc+'\'+cNomArc,nModCry)
       CreaCaFAno(lShared,nModCry,PathArc,cNomArc,,.F.,@aStrNew)
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
	  cError('El Archivo CONFIG DEL A¥O su Estructura Esta DesActualizada.',;
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
			 {||CreaCaFAno(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: LECTURAS PATHS DE INTEGRACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:10 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathCaFAno(lShared,cPatSis,cAnoUsr,cIntUno,;
		    cIntDos,cIntTre,cIntCua,nModCry,lPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       cAnoUsr                              // A¤o del Usuario
       cIntUno                              // @Path de Integraci¢n uno
       cIntDos                              // @Path de Integraci¢n dos
       cIntTre                              // @Path de Integraci¢n tres
       cIntCua                              // @Path de Integraci¢n cuatro
       nModCry                              // Modo de Protecci¢n
       lPatSis                              // .T. Incluir Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cNalias := ''                  // Alias
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(nModCry) != 'N'
	  cError('NO ES NUMERICO EL PARAMETRO EN LOS PATHS DE INTEGRACCION')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>ANALISIS DEL ALIAS
       IF ALIAS(SELECT('CfA')) == 'CfA'
	  cNalias := 'CfA'
       ELSE
	  cNalias := 'ANO'
       ENDIF
*>>>>FIN ANALISIS DEL ALIAS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF cNalias == 'ANO'
	  IF !lUseDbf(.T.,cPatSis+'\'+;
			  FCaFAno+cAnoUsr+ExtFile,cNalias,NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf(cNalias,cPatSis+'\'+FCaFAno+cAnoUsr+ExtFile,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT &cNalias
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(&cNalias->cIntUnoCfA)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(&cNalias->cIntDosCfA)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(&cNalias->cIntTreCfA)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(&cNalias->cIntCuaCfA)+IF(lPatSis,'\'+cPatSis,'')
       IF cNalias == 'ANO'
	  CloseDbf(cNalias,cPatSis+'\'+FCaFAno+cAnoUsr+ExtFile,nModCry)
       ENDIF
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:15 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManCaFAno(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL oBrowse := NIL                 // Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FCaFAno+cAnoUsr+ExtFile,'CfA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('CfA',cPatSis+'\'+FCaFAno+cAnoUsr+ExtFile,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwCaFAno(lShared,cAnoUsr,nFilPal+1,00,22,79)
       CfA->(CtrlBrw(lShared,oBrowse))
       CloseDbf('CfA',cPatSis+'\'+FCaFAno+cAnoUsr+ExtFile,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:20 PM   MAY 20/2002 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwCaFAno(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL	            // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<< CONFIGURACION DEL A¥O: '+cAnoUsr+' >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CfA
       oColumn	:= TBCOLUMNNEW('PATH DE;SIMACONT',;
				    {||CfA->cIntUnoCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cIntUnoCfA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE;SIMACART',;
				    {||CfA->cIntDosCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cIntDosCfA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE;INTEGRACION 3',;
				    {||CfA->cIntTreCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cIntTreCfA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE;INTEGRACION 4',;
				    {||CfA->cIntCuaCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cIntCuaCfA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MAESTROS;HABILITADOS',{||CfA->cMaeHabCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cMaeHabCfA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('JORNADAS;HABILITADAS',{||CfA->cJorHabCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cJorHabCfA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PERMITIR NOVEDEDES;DE CAFETERIA',;
			       {||CfA->lHayNovCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','lHayNovCfA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('INGRESOS DIARIOS;ESTUDIANTES',;
			       {||CfA->nSerEstCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','nSerEstCfA'}, {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('INGRESOS DIARIOS;PROFESORES',;
			       {||CfA->nSerProCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','nSerProCfA'}, {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('INGRESOS DIARIOS;PERSONAL',;
			       {||CfA->nSerPerCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','nSerPerCfA'}, {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('AUTORIZACION DE;INGRESOS',;
			       {||CfA->cAutIngCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cAutIngCfA'}, {'PICTURE','999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('SERVICIOS MENSUALES;DE CAFETERIA',;
			       {||CfA->cMesSerCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cMesSerCfA'}, {'PICTURE','999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('ITEM;PAZ Y SALVO',{||CfA->cCodPazCfA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CfA'},;
			 {'FIELD','cCodPazCfA'},{'PICTURE','@S76X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE