/*               	   SIMA - SISTEMA DE CAFETERIA
	   BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE TIPO DE PERSONAL

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 02:30 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfTip(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL       i := 0                   // Contador
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoTip","Character",01,0}) // C¢digo del Tipo de Personal
       AADD(aDbfStr,{"cNombreTip","Character",30,0}) // Nombre del Tipo de Personal
       AADD(aDbfStr,{"lBoletaTip","Logical",01,0})   // .T. Boleta de Ingreso
       AADD(aDbfStr,{"nVlrBolTip","Numeric",10,2})   // .T. Boleta de Ingreso
       AADD(aDbfStr,{"nTotBolTip","Numeric",06,2})   // Total de Boletas
       AADD(aDbfStr,{"nTotVenTip","Numeric",06,2})   // Total de Boletas Vendidas
       AADD(aDbfStr,{"nTotCnsTip","Numeric",06,2})   // Total de Boletas Consumidas
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TIP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO TIPO DE PERSONAL')
	  CloseDbf('TIP',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DEL REGISTRO INICIAL
       FOR i := 0 TO 3

	   IF TIP->(lRegLock(lShared,.T.))
	      DO CASE
	      CASE i == 0
		   REPL TIP->cCodigoTip WITH '0'
		   REPL TIP->cNombreTip WITH 'NO CLASIFICADO'
		   TIP->(DBCOMMIT())

	      CASE i == 1
		   REPL TIP->cCodigoTip WITH '1'
		   REPL TIP->cNombreTip WITH 'ESTUDIANTES'
		   TIP->(DBCOMMIT())

	      CASE i == 2
		   REPL TIP->cCodigoTip WITH '2'
		   REPL TIP->cNombreTip WITH 'PROFESORES'
		   TIP->(DBCOMMIT())

	      CASE i == 3
		   REPL TIP->cCodigoTip WITH '3'
		   REPL TIP->cNombreTip WITH 'ADMINISTRATIVOS'
		   TIP->(DBCOMMIT())
	      ENDCASE

	      IF lShared
		 TIP->(DBUNLOCK())
	      ENDIF
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL')
	   ENDIF

       ENDFOR
       CloseDbf('TIP',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO INICIAL

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 02:45 AM   JUL 04/2002 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfTip(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo
       fNtxArc			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfTip(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 02:50 AM   JUL 04/2002 JUE

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

FUNCTION nActStrTip(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'TIP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('TIP')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := TIP->(DBSTRUCT())
       CloseDbf('TIP')
       CreaDbfTip(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo TIPO PERSONAL su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfTip(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 02:55 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTip(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL aCamLoc := {}                  // Campos a Localizar
       LOCAL cTitCam := ''                  // T¡tulo del Campo
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos
       LOCAL bCodIns := NIL                 // CodeBlock de Inserci¢n

       LOCAL GetList := {}                  // Variable del Sistema

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
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
       CASE TIP->(RECCOUNT()) == 0
	    cError('NO EXISTEN TIPOS DE PERSONAL CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT TIP
       IF !lFileLock()
	  oBrowse := oDefBrwTip(lShared,nFilPal+1,00,22,79,cAnoUsr)
	  TIP->(CtrlBrw(lShared,oBrowse))
       ENDIF
       DBUNLOCKALL()
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwTip(lShared,nFilSup,nColSup,nFilInf,nColInf,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cAnoUsr                              // A¤o del Usuario */
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

       oBrowse:Cargo := {'<< TIPOS DE PERSONAL'+' .'+;
			 'TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>',;
			 '<INS>Incluir <F5>Buscar  <DEL>Borrar  '+;
			 '<ESC>Abandonar',{||IncluirTip(lShared,cAnoUsr)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TIP
       oColumn	     := TBCOLUMNNEW('CODIGO', {||TIP->cCodigoTip})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','TIP'},{'FIELD','cCodigoTip'},;
			 {'PICTURE','9'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE', {||TIP->cNombreTip})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TIP'},{'FIELD','cNombreTip'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BOLETA;DE INGRESO', {||TIP->lBoletaTip})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TIP'},{'FIELD','lBoletaTip'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR', {||TIP->nVlrBolTip})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TIP'},{'FIELD','nVlrBolTip'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BOLETAS;EMITIDAS', {||TIP->nTotBolTip})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BOLETAS;VENDIDAS', {||TIP->nTotVenTip})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BOLETAS;CONSUMIDAS', {||TIP->nTotCnsTip})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Inserta un registro al archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirTip(lShared,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTtp := ''               // C¢digo del Tipo de Personal
       LOCAL cNombreTtp := ''               // Nombre del Tipo de Personal
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil+3,'POR FAVOR ENTRE LOS TIOS DE PERSONAL',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTtp := cSpaces('TIP','cCodigoTip')
	       cNombreTtp := cSpaces('TIP','cNombreTip')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+00,nNroCol SAY 'TIPO PERSONAL  :';
				 GET cCodigoTtp PICT '@!';
				 VALID !lValCodTip(cCodigoTtp)

	    @ nNroFil+01,nNroCol SAY 'NOMBRE DEL TIPO:';
				 GET cNombreTtp PICT '@!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF !EMPTY(cCodigoTtp) .AND. !EMPTY(cNombreTtp)
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
       SELECT TIP
       IF lGrabar
	  IF TIP->(lRegLock(lShared,.T.))
	     REPL TIP->cCodigoTip WITH cCodigoTtp
	     REPL TIP->cNombreTip WITH cNombreTtp
	     TIP->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  TIP->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodTip(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('cCodigoTip','TIP',cCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CONCEPTO                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 04:00 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Debe estar en uso el archivo Conceptos

2- Realiza la validaci¢n del c¢digo del concepto de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTipo(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // C¢digo para Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF !lLocCodigo('cCodigoTip','TIP',cCodigo)
	  nNroReg := nSelTipo(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := cSpaces('TIP','cCodigoTip')
	  ELSE
	     GO nNroReg
	     cCodigo := TIP->cCodigoTip
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO..: SELECCION DEL CONCEPTO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Colombia, Bucaramanga        INICIO: 04:05 AM   JUL 04/2002 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelTipo(nNroFil,nNroCol)

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
       LOCAL nNroReg := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF TIP->(RECCOUNT()) == 0
	  cError('NO EXISTEN TIPOS DE PERSONAL GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT TIP
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
       TIP->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||TIP->cNombreTip})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CONCEPTO

/*************************************************************************
* TITULO..: LOCALIZACION DEL NOMBRE DEL TIPO DE EMPLEADO                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 30/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   AGO 30/2002 VIE

OBJETIVOS:

1- Deben estar en uso el archivo

2- Permite encontrar el nombre

3- Si el nombre se incluye en un browse se debe pasar
   el Alias del Archivo del Browse

4- Retorna el nombre

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomTipPer(cCodigo,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				      // C¢digo de b£squeda
       cNalias				      // Alias del Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNombreTip := ''                 // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       IF lLocCodigo('cCodigoTip','TIP',cCodigo)
	  cNombreTip := TIP->cNombreTip
       ELSE
	  cNombreTip := 'PERSONAL NO CLASIFICADO'
       ENDIF
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cNombreTip
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO..: INTERVALO DE TIPOS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:20 PM   OCT 03/2002 MIE


OBJETIVOS:

1- Permite selecionar un intervalo de tipos.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervTip(nNroFil,nNroCol,nRegIni,nRegFin,lIniFin)

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
       cMsgTxt ='TIPO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'TIPO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT TIP
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+29

	TIP->(DBGOTOP())
	nIniReg := TIP->(RECNO())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||TIP->cNombreTip})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	TIP->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY TIP->cNombreTip
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       TIP->(DBGOBOTTOM())
       nFinReg := TIP->(RECNO())

       TIP->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||TIP->cNombreTip})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       TIP->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY TIP->cNombreTip
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