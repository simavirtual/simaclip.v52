/* SIMA - CONTABILIDAD PROFESORES

MODULO      : INDICADORES
SUBMODULO...: IMPRIMIR - ASOCIADOS

**************************************************************************
* TITULO..: INFORME DE INDICADORES ASOCIADOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 28/2009 JUE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 28/2009 JUE


OBJETIVOS:

1- Permite imprimir los indicadores del profesor clasificados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_510(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE PARAMETROS
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
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

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

       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCodigoTcl := ''               // C¢digo de la clase

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

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
	  CloseAll()
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

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES GRABADOS')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE MAP->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS DEL PROFESOR GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>SELECCION DE LA MATERIA
       IF nSelMap(nFilInf+1,00) == 0
	  CloseAll()
	  RETURN NIL
       ENDIF

       cMsgTxt := 'ESCOGIO '+ALLTRIM(MAP->cNombreMat)+;
		  IF(TCO->lIndNivTbl,' DEL NIVEL '+MAP->cCodigoNiv,'')
       cMsgTxt := SUBS(cMsgTxt,1,50)

       IF !lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
       cCodigoTni := MAP->cCodigoNiv
       cCodigoTma := MAP->cCodigoMat
*>>>>FIN SELECCION DE LA MATERIA

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(CLA->cNombreCla)
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>SELECCION DE LA CLASE DE INDICADOR
      SELECT CLA
      DO WHILE .T.
	 IF nSelRegDbf(nFilInf+1,nColInf-1,'CLA','cNombreCla') == 0
	    CloseAll()
	    RETURN NIL
	 ENDIF
	 IF lPregunta('ESCOGIO '+ALLTRIM(CLA->cNombreCla)+;
	    ' DESEA CONTINUAR? Si No')
	    EXIT
	 ENDIF
      ENDDO
      cCodigoTcl := CLA->cCodigoCla
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

*>>>>SELECION DE LA MATERIA O AREA A GRABAR
       IF EMPTY(CLA->cCodigoMat)
	  IF UPPER(CLA->cCodigoCla) == 'A'
	     cCodigoTma := SUBS(MAP->cCodigoMat,1,2)+'00'
	  ELSE
	     cCodigoTma := MAP->cCodigoMat
	  ENDIF
       ELSE
	  cCodigoTma := CLA->cCodigoMat
	  cCodigoTni := SPACE(02)
       ENDIF
*>>>>FIN SELECION DE LA MATERIA O AREA A GRABAR

*>>>>LOCALIZACION DE LA MATERIA GENERAL
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	  cError('NO SE ENCUENTRA EL CODIGO '+cCodigoTma+' '+;
		 'PARA GRABACION GENERAL')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA GENERAL

*>>>>FILTRACION DE LOS INDICADORES
       SELECT IND
       IF TCO->lIndNivTbl
	  SET FILTER TO SUBS(IND->cCodigoJui,1,4) == cCodigoTma .AND.;
			IND->cCodigoNiv == cCodigoTni
       ELSE
	  SET FILTER TO SUBS(IND->cCodigoJui,1,4) == cCodigoTma
       ENDIF
       IND->(DBGOTOP())
       IF IND->(EOF())
	  cError('NO HAY INDICADORES '+;
		 IF(TCO->lIndNivTbl,'DE NIVEL','DE MATERIA')+' '+;
		 'PARCIALES PARA '+ALLTRIM(MAT->cNombreMat)+' '+;
		 'DE '+ALLTRIM(CLA->cNombreCla))
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS INDICADORES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 50402
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[INDICACADORES][IMPRIMIR]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'S5040200'
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
       AADD(aTitIso,'LOGROS E INDICADORES PROVISIONALES.'+;
		    'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')     // T¡tulo Uno
       AADD(aTitIso,cCodigoTma+':'+ALLTRIM(MAT->cNombreMat)) // T¡tulo Dos
       AADD(aTitIso,'NIVEL:'+MAP->cCodigoNiv)                     // T¡tulo Tres
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

       nParameSet(aP3,'aTitIso',aTitIso)
*>>>>FIN PARAMETROS DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       DO CASE
       CASE cCodInf == 'S5040200'

	    S_50402_00(aP1,aP2,aP3)
	   *Versi¢n por defecto

       OTHERWISE
	    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
       ENDCASE
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CONTROL DE DOCUMENTOS


