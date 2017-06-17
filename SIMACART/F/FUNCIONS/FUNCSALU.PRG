/*               	 SISTEMA CARTERA ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA LOS ARCHIVOS MAESTROS DE ALUMNOS

REQUERIMIENTOS:

- Compilar: clipper FuncsAlu /w/m/b

OBJETIVOS:

- Funciones aplicadas para los archivos maestros de alumnos de la
  de la contabilidad acad‚mica

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION SELECION DEL ALIAS POR EL GRUPO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 03/96 SAB A
       Colombia, Bucaramanga        INICIO: 02:50 PM   FEB 03/96 SAB

OBJETIVOS:

1- Seleciona el Alias de acuerdo al nivel

2- Retorna retorna el alias del nivel

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cAliasNiv(nNroNiv,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroNiv				    // N£mero del nivel
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                  // Nombre del Alias
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DEL MAESTRO DE ACUERDO A LA DIVISION
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)
       DO CASE
       CASE nNroNiv >= 0 .AND. nNroNiv <= 5
	    cNalias := IF(lAnoAct,'PRI','PRA')

       CASE nNroNiv >= 6 .AND. nNroNiv <= 11
	    cNalias := IF(lAnoAct,'BTO','BTA')

       CASE nNroNiv >= 12  .AND. nNroNiv <= 16
	    cNalias := IF(lAnoAct,'JAR','JAA')

       OTHERWISE
	    cError('MAL PASADO EL NIVEL')
	    cNalias := 'ERROR'
       ENDCASE
       RETURN cNalias
*>>>>FIN SELECION DEL MAESTRO DE ACUERDO A LA DIVISION

/*************************************************************************
* TITULO DEL PROGRAMA..: ENCONTRAR EL NOMBRE DEL ALUMNO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 27/94 LUN A
						       JUN 27/94 LUN
OBJETIVOS:

1- Deben estar en uso los maestros habilitados

2- Permite encontrar el nombre del estudiante dentro de los archivos
   de Bachillerato,Primari,Jardin

3- Si el nombre del estudiante se incluye en un browse de debe pasar
   el Alias del Archivo del Browse

4- Retorna el nombre del Estudiante

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSekNomAlu(cCodEst,cMaeAlu,cAlias,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst                                // C¢digo del Estudiante
       cMaeAlu				      // Maestros habilitados
       cAlias                                 // Alias diferente al maestro
       lAnoAct                                // A¤o Actual*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNalias := ''                    // Alias del maestro

       LOCAL cNombreTes := ''                 // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
       lAnoAct := IF(lAnoAct == NIL,.T.,lAnoAct)
       IF lSekCodMae(cCodEst,cMaeAlu,@cNalias,.F.)
	  cNombreTes := &cNalias->cCodigoGru+' '+;
			RTRIM(&cNalias->cApelliEst)+' '+;
			RTRIM(&cNalias->cNombreEst)
	  IF &cNalias->lRetiroEst
	     cNombreTes := 'RETIRADO '+cNombreTes
	  ENDIF

       ELSE
	  cNombreTes := 'ALUMNO NO EXISTE'
       ENDIF
       IF cAlias # NIL
	  SELECT &cAlias
       ENDIF
       RETURN cNombreTes
*>>>>FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE ALUMNOS		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Permite el mantenimiento del archivo Alumnos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenAlu(aParam1,aParam2,aParam3)

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
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL oBrwAlu := NIL                 // Browse de Alumnos
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT &cMaeAct

       oBrwAlu := oDefBrwAlu(lShared,00,00,22,79,cMaeAct,;
		 '<<  MANTENIMIENTO DE ALUMNOS DE '+cMaeAct+;
		 ' .TOTAL ='+STR(RECCOUNT(),4)+'  >>',;
		 '<F2> Informaci¢n Personal '+;
		 '<F5>Buscar  <ESC>Abandonar')

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cMaeAct,cNomEmp,cNomSis)})

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrwAlu,cMaeAct,cAnoSis,cIntUno)})

       DO CASE
       CASE cMaeAct == 'JAR'
	    JAR->(CtrlBrw(lShared,oBrwAlu))
       CASE cMaeAct == 'PRI'
	    PRI->(CtrlBrw(lShared,oBrwAlu))
       CASE cMaeAct == 'BTO'
	    BTO->(CtrlBrw(lShared,oBrwAlu))
       ENDCASE
       SETKEY(K_F2,NIL)
       SETKEY(K_F5,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE ALUMNOS		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Define el objeto Browse del archivo Alumnos

SINTAXIS:

 oBrwAlu := oDefBrwAlu(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwAlu(lShared,nFilSup,nColSup,nFilInf,;
		    nColInf,cNalias,cTitUno,cTitDos)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNomGra			            // Nombre Del Grado
       cNalias                              // Alias del maestro
       cTitUno                              // Titulo Uno de la pantalla
       cTitDos                              // Titulo Dos de la pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwAlu := NIL		    // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       cTitUno := IF(cTitUno == NIL,'CONSULTA DE ALUMNOS',cTitUno)
       cTitDos := IF(cTitDos == NIL,'<ESC> Abandonar',cTitDos)

       oBrwAlu := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwAlu:ColSep    := '³'
       oBrwAlu:HeadSep   := 'Ä'
       oBrwAlu:Cargo     := {cTitUno,cTitDos}

     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT &cNalias
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CODIGO', {||JAR->cCodigoEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CODIGO', {||PRI->cCodigoEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CODIGO', {||BTO->cCodigoEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CURSO', {||JAR->cCodigoGru})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CURSO', {||PRI->cCodigoGru})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CURSO', {||BTO->cCodigoGru})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||JAR->cApelliEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||PRI->cApelliEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('APELLIDOS',;
		       {||BTO->cApelliEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cNombreEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
       oBrwAlu:Freeze:= 3
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('NOMBRES',;
		       {||JAR->cNombreEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('NOMBRE',;
		       {||PRI->cNombreEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('NOMBRES',;
		       {||BTO->cNombreEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cNombreEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(JAR->lRetiroEst,;
						       'RETIRADO',;
						       SPACE(08))})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(PRI->lRetiroEst,;
						       'RETIRADO',;
						       SPACE(08))})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTADO',{||IF(BTO->lRetiroEst,;
						       'RETIRADO',;
							SPACE(08))})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('F.RETIRO',{||cFecha(JAR->dFecRetEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('F.RETIRO',{||cFecha(PRI->dFecRetEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('F.RETIRO',{||cFecha(BTO->dFecRetEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','dFecRetEst'}, {'PICTURE','@D'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(JAR->dFecNacEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(PRI->dFecNacEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('F.NACIM',{||cFecha(BTO->dFecNacEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','dFecNacEst'}, {'PICTURE','@D'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('LUGAR', {||JAR->cLugNacEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('LUGAR', {||PRI->cLugNacEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('LUGAR', {||BTO->cLugNacEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cLugNacEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||JAR->cDocNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||PRI->cDocNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DOCUMENTO',{||BTO->cDocNitEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DE',{||JAR->cLugNitEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DE',{||PRI->cLugNitEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DE',{||BTO->cLugNitEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cLugNitEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('DIRECCION',{||JAR->cDireccEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('DIRECCION',{||PRI->cDireccEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('DIRECCION',{||BTO->cDireccEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cDireccEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cDireccEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelefnEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelefnEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelefnEst})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cTelefnEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('BARRIO',{||JAR->cBarrioEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('BARRIO',{||PRI->cBarrioEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('BARRIO',{||BTO->cBarrioEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cBarrioEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cBarrioEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PADRE',{||JAR->cNomPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PADRE',{||PRI->cNomPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PADRE',{||BTO->cNomPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cNomPadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cNomPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PROFESION',{||JAR->cProPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PROFESION',{||PRI->cProPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PROFESION',{||BTO->cProPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cProPadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cProPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||JAR->cEmpPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||PRI->cEmpPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||BTO->cEmpPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cEmpPadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cEmpPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CARGO',{||JAR->cCarPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CARGO',{||PRI->cCarPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CARGO',{||BTO->cCarPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cCarPadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cCarPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelPadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelPadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelPadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTelPadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cTelPadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('MADRE',{||JAR->cNomMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('MADRE',{||PRI->cNomMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('MADRE',{||BTO->cNomMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cNomMadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cNomMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('PROFESION',{||JAR->cProMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('PROFESION',{||PRI->cProMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('PROFESION',{||BTO->cProMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cProMadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cProMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||JAR->cEmpMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||PRI->cEmpMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('EMPRESA',{||BTO->cEmpMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cEmpMadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cEmpMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CARGO',{||JAR->cCarMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CARGO',{||PRI->cCarMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CARGO',{||BTO->cCarMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cCarMadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cCarMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||JAR->cTelMadEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||PRI->cTelMadEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO',{||BTO->cTelMadEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTelMadEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cTelMadEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ACUDIENTE',{||JAR->cNomAcuEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ACUDIENTE',{||PRI->cNomAcuEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ACUDIENTE',{||BTO->cNomAcuEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cNomAcuEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cNomAcuEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO1',{||JAR->cTe1AcuEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO1',{||PRI->cTe1AcuEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO1',{||BTO->cTe1AcuEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cTe1AcuEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('TELEFONO2',{||JAR->cTe2AcuEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('TELEFONO2',{||PRI->cTe2AcuEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('TELEFONO2',{||BTO->cTe2AcuEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cTe2AcuEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||JAR->cEstratEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||PRI->cEstratEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('ESTRATO',{||BTO->cEstratEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','cEstratEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('REPITE',{||JAR->lRepiteEst})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('REPITE',{||PRI->lRepiteEst})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('REPITE',{||BTO->lRepiteEst})
       ENDCASE
       oColumn:Width := LEN(cSpaces(cNalias,'cTe1AcuEst'))
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','lRepiteEst'}, {'PICTURE','@!'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('CUPO',{||IF(JAR->lRetiroEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('CUPO',{||IF(PRI->lRetiroEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('CUPO',{||IF(BTO->lRetiroEst,;
						'SI',;
						'NO')})
       ENDCASE
       oColumn:Width := 4
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(JAR->lSiMatrEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(PRI->lSiMatrEst,;
						'SI',;
						'NO')})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(BTO->lSiMatrEst,;
						'SI',;
						'NO')})
       ENDCASE
       oColumn:Width := 11
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('F.MATRI',{||cFecha(JAR->dFecMatEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('F.MATRI',{||cFecha(PRI->dFecMatEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('F.MATRI',{||cFecha(BTO->dFecMatEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS',cNalias},;
			 {'FIELD','dFecMatEst'}, {'PICTURE','@D'}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE cNalias == 'JAR'
	    oColumn := TBCOLUMNNEW('H.MATRI',{||cHoraSys(JAR->cHorMatEst)})
       CASE cNalias == 'PRI'
	    oColumn := TBCOLUMNNEW('H.MATRI',{||cHoraSys(PRI->cHorMatEst)})
       CASE cNalias == 'BTO'
	    oColumn := TBCOLUMNNEW('H.MATRI',{||cHoraSys(BTO->cHorMatEst)})
       ENDCASE
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwAlu:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwAlu
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DEL PROGRAMA..: GRABACION DE LOS DATOS DEL ESTUDIANTE           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 05:20 PM   DIC 02/96 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de Estudiantes del respectivo Nivel

2- El archivo debe estar ubicado en el registro del estudiante y debe estar
   bloqueado

3- Graba los datos Generales del Estudiante

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDatosEst(lShared,nFilInf,nColInf,cCodEst,cMaeAlu,cMaeAct,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cCodEst                              // C¢digo del Estudiante
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Habilitado
       cNalias                              // Alias del que Invoca */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL cSexFem := ''                  // Sexo del Estudiante

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cLugNacTes := ''               // Lugar de nacimiento
       LOCAL dFecNacTes := ''               // Fecha de nacimiento
       LOCAL cDocNitTes := ''		    // Documento de identidad
       LOCAL cLugNitTes := ''		    // Lugar de expedici¢n
       LOCAL cTipNitTes := ''               //*Tipo del Documento
       LOCAL lSexFemTes := .F.              //*Sexo del Estudiante
       LOCAL nEstratTes := 0                // Estracto del Estudiante
       LOCAL cDireccTes := ''		    // Direcci¢n del candidato
       LOCAL cBarrioTes := ''		    // Barrio
       LOCAL cCiudadTes := ''               //*Ciudad del Estudiante
       LOCAL cTelefnTes := ''		    // Telefono de la residencia
       LOCAL cMaiEstTes := ''               // E-MAIL del Estudiante o Casa

       LOCAL cApePadTes := ''               //*Apellido del padre
       LOCAL cNomPadTes := ''		    // Nombre del padre
       LOCAL lPadQepTes := .F.              // Fallecido
       LOCAL cPadQepTes := ''               // Fallecido
       LOCAL cPadNitTes := ''               // C‚dula del padre
       LOCAL cPadLugTes := ''               // Lugar de la c‚dula
       LOCAL cPadTntTes := ''               //*Tipo del Documento
       LOCAL cDirPadTes := ''               //*Direcci¢n del Padre
       LOCAL cBarPadTes := ''               //*Barrio del Padre
       LOCAL cCiuPadTes := ''               //*Ciudad del Padre
       LOCAL cProPadTes := ''		    // Profesi¢n del padre
       LOCAL cEmpPadTes := ''		    // Empresa del padre
       LOCAL cCarPadTes := ''		    // Cargo del padre
       LOCAL cTelPadTes := ''               // Telefono del padre
       LOCAL cMaiPadTes := ''               // E-MAIL del Padre

       LOCAL cApeMadTes := ''               //*Apellido de la madre
       LOCAL cNomMadTes := ''		    // Nombre de la madre
       LOCAL lMadQepTes := .F.              // Fallecida
       LOCAL cMadQepTes := ''               // Fallecida
       LOCAL cMadNitTes := ''               // C‚dula de la madre
       LOCAL cMadLugTes := ''               // Lugar de la c‚dula
       LOCAL cMadTntTes := ''               //*Tipo del Documento
       LOCAL cDirMadTes := ''               //*Direcci¢n de la Madre
       LOCAL cBarMadTes := ''               //*Barrio de la Madre
       LOCAL cCiuMadTes := ''               //*Ciudad de la Madre
       LOCAL cProMadTes := ''		    // Profesi¢n de la madre
       LOCAL cEmpMadTes := ''		    // Empresa de la madre
       LOCAL cCarMadTes := ''		    // Cargo de la madre
       LOCAL cTelMadTes := ''		    // Telefono de la madre
       LOCAL cMaiMadTes := ''               // E-MAIL de la Madre
       LOCAL cApeAcuTes := ''               //*Apellido del Acudiente
       LOCAL cNomAcuTes := ''		    // Nombre del acudiente
       LOCAL cAcuNitTes := ''               // C‚dula del acudiante
       LOCAL cAcuLugTes := ''               // Lugar de la c‚dula
       LOCAL cAcuTntTes := ''               //*Tipo del Documento
       LOCAL cDirAcuTes := ''               //*Direcci¢n del Acudiente
       LOCAL cBarAcuTes := ''               //*Barrio del Acudiente
       LOCAL cCiuAcuTes := ''               //*Ciudad del Acudiente
       LOCAL cTe1AcuTes := ''		    // Telefono casa acudiente
       LOCAL cTe2AcuTes := ''		    // Telefono oficina acudiente
       LOCAL cMaiAcuTes := ''               // E-MAIL del Acudiente
       LOCAL cParAcuTes := ''               //*Parentesco del Acudiente

       LOCAL GetList    := {}               // Variable del sistema
       FIELD cCodigoGru
*>>>>FIN DECLARACION DE VARIABLES

*>>>>MENU DE ACTUALIZACION
       nTipCur := SETCURSOR(1)
       cSavPan := SAVESCREEN(0,0,24,79)

       AADD(aMenus,'1<INFORMACION PERSONAL >')
       AADD(aMenus,'2<INFORMACION PADRES   >')
       AADD(aMenus,'3<INFORMACION ACUDIENTE>')
       AADD(aAyuda,'Actualiza la Informaci¢n Personal')
       AADD(aAyuda,'Actualiza la Informaci¢n de los Padres')
       AADD(aAyuda,'Actualiza la Informaci¢n del Acudiente')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'ACTUALIZAR',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  IF !EMPTY(cNalias)
	     SELECT &cNalias
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN MENU DE ACTUALIZACION

*>>>>BUSQUEDA DEL CODIGO
       IF EMPTY(cMaeAct)
	  IF lSekCodMae(cCodEst,cMaeAlu,@cMaeAct)
	     cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				 &cMaeAct->cNombreEst
	  ELSE
	     cNombreTes := 'EL CODIGO: '+cCodEst+' NO EXISTE'
	  ENDIF
       ENDIF
*>>>>FIN BUSQUEDA DEL CODIGO

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,;
		  IF(nNroOpc==1,;
		     'POR FAVOR ACTUALICE LA INFORMACION DEL ESTUDIANTE',;
		     'CODIGO: '+&cMaeAct->cCodigoEst+' '+cNombreTes+' '+;
		     'CURSO : '+&cMaeAct->cCodigoGru),22,'°')

       nNroCol := nColInf
       IF nNroOpc == 1
	  @ nNroFil,nNroCol+00 SAY 'CODIGO: '+&cMaeAct->cCodigoEst
	  @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(&cMaeAct->cApelliEst)+' '+;
						    &cMaeAct->cNombreEst
	  @ nNroFil,nNroCol+65 SAY 'CURSO : '+&cMaeAct->cCodigoGru
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT &cMaeAct
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TANOORALES
	    IF lGrabar
	       DO CASE
	       CASE nNroOpc == 1  // INFORMACION PERSONAL

		    cLugNacTes := &cMaeAct->cLugNacEst
		    dFecNacTes := &cMaeAct->dFecNacEst
		    cDocNitTes := &cMaeAct->cDocNitEst
		    cLugNitTes := &cMaeAct->cLugNitEst
		    cTipNitTes := &cMaeAct->cTipNitEst
		    lSexFemTes := &cMaeAct->lSexFemEst
		    nEstratTes := &cMaeAct->nEstratEst
		    IF lSexFemTes
		       cSexFem := 'F'
		    ELSE
		       cSexFem := 'M'
		    ENDIF
		    cDireccTes := &cMaeAct->cDireccEst
		    cBarrioTes := &cMaeAct->cBarrioEst
		    cCiudadTes := &cMaeAct->cCiudadEst
		    cTelefnTes := &cMaeAct->cTelefnEst
		    cMaiEstTes := &cMaeAct->cMaiEstEst

	       CASE nNroOpc == 2  // INFORMACION DE LOS PADRES

		    cApePadTes := &cMaeAct->cApePadEst
		    cNomPadTes := &cMaeAct->cNomPadEst
		    lPadQepTes := &cMaeAct->lPadQepEst
		    cPadQepTes := IF(lPadQepTes,'S','N')
		    cPadNitTes := &cMaeAct->cPadNitEst
		    cPadLugTes := &cMaeAct->cPadLugEst
		    cPadTntTes := &cMaeAct->cPadTntEst
		    cDirPadTes := &cMaeAct->cDirPadEst
		    cBarPadTes := &cMaeAct->cBarPadEst
		    cCiuPadTes := &cMaeAct->cCiuPadEst
		    cProPadTes := &cMaeAct->cProPadEst
		    cEmpPadTes := &cMaeAct->cEmpPadEst
		    cCarPadTes := &cMaeAct->cCarPadEst
		    cTelPadTes := &cMaeAct->cTelPadEst
		    cMaiPadTes := &cMaeAct->cMaiPadEst
		  *ÀInformaci¢n del Padre

		    cApeMadTes := &cMaeAct->cApeMadEst
		    cNomMadTes := &cMaeAct->cNomMadEst
		    lMadQepTes := &cMaeAct->lMadQepEst
		    cMadQepTes := IF(lMadQepTes,'S','N')
		    cMadNitTes := &cMaeAct->cMadNitEst
		    cMadLugTes := &cMaeAct->cMadLugEst
		    cMadTntTes := &cMaeAct->cMadTntEst
		    cDirMadTes := &cMaeAct->cDirMadEst
		    cBarMadTes := &cMaeAct->cBarMadEst
		    cCiuMadTes := &cMaeAct->cCiuMadEst
		    cProMadTes := &cMaeAct->cProMadEst
		    cEmpMadTes := &cMaeAct->cEmpMadEst
		    cCarMadTes := &cMaeAct->cCarMadEst
		    cTelMadTes := &cMaeAct->cTelMadEst
		    cMaiMadTes := &cMaeAct->cMaiMadEst
		  *ÀInformaci¢n de la Madre

	       CASE nNroOpc == 3  // INFORMACION DEL ACUDIENTE

		    cApeAcuTes := &cMaeAct->cApeAcuEst
		    cNomAcuTes := &cMaeAct->cNomAcuEst
		    cAcuNitTes := &cMaeAct->cAcuNitEst
		    cAcuLugTes := &cMaeAct->cAcuLugEst
		    cAcuTntTes := &cMaeAct->cAcuTntEst
		    cDirAcuTes := &cMaeAct->cDirAcuEst
		    cBarAcuTes := &cMaeAct->cBarAcuEst
		    cCiuAcuTes := &cMaeAct->cCiuAcuEst
		    cTe1AcuTes := &cMaeAct->cTe1AcuEst
		    cTe2AcuTes := &cMaeAct->cTe2AcuEst
		    cMaiAcuTes := &cMaeAct->cMaiAcuEst
		    cParAcuTes := &cMaeAct->cParAcuEst
		  *ÀInformaci¢n del Acudiente

	       ENDCASE
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TANOORALES

**********ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE
	    DO CASE
	    CASE nNroOpc == 1

*----------------INFORMACION PERSONAL
		   nNroFil := nFilInf+6
		   @nNroFil,nNroCol+00   SAY 'NACIDO EN:';
					 GET cLugNacTes PICT "@!";
					 VALID !EMPTY(cLugNacTes)

		   @nNroFil,nNroCol+34 SAY 'FECHA:';
					 GET dFecNacTes;
					 VALID !EMPTY(dFecNacTes)

		   @nNroFil,nNroCol+53 SAY 'SEXO:';
					 GET cSexFem;
					 VALID lValSexo(ROW(),COL()-1,;
					       @cSexFem,@lSexFemTes)

		   @nNroFil++,nNroCol+62 SAY 'ESTRATO:';
					 GET nEstratTes PICT "99"

		   @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cDocNitTes PICT "9999999999999999";
					 VALID !EMPTY(cDocNitTes)

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cTipNitTes PICT "@!";
					 VALID lValTipNit(ROW(),COL()-1,;
							  @cTipNitTes)

		   @nNroFil++,nNroCol+40 SAY 'DE:';
					 GET cLugNitTes PICT "@!" ;
					 VALID !EMPTY(cLugNitTes)


		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDireccTes PICT "@!S40";
					 VALID !EMPTY(cDireccTes)

		   @nNroFil++  ,nNroCol+53 SAY 'BARRIO:';
					   GET cBarrioTes PICT "@!";
					   VALID !EMPTY(cBarrioTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiudadTes PICT "@!S30";
					 VALID !EMPTY(cCiudadTes)

		   @nNroFil++,nNroCol+40 SAY 'TELEFONO:';
					 GET cTelefnTes PICT "@S7"

		   @nNroFil++,nNroCol+00 SAY 'E-MAIL:';
					 GET cMaiEstTes PICT "@!"
*----------------FIN INFORMACION PERSONAL

	    CASE nNroOpc == 2

*----------------ACTUALIZACION DE LOS DATOS DEL PADRE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS PADRE:';
					 GET cApePadTes PICT "@!S20";
					 VALID !EMPTY(cApePadTes)

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES PADRE:';
					 GET cNomPadTes PICT "@!S25";
					 VALID !EMPTY(cNomPadTes)

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cPadNitTes PICT "9999999999999999";
					 VALID !EMPTY(cPadNitTes)

		   @nNroFil,nNroCol+28 SAY 'TIPO:';
				       GET cPadTntTes PICT "@!";
				       VALID lValTipNit(ROW(),COL()-1,;
							@cPadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cPadLugTes PICT "@!";
					 VALID !EMPTY(cPadLugTes)

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelPadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpPadTes PICT "@!";
					 VALID !EMPTY(cEmpPadTes)

		   @nNroFil++,nNroCol+38  SAY 'CARGO:';
					 GET cCarPadTes PICT "@!";
					 VALID !EMPTY(cCarPadTes)

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirPadTes PICT "@!S45";
					 VALID !EMPTY(cDirPadTes)

		   @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					   GET cBarPadTes PICT "@!";
					   VALID !EMPTY(cBarPadTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuPadTes PICT "@!S29";
					 VALID !EMPTY(cCiuPadTes)

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProPadTes PICT "@!" ;
					 VALID !EMPTY(cProPadTes)

		   @nNroFil,nNroCol+00 SAY 'E-MAIL:';
					 GET cMaiPadTes PICT "@!"

		  @ nNroFil++,nNroCol+52 SAY 'FALLECIDO:';
					 GET cPadQepTes PICT '@!';
					 VALID lValSiNo(ROW(),COL()-1,;
					       @cPadQepTes,@lPadQepTes)
*----------------FIN ACTUALIZACION DE LOS DATOS DEL PADRE

*----------------ACTUALIZACION DE LOS DATOS DE LA MADRE
		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS MADRE:';
					 GET cApeMadTes PICT "@!S20";
					 VALID !EMPTY(cApeMadTes)

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES MADRE:';
					 GET cNomMadTes PICT "@!S25";
					 VALID !EMPTY(cNomMadTes)

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cMadNitTes PICT "9999999999999999";
					 VALID !EMPTY(cMadNitTes)

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cMadTntTes PICT "@!";
					 VALID lValTipNit(ROW(),COL()-1,;
							  @cMadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cMadLugTes PICT "@!";
					 VALID !EMPTY(cMadLugTes)

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelMadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpMadTes PICT "@!";
					 VALID !EMPTY(cEmpMadTes)

		   @nNroFil++,nNroCol+38  SAY 'CARGO:';
					 GET cCarMadTes PICT "@!";
					 VALID !EMPTY(cCarMadTes)

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirMadTes PICT "@!S45";
					 VALID !EMPTY(cDirMadTes)

		   @nNroFil++,nNroCol+52 SAY 'BARRIO:';
					   GET cBarMadTes PICT "@!";
					   VALID !EMPTY(cBarMadTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuMadTes PICT "@!S29";
					 VALID !EMPTY(cCiuMadTes)

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProMadTes PICT "@!" ;
					 VALID !EMPTY(cProMadTes)

		   @nNroFil,nNroCol+00 SAY 'E-MAIL:';
					 GET cMaiMadTes PICT "@!"

		  @ nNroFil++,nNroCol+52 SAY 'FALLECIDA:';
					 GET cMadQepTes PICT '@!';
					 VALID lValSiNo(ROW(),COL()-1,;
					       @cMadQepTes,@lMadQepTes)
*----------------FIN ACTUALIZACION DE LOS DATOS DE LA MADRE

	    CASE nNroOpc == 3

*----------------ACTUALIZACION DE LOS DATOS DEL ACUDIENTE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS ACUDIENTE:';
					 GET cApeAcuTes PICT "@!S16";
					 VALID !EMPTY(cApeAcuTes)

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES ACUDIENTE:';
					 GET cNomAcuTes PICT "@!S21";
					 VALID !EMPTY(cNomAcuTes)

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cAcuNitTes PICT "@S11 9999999999999999";
					 VALID !EMPTY(cAcuNitTes)

		   @nNroFil,nNroCol+23 SAY 'TIPO:';
				       GET cAcuTntTes PICT "@!";
				       VALID lValTipNit(ROW(),COL()-1,;
							@cAcuTntTes)

		   @nNroFil,nNroCol+33 SAY 'DE:';
				       GET cAcuLugTes PICT "@!S12";
				       VALID !EMPTY(cAcuLugTes)

		   @nNroFil++,nNroCol+50 SAY 'PARENTESCO:';
					 GET cParAcuTes PICT "@!";
					 VALID !EMPTY(cParAcuTes)

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirAcuTes PICT "@!S45";
					 VALID !EMPTY(cDirAcuTes)

		   @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					   GET cBarAcuTes PICT "@!";
					   VALID !EMPTY(cBarAcuTes)

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuAcuTes PICT "@!S29";
					 VALID !EMPTY(cCiuAcuTes)

		   @nNroFil  ,nNroCol+38 SAY 'TEL CASA:';
					 GET cTe1AcuTes PICT "@!S10"
		   @nNroFil  ,nNroCol+59 SAY 'TEL OFI:';
					 GET cTe2AcuTes PICT "@!S10"

		   @++nNroFil,nNroCol+00 SAY 'E-MAIL:';
					 GET cMaiAcuTes PICT "@!"
*----------------FIN ACTUALIZACION DE LOS DATOS DEL ACUDIENTE

	    ENDCASE
	    READ
**********FIN ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
	    ENDCASE
**********FIN PREGUNTA DE DECISION

**********GRABACION DE LOS DATOS DEL CANDIDATO
	    SELECT &cMaeAct
	    IF lGrabar
	       IF lRegLock(lSiRed,.F.)
		  DO CASE
		  CASE nNroOpc == 1

*----------------------GRABACION DE LA INFORMACION PERSONAL
			 REPL &cMaeAct->cLugNacEst WITH cLugNacTes
			 REPL &cMaeAct->dFecNacEst WITH dFecNacTes
			 REPL &cMaeAct->cDocNitEst WITH cDocNitTes
			 REPL &cMaeAct->cLugNitEst WITH cLugNitTes
			 REPL &cMaeAct->cTipNitEst WITH cTipNitTes
			 REPL &cMaeAct->lSexFemEst WITH lSexFemTes
			 REPL &cMaeAct->nEstratEst WITH nEstratTes
			 REPL &cMaeAct->cDireccEst WITH cDireccTes
			 REPL &cMaeAct->cBarrioEst WITH cBarrioTes
			 REPL &cMaeAct->cCiudadEst WITH cCiudadTes
			 REPL &cMaeAct->cTelefnEst WITH cTelefnTes
			 REPL &cMaeAct->cMaiEstEst WITH cMaiEstTes
*----------------------FIN GRABACION DE LA INFORMACION PERSONAL

		  CASE nNroOpc == 2

*----------------------GRABACION DE LA INFORMACION DE LOS PADRES
			 REPL &cMaeAct->cApePadEst WITH cApePadTes
			 REPL &cMaeAct->cNomPadEst WITH cNomPadTes
			 REPL &cMaeAct->lPadQepEst WITH lPadQepTes
			 REPL &cMaeAct->cPadNitEst WITH cPadNitTes
			 REPL &cMaeAct->cPadLugEst WITH cPadLugTes
			 REPL &cMaeAct->cPadTntEst WITH cPadTntTes
			 REPL &cMaeAct->cDirPadEst WITH cDirPadTes
			 REPL &cMaeAct->cBarPadEst WITH cBarPadTes
			 REPL &cMaeAct->cCiuPadEst WITH cCiuPadTes
			 REPL &cMaeAct->cProPadEst WITH cProPadTes
			 REPL &cMaeAct->cEmpPadEst WITH cEmpPadTes
			 REPL &cMaeAct->cCarPadEst WITH cCarPadTes
			 REPL &cMaeAct->cTelPadEst WITH cTelPadTes
			 REPL &cMaeAct->cMaiPadEst WITH cMaiPadTes
		       *ÀGrabaci¢n de la Informaci¢n del Padre

			 REPL &cMaeAct->cApeMadEst WITH cApeMadTes
			 REPL &cMaeAct->cNomMadEst WITH cNomMadTes
			 REPL &cMaeAct->lMadQepEst WITH lMadQepTes
			 REPL &cMaeAct->cMadNitEst WITH cMadNitTes
			 REPL &cMaeAct->cMadLugEst WITH cMadLugTes
			 REPL &cMaeAct->cMadTntEst WITH cMadTntTes
			 REPL &cMaeAct->cDirMadEst WITH cDirMadTes
			 REPL &cMaeAct->cBarMadEst WITH cBarMadTes
			 REPL &cMaeAct->cCiuMadEst WITH cCiuMadTes
			 REPL &cMaeAct->cProMadEst WITH cProMadTes
			 REPL &cMaeAct->cEmpMadEst WITH cEmpMadTes
			 REPL &cMaeAct->cCarMadEst WITH cCarMadTes
			 REPL &cMaeAct->cTelMadEst WITH cTelMadTes
			 REPL &cMaeAct->cMaiMadEst WITH cMaiMadTes
		       *ÀGrabaci¢n de la Informaci¢n de la Madre
*----------------------FIN GRABACION DE LA INFORMACION DE LOS PADRES

		  CASE nNroOpc == 3

*----------------------GRABACION DE LA INFORMACION DEL ACUDIENTE
			 REPL &cMaeAct->cApeAcuEst WITH cApeAcuTes
			 REPL &cMaeAct->cNomAcuEst WITH cNomAcuTes
			 REPL &cMaeAct->cAcuNitEst WITH cAcuNitTes
			 REPL &cMaeAct->cAcuLugEst WITH cAcuLugTes
			 REPL &cMaeAct->cAcuTntEst WITH cAcuTntTes
			 REPL &cMaeAct->cDirAcuEst WITH cDirAcuTes
			 REPL &cMaeAct->cBarAcuEst WITH cBarAcuTes
			 REPL &cMaeAct->cCiuAcuEst WITH cCiuAcuTes
			 REPL &cMaeAct->cTe1AcuEst WITH cTe1AcuTes
			 REPL &cMaeAct->cTe2AcuEst WITH cTe2AcuTes
			 REPL &cMaeAct->cParAcuEst WITH cParAcuTes
			 REPL &cMaeAct->cMaiAcuEst WITH cMaiAcuTes
		       *ÀGrabaci¢n de la Informaci¢n del Acudiente
*----------------------FIN GRABACION DE LA INFORMACION DEL ACUDIENTE

		  ENDCASE
	       ELSE
		   cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       DBCOMMIT()
	       IF lShared
		  DBUNLOCK()
	       ENDIF

	    ENDIF
	    EXIT
**********FIN GRABACION DE LOS DATOS DEL CANDIDATO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
       SET ESCAPE OFF
       IF !EMPTY(cNalias)
	  SELECT &cNalias
       ENDIF
       RETURN lGrabar
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA

/*************************************************************************
* TITULO..: FORMATO DE ACTUALIZACION DE LA INFORMACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2001 MAR A
       Colombia, Bucaramanga        INICIO: 05:25 PM   JUN 05/2001 MAR

OBJETIVOS:

1- Imprime el Formato para la Actualizaci¢n de la Informaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FrmActInf(cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cMaeAct			            // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       cSavPan := SAVESCREEN(0,0,24,79)

       DO WHILE !Printer_on(); ENDDO

       @ PROW(),00 SAY INICIALIZA+GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMATO DE ACTUALIZACION
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'FORMATO DE ACTUALIZACION DE DATOS'
       @ PROW()+3,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := RTRIM(&cMaeAct->cApelliEst)+' '+;
		  RTRIM(&cMaeAct->cNombreEst)+'. '+;
		  'CODIGO: '+&cMaeAct->cCodigoEst+' '+;
		  'CURSO:'+&cMaeAct->cCodigoGru
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+2,02 SAY 'Se¤or Padre de Familia le solicitamos el favor '+;
			 'de revisar y corregir la informaci¢n de su '+;
			 'hijo(a) con el objectivo de mantener actualizado '+;
			 'el Directorio'
       @ PROW()+1,02 SAY 'de los Estudiantes. Favor Diligenciar todos los '+;
			 'Campos. Muchas Gracias.'
       @ PROW(),00 SAY CONDEN_OF

       LineaPrn({'NACIDO EN: ',&cMaeAct->cLugNacEst+' FECHA: '+;
		  cFecha(&cMaeAct->dFecNacEst)},2)

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+1,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',&cMaeAct->cTipNitEst+SPACE(01),;
		 'No' ,cLenSpace(&cMaeAct->cDocNitEst,30),;
		 'DE' ,cLenSpace(&cMaeAct->cLugNitEst,31)})

       LineaPrn({'              : ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDireccEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarrioEst,21)})
       LineaPrn({'          ',REPL('_',49),'       ',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiudadEst,39),;
		 'TELEFONO:',cLenSpace(&cMaeAct->cTelefnEst,32)})
       LineaPrn({'       ',REPL('_',39),'         ',REPL('_',32)})
       LineaPrn({'E-MAIL DEL ESTUDIANTE:',cLenSpace(&cMaeAct->cMaiEstEst,39)})
       LineaPrn({'                     :',REPL('_',40)})


       LineaPrn({'APELLIDOS PADRE:',cLenSpace(&cMaeAct->cApePadEst,30),;
		 'NOMBRES PADRE:',cLenSpace(&cMaeAct->cNomPadEst,27)},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cPadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cPadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cPadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelPadEst,13)})

       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpPadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarPadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirPadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarPadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuPadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProPadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       LineaPrn({'E-MAIL DEL PADRE:',cLenSpace(&cMaeAct->cMaiPadEst,39)})
       LineaPrn({'                :',REPL('_',40)})


       LineaPrn({'APELLIDOS MADRE:',cLenSpace(&cMaeAct->cApeMadEst,30),;
		 'NOMBRES MADRE:',&cMaeAct->cNomMadEst},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cMadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cMadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cMadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelMadEst,13)})
       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpMadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarMadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirMadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarMadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuMadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProMadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL DE LA MADRE:',cLenSpace(&cMaeAct->cMaiMadEst,39)})
       LineaPrn({'                  :',REPL('_',40)})

       LineaPrn({'APELLIDOS ACUDIENTE:',cLenSpace(&cMaeAct->cApeAcuEst,26),;
		 'NOMBRES ACUDIENTE:',cLenSpace(&cMaeAct->cNomAcuEst,23)},2)
       LineaPrn({'                    ',REPL('_',26),;
		 '                  ',REPL('_',23)},)

       LineaPrn({'IDENTI: '+&cMaeAct->cAcuTntEst+;
		 ' No.:',cLenSpace(&cMaeAct->cAcuNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cAcuLugEst,19),;
		 'PARENTESCO:',cLenSpace(&cMaeAct->cParAcuEst,14)})
       LineaPrn({'        ___'+;
		 '     ',REPL('_',21),;
		 '  :',REPL('_',19),;
		 '          :',REPL('_',14)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirAcuEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarAcuEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuAcuEst,31),;
		 'TEL CASA:',cLenSpace(&cMaeAct->cTe1AcuEst,15),;
		 'TEL OFI:',cLenSpace(&cMaeAct->cTe2AcuEst,15)})
       LineaPrn({'      :',REPL('_',31),;
		 '        :',REPL('_',15),;
		 '       :',REPL('_',15)})
       LineaPrn({'E-MAIL DEL ACUDIENTE:',cLenSpace(&cMaeAct->cMaiAcuEst,39)})
       LineaPrn({'                    :',REPL('_',40)})

       EJECT
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMATO DE ACTUALIZACION

FUNCTION cLenSpace(cTxtTem,nLenSpa)
RETURN SUBS(cTxtTem+SPACE(nLenSpa),1,nLenSpa)

FUNCTION cTipNomRep(nNomFac)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNomFac                              // Nombre de la Factura */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cTipNom := ''                  // Tipo de Nombre
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL NOMBRE DE LA FACTURA
       DO CASE
       CASE nNomFac == 0 .OR. nNomFac == 1
	    cTipNom := 'PADRE'
       CASE nNomFac == 2
	    cTipNom := 'MADRE'
       CASE nNomFac == 3
	    cTipNom := 'ACUDIENTE'
       OTHERWISE
	    cTipNom = 'ERROR NOMBRE A REPORTAR'
       ENDCASE
       RETURN cTipNom
*>>>>FIN ANALISIS DEL NOMBRE DE LA FACTURA

/*************************************************************************
* TITULO DE LA FUNCION..: APERTURA DE LOS MAESTROS DE LA CONTABILIDAD    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   FEB 02/96 VIE

OBJETIVOS:

1)- Pone en uso los archivos de alumnos de la contabilidad habilitados

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseXYZ(lShared,cPatSis,cMaeAlu,cAnoSis,lAnoAct,lUseNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoSis                              // A¤o del sistema
       lAnoAct                              // .F. A¤o Anteriores
       lUseNtx                              // .T. Abrir Indixes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
*       #INCLUDE "FILES.PRG"                 // Archivos Compartidos

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathAlu := ''                  // Path de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lAnoAct := IF(lAnoAct==NIL,.T.,lAnoAct)
       lUseNtx := IF(lUseNtx==NIL,.T.,lUseNtx)
       IF 'JAR' $ cMaeAlu

	  PathAlu := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathAlu+FMaeJar+cAnoSis+ExtFile,;
		      IF(lAnoAct,'JAR','JAA'),;
		      IF(lUseNtx,PathAlu+fNtxJar+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathAlu := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathAlu+FMaePri+cAnoSis+ExtFile,;
		      IF(lAnoAct,'PRI','PRA'),;
		      IF(lUseNtx,PathAlu+fNtxPri+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathAlu := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathAlu+FMaeBto+cAnoSis+ExtFile,;
		      IF(lAnoAct,'BTO','BTA'),;
		      IF(lUseNtx,PathAlu+fNtxBto+cAnoSis+cExtNtx,NIL),lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathAlu)
	     CLOSE ALL
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: INFORMACION DEL ESTUDIANTE                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 26/94 VIE A
						       AGO 27/94 SAB
OBJETIVOS:

1)- Debe estar en uso el archivo de admisiones en el registro del aspirante

2)- Visualiza la informaci¢n sobre el aspirante

3)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DetalleCli(nFilInf,nColInf,cMaeAlu,cMaeAct,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilInf                              // Fila de Impresi¢n
       nColInf                              // Columna de Impresi¢n
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       cTitulo                              // T¡tulo de la Pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL ESTUDIANTE
       IF EMPTY(cMaeAct)
	  lSekCodMae(COB->cCodigoEst,cMaeAlu,@cMaeAct)
       ENDIF
*>>>>FIN BUSQUEDA DEL ESTUDIANTE

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cTitulo := IF(cTitulo == NIL,'DETALLES DE LA HOJA DE VIDA',cTitulo)
       nNroFil := nMarco(nFilInf+1,cTitulo,22,'°')
       nNroCol := nColInf
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+&cMaeAct->cCodigoEst
       @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(&cMaeAct->cApelliEst)+' '+;
					   &cMaeAct->cNombreEst
       @ nNroFil,nNroCol+65 SAY 'CURSO : '+&cMaeAct->cCodigoGru
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRSION DE LOS TITULOS
       nNroFil := nFilInf+6
       @nNroFil,nNroCol+00 SAY 'NACIDO EN: '
       @nNroFil++,nNroCol+36 SAY 'FECHA:'

       @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:'
       @nNroFil++,nNroCol+36 SAY 'DE:'

       @++nNroFil,nNroCol+00 SAY 'DIRECCION:'
       @nNroFil  ,nNroCol+37 SAY 'BARRIO:'
       @nNroFil++,nNroCol+61 SAY 'TELEFONO:'

       @++nNroFil,nNroCol+00 SAY 'PADRE:'
       @nNroFil++,nNroCol+42 SAY 'PROFESION:'
       @nNroFil  ,nNroCol+00 SAY 'EMPRESA:'
       @nNroFil  ,nNroCol+34 SAY 'CARGO:'
       @nNroFil++,nNroCol+61 SAY 'TELEFONO:'

       @++nNroFil,nNroCol+00 SAY 'MADRE:'
       @nNroFil++,nNroCol+42 SAY 'PROFESION:'
       @nNroFil  ,nNroCol+00 SAY 'EMPRESA:'
       @nNroFil  ,nNroCol+34 SAY 'CARGO:'
       @nNroFil++,nNroCol+61 SAY 'TELEFONO:'

       @++nNroFil,nNroCol+00 SAY 'ACUDIENTE:'
       @nNroFil  ,nNroCol+42 SAY 'TEL CASA:'
       @nNroFil  ,nNroCol+61 SAY 'TEL OFIC:'
*>>>>FIN IMPRSION DE LOS TITULOS

*>>>>IMPRESION DE LOS DATOS
       nNroFil := nFilInf+6
       SET COLOR TO I
       @nNroFil  ,nNroCol+10 SAY &cMaeAct->cLugNacEst
       @nNroFil++,nNroCol+44 SAY &cMaeAct->dFecNacEst

       @nNroFil  ,nNroCol+10 SAY &cMaeAct->cDocNitEst
       @nNroFil++,nNroCol+39 SAY &cMaeAct->cLugNitEst

       @++nNroFil,nNroCol+10 SAY &cMaeAct->cDireccEst PICT "@!S25"
       @nNroFil  ,nNroCol+44 SAY &cMaeAct->cBarrioEst PICT "@!"
       @nNroFil++,nNroCol+70 SAY &cMaeAct->cTelefnEst

       @++nNroFil,nNroCol+07 SAY &cMaeAct->cNomPadEst PICT "@!S30"
       @nNroFil++,nNroCol+52 SAY &cMaeAct->cProPadEst PICT "@!"
       @nNroFil  ,nNroCol+08 SAY &cMaeAct->cEmpPadEst PICT "@!"
       @nNroFil  ,nNroCol+40 SAY &cMaeAct->cCarPadEst PICT "@!"
       @nNroFil++,nNroCol+70 SAY &cMaeAct->cTelPadEst

       @++nNroFil,nNroCol+07 SAY &cMaeAct->cNomMadEst PICT "@!S30"
       @nNroFil++,nNroCol+52 SAY &cMaeAct->cProMadEst PICT "@!"
       @nNroFil  ,nNroCol+08 SAY &cMaeAct->cEmpMadEst PICT "@!"
       @nNroFil  ,nNroCol+40 SAY &cMaeAct->cCarMadEst PICT "@!"
       @nNroFil++,nNroCol+70 SAY &cMaeAct->cTelMadEst

       @++nNroFil,nNroCol+10 SAY &cMaeAct->cNomAcuEst PICT "@!S30"
       @nNroFil  ,nNroCol+52 SAY &cMaeAct->cTe1AcuEst
       @nNroFil  ,nNroCol+70 SAY &cMaeAct->cTe2AcuEst
       SET COLOR TO

       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DATOS