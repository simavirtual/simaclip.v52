/*                       SIMA - CONTABILIDAD ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION DEL A¥O

REQUERIMIENTOS:

- Compilar: clipper FContAno /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 05/96 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaConAno(lShared,PathAno,FileAno,lIntUno,fNtxAno,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathAno				    // Path del Archivo
       FileAno				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxAno				    // Archivo de Indices
       aStrDbf                              // Structura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfAno := {{"cIntUnoCoA","Character",070,0},; // Path de Integraci¢n No. 1
			 {"cIntDosCoA","Character",070,0},; // Path de Integraci¢n No. 2
			 {"cIntTreCoA","Character",070,0},; // Path de Integraci¢n No. 3
			 {"cIntCuaCoA","Character",070,0},; // Path de Integraci¢n No. 4
			 {"cMaeHabCoA","Character",009,0},; //* Maestros Habilitados para el A¤o
			 {"cJorHabCoA","Character",004,0},; //* Jornadas Habilitadas
			 {"nNroAluCoA","Numeric"  ,004,0},; // Contador de Alumnos Nuevos
			 {"nNroProCoA","Numeric"  ,004,0},; // Contador de Profesores
			 {"nNroPazCoA","Numeric"  ,002,0},; // Numero del Paz y Salvo
			 {"cTitulECoA","Character",022,0},; // T¡tulo para Excelente
			 {"cDescrECoA","Character",300,0},; // Descripci¢n para Excelente
			 {"cTitulSCoA","Character",022,0},; // T¡tulo para SobreSaliente
			 {"cDescrSCoA","Character",300,0},; // Descripci¢n para SobreSaliente
			 {"cTitulACoA","Character",022,0},; // T¡tulo para Aceptable
			 {"cDescrACoA","Character",300,0},; // Descripci¢n para Aceptable
			 {"cTitulICoA","Character",022,0},; // T¡tulo para Insuficiente.
			 {"cDescrICoA","Character",300,0},; // Descripci¢n para Insuficiente
			 {"cTitulDCoA","Character",022,0},; // T¡tulo para Deficiente
			 {"cDescrDCoA","Character",300,0},; // Descripci¢n para Deficiente
			 {"cHorClaCoA","Character",070,0},; // Hora de Clase del Sistema
			 {"cTitPazCoA","Character",130,0},; // Pie de P gina para el Paz y Salvo
			 {"cGenJorCoA","Character",030,0},; // Genero de la Jornada
			 {"cLeyPlaCoA","Character",200,0},; // Ley del plan de Estudios
			 {"cTxtNpRCoA","Character",300,0},; // Observacion general para el que no se presenta a la Recuperaci¢n
			 {'cDerechCoA','Character',110,0}}  // Activaci¢n de Derechos Individuales
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfAno
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathAno) == 0
	    DBCREATE(FileAno,aDbfAno,"DBFNTX")

       CASE DIRCHANGE(PathAno) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathAno)

       CASE DIRCHANGE(PathAno) == -5
	    cError('NO TIENE DERECHOS EN: '+PathAno)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathAno+'\'+FileAno,'COA',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF COA->(lRegLock(lShared,.T.))
	  REPL COA->cIntUnoCoA WITH '\Sima\SimaProf'
	  REPL COA->cIntDosCoA WITH '\Sima\SimaMatr'
	  REPL COA->cIntTreCoA WITH '\Sima\SimaCart'
	  REPL COA->cIntCuaCoA WITH ''
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
       ENDIF
       COA->(DBCOMMIT())
       IF lShared
	  COA->(DBUNLOCK())
       ENDIF
       CloseDbf('COA')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:15 AM   SEP 05/96 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuConAno(lShared,PathAno,FileAno,lIntUno,fNtxAno)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathAno			      // Path del Archivo
       FileAno			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxAno			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathAno+'\'+FileAno,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DEL A¥O")
       Termometro(100)

       CreaConAno(lShared,PathAno,FileAno,lIntUno,fNtxAno)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 01/2000 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUN 01/2000 JUE

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

FUNCTION nActStrCoA(lShared,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'COA',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL')
	  CloseDbf('COA')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := COA->(DBSTRUCT())
       CloseDbf('COA')
       CreaConAno(lShared,PathArc,cNomArc,,,@aStrNew)
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
			 {||CreaConAno(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURAS PATHS DE INTEGRACION                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:15 AM   SEP 05/96 JUE

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathConAno(lShared,cAnoUsr,cPatSis,cIntUno,;
		    cIntDos,cIntTre,cIntCua,lPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cIntUno                              // @Path de Integraci¢n uno
       cIntDos                              // @Path de Integraci¢n dos
       cIntTre                              // @Path de Integraci¢n tres
       cIntCua                              // @Path de Integraci¢n cuatro
       lPatSis                              // .T. Incluir Path del sistema*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DIRECTORIO DEL A¥O
       PathAct := cPathAct()

       Mdir(cPatSis,PathAct)
     *ÀDirectorio del A¤o.
*>>>>FIN DIRECTORIO DEL A¥O

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatSis+'\'+fConAno+cAnoUsr+ExtFile)
	  CreaConAno(lShared,cPatSis,fConAno+cAnoUsr+ExtFile)
       ELSE
	  nActStrCoA(lShared,cPatSis,fConAno+cAnoUsr+ExtFile)
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CLOSE ALL
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS DE LA INTEGRACION
       IF !EMPTY(COA->cIntUnoCoA) .AND. !'SIMAPROF' $ UPPER(COA->cIntUnoCoA)
	  cError('EL PATH DE INTEGRACION UNO '+;
		 'NO ES DE SIMAPROF')
	  CloseDbf('COA')
	  RETURN .F.
       ENDIF

       IF !EMPTY(COA->cIntDosCoA) .AND.!'SIMAMATR' $ UPPER(COA->cIntDosCoA)
	  cError('EL PATH DE INTEGRACION DOS '+;
		 'NO ES DE SIMAMATR')
	  CloseDbf('COA')
	  RETURN .F.
       ENDIF

       IF !EMPTY(COA->cIntTreCoA) .AND. !'SIMACART' $ UPPER(COA->cIntTreCoA)
	  cError('EL PATH DE INTEGRACION DOS '+;
		 'NO ES DE SIMACART')
	  CloseDbf('COA')
	  RETURN .F.
       ENDIF
*>>>>FIN ANALISIS DE LA INTEGRACION

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT COA
       GO TOP
       lPatSis := IF(lPatSis == NIL,.T.,lPatSis)
       cIntUno := ALLTRIM(COA->cIntUnoCoA)+IF(lPatSis,'\'+cPatSis,'')
       cIntDos := ALLTRIM(COA->cIntDosCoA)+IF(lPatSis,'\'+cPatSis,'')
       cIntTre := ALLTRIM(COA->cIntTreCoA)+IF(lPatSis,'\'+cPatSis,'')
       cIntCua := ALLTRIM(COA->cIntCuaCoA)+IF(lPatSis,'\'+cPatSis,'')
       CloseDbf('COA')
       RETURN .T.
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUL 19/96 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManConAno(aP1,aP2,aP3,bMenSys)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       bMenSys                              // Menus del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL oBrowse := NIL                 // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
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

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aP1,aP2,aP3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwConAno(lShared,cAnoUsr,nFilPal+1,00,22,79)

       SETKEY(K_F5,{||DerechCoA(lShared,bMenSys,cNomSis)})
       COA->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)

       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/96 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   SEP 05/96 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwConAno(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

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
       oBrowse:Cargo     := {'<< CONFIGURACION DE LA CONTABILIDAD PARA '+;
			     cAnoUsr+' >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT COA
       oColumn	:= TBCOLUMNNEW('PATH DE SIMAPROF',{||COA->cIntUnoCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cIntUnoCoA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMAMATR',{||COA->cIntDosCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cIntDosCoA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('PATH DE SIMACART',{||COA->cIntTreCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cIntTreCoA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn	:= TBCOLUMNNEW('PATH DE INTEGRACION 4',;
				    {||COA->cIntCuaCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cIntCuaCoA'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn	:= TBCOLUMNNEW('MAESTROS;HABILITADOS',{||COA->cMaeHabCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cMaeHabCoA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('JORNADAS;HABILITADAS',{||COA->cJorHabCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cJorHabCoA'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NRO PROFESORES', {||COA->nNroProCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','nNroProCoA'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;PAZ Y SALVO', {||COA->nNroPazCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','nNroPazCoA'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PIE DE PAGINA;PAZ Y SALVO',;
				    {||COA->cTitPazCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTitPazCoA'},{'PICTURE','@S70'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE CLASE PARA CERTIFICADO',;
				    {||COA->cHorClaCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cHorClaCoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA EXCELENTE',;
				    {||COA->cTitulECoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTitulECoA'},{'PICTURE','@S22'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION PARA EXCELENTE',;
				    {||COA->cDescrECoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cDescrECoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA SOBRESALIENTE',;
				    {||COA->cTitulSCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTitulSCoA'},{'PICTURE','@S22'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION PARA SOBRESALIENTE',;
				    {||COA->cDescrSCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cDescrSCoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA ACEPTABLE',;
				    {||COA->cTitulACoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTitulACoA'},{'PICTURE','@S22'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION PARA ACEPTABLE',;
				    {||COA->cDescrACoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cDescrACoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA INSUFICIENTE',;
				    {||COA->cTitulICoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTitulICoA'},{'PICTURE','@S22'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION PARA INSUFICIENTE',;
				    {||COA->cDescrICoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cDescrICoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO PARA DEFICIENTE',;
				    {||COA->cTitulDCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTitulDCoA'},{'PICTURE','@S22'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION PARA DEFICIENTE',;
				    {||COA->cDescrDCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cDescrDCoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NO SE PRESENTO A RECUPERACIONES',;
				    {||COA->cTxtNpRCoA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','COA'},;
			 {'FIELD','cTxtNpRCoA'},{'PICTURE','@S70!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: DERECHOS DEL SISTEMA                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/2008 LUN A
       Colombia, Bucaramanga        INICIO: 09:00 PM   FEB 11/2008 LUN

1- Permite asignar y grabar los derechos a los men£s del sistema

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DerechCoA(lShared,bMenSys,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       bMenSys				    // Menu del Sistema
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cDerech := ''                  // Derechos del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DERECHOS DEL SISTEMA
       cDerech := COA->cDerechCoA
       cDerech := cOpcOnOf(lShared,bMenSys,cDerech,cNomSis)

       IF COA->(lRegLock(lShared,.F.))
	  REPL COA->cDerechCoA WITH cDerech
	  COA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABAN LOS DERECHOS')
       ENDIF
       IF lShared
	  COA->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN DERECHOS DEL SISTEMA
