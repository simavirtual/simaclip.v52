/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR ESTUDIANTE                            MODULO No. 401

**************************************************************************
* TITULO..: ESTADISTICAS POR ESTUDIANTE. INDICADORE APROBADOS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2006 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 AM   SEP 04/2006 LUN


OBJETIVOS:

1- Imprime los estudiantes sin dificultadas

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_414(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                 // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL     i,j := 0                   // Contador
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
     *ÀVariables de informe

       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL     k,y := 0                   // Contador
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades

       LOCAL cNombreTes := ''               // Nombre del Estudinate
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 414
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<ESTADISTICA><POR ESTUDIANTE><POR INDICADORES>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aMezIso,{'<nNroPer>',STR(nNroBis,2)})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'PERIODO No.<nNroPer> A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'ESTUDIANTES SIN INDICADORES PERDIDOS') // T¡tulo Dos
       AADD(aTitIso,'')                                     // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(CON->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)
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
       nRegPrn := PRN->(RECNO())

       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'IndSi'+cMaeAct
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.T.,.T.,bInsIso)

	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
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

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,04)
       AADD(aTitPrn,'No.')

       AADD(aNroCol,06)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,8)
       AADD(aTitPrn,'CURSO')

       AADD(aNroCol,42)
       AADD(aTitPrn,'APELLIDOS Y NOMBRES')

       AADD(aNroCol,20)
       AADD(aTitPrn,'OBSERVACION')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPie)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroBis)
**********FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

**********LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
	    lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
**********FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

**********RECORRIDO POR NOTAS
	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*==============IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			     'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			      NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)

		 SET DEVICE TO PRINT
*==============FIN IMPRESION DE LA LINEA DE ESTADO

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(42),1,42)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

*==============ANALISIS DEL PERIODO DEL RETIRO
		 IF &cMaeAct->lRetiroEst
		    IF nNroBis > &cMaeAct->nPerRetEst
		       SELECT NOT
		       NOT->(DBSKIP())
		       LOOP
		    ENDIF
		 ENDIF
*==============FIN ANALISIS DEL PERIODO DEL RETIRO

*==============RECORRIDO POR AREAS
		 nTotDif := 0
		 FOR i:=1 TO LEN(aNotAre)

*--------------------ANALISIS DEL AREA
		       IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*:::::::::::::::::::::::::INDICADORES POR RECUPERAR DEL AREA
			    nNroDif := 0
			    cCamInd := aNotAre[i,6]
			    FOR k := 1 TO nNroBis
				cCamInd := STUFF(cCamInd,8,1,STR(k,1))
				cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
				cSiRecu := ''
				cNoRecu := ''
				IF !aNotAre[i,15]   // Recuperable
				   IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)
				ENDIF
				aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
				nNroDif += LEN(aJuicio)
				nTotDif += LEN(aJuicio)
			    ENDFOR
*:::::::::::::::::::::::::FIN INDICADORES POR RECUPERAR DEL AREA

		       ENDIF
*--------------------FIN ANALISIS DEL AREA

*--------------------RECORRIDO POR MATERIAS
		       FOR j:=1 TO LEN(aNotMat)

*::::::::::::::::::::::::::INDICADORES DE LA MATERIA
			     IF aNotAre[i,2] == aNotMat[j,1]

*...............................ANALISIS DE LA MATERIA NO IMPRIMIR
				  cCodigoTma := SUBS(aNotMat[j,5],9,4)
				  IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
				     SUBS(PLA->cPrnBolPla,nNroBis,1) == '1'
				     LOOP
				  ENDIF
*...............................FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*...............................INDICADORES POR RECUPERAR DE LA MATERIA
				  nNroDif := 0
				  cCamInd := aNotMat[j,5]

				  FOR k := 1 TO nNroBis
				     cCamInd := STUFF(cCamInd,8,1,STR(k,1))
				     cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
				     cSiRecu := ''
				     cNoRecu := ''
				     IF !aNotMat[j,15]  // No Recuperable
					IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)
				     ENDIF
				     aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
				     nNroDif += LEN(aJuicio)
				     nTotDif += LEN(aJuicio)
				  ENDFOR
*...............................FIN INDICADORES POR RECUPERAR DE LA MATERIA

			     ENDIF
*::::::::::::::::::::::::::FIN INDICADORES DE LA MATERIA

		       ENDFOR
*--------------------FIN RECORRIDO POR MATERIAS

		 ENDFOR
*==============RECORRIDO POR AREAS

*==============IMPRESION DEL REGISTRO
		 IF nTotDif == 0
		    aRegPrn := {}
		    AADD(aRegPrn,STR(++y,4,0))
		    AADD(aRegPrn,NOT->cCodigoEst)
		    AADD(aRegPrn,&cMaeAct->cCodigoGru+'-'+STR(NOT->(RECNO()),2,0))
		    AADD(aRegPrn,cNombreTes)
		    AADD(aRegPrn,'')

		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		 ENDIF
*==============FIN IMPRESION DEL REGISTRO

*==============AVANCE DEL SIGUIENTE REGISTRO
		 SELECT NOT
		 NOT->(DBSKIP())
*==============FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
	    CloseDbf('NOT')
**********FIN RECORRIDO POR NOTAS

**********AVANCE AL SIGUIENTE REGISTRO
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS