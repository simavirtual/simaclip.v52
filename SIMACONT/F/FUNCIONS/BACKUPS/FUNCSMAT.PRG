/*                    SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO MATERIAS

REQUERIMIENTOS:

- Compilar: clipper FuncsMat /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo Materias

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:40 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo Materias

2)- Retorna NIL

SINTAXIS:

   CreaDbfMat(PathMat,FileMat,fNtxMat)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfMat(lShared,PathMat,FileMat,lIntUno,fNtxMat,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       PathMat				    // Path del Archivo
       FileMat				    // Nombre del Archivo
       lIntUno                              // Sistema Integrado
       fNtxMat				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfMat := {{"cCodigoMat","Character",04,0},;
			 {"cNombreMat","Character",80,0},; // Nombre de la Materia (30)
			 {"cTituloMat","Character",08,0},; // Alias de la Materia
			 {"cNomAulMat","Character",20,0},; // Nombre del Aula Virtual
			 {"cTipMatMat","Character",01,0},; // Tipo Materia o Area
			 {"cCodigoPro","Character",06,0},; // Codigo del Profesor que dicta la materia para todos los niveles
			 {"nMatVarMat","Numeric"  ,01,0},; // 0=> Materia Fija 1=>Materia Variable por Nivel 2=>Materia Variable por Grupo. Ej: Como Ludicas
			 {"lMatSelMat","Logical"  ,01,0},; // .T. Materia Selectiva
			 {"lPrnVarMat","Logical"  ,01,0},; // .T. Imprimir la Materia Variable
			 {"lModaliMat","Logical"  ,01,0},; // .T. Modalidad .F. No Modalidad
			 {"lPorNivMat","Logical"  ,01,0},; // .T. Materia Selectiva por Nivel
			 {"lNoRecuMat","Logical"  ,01,0},; // .T. Materia NO Recuperable .F. Materia SI Recuperables
			 {"lJvfCalMat","Logical"  ,01,0},; // .F. Calcula el Juicio Valorativo .T. No Calcula el Juicio Valorativo
			 {"cJvfCalMat","Character",15,0},; // Juicio Valorativo Calculado. Tres digitos por periodo. 101 =>1:Clase 01:Metodo
			 {"nNroOrdMat","Numeric"  ,01,0},; // Orden de la Materia
			 {"lHayAnoMat","Logical"  ,01,0},; // .T. La materia se utiliza en el a¤o.
			 {"lCertifMat","Logical"  ,01,0},; // .T. Entra en el certificado de notas
			 {"cMatIndMat","Character",04,0}}  // C¢digo de la Materia para traslado de indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfMat
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathMat) == 0
	    DBCREATE(FileMat,aDbfMat,"DBFNTX")

       CASE DIRCHANGE(PathMat) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathMat)

       CASE DIRCHANGE(PathMat) == -5
	    cError('NO TIENE DERECHOS EN: '+PathMat)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:45 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo de Materias

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfMat(lShared,PathMat,FileMat,lIntUno,fNtxMat)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       PathMat				    // Path del Archivo
       FileMat				    // Nombre del Archivo
       lIntUno                              // Sistema Integrado
       fNtxMat				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathMat+'\'+FileMat,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE MATERIAS")
       Termometro(100)
       CreaDbfMat(lShared,PathMat,FileMat,lIntUno,fNtxMat)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 04/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 04/99 JUE

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

FUNCTION nActStrMat(lShared,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'MAT',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE MATERIAS')
	  CloseDbf('MAT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := MAT->(DBSTRUCT())
       CloseDbf('MAT')
       CreaDbfMat(lShared,PathArc,cNomArc,,,@aStrNew)
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
	  cError('El Archivo MATERIAS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfMat(lShared,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: VECTOR DE LA ESTRUCTURA                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 10/2008 MIE A
       Colombia, Bucaramanga        INICIO:  02:45 PM  SEP 10/2008 MIE

OBJETIVOS:

1- Crea para accesar todos los campos de la tabla

2- Debe estar en uso el archivo

3- Retorna el vector

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aArrStrMat(cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo del Campo
       LOCAL cCampos := ''                  // Campo de la Tabla
       LOCAL aCampos := {}                  // Campos de la Tabla
       LOCAL aStrDbf := {'1'}               // Estructura de la Tabla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS DE LA TABLA
       cNalias := IF(EMPTY(cNalias),'MAT',cNalias)
       CreaDbfMat(,,,,,@aStrDbf)
       FOR i := 1 TO LEN(aStrDbf)

	   cCampos := aStrDbf[i,1]
	   DO CASE
	   CASE cCampos == 'cCodigoMat'
		cCodigo := 'cCodMat'

	   CASE cCampos == 'cCodigoPro'
		cCodigo := 'cCodPro'
	   OTHERWISE
		DO CASE
		CASE LEN(cCampos) == 10
		     cCodigo := SUBS(cCampos,1,7)
		CASE LEN(cCampos) == 9
		     cCodigo := SUBS(cCampos,1,7)
		OTHERWISE
		     cCodigo := 'Err'
		     cError('EL CAMPO '+cCampos+' '+;
			    'NO CUMPLE LA NORMA DEL NOMBRE')
		ENDCASE
	   ENDCASE

	   AADD(aCampos,{cCodigo,&(cNalias+'->'+cCampos)})

       ENDFOR
       RETURN aCampos
*>>>>FIN CAMPOS DE LA TABLA

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO                   	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   MAY 10/95 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Verifica la existencia del c¢digo

3- Deja el archivo en el registro del c¢digo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lMatVarMat(cCodMat,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodMat				    // C¢digo de la Materia
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodMat)
	  IF lMensaj
	     cError('LA MATERIA '+cCodMat,' NO EXISTE. NO ES VARIABLE')
	  ENDIF
	  RETURN .NOT. lExiste
       ELSE
	  IF .NOT. MAT->lMatSelMat
	     RETURN .NOT. lExiste
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>LOCALIZACION DE LA MATERIA PRINCIPAL
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       IF .NOT. MAT->lPorNivMat

	  SELECT MAT
	  GO TOP
	  LOCATE FOR SUBS(MAT->cCodigoMat,1,2) == SUBS(cCodMat,1,2) .AND.;
		     MAT->nMatVarMat # 0
	  IF .NOT. FOUND()
	     IF lMensaj
		cError('LA MATERIA '+cCodMat,' NO ES VARIABLE')
	     ENDIF
	     lExiste := .F.
	  ENDIF
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DE LA MATERIA PRINCIPAL

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 10:33 AM   MAY 10/95 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

2- Se debe pasar el directorio completo de archivo

3- Retorn NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenMat(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivo Grupos

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cPatTem := ''                  // Path Temporal
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
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS DE MATERIAS EN '+cPatSis)
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
       SELECT MAT

       oBrowse := oDefBrwMat(lShared,cAnoUsr,cPatSis,cMaeAct,;
			     nFilPal+1,00,22,79,cMaeAct,;
			    'AREAS DE CONOCIMIENTO PARA')
       SETKEY(K_F5,{||BuscarMat(oBrowse)})

       SETKEY(K_F9,{||MenuOtrMat(aParam1,aParam2,aParam3,oBrowse)})

       MAT->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE          	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 10:40 AM   MAY 10/95 MIE

OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwMat(lShared,cAnoUsr,cPatSis,cMaeAct,nFilSup,nColSup,;
		    nFilInf,nColInf,cNalias,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNalias                              // Alias del Maestro
       cTitulo                              // T¡tulo del Browse */
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
       CASE cNalias == 'JAR'
	    cNomNiv := 'JARDIN'
       CASE cNalias == 'PRI'
	    cNomNiv := 'PRIMARIA'
       CASE cNalias == 'BTO'
	    cNomNiv := 'BACHILLERATO'
       ENDCASE

       cTitulo := IF(cTitulo == NIL,'MANTENIMIENTO DE MATERIAS DE',cTitulo)
       oBrowse:Cargo := {'<<'+cTitulo+' '+cNomNiv+' >>',;
			 '<INS>Incluir <DEL>Borrar <F5>Buscar <F9>Imprimir '+;
			 '<ESC>Abandonar',;
			 {||IncluirMat(lShared,cAnoUsr,cPatSis,cMaeAct)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT MAT
       
       oColumn	     := TBCOLUMNNEW('CODIGO', {||MAT->cCodigoMat})
       IF SCO->lModPlaCon
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','cCodigoMat'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 1
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('AREA O MATERIA',;
				   {||IIF(SUBS(MAT->cCodigoMat,3,2) == '00',;
					       MAT->cNombreMat+SPACE(02),;
					       SPACE(02)+MAT->cNombreMat)})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','cNombreMat'},;
			 {'PICTURE','@S76!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TITULO', {||MAT->cTituloMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','cTituloMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('AULA VIRTUAL', {||MAT->cNomAulMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','cNomAulMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VARIABLE', {||MAT->nMatVarMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','nMatVarMat'},;
			 {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR', {||MAT->lPrnVarMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lPrnVarMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CLASE',;
				    {||IF(SUBS(MAT->cCodigoMat,3,2)=='00',;
					 'AREA',;
					 IF(MAT->nMatVarMat==0,;
					   'MATERIA FIJA',;
					   IF(MAT->nMatVarMat=1,;
					      'VARIABLE X NIVEL',;
					      'VARIABLE X GRUPO')))})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width  := 17
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SELECTIVA', {||MAT->lMatSelMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lMatSelMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO', {||MAT->cCodigoPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','cCodigoPro'},;
			 {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('PROFESOR',{||cSekNomPro(MAT->cCodigoPro,'MAT')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 51
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA TRASLADO;DE LOS INDICADORES',;
				    {||MAT->cMatIndMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','cMatIndMat'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MODALIDAD', {||MAT->lModaliMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lModaliMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA POR NIVEL', {||MAT->lPorNivMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lPorNivMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA NO RECUPERABLE', {||MAT->lNoRecuMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lNoRecuMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('F=SI T=NO CALCULAR;JUICIO VALORATIVO',;
				   {||MAT->lJvfCalMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lJvfCalMat'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JUICIO VALORATIVO;CALCULADO', {||MAT->cJvfCalMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','GRU'},{'FIELD','cJvfCalMat'},;
			 {'PICTURE','999999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA UTILIZADA',{||MAT->lHayAnoMat})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ENTRA AL;CERTIFICADO', {||MAT->lCertifMat})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MAT'},{'FIELD','lCertifMat'},;
			 {'PICTURE','@!'}}
       oColumn:Picture := "@!"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 10:50 AM   MAY 10/95 MIE

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirMat(lShared,cAnoUsr,cPatSis,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cTituloTma := ''               // T¡tulo de la materia
       LOCAL cTipMatTma := ''               // Tipo de materia
       LOCAL nMatVarTma := 0                // Materia Variable
       LOCAL lPrnVarTma := .F.              // .T. Imprimir Materia Variable
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA DE LAS MATERIAS DEL A¥O ANTERIOR
       IF MAT->(RECCOUNT()) == 0
	  IF lLeeMatAnt(lShared,cAnoUsr,cPatSis,cMaeAct)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DE LAS MATERIAS DEL A¥O ANTERIOR

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL MATERIA',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTma := cSpaField('MAT','cCodigoMat')
	       cNombreTma := cSpaField('MAT','cNombreMat')
	       cTituloTma := cSpaField('MAT','cTituloMat')
	       cTipMatTma := SPACE(01)
	       nMatVarTma := 0
	       lPrnVarTma := .F.
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DE LA MATERIA:';
				GET cCodigoTma PICT '9999';
				VALID !lValCodMat(cCodigoTma)

	    @ nNroFil+1,nNroCol SAY 'NOMBRE DE LA MATERIA:';
				GET cNombreTma PICT '@!'

	    @ nNroFil+2,nNroCol SAY 'TITULO DE LA MATERIA:';
				GET cTituloTma PICT '@!'

	    @ nNroFil+3,nNroCol SAY 'TIPO DE LA MATERIA  :';
				GET cTipMatTma PICT '@!';
				VALID lValTipMat(ROW(),COL()-1,@cTipMatTma)
	    READ

	    nMatVarTma := 0
	    IF cTipMatTma == 'M'
	       @ nNroFil+4,nNroCol SAY 'CLASE DE LA MATERIA :';
				   GET nMatVarTma PICT '9';
				   VALID lValVarMat(ROW(),COL()-1,@nMatVarTma)
	       READ
	    ENDIF

	    lPrnVarTma := .F.
	    IF nMatVarTma # 0
	       @ nNroFil+5,nNroCol SAY 'IMPRIMIR LA MATERIA :';
				   GET lPrnVarTma PICT '@!'
	       READ
	    ENDIF
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cCodigoTma == cSpaField('MAT','cCodigoMat') .OR.;
		 cNombreTma == cSpaField('MAT','cNombreMat') .OR.;
		 cTituloTma == cSpaField('MAT','cTituloMat') .OR.;
		 cTipMatTma == SPACE(01)

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
       SELECT MAT
       IF lGrabar
	  IF MAT->(lRegLock(lShared,.T.))
	     REPL MAT->cCodigoMat WITH IF(cTipMatTma == 'A',;
					  SUBS(cCodigoTma,1,2)+'00',;
					  cCodigoTma)
	     REPL MAT->cNombreMat WITH cNombreTma
	     REPL MAT->cTituloMat WITH cTituloTma
	     REPL MAT->cTipMatMat WITH cTipMatTma
	     REPL MAT->nMatVarMat WITH nMatVarTma
	     REPL MAT->lPrnVarMat WITH lPrnVarTma
	     REPL MAT->lMatSelMat WITH .F.
	     MAT->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  MAT->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 11:55 AM   MAY 10/95 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodMat(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('cCodigoMat','MAT',cCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO EN EL BROWSE                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/95 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 10/95 MIE

OBJETIVOS:

1- Localiza el c¢digo dentro del Browse del archivo

2- Retorna NIL

SINTAXIS:

  BuscarMat(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarMat(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse de Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTma := cSpaField('MAT','cCodigoMat')
       TitBuscar(LEN(cCodigoTma),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTma PICT '9999';
			 VALID lValMateria(ROW(),COL()-4,@cCodigoTma)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTma == cSpaField('MAT','cCodigoMat')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT MAT
       IF lBuscar .AND. lLocCodigo('cCodigoMat','MAT',cCodigoTma)
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
* TITULO DE LA FUNCION..: VALIDACION DEL TIPO DE MATERIA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/95 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   MAY 11/95 JUE

OBJETIVOS:

1- Realiza la validaci¢n del c¢digo

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTipMat(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<AREA   >',;
		  '2<MATERIA>'}

       aAyudas := {'Area',;
		   'Materia'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # 'A' .AND. cCodigo # 'M'

	  SAVE SCREEN
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTORE SCREEN

	  IF nNroOpc == 0
	     cCodigo := cSpaField('MAT','cTipMatMat')
	  ELSE
	     cCodigo := SUBS('AM',nNroOpc,1)
	  ENDIF

       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA MATERIA VARIABLE             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 01:10 PM   MAR 06/98 VIE

OBJETIVOS:

1- Realiza la validaci¢n del c¢digo

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValVarMat(nNroFil,nNroCol,nMatVar)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Materia Variable */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<FIJA     >',;
		  '2<POR NIVEL>',;
		  '3<POR GRUPO>'}

       aAyudas := {'Materia Fija',;
		   'Variable Por Nivel',;
		   'Variable Por Grupo'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       DO WHILE .T.

	  SAVE SCREEN
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTORE SCREEN

	  DO CASE
	  CASE nNroOpc == 0
	       LOOP
	  CASE nNroOpc == 1
	       nMatVar := 0
	  CASE nNroOpc == 2
	       nMatVar := 1
	  OTHERWISE
	       nMatVar := 2
	  ENDCASE

	  EXIT

       ENDDO
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DEL PROGRAMA..: LOCALIZAR LA MATERIA VARIABLE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 09/98 LUN A
       Colombia, Bucaramanga        INICIO: 12:50 AM   MAR 09/98 LUN

OBJETIVOS:

1- Deben estar en uso el archivo de materias

2- Permite localizar el c¢digo de la materia variable

3- Se debe pasar el Alias del Archivo del Browse

4- Retorna .T. si la Materia es Variable

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocMatVar(cCodigo,cAlias)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				      // C¢digo de b£squeda
       cAlias                                 // Alias diferente al maestro*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lMatVarTma := .F.               // .T. Materia Variable
*>>>>DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CODIGO
       IF lLocCodigo('cCodigoMat','MAT',cCodigo)
	  IF MAT->nMatVarMat # 0
	     lMatVarTma := .T.
	  ENDIF
       ENDIF

       IF cAlias # NIL
	  SELECT &cAlias
       ENDIF
       RETURN lMatVarTma
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: LEE LAS MATERIAS DEL A¥O ANTERIOR                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 22/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:05 AM   MAR 22/2002 VIE

OBJETIVOS:

1- Deben estar en uso el archivo de materias

2- Permite localizar el c¢digo de la materia variable

3- Se debe pasar el Alias del Archivo del Browse

4- Retorna .T. si la Materia es Variable

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeMatAnt(lShared,cAnoUsr,cPatSis,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatAnt+'\'+cMaeAct+'\'+FileMat)
	  RETURN .T.
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA INSERTAR LAS ASIGNATURAS DEL A¥O ANTERIOR? Si No')
	  RETURN .F.
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatAnt+'\'+cMaeAct+'\'+FileMat,'TEM',NIL,lShared)
	  cError('NO EXISTEN ASIGNATURAS PARA EL A¥O ANTERIOR')
	  CloseDbf('TEM')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR
       SELECT TEM
       GO TOP
       DO WHILE .NOT. TEM->(EOF())

**********GRABACION DEL REGISTRO
	    IF MAT->(lRegLock(lShared,.T.))
	       REPL MAT->cCodigoMat WITH TEM->cCodigoMat
	       REPL MAT->cNombreMat WITH TEM->cNombreMat
	       REPL MAT->cTituloMat WITH TEM->cTituloMat
	       REPL MAT->cNomAulMat WITH TEM->cNomAulMat
	       REPL MAT->cTipMatMat WITH TEM->cTipMatMat
	       REPL MAT->cCodigoPro WITH TEM->cCodigoPro
	       REPL MAT->nMatVarMat WITH TEM->nMatVarMat
	       REPL MAT->lMatSelMat WITH TEM->lMatSelMat
	       REPL MAT->lPrnVarMat WITH TEM->lPrnVarMat
	       REPL MAT->lModaliMat WITH TEM->lModaliMat
	       REPL MAT->lPorNivMat WITH TEM->lPorNivMat
	       REPL MAT->lNoRecuMat WITH TEM->lNoRecuMat
	       REPL MAT->nNroOrdMat WITH TEM->nNroOrdMat
	       MAT->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       MAT->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  SELECT TEM
	  SKIP

       ENDDO
       RETURN .T.
*>>>>FIN LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV  3/2004 MIE A
       Colombia, Bucaramanga        INICIO:  3:22 PM   NOV  3/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrMat(aParam1,aParam2,aParam3,;
		    oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<AREAS DE CONOCIMIENTO>')
       AADD(aMenus,'2<TRASLADO INDICADORES >')
       AADD(aMenus,'3<POR PROFESORES       >')

       aAyuda := {}
       AADD(aAyuda,'Imprime las Areas de Conocimiento')
       AADD(aAyuda,'Imprime la autorizaci¢n del traslado de indicadores')
       AADD(aAyuda,'Imprime los Profesores que dictan')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'MENU OTROS',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
          RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    PrnMateria(lShared,cNomEmp,cNomSis,cNomUsr,;
		       cAnoUsr,cPatSis,cMaeAct,cJorTxt)

       CASE nNroOpc == 2
	    CopyIndMat(lShared,cNomEmp,cNomSis,cNomUsr,;
		       cAnoUsr,cPatSis,cMaeAct,cJorTxt)

       CASE nNroOpc == 3
	    PrnMatProf(lShared,cNomEmp,cNomSis,cNomUsr,;
		       cAnoUsr,cPatSis,cMaeAct,cJorTxt)

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LAS AREAS DE CONOCIMIENTO         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 04/97 MAR A
       Colombia, Bucaramanga        INICIO: 11:50 AM   FEB 04/97 MAR

OBJETIVOS:

1- Imprime las areas de conocimiento.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnMateria(lShared,cNomEmp,cNomSis,cNomUsr,;
		    cAnoUsr,cPatSis,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF MAT->(RECCOUNT()) == 0
	  cError('NO EXISTEN AREAS O MATERIAS GRABADAS')
	  RETURN NIL
       ENDIF
       lHayMatAno(lShared,nModCry,cAnoUsr,cPatSis,cMaeAct)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := MAT->(RECCOUNT())+nLinTot

       aCabeza := {cNomEmp,cNomSis,;
		   'AREAS DE CONOCIMIENTO A¥O:'+cAnoUsr+' '+;
		   cMaeAct+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,82,16,08,12}
       aTitulo := {'CODIGO',;
		   'NOMBRE DEL AREA O MATERIA',;
		   'TIPO',;
		   'TITULO',;
		   'OBSERVACION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'materias'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL PLAN ACADEMICO
       SELECT MAT
       GO TOP
       DO WHILE .NOT. MAT->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MAT->(RECNO()) / MAT->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aTitulo := {IF(MAT->lHayAnoMat,'','X ')+MAT->cCodigoMat,;
			IF(SUBS(MAT->cCodigoMat,3,2) = '00',;
			   MAT->cNombreMat+SPACE(02),;
			   SPACE(02)+MAT->cNombreMat),;
			IF(SUBS(MAT->cCodigoMat,3,2) == '00',;
			   'AREA',;
			    IF(MAT->nMatVarMat==0,;
			      'MATERIA',;
			      IF(MAT->nMatVarMat==1,;
			      'VARIABLE X NIVEL',;
			      'VARIABLE X GRUPO'))),;
			MAT->cTituloMat,;
			IF(MAT->lHayAnoMat,'','NO SE DICTA')}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT MAT
	    MAT->(DBSKIP())
	    IF MAT->(EOF())
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
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: TRASLADO DE INDICADORES                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 04/97 MAR A
       Colombia, Bucaramanga        INICIO: 11:50 AM   FEB 04/97 MAR

OBJETIVOS:

1- Imprime las areas de conocimiento.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CopyIndMat(lShared,cNomEmp,cNomSis,cNomUsr,;
		    cAnoUsr,cPatSis,cMaeAct,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del Sistema
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior
       LOCAL cObserv := ''                  // Observaci¢n
       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF MAT->(RECCOUNT()) == 0
	  cError('NO EXISTEN AREAS O MATERIAS GRABADAS')
	  RETURN NIL
       ENDIF
       lHayMatAno(lShared,nModCry,cAnoUsr,cPatSis,cMaeAct)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatAnt+'\'+cMaeAct+'\'+FileMat)
	  cError('NO EXISTEN MATERIAS DEL A¥O ANTERIOR')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatAnt+'\'+cMaeAct+'\'+FileMat,'TEM',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE MATERIAS DEL A¥O ANTERIOR')
	  CloseDbf('TEM')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TEM->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('TEM')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := MAT->(RECCOUNT())+nLinTot

       aCabeza := {cNomEmp,cNomSis,;
		   'AREAS DE CONOCIMIENTO A¥O:'+cAnoUsr+' '+;
		   cMaeAct+' JORNADA: '+cJorTxt,;
		   'AUTORIZACION DE TRASLADO DE INDICADORES',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,82,50}
       aTitulo := {'CODIGO',;
		   'NOMBRE DEL AREA O MATERIA',;
		   'AREA O MATERIA A TRASLDAR'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'CopyInd'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL PLAN ACADEMICO
       SELECT MAT
       GO TOP
       DO WHILE .NOT. MAT->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MAT->(RECNO()) / MAT->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********AVANCE DEL SIGUIENTE REGISTRO
	    IF .NOT. MAT->lHayAnoMat
	       SELECT MAT
	       MAT->(DBSKIP())
	       IF MAT->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********LOCALIZACION DE LA MATERIA
	    IF !EMPTY(MAT->cMatIndMat)

	       IF lLocCodigo('cCodigoMat','TEM',MAT->cMatIndMat)

		  IF MAT->cCodigoMat == TEM->cCodigoMat .AND.;
		     ALLTRIM(MAT->cNombreMat) == ALLTRIM(TEM->cNombreMat)
		     cObserv := 'SI TRASLADAR'
		  ELSE
		     cObserv := MAT->cMatIndMat+' '+;
				ALLTRIM(TEM->cNombreMat)
		  ENDIF

	       ELSE
		  cObserv := 'ERROR '+MAT->cMatIndMat+' '+;
			     'MATERIA NO EXISTE'
	       ENDIF
	    ELSE
		IF SUBS(MAT->cCodigoMat,3,2) == '00'
		   cObserv := ''
		ELSE
		   cObserv := 'NO TRASLADAR'
		ENDIF
	    ENDIF
	    cObserv := SUBS(cObserv+SPACE(50),1,50)
**********FIN LOCALIZACION DE LA MATERIA

**********IMPRESION DEL REGISTRO
	    aTitulo := {MAT->cCodigoMat,;
			IF(SUBS(MAT->cCodigoMat,3,2) = '00',;
			   MAT->cNombreMat+SPACE(02),;
			   SPACE(02)+MAT->cNombreMat),;
			cObserv}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT MAT
	    MAT->(DBSKIP())
	    IF MAT->(EOF())
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
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALIDACION SI LA MATERIA SE UTILIZA                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2007 JUE A
       Colombia, Bucaramanga        INICIO: 03:20 AM   MAR 01/2007 JUE

OBJETIVOS:

1- Verifica si la materia se utiliza en cualquier plan academica.

4- Retorna .T. si la Materia es Variable

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHayMatAno(lShared,nModCry,cAnoUsr,cPatSis,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro habilitado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema

       LOCAL lHayAnoTma := .F.              // .T. La materia se utiliza en el a¤o.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuN,'SUN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuG,'SUG',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('NIV')
	  CloseDbf('GRU')
	  CloseDbf('SUN')
	  CloseDbf('SUG')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>RECORRIDO POR MATERIAS
       SELECT MAT
       MAT->(DBGOTOP())
       DO WHILE .NOT. MAT->(EOF())

***********LOCALIZACION DE LA MATERIA
	     lHayAnoTma := lLocCodigo('cCodigoMat','SUN',MAT->cCodigoMat)
	     IF .NOT. lHayAnoTma
		lHayAnoTma := lLocCodigo('cCodigoMat','SUG',MAT->cCodigoMat)
	     ENDIF
***********FIN LOCALIZACION DE LA MATERIA

***********RECORRIDO POR NIVELES
	     IF .NOT. lHayAnoTma

		SELECT NIV
		NIV->(DBGOTOP())
		DO WHILE .NOT. NIV->(EOF())

*==================PLAN DE ESTUDIOS POR GRUPOS
		     IF NIV->lPlaGruNiv

*-----------------------FILTRACION DEL DEL ARCHIVO
			  SELECT GRU
			  SET FILTER TO SUBS(GRU->cCodigoGru,1,2) == NIV->cCodigoNiv
			  GRU->(DBGOTOP())

			  IF GRU->(EOF())
			     cError('NO EXISTEN GRUPOS PARA EL NIVEL '+;
				    NIV->cCodigoNiv)

			     GRU->(DBCLEARFILTER())
			     CloseDbf('NIV')
			     CloseDbf('GRU')
			     CloseDbf('SUN')
			     CloseDbf('SUG')
			     RETURN NIL
			  ENDIF
*-----------------------FIN FILTRACION DEL DEL ARCHIVO

*-----------------------RECORRIDO POR GRUPOS
			  SELECT GRU
			  GRU->(DBGOTOP())
			  DO WHILE .NOT. GRU->(EOF())

			     FilePla := 'PL'+GRU->cCodigoGru+cAnoSis+ExtFile

*::::::::::::::::::::::::::::SELECION DE LAS AREAS DE TRABAJO
			       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
					       FilePla,'PLA',NIL,lShared)
				  cError('ABRIENDO ARCHIVO DE PLAN ACADEMICO')
				  CloseDbf('NIV')
				  CloseDbf('GRU')
				  CloseDbf('SUN')
				  CloseDbf('SUG')
				  RETURN NIL
			       ENDIF
*::::::::::::::::::::::::::::FIN SELECION DE LAS AREAS DE TRABAJO

*::::::::::::::::::::::::::::LOCALIZACION DE LA MATERIA
			       lHayAnoTma := lLocCodigo('cCodigoMat','PLA',;
							 MAT->cCodigoMat)
			       IF lHayAnoTma
				  EXIT
			       ENDIF
*::::::::::::::::::::::::::::FIN LOCALIZACION DE LA MATERIA

			     SELECT GRU
			     GRU->(DBSKIP())

			  ENDDO
*-----------------------FIN RECORRIDO POR GRUPOS

		     ENDIF
*==================FIN PLAN DE ESTUDIOS POR GRUPOS

*==================PLAN DE ESTUDIOS POR NIVELES
		     IF .NOT. NIV->lPlaGruNiv

			FilePla := 'PLAN'+NIV->cCodigoNiv+cAnoSis+ExtFile

*-----------------------SELECION DE LAS AREAS DE TRABAJO
			  IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
					  FilePla,'PLA',NIL,lShared)
			     cError('ABRIENDO ARCHIVO DE PLAN ACADEMICO')
			     CloseDbf('NIV')
			     CloseDbf('GRU')
			     CloseDbf('SUN')
			     CloseDbf('SUG')
			     RETURN NIL
			  ENDIF
*-----------------------FIN SELECION DE LAS AREAS DE TRABAJO

*-----------------------LOCALIZACION DE LA MATERIA
			  lHayAnoTma := lLocCodigo('cCodigoMat','PLA',;
						    MAT->cCodigoMat)
			  IF lHayAnoTma
			     EXIT
			  ENDIF
*-----------------------FIN LOCALIZACION DE LA MATERIA

		     ENDIF
*==================FIN PLAN DE ESTUDIOS POR NIVELES

		   SELECT NIV
		   NIV->(DBSKIP())

		ENDDO

	     ENDIF
***********FIN RECORRIDO POR NIVELES

***********GRABACION DEL REGISTRO
	     IF MAT->(lRegLock(lShared,.F.))
		REPL MAT->lHayAnoMat WITH lHayAnoTma
		MAT->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABA EL REGISTRO')
	     ENDIF

	     IF lShared
		MAT->(DBUNLOCK())
	     ENDIF
***********FIN GRABACION DEL REGISTRO

	   SELECT MAT
	   MAT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR MATERIAS

/*************************************************************************
* TITULO..: PROFESOR QUE DICTA LA MATERIA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2000 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAY 19/2000 VIE

OBJETIVOS:

1- Permite conocer el c¢digo y nombre del profesor que dicta la materia

2- Retorna el C¢digo del Profesor

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodProMat(cCodEst,cCodGru,nNroBis,cCodMat,cNomMat,cNomPro,cApePro)

*>>>>DECLARACION DE VARIABLES
/*     cCodEst                              // C¢digo de la materia
       cCodGru                              // C¢digo del Grupo
       nNroBis                              // N£mero del Bimestre
       cCodMat                              // @C¢digo de la Materia
       cNomMat                              // @Nombre de la Materia
       cNomPro                              // @Nombre del Profesor
       cApePro                              // @Apellido del Profesor */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL nMatVar := 0                   // Materia Variable
       LOCAL cCodPro := SPACE(06)           // C¢digo del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO DEL PROFESOR
       nMatVar := nMatSelEst(cCodEst,nNroBis,@cCodMat,@cNomMat)
       DO CASE
       CASE nMatVar == 0   // Materia Fija
	    SELECT PLA
	    IF lLocCodigo('cCodigoMat','PLA',cCodMat)
	       cCodPro := &("PLA->cPr"+cCodGru+"Pla")
	    ENDIF

       CASE nMatVar == 1   // Materia Variable por Nivel
	    SELECT SUN
	    GO TOP
	    LOCATE FOR SUN->cCodigoNiv == SUBS(cCodGru,1,2) .AND.;
		       SUN->cCodigoMat == cCodMat
	    IF FOUND()
	       IF SUN->lPorNivSuN
		  cCodPro := SUN->cCodigoPro
		 *Variable por Nivel
	       ELSE
		  IF lLocCodigo('cCodigoMat','MAT',cCodMat)
		     cCodPro := MAT->cCodigoPro
		    *Variable por Niveles
		  ENDIF
	       ENDIF
	    ENDIF

       CASE nMatVar == 2   // Materia Variable por Grupo
	    SELECT SUG
	    GO TOP
	    LOCATE FOR SUG->cCodigoGru == cCodGru .AND.;
		       SUG->cCodigoMat == cCodMat
	    IF FOUND()
	       cCodPro := SUG->cCodigoPro
	    ENDIF

       ENDCASE
*>>>>FIN LOCALIZACION DEL CODIGO DEL PROFESOR

*>>>>LOCALIZACION DEL NOMBRE DEL PROFESOR
       IF .NOT. EMPTY(cCodPro)
	  IF lLocCodigo('cCodigoPro','PRO',cCodPro)
	     cNomPro := PRO->cNombrePro
	     cApePro := PRO->cApelliPro
	  ENDIF
       ENDIF
       RETURN cCodPro
*>>>>FIN LOCALIZACION DEL NOMBRE DEL PROFESOR

/*************************************************************************
* TITULO..: AREAS DE CONOCIMIENTO CON PROFESORES                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/2008 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   OCT 30/2008 JUE

OBJETIVOS:

1- Imprime las areas de conocimiento con los profesores

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnMatProf(lShared,cNomEmp,cNomSis,cNomUsr,;
		    cAnoUsr,cPatSis,cMaeAct,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL   i,j,k := 0                   // Contador

       LOCAL aProfes := {}                  // Profesores

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroLin := ''                  // N£mero de l¡neas
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(1)
       cCodigoTma := cSpaField('MAT','cCodigoMat')
       TitBuscar(LEN(cCodigoTma),@nNroFil,@nNroCol,'CODIGO MATERIA:')
       @ nNroFil,nNroCol GET cCodigoTma PICT '9999';
			 VALID lValMateria(ROW(),COL()-4,@cCodigoTma);
			 WHEN {||HelpRead('<ESC> SELECCIONA TODAS '+;
					  'LAS AREAS Y MATERIAS')}
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF !EMPTY(cCodigoTma) .AND.;
	  !lPregunta('ESCOGIO:'+ALLTRIM(MAT->cNombreMat)+'.'+;
		     'DESEA CONTINAR?Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CONTENIDO
       IF MAT->(RECCOUNT()) == 0
	  cError('NO EXISTEN AREAS O MATERIAS GRABADAS')
	  RETURN NIL
       ENDIF
       lHayMatAno(lShared,nModCry,cAnoUsr,cPatSis,cMaeAct)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := MAT->(RECCOUNT())+nLinTot

       aCabeza := {cNomEmp,cNomSis,;
		   'AREAS DE CONOCIMIENTO A¥O:'+cAnoUsr+' '+;
		   cMaeAct+' JORNADA: '+cJorTxt,;
		   'POR PROFESOR',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,82,16,08,12}
       aTitulo := {'CODIGO',;
		   'NOMBRE DEL AREA O MATERIA',;
		   'TIPO',;
		   'TITULO',;
		   'OBSERVACION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'materias'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL PLAN ACADEMICO
       SELECT MAT
       GO TOP
       DO WHILE .NOT. MAT->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MAT->(RECNO()) / MAT->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ANALISIS DE DECISION
	    IF !EMPTY(cCodigoTma)
	       IF cCodigoTma # MAT->cCodigoMat

		  MAT->(DBSKIP())
		  IF MAT->(EOF())
		     SET DEVICE TO SCREEN
		     Termometro(100)
		     SET DEVICE TO PRINT
		  ENDIF
		  LOOP

	       ENDIF
	    ENDIF
**********FIN ANALISIS DE DECISION


**********IMPRESION DEL REGISTRO
	    aTitulo := {IF(MAT->lHayAnoMat,'','X ')+MAT->cCodigoMat,;
			IF(SUBS(MAT->cCodigoMat,3,2) = '00',;
			   MAT->cNombreMat+SPACE(02),;
			   SPACE(02)+MAT->cNombreMat),;
			IF(SUBS(MAT->cCodigoMat,3,2) == '00',;
			   'AREA',;
			    IF(MAT->nMatVarMat==0,;
			      'MATERIA',;
			      IF(MAT->nMatVarMat==1,;
			      'VARIABLE X NIVEL',;
			      'VARIABLE X GRUPO'))),;
			MAT->cTituloMat,;
			IF(MAT->lHayAnoMat,'','NO SE DICTA')}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********FILTRACION DEL ARCHIVO
	    IF MAT->lHayAnoMat

	       SELECT CAR
	       CAR->(DBGOTOP())

	       SET FILTER TO SUBS(CAR->cCodigoCar,1,4) == MAT->cCodigoMat

	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

***********PROFESORES DE LA MATERIA
	     IF MAT->lHayAnoMat

	       aProfes := {}
	       CAR->(DBGOTOP())
	       DO WHILE .NOT. CAR->(EOF())

		  IF LEN(aProfes) == 0
		     AADD(aProfes,{CAR->cCodigoPro,SUBS(CAR->cCodigoCar,5,4)})
		  ELSE

		     k := ASCAN(aProfes,{|aPro|aPro[1] == CAR->cCodigoPro})
		     IF k # 0
			aProfes[k,2] += ' '+SUBS(CAR->cCodigoCar,5,4)
		     ELSE
			AADD(aProfes,{CAR->cCodigoPro,;
				      SUBS(CAR->cCodigoCar,5,4)})
		     ENDIF

		  ENDIF

		  CAR->(DBSKIP())

	       ENDDO

	     ENDIF
***********FIN PROFESORES DE LA MATERIA

**********IMPRESION DE LOS PROFESORES
	    IF MAT->lHayAnoMat

	       FOR i := 1 TO LEN(aProfes)

		  cCodigoTpr := aProfes[i,1]
		  cNombreTpr := 'PROFESOR NO EXISTE'
		  IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
		     cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
				   ALLTRIM(PRO->cNombrePro)
		  ENDIF
		  cNombreTpr += ' DICTA EN:'+aProfes[i,2]

		  aNroLin := aDivLin(ALLTRIM(cNombreTpr),78)
		  FOR j := 1 TO LEN(aNroLin)

		      cNroLin := SPACE(03)+aNroLin[j]
		      cNroLin := SUBS(cNroLin+SPACE(82),1,81)

		      aTitulo := {}
		      IF j == 1
			 AADD(aTitulo,cCodigoTpr)
			 AADD(aTitulo,'-'+cNroLin)
		      ELSE
			 AADD(aTitulo,'')
			 AADD(aTitulo,' '+cNroLin)
		      ENDIF

		      AADD(aTitulo,'')
		      AADD(aTitulo,'')
		      AADD(aTitulo,'')

		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)


		  NEXT

	       ENDFOR

	    ENDIF
**********FIN IMPRESION DE LOS PROFESORES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT MAT
	    MAT->(DBSKIP())
	    IF MAT->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

	  SELECT CAR
	  SET FILTER TO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS