/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES - ESTUDIANTE

**************************************************************************
* TITULO..: IMPRESION DE BOLETINES POR GRUPOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 22/2008 MIE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   OCT 22/2008 MIE

OBJETIVOS:

1- Imprime los Boletines por c¢digo del Estudiante.

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ContE_262(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL cSavLin := ''                  // Salvar linea

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL nCabIso := 0                   // Encabezado del Informe
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
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀGestion Documental

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		    // Detalles informes para www
       LOCAL lPrnCab := .T.                 // .T. Imprimir el Encabezado
       LOCAL aDetInf := {}                  // Detalles del Informe
     *ÀVariables de informe

       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL cTipBol := ''                  // Tipo de Boletin

       LOCAL cNomPro := ''                  // Nombre del profesor
       LOCAL cTitDos := ''                  // Profesor Titular Dos
       LOCAL aFirmas := {}                  // Firmas del libro

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
     *ÀVariables especificas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       AADD(aP2,{'nNroPer',nNroPer})
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSel+cMaeAct+ExtFile,'SEL',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxSel+cMaeAct+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat+ExtFile,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+cAnoSis+ExtFile,'JUI',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxInd+cMaeAct+cAnoSis+cExtNtx,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileApr,'APR',NIL,lShared,nModCry})
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
       SELECT &cMaeAct

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA        
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nPrnBolPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 206
       AADD(aP3,{'nNroInf',nNroInf})
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[PERIODOS][BOLETINES]'
       AADD(aP3,{'cOpcSys',cOpcSys})
     *ÀOpci¢n del sistema del informe

       cCodInf := 'SCO20600'
       AADD(aP3,{'cCodInf',cCodInf})
     *ÀC¢digo del Informe

       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
       AADD(aP3,{'aMarInf',aMarInf})
     *ÀM rgenes del informe

       nNroDoc := 0
       AADD(aP3,{'nNroDoc',nNroDoc})
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aP3,{'aMezIso',aMezIso})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'')                     // T¡tulo Uno
       AADD(aTitIso,'')                     // T¡tulo Dos
       AADD(aTitIso,'')                     // T¡tulo Tres
       AADD(aP3,{'aTitIso',aTitIso})
     *ÀT¡tulos del Informe por defecto

       cPiePag := xPrm(aP3,'cPieTre')
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
       AADD(aP3,{'aPieIso',aPieIso})
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aP3,{'aObsIso',aObsIso})

       cUsrIso := xPrm(aP3,'cUsrIso')
       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
       AADD(aP3,{'bInsIso',bInsIso})
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF nNroInf == 0
	  FilePrn := 'boleest'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,.T.)
       ELSE
	  FilePrn := 'boleest'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,2,bInsIso)
       ENDIF
       SET DEVICE TO SCREEN
       IF EMPTY(nOpcPrn)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       AADD(aP3,{'FilePrn',FilePrn})
       AADD(aP3,{'nOpcPrn',nOpcPrn})
       AADD(aP3,{'nHanXml',-1})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>CONFIGURACION GENERAL DE LA CONTABILIDAD
       AADD(aP2,{'cTxtTop',ALLTRIM(SCO->cTxtLibCon)+;
			   ALLTRIM(SCO->cTxtLi1Con)})

       AADD(aP2,{'cGerent',ALLTRIM(SCO->cGerentCon)})
       AADD(aP2,{'cCarGer',ALLTRIM(SCO->cCarGerCon)})
*>>>>FIN CONFIGURACION GENERAL DE LA CONTABILIDAD

*>>>>CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       cTipBol := SUBS(TCO->cTipBolTbl,nNroPer*2-1,2)

       AADD(aP2,{'lOficio',TCO->lOficioTbl})
       AADD(aP2,{'nLinEsp',TCO->nLinEspTbl})
       AADD(aP2,{'lPrnEmp',TCO->lPrnEmpTbl})
       AADD(aP2,{'nColEnc',TCO->nColEncTbl})
       AADD(aP2,{'nColBol',TCO->nColBolTbl})

       AADD(aP2,{'cTitReS',TCO->cTitReSTbl})
       AADD(aP2,{'cTitReN',TCO->cTitReNTbl})
       AADD(aP2,{'cTitRec',TCO->cTitRecTbl})
       AADD(aP2,{'cObsBol',TCO->cObsBolTbl})
       AADD(aP2,{'aFirmas',aFirmas})

       AADD(aP2,{'cTotAus',TCO->cTotAusTbl})
       AADD(aP2,{'cCfgBol',TCO->cCfgBolTbl})
       AADD(aP2,{'lNegAre',TCO->lNegAreTbl})
       AADD(aP2,{'nTotLin',TCO->nTotLinTbl})

       AADD(aP2,{'nTotPer',TCO->nTotPerTbl})
       AADD(aP2,{'nRecPer',TCO->nRecPerTbl})

       IF nNroPer == TCO->nTotPerTbl
	  AADD(aP2,{'cTitTop',TCO->cTi3BolTbl})
       ELSE
	  AADD(aP2,{'cTitTop',TCO->cTitBolTbl})
       ENDIF

       IF nNroPer == TCO->nTotPerTbl
	  IF EMPTY(ALLTRIM(TCO->cBolFinTbl))
	     AADD(aP2,{'cMsgBol',ALLTRIM(TCO->cMsgBolTbl)})
	  ELSE
	     AADD(aP2,{'cMsgBol',ALLTRIM(TCO->cBolFinTbl)})
	  ENDIF
       ELSE
	  AADD(aP2,{'cMsgBol',ALLTRIM(TCO->cMsgBolTbl)})
       ENDIF
     *ÀMensaje del Boletin

       AADD(aP2,{'cClaInd',TCO->cClaIndTbl})
       AADD(aP2,{'lIndNiv',TCO->lIndNivTbl})
       AADD(aP2,{'lPrnCod',TCO->lPrnCodTbl})
       AADD(aP2,{'cEvaInd',SUBS(TCO->cEvaIndTbl,nNroPer,1)})
       AADD(aP2,{'lNotNum',IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)})
       AADD(aP2,{'lPrnVar',IF(SUBS(TCO->cPrnVarTbl,nNroPer,1)='1',.T.,.F.)})
*>>>>FIN CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>PARAMETROS ESPECIFICOS
       AADD(aP2,{'cNroFol',''})

       AADD(aP2,{'cCodGru',''})
       AADD(aP2,{'cNomPro',''})
       AADD(aP2,{'cTitDos',''})

       AADD(aP2,{'cCodEst',''})
       AADD(aP2,{'cNomEst',''})
       AADD(aP2,{'nNroLis',''})
       AADD(aP2,{'nAprNot',''})

       AADD(aP2,{'aNotAre',''})
       AADD(aP2,{'aNotMat',''})
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>ANALISIS DE DECISION
       IF cCodEmp == 'COLSAN001001'  // Colegio La Salle. Bucaramanga

	 IF !EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND. nNroPer < TCO->nPerActTbl

	    IF lPregunta('DESEA IMPRIMIR LOS INDICADORES SUPERADOS? Si No')

	       nParameSet(aP2,'cCfgBol',STUFF(TCO->cCfgBolTbl,4,1,' '))
	     *ÀSPACE(01) Imprime los indicadores superados

	    ENDIF

	 ENDIF

       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES:',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS BOLETINES
       nNroFil++
       DO WHILE .T.

	  CloseDbf('PLA')
	  CloseDbf('NOT')

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   'PLAN'+SUBS(&cNalias->cCodigoGru,1,2)+;
			   cAnoSis+ExtFile,'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(&cNalias->cCodigoGru,1,2)))

	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    IF PLA->(RECCOUNT()) == 0
	       cError('NO EXISTEN PLAN ACADEMICO PARA GRUPO'+;
		      &cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+&cNalias->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      &cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',&cNalias->cCodigoEst)

	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+GRU->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO PERTENECE AL GRUPO '+GRU->cCodigoGru)

	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********LOCALIZACION DEL GRUPO
	    IF !lLocCodigo('cCodigoGru','GRU',&cNalias->cCodigoGru)
		cError('EL GRUPO '+&cNalias->cCodigoGru+ ' NO EXISTE')
		LOOP
	    ENDIF
**********FIN LOCALIZACION DEL GRUPO

**********LOCALIZACION DEL NOMBRE DEL TITULAR
	    cTitDos := 'NO EXISTE TITULAR2'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodProPro)

	       cTitDos := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)

	    ENDIF

	    cNomPro := 'NO EXISTE TITULAR'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro,;
			  'DEL PROFESOR TITULAR')

	       cNomPro := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)
			     
	    ENDIF
**********FIN LOCALIZACION DEL NOMBRE DEL TITULAR

**********SELECION DE LAS AREAS DE TRABAJO
	    IF cTipBol == '99' .AND. !EMPTY(PathTre)

	       FileCli := PathTre+'\'+cPatSis+;
			  '\CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared)
		  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
		  CloseDbf('CLI')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LINEA DE ESTADO
	    @ nNroFil,aNroCol[1] SAY cCodigoTes
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes

	    LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			cNombreTes+' '+GRU->cCodigoGru+;
			'ºFAVOR ESPERAR ...',cNomSis)
**********FIN LINEA DE ESTADO

**********DETALLE DE AREAS Y ASIGNATURAS
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroPer)
**********FIN DETALLE DE AREAS Y ASIGNATURAS

**********REEMPLAZO DE LAS ASIGNATURAS VARIABLES
	    IF SEL->(RECCOUNT()) # 0
	       lDetAreEst(@aNotAre,@aNotMat,nNroPer,cCodigoTes)
	    ENDIF
**********FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

**********PARAMETROS ESPECIFICOS
	    nParameSet(aP2,'cCodGru',GRU->cCodigoGru)
	    nParameSet(aP2,'cNomPro',cNomPro)
	    nParameSet(aP2,'cTitDos',cTitDos)

	    nParameSet(aP2,'cCodEst',NOT->cCodigoEst)
	    nParameSet(aP2,'cNomEst',cNombreTes)
	    nParameSet(aP2,'nNroLis',NOT->(RECNO()))
	    nParameSet(aP2,'nAprNot',NOT->nAproboNot)

	    nParameSet(aP2,'aNotAre',aNotAre)
	    nParameSet(aP2,'aNotMat',aNotMat)
**********FIN PARAMETROS ESPECIFICOS

**********IMPRESION DEL BOLETIN
	    DO CASE
	    CASE cTipBol == '96'

		 ScoBol_96(aP1,aP2,aP3)
	       *ÀBoletin Indice de cumplimiento. SalleBga. Periodos: 1-3

	    CASE cTipBol == '97'

		 ScoBol_97(aP1,aP2,aP3)
	       *ÀBoletin Indice de cumplimiento. SalleBga. Periodos: 4,5

	    ENDCASE
**********FIN IMPRESION DEL BOLETIN

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES:',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       VerPrn(nOpcPrn,FilePrn,xPrm(aP3,'nHanXml'))
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LOS BOLETINES

