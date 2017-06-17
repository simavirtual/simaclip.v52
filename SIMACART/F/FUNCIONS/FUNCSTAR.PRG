/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO TARIFAS

REQUERIMIENTOS:

- Compilar: clipper FuncsTar /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Tarifas

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 21/94 JUE A
						       DIC 21/94 JUE
OBJETIVOS:

1)- Crea la estructura del archivo Tarifas

2)- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfTar(lShared,nModCry,PathTar,FileTar,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathTar				    // Path del Archivo
       FileTar				    // Nombre del Archivo
       aStrDbf                              // Estructura de Archivos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfTar := {{"cCodigoGru","Character",04,0},;
			 {"cCodigoCon","Character",02,0},;
			 {"nValorTar" ,"Numeric"  ,12,2},;
			 {"nValor2Tar","Numeric"  ,12,2},;
			 {"nVlrEneTar","Numeric"  ,12,2},;
			 {"nVlrFebTar","Numeric"  ,12,2},;
			 {"nVlrMarTar","Numeric"  ,12,2},;
			 {"nVlrAbrTar","Numeric"  ,12,2},;
			 {"nVlrMayTar","Numeric"  ,12,2},;
			 {"nVlrJunTar","Numeric"  ,12,2},;
			 {"nVlrJulTar","Numeric"  ,12,2},;
			 {"nVlrAgoTar","Numeric"  ,12,2},;
			 {"nVlrSepTar","Numeric"  ,12,2},;
			 {"nVlrOctTar","Numeric"  ,12,2},;
			 {"nVlrNovTar","Numeric"  ,12,2},;
			 {"nVlrDicTar","Numeric"  ,12,2}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfTar
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathTar) == 0
	    DBCREATE(FileTar,aDbfTar,"DBFNTX")
	    Proteger(FileTar,nModCry)

       CASE DIRCHANGE(PathTar) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathTar)

       CASE DIRCHANGE(PathTar) == -5
	    cError('NO TIENE DERECHOS EN: '+PathTar)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 21/94 JUE A
						       DIC 21/94 JUE
OBJETIVOS:

1)- Recupera la estructura del archivo de Empresa

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfTar(lShared,nModCry,PathTar,FileTar)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathTar			      // Path del Archivo
       FileTar			      // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathTar+'\'+FileTar,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE TARIFAS")
       Termometro(100)
       CreaDbfTar(lShared,nModCry,PathTar,FileTar)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/2010 MAR A
       Colombia, Bucaramanga        INICIO: 05:00 PM   FEB 02/2010 MAR

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActDbfTar(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'TAR',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE TARIFAS')
	  CloseDbf('TAR',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := TAR->(DBSTRUCT())
       CloseDbf('TAR',PathArc+'\'+cNomArc,nModCry)
       CreaDbfTar(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
	  cError('El Archivo TARIFAS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfTar(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: VALOR DEL CONCEPTO FIJO MENSUAL                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de tarifas y conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Termina el programa si no existe el c¢digo o valor del concepto

4- Retorna el valor del concepto

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nValorTar(cCodGru,cCodCon,cNomCon,nValor2)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       cCodCon                              // C¢digo del concepto
       cNomCon                              // @Nombre del Concepto
       nValor2                              // @Valor2 del Concepto  */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nValor  := 0                  // Valor del concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL VALOR DEL CONCEPTO
       SELECT TAR
       GO TOP
       LOCATE FOR TAR->cCodigoGru == cCodGru .AND.;
		  TAR->cCodigoCon == cCodCon

       IF FOUND()
	  nValor  := TAR->nValorTar
	  nValor2 := TAR->nValor2Tar
       ELSE
	  nValor  := 0
	  nValor2 := 0
	 *No existe tarifa asignada
       ENDIF
*>>>>FIN LECTURA DEL VALOR DEL CONCEPTO

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       cNomCon := NIL
       SELECT CON
       GO TOP
       LOCATE FOR CON->cCodigoCon == cCodCon

       IF FOUND()
	  cNomCon := CON->cNombreCon
       ELSE
	  cNomCon := 'No Existe Con:'+cCodCon
	  nValor  := 0
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

*>>>>VALIDACION DEL NOMBRE DEL CONCEPTO
       IF cNomCon == SPACE(16)
	  cNomCon := 'No Existe Nom:'+cCodCon
	  nValor  := 0
       ENDIF
       RETURN nValor
*>>>>FIN VALIDACION DEL NOMBRE DEL CONCEPTO

/*************************************************************************
* TITULO..: VALOR DEL CONCEPTO MENSUAL VARIABLE                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2012 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ENE 19/2012 JUE

OBJETIVOS:

1- Calcula el valor del concepto de acuerdo al mes.

2- Retorna el valor del concepto.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrTarMes(cCodGru,nMesIni,cCodCon,cNomCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       nMesIni                              // Mes Inicial
       cCodCon                              // C¢digo del concepto
       cNomCon                              // @Nombre del Concepto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nValor := 0                    // Valor del concepto
       LOCAL cCampo := ''                   // Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL VALOR DEL CONCEPTO
       SELECT TAR
       GO TOP
       LOCATE FOR TAR->cCodigoGru == cCodGru .AND.;
		  TAR->cCodigoCon == cCodCon

       IF FOUND()
	  cCampo := 'TAR->nVlr'+cMes(nMesIni,3)+'Tar'
	  nValor := &cCampo
       ELSE
	  nValor  := 0
	 *No existe tarifa asignada
       ENDIF
*>>>>FIN LECTURA DEL VALOR DEL CONCEPTO

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       cNomCon := NIL
       SELECT CON
       GO TOP
       LOCATE FOR CON->cCodigoCon == cCodCon

       IF FOUND()
	  cNomCon := CON->cNombreCon
       ELSE
	  cNomCon := 'No Existe Con:'+cCodCon
	  nValor  := 0
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

*>>>>VALIDACION DEL NOMBRE DEL CONCEPTO
       IF cNomCon == SPACE(16)
	  cNomCon := 'No Existe Nom:'+cCodCon
	  nValor  := 0
       ENDIF
       RETURN nValor
*>>>>FIN VALIDACION DEL NOMBRE DEL CONCEPTO


/*************************************************************************
* TITULO..: VALOR DEL CONCEPTO POR VARIOS MESES VARIABLE                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2012 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ENE 19/2012 JUE

OBJETIVOS:

1- Calcula el valor de la tarifa de varios meses de acuerdo a tarifa
   variable de cada mes.

3- Retorna el valor del concepto de varios meses

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nTarIniFin(cCodGru,nMesIni,nMesFin,cConcep)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       nMesIni                              // Mes Inicial
       nMesFin                              // Mes Final
       cConcep			            // Conceptos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL    i,j  := 0                    // Contador
       LOCAL cCodCon := 0                    // C¢digo del Concepto
       LOCAL nVlrTar := 0                    // Valor de la Tarifa
       LOCAL nValor  := 0                    // Valor del concepto
       LOCAL cCampo  := ''                   // Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALOR DE LOS CONCEPTOS
       FOR i := 1 TO LEN(ALLTRIM(cConcep))/2

	   cCodCon := SUBS(cConcep,i*2-1,2)
	   FOR j := nMesIni TO nMesFin
	       nVlrTar := nVlrTarMes(cCodGru,j,cCodCon)
		nValor += nVlrTar
	   ENDFOR

       ENDFOR
       RETURN nValor
*>>>>FIN VALOR DE LOS CONCEPTOS

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DE LA TARIFA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo de Tarifas

2- Verifica la existencia del c¢digo compuesto por los c¢digos del grupo y
   del concepto

3- Deja el archivo en el registro localizado

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodTar(cCodTar,lMensaj)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodTar			            // C¢digo de la tarifa
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT TAR
       GO TOP
       LOCATE FOR TAR->cCodigoGru+TAR->cCodigoCon == cCodTar
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('LA TARIFA: '+SUBS(cCodTar,4,2)+' PARA EL CURSO: '+;
		     SUBS(cCodTar,1,3)+' NO SE ENCUENTRA')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE TARIFAS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Permite el mantenimiento del archivo Tarifas

SINTAXIS:

MantenTar()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTar(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
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
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL oBrowse := NIL                 // Browse de Tarifas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cIntUno := cIntUno
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)   .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS DE MANTENIMIENTO DE TARIFAS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
     *ÀArchivos del sistema
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nMesIniCaA == 0
	    cError('NO SE HA DEFINIDO EL MES INICIAL DE LA FACTURACION')

       CASE CAA->nMesFinCaA == 0
	    cError('NO SE HA DEFINIDO EL MES FINAL DE LA FACTURACION')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT TAR
       oBrowse := oDefBrwTar(lShared,00,00,22,79,cMaeAct)

       SETKEY(K_F5,{||BuscarTar(oBrowse)})

       SETKEY(K_F9,{||MenuOtrTar(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
				 cJorTxt,oBrowse)})

       TAR->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf)
       OrdenarTar(lShared,nModCry,cNomUsr,cPatSis+'\'+FileTar)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE TARIFAS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Define el objeto Browse del archivo Tarifas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwTar(lShared,nFilSup,nColSup,nFilInf,nColInf,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAct                              // Maestro Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL                 // Browse de Tarifas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE TARIFAS>>',;
			    '<ENTER>Modificar  <INS>Incluir  <F5>Buscar  '+;
			    '<DEL>Borrar  <ESC>Abandonar',;
			    {||IncluirTar(lShared,cMaeAct)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TAR
       oColumn	     := TBCOLUMNNEW('CURSO', {||TAR->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO DEL CONCEPTO', {||TAR->cCodigoCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:Freeze:= 2
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       DO CASE
       CASE CAA->nMtdFacCaA == 1

	   oColumn	     := TBCOLUMNNEW('VALOR1', {||TAR->nValorTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nValorTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	    oColumn	     := TBCOLUMNNEW('VALOR2', {||TAR->nValor2Tar})
	    oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nValor2Tar'},;
			      {'PICTURE','999999999.99'}}
	    oBrowse:ADDCOLUMN(oColumn)
	  *ÀDefinici¢n Columna

       CASE CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses

	   oColumn	     := TBCOLUMNNEW('ENE', {||TAR->nVlrEneTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrEneTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('FEB', {||TAR->nVlrFebTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrFebTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('MAR', {||TAR->nVlrMarTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrMarTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('ABR', {||TAR->nVlrAbrTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrAbrTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('MAY', {||TAR->nVlrMayTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrMayTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('JUN', {||TAR->nVlrJunTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrJunTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('JUL', {||TAR->nVlrJulTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrJulTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('AGO', {||TAR->nVlrAgoTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrAgoTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('SEP', {||TAR->nVlrSepTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrSepTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('OCT', {||TAR->nVlrOctTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrOctTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('NOV', {||TAR->nVlrNovTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrNovTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('DIC', {||TAR->nVlrDicTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nVlrDicTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

	   oColumn	     := TBCOLUMNNEW('VALOR', {||TAR->nValorTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nValorTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

       OTHERWISE
	   oColumn	     := TBCOLUMNNEW('VALOR', {||TAR->nValorTar})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TAR'}, {'FIELD','nValorTar'},;
			     {'PICTURE','999999999.99'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna
       ENDCASE

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE TARIFAS   	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Permite incluir un registro al archivo de Tarifas

SINTAXIS:

  IncluirTar()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirTar(lShared,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cMaeAct                              // Maestro Actual   */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       LOCAL lSiorNo := .F.                 // Variable control de flujo
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lGrabar := .F.                 // Grabar el registro
       LOCAL cGruIni := ''                  // Grupo Inicial
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL cCodCon := ''                  // C¢digo del concepto
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del grupo
       LOCAL nValorTta  := 0                // Valor de la tarifa No.1
       LOCAL nValor2Tta := 0                // Valor de la tarifa No.2

       LOCAL nVlrEneTta := 0                // Valor de la tarifa de Ene
       LOCAL nVlrFebTta := 0                // Valor de la tarifa de Feb
       LOCAL nVlrMarTta := 0                // Valor de la tarifa de Mar
       LOCAL nVlrAbrTta := 0                // Valor de la tarifa de Abr
       LOCAL nVlrMayTta := 0                // Valor de la tarifa de May
       LOCAL nVlrJunTta := 0                // Valor de la tarifa de Jun
       LOCAL nVlrJulTta := 0                // Valor de la tarifa de Jul
       LOCAL nVlrAgoTta := 0                // Valor de la tarifa de Ago
       LOCAL nVlrSepTta := 0                // Valor de la tarifa de Sep
       LOCAL nVlrOctTta := 0                // Valor de la tarifa de Oct
       LOCAL nVlrNovTta := 0                // Valor de la tarifa de Nov
       LOCAL nVlrDicTta := 0                // Valor de la tarifa de Dic
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DETALLES '+;
				 'DE LA DE LAS TARIFAS PARA '+;
				 cNomNiv(cMaeAct),22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
		 cGruIni := cSpaces('TAR','cCodigoGru')
		 cGruFin := cSpaces('TAR','cCodigoGru')
		 cCodCon := cSpaces('TAR','cCodigoCon')
	       nValorTta := 0
	      nValor2Tta := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET cCodCon PICT '@!';
				VALID lValConcep(ROW(),COL()-2,@cCodCon)

	    DO CASE
	    CASE CAA->nMtdFacCaA == 1
		 nNroFil++
		 @ nNroFil,nNroCol SAY 'VALOR1 DEL CONCEPTO:';
				     GET nValorTta  PICT '9999999.99'

		 nNroFil++
		 @ nNroFil,nNroCol SAY 'VALOR2 DEL CONCEPTO:';
				     GET nValor2Tta  PICT '9999999.99'

	    CASE CAA->nMtdFacCaA == 2 // Tarifas variables por meses

		 IF 1 >= CAA->nMesIniCaA .AND. 1 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA ENE.....:';
				      GET nVlrEneTta  PICT '9999999.99'
		 ENDIF

		 IF 2 >= CAA->nMesIniCaA .AND. 2 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA FEB.....:';
				      GET nVlrFebTta  PICT '9999999.99'
		 ENDIF

		 IF 3 >= CAA->nMesIniCaA .AND. 3 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA MAR.....:';
				      GET nVlrMarTta  PICT '9999999.99'
		 ENDIF

		 IF 4 >= CAA->nMesIniCaA .AND. 4 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA ABR.....:';
				      GET nVlrAbrTta  PICT '9999999.99'
		 ENDIF

		 IF 5 >= CAA->nMesIniCaA .AND. 5 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA MAY.....:';
				      GET nVlrMayTta  PICT '9999999.99'
		 ENDIF

		 IF 6 >= CAA->nMesIniCaA .AND. 6 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA JUN.....:';
				      GET nVlrJunTta  PICT '9999999.99'
		 ENDIF

		 IF 7 >= CAA->nMesIniCaA .AND. 7 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA JUL.....:';
				      GET nVlrJulTta  PICT '9999999.99'
		 ENDIF

		 IF 8 >= CAA->nMesIniCaA .AND. 8 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA AGO.....:';
				      GET nVlrAgoTta  PICT '9999999.99'
		 ENDIF

		 IF 9 >= CAA->nMesIniCaA .AND. 9 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA SEP.....:';
				      GET nVlrSepTta  PICT '9999999.99'
		 ENDIF

		 IF 10 >= CAA->nMesIniCaA .AND. 10 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA OCT.....:';
				      GET nVlrOctTta PICT '9999999.99'
		 ENDIF

		 IF 11 >= CAA->nMesIniCaA .AND. 11 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA NOV.....:';
				      GET nVlrNovTta PICT '9999999.99'
		 ENDIF

		 IF 12 >= CAA->nMesIniCaA .AND. 12 <= CAA->nMesFinCaA
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR PARA DIC.....:';
				      GET nVlrDicTta PICT '9999999.99'
		 ENDIF

	    OTHERWISE
		    nNroFil++
		    @ nNroFil,nNroCol SAY 'VALOR DEL CONCEPTO :';
				      GET nValorTta  PICT '9999999.99'
	    ENDCASE

	    nNroFil += 2
	    @ nNroFil,nNroCol SAY 'GRUPO INICIAL      :';
			      GET cGruIni PICT '9999';
			     VALID lValGrupo(ROW(),COL()-4,@cGruIni,@nRegIni)

	    nNroFil++
	    @ nNroFil,nNroCol SAY 'GRUPO FINAL        :';
			      GET cGruFin PICT '9999';
			      VALID lValGrupo(ROW(),COL()-4,@cGruFin,@nRegFin)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE CAA->nMtdFacCaA == 2 // Tarifas variables por meses

		 lSiorNo := .F.
		 IF cCodCon == cSpaces('TAR','cCodigoCon')

		    cError('DEBE ESPECIFICAR EL CONCEPTO A FACTURAR.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF cGruIni == cSpaces('TAR','cCodigoGru') .OR.;
		    cGruFin == cSpaces('TAR','cCodigoGru')

		    cError('DEBE ESPECIFICAR EL INTERVALOR DE LOS GRUPOS.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 1 >= CAA->nMesIniCaA .AND. 1 <= CAA->nMesFinCaA .AND.;
		    nVlrEneTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA ENERO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 2 >= CAA->nMesIniCaA .AND. 2 <= CAA->nMesFinCaA .AND.;
		    nVlrFebTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA FEBRERO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 3 >= CAA->nMesIniCaA .AND. 3 <= CAA->nMesFinCaA .AND.;
		    nVlrMarTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA MARZO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 4 >= CAA->nMesIniCaA .AND. 4 <= CAA->nMesFinCaA .AND.;
		    nVlrAbrTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA ABRIL.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 5 >= CAA->nMesIniCaA .AND. 5 <= CAA->nMesFinCaA .AND.;
		    nVlrMayTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA MAYO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 6 >= CAA->nMesIniCaA .AND. 6 <= CAA->nMesFinCaA .AND.;
		    nVlrJunTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA JUNIO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 7 >= CAA->nMesIniCaA .AND. 7 <= CAA->nMesFinCaA .AND.;
		    nVlrJulTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA JULIO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 8 >= CAA->nMesIniCaA .AND. 8 <= CAA->nMesFinCaA .AND.;
		    nVlrAgoTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA AGOSTO.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 9 >= CAA->nMesIniCaA .AND. 9 <= CAA->nMesFinCaA .AND.;
		    nVlrSepTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA SEPTIEMBRE.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 10 >= CAA->nMesIniCaA .AND. 10 <= CAA->nMesFinCaA .AND.;
		    nVlrOctTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA OCTUBRE.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 11 >= CAA->nMesIniCaA .AND. 11 <= CAA->nMesFinCaA .AND.;
		    nVlrNovTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA NOVIEMBRE.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF 12 >= CAA->nMesIniCaA .AND. 12 <= CAA->nMesFinCaA .AND.;
		    nVlrDicTta == 0

		    cError('DEBE ESPECIFICAR EL VALOR PARA DICIEMBRE.'+;
			   'NO SE ASIGNAN TARIFAS')

		    lSiorNo := .T.

		 ENDIF

		 IF !lSiorNo
		    lGrabar := .T.
		 ENDIF

	    OTHERWISE

		 IF cCodCon == cSpaces('TAR','cCodigoCon') .OR.;
		    cGruIni == cSpaces('TAR','cCodigoGru') .OR.;
		    cGruFin == cSpaces('TAR','cCodigoGru') .OR.;
		    nValorTta == 0

		      cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			     'NO SE ASIGNAN TARIFAS')
		 ELSE
		    lGrabar := .T.
		 ENDIF

	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR LAS TARIFAS PARA LOS GRUPOS '+;
			    'ESCOGIDOS? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DE LAS TARIFAS
       SELECT GRU
       GO nRegIni
       DO WHILE RECNO() <= nRegFin .AND. lGrabar

**********ANALISIS PARA LA GRABACION
	    SELECT TAR
	    GO TOP
	    IF lLocCodTar(GRU->cCodigoGru+cCodCon,.F.)
	       lGrabar := TAR->(lRegLock(lShared,.F.))
	    ELSE
	       lGrabar := TAR->(lRegLock(lShared,.T.))
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION

**********GRABACION DE LA TARIFA PARA EL GRUPO
	    IF lGrabar
	       REPL TAR->cCodigoGru WITH GRU->cCodigoGru
	       REPL TAR->cCodigoCon WITH cCodCon
	       REPL TAR->nValorTar  WITH nValorTta
	       IF CAA->nMtdFacCaA == 1
		  REPL TAR->nValor2Tar  WITH nValor2Tta
	       ENDIF
	       IF CAA->nMtdFacCaA == 2
		  REPL TAR->nVlrEneTar WITH nVlrEneTta
		  REPL TAR->nVlrFebTar WITH nVlrFebTta
		  REPL TAR->nVlrMarTar WITH nVlrMarTta
		  REPL TAR->nVlrAbrTar WITH nVlrAbrTta
		  REPL TAR->nVlrMayTar WITH nVlrMayTta
		  REPL TAR->nVlrJunTar WITH nVlrJunTta
		  REPL TAR->nVlrJulTar WITH nVlrJulTta
		  REPL TAR->nVlrAgoTar WITH nVlrAgoTta
		  REPL TAR->nVlrSepTar WITH nVlrSepTta
		  REPL TAR->nVlrOctTar WITH nVlrOctTta
		  REPL TAR->nVlrNovTar WITH nVlrNovTta
		  REPL TAR->nVlrDicTar WITH nVlrDicTta
	       ENDIF
	       TAR->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       TAR->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA TARIFA PARA EL GRUPO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       RETURN NIL
*>>>>FIN GRABACION DE LAS TARIFAS


/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DE LA TARIFA EN EL BROWSE     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/94 VIE A
						       JUL 08/94 VIE
OBJETIVOS:

1- Debe estar en uso los archivos de Tarifas, Grupos y Conceptos

2- Busca el c¢digo de la tarifa compuesto por los c¢digos del grupo y
   del concepto dentro del Browse de Tarifas

3- Retorna NIL

SINTAXIS:

  BuscarTar(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarTar(oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     oBrowse				    // Browse de Tarifas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegTar := 0                   // Registro de Tarifa
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodGru := ''               // C¢digo del Grupo
       LOCAL cCodCon := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       TitBuscar(LEN(cSpaces('TAR','cCodigoGru'))+;
		 LEN(cSpaces('TAR','cCodigoCon'))+1,@nNroFil,@nNroCol)

       cCodGru := cSpaces('TAR','cCodigoGru')
       cCodCon := cSpaces('TAR','cCodigoCon')

       @ nNroFil,nNroCol GET cCodGru PICT '9999';
			 VALID lValGrupo(ROW(),COL()-4,@cCodGru)

       @ nNroFil,nNroCol+LEN(cSpaces('TAR','cCodigoCon'))+2;
			 GET cCodCon PICT '@!';
			 VALID lValConcep(ROW(),COL()-2,@cCodCon)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE cCodGru == cSpaces('TAR','cCodigoGru') .AND.;
	    cCodCon == cSpaces('TAR','cCodigoCon')

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       CASE cCodGru == cSpaces('TAR','cCodigoGru') .OR.;
	    cCodCon == cSpaces('TAR','cCodigoCon')

	    cError('PATRON DE BUSQUEDA INCOMPLETO',;
		   'ADVERTENCIA')
       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT TAR
       IF lBuscar .AND. lLocCodTar(cCodGru+cCodCon)
	  nRegTar := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegTar
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENACION DE UN ARCHIVO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/96 DOM A
       Bucaramanga, Colombia        INICIO: 06:45 PM   FEB 25/96 DOM

OBJETIVOS:

1)- Permite Ordenar el maestro de alumnos seleccionado

2)- Permite activar el nivel de estudios Jardin, Primaria o Bachillerato

3)- Retorna las tres iniciales del nivel de estudios

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenarTar(lShared,nModCry,cNomUsr,FileDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Compartir Archivos
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       FileDbf                              // Archivo a Ordenar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ARCHIVO
       FileTem := SUBS(cNomUsr,1,3)+FileTem+cExtTem
       IF FILE(FileTem)
	  cError(ALLTRIM(cNomUsr)+;
		 ' ESTA ORDENANDO. NO PUEDE UTILIZAR EL MISMO USUARIO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>COPIA DEL ARCHIVO
       FILECOPY(FileDbf,;
		DIRNAME()+'\'+FileTem)
*>>>>FIN COPIA DEL MAESTRO PARA EL ORDENAMIENTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,DIRNAME()+'\'+;
		      FileTem,'TEM',NIL,.F.,nModCry)
	  cError('ABRIENDO ARCHIVO MAESTRO TEMPORAL EN '+DIRNAME())
	  CloseDbf('TEM',FileTem,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TEM->(RECCOUNT()) == 0
	    cError('NO EXISTEN TEMMNOS GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('TEM',FileTem,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ORDENAMIENTO DEL MAESTRO
       TERMOMETRO(0,'ORDENANDO EL ARCHIVO TARIFAS')
       TERMOMETRO(50)
       SORT TO &(FileDbf) ;
	    ON cCodigoGru,cCodigoCon
       TERMOMETRO(100)
*>>>>FIN ORDENAMIENTO DEL MAESTRO

*>>>>PROTECCION DEL ARCHIVO ORDENADO
       nModCry := IF(EMPTY(nModCry),0,nModCry)
       IF nModCry # 0
	  Proteger(FileDbf,nModCry)
       ENDIF
*>>>>FIN PROTECCION DEL ARCHIVO ORDENADO

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       CloseDbf('TEM',FileTem,nModCry)
       IF !lFileDelete(DIRNAME()+'\'+FileTem)
	  cError('NO SE BORRO EL MAESTRO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO..: VALOR DE LOS CONCEPTOS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2001 LUN A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 21/2001 LUN

OBJETIVOS:

1- Calcula el Total de los Conceptos

2- Retorna el Total

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nTotalCon(cCodGru,cCodCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       cCodCon                              // C¢digos de los Conceptos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL          i := 0                // Contador
       LOCAL     nTotal := 0                // Total Conceptos
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TOTALIZACION DE LOS CONCEPTOS
       SELECT TAR
       FOR i:=1 TO LEN(cCodCon)/2

	   TAR->(DBGOTOP())
	   cCodigoTco := SUBS(cCodCon,i*2-1,2)
	   LOCATE FOR TAR->cCodigoGru == cCodGru .AND.;
		      TAR->cCodigoCon == cCodigoTco

	   IF FOUND()
	      nTotal += TAR->nValorTar
	   ENDIF
       ENDFOR
       RETURN nTotal
*>>>>FIN TOTALIZACION DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 24/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   FEB 24/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrTar(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
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
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<IMPRESION DE TARIFAS')

       AADD(aAyuda,'Permite Imprimir las Tarifas para la facturaci¢n')

       IF LEN(aMenus) == 1
	  nNroOpc := 1
       ELSE
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrTar011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,oBrowse)
	   *Impresi¢n de las Tarifas

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION DE LAS TARIFAS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 24/2004 MIE A
       Colombia, Bucaramanga        INICIO: 10:10 AM   FEB 24/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite imprimir el archivo con caracteristicas especificas

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTar011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,;
		   cMaeAlu,cMaeAct,cJorTxt,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
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
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe Espec¡fico
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos Encabezados para impresi¢n
       LOCAL aRegPrn := {}                  // Regitros para impresi¢n
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
       LOCAL aRegXml := {}                  // Registros Xml
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := nTotReg+nLinTot
       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'RELACION DE TARIFAS DE COBRO',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,06)
       AADD(aTitPrn,'GRUPO ')

       AADD(aNroCol,20)
       AADD(aTitPrn,'CONCEPTO')

       DO CASE
       CASE CAA->nMtdFacCaA == 1

	    AADD(aNroCol,12)
	    AADD(aTitPrn,'VALOR1')

	    AADD(aNroCol,12)
	    AADD(aTitPrn,'VALOR2')

       CASE CAA->nMtdFacCaA == 2

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'ENE')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'FEB')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'MAR')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'ABR')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'MAY')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'JUN')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'JUL')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'AGO')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'SEP')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'OCT')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'NOV')

	    AADD(aNroCol,08)
	    AADD(aTitPrn,'DIC')

       OTHERWISE
	    AADD(aNroCol,12)
	    AADD(aTitPrn,'VALOR ')
       ENDCASE

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn :='tarifas'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

/*
*>>>>APERTURA DEL ARCHIVO XML
       FileXml := cPatSis+'\FILEWWW\'+'tarifas.xml'

       nHanXml := nOpenXml(FileXml,aCabPrn)
       IF EMPTY(nHanXml)
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO XML
*/

*>>>>IMPRESION DEL TERMOMETRO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO LAS TARIFAS')
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT TAR
       GO TOP
       DO WHILE .NOT. TAR->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('REGISTROS: '+TAR->(STR(RECNO(),5))+'/'+;
				       TAR->(STR(RECCOUNT(),5)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DEL CONCEPTO
	    IF lLocCodigo('cCodigoCon','CON',TAR->cCodigoCon)
	       cNombreTco := CON->cNombreCon
	    ELSE
	       cNombreTco := 'Concepto NO existe'
	    ENDIF
**********FIN LOCALIZACION DEL CONCEPTO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aRegPrn := {}

	    AADD(aRegPrn,TAR->cCodigoGru)
	    AADD(aRegPrn,TAR->cCodigoCon+':'+cNombreTco)

	    DO CASE
	    CASE CAA->nMtdFacCaA == 1

		 AADD(aRegPrn,TRANS(TAR->nValorTar,'@Z ####,###,###'))
		 AADD(aRegPrn,TRANS(TAR->nValor2Tar,'@Z ####,###,###'))

	    CASE CAA->nMtdFacCaA == 2

		 AADD(aRegPrn,TRANS(TAR->nVlrEneTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrFebTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrMarTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrAbrTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrMayTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrJunTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrJulTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrAgoTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrSepTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrOctTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrNovTar,'@Z ####,###'))
		 AADD(aRegPrn,TRANS(TAR->nVlrDicTar,'@Z ####,###'))

	    OTHERWISE
		 AADD(aRegPrn,TRANS(TAR->nValorTar,'@Z ####,###,###'))
	    ENDCASE

*	    SaveRegXml(FileXml,nHanXml,aRegPrn,aTitPrn)

	    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( TAR->(RECNO()) / TAR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT TAR
	    TAR->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*       CloseXml(FileXml,nHanXml)
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,PCL('n20Stan'))
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       SET FILTER TO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: CONCEPTOS A FACTURAR GENERALES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 10/2005 MAR A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   ENE 10/2005 MAR

OBJETIVOS:

1- Crea un vector con los conceptos a facturar.

2- El vector de conceptos esta formado con Codigo del Concepto,Mes Inicial
   y final de facturaci¢n, Valor del Concepto, Nombre del Concepto y el
   n£mero del registro del Concepto

3- Retorna el vector con los conceptos a facturar.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aConGen(cCodEst,cConGen,cConEst,cCodGru,nIniPag,nFinPag,nUltRec)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cConGen                              // Conceptos Generar a facturar
       cConEst                              // Conceptos Individuales a Facturar
       cCodGru                              // C¢digo del Grupo
       nIniPag                              // Mes Inicial del Pago
       nFinPag                              // Mes Final del Pago
       nUltRec                              // Ultimo recibo del Estudiante
       lHayCoE                              // Hay Conceptos Individuales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aConcep := {}                  // Conceptos a facturar
       LOCAL nMesIni := 0                   // Mes Inicial del Pago
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL cConcep := ''                  // Conceptos facturados

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ULTIMO RECIBO
       IF nUltRec # 0
	  IF nIniPag > nUltRec
	     RETURN aConcep
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL ULTIMO RECIBO

*>>>>CONCEPTOS GENERALES
       cConcep := ALLTRIM(cConGen)+ALLTRIM(cConEst)

       FOR i := 1 TO LEN(ALLTRIM(cConcep))/2

	   cCodigoTco := SUBS(cConcep,i*2-1,2)

	   nVlrCon := nValorTar(cCodGru,cCodigoTco,@cNombreTco)

	   AADD(aConcep,{cCodigoTco,;     // 1. C¢digo del Concepto
			 nIniPag,;        // 2. Mes Inicial
			 CAA->nMesFinCaA,;// 3. Mes Final
			 nVlrCon,;        // 4. Valor del Concepto
			 cNombreTco,;     // 5. Nombre del Concepto
			 CON->(RECNO()),; // 6. Numero del Registro
			 IF(cCodigoTco $ cConGen,.F.,.T.)}) // 7. .F. General .T. Individual
       NEXT
       RETURN aConcep
*>>>>FIN CONCEPTOS GENERALES

/*************************************************************************
* TITULO..: CONCEPTOS A FACTURAR INDIVIDUALES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 10/2005 MAR A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   ENE 10/2005 MAR

OBJETIVOS:

1- Crea un vector con los conceptos a facturar.

2- El vector de conceptos esta formado con Codigo del Concepto,Mes Inicial
   y final de facturaci¢n, Valor del Concepto, Nombre del Concepto y el
   n£mero del registro del Concepto

3- Retorna el vector con los conceptos a facturar.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aConEst(cCodEst,cConGen,cConEst,cCodGru,nIniPag,nFinPag,nUltRec,;
		 lPrnCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cConGen                              // Conceptos Generar a facturar
       cConEst                              // Conceptos Individuales a Facturar
       cCodGru                              // C¢digo del Grupo
       nIniPag                              // Mes Inicial del Pago
       nFinPag                              // Mes Final del Pago
       nUltRec                              // Ultimo recibo del Estudiante
       lPrnCon                              // Imprimir Recibos por Conceptos Individuales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aConcep := {}                  // Conceptos a facturar
       LOCAL nMesIni := 0                   // Mes Inicial del Pago
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL cConcep := ''                  // Conceptos facturados

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ULTIMO RECIBO
       lPrnCon := IF(lPrnCon == NIL,.F.,lPrnCon)
       IF nUltRec # 0
	  IF nIniPag > nUltRec
	     RETURN aConcep
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL ULTIMO RECIBO

*>>>>CONCEPTOS INDIVIDUALES
       cConcep := ALLTRIM(cConGen)+ALLTRIM(cConEst)
       FOR i := 1 TO LEN(cConcep)/2

***********LOCALIZACION DEL CONCEPTO
	     cCodigoTco := SUBS(cConcep,i*2-1,2)
	     SELECT COE
	     COE->(DBGOTOP())
	     LOCATE FOR COE->cCodigoEst == cCodEst .AND.;
			COE->cCodigoCon == cCodigoTco
***********FIN LOCALIZACION DEL CONCEPTO

***********INICIALIZACION DE LOS MESES DE LOS CONCEPTOS
	     IF COE->(FOUND())

		nMesIni := LEN(RTRIM(COE->cMesPagCli))
		DO CASE
		CASE nMesIni == 0  // Sin Facturar


*====================SIN FACTURAR
		       nMesIni := COE->nMesIniPag
		       nMesFin := COE->nMesFinPag
*====================FIN SIN FACTURAR

		CASE nMesIni # 0 .AND.;
		     SUBS(COE->cMesPagCli,nMesIni,1) == 'F'

*====================SOLO FACTURADO SIN DEUDAS
		       nMesIni := AT('F',COE->cMesPagCli)
		       nMesFin := COE->nMesFinPag
*====================FIN SOLO FACTURADO SIN DEUDAS

		CASE nMesIni # 0 .AND.;
		     SUBS(COE->cMesPagCli,nMesIni,1) == '*'

*====================SOLO FACTURADO CON DEUDAS
		       nMesIni := AT('*',COE->cMesPagCli)
		       nMesFin := COE->nMesFinPag
*====================FIN SOLO FACTURADO CON DEUDAS

		CASE nMesIni # 0 .AND. ;
		    (SUBS(COE->cMesPagCli,nMesIni,1) # ' ' .OR.;
		     SUBS(COE->cMesPagCli,nMesIni,1) # 'F' .OR.;
		     SUBS(COE->cMesPagCli,nMesIni,1) # '*')


*====================CONCEPTO CANCELADO
		       nMesIni := LEN(RTRIM(COE->cMesPagCli))
		       nMesFin := COE->nMesFinPag
		       IF nMesIni < COE->nMesFinPag

			  IF nIniPag <= nMesIni
			     nMesIni := 0
			     nMesFin := 0
			    *Mes Facturado mayor al mes a facturar
			  ELSE

			     IF lPrnCon

				IF nIniPag == nMesIni+1
				   nMesIni++
				   nMesFin := COE->nMesFinPag
				 *ÀFacturaci¢n del Mes Actual
				ELSE
				   cError('SE VA A FACTURAR '+cCodigoTco+;
					  ' EN '+cMes(nIniPag),;
					  cCodigoTco+' FACTURADO HASTA '+;
					  cMes(nMesIni),;
					  'Favor Confirmar')
				   nMesIni := nIniPag
				   nMesFin := IF(nIniPag > nMesFin,;
						 nIniPag,nMesFin)
				 *ÀFacturaci¢n posterior al mes actual
				ENDIF

			     ELSE
				nMesIni++
				nMesFin := COE->nMesFinPag
			     ENDIF

			  ENDIF

		       ELSE
			  nMesIni := 0
			  nMesFin := 0
		       ENDIF
*====================FIN CONCEPTO CANCELADO

		ENDCASE

	     ELSE
		nMesIni := nIniPag
		nMesFin := nFinPag
	      *ÀMeses conceptos individuales no habilitados
	     ENDIF
***********FIN INICIALIZACION DE LOS MESES DE LOS CONCEPTOS

***********HABILITACION DEL CONCEPTO
	     IF nMesIni # 0 .AND. nMesFin # 0

		nVlrCon := nValorTar(cCodGru,cCodigoTco,@cNombreTco)

		AADD(aConcep,{cCodigoTco,;     // 1. C¢digo del Concepto
			      nMesIni,;        // 2. Mes Inicial
			      nMesFin,;        // 3. Mes Final
			      nVlrCon,;        // 4. Valor del Concepto
			      cNombreTco,;     // 5. Nombre del Concepto
			      CON->(RECNO()),; // 6. Numero del Registro
			      IF(cCodigoTco $ cConGen,.F.,.T.)}) // 7. .F. General .T. Individual
	     ENDIF
***********HABILITACION DEL CONCEPTO

       NEXT
       RETURN aConcep
*>>>>FIN CONCEPTOS INDIVIDUALES
