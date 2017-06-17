/* SIMA - SIMA - SISTEMA DE VOTACION DEL GOBIERNO ESCOLAR
			CONFIGURACION DEL SISTEMA

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaSimVot(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       AADD(aDbfStr,{'cAnoSysVot','Character'  ,004,0}) // A¤o del Sistema
       AADD(aDbfStr,{'cAnoUsrVot','Character'  ,004,0}) // A¤o del Usuario

       AADD(aDbfStr,{'cSysHabVot','Character',02,0}) // SPACES(02) => Ingreso Habilitado. Diferente a Espacios => Ingreso NO habilitado.
       AADD(aDbfStr,{'dFecHabVot','Date'     ,08,0}) // Fecha de Cierre del Sistema
       AADD(aDbfStr,{'cHorHabVot','Character',08,0}) // Hora de Cierre del Sistema

       AADD(aDbfStr,{'lPrnArcVot','Logical'  ,001,0}) // .T. Imprimir en la impresora
       AADD(aDbfStr,{'nCodigoPrn','Numeric'  ,004,0}) // C¢digo de la Impresora
       AADD(aDbfStr,{'cOpcPrnVot','Character',004,0}) // Opciones de Impresi¢n
       AADD(aDbfStr,{'nCodigoClr','Numeric'  ,002,0}) // C¢digo del Color

       AADD(aDbfStr,{'cLogEmpVot','Character',012,0}) // Logo de la Empresa
       AADD(aDbfStr,{'cUsrIsoVot','Character',010,0}) // Usuario del Iso
       AADD(aDbfStr,{'nCodXslVot','Numeric'  ,002,0}) // C¢digo Xsl informes
       AADD(aDbfStr,{'cPiePagVot','Character'  ,255,0}) // Pie de p gina informes

       AADD(aDbfStr,{'nPruebaVot','Numeric'  ,002,0}) // Habilitar pruebas

       AADD(aDbfStr,{'nIdeCodVot','Numeric'  ,016,0}) // C¢digo del Registro
       AADD(aDbfStr,{'cNomUsrVot','Character',010,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrVot','Date'     ,008,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrVot','Character',010,0}) // Hora del Usuario
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
       CASE nCd(PathArc) == 0
            DBCREATE(fArchvo,aDbfStr,'DBFNTX')

       CASE nCd(PathArc) == -3
	    WAIT 'NO EXISTE EL DIRECTORIO: '+PathArc

       CASE nCd(PathArc) == -5
	    WAIT 'NO TIENE DERECHOS EN: '+PathArc
       ENDCASE
       nCd(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'ARC',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA')
	  Closeall()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF ARC->(lRegLock(lShared,.T.))
	  REPL ARC->lPrnArcVot WITH .F.
	  REPL ARC->nCodigoClr WITH 1

	  REPL ARC->nIdeCodVot WITH ARC->(RECNO())
	  REPL ARC->cNomUsrVot WITH 'system'
	  REPL ARC->dFecUsrVot WITH DATE()
	  REPL ARC->cHorUsrVot WITH TIME()

	  ARC->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
       ENDIF
       IF lShared
	  ARC->(DBUNLOCK())
       ENDIF
       CloseDbf('ARC')
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSimVot(lShared,nModCry,PathArc,fArchvo)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       WAIT "SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo

       Termometro(0,"CREANDO LA ESTRUCTURA DE CONFIGURACION DEL SISTEMA")
       Termometro(100)

       CreaSimVot(lShared,nModCry,PathArc,fArchvo)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

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

FUNCTION nActSimVot(lShared,nModCry,PathArc,cNomArc)

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
	  WAIT 'ABRIENDO EL ARCHIVO'
	  CloseDbf('ACT')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ACT->(DBSTRUCT())
       CloseDbf('ACT')
       CreaSimVot(lShared,nModCry,PathArc,cNomArc,@aStrNew)
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
	  WAIT 'El Archivo CONFIG DEL SISTEMA su Estructura Esta DesActualizada.'
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
			 {||CreaSimVot(lShared,nModCry,PathArc,FileTem)})
	     WAIT 'NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO'
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManSimVot(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"        // Archivos del Sistema

       LOCAL oBrowse := NIL                 // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

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

       CloseAll()
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimVot,'ARC',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwSimVot(lShared,cAnoUsr,nFilPal+1,00,22,79)
       ARC->(CtrlBrw(lShared,oBrowse))
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF ARC->lPrnArcVot
	  SET PRINTER TO SIMATEMP              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwSimVot(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

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
       oBrowse:Cargo     := {'<< CONFIGURACION DEL SISTEMA >>',;
			    '<ENTER>Modificar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ARC
       oColumn	     := TBCOLUMNNEW('A¥O DEL;SISTEMA', {||ARC->cAnoSysVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cAnoSysVot'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O DEL;USUARIO',{||ARC->cAnoUsrVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cAnoUsrVot'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('INGRESO ACTIVADO;AL SISTEMA',{||ARC->cSysHabVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cSysHabVot'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('FECHA CIERRE;DEL SISTEMA',{||ARC->dFecHabVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','dFecHabVot'},{'PICTURE','@D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	:= TBCOLUMNNEW('HORA CIERRE;DEL SISTEMA',{||ARC->cHorHabVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cHorHabVot'},{'PICTURE','XXXXXXXX'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR;EN ARCHIVO', {||ARC->lPrnArcVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','lPrnArcVot'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;IMPRESORA', {||ARC->nCodigoPrn})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OPCIONES;IMPRESORA', {||ARC->cOpcPrnVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cOpcPrnVot'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONFIGURACION;DEL COLOR', {||ARC->nCodigoClr})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','nCodigoClr'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('LOGO;EMPRESA', {||ARC->cLogEmpVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cLogEmpVot'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('USUARIO ISO', {||ARC->cUsrIsoVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cUsrIsoVot'},{'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INFORMES;INTRANET', {||ARC->nCodXslVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','nCodXslVot'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PIE DE PAGINA;POR DEFECTO', {||ARC->cPiePagVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','cPiePagVot'},{'PICTURE','@S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('HABILITAR;PRUEBAS', {||ARC->nPruebaVot})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ARC'},;
			 {'FIELD','nPruebaVot'},{'PICTURE','99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||ARC->cNomUsrVot})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(ARC->dFecUsrVot)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(ARC->cHorUsrVot)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',{||ARC->nIdeCodVot})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('No.',{||ARC->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 16/2009 DIA A
       Colombia, Bucaramanga        INICIO:  08:36 AM  feb 16/2009 DIA

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysVot(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"        // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimVot,'ARC',NIL,lShared,nModCry})
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
       CASE ARC->(RECCOUNT()) == 0
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
       xClrSys := xColorSys(ARC->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR
