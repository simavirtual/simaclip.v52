/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 13/2008 JUE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   MAR 13/2008 JUE

OBJETIVOS:

1- Imprime el boletin abreviado con las asignaturas en columna. Virrey

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ScoBol_11(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroPer,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroPer			      // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final
       nNroCol                              // N£mero de la Columna
       nColEnc                              // Columna del Encabezado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aPrmFun := {}                  // Parametros de Funci¢n

       LOCAL i,j,k,x,y,p := 0                 // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL cTx1Top := ''                  // Texto para el Encabezado
       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroFol := NIL                 // N£mero de Folio

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotLin := 0                   // Total lineas impresas
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL cEvaInd := ''                  // Evaluar el indicador
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lPrnEva := .F.                 // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       LOCAL nLenEva := 0                   // Longitud del Nombre de la Evaluaci¢n del Indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lPrnCod := .F.                 // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL nLinObs := 0                   // L¡neas de Observaci¢n
       LOCAL bDerPrn := NIL                 // Derechos de Impresi¢n
       LOCAL bCabBol := NIL                 // Encabezados del Boletin
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cAcuAre := ''                  // Acumulado del area
       LOCAL cProAre := ''                  // Promedio del area
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cClaInd := ''                  // Clase de Indicador de Configuraci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL cNomCla := ''                  // Nombre de la Clase
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL cMatRec := ''                  // Materia de las Recuperaciones
       LOCAL cTitReN := ''                  // T¡tulo Indicadores NO Recuperados
       LOCAL cTitReS := ''                  // T¡tulo Indicadores SI Recuperados
       LOCAL cIndAnt := ''                  // Indicadores Periodos Anteriores
       LOCAL cChrIni := ''                  // C¢digo Inicial de Impresi¢n
       LOCAL cChrFin := ''                  // C¢digo Final de Impresi¢n
       LOCAL cChrLin := ''                  // Caracter separador de l¡nea
       LOCAL nNroPos := 0                   // N£mero de la Posici¢n
       LOCAL lPiePag := .T.                 // .T. Imprimir el Pie de P gina

       LOCAL aPrnBol := {}                  // Areas y Materias a Imprimir
       LOCAL aMatBol := {}                  // Materias del Boletin
       LOCAL aLinUno := {}                  // N£mero de l¡neas
       LOCAL aLinDos := {}                  // N£mero de l¡neas

       LOCAL aMatUno := {}                  // Materia Uno
       LOCAL aMatDos := {}                  // Materia Dos
       LOCAL aIntHor := {}                  // Intensidad Horaria
       LOCAL aNomMat := {}                  // Materia del Boletin
       LOCAL aNotDef := {}                  // Nota Definitiva
       LOCAL aNroAus := {}                  // N£mero de Ausencias
       LOCAL aIndUno := {}                  // Indicadores Uno
       LOCAL aIndDos := {}                  // Indicadores Dos
       LOCAL cNomInd := ''                  // Nombre del Indicador
       LOCAL aNomInd := {}                  // Nombre del Indicador
       LOCAL aIndMat := {}                  // Indicadores de la Materia
       LOCAL aIndica := {}                  // Indicadores
       LOCAL nTotInd := 0                   // Total Indicadores
       LOCAL cNomEva := ''                  // Nota Definitva. Evalutiva


       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCamJuiNot := ''               // Campo de Indicadores
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL LIBRO FINAL
       nLenPrn := PCL('n17Stan')
       IF aFirmas == NIL
	  cNroFol := NIL
       ELSE
	  cNroFol := 'Folio No.'
       ENDIF
*>>>>FIN ANALISIS DEL LIBRO FINAL

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nColEnc := IF(EMPTY(nColEnc),0,nColEnc)
       nNroCol := IF(EMPTY(nNroCol),0,nNroCol)

       cTx1Top := ALLTRIM(SCO->cTxtLibCon)+;
		  ALLTRIM(SCO->cTxtLi1Con)
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       IF EMPTY(TCO->nTotLinTbl)
	  nTotLin := IIF(lOficio,70,58)
       ELSE
	  nTotLin := TCO->nTotLinTbl
       ENDIF
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroPer,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroPer,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       cEvaInd := TCO->cEvaIndTbl
       lEvaInd := IF(SUBS(cEvaInd,nNroPer,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(cEvaInd,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(cEvaInd,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       IF nNroPer == TCO->nTotPerTbl
	  IF EMPTY(ALLTRIM(TCO->cBolFinTbl))
	     cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
	  ELSE
	     cMsgBol := ALLTRIM(TCO->cBolFinTbl)
	  ENDIF
       ELSE
	  cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
       ENDIF

       IF !lPrnNot
	  lHayNot := .F.
       ENDIF
       IF !lHayNot .AND. lEvaInd
	  lNotNum := .F.
       ENDIF
       lHayItv := lHayItvJvf()
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DEL ENCABEZADO DEL BOLETIN
       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
		  nTotReg,;
		  cNomEst,;
		  NOT->cCodigoEst,;
		  GRU->cCodigoGru,;
		  NOT->(RECNO()),;
		  nPorAcu,cPorcen,nNroPer,cAnoSys,;
		  cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
		  IF(nNroPer==nTotPer,TCO->cTitBolTbl,''),,;
		  nColEnc)
*>>>>FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitulo := {}

       AADD(aNroCol,40)
       AADD(aTitulo,cMsgBol)
      *Intensidad Horaria

       AADD(aNroCol,18)
       AADD(aTitulo,'NOTA')
      *Mensaje Boletin

       AADD(aNroCol,40)
       AADD(aTitulo,cMsgBol)
      *Intensidad Horaria

       AADD(aNroCol,18)
       AADD(aTitulo,'NOTA')
      *Mensaje Boletin

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,nNroCol SAY cTxtPrn
       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>MATERIAS DEL BOLETIN
       aPrmFun := {}
       AADD(aPrmFun,{'cCodGru',GRU->cCodigoGru})
       AADD(aPrmFun,{'aNotAre',aNotAre})
       AADD(aPrmFun,{'aNotMat',aNotMat})
       AADD(aPrmFun,{'nNroPer',nNroPer})
       AADD(aPrmFun,{'cEvaInd',cEvaInd})
       AADD(aPrmFun,{'lIndNiv',lIndNiv})
       AADD(aPrmFun,{'lPrnAre',lPrnAre})

       aPrnBol := aPrnBole(aPrmFun)
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>ANALISIS DE DECISION
	    k := 1
      aMatBol := {}
      aMatUno := {}
      aMatDos := {}

      FOR i := 1 TO LEN(aPrnBol)

	  DO CASE
	  CASE k == 1
	       aMatUno := aPrnBol[i]

	       k++
	       IF i == LEN(aPrnBol)

		  aMatDos := {}
		  AADD(aMatDos,{'cIntHor',''})
		  AADD(aMatDos,{'cMatBol',''})
		  AADD(aMatDos,{'cNotDef',''})
		  AADD(aMatDos,{'cNroAus',''})

		  aIndMat := {}
		  AADD(aMatDos,{'aIndMat',aIndMat})

		  AADD(aMatBol,{aMatUno,aMatDos})

		  k := 1

	       ENDIF

	  CASE k == 2
	       aMatDos := aPrnBol[i]
	       AADD(aMatBol,{aMatUno,aMatDos})
	       k := 1
	  ENDCASE

      ENDFOR
*>>>>ANALISIS DE DECISION

*>>>>AREAS Y/O MATERIAS DEL BOLETIN
      FOR i := 1 TO LEN(aMatBol)

**********LECTURA DETALLES DEL AREA O MATERIA
	    aMatUno := aMatBol[i,1]
	    aMatDos := aMatBol[i,2]

	    aIntHor := {}
	    AADD(aIntHor,xPrm(aMatUno,'cIntHor'))
	    AADD(aIntHor,xPrm(aMatDos,'cIntHor'))

	    aNomMat := {}
	    AADD(aNomMat,xPrm(aMatUno,'cMatBol'))
	    AADD(aNomMat,xPrm(aMatDos,'cMatBol'))

	    aNotDef := {}
	    AADD(aNotDef,ALLTRIM(xPrm(aMatUno,'cNotDef')))
	    AADD(aNotDef,ALLTRIM(xPrm(aMatDos,'cNotDef')))

	    aNroAus := {}
	    AADD(aNroAus,ALLTRIM(xPrm(aMatUno,'cNroAus')))
	    AADD(aNroAus,ALLTRIM(xPrm(aMatDos,'cNroAus')))
**********FIN LECTURA DETALLES DEL AREA O MATERIA

**********AREA O MATERIA NOTA
	    aRegPrn := {}
	    AADD(aRegPrn,SUBS(aNomMat[1],1,40))
	    AADD(aRegPrn,aNotDef[1])
	  *ÀPrimera Columna

	    AADD(aRegPrn,SUBS(aNomMat[2],1,40))
	    AADD(aRegPrn,aNotDef[2])
	  *ÀSegunda Columna

	    @ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
**********FIN AREA O MATERIA NOTA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			  nTotReg,;
			  cNomEst,;
			  NOT->cCodigoEst,;
			  GRU->cCodigoGru,;
			  NOT->(RECNO()),nPorAcu,;
			  cPorcen,nNroPer,cAnoSys,cJorTxt,3,;
			  cNomEmp,lPrnEmp,cNroFol,,,;
			  IF(nNroPer==nTotPer,TCO->cTitBolTbl,''),,;
			  nColEnc)

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

	       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
	       @ PROW()+1,nNroCol SAY cTxtPrn
	       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

	       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

**********INTENSIDAD
	    aRegPrn := {}
	    AADD(aRegPrn,SUBS('INTENSIDAD'+SPACE(40),1,40))
	    AADD(aRegPrn,aIntHor[1])
	  *ÀPrimera Columna

	    AADD(aRegPrn,SUBS('INTENSIDAD'+SPACE(40),1,40))
	    AADD(aRegPrn,aIntHor[2])
	  *ÀSegunda Columna

	    @ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
**********FIN INTENSIDAD

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			  nTotReg,;
			  cNomEst,;
			  NOT->cCodigoEst,;
			  GRU->cCodigoGru,;
			  NOT->(RECNO()),nPorAcu,;
			  cPorcen,nNroPer,cAnoSys,cJorTxt,3,;
			  cNomEmp,lPrnEmp,cNroFol,,,;
			  IF(nNroPer==nTotPer,TCO->cTitBolTbl,''),,;
			  nColEnc)

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

	       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
	       @ PROW()+1,nNroCol SAY cTxtPrn
	       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

	       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

**********AUSENCIAS
	    aRegPrn := {}
	    AADD(aRegPrn,SUBS('AUSENCIAS'+SPACE(40),1,40))
	    AADD(aRegPrn,aNroAus[1])
	  *ÀPrimera Columna

	    AADD(aRegPrn,SUBS('AUSENCIAS'+SPACE(40),1,40))
	    AADD(aRegPrn,aNroAus[2])
	  *ÀSegunda Columna

	    @ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
**********FIN AUSENCIAS

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			  nTotReg,;
			  cNomEst,;
			  NOT->cCodigoEst,;
			  GRU->cCodigoGru,;
			  NOT->(RECNO()),nPorAcu,;
			  cPorcen,nNroPer,cAnoSys,cJorTxt,3,;
			  cNomEmp,lPrnEmp,cNroFol,,,;
			  IF(nNroPer==nTotPer,TCO->cTitBolTbl,''),,;
			  nColEnc)

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

	       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
	       @ PROW()+1,nNroCol SAY cTxtPrn
	       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

	       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

**********NUMERO DE LINEAS DEL NOMBRE DEL INDICADOR
	    aIndUno := {}
	    aIndMat := xPrm(aMatUno,'aIndMat')
	    FOR j := 1 TO LEN(aIndMat)

		aIndica := aIndMat[j]

		cNomInd := xPrm(aIndica,'cNomInd')
		aNomInd := aNombreInd(cNomInd,38)

		cNomEva := xPrm(aIndica,'cNomEva')
		FOR k := 1 TO LEN(aNomInd)
		    IF k == 1
		       AADD(aIndUno,{aNomInd[k],cNomEva})
		    ELSE
		       AADD(aIndUno,{aNomInd[k],''})
		    ENDIF
		ENDFOR

		nParameSet(aIndica,'aNomInd',aNomInd)
		aIndMat[j] := aIndica

	    ENDFOR
	    nParameSet(aMatUno,'aIndMat',aIndMat)
	  *ÀPrimera Columna

	    aIndDos := {}
	    aIndMat := xPrm(aMatDos,'aIndMat')
	    FOR j := 1 TO LEN(aIndMat)

		aIndica := aIndMat[j]

		cNomInd := xPrm(aIndica,'cNomInd')
		aNomInd := aNombreInd(cNomInd,38)

		cNomEva := xPrm(aIndica,'cNomEva')
		FOR k := 1 TO LEN(aNomInd)
		    IF k == 1
		       AADD(aIndDos,{aNomInd[k],cNomEva})
		    ELSE
		       AADD(aIndDos,{aNomInd[k],''})
		    ENDIF
		ENDFOR

		nParameSet(aIndica,'aNomInd',aNomInd)
		aIndMat[j] := aIndica

	    ENDFOR
	    nParameSet(aMatDos,'aIndMat',aIndMat)
	  *ÀSegunda Columna
**********FIN NUMERO DE LINEA DEL NOMBRE DEL INDICADOR

**********ANALISIS DE DECISION
	    IF LEN(aIndUno) >= LEN(aIndDos)
	       nTotInd := LEN(aIndUno)
	    ELSE
	       nTotInd := LEN(aIndDos)
	    ENDIF
**********FIN ANALISIS DE DECISION

**********IMPRESION DE LOS INDICADORES
	    FOR j := 1 TO nTotInd

		DO CASE
		CASE LEN(aIndUno) == LEN(aIndDos)  // Iguales

		     cNomInd := aIndUno[j,1]
		     cNomEva := aIndUno[j,2]

		     aRegPrn := {}
		     AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
		     AADD(aRegPrn,cNomEva)

		     cNomInd := aIndDos[j,1]
		     cNomEva := aIndDos[j,2]

		     AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
		     AADD(aRegPrn,cNomEva)

		CASE LEN(aIndUno) > LEN(aIndDos)  // Mayor aIndUno

		     IF j <= LEN(aIndDos)

			cNomInd := aIndUno[j,1]
			cNomEva := aIndUno[j,2]

			aRegPrn := {}
			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

			cNomInd := aIndDos[j,1]
			cNomEva := aIndDos[j,2]

			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

		     ELSE

			cNomInd := aIndUno[j,1]
			cNomEva := aIndUno[j,2]

			aRegPrn := {}
			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

			cNomInd := ''
			cNomEva := ''

			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

		     ENDIF

		CASE LEN(aIndUno) < LEN(aIndDos)  // Mayor aIndDos

		     IF j <= LEN(aIndUno)

			cNomInd := aIndUno[j,1]
			cNomEva := aIndUno[j,2]

			aRegPrn := {}
			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

			cNomInd := aIndDos[j,1]
			cNomEva := aIndDos[j,2]

			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

		     ELSE

			cNomInd := ''
			cNomEva := ''

			aRegPrn := {}
			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

			cNomInd := aIndDos[j,1]
			cNomEva := aIndDos[j,2]

			AADD(aRegPrn,SUBS(cNomInd+SPACE(40),1,40))
			AADD(aRegPrn,cNomEva)

		     ENDIF

		ENDCASE

		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

*===============ANALISIS PARA EL CAMBIO DE PAGINA
		  IF PROW() > nTotLin
		     DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		     EJECT
		     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				nTotReg,;
				cNomEst,;
				NOT->cCodigoEst,;
				GRU->cCodigoGru,;
				NOT->(RECNO()),nPorAcu,;
				cPorcen,nNroPer,cAnoSys,cJorTxt,3,;
				cNomEmp,lPrnEmp,cNroFol,,,;
				IF(nNroPer==nTotPer,TCO->cTitBolTbl,''),,;
				nColEnc)

		     cTxtPrn := cRegPrint(aTitulo,aNroCol)
		     @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		     @ PROW()+1,nNroCol SAY cTxtPrn
		     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		  ENDIF
*===============FIN ANALISIS PARA EL CAMBIO DE PAGINA

	    ENDFOR
**********FIN IMPRESION DE LOS INDICADORES

********LINEA SEPARADORA
	  cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
	  cChrLin := IF(EMPTY(cChrLin),'=',cChrLin)
	  aRegPrn := {}
	  AADD(aRegPrn,REPL(cChrLin,aNroCol[1]))
	  AADD(aRegPrn,REPL(cChrLin,aNroCol[2]))
	  AADD(aRegPrn,REPL(cChrLin,aNroCol[3]))
	  AADD(aRegPrn,REPL(cChrLin,aNroCol[4]))

	  @ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
********FIN LINEA SEPARADORA

      ENDFOR
*>>>>AREAS Y/O MATERIAS DEL BOLETIN

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > nTotLin - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= nTotLin
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroPer,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroPer==nTotPer,TCO->cTitBolTbl,''),,;
		     nColEnc)

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

	  @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,nNroCol SAY cTxtPrn
	  @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroPer == nTotPer
	  cEstado := cAproboJui(NOT->nAproboNot,;
				SUBS(GRU->cCodigoGru,1,2),;
				     @cTxtObsTap)
	  cEstado := ALLTRIM(cEstado)
       ENDIF

       aNroLin := aDivLin(ALLTRIM('OBSERVACION: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,nNroCol SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       aMatHab := {}
       IF nNroPer == nTotPer
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroPer == nTotPer .AND. !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''

	  cTxtPrn := IF(EMPTY(TCO->cTitRecTbl),;
		       'ACTIVIDADES DE RECUPERACION DE',;
			ALLTRIM(TCO->cTitRecTbl))

	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			    ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			    ' DE '+aMatHab[i,2]+'. '
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nNroCol SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(cTxtObsTap)
	  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nNroCol SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n de Recuperacion.

       IF !EMPTY(TCO->cObsBolTbl)
	  aNroLin := aDivLin(ALLTRIM(TCO->cObsBolTbl),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nNroCol SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General del Boletin

       nLinObs := VAL(SUBS(TCO->cCfgBolTbl,1,1))
       nLinObs := IF(EMPTY(nLinObs),2,nLinObs)

       nLenLin := LEN(cTxtPrn)
       FOR p := 1 TO nLinObs
	   @ PROW()+2,nNroCol SAY REPL('-',nLenLin)
       ENDFOR
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>FIRMANTES DEL BOLETIN
       IF aFirmas == NIL
	  aFirmas := {}
	  DO CASE
	  CASE EMPTY(SUBS(TCO->cCfgBolTbl,7,1)) .OR.;
	       SUBS(TCO->cCfgBolTbl,7,1) == '1'

	       cTxtPrn := 'Dir. '+cTitUno
	       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

	  CASE SUBS(TCO->cCfgBolTbl,7,1) == '2'
	       aFirmas := {{ALLTRIM(SCO->cGerentCon),NIL,ALLTRIM(SCO->cCarGerCon)},;
			   {cTitUno,NIL,'Dir.'}}
	       Firmas(PCL('n17Stan'),4,aFirmas)

	  CASE SUBS(TCO->cCfgBolTbl,7,1) == '3'

	       aFirmas := {{cTitUno,NIL,'Dir.'},;
			   {cTitDos,NIL,'Dir.'}}
	       Firmas(PCL('n17Stan'),4,aFirmas)

	  OTHERWISE
	       cTxtPrn := 'Dir. '+cTitUno
	       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
	  ENDCASE

       ELSE
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.,nNroCol)
       ENDIF

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
       EJECT
       RETURN NIL
*>>>>FIN FIRMANTES DEL BOLETIN



/*************************************************************************
* TITULO..: ENCABEZADO DEL BOLETIN No.11                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 27/2008 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   MAR 27/2008 JUE

OBJETIVOS:

1- Imprime el encabezado del boletin

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabBol_11(lOficio,nLinSpa,cTxtPrn,nNroPag,nTotReg,cNomEst,cCodEst,;
		   cCodGru,nNroLis,nPorAcu,cPorcen,nNroPer,cAnoSys,cJorTxt,;
		   nTipBol,cNomEmp,lPrnEmp,cNroFol,cTxtObs,cNomSec,cTitTop,;
		   cMatMod,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     lOficio                              // .F. Tama¤o Carta
       nLinSpa                              // Espacios para el encabezado
       cTxtPrn                              // @Texto de impresion
       nNroPag                              // N£mero de p gina
       nTotReg			            // Total registros a imprimir
       cNomEst                              // Nombre del Estudiante
       cCodEst                              // C¢digo del estudiante
       nNroLis                              // N£mero de lista
       nPorAcu                              // Porcentaje Acumulado
       cPorcen                              // Porcentajes aplicados
       nNroPer			      // N£mero del bimestre
       cAnoSys                              // A¤o del sistema
       cJotTxt                              // Jornada escogidad
       nTipBol                              // Tipo de boletin
       cNomEmp                              // Nombre de Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del folio
       cTxtObs                              // Texto de Observaci¢n
       cNomSec                              // Nombre Secundario
       cTitTop                              // T¡tulo Superior
       cMatMod                              // Materia de Modalida o Especialidad
       nNroCol                              // N£mero de Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nColEnc := 0                   // Columna del Encabezado
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lLibro  := .F.                 // .T. Encabezado del libro
       LOCAL nLinPag := 0                   // L¡neas por p gina
       LOCAL nNroLin := 0                   // N£mero de l¡neas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       @ PROW(),00 SAY PCL({"GraphiOn","CondenOf","ProporOf",;
			    "Pica","DraftOf","Roman"})

       IF lPrnEmp
	  @ PROW(),00 SAY PCL("DobAncOn")+cNomEmp+PCL("DobAncOf")

	  IF !EMPTY(cNomSec)
	     @ PROW()+1,00 SAY PCL("DobAncOn")+cNomSec+PCL("DobAncOf")
	  ENDIF

	  SendCodes(PCL("CondenOn"))
	  aNroLin := aDivLin(ALLTRIM(cTxtObs),120)

	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
	  SendCodes(PCL("CondenOf"))
	*ÀImpresi¢n del Texto despu‚s de la Empresa
       ENDIF
*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL TITULO SUPERIOR
       cTitTop := IF(cTitTop == NIL,'',cTitTop)
       IF !EMPTY(cTitTop)
	  cTitTop := ALLTRIM(cTitTop)
	  @ PROW()+nLinSpa,(80-LEN(cTitTop))/2 SAY cTitTop
	  nLinSpa := 2
       ENDIF
*>>>>FIN IMPRESION DEL TITULO SUPERIOR

*>>>>IMPRESION DEL NOMBRE DEL ALUMNO
       IF !EMPTY(SCO->cIsoBolCon)
	  cNomEst := SUBS(cNomEst+SPACE(36),1,36)
       ENDIF

       cTxtPrn :=    'ALUMNO: '+cNomEst+SPACE(02)+;
			       SPACE(02)+'PERIODO:'+STR(nNroPer,2)+;
			       SPACE(01)+;
			       SPACE(SCO->nSpaBolCon)+ALLTRIM(SCO->cIsoBolCon)

       nColEnc := nNroCol
       @ PROW()+nLinSpa,nColEnc SAY cTxtPrn
*>>>>FIN IMPRESION DEL NOMBRE DEL ALUMNO

*>>>>IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA
       nLinPag := IF(lOficio,54,46)

       IF EMPTY(nTotReg)
	  cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		     'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
				SUBS(cCodGru,3,2)+SPACE(02)+;
		     'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		     'A¥O:'    +cAnoSys          +SPACE(01)+;
		     'JORNADA:'+cJorTxt          +SPACE(01)+;
		     'P gina No.'+LTRIM(STR(nNroPag))
       ELSE
	  cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		     'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
				SUBS(cCodGru,3,2)+SPACE(02)+;
		     'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		     'A¥O:'    +cAnoSys          +SPACE(01)+;
		     'JORNADA:'+cJorTxt          +SPACE(01)+;
		     'P gina No.'+LTRIM(STR(nNroPag))+'/'+;
		     cTotPagina(nTotReg,nLinPag,lOficio)
       ENDIF

       @ PROW()+1,nColEnc SAY cTxtPrn
       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})
*>>>>FIN IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA

*>>>>IMPRESION DE LA DESCRIPCION DE LA ESCALA EVALUATIVA
       IF nNroPag == 1
	  IF !EMPTY(COA->cDescrECoA)
	     @ PROW()+nNroLin,00 SAY REPL('-',122)
	     SendCodes(PCL("CondenOn"))
	     @ PROW()+1,00 SAY PCL("NegraOn")+;
			      'ESCALA EVALUATIVA...:'+;
			       PCL("NegraOf")


	     aNroLin := aDivLin(ALLTRIM(COA->cDescrECoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'EXCELENTE(Ee).......: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrSCoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrSCoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'SOBRESALIENTE(Ss)...: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrACoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrACoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'ACEPTABLE(Aa).......: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrICoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrICoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'INSUFICIENTE(Ii)....: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrDCoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrDCoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'DEFICIENTE(Dd)......: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LA DESCRIPCION DE LA ESCALA EVALUATIVA

/*************************************************************************
* TITULO..: CUERPO DEL BOLETIN. No.11                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/2008 VIE A
       Colombia, Bucaramanga        INICIO: 07:30 AM   MAR 14/2008 VIE

OBJETIVOS:

1- Define el cuerpo del Boletin

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aPrnBole(aParamt)

*>>>>DESCRIPCION DE PARAMETROS
       LOCAL cCodGru := xPrm(aParamt,'cCodGru') // C¢digo del Grupo
       LOCAL aNotAre := xPrm(aParamt,'aNotAre') // Detalles de las areas
       LOCAL aNotMat := xPrm(aParamt,'aNotMat') // Detalles de las materias
       LOCAL nNroPer := xPrm(aParamt,'nNroPer') // N£mero del Periodo
       LOCAL cEvaInd := xPrm(aParamt,'cEvaInd') // Evaluar el Indicador
       LOCAL lIndNiv := xPrm(aParamt,'lIndNiv') // // .T. Indicadores por nivel
       LOCAL lPrnAre := xPrm(aParamt,'lPrnAre') // Imprimir el  rea
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contador

       LOCAL aPrmFun := {}                  // Parametros de Funci¢n

       LOCAL aDetAre := ''                  // Detalles del Area
       LOCAL aDetMat := ''                  // Detalles de la Materia

       LOCAL lNoPrnM := .F.                 // .T. No Imprimir .F. Imprimir Materia en Boletin
       LOCAL lModali := .F.                 // .T. Modadilidad

       LOCAL cIntHor := ''                  // Intensidad Horaria
       LOCAL cMatBol := ''                  // Materia del Boletin
       LOCAL cLogros := ''                  // Logros
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNroAus := ''                  // N£mero de Ausencias

       LOCAL cClaPrn := ''                  // Imprimir en el Boletin
       LOCAL aIndTem := {}                  // Indicadores Temporales
       LOCAL aIndMat := {}                  // Indicadores de la Materia
       LOCAL aIndica := {}                  // Indicadores

       LOCAL aAreBol := {}                  // Areas del Boletin
       LOCAL aMatBol := {}                  // Materias del Boletin
       LOCAL aPrnBol := {}                  // Areas y Materias a Imprimir
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       aPrnBol := {}
       FOR i:=1 TO LEN(aNotAre)

**********DETALLES DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------DETALLES DE LA AREA
		 aPrmFun := {}
		 AADD(aPrmFun,{'aDetAre',aNotAre[i]})
		 AADD(aPrmFun,{'nNroPer',nNroPer})
		 AADD(aPrmFun,{'cCodGru',cCodGru})
		 AADD(aPrmFun,{'cEvaInd',cEvaInd})
		 AADD(aPrmFun,{'lIndNiv',lIndNiv})

		 aDetAre := aNotasAre(aPrmFun)
*--------------FIN DETALLES DE LA AREA

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 lNoPrnM := xPrm(aDetAre,'lNoPrnM')
		 IF lNoPrnM  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 cLogros := xPrm(aDetAre,'cLogros')
		 lModali := xPrm(aDetAre,'lModali')
		 IF lModali  // .T. Modalidad
		    IF EMPTY(cLogros)
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------DETALLES DEL BOLETIN
		 aAreBol := {}

		 cIntHor := xPrm(aDetAre,'cIntHor')
		 AADD(aAreBol,{'cIntHor',cIntHor})

		 cMatBol := xPrm(aDetAre,'cMatBol')
		 AADD(aAreBol,{'cMatBol',cMatBol})

*		 cNotDef := xPrm(aDetAre,'cNotDef')
*		 cNotDef := xPrm(aDetAre,'cDefNum')
*		 cNotDef := xPrm(aDetAre,'cDefEva')
		 cNotDef := xPrm(aDetAre,'cNomDef')
		 AADD(aAreBol,{'cNotDef',cNotDef})

		 IF SUBS(TCO->cTotAusTbl,nNroPer,1) == '1'
		    cNroAus := xPrm(aDetAre,'cTotAus')
		    AADD(aAreBol,{'cNroAus',cNroAus})
		 ELSE
		    cNroAus := xPrm(aDetAre,'cNroAus')
		    AADD(aAreBol,{'cNroAus',cNroAus})
		 ENDIF

		 aIndMat := xPrm(aDetAre,'aIndica')
		 AADD(aAreBol,{'aIndMat',aIndMat})

		 AADD(aPrnBol,aAreBol)
*--------------FIN DETALLES DEL BOLETIN

	    ENDIF
**********FIN DETALLES DEL AREA

**********DETALLES DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*------------------DETALLES DE LA MATERIA
		     aPrmFun := {}
		     AADD(aPrmFun,{'aDetMat',aNotMat[j]})
		     AADD(aPrmFun,{'nNroPer',nNroPer})
		     AADD(aPrmFun,{'cCodGru',cCodGru})
		     AADD(aPrmFun,{'cEvaInd',cEvaInd})
		     AADD(aPrmFun,{'lIndNiv',lIndNiv})

		     aDetMat := aNotasMat(aPrmFun)
*------------------DETALLES DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    lNoPrnM := xPrm(aDetMat,'lNoPrnM')
		    IF lNoPrnM  // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    cLogros := xPrm(aDetMat,'cLogros')
		    lModali := xPrm(aDetMat,'lModali')
		    IF lModali  // .T. Modalidad
		       IF EMPTY(cLogros)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------DETALLES DEL BOLETIN
		    aMatBol := {}

		    cIntHor := xPrm(aDetMat,'cIntHor')
		    AADD(aMatBol,{'cIntHor',cIntHor})

		    cMatBol := xPrm(aDetMat,'cMatBol')
		    AADD(aMatBol,{'cMatBol',cMatBol})

*		    cNotDef := xPrm(aDetMat,'cNotDef')
*		    cNotDef := xPrm(aDetMat,'cDefNum')
*		    cNotDef := xPrm(aDetMat,'cDefEva')
		    cNotDef := xPrm(aDetMat,'cNomDef')
		    AADD(aMatBol,{'cNotDef',cNotDef})

		    IF SUBS(TCO->cTotAusTbl,nNroPer,1) == '1'
		       cNroAus := xPrm(aDetMat,'cTotAus')
		       AADD(aMatBol,{'cNroAus',cNroAus})
		    ELSE
		       cNroAus := xPrm(aDetMat,'cNroAus')
		       AADD(aMatBol,{'cNroAus',cNroAus})
		    ENDIF

		    aIndMat := {}
		    aIndTem := xPrm(aDetMat,'aIndica')
		    FOR k := 1 TO LEN(aIndTem)

			aIndica := aIndTem[k]

			cClaPrn := xPrm(aIndica,'cPrnBol')
			IF cClaPrn == '0'
			   LOOP
			ENDIF
			AADD(aIndMat,aIndica)
		    ENDFOR
		    AADD(aMatBol,{'aIndMat',aIndMat})

		    AADD(aPrnBol,aMatBol)
*------------------FIN DETALLES DEL BOLETIN

	       ENDIF
	    ENDFOR
**********FIN DETALLES DE LA MATERIA

       ENDFOR
       RETURN aPrnBol
*>>>>FIN RECORRIDO POR AREAS

/*************************************************************************
* TITULO..: INDICADORES DEL BOLETIN                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/2008 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAR 25/2008 MAR

OBJETIVOS:

1- Lee los indicadores de la materia que deben salir en el boletin.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aIndBol11(cCodNiv,cCodMat,lIndNiv,cJuicio,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodNiv                              // C¢digo del Nivel
       cCodMat                              // C¢digo de la Materia
       lIndNiv                              // .T. Indicadores por nivel
       cJuicio                              // C¢digos de Indicadores
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo

       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cCodEva := ''                  // Nota del Indicador

       LOCAL aJuicio := {}                  // Indicadores para el periodo
       LOCAL cNomInd := {}                  // Nombre del Indicador
       LOCAL aIndMat := {}                  // C¢digos de los Indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE LOS INDICADORES
       aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

       FOR i := 1 TO LEN(aJuicio)

***********LECTURA DEL CODIGO DEL INDICADOR
	     cCodigo := aJuicio[i]

	     cCodInd := SUBS(cCodigo,1,4)
	     cCodCla := SUBS(cCodInd,1,1)
	     cCodEva := SUBS(cCodigo,5,1)
***********FIN LECTURA DEL CODIGO DEL INDICADOR

***********LOCALIZACION DE LA CLASE DE INDICADORES
	     IF !lLocCodigo('cCodigoCla','CLA',cCodCla)
		LOOP
	     ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADORES

***********VALIDACION DE IMPRESION
	     IF SUBS(CLA->cPrnBolCla,nNroPer,1) == '0'  // No Imprimir
		LOOP
	     ENDIF
***********FIN VALIDACION DE IMPRESION

***********CODIGO DEL INDICADOR
	     cNomInd := cTextoInd(cCodNiv,cCodMat,lIndNiv,cCodInd)
	     AADD(aIndMat,{cCodInd,cCodEva,cNomInd})
***********FIN CODIGO DEL INDICADOR

       ENDFOR
       RETURN aIndMat
*>>>>FIN RECORRIDO DE LOS INDICADORES

/*************************************************************************
* TITULO..: LECTURA DEL TEXTO DEL INDICADOR                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/2008 MAR A
       Colombia, Bucaramanga        INICIO: 11:30 AM   MAR 25/2008 MAR

OBJETIVOS:

1- Lee el texto del indicador

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTextoInd(cCodNiv,cCodMat,lIndNiv,cCodInd)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodNiv                              // C¢digo del Nivel
       cCodMat                              // C¢digo de la Materia
       lIndNiv                              // .T. Indicadores por nivel
       cCodInd                              // C¢digo del Indicador */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo b£squeda del indicador
       LOCAL nJuiExt := 0                   // Indicadores Extras
       LOCAL cNomInd := ''                  // Nombre del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CODIGO DE BUSQUEDA
       IF lIndNiv
	  cCodigo := cCodNiv+cCodMat+cCodInd
       ELSE
	  cCodigo := cCodMat+cCodInd
       ENDIF
*>>>>FIN CODIGO DE BUSQUEDA

*>>>>BUSQUEDA DEL INDICADOR
       cNomInd := 'NO EXISTE EL CODIGO '+cCodInd
       IF lSekCodigo(cCodigo,'JUI')

	  cNomInd := ALLTRIM(JUI->cNombreJui)+' '

**********INDICADOR EXTRA
	    nJuiExt := IF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)
	    FOR i := 1 TO nJuiExt
		cNomInd += &('JUI->cExtra'+STR(i,1)+'Jui')
	    ENDFOR
**********FIN INDICADOR EXTRA

	  cNomInd := cNomInd(ALLTRIM(cNomInd),;
			     CLA->lMinuscCla,CLA->cTipPrnCla,.T.)

       ENDIF
       RETURN cNomInd
*>>>>FIN BUSQUEDA DEL INDICADOR

/*************************************************************************
* TITULO..: NOTAS DEL AREA                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 04/2008 MIE A
       Colombia, Bucaramanga        INICIO: 11:45 AM   ABR 04/2008 MIE

OBJETIVOS:

1- Lee los detalles de las notas del area

2- Retorna un vector con la informaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aNotasAre(aParamt)

*>>>>DESCRIPCION DE PARAMETROS
       LOCAL aDetAre := xPrm(aParamt,'aDetAre') // Detalles del Area
       LOCAL nNroPer := xPrm(aParamt,'nNroPer') // N£mero del Periodo
       LOCAL cCodGru := xPrm(aParamt,'cCodGru') // C¢digo del Grupo
       LOCAL cEvaInd := xPrm(aParamt,'cEvaInd') // Evaluar el Indicador
       LOCAL lIndNiv := xPrm(aParamt,'lIndNiv') // .T. Indicadores por nivel
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                   // Contador

       LOCAL aDetNot := {}                  // Detalles de la Nota

       LOCAL cCodNiv := ''                  // C¢digo del Nivel
       LOCAL cCodMat := ''                  // C¢digo de la Materia

       LOCAL cCamAre := ''                  // Campo del Area
       LOCAL cNotAre := ''                  // Notas del Area
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cLogros := ''                  // Indicadores
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cNotInd := ''                  // Notas de los Indicadores
     *ÀCampos

       LOCAL cIntens := ''                  // Intensidad Horaria

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cDefNum := ''                  // Definitiva Numerica
       LOCAL cDefEva := ''                  // Definitiva Cualitativa
       LOCAL cNomDef := ''                  // Definitiva Cualitativa. Nombre

       LOCAL cCamAus := ''                  // Campos de Ausencias
       LOCAL cNroAus := ''                  // N£mero de Ausencias
       LOCAL cTotAus := ''                  // Total de de Ausencias

       LOCAL aIndica := ''                  // Indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL AREA
       AADD(aDetNot,{'nOrdPla',aDetAre[01]}) // No.01 Orden en el Boletin
       AADD(aDetNot,{'cCodAre',aDetAre[02]}) // No.02 C¢digo del Area
       AADD(aDetNot,{'cMatBol',aDetAre[03]}) // No.03 Materia para el Boletin
       AADD(aDetNot,{'cCamAre',aDetAre[04]}) // No.04 Campo del Area
       AADD(aDetNot,{'cTipMat',aDetAre[05]}) // No.05 Tipo Materia o Area
       AADD(aDetNot,{'cCamInd',aDetAre[06]}) // No.06 Campo de Indicadores
       AADD(aDetNot,{'cTitMat',aDetAre[07]}) // No.07 T¡tulo del Area
       AADD(aDetNot,{'cCamAcu',aDetAre[08]}) // No.08 Notas Acumuladas
       AADD(aDetNot,{'lCertif',aDetAre[09]}) // No.09 .T. Entra en el certificado de notas
       AADD(aDetNot,{'cMatCer',aDetAre[10]}) // No.10 Materia para el Certificado
       AADD(aDetNot,{'cIntHor',aDetAre[11]}) // No.11 Intensidad Horaria
       AADD(aDetNot,{'lNoPrnM',aDetAre[12]}) // No.12 No Imprimir la Materia en el Boletin. Ej: 1:No Imprime  0:Si Imprime
       AADD(aDetNot,{'lModali',aDetAre[13]}) // No.13 .T. Modalidad .F. No Modalidad
       AADD(aDetNot,{'cMatSel',aDetAre[14]}) // No.14 Materias Selectivas
       AADD(aDetNot,{'lNoRecu',aDetAre[15]}) // No.15 =>Materia No Recuperable
       AADD(aDetNot,{'cIntCer',aDetAre[16]}) // No.16 =>Intensidad Horaria para el Certficado
       AADD(aDetNot,{'cPrnNot',aDetAre[17]}) // No.17 =>Imprimir la Nota en el Boletin
       AADD(aDetNot,{'cPrnBol',aDetAre[18]}) // No.18 =>No Imprimir la Materia en el Boletin. Ej: 1:No Imprime  0:Si Imprime
*>>>>FIN DETALLES DEL AREA

*>>>>CAMPOS DEL AREA
       cCodNiv := SUBS(cCodGru,1,2)

       cCamAre := xPrm(aDetNot,'cCamAre')
       cNotAre := &cCamAre

       cCamInd := xPrm(aDetNot,'cCamInd')
       cLogros := ALLTRIM(&cCamInd)+SPACE(01)
       AADD(aDetNot,{'cLogros',cLogros})

       cCodMat := SUBS(cCamInd,9,4)
       cCamAus := 'NOT->cFa'+cCodMat+'Not'

       IF lHayJnt(cEvaInd)
	  cCamNtI := 'NOT->cN'+STR(nNroPer,1)+cCodMat+'Not'
	  cNotInd := &cCamNtI
       ELSE
	  cCamNtI := NIL
	  cNotInd := ''
       ENDIF
       AADD(aDetNot,{'cNotInd',cNotInd})
*>>>>FIN CAMPOS DEL AREA

*>>>>INTENSIDAD HORARIA
       cIntens := xPrm(aDetNot,'cIntHor')
       IF VAL(cIntens) == 0
	  cIntens := SPACE(02)
          nParameSet(aDetNot,'cIntHor',cIntens)
       ENDIF
*>>>>FIN INTENSIDAD HORARIA

*>>>>NOTAS DEL AREA
       cNotDef := SUBS(cNotAre,nNroPer*4-3,4)

       AADD(aDetNot,{'cNotDef',cNotDef})

       IF EMPTY(cNotDef)
	  cDefNum := ''
	  cDefEva := ''
	  cNomDef := ''

	  AADD(aDetNot,{'cDefNum',cDefNum})
	  AADD(aDetNot,{'cDefEva',cDefEva})
	  AADD(aDetNot,{'cNomDef',cNomDef})
       ENDIF

       IF VAL(cNotDef) > 0
	  cDefNum := cNotDef
	  cDefEva := cNotDefJvf(VAL(cDefNum))
	  cNomDef := cNombreJvf(cDefEva)

	  AADD(aDetNot,{'cDefNum',cDefNum})
	  AADD(aDetNot,{'cDefEva',cDefEva})
	  AADD(aDetNot,{'cNomDef',cNomDef})
       ENDIF
     *ÀNota N£merica

       IF VAL(cNotDef) == 0
	  cDefNum := ''
	  cDefEva := cNotDef
	  cNomDef := cNombreEva(ALLTRIM(cDefEva))

	  AADD(aDetNot,{'cDefNum',cDefNum})
	  AADD(aDetNot,{'cDefEva',cDefEva})
	  AADD(aDetNot,{'cNomDef',cNomDef})
       ENDIF
     *ÀNota Cualitativa
*>>>>FIN NOTAS DEL AREA

*>>>>AUSENCIAS
       cNroAus := 0
       cTotAus := 0
       IF SUBS(TCO->cTotAusTbl,nNroPer,1) == '1'
	  FOR k := 1 TO nNroPer
	     cTotAus += VAL(SUBS(&cCamAus,k*2-1,2))
	  NEXT
       ELSE
	  cNroAus := VAL(SUBS(&cCamAus,nNroPer*2-1,2))
       ENDIF
       cNroAus := IF(EMPTY(cNroAus),SPACE(04),STR(cNroAus,4,0))
       cTotAus := IF(EMPTY(cTotAus),SPACE(04),STR(cTotAus,4,0))

       AADD(aDetNot,{'cNroAus',cNroAus})
       AADD(aDetNot,{'cTotAus',cTotAus})
*>>>>FIN AUSENCIAS

*>>>>INDICADORES DE LA AREA
       aIndica := aIndicaMat(nNroPer,;
			     cCodNiv,;
			     cCodMat,;
			     lIndNiv,cLogros,cNotInd,;
			     cEvaInd,'IND')

       AADD(aDetNot,{'aIndica',aIndica})
       RETURN aDetNot
*>>>>FIN INDICADORES DE LA AREA

/*************************************************************************
* TITULO..: NOTAS DE LA MATERIA                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 04/2008 MIE A
       Colombia, Bucaramanga        INICIO: 03:45 AM   ABR 04/2008 MIE

OBJETIVOS:

1- Lee los detalles de las notas de la materia

2- Retorna un vector con la informaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aNotasMat(aParamt)

*>>>>DESCRIPCION DE PARAMETROS
       LOCAL aDetMat := xPrm(aParamt,'aDetMat') // Detalles del Area
       LOCAL nNroPer := xPrm(aParamt,'nNroPer') // N£mero del Periodo
       LOCAL cCodGru := xPrm(aParamt,'cCodGru') // C¢digo del Grupo
       LOCAL cEvaInd := xPrm(aParamt,'cEvaInd') // Evaluar el Indicador
       LOCAL lIndNiv := xPrm(aParamt,'lIndNiv') // .T. Indicadores por nivel
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                   // Contador

       LOCAL aDetNot := {}                  // Detalles de la Nota

       LOCAL cCodNiv := ''                  // C¢digo del Nivel
       LOCAL cCodMat := ''                  // C¢digo de la Materia

       LOCAL cCamMat := ''                  // Campo de la Materia
       LOCAL cNotMat := ''                  // Notas de la Materia
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cLogros := ''                  // Indicadores
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cNotInd := ''                  // Notas de los Indicadores
     *ÀCampos

       LOCAL cIntens := ''                  // Intensidad Horaria

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cDefNum := ''                  // Definitiva Numerica
       LOCAL cDefEva := ''                  // Definitiva Cualitativa
       LOCAL cNomDef := ''                  // Definitiva Cualitativa. Nombre

       LOCAL cCamAus := ''                  // Campos de Ausencias
       LOCAL cNroAus := ''                  // N£mero de Ausencias
       LOCAL cTotAus := ''                  // Total de de Ausencias

       LOCAL aIndica := ''                  // Indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DE LA MATERIA
       AADD(aDetNot,{'cCodAre',aDetMat[01]}) // No.01 C¢digo del Area
       AADD(aDetNot,{'cMatBol',aDetMat[02]}) // No.02 Materia para el Boletin
       AADD(aDetNot,{'cIntHor',aDetMat[03]}) // No.03 Intensidad Horaria
       AADD(aDetNot,{'cCamMat',aDetMat[04]}) // No.04 Campo de la materia
       AADD(aDetNot,{'cCamInd',aDetMat[05]}) // No.05 Campo de Indicadores
       AADD(aDetNot,{'cCamAus',aDetMat[06]}) // No.06 Campo de Ausencias
       AADD(aDetNot,{'cTitMat',aDetMat[07]}) // No.07 T¡tulo del Area
       AADD(aDetNot,{'cCamAcu',aDetMat[08]}) // No.08 Notas Acumuladas
       AADD(aDetNot,{'lCertif',aDetMat[09]}) // No.09 .T. Entra en el certificado de notas
       AADD(aDetNot,{'cMatCer',aDetMat[10]}) // No.10 Materia para el Certificado
       AADD(aDetNot,{'cSpaMat',aDetMat[11]}) // No.11 lDetAreEst. SPACE(02) para el nivel+ Materia para los indicadores.
       AADD(aDetNot,{'lNoPrnM',aDetMat[12]}) // No.12 No Imprimir la Materia en el Boletin. Ej: 1:No Imprime  0:Si Imprime
       AADD(aDetNot,{'lModali',aDetMat[13]}) // No.13 .T. Modalidad .F. No Modalidad
       AADD(aDetNot,{'cMatSel',aDetMat[14]}) // No.14 Materias Selectivas
       AADD(aDetNot,{'lNoRecu',aDetMat[15]}) // No.15 =>Materia No Recuperable
       AADD(aDetNot,{'cIntCer',aDetMat[16]}) // No.16 =>Intensidad Horaria para el Certficado
       AADD(aDetNot,{'cPrnNot',aDetMat[17]}) // No.17 =>Imprimir la Nota en el Boletin
       AADD(aDetNot,{'cPrnBol',aDetMat[18]}) // No.18 =>No Imprimir la Materia en el Boletin. Ej: 1:No Imprime  0:Si Imprime
*>>>>FIN DETALLES DE LA MATERIA

*>>>>CAMPOS DE MATERIA
       cCodNiv := SUBS(cCodGru,1,2)

       cCamMat := xPrm(aDetNot,'cCamMat')
       cNotMat := &cCamMat

       cCamInd := xPrm(aDetNot,'cCamInd')
       cLogros := ALLTRIM(&cCamInd)+SPACE(01)
       AADD(aDetNot,{'cLogros',cLogros})

       cCodMat := SUBS(cCamMat,9,4)
       cCamAus := 'NOT->cFa'+cCodMat+'Not'

       IF lHayJnt(cEvaInd)
	  cCamNtI := 'NOT->cN'+STR(nNroPer,1)+cCodMat+'Not'
	  cNotInd := &cCamNtI
       ELSE
	  cCamNtI := NIL
	  cNotInd := ''
       ENDIF
       AADD(aDetNot,{'cNotInd',cNotInd})
*>>>>FIN CAMPOS DE MATERIA

*>>>>INTENSIDAD HORARIA
       cIntens := xPrm(aDetNot,'cIntHor')
       IF VAL(cIntens) == 0
	  cIntens := SPACE(02)
          nParameSet(aDetNot,'cIntHor',cIntens)
       ENDIF
*>>>>FIN INTENSIDAD HORARIA

*>>>>NOTAS DEL AREA
       cNotDef := SUBS(cNotMat,nNroPer*4-3,4)
       AADD(aDetNot,{'cNotDef',cNotDef}) // No.19 => Nota Defintiva

       IF EMPTY(cNotDef)
	  cDefNum := ''
	  cDefEva := ''
	  cNomDef := ''

	  AADD(aDetNot,{'cDefNum',cDefNum}) // No.20 => Definitiva N£merica
	  AADD(aDetNot,{'cDefEva',cDefEva}) // No.21 => Definitiva Cualitativa
	  AADD(aDetNot,{'cNomDef',cNomDef}) // No.22 => Definitiva Cualitativa. Nombre
       ENDIF

       IF VAL(cNotDef) > 0
	  cDefNum := cNotDef
	  cDefEva := cNotDefJvf(VAL(cDefNum))
	  cNomDef := cNombreJvf(cDefEva)

	  AADD(aDetNot,{'cDefNum',cDefNum}) // No.20 => Definitiva N£merica
	  AADD(aDetNot,{'cDefEva',cDefEva}) // No.21 => Definitiva Cualitativa
	  AADD(aDetNot,{'cNomDef',cNomDef}) // No.22 => Definitiva Cualitativa. Nombre
       ENDIF
     *ÀNota N£merica

       IF VAL(cNotDef) == 0
	  cDefNum := ''
	  cDefEva := cNotDef
	  cNomDef := cNombreEva(ALLTRIM(cDefEva))

	  AADD(aDetNot,{'cDefNum',cDefNum}) // No.20 => Definitiva N£merica
	  AADD(aDetNot,{'cDefEva',cDefEva}) // No.21 => Definitiva Cualitativa
	  AADD(aDetNot,{'cNomDef',cNomDef}) // No.22 => Definitiva Cualitativa. Nombre
       ENDIF
     *ÀNota Cualitativa
*>>>>FIN NOTAS DEL AREA

*>>>>AUSENCIAS
       cNroAus := 0
       cTotAus := 0
       IF SUBS(TCO->cTotAusTbl,nNroPer,1) == '1'
	  FOR k := 1 TO nNroPer
	     cTotAus += VAL(SUBS(&cCamAus,k*2-1,2))
	  NEXT
       ELSE
	  cNroAus := VAL(SUBS(&cCamAus,nNroPer*2-1,2))
       ENDIF
       cNroAus := IF(EMPTY(cNroAus),SPACE(04),STR(cNroAus,4,0))
       cTotAus := IF(EMPTY(cTotAus),SPACE(04),STR(cTotAus,4,0))

       AADD(aDetNot,{'cNroAus',cNroAus}) // No.23 => Ausencias del Periodo
       AADD(aDetNot,{'cTotAus',cTotAus}) // No.24 => Total Ausencias
*>>>>FIN AUSENCIAS

*>>>>INDICADORES DE LA MATERIA
       aIndica := aIndicaMat(nNroPer,;
			     cCodNiv,;
			     cCodMat,;
			     lIndNiv,cLogros,cNotInd,;
			     cEvaInd,'IND')

       AADD(aDetNot,{'aIndica',aIndica}) // No.25 => Total Ausencias
       RETURN aDetNot
*>>>>FIN INDICADORES DE LA MATERIA