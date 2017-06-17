/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: INDICADORES APLICADOS

**************************************************************************
* TITULO..: IMPRIME EL RESUMEN DE INDICADORES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2008 MAR A
       Colombia, Bucaramanga        INICIO: 04:15 PM   MAR 01/2008 MAR


OBJETIVOS:

1- Permite imprimir el resumen de Indicadores.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_103(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL cEvaInd := ''                  // Evaluar el Indicador
       LOCAL lEvaInd := .F.                 // .T. Evaluar el Indicador
       LOCAL lHayNot := .F.                 // .T. Hay nota definitiva
       LOCAL lNotNum := .F.                 // .T. Nota N£merica .F. Nota Cualitativa
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL lPrnLin := .F.                 // .T. L¡nea Separadora

       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
     *ÀVariables especificas
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
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
			 PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})


       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})


       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES DE LA CONTABILIDAD')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')
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

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lIndNiv := TCO->lIndNivTbl
       cEvaInd := SUBS(TCO->cEvaIndTbl,nNroPer,1)
       lEvaInd := IF(SUBS(cEvaInd,nNroPer,1)='0',.F.,.T.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       IF lNotNum
	  cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
       ELSE
	  IF EMPTY(TCO->cValNumTbl)
	     cValNot := ALLTRIM(TCO->cValNotTbl)+SPACE(01)
	  ELSE
	     cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,TCO->nTotPerTbl)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECCION DE LA CLASE DE INDICADOR
      SELECT CLA
      DO WHILE .T.
	 IF nSelRegDbf(nFilInf+1,nColInf-1,'CLA','cNombreCla') # 0
	    IF !lPregunta('ESCOGIO '+ALLTRIM(CLA->cNombreCla)+;
	       ' DESEA CONTINUAR? Si No')
	       CloseAll()
	       RETURN NIL
	    ENDIF
	    EXIT
	 ELSE
	     IF !lPregunta('ESCOGIO TODOS LOS INDICADORES. '+;
			   'DESEA CONTINUAR? No Si')
		CloseAll()
		RETURN NIL
	     ENDIF
	     CLA->(DBGOTO(CLA->(RECCOUNT())+1))
	    *Se Ubica al final del Archivo
	     EXIT
	 ENDIF
      ENDDO
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

*>>>>ANALISIS DE LA IMPRESION DE LA EVALUACION DEL INDICADOR
       IF lEvaInd
	  lEvaInd := lPregunta('DESEA IMPRIMIR EL RESUMEN '+;
			       'CON LA EVALUACION DE LOS INDICADORES? Si No')
       ENDIF
       lPrnLin := lPregunta('DESEA IMPRIMIR LA LINEA SEPRADORA? No Si')
*>>>>FIN ANALISIS DE LA IMPRESION DE LA EVALUACION DEL INDICADOR

*>>>>SELECCION DE LA EVALUACION DEL INDICADOR
      IF lEvaInd
	 SELECT EVA
	 DO WHILE .T.
	    IF nSelRegDbf(nFilInf+1,nColInf-1,'EVA','cNombreEva') # 0
	       IF !lPregunta('ESCOGIO '+ALLTRIM(EVA->cNombreEva)+;
		  ' DESEA CONTINUAR? Si No')
		  CloseAll()
		  RETURN NIL
	       ENDIF
	       EXIT
	    ELSE
		IF !lPregunta('ESCOGIO TODOS LAS EVALUACIONES. '+;
			      'DESEA CONTINUAR? No Si')
		   CloseAll()
		   RETURN NIL
		ENDIF
		EVA->(DBGOTO(EVA->(RECCOUNT())+1))
	       *Se Ubica al final del Archivo
		EXIT
	    ENDIF
	 ENDDO
       ELSE
	  lLocCodigo('cCodigoEva','EVA',SPACE(01))
	 *Permite localizar los indicadores
       ENDIF
*>>>>FIN SELECCION DE LA EVALUACION DEL INDICADOR

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervCaP(nFilInf+1,01,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
       SELECT CAP
       CAP->(DBGOTO(nRegIni))
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 103
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[LISTAS][INDICADORES APLICADOS]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'Spr10300'
       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID

       nNroDoc := 0
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aMezIso,{'<nNroPer>',STR(nNroPer,1)})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'RESUMEN DE INDICADORES.')               // T¡tulo Uno

       AADD(aTitIso,SUBS(CAP->cCodigoCar,1,4)+':'+;
		    ALLTRIM(CAP->cNombreMat))                // T¡tulo Dos

       AADD(aTitIso,'GRUPO:'+SUBS(CAP->cCodigoCar,5,4)+' '+;
		    'A¥O: <cAnoUsr> '+;
		    'JORNADA:<cJorTxt> '+;
		    'PERIODO No.<nNroPer>')                  // T¡tulo Tres
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
       AADD(aObsIso,'')

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
	  FilePrn := 'ResumInd'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.,.T.)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.,2,bInsIso)
       ENDIF
       IF EMPTY(nOpcPrn)
	  CloseAll()
	  RETURN NIL
       ENDIF
       SET DEVICE TO SCREEN
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

*>>>>ASIGNACION ACADEMICA DEL PROFESOR
       DO WHILE CAP->(RECNO()) <= nRegFin

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR')

	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE NOP->(RECCOUNT()) == 0
		 cError('NO EXISTEN ESTUDIANTES')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********TITULOS DEL INFORME
	    aTitIso[2] := SUBS(CAP->cCodigoCar,1,4)+':'+;
			  ALLTRIM(CAP->cNombreMat)
	  *ÀT¡tulo Dos

	    aTitIso[3] := 'GRUPO:'+SUBS(CAP->cCodigoCar,5,4)+' '+;
			  'A¥O: <cAnoUsr> '+;
			  'JORNADA:<cJorTxt> '+;
			  'PERIODO No.<nNroPer>'
	  *ÀT¡tulo Tres
	    ReplTitIso(@aTitIso,aMezIso)

	    nParameSet(aP3,'aTitIso',aTitIso)
**********FIN TITULOS DEL INFORME

**********CONTROL DE DOCUMENTOS
	    DO CASE
	    CASE cCodInf == 'Spr10300'

		  nHanXml := SPR_10300(aP1,aP2,aP3,;
				       nNroPer,;
				       SUBS(CAP->cCodigoCar,1,4),cNomPro,;
				       SUBS(CAP->cCodigoCar,5,4),;
				       ALLTRIM(CAP->cNombreMat),;
				       lIndNiv,cEvaInd,lEvaInd,;
				       lHayNot,lNotNum,lPrnLin)
		*Versi¢n por defecto

	    OTHERWISE
		 cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
	    ENDCASE
**********FIN CONTROL DE DOCUMENTOS

**********AVANCE DEL REGISTRO
	    CAP->(DBSKIP())
	    CloseDbf('NOP')
**********FIN AVANCE DEL REGISTRO

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseAll()
       RETURN NIL
*>>>>FIN ASIGNACION ACADEMICA DEL PROFESOR
