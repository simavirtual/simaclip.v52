/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CONCEPTOS

REQUERIMIENTOS:

- Compilar: clipper FuncsCon /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Conceptos

FUNCIONES:

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfCon(PathCon,FileCon,lIntUno,fNtxCon)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCon(lShared,nModCry,PathCon,FileCon,fNtxCon,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCon				    // Path del Archivo
       FileCon				    // Nombre del Archivo
       fNtxCon				    // Archivo de Indices
       aStrDbf                              // Estructura de Archivos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfCon := {{"cCodigoCon","Character",02,0},;
			 {"cNombreCon","Character",16,0},;
			 {"lBecadoCon","Logical"  ,01,0},;
			 {"nValorCon" ,"Numeric"  ,12,2},;
			 {"nTipoCon"  ,"Numeric"  ,01,0},; // Tipo Concepto 0=>Pensi¢n, 1=>Ruta 2=>Cafeteria
			 {"lSiCertCon","Logical"  ,01,0},; // .T. Si Certificado
			 {"cCodCerCon","Character",02,0},; // C¢digo para el Certificado
			 {"cNomCerCon","Character",16,0},; // Nombre para el Certificado
			 {"nMesIniCon","Numeric"  ,02,0},; // Mes Inicial del Concepto
			 {"nMesFinCon","Numeric"  ,02,0},; // Mes Final del Concepto
			 {"lDesEfeDes","Logical"  ,01,0},; // .T. Descuento del Efectivo .F. No Descuento de Efectio implica ingreso
			 {"cNomExtCon","Character",16,0},; // Nombre Extra
			 {"nIntHonCon","Numeric"  ,05,2},; // Intereses Honorarios por cobranza
			 {"nVlrHonCon","Numeric"  ,12,2},; // Valor Honorarios por cobranza
			 {"nDiaMorCon","Numeric"  ,04,0}}  // Dias de Mora para cobrar Honorarios por Cobranza
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCon
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCon) == 0
	    DBCREATE(FileCon,aDbfCon,"DBFNTX")
	    Proteger(FileCon,nModCry)

       CASE DIRCHANGE(PathCon) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCon)

       CASE DIRCHANGE(PathCon) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCon)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCon+'\'+FileCon,'CON',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO CONCEPTOS EN CREACION DE ESTRUCTURAS')
	  CloseDbf('CON',PathCon+'\'+FileCon,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF CON->(lRegLock(lShared,.T.))
	  REPL CON->cCodigoCon WITH 'PE'       // Pensi¢n
	  REPL CON->cNombreCon WITH 'PENSION'
	  REPL CON->lBecadoCon WITH .T.        // Concepto con Beca
	  CON->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL EN CONCEPTOS')
       ENDIF
       IF lShared
	  CON->(DBUNLOCK())
       ENDIF
       CloseDbf('CON',PathCon+'\'+FileCon,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:20 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCon(lShared,nModCry,PathCon,FileCon,fNtxCon)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathCon			      // Path del Archivo
       FileCon			      // Nombre del Archivo
       fNtxCon			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCon+'\'+FileCon,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONCEPTOS")
       Termometro(100)

       CreaDbfCon(lShared,nModCry,PathCon,FileCon,fNtxCon)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2001 LUN A
       Colombia, Bucaramanga        INICIO: 03:45 AM   OCT 08/2001 LUN

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

FUNCTION nActDbfCon(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'CON',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONCEPTOS')
	  CloseDbf('CON',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CON->(DBSTRUCT())
       CloseDbf('CON',PathArc+'\'+cNomArc,nModCry)
       CreaDbfCon(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo CONCEPTOS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfCon(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DEL CONCEPTO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez        FECHA DE CREACION: JUL 02/94 SAB A
							JUL 02/94 SAB
OBJETIVOS:

1- Debe estar en uso el archivo de conceptos

2- Verifica la existencia del c¢digo del concepto

3- Deja el archivo en el registro del c¢digo del Concepto si este existe.

4- Retorna .T. si localizo el codigo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodCon(cCodigo,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo a localizar
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT CON
       GO TOP
       LOCATE FOR CON->cCodigoCon == cCodigo
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CODIGO DEL CONCEPTO '+cCodigo+' NO SE ENCUENTRA')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CONCEPTO                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo Conceptos

2- Realiza la validaci¢n del c¢digo del concepto de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValConcep(nNroFil,nNroCol,cCodCon)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodCon                              // C¢digo del Concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegCon := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF !lLocCodCon(cCodCon,.F.)
	  nRegCon := nSelConcep(nNroFil,nNroCol)
	  IF nRegCon == 0
	     cCodCon := cSpaces('CON','cCodigoCon')
	  ELSE
	     GO nRegCon
	     cCodCon := CON->cCodigoCon
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL CONCEPTO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:
1- Debe estar en uso el archivo de Conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite escoger el registro del archivo de acuerdo al nombre del concepto

4- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelConcep(nNroFil,nNroCol)

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
       LOCAL nRegCon := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF CON->(RECCOUNT()) == 0
	  cError('NO EXISTEN CONCEPTOS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CON
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CONCEPTO
       CON->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegCon := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||CON->cNombreCon})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nRegCon
*>>>>FIN SELECCION DEL CONCEPTO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE CONCEPTOS         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 VIE A
						       SEP 02/94 VIE
OBJETIVOS:

1- Permite el mantenimiento del archivo Conceptos

SINTAXIS:

MantenCon()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCon(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"              // Archivos del Sistema

       LOCAL oBrwCon := NIL                 // Objeto para el Concepto
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})

*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwCon := oDefBrwCon(lShared,nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarCon(oBrwCon)})

       SETKEY(K_F9,{||MenuOtrCon(aParam1,aParam2,aParam3,oBrwCon)})

       CON->(CtrlBrw(lShared,oBrwCon))
       SETKEY(K_F5,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE CONCEPTOS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 SAB A
						       SEP 02/94 SAB
OBJETIVOS:

1- Define el objeto Browse del archivo Conceptos

SINTAXIS:

 oBrwCon := oDefBrwCon(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCon(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse			    // Browse de Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE CONCEPTOS>>',;
			    '<ENTER>Modificar  <INS>Incluir  <F5>Buscar  '+;
			    '<DEL>Borrar  <ESC>Abandonar',;
			     {||IncluirCon(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CON
       oColumn	     := TBCOLUMNNEW('CODIGO', {||CON->cCodigoCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL CONCEPTO', {||CON->cNombreCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cNombreCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTO CON BECA', {||CON->lBecadoCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','lBecadoCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR', {||CON->nValorCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nValorCon'},;
			 {'PICTURE','999999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE CONCEPTO', {||CON->nTipoCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','nTipoCon'},;
			 {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CERTIFICADO', {||CON->lSiCertCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','lSiCertCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;CERTIFICADO', {||CON->cCodCerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cCodCerCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE CONCEPTO', {||CON->cNomCerCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cNomCerCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES INICIAL;FACTURACION', {||CON->nMesIniCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nMesIniCon'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES FINAL;FACTURACION', {||CON->nMesFinCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nMesFinCon'},;
			 {'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE EXTRA', {||CON->cNomExtCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'},{'FIELD','cNomExtCon'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('%HONORARIOS COBRANZA', {||CON->nIntHonCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nIntHonCon'},;
			 {'PICTURE','99.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('$HONORARIOS COBRANZA', {||CON->nVlrHonCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nVlrHonCon'},;
			 {'PICTURE','999999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIAS EN MORA', {||CON->nDiaMorCon})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CON'}, {'FIELD','nDiaMorCon'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE CONCEPTOS 	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 VIE A
						       SEP 02/94 VIE
OBJETIVOS:

1- Incluye un registro al archivo de Conceptos

SINTAXIS:

  IncluirCon()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirCon(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar el registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTco := ''               // Codigo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
       LOCAL lBecadoTco := .F.              // .T. Beca para el concepto
       LOCAL  nValorTco := 0                // Valor del Concepto
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL CONCEPTO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTco := cSpaces('CON','cCodigoCon')
	       cNombreTco := cSpaces('CON','cNombreCon')
	       lBecadoTco := .F.
	       nValorTco  := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET cCodigoTco PICT '@!';
				VALID !lValCodCon(cCodigoTco)
	    @ nNroFil+1,nNroCol SAY 'NOMBRE DEL CONCEPTO:';
				GET cNombreTco PICT '@!'
	    @ nNroFil+2,nNroCol SAY 'CONCEPTO CON BECA? :';
				GET lBecadoTco PICT '@!'
	    @ nNroFil+3,nNroCol SAY 'VALOR DEL CONCEPTO :';
				GET nValorTco  PICT '9999999.99'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF cCodigoTco # cSpaces('CON','cCodigoCon') .AND.;
	       cNombreTco # cSpaces('CON','cNombreCon')
	       lGrabar := .T.
	    ELSE
	       lGrabar := .F.
	       cError('DEBE DAR LOS DATOS COMPLETOS. NO SE GRABA EL REGISTRO')
	    ENDIF
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
       SELECT CON
       IF lGrabar
	  IF CON->(lRegLock(lShared,.T.))
	     REPL CON->cCodigoCon WITH cCodigoTco
	     REPL CON->cNombreCon WITH cNombreTco
	     REPL CON->lBecadoCon WITH lBecadoTco
	     REPL CON->nValorCon  WITH nValorTco
	     CON->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA LOS DATOS DEL CONCEPTO')
	  ENDIF
       ENDIF
       IF lShared
	  CON->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CONCEPTO EN EL BROWSE     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 VIE A
						       SEP 02/94 VIE
OBJETIVOS:

1- Localiza el c¢digo del Concepto dentro del Browse de Conceptos

2- Retorna NIL

SINTAXIS:

  BuscarCon(oBrwCon)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCon(oBrwCon)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwCon			            // Browse de Conceptos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegCon := 0                   // Registro del Concepto
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTco := ''               // Codigo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTco := cSpaces('CON','cCodigoCon')
       TitBuscar(LEN(cCodigoTco),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTco PICT '@!';
			 VALID lValConcep(ROW(),COL()-2,@cCodigoTco)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTco == cSpaces('CON','cCodigoCon')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT CON
       IF lBuscar .AND. lLocCodCon(cCodigoTco)
	   nRegCon := RECNO()
	   GO TOP
	   oBrwCon:GOTOP()
	   GO nRegCon
	   oBrwCon:FORCESTABLE()
       ELSE
	   oBrwCon:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL CONCEPTO		*
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/94 SAB A
						       SEP 02/94 SAB
OBJETIVOS:
1- Debe estar en uso el archivo Conceptos

2- Realiza la validaci¢n del c¢digo del Concepto

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodCon(cCodCon)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodCon			            // C¢digo del Concepto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF cCodCon # cSpaces('CON','cCodigoCon')
	  IF lLocCodCon(cCodCon,.F.)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LOS CONCEPTOS A COBRAR              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/94 LUN A
						       SEP 19/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de Conceptos

2- Permite leer los c¢digos de los conceptos a cobrar

3- Retorna los c¢digos de los conceptos le¡dos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeConcep(nNroFil,nNroCol,nFilCon,nColCon,cConEst)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilCon                              // Fila Impresion de Conceptos
       nColCon                              // Columna impresion Conceptos
       cConEst                              // Conceptos Aplicados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL lSavPan := .T.                 // .T. Salvar Pantalla

       LOCAL nNroCon := 1                   // N£mero de Conceptos
       LOCAL nRegCon := 0                   // N£mero de Registro

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CON
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>LECTURA DE LOS CONCEPTOS
       cConEst := IF(cConEst == NIL,'',cConEst)
       DO WHILE .T.

**********SELECCION DEL CODIGO DEL CONCEPTO
	    SELECT CON
	    CON->(DBGOTOP())
	    nRegCon := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
				  {||CON->cNombreCon},16,lSavPan)
	    IF nRegCon == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DEL CODIGO DEL CONCEPTO

**********ACUMULACION DEL CODIGO DEL CONCEPTO
	    IF nRegCon <> 0

	       CON->(DBGOTO(nRegCon))
	       IF CON->cCodigoCon $ cCodigoTco .OR.;
		  CON->cCodigoCon $ cConEst

		  cError('EL CONCEPTO '+ALLTRIM(CON->cNombreCon)+;
			 ' YA LO APLICO')
	       ELSE

*--------------ANALISIS PARA EL LIMITE DE LOS CONCEPTOS
		 IF nNroCon <= 7
		    cCodigoTco = cCodigoTco + CON->cCodigoCon
		    @ nFilCon,nColCon SAY cCodigoTco
		    nNroCon++
		 ELSE
		    cError('SOLO SE PUEDEN APLICAR SIETE (7) CONCEPTOS',;
			   'A CONTINUACION SE GRABAN LOS CONCEPTOS')
		    EXIT
		 ENDIF
*--------------FIN ANALISIS PARA EL LIMITE DE LOS CONCEPTOS

	       ENDIF

	    ENDIF
**********FIN ACUMULACION DEL CODIGO DEL CONCEPTO

       ENDDO
       RETURN cCodigoTco
*>>>>FIN LECTURA DE LOS CONCEPTOS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA LECTURA DE LOS CONCEPTOS      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/97 MIE A
       Bucaramanga, Colombia	    INICIO: 02:00 PM   JUN 11/97 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de Conceptos

2- Permite la lectura de los c¢digos de los conceptos

3- Valida los conceptos leidos

4- Retorna .T. para permitir la validaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValLeeCon(nNroFil,nNroCol,nFilCon,nColCon,cConcep,nTotCon)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilCon				    // Fila Impresion de Conceptos
       nColCon				    // Columna impresion Conceptos
       cConcep			            // @Conceptos
       nTotCon                              // Total Conceptos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL lSavPan := .T.                 // .T. Salvar Pantalla

       LOCAL       i := 0                   // Contador
       LOCAL nNroLee := 1                   // N£mero de Lecturas
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL cCodCon := ''                  // C¢digo del Concepto

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS CONCEPTOS
       IF EMPTY(cConcep)
	  RETURN .T.
       ENDIF

       IF lPar(LEN(ALLTRIM(cConcep)))
	  FOR i := 1 TO LEN(ALLTRIM(cConcep))/2
	      cCodCon := SUBS(cConcep,i*2-1,2)
	      IF !lLocCodigo('cCodigoCon','CON',cCodCon)
		 lHayErr := .T.
		 LOOP
	      ENDIF
	      cCodigoTco += cCodCon
	  NEXT
       ELSE
	  @ nFilCon,nColCon SAY SPACE(LEN(cConcep)) COLOR("I")
	  cCodigoTco := ''
	  lHayErr := .T.
       ENDIF

       IF !lHayErr
	  RETURN .T.
       ENDIF
*>>>>FIN VALIDACION DE LOS CONCEPTOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CON
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+16
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>LECTURA DE LOS CONCEPTOS
       DO WHILE .T.

**********SELECCION DEL CODIGO DEL CONCEPTO
	    SELECT CON
	    CON->(DBGOTOP())
	    nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
				  {||CON->cNombreCon},30,lSavPan)
	    IF nNroReg == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DEL CODIGO DEL CONCEPTO

**********ACUMULACION DEL CODIGO DEL CONCEPTO
	    IF nNroReg <> 0

	       CON->(DBGOTO(nNroReg))
	       IF CON->cCodigoCon $ cCodigoTco
		  cError('EL CONCEPTO '+ALLTRIM(CON->cNombreCon)+;
			 ' YA LO APLICO')
	       ELSE

*--------------ANALISIS PARA EL LIMITE DE LOS CONCEPTOS
		 nTotCon := IF(nTotCon==NIL,7,nTotCon)
		 IF nNroLee <= nTotCon
		    cCodigoTco = cCodigoTco + CON->cCodigoCon
		    @ nFilCon,nColCon SAY cCodigoTco COLOR ("I")
		    nNroLee++
		 ELSE
		    cError('SOLO SE PUEDEN APLICAR SIETE (7) CONCEPTOS')
		    EXIT
		 ENDIF
*--------------FIN ANALISIS PARA EL LIMITE DE LOS CONCEPTOS

	       ENDIF

	    ENDIF
**********FIN ACUMULACION DEL CODIGO DEL CONCEPTO

       ENDDO
       cConcep := cCodigoTco+SPACE(LEN(cConcep)-LEN(cCodigoTco))
       RETURN .T.
*>>>>FIN LECTURA DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: INTERVALO DE REGISTROS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 21/2001 MAR A
       Bucaramanga, Colombia	    INICIO: 06:30 PM   NOV 21/2001 MAR


OBJETIVOS:

1- Permite selecionar un intervalo de Registros.

2- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervCon(nNroFil,nNroCol,nRegIni,nRegFin,lIniFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final
       lIniFin                              // @ .T. Todos los Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
       LOCAL nIniReg := 0                   // Registro Inicial
       LOCAL nFinReg := 0                   // Registro Final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt ='CONCEPTO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'CONCEPTO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT CON
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+3

	CON->(DBGOTOP())
	nIniReg := CON->(RECNO())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||CON->cCodigoCon})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	CON->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY CON->cCodigoCon
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       CON->(DBGOBOTTOM())
       nFinReg := CON->(RECNO())

       CON->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||CON->cCodigoCon})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       CON->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY CON->cCodigoCon
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
*>>>>FIN INTERCAMBIO DE REGISTROS

*>>>>ANALISIS DE TODOS LOS REGISTROS
       lIniFin := .F.
       IF nRegIni == nIniReg .AND. nRegFin == nFinReg
	  lIniFin := .T.
       ENDIF
       RETURN .T.
*>>>>FIN ANALISIS DE TODOS LOS REGISTROS

/*************************************************************************
* TITULO..: LECTURA DE TODOS LOS CONCEPTOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/2002 MIE A
       Bucaramanga, Colombia	    INICIO: 11:30 AM   MAY 15/2002 MIE


OBJETIVOS:

1- Retorna todos los c¢digos de los conceptos como un string

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cConceptos()

*>>>>DECLRACION DE VARIABLES
       LOCAL cConcep := ''                  // C¢digos de Conceptos
*>>>>FIN DECLRACION DE VARIABLES

*>>>>LECTURA DE LOS CONCEPTOS
       SELECT CON
       GO TOP
       DO WHILE .NOT. CON->(EOF())
	  cConcep += CON->cCodigoCon
	  CON->(DBSKIP())
       ENDDO
       RETURN cConcep
*>>>>FIN LECTURA DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: IMPRESION DE LOS CONCEPTOS DESCRIMINADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2003 VIE A
       Bucaramanga, Colombia        INICIO: 04:00 PM   SEP 05/2003 VIE

OBJETIVOS:

1- Imprime el valor de los conceptos descriminados

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnConVlr(nNroCol,bPagina,bDerAut,bCabeza,aVlrCon,nTipPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la Fila
       nNroCol                              // N£mero de Columna
       bPagina                              // Block de P gina
       bCabeza                              // Block de Encabezado
       bDerAut                              // Block Derechos de Autor
       aVlrCon                              // Valor Por Conceptos
       nTipPrn                              // Tipo de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aNroCol := {}                  // N£mero de Columnas
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nTotCon := 0                   // Valor total de los Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nTipPrn := IF(EMPTY(nTipPrn),1,nTipPrn)
       FOR i:=1 TO LEN(aVlrCon)

	   AADD(aNroCol,LEN(aVlrCon[i,2]))
	   DO CASE
	   CASE nTipPrn == 1   // Encabezado
		AADD(aTitulo,aVlrCon[i,2])

	   CASE nTipPrn == 2   // Registro en fila

		nVlrCon := aVlrCon[i,3]
		nTotCon += nVlrCon

		AADD(aTitulo,TRANS(nVlrCon,"####,###,###"))

	   CASE nTipPrn == 3   // Registros en Columna

		nVlrCon := aVlrCon[i,3]
		nTotCon += nVlrCon

		cTxtPrn := aVlrCon[i,2]+'=>'+TRANS(nVlrCon,"####,###,###")
		lPrnReg(01,nNroCol,cTxtPrn,bPagina,bDerAut,bCabeza)

	   ENDCASE

       ENDFOR
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL
       AADD(aNroCol,12)
       DO CASE
       CASE nTipPrn == 1

	    AADD(aTitulo,'TOTAL')
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nNroCol,cTxtPrn,bPagina,bDerAut,bCabeza)

       CASE nTipPrn == 2

	    AADD(aTitulo,TRANS(nTotCon,"####,###,###"))
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nNroCol,cTxtPrn,bPagina,bDerAut,bCabeza)

       CASE nTipPrn == 3

	    cTxtPrn := SPACE(18)+REPL('=',12)
	    lPrnReg(01,nNroCol,cTxtPrn,bPagina,bDerAut,bCabeza)

	    cTxtPrn := 'TOTAL'+SPACE(11)+'=>'+TRANS(nTotCon,"####,###,###")
	    lPrnReg(01,nNroCol,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDCASE
       RETURN NIL
*>>>>IMPRESION DEL TOTAL

/*************************************************************************
* TITULO..: DISCRIMINACION CONCEPTOS DE MATRICULAS DE TARIFAS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2003 JUE A
       Bucaramanga, Colombia        INICIO: 06:00 AM   MAR 11/2003 JUE

OBJETIVOS:

1- Descrimina el valor de los conceptos de la Matricula seg£n el
   valor de las tarifas

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VlrTarMtr(cConcep,cCodGru,aVlrCon,lSiCert)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDiv                              // Conceptos
       cCodGru                              // C¢digo del Grupo
       aVlrCon                              // @Valor de los Conceptos
       lSiCert                              // .T. Si Certificado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nVlrCon := 0                   // Valor del Concepto

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DEL VALOR
       lSiCert := IF(lSiCert==NIL,.F.,lSiCert)
       FOR i := 1 TO LEN(ALLTRIM(cConcep))/2

***********LOCALIZACION DEL VALOR DEL CONCEPTO
	     cCodigoTco := SUBS(ALLTRIM(cConcep),i*2-1,2)
	     lLocCodigo('cCodigoCon','CMT',cCodigoTco)

	     SELECT TMT
	     GO TOP
	     LOCATE FOR TMT->cCodigoGru == SUBS(cCodGru,1,2)+'00' .AND.;
			TMT->cCodigoCon == cCodigoTco

	     IF FOUND()
		nVlrCon := TMT->nValorTar
	     ELSE
		nVlrCon := 0
	       *No existe tarifa asignada
	     ENDIF
***********FIN LOCALIZACION DEL CONCEPTO

***********SUMA DEL CONCEPTO DESCRIMINADO
	     IF nVlrCon # 0

*---------------SUMA DEL CONCEPTO DESCRIMINADO
		  IF lSiCert

		     IF CMT->lSiCertCon

			VlrCon(IF(EMPTY(CMT->cCodCerCon),;
				  cCodigoTco,CMT->cCodCerCon),;
			       IF(EMPTY(CMT->cNomCerCon),;
				  CMT->cNombreCon,CMT->cNomCerCon),;
			       nVlrCon,aVlrCon)
		     ENDIF
		  ELSE

		     VlrCon(cCodigoTco,CMT->cNombreCon,nVlrCon,aVlrCon)
		  ENDIF
*---------------FIN SUMA DEL CONCEPTO DESCRIMINADO

	     ENDIF
***********FIN SUMA DEL CONCEPTO DESCRIMINADO

       ENDFOR
       RETURN NIL
*>>>>FIN DESCRIMINACION DEL VALOR

/*************************************************************************
* TITULO..: DISCRIMINACION CONCEPTOS DE LA CARTERA DE TARIFAS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2003 JUE A
       Bucaramanga, Colombia        INICIO: 06:00 AM   MAR 11/2003 JUE

OBJETIVOS:

1- Descrimina el valor de los conceptos de la Matricula seg£n el
   valor de las tarifas

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VlrTarCar(cConcep,cCodGru,aVlrCon,lSiCert)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDiv                              // Conceptos
       cCodGru                              // C¢digo del Grupo
       aVlrCon                              // @Valor de los Conceptos
       lSiCert                              // .T. Si Certificado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nVlrCon := 0                   // Valor del Concepto

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DEL VALOR
       lSiCert := IF(lSiCert==NIL,.F.,lSiCert)
       FOR i := 1 TO LEN(ALLTRIM(cConcep))/2

***********LOCALIZACION DEL VALOR DEL CONCEPTO
	     cCodigoTco := SUBS(ALLTRIM(cConcep),i*2-1,2)

	     nVlrCon := nValorTar(cCodGru,cCodigoTco,@cNombreTco)

	     lLocCodigo('cCodigoCon','CON',cCodigoTco)
***********FIN LOCALIZACION DEL CONCEPTO

***********SUMA DEL CONCEPTO DESCRIMINADO
	     IF nVlrCon # 0

*---------------SUMA DEL CONCEPTO DESCRIMINADO
		  IF lSiCert
		     IF CON->lSiCertCon
			VlrCon(IF(EMPTY(CON->cCodCerCon),;
				  cCodigoTco,CON->cCodCerCon),;
			       IF(EMPTY(CON->cNomCerCon),;
				  CON->cNombreCon,CON->cNomCerCon),;
			       nVlrCon,aVlrCon)
		     ENDIF
		  ELSE
		     VlrCon(cCodigoTco,CON->cNombreCon,nVlrCon,aVlrCon)
		  ENDIF
*---------------FIN SUMA DEL CONCEPTO DESCRIMINADO

	     ENDIF
***********FIN SUMA DEL CONCEPTO DESCRIMINADO

       ENDFOR
       RETURN NIL
*>>>>FIN DESCRIMINACION DEL VALOR

/*************************************************************************
* TITULO..: LECTURA DE LOS MESES DE LOS CONCEPTOS A FACTURAR             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 12/2005 MIE A
       Bucaramanga, Colombia	    INICIO: 11:00 AM   ENE 12/2005 MIE

OBJETIVOS:

1- Permite leer los meses inicial y final de cada uno de los conceptos
   a facturar

2- Retorna el vector con los conceptos a facturar.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeMesCon(cCodEst,cNomEst,aConcep,nIniPag,nUltRec)

*>>>>DECLARACION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cConcep                              // @Conceptos a facturar
       nIniPag                              // Mes Inicial del Pago
       nUltRec                              // Ultimo recibo del Estudiante */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador

       LOCAL nFilSup := 0                   // Fila Superior del marco
       LOCAL nColSup := 0                   // Columna Superior del marco
       LOCAL nFilInf := 0                   // Fila Inferior del marco
       LOCAL nColInf := 0                   // Columna Inferior del marco

       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nValIni := 0                   // Mes Inicial de Validaci¢n
       LOCAL nValFin := 0                   // Mes Final de Validaci¢n
       LOCAL nTotCon := 0                   // Total de Conceptos
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL lHayCoE := .T.                 // .T. Hay Concptos Individuales
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTco := ''               // Codigo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONTEO DE LOS CONCPETOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nTotCon := 0
       FOR i := 1 TO LEN(aConcep)
	   IF !EMPTY(aConcep[i,1])
	      nTotCon++
	   ENDIF
       NEXT
*>>>>FIN CONTEO DE LOS CONCPETOS

*>>>>LECTURA Y VALIDACION DE LOS MESES DE LOS CONCEPTOS
       nFilSup := 03
       nColSup := 34
       nFilInf := nFilSup+nTotCon+3
       nColInf := 66

       DO WHILE .T.

***********LECTURA DE LOS MESES
	     nNroFil := nMarco(nFilSup,'CONCEPTOS A FACTURAR PARA '+;
				       cMes(nIniPag,3),nFilInf,'°',,;
				       nColSup,nColInf)
	     FOR i := 1 TO nTotCon

*================LECTURA DEL MES INICIAL
		   nNroCol := nColSup
		   cNombreTco := aConcep[i,5]

		   cTxtTem := 'FAVOR INGRESE EL MES INICIAL '+;
			      'A FACTURAR DEL CONCEPTO'

		   nMesIni := aConcep[i,2]
		   nMesFin := nMesIni

		   nValIni := aConcep[i,2]
		   nValFin := aConcep[i,3]

		   @ nNroFil,nNroCol+1 SAY cNombreTco+' DE:';
			     GET nMesIni PICT '99';
			     VALID lnValMes(ROW(),COL()-2,@nMesIni) .AND.;
				   nMesIni == nValIni;
			     WHEN {||HelpRead(cTxtTem)}
*================FIN LECTURA DEL MES INICIAL

*================LECTURA DEL MES FINAL
		   nNroCol := nNroCol+LEN(cNombreTco)+8

		   cTxtTem := 'FAVOR INGRESE EL MES FINAL '+;
			      'A FACTURAR DEL CONCEPTO'

		   @ nNroFil,nNroCol SAY ' A:' ;
			     GET nMesFin PICT '99';
			     VALID lnValMes(ROW(),COL()-2,@nMesFin) .AND.;
				   nMesFin >= nMesIni .AND.;
				   nMesFin <= nValFin;
			     WHEN {||HelpRead(cTxtTem)}
		   READ
		   nNroFil++
		   aConcep[i,2] := nMesIni
		   aConcep[i,3] := nMesFin
*================FIN LECTURA DEL MES FINAL

*================VALIDACION DE LOS MESES DE FACTURACION
		   IF !aConcep[i,7] .AND.;  // Concepto General
		      nMesIni # 0 .AND. nMesFin # 0

		      nRegPag := 0
		      IF !lDobleFac(CLI->cCodigoEst,nMesIni,nMesFin,;
				    CLI->cMesPagCli,@nRegPag,cNomEst,;
				    nUltRec,lHayCoE)

			 lHayErr := .T.
			 RESTSCREEN(0,0,24,79,cSavPan)
			 RETURN !lHayErr
		      ENDIF

		   ENDIF
*================FIN VALIDACION DE LOS MESES DE FACTURACION

	     NEXT
***********FIN LECTURA DE LOS MESES

***********ANALISIS DE DECISION
	     IF lPregunta('DESEA CORREGIR? No Si')
		LOOP
	     ENDIF
***********FIN ANALISIS DE DECISION

***********CONSULTA DE LOS CONCEPTOS A FACTURAR
	     nNroFil := nMarco(nFilSup,'MESES A FACTURAR',;
			       nFilInf,'°',,nColSup,nColInf)
	     FOR i := 1 TO nTotCon

		 nNroCol := nColSup
		 cNombreTco := aConcep[i,5]

		 nMesIni := aConcep[i,2]
		 nMesFin := aConcep[i,3]

		 IF nMesIni == 0 .OR. nMesFin == 0
		    @ nNroFil,nNroCol+1 SAY cNombreTco+' NO SE FACTURA'

		    aConcep[i,1] := SPACE(02)
		   *Borrado del Concepto
		 ELSE
		    @ nNroFil,nNroCol+1 SAY cNombreTco+' DE: '+;
					    cMes(nMesIni,3)+' A '+;
					    cMes(nMesFin,3)
		 ENDIF
		 nNroFil++
	     NEXT
***********FIN CONSULTA DE LOS CONCEPTOS A FACTURAR

***********ANALISIS DE DECISION
	     IF lPregunta('POR FAVOR VERIFIQUE LOS CONCEPTOS A '+;
				  'FACTURAR. DESEA CONTINUAR? No Si')
		lHayErr := .F.
	     ELSE
		lHayErr := .T.
	     ENDIF
	     EXIT
***********FIN ANALISIS DE DECISION

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN !lHayErr
*>>>>FIN LECTURA Y VALIDACION DE LOS MESES DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: MES INICIAL Y FINAL FACTURADOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2005 DOM A
       Bucaramanga, Colombia	    INICIO: 12:00 AM   ENE 16/2005 DOM

OBJETIVOS:

1- Permite armar los meses facturados de cada concepto

2- Retorna los meses facturados.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIniFin(aConcep,lMesIni)

*>>>>DECLARACION DE PARAMETROS
/*     aConcep                              // Conceptos a facturar
       lMesIni                              // .T. Mes Inicial = Mes Final */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL cMesFin := ''                  // Mes Final
       LOCAL cIniFin := ''                  // Meses Inicial y final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS MESES FACTURADOS
       lMesIni := IF(lMesIni == NIL,.F.,lMesIni)
       FOR i := 1 TO LEN(aConcep)

	   nMesIni := aConcep[i,2]
	   nMesFin := aConcep[i,3]

	   cMesIni := STR(nMesIni,2)
	   cMesFin := STR(nMesFin,2)

	   lCorrecion(@cMesIni,.T.)
	   lCorrecion(@cMesFin,.T.)

	   IF lMesIni
	      cIniFin += cMesIni+cMesIni
	   ELSE
	      cIniFin += cMesIni+cMesFin
	   ENDIF

       NEXT
       RETURN cIniFin
*>>>>FIN CALCULO DE LOS MESES FACTURADOS

/*************************************************************************
* TITULO..: CONCEPTOS                                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2005 DOM A
       Bucaramanga, Colombia	    INICIO: 12:00 AM   ENE 16/2005 DOM

OBJETIVOS:

1- Permite armar los conceptos facturados de cada concepto

2- Retorna los conceptos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cConcep(aConcep)

*>>>>DECLARACION DE PARAMETROS
/*     aConcep                              // Conceptos a facturar */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL cConcep := ''                  // Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS MESES FACTURADOS
       FOR i := 1 TO LEN(aConcep)
	   IF aConcep[i,2] # 0 .AND. aConcep[i,2] # 0
	      cConcep += aConcep[i,1]
	   ENDIF
       NEXT
       RETURN cConcep
*>>>>FIN CALCULO DE LOS MESES FACTURADOS

/*************************************************************************
* TITULO..: MES INICIAL Y FINAL FACTURADOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2005 DOM A
       Bucaramanga, Colombia	    INICIO: 12:00 AM   ENE 16/2005 DOM

OBJETIVOS:

1- Permite armar los meses facturados de cada concepto

2- Retorna los meses facturados.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIniIni(cIniFin)

*>>>>DECLARACION DE PARAMETROS
/*     cIniFin				    // Meses Inicial y Final */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final

       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL cMesFin := ''                  // Mes Final

       LOCAL cMeses  := ''                  // Mes Inicial y Final
       LOCAL cIniIni := ''                  // Mes Inicial y Inicial
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS MESES FACTURADOS
       FOR i := 1 TO LEN(ALLTRIM(cIniFin))/4

	   cMeses  := SUBS(cIniFin,i*4-3,4)
	   nMesIni := VAL(SUBS(cMeses,1,2))
	   nMesFin := VAL(SUBS(cMeses,3,2))

	   cMesIni := STR(nMesIni,2)
	   cMesFin := STR(nMesFin,2)

	   lCorrecion(@cMesIni,.T.)
	   lCorrecion(@cMesFin,.T.)

	   cIniIni += cMesIni+cMesIni

       NEXT
       RETURN cIniIni
*>>>>FIN CALCULO DE LOS MESES FACTURADOS

/*************************************************************************
* TITULO..: FACTURACION DEL A¥O                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Descrimina todos los Conceptos del A¤o

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nFacConAno(cCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL nFacAno := 0                   // Facturaci¢n del A¤o
       LOCAL aVlrCon := {}                  // Valor de los conceptos
       LOCAL aAntici[16]                    // Anticipos. 8 Conceptos
       LOCAL aAntEst := {}                  // Anticipos del Estudiante
       LOCAL nAntici := 0                   // Anticipos de los Estudiantes
*>>>>FIN DECLARACION DE VARIABLES

       AFILL(aAntici,0)

*>>>>FILTRACION DE LOS PAGOS
       SELECT PAG
       nRegPag := PAG->(RECNO())
       SET FILTER TO PAG->cCodigoEst == cCodEst
       PAG->(DBGOTOP())
       IF PAG->(EOF())
	  SET FILTER TO
	  RETURN nFacAno
       ENDIF
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>RECORRIDO DEL ARCHIVO
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********FACTURACION DEL MES
	    aVlrCon := {}
	    nFacAno += nVlrMes(@aVlrCon)
**********FIN FACTURACION DEL MES

**********ANTICIPOS DEL MES
	    IF (PAG->nMesIniPag # PAG->nMesFinPag .OR.;
		lHayAntici(PAG->nMesIniPag,PAG->cIniFinPag)) .AND.;
		(PAG->cEstadoPag = 'P' .OR. PAG->cEstadoPag = 'A') .AND.;
		!EMPTY(PAG->dFecPagPag)

		IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses

		   aAntEst := AnticiVar(GRU->cCodigoGru,;
					aVlrCon,;
					PAG->nMesIniPag+1,;
					PAG->nMesFinPag,;
					aAntici,;
					PAG->cIniFinPag,;
					PAG->cConcepPag,;
					PAG->cConcepPag)

		ELSE
		   aAntEst := Anticipos(aVlrCon,;
					(nNroMesFac(PAG->nMesIniPag,;
					 PAG->nMesFinPag)-1),aAntici,;
					PAG->cIniFinPag,PAG->cConcepPag,;
					PAG->cConcepPag)
	       ENDIF

	       nAntici := nSuma(aAntEst)
	       nFacAno += nAntici

	    ENDIF
**********FIN ANTICIPOS DEL MES

	  PAG->(DBSKIP())

       ENDDO
       SET FILTER TO
       PAG->(DBGOTO(nRegPag))
       RETURN nFacAno
*>>>>FIN RECORRIDO DEL ARCHIVO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2013 LUN A
       Colombia, Bucaramanga        INICIO: 10:33 AM   NOV 18/2013 LUN

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrCon(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<CONCILIACIONES>')

       aAyuda := {}
       AADD(aAyuda,'Imprime los Detalles del Archivo')

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
	    OtrCon011(aParam1,aParam2,aParam3)
	   *Impresi¢n de los campos del Archivo

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 13/2014 MAR A
       Colombia, Bucaramanga        INICIO:  2:08 PM   MAY 13/2014 MAR

OBJETIVOS:

1- Imprime los campos del archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrCon011(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF SCA->lPrnArcCar
          SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Con'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,2,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'CONCEPTOS',;
		   '',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,16)
       AADD(aTitPrn,'CONCEPTO')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT CON
       CON->(DBGOTOP())
       DO WHILE .NOT. CON->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CON->(RECNO()) / CON->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
            aRegPrn := {}
	    AADD(aRegPrn,CON->cCodigoCon)
	    AADD(aRegPrn,CON->cNombreCon)


	    SET DEVICE TO PRINT
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DEL REGISTRO


**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CON
	    CON->(DBSKIP())
	    IF CON->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       SET DEVICE TO SCREEN
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALOR HONORARIOS DE COBRANZA                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 26/2014 MAR A
       Colombia, Bucaramanga        INICIO: 10:30 AM   AGO 26/2014 MAR

OBJETIVOS:

1- Calcula el valor de los honorarios por cobranza

2- Retorna el valor de los Honorarios

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrHon(nVlrDeu)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDeu			            // Valor de la Deuda */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrHon := 0                   // Honorarios de Cobranza
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO HONORARIOS DE COBRANZA
       IF CON->nIntHonCon + CON->nVlrHonCon > 0

	  IF CON->nIntHonCon > 0
	     nVlrHon := ROUND((nVlrDeu*CON->nIntHonCon)/100,0)
	  ELSE
	     nVlrHon := CON->nVlrHonCon
	  ENDIF

       ENDIF
       RETURN nVlrHon
*>>>>FIN CALCULO HONORARIOS DE COBRANZA

/*************************************************************************
* TITULO..: VALIDAR CONCEPTOS A FACTURAR                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 29/2014 VIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   AGO 29/2014 VIE

OBJETIVOS:

1- Analiza los c¢digos de los conceptos a facturar.

2- Elimina el c¢digo del concepto de Gesti¢n de Cobraza si no se debe cobrar

2- Retorna los conceptos a Cobrar


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cValConFac(cConcep,nVlrDeu,nDiaMor)

*>>>>DESCRIPCION DE PARAMETROS
/*     cConcep                              // Conceptos por cobrar
       nVlrDeu			            // Valor de la Deuda
       nDiaMor                              // Dias en Mora */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL    i,j  := 0                   // Contador
       LOCAL cCodCon := ''                  // C¢digo del Concepto
       LOCAL cConFac := ''                  // Conceptos a facturar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       FOR i := 1 TO LEN(cConcep)/2

	   cCodCon := SUBS(cConcep,i*2-1,2)

	   IF cCodCon <> SPACE(2)

	      lLocCodigo('cCodigoCon','CON',cCodCon)
	      IF CON->nIntHonCon + CON->nVlrHonCon > 0

		 IF nVlrDeu > 0
		    IF nDiaMor > CON->nDiaMorCon
		       cConFac += cCodCon            // Concepto normal
		    ELSE
		       j++
		       // Descarta Gesti¢n de Cobranza
		    ENDIF
		 ELSE
		    j++
		    // Descarta Gesti¢n de Cobranza
		 ENDIF
	      ELSE
		 cConFac += cCodCon            // Concepto normal
	      ENDIF

	   ELSE
	      cConFac += cCodCon            // Concepto en Blanco
	   ENDIF

       ENDFOR
       IF j > 0
	  cConFac += SPACE(j*2)
       ENDIF
       RETURN cConFac
*>>>>FIN ANALISIS DE DECISION

