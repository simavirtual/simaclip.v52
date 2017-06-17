/* SIMA - MATRICULA ACADEMICA

MODULO      : INSCRIPCIONES
SUBMODULO...: CONSULTA               MODULO No. 102

**************************************************************************
* TITULO ..: CONSULTA DE CANDIDATOS                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   ENE 03/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite permite consultar los candidatos inscritos

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_102(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL lRapido := .T.                 // .T. Impresi¢n r pida

       LOCAL oConsul := NIL                 // Browse de Alumnos
       LOCAL cObsInc := ''                  // Observaci¢n para la Inscripci¢n

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
       IF  !lParam0101(aParams,;
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE INF->(RECCOUNT()) == 0
	    cError('NO SE HAN CREADO LOS INFORMES DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ANO->lPrnAdmAno .AND. ANO->nTipAdmAno == 0
	    cError('NO SE HA ESPECIFICADO EL NUMERO DE HOJA DE INSCRIPCION')

       CASE ANO->lPrnAdmAno .AND. ANO->nTipAdmAno > 10 .AND.;
	    ANO->nTipAdmAno # 99
	    cError('NUMERO DE HOJA DE INSCRIPCION NO HABILITADO')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nPrnCerPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT ADM
       oConsul := oDefInsAdm(nFilPal+1,00,22,79,cJorTxt)
       SETKEY(K_F5,{||BuscarAdm(lShared,cPatSis,oConsul)})

       cObsInc := ANO->cMenIncAno

       SETKEY(K_F9,{||MenuOtr102(lShared,nModCry,cCodSui,cNomSis,cCodEmp,;
				 cEmpPal,cNitEmp,cNomEmp,cNomSec,nFilInf,;
				 nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
				 PathUno,PathDos,PathTre,PathCua,cMaeAlu,;
				 cMaeAct,cJorTxt,oConsul,lRapido,cObsInc)})

       ADM->(CtrlBrw(lShared,oConsul))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION OBJETO DE INSCRITOS                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   ENE 03/96 MIE

1- Define el objeto Browse del Inscritos

2- Debe estar en uso el archivo de Admisiones

SINTAXIS:

 oConsul := oDefInsAdm(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefInsAdm(nFilSup,nColSup,nFilInf,nColInf,cJorTxt,cTitSup,cTitInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cJorTxt                              // Jornada Escogida
       cTitSup                              // T¡tulo Superior del Browse
       cTitInf                              // T¡tulo Inferior del Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oConsul := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oConsul := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       cTitSup := IF(!EMPTY(cTitSup),cTitSup,;
		    '<<  CONSULTA DE INSCRITOS. JORNADA: '+cJorTxt+' >>')

       cTitInf := IF(!EMPTY(cTitInf),cTitInf,;
		     '<F5>Buscar  <F9>Otros <ESC>Abandonar')


       oConsul:ColSep    := '³'
       oConsul:HeadSep   := 'Ä'
       oConsul:Cargo     := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ADM
       oColumn	     := TBCOLUMNNEW('CODIGO',;
				   {||ADM->cNumeroAdm})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NIVEL',{||ADM->cCodigoGru})
       IF MTR->nPruebaMtr # 0
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cCodigoGru'},;
			    {'PICTURE','9999'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('APELLIDOS',;
			      {||ADM->cApelliEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cApelliEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
       oConsul:Freeze := 4
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES',;
			      {||ADM->cNombreEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cNombreEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn := TBCOLUMNNEW('CODIGO',{||ADM->cCodigoEst})
       IF MTR->nPruebaMtr # 0
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cCodigoEst'},;
			    {'PICTURE','999999'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;INSCRIPCION',{||ADM->dFecInsAdm})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','dFecInsAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('CUPO',;
				    {||ADM->lSiCupoEst})
       IF MTR->nPruebaMtr # 0
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','lSiCupoEst'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATRICULADO',;
				    {||ADM->lSiMatrEst})
       IF MTR->nPruebaMtr # 0
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','lSiMatrEst'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;MATRICULA',{||ADM->dFecMatEst})
       IF MTR->nPruebaMtr # 0
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','dFecMatEst'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('RETIRADO',;
				    {||ADM->lRetiroAdm})
       IF MTR->nPruebaMtr # 0
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','lRetiroAdm'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PADRES EXALUMNOS',;
				    {||ADM->lExAlumAdm})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','lExAlumAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DEL;RECIBO DE PAGO',;
				    {||ADM->cRecPagAdm})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cRecPagAdm'},;
			 {'PICTURE','@X'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('CONSULTAR;CEDULAS',{||ADM->cPrnNitAdm})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cPrnNitAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA;DEL PADRE',{||ADM->cPadNitEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cPadNitEst'},;
			 {'PICTURE','9999999999999999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA;DEL MADRE',{||ADM->cMadNitEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cMadNitEst'},;
			 {'PICTURE','9999999999999999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA DEL;ACUDIENTE',{||ADM->cAcuNitEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cAcuNitEst'},;
			 {'PICTURE','9999999999999999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION',;
				    {||IF(!ADM->lRetiroAdm .AND. ;
					  !ADM->lExamenAdm .AND. ;
					  ADM->nDefExaAdm == 0,;
					  'PENDIENTE',SPACE(09))})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('APELLIDOS DEL;PADRE',{||ADM->cApePadEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cApePadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES DEL;PADRE',{||ADM->cNomPadEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cNomPadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('APELLIDOS;DE LA MADRE',{||ADM->cApeMadEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cApeMadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOMBRES;DE LA MADRE',{||ADM->cNomMadEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cNomMadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TELEFONO',{||ADM->cTelefnEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','cTelefnEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ESTRATO',{||ADM->nEstratEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},{'FIELD','nEstratEst'},;
			 {'PICTURE','99'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oConsul
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: MENU DE INFORMES PARA EL BROWSE DE INSCRIPTOS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 02/2001 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   OCT 02/2001 MAR

OBJETIVOS:

1- Menu de Otros Procesos e informes

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtr102(lShared,nModCry,cCodSui,cNomSis,cCodEmp,;
		    cEmpPal,cNitEmp,cNomEmp,cNomSec,nFilInf,;
		    nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		    PathUno,PathDos,PathTre,PathCua,cMaeAlu,;
		    cMaeAct,cJorTxt,oBrowse,lRapido,cObsInc)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cCodSui                              // C¢digo del Sistema
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
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
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo
       lRapido                              // .T. Impresi¢n r pida
       cObsInc                              // Observaci¢n para la Inscripci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
*      LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀGestion Documental

       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables del informe

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<IMPRIMIR INSCRIPCION >',;
		   '2<IMPRIMIR POR CEDULAS >',;
		   '3<ACTIVAR CEDULAS      >',;
		   '4<DESACTIVAR CEDULAS   >',;
		   '5<PAGO DE INSCRIPCIONES>'}

       aAyuda := {'Imprime el formato de Inscripci¢n',;
		  'Imprime los Inscritos por Cedulas',;
		  'Activa la Impresi¢n de C‚dulas para '+;
		   'Consulta a la Central de Riesgos',;
		  'DesActiva la Impresi¢n de C‚dulas '+;
		   'para Consulta a la Central de Riesgos',;
		  'Imprime la relaci¢n del pago de inscripciones'}

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1 .AND. ANO->lPrnAdmAno
	    PrnFrmIns(cNomSis,cNomEmp,cAnoUsr,cJorTxt,lRapido,cObsInc)
	   *Impresi¢n del Formulario de Inscripci¢n

       CASE nNroOpc == 2

************GESTION DOCUMENTAL DEL INFORME
	      nLenPrn := PCL('n17Stan')

	      nNroInf := 102
	    *ÀN£mero de identificaci¢n del informe

	      cOpcSys := '<INSCRIPCIONES><CONSULTA>'
	    *ÀOpci¢n del sistema del informe

	      cCodInf := 'MTR00201'
	      AADD(aMarInf,{0,0}) // MS:ID
	      AADD(aMarInf,{0,0}) // MI:ID
	      AADD(aMarInf,{0,0}) // M1:ID
	      AADD(aMarInf,{0,0}) // M2:ID
	      nNroDoc := 0
	    *ÀInforme por defecto

	      aMezIso := {}
	      AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
	      AADD(aMezIso,{'<cJorTxt>',cJorTxt})
	    *ÀCampos a sustituir

	      aTitIso := {}
	      AADD(aTitIso,'CEDULA DE LOS PADRES DE INSCRITOS')  // T¡tulo Uno
	      AADD(aTitIso,'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')  // T¡tulo Dos
	      AADD(aTitIso,'')                                   // T¡tulo Tres
	    *ÀT¡tulos del Informe por defecto

	      cPiePag := ALLTRIM(SCO->cPiePagCon)
	      IF !EMPTY(cPiePag)
		 cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
	      ENDIF

	      aPieIso := {}
	      AADD(aPieIso,'')                 // Pie de p gina Uno
	      AADD(aPieIso,'')                 // Pie de p gina Dos
	      AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
	    *ÀPie de p ginas por defecto

	      aObsIso := {}
	      AADD(aObsIso,'')
	      AADD(aObsIso,'')
	      AADD(aObsIso,'')

	      bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				       nNroInf,aTitIso[1],cOpcSys,;
				       MTR->cUsrIsoMtr,;
				       cCodInf,aMarInf,nNroDoc,aObsIso)}
	    *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
************FIN GESTION DOCUMENTAL DEL INFORME

************ACTIVACION DE LA IMPRESORA
	      IF MTR->lPrnArcMtr
		 SET DEVICE TO PRINT
	      ELSE
		 FilePrn := cCodInf
		 nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,;
					MTR->cOpcPrnMtr,.T.,2,bInsIso)
		 IF EMPTY(nOpcPrn)
		    RETURN NIL
		 ENDIF
	      ENDIF
************FIN ACTIVACION DE LA IMPRESORA

************SUSTITUCION DE TEXTO
	      fDocPrn := ''
	      IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
			     @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
			     @fDocPrn)
		 RETURN NIL
	      ENDIF
	      ReplTitIso(@aTitIso,aMezIso)
************FIN SUSTITUCION DE TEXTO

************IMPRESION DEL INFORME
	      DO CASE
	      CASE cCodInf == 'MTR00201'
		   Mtr_002_01(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			     nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			     cPatSis,cMaeAlu,cMaeAct,cJorTxt,oBrowse,;
			     cCodInf,cCodIso,aTitIso,aPieIso,aMarInf,;
			     @aObsIso,FilePrn,nOpcPrn)
       /*
		   PrnCedulas(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			     nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
			     cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
			     cMaeAlu,cMaeAct,cJorTxt,oBrowse)
		  *Impresi¢n por C‚dulas
       */
	      ENDCASE
************IMPRESION DEL INFORME

       CASE nNroOpc == 3
	    ActivarCed(lShared,oBrowse,.T.)
	   *Activaci¢n Impresi¢n de Cedulas

       CASE nNroOpc == 4
	    ActivarCed(lShared,oBrowse,.F.)
	   *DesActivaci¢n Impresi¢n de Cedulas

       CASE nNroOpc == 5
	    PrnPagoIns(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		       nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		       cPatSis,cMaeAlu,cMaeAct,cJorTxt,oBrowse)
	   *Impresi¢n pago de inscripciones

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRESION DEL FORMULARIO DE ADMISION                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2001 MIE A
       Colombia, Bucaramanga        INICIO: 09:20 AM   OCT 03/2001 MIE

OBJETIVOS:

1- Imprime el formulario de Inscripci¢n

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnFrmIns(cNomSis,cNomEmp,cAnoUsr,cJorTxt,lRapido,cObsInc)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       lRapido                              // .T. Impresi¢n r pida
       cObsInc                              // Observaci¢n para la Inscripci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀGestion Documental
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nNroInf := 101
     *ÀN£mero de identificaci¢n del informe

       AADD(aMarInf,{8,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
     *ÀInforme por defecto

       aTitIso := {}
       AADD(aTitIso,'')                                 // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,'')                 // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>SUSTITUCION DE TEXTO
       fDocPrn := 'Bases\FrmAdmXX.Txt'
       IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
		     @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
		     @fDocPrn)
	  RETURN NIL
       ENDIF
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>IMPRESION INFORME DEL SISTEMA
       IF ANO->lPrnAdmAno
	  DO CASE
	  CASE cCodInf == 'MTR00101'

	       Mtr_001_01(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Solicitud de Cupo por defecto

	  CASE cCodInf == 'MTR00102'

	       Mtr_001_02(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario del Virrey Solis

	  CASE cCodInf == 'MTR00103'

	       Mtr_001_03(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario de Instituto San Bernardo y la Merced

	  CASE cCodInf == 'MTR00104'

	       Mtr_001_04(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario con firma de Rectoria Psicoorientadora

	  CASE cCodInf == 'MTR00105'

	       Mtr_001_05(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario con foto,tiempo de servicio,etc

	  CASE cCodInf == 'MTR00106'

	       Mtr_001_06(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)

	  CASE cCodInf == 'MTR00107'

	       Mtr_001_07(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario Enfermedades y Religi¢n. Virres

	  CASE cCodInf == 'MTR00108'

	       Mtr_001_08(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario por Defecto alternativo

	  CASE cCodInf == 'MTR00109'

	       Mtr_001_09(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	     *ÀSugerido por el colegio la presentaci¢n.

	  CASE cCodInf == 'MTR00110'

	       Mtr_001_10(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,cNomSis,;
			  cNomEmp,cAnoUsr,lRapido,;
			  ANO->cObsUnoAno,;
			  ANO->cObsDosAno,;
			  ANO->cObsTreAno,cJorTxt,cObsInc,;
			  aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)
	      *Formulario 5 con foto,modificado.

	  CASE cCodInf == 'MTR00199'

	       Mtr_001_99(ADM->cNumeroAdm,;
			  SUBS(ADM->cCodigoGru,1,2),;
			  ADM->cNombreEst,;
			  ADM->cApelliEst,;
			  ADM->lExAlumAdm,;
			  cAnoUsr,cJorTxt,;
			  cObsInc,nNroDoc)
	      *Formulario tomado de un archivo texto

	  OTHERWISE
	       cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
	  ENDCASE
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION INFORME DEL SISTEMA

/*************************************************************************
* TITULO..: ACTIVACION DE LA IMPRESION DE LAS CEDULAS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2001 MIE A
       Colombia, Bucaramanga        INICIO: 09:45 AM   OCT 03/2001 MIE

OBJETIVOS:

1- Activa o DesActiva la impresi¢n de Cedulas para la consulta de la
   central de Riesgos.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActivarCed(lShared,oBrowse,lActiva)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       oBrowse			            // Browse del Profesor
       lActiva                              // .T. Activar Cedulas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nAvance := 0                   // Avance del Termometro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF ADM->(RECCOUNT()) == 0
	  cError('NO EXISTEN INSCRIPCIONES')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ACTIVACION DE LA IMPRESION DE CEDULAS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,IF(lActiva,'ACTIVANDO','DESACTIVANDO')+' '+;
		    'LA IMPRESION DE CEDULAS')

       SELECT ADM
       GO TOP
       DO WHILE .NOT. ADM->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ADM->(RECNO()) / ADM->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ACTIVACION DE LA IMPRESION
	    IF ADM->(lRegLock(lShared,.F.))
	       IF lActiva
		  REPL ADM->cPrnNitAdm WITH SPACE(04)
	       ELSE
		  REPL ADM->cPrnNitAdm WITH '111 '
	       ENDIF
	       ADM->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       ADM->(DBUNLOCK())
	    ENDIF
**********FIN ACTIVACION DE LA IMPRESION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ADM
	    ADM->(DBSKIP())
	    IF ADM->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ACTIVACION DE LA IMPRESION DE CEDULAS

/*************************************************************************
* TITULO..: IMPRESION POR CEDULAS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 25/2001 MAR A
       Colombia, Bucaramanga        INICIO: 05:30 PM   SEP 25/2001 MAR

OBJETIVOS:

1- Permite imprimir los inscritos por c‚dulas de los padres o acudiente

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnCedulas(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		    cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,;
		    cMaeAlu,cMaeAct,cJorTxt,oBrowse)

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
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*      #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nTotReg := 0                   // Total de Registros
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL cNomEst := ''                  // Nombre del estudiante
       LOCAL cNomPad := ''                  // Nombre del Padre
       LOCAL cNomMad := ''                  // Nombre de la Madre
       LOCAL cNomAcu := ''                  // Nombre del Acudiente
       LOCAL lTodos  := .F.                 // .T.
       LOCAL lSiPrin := .F.                 // .T. Imprimir
       LOCAL lPrnPad := .F.                 // Imprimir al Padre
       LOCAL lPrnMad := .F.                 // Imprimir a la Madre
       LOCAL lPrnAcu := .F.                 // Imprimir al Acudiente

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cPrnNitTad := ''               // Imprimir Cedulas.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       lTodos := lPregunta('DESEA IMPRIMIR TODOS LOS INSCRITOS? No Si')

       nNroPag := 0
       lTamAnc := .F.

       nTotReg := ADM->(RECCOUNT())
       aCabeza := {cNomEmp,cNomSis,;
		   IF(lTodos,'RELACION DE INSCRITOS POR CEDULAS',;
			     'RELACION DE CEDULAS PARA CONSULTA'),;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,40,16,10,30}
       aTitulo := {'No. ',;
		   'CODIGO',;
		   'NIVEL',;
		   'APELLIDOS Y NOMBRES ','CEDULA',;
		   'PARENTESCO','OBSERVACIONES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL TERMOMETRO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'IMPRIMIENDO LOS INSCRIPTOS')
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr)
       IF EMPTY(nOpcPrn)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP
       DO WHILE .NOT. ADM->(EOF())

/*
**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       ADM->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO
*/

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cNomEst := RTRIM(ADM->cApelliEst)+' '+;
			       ADM->cNombreEst+SPACE(10)

	    cNomPad := RTRIM(ADM->cApePadEst)+' '+;
			     ADM->cNomPadEst+SPACE(10)

	    cNomMad := RTRIM(ADM->cApeMadEst)+' '+;
			     ADM->cNomMadEst+SPACE(10)

	    cNomAcu := RTRIM(ADM->cApeAcuEst)+' '+;
			     ADM->cNomAcuEst+SPACE(10)

	    cPrnNitTad := SPACE(04)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INSCRITO
	    lSiPrin := .F.
	    IF ( ADM->cPrnNitAdm = SPACE(04) .AND.;
		(!EMPTY(ADM->cPadNitEst)     .OR.;
		 !EMPTY(ADM->cMadNitEst)     .OR.;
		 !EMPTY(ADM->cAcuNitEst)) )  .OR. lTodos

	       aTitulo := {IF(!lTodos,SPACE(04),STR(nNumero++,4)),;
			   ADM->cNumeroAdm,;
			   ADM->cCodigoGru,;
			   SUBS(cNomEst,1,40),;
			   SPACE(16),;
			   'ESTUDIANTE',''}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	       lSiPrin := .T.
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INSCRITO

**********IMPRESION DEL CONTENIDO DEL PADRE
	    lPrnPad := SUBS(ADM->cPrnNitAdm,1,1) # '1' .AND.;
		       !EMPTY(ADM->cPadNitEst)

	    IF lPrnPad .OR. lTodos
	       aTitulo := {IF(!lTodos,STR(nNumero++,4),SPACE(04)),;
			   SPACE(06),;
			   SPACE(06),;
			   SUBS(cNomPad,1,40),;
			   ADM->cPadNitEst,;
			   'PADRE',;
			   IF(lTodos,IF(lPrnPad .OR. EMPTY(ADM->cPadNitEst),;
					'POR CONSULTAR'+SPACE(17),''),'')}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	       cPrnNitTad := STUFF(cPrnNitTad,1,1,'1')
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL PADRE

**********IMPRESION DEL CONTENIDO DE LA MADRE
	    lPrnMad := SUBS(ADM->cPrnNitAdm,2,1) # '1'   .AND.;
		       !EMPTY(ADM->cMadNitEst)           .AND.;
		       ADM->cMadNitEst # ADM->cPadNitEst

	    IF lPrnMad .OR. lTodos
	       aTitulo := {IF(!lTodos,STR(nNumero++,4),SPACE(04)),;
			   SPACE(06),;
			   SPACE(06),;
			   SUBS(cNomMad,1,40),;
			   ADM->cMadNitEst,;
			   'MADRE',;
			   IF(lTodos,IF(lPrnMad .OR. EMPTY(ADM->cMadNitEst),;
				       'POR CONSULTAR'+SPACE(17),''),'')}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	       cPrnNitTad := STUFF(cPrnNitTad,2,1,'1')
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DE LA MADRE

**********IMPRESION DEL CONTENIDO DEL ACUDIENTE
	    lPrnAcu := SUBS(ADM->cPrnNitAdm,3,1) # '1'   .AND.;
		       !EMPTY(ADM->cAcuNitEst)           .AND.;
		       ADM->cAcuNitEst # ADM->cPadNitEst .AND.;
		       ADM->cAcuNitEst # ADM->cMadNitEst

	    IF lPrnAcu .OR. lTodos
	       aTitulo := {IF(!lTodos,STR(nNumero++,4),SPACE(04)),;
			   SPACE(06),;
			   SPACE(06),;
			   SUBS(cNomAcu,1,40),;
			   ADM->cAcuNitEst,;
			   'ACUDIENTE',;
			   IF(lTodos,IF(lPrnAcu .OR. EMPTY(ADM->cAcuNitEst),;
				     'POR CONSULTAR'+SPACE(17),''),'')}

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	       cPrnNitTad := STUFF(cPrnNitTad,3,1,'1')
	    ENDIF
	    IF lSiPrin
	       lPrnReg(01,00,REPL('=',LEN(cTxtPrn)),bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL ACUDIENTE

**********GRABACION DEL CONTROL DE LA IMPRESION POR CEDULAS
	    IF !lTodos
	       IF ADM->(lRegLock(lShared,.F.))
		  IF lSiPrin
		     REPL ADM->cPrnNitAdm WITH cPrnNitTad
		  ENDIF
		  ADM->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABABO EL REGISTRO')
	       ENDIF
	       IF lShared
		  ADM->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL CONTROL DE LA IMPRESION POR CEDULAS

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( ADM->(RECNO()) / ADM->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT ADM
	    ADM->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION RECIBO DE PAGO DE INSCRIPCIONES                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 11/2003 LUN A
       Colombia, Bucaramanga        INICIO: 04:30 PM   AGO 11/2003 LUN

OBJETIVOS:

1- Permite imprimir la relaci¢n de los recibos de pagos de las
   inscripciones.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnPagoIns(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		    cPatSis,cMaeAlu,cMaeAct,cJorTxt,oBrowse)

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
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nTotReg := 0                   // Total de Registros
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL nNroIns := 0                   // N£mero de Inscritos
       LOCAL nVlrTot := 0                   // Valor total de inscripci¢n
       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL TIPO DE LISTADO
       nOpcion := nLeeOpcion('ENTRE EL TIPO DE LISTADO: '+;
		 '1<RECIBOS> 2<SIN RECIBOS> 3<TODOS> 4<ABANDONAR>?',4,'0')

       IF nOpcion == 4
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE LISTADO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       DO CASE
       CASE nOpcion == 1
	    cTxtPrn := 'RELACION DE INSCRIPCIONES CANCELADAS'
       CASE nOpcion == 2
	    cTxtPrn := 'RELACION DE INSCRIPCIONES POR CANCELAR'
       CASE nOpcion == 3
	    cTxtPrn := 'RELACION DE TODAS LAS INSCRIPCIONES'
       ENDCASE

       nTotReg := ADM->(RECCOUNT())
       aCabeza := {cNomEmp,cNomSis,;
		   cTxtPrn,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,40,10,12}
       aTitulo := {'No. ',;
		   'CODIGO',;
		   'NIVEL',;
		   'APELLIDOS Y NOMBRES ','RECIBO','VALOR'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr)
       IF EMPTY(nOpcPrn)
	   RETURN NIL
       ENDIF

       @ PROW(),00 SAY PCL('Reset')
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP
       DO WHILE .NOT. ADM->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('REGISTRO No. '+ADM->(STR(RECNO(),4))+'/'+;
			  ADM->(STR(RECCOUNT(),4)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL CONTENIDO DEL INSCRITO
	    IF (nOpcion == 1 .AND. !EMPTY(ADM->cRecPagAdm)) .OR.;
	       (nOpcion == 2 .AND. EMPTY(ADM->cRecPagAdm))  .OR.;
		nOpcion == 3

*---------------CALCULO DEL VALOR DE LA INSCRIPCION
		  cTxtPrn := ''
		  IF (nOpcion == 1 .OR. nOpcion == 3) .AND.;
		     !EMPTY(ADM->cRecPagAdm)
		     cTxtPrn := TRANS(ANO->nVlrAdmAno,'####,###,###')
		     nVlrTot += ANO->nVlrAdmAno
		  ENDIF
*---------------FIN CALCULO DEL VALOR DE LA INSCRIPCION

*---------------IMPRESION DEL REGISTRO
		  cNombreTes := RTRIM(ADM->cApelliEst)+' '+;
				      ADM->cNombreEst+SPACE(10)

		  aTitulo := {STR(++nNroIns,4),;
			      ADM->cCodigoEst,;
			      ADM->cCodigoGru,;
			      SUBS(cNombreTes,1,40),;
			      ADM->cRecPagAdm,;
			      cTxtPrn}

		  cTxtPrn := cRegPrint(aTitulo,aNroCol)
		  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*---------------FIN IMPRESION DEL REGISTRO

	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INSCRITO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ADM
	    ADM->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DEL TOTAL
       cTxtPrn := REPL('-',aNroCol[06])
       lPrnReg(01,nColTxt(aNroCol,06),cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := TRANS(nVlrTot,'####,###,###')
       lPrnReg(01,nColTxt(aNroCol,06),cTxtPrn,bPagina,bDerAut,bCabeza)

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DEL TOTAL