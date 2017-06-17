/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: LISTAS DE CLASE     MODULO No. 609

**************************************************************************
* TITULO..: MENU PARA LISTAS DE CLASE                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/1995 MIE A
       Bucaramanga, Colombia	    INICIO: 09:25 AM   ENE 25/1995 MIE

OBJETIVOS:

1- Visualiza el men£ para la impresi¢n de las listas de clase

2- Ejecuta las diferentes funciones para las listas de clase

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_609(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL     i,j := 0                   // Contadores
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       FIELD cCodigoGru                     // C¢digo del Grupo
       FIELD cNombreEst                     // Nombre del Estudiante
       FIELD cApelliEst                     // Apellido del Estudiante

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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)

       cNalias := cMaeAct
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis,lAnoAct)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES MATRICULADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE ANO->nTipLisAno <> 0 .AND. ANO->nTipLisAno <> 1 .AND.;
	    ANO->nTipLisAno <> 99
	    cError('TIPO DE LISTA NO PERMITIDO. '+STR(ANO->nTipLisAno,2))

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 609
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<MATRICULAS><LISTAS CLASE>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'LISTA DE CLASE PROVISIONAL.'+;
		    'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Lista'+cMaeAct
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,.F.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<POR GRUPOS >',;
		   '2<POR NIVELES>'}
       aAyuda := {'Imprime las listas de clase provisionales por grupos',;
		  'Imprime las listas de clase provisionales por niveles'}

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL ARCHIVO
       fNtxTem := SUBS(cNomUsr,1,3)+FileTem+cExtNtx
       IF FILE(FileTem)
	  cError(cNomUsr+;
		 ' ESTA IMPRIMIENDO. NO PUEDE UTILIZAR EL MISMO USUARIO')
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>INDEXACION DEL ARCHIVO
       SELECT &cNalias
       SAVE SCREEN
       Termometro(0,'ORDENANDO POR APELLIDO')
       Termometro(50)
       INDEX ON cCodigoGru+;
		cApelliEst+;
		cNombreEst TO &fNtxTem
       Termometro(100)
       RESTORE SCREEN
       IF lShared
	  DBSETINDEX(fNtxTem)
       ELSE
	  SET INDEX TO &fNtxTem
       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Matri_691(aParam1,aParam2,aParam3,;
		      cOpcSys,nNroIso,cCodIso,aTitIso,;
		      cPiePag,aPieIso,nTotPie,aMezIso,;
		      bInsIso)
	   *Listas de Clase por grupos

       CASE nNroOpc == 2
	    Matri_692(aParam1,aParam2,aParam3,;
		      cOpcSys,nNroIso,cCodIso,aTitIso,;
		      cPiePag,aPieIso,nTotPie,aMezIso,;
		      bInsIso)
	   *Listas de clase por niveles

       ENDCASE
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       IF !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO INDICE TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO..: IMPRESION DE LA LISTA DE CLASE                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/1994 MAR A
       Bucaramanga, Colombia	    INICIO: 10:00 AM   DIC 06/1994 MAR

OBJETIVOS:

1- Imprime imprime una lista de clase por defecto del sistema.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListaPrv00(cCodGru,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
		    cOpcSys,nNroIso,cCodIso,aTitIso,cPiePag,aPieIso,nTotPie,;
		    aMezIso,bInsIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       cOpcSys                              // Opci¢n del Sistema
       nNroIso                              // N£mero Iso del Informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       cPiePag                              // Pie de P gina por defecto
       aPieIso      		            // Textos del pie de p gina
       nTotPie                              // Total de Pie de p ginas
       aMezIso                              // Campos a Mesclar
       bInsIso                              // Block de Gestion Documental */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL bDerAut := NIL                 // Block Derechos de Autor

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''                  // Nombre del estudiante
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VARIABLES PARA EL ENCABEZADO DEL INFORME
       SELECT &cMaeAct

       COUNT FOR cCodigoGru == cCodGru TO nTotReg
      *Total de registros a imprimir
*>>>>FIN VARIABLES PARA EL ENCABEZADO DEL INFORME

*>>>>PIE DE PAGINA
       nLenPrn := PCL('n17Stan')
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN PIE DE PAGINA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis+cCodIso,;
			    aTitIso[1],;
			    aTitIso[2],;
			    'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
						 SUBS(cCodGru,3,2),;
			    nNroPag++,;
			    cTotPagina(nTotReg))

		 SendCodes(PCL('CondenOn'))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,44,02,06,06,06,06,06,06,06,06,06,06,04,02}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     'GR',;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     'AUSE',;
			     'No'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 SendCodes(PCL({'DraftOn','Pica'}))
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 SendCodes(PCL({'NegraOf','DobGolOf'}))
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,44)

	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,44,74,04,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O',;
			     SPACE(04),;
			     STR(i,2)}

	    OTHERWISE
		 aNroCol := {02,06,44,02,06,06,06,06,06,;
			     06,06,06,06,06,04,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     SPACE(02),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(04),;
			     STR(i,2)}
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    i++
	    @ PROW()+1,00 SAY cTxtPrn
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION DE LA LISTA DE CLASE                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2007 MAR A
       Bucaramanga, Colombia	    INICIO: 05:45 PM   DIC 06/2007 MAR

OBJETIVOS:

1- Imprime imprime una lista de clase por defecto del sistema sin
   sin encabezado, y orientada a impresi¢n laser.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListaPrv01(cCodGru,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
		    cOpcSys,nNroIso,cCodIso,aTitIso,cPiePag,aPieIso,nTotPie,;
		    aMezIso,bInsIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       cOpcSys                              // Opci¢n del Sistema
       nNroIso                              // N£mero Iso del Informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       cPiePag                              // Pie de P gina por defecto
       aPieIso      		            // Textos del pie de p gina
       nTotPie                              // Total de Pie de p ginas
       aMezIso                              // Campos a Mesclar
       bInsIso                              // Block de Gestion Documental */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL bDerAut := NIL                 // Block Derechos de Autor

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''                  // Nombre del estudiante
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VARIABLES PARA EL ENCABEZADO DEL INFORME
       SELECT &cMaeAct

       COUNT FOR cCodigoGru == cCodGru TO nTotReg
      *Total de registros a imprimir
*>>>>FIN VARIABLES PARA EL ENCABEZADO DEL INFORME

*>>>>PIE DE PAGINA
       nLenPrn := PCL('n17Stan')
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN PIE DE PAGINA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 @ PROW()+ANO->nLinEspAno,00 SAY ''
	       *ÀEspacio para el encabezado

		 EncabezPrn('','',;
			    aTitIso[1],;
			    aTitIso[2],;
			    'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
						 SUBS(cCodGru,3,2)+;
			    '.JORNADA '+cJorTxt+'.A¥O:'+cAnoUsr,;
			    nNroPag++,;
			    cTotPagina(nTotReg))

		 SendCodes(PCL('CondenOn'))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,44,02,06,06,06,06,06,06,06,06,06,06,04,02}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     'GR',;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     'AUSE',;
			     'No'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 SendCodes(PCL({'DraftOn','Pica'}))
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 SendCodes(PCL({'NegraOf','DobGolOf'}))
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,44)

	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,44,74,04,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     'R      E      T      I      R      A      D      O',;
			     SPACE(04),;
			     STR(i,2)}

	    OTHERWISE
		 aNroCol := {02,06,44,02,06,06,06,06,06,;
			     06,06,06,06,06,04,02}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     SPACE(02),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(06),;
			     SPACE(04),;
			     STR(i,2)}
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    i++

	    SendCodes(PCL('SubryOn'))
	    @ PROW()+1,00 SAY cTxtPrn
	    SendCodes(PCL('SubryOf'))
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION DE LA LISTA DE CLASE                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/1994 MAR A
       Bucaramanga, Colombia	    INICIO: 10:00 AM   DIC 06/1994 MAR

OBJETIVOS:

1- Imprime imprime una lista de clase por defecto del sistema.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ListaPrv99(cCodGru,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
		    cOpcSys,nNroIso,cCodIso,aTitIso,cPiePag,aPieIso,nTotPie,;
		    aMezIso,bInsIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       cOpcSys                              // Opci¢n del Sistema
       nNroIso                              // N£mero Iso del Informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       cPiePag                              // Pie de P gina por defecto
       aPieIso      		            // Textos del pie de p gina
       nTotPie                              // Total de Pie de p ginas
       aMezIso                              // Campos a Mesclar
       bInsIso                              // Block de Gestion Documental */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL bDerAut := NIL                 // Block Derechos de Autor

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''                  // Nombre del estudiante
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VARIABLES PARA EL ENCABEZADO DEL INFORME
       SELECT &cMaeAct

       COUNT FOR cCodigoGru == cCodGru TO nTotReg
      *Total de registros a imprimir
*>>>>FIN VARIABLES PARA EL ENCABEZADO DEL INFORME

*>>>>PIE DE PAGINA
       nLenPrn := PCL('n17Stan')
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN PIE DE PAGINA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis+cCodIso,;
			    aTitIso[1],;
			    aTitIso[2],;
			    'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
						 SUBS(cCodGru,3,2),;
			    nNroPag++,;
			    cTotPagina(nTotReg))

		 SendCodes(PCL('CondenOn'))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {02,06,44,02,20}
		 aTitulo := {'No',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ',;
			     'GR','OBSERVACIONES'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 SendCodes(PCL({'DraftOn','Pica'}))
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 SendCodes(PCL({'NegraOf','DobGolOf'}))
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,44)

	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 aNroCol := {02,06,44,02,20}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     ' ',;
			     'RETI'}

	    OTHERWISE
		 aNroCol := {02,06,44,02,20}
		 aTitulo := {STR(i,2),;
			     &cMaeAct->cCodigoEst,;
			     cNombreTes,;
			     SPACE(02),;
			     SPACE(06)}
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion
	    i++
	    @ PROW()+1,00 SAY cTxtPrn
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS