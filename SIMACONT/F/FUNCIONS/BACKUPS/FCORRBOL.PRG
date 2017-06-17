/*                  SISTEMA CONTABILIDAD ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CORRECION DE BOLETINES

REQUERIMIENTOS:

- Compilar: clipper fCorrBol /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   ABR 19/2002 VIE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION CreaCorBol(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

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

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoEst","Character",006,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{"cCodigoCar","Character",008,0}) // C¢digo de la Carga
       AADD(aDbfStr,{"cCodigoPro","Character",006,0}) // C¢digo del Profesor
       AADD(aDbfStr,{"cNroPerCBo","Character",001,0}) // N£mero del Peri¢do
       AADD(aDbfStr,{"cCodCorCBo","Character",001,0}) // C¢digo de la Correci¢n 1=>Aplicaci¢n 2=>Indicadores 3=>Repetir Boletin
       AADD(aDbfStr,{"cTipCorCBo","Character",001,0}) // Tipo de Correci¢n
     *ÀLlave Principal

       AADD(aDbfStr,{"cCodigoJui","Character",008,0}) // C¢digo del Indicador
       AADD(aDbfStr,{"cNomAntJui","Character",106,0}) // Nombre del Indicador Anterio
       AADD(aDbfStr,{"cExtAntJui","Character",106,0}) // Continuaci¢n del Indicador Anterior
       AADD(aDbfStr,{"cNomActJui","Character",106,0}) // Nombre del Indicador Actual
       AADD(aDbfStr,{"cExtActJui","Character",106,0}) // Continuaci¢n del Indicador Actual
     *ÀIndicadores Corregidos

       AADD(aDbfStr,{"cIndAntNoP","Character",101,0}) // C¢digos de Indicadores Anteriores
       AADD(aDbfStr,{"cIndActNoP","Character",101,0}) // C¢digos de Indicadores Anteriores
     *ÀC¢digos de Indicadores aplicados Corregidos

       AADD(aDbfStr,{"cDefAntNoP","Character", 04,0}) // Juicio Valorativo Anterior
       AADD(aDbfStr,{"cDefActNoP","Character", 04,0}) // Juicio Valorativo Anterior
     *ÀJuicio valorativos Corregidos.
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
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:05 PM   ABR 19/2002 VIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuCorBol(lShared,nModCry,PathArc,fArchvo,fNtxArc)

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
       CreaCorBol(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:10 PM   ABR 19/2002 VIE

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

FUNCTION nActCorBol(lShared,nModCry,PathArc,cNomArc)

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
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'CBO',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('CBO')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CBO->(DBSTRUCT())
       CloseDbf('CBO')
       CreaCorBol(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
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
	  cError('El Archivo CORRECIONES su Estructura Esta DesActualizada.',;
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
			 {||CreaCorBol(lShared,nModCry,PathArc,FileTem)})
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:15 PM   ABR 19/2002 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCBo(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL oBrowse := NIL                 // Browse de Archivo

       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nTipCor := 0                   // Tipo de Correci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
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

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseXYZ(lShared,cPatSis,cMaeAlu,cAnoSis)               .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\'+fCorBol,'CBO',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE EMPTY(TCO->nPerActTbl)
	    cError('DEBE HABILITAR EL PERIODO ACTUAL')

       CASE TCO->nPerActTbl > TCO->nTotPerTbl
	    cError('EL PERIODO ACTUAL NO DEBE SER MAYOR AL TOTAL DE PERIODOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)

       IF nNroPer == 0 .OR. nNroPer # TCO->nPerActTbl
	  IF nNroPer # TCO->nPerActTbl
	     cError('DEBE DIGITAR EL PERIODO ACTUAL HABILITADO')
	  ENDIF
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<APLICACION>')
       AADD(aMenus,'2<REDACCION >')
       AADD(aMenus,'3<REPETIR   >')

       AADD(aAyuda,'Permite Corregir los Indicadores Aplicados')
       AADD(aAyuda,'Permite Corregir la Redacci¢n de los Indicadores')
       AADD(aAyuda,'Permite Repetir Boletines')

       cSavPan := SAVESCREEN(0,0,24,79)
       nTipCor := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,'CORRECIONES',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nTipCor == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>FILTRACION DE LA CARGA DEL NIVEL
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro
       GO TOP
       IF PRO->(EOF())
	  cError('NO EXISTE PROFESORES DICTANDO EN '+cMaeAct)
	  SET FILTER TO
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LA CARGA DEL NIVEL

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oDefBrwCBo(lShared,cAnoUsr,cPatSis,;
			     nFilPal+1,00,22,79,;
			     cMaeAlu,nNroPer,nTipCor)
/*
       SETKEY(K_F5,{||BuscarCBo(oBrowse)})
       SETKEY(K_F9,{||MenuOtrCBo(aParam1,aParam2,aParam3,;
				    oBrowse)})
*/
       CBO->(CtrlBrw(lShared,oBrowse))

*      SETKEY(K_F5,NIL)
*      SETKEY(K_F9,NIL)

       SELECT PRO
       SET FILTER TO
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:15 PM   ABR 19/2002 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

 oBrowse := oDefBrwCBo(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCBo(lShared,cAnoUsr,cPatSis,nFilSup,nColSup,nFilInf,nColInf,;
		    cMaeAlu,nNroPer,nTipCor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros Habilitados
       nNroPer                              // N£mero del Periodo
       nTipCor                              // Tipo de Correcion */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<CORRECIONES PARA '+cAnoUsr+' >>',;
			    '<F5>Buscar <F9>Otros <INS>Incluir <DEL>Borrar',;
			    {||IncluirCBo(lShared,cAnoUsr,cPatSis,;
					  cMaeAlu,nNroPer,nTipCor,nFilSup-1)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CBO
       IF nTipCor == 1 .OR. nTipCor == 3
	  oColumn := TBCOLUMNNEW('CODIGO;ESTUDIANTE',{||CBO->cCodigoEst})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CBO'},;
			    {'FIELD','cCodigoEst'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF nTipCor == 1 .OR. nTipCor == 2
	  oColumn := TBCOLUMNNEW('MATERIA', {||CBO->cCodigoCar})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF nTipCor == 1 .OR. nTipCor == 2
	  oColumn := TBCOLUMNNEW('CODIGO;PROFESOR', {||CBO->cCodigoPro})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn := TBCOLUMNNEW('PERIODO', {||CBO->cNroPerCBo})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CORRECION', {||CBO->cCodCorCBo})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF nTipCor == 2
	  oColumn := TBCOLUMNNEW('CODIGO;INDICADOR', {||CBO->cCodigoJui})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF nTipCor == 1
	  oColumn := TBCOLUMNNEW('INDICADORES;ANTERIORES', {||CBO->cIndAntNoP})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('INDICADORES;ACTUALES', {||CBO->cIndActNoP})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('JUICIO;ANTERIOR',{||CBO->cDefAntNoP})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn := TBCOLUMNNEW('JUICIO;ACTUAL',{||CBO->cDefActNoP})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

       ENDIF
       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   ABR 19/2002 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de Configuraci¢n del A¤o

2- Incluye un registro al archivo

SINTAXIS:

  IncluirCBo()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirCBo(lShared,cAnoUsr,cPatSis,cMaeAlu,nNroPer,nTipCor,nFilInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros Habilitados
       nNroPer                              // N£mero de Periodos
       nTipCor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTca := ''               // C¢digo de la Carga
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
*>>>>FIN DECLARACION DE CONSTANTES

SET CURSOR ON


DO CASE
CASE nTipCor == 1
*     cRevCodInd(lShared,cMaeAlu,nNroPer,nFilInf)

CASE nTipCor == 2
CASE nTipCor == 3
     cPrnEst(lShared,cMaeAlu,nNroPer,nFilInf)
ENDCASE
RETURN NIL



*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       nNroFil := nMarco(nNroFil+3,'POR FAVOR ENTRE LOS DETALLES DE LA '+;
				   'CORRECION',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTpr := cSpaces('CBO','cCodigoPro')
	       cCodigoTca := cSpaces('CBO','cCodigoCar')
	       cCodigoTes := cSpaces('CBO','cCodigoEst')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL CODIGO DEL PROFESOR
	    @ nNroFil+00,nNroCol SAY 'PROFESOR    :';
				 GET cCodigoTpr PICT '999999';
				 VALID lValProfes(ROW()+2,COL()-20,@cCodigoTpr)
	    READ
**********FIN LECTURA DEL CODIGO DEL PROFESOR

**********FILTRACION DE LA CARGA DEL PROFESOR
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == cCodigoTpr
	    GO TOP
	    IF CAR->(EOF())
	       cError('AL PROFESOR '+cCodigoTpr+' '+;
		      'NO LE FIGURA ASIGNACION ACADEMICA')
	       SET FILTER TO
	       EXIT
	    ENDIF
**********FIN FILTRACION DE LA CARGA DEL PROFESOR

**********LECTURA DEL REGISTRO
	    @ nNroFil+01,nNroCol SAY 'MATERIA :';
				 GET cCodigoTca PICT '99999999';
				 VALID lValCarga(ROW()+1,COL()-20,;
				       @cCodigoTca,cCodigoTpr)


	    @ nNroFil+02,nNroCol SAY 'ESTUDIANTE  :';
				 GET cCodigoTes PICT '999999'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF !EMPTY(cCodigoTpr) .AND. !EMPTY(cCodigoTca)
	       !EMPTY(cCodigoTes)
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
       SELECT CBO
       IF lGrabar
	  IF CBO->(lRegLock(lShared,.T.))
	     REPL CBO->cCodigoPro WITH cCodigoTpr
	     REPL CBO->cCodigoCar WITH cCodigoTca
	     REPL CBO->cCodigoEst WITH cCodigoTes
	     CBO->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  CBO->(DBUNLOCK())
       ENDIF
       SELECT CAR
       SET FILTER TO
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO..: REPETIR BOLETINES                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:25 PM   ABR 19/2002 VIE

OBJETIVOS:

1- Permite activar la repetici¢n de boletines

SINTAXIS:

  IncluirCBo()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPrnEst(lShared,cMaeAlu,nNroPer,nFilInf)

*>>>>DECLARACION DE VARIABLES
/*     lShared                              // .T. Archivos Compartidos
       cMaeAlu                              // Maestros Habilitados
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡nea

       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       FIELD cBoletiEst                     // Repetir Boletines
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilInf+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS BOLETINES
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cMaeAct)

	    IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA REPETIR EL BOLETIN? Si No')
	       cError('NO SE ACTIVA LA REPETICION DEL BOLETIN')
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********GRABACION DEL REGISTRO
	   SELECT &cMaeAct
	   IF lRegLock(lShared,.F.)
	      REPL cBoletiEst WITH STUFF(cBoletiEst,nNroPer*2-1,1,'1')
	      DBCOMMIT()
	   ELSE
	      cError('NO SE GRABA EL REGISTRO')
	   ENDIF
	   IF lShared
	      DBUNLOCK()
	   ENDIF
**********FIN GRABACION DEL REGISTRO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilInf+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DE LOS BOLETINES

/*************************************************************************
* TITULO..: CORREGIR CODIGOS APLICADOS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   ABR 19/2002 VIE

OBJETIVOS:

1- Permite activar a los

2- Incluye un registro al archivo

SINTAXIS:

  IncluirCBo()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cRevCodInd(lShared,cMaeAlu,nNroPer,nFilInf)

*>>>>DECLARACION DE VARIABLES
/*     lShared                              // .T. Archivos Compartidos
       cMaeAlu                              // Maestros Habilitados
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡nea

       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       FIELD cBoletiEst                     // Repetir Boletines
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilInf+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS BOLETINES
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cMaeAct)

	    IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? Si No')
	       cError('NO SE ACTIVA LA CORRECION')
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********GRABACION DEL REGISTRO
	   SELECT &cMaeAct
	   IF lRegLock(lShared,.F.)
	      REPL cBoletiEst WITH STUFF(cBoletiEst,1,1,'1')
	      DBCOMMIT()
	   ELSE
	      cError('NO SE GRABA EL REGISTRO')
	   ENDIF
	   IF lShared
	      DBUNLOCK()
	   ENDIF
**********FIN GRABACION DEL REGISTRO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilInf+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DE LOS BOLETINES

