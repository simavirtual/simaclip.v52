/*               	 SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO GRUPOS

REQUERIMIENTOS:

- Compilar: clipper FuncsGru /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo grupos

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: APERTURA DEL ARCHIVO DE GRUPOS                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 12/94 JUE A
       Bucaramanga, Colombia        INICIO: 08:30 PM   ENE 12/94 JUE

OBJETIVOS:

1- Pone en uso el archivo de grupos de la contabilidad habilitado

2- Debe pasarse el directorio completo donde se encuentran los archivos

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseGru(cPatSis,cAnoSis,cMaeAlu,lShared,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis				    // Path del sistema
       cAnoSis                              // A¤o del sistema
       cMaeAlu                              // Maestros habilitados
       lShared                              // .T. Archivo Compartido
       cNalias                              // @Alias del maestro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL       i := 1                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE AREAS DE TRABAJO
       DO CASE
       CASE 'JAR' $ cMaeAlu

************ARCHIVOS DE JARDIN
	      IF !lUseDbf(.T.,cPatSis+;
			  FGruJar+cAnoSis+ExtFile,'GRU',NIL,lShared)
		 cError('ABRIENDO GRUPOS EN '+cPatSis)
		 lHayErr := .T.
	      ENDIF
	      cNalias := 'JAR'
************FIN ARCHIVOS DE JARDIN

       CASE 'PRI' $ cMaeAlu

************ARCHIVOS DE PRIMARIA
	      IF !lUseDbf(.T.,cPatSis+;
			      FGruPri+cAnoSis+ExtFile,'GRU',NIL,lShared)
		 cError('ABRIENDO GRUPOS EN '+cPatSis)
		 lHayErr := .T.
	      ENDIF
	      cNalias := 'PRI'
************FIN ARCHIVOS DE PRIMARIA

       CASE 'BTO' $ cMaeAlu

************ARCHIVOS DE BACHILLERATO
	      IF !lUseDbf(.T.,cPatSis+;
			      FGruBto+cAnoSis+ExtFile,'GRU',NIL,lShared)
		 cError('ABRIENDO GRUPOS EN '+cPatSis)
		 lHayErr := .T.
	      ENDIF
	      cNalias := 'BTO'
************FIN ARCHIVOS DE BACHILLERATO

       ENDCASE
       RETURN !lHayErr
*>>>>FIN SELECION DE AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DEL GRUPO         	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Bucaramanga, Colombia        INICIO: 10:20 AM   MAY 09/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de Grupo

2- Verifica la existencia del c¢digo del Grupo.

3- Deja el archivo en el registro del c¢digo del Grupo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodGru(cCodigo,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a localizar
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT GRU
       GO TOP
       LOCATE FOR GRU->cCodigoGru == cCodigo
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CURSO: '+cCodigo+' NO EXISTE')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE GRUPOS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 08:35 AM   MAY 09/95 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo Grupos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenGru(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivo Grupos

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL oBrwGru := NIL                 // Browse de Grupos
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
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT GRU
       oBrwGru := oDefBrwGru(lShared,cAnoUsr,cPatSis,cMaeAct,;
			     nFilPal+1,00,22,79,;
			     'TITULARES PARA',;
			     !lFilesPla(cPatSis+'\'+cMaeAct,cAnoSis,cMaeAlu))
       SETKEY(K_F5,{||BuscarGru(oBrwGru)})
       SETKEY(K_F9,{||PrnGrupos(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt)})
       GRU->(CtrlBrw(lShared,oBrwGru))
       SETKEY(K_F5,NIL)
       CloseDbf('GRU')
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE GRUPOS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 08:45 AM   MAY 09/95 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo Grupos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwGru(lShared,cAnoUsr,cPatSis,cMaeAct,nFilSup,;
		    nColSup,nFilInf,nColInf,cTitulo,lModifi)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Activo
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAct			            // Maestro Activado
       cTitulo                              // T¡tulo del Browse
       lModifi                              // .T. Modificar el archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       DO CASE
       CASE cMaeAct == 'JAR'
	    cNomNiv := 'JARDIN'
       CASE cMaeAct == 'PRI'
	    cNomNiv := 'PRIMARIA'
       CASE cMaeAct == 'BTO'
	    cNomNiv := 'BACHILLERATO'
       ENDCASE

       cTitulo := IF(cTitulo == NIL,'MANTENIMIENTO DE GRUPOS DE',cTitulo)
       lModifi := IF(lModifi == NIL,.T.,lModifi)

       IF lModifi
	  oBrowse:Cargo := {'<<'+cTitulo+' '+cNomNiv+' >>',;
			    '<INS>Incluir <F5>Buscar <F9>Imprimir <DEL>Borrar  '+;
			    '<ESC>Abandonar',;
			    {||IncluirGru(lShared,cAnoUsr,cPatSis,cMaeAct)}}
       ELSE
	  oBrowse:Cargo := {'<<'+cTitulo+' '+cNomNiv+' >>',;
			    '<F5>Buscar  <F9>Imprimir <ESC>Abandonar'}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT GRU
       oColumn	     := TBCOLUMNNEW('CODIGO;GRUPO', {||GRU->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 1
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;TITULAR No.1',;
				   {||cSekNomPro(GRU->cCodigoPro,'GRU')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;PROFESOR No.1', {||GRU->cCodigoPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cCodigoPro'},;
			 {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('NOMBRE;TITULAR No.2',;
				   {||cSekNomPro(GRU->cCodProPro,'GRU')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;PROFESOR No.2', {||GRU->cCodProPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cCodProPro'},;
			 {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna





       oColumn	     := TBCOLUMNNEW('CODIGO;IDENTIFICACION', {||GRU->cIdentiGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cIdentiGru'},;
			 {'PICTURE','XX'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL GRUPO', {||GRU->cNombreGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cNombreGru'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIVEL AL;QUE PERTENECE', {||GRU->cNivEduGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cNivEduGru'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO PARA;DISCIPLINA',;
				   {||GRU->cMatDisGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cMatDisGru'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO PARA;CONDUCTA',;
				   {||GRU->cMatConGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cMatConGru'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORARIO DE;ENTRADA Y SALIDA',;
				   {||GRU->cEntSalGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cEntSalGru'},;
			 {'PICTURE','99:9999:9999:9999:99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MINUTOS;CLASE', {||GRU->cMinClaGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cMinClaGru'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORAS;SEMANALES', {||GRU->cHorSemGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cHorSemGru'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORAS;ANUALES', {||GRU->cHorAnoGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cHorAnoGru'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JUICIO VALORATIVO;CALCULADO', {||GRU->cJvfCalGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cJvfCalGru'},;
			 {'PICTURE','999999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO;ALUMNOS', {||GRU->nNroAluGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','nNroAluGru'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TEMPORAL', {||GRU->nNroTemGru})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','nNroTemGru'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE


/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE GRUPOS	     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 08:50 AM   MAY 09/95 MAR

OBJETIVOS:

1- Incluye un registro al archivo de Grupos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirGru(lShared,cAnoUsr,cPatSis,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Activo */
*>>>>PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL nPosIni := 0                   // Posici¢n inicial
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTpr := ''               // C¢digo del profesor
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>CREACION DE LOS GRUPOS
       IF GRU->(RECCOUNT()) == 0
	  CreaGrupos(lShared,cAnoUsr,cPatSis,cMaeAct)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DE LOS GRUPOS

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL GRUPO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTgr := cSpaField('GRU','cCodigoGru')
	       cCodigoTPr := cSpaField('PRO','cCodigoPro')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL GRUPO    :';
				GET cCodigoTgr PICT '9999';
				VALID !lValCodGru(cCodigoTgr,cMaeAct)
	    @ nNroFil+1,nNroCol SAY 'CODIGO DEL PROFESOR :';
				GET cCodigoTpr PICT '999999';
				VALID lValProfes(ROW(),COL()-6,@cCodigoTpr)

	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(cCodigoTgr)

		 cError('DEBE DAR EL CODIGO DEL GRUPO COMPLETO. '+;
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

*>>>>GRABACION DEL REGISTRO
       SELECT GRU
       IF lGrabar
	  IF GRU->(lRegLock(lShared,.T.))
	     REPL GRU->cCodigoGru WITH cCodigoTgr
	     REPL GRU->cCodigoPro WITH cCodigoTpr
	     GRU->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL NIVEL DONDE DICTA EL PROFESOR')
	  ENDIF
	  IF lShared
	     GRU->(DBUNLOCK())
	  ENDIF
       ENDIF
*>>>>FIN GRABACION DEL CAMPO

*>>>>GRABACION DEL NIVEL DONDE DICTA EL PROFESOR
       IF lGrabar

	  lGrabar := !(cMaeAct $ PRO->cMaeAluPro)
	  IF lGrabar
	     SELECT PRO
	     nPosIni := AT(SPACE(03),PRO->cMaeAluPro)

	     IF PRO->(lRegLock(lShared,.F.))
		REPL PRO->cMaeAluPro WITH STUFF(PRO->cMaeAluPro,nPosIni,3,cMaeAct)
		PRO->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABA EL NIVEL DONDE DICTA EL PROFESOR')
	     ENDIF

	     IF lShared
		PRO->(DBUNLOCK())
	     ENDIF
	  ENDIF

       ENDIF
       SELECT GRU
       RETURN NIL
*>>>>FIN GRABACION DEL NIVEL DONDE DICTA EL PROFESOR

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL GRUPO		*
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 09:00 AM   MAY 09/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo Grupos

2- Realiza la validaci¢n del c¢digo del Grupos

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodGru(cCodGru,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodGru			            // C¢digo del Grupo
       cMaeAct			            // Maestro Activado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aNomNiv := ''
       LOCAL nNroNiv := 0                   // N£mero del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL NIVEL
       nNroNiv := VAL(SUBS(cCodGru,1,2))
       aNomNiv := {'JARDINB','PRIMERO','SEGUNDO','TERCERO','CUARTO','QUINTO',;
		   'SEXTO','SEPTIMO','OCTAVO','NOVENO','DECIMO','UNDECIMO',;
		   'MATERNALES','CAMINADORES','PARVULOS','PREJARDIN','JARDINA'}
       IF nNroNiv < 0 .OR. nNroNiv > 16
	  lHayErr := .T.
	  cError('ESTE NIVEL NO ESTA DISPONIBLE')
	  RETURN lHayErr
       ENDIF
*>>>>FIN VALIDACION DEL NIVEL

*>>>>VALIDACION DEL CODIGO DEL GRUPO EN EL NIVEL
       lHayErr := .T.
       DO CASE
       CASE cCodGru == cSpaField('GRU','cCodigoGru')
	    lHayErr := .F.

       CASE cMaeAct == 'PRI' .AND. !(nNroNiv >= 0 .AND. nNroNiv < 6)
	    cError(aNomNiv[nNroNiv+1]+' NO PERTENECE A PRIMARIA')

       CASE cMaeAct == 'BTO' .AND. !(nNroNiv >= 6 .AND. nNroNiv <= 11)
	    cError(aNomNiv[nNroNiv+1]+' NO PERTENECE A BACHILLERATO')

       CASE cMaeAct == 'JAR' .AND. !(nNroNiv >= 12 .AND. nNroNiv < 17)
	    cError('ESTE GRUPO PERTENECE A JARDIN')

       OTHERWISE
	    lHayErr := .F.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO DEL GRUPO EN EL NIVEL

*>>>>VALIDACION DEL CODIGO DEL GRUPO
       IF lLocCodGru(cCodGru,.F.) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL GRUPO



/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL GRUPO EN EL BROWSE        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 09/95 MAR A
       Colombia, Bucaramanga        INICIO: 08:55 AM   MAY 09/95 MAR

OBJETIVOS:

1- Localiza el c¢digo del Grupos dentro del Browse de Grupos

2- Retorna NIL

SINTAXIS:

  BuscarGru(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarGru(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse de Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegGru := 0                   // Registro del Grupos
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTgr := cSpaField('GRU','cCodigoGru')
       TitBuscar(LEN(cCodigoTgr),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTgr PICT '9999';
			 VALID lValGrupo(ROW(),COL()-4,@cCodigoTgr)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTgr == cSpaField('GRU','cCodigoGru')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT GRU
       IF lBuscar .AND. lLocCodGru(cCodigoTgr)
	   nRegGru := RECNO()
	   GO TOP
	   oBrowse:GOTOP()
	   GO nRegGru
	   oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS TITULARES DE GRUPO            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 31/97 VIE A
       Colombia, Bucaramanga        INICIO: 01:15 PM   ENE 31/97 VIE

OBJETIVOS:

1- Imprime los titulares de curso.

2- Debe estar en uso los archivos de profesores y grupos.

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnGrupos(lShared,cNomEmp,cNomSis,cAnoUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "\EPSONFX.PRG"  // Impresora EPSON FX
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

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cNombreTpr := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF GRU->(RECCOUNT()) == 0
	  cError('NO EXISTEN GRUPOS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := GRU->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'TITULARES DE CURSO A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,52,06}
       aTitulo := {'GRUPO',;
		   'NOMBRE DEL TITULAR',;
		   'CODIGO'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n10Stan
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT GRU
       GO TOP
       DO WHILE .NOT. GRU->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( GRU->(RECNO()) / GRU->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DEL NOMBRE DEL PROFESOR
	    cNombreTpr := SPACE(52)
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro)
	       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	       cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
	    ENDIF
**********FIN LOCALIZACION DEL NOMBRE DEL PROFESOR

**********IMPRESION DEL REGISTRO
	    aTitulo := {cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
				   SUBS(GRU->cCodigoGru,3,2),;
			cNombreTpr,;
			GRU->cCodigoPro}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    GRU->(DBSKIP())
	    IF GRU->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LOS GRUPOS DEL NIVEL               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 31/97 VIE A
       Colombia, Bucaramanga        INICIO: 02:20 PM   ENE 31/97 VIE

OBJETIVOS:

1- Crea los grupos de acuerdo al n£mero especificado en cada nivel.

2- Debe estar en uso los archivos: grupos, niveles

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaGrupos(lShared,cAnoUsr,cPatSis,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Activo */
*>>>>PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL lHayGru := .F.                 // .T. Hay Grupos Especificados
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS NIVELES
       SELECT NIV
       GO TOP
       DO WHILE .NOT. NIV->(EOF())

**********GRABACION DEL REGISTRO
	    FOR i := 1 TO NIV->nNroGruNiv

	      IF GRU->(lRegLock(lShared,.T.))
		 REPL GRU->cCodigoGru WITH NIV->cCodigoNiv+PADL(i,2,'0')
		 GRU->(DBCOMMIT())
		 lHayGru := .T.
	      ELSE
		 cError('NO SE GRABA EL REGISTRO')
	      ENDIF

	    ENDFOR

	    IF lShared
	       GRU->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  SELECT NIV
	  SKIP

       ENDDO
*>>>>FIN LECTURA DE LOS NIVELES

*>>>>ANALISIS SI ESTAN ESPECIFICADO LOS GRUPOS
       IF !lHayGru
	  cError('NO SE HAN ESPECIFICADO EL TOTAL DE GRUPOS POR NIVEL')
       ENDIF
       SET FIXED ON
       RETURN NIL
*>>>>FIN ANALISIS SI ESTAN ESPECIFICADO LOS GRUPOS