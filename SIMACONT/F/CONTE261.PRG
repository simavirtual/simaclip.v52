/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES - POR GRUPOS

**************************************************************************
* TITULO..: IMPRESION DE BOLETINES POR GRUPOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 17/2008 VIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 17/2008 VIE

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los boletines de los estudiantes

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ContE_261(aP1,aP2,aP3)

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
       LOCAL nTipPrn := 0                   // Tipo de Impresi¢n 1=>Por Grupos 2=>Repetir Boletines

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial

       LOCAL cNomPro := ''                  // Nombre del profesor
       LOCAL cTitDos := ''                  // Profesor Titular Dos
       LOCAL aFirmas := {}                  // Firmas del libro

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
     *ÀVariables Especificas

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cBoletiTes := ''               // Campo de Repetir Boletines
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

*>>>>LECTURA DEL TIPO DE IMPRESION
       nTipPrn := nLeeOpcion('ENTRE EL TIPO DE IMPRESION.: '+;
		 '1<POR GRUPOS> 2<REPETIR> 3<ABANDONAR>?',3,'0')

       IF nTipPrn == 3
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE IMPRESION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

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
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,.T.)
       ELSE
	  FilePrn := cCodInf
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

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nRegFin))
       cGruFin := GRU->cCodigoGru

       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   'PLAN'+SUBS(GRU->cCodigoGru,1,2)+cAnoSis+ExtFile,;
			   'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    IF PLA->(RECCOUNT()) == 0
	       cError('NO EXISTEN PLAN ACADEMICO PARA GRUPO'+GRU->cCodigoGru)
	       CloseDbf('PLA')
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CloseAll()
	      RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL NOMBRE DEL TITULAR
	    cNomPro := 'NO EXISTE TITULAR'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro,;
			  'DEL PROFESOR TITULAR')

	       cNomPro := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)
			     
	    ENDIF

	    cTitDos := 'NO EXISTE TITULAR2'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodProPro)

	       cTitDos := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)

	    ENDIF
**********FIN LOCALIZACION DEL NOMBRE DEL TITULAR

**********SELECION DE LAS AREAS DE TRABAJO
	    IF cTipBol == '99' .AND. !EMPTY(PathTre)

	       FileCli := PathTre+'\'+cPatSis+;
			  '\CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared)
		  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********DETALLE DE AREAS Y ASIGNATURAS
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroPer)
**********FIN DETALLE DE AREAS Y ASIGNATURAS

**********PARAMETROS ESPECIFICOS
	    nParameSet(aP2,'cCodGru',GRU->cCodigoGru)
	    nParameSet(aP2,'cNomPro',cNomPro)
	    nParameSet(aP2,'cTitDos',cTitDos)

	    nParameSet(aP2,'aNotAre',aNotAre)
	    nParameSet(aP2,'aNotMat',aNotMat)
**********FIN PARAMETROS ESPECIFICOS

**********RECORRIDO POR NOTAS
	    SELECT NOT
	    NOT->(DBGOTO(nNroIni))
	    DO WHILE .NOT. NOT->(EOF())

*==============LINEA DE ESTADO
		 LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			     'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)
*==============FIN LINEA DE ESTADO

*==============ANALISIS PARA LA SALIDA
		 SELECT NOT
		 IF nNroFin <> 0
		    IF NOT->(RECNO()) > nNroFin
		       EXIT
		    ENDIF
		 ENDIF
*==============FIN ANALISIS PARA LA SALIDA

*==============ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============ANALISIS DEL PERIODO DEL RETIRO
		 lRetiroTes := &cMaeAct->lRetiroEst
		 IF lRetiroTes
		    IF nNroPer <= &cMaeAct->nPerRetEst
		       lRetiroTes := .F.
		    ENDIF
		 ENDIF
*==============FIN ANALISIS DEL PERIODO DEL RETIRO

*==============ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF lRetiroTes
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*==============REEMPLAZO DE LAS ASIGNATURAS VARIABLES
		 IF SEL->(RECCOUNT()) # 0
		    lDetAreEst(@aNotAre,@aNotMat,nNroPer,NOT->cCodigoEst)
		 ENDIF
*==============FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

*==============ANALISIS DE LA REPETICION DEL BOLETIN
		 cBoletiTes := SUBS(&cMaeAct->cBoletiEst,nNroPer*2-1,2)
		 IF nTipPrn == 2

		    IF SUBS(cBoletiTes,1,1) # '1' .OR.;
		       SUBS(cBoletiTes,2,1) # SPACE(01)

		       SELECT NOT
		       NOT->(DBSKIP())
		       LOOP

		    ENDIF
		 ENDIF
*==============FIN ANALISIS DE LA REPETICION DEL BOLETIN

*==============PARAMETROS ESPECIFICOS
		 nParameSet(aP2,'cCodEst',NOT->cCodigoEst)
		 nParameSet(aP2,'cNomEst',cNombreTes)
		 nParameSet(aP2,'nNroLis',NOT->(RECNO()))
		 nParameSet(aP2,'nAprNot',NOT->nAproboNot)
*==============FIN PARAMETROS ESPECIFICOS

*==============IMPRESION DEL BOLETIN
		 DO CASE
		 CASE cTipBol == '96'

		      ScoBol_96(aP1,aP2,aP3)
		    *ÀBoletin Indice de cumplimiento. SalleBga. Periodos: 1-3

		 CASE cTipBol == '97'

		      ScoBol_97(aP1,aP2,aP3)
		    *ÀBoletin Indice de cumplimiento. SalleBga. Periodos:4,5

		 ENDCASE
*==============FIN IMPRESION DEL BOLETIN

*==============GRABACION DE LA REPETICION DEL BOLETIN
		 IF nTipPrn == 2

		    SELECT &cMaeAct
		    cBoletiTes := STUFF(cBoletiTes,2,1,'1')
		    cBoletiTes := STUFF(&cMaeAct->cBoletiEst,;
					nNroPer*2-1,2,cBoletiTes)

		    IF lRegLock(lShared,.F.)
		       REPL &cMaeAct->cBoletiEst WITH cBoletiTes
		       DBCOMMIT()
		    ELSE
		       cError('NO SE GRABA EL REGISTRO REPETIR BOLETINES')
		    ENDIF
		    IF lShared
		       DBUNLOCK()
		    ENDIF
		 ENDIF
*==============FIN GRABACION DE LA REPETICION DEL BOLETIN

	       NOT->(DBSKIP())

	    ENDDO
	    CloseDbf('NOT')
**********FIN RECORRIDO POR NOTAS

**********AVANCE AL SIGUIENTE REGISTRO
	    nNroIni := 1
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       VerPrn(nOpcPrn,FilePrn,xPrm(aP3,'nHanXml'))
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS