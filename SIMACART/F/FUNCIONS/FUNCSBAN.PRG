/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO BANCOS

REQUERIMIENTOS:

- Compilar: clipper FuncsBan /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Bancos

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

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfBan(lShared,nModCry,PathBan,FileBan,fNtxBan,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathBan				    // Path del Archivo
       FileBan				    // Nombre del Archivo
       fNtxBan				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

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
			 {"cCodFacCar","Character",02,0},; //* C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE
			 {'lValExtBan','Logical'  ,01,0},; // .T. Validar el extracto.
			 {'lLeeExtBan','Logical'  ,01,0}}  // .T. Leer el extracto.

/* nPagOnlBan: "Formato para pagos en lineas."
   01 => Asobancaria 2001
   02 => Asobancaria 2001. Place to Pay
*/

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
	    Proteger(FileBan,nModCry)

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

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathBan			      // Path del Archivo
       FileBan			      // Nombre del Archivo
       fNtxBan			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

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
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO DEL BANCO                  *
**************************************************************************

OBJETIVOS:                           FECHA DE CREACION: AGO 13/94 SAB A
							AGO 13/94 SAB
1- Debe estar en uso el archivo de Bancos

2- Verifica la existencia del c¢digo del Banco.

3- Deja el archivo en el registro del c¢digo del Banco si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodBan(cCodBan,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodBan                              // C¢digo del banco
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT BAN
       GO TOP
       LOCATE FOR BAN->cCodigoBan == cCodBan
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CODIGO DEL BANCO '+cCodBan+' NO SE ENCUENTRA')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

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

FUNCTION MantenBan(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL oBrwBan := NIL                  // Browse de Bancos
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimCar,'SCA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry)

	  cError('ABRIENDO EL ARCHIVO BANCOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwBan := oDefBrwBan(lShared,nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarBan(oBrwBan)})

       SETKEY(K_F9,{||MenuOtrBan(aParam1,aParam2,aParam3,;
				 SCA->lPrnArcCar,SCA->cOpcPrnCar,oBrwBan)})

       BAN->(CtrlBrw(lShared,oBrwBan))

       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseAll()
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

       oColumn	     := TBCOLUMNNEW('CODIGO;SERVICIO FACTURADO', {||BAN->cCodFacCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','BAN'},;
			 {'FIELD','cCodFacCar'},{'PICTURE','@!'}}
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
       IF lBuscar .AND. lLocCodBan(cCodigoTba)
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
       IF !lLocCodBan(cCodBan,.F.)
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
	  IF lLocCodBan(cCodBan,.F.)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV  3/2006 VIE A
       Colombia, Bucaramanga        INICIO:  5:17 PM   NOV  3/2006 VIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrBan(aParam1,aParam2,aParam3,;
		    lPrnArc,cOpcPrn,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
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
       aMenus := {}
       AADD(aMenus,'1<CONFIGURACION>')

       aAyuda := {}
       AADD(aAyuda,'Imprime configuracion del archivo plano')

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
	    OtrBan011(aParam1,aParam2,aParam3,;
		      lPrnArc,cOpcPrn,oBrowse)
	   *Configuraci¢n archivo plano.

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV  3/2006 VIE A
       Colombia, Bucaramanga        INICIO:  5:17 PM   NOV  3/2006 VIE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrBan011(aParam1,aParam2,aParam3,;
		   lPrnArc,cOpcPrn,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
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

       IF lPrnArc
          SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Banco'
          nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)
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
		   'CONFIGURACION ARCHIVO PLANO',;
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

       AADD(aNroCol,30)
       AADD(aTitPrn,'CAMPO')

       AADD(aNroCol,08)
       AADD(aTitPrn,'POSICION')

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

       SELECT BAN
       BAN->(DBGOTOP())
       DO WHILE .NOT. BAN->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( BAN->(RECNO()) / BAN->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    AADD(aRegPrn,'POSICION REFERENCIA1')
	    AADD(aRegPrn,STR(BAN->nCodEstBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS ANCHO REFERENCIA1')
	    AADD(aRegPrn,STR(BAN->nLenRefBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POSICION REFERENCIA2')
	    AADD(aRegPrn,STR(BAN->nCodRf2Ban,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS PAGADO CIFRA ENTERA')
	    AADD(aRegPrn,STR(BAN->nPagIntBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS ANCHO CIFRA ENTERA')
	    AADD(aRegPrn,STR(BAN->nLenIntBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS PAGADO CIFRA DECIMAL')
	    AADD(aRegPrn,STR(BAN->nPagDecBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS ANCHO CIFRA DECIMAL')
	    AADD(aRegPrn,STR(BAN->nLenDecBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS A¥O DE LA FECHA DE PAGO')
	    AADD(aRegPrn,STR(BAN->nAnoPagBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'LEN A¥O DE LA FECHA DE PAGO')
	    AADD(aRegPrn,STR(BAN->nLenAnoBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS MES DE LA FECHA DE PAGO')
	    AADD(aRegPrn,STR(BAN->nMesPagBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS DIA DE LA FECHA DE PAGO')
	    AADD(aRegPrn,STR(BAN->nDiaPagBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS TIPO MVTO')
	    AADD(aRegPrn,STR(BAN->nTipMovBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS ANCHO TIPO MVTO')
	    AADD(aRegPrn,STR(BAN->nLenTipBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS SIGNO TIPO MVTO')
	    AADD(aRegPrn,STR(BAN->nSigMovBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS ANCHO SIGNO TIPO MVTO')
	    AADD(aRegPrn,STR(BAN->nLenSigBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'LUGAR SIGNO TIPO MVTO')
	    AADD(aRegPrn,STR(BAN->nLugSigBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS MOTIVO TRANSACION')
	    AADD(aRegPrn,STR(BAN->nMotivoBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}
	    AADD(aRegPrn,'POS ANCHO MOTIVO')
	    AADD(aRegPrn,STR(BAN->nLenMtvBan,3,0))
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT BAN
	    BAN->(DBSKIP())
	    IF BAN->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

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
	  RETURN 'ALGORITMO 1. CONAVI'
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
	  nNroChe := STR(nNroChe,2)
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
	  RETURN 'DOBLE DIGITO. DAVIVIENDA'
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
* TITULO DE LA FUNCION..: MODULO 12. COLMENA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 15/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   DIC 15/98 MAR

OBJETIVOS:

1- Implementa el algoritmo M¢dulo 12 de digito de Chequeo para Colmena

2- Retorna Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe03(cNumero)

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
	  RETURN 'MODULO 12. COLMENA'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>CALCULO DEL PRIMER DIGITO DE CHEQUEO
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
       IF nNroChe == 10
	  nNroChe := 0
       ENDIF
       nNroChe := STR(nNroChe,2,0)
       RETURN nNroChe
*>>>>FIN CALCULO DEL PRIMER DIGITO DE CHEQUEO

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

/*************************************************************************
* TITULO..: ESTRUCTURA DE LA TRANSACION                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 23/2016 JUE A
       Bucaramanga, Colombia        INICIO: 02:00 PM   JUN 23/2016 JUE

OBJETIVOS:

1- Lee el registro del archivo plano de cada uno de los campos

2- Crea un vector con la estructura de cada campo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aStrTra(cRegTra)

*>>>>DESCRIPCION DE PARAMETROS
/*     cRegTra                              // Registro de la Transaci¢n */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aStrTra := {}                  // Estructura del Registro

       LOCAL       i := 0                   // Contador
       LOCAL cChrSep := ''                  // Caracter Seperador
       LOCAL cChrTra := ''                  // Caracter de la Transaci¢n
       LOCAL nNroCam := 0                   // N£mero de Campo.
       LOCAL cCampo  := ''                  // Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ESTRUCTURA SIN CARACTER SEPARADOR
       cChrSep := ALLTRIM(BAN->cChrSepBan)
       cRegTra := ALLTRIM(cRegTra)
       IF EMPTY(cChrSep)
	  aStrTra := {}
       ENDIF
*>>>>FIN ESTRUCTURA SIN CARACTER SEPARADOR

*>>>>ESTRUCTURA CON CARACTER SEPARADOR
       IF !EMPTY(cChrSep)

	  cRegTra := ALLTRIM(cRegTra)

	  nNroCam := 1
	  FOR i := 1 TO LEN(cRegTra)

	      cChrTra := SUBS(cRegTra,i,1)

	      IF cChrTra == cChrSep .OR. i == LEN(cRegTra)

		 IF i == LEN(cRegTra)
		    cCampo += cChrTra
		 ENDIF

		 AADD(aStrTra,{STR(nNroCam,4),cCampo})

		 cCampo := ''
		 nNroCam++

	      ELSE
		 cCampo += cChrTra
	      ENDIF

	  ENDFOR
       ENDIF
*>>>>FIN ESTRUCTURA CON CARACTER SEPARADOR

*>>>>CONSULTA DE LA ESTRUCTURA
/*
       FOR i := 1 TO LEN(aStrTra)
	   wait aStrTra[i][1]+':'+aStrTra[i][2]
       ENDFOR
*/
       RETURN aStrTra
*>>>>FIN CONSULTA DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: REGISTRO DE LA TRANSACION                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 23/2016 JUE A
       Bucaramanga, Colombia        INICIO: 11:00 AM   JUN 23/2016 JUE

OBJETIVOS:

1. La lectura del archivo plano de los movimientos bancarios se realiza
   a trav‚s de 2 m‚todos:

   1. Lectura de los campos de acuerdo al n£mero de la posici¢n en el
      archivo. LEN(aStrTra) == 0

   2. Lectura de los campos de forma secuencial de acuerdo un caracter
      separador. LEN(aStrTra) # 0


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aRegTra(cRegTra,aStrTra)

*>>>>DESCRIPCION DE PARAMETROS
/*     cRegTra                              // Registro de la Transaci¢n
       aStrTra                              // Estructura del Registro */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aRegTra := {}                  // Parametros Generales

       LOCAL cNroCta := ''                  // N£mero de la cuenta
       LOCAL cCodFac := ''                  // C¢digo de la factura
       LOCAL cCodRf1 := ''                  // Referencia No. 1
       LOCAL cCodRf2 := ''                  // Referencia No. 1
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL nVlrDec := 0                   // Valor Decimal
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL dFecTra := CTOD('00/00/00')    // Fecha de la Transaci¢n
       LOCAL cFecTra := ''                  // Fecha
       LOCAL cFecAno := ''                  // A¤o de la fecha
       LOCAL cFecMes := ''                  // Mes de la fecha
       LOCAL cFecDia := ''                  // D¡a de la fecha
       LOCAL aFecTra := {}                  // Fecha de la Transacci¢n
       LOCAL cCodTra := ''                  // C¢digo de la Transacci¢n
       LOCAL cSigTra := ''                  // Signo de la transaci¢n
       LOCAL cOficin := ''                  // Oficina de la Trnasacci¢n
       LOCAL cTerOfi := ''                  // Terminal de la Oficina
       LOCAL cTalon  := ''                  // Talon de la Transaci¢n
       LOCAL cJornad := ''                  // Jornada de pago
       LOCAL cMaiPag := ''                  // MAIL del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REFERENCIA1
       IF LEN(aStrTra) == 0
	  cCodFac := SPACE(02)
	  IF BAN->nCodEstBan # 0
	     cCodRf1 := SUBS(cRegTra,BAN->nCodEstBan,BAN->nLenRefBan)
	  ENDIF

	  DO CASE
	  CASE BAN->nLenRefBan == 10
	       cCodRef := cCodRf1
	       cCodFac := SPACE(02)

	  CASE BAN->nLenRefBan == 12  // C¢digo Servicio Facturado


	       cCodFac := SUBS(cCodRf1,1,2)
	       IF VAL(cCodFac) == 0
		  cCodRef := SUBS(cCodRf1,3,10)
		  cCodRef := cCodRef+cCodFac
	       ELSE
		  cCodRef := cCodRf1
		  cCodFac := SUBS(cCodRf1,11,2)
	       ENDIF

	  OTHERWISE
	       cCodRef := cCodRf1
	       cCodFac := SPACE(02)
	  ENDCASE
       ENDIF
*>>>>FIN REFERENCIA1

*>>>>REFERENCIA2
       IF LEN(aStrTra) == 0

	  IF BAN->nCodRf2Ban # 0
	     cCodRf2 := SUBS(cRegTra,BAN->nCodRf2Ban,BAN->nLenRefBan)
	  ENDIF

	  IF BAN->nCodRf2Ban # 0 .AND. VAL(cCodRf1) == 0
	     cCodRef := cCodRf2

	     DO CASE
	     CASE BAN->nLenRefBan == 10
		  cCodRef := cCodRf2

	     CASE BAN->nLenRefBan == 12  // C¢digo Servicio Facturado

		  cCodFac := SUBS(cCodRf2,1,2)
		  IF VAL(cCodFac) == 0
		     cCodRef := SUBS(cCodRf2,3,10)
		     cCodRef := cCodRef+cCodFac
		  ELSE
		     cCodRef := cCodRf2
		  ENDIF

	     OTHERWISE
		  cCodRef := cCodRf2
	     ENDCASE

	  ENDIF

       ENDIF
*>>>>FIN REFERENCIA2

*>>>>MOTIVO DE LA TRANSACCION
       IF LEN(aStrTra) == 0

	  IF BAN->nMotivoBan # 0 .AND. VAL(cCodRef) == 0

	     cCodRef := SUBS(cRegTra,BAN->nMotivoBan,BAN->nLenMtvBan)

	     IF BAN->nLenRefBan > BAN->nLenMtvBan
		cCodRef += SPACE(BAN->nLenRefBan - BAN->nLenMtvBan)
	     ENDIF

	  ENDIF

       ENDIF
*>>>>FIN MOTIVO DE LA TRANSACCION

*>>>>NUMERO DE LA CUENTA
       IF LEN(aStrTra) # 0
	  cNroCta := xPrm(aStrTra,STR(BAN->nNroCtaBan,4)) // POS NUMERO;CUENTA
       ELSE
	  cNroCta := ALLTRIM(SUBS(cRegTra,BAN->nNroCtaBan,BAN->nLenCtaBan))
       ENDIF
       AADD(aRegTra,{'cNroCta',ALLTRIM(cNroCta)})
*>>>>FIN NUMERO DE LA CUENTA



*>>>>REFERENCIA
       IF LEN(aStrTra) # 0
	  cCodRef := xPrm(aStrTra,STR(BAN->nCodEstBan,4)) // POSICION REFERENCIA1
	  AADD(aRegTra,{'cCodRef',SUBS(cCodRef,1,10)})
	  AADD(aRegTra,{'cAnoUsr',SUBS(cCodRef,11,4)})
	  AADD(aRegTra,{'cCodFac',SUBS(cCodRef,15,2)})
	  AADD(aRegTra,{'nNroRec',VAL(SUBS(cCodRef,17,8))})
       ELSE
	  AADD(aRegTra,{'cCodRef',SUBS(cCodRef,1,10)})
	  AADD(aRegTra,{'cAnoUsr',''})
	  IF LEN(ALLTRIM(cCodRef)) > 10
	     AADD(aRegTra,{'cCodFac',SUBS(cCodRef,11,12)})
	  ELSE
	     AADD(aRegTra,{'cCodFac',CAR->cCodFacCar})
	  ENDIF
	  AADD(aRegTra,{'nNroRec',0})
       ENDIF
*>>>>FIN REFERENCIA

*>>>>VALOR DE LA TRANSACCION
       IF LEN(aStrTra) # 0

	  nVlrTra := xPrm(aStrTra,STR(BAN->nPagIntBan,4)) // POS PAGADO;CIFRA ENTERA
	  AADD(aRegTra,{'nVlrTra',VAL(nVlrTra)})

       ELSE

	  nVlrDec := 0
	  IF !EMPTY(BAN->nPagDecBan)
	     nVlrDec := VAL(SUBS(cRegTra,BAN->nPagDecBan,;
					       BAN->nLenDecBan))/100
	  ENDIF

	  nVlrTra := VAL(SUBS(cRegTra,;
			      BAN->nPagIntBan,;
			      BAN->nLenIntBan))+nVlrDec

	  AADD(aRegTra,{'nVlrTra',nVlrTra})

       ENDIF
*>>>>FIN VALOR DE LA TRANSACCION

*>>>>FECHA DE LA TRANSACCION
       IF LEN(aStrTra) # 0
	  cFecTra := xPrm(aStrTra,STR(BAN->nLenAnoBan,4)) // LEN A¥O DE LA;FECHA DE PAGO

	  aFecTra := aFechaBan(cFecTra,;
			       BAN->cChrFecBan,;
			       BAN->nDiaPagBan,; // POS DIA DE LA;FECHA DE PAGO
			       BAN->nMesPagBan,; // POS MES DE LA;FECHA DE PAGO
			       BAN->nAnoPagBan)  // POS A¥O DE LA;FECHA DE PAGO

	  dFecTra  := CTOD(aFecTra[BAN->nMesPagBan]+'/'+;
			   aFecTra[BAN->nDiaPagBan]+'/'+;
			   aFecTra[BAN->nAnoPagBan])


       ELSE
	  dFecTra  := CTOD(SUBS(cRegTra,BAN->nMesPagBan,02)+'/'+;
			   SUBS(cRegTra,BAN->nDiaPagBan,02)+'/'+;
			   SUBS(cRegTra,;
				BAN->nAnoPagBan,BAN->nLenAnoBan))
       ENDIF
       AADD(aRegTra,{'dFecTra',dFecTra})
*>>>>FIN FECHA DE LA TRANSACCION

*>>>>TIPO DE MOVIMIENTO
       IF LEN(aStrTra) # 0

	  IF BAN->nTipMovBan == 0
	     cCodTra := 'PSE'
	  ELSE
	     cCodTra := 'PSE'
	  ENDIF

       ELSE
	    cCodTra := SUBS(cRegTra,BAN->nTipMovBan,BAN->nLenTipBan)
	    IF BAN->nSigMovBan # 0 .AND.;
	       BAN->nLenSigBan # 0 .AND.;
	       BAN->nLugSigBan # 0

	       cSigTra := SUBS(cRegTra,BAN->nSigMovBan,BAN->nLenSigBan)
	       IF BAN->nLugSigBan == 1
		  cCodTra := cSigTra+cCodTra
	       ELSE
		  cCodTra := cCodTra+cSigTra
	       ENDIF
	    ENDIF
       ENDIF
       AADD(aRegTra,{'cCodTra',cCodTra})
*>>>>FIN TIPO DE MOVIMIENTO

*>>>>OFICINA
       cOficin := ''
       IF LEN(aStrTra) # 0
	  cOficin := ''
       ELSE
	  IF !EMPTY(BAN->nPosOfiBan)
	     cOficin := SUBS(cRegTra,BAN->nPosOfiBan,BAN->nLenOfiBan)
	  ENDIF
       ENDIF
       AADD(aRegTra,{'cOficin',cOficin})
*>>>>FIN OFICINA

*>>>>TERMINAL
       cTerOfi := ''
       IF LEN(aStrTra) # 0
	  cTerOfi := ''
       ELSE
	 IF !EMPTY(BAN->nPosTerBan)
	    cTerOfi := SUBS(cRegTra,BAN->nPosTerBan,BAN->nLenTerBan)
	 ENDIF
       ENDIF
       AADD(aRegTra,{'cTerOfi',cTerOfi})
*>>>>FIN TERMINAL

*>>>>TALON
       cTalon  := ''
       IF LEN(aStrTra) # 0
	  cTalon  := ''
       ELSE
	 IF !EMPTY(BAN->nPosTalBan)
	    cTalon := SUBS(cRegTra,BAN->nPosTalBan,BAN->nLenTalBan)
	 ENDIF
       ENDIF
       AADD(aRegTra,{'cTalon',cTalon})
*>>>>TALON FIN

*>>>>JORNADA
       cJornad := ''
       IF LEN(aStrTra) # 0
	  cJornad := ''
       ELSE
	  IF !EMPTY(BAN->nPosJorBan)
	     cJornad := SUBS(cRegTra,BAN->nPosJorBan,BAN->nLenJorBan)
	  ENDIF
       ENDIF
       AADD(aRegTra,{'cJornad',cJornad})
*>>>>FIN JORNADA

*>>>>MAIL DEL PAGOS
       cMaiPag := ''
       IF LEN(aStrTra) # 0
	  cMaiPag := xPrm(aStrTra,STR(BAN->nPosMaiBan,4)) // POS MAIL;PAGO
       ELSE
	  IF !EMPTY(BAN->nPosMaiBan)
	     cMaiPag := SUBS(cRegTra,BAN->nPosMaiBan,BAN->nLenMaiBan)
	  ENDIF
       ENDIF
       AADD(aRegTra,{'cMaiPag',cMaiPag})
       RETURN aRegTra
*>>>>FIN MAIL DEL PAGOS

/**************************************************************************
* TITULO..: SEPARACION DE LA FECHA                                        *
***************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/2016 VIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   JUN 24/2016 VIE

OBJETIVOS:

1- Separa la fecha en a¤o,mes,dia en un vector de acuerdo a un separador

2- Retorna la fecha separada en un vector

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aFechaBan(cFecha,cChrSep,nPosDia,nPosMes,nPosAno)

*>>>>DESCRIPCION DE PARAMETROS
/*     cFecha                                    // Fecha a separar
       cChrSep				         // Separador de la fecha.
       nPosDia                                   // Posici¢n del d¡a.
       nPosMes                                   // Posici¢n del Mes.
       nPosAno                                   // Posici¢n del A¤o. */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIBLES
       LOCAL       i := 0                        // Contador
       LOCAL cChract := ''                       // Caracter leido
       LOCAL cCampo  := ''                       // Campo

       LOCAL cNroAno := SPACE(04)                // N£mero del a¤o
       LOCAL cNroMes := SPACE(02)                // N£mero del mes
       LOCAL cNroDia := SPACE(02)                // N£mero del d¡a
       LOCAL aFecha  := [3]                      // Fecha en Vector

*>>>>FIN DECLARACION DE VARIBLES

*>>>>SEPARACION DE LA FECHA SIN SEPARADOR
       IF EMPTY(ALLTRIM(cChrSep))

**********SEPARACION DEL DIA
	    DO CASE
	    CASE nPosDia == 1
		 cNroDia := SUBS(cFecha,1,2)
	    CASE nPosDia == 2
		 IF nPosAno == 1
		    cNroDia := SUBS(cFecha,5,2)
		 ELSE
		    cNroDia := SUBS(cFecha,3,2)
		 ENDIF
	    CASE nPosDia == 3
		 cNroDia := SUBS(cFecha,7,2)
	    ENDCASE
	    aFecha[nPosDia] := cNroDia
**********FIN SEPARACION DEL DIA

**********SEPARACION DEL MES
	    DO CASE
	    CASE nPosMes == 1
		 cNroMes := SUBS(cFecha,1,2)
	    CASE nPosMes == 2
		 IF nPosAno == 1
		    cNroMes := SUBS(cFecha,5,2)
		 ELSE
		    cNroMes := SUBS(cFecha,3,2)
		 ENDIF
	    CASE nPosMes == 3
		 cNroMes := SUBS(cFecha,7,2)
	    ENDCASE
	    aFecha[nPosMes] := cNroMes
**********FIN SEPARACION DEL MES

**********SEPARACION DEL A¥O
	    DO CASE
	    CASE nPosAno == 1
		 cNroAno := SUBS(cFecha,1,4)
	    CASE nPosAno == 2
		 cNroAno := SUBS(cFecha,3,4)
	    CASE nPosAno == 3
		 cNroAno := SUBS(cFecha,5,2)
	    ENDCASE
	    aFecha[nPosAno] := cNroAno
**********FIN SEPARACION DEL A¥O

       ENDIF
*>>>>FIN SEPARACION DE LA FECHA SIN SEPARADOR

*>>>>SEPARACION DE LA FECHA CON SEPARADOR
       IF !EMPTY(ALLTRIM(cChrSep))

	  aFecha := {}
	  FOR i := 1 TO LEN(cFecha)

	      cChract := SUBS(cFecha,i,1)

	      IF cChract == cChrSep .OR. i == LEN(cFecha)

		 IF i == LEN(cFecha)
		    cCampo += cChract
		 ENDIF

		 AADD(aFecha,cCampo)
		 cCampo := ''

	      ELSE
		 cCampo += cChract
	      ENDIF

	  ENDFOR

       ENDIF
       RETURN aFecha
*>>>>FIN SEPARACION DE LA FECHA SIN SEPARADOR

