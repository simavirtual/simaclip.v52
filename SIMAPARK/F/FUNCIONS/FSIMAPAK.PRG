/*                 SIMA - SISTEMA PARA INTRANET E INTERNET
		 FUNCIONES ARCHIVO DE CONFIGURACION GENERAL

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPak(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cNomSupPak','Character',50,0}) // Nombre del Supervisor del Sistema
       AADD(aDbfStr,{'cPasSupPak','Character',10,0}) // PassWord del Supervisor
       AADD(aDbfStr,{'cDirEmpPak','Character',20,0}) // Direccion de la Empresa
       AADD(aDbfStr,{'cTelEmpPak','Character',20,0}) // Direccion de la Empresa
       AADD(aDbfStr,{'cTelEmpPak','Character',20,0}) // Direccion de la Empresa
       AADD(aDbfStr,{'cRegDiaPak','Character',40,0}) // Registro Dian
       AADD(aDbfStr,{'cMsgTxtPak','Character',40,0}) // Mensaje de Texto
       AADD(aDbfStr,{'lTarMinPak','Logical'  ,01,0}) // .T. Tarifas por minutos
       AADD(aDbfStr,{'lVlrMenPak','Logical'  ,01,0}) // .T. Valor de la Mensualidad
       AADD(aDbfStr,{'nRoundPak' ,'Numeric'  ,03,0}) // Valor para el redondeo.
       AADD(aDbfStr,{'nNroFacPak','Numeric'  ,09,0}) // Numero de la Factura
       AADD(aDbfStr,{'nMinFraPak','Numeric'  ,02,0}) // Minutos de la Fracci¢n de Dividir
       AADD(aDbfStr,{'nMinDesPak','Numeric'  ,02,0}) // Minutos de Descuento
       AADD(aDbfStr,{'lMinDesPak','Logical'  ,01,0}) // .F. => NO cobra la primera Fracci¢n .T. => SI cobra la primera Fracci¢n
       AADD(aDbfStr,{'lTotHorPak','Logical'  ,01,0}) // .F. => Cobra sumatoria horas diurnas y nocturnas .T. => Cobra por total de horas Ej: 13 horas
       AADD(aDbfStr,{'nPorIvaPak','Numeric'  ,05,2}) // Porcentaje del Iva
       AADD(aDbfStr,{'cIniDiaPak','Character',08,0}) // Inicio de la Hora Diurna
       AADD(aDbfStr,{'cFinDiaPak','Character',08,0}) // Final de la Hora Diurna
       AADD(aDbfStr,{'cIniNocPak','Character',08,0}) // Inicio de la Hora Nocturna
       AADD(aDbfStr,{'cFinNocPak','Character',08,0}) // Final de la Hora Nocturna
       AADD(aDbfStr,{'nLinPrnPak','Numeric'  ,02,0}) // L¡neas de Espaciado
       AADD(aDbfStr,{'cBrkPrnPak','Character',20,0}) // Corte de Papel
       AADD(aDbfStr,{'cOpeCajPak','Character',20,0}) // Abrir la Caja
       AADD(aDbfStr,{'lRunAppPak','Logical'  ,01,0}) // .T. Activar el control de ejecuci¢n
       AADD(aDbfStr,{'nRunAppPak','Numeric'  ,04,0}) // Contador de Ejecusion.
       AADD(aDbfStr,{'lPrnArcPak','Logical'  ,01,0}) // .T. Imprimir en la impresora
       AADD(aDbfStr,{'nCodigoPrn','Numeric'  ,04,0}) // C¢digo de la Impresora
       AADD(aDbfStr,{'cOpcPrnPak','Character',04,0}) // Opciones de Impresi¢n
       AADD(aDbfStr,{'cOpcRecPak','Character',04,0}) // Opciones de Impresi¢n para recibos
       AADD(aDbfStr,{'nCodigoClr','Numeric'  ,02,0}) // C¢digo del Color
       AADD(aDbfStr,{'cPatDatPak','Character',70,0}) // Path para Datos
       AADD(aDbfStr,{'lPruebaPak','Logical'  ,01,0}) // .T. Hacer Pruebas
       AADD(aDbfStr,{'nLeeCatPak','Numeric'  ,02,0}) // Tipo de lectura de la categoria
       AADD(aDbfStr,{'dFecSysPak','Date'     ,08,0}) // Fecha del Sistema
       AADD(aDbfStr,{'cHorSysPak','Character',08,0}) // Hora del Sistema
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>VERIFICACION O CREACION DEL DIRECTORIO
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathArc) == 0
	    nCd(PathAct)

       CASE nCd(PathArc) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathArc)
	    QUIT

       CASE nCd(PathArc) == -3
	    DIRMAKE(PathArc)
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO

*>>>>CREACION DE LA ESTRUCTURA
       DO CASE
       CASE nCd(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE nCd(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE nCd(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       nCd(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'ARC',NIL,lShared,nModCry)
	  WAIT 'ABRIENDO EL ARCHIVO DE CONFIGURACION DE CARTERA'
	  CloseDbf('ARC',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF ARC->(lRegLock(lShared,.T.))
	  REPL ARC->nCodigoClr WITH 1
	  REPL ARC->cPatDatPak WITH '\SIMA\DATOS'
	  REPL ARC->cIniDiaPak WITH '06:00:00'
	  REPL ARC->cFinDiaPak WITH '18:00:00'
	  REPL ARC->cIniNocPak WITH '18:00:01'
	  REPL ARC->cFinNocPak WITH '05:59:59'
	  REPL ARC->lVlrMenPak WITH .T.
	  ARC->(DBCOMMIT())
       ELSE
	  WAIT 'NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION'
       ENDIF
       IF lShared
	  ARC->(DBUNLOCK())
       ENDIF
       CloseDbf('ARC',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:05 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPak(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfPak(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:10 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrPak(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('ACT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaDbfPak(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
	  cError('El Archivo '+cNomArc+' su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfPak(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:15 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPak(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   cNomSec,cCodEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatDat,cPatSys,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,lModReg,lDelReg,lInsReg,lHaySql)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodEmp			            // C¢digo de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar el Registro
       lHaySql                              // .T. Exportar a Sql */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL oBrowse := NIL                 // Objeto Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimPak,'PAK',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
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
       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       lHaySql := IF(lHaySql==NIL,.T.,lHaySql)
       oBrowse := oDefBrwPak(lShared,cAnoUsr,nFilPal+1,00,22,79,;
			     lModReg,lDelReg,lInsReg,lHaySql)

       SETKEY(K_F9,{||MenuOtrPak(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
				 nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
				 cPatSis,cMaeAlu,cMaeAct,cJorTxt,lModReg,;
				 lDelReg,lInsReg,lHaySql,oBrowse)})

       PAK->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F9,NIL)
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF PAK->lPrnArcPak
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CloseDbf('PAK')
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:20 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPak(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
		    lModReg,lDelReg,lInsReg,lHaySql)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registros
       lHaySql                              // .T. Exportar a Sql */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL	            // Browse de Archivo
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       lDelReg := IF(lDelReg==NIL,.F.,lDelReg)
       lInsReg := IF(lInsReg==NIL,.F.,lInsReg)

       cTitSup := '<< CONFIGURACION DEL SISTEMA >>'
       cTitInf := '<ENTER>Modificar'+;
		   IF(lDelReg,' <DEL>Borrar','')+;
		   IF(lInsReg,' <INS>Insertar','')+;
		   IF(lHaySql,' <F9>Otros','')+;
		   ' <ESC>Abandonar'

       oBrowse:Cargo := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       lModReg := IF(EMPTY(lModReg),.T.,lModReg)
       lModReg := IF(lModReg .AND. PAK->(RECCOUNT())==0,.F.,lModReg)

       SELECT PAK
/*
       oColumn	     := TBCOLUMNNEW('TARIFAS POR;MINUTOS', {||PAK->lTarMinPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lTarMinPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn	     := TBCOLUMNNEW('UNIDAD A;REDONDEAR', {||PAK->nRoundPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nRoundPak'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR POR;MENSUALIDAD', {||PAK->lVlrMenPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lVlrMenPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FRACCION DE;MINUTOS A COBRAR', {||PAK->nMinFraPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nMinFraPak'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MINUTOS;DESCUENTO', {||PAK->nMinDesPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nMinDesPak'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COBRAR LA;PRIMERA FRACCION', {||PAK->lMinDesPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lMinDesPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COBRAR POR;TOTAL HORAS', {||PAK->lTotHorPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lTotHorPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INICIO;JORNADA DIURNA',;
				    {||PAK->cIniDiaPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cIniDiaPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FINALIZA;JORNADA DIURNA',;
				    {||PAK->cFinDiaPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cFinDiaPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INICIO;JORNADA NOCTURNA',;
				    {||PAK->cIniNocPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cIniNocPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FINALIZA;JORNADA NOCTURNA',;
				    {||PAK->cFinNocPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cFinNocPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('DIRECCION', {||PAK->cDirEmpPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cDirEmpPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO', {||PAK->cTelEmpPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cTelEmpPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IVA', {||PAK->nPorIvaPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nPorIvaPak'},{'PICTURE','99.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURA', {||PAK->nNroFacPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nNroFacPak'},{'PICTURE','999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REGISTRO DIAN', {||PAK->cRegDiaPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cRegDiaPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MENSAJE', {||PAK->cMsgTxtPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cMsgTxtPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LINEAS DE;ESPACIO', {||PAK->nLinPrnPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nLinPrnPak'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CORTE DE PAPEL', {||PAK->cBrkPrnPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cBrkPrnPak'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ABRIR LA CAJA', {||PAK->cOpeCajPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cOpeCajPak'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONTROL;EJECUCION', {||PAK->lRunAppPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lRunAppPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONTROL;EJECUCION', {||PAK->nRunAppPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nRunAppPak'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EN ARCHIVO', {||PAK->lPrnArcPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lPrnArcPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;IMPRESORA', {||PAK->nCodigoPrn})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OPCIONES;RECIBOS PRN', {||PAK->cOpcRecPak})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAK'},;
			 {'FIELD','cOpcRecPak'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OPCIONES;IMPRESORA', {||PAK->cOpcPrnPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','cOpcPrnPak'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE LECTURA;DE LA CATEGORIA', {||PAK->nLeeCatPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nLeeCatPak'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('FECHA;CONTROL',{||PAK->dFecSysPak})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PAK'},;
			 {'FIELD','dFecSysPak'},{'PICTURE','@!D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('HORA;CONTROL',{||PAK->cHorSysPak})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PAK'},;
			 {'FIELD','cHorSysPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONFIGURACION;DEL COLOR', {||PAK->nCodigoClr})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','nCodigoClr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PATH PARA LOS DATOS', {||PAK->cPatDatPak})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAK'},;
			 {'FIELD','cPatDatPAK'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HABILITAR;PRUEBAS', {||PAK->lPruebaPak})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','PAK'},;
			 {'FIELD','lPruebaPak'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:25 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPak(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    cNomSec,cCodEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		    cAnoUsr,cPatDat,cPatSys,cPatSis,cMaeAlu,cMaeAct,;
		    cJorTxt,lModReg,lDelReg,lInsReg,lHaySql,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodEmp                              // C¢digo de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar el Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

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
       LOCAL aDbfStr := {'1'}               // Estructura del Archivo

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<CONFIGURACION SISTEMA>')
       IF lHaySql
	  AADD(aMenus,'2<EXPORTAR A MYSQL   >')
	  AADD(aMenus,'3<CREAR TABLA SIMAPAK>')
       ENDIF

       aAyuda := {}
       AADD(aAyuda,'Imprime la Configuraci¢n del Sistema')
       IF lHaySql
	  AADD(aAyuda,'Exporta los Registros a MySql')
	  AADD(aAyuda,'Crea la Tabla SimaPak para MySql')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrWwA011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      cNomSec,cCodEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		      cAnoUsr,cPatDat,cPatSys,cPatSis,cMaeAlu,cMaeAct,;
		      cJorTxt,lModReg,lDelReg,lInsReg,lHaySql,oBrowse)
	  *ÀImpresi¢n Configuraci¢n del Sistema

       CASE nNroOpc == 2

************EXPORTAR A MYSQL
	      CreaDbfPak(,,,,@aDbfStr)
	    *ÀEstructura

/*
	      FileSql(cPatSis(cPatDat,cPatSys,cPatSis)+'\FILEWWW',;
		      '1'+fSimWww,fSimWww,aDbfStr,'WWW') */
	    *ÀCreaci¢n de la Tabla Sql
************FIN EXPORTAR A MYSQL

       CASE nNroOpc == 3

************TABLA SIMAWWW
	      aDbfStr := {}
	      AADD(aDbfStr,{'cUrlBolWww','Character',60,0}) // Url para el Boletin
	      AADD(aDbfStr,{'cExtBolWww','Character',04,0}) // Extensi¢n para el Boletin
	      AADD(aDbfStr,{'cUrlImgWww','Character',60,0}) // Url para las Imagenes
	      AADD(aDbfStr,{'cUrlFotWww','Character',60,0}) // Url para las Fotos
	      AADD(aDbfStr,{'cExtFotWww','Character',04,0}) // Extensi¢n para las Fotos
	    *ÀEstructura

/*
	      FileSql(cPatSis(cPatDat,cPatSys,cPatSis)+'\FILEWWW',;
		      fSimWww,fSimWww,aDbfStr,'WWW') */
	    *ÀCreaci¢n de la Tabla Sql
************FIN TABLA SIMAWWW

       ENDCASE
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrWwA011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   cNomSec,cCodEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatDat,cPatSys,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,lModReg,lDelReg,lInsReg,lHaySql,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodEmp                              // C¢digo de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar el Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

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

       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL FileXml := ''                  // Archivo Xml
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE WWW->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA CONFIGURACIN DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr,;
		   'CONFIGURACION DEL SISTEMA',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {120}
       aTitPrn := {'CONFIGURACION DEL SISTEMA'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .T.
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
       IF WWW->lPrnArcWww
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Www'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,WWW->cOpcPrnWww,.F.,.T.)
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

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT WWW
       WWW->(DBGOTOP())
       DO WHILE .NOT. WWW->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( WWW->(RECNO()) / WWW->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    cTxtPrn := 'SUPERVISOR:'+ALLTRIM(WWW->cNomSupWww)
	    cTxtPrn := SUBS(cTxtPrn+SPACE(120),1,120)

	    AADD(aRegPrn,cTxtPrn)
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    aRegPrn := {}

	    cTxtPrn := 'IMPRIMIR A ARCHIVO:'+IF(WWW->lPrnArcWww,'SI','NO')
	    cTxtPrn := SUBS(cTxtPrn+SPACE(120),1,120)

	    AADD(aRegPrn,cTxtPrn)
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT WWW
	    WWW->(DBSKIP())
	    IF WWW->(EOF())
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
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:25 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysPak(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimPak,'PAK',NIL,lShared,nModCry})
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
       CASE PAK->(RECCOUNT()) == 0
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
       xClrSys := xColorSys(PAK->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR

/*************************************************************************
* TITULO..: PATH GENERALES DEL SISTEMA                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   OCT 01/2004 VIE

OBJETIVOS:

1- Retorna por referencia los paths generales del Sistema

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathSysPak(lShared,nModCry,cDirEmp,cPatDat,cPatSys)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cDirEmp                              // Directorio de la Empresa
       cPatDat                              // @Path de Datos
       cPatSys                              // @Path del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimPak,'TEM',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('TEM')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TEM->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('TEM')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DEL COLOR
       IF EMPTY(ALLTRIM(TEM->cPatDatPak))
	  cPatDat := ""
	  cPatSys := ""
       ELSE
	  cPatDat := ALLTRIM(TEM->cPatDatPak)
	  cPatSys := cDirEmp
	  cPatSys := ''    // Sin Directorio de Empresa
       ENDIF
       CloseDbf('TEM')
       RETURN NIL
*>>>>FIN SELECCION DEL COLOR