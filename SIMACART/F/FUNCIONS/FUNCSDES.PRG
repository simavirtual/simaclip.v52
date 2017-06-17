/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DESCUENTO

REQUERIMIENTOS:

- Compilar: clipper FuncsDes /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Descuentos

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: TIPO DE DESCUENTO                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2003 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   SEP 26/2003 VIE

OBJETIVOS:

1- Debe estar ubicado en el Registro Respectivo

2- Describe el tipo de descuento

3- Retorna el Nombre del tipo de Descuento

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTipDes()

*>>>>DESCRIPCION DE VARIABLES
       LOCAL cTipDes := ''                  // Nombre del Tipo de Descuento
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>ANALISIS DEL TIPO DE DESCUENTO
       DO CASE
       CASE DES->nTipDesDes == 1  // Descuento
	    cTipDes := 'DESCUENTO'

       CASE DES->nTipDesDes == 2  // Recargo
	    cTipDes := 'RECARGO'

       CASE DES->nTipDesDes == 3  .AND. !DES->lDesEfeDes // Abono
	    cTipDes := 'ABONO'

       CASE DES->nTipDesDes == 3 .AND. DES->lDesEfeDes // Abono Descuento
	    cTipDes := 'ABONO DESCUE'

       CASE DES->nTipDesDes == 4  // Pago Parcial
	    cTipDes := 'PAGO PARCIAL'

       OTHERWISE
	    cTipDes := 'ERROR TipoDes'
       ENDCASE
       RETURN cTipDes
*>>>>FIN ANALISIS DEL TIPO DE DESCUENTO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE DESCUENTOS		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:

1- Permite el mantenimiento del archivo Descuentos

SINTAXIS:

MantenDes()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenDes(aParam1,aParam2,aParam3)

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

       LOCAL oBrowse := NIL                 // Browse de Descuentos

       LOCAL cCodigoTba := ''               // C¢digo del Banco
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
       PathCarAno(lShared,cPatSis,cAnoUsr,;
		  @cIntUno,@cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTE BANCOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cCodigoTba := BAN->cCodigoBan
       CloseAll(aUseDbf)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
		     fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileFpg,'FPG',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})

       FileTmv := FileTmv+cCodigoTba+ExtFile
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTmv,'TMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lNoRed,nModCry})

       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS DE ALUMNOS O DESCUENTOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LOCALIZACION DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',cCodigoTba)
	  cError('NO EXISTE EL CODIGO DEL BANCO:'+cCodigoTba)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL BANCO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT DES

       oBrowse := oDefBrwDes(lShared,nFilPal+1,00,22,79,nFilInf,nColInf,;
			     nFilPal,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			     cMaeAlu,cPatSis,lAnoAct)
       SETKEY(K_F5,{||BuscarDes(lShared,cPatSis,oBrowse)})

       SETKEY(K_F9,{||MenuOtrDes(aParam1,aParam2,aParam3,;
				 oBrowse)})

       DES->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE DESCUENTOS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/94 SAB A
						       JUL 09/94 SAB
OBJETIVOS:

1- Define el objeto Browse del archivo Descuentos

SINTAXIS:

 oBrowse := oDefBrwDes(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwDes(lShared,nFilSup,nColSup,nFilInf,nColInf,nNroFil,;
		    nNroCol,nFilPal,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		    cMaeAlu,cPatSis,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maetros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Descuentos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'


       oBrowse:Cargo     := {'<<MANTENIMIENTO DE DESCUENTOS Y RECARGOS>>',;
			    '<F5>Buscar '+;
			    '<INS>Incluir <F9>Imprimir <ESC>Abandonar',;
			    {||IncluirDes(lShared,nNroFil,nNroCol,nFilPal,;
					  cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
					  cMaeAlu,cPatSis,lAnoAct)}}


     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras


       SELECT DES
       oColumn	     := TBCOLUMNNEW('CODIGO', {||DES->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:Freeze:= 2
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL ESTUDIANTE',;
				    {||IF(DES->(EOF()),SPACE(50),;
				     cSekNomAlu(DES->cCodigoEst,;
				     cMaeAlu,'DES',lAnoAct))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
       oColumn:Width := 50
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',{||IF(DES->(EOF()),SPACE(10),;
					     cMes(DES->nNroMesDes))})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 10
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR',{||IF(DES->(EOF()),SPACE(12),;
					       DES->nValorDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEUDA A¥O ANTERIOR',{||IF(DES->(EOF()),SPACE(12),;
					       DES->nSdoAnoDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA A¥O ANTERIOR',{||IF(DES->(EOF()),SPACE(12),;
					       DES->nMorAnoDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CLASE',;
			{||IF(DES->(EOF()),SPACE(12),;
			   cNombreDes(DES->nTipDesDes,12))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION', {||DES->cDescriDes})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 50
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;LA NOVEDAD',;
				    {||cFecha(DES->dFechaDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF CAA->lForPagCaA
	  oColumn	     := TBCOLUMNNEW('TIPO;DE PAGO',{||DES->cCodigoFpg})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cCodigoFpg'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF CAA->lForPagCaA
	  oColumn := TBCOLUMNNEW('DOCUMENTO DEL;TIPO DE PAGO',;
				{||DES->cNroFpgDes})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cNroFpgDes'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('RECIBO No',{||DES->nNroFacCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nNroFacCaA'},;
			 {'PICTURE','999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS',{||DES->cConcepDes})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cConcepDes'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 1', {||DES->nVlrCo1Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo1Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 2', {||DES->nVlrCo2Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo2Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 3', {||DES->nVlrCo3Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo3Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 4', {||DES->nVlrCo4Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo4Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 5', {||DES->nVlrCo5Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo5Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 6', {||DES->nVlrCo6Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo6Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 7', {||DES->nVlrCo7Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo7Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 8', {||DES->nVlrCo8Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo8Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF CAA->lNomConDes
	  oColumn	     := TBCOLUMNNEW('CONCEPTO FACTURA;RECARGO', {||DES->cNombreCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cNombreCon'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('BANCO',{||DES->cCodigoBan})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','DES'},{'FIELD','cCodigoBan'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||DES->cNomUsrDes})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(DES->dFecUsrDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||DES->cHorUsrDes})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DE LA TARIFA EN EL BROWSE     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 11/94 LUN A
						       JUL 11/94 LUN
OBJETIVOS:

1- Debe estar en uso los archivos de Descuentos

2- Busca el c¢digo del descuentos compuesto por el c¢digo del estudiante y
   el n£mero del mes del descuento

3- Retorna NIL

SINTAXIS:

  BuscarDes(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarDes(lShared,cPatSis,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       oBrowse				    // Browse de Descuentos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegTar := 0                   // Registro de Tarifa
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL nNroMesTde := 0                // Mes del descuento
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DEL INDICE
       IF lShared
	  DBSETINDEX(cPatSis+'\'+fNtxDes)
       ELSE
	  SET INDEX TO (cPatSis+'\'+fNtxDes)
       ENDIF
*>>>>FIN ACTIVACION DEL INDICE

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON

       cCodigoTes := cSpaces('DES','cCodigoEst')
       nNroMesTde := 0
       TitBuscar(LEN(cCodigoTes)+2,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lCorrecion(@cCodigoTes)

       @ nNroFil,COL()+1 GET nNroMesTde PICT '99' VALID;
			 lValMesDes(ROW(),COL()-2,@nNroMesTde)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       lBuscar := .F.
       DO CASE
       CASE EMPTY(cCodigoTes) .AND. EMPTY(nNroMesTde)
	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       CASE EMPTY(cCodigoTes) .OR. EMPTY(nNroMesTde)
	    cError('PATRON DE BUSQUEDA INCOMPLETO',;
		   'ADVERTENCIA')
       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT DES
       IF lBuscar .AND. lSekDesAbo(cCodigoTes,nNroMesTde)
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
* TITULO DE LA FUNCION..: VALIDACION DEL MES DEL DESCUENTO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 12/94 MAR A
						       JUL 12/94 MAR
OBJETIVOS:

1- Debe estar en uso los archivos de Descuentos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Valida el mes del descuento, en caso de error permite seleccionar
   el mes correcto

4- Retorna .T.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValMesDes(nNroFil,nNroCol,nNroMes)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nNroMes				    // @N£mero del mes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE nNroMes > 0 .AND. nNroMes <= 12
       OTHERWISE
	    nNroMes := VAL(cSelMes(nNroFil,nNroCol))
	    lHayErr := .F.
       ENDCASE
       RETURN .T.
*>>>>FIN FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE LOS DESCUENTOS O RECARGOS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 21/94 JUE A
						       JUL 21/94 JUE
1- Permiter defenir los clientes que tienen descuento o recargos para
   un mes especifico.

2- Retorna NIL


SINTAXIS:

  IncluirDes()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirDes(lShared,nFilInf,nColInf,nFilPal,cNomEmp,;
		    cNomSis,cNomUsr,cAnoUsr,cMaeAlu,cPatSis,;
		    lAnoAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior del Men£
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr			            // A¤o del Usuario
       cMaeAlu                              // Maestros Habilitados
       cPatSis                              // Path del sistema
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cTxtTem := ''                  // Texto temporal

       LOCAL       i := 0                   // Contador
       LOCAL cTipDes := ''                  // Tipo de Descuento
       LOCAL nNroOpc := 0                   // N£mero de opci¢n
       LOCAL lncluir := .T.                 // .T. Incluir
       LOCAL lGrabar := .F.                 // Grabar el registro
       LOCAL nRegDes := 0                   // Registro del Descuento
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cConcep := ''                  // Conceptos
       LOCAL aVlrCon[8]                     // Valor de los Conceptos
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL nNroMesTde := 0                // Mes del descueto/Recargo
       LOCAL nTipDesTde := 0                // Tipo de Descuento
       LOCAL cDescriTde := ''               // Descripci¢n
       LOCAL  nValorTde := 0                // Valor descuento/Recargo
       LOCAL dFechaTde  := CTOD('00/00/00') // Fecha del Descuento
       LOCAL cNombreTco := ''               // Nombre del Descuento

       LOCAL cNroFpgTde := ''               // N£mero de la forma de pago
       LOCAL cCodigoTfp := ''               // C¢digo de la forma de pago
       LOCAL cTituloTfp := ''               // T¡tulo de la forma de pago
       SETCURSOR(1)                         // Activaci¢n del cursor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DEL INDICE
       IF lShared
	  DBSETINDEX(cPatSis+'\'+fNtxDes)
       ELSE
	  SET INDEX TO (cPatSis+'\'+fNtxDes)
       ENDIF
*>>>>FIN ACTIVACION DEL INDICE

*>>>>SELECION DE MES A PROCESAR
       nNroMesTde := nMesano(nFilInf+1,IF(nColInf>30,30,nColInf),NIL,.F.)
       IF nNroMesTde == 0
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE MES A PROCESAR

*>>>>VALIDACION DE LA CONCILIACION
       IF SUBS(CAA->cValConCaA,nNroMesTde,1) # SPACE(01)

	  cError('EL MES DE '+cMes(nNroMesTde,10)+' '+;
		 'YA SE REPORTO A CONTABILIDAD')
	  RETURN NIL

       ENDIF
       LineaEstado('MES DE PROCESO: '+cMes(nNroMesTde,10),cNomSis)
*>>>>FIN VALIDACION DE LA CONCILIACION

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DESCUENTOS'+;
			 ' O RECARGOS PARA EL MES ESCOGIDO',22,'°')

       aTamCol := {06,06,26,16,10,10}
       aTitulo := {'CODIGO'      ,'GRUPO '    ,'NOMBRE',;
		   'DESCRIPCION ','VALOR     ','TIPO'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS DESCUENTOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL ESTUDIANTE
	     cNombreTes := SUBS(cNombreTes,1,26)
	     @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	     @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN IMPRESION DEL ESTUDIANTE

**********INICIALIZACION DEL VALOR DE LOS CONCEPTOS
	    FOR i := 1 TO 8
	       aVlrCon[i] := 0
	    ENDFOR
**********FIN INICIALIZACION DEL VALOR DE LOS CONCEPTOS

**********LECTURA DEL DESCUENTO ACTUAL
	    IF lSekCodDes(cCodigoTes,nNroMesTde,.F.)
	       cDescriTde := DES->cDescriDes
		nValorTde := DES->nValorDes
		FOR i := 1 TO (LEN(cConcep)/2)
		   aVlrCon[i] := &('DES->nVlrCo'+STR(i,1)+'Des')
		ENDFOR
		cConcep := DES->cConcepDes
		lncluir := .F.
		nRegDes := RECNO()
	    ELSE
	       cDescriTde := cSpaces('DES','cDescriDes')
		nValorTde := 0
		cConcep := '.'+SPACE(15)
		lncluir := .T.
	    ENDIF
**********FIN LECTURA DEL DESCUENTO ACTUAL

**********LECTURA DEL DESCUENTOS
	    @ nNroFil,aNroCol[4] GET cDescriTde PICT "@!S16";
		      VALID (cDescriTde) # cSpaces('DES','cDescriDes')

	    @ nNroFil,aNroCol[5] GET nValorTde  PICT "9999999.99";
		      VALID nValorTde # 0
	    READ
**********FIN LECTURA DEL DESCUENTOS

**********PREGUNTA DE DECISION
	    nNroOpc := nLeeOpcion('1<DESCUENTO> 2<RECARGO> '+;
				  '3<PAGO PARCIAL> 4<NO GRABAR>?',4,'0')
	    IF nNroOpc == 4
	       RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ANALISIS DEL TIPO DE DESCUENTO
	    DO CASE
	    CASE nNroOpc == 1
		    cTipDes := 'DESCUENTO'
		 nTipDesTde := 1

	    CASE nNroOpc == 2
		    cTipDes := 'RECARGO'
		 nTipDesTde := 2

	    CASE nNroOpc == 3
		    cTipDes := 'PAGO PARCIAL'
		 nTipDesTde := 4
	    ENDCASE
	    @ nNroFil,aNroCol[6] SAY cNombreDes(nTipDesTde)
**********FIN ANALISIS DEL TIPO DE DESCUENTO

**********LECTURA DE LOS CONCEPTOS
	    cSavPan := SAVESCREEN(0,0,24,79)

	    DO WHILE .T.
	       cTxtTem := 'ESCOJA LOS CONCEPTOS DEL '+cTipDes+':'
	       @ 21,24 SAY cTxtTem GET cConcep PICT "@!";
			    VALID lValLeeCon(nNroFil+1,02,21,25+LEN(cTxtTem),;
					     @cConcep)
	       READ
	       IF EMPTY(cConcep) .OR.;
		  !lPregunta('DESEA APLICAR LOS CONCEPTOS? Si No')
		  LOOP
	       ENDIF
	       EXIT
	    ENDDO
	    cConcep := ALLTRIM(cConcep)
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA DE LOS CONCEPTOS

**********ASIGNACION DE VALOR DE UN SOLO CONCEPTO
	    IF LEN(ALLTRIM(cConcep))/2 == 1
	       aVlrCon[1] := nValorTde
	    ELSE
	       cError('DEBE DEFINIR EL VALOR PARA '+;
		      'CADA UNO DE LOS CONCEPTOS')
	    ENDIF
**********FIN ASIGNACION DE VALOR DE UN SOLO CONCEPTO

/*
**********LECTURA DEL VALOR DE LOS CONCEPTOS
	    IF LEN(ALLTRIM(cConcep))/2 > 1
	       DO WHILE .T.

*-----------------LECTURA DE LOS CONCEPTOS
		    FOR i := 1 TO (LEN(cConcep)/2)
			cError('i:='+str(i,1))
			@ 10+i,10 GET aVlrCon[i] PICT '9999999.99';
				       VALID {|oLeeGet|Prueba1(oLeeGet)};
				       WHEN {|oLeeGet|Prueba2(oLeeGet)}
		    READ
		    ENDFOR
*-----------------FIN LECTURA DE LOS CONCEPTOS

*-----------------VALIDACION DEL TOTAL LEIDO
		    nVlrTot := 0
		    FOR i := 1 TO (LEN(cConcep)/2)
			nVlrTot += aVlrCon[i]
		    ENDFOR

		    IF nVlrTot # nValorTde
		       cError('VALOR NO COINCIDE')
		       LOOP
		    ENDIF
		    EXIT
*-----------------FIN VALIDACION DEL TOTAL LEIDO

	       ENDDO

	    ENDIF
**********FIN LECTURA DEL VALOR DE LOS CONCEPTOS
*/

**********LECTURA DE LA FECHA DEL PAGO PARCIAL
	    dFechaTde := DATE()
	    IF nTipDesTde == 4
	       cSavLin := SAVESCREEN(21,00,21,79)
	       DO WHILE .T.
		  @ 21,20 SAY 'FECHA DEL PAGO PARCIAL:' GET dFechaTde PICT '@D';
			  VALID {||HelpRead()};
			  WHEN  {||HelpRead('FECHA')}
		 READ
		 IF !EMPTY(dFechaTde)
		    EXIT
		 ENDIF
	       ENDDO
	       RESTSCREEN(21,00,21,79,cSavLin)
	    ENDIF
**********FIN LECTURA DE LA FECHA DEL PAGO PARCIAL

**********LECTURA Y VALIDACION DEL TIPO DE PAGO
	    cCodigoTfp := cSpaces('DES','cCodigoFpg')
	    IF nTipDesTde == 4

	       cCodigoTfp := DES->cCodigoFpg
	       IF CAA->lForPagCaA

		  cSavLin := SAVESCREEN(21,00,21,79)
		  @ 21,20 SAY 'INGRESE EL TIPO DE PAGO';
			  GET cCodigoTfp PICT '@!';
			  VALID lValidaFpg(10,20,@cCodigoTfp)
		  READ
		  RESTSCREEN(21,00,21,79,cSavLin)

	       ENDIF
	    ENDIF
**********FIN LECTURA Y VALIDACION DEL TIPO DE PAGO

**********LECTURA DEL NUMERO DE LA FORMA DE PAGO
	    cNroFpgTde := cSpaces('DES','cNroFpgDes')
	    IF nTipDesTde == 4
	       cNroFpgTde := DES->cNroFpgDes
	       IF lLocCodigo('cCodigoFpg','FPG',cCodigoTfp)

		  cTituloTfp := 'INGRESE EL NUMERO '+ALLTRIM(FPG->cTituloFpg)
		  IF FPG->lLeeNroFpg
		     cSavLin := SAVESCREEN(21,00,21,79)
		     @ 21,20 SAY cTituloTfp GET cNroFpgTde PICT '@!'
		     READ
		     RESTSCREEN(21,00,21,79,cSavLin)
		  ENDIF

	       ENDIF
	    ENDIF
**********FIN LECTURA DEL NUMERO DE LA FORMA DE PAGO

**********LECTURA DEL NOMBRE DEL CONCEPTO REGARGO
	    cNombreTco := cSpaces('CON','cNombreCon')
	    IF CAA->lNomConDes

	       DO CASE
	       CASE nTipDesTde == 1 // DESCUENTO

		    cNombreTco := DES->cNombreCon

		    cSavLin := SAVESCREEN(21,00,21,79)
		    @ 21,20 SAY 'CONCEPTO DEL DESCUENTO PARA EL RECIBO' GET cNombreTco PICT '@!'
		    READ
		    RESTSCREEN(21,00,21,79,cSavLin)

	       CASE nTipDesTde == 2 // RECARGO

		    cNombreTco := DES->cNombreCon

		    cSavLin := SAVESCREEN(21,00,21,79)
		    @ 21,20 SAY 'CONCEPTO DEL RECARGO PARA EL RECIBO' GET cNombreTco PICT '@!'
		    READ
		    RESTSCREEN(21,00,21,79,cSavLin)

	       OTHERWISE
	       ENDCASE

	    ENDIF
**********LECTURA DEL NOMBRE DEL CONCEPTO DESCUENTO REGARGO

**********ANALISIS PARA LA GRABACION
	    SELECT DES
	    IF lncluir
	       lGrabar := DES->(lRegLock(lShared,.T.))
	    ELSE
	       GO nRegDes
	       lGrabar := DES->(lRegLock(lShared,.F.))
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION

**********GRABACION DEL MES Y VALOR DEL DESCUENTO
	    IF lGrabar
	       REPL DES->cCodigoEst WITH cCodigoTes
	       REPL DES->nNroMesDes WITH nNroMesTde
	       REPL DES->nTipDesDes WITH nTipDesTde
	       REPL DES->cDescriDes WITH cDescriTde
	       REPL DES->nValorDes  WITH nValorTde
	       REPL DES->dFechaDes  WITH dFechaTde
	       REPL DES->cCodigoFpg WITH cCodigoTfp
	       REPL DES->cNroFpgDes WITH cNroFpgTde
	       REPL DES->cConcepDes WITH cConcep
	       REPL DES->cNombreCon WITH cNombreTco
	       FOR i := 1 TO (LEN(cConcep)/2)
		   REPL &('DES->nVlrCo'+STR(i,1)+'Des');
		   WITH aVlrCon[i]
	       ENDFOR

	       REPL DES->cNomUsrDes WITH cNomUsr
	       REPL DES->dFecUsrDes WITH DATE()
	       REPL DES->cHorUsrDes WITH TIME()
	       DES->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL DESCUENTO')
	    ENDIF
	    IF lShared
	       DES->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL MES Y VALOR DEL DESCUENTO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DESCUENTOS'+;
				   ' O RECARGOS PARA EL MES ESCOGIDO',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 SET COLOR TO
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO I
		 @ nNroFil,aNroCol[4] SAY cDescriTde PICT '@S16'
		 @ nNroFil,aNroCol[5] SAY nValorTde  PICT '9999999.99'
		 @ nNroFil,aNroCol[6] SAY cNombreDes(nTipDesTde)
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       DES->(DBCLEARINDEX())                // Cierra los indixes
       SETCURSOR(0)                         // Activaci¢n del cursor
       RETURN NIL
*>>>>GRABACION DE LOS DESCUENTOS

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE OTROS PARA EL ARCHIVO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2003 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   SEP 26/2003 VIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrDes(aParam1,aParam2,aParam3,;
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
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<IMPRESION DE DESCUENTOS/RECARGOS>')
       AADD(aMenus,'2<DESCUENTOS/RECARGOS POR CONCEPTOS>')
       AADD(aMenus,'3<ABONOS OTROS MESES               >')
       AADD(aMenus,'4<VALIDAR ABONOS                   >')

       AADD(aAyuda,'Permite Imprimir la Relaci¢n de Abonos,Descuentos y Recargos')
       AADD(aAyuda,'Permite Imprimir la Relaci¢n de Abonos,Descuentos y Recargos por Conceptos')
       AADD(aAyuda,'Permite Imprimir la Relaci¢n de Abonos Otros Meses')
       AADD(aAyuda,'Permite validar los abonos contra el extracto')

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
	    OtrDes011(aParam1,aParam2,aParam3,;
		      oBrowse)
	   *Impresi¢n Abonos,Descuentos y recargos

       CASE nNroOpc == 2

	    OtrDes012(aParam1,aParam2,aParam3,;
		      oBrowse)
	   *Descripminaci¢n por Conceptos

       CASE nNroOpc == 3
	    OtrDes013(aParam1,aParam2,aParam3,;
		      oBrowse)
	   *Abonos Otros Meses

       CASE nNroOpc == 4
	    OtrDes014(aParam1,aParam2,aParam3,;
		      oBrowse)
	   *Validar abonos

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: DESCUENTOS RECARGOS POR INTERVALO DE FECHAS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 03/2006 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ABR 03/2006 LUN

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite imprimir los abonos descuentos y recargos por intervalo de
   fechas.

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrDes011(aParam1,aParam2,aParam3,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables Generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀVariables Gestion Documental

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
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registro Xml
     *ÀVariables de informe

       LOCAL nOpcion := 0                   // Opci¢n de selecci¢n
       LOCAL lValida := .F.                 // Validar Descuentos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL nVlrAbo := 0                   // Valor Abonos
       LOCAL nVlrPag := 0                   // Valor Pagos Parciales
       LOCAL nVlrDes := 0                   // Valor Descuentos
       LOCAL nVlrRec := 0                   // Valor Recargos
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL nTotPag := 0                   // Total Pagos Parciales
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotRec := 0                   // Total Recargos
       LOCAL cVlrAbo := ''                  // Valor del Abono

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nNroMesTde := 0                // Mes del descuento
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables temporales de campo
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

*>>>>CAPTURA DEL MES
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroMesTde := nMesAno(09,09,'Mes de los Descuentos',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CAPTURA DEL MES

*>>>>LECTURA DEL TIPO DE INFORME
       nOpcion := nLeeOpcion('1<SIN FECHA> 2<FECHA DE CORTE> '+;
			     '3<INTERVALO DE FECHAS> 4<ABANDONAR>?',4,'0')

       IF nOpcion == 4
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE INFORME

*>>>>LECTURA DE LAS FECHAS DEL INFORME
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')

       SET CURSOR ON
       cSavPan := SAVESCREEN(0,0,24,79)

       DO CASE
       CASE nOpcion == 2

************LECTURA DE LA FECHA DE CORTE
	      nNroFil := nMarco(10,'FECHA DE CORTE:',14,' ',NIL,20,47)

	      @ 22,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	      @ nNroFil  ,21 SAY 'FECHA DE CORTE:' GET dFecFin PICT '@D'
	      READ

	      SET CURSOR OFF
	      RESTSCREEN(0,0,24,79,cSavPan)

	      IF EMPTY(dFecFin)
		 RETURN NIL
	      ENDIF
************FIN LECTURA DE LA FECHA DE CORTE

       CASE nOpcion == 3

************LECTURA DEL INTERVALO DE FECHAS
	      nNroFil := nMarco(10,'FECHA DE CORTE:',15,' ',NIL,20,47)

	      @ 22,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	      @ nNroFil  ,21 SAY 'FECHA INICIAL :' GET dFecIni PICT '@D'
	      @ nNroFil+1,21 SAY 'FECHA FINAL   :' GET dFecFin PICT '@D'
	      READ

	      SET CURSOR OFF
	      RESTSCREEN(0,0,24,79,cSavPan)

	      IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
		 RETURN NIL
	      ENDIF
************FIN LECTURA DEL INTERVALO DE FECHAS

       ENDCASE
*>>>>FIN LECTURA DE LAS FECHAS DEL INFORME

*>>>>PREGUNTA DE DECISION
       lValida := lPregunta('DESEA VALIDAR LOS DESCUENTOS? SI NO')
*>>>>FIN PREGUNTA DE DECISION

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS
       IF nNroMesTde # 0
	  SELECT DES
	  SET FILTER TO DES->nNroMesDes == nNroMesTde
	  DES->(DBGOTOP())
	  IF DES->(EOF())
	     cError('NO HAY DESCUENTOS,RECARGOS O ABONOS PARA '+;
		    cMes(nNroMesTde))
	     SET FILTER TO
	     RETURN NIL
	  ENDIF
	  COUNT TO nTotReg FOR DES->nNroMesDes == nNroMesTde
       ELSE
	  nTotReg := DES->(RECCOUNT())
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 541
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<ACTUALIZAR><DESCUENTOS/RECARGOS>'+;
		  '<ACTIVAR INDIVIDUALES><F9>'+;
		  '<IMPRESION DE DESCUENTOS/RECARGOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')        // T¡tulo Uno
       AADD(aTitIso,'RELACION DE ABONOS, DESCUENTOS, RECARGOS') // T¡tulo Dos
       AADD(aTitIso,'')                                         // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(CAR->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'AboDesR'+STR(nOpcion,1,1)
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.T.,bInsIso,PathDoc)
          IF EMPTY(nOpcPrn)
             RETURN NIL
          ENDIF
       ENDIF
       SET DEVICE TO SCREEN
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := nTotReg+nLinTot
       DO CASE
       CASE nOpcion == 1
	    aCabPrn := {cNomEmp,cNomSis+cCodIso,;
			aTitIso[1],;
			aTitIso[2],;
			''}

       CASE nOpcion == 2
	    aCabPrn := {cNomEmp,cNomSis+cCodIso,;
			aTitIso[1],;
			aTitIso[2],;
			'A '+cFecha(dFecIni)}

       CASE nOpcion == 3
	    aCabPrn := {cNomEmp,cNomSis+cCodIso,;
			aTitIso[1],;
			aTitIso[2],;
			'DE '+cFecha(dFecIni)+' A '+cFecha(dFecFin)}
       ENDCASE

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,08,12,12,12,12,12,40}
       aTitPrn := {'CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
		   'MES ','FECHA','VLR ABONOS','PAGO PARCIAL',;
		   'DESCUENTOS','RECARGOS',;
		   'DESCRIPCION '}
       aCamXml := aTitPrn
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
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
       SET DEVICE TO SCREEN
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'IMPRIMIENDO')

       SELECT DES
       DES->(DBGOTOP())
       DO WHILE .NOT. DES->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('REGISTROS: '+DES->(STR(RECNO(),5))+'/'+;
				       DES->(STR(RECCOUNT(),5)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( DES->(RECNO()) / DES->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		cNalias := ''
	     cNombreTes := ' ALUMNO NO EXISTE'+SPACE(50)
	     IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias)
		cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				    &cNAlias->cNombreEst
	     ENDIF
	     cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

***********ANALISIS DE LA FECHA DE PAGO
	     lFechOk := .T.
	     IF nOpcion # 1
		IF DES->dFechaDes < dFecIni .OR.;
		   DES->dFechaDes > dFecFin
		   lFechOk := .F.
		ENDIF
	     ENDIF
***********FIN ANALISIS DE LA FECHA DE PAGO

***********ACUMULACION DEL TIPO DE DESCUENTO
	     nVlrDes := 0
	     nVlrRec := 0
	     nVlrAbo := 0
	     nVlrPag := 0
	     cVlrAbo := ''
	     IF lFechOk
		DO CASE
		CASE DES->nTipDesDes == 1  // Descuento
		     nVlrDes := DES->nValorDes
		     nTotDes += nVlrDes

		CASE DES->nTipDesDes == 2  // Recargo
		     nVlrRec := DES->nValorDes
		     nTotRec += nVlrRec

		CASE DES->nTipDesDes == 3  .AND. !DES->lDesEfeDes // Abono
		     nVlrAbo := DES->nValorDes
		     nTotAbo += nVlrAbo
		     cVlrAbo := TRANS(nVlrAbo,'@Z ####,###,###')

		CASE DES->nTipDesDes == 3 .AND. DES->lDesEfeDes // Abono Descuento
		     nVlrDes := DES->nValorDes
		     nTotDes += nVlrDes
		     cVlrAbo := 'ABONO'

		CASE DES->nTipDesDes == 4  // Pago Parcial
		     nVlrPag := DES->nValorDes
		     nTotPag += nVlrPag
		ENDCASE
	     ENDIF
***********FIN ACUMULACION DEL TIPO DE DESCUENTO

***********VALIDACION DE ABONO
	     IF lValida
		cTxtTem := ''
		IF DES->nTipDesDes == 3 .AND. !EMPTY(cNalias)
		   FilePag := cPatSis+'\PAGOS\PA'+;
			      &cNalias->cCodigoGru+cAnoSis+ExtFile
		   lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		   IF lLocCodPag(DES->cCodigoEst,DES->nMesModDes,.F.)
		      IF PAG->cEstadoPag == 'P' .OR.;
			 PAG->cEstadoPag == 'A'
			 cTxtTem := '* '
		      ENDIF
		   ENDIF
		   CloseDbf('PAG',FilePag,nModCry)
		ENDIF
		SELECT DES
	     ENDIF
***********FIN VALIDACION DE ABONO

***********VALIDACION DEL DESCUENTO,RECARGO,PAGO PARCIAL
	     IF lValida

		cTxtTem := ''
		IF DES->nTipDesDes # 3 .AND. !EMPTY(cNalias)

		   FilePag := cPatSis+'\PAGOS\PA'+;
			      &cNalias->cCodigoGru+cAnoSis+ExtFile

		   lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		   IF lLocCodPag(DES->cCodigoEst,nNroMesTde,.F.)

		      IF PAG->cEstadoPag == 'P' .OR.;
			 PAG->cEstadoPag == 'A'

			 DO CASE
			 CASE PAG->nVlrDesPag == DES->nValorDes
			 CASE PAG->nPagParPag == DES->nValorDes
			 CASE PAG->nVlrRecPag == DES->nValorDes
			 OTHERWISE
			      cTxtTem := 'ERROR '
			 ENDCASE

		      ENDIF
		   ENDIF
		   CloseDbf('PAG',FilePag,nModCry)
		ENDIF
		SELECT DES
	     ENDIF
***********FIN VALIDACION DEL DESCUENTO,RECARGO,PAGO PARCIAL

**********IMPRESION DEL REGISTRO
	    IF lFechOk
	       aRegPrn := {}
	       AADD(aRegPrn,DES->cCodigoEst)
	       AADD(aRegPrn,IF(EMPTY(cNalias),'',&cNalias->cCodigoGru))
	       AADD(aRegPrn,cNombreTes)

	       AADD(aRegPrn,cMes(DES->nNroMesDes,3)+;
			    IF(DES->nTipDesDes==3,'-'+;
			       cMes(DES->nMesModDes,3),''))

	       AADD(aRegPrn,cFecha(DES->dFechaDes))

	       AADD(aRegPrn,cVlrAbo)
	       AADD(aRegPrn,TRANS(nVlrPag,'@Z ####,###,###'))
	       AADD(aRegPrn,TRANS(nVlrDes,'@Z ####,###,###'))
	       AADD(aRegPrn,TRANS(nVlrRec,'@Z ####,###,###'))
	       AADD(aRegPrn,cTxtTem+DES->cDescriDes)

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       AADD(aRegPrn,'') // Campo Url
	       AADD(aRegXml,aRegPrn)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT DES
	    DES->(DBSKIP())
	    IF DES->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       SET DEVICE TO PRINT
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])
       @ PROW()  ,nColTxt(aNroCol,09) SAY REPL('-',aNroCol[09])

       AADD(aRegXml,{'','',REPL('*',42),REPL('*',12),REPL('*',12),;
		     REPL('=',aNroCol[06]),;
		     REPL('=',aNroCol[07]),;
		     REPL('=',aNroCol[08]),;
		     REPL('=',aNroCol[09]),REPL('*',20),''})

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotAbo,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotPag,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotDes,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,09) SAY TRANS(nTotRec,"$###,###,###")

       AADD(aRegXml,{'TOTALES ...','','','','',;
		     TRANS(nTotAbo,"$###,###,###"),;
		     TRANS(nTotPag,"$###,###,###"),;
		     TRANS(nTotDes,"$###,###,###"),;
		     TRANS(nTotRec,"$###,###,###"),''})
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn,nHanXml)

       SET DEVICE TO SCREEN
       SET FILTER TO
*>>>>FIN IMPRESION DERECHOS

*>>>>GENERACION DEL ARCHIVO XML DEL REPORTE
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{ACTUALIZAR}{DESCUENTOS/RECARGOS}'+;
			    '{ACTIVAR INDIVIDUALES}{F9}'+;
			    '{IMPRIMIR DESCUENTOS/RECARGOS}')
      *Nombre del Sistema

       AADD(aCabXml,'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt)
      *Titulo No. 1

       AADD(aCabXml,'RELACION DE ABONOS, DESCUENTOS, RECARGOS')
      *Titulo No. 2

       AADD(aCabXml,'')
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       FileXml(PathW01+'\'+'FACT'+cMes(nNroMesTde,3)+'\'+;
	       'DES'+cMes(nNroMesTde,3)+cAnoSis+'.XML',;
	       aRegXml,aCamXml,aCabXml)
     *ÀCreaci¢n del Archivo

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN GENERACION DEL ARCHIVO XML DEL REPORTE

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrDes012(aParam1,aParam2,aParam3,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL cVlrAbo := ''                  // Valor del Abono

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lValida := .F.                 // Validar Descuentos

       LOCAL       i := 0                   // Contador
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL nAboDes := 0                   // Total Abonos Descuentos
       LOCAL nTotPag := 0                   // Total Pagos Parciales
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotRec := 0                   // Total Recargos

       LOCAL aVlrCon := {}                  // Descriminaci¢n por Conceptos
       LOCAL aTotAbo := {}                  // Descriminacion de Abonos
       LOCAL aAboDes := {}                  // Descriminaci¢n de Abonos Desucuentos
       LOCAL aTotPag := {}                  // Descriminaci¢n de Pagos Parciales
       LOCAL aTotDes := {}                  // Descriminaci¢n de Descuentos
       LOCAL aTotRec := {}                  // Descriminaci¢n de Recargos
       LOCAL nRegDes := 0                   // Registro del Descuento

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual
       LOCAL GetList := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL nNroMesTde := 0                // Mes del descuento
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables temporales de campo
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

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroMesTde := nMesAno(09,09,'Mes de los Descuentos',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')
       lPrnFec := CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA

       IF lPrnFec
	  IF lPregunta('DESEA EL INFORME POR INTERVALO DE FECHAS? No Si')

	     SET CURSOR ON
	     cSavPan := SAVESCREEN(0,0,24,79)
	     nNroFil := nMarco(10,'FECHA DE CORTE:',15,' ',NIL,20,47)

	     @ 22,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	     @ nNroFil  ,21 SAY 'FECHA INICIAL :' GET dFecIni PICT '@D'
	     @ nNroFil+1,21 SAY 'FECHA FINAL   :' GET dFecFin PICT '@D'
	     READ

	     SET CURSOR OFF
	     RESTSCREEN(0,0,24,79,cSavPan)

	     IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
		RETURN NIL
	     ENDIF

	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecIni) .AND. EMPTY(dFecFin)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>PREGUNTA DE DECISION
       lValida := lPregunta('DESEA VALIDAR LOS DESCUENTOS? No SI')
*>>>>FIN PREGUNTA DE DECISION

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS
       IF nNroMesTde # 0
	  COUNT TO nTotReg FOR DES->nNroMesDes == nNroMesTde
       ELSE
	  nTotReg := DES->(RECCOUNT())
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := nTotReg+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'RELACION DE ABONOS, DESCUENTOS, RECARGOS',;
		   'MES DE '+cMes(nNroMesTde,3)+' '+;
		   IF(lPrnFec,' DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin),''),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,08,12,40,12,12,16,12}
       aTitulo := {'CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
		   'MES ','FECHA','DESCRIPCION','TIPO','TOTAL','CONCEPTO',;
		   'VALOR'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
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
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO LOS DESCUENTOS '+;
		    IF(nNroMesTde == 0,'','DE '+cMes(nNroMesTde)))
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'AboDesCo'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       CreaFrmPrn(lShared,'printer\descuent.dbf',aNroCol,nOpcPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT DES
       GO TOP

       DO WHILE .NOT. DES->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('CODIGO:'+DES->cCodigoEst+' '+;
			 'REGISTROS: '+DES->(STR(RECNO(),5))+'/'+;
				       DES->(STR(RECCOUNT(),5)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		cNalias := ''
	     cNombreTes := ' ALUMNO NO EXISTE'+SPACE(50)
	     IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias)
		cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				    &cNAlias->cNombreEst
	     ENDIF
	     cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DE DECISION
	    IF nNroMesTde # 0 .OR. EMPTY(cNalias)
	       SELECT DES
	       IF DES->nNroMesDes # nNroMesTde .OR. EMPTY(cNalias)

		  nAvance := INT(( DES->(RECNO()) / DES->(RECCOUNT()) )*100)
		  IF STR(nAvance,3) $ '25 50 75100'
		     Termometro(nAvance)
		  ENDIF

		  SELECT DES
		  DES->(DBSKIP())
		  LOOP

	       ENDIF
	    ENDIF
**********FIN ANALISIS DE DECISION

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 CloseDbf('CLI',FileCli,nModCry)
		 CloseDbf('PAG',FilePag,nModCry)

	    CASE PAG->(RECCOUNT()) == 0
		 CloseDbf('CLI',FileCli,nModCry)
		 CloseDbf('PAG',FilePag,nModCry)
	    ENDCASE
	    lLocCodPag(DES->cCodigoEst,DES->nNroMesDes,.F.)
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********ANALISIS DE LA FECHA DE PAGO
	     lFechOk := .T.
	     IF lPrnFec
		IF (DES->dFechaDes < dFecIni  .OR.;
		    DES->dFechaDes > dFecFin) .AND.;
		   (DES->nTipDesDes == 3 .OR. DES->nTipDesDes == 4)
		    lFechOk := .F.
		ENDIF
	     ENDIF
***********FIN ANALISIS DE LA FECHA DE PAGO

***********ACUMULACION DEL TIPO DE DESCUENTO
	     lHayErr := .F.
	     aVlrCon := {}
	     IF lFechOk
		DO CASE
		CASE DES->nTipDesDes == 1  // Descuento
		     nTotDes += DES->nValorDes
		     VlrConDes(DES->nValorDes,aVlrCon)
		     SumArrCon(aTotDes,aVlrCon)

		CASE DES->nTipDesDes == 2  // Recargo
		     nTotRec += DES->nValorDes
		     VlrConDes(DES->nValorDes,aVlrCon)
		     SumArrCon(aTotRec,aVlrCon)

		CASE DES->nTipDesDes == 3  .AND. !DES->lDesEfeDes // Abono

		     nTotAbo += DES->nValorDes

		     nRegDes := DES->(RECNO())
		     DES->(DBSETINDEX(cPatSis+'\'+fNtxDes))
		     DES->(DBGOTO(nRegDes))

		     lHayErr := !lVlrConAbo(aVlrCon)

		     DES->(DBCLEARINDEX())
		     DES->(DBGOTO(nRegDes))
		     IF !lHayErr
			SumArrCon(aTotAbo,aVlrCon)
		     ENDIF

		CASE DES->nTipDesDes == 3 .AND. DES->lDesEfeDes // Abono Descuento

		     nAboDes += DES->nValorDes
		     nRegDes := DES->(RECNO())

		     DES->(DBSETINDEX(cPatSis+'\'+fNtxDes))
		     DES->(DBGOTO(nRegDes))
		     lHayErr := !lVlrConAbo(aVlrCon)
		     DES->(DBCLEARINDEX())

		     DES->(DBGOTO(nRegDes))
		     IF !lHayErr
			SumArrCon(aAboDes,aVlrCon)
		     ENDIF

		CASE DES->nTipDesDes == 4  // Pago Parcial
		     nTotPag += DES->nValorDesf
		     VlrConDes(DES->nValorDes,aVlrCon)
		     SumArrCon(aTotPag,aVlrCon)
		ENDCASE
	     ENDIF
***********FIN ACUMULACION DEL TIPO DE DESCUENTO

***********VALIDACION DE ABONO
	     IF lValida
		cTxtTem := ''
		IF DES->nTipDesDes == 3 .AND. !EMPTY(cNalias)

		   IF lLocCodPag(DES->cCodigoEst,DES->nMesModDes,.F.)
		      IF PAG->cEstadoPag == 'P' .OR.;
			 PAG->cEstadoPag == 'A'
			 cTxtTem := '* '
		      ENDIF
		   ENDIF

		ENDIF
		SELECT DES
	     ENDIF
***********FIN VALIDACION DE ABONO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF lFechOk

*--------------IMPRESION DE LA NOVEDAD
		 aTitulo := {}
		 AADD(aTitulo,DES->cCodigoEst)
		 AADD(aTitulo,IF(EMPTY(cNalias),'',&cNalias->cCodigoGru))
		 AADD(aTitulo,cNombreTes)
		 AADD(aTitulo,cMes(DES->nNroMesDes,3)+;
			      IF(DES->nTipDesDes==3,'-'+;
				 cMes(DES->nMesModDes,3),''))
		 AADD(aTitulo,cFecha(DES->dFechaDes))
		 AADD(aTitulo,cTxtTem+DES->cDescriDes)
		 AADD(aTitulo,cTipDes())
		 AADD(aTitulo,TRANS(DES->nValorDes,'@Z ####,###,###'))

		 IF LEN(aVlrCon) >= 1
		    AADD(aTitulo,aVlrCon[1,2])
		    AADD(aTitulo,TRANS(aVlrCon[1,3],'@Z ####,###,###'))
		 ELSE
		    IF EMPTY(aVlrCon)
		       AADD(aTitulo,'?')
		       AADD(aTitulo,'?')
		    ELSE
		       AADD(aTitulo,'error')
		       AADD(aTitulo,'error')
		    ENDIF
		 ENDIF
	       *ÀImpresi¢n del Primer Concepto

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 IF lHayErr
		    cTxtPrn += '?revisar'
		 ELSE
		    cTxtPrn += IF(DES->nValorDes # nSuma(aVlrCon,3),'?REVISAR','')
		 ENDIF
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
		 GraFrmPrn(lShared,aTitulo,nOpcPrn)
*--------------FIN IMPRESION DE LA NOVEDAD

*--------------IMPRESION DE LOS RESTANTES CONCEPTOS DESCRIMINADOS
		 IF LEN(aVlrCon) > 1
		    FOR i := 2 TO LEN(aVlrCon)
			aTitulo := {'','','','','','','','',;
				    aVlrCon[i,2],;
				    TRANS(aVlrCon[i,3],'@Z ####,###,###')}

			cTxtPrn := cRegPrint(aTitulo,aNroCol)
			lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
			GraFrmPrn(lShared,aTitulo,nOpcPrn)
		    ENDFOR
		 ENDIF
*--------------FIN IMPRESION DE LOS RESTANTES CONCEPTOS DESCRIMINADOS

	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( DES->(RECNO()) / DES->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	    ENDIF

	    SELECT DES
	    DES->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       SET DEVICE TO PRINT
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION ENCABEZADO DEL RESUMEN
       aNroCol := {18,12,16,12}
       aTitulo := {'RESUMEN','TOTAL ','CONCEPTO','TOTAL'}
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION ENCABEZADO DEL RESUMEN

*>>>>TOTAL DE ABONOS
       aTitulo := {}
       IF nTotAbo # 0

	  AADD(aTitulo,'ABONOS')
	  AADD(aTitulo,TRANS(nTotAbo,"$###,###,###"))

	  IF LEN(aTotAbo) >= 1
	     AADD(aTitulo,aTotAbo[1,2])
	     AADD(aTitulo,TRANS(aTotAbo[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotAbo)
		AADD(aTitulo,'?')
		AADD(aTitulo,'?')
	     ELSE
		AADD(aTitulo,'error')
		AADD(aTitulo,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		     IF(nTotAbo # nSuma(aTotAbo,3),'?REVISAR','')
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotAbo) > 1
	     FOR i := 2 TO LEN(aTotAbo)
		 aTitulo := {'','',;
			     aTotAbo[i,2],;
			     TRANS(aTotAbo[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL DE ABONOS

*>>>>TOTAL PAGO PARCIAL
       aTitulo := {}
       IF nTotPag # 0

	  AADD(aTitulo,'PAGO PARCIAL')
	  AADD(aTitulo,TRANS(nTotPag,"$###,###,###"))

	  IF LEN(aTotPag) >= 1
	     AADD(aTitulo,aTotPag[1,2])
	     AADD(aTitulo,TRANS(aTotPag[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotPag)
		AADD(aTitulo,'?')
		AADD(aTitulo,'?')
	     ELSE
		AADD(aTitulo,'error')
		AADD(aTitulo,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		     IF(nTotPag # nSuma(aTotPag,3),'?REVISAR','')
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotPag) > 1
	     FOR i := 2 TO LEN(aTotPag)
		 aTitulo := {'','',;
			     aTotPag[i,2],;
			     TRANS(aTotPag[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL PAGO PARCIAL

*>>>>TOTAL DE ABONOS DESCUENTOS
       aTitulo := {}
       IF nAboDes # 0
	  AADD(aTitulo,'ABONOS DESCUENTOS')
	  AADD(aTitulo,TRANS(nAboDes,"$###,###,###"))

	  IF LEN(aAboDes) >= 1
	     AADD(aTitulo,aAboDes[1,2])
	     AADD(aTitulo,TRANS(aAboDes[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aAboDes)
		AADD(aTitulo,'?')
		AADD(aTitulo,'?')
	     ELSE
		AADD(aTitulo,'error')
		AADD(aTitulo,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		     IF(nAboDes # nSuma(aAboDes,3),'?REVISAR','')
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aAboDes) > 1
	     FOR i := 2 TO LEN(aAboDes)
		 aTitulo := {'','',;
			     aAboDes[i,2],;
			     TRANS(aAboDes[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL DE ABONOS DESCUENTOS

*>>>>TOTAL DESCUENTOS
       aTitulo := {}
       IF nTotDes # 0
	  AADD(aTitulo,'DESCUENTOS')
	  AADD(aTitulo,TRANS(nTotDes,"$###,###,###"))

	  IF LEN(aTotDes) >= 1
	     AADD(aTitulo,aTotDes[1,2])
	     AADD(aTitulo,TRANS(aTotDes[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotDes)
		AADD(aTitulo,'?')
		AADD(aTitulo,'?')
	     ELSE
		AADD(aTitulo,'error')
		AADD(aTitulo,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		     IF(nTotDes # nSuma(aTotDes,3),'?REVISAR','')
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotDes) > 1
	     FOR i := 2 TO LEN(aTotDes)
		 aTitulo := {'','',;
			     aTotDes[i,2],;
			     TRANS(aTotDes[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL DESCUENTOS

*>>>>TOTAL RECARGOS
       aTitulo := {}
       IF nTotRec # 0

	  AADD(aTitulo,'RECARGOS')
	  AADD(aTitulo,TRANS(nTotRec,"$###,###,###"))

	  IF LEN(aTotRec) >= 1
	     AADD(aTitulo,aTotRec[1,2])
	     AADD(aTitulo,TRANS(aTotRec[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotRec)
		AADD(aTitulo,'?')
		AADD(aTitulo,'?')
	     ELSE
		AADD(aTitulo,'error')
		AADD(aTitulo,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		     IF(nTotRec # nSuma(aTotRec,3),'?REVISAR','')

	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotRec) > 1
	     FOR i := 2 TO LEN(aTotRec)
		 aTitulo := {'','',;
			     aTotRec[i,2],;
			     TRANS(aTotRec[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN IMPRESION DE RESUMENES

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
* TITULO..: IMPRESION ABONOS OTROS MESES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 06/2003 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   FEB 06/2003 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite imprimir los obonos otros meses para un mes especifico.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrDes013(aParam1,aParam2,aParam3,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL cVlrAbo := ''                  // Valor del Abono

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lValida := .F.                 // Validar Descuentos

       LOCAL nVlrAbo := 0                   // Valor Abonos
       LOCAL nVlrMod := 0                   // Valor Pagos Parciales
       LOCAL nVlrRec := 0                   // Valor Recargos
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL nTotMod := 0                   // Total Pagos Parciales
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotRec := 0                   // Total Recargos
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual
       LOCAL GetList := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL nNroMesTde := 0                // Mes del descuento
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables temporales de campo
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

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroMesTde := nMesAno(09,09,'Mes de los Descuentos',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(nNroMesTde)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecPrn := CTOD('00/00/00')
       lPrnFec := CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA

       IF lPrnFec
	  IF lPregunta('DESEA EL INFORME POR FECHA DE CORTE? No Si')

	     SET CURSOR ON
	     cSavPan := SAVESCREEN(0,0,24,79)
	     nNroFil := nMarco(10,'FECHA DE CORTE:',14,' ',NIL,20,47)

	     @ 22,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	     @ nNroFil  ,21 SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
	     READ

	     SET CURSOR OFF
	     RESTSCREEN(0,0,24,79,cSavPan)

	     IF EMPTY(dFecPrn)
		RETURN NIL
	     ENDIF

	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecPrn)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>PREGUNTA DE DECISION
       lValida := lPregunta('DESEA VALIDAR LOS DESCUENTOS? No SI')
*>>>>FIN PREGUNTA DE DECISION

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS
       IF nNroMesTde # 0
	  SELECT DES
	  SET FILTER TO DES->nMesModDes == nNroMesTde .AND.;
			DES->nTipDesDes == 3
	  GO TOP
	  IF EOF()
	     cError('NO HAY DESCUENTOS,RECARGOS O ABONOS PARA '+;
		    cMes(nNroMesTde))
	     SET FILTER TO
	     RETURN NIL
	  ENDIF
	  COUNT TO nTotReg FOR DES->nNroMesDes == nNroMesTde
       ELSE
	  nTotReg := DES->(RECCOUNT())
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := nTotReg+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'RELACION DE ABONOS OTROS MESES DE '+cMes(nNroMesTde),;
		   IF(lPrnFec,'A '+cFecha(dFecPrn),''),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,08,12,12,08,12,10,12}
       aTitulo := {'CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
		   'MES ','FECHA','VLR ABONOS','MES MOD',;
		   'VLR MODI','TIPO','DIF ABO EXT'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
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
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO LOS DESCUENTOS '+;
		    IF(nNroMesTde == 0,'','DE '+cMes(nNroMesTde)))
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn = 'OtAbo'+cMes(nNroMesTde,3)
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT DES
       GO TOP
       DO WHILE .NOT. EOF()

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('REGISTROS: '+DES->(STR(RECNO(),5))+'/'+;
				       DES->(STR(RECCOUNT(),5)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		cNalias := ''
	     cNombreTes := ' ALUMNO NO EXISTE'+SPACE(50)
	     IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias)
		cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				    &cNAlias->cNombreEst
	     ELSE
		SET DEVICE TO PRINT
	     ENDIF
	     cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

***********ANALISIS DE LA FECHA DE PAGO
	     lFechOk := .T.
	     IF lPrnFec
		IF DES->dFechaDes > dFecPrn .AND.;
		   (DES->nTipDesDes == 3 .OR. DES->nTipDesDes == 4)
		    lFechOk := .F.
		ENDIF
	     ENDIF
***********FIN ANALISIS DE LA FECHA DE PAGO

***********ACUMULACION DEL TIPO DE DESCUENTO
	     nVlrAbo := 0
	     nVlrMod := 0
	     cVlrAbo := ''
	     IF lFechOk
		IF DES->nTipDesDes == 3
		   nVlrAbo := DES->nValorDes
		   nTotAbo += nVlrAbo
		   nVlrMod := DES->nAboOtrDes
		   nTotMod += nVlrMod
		ENDIF

	     ENDIF
***********FIN ACUMULACION DEL TIPO DE DESCUENTO

***********VALIDACION DE ABONO
	     IF lValida
		cTxtTem := ''
		IF DES->nTipDesDes == 3 .AND. !EMPTY(cNalias)
		   FilePag := cPatSis+'\PAGOS\PA'+;
			      &cNalias->cCodigoGru+cAnoSis+ExtFile
		   lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		   IF lLocCodPag(DES->cCodigoEst,DES->nMesModDes,.F.)
		      IF PAG->cEstadoPag == 'P' .OR.;
			 PAG->cEstadoPag == 'A'
			 cTxtTem := '* '
		      ENDIF
		   ENDIF
		   CloseDbf('PAG',FilePag,nModCry)
		ENDIF
		SELECT DES
	     ENDIF
***********FIN VALIDACION DE ABONO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF lFechOk
	       aTitulo := {DES->cCodigoEst,;
			   IF(EMPTY(cNalias),'',&cNalias->cCodigoGru),;
			   cNombreTes,;
			   cMes(DES->nNroMesDes,3)+;
			   IF(DES->nTipDesDes==3,'-'+;
			      cMes(DES->nMesModDes,3),''),;
			   cFecha(DES->dFechaDes),;
			   TRANS(nVlrAbo,'@Z ####,###,###'),;
			   cMes(DES->nMesModDes,3),;
			   TRANS(nVlrMod,'@Z ####,###,###'),;
			   IF(DES->lDesEfeDes,'DESCUENTO','ABONO'),;
			   TRANS(nVlrAbo-nVlrMod,'@Z ####,###,###')}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( DES->(RECNO()) / DES->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT DES
	    DES->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotAbo,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotMod,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,10) SAY TRANS(nTotAbo-nTotMod,"$###,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

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
* TITULO..: VALIDAR ABONOS                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 30/2005 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   ABR 30/2005 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Valida los abonos contra el extracto.

3- Relaciona los abonos de acuerdo al mes.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrDes014(aParam1,aParam2,aParam3,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL cVlrAbo := ''                  // Valor del Abono

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lValida := .F.                 // Validar Descuentos

       LOCAL nVlrAbo := 0                   // Valor Abonos
       LOCAL nVlrMod := 0                   // Valor Pagos Parciales
       LOCAL nVlrRec := 0                   // Valor Recargos
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL nAboBan := 0                   // Total Abonos en Bancos
       LOCAL nTotMod := 0                   // Total Pagos Parciales
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotRec := 0                   // Total Recargos
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual
       LOCAL nMesPag := 0                   // Mes de Pago
       LOCAL cMesPag := ''                  // Mes del Pago
       LOCAL nHayExt := ''                  // Validaci¢n del Extracto
       LOCAL nVlrBan := 0                   // Valor del Banco
       LOCAL dFecBan := CTOD('00/00/00')    // Fecha del Banco
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL GetList := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL nNroMesTde := 0                // Mes del descuento
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables temporales de campo
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

*>>>>CAPTURA DEL ABONO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroMesTde := nMesAno(09,09,'Mes de los Abonos',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(nNroMesTde)
	  RETURN NIL
       ENDIF
       cNroMes := STR(nNroMesTde,2)
       lCorrecion(@cNroMes)
*>>>>FIN CAPTURA DEL MES DEL ABONO

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesPag := nMesAno(10,09,'Mes del Pago',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(nMesPag)
	  RETURN NIL
       ENDIF
       cMesPag := STR(nMesPag,2)
       lCorrecion(@cMesPag)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       nHayExt := 1
       IF !lUseDbf(.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		       BAN->cCodigoBan+cAnoUsr+cMesPag+ExtFile,'EXT',;
		       NIL,lShared,nModCry)
	  CloseDbf('EXT')
	 RETURN NIL
       ENDIF
*>>>>FIN AREAS DE TRABAJO

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS POR ABONOS
       SELECT DES
       SET FILTER TO DES->nNroMesDes == nNroMesTde    .AND.;
		     MONTH(DES->dFechaDes) == nMesPag .AND.;
		     DES->nTipDesDes == 3             .AND.;
		     !DES->lDesEfeDes
       GO TOP
       IF EOF()
	  cError('NO HAY DESCUENTOS,RECARGOS O ABONOS PARA '+;
		 cMes(nNroMesTde))
	  SET FILTER TO
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS POR ABONOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := nTotReg+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'VALIDACION DE ABONOS  MES DE '+cMes(nNroMesTde),;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO


*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,08,12,12,12,12,20}
       aTitulo := {'CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
		   'MES ','FECHA','VLR ABONOS','VLR BANCO','FECBAN',;
		   'OBSERVACION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
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
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO LOS ABONOS '+;
		    IF(nNroMesTde == 0,'','DE '+cMes(nNroMesTde)))
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE                   
	  FilePrn := 'Abo'+cMes(nNroMesTde,3)+'PA'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT DES
       GO TOP
       DO WHILE .NOT. EOF()

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('REGISTROS: '+DES->(STR(RECNO(),5))+'/'+;
				       DES->(STR(RECCOUNT(),5)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		cNalias := ''
	     cNombreTes := ' ALUMNO NO EXISTE'+SPACE(50)
	     IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias)
		cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				    &cNAlias->cNombreEst
	     ELSE
		SET DEVICE TO PRINT
	     ENDIF
	     cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

***********ACUMULACION DEL TIPO DE DESCUENTO
	     nVlrAbo := DES->nValorDes
	     nTotAbo += nVlrAbo
***********FIN ACUMULACION DEL TIPO DE DESCUENTO

***********LOCALIZACION DEL PAGO EN EL EXTRACTO
	     nVlrBan := 0
	     dFecBan := CTOD('00/00/00')

	     cCodRef := DES->cCodigoEst+'14'+cNroMes

	     IF nVlrAboExt(cCodRef,nVlrAbo,DES->dFechaDes) # 0
		nVlrBan := EXT->nValorTra
		dFecBan := EXT->dFechaTra
		nAboBan += nVlrBan
	     ENDIF
***********FIN LOCALIZACION DEL PAGO EN EL EXTRACTO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {DES->cCodigoEst,;
			IF(EMPTY(cNalias),'',&cNalias->cCodigoGru),;
			cNombreTes,;
			cMes(DES->nNroMesDes,3)+;
			IF(DES->nTipDesDes==3,'-'+;
			   cMes(DES->nMesModDes,3),''),;
			cFecha(DES->dFechaDes),;
			TRANS(nVlrAbo,'@Z ####,###,###')}

	    AADD(aTitulo,TRANS(nVlrBan,'@Z ####,###,###'))
	    AADD(aTitulo,cFecha(dFecBan))

	    DO CASE
	    CASE nVlrBan == 0
		 AADD(aTitulo,'NO EXISTE EN BANCO')

	    CASE nVlrAbo # nVlrBan
		 AADD(aTitulo,TRANS(nVlrAbo-nVlrBan,'@Z ####,###,###'))

	    CASE DES->dFechaDes # dFecBan
		 AADD(aTitulo,'FECHAS DIFERENTES')
	    OTHERWISE
		 AADD(aTitulo,'')
	    ENDCASE

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( DES->(RECNO()) / DES->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT DES
	    DES->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotAbo,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nAboBan,"$###,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

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
* TITULO..: LOCALIZAR EL ABONO DEL EXTRACTO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2013 MAR A
       Colombia, Bucaramanga        INICIO: 11:30 AM   SEP 24/2013 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Localiza el abono del Extracto

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrAboExt(cCodRef,nVlrAbo,dFecPag)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodRef                              // C¢digo de la Referencia
       nVlrAbo                              // Valor del Abono
       dFecPag                              // Fecha de Pago         */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       SELECT EXT
       SET FILTER TO EXT->nCodigoCmv == 3  .AND.;
		     SUBS(EXT->cCodRefTra,1,10) == cCodRef
       IF EXT->(EOF())
	  SET FILTER TO
	  RETURN nNroReg
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>RECORRIDO DEL ARCHIVO
       SELECT EXT
       EXT->(DBGOTOP())
       DO WHILE .NOT. EXT->(EOF())

	  IF dFecPag == EXT->dFechaTra .AND.;
	     nVlrAbo == EXT->nValorTra

	     nNroReg := EXT->(RECNO())

	     EXIT
	  ENDIF
	  EXT->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO DEL ARCHIVO

*>>>>UBICACION DEL REGISTRO
       SET FILTER TO
       IF nNroReg # 0
	  EXT->(DBGOTO(nNroReg))
       ELSE
	  EXT->(DBGOTOP())
       ENDIF
       RETURN nNroReg
*>>>>FIN UBICACION DEL REGISTRO

	  

