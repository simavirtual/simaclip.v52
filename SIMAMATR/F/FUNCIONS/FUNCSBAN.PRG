/*                       SIMA - CARTERA ACADEMICA
		BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO BANCOS

REQUERIMIENTOS:

- Compilar: clipper funcsAdm /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfBan(PathBan,FileBan,lIntUno,fNtxBan)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfBan(lShared,nModCry,PathBan,FileBan,fNtxBan,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathBan				    // Path del Archivo
       FileBan				    // Nombre del Archivo
       fNtxBan				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfBan := {{"cCodigoBan","Character",02,0},; // C¢digo del Banco
			 {"cNombreBan","Character",20,0},; // Nombre del Banco
			 {"cNomBanBan","Character",20,0},; // Nombre del Banco
			 {"cLugarBan" ,"Character",16,0},; // Lugar del Banco
			 {"cNroCtaBan","Character",20,0},; // N£mero de la Cuenta
			 {"cValCtaBan","Character",20,0},; // N£mero de la Cuenta a validar
			 {"cEanCtaBan","Character",13,0},; // C¢digo EAN-13 de la Empresa
			 {"nNroCtaBan","Numeric"  ,03,0},; // Posici¢n archivo plano N£mero de la Cuenta
			 {"nLenCtaBan","Numeric"  ,03,0},; // Posici¢n archivo plano Longitud N£mero de la Cuenta
			 {"cChrSepBan","Character",02,0},; // Caracter Seperador
			 {"nCodEstBan","Numeric"  ,03,0},; // Posici¢n archivo plano del c¢digo del Estudiante
			 {"nLenRefBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del C¢digo de la Referencia.
			 {"nCodRf2Ban","Numeric"  ,03,0},; // Posici¢n archivo plano del c¢digo del Estudiante
			 {"nPagIntBan","Numeric"  ,03,0},; // Posici¢n archivo plano del valor pagado entero
			 {"nLenIntBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la logitud del valor pagado en cifra entera
			 {"nPagDecBan","Numeric"  ,03,0},; // Posici¢n archivo plano del valor pagado en decimal
			 {"nLenDecBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud valor pagado en cifra decimal
			 {"cChrFecBan","Character",01,0},; // Caracter Seperador de fecha
			 {"nAnoPagBan","Numeric"  ,03,0},; // Posici¢n archivo plano A¤o de la fecha de Pago
			 {"nLenAnoBan","Numeric"  ,02,0},; // Posici¢n archivo plano longitud del A¤o de la fecha de Pago
			 {"nMesPagBan","Numeric"  ,03,0},; // Posici¢n archivo plano Mes de la fecha de Pago
			 {"nDiaPagBan","Numeric"  ,03,0},; // Posici¢n archivo plano D¡a de la fecha de Pago
			 {"nTipMovBan","Numeric"  ,03,0},; // Posici¢n archivo plano de tipo de Mvto Ej: NB
			 {"nLenTipBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud tipo de Mvto Ej: NB
			 {"nSigMovBan","Numeric"  ,03,0},; // Posici¢n del Archivo Plano del signo del Tipo del Movimiento. Ej: + o -
			 {"nLenSigBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del signo del Tipo del Movimiento
			 {"nLugSigBan","Numeric"  ,01,0},; // Lugar del Signo del tipo del movimiento. Ej 0=>No existe o esta integrado en el tipo de movimiento, 1=>Derecha 2=>Inzquierda
			 {"nMotivoBan","Numeric"  ,03,0},; // Posici¢n archivo plano del Motivo de la transaci¢n Ej: Davivienda 0020 Cobro Empresarial
			 {"nLenMtvBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del Motivo de la transaci¢n Ej: Davivienda 0020 Cobro Empresarial Longitud = 4
			 {"nPosOfiBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la oficina
			 {"nLenOfiBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud de la Oficina
			 {"nPosTerBan","Numeric"  ,03,0},; // Posici¢n archivo plano Terminal de la oficina
			 {"nLenTerBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud de la terminal de la oficina
			 {"nPosTalBan","Numeric"  ,03,0},; // Posici¢n archivo plano talon
			 {"nLenTalBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del talon
			 {"nPosJorBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la jornada de pago
			 {"nLenJorBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud de la jornada de pago
			 {"nPosMaiBan","Numeric"  ,03,0},; // Posici¢n archivo plano del mail del pago
			 {"nLenMaiBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del mail del pago
			 {"nPagOnlBan","Numeric"  ,02,0},; // Formato para pagos en lineas.
			 {"nDigVerBan","Numeric"  ,02,0},; //* N£mero del M‚todo de Verificaci¢n
			 {'lValExtBan','Logical'  ,01,0},; // .T. Validar el extracto.
			 {'lLeeExtBan','Logical'  ,01,0}}  // .T. Leer el extracto.

       LOCAL cPatInt := ''               // Path de la contabilidad
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfBan
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathBan) == 0
	    DBCREATE(FileBan,aDbfBan,"DBFNTX")

       CASE DIRCHANGE(PathBan) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathBan)

       CASE DIRCHANGE(PathBan) == -5
	    cError('NO TIENE DERECHOS EN: '+PathBan)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/95 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   DIC 27/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfBan(lShared,nModCry,PathBan,FileBan,fNtxBan)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathBan			      // Path del Archivo
       FileBan			      // Nombre del Archivo
       fNtxBan			      // Archivo de Indice */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathBan+'\'+FileBan,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE BANCOS")
       Termometro(100)

       CreaDbfBan(lShared,nModCry,PathBan,FileBan,fNtxBan)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 17/2000 LUN A
       Colombia, Bucaramanga        INICIO: 11:30 AM   JUL 17/2000 LUN

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

FUNCTION nActStrBan(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'BAN',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE BANCOS')
	  CloseDbf('BAN',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := BAN->(DBSTRUCT())
       CloseDbf('BAN',PathArc+'\'+cNomArc,nModCry)
       CreaDbfBan(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo BANCOS su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfBan(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE BANCOS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
				    INICIO: 03:40 PM   DIC 26/94 LUN
OBJETIVOS:

1- Permite el mantenimiento del archivo Banco

SINTAXIS:

MantenBan()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenBan(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		   cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		   cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL oBrwBan := NIL                  // Browse de Bancos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO BANCOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwBan := oDefBrwBan(lShared,nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarBan(oBrwBan)})
       BAN->(CtrlBrw(lShared,oBrwBan))
       SETKEY(K_F5,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE BANCOS         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
				    INICIO: 03:43 PM   DIC 26/94 LUN

OBJETIVOS:
1- Define el objeto Browse del archivo Empresa

SINTAXIS:

 oBrwBan := oDefBrwBan(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwBan(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwBan := NIL		    // Browse de Bancos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwBan := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwBan:ColSep    := '³'
       oBrwBan:HeadSep   := 'Ä'
       oBrwBan:Cargo     := {'<<MANTENIMIENTO DE BANCOS>>',;
			    '<ENTER>Modificar  <INS>Incluir  <F5>BUSCAR  '+;
			    '<DEL>Borrar  <ESC>Abandonar',{||IncluirBan(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT BAN
       oColumn	     := TBCOLUMNNEW('CODIGO;DEL BANCO', {||BAN->cCodigoBan})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','BAN'},{'FIELD','cCodigoBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL BANCO', {||BAN->cNombreBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cNombreBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL BANCO', {||BAN->cNomBanBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cNomBanBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('LUGAR', {||BAN->cLugarBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'}, {'FIELD','cLugarBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO;DE CUENTA', {||BAN->cNroctaBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cNroCtaBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('NRO CUENTA;A VALIDAR', {||BAN->cValCtaBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cValCtaBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS NUMERO;CUENTA', {||BAN->nNroCtaBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nNroCtaBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;CUENTA', {||BAN->nLenCtaBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenCtaBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARACTER;SEPARADOR', {||BAN->cChrSepBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cChrSepBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POSICION;REFERENCIA1', {||BAN->nCodEstBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nCodEstBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;REFERENCIA1', {||BAN->nLenRefBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenRefBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POSICION;REFERENCIA2', {||BAN->nCodRf2Ban})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nCodRf2Ban'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS PAGADO;CIFRA ENTERA', {||BAN->nPagIntBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPagIntBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;CIFRA ENTERA', {||BAN->nLenIntBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenIntBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS PAGADO;CIFRA DECIMAL', {||BAN->nPagDecBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPagDecBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;CIFRA DECIMAL', {||BAN->nLenDecBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenDecBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SEPARADOR;FECHA', {||BAN->cChrFecBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cChrFecBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS A¥O DE LA;FECHA DE PAGO', {||BAN->nAnoPagBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nAnoPagBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LEN A¥O DE LA;FECHA DE PAGO', {||BAN->nLenAnoBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenAnoBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS MES DE LA;FECHA DE PAGO', {||BAN->nMesPagBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nMesPagBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS DIA DE LA;FECHA DE PAGO', {||BAN->nDiaPagBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nDiaPagBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS TIPO;MVTO', {||BAN->nTipMovBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nTipMovBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;TIPO MVTO', {||BAN->nLenTipBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenTipBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS SIGNO;TIPO MVTO', {||BAN->nSigMovBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nSigMovBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;SIGNO TIPO MVTO', {||BAN->nLenSigBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenSigBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LUGAR;SIGNO TIPO MVTO', {||BAN->nLugSigBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLugSigBan'},;
			 {'PICTURE','9'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS MOTIVO;TRANSACION', {||BAN->nMotivoBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nMotivoBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;MOTIVO', {||BAN->nLenMtvBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenMtvBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS OFICINA;TRANSACION', {||BAN->nPosOfiBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPosOfiBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;OFICINA', {||BAN->nLenOfiBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenOfiBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS TERMINAL;TRANSACION', {||BAN->nPosTerBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPosTerBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;TERMINAL', {||BAN->nLenTerBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenTerBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS TALON;TRANSACION', {||BAN->nPosTalBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPosTalBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;TALON', {||BAN->nLenTalBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenTalBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS JORNADA;PAGO', {||BAN->nPosJorBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPosJorBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;JORNADA', {||BAN->nLenJorBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenJorBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS MAIL;PAGO', {||BAN->nPosMaiBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPosMaiBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POS ANCHO;MAIL PAGO', {||BAN->nLenMaiBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nLenMaiBan'},;
			 {'PICTURE','999'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('METODO PARA EL;DIGITO VERIFIACION', {||BAN->nDigVerBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nDigVerBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO EAN-13;ASOCIADO A LA CUENTA',;
				    {||BAN->cEanCtaBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','cEanCtaBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FORMATO PARA;PAGOS EN LINEA',;
				    {||BAN->nPagOnlBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},{'FIELD','nPagOnlBan'},;
			 {'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALIDAR EL;EXTRACTO',{||BAN->lValExtBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},;
			 {'FIELD','lValExtBan'},{'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LEER EL;EXTRACTO',{||BAN->lLeeExtBan})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},;
			 {'FIELD','lLeeExtBan'},{'PICTURE','@!'}}
       oBrwBan:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwBan
*>>>>FIN DEFINICION DEL OBJETO BROWSE


/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO DE BANCOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Incluye un registro al archivo de Bancos

SINTAXIS:

  IncluirBan()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirBan(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTba := ''               // Codigo del Banco
       LOCAL cNombreTba := ''               // Nombre del Banco
       LOCAL cLugarTba  := ''               // Lugar del Banco
       LOCAL cNroCtaTba := ''               // N£mero de la cuenta
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL BANCO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTba := cSpaces('BAN','cCodigoBan')
	       cNombreTba := cSpaces('BAN','cNombreBan')
	       cLugarTba  := cSpaces('BAN','cLugarBan')
	       cNroCtaTba := cSpaces('BAN','cNroCtaBan')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL BANCO   :';
				GET cCodigoTba PICT '99';
				VALID !lValCodBan(cCodigoTba)
	    @ nNroFil+1,nNroCol SAY 'NOMBRE DEL BANCO   :';
				GET cNombreTba PICT '@!'
	    @ nNroFil+2,nNroCol SAY 'LUGAR DEL BANCO    :';
				GET cLugarTba  PICT '@!'
	    @ nNroFil+3,nNroCol SAY 'NUMERO DE LA CUENTA:';
				GET cNroctaTba PICT '@!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF cCodigoTba # cSpaces('BAN','cCodigoBan') .AND.;
	       cNombreTba # cSpaces('BAN','cNombreBan') .AND.;
	       cNroctaTba # cSpaces('BAN','cNroCtaBan')
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
       SELECT BAN
       IF lGrabar
	  IF BAN->(lRegLock(lShared,.T.))
	     REPL BAN->cCodigoBan WITH cCodigoTba
	     REPL BAN->cNombreBan WITH cNombreTba
	     REPL BAN->cLugarBan  WITH cLugarTba
	     REPL BAN->cNroctaBan WITH cNroctaTba
	     BAN->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  BAN->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL BANCO EN EL BROWSE        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/94 LUN A
						       SEP 12/94 LUN
OBJETIVOS:

1- Localiza el c¢digo del Banco dentro del Browse de Bancos

2- Retorna NIL

SINTAXIS:

  BuscarBan(oBrwBan)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarBan(oBrwBan)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwBan                              // Browse de Bancos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegBan := 0                   // Registro del Banco
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTba := ''               // C¢digo del banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTba := cSpaces('BAN','cCodigoBan')
       TitBuscar(LEN(cCodigoTba),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTba PICT '99';
			 VALID lValBanco(ROW(),COL()-3,@cCodigoTba)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTba == cSpaces('BAN','cCodigoBan')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT BAN       
       IF lBuscar .AND. lLocCodigo('cCodigoBan','BAN',cCodigoTba)
	   nRegBan := RECNO()
	   GO TOP
	   oBrwBan:GOTOP()
	   GO nRegBan
	   oBrwBan:FORCESTABLE()
       ELSE
	  oBrwBan:GOTOP()
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

FUNCTION lValBanco(nNroFil,nNroCol,cCodBan)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodBan                              // C¢digo del Banco */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegBan := 0                   // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',cCodBan)
	  nRegBan := nSelBanco(nNroFil,nNroCol)
	  IF nRegBan == 0
	     cCodBan := cSpaces('BAN','cCodigoBan')
	  ELSE
	     GO nRegBan
	     cCodBan := BAN->cCodigoBan
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

FUNCTION nSelBanco(nNroFil,nNroCol)

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
       LOCAL nRegBan := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF BAN->(RECCOUNT()) == 0
	  cError('NO EXISTEN BANCOS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT BAN
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
       BAN->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegBan := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||BAN->cNombreBan})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nRegBan
*>>>>FIN SELECCION DEL BANCO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL BANCO                *
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

FUNCTION lValCodBan(cCodBan)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodBan                              // C¢digo del Banco */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF cCodBan # cSpaces('BAN','cCodigoBan')
	     
	  IF lLocCodigo('cCodigoBan','BAN',cCodBan)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DE LA FUNCION..: DIGITO DE CHEQUEO ALGORITMO 1                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   OCT 06/98 MAR

OBJETIVOS:

1- Implementa el algoritmo 1 seg£n Conavi

2- La longitud m xima del n£mero debe ser de 10

3- Retorna del Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe01(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aPrimos := {}                  // N£mero de Primos
       LOCAL  nTotal := 0                   // Total de la Sumatoria
       LOCAL nNroChe := 0                   // N£mero de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'ALGORITMO 1'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       IF LEN(cNumero) <= 10

	  aPrimos := {31,29,23,19,17,13,7,5,3,2}
	  cNumero := ALLTRIM(cNumero)
	  cNumero := SPACE(10-LEN(cNumero))+cNumero

	  FOR i := 1 TO LEN(cNumero)
	      nTotal += VAL(SUBS(cNumero,i,1))*aPrimos[i]
	  ENDFOR
	  nNroChe := MOD(nTotal,11)

	  DO CASE
	  CASE nNroChe == 0 .OR. nNroChe == 1
	       nNroChe := 0
	  CASE nNroChe == 10
	       nNroChe := 1
	  OTHERWISE
	       nNroChe := 11 - nNroChe
	  ENDCASE
	  nNroChe := STR(nNroChe,2,0)
       ELSE
	  nNroChe := SPACE(02)
       ENDIF
       RETURN nNroChe
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

/*************************************************************************
* TITULO DE LA FUNCION..: DIGITO DE CHEQUEO ALGORITMO 11                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   OCT 06/98 MAR

OBJETIVOS:

1- Implementa el algoritmo 11 seg£n Conavi

2- La longitud m xima del n£mero debe ser de 10

3- Retorna del Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe11(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroChe := 0                   // N£mero de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'ALGORITMO 11'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       IF LEN(cNumero) <= 10

	  DO WHILE .T.

	     nNroChe := 0
	     FOR i := 1 TO LEN(cNumero)
		 nNroChe += VAL(SUBS(cNumero,i,1))
	     ENDFOR

	     IF nNroChe >= 10
		cNumero := ALLTRIM(STR(nNroChe,nNroChe,0))
		LOOP
	     ENDIF
	     EXIT

	  ENDDO
	  nNroChe = STR(nNroChe,2,0)
       ELSE
	  nNroChe := SPACE(02)
       ENDIF
       RETURN nNroChe
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

/*************************************************************************
* TITULO DE LA FUNCION..: DIGITO DE CHEQUEO ALGORITMO 13                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   OCT 06/98 MAR

OBJETIVOS:

1- Implementa el algoritmo 13 seg£n Conavi

2- La longitud m xima del n£mero debe ser de 10

3- Retorna del Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe13(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroTem := 0                   // N£mero Temporal de Calculo
       LOCAL cNroTem := ''                  // N£mero Temporal de Calculo
       LOCAL  nTotal := 0                   // Total de la Sumatoria
       LOCAL nNroChe := 0                   // N£mero de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'ALGORITMO 13'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       IF LEN(cNumero) <= 10

	  cNumero := ALLTRIM(cNumero)
	  cNumero := SPACE(10-LEN(cNumero))+cNumero

	  FOR i := 1 TO LEN(cNumero)

	      nNroTem := VAL(SUBS(cNumero,i,1))*IF(lPar(i),2,1)

	      IF nNroTem > 9

		 cNroTem := ALLTRIM(STR(nNroTem,nNroTem,0))
		 FOR j := 1 TO LEN(cNroTem)
		     nNroTem := VAL(SUBS(cNroTem,j,1))
		     nTotal += nNroTem
		 ENDFOR

	      ELSE
		 nTotal += nNroTem
	      ENDIF
	      
	  ENDFOR
	  nNroChe := (INT(nTotal/10)*10+10)-nTotal
	  nNroChe := STR(nNroChe,2,0)
       ELSE
	  nNroChe := SPACE(02)
       ENDIF
       RETURN nNroChe
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

/*************************************************************************
* TITULO DE LA FUNCION..: RUTINA DOBLE DIGITO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 15/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   DIC 15/98 MAR

OBJETIVOS:

1- Implementa el algoritmo Doble D¡gito de Chequeo seg£n Davivienda

2- Retorna del Doble Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe02(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroTem := 0                   // N£mero Temporal de Calculo
       LOCAL cNroTem := ''                  // N£mero Temporal de Calculo
       LOCAL  nTotal := 0                   // Total de la Sumatoria
       LOCAL nNroChe := 0                   // N£mero de Chequeo
       LOCAL cNroUno := ''                  // Primer Digito de Chequeo
       LOCAL cNroDos := ''                  // Segundo Digito de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'DOBLE DIGITO DE CHEQUEO'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>INVESION DEL NUMERO
       cNumero := ALLTRIM(cNumero)
       FOR i := LEN(cNumero) TO 1 STEP -1
	   cNroTem += SUBS(cNumero,i,1)
       ENDFOR
       cNumero := cNroTem
*>>>>FIN INVESION DEL NUMERO

*>>>>CALCULO DEL PRIMER DIGITO DE CHEQUEO
       FOR i := 1 TO LEN(cNumero)

	   nNroTem := VAL(SUBS(cNumero,i,1))*IF(lPar(i),1,2)

	   IF nNroTem > 9

	      cNroTem := ALLTRIM(STR(nNroTem,nNroTem,0))
	      FOR j := 1 TO LEN(cNroTem)
		  nNroTem := VAL(SUBS(cNroTem,j,1))
		  nTotal += nNroTem
	      ENDFOR

	   ELSE
	      nTotal += nNroTem
	   ENDIF

       ENDFOR
       IF nTotal > 9
	  cNroUno := SUBS(STR(nTotal,2,0),2,1)
       ELSE
	  cNroUno := STR(nTotal,1,0)
       ENDIF
*>>>>FIN CALCULO DEL PRIMER DIGITO DE CHEQUEO

*>>>>CALCULO DEL SEGUNDO DIGITO DE CHEQUEO
       nTotal := 0
       FOR i := 1 TO LEN(cNumero)

	   nNroTem := VAL(SUBS(cNumero,i,1))*IF(lPar(i),3,1)

	   IF nNroTem > 9

	      cNroTem := ALLTRIM(STR(nNroTem,nNroTem,0))
	      FOR j := 1 TO LEN(cNroTem)
		  nNroTem := VAL(SUBS(cNroTem,j,1))
		  nTotal += nNroTem
	      ENDFOR

	   ELSE
	      nTotal += nNroTem
	   ENDIF

       ENDFOR
       IF nTotal > 9
	  cNroDos := SUBS(STR(nTotal,2,0),2,1)
       ELSE
	  cNroDos := STR(nTotal,1,0)
       ENDIF
       RETURN cNroUno+cNroDos
*>>>>FIN CALCULO DEL SEGUNDO DIGITO DE CHEQUEO

/*************************************************************************
* TITULO..: DIGITO TABLA No. 16 BANCO CAJA SOCIAL                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 15/2002 MAR A
       Bucaramanga, Colombia        INICIO: 11:30 AM   ENE 15/2002 MAR

OBJETIVOS:

1- Implementa el algoritmo No. 16 "Gas Natural" de la tabla,
   seg£n el Instructivo para la Generaci¢n de Digitos de Chequeo del
   Banco Caja Social.

2- Retorna Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe04(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroTem := 0                   // N£mero Temporal de Calculo
       LOCAL cContan := ''                  // N£mero Constante
       LOCAL  nTotal := 0                   // Total de la Sumatoria
       LOCAL nNroChe := 0                   // N£mero de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'CODIGO EN LA TABLA No. 16. BANCO SOCIAL'
       ENDIF
       cNumero := SPACE(14-LEN(ALLTRIM(cNumero)))+ALLTRIM(cNumero)
*>>>>FIN NOMBRE DEL METODO

*>>>>CALCULO DEL PRIMER DIGITO DE CHEQUEO
	     j := 1
       cContan := '23456723456723'
       FOR i := LEN(cNumero) TO 1 STEP -1

	   nNroTem := VAL(SUBS(cNumero,i,1))*VAL(SUBS(cContan,j++,1))
	   nTotal += nNroTem

       ENDFOR
       nNroChe := (INT(nTotal/10)*10)
       nNroChe := nTotal - nNroChe
       nNroChe := 10 - nNroChe
       IF nNroChe > 9
	  nNroChe := 0
       ENDIF
       nNroChe := STR(nNroChe,2,0)
       RETURN nNroChe
*>>>>FIN CALCULO DEL PRIMER DIGITO DE CHEQUEO

/*************************************************************************
* TITULO..: DIGITO DE CHEQUEO BASE 10. BANCAFE                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 11/2003 SAB A
       Bucaramanga, Colombia        INICIO: 11:30 AM   ENE 11/2003 SAB

OBJETIVOS:

1- Implementa el d¡gito de chequeo base 10 de Bancafe utilizado como
   digito de control en el c¢digo de Barras UCC-128 para recaudo Bancarios

2- Retorna Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe05(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                  // Contador
       LOCAL cFactor := ''                 // Factor de Peso
       LOCAL nNroFac := 0                  // N£mero del Factor
       LOCAL nDigito := 0                  // Digito
       LOCAL nSumTot := 0                  // Suma Total
       LOCAL nDigChe := 0                  // D¡gito de Chequeo
       LOCAL nNroTem := 0                  // N£mero Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'BASE 10. BANCAFE'
       ENDIF
       cNumero := cNroInv(cNumero)
       cFactor := '2121212121212121212121'
*>>>>FIN NOMBRE DEL METODO

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       FOR i := 1 TO LEN(cNumero)
	   nDigito := VAL(SUBS(cNumero,i,1))
	   nNroFac := VAL(SUBS(cFactor,i,1))
	   nNroTem := nDigito*nNroFac
	   nSumTot += nSumDigNro(STR(nNroTem,2))
       ENDFOR
       nDigChe := (INT(nSumTot/10)*10+10)-nSumTot
       IF nDigChe == 10
	  nDigChe := 0
       ENDIF
       RETURN STR(nDigChe,1,0)
*>>>>CALCULO DEL DIGITO DE CHEQUEO

/*************************************************************************
* TITULO..: CODIGO EN LA TABLA 04. COLMENA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2006 MAR A
       Bucaramanga, Colombia        INICIO: 04:30 AM   SEP 26/2006 MAR

OBJETIVOS:

1- Implementa el d¡gito de chequeo c¢digo en la tabla 04 se£n colmena el
   cual se utiliza para n£meros de cedulas de ciudadania y Nits de 1 a 15
   digitos.

2- Retorna Digito de Chequeo.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe06(cNumero)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL aPrimos := {}                  // N£meros primos
       LOCAL  nPrimo := 0                   // N£mero primo

       LOCAL nNroTem := 0                   // N£mero Temporal
       LOCAL nDigito := 0                   // Digito
       LOCAL nSumTot := 0                   // Suma Total
       LOCAL nDigChe := 0                   // D¡gito de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'CODIGO EN LA TABLA 04. COLMENA'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>MULTIPLICAR LOS DIGITOS POR EL NUMERO PRIMO
       aPrimos := {3,7,13,17,19,23,29,37,41,43,47,53,59,67,71}
       cNumero := ALLTRIM(cNumero)

       j := 1
       FOR i := LEN(cNumero) TO 1 STEP -1
	   nDigito := VAL(SUBS(cNumero,i,1))
	   nPrimo  := aPrimos[j++]

	   nNroTem := nDigito*nPrimo
	   nSumTot += nNroTem
       ENDFOR
*>>>>FIN MULTIPLICAR LOS DIGITOS POR EL NUMERO PRIMO

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       nDigChe := (nSumTot - INT(nSumTot/11)*11)
       IF nDigChe # 1 .AND. nDigChe # 0
	  nDigChe := 11 - nDigChe
       ENDIF
       RETURN STR(nDigChe,1,0)
*>>>>CALCULO DEL DIGITO DE CHEQUEO

/*************************************************************************
* TITULO..: INVERSION DE UN NUMERO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 11/2003 SAB A
       Bucaramanga, Colombia        INICIO: 11:30 AM   ENE 11/2003 SAB

OBJETIVOS:

1- Invierte el n£mero

2- Retorna el N£mero invertido

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNroInv(cNumero)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNumero                              // N£mero a Invertir */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNroTem := ''                  // N£mero Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INVESION DEL NUMERO
       cNumero := ALLTRIM(cNumero)
       FOR i := LEN(cNumero) TO 1 STEP -1
	   cNroTem += SUBS(cNumero,i,1)
       ENDFOR
       RETURN cNroTem
*>>>>FIN INVESION DEL NUMERO

/*************************************************************************
* TITULO..: SUMATORIA DE UN NUMERO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 11/2003 SAB A
       Bucaramanga, Colombia        INICIO: 11:35 AM   ENE 11/2003 SAB

OBJETIVOS:

1- Permite suma los digitos de un n£mero.

2- Retorna la sumatoria de los digitos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSumDigNro(cNumero)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNumero                              // N£mero a Invertir */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nTotSum := 0                   // Total Suma
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SUMATORIA DE LOS DIGITOS
       cNumero := ALLTRIM(cNumero)
       IF VAL(cNumero) > 9
	  FOR i := 1 TO LEN(cNumero)
	      nTotSum += VAL(SUBS(cNumero,i,1))
	  ENDFOR
       ELSE
	  nTotSum := VAL(cNumero)
       ENDIF
       RETURN nTotSum
*>>>>FIN SUMATORIA DE LOS DIGITOS