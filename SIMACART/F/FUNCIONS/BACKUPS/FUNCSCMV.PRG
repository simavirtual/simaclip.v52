/*               	 SISTEMA CARTERA ACADEMICA
	BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO TIPO DE MOVIMIENTOS

REQUERIMIENTOS:

- Compilar: clipper FuncsCmv /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo Conceptos del Movimiento

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1)- Crea la estructura del archivo.

2)- Retorna NIL

SINTAXIS:

   CreaDbfCmv(PathCmv,FileCmv,fNtxCmv)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCmv(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL       i := 0                   // Contador
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'nCodigoCmv','Numeric',4,0})    // Codigo del Nombre del Concepto.
       AADD(aDbfStr,{'cCodRefTra','Character',12,0}) // C¢digo de la Referencia
       AADD(aDbfStr,{'cNombreCmv','Character',40,0}) // Nombre del tipo del Movimiento
       AADD(aDbfStr,{'lConsigCmv','Logical'  ,01,0}) // .T. Habilita el concepto para consignar
       AADD(aDbfStr,{'nCodCmvCmv','Numeric',4,0})    // Codigo del Nombre del tipo de movimiento
       AADD(aDbfStr,{'cAnoCmvCmv','Character',04,0}) // C¢digo de la Referencia
       AADD(aDbfStr,{'cMotivoTra','Character',12,0}) // Movito de la Transaci¢n
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
          aStrDbf := aDbfStr
          RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathArc) == 0
            DBCREATE(fArchvo,aDbfStr,'DBFNTX')

       CASE nCd(PathArc) == -3
            cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE nCd(PathArc) == -5
            cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       nCd(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'CMV',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONCEPTO DEL MOVIMIENTO')
	  CloseDbf('CMV')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := 0 TO 4

	   IF CMV->(lRegLock(lShared,.T.))
	      DO CASE
	      CASE i == 0
		   REPL CMV->nCodigoCmv WITH 0
		   REPL CMV->cNombreCmv WITH 'OTROS'
		   CMV->(DBCOMMIT())

	      CASE i == 1
		   REPL CMV->nCodigoCmv WITH 1
		   REPL CMV->cNombreCmv WITH 'RECIBOS MES ACTUAL'
		   CMV->(DBCOMMIT())

	      CASE i == 2
		   REPL CMV->nCodigoCmv WITH 2
		   REPL CMV->cNombreCmv WITH 'RECIBOS OTROS MESES'
		   CMV->(DBCOMMIT())

	      CASE i == 3
		   REPL CMV->nCodigoCmv WITH 3
		   REPL CMV->cNombreCmv WITH 'ABONOS'
		   CMV->(DBCOMMIT())

	      CASE i == 4
		   REPL CMV->nCodigoCmv WITH 4
		   REPL CMV->cNombreCmv WITH 'MATRICULAS'
		   CMV->(DBCOMMIT())
	      ENDCASE

	      IF lShared
		 CMV->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	   ENDIF

       ENDFOR
       CloseDbf('CMV')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB  1/2007 JUE A
       Colombia, Bucaramanga        INICIO:  5:25 PM   FEB  1/2007 JUE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCmv(lShared,nModCry,PathArc,fArchvo)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError('SE BORRO EL ARCHIVO '+PathArc+'\'+fArchvo,;
              'Error Grave. TOME NOTA',;
              'Al Presionar Cualquier tecla se crea el archivo')
       Termometro(0,'CREANDO LA ESTRUCTURA')
       Termometro(100)
       CreaDbfCmv(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB  1/2007 JUE A
       Colombia, Bucaramanga        INICIO:  5:25 PM   FEB  1/2007 JUE

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

FUNCTION nActStrCmv(lShared,nModCry,PathArc,cNomArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       cNomArc                              // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

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
       CreaDbfCmv(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
*>>>>FIN VALIDACION DE LA ESTRUCTURA

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
			 {||CreaDbfCmv(lShared,nModCry,PathArc,FileTem)})
             cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
             nNroErr := 1
          ENDIF
          RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

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

FUNCTION MantenCmv(aP1,aP2,aP3,aArchvo,cOpcPrn,nCodPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aArchvo                              // Archivos en Uso
       cOpcPrn                              // Opciones de Impresi¢n
       nCodPrn                              // C¢digo de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

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

       LOCAL       i := 0                   // Contador
       LOCAL lHayPrn := .F.                 // .T. Hay Archivo de Impresi¢n
       LOCAL fArchvo := ''                  // Nombre del Archivo
       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL cNalias := ''                  // Alias del Archivo

       LOCAL oBrowse := NIL                 // Browse de Transaciones
       LOCAL GetList := {}                  // Variable del Sistema

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       FOR i := 1 TO LEN(aArchvo)
           fArchvo := aArchvo[i,1]
           fNtxArc := aArchvo[i,2]
           cNalias := aArchvo[i,3]
           AADD(aUseDbf,{.T.,fArchvo,cNalias,fNtxArc,lShared,nModCry})
           IF cNalias == 'PRN'
              lHayPrn := .T.
           ENDIF
       ENDFOR
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
          cError('ABRIENDO EL ARCHIVO')
          CloseAll()
          RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF lHayPrn
          IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
             cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
             CloseAll()
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT CMV
       oBrowse := oDefBrwCmv(lShared,nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarCmv(oBrowse)})
       SETKEY(K_F6,{||OrdenaCmv(lShared,nModCry,cAnoUsr,cPatSis,oBrowse)})

       SETKEY(K_F9,{||PrnConMov(lShared,nModCry,cNomEmp,;
				cNomSis,cNomUsr,cAnoUsr,cOpcPrn)})
       CMV->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F6,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf)
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

 oBrowse := oDefBrwCmv(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCmv(lShared,nFilSup,nColSup,nFilInf,nColInf)

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
			 '<INS>Incluir <F5>Buscar <F6>Ordenar <DEL>Borrar  '+;
			 '<F9>Imprimir <ESC>Abandonar',{||IncluirCmv(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CMV
       oColumn	     := TBCOLUMNNEW('CODIGO', {||CMV->nCodigoCmv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','nCodigoCmv'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION', {||CMV->cNombreCmv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','cNombreCmv'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REFERENCIA', {||CMV->cCodRefTra})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','cCodRefTra'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONSIGNAR', {||CMV->lConsigCmv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','lConsigCmv'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||CMV->nCodCmvCmv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','nCodCmvCmv'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O', {||CMV->cAnoCmvCmv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','cAnoCmvCmv'},;
			 {'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MOTIVO', {||CMV->cMotivoTra})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CMV'},{'FIELD','cMotivoTra'},;
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

FUNCTION IncluirCmv(lShared)

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
	       cNombreTcm := cSpaces('CMV','cNombreCmv')
	       cCodRefTtr := cSpaces('CMV','cCodRefTra')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET nCodigoTcm PICT '9999';
				VALID !lValCodCmv(nCodigoTcm)

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
       SELECT CMV
       IF lGrabar
	  IF CMV->(lRegLock(lShared,.T.))
	     REPL CMV->nCodigoCmv WITH nCodigoTcm
	     REPL CMV->cNombreCmv WITH cNombreTcm
	     REPL CMV->cCodRefTra WITH cCodRefTtr
	     CMV->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  CMV->(DBUNLOCK())
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

FUNCTION lValCodCmv(nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('nCodigoCmv','CMV',nCodigo) .AND. !lHayErr
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

  BuscarCmv(oBrowse,cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCmv(oBrowse)

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
			 VALID lValidaCmv(ROW(),COL()-1,@nCodigo)
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
       SELECT CMV
       IF lBuscar .AND. lLocCodigo('nCodigoCmv','CMV',nCodigo)
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

FUNCTION lValidaCmv(nNroFil,nNroCol,nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodigo				    // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('nCodigoCmv','CMV',nCodigo)
	  nNroReg := nSelCodCmv(nNroFil,nNroCol)
	  IF nNroReg == 0
	     nCodigo := 0
	  ELSE
	     GO nNroReg
	     nCodigo := CMV->nCodigoCmv
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

FUNCTION nSelCodCmv(nNroFil,nNroCol)

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
       IF CMV->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CMV
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
       CMV->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||CMV->cNombreCmv})
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

FUNCTION PrnConMov(lShared,nModCry,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cOpcPrn)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cOpcPrn                              // Opciones de Impresion */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF CMV->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := CMV->(RECCOUNT())+nLinTot
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

*>>>>ACTIVACION DE LA IMPRESORA
       FilePrn := 'FileCmv'
       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,,,PathDoc)
       IF EMPTY(nOpcPrn)
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

       SELECT CMV
       GO TOP
       DO WHILE .NOT. CMV->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CMV->(RECNO()) / CMV->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aTitulo := {STR(CMV->nCodigoCmv,4),;
			CMV->cNombreCmv,;
			CMV->cCodRefTra}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CMV
	    CMV->(DBSKIP())
	    IF CMV->(EOF())
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
       VerPrn(nOpcPrn,FilePrn)

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

FUNCTION nCodigoCmv(nMesAct,cCodRef,nLenRef,cCodFac,cCodSer,cCodMtv)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMesAct                              // Mes Actual
       cCodRef                              // C¢digo de la Referencia
       nLenRef                              // Longitud de la Referencia
       cCodFac                              // C¢digo Servicio Facturado. Ej: 01->PENSION,02->RESTAURANTE,03->TRANSPORTE
       cCodSer                              // C¢digo Servicio Facturado. Configurado
       cCodMtv                              // C¢digo del motivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodEst := ''                  // C¢digo del Estudiante
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nCodigoTcm := 0                // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA REFERENCIA
       cCodFac := IF(cCodFac==NIL,'',cCodFac)
       cCodSer := IF(cCodSer==NIL,'',cCodSer)
       cCodRef := ALLTRIM(cCodRef)
       cCodEst := SUBS(cCodRef,1,6)
       nMesIni := VAL(SUBS(cCodRef,7,2))
       nMesFin := VAL(SUBS(cCodRef,9,2))

       cCodMtv := IF(cCodMtv==NIL,'',cCodMtv)
       cCodMtv := ALLTRIM(cCodMtv)

       DO CASE
       CASE LEN(cCodRef) == nLenRef          .AND.;
	    LEN(ALLTRIM(cCodEst)) == 6       .AND.;
	    nMesIni >= 1 .AND. nMesIni <= 12 .AND.;
	    nMesFin >= 1 .AND. nMesFin <= 12

	    IF cCodFac == cCodSer
	       IF nMesAct == nMesIni
		  nCodigoTcm := 1              // Pension Mes Actual
	       ELSE
		  nCodigoTcm := 2              // Pensi¢n Otros Meses
	       ENDIF
	    ELSE
	       SELECT CMV
	       CMV->(DBGOTOP())
	       LOCATE FOR ALLTRIM(CMV->cCodRefTra) == ALLTRIM(cCodFac)

	       IF FOUND()

		  IF CMV->nCodCmvCmv > 0
		     nCodigoTcm := CMV->nCodCmvCmv
		  ELSE
		     nCodigoTcm := CMV->nCodigoCmv
		 ENDIF
	       ENDIF
	    ENDIF

       CASE LEN(cCodRef) == nLenRef    .AND.;
	    LEN(ALLTRIM(cCodEst)) == 6 .AND.;
	    nMesIni == 14              .AND.;
	    nMesFin >= 1 .AND. nMesFin <= 12

	    IF cCodFac == cCodSer
	       nCodigoTcm := 3                     // Abono
	    ELSE
	       SELECT CMV
	       CMV->(DBGOTOP())
	       LOCATE FOR ALLTRIM(CMV->cCodRefTra) == ALLTRIM(cCodFac)

	       IF FOUND()

		  IF CMV->nCodCmvCmv > 0
		     nCodigoTcm := CMV->nCodCmvCmv
		  ELSE
		     nCodigoTcm := CMV->nCodigoCmv
		 ENDIF
	       ENDIF
	    ENDIF

       CASE LEN(cCodRef) == nLenRef    .AND.;
	    LEN(ALLTRIM(cCodEst)) == 6 .AND.;
	    nMesIni == 13 .AND. nMesFin > 0

	    IF cCodFac == cCodSer
	       nCodigoTcm := 4                     // Matricula
	    ELSE
	       SELECT CMV
	       CMV->(DBGOTOP())
	       LOCATE FOR ALLTRIM(CMV->cCodRefTra) == ALLTRIM(cCodFac)

	       IF FOUND()

		  IF CMV->nCodCmvCmv > 0
		     nCodigoTcm := CMV->nCodCmvCmv
		  ELSE
		     nCodigoTcm := CMV->nCodigoCmv
		 ENDIF
	       ENDIF
	    ENDIF

       OTHERWISE
	       SELECT CMV
	       CMV->(DBGOTOP())
	       LOCATE FOR ALLTRIM(SUBS(CMV->cCodRefTra,1,;
			  BAN->nLenRefBan)) == ALLTRIM(cCodRef)

	       IF FOUND()

		  IF CMV->nCodCmvCmv > 0
		     nCodigoTcm := CMV->nCodCmvCmv
		  ELSE
		     nCodigoTcm := CMV->nCodigoCmv
		 ENDIF
	       ENDIF

       ENDCASE
*>>>>FIN ANALISIS DE LA REFERENCIA

*>>>>ANALISIS DEL MOTIVO
       IF nCodigoTcm == 0 .AND. !EMPTY(cCodMtv)

	  SELECT CMV
	  CMV->(DBGOTOP())
	  LOCATE FOR ALLTRIM(CMV->cMotivoTra) == ALLTRIM(cCodMtv)

	  IF FOUND()

	     IF CMV->nCodCmvCmv > 0
		nCodigoTcm := CMV->nCodCmvCmv
	     ELSE
		nCodigoTcm := CMV->nCodigoCmv
	     ENDIF

	  ENDIF

       ENDIF
       RETURN nCodigoTcm
*>>>>FIN ANALISIS DEL MOTIVO

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

FUNCTION cConcepCmv(nCodigo,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     nCodigo                              // C¢digo a Buscar
       cNalias                              // Alias para el Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cConcep := ''                  // Concepto del Movimiento.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CONCEPTO DEL MOVIMIENTO
       IF lLocCodigo('nCodigoCmv','CMV',nCodigo)
	  cConcep := CMV->cNombreCmv
       ELSE
	  cConcep := 'OTROS'
       ENDIF
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cConcep
*>>>>FIN LOCALIZACION DEL CONCEPTO DEL MOVIMIENTO


/*************************************************************************
* TITULO..: ORDENAR POR FECHA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 12/99 VIE A
       Colombia, Bucaramanga        INICIO: 10:45 AM   FEB 12/99 VIE

OBJETIVOS:

1- Ordena el archivo por fecha

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaCmv(lShared,nModCry,cAnoUsr,cPatSis,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del Sistema
       oBrowse			            // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF CMV->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
       CloseDbf('CMV',cPatSis+'\'+FileCmv,nModCry)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,cPatSis+'\'+FileCmv,'nCodigoCmv',,nModCry)
	  cError('NO SE ORDENO EL MAESTRO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DEL EXTRACTO')
	  RETURN NIL
       ENDIF
       SELECT CMV
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO