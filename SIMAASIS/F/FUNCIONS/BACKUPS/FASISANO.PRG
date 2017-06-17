/*                       SIMA - SISTEMA CENTRAL DE RIESGOS
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION DATAaaaa

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 03/2004 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaAsiAno(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cIntUnoAsA','Character',70,0}) // Path de Integraci¢n No. 1
       AADD(aDbfStr,{'cIntDosAsA','Character',70,0}) // Path de Integraci¢n No. 2
       AADD(aDbfStr,{'cIntTreAsA','Character',70,0}) // Path de Integraci¢n No. 3
       AADD(aDbfStr,{'cIntCuaAsA','Character',70,0}) // Path de Integraci¢n No. 4
       AADD(aDbfStr,{'cMaeHabAsA','Character',09,0}) // Maestros Habilitados para el A¤o
       AADD(aDbfStr,{'cJorHabAsA','Character',04,0}) // Jornadas Habilitadas
       AADD(aDbfStr,{'nTipLecAsA','Numeric'  ,02,0}) // Tipo de Lectura del nombre del estudiante. 0=> De £ltimo, 1=> De primero.
       AADD(aDbfStr,{"cCodHraAsA","Character",02,0}) // C¢digo de la Hora
       AADD(aDbfStr,{'cCodTauAsA','Character',02,0}) // C¢digo del Tipo de Ausencia
       AADD(aDbfStr,{'nNroPerAsA','Numeric'  ,04,0}) // Contador del personal
       AADD(aDbfStr,{'lHayCodAsA','Logical'  ,01,0}) // .T. Hay Codigo .F. Generar el c¢digo
       AADD(aDbfStr,{'nCodEstAsA','Numeric'  ,03,0}) // Posici¢n c¢digo del Estudiante
       AADD(aDbfStr,{'nLenCodAsA','Numeric'  ,03,0}) // Longitud c¢digo del Estudiante
       AADD(aDbfStr,{'nTipPnlAsA','Numeric'  ,03,0}) // Posici¢n tipo de personal
       AADD(aDbfStr,{'nLenPnlAsA','Numeric'  ,03,0}) // Longitud tipo de personal
       AADD(aDbfStr,{"cTipEstAsA","Character",02,0}) // C¢digo del tipo del estudiante.
       AADD(aDbfStr,{"cTipProAsA","Character",02,0}) // C¢digo del tipo del profesor
*>>>>FIN DECLARACION DE LA ESTRUCTURA

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
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'ASA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('ASA',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF ASA->(lRegLock(lShared,.T.))
	  REPL ASA->cIntUnoAsA WITH '\Sima\SimaCont'
	  REPL ASA->cIntDosAsA WITH ''
	  REPL ASA->cIntTreAsA WITH ''
	  REPL ASA->cIntCuaAsA WITH ''
	  REPL ASA->nTipLecAsA WITH 0
	  REPL ASA->nCodEstAsA WITH 1
	  REPL ASA->nLenCodAsA WITH 6
	  REPL ASA->nTipPnlAsA WITH 7
	  REPL ASA->nLenPnlAsA WITH 2
	  REPL ASA->cTipEstAsA WITH '01'  // Estudiante
	  REPL ASA->cTipProAsA WITH '02'  // Profesor

	  ASA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
       ENDIF
       IF lShared
	  ASA->(DBUNLOCK())
       ENDIF
       CloseDbf('ASA',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:35 PM   JUN 03/2004 JUE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuAsiAno(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaAsiAno(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:40 PM   JUN 03/2004 JUE

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('ACT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaAsiAno(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
	  cError('El Archivo '+cNomArc+' su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaAsiAno(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: LECTURAS PATHS DE INTEGRACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:45 PM   JUN 03/2004 JUE

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathAsiAno(lShared,cPatSis,cAnoUsr,cIntUno,;
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
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cNalias := ''                  // Nombre del Alias
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(nModCry) != 'N'
	  cError('NO ES NUMERICO EL PARAMETRO EN LOS PATHS DE INTEGRACCION')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>ANALISIS DEL ALIAS
       IF ALIAS(SELECT('ASA')) == 'ASA'
	  cNalias := 'ASA'
       ELSE
	  cNalias := 'ANO'
       ENDIF
*>>>>FIN ANALISIS DEL ALIAS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF cNalias == 'ANO'
	  IF !lUseDbf(.T.,cPatSis+'\'+;
			  FAsiAno+cAnoUsr+ExtFile,cNalias,NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf(cNalias,cPatSis+'\'+FAsiAno+cAnoUsr+ExtFile,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT &cNalias
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(&cNalias->cIntUnoAsA)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(&cNalias->cIntDosAsA)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(&cNalias->cIntTreAsA)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(&cNalias->cIntCuaAsA)+IF(lPatSis,'\'+cPatSis,'')
       IF cNalias == 'ANO'
	  CloseDbf(cNalias,cPatSis+'\'+fAsiAno+cAnoUsr+ExtFile,nModCry)
       ENDIF
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:50 PM   JUN 03/2004 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManAsiAno(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL oBrowse := NIL                 // Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FAsiAno+cAnoUsr+ExtFile,'ASA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CloseDbf('ASA',cPatSis+'\'+FAsiAno+cAnoUsr+ExtFile,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwAsiAno(lShared,cAnoUsr,nFilPal+1,00,22,79)
       ASA->(CtrlBrw(lShared,oBrowse))
       CloseDbf('ASA',cPatSis+'\'+FAsiAno+cAnoUsr+ExtFile,nModCry)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2004 JUE A
       Colombia, Bucaramanga        INICIO: 01:55 PM   JUN 03/2004 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwAsiAno(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,lModReg)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lModReg                              // .T. Modificar el Registro */
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

       lModReg := IF(EMPTY(lModReg),.F.,lModReg)

       SELECT ASA
       oColumn	:= TBCOLUMNNEW('PATH DE SIMACONT',;
				    {||ASA->cIntUnoAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','cIntUnoAsA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('MAESTROS;HABILITADOS',{||ASA->cMaeHabAsA})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ASA'},;
			 {'FIELD','cMaeAluAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('JORNADAS;HABILITADAS',{||ASA->cJorHabAsA})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','ASA'},;
			 {'FIELD','cJorHabAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE LECTURA;NOMBRE DEL ESTUDIANTE',;
				   {||ASA->nTipLecAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},{'FIELD','nTipLecAsA'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('HORA AUSENCIA;TOTAL',{||ASA->cCodHraAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','cCodHraAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO AUSENCIA;TOTAL',{||ASA->cCodTauAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','cCodTauAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NRO PERSONAL', {||ASA->nNroPerAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','nNroPerAsA'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HAY CODIGOS;CREADOS',;
				   {||ASA->lHayCodAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','lHayCodAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO TIPO;ESTUDIANTE',{||ASA->cTipEstAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','cTipEstAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('CODIGO TIPO;PROFESOR',{||ASA->cTipProAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},;
			 {'FIELD','cTipProAsA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POSICION;CODIGO ESTUDIANTE',;
				   {||ASA->nCodEstAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},{'FIELD','nCodEstAsA'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;CODIGO ESTUDIANTE',;
				    {||ASA->nLenCodAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},{'FIELD','nLenCodAsA'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POSICION;TIPO PERSONAL',;
				   {||ASA->nTipPnlAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},{'FIELD','nTipPnlAsA'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;TIPO PERSONAL',;
				    {||ASA->nLenPnlAsA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ASA'},{'FIELD','nLenPnlAsA'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE