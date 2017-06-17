/*                       SIMA - CONTABILIDAD PROFESORES
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO TABLAEVA

REQUERIMIENTOS:

- Compilar: clipper FuncsEva /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo Tabla de Evaluaci¢n

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/96 MIE A
       Colombia, Bucaramanga        INICIO: 09:19 AM   OCT 30/96 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfApr(lShared,PathApr,FileApr,lIntUno,fNtxApr,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathApr				    // Path del Archivo
       FileApr				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxApr				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfApr := {{"nCodigoApr","Numeric"  ,002,0},;
			 {"cDescriApr","Character",200,0},;
			 {"lAproboApr","Logical"  ,001,0},;
			 {"lHayHabApr","Logical"  ,001,0},;
			 {"nTotJidApr","Numeric"  ,002,0},;
			 {"cNivIniApr","Character",002,0},;
			 {"cNivFinApr","Character",002,0},;
			 {"cIniFinApr","Character",036,0},; // Grados en que se aplican
			 {"cTxtObsApr","Character",110,0},; // Texto de Observaci¢n.
			 {"cObsNivApr","Character",110,0}}  // Observaci¢n de nivelaciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfApr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathApr) == 0
	    DBCREATE(FileApr,aDbfApr,"DBFNTX")

       CASE DIRCHANGE(PathApr) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathApr)

       CASE DIRCHANGE(PathApr) == -5
	    cError('NO TIENE DERECHOS EN: '+PathApr)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 17/2000 MAY A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAY 17/2000 MAY

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

FUNCTION nActStrApr(lShared,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'APR',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE TABLA DE APROBACIONES')
	  CloseDbf('APR')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := APR->(DBSTRUCT())
       CloseDbf('APR')
       CreaDbfApr(lShared,PathArc,cNomArc,,,@aStrNew)
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
	  cError('La Tabla de Aprobaciones su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfApr(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:21 AM   MAR 20/96 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfApr(lShared,PathApr,FileApr,lIntUno,fNtxApr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathApr			      // Path del Archivo
       FileApr			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxApr			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathApr+'\'+FileApr,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE EVALUACION")
       Termometro(100)

       CreaDbfApr(lShared,PathApr,FileApr,lIntUno,fNtxApr)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:33 AM   NOV 19/95 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo

2- Se debe pasar el directorio completo de archivo

3- Retorn NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenApr(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivo Grupos

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL oBrowse := NIL                 // Objeto para el Browse
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
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+FileApr,'APR',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
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
       SELECT APR
       oBrowse := oDefBrwApr(lShared,cAnoUsr,nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarApr(oBrowse)})
       SETKEY(K_F9,{||PrnTblApr(lShared,cNomEmp,cNomSis,;
				cAnoUsr,cMaeAct,cJorTxt)})
       APR->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE          	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:40 AM   NOV 19/95 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwApr(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       oBrowse:Cargo := {'<< MANTENIMIENTO TABLA DE APROBACIONES >>',;
			 '<INS>Incluir <F5>Buscar  <DEL>Borrar  '+;
			 '<F9>Imprimir <ESC>Abandonar',{||IncluirApr(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT APR
       oColumn	     := TBCOLUMNNEW('CODIGO', {||APR->nCodigoApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','nCodigoApr'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 1
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION',{||APR->cDescriApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','cDescriApr'},;
			 {'PICTURE','@!S60'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PASA DE NIVEL',{||APR->lAproboApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','lAproboApr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEBE RECUPERAR',{||APR->lHayHabApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','lHayHabApr'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIAS PERDIDAS', {||APR->nTotJidApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','nTotJidApr'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIVEL INICIAL',{||APR->cNivIniApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','cNivIniApr'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIVEL FINAL',{||APR->cNivFinApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','cNivFinApr'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRADOS DONDE SE APLICA',{||APR->cIniFinApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','cIniFinApr'},;
			 {'PICTURE','@S36'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION',{||APR->cTxtObsApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','cTxtObsApr'},;
			 {'PICTURE','@S60'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSRVACION NIVELACIONES',{||APR->cObsNivApr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','APR'},{'FIELD','cObsNivApr'},;
			 {'PICTURE','@S60'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 AM   NOV 19/95 MAR

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirApr(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nCodigoTap := 0                // C¢digo de Aprobaci¢n
       LOCAL cDescriTap := ''               // Descripci¢n
       LOCAL lAproboTap := .T.              // .T. Aprobo el nivel
       LOCAL lHayHabTap := .F.              // .T. Debe Recuperar.
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DE EVALUACION',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       nCodigoTap := 0
	       cDescriTap := cSpaces('APR','cDescriApr')
	       lAproboTap := .T.
	       lHayHabTap := .F.
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DE LA APROBACION:';
				GET nCodigoTap PICT '99';
				VALID !lValCodApr(nCodigoTap)

	    @ nNroFil+1,nNroCol SAY 'DESCRIPCION            :';
				GET cDescriTap PICT '@!S52'

	    @ nNroFil+2,nNroCol SAY 'PASA DE NIVEL          :';
				GET lAproboTap PICT '@!'

	    @ nNroFil+3,nNroCol SAY 'DEBE RECUPERAR         :';
				GET lHayHabTap PICT '@!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(nCodigoTap) .OR. EMPTY(cDescriTap)

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

*>>>>GRABACION DEL REGISTRO
       SELECT APR
       IF lGrabar
	  IF APR->(lRegLock(lShared,.T.))
	     REPL APR->nCodigoApr WITH nCodigoTap
	     REPL APR->cDescriApr WITH cDescriTap
	     REPL APR->lAproboApr WITH lAproboTap
	     REPL APR->lHayHabApr WITH lHayHabTap
	     APR->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  APR->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL BANCO EN EL BROWSE        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:50 AM   NOV 19/95 MAR

OBJETIVOS:

1- Localiza el c¢digo dentro del Browse

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarApr(oBrwApr)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwApr			      // Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegApr := 0                   // Registro del Banco
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nCodigoTap := ''               // C¢digo de Aprobaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       nCodigoTap := 0
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET nCodigoTap PICT '99';
			 VALID lValCodigo(ROW(),COL()-3,@nCodigoTap)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(nCodigoTap)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT APR
       IF lBuscar .AND. lLocCodigo('nCodigoApr','APR',nCodigoTap)
	   nRegApr := RECNO()
	   GO TOP
	   oBrwApr:GOTOP()
	   GO nRegApr
	   oBrwApr:FORCESTABLE()
       ELSE
	  oBrwApr:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL NOMBRE DEL BANCO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo Bancos

2- Realiza la validaci¢n del c¢digo del Banco de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodigo(nNroFil,nNroCol,nCodApr)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodApr			            // C¢digo del Banco */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegApr := 0                   // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('nCodigoApr','APR',nCodApr)
	  nRegApr := nSelCodApr(nNroFil,nNroCol)
	  IF nRegApr == 0
	     nCodApr := 0
	  ELSE
	     GO nRegApr
	     nCodApr := APR->nCodigoApr
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL BANCO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de Bancos

2- Permite escoger el registro del archivo de acuerdo al nombre del Banco

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodApr(nNroFil,nNroCol)

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
       LOCAL nRegApr := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF APR->(RECCOUNT()) == 0
	  cError('NO EXISTEN CODIGOS DE APROBACION GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT APR
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL BANCO
       APR->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegApr := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||APR->cDescriApr})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nRegApr
*>>>>FIN SELECCION DEL BANCO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 01/94 VIE A
						       JUL 01/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo Bancos

2- Realiza la validaci¢n del c¢digo del Banco

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodApr(nCodApr)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodApr			      // C¢digo del Banco */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !EMPTY(nCodApr)
	     
	  IF lLocCodigo('nCodigoApr','APR',nCodApr)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DEL PROGRAMA..: ESTADO DE LA APROBACION DEL A¥O POR JUICIO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:20 AM   SEP 05/95 MAR

OBJETIVOS:

1- Define el estado de aprobaci¢n del a¤o del estudiante

2- Retorna el texto del estado

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cAproboJui(nCodApr,cCodNiv,cObsApr,cSiPaso)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodApr                              // C¢digo de la aprobaci¢n
       cCodNiv                              // C¢digo del Nivel
       cObsApr                              // Texto de Observaci¢n de Promoci¢n
       cSiPaso                              // Texto de Promoci¢n. Promovido No Promovido */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL cNivSgt := ''                  // Nivel Siguiente
       LOCAL cNivAct := ''                  // Nivel Actual

       LOCAL cDescriTap := ''               // Descripci¢n de la aprobaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO DE LA APROBACION
       cSiPaso := ''
       IF lLocCodigo('nCodigoApr','APR',nCodApr)
	  cDescriTap := APR->cDescriApr
	     cObsApr := APR->cTxtObsApr

	  IF APR->lAproboApr
	     cSiPaso := 'Promovido'
	  ELSE
	     cSiPaso := 'No Promovido'
	  ENDIF

       ELSE
	  cDescriTap := 'No Definida'
	     cObsApr := ''
	     cSiPaso := ''
       ENDIF
*>>>>FIN ANALISIS DE LA APROBACION DEL A¥O

*>>>>CAMPOS A SUSTITUIR
       IF cCodNiv # NIL

	  cNivAct := cNomNiv(cCodNiv)
	  cNivSgt := cNomNiv(cSgteNiv(cCodNiv))

	  aMezcla := {{'(GRADO)',cNivAct},;
		      {'(SGTE GRADO)',cNivSgt}}

	  FOR i := 1 TO LEN(aMezcla)
	      IF AT(aMezcla[i,1],cDescriTap) > 0
		 cDescriTap := cReplTxt(aMezcla[i,1],;
					aMezcla[i,2],;
					cDescriTap)
	      ENDIF
	  ENDFOR

       ENDIF
       RETURN cDescriTap
*>>>>FIN CAMPOS A SUSTITUIR

/*************************************************************************
* TITULO..: CODIGO DE PROMOCION AUTOMATICO. No. 01                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2003 JUE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   NOV 14/2003 JUE

OBJETIVOS:

1- Calcula automaticamente el c¢digo de promoci¢n de acuerdo al
   intervalo de los grados.

2- Retorna el c¢digo de promoci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nAprAut001(nMatPer,cCodNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMatPer                              // Materias Perdidas
       cCodNiv                              // C¢digo del Nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nCodigoTap := 0                // C¢digo de Promoci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL CODIGO DE PROMOCION
       APR->(DBGOTOP())
       DO WHILE .NOT. APR->(EOF())

**********ANALISIS DE LA PROMOCION
	    nCodigoTap := 0
	    DO CASE
	    CASE  APR->lAproboApr .AND. !APR->lHayHabApr .AND.; // (V,F)
		  VAL(cCodNiv) >= VAL(APR->cNivIniApr)   .AND.;
		  VAL(cCodNiv) <= VAL(APR->cNivFinApr)

		  IF nMatPer == APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    CASE  APR->lAproboApr .AND.  APR->lHayHabApr .AND.; // (V,V)
		  VAL(cCodNiv) >= VAL(APR->cNivIniApr)   .AND.;
		  VAL(cCodNiv) <= VAL(APR->cNivFinApr)

		  IF nMatPer >  0  .AND. nMatPer <= APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    CASE !APR->lAproboApr .AND. !APR->lHayHabApr .AND.; // (F,F)
		  VAL(cCodNiv) >= VAL(APR->cNivIniApr)   .AND.;
		  VAL(cCodNiv) <= VAL(APR->cNivFinApr)

		  IF nMatPer >= APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    CASE !APR->lAproboApr .AND.  APR->lHayHabApr .AND.; // (F,V)
		  VAL(cCodNiv) >= VAL(APR->cNivIniApr)   .AND.;
		  VAL(cCodNiv) <= VAL(APR->cNivFinApr)

		  IF nMatPer >  0  .AND. nMatPer <= APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    ENDCASE
	    IF !EMPTY(nCodigoTap)
	       EXIT
	    ENDIF
**********FIN ANALISIS DE LA PROMOCION

	  APR->(DBSKIP())

       ENDDO
       RETURN nCodigoTap
*>>>>FIN CALCULO DEL CODIGO DE PROMOCION

/*************************************************************************
* TITULO..: CODIGO DE PROMOCION AUTOMATICO. No. 02                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2008 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   NOV 12/2008 JUE

OBJETIVOS:

1- Calcula automaticamente el c¢digo de promoci¢n de acuerdo al
   grados establecidos en la configuraci¢n.

2- Retorna el c¢digo de promoci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nAprAut002(nMatPer,cCodNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMatPer                              // Materias Perdidas
       cCodNiv                              // C¢digo del Nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nCodigoTap := 0                // C¢digo de Promoci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL CODIGO DE PROMOCION
       APR->(DBGOTOP())
       DO WHILE .NOT. APR->(EOF())

**********ANALISIS DE LA PROMOCION
	    nCodigoTap := 0
	    DO CASE
	    CASE  APR->lAproboApr .AND. !APR->lHayHabApr .AND.; // (V,F)
		  lIniFinApr(cCodNiv)

		  IF nMatPer == APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    CASE  APR->lAproboApr .AND.  APR->lHayHabApr .AND.; // (V,V)
		  lIniFinApr(cCodNiv)

		  IF nMatPer >  0  .AND. nMatPer <= APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    CASE !APR->lAproboApr .AND. !APR->lHayHabApr .AND.; // (F,F)
		 lIniFinApr(cCodNiv)

		  IF nMatPer >= APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    CASE !APR->lAproboApr .AND.  APR->lHayHabApr .AND.; // (F,V)
		 lIniFinApr(cCodNiv)

		  IF nMatPer >  0  .AND. nMatPer <= APR->nTotJidApr
		     nCodigoTap := APR->nCodigoApr
		  ENDIF

	    ENDCASE
	    IF !EMPTY(nCodigoTap)
	       EXIT
	    ENDIF
**********FIN ANALISIS DE LA PROMOCION

	  APR->(DBSKIP())

       ENDDO
       RETURN nCodigoTap
*>>>>FIN CALCULO DEL CODIGO DE PROMOCION


/*************************************************************************
* TITULO..: VALIDACION DE LOS NIVELES DE PROMOCION                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2003 JUE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   NOV 14/2003 JUE

OBJETIVOS:

1- Valida los niveles de promoci¢n

2- Retorna .F. si no hay problemas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNivApr(nAprAut)

*>>>>DESCRIPCION DE PARAMETROS
/*     nAprAut			            // Promoci¢n Automatica */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nMatPer := 0                   // Materias Perdidas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS NIVELES DE LA PROMOCION
       APR->(DBGOTOP())
       DO WHILE .NOT. APR->(EOF())

	  nMatPer += APR->nTotJidApr

**********ANALISIS DE LA PROMOCION
	    DO CASE
	    CASE nAprAut == 1  // Metodo No.1
		 IF EMPTY(APR->cNivIniApr) .OR. EMPTY(APR->cNivFinApr)
		    lHayErr := .T.
		    EXIT
		 ENDIF

	    CASE nAprAut == 2  // Metodo No.2
		 IF EMPTY(APR->cIniFinApr)
		    lHayErr := .T.
		    EXIT
		 ENDIF
	    ENDCASE
**********FIN ANALISIS DE LA PROMOCION

	  APR->(DBSKIP())

       ENDDO

       IF nMatPer == 0
	  lHayErr := .T.
       ENDIF

       APR->(DBGOTOP())
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LOS NIVELES DE LA PROMOCION

/*************************************************************************
* TITULO..: LOCALIZAR EL NIVEL O GRADO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 12/2008 JUE A
       Colombia, Bucaramanga        INICIO: 11:35 AM   NOV 12/2008 JUE

OBJETIVOS:

1- Buscar el grado dentro de los grados autorizados para aplicar el
   c¢digo de la promoci¢n.

2- Retorna .T. si encontro el grado.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIniFinApr(cCodNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodNiv                              // C¢digo del Nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayNiv := .F.                 // .T. Hay Nivel
       LOCAL       i := 1                   // Contador
       LOCAL cCodigo := ''                  // Codigo del Grado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL GRADO
       lHayNiv := .F.
       FOR i := 1 TO LEN(ALLTRIM(APR->cIniFinApr))/2
	   cCodigo := SUBS(APR->cIniFinApr,i*2-1,2)
	   IF cCodNiv == cCodigo
	      lHayNiv := .T.
	   ENDIF
       ENDFOR
       RETURN lHayNiv
*>>>>FIN BUSQUEDA DEL GRADO

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION CAMPOS DEL MANTENIMIENTO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/97 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 02/97 MAR

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTblApr(lShared,cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "\EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CONT.PRG"      // Variables del sistema

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
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF APR->(RECCOUNT()) == 0
	  cError('NO EXISTEN LOS CODIGOS DE LAS PROMOCIONES')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DE ?
       DO CASE
       CASE cMaeAct = 'JAR'
	    cTxtPrn := 'JARDIN'
       CASE cMaeAct = 'PRI'
	    cTxtPrn := 'PRIMARIA'
       CASE cMaeAct = 'BTO'
	    cTxtPrn := 'BACHILLERATO'
       ENDCASE
*>>>>FIN ANALISIS DE ?

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := APR->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'TABLA DE PROMOCION PARA '+cTxtPrn+' DE '+;
		   cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,110,10,10,02,02,02}
       aTitulo := {'CODIGO',;
		   'OBSERVACION PARA EL LIBRO FINAL',;
		   'PROMOVIDO','RECUPERA','MP','NI','NF'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Wide
       lCentra := .F.
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

*>>>>ACTIVACION DE LA IMPRESORA
       ActivaPrn(lShared,cNomSis,PathSis,fSimaCo,'cColaAcCon','Con')
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

       SELECT APR
       GO TOP
       DO WHILE .NOT. APR->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( APR->(RECNO()) / APR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aNroLin := aDivLin(ALLTRIM(APR->cDescriApr),110)
	    FOR i := 1 TO LEN(aNroLin)

		aTitulo := {}
		aNroCol := {}

		IF i == 1
		   AADD(aTitulo,STR(APR->nCodigoApr,2))
		   AADD(aNroCol,06)

		   AADD(aTitulo,SUBS(aNroLin[i]+SPACE(110),1,110))
		   AADD(aNroCol,110)

		   AADD(aTitulo,IF(APR->lAproboApr,'SI','NO'))
		   AADD(aNroCol,10)

		   AADD(aTitulo,IF(APR->lHayHabApr,'SI','NO'))
		   AADD(aNroCol,10)

		   AADD(aTitulo,STR(APR->nTotJidApr,2))
		   AADD(aNroCol,02)

		   AADD(aTitulo,APR->cNivIniApr)
		   AADD(aNroCol,02)

		   AADD(aTitulo,APR->cNivFinApr)
		   AADD(aNroCol,02)

		ELSE

		   AADD(aTitulo,'')
		   AADD(aNroCol,06)

		   AADD(aTitulo,SUBS(aNroLin[i]+SPACE(110),1,110))
		   AADD(aNroCol,110)

		   AADD(aTitulo,'')
		   AADD(aNroCol,10)

		   AADD(aTitulo,'')
		   AADD(aNroCol,10)

		   AADD(aTitulo,'')
		   AADD(aNroCol,02)

		   AADD(aTitulo,'')
		   AADD(aNroCol,02)

		   AADD(aTitulo,'')
		   AADD(aNroCol,02)

		ENDIF

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    NEXT
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT APR
	    APR->(DBSKIP())
	    IF APR->(EOF())
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