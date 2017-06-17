/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: SIMAUSB

**************************************************************************
* TITULO..: MENU UTILIDADES SIMAUSB                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 24/2008 SAB A
       Colombia, Bucaramanga        INICIO:  12:00 AM  MAY 24/2008 SAB

OBJETIVOS:

1- Visualiza un men£ de utilidades del SIMAUSB

2- Ejecuta las diferentes opciones

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_709(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE PARAMETROS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cUnidad := ''                  // Unidad de la Usb
       LOCAL cPatUsb := ''                  // Path del SimaUsb sin Unidad
       LOCAL PathUsb := ''                  // Path del SimaUsb con Unidad
       LOCAL FileUsb := ''                  // Archivo SimaUsb

       LOCAL PathAct := ''                  // Path Actual

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA UNIDAD USB
       PathAct := cPathAct()
       DO WHILE .T.

	  cUnidad := SPACE(01)
	  @ nFilInf+1,nColInf SAY 'UNIDAD DE LA USB:';
			      GET cUnidad PICT '@! A';
			      WHEN {||HelpRead('FAVOR INGRESE LA LETRA '+;
				    'DE LA UNIDAD DONDE ESTA INSTALADA LA USB')}
	  READ

	  lHayErr := .T.
	  DO CASE

	  CASE cUnidad == 'C'
	       cError('NO PUEDE SER LA UNIDAD '+'C:')

	  CASE !EMPTY(cUnidad) .AND. SUBS(PathAct,1,2) == cUnidad+':'
	       cError('NO PUEDE SER LA MISMA UNIDAD '+cUnidad+':')

	  CASE !EMPTY(cUnidad) .AND. DIRCHANGE(cUnidad+':\') # 0
	       cError('LA UNIDAD '+cUnidad+' NO LA RECONOCE EL SISTEMA')

	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE
	  IF lHayErr
	     LOOP
	  ENDIF

	  EXIT

       ENDDO
       IF EMPTY(cUnidad)
	  RETURN NIL
       ENDIF

       cUnidad += ':'
*>>>>FIN LECTURA DE LA UNIDAD USB

*>>>>CREACION DE DIRECTORIOS DE SIMAUSB
       cPatUsb := 'SIMA\SIMAPROF'
       PathUsb := cUnidad+'\'+cPatUsb

       Mdir(PathUsb+'\'+PathSis,PathAct)
       Mdir(PathUsb+'\'+cPatSis,PathAct)
     *ÀDirectorios del Sima
*>>>>FIN CREACION DE DIRECTORIOS DE SIMAUSB

*>>>>COPIA ARCHIVOS SIMAUSB
       FileUsb := 'simaprof.exe'
       IF !FILE(PathUsb+'\'+FileUsb)
	  IF FILECOPY(FileUsb,;
		      PathUsb+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := 'DATO0103.DAT'
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := 'TEMP.DAT'
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := fSimSpr
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := FileClr
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := FilePrn
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := FileIso
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := FileInf
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := fSimSpr
       IF !FILE(PathUsb+'\'+PathSis+'\'+FileUsb)
	  IF FILECOPY(PathSis+'\'+FileUsb,;
		      PathUsb+'\'+PathSis+'\'+FileUsb) == 0
	     lHayErr := .T.
	  ENDIF
       ENDIF

       FileUsb := fSprAno+cAnoUsr+ExtFile
       IF !FILE(PathUsb+'\'+cPatSis+'\'+FileUsb)

	  IF FILECOPY(cPatSis+'\'+FileUsb,;
		      PathUsb+'\'+cPatSis+'\'+FileUsb) == 0

	     lHayErr := .T.
	  ENDIF
       ENDIF
*>>>>FIN COPIA DEL SISTEMA

*>>>>AREAS DE TRABAJO
       IF !lHayErr
	  aUseDbf := {}

	  AADD(aUseDbf,{.T.,cUnidad+'\'+cPatUsb+'\'+PathSis+'\'+;
			   fSimSpr,'SPR',NIL,lShared,nModCry})

	  AADD(aUseDbf,{.T.,cUnidad+'\'+cPatUsb+'\'+cPatSis+'\'+;
			   fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared,nModCry})

	  AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			    FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       ENDIF
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lHayErr
	  IF !lUseDbfs(aUseDbf)
	     cError('ABRIENDO ARCHIVOS')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF !lHayErr .AND. !EMPTY(SPR->cCodProSpr)

	  IF !EMPTY(SPR->cCodProSpr) .AND. cCodPro # SPR->cCodProSpr
	     cError('LA MEMORIA USB FIGURA DE '+ALLTRIM(SPR->cNomProSpr))
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>GRABACION CONFIGURACION GENERAL
       IF !lHayErr

	  SELECT SPR
	  IF SPR->(lRegLock(lShared,.F.))

	     REPL SPR->cAnoUsrSpr WITH cAnoUsr

	     REPL SPR->lMemUsbSpr WITH .T.
	     REPL SPR->cUnidadSpr WITH SUBS(PathAct,1,2)
	     REPL SPR->cCodProSpr WITH cCodPro
	     REPL SPR->cNomProSpr WITH cNomPro

	     SPR->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABO EL REGISTRO')
	     lHayErr := .T.
	  ENDIF
	  IF lShared
	     SPR->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION CONFIGURACION GENERAL

*>>>>GRABACION CONFIGURACION DEL A¥O
       IF !lHayErr

	  SELECT PRA
	  IF PRA->(lRegLock(lShared,.F.))

	     REPL PRA->cMaeHabAno WITH PRO->cMaeAluPro
	     REPL PRA->cJorHabAno WITH cJornad

	     PRA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABO EL REGISTRO')
	     lHayErr := .T.
	  ENDIF
	  IF lShared
	     PRA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION CONFIGURACION DEL A¥O

*>>>>ANALISIS DE DECISION
       IF lHayErr
	  cError('NO SE CREO EL SISTEMA CORRECTAMENTE','ERROR')
       ELSE
	  cError('COPIA EXITOSA EN LA UNIDIAD:'+cUnidad)
       ENDIF
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ANALISIS DE DECISION
