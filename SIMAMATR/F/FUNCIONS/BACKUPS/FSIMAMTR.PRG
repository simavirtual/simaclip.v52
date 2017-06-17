/*                       SIMA - MATRICULA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CONFIGURACION SIMAMATR

REQUERIMIENTOS:

- Compilar: clipper fSimaMtr /w/m/b

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

   CreaDbfMtr(PathMtr,fSimMtr+cAnoUsr+ExtFile+cAnoUsr+ExtFile,lIntUno,fNtxMtr)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfMtr(lShared,PathMtr,fSimMtr,fNtxMtr,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathMtr				    // Path del Archivo
       fSimMtr				    // Nombre del Archivo
       fNtxMtr				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema



       LOCAL aDbfMtr := {{"cNomEmpMtr","Character",40,0},; // Nombre de la Empresa
			 {"cCiuEmpMtr","Character",20,0},; // Ciudad de la Empresa
			 {"cNroNitMtr","Character",14,0},; // Nit de la Empresa
			 {"cDireccMtr","Character",40,0},; // Direcci¢n de la Empresa
			 {"cTelef1Mtr","Character",12,0},; // Telefono No. 1
			 {"cTelef2Mtr","Character",12,0},; // Telefono No. 2
			 {"cNroFaxMtr","Character",12,0},; // Telefono No. 3
			 {"cGerentMtr","Character",50,0},; // Nombre del Gerente o Rector Actual
			 {"cCarGerMtr","Character",50,0},; // Nombre del Cargo
			 {"cPasGerMtr","Character",10,0},; // PassWord del Gerente
			 {"cNitGerMtr","Character",40,0},; // Documento de Gerente
			 {"cSecretMtr","Character",50,0},; // Nombre de la Secretaria Actual
			 {"cNitSecMtr","Character",40,0},; // Documento de la Secretaria
			 {"cCarSecMtr","Character",50,0},; // Nombre del Cargo
			 {"cPasSecMtr","Character",10,0},; // PassWord de la Secretaria
			 {"cNomSupMtr","Character",50,0},; // Nombre del Supervisor del Sistema
			 {"cPasSupMtr","Character",10,0},; // PassWord del Supervisor
			 {"cModemMtr" ,"Character",20,0},; // Banco para la Gerencia Electronica
			 {"cCodFacMtr","Character",02,0},; // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE
			 {"cSerFacMtr","Character",15,0},; // Servicio facturado
			 {"lModCntMtr","Logical"  ,01,0},; // .T. Modificar Contratantes
			 {"lPrnArcMtr","Logical"  ,01,0},; // .T. Imprimir en la impresora
			 {"nCodigoPrn","Numeric"  ,04,0},; // C¢digo de la Impresora
			 {"nPrnCerPrn","Numeric"  ,04,0},; // C¢digo de la Impresora para certificados
			 {"cOpcPrnMtr","Character",04,0},; // Opciones de Impresi¢n
			 {"nModCarMtr","Numeric"  ,02,0},; // Modo de Protecci¢n de la Cartera
			 {"nCodigoClr","Numeric"  ,02,0},; // C¢digo del Color
			 {"nCodXslMtr","Numeric"  ,02,0},; // C¢digo Xsl para los informes
			 {"cPiePagMtr","Numeric"  ,255,0},; // Pie de p gina informes
			 {"cUsrIsoMtr","Character",10,0},; // Usuario del Iso
			 {"cColaAcMtr","Character",02,0},; // Cola de Impresi¢n Activada
			 {"lModColMtr","Logical"  ,01,0},; // .T. Modificar la Cola Activada
			 {"cCola01Mtr","Character",20,0},;
			 {"cCola02Mtr","Character",20,0},;
			 {"cCola03Mtr","Character",20,0},;
			 {"cCola04Mtr","Character",20,0},;
			 {"cCola05Mtr","Character",20,0},;
			 {"cCola06Mtr","Character",20,0},;
			 {"cCola07Mtr","Character",20,0},;
			 {"cCola08Mtr","Character",20,0},;
			 {"cCola09Mtr","Character",20,0},;
			 {"cCola10Mtr","Character",20,0},;
			 {"nPagOnlMtr","Numeric"  ,02,0},; // Formato para pagos en lineas.
			 {"cCodOnlMtr","Character",36,0},; // C¢digo asignado para pagos en lineas.
			 {"cCodSerMtr","Character",36,0},; // C¢digo interno asignado por la empresa para clasificar el servicio que se recauda
			 {"nPruebaMtr'","Numeric" ,02,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfMtr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathMtr) == 0
	    DBCREATE(fSimMtr,aDbfMtr,"DBFNTX")

       CASE DIRCHANGE(PathMtr) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathMtr)

       CASE DIRCHANGE(PathMtr) == -5
	    cError('NO TIENE DERECHOS EN: '+PathMtr)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathMtr+'\'+fSimMtr,'MTR',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF MTR->(lRegLock(lShared,.T.))
	  REPL MTR->cTelef1Mtr WITH ''
	  REPL MTR->lPrnArcMtr WITH .F.
	  REPL MTR->nCodigoClr WITH 1
	  REPL MTR->lModCntMtr WITH .F.
	  MTR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
       ENDIF
       IF lShared
	  MTR->(DBUNLOCK())
       ENDIF
       CLOSE MTR
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

FUNCTION RecuDbfMtr(lShared,PathMtr,fSimMtr,fNtxMtr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathMtr			      // Path del Archivo
       fSimMtr			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxMtr			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathMtr+'\'+fSimMtr,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DE LA MATRICULA")
       Termometro(100)

       CreaDbfMtr(lShared,PathMtr,fSimMtr,fNtxMtr)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/99 SAB A
       Colombia, Bucaramanga        INICIO: 07:30 PM   SEP 04/99 SAB

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

FUNCTION nActStrMtr(lShared,PathMtr,FileMtr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCar				    // Path del Archivo
       FileMtr				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('MTR')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathMtr+'\'+FileMtr,'MTR',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION GENERAL')
	  CloseDbf('MTR')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := MTR->(DBSTRUCT())
       CloseDbf('MTR')
       CreaDbfMtr(lShared,PathMtr,FileMtr,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
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
	  cError('El Archivo CONFIGURACION GENERAL su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(FileMtr,1,AT('.',FileMtr))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathMtr+'\'+FileMtr,;
			 PathMtr+'\'+FileTem,;
			 {||CreaDbfMtr(lShared,PathMtr,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
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

MantenMtr()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenMtr(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
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
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL oBrwMtr := NIL                 // Objeto Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DE MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrwMtr := oDefBrwMtr(lShared,cAnoUsr,nFilPal+1,00,22,79)
       MTR->(CtrlBrw(lShared,oBrwMtr))
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF MTR->lPrnArcMtr
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CLOSE ALL
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

FUNCTION oDefBrwMtr(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

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
       oBrowse:Cargo     := {'<< CONFIGURACION DEL SISTEMA DE MATRICULA >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT MTR
       oColumn	     := TBCOLUMNNEW('NOMBRE EMPRESA', {||MTR->cNomEmpMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cNomEmpMtr'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CIUDAD', {||MTR->cCiuEmpMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCiuEmpMtr'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIT', {||MTR->cNroNitMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cNroNitMtr'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIRECCION', {||MTR->cDireccMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cDireccMtr'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO 1', {||MTR->cTelef1Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cTelef1Mtr'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO 2', {||MTR->cTelef2Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cTelef2Mtr'}, {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO FAX', {||MTR->cNroFaxMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cNroFaxMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECTOR', {||MTR->cGerentMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cGerentMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA RECTOR', {||MTR->cNitGerMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cNitGerMtr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARGO RECTOR', {||MTR->cCarGerMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCarGerMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SECRETARIA', {||MTR->cSecretMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cSecretMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA SECRETARIA', {||MTR->cNitSecMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cNitSecMtr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CARGO SECRETARIA', {||MTR->cCarSecMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCarSecMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MODIFICAR;CONTRATANTES', {||MTR->lModCntMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','lModCntMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MODO CARTERA', {||MTR->nModCarMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nModCarMtr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BANCO;MODEM', {||MTR->cModemMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cModemMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FORMATO PARA;PAGOS EN LINEA',{||MTR->nPagOnlMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nPagOnlMtr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO ASIGNADO;PAGOS EN LINEA',{||MTR->cCodOnlMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCodOnlMtr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO ASIGNADO;SERVICIO PAGOS EN LINEA',{||MTR->cCodSerMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCodSerMtr'},{'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('CODIGO;SERVICIO FACTURADO', {||MTR->cCodFacMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCodFacMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('SERVICIO;FACTURADO', {||MTR->cSerFacMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cSerFacMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EN ARCHIVO', {||MTR->lPrnArcMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','lPrnArcMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;IMPRESORA', {||MTR->nCodigoPrn})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('IMPRESORA;CERTIFICADO', {||MTR->nPrnCerPrn})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nPrnCerPrn'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)

       oColumn	     := TBCOLUMNNEW('OPCIONES;IMPRESORA', {||MTR->cOpcPrnMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cOpcPrnMtr'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONFIGURACION;DEL COLOR', {||MTR->nCodigoClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nCodigoClr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('USUARIO ISO', {||MTR->cUsrIsoMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cUsrIsoMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INFORMES;INTRANET', {||MTR->nCodXslMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nCodXslMtr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PIE DE PAGINA;POR DEFECTO', {||MTR->cPiePagMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cPiePagMtr'},{'PICTURE','@S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA ACTIVA', {||MTR->cColaAcMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cColaAcMtr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MODIFICAR COLAS', {||MTR->lModColMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','lModColMtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 01', {||MTR->cCola01Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola01Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 02', {||MTR->cCola02Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola02Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('HABILITAR;PRUEBAS', {||MTR->nPruebaMtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','nPruebaMtr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn	     := TBCOLUMNNEW('COLA No. 03', {||MTR->cCola03Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola03Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 04', {||MTR->cCola04Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola04Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 05', {||MTR->cCola05Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola05Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 06', {||MTR->cCola06Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola06Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 07', {||MTR->cCola07Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola07Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 08', {||MTR->cCola08Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola08Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 09', {||MTR->cCola09Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola09Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COLA No. 10', {||MTR->cCola10Mtr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','MTR'},;
			 {'FIELD','cCola10Mtr'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 23/2004 JUE A
       Colombia, Bucaramanga        INICIO: 06:15 PM   SEP 23/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysMtr(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimMtr,'MTR',NIL,lShared,nModCry})
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
       CASE MTR->(RECCOUNT()) == 0
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
       xClrSys := xColorSys(MTR->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR