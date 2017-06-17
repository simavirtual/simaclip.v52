/*                       SIMA - MATRICULA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION SIMACART

REQUERIMIENTOS:

- Compilar: clipper fSimaCar /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:15 AM   JUL 19/96 VIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCar(lShared,nModCry,PathCar,fSimCar,fNtxCar,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       fSimCar				    // Nombre del Archivo
       fNtxCar				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       AADD(aDbfStr,{'cSecretCar','Character',50,0}) // Nombre de la Secretaria Actual
       AADD(aDbfStr,{'cNitSecCar','Character',40,0}) // Documento de la Secretaria
       AADD(aDbfStr,{'cCarSecCar','Character',50,0}) // Nombre del Cargo
       AADD(aDbfStr,{'cNomSupCar','Character',50,0}) // Nombre del Supervisor del Sistema
       AADD(aDbfStr,{'cPasSupCar','Character',10,0}) // PassWord del Supervisor
       AADD(aDbfStr,{'cOpcRecCar','Character',04,0}) // Opciones de Impresi¢n para los recibos
       AADD(aDbfStr,{'cModemCar' ,'Character',20,0}) // Banco para la Gerencia Electronica
       AADD(aDbfStr,{'cEmpCobCar','Character',20,0}) // Empresa de Cobro para la Cartera
       AADD(aDbfStr,{'cCodCobCar','Character',06,0}) // C¢digo de la Empresa seg£n Empresa de Cobro
       AADD(aDbfStr,{'cPswCobCar','Character',12,0}) // Clave para Reportar
       AADD(aDbfStr,{'lNtfCobCar','Logical'  ,01,0}) // La Empresa de Cobro SI/NO envia Cartas de Notificaci¢n a los reportados
       AADD(aDbfStr,{'cTipNtfCar','Character',20,0}) // Tipo de Notificaci¢n. Ej: INSTITUCION - CORREO
       AADD(aDbfStr,{'nAutRetCar','Numeric'  ,08,0}) // Contador de Autorizaci¢n de Retiros
       AADD(aDbfStr,{'nFacMesCar','Numeric'  ,02,0}) // C¢digo para la Facturaci¢n del Mes
       AADD(aDbfStr,{'nSdoAnoCar','Numeric'  ,02,0}) // Saldo de A¤os Anteriores
       AADD(aDbfStr,{'nAnoIniCar','Numeric'  ,04,0}) // A¤o Inicial de la Cartera
       AADD(aDbfStr,{'nAnoFinCar','Numeric'  ,04,0}) // A¤o Final de la Cartera
       AADD(aDbfStr,{'nRepIniCar','Numeric'  ,04,0}) // A¤o Inicial del Reporte
       AADD(aDbfStr,{'nRepFinCar','Numeric'  ,04,0}) // A¤o Final del Reporte
       AADD(aDbfStr,{'nIniCerCar','Numeric'  ,04,0}) // A¤o Inicial habilitado para Certificados
       AADD(aDbfStr,{'nFinCerCar','Numeric'  ,04,0}) // A¤o Final habilitado para Certificados
       AADD(aDbfStr,{'nIzqTxtCar','Numeric'  ,02,0}) // Margen Inquierdo Texto para certificado
       AADD(aDbfStr,{'nIzqConCar','Numeric'  ,02,0}) // Margen Inquierdo Conceptos para certificado
       AADD(aDbfStr,{'nMarDerCar','Numeric'  ,03,0}) // Margen Derecho para certificado
       AADD(aDbfStr,{'cConPrnCar','Character',32,0}) // Conceptos a imprimir en los reportes
       AADD(aDbfStr,{'nNroCarCar','Numeric'  ,16,0}) // N£mero de Cartas
       AADD(aDbfStr,{'cColaAcCar','Character',02,0}) // Cola de Impresi¢n Activada
       AADD(aDbfStr,{'lModColCar','Logical'  ,01,0}) // .T. Modificar la Cola Activada

       AADD(aDbfStr,{'nPagOnlCar','Numeric'  ,002,0}) // Formato para pagos en lineas.
       AADD(aDbfStr,{'cCodOnlCar','Character',036,0}) // C¢digo asignado para pagos en lineas.
       AADD(aDbfStr,{'cCodSerCar','Character',036,0}) // C¢digo interno asignado por la empresa para clasificar el servicio que se recauda
       AADD(aDbfStr,{'cSerFacCar','Character',15,0})  // Servicio Facturado. Campo No.4 Registro de encabezado de lote. Formato Asobancaria 2001

       AADD(aDbfStr,{'cCodFacCar','Character',02,0})  // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE

       AADD(aDbfStr,{'lPrnArcCar','Logical'  ,001,0}) // .T. Imprimir en la impresora
       AADD(aDbfStr,{'nCodigoPrn','Numeric'  ,004,0}) // C¢digo de la Impresora
       AADD(aDbfStr,{'cOpcPrnCar','Character',004,0}) // Opciones de Impresi¢n
       AADD(aDbfStr,{'nCodigoClr','Numeric'  ,002,0}) // C¢digo del Color
       AADD(aDbfStr,{'cUsrIsoCar','Character',010,0}) // Usuario del Iso
       AADD(aDbfStr,{'nCodXslCar','Numeric'  ,002,0}) // C¢digo Xsl informes
       AADD(aDbfStr,{'cPiePagCar','Character',255,0}) // Pie de p gina informes

       AADD(aDbfStr,{'nPruebaCar','Numeric'  ,002,0}) // Habilitar pruebas
       AADD(aDbfStr,{'lValidaCar','Logical'  ,001,0}) // .T. Validar la Cartera.

       AADD(aDbfStr,{'cCola01Car','Character',20,0})
       AADD(aDbfStr,{'cCola02Car','Character',20,0})
       AADD(aDbfStr,{'cCola03Car','Character',20,0})
       AADD(aDbfStr,{'cCola04Car','Character',20,0})
       AADD(aDbfStr,{'cCola05Car','Character',20,0})
       AADD(aDbfStr,{'cCola06Car','Character',20,0})
       AADD(aDbfStr,{'cCola07Car','Character',20,0})
       AADD(aDbfStr,{'cCola08Car','Character',20,0})
       AADD(aDbfStr,{'cCola09Car','Character',20,0})
       AADD(aDbfStr,{'cCola10Car','Character',20,0})
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCar) == 0
	    DBCREATE(fSimCar,aDbfStr,"DBFNTX")
	    Proteger(fSimCar,nModCry)

       CASE DIRCHANGE(PathCar) == -3
	    WAIT 'NO EXISTE EL DIRECTORIO: '+PathCar

       CASE DIRCHANGE(PathCar) == -5
	    WAIT 'NO TIENE DERECHOS EN: '+PathCar
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCar+'\'+fSimCar,'SCA',NIL,lShared,nModCry)
	  WAIT 'ABRIENDO EL ARCHIVO DE CONFIGURACION DE CARTERA'
	  CloseDbf('SCA',PathCar+'\'+fSimCar,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF SCA->(lRegLock(lShared,.T.))
	  REPL SCA->lPrnArcCar WITH .F.
	  REPL SCA->nCodigoClr WITH 1
	  REPL SCA->cOpcRecCar WITH '2'
	  REPL SCA->nMarDerCar WITH 70
	  SCA->(DBCOMMIT())
       ELSE
	  WAIT 'NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION'
       ENDIF
       IF lShared
	  SCA->(DBUNLOCK())
       ENDIF
       CloseDbf('SCA',PathCar+'\'+fSimCar,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:28 AM   JUL 19/96 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCar(lShared,nModCry,PathCar,fSimCar,fNtxCar)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathCar			      // Path del Archivo
       fSimCar			      // Nombre del Archivo
       fNtxCar			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       WAIT "SE BORRO EL ARCHIVO "+PathCar+'\'+fSimCar

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DE LA MATRICULA")
       Termometro(100)

       CreaDbfCar(lShared,nModCry,PathCar,fSimCar,fNtxCar)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/99 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   AGO 13/99 VIE

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

FUNCTION nActStrCar(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'SCA',NIL,lShared,nModCry)
	  WAIT 'ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL'
	  CloseDbf('SCA',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := SCA->(DBSTRUCT())
       CloseDbf('SCA',PathArc+'\'+cNomArc,nModCry)
       CreaDbfCar(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  WAIT 'El Archivo CONFIG GENERAL su Estructura Esta DesActualizada.'
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
			 {||CreaDbfCar(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     WAIT 'NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO'
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:31 AM   JUL 19/96 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

MantenCar()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCar(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL oBrwCar := NIL                 // Objeto Browse
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
       IF !lUseDbf(.T.,PathSis+'\'+fSimCar,'SCA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE CARTERA')
	  CloseDbf('SCA',PathSis+'\'+fSimCar,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwCar := oDefBrwCar(lShared,cAnoUsr,nFilPal+1,00,22,79)
       SCA->(CtrlBrw(lShared,oBrwCar))
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF SCA->lPrnArcCar
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CloseDbf('SCA',PathSis+'\'+fSimCar,nModCry)
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 11:32 AM   JUL 19/96 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCar(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
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
       oBrowse:Cargo     := {'<< CONFIGURACION DEL SISTEMA DE CARTERA >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT SCA
       oColumn	     := TBCOLUMNNEW('RESPONSABLE;DE LA CARTERA', {||SCA->cSecretCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cSecretCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARGO DEL;RESPONSABLE', {||SCA->cCarSecCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCarSecCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA RESPONSABLE;DE LA CARTERA',;
				    {||SCA->cNitSecCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cNitSecCar'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARGO DE;LA SECRETARIA', {||SCA->cCarSecCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCarSecCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FORMATO PARA;PAGOS EN LINEA',{||SCA->nPagOnlCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nPagOnlCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO ASIGNADO;PAGOS EN LINEA',{||SCA->cCodOnlCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCodOnlCar'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO ASIGNADO;SERVICIO PAGOS EN LINEA',{||SCA->cCodSerCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCodSerCar'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('CODIGO;SERVICIO FACTURADO', {||SCA->cCodFacCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCodFacCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('SERVICIO;FACTURADO', {||SCA->cSerFacCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cSerFacCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EN ARCHIVO', {||SCA->lPrnArcCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','lPrnArcCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;IMPRESORA', {||SCA->nCodigoPrn})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OPCIONES;IMPRESORA', {||SCA->cOpcPrnCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cOpcPrnCar'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OPCIONES;RECIBOS PRN', {||SCA->cOpcRecCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cOpcRecCar'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONFIGURACION;DEL COLOR', {||SCA->nCodigoClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nCodigoClr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('USUARIO ISO', {||SCA->cUsrIsoCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cUsrIsoCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INFORMES;INTRANET', {||SCA->nCodXslCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nCodXslCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PIE DE PAGINA;POR DEFECTO', {||SCA->cPiePagCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cPiePagCar'},{'PICTURE','@S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('HABILITAR;PRUEBAS', {||SCA->nPruebaCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nPruebaCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('BANCO;MODEM', {||SCA->cModemCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cModemCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DE LA;EMPRESA DE COBRO',;
				    {||SCA->cEmpCobCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cEmpCobCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO INTERNO;EMPRESA DE COBRO',;
				   {||SCA->cCodCobCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCodCobCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CLAVE DE REPORTE;EMPRESA DE COBRO',;
				    {||SCA->cPswCobCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cPswCobCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOTIFICAR;POR ESCRITO',;
				   {||SCA->lNtfCobCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','lNtfCobCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE;NOTIFICACION',;
				   {||SCA->cTipNtfCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cTipNtfCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DE;AUTORIZACION',;
				   {||SCA->nAutRetCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nAutRetCar'},{'PICTURE','99999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURACION;DEL MES',{||SCA->nFacMesCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nFacMesCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O INICIAL;DE LA CARTERA',{||SCA->nAnoIniCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nAnoIniCar'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O FINAL;DE LA CARTERA',{||SCA->nAnoFinCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nAnoFinCar'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O INICIAL;PARA REPORTAR',{||SCA->nRepIniCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nRepIniCar'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O FINAL;PARA REPORTAR',{||SCA->nRepFinCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nRepFinCar'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MARGEN DERECHO;PARA EL CERTIFICADO',;
			      {||SCA->nMarDerCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nMarDerCar'}, {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MARGEN IZQUIERDO;TEXTO CERTIFICADO',{||SCA->nIzqTxtCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nIzqTxtCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MARGEN IZQUIERDO;CONCEPTOS CERTIFICADO',{||SCA->nIzqConCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nIzqConCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NUMERO DE;CARTAS',{||SCA->nNroCarCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nNroCarCar'},{'PICTURE','9999999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)

       oColumn	     := TBCOLUMNNEW('COLA ACTIVA;DE IMPRESION', {||SCA->cColaAcCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cColaAcCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MODIFICAR COLAS;DE IMPRESION', {||SCA->lModColCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','lModColCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA;No. 01', {||SCA->cCola01Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola01Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA;No. 02', {||SCA->cCola02Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola02Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SALDOS A¥OS;ANTERIORES',{||SCA->nSdoAnoCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','nSdoAnoCar'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('VALIDAR', {||SCA->lValidaCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','lValidaCar'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*

       oColumn	     := TBCOLUMNNEW('COLA;No. 03', {||SCA->cCola03Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola03Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 04', {||SCA->cCola04Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola04Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 05', {||SCA->cCola05Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola05Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 06', {||SCA->cCola06Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola06Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 07', {||SCA->cCola07Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola07Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 08', {||SCA->cCola08Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola08Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 09', {||SCA->cCola09Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola09Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 10', {||SCA->cCola10Car})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','SCA'},;
			 {'FIELD','cCola10Car'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 10:25 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysCar(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLRES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCar,'CAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileClr,'CLR',NIL,lShared,nModCry})
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
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DEL COLOR
       xClrSys := xColorSys(CAR->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR

/*************************************************************************
* TITULO..: VALIDACION DE LA LICENCIA DE LA CARTERA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 10:25 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nDatCar(cCodEmp,nLicAct,cAnoUsr)

*>>>>DECLARACION DE PARAMETROS
/*     cCodEmp                              // C¢digo de la Empresa
       nLicAct                              // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .T.                 // Variable control de flujo

       LOCAL       i := 0                   // Contador
       LOCAL aCodEmp := {}                  // Empresas. Mantenimiento
       LOCAL nAnoLic := 2010                // A¤o de la licencia

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       AADD(aCodEmp,{'COLSAN001001',nAnoLic-0})        // Colegio La Salle
       AADD(aCodEmp,{'COLSAN001002',nAnoLic-1})        // Instituto San Jose
       AADD(aCodEmp,{'COLSAN001003',nAnoLic-1})        // Colegio del Sagrado Corazon
       AADD(aCodEmp,{'COLSAN001004',nAnoLic-0})        // Colegio Virrey Solis
     *ÀBucaramanga

       AADD(aCodEmp,{'COLSAN002001',nAnoLic-0})        // Colegio del Sagrado Corazon
     *ÀBarrancabermeja

       AADD(aCodEmp,{'COLNSA001001',nAnoLic-1})        // Colegio La Salle
     *ÀCucuta

       AADD(aCodEmp,{'COLCUN001001',nAnoLic-1})        // Colegio de la Salle
       AADD(aCodEmp,{'COLCUN001002',nAnoLic-0})        // Instituto San Bernardo
       AADD(aCodEmp,{'COLCUN001003',nAnoLic-0})        // Liceo Hermano Miguel
       AADD(aCodEmp,{'COLCUN001004',nAnoLic-1})        // Nuestra Se¤ora de la presentaci¢n. Centro
       AADD(aCodEmp,{'COLCUN001005',nAnoLic-1})        // Colegio Parroquial San Carlos
       AADD(aCodEmp,{'COLCUN001012',nAnoLic-0})        // Colegio Nuestra Se¤ora de la Sabidur¡a.
     *ÀBogot 

       AADD(aCodEmp,{'COLMET001001',nAnoLic-0})        // Colegio la Salle
     *ÀVillavicencio

       AADD(aCodEmp,{'COLBOL001001',nAnoLic-1})        // Colegio La Salle
     *ÀCartagena.
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DE LICENCIAS
       lSiorNo := .F.
       FOR i := 1 TO LEN(aCodEmp)
	   IF aCodEmp[i,1] == cCodEmp
	      lSiorNo := .T.
	      IF nLicAct == 0
		 nLicAct := aCodEmp[i,2]
	      ENDIF
	   ENDIF
       ENDFOR
       IF !lSiorNo .OR. (VAL(cAnoUsr)-1) > nLicAct
	  CloseAll()
	  wait error
       ENDIF
       RETURN nLicAct
*>>>>FIN ANALISIS DE LICENCIAS