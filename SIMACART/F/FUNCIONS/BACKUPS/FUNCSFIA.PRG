/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE FIADORES

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 19/2004 VIE A
       Colombia, Bucaramanga        INICIO: 04:30 AM   MAR 19/2004 VIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfFia(lShared,nModCry,PathArc,cNomArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfFia := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfFia,{"cCodigoEst","Character",06,0})  // C¢digo del Estudiante
       AADD(aDbfFia,{"cNroFiaFia","Character",01,0})  // N£mero del Fiador
       AADD(aDbfFia,{"cDocNitFia","Character",11,0})  // N£mero de Identificaci¢n
       AADD(aDbfFia,{"cTipDocFia","Character",01,0})  // Tipo de Documento
       AADD(aDbfFia,{"cNombreFia","Character",45,0})  // Nombre del Fiador
       AADD(aDbfFia,{"dFecNacFia","Date"     ,08,0})  // Fecha de Nacimiento
       AADD(aDbfFia,{"cDireccFia","Character",30,0})  // Direcci¢n del Fiador
       AADD(aDbfFia,{"cCiuDirFia","Character",15,0})  // Ciudad de Residencia
       AADD(aDbfFia,{"cTelefnFia","Character",10,0})  // Telefono
       AADD(aDbfFia,{"cDirEnvFia","Character",30,0})  // Direcci¢n de Correspondencia
       AADD(aDbfFia,{"cCiuEnvFia","Character",15,0})  // Ciudad de Correspondencia
       AADD(aDbfFia,{"cTelTraFia","Character",10,0})  // Telefono del Trabajo
       AADD(aDbfFia,{"cCiuTraFia","Character",15,0})  // Ciudad del Trabajo
       AADD(aDbfFia,{"cEstratFia","Character",01,0})  // Estrato
       AADD(aDbfFia,{"cParentFia","Character",16,0})  // Parentesco
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfFia
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(cNomArc,aDbfFia,"DBFNTX")
	    Proteger(cNomArc,nModCry)

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 19/2004 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 AM   MAR 19/2004 VIE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfFia(lShared,nModCry,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       cNomArc			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+cNomArc,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE FIADORES")
       Termometro(100)

       CreaDbfFia(lShared,nModCry,PathArc,cNomArc)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 19/2004 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 AM   MAR 19/2004 VIE

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

FUNCTION nActStrFia(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'FIA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE FIADORES')
	  CloseDbf('FIA',PathArc+'\'+cNomArc,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := FIA->(DBSTRUCT())
       CloseDbf('FIA',PathArc+'\'+cNomArc,nModCry)
       CreaDbfFia(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
	  cError('El Archivo FIADORES su Estructura Esta DesActualizada.',;
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
			 {||CreaDbfFia(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 19/2004 VIE A
       Colombia, Bucaramanga        INICIO: 05:05 AM   MAR 19/2004 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

MantenFia()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenFia(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		   lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt)

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
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL oBrowse := NIL                  // Browse de Bancos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,;
		  @PathUno,@PathDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileFia,'FIA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

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

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oDefBrwFia(lShared,nFilPal+1,00,22,79,cMaeAlu)
       SETKEY(K_F5,{||BuscarFia(oBrowse)})

       SETKEY(K_F7,{||lDatosFia(lShared,.F.,03,01)})

       SETKEY(K_F9,{||MenuOtrFia(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
				 lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
				 oBrowse)})
       FIA->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F7,NIL)
       SETKEY(K_F9,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO.: DEFINICION DEL BROWSE                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 19/2004 VIE A
       Colombia, Bucaramanga        INICIO: 05:10 AM   MAR 19/2004 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwFia(lShared,nFilSup,nColSup,nFilInf,nColInf,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Bancos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE FIADORES>>',;
			    '<INS>Incluir <F5>Buscar <F7>Modificar '+;
			    '<DEL>Borrar <ESC>Abandonar',;
			     {||IncluirFia(lShared,cMaeAlu)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT FIA
       oColumn	     := TBCOLUMNNEW('CODIGO DE;ESTUDIANTE', {||FIA->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO;DEL FIADOR', {||FIA->cNroFiaFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DOCUMENTO;DE IDENTIDAD', {||FIA->cDocNitFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE;DOCUMENTO', {||FIA->cTipDocFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;COMPLETO', {||FIA->cNombreFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PARENTESCO', {||FIA->cParentFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIRECCION;DE LA CASA', {||FIA->cDireccFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CIUDAD DE;LA DIRECCION', {||FIA->cCiuDirFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO;DE LA CASA', {||FIA->cTelefnFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DIRECCION DE;LA CORRESPONDENCIA', {||FIA->cDireccFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CIUDAD DE;LA CORRESPONDENCIA', {||FIA->cCiuEnvFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TELEFONO;DEL TRABAJO', {||FIA->cTelTraFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTRATO', {||FIA->cEstratFia})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUSION DE REGISTROS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 19/2004 VIE A
       Colombia, Bucaramanga        INICIO: 05:30 AM   MAR 19/2004 VIE

OBJETIVOS:

1- Permite la inclusion de registros

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirFia(lShared,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNroFiaTfi := ''               // N£mero del Fiador
       LOCAL cDocNitTfi := ''               // N£mero de Identificaci¢n
       LOCAL cTipDocTfi := ''               // Tipo de Documento
       LOCAL cNombreTfi := ''               // Nombre del Fiador
       LOCAL dFecNacTfi := CTOD('00/00/00') // Fecha de Nacimiento
       LOCAL cDireccTfi := ''               // Direcci¢n del Fiador
       LOCAL cCiuDirTfi := ''               // Ciudad de Residencia
       LOCAL cTelefnTfi := ''               // Telefono
       LOCAL cDirEnvTfi := ''               // Direcci¢n de Correspondencia
       LOCAL cCiuEnvTfi := ''               // Ciudad de Correspondencia
       LOCAL cTelTraTfi := ''               // Telefono del Trabajo
       LOCAL cCiuTraTfi := ''               // Ciudad del Trabajo
       LOCAL cEstratTfi := ''               // Estrato
       LOCAL cParentTfi := ''               // Parentesco
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR INGRESE LOS '+;
				 'DETALLES DEL FIADOR',22,'°')

       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTes := cSpaces('FIA','cCodigoEst')
	       cDocNitTfi := cSpaces('FIA','cDocNitFia')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil,nNroCol SAY 'CODIGO DEL ESTUDIANTE:';
			      GET cCodigoTes PICT '@!';
			      VALID !lValCodFia(cCodigoTes,cMaeAlu,@cMaeAct)

	    @ nNroFil+1,nNroCol SAY 'DOCUMENTO DEL FIADOR :';
				GET cDocNitTfi PICT '@!';
				VALID !lValDocFia(cDocNitTfi,cCodigoTes)

	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF cCodigoTes # cSpaces('FIA','cCodigoEst') .AND.;
	       cDocNitTfi # cSpaces('FIA','cDocNitFia')
	       lGrabar := .T.
	    ELSE
	       lGrabar := .F.
	       cError('DEBE DAR LOS DATOS COMPLETOS. NO SE GRABA EL REGISTRO')
	    ENDIF
**********FIN VALIDACION DEL REGISTRO

**********INICIALIZACION DE VARIABLES
	    cDocNitTfi := ALLTRIM(cDocNitTfi)

	    cNroFiaTfi := FIA->cNroFiaFia
	    cTipDocTfi := FIA->cTipDocFia
	    cNombreTfi := FIA->cNombreFia
	    dFecNacTfi := FIA->dFecNacFia
	    cDireccTfi := FIA->cDireccFia
	    cCiuDirTfi := FIA->cCiuDirFia
	    cTelefnTfi := FIA->cTelefnFia
	    cDirEnvTfi := FIA->cDirEnvFia
	    cCiuEnvTfi := FIA->cCiuEnvFia
	    cTelTraTfi := FIA->cTelTraFia
	    cCiuTraTfi := FIA->cCiuTraFia
	    cEstratTfi := FIA->cEstratFia
	    cParentTfi := FIA->cParentFia
**********FIN INICIALIZACION DE VARIABLES

**********ANALISIS DEL DOCUMENTO
	    IF lGrabar
	       DO CASE
	       CASE cDocNitTfi == ALLTRIM(&cMaeAct->cPadNitEst) // Padre

		    cNombreTfi := SUBS(ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
				       ALLTRIM(&cMaeAct->cApePadEst)+;
				       SPACE(45),1,45)
		    dFecNacTfi := &cMaeAct->dNacPadEst
		    cDireccTfi := SUBS(&cMaeAct->cDireccEst+SPACE(30),1,30)
		    cCiuDirTfi := SUBS(&cMaeAct->cCiudadEst+SPACE(15),1,15)
		    cTelefnTfi := SUBS(&cMaeAct->cTelefnEst+SPACE(10),1,10)
		    cTelTraTfi := SUBS(&cMaeAct->cTelPadEst+SPACE(10),1,10)
		    cCiuTraTfi := SUBS(&cMaeAct->cCiuPadEst+SPACE(15),1,15)
		    cParentTfi := SUBS('PADRE'+SPACE(16),1,16)

	       CASE cDocNitTfi == ALLTRIM(&cMaeAct->cMadNitEst) // Madre

		    cNombreTfi := SUBS(ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
				       ALLTRIM(&cMaeAct->cApeMadEst)+;
				       SPACE(45),1,45)
		    dFecNacTfi := &cMaeAct->dNacMadEst
		    cDireccTfi := SUBS(&cMaeAct->cDireccEst+SPACE(30),1,30)
		    cCiuDirTfi := SUBS(&cMaeAct->cCiudadEst+SPACE(15),1,15)
		    cTelefnTfi := SUBS(&cMaeAct->cTelefnEst+SPACE(10),1,10)
		    cTelTraTfi := SUBS(&cMaeAct->cTelMadEst+SPACE(10),1,10)
		    cCiuTraTfi := SUBS(&cMaeAct->cCiuPadEst+SPACE(15),1,15)
		    cParentTfi := SUBS('MADRE'+SPACE(16),1,16)

	       CASE cDocNitTfi == ALLTRIM(&cMaeAct->cAcuNitEst) // Acudiente

		    cNombreTfi := SUBS(ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
				       ALLTRIM(&cMaeAct->cApeAcuEst)+;
				       SPACE(45),1,45)
		    dFecNacTfi := &cMaeAct->dNacAcuEst
		    cDireccTfi := SUBS(&cMaeAct->cDirAcuEst+SPACE(30),1,30)
		    cCiuDirTfi := SUBS(&cMaeAct->cCiuAcuEst+SPACE(15),1,15)
		    cTelefnTfi := SUBS(&cMaeAct->cTe1AcuEst+SPACE(10),1,10)
		    cTelTraTfi := SUBS(&cMaeAct->cTe2AcuEst+SPACE(10),1,10)
		    cCiuTraTfi := SUBS(&cMaeAct->cCiuAcuEst+SPACE(15),1,15)
		    cParentTfi := SUBS(&cMaeAct->cParAcuEst+SPACE(16),1,16)

	       ENDCASE
	    ENDIF
**********FIN ANALISIS DEL DOCUMENTO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lDatosFia(lShared,.T.,03,01,;
			    cCodigoTes,cNroFiaTfi,cDocNitTfi,cTipDocTfi,;
			    cNombreTfi,dFecNacTfi,cDireccTfi,cCiuDirTfi,;
			    cTelefnTfi,cDirEnvTfi,cCiuEnvTfi,cTelTraTfi,;
			    cCiuTraTfi,cEstratTfi,cParentTfi)
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
**********PREGUNTA DE DECISION

       ENDDO
       RETURN NIL
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:00 PM   MAR 23/2004 MAR

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarFia(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse de Bancos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegFia := 0                   // Registro del Banco
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo de b£squeda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigo := cSpaces('FIA','cCodigoEst')
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValFiado(ROW(),COL()-3,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigo == cSpaces('FIA','cCodigoFia')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT FIA
       IF lBuscar .AND. lLocCodigo('cCodigoFia','FIA',cCodigo)
	  nRegFia := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegFia
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:05 PM   MAR 23/2004 MAR

OBJETIVOS:

1- Debe estar en uso el archivo Bancos

2- Realiza la validaci¢n del c¢digo del Banco de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValFiado(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('cCodigoFia','FIA',cCodigo)
	  nNroReg := nSelFiado(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := cSpaces('FIA','cCodigoFia')
	  ELSE
	     GO nNroReg
	     cCodigo := FIA->cCodigoFia
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:10 PM   MAR 23/2004 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelFiado(nNroFil,nNroCol)

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
       IF FIA->(RECCOUNT()) == 0
	  cError('NO EXISTEN FIADORES GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT FIA
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO
       FIA->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||FIA->cNombreFia})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2004 MAR A
       Colombia, Bucaramanga        INICIO: 05:15 PM   MAR 23/2004 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodFia(cCodigo,cMaeAlu,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo a Validar
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // @Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # cSpaces('FIA','cCodigoEst')

	  IF lSekCodMae(cCodigo,cMaeAlu,@cMaeAct)

	     cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			   RTRIM(&cMaeAct->cNombreEst)

	     cError(cNombreTes+' GRUPO:'+&cMaeAct->cCodigoGru)
	  ELSE
	     lHayErr := .T.
	  ENDIF

       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL DOCUMENTO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2004 MAR A
       Colombia, Bucaramanga        INICIO: 07:15 PM   MAR 23/2004 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValDocFia(cCodigo,cCodEst)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo a Validar
       cCodEst                              // C¢digo del Documento */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # cSpaces('FIA','cDocNitFia')

	  LOCATE FOR FIA->cDocNitFia == cCodigo .AND.;
		     FIA->cCodigoEst == cCodEst

	  IF FIA->(FOUND())
	     cError(ALLTRIM(FIA->cNombreFia)+' YA EXISTE COMO FIADOR')
	     lHayErr := .T.
	  ENDIF

       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2001 MAR A
       Bucaramanga, Colombia	    INICIO: 03:00 PM   OCT 16/2001 MAR

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrFia(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		    cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		    lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {'1<IMPRESION DE FIADORES>'}

       aAyuda := {'Imprime los Estudiantes que tienen asignado una Ruta'}

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
	    OtrFia011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		      cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		      cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		      lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		      oBrowse)
	   *Impresi¢n de los Fiadores

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

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

FUNCTION OtrFia011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		   lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   oBrowse)

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
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

cError('PENDIENTE')

RETURN NIL


/*************************************************************************
* TITULO..: GRABACION DE LOS DATOS DEL FIADOR                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2004 MAR A
       Colombia, Bucaramanga        INICIO: 08:30 PM   MAR 23/2004 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de Estudiantes del respectivo Nivel

2- El archivo debe estar ubicado en el registro del estudiante y debe estar
   bloqueado

3- Graba los datos Generales del Estudiante

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDatosFia(lShared,lInsReg,nFilInf,nColInf,cCodEst,cNroFia,cDocNit,;
		   cTipDoc,cNombre,dFecNac,cDirecc,cCiuDir,cTelefn,cDirEnv,;
		   cCiuEnv,cTelTra,cCiuTra,cEstrat,cParent)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       lInsReg                              // .T. Insertar Registro
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cCodEst                              // C¢digo del Estudiante
       cNroFia                              // N£mero del Fiador
       cDocNit                              // N£mero de Identificaci¢n
       cTipDoc                              // Tipo de Documento
       cNombre                              // Nombre del Fiador
       dFecNac                              // Fecha de Nacimiento
       cDirecc                              // Direcci¢n del Fiador
       cCiuDir                              // Ciudad de Residencia
       cTelefn                              // Telefono
       cDirEnv                              // Direcci¢n de Correspondencia
       cCiuEnv                              // Ciudad de Correspondencia
       cTelTra                              // Telefono del Trabajo
       cCiuTra                              // Ciudad del Trabajo
       cEstrat                              // Estrato
       cParent                              // Parentesco */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura

       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE VALIDACION
       IF EMPTY(cDirEnv)
	  cDirEnv := cDirecc
       ENDIF

       IF EMPTY(cCiuEnv)
	  cCiuEnv := cCiuDir
       ENDIF
*>>>>FIN ANALISIS DE VALIDACION

*>>>>INICIALIZACION DEL REGISTRO
       IF EMPTY(cCodEst)
	  cCodEst := FIA->cCodigoEst
	  cDocNit := FIA->cDocNitFia

	  cTipDoc := FIA->cTipDocFia
	  cNroFia := FIA->cNroFiaFia
	  cNombre := FIA->cNombreFia
	  dFecNac := FIA->dFecNacFia
	  cDirecc := FIA->cDireccFia
	  cCiuDir := FIA->cCiuDirFia
	  cTelefn := FIA->cTelefnFia
	  cDirEnv := FIA->cDirEnvFia
	  cCiuEnv := FIA->cCiuEnvFia
	  cTelTra := FIA->cTelTraFia
	  cCiuTra := FIA->cCiuTraFia
	  cEstrat := FIA->cEstratFia
	  cParent := FIA->cParentFia
       ENDIF
*>>>>FIN INICIALIZACION DEL REGISTRO

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nTipCur := SETCURSOR(1)
       cSavPan := SAVESCREEN(0,0,24,79)

       nFilIni := nMarco(nFilInf,'POR FAVOR ACTUALICE LA INFORMACION '+;
				 'DEL FIADOR',22,'°')

       nNroCol := nColInf
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       DO WHILE .T.

**********ACTUALIZACION DE LA INFORMACION DEL FIADOR
	    nNroFil := nFilIni

	    @nNroFil,nNroCol+0 SAY 'NOMBRE COMPLETO:';
				  GET cNombre PICT "@!" ;
				  VALID !EMPTY(cNombre);
				  WHEN {||HelpRead('DIGITE EL '+;
						   'NOMBRE DEL FIADOR')}

	    @nNroFil,nNroCol+63 SAY 'ESTRATO:';
				GET cEstrat PICT "9";
				VALID !EMPTY(cEstrat);
	      WHEN {||HelpRead('INGRESE EL NUMERO DEL ESTRATO DEL FIADOR')}

	    nNroFil += 2
	    @ nNroFil,nNroCol+00 SAY 'DOCUMENTO: '+cDocNit

	    @nNroFil,nNroCol+20 SAY 'TIPO:';
				GET cTipDoc PICT "@!";
				VALID lValTipDoc(ROW(),COL()-1,;
						   @cTipDoc);
				WHEN {||HelpRead('DIGITE EL TIPO DE DOCUMENTO')}


	    @nNroFil,nNroCol+28 SAY 'F. NACI:';
				  GET dFecNac PICT "@!" ;
				  VALID !EMPTY(dFecNac) .AND. HelpRead();
				  WHEN {||HelpRead('FECHA')}

	    @nNroFil++,nNroCol+48 SAY 'PARENTESCO:';
				  GET cParent PICT "@!" ;
				  VALID !EMPTY(cParent)

	    @++nNroFil,nNroCol+00 SAY 'NUMERO DE FIADOR:';
				  GET cNroFia PICT "9";
				  VALID lValNroFia(ROW(),COL()-1,;
						   @cNroFia,cCodEst)

	    nNroFil++
	    @++nNroFil,nNroCol+00 SAY 'DIRECCION CASA:';
				  GET cDirecc PICT "@!";
				  VALID !EMPTY(cDirecc) .AND.;
				  LEN(ALLTRIM(cDirecc)) > 6

	    @nNroFil++,nNroCol+47 SAY 'CIUDAD:';
				  GET cCiuDir PICT "@!";
				  VALID !EMPTY(cCiuDir)

	    @nNroFil,nNroCol SAY 'TELEFONO CASA:';
				  GET cTelefn PICT "@S7";
				  VALID !EMPTY(cTelefn)

	    @nNroFil,nNroCol+24 SAY 'TEL TRABAJO:';
				GET cTelTra PICT "@S7";
				VALID !EMPTY(cTelTra)

	    @nNroFil++,nNroCol+46 SAY 'CIUDAD TRABAJO:';
				  GET cCiuTra PICT "@!";
				  VALID !EMPTY(cCiuTra) .AND.;
				  LEN(ALLTRIM(cCiuTra)) > 4

	    @++nNroFil,nNroCol+00 SAY 'DIRECCION CORRESPONDENCIA:';
				  GET cDirEnv PICT "@!";
				  VALID !EMPTY(cDirEnv) .AND.;
				  LEN(ALLTRIM(cDirEnv)) > 6

	    @++nNroFil,nNroCol+00 SAY 'CIUDAD CORRESPONDECIA:';
				  GET cCiuEnv PICT "@!";
				  VALID !EMPTY(cCiuEnv) .AND.;
				  LEN(ALLTRIM(cCiuEnv)) > 4
	    READ
**********FIN ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
	    ENDCASE
**********FIN PREGUNTA DE DECISION

**********GRABACION O ACTUALIZACION DEL REGISTRO
	    SELECT FIA
	    IF lGrabar
	       IF lRegLock(lShared,lInsReg)

		  IF lInsReg
		     REPL FIA->cCodigoEst WITH cCodEst
		     REPL FIA->cDocNitFia WITH cDocNit
		  ENDIF

		  REPL FIA->cTipDocFia WITH cTipDoc
		  REPL FIA->cNroFiaFia WITH cNroFia
		  REPL FIA->cNombreFia WITH cNombre
		  REPL FIA->dFecNacFia WITH dFecNac
		  REPL FIA->cDireccFia WITH cDirecc
		  REPL FIA->cCiuDirFia WITH cCiuDir
		  REPL FIA->cTelefnFia WITH cTelefn
		  REPL FIA->cDirEnvFia WITH cDirEnv
		  REPL FIA->cCiuEnvFia WITH cCiuEnv
		  REPL FIA->cTelTraFia WITH cTelTra
		  REPL FIA->cCiuTraFia WITH cCiuTra
		  REPL FIA->cEstratFia WITH cEstrat
		  REPL FIA->cParentFia WITH cParent
	       ELSE
		   cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       FIA->(DBCOMMIT())
	       IF lShared
		  FIA->(DBUNLOCK())
	       ENDIF

	    ENDIF
	    EXIT
**********FIN GRABACION O ACTUALIZACION DEL REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
       SET ESCAPE OFF
       RETURN lGrabar
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA

/*************************************************************************
* TITULO..: VALIDACION NUMERO DE FAMILIA                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/2004 MAR A
       Colombia, Bucaramanga        INICIO: 02:40 PM   MAR 25/2004 MAR

OBJETIVOS:

1- Realiza la validaci¢n del tipo de Documento

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNroFia(nNroFil,nNroCol,cCodigo,cCodEst)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar
       cCodEst                              // C¢digo del Estudiante */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DEL MENU
       aMenus := {'1<PRIMER FIADOR >',;
		  '2<SEGUNDO FIADOR>',;
		  '3<TERCER FIADOR >'}

       aAyudas := {'Primer Fiador que Respalda la Deuda',;
		   'Segundo Fiador que Respalda la Deuda',;
		   'Tercer Fiador que Respalda la Deuda'}
*>>>>FIN DEFINICION DEL MENU

*>>>>VALIDACION DEL CODIGO
       cCodigo := ALLTRIM(cCodigo)
       IF cCodigo # '1' .AND. cCodigo # '2' .AND. cCodigo # '3'

	  DO WHILE .T.
	     SAVE SCREEN
	     nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	     RESTORE SCREEN

	     IF nNroOpc == 0
		LOOP
	     ENDIF
	     cCodigo := STR(nNroOpc,1)

	     SELECT FIA
	     LOCATE FOR FIA->cCodigoEst == cCodEst .AND.;
			FIA->cNroFiaFia == cCodigo
	     IF FOUND()
		cError('NUMERO DE FIADOR YA ASIGNADO')
	     ELSE
		EXIT
	     ENDIF
	  ENDDO


       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: CEDULAS DE LOS FIADORES                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2004 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   MAY 19/2004 MIE

OBJETIVOS:

1- Almacena todas las cedulas de los fiadores para un estudiante
   determinado.

2- Retorna un vector con las cedulas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aCedulafia(cCodEst)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del Estudiante */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aCedFia := {}                  // C‚dulas de Fiadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       SELECT FIA
       SET FILTER TO FIA->cCodigoEst == cCodEst
       FIA->(DBGOTOP())
       IF FIA->(EOF())
	  SET FILTER TO
	  RETURN aCedFia
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>RECORRIDO DEL ARCHIVO
       SELECT FIA
       FIA->(DBGOTOP())
       DO WHILE .NOT. FIA->(EOF())
	  AADD(aCedFia,FIA->cDocNitFia)
	  FIA->(DBSKIP())
       ENDDO
       SET FILTER TO
       RETURN aCedFia
*>>>>FIN RECORRIDO DEL ARCHIVO