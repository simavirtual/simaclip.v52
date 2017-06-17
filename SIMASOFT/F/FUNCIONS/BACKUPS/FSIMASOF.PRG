/*                      SIMASOFT - SISTEMA ADMINISTRADOR
		 FUNCIONES ARCHIVO DE CONFIGURACION GENERAL

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:10 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaSimSof(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"PathMatr","Character",70,0})    // Path de la Matricula
       AADD(aDbfStr,{"PathCont","Character",70,0})    // Path de la Contabilidad
       AADD(aDbfStr,{"PathProf","Character",70,0})    // Path de la Contabilidad Profesores
       AADD(aDbfStr,{"PathCart","Character",70,0})    // Path de la Cartera
       AADD(aDbfStr,{"PathCafe","Character",70,0})    // Path de la Cafeteria
     *ÀPaths de los sistemas del Sima

       AADD(aDbfStr,{"cNomSupSof","Character",10,0})    // Supervisor del Sistema
       AADD(aDbfStr,{"cPwdSupSof","Character",10,0})    // Clave del Supervisor del Sistema
     *ÀSupervisor del Sistema

       AADD(aDbfStr,{"lPrnArcSof","Logical"  ,01,0})   // .T. Imprimir en la impresora
       AADD(aDbfStr,{"nCodigoClr","Numeric"  ,02,0})   // C¢digo del Color
       AADD(aDbfStr,{"nCodigoPrn","Numeric"  ,04,0})   // C¢digo de la Impresora
       AADD(aDbfStr,{"cColaAcSof","Character",02,0})   // Cola de Impresi¢n Activada
       AADD(aDbfStr,{"lModColSof","Logical"  ,01,0})   // .T. Modificar la Cola Activada
       AADD(aDbfStr,{"cCola01Sof","Character",20,0})   // Cola de Impresi¢n No. 1
       AADD(aDbfStr,{"cCola02Sof","Character",20,0})   // Cola de Impresi¢n No. 2
     *ÀConfiguracines Generales del Sistema
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
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
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'SOF',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA')
	  CloseDbf('SOF',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF SOF->(lRegLock(lShared,.T.))
	  REPL SOF->lPrnArcSof WITH .F.
	  REPL SOF->nCodigoClr WITH 1
	  REPL SOF->PathMatr   WITH '\SIMA\SIMAMATR'
	  REPL SOF->PathCont   WITH '\SIMA\SIMACONT'
	  REPL SOF->PathProf   WITH '\SIMA\SIMAPROF'
	  REPL SOF->PathCart   WITH '\SIMA\SIMACART'
	  REPL SOF->PathCafe   WITH '\SIMA\SIMACAFE'
	  REPL SOF->cNomSupSof WITH CRYPT('CONTROL   ',"IVANAN")
	  REPL SOF->cPwdSupSof WITH CRYPT('CONTROL   ',"IVANAN")
	  SOF->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
       ENDIF
       IF lShared
	  SOF->(DBUNLOCK())
       ENDIF
       CloseDbf('SOF',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSimSof(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo
       fNtxArc			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaSimSof(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:20 PM   SEP 04/2002 MIE

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

FUNCTION nActStrSof(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo */
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
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'SOF',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('SOF')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := SOF->(DBSTRUCT())
       CloseDbf('SOF')
       CreaSimSof(lShared,nModCry,PathArc,fArchvo,,@aStrNew)
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
	  cError('El Archivo SIMASOFT su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaSimSof(lShared,nModCry,PathArc,FileTem)})
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenSof(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimSof,'SOF',NIL,lSiRed,nModCry})
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
       CASE SOF->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINICION TITULOS DEL BROWSE
       SELECT SOF
       cTitSup := '<< CONFIGURACION DEL SISTEMA DE SIMASOFT >>'
     *ÀT¡tulo Superior

       cTitInf := '<ESC>Abandona'
      *ÀT¡tulo Inferior
*>>>>FIN DEFINICION TITULOS DEL BROWSE

*>>>>DEFINICION DE CAMPOS DEL BROWSE
       aCampos := {}
       AADD(aCampos,{{"PATH SIMAMATR","PathMatr"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','PathMatr'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMACONT","PathCont"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','PathCont'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMAPROF","PathProf"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','PathProf'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMACART","PathCart"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','PathCart'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMACAFE","PathCafe"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','PathCafe'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"SUPERVISOR;SISTEMA","cNomSupSof"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','cNomSupSof'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"CLAVE;SUPERVISOR","cPwdSupSof"},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','cPwdSupSof'},{'PICTURE','@!'}}})

       AADD(aCampos,{{'IMPRIMIR;EN ARCHIVO','lPrnArcSof'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','lPrnArcSof'},{'PICTURE','@!'}}})

       AADD(aCampos,{{'CONFIGURACION;DEL COLOR','nCodigoClr'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','nCodigoClr'},{'PICTURE','99'}}})

       AADD(aCampos,{{'CODIGO;IMPRESORA','nCodigoPrn'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}})

       AADD(aCampos,{{'COLA ACTIVA;DE IMPRESION','cColaAcSof'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','cColaAcSof'},{'PICTURE','99'}}})

       AADD(aCampos,{{'MODIFICAR COLAS;DE IMPRESION','lModColSof'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','lModColSof'},{'PICTURE','@!'}}})

       AADD(aCampos,{{'COLA;No. 01','cCola01Sof'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','cCola01Sof'},{'PICTURE','@!'}}})

       AADD(aCampos,{{'COLA;No. 02','cCola02Sof'},;
		     {{'MODI',.T.},{'ALIAS','SOF'},;
		      {'FIELD','cCola02Sof'},{'PICTURE','@!'}}})
*>>>>FIN DEFINICION DE CAMPOS DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       IF !lFileLock()
	  oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
	 *Creaci¢n del Browse

	  SOF->(CtrlBrw(lShared,oBrowse))
	 *Browse del Archivo
       ENDIF
       SOF->(DBUNLOCKALL())
*>>>>FIN BROWSE DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF SOF->lPrnArcSof
	  SET PRINTER TO SIMASOFT              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysSof(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimSof,'SOF',NIL,lShared,nModCry})
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
       CASE SOF->(RECCOUNT()) == 0
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
       xClrSys := xColorSys(SOF->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR

/*************************************************************************
* TITULO..: LECTURAS PATHS DE INTEGRACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:05 PM   SEP 04/2002 MIE

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathSoft(lShared,nModCry,PathMtr,PathCon,PathPro,PathCar,PathCaf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       PathMtr			            // @Path de la Matr¡cula
       PathCon			            // @Path de la Contabilidad
       PathPro			            // @Path de la Contabilidad Profesores
       PathCar			            // @Path de la Cartera
       PathCaf                              // @Path de la Cafeteria */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL cNalias := 'XYZ'
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimSof,cNalias,NIL,lSiRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT &cNalias
       DBGOTOP()
       PathMtr := ALLTRIM(&cNalias->PathMatr)
       PathCon := ALLTRIM(&cNalias->PathCont)
       PathPro := ALLTRIM(&cNalias->PathProf)
       PathCar := ALLTRIM(&cNalias->PathCart)
       PathCaf := ALLTRIM(&cNalias->PathCafe)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION

