/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN A¥O
SUBMODULO...: RECUPERACIONES. POR PROFESOR

**************************************************************************
* TITULO..: RECUPERACIONES SEMETRESTRALES                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 26/2015 VIE A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   OCT 26/2015 VIE

OBJETIVOS:

1- Imprime los estudiantes que deben presentar recuperaciones semestrales

2- Implementaci¢n para el Colegio ColSalle del 170

3- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_513(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lNotJvf := .F.                 // Nota en Juicio valorativo
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL nIniCaP := 0                   // Registro Inicial Carga Profesor
       LOCAL nFinCaP := 0                   // Registro Final Carga Profesor
       LOCAL cCodMat := ''                  // C¢digo de la materia
       LOCAL aCampos := {}                  // Campos de la materia


       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTpr := ''               // Nombre del Profesor
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
       LOCAL cPatSis := ''                 
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>FILTRACION DE LOS PROFESORES
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro .AND.;
		     PRO->lCargasPro .AND. !PRO->lRetiroPro
       GO TOP
       IF EOF()
	  cError('NO EXISTEN PROFESORES PARA '+cMaeAct)
	  SET FILTER TO
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervPro(nFilInf+1,nColInf-22,@nRegIni,@nRegFin)
	  SET FILTER TO
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'recuseme'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     SET FILTER TO
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION POR PROFESOR
       SELECT PRO
       GO nRegIni
       DO WHILE PRO->(RECNO()) <= nRegFin

**********VALIDACION DE LA CARGA ACADEMICA
	    DO CASE
	    CASE !PRO->lCargasPro
		 cError('NO TIENE CARGA ACADEMICA')

	    CASE !(cMaeAct $ PRO->cMaeAluPro)
		 cError('NO TIENE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)
**********FIN VALIDACION DE LA CARGA ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    PRO->cCodigoPro+'\'+;
			   'CARPRO'+cAnoSis+ExtFile,'CAP',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE CARGA ACADEMICA')
	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********CAPTURA DE LOS GRUPOS POR INTERVALO
	    IF nRegIni == nRegFin
	       IF !lIntervCaP(nFilInf+1,1,@nIniCaP,@nFinCaP)
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ELSE
	       nIniCaP := 1
	       nFinCaP := CAP->(RECCOUNT())
	    ENDIF
**********FIN CAPTURA DE LOS GRUPOS POR INTERVALO

**********RECORRIDO DE LA CARGA ACADEMICA
	    nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
	    SELECT CAP
	    CAP->(DBGOTO(nIniCaP))
	    DO WHILE CAP->(RECNO()) <= nFinCaP

*--------------ANALISIS DE DECISION
		 IF CAP->nTipCarCar == 1
		    CloseDbf('NOT')
		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE DECISION

*--------------INICIALIZACION DEL PATH DE NOTAS
		 IF CAP->nTipCarCar == 0
		    cCodGru := SUBS(CAP->cCodigoCar,5,4)
		    FileNot := cPatSis+'\'+cMaeAct+'\NOTAS'+'\'+;
			       'NT'+cCodGru+cAnoSis+ExtFile
		 ENDIF
*--------------FIN INICIALIZACION DEL PATH DE NOTAS

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF CAP->nTipCarCar == 0
		    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
				cFilePlan(cAnoUsr,cCodGru),;
				'PLA',NIL,lShared)

		       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			       cNomNiv(SUBS(cCodGru,1,2)))
		       CloseAll(aUseDbf)
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF CAP->nTipCarCar == 0
		    IF !lUseDbf(.T.,FileNot,'NOT',NIL,lShared)
		       cError('ABRIENDO EL ARCHIVO DE NOTAS')
		       IF lPregunta('DESEA CONTINUAR? Si No')
			  EXIT
		       ENDIF
		       CloseAll()
		       RETURN NIL
		    ENDIF
		    lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------RECUPERACIONES SEMESTRALES
		 cCodMat := SUBS(CAP->cCodigoCar,1,4)

		 IF CAP->nTipCarCar == 0
		    aCampos := aCamposNot(cCodMat)
		    RecuSemNot(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			       cNombreTpr,SUBS(CAP->cCodigoCar,5,4),;
			       MAT->cNombreMat,cMaeAct,cJorTxt,;
			       cCodMat,aCampos)
		 ELSE
		    RecuSemSel(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			       cNombreTpr,SUBS(CAP->cCodigoCar,5,4),;
			       MAT->cNombreMat,cMaeAct,cJorTxt,;
			       cCodMat,PathUno,cPatSis)

		 ENDIF
*--------------FIN RECUPERACIONES SEMESTRALES

*--------------VISUALIZACION DE LA CARGA
		 IF CAP->nTipCarCar == 0 .OR.;
		    CAP->nTipCarCar == 1
		    @ nNroFil,01 SAY 'CURSO: '+cCodGru+' '+;
				     'MATERIA:'+ALLTRIM(CAP->cNombreMat)
		 ELSE
		    @ nNroFil,01 SAY 'NIVEL: '+SUBS(cCodGru,1,2)+' '+;
				     'MATERIA:'+ALLTRIM(CAP->cNombreMat)
		 ENDIF

		 nNroFil++
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
		 ENDIF
*--------------FIN VISUALIZACION DE LA CARGA

	       CloseDbf('NOT')
	       CAP->(DBSKIP())

	    ENDDO
	    CloseDbf('NOT')
**********FIN RECORRIDO DE LA CARGA ACADEMICA

	  SELECT PRO
	  PRO->(DBSKIP())

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       SELECT PRO
       SET FILTER TO
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION POR PROFESOR

/*************************************************************************
* TITULO..: RECUPERACIONES SEMESTRALES                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 26/2015 VIE A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   OCT 26/2015 VIE

OBJETIVOS:

1- Recorre el archivo de notas de materias no selectivas.

2- Especifico para Colsalle

3- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSemNot(cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,cCodGru,;
		    cNomMat,cMaeAct,cJorTxt,cCodMat,aCampos)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cCodMat                              // C¢digo de la materia
       aCampos                              // Campos de la materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL FilePrn := ''                  // Archivo de impresi¢n
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL       i := 1                   // Contador
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL lPrnReg := .F.                 // .T. Imprimir Registro
       LOCAL cLogros := ''                  // Indicadores del Periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL cNroDif := ''                  // N£mero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades
       LOCAL cTotDif := ''                  // Total de Dificultades
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota Recuperaci¢n
       LOCAL aStrNot := {}                  // Vector con la estructura
       LOCAL aArePer := {}                  // Areas Perdidas
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nTotPer := 5                   // Total Periodos
       LOCAL cDefAre := ''                  // Nota del Area
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCamIndNot := ''                  // Campo de Indicadores
       LOCAL cCamNotDef := ''                  // Campo de Definitivas
       LOCAL cCamNotRec := ''                  // Campo de Recuperciones

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := NOT->(RECCOUNT())
       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  ALLTRIM(cNomMat),;
		  'ESTUDIANTES QUE DEBE PRESENTAR SUPERACION FINAL',;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitulo := {}

       AADD(aTitulo,'No')
       AADD(aNroCol,02)

       AADD(aTitulo,'CODIGO')
       AADD(aNroCol,06)

       AADD(aTitulo,'APELLIDOS Y NOMBRES ')
       AADD(aNroCol,54)

       AADD(aTitulo,'PF')
       AADD(aNroCol,10)

       AADD(aTitulo,'NOTA')
       AADD(aNroCol,10)

       AADD(aTitulo,'FECHA ')
       AADD(aNroCol,10)

       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := {}
       IF !EMPTY(cNomPro)
	  aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       ENDIF

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       cCamNotDef := cCamNotDef(aCampos,cCodMat)
       cCamNotRec := cCamNotRec(aCampos,cCodMat)

       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOT->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    
	    lRetiroTno := NOT->lRetGruNot
**********FIN BUSQUEDA DEL ESTUDIANTE

**********AREAS PERDIDAS
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)

	    cDefAre := ''
	    aArePer := {}
	    AreNPerEst(aNotAre,aNotMat,@aArePer,cCodMat,@cDefAre)
**********FIN AREAS PERDIDAS

**********ANALISIS DE DECISION
	    IF !(LEN(aArePer) > 0 .AND. LEN(aArePer) <= 2)
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS DE LA NOTA DEL AREA
	    IF VAL(cDefAre) >= 7.0
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE LA NOTA DEL AREA

**********ANALISIS DEL ESTUDIANTE RETIRADO
	    IF &cMaeAct->lRetiroEst
	       lRetiroTes := .T.
	    ELSE
	       lRetiroTno := NOT->lRetGruNot
	       lRetiroTes := .F.
	    ENDIF
	    IF lRetiroTes
	       cNombreTes += 'RETIRADO'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(54),1,54)
**********FIN ANALISIS DEL ESTUDIANTE RETIRADO

**********IMPRESION DE LA PRIMERA LINEA
	    lPrnReg := .T.
	    aTitulo := {}
	    AADD(aTitulo,STR(NOT->(RECNO()),2))
	    AADD(aTitulo,&cMaeAct->cCodigoEst)
	    AADD(aTitulo,cNombreTes)

	    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nTotPer*4-3,4))
	    cNotDef := cNotDef(cNotDef,.F.)

	    AADD(aTitulo,cNotDef)
	    AADD(aTitulo,'')
	    AADD(aTitulo,'')

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    IF VAL(cNotDef) > 0 .AND. VAL(cNotDef) < 7.0
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DE LA PRIMERA LINEA

	  NOT->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>FIRMA
       @ PROW()+2,1 SAY 'OBSERVACIONES: '
       FOR i := PROW() TO 16
	   @ PROW()+1,1 SAY REPL('-',LEN(cTxtPrn))
       ENDFOR

       cTxtPrn := 'Prof. '+ALLTRIM(cNomPro)
       @ PROW()+4,1 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,1 SAY cTxtPrn
*>>>>FIN FIRMA

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Impresi¢n de Derechos

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: RECUPERACIONES SEMESTRALES SELECTIVAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 26/2015 VIE A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   OCT 26/2015 VIE

OBJETIVOS:

1- Materias selectivas el recorrido del archivo de notas dependende
   del grupo del estudiante

2- Especifico para Colsalle

3- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSemSel(cNomEmp,cNomSis,cNomUsr,cAnoUsr,cNomPro,cCodGru,;
		    cNomMat,cMaeAct,cJorTxt,cCodMat,PathUno,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cCodMat                              // C¢digo de la materia
       PathUno			            // Paht Integraci¢n Uno
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL ExtFile := '.DAT'              // Extension para las bases
       LOCAL FilePrn := ''                  // Archivo de impresi¢n
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL       i := 1                   // Contador
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL lPrnReg := .F.                 // .T. Imprimir Registro
       LOCAL cLogros := ''                  // Indicadores del Periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL cNroDif := ''                  // N£mero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades
       LOCAL cTotDif := ''                  // Total de Dificultades
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota Recuperaci¢n
       LOCAL aStrNot := {}                  // Vector con la estructura
       LOCAL aArePer := {}                  // Areas Perdidas
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nTotPer := 5                   // Total Periodos
       LOCAL aCampos := {}                  // Campos de la materia
       LOCAL cDefAre := ''                  // Nota del Area
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCamIndNot := ''                  // Campo de Indicadores
       LOCAL cCamNotDef := ''                  // Campo de Definitivas
       LOCAL cCamNotRec := ''                  // Campo de Recuperciones

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+;
		       cMaeAct+'\'+PRO->cCodigoPro+'\'+;
		    CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL PROFESOR')
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0
       aCabeza := {cNomEmp,;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  ALLTRIM(cNomMat),;
		  'ESTUDIANTES QUE DEBE PRESENTAR SUPERACION FINAL',;
		  'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
		  SUBS(cCodGru,3,2),;
		  nNroPag,cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitulo := {}

       AADD(aTitulo,'No')
       AADD(aNroCol,02)

       AADD(aTitulo,'CODIGO')
       AADD(aNroCol,06)

       AADD(aTitulo,'APELLIDOS Y NOMBRES ')
       AADD(aNroCol,54)

       AADD(aTitulo,'PF')
       AADD(aNroCol,10)

       AADD(aTitulo,'NOTA')
       AADD(aNroCol,10)

       AADD(aTitulo,'FECHA ')
       AADD(aNroCol,10)

       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := {}
       IF !EMPTY(cNomPro)
	  aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       ENDIF

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>LOCALIZACION DE LA MATERIA VARIABLE
       lMatVarMat(cCodMat,.F.)
       cCodMat := MAT->cCodigoMat
*>>>>FIN LOCALIZACION DE LA MATERIA VARIABLE

*>>>>RECORRIDO NOTAS DEL PROFESOR
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,44)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('PRO. '+STR(PRO->(RECNO()),4)+'/'+;
			       STR(PRO->(RECCOUNT()),4)+;
			'ºNOT. '+STR(NOP->(RECNO()),4)+'/'+;
			  STR(NOP->(RECCOUNT()),4),'')
	    SET DEVICE TO PRINT
**********LINEA DE ESTADO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			cFilePlan(cAnoUsr,&cMaeAct->cCodigoGru),;
			'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(cCodGru,1,2)))
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS'+'\'+;
			'NT'+&cMaeAct->cCodigoGru+cAnoSis+ExtFile,'NOT',;
			NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS')
	       IF lPregunta('DESEA CONTINUAR? Si No')
		  EXIT
	       ENDIF
	       CloseDbf('NOT')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)
	       cError('EL CODIGO '+NOP->nCodigoEst+' NO EXISTE EN NOTAS')
	       CloseDbf('NOT')
	       RETURN NIL
	    ENDIF

	       aCampos := aCamposNot(cCodMat)
	    cCamNotDef := cCamNotDef(aCampos,cCodMat)
	    cCamNotRec := cCamNotRec(aCampos,cCodMat)
**********FIN LOCALIZACION EN NOTAS

**********ANALISIS DEL ESTUDIANTE RETIRADO
	    IF &cMaeAct->lRetiroEst
	       lRetiroTes := .T.
	    ELSE
	       lRetiroTno := NOT->lRetGruNot
	       lRetiroTes := .F.
	    ENDIF
	    IF lRetiroTes
	       cNombreTes += 'RETIRADO'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(54),1,54)
**********FIN ANALISIS DEL ESTUDIANTE RETIRADO

**********AREAS PERDIDAS
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)

	    cDefAre := ''
	    aArePer := {}
	    AreNPerEst(aNotAre,aNotMat,@aArePer,cCodMat,@cDefAre)
**********FIN AREAS PERDIDAS

**********ANALISIS DE DECISION
	    IF !(LEN(aArePer) > 0 .AND. LEN(aArePer) <= 2)
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS DE LA NOTA DEL AREA
	    IF VAL(cDefAre) >= 7.0
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE LA NOTA DEL AREA

**********ANALISIS DE LA NOTA
	       aCampos := aCamposNot(cCodMat)
	    cCamNotDef := cCamNotDef(aCampos,cCodMat)
	    cCamNotRec := cCamNotRec(aCampos,cCodMat)

	    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nTotPer*4-3,4))
	    cNotDef := cNotDef(cNotDef,.F.)
**********FIN ANALISIS DE LA NOTA

**********ANALISIS DE LA RECUPERACION
	    lPrnReg := .T.
	    aTitulo := {}
	    AADD(aTitulo,STR(NOT->(RECNO()),2))
	    AADD(aTitulo,&cMaeAct->cCodigoEst)
	    AADD(aTitulo,cNombreTes)
	    AADD(aTitulo,cNotDef)
	    AADD(aTitulo,'')
	    AADD(aTitulo,'')

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    IF VAL(cNotDef) > 0 .AND. VAL(cNotDef) < 7.0
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN ANALISIS DE LA RECUPERACION

	  NOP->(DBSKIP())


       ENDDO
*>>>>FIN RECORRIDO NOTAS DEL PROFESOR

*>>>>FIRMA
       @ PROW()+2,1 SAY 'OBSERVACIONES: '
       FOR i := PROW() TO 16
	   @ PROW()+1,1 SAY REPL('-',LEN(cTxtPrn))
       ENDFOR

       cTxtPrn := 'Prof. '+ALLTRIM(cNomPro)
       @ PROW()+4,1 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,1 SAY cTxtPrn
*>>>>FIN FIRMA

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Impresi¢n de Derechos

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO..: AREAS PERDIDAS DEL ESTUDIANTE                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 26/2015 VIE A
       Bucaramanga, Colombia	    INICIO: 03:30 PM   OCT 26/2015 VIE

OBJETIVOS:

1- Determina las Areas perdidas del estudiante para un periodo especifico

2- Caso espec¡fico para Colegio La Sall de la 170

2- Retorna un vector con las Areas perdidas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AreNPerEst(aNotAre,aNotMat,aArePer,cCodMat,cDefAre)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aArePer                              // Areas Perdidas
       cCodMat                              // C¢digo de la materia
       cDefAre                              // Definitiva del Area */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j := 0                       // Contadores

       LOCAL nNroPer := 5                   // N£mero del Periodo.
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cNomJvf := ''                  // Nombre del Juicio Valorativo

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       aArePer := {}
       FOR i := 1 TO LEN(aNotAre)

***********AREAS NO PROMEDIABLES
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN'

	       // No se tienen en cuenta
	       LOOP

	     ENDIF
***********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS
	    FOR j := 1 TO LEN(aNotMat)

*===============ANALISIS DEL AREA COMO MATERIA
		  IF aNotAre[i,2] == aNotMat[j,1]

*--------------------DESCARTAR LA MATERIA
		       cCodigoTma := SUBS(aNotMat[j,11],3,4)
		       IF SUBS(cCodigoTma,3,2) # '00'
			  LOOP
		       ENDIF
*--------------------FIN DESCARTAR LA MATERIA

*--------------------ANALAISIS DEL AREA
		       cCamNotDef := aNotMat[j,4]

		       cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))

		       IF SUBS(cCodMat,1,2) == aNotAre[i,2]
			  cDefAre := cNotDef
		       ENDIF
		     *ÀNota del Area de la materia

		       IF VAL(cNotDef) > 0 .AND. VAL(cNotDef) < 7.0

			  AADD(aArePer,{aNotMat[j,10],;  //IF(EMPTY(PLA->cMatCerPla),cMatBol,cMatCer)
					cNotDef,;
					cNomJvf,;
					aNotMat[j,7]})   // Titulo
		       ENDIF
*--------------------FIN ANALAISIS DEL AREA

		  ENDIF
*===============FIN ANALISIS DEL AREA COMO MATERIA

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS