/*               	 SISTEMA CARTERA ACADEMICA
	BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CUENTAS DE CONTABILIDAD

REQUERIMIENTOS:

- Compilar: clipper FuncsCCO /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo Cuentas de Contabilidad

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/2000 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 15/2000 LUN

OBJETIVOS:

1)- Crea la estructura del archivo.

2)- Retorna NIL

SINTAXIS:

   CreaDbfCco(PathCco,FileCco,fNtxCco)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCco(lShared,PathCco,FileCco,lIntUno,fNtxCco)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCco				    // Path del Archivo
       FileCco				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxCco				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL       i := 0                   // Contador

       LOCAL aDbfCco := {{"cCodigoCco","Numeric"  ,12,0},;  // Codigo de la Cuenta
			 {"cNombreCco","Character",60,0}}   // Nombre de la Cuenta
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE(PathCco) == 0
	    DBCREATE(FileCco,aDbfCco,"DBFNTX")

       CASE DIRCHANGE(PathCco) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCco)

       CASE DIRCHANGE(PathCco) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCco)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCco+'\'+FileCco,'CCO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CUENTAS DE CONTABILIDAD')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
	   IF CCO->(lRegLock(lShared,.T.))

	      REPL CCO->nCodigoCco WITH 0
	      REPL CCO->cNombreCco WITH 'POR CONTABILIZAR'
	      CCO->(DBCOMMIT())
	      IF lShared
		 CCO->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL CUENTAS DE CONTABILIDAD')
	   ENDIF

       CloseDbf('CCO')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/2000 LUN A
       Colombia, Bucaramanga        INICIO: 04:03 PM   MAY 15/2000 LUN

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCco(lShared,PathCco,FileCco,lIntUno,fNtxCco)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathCco			      // Path del Archivo
       FileCco			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxCco			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCco+'\'+FileCco,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE CLASES")
       Termometro(100)

       CreaDbfCco(lShared,PathCco,FileCco,lIntUno,fNtxCco)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO 		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCco(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,;
		   lIntCua,cMaeAlu,cMaeAct,cJorTxt,cModem)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       cModem                               // Banco de la Gerencia */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del Maestro

       LOCAL oBrowse := NIL                 // Browse de Transaciones
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileCco,'CCO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT CCO
       IF !lFileLock()
	  oBrowse := oDefBrwCco(lShared,nFilPal+1,00,22,79)
	  SETKEY(K_F5,{||BuscarCco(oBrowse)})
	  SETKEY(K_F9,{||PrnConMov(lShared,cNomEmp,cNomSis)})
	  CCO->(CtrlBrw(lShared,oBrowse))
	  SETKEY(K_F5,NIL)
	  SETKEY(K_F9,NIL)
       ENDIF
       DBUNLOCKALL()
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo.

SINTAXIS:

 oBrowse := oDefBrwCco(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCco(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Transaciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo := {'<< MANTENIMIENTO CONCEPTOS DE LOS MOVIMIENTOS >>',;
			 '<INS>Incluir <F5>Buscar  <DEL>Borrar  '+;
			 '<F9>Imprimir <ESC>Abandonar',{||IncluirCco(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CCO
       oColumn	     := TBCOLUMNNEW('CODIGO', {||CCO->nCodigoCco})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CCO'},{'FIELD','nCodigoCco'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION', {||CCO->cNombreCco})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CCO'},{'FIELD','cNombreCco'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REFERENCIA', {||CCO->cCodRefTra})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CCO'},{'FIELD','cCodRefTra'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirCco(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nCodigoTcm := ''               // C¢digo del Concepto
       LOCAL cNombreTcm := ''               // Nombre del Concepto
       LOCAL cCodRefTtr := ''               // C¢digo de la Referencia
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR DIGITE LOS NOMBRES '+;
			 'DE LOS CONCEPTOS',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       nCodigoTcm := 0
	       cNombreTcm := cSpaces('CCO','cNombreCco')
	       cCodRefTtr := cSpaces('CCO','cCodRefTra')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET nCodigoTcm PICT '9999';
				VALID !lValCodCco(nCodigoTcm)

	    @ nNroFil+1,nNroCol SAY 'NOMBRE DEL CONCEPTO:';
				GET cNombreTcm PICT '@!'

	    @ nNroFil+2,nNroCol SAY 'REFERENCIA         :';
				GET cCodRefTtr PICT '@!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(cNombreTcm)

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
       SELECT CCO
       IF lGrabar
	  IF CCO->(lRegLock(lShared,.T.))
	     REPL CCO->nCodigoCco WITH nCodigoTcm
	     REPL CCO->cNombreCco WITH cNombreTcm
	     REPL CCO->cCodRefTra WITH cCodRefTtr
	     CCO->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  CCO->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

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

FUNCTION lValCodCco(nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('nCodigoCco','CCO',nCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Debe estar en uso los archivo.

2- Busca el c¢digo.

3- Retorna NIL

SINTAXIS:

  BuscarCco(oBrowse,cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCco(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nCodigo := ''                  // C¢digo de Buscar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       nCodigo := 0
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET nCodigo PICT '9999';
			 VALID lValidaCco(ROW(),COL()-1,@nCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(nCodigo)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT CCO
       IF lBuscar .AND. lLocCodigo('nCodigoCco','CCO',nCodigo)
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
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValidaCco(nNroFil,nNroCol,nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodigo				    // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('nCodigoCco','CCO',nCodigo)
	  nNroReg := nSelCodCco(nNroFil,nNroCol)
	  IF nNroReg == 0
	     nCodigo := 0
	  ELSE
	     GO nNroReg
	     nCodigo := CCO->nCodigoCco
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL CODIGO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger el registro del archivo de acuerdo al nombre.

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodCco(nNroFil,nNroCol)

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
       LOCAL nNroReg := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF CCO->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CCO
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL REGISTRO
       CCO->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||CCO->cNombreCco})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION CAMPOS DEL MANTENIMIENTO             *
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

FUNCTION PrnConMov(lShared,cNomEmp,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "CAMPOS\ARC-CART.PRG"       // Archivos del Sistema

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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF CCO->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := CCO->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'CONCEPTO DE LAS TRANSACIONES',;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,40,12}
       aTitulo := {'CODIGO',;
		   'DESCRIPCION',;
		   'REFERENCIA'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n10Stan
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

*>>>>ANALISIS DE DECISION
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
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

       SELECT CCO
       GO TOP
       DO WHILE .NOT. CCO->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CCO->(RECNO()) / CCO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aTitulo := {STR(CCO->nCodigoCco,4),;
			CCO->cNombreCco,;
			CCO->cCodRefTra}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CCO
	    CCO->(DBSKIP())
	    IF CCO->(EOF())
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

/*************************************************************************
* TITULO DE LA FUNCION..: CODIGO DEL CONCEPTO DEL MOVIMIENTO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Retorna el C¢digo del Concepto del Movimiento de acuerdo al c¢digo
   de la referencia.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCodigoCco(nMesAct,cCodRef,nLenRef)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMesAct                              // Mes Actual
       cCodRef                              // C¢digo de la Referencia
       nLenRef                              // Longitud de la Referencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodEst := ''                  // C¢digo del Estudiante
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nCodigoTcm := 0                // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA REFERENCIA
       cCodRef := ALLTRIM(cCodRef)
       cCodEst := SUBS(cCodRef,1,6)
       nMesIni := VAL(SUBS(cCodRef,7,2))
       nMesFin := VAL(SUBS(cCodRef,9,2))

       DO CASE
       CASE LEN(cCodRef) == nLenRef    .AND.;
	    LEN(ALLTRIM(cCodEst)) == 6 .AND.;
	    nMesIni >= 1 .AND. nMesIni <= 12

	    IF nMesAct == nMesIni
	       nCodigoTcm := 1              // Pension Mes Actual
	    ELSE
	       nCodigoTcm := 2              // Pensi¢n Otros Meses
	    ENDIF

       CASE LEN(cCodRef) == nLenRef    .AND.;
	    LEN(ALLTRIM(cCodEst)) == 6 .AND.;
	    nMesIni == 14
	    nCodigoTcm := 3                     // Abono

       CASE LEN(cCodRef) == nLenRef    .AND.;
	    LEN(ALLTRIM(cCodEst)) == 6 .AND.;
	    nMesIni == 13 .AND. nMesIni == 13
	    nCodigoTcm := 4                     // Matricula

       OTHERWISE
	    IF lLocCodigo('ALLTRIM(cCodRefTra)','CCO',cCodRef)
	       nCodigoTcm := CCO->nCodigoCco
	    ENDIF
       ENDCASE
       RETURN nCodigoTcm
*>>>>FIN ANALISIS DE LA REFERENCIA

/*************************************************************************
* TITULO DEL PROGRAMA..: NOMBRE DEL CONCEPTO DEL MOVIMIENTO              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/99 JUE A
       Bucaramanga, Colombia        INICIO: 05:15 PM   MAY 06/99 JUE

OBJETIVOS:

1- Deben estar en uso los archivos de tipos y conceptos del Movimiento.

2- Permite analizar el concepto del movimiento del extracto.

3- Retorna el concepto del movimiento.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cConcepCco(nCodigo,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodigo                              // C¢digo a Buscar
       cNalias                              // Alias para el Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cConcep := ''                  // Concepto del Movimiento.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CONCEPTO DEL MOVIMIENTO
       IF lLocCodigo('nCodigoCco','CCO',nCodigo)
	  cConcep := CCO->cNombreCco
       ELSE
	  cConcep := 'OTROS'
       ENDIF
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cConcep
*>>>>FIN LOCALIZACION DEL CONCEPTO DEL MOVIMIENTO