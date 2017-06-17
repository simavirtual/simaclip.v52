/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : INDICADORES
SUBMODULO...: IMPRIMIR - CLASIFICACION

**************************************************************************
* TITULO..: IMPRIME LA CLASIFICACION DE LOS INDICADORES                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/2008 LUN A
       Colombia, Bucaramanga        INICIO:  04:30 PM  FEB 25/2008 LUN

OBJETIVOS:

1- Permite imprimir los indicadores clasificados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Spr_504_01(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior
       LOCAL cMsgTxt := ''                  // Texto temporal

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀVariables de informe

       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTma := ''               // C¢digo de la materia
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 fNroInd+cMaeAct+cAnoSis+ExtFile,'NRO',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileSin+cMaeAct+cAnoSis+ExtFile,'SIN',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FProTbl+cMaeAct+ExtFile,'TPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+ExtFile,'IND',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxInd+cMaeAct+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+;
			 fMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared,nModCry})
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
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS CLASES DE INDICADORES')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE INF->(RECCOUNT()) == 0
	    cError('NO SE HAN CREADO LOS INFORMES DEL SISTEMA')

       CASE MAP->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS DEL PROFESOR GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lHayErr := .F.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>SELECCION DE LA MATERIA
       SELECT MAP
       IF MAP->(RECCOUNT()) # 1

**********INICIALIZACION DE LAS COORDENADAS
	    nFilSup := nFilInf+2
	    nColSup := nColInf
	    IF nFilSup+RECCOUNT() > 22
	       nInfFil := 21
	    ELSE
	       nInfFil := nFilSup + RECCOUNT()-1
	    ENDIF
	    nInfCol := nColSup+LEN(MAP->cNombreMat)+2
**********FIN INICIALIZACION DE LAS COORDENADAS

**********BROWSE DE SELECCION
	    DO WHILE .T.
	       IF nBrowseDbf(nFilSup,02,nInfFil,78,;
			     {||MAP->cCodigoNiv+' '+MAP->cNombreMat}) == 0
		  CloseAll()
		  RETURN NIL
	       ENDIF
	       cMsgTxt := 'ESCOGIO '+ALLTRIM(MAP->cNombreMat)+;
			  IF(TCO->lIndNivTbl,' DEL NIVEL '+MAP->cCodigoNiv,'')
	       cMsgTxt := SUBS(cMsgTxt,1,50)

	       IF lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
		  EXIT
	       ENDIF
	    ENDDO
**********FIN BROWSE DE SELECCION

       ENDIF
       cCodigoTni := MAP->cCodigoNiv
       cCodigoTma := MAP->cCodigoMat

       AADD(aP3,{'cCodNiv',cCodigoTni})
       AADD(aP3,{'cCodMat',cCodigoTma})
*>>>>FIN SELECCION DE LA MATERIA

*>>>>LOCALIZACION DE LA MATERIA GENERAL
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,'DE LA MATERIA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA GENERAL

*>>>>FILTRACION DE LA CLASIFICACION
       SELECT SIN
       SET FILTER TO SIN->cCodGruSin == cCodigoTni+'00' .AND.;
		     SIN->cCodMatSin == cCodigoTma

       SIN->(DBGOTOP())
       IF SIN->(EOF())
	  cError('NO ESTAN CLASIFICADOS LOS INDICADORES')
	  SET FILTER TO
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LA CLASIFICACION

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 50401
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[INDICACADORES][IMPRIMIR]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'S5040100'
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
       AADD(aTitIso,'CLASIFICACION DE LOGROS E INDICADORES.'+;
		    'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')     // T¡tulo Uno
       AADD(aTitIso,cCodigoTma+':'+ALLTRIM(MAT->cNombreMat)) // T¡tulo Dos
       AADD(aTitIso,'NIVEL:'+cCodigoTni)                     // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := SPR->cPiePagSpr
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
       AADD(aObsIso,'LOGROS E INDICADORES')

       cUsrIso := SPR->cUsrIsoSpr
       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       IF nNroInf # 0
	  cCodIso := ALLTRIM(ISO->cCodigoIso)
	  cFecIso := ALLTRIM(ISO->cFecAprIso)
	  cVerIso := ALLTRIM(ISO->cNroVerIso)
       ENDIF
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF nNroInf == 0
	  FilePrn := 'Ind'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.,.T.)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.,2,bInsIso)
       ENDIF
       IF EMPTY(nOpcPrn)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       fDocPrn := ''
       IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
		      @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
		      @fDocPrn)
	  CloseAll()
	  RETURN NIL
       ENDIF
       ReplTitIso(@aTitIso,aMezIso)
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>PARAMETROS DEL INFORME
       AADD(aP3,{'nCodXsl',SPR->nCodXslSpr})
       AADD(aP3,{'nOpcPrn',nOpcPrn})
       AADD(aP3,{'FilePrn',FilePrn})

       AADD(aP3,{'nLenPrn',nLenPrn})
       AADD(aP3,{'nNroInf',nNroInf})
       AADD(aP3,{'cOpcSys',cOpcSys})
       AADD(aP3,{'cCodInf',cCodInf})
       AADD(aP3,{'aMarInf',aMarInf})
       AADD(aP3,{'nNroDoc',nNroDoc})
       AADD(aP3,{'aTitIso',aTitIso})
       AADD(aP3,{'aPieIso',aPieIso})
       AADD(aP3,{'aObsIso',aObsIso})
       AADD(aP3,{'cUsrIso',cUsrIso})
       AADD(aP3,{'cCodIso',cCodIso})
       AADD(aP3,{'cFecIso',cFecIso})
       AADD(aP3,{'cVerIso',cVerIso})
*>>>>FIN PARAMETROS DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       DO CASE
       CASE cCodInf == 'S5040100'

	    S_50401_00(aP1,aP2,aP3)
	   *Versi¢n por defecto


       OTHERWISE
	    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
       ENDCASE
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CONTROL DE DOCUMENTOS
