/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: POR PROFESOR. ACTUALIZACION

**************************************************************************
* TITULO..: ACTUALIZACION                                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   NOV 10/2002 JUE

OBJETIVOS:

1- Permite actualizar las notas que aparecen en el profesor contra las que
   aparecen leidas en la contabilidad acad‚mica.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_319(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema


       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'TEM'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log

       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nSecArc := 0                   // Secuencial de Archivo
       LOCAL cSecArc := 0                   // Secuencial de Archivo

       LOCAL oBrowse := NIL                 // Objeto para el Browse
       LOCAL GetList := {}                  // Variable del sistema
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

*>>>>LECTURA DEL PERIODO
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL PERIODO

*>>>>LECTURA DEL SECUENCIAL DEL ARCHIVO
       @ nFilInf+1,nColInf SAY 'ARCHIVO No.';
			   GET nSecArc PICT '9999'
       READ
       IF nSecArc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cSecArc := STR(nSecArc,4)
       lCorrecion(@cSecArc)
*>>>>FIN LECTURA DEL SECUENCIAL DEL ARCHIVO

*>>>>VALIDACION DEL ARCHIVO
       cSecArc := STR(nSecArc,4)
       lCorrecion(@cSecArc)

       FileTem = cPatSis+'\'+PathOtr+'\'+;
		 'VAN'+STR(nNroPer,1,0)+cSecArc+ExtFile
       IF !FILE(FileTem)
	  cError('EL ARCHIVO DE ACTUALIZACION No.'+cSecArc+' NO EXISTE')
	  CloseAll()
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,FileTem,'ACT',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE ACTUALIZACION')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS')

       CASE ACT->(RECCOUNT()) == 0
	    cError('NO EXISTE REGISTROS PARA ACTUALIZAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT ACT
       oBrowse := oDefBrwAct(lShared,cAnoUsr,nFilPal+1,00,22,79)

       SETKEY(K_F2,{||IndValNot(oBrowse,cMaeAct)})
*      SETKEY(K_F5,{||BuscarAct(oBrowse)})
       SETKEY(K_F9,{||MenuOtrAct(aParam1,aParam2,aParam3,;
				 oBrowse)})


       ACT->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F2,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE          	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2002 DOM A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   NOV 10/2002 DOM


OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwAct(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       oBrowse:Cargo := {'<< REGISTROS DE ACTUALIZACION. TOTAL='+;
			 STR(ACT->(RECCOUNT()),4)+'>>',;
			'<F2>Indicadores <F5>Buscar <F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ACT
       oColumn	     := TBCOLUMNNEW('REGISTRO No.',{||ACT->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION',{||ACT->cObservLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIVEL',{||ACT->cMaeActLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PERIODO',{||ACT->nNroPerLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;ESTUDIANTE',{||ACT->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRUPO',{||ACT->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('No.',{||ACT->nNroRegEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;PROFESOR',{||ACT->cCodigoPro})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA EN;SIMACONT',{||ACT->cMatNotLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA EN;SIMAPROF',{||ACT->cMatNoPLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IND',{||ACT->cActIndLog})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ACT'},{'FIELD','cActIndLog'},;
			 {'PICTURE','X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JVA',{||ACT->cActDefLog})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ACT'},{'FIELD','cActDefLog'},;
			 {'PICTURE','X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JVR',{||ACT->cActRecLog})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ACT'},{'FIELD','cActRecLog'},;
			 {'PICTURE','X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ACTUALIZADO',{||ACT->lRegActLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INDICADORES EN;SIMACONT',;
				    {||ACT->cIndNotLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INDICADORES EN;SIMAPROF',;
				    {||ACT->cIndNoPLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JVA',{||ACT->cActDefLog})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ACT'},{'FIELD','cActDefLog'},;
			 {'PICTURE','X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JUICIOS VALORATIVOS EN;SIMACONT',;
				    {||ACT->cDefNotLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JUICIOS VALORATIVOS EN;SIMAPROF',;
				    {||ACT->cDefNoPLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('JVR',{||ACT->cActRecLog})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ACT'},{'FIELD','cActRecLog'},;
			 {'PICTURE','X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECUPERACIONES;EN SIMACONT',;
				    {||ACT->cRecNotLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECUPERACIONES; EN SIMAPROF',;
				    {||ACT->cRecNoPLog})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('cCodAreSel',{||ACT->cCodAreSel})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('cSecMatSel',{||ACT->cSecMatSel})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('cSecProSel',{||ACT->cSecProSel})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: CONSULTAR INDICADORES DE VALIDACION   	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2002 DOM A
       Bucaramanga, Colombia	    INICIO: 11:45 PM   NOV 10/2002 DOM


OBJETIVOS:

1- Consulta los Indicadores de Validaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IndValNot(oBrowse,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse                              // Browse del Archivo
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 1                   // N£mero de Columna

       LOCAL lHayEst := .F.                 // .T. Hay Estudiante
       LOCAL cMaeAct := ''                  // Maestro habilitado
       LOCAL cMatNot := ''                  // Materia en Contabilidad
       LOCAL cMatNoP := ''                  // Materia en Profesor
       LOCAL cNomPro := ''                  // Nombre del Profesor
       LOCAL cNomEst := ''                  // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DE LA MATERIA
       cMatNot := ACT->cMatNotLog+' MATERIA NO EXISTE'
       IF lLocCodigo('cCodigoMat','MAT',ACT->cMatNotLog)
	  cMatNot := ACT->cMatNotLog+':'+ALLTRIM(MAT->cNombreMat)
       ENDIF

       IF ACT->cMatNotLog # ACT->cMatNoPLog
	  cMatNoP = ACT->cMatNoPLog+' MATERIA NO EXISTE'
	  IF lLocCodigo('cCodigoMat','MAT',ACT->cMatNoPLog)
	     cMatNoP := ACT->cMatNoPLog+':'+ALLTRIM(MAT->cNombreMat)
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>LOCALIZACION DEL PROFESOR
       cNomPro := ACT->cCodigoPro+' PROFESOR NO EXISTE'
       IF lLocCodigo('cCodigoPro','PRO',ACT->cCodigoPro)
	  cNomPro := ACT->cCodigoPro+':'+;
		     ALLTRIM(PRO->cApelliPro)+' '+ALLTRIM(PRO->cNombrePro)
       ENDIF
*>>>>FIN LOCALIZACION DEL PROFESOR

*>>>>BUSQUEDA DEL ESTUDIANTE
       lHayEst := .F.
       cNomEst := 'NOMBRE DEL ESTUDIANTE NO REGISTRADO'
       IF !EMPTY(ACT->cCodigoEst)
	  lHayEst := lSekCodMae(ACT->cCodigoEst,cMaeAlu,@cMaeAct)
	  IF lHayEst
	     cNomEst := RTRIM(&cMaeAct->cApelliEst)+' '+;
			RTRIM(&cMaeAct->cNombreEst)
	  ENDIF
       ENDIF
*>>>>FIN BUSQUEDA DEL ESTUDIANTE

*>>>>IMPRESION DE LOS ENCABEZADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(3,'PROFESOR:'+cNomPro,22,'°')

       cSay(nNroFil,nNroCol,'CODIGO:',ACT->cCodigoEst)
       cSay(nNroFil,nNroCol+16,'NOMBRE:',cNomEst)

       IF !EMPTY(ACT->cCodigoEst) .AND. lHayEst
	  cSay(nNroFil,nNroCol+65,'CURSO:',&cMaeAct->cCodigoGru)
       ENDIF

       cSay(nNroFil+2,nNroCol,'INDICADORES EN SIMACONT DE:',cMatNot)
       SET COLOR TO I
       cSay(nNroFil+3,nNroCol,SUBS(ACT->cIndNotLog,1,60))
       SET COLOR TO

       SET COLOR TO I
       cSay(nNroFil+4,nNroCol,SUBS(ACT->cIndNotLog,61,125))
       SET COLOR TO

       IF ACT->cMatNotLog # ACT->cMatNoPLog
	  cSay(nNroFil+6,nNroCol,'INDICADORES EN SIMAPROF:',cMatNoP)
       ELSE
	  cSay(nNroFil+6,nNroCol,'INDICADORES EN SIMAPROF DE:',cMatNot)
       ENDIF
       SET COLOR TO I
       cSay(nNroFil+7,nNroCol,SUBS(ACT->cIndNoPLog,1,60))
       SET COLOR TO

       SET COLOR TO I
       cSay(nNroFil+8,nNroCol,SUBS(ACT->cIndNoPLog,61,125))
       SET COLOR TO

       cSay(nNroFil+10,nNroCol,'JUICIOS VALORATIVOS EN SIMACONT:')
       SET COLOR TO I
       cSay(nNroFil+10,nNroCol+33,ACT->cDefNotLog)
       SET COLOR TO

       cSay(nNroFil+11,nNroCol,'JUICIOS VALORATIVOS EN SIMAPROF:')
       SET COLOR TO I
       cSay(nNroFil+11,nNroCol+33,ACT->cDefNoPLog)
       SET COLOR TO
       cSay(nNroFil+11,nNroCol+42,'Periodo No.',STR(ACT->nNroPerLog,1))

       IF !EMPTY(ACT->cRecNotLog) .OR. !EMPTY(ACT->cRecNoPLog)
	  cSay(nNroFil+13,nNroCol,'JUICIOS RECUPERADOS EN SIMACONT:')
	  SET COLOR TO I
	  cSay(nNroFil+13,nNroCol+33,ACT->cRecNotLog)
	  SET COLOR TO
       ENDIF

       IF !EMPTY(ACT->cRecNotLog) .OR. !EMPTY(ACT->cRecNoPLog)
	  cSay(nNroFil+14,nNroCol,'JUICIOS RECUPERADOS EN SIMAPROF:')
	  SET COLOR TO I
	  cSay(nNroFil+14,nNroCol+33,ACT->cRecNoPLog)
	  SET COLOR TO
	  cSay(nNroFil+14,nNroCol+42,'Periodo No.',STR(ACT->nNroPerLog,1))
       ENDIF

       cPausa()
       SELECT ACT
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

/*************************************************************************
* TITULO..: MENU OTROS PROCESOS PARA EL BROWSE DEL ARCHIVO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2002 DOM A
       Bucaramanga, Colombia	    INICIO: 11:20 PM   NOV 10/2002 DOM

OBJETIVOS:

1- Menu de otros procesos para el Browse del Archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrAct(aParam1,aParam2,aParam3,;
		    oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<SIMACONT A SIMAPROF>')
       AADD(aMenus,'2<SIMAPROF A SIMACONT>')
       AADD(aMenus,'3<ACTUALIZAR         >')

       aAyuda := {}
       AADD(aAyuda,'Permite Activar la Actualizaci¢n de SIMACONT A SIMAPROF')
       AADD(aAyuda,'Permite Activar la Actualizaci¢n de SIMAPROF A SIMACONT')
       AADD(aAyuda,'Actualiza TODOS los registros Activados')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1         // SIMACONT A SIMAPROF
	    ContProf(lShared,oBrowse,1)

       CASE nNroOpc == 2         // SIMAPROF A SIMACONT
	    ContProf(lShared,oBrowse,2)

       CASE nNroOpc == 3         // ACTUALIZAR
	    ActValNot(lShared,oBrowse)

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: ACTIVAR ACTUALIZACION DE SIMACONT A SIMAPROF                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 11/2002 LUN A
       Bucaramanga, Colombia	    INICIO: 02:00 AM   NOV 11/2002 LUN


OBJETIVOS:

1- Activa la Actualizaci¢n de SimaCont a SimaProf o SimaProf a SimaCont

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ContProf(lShared,oBrowse,nTipAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       oBrowse                              // Browse del Archivo
       nTipAct                              // Tipo de Actualizaci¢n. 1=>SimaCont a SimaProf 2=>SimaProf a SimaCont */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nAvance := 0                   // Avance del Termometro
       LOCAL nActiva := 0                   // Activar la Actualizaci¢n
       LOCAL nOpcion := 0                   // Opci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DETALLES DE LA ACTUALIZACION
       nActiva := nLeeOpcion('ENTRE EL TIPO DE ACTIVACION: '+;
		 '1<ACTIVAR> 2<DESACTIVAR> 3<ABANDONAR>?',3,'0')
       IF nActiva == 0
	  RETURN NIL
       ENDIF

       nOpcion := nLeeOpcion(IF(nActiva==1,'ACTIVAR','DESACTIVAR')+': '+;
			     '1<INDICADORES> 2<JUICIOS VALORATIVOS> '+;
			     '3<RECUPERACIONES> 4<ABANDONAR>?',4,'0')
       IF nOpcion == 0
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DETALLES DE LA ACTUALIZACION

*>>>>ACTIVACION DE LA ACTUALIZACION
       cSavPan := SAVESCREEN(0,0,24,79)

       DO CASE
       CASE nOpcion == 1
	    Termometro(0,IF(nActiva==1,'ACTIVANDO','DESACTIVANDO')+' '+;
			    'INDICADORES')

       CASE nOpcion == 2
	    Termometro(0,IF(nActiva==1,'ACTIVANDO','DESACTIVANDO')+' '+;
			    'JUICIOS VALORATIVOS')

       CASE nOpcion == 3
	    Termometro(0,IF(nActiva==1,'ACTIVANDO','DESACTIVANDO')+' '+;
			    'RECUPERACIONES')
       OTHERWISE
	    RETURN NIL
       ENDCASE

       SELECT ACT
       GO TOP
       DO WHILE .NOT. ACT->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ACT->(RECNO()) / ACT->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ACTIVACION O DESACTIVACION
	    IF ACT->(lRegLock(lShared,.F.))

*--------------ACTUALIZACION SIMACONT A SIMAPROF
		 IF nTipAct == 1

		    DO CASE
		    CASE nOpcion == 1 .AND. !ACT->lRegActLog

*........................INDICADORES
			   IF nActiva == 1 .AND. UPPER(ACT->cActIndLog) == 'X'
			      REPL ACT->cActIndLog WITH '1'
			   ENDIF
			 *ÀActivar

			   IF nActiva == 2 .AND. ACT->cActIndLog == '1'
			      REPL ACT->cActIndLog WITH 'x'
			   ENDIF
			 *ÀDesActivar
*........................FIN INDICADORES

		    CASE nOpcion == 2 .AND. !ACT->lRegActLog

*........................JUICIOS VALORATIVOS
			   IF nActiva == 1 .AND. UPPER(ACT->cActDefLog) == 'X'
			      REPL ACT->cActDefLog WITH '1'
			   ENDIF
			 *ÀActivar

			   IF nActiva == 2 .AND. ACT->cActDefLog == '1'
			      REPL ACT->cActDefLog WITH 'x'
			   ENDIF
			 *ÀDesActivar
*........................FIN JUICIOS VALORATIVOS


		    CASE nOpcion == 3 .AND. !ACT->lRegActLog

*........................RECUPERACIONES
			   IF nActiva == 1 .AND. UPPER(ACT->cActRecLog) == 'X'
			      REPL ACT->cActRecLog WITH '1'
			   ENDIF
			 *ÀActivar

			   IF nActiva == 2 .AND. ACT->cActRecLog == '1'
			      REPL ACT->cActRecLog WITH 'x'
			   ENDIF
			 *ÀDesActivar
*........................FIN RECUPERACIONES

		    ENDCASE

		 ENDIF
*--------------FIN ACTUALIZACION SIMACONT A SIMAPROF

*--------------ACTUALIZACION SIMAPROF A SIMACONT
		 IF nTipAct == 2

		    DO CASE
		    CASE nOpcion == 1 .AND. !ACT->lRegActLog

*........................INDICADORES
			   IF nActiva == 1 .AND. UPPER(ACT->cActIndLog) == 'Y'
			      REPL ACT->cActIndLog WITH '2'
			   ENDIF
			 *ÀActivar

			   IF nActiva == 2 .AND. ACT->cActIndLog == '2'
			      REPL ACT->cActIndLog WITH 'y'
			   ENDIF
			 *ÀDesActivar
*........................FIN INDICADORES

		    CASE nOpcion == 2 .AND. !ACT->lRegActLog

*........................JUICIOS VALORATIVOS
			   IF nActiva == 1 .AND. UPPER(ACT->cActDefLog) == 'Y'
			      REPL ACT->cActDefLog WITH '2'
			   ENDIF
			 *ÀActivar

			   IF nActiva == 2 .AND. ACT->cActDefLog == '2'
			      REPL ACT->cActDefLog WITH 'y'
			   ENDIF
			 *ÀDesActivar
*........................FIN JUICIOS VALORATIVOS


		    CASE nOpcion == 3 .AND. !ACT->lRegActLog

*........................RECUPERACIONES
			   IF nActiva == 1 .AND. UPPER(ACT->cActRecLog) == 'Y'
			      REPL ACT->cActRecLog WITH '2'
			   ENDIF
			 *ÀActivar

			   IF nActiva == 2 .AND. ACT->cActRecLog == '2'
			      REPL ACT->cActRecLog WITH 'y'
			   ENDIF
			 *ÀDesActivar
*........................FIN RECUPERACIONES

		    ENDCASE

		 ENDIF
*--------------FIN ACTUALIZACION SIMAPROF A SIMACONT

	       ACT->(DBCOMMIT())

	    ENDIF
	    IF lShared
	       ACT->(DBUNLOCK())
	    ENDIF
**********FIN ACTIVACION O DESACTIVACION DE LA REVISION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ACT
	    ACT->(DBSKIP())
	    IF ACT->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ACTIVACION DEL CAMPO DE REVISAR A ESTUDIANTES


/*************************************************************************
* TITULO..: ACTUALIZAR LA VALIDACION DE LAS NOTAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 11/2002 LUN A
       Bucaramanga, Colombia	    INICIO: 03:30 AM   NOV 11/2002 LUN


OBJETIVOS:

1- Activa la Actualizaci¢n de SimaCont a SimaProf o SimaProf a SimaCont

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActValNot(lShared,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL FAntNoP := ''                  // Archivo Anterior de Notas del Profesor
       LOCAL FAntNot := ''                  // Archivo Anterior de Notas
       LOCAL cCampos := ''                  // Campos

       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cMsgTxt := ''                  // Mensaje de Texto
       LOCAL lRegAct := .F.                 // .T. Registro Actualizado
       LOCAL lSiorNo := .F.                 // Variable Logica
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTUALIZACION DE LAS NOTAS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(3,'ACTUALIZANDO LAS NOTAS',22,'°')

       SELECT ACT
       ACT->(DBGOTOP())
       DO WHILE .NOT. ACT->(EOF())

**********VALIDACION DEL CODIGO DE ESTUDIANTE
	    @ nNroFil,nNroCol SAY ACT->cCodigoEst

	    IF EMPTY(ACT->cCodigoEst)
	       SELECT ACT
	       ACT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO DE ESTUDIANTE

**********SELECION DE LAS AREAS DE TRABAJO
	    FileNot := ALLTRIM(ACT->cNomArcNot)
	    IF FAntNot # FileNot
	       IF !lUseDbf(.T.,FileNot,'NOT',NIL,lShared)
		  cError('ABRIENDO EL ARCHIVO '+FileNot)
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    FNotPro := ALLTRIM(ACT->cNomArcNop)
	    IF FAntNoP # FNotPro
	       IF !lUseDbf(.T.,FNotPro,'NOP',NIL,lShared)
		  cError('ABRIENDO EL ARCHIVO '+FNotPro)
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF ACT->cCodigoEst # NOT->cCodigoEst
	       IF !lLocCodigo('cCodigoEst','NOT',ACT->cCodigoEst)
		  cError('EL CODIGO:'+ACT->cCodigoEst+' '+;
			 'NO EXISTE EN NOTAS')
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********LOCALIZACION DEL ESTUDIANTE EN EL PROFESOR
	    IF ACT->cCodigoEst # NOP->cCodigoEst
	       IF !lLocCodigo('cCodigoEst','NOP',ACT->cCodigoEst)
		  cError('EL CODIGO:'+ACT->cCodigoEst+' '+;
			 'NO EXISTE EN NOTAS DEL PROFESOR')
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN EL PROFESOR

**********ACTUALIZACION DE LAS NOTAS DE SIMACONT A SIMAPROF
	    cMsgTxt := ''
	    lRegAct := .F.
	    lSiorNo := ACT->cCodigoEst == NOT->cCodigoEst .AND.;
		       ACT->cCodigoEst == NOP->cCodigoEst

	    IF lSiorNo .AND. (ACT->cActIndLog == '1' .OR.;
			      ACT->cActDefLog == '1' .OR.;
			      ACT->cActRecLog == '1')

	       IF NOP->(lRegLock(lShared,.F.))

*-----------------ACTUALIZACION DE LOS INDICADORES
		    IF &(ACT->cCamIndNot) == ACT->cIndNotLog .AND.;
		       &(ACT->cCamIndNoP) == ACT->cIndNoPLog

		       IF ACT->cActIndLog == '1'
			  cCampos := ACT->cCamIndNoP
			  REPL &cCampos WITH ACT->cIndNotLog
			  cMsgTxt += '1Ind-Ok,'
			  lRegAct := .T.
		       ENDIF

		    ELSE
			cMsgTxt += ACT->cCamIndNot+'#'+ACT->cCamIndNoP
		    ENDIF
*-----------------FIN ACTUALIZACION DE LOS INDICADORES

*-----------------ACTUALIZACION DE JUICIOS VALORATIVOS
		    IF SUBS(&(ACT->cCamDefNot),1,20) == SUBS(ACT->cDefNotLog,1,20) .AND.;
		       &(ACT->cCamDefNoP) == ACT->cDefNoPLog

		       IF ACT->cActDefLog == '1'
			  cCampos := ACT->cCamDefNoP
			  REPL &cCampos WITH SUBS(ACT->cDefNotLog,;
						  ACT->nNroPerLog*4-3,4)
			  cMsgTxt += '1JVA-Ok,'
			  lRegAct := .T.
		       ENDIF

		    ELSE
			cMsgTxt += ACT->cCamDefNot+'#'+ACT->cCamDefNoP
		    ENDIF
*-----------------FIN ACTUALIZACION DE JUICIOS VALORATIVOS

*-----------------ACTUALIZACION DE RECUPERACIONES
		    IF &(ACT->cCamRecNot) == ACT->cRecNotLog .AND.;
		       &(ACT->cCamRecNoP) == ACT->cRecNoPLog

		       IF ACT->cActRecLog == '1'
			  cCampos := ACT->cCamRecNoP
			  REPL &cCampos WITH SUBS(ACT->cRecNotLog,;
						  ACT->nNroPerLog*4-3,4)
			  cMsgTxt += '1JVR-Ok,'
			  lRegAct := .T.
		       ENDIF

		    ELSE
			cMsgTxt += ACT->cCamIndNot+'#'+ACT->cCamIndNoP
		    ENDIF
*-----------------FIN ACTUALIZACION DE RECUPERACIONES

		  NOP->(DBCOMMIT())

	       ENDIF
	       IF lShared
		  NOP->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********ACTUALIZACION DE LAS NOTAS DE SIMACONT A SIMAPROF

**********ACTUALIZACION DE LAS NOTAS DE SIMAPROF A SIMACONT
	    IF lSiorNo .AND. (ACT->cActIndLog == '2' .OR.;
			      ACT->cActDefLog == '2' .OR.;
			      ACT->cActRecLog == '2')

	       IF NOT->(lRegLock(lShared,.F.))

*-----------------ACTUALIZACION DE LOS INDICADORES
		    IF &(ACT->cCamIndNot) == ACT->cIndNotLog .AND.;
		       &(ACT->cCamIndNoP) == ACT->cIndNoPLog

		       IF ACT->cActIndLog == '2'
			  cCampos := ACT->cCamIndNot
			  REPL &cCampos WITH ACT->cIndNoPLog
			  cMsgTxt += '2Ind-Ok,'
			  lRegAct := .T.
		       ENDIF

		    ELSE
			cMsgTxt += ACT->cCamIndNot+'#'+ACT->cCamIndNoP
		    ENDIF
*-----------------FIN ACTUALIZACION DE LOS INDICADORES

*-----------------ACTUALIZACION DE JUICIOS VALORATIVOS
		    IF &(ACT->cCamDefNot) == ACT->cDefNotLog .AND.;
		       &(ACT->cCamDefNoP) == ACT->cDefNoPLog

		       IF ACT->cActDefLog == '2'

			  cCampos := ACT->cCamDefNot
			  REPL &cCampos WITH STUFF(&cCampos,;
						   ACT->nNroPerLog*4-3,4,;
						   ACT->cDefNoPLog)

			  cMsgTxt += '2JVA-Ok,'
			  lRegAct := .T.
		       ENDIF

		    ELSE
			cMsgTxt += ACT->cCamDefNot+'#'+ACT->cCamDefNoP
		    ENDIF
*-----------------FIN ACTUALIZACION DE JUICIOS VALORATIVOS

*-----------------ACTUALIZACION DE RECUPERACIONES
		    IF &(ACT->cCamRecNot) == ACT->cRecNotLog .AND.;
		       &(ACT->cCamRecNoP) == ACT->cRecNoPLog

		       IF ACT->cActRecLog == '2'

			  cCampos := ACT->cCamRecNot
			  REPL &cCampos WITH STUFF(&cCampos,;
						   ACT->nNroPerLog*4-3,4,;
						   ACT->cRecNoPLog)

			  cMsgTxt += '2JVR-Ok,'
			  lRegAct := .T.
		       ENDIF

		    ELSE
			cMsgTxt += ACT->cCamIndNot+'#'+ACT->cCamIndNoP
		    ENDIF
*-----------------FIN ACTUALIZACION DE RECUPERACIONES

		  NOT->(DBCOMMIT())

	       ENDIF
	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DE LAS NOTAS DE SIMAPROF A SIMACONT

**********GRABACION DEL ESTADO DE LA GRABACION
	    IF lSiorNo .OR. !EMPTY(cMsgTxt) .OR. lRegAct

	       IF ACT->(lRegLock(lShared,.F.))
		  IF !EMPTY(cMsgTxt)
		     REPL ACT->cObservLog WITH ALLTRIM(ACT->cObservLog)+' '+;
					       cMsgTxt
		  ENDIF
		  IF lRegAct
		     REPL ACT->lRegActLog WITH lRegAct
		  ENDIF
		  ACT->(DBCOMMIT())
	       ENDIF

	       IF lShared
		  ACT->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL ESTADO DE LA GRABACION

**********VISUALIZACION DE LA CARGA€
	    @ nNroFil,8 SAY cMsgTxt
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(3,'ACTUALIZANDO LAS NOTAS',22,'°')
	    ENDIF
**********FIN VISUALIZACION DE LA CARGA

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ACT
	    ACT->(DBSKIP())
	    NOT->(DBSKIP())
	    NOP->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DE ARCHIVOS ANTERIORES
	    IF FileNot # ALLTRIM(ACT->cNomArcNot)
	       FileNot := ALLTRIM(ACT->cNomArcNot)
	    ENDIF
	    IF FNotPro # ALLTRIM(ACT->cNomArcNop)
	       FNotPro := ALLTRIM(ACT->cNomArcNop)
	    ENDIF
**********FIN ANALISIS DE ARCHIVOS ANTERIORES

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LAS NOTAS

