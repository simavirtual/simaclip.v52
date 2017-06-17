/*                    SIMA - CONTABILIDAD ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE BOLETINES

REQUERIMIENTOS:

- Compilar: clipper FuncsBol /w/m/b

OBJETIVOS:

- Funciones aplicadas para los diferentes boletines y libro final.


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

FUNCTION Bol1IndAre(cNomEmp,cNomSis,cAnoSys,cNomEst,cNomTit,;
		    nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		    aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL   i,j,k := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL nNroInd := 0                   // N£mero de Indicador
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
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

       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
	     nJuiAre += ROUND(LEN(cJuicio)/5,0)
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	  cJuicio := ALLTRIM(&(aNotMat[i,5]))+SPACE(01)
	  nJuiMat += ROUND(LEN(cJuicio)/5,0)
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nLinCol := 3
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna

	nEncCol := 3
	nLinTop := nTotCab+nEncCol
      *Total l¡neas del encabezado

       nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,108,04,04}
       IF lHayNot .OR. lEvaInd
	  aTitulo := {'IH',cMsgBol,IF(lNotNum,'NOTA','JUIC'),'AUS.'}
       ELSE
	  aTitulo := {'IH',cMsgBol,'AUS.'}
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL NOMBRE DEL AREA
	    cNomAre := aNotAre[i,10]
	    cNomAre := cNomAre+SPACE(108-LEN(cNomAre))
	    cNota   := 'Debe venir la nota del area'
	    cIntens := SPACE(02)
	    cNota   := SPACE(04)
	    cNroFal := SPACE(02)

	    IF SUBS(aNotAre[i][4],7,4) == 'AREP'
	       IF lHayNot .OR. lEvaInd
		  aRegPrn := {cIntens,;
			      cNomAre,;
			      IF(lHayNot,cNota,SPACE(04)),;
			      cNroFal}
	       ELSE
		  aRegPrn := {cIntens,;
			      cNomAre,;
			      cNroFal}
	       ENDIF
	       @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
	    ENDIF
**********FIN IMPRESION DEL NOMBRE DEL AREA

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := NEGRA_ON+cNomAre+NEGRA_OF
		 ENDIF

		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				IF(lHayNot,cNota,SPACE(04)),;
				cNroFal}
		 ELSE
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				cNroFal}
		 ENDIF
		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > 58
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,00 SAY cTxtPrn
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF
	       *ÀDescarta los indicadores ya recuperados

		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)+SPACE(03)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     IF(lEvaInd,cCodigoTev,SPACE(04)),;
				     SPACE(02)}
		      ELSE
			  aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				      '- '+cNombreTju,;
				      SPACE(02)}
		      ENDIF
		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > 58
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp)

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,00 SAY cTxtPrn
			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)-1
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10])-1)
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10])-1)
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := NEGRA_ON+cNomMat+NEGRA_OF
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := {cIntens,;
				   ' '+cNomMat,;
				   IF(lHayNot,cNota,SPACE(04)),;
				   cNroFal}
		    ELSE
		       aRegPrn := {cIntens,;
				   ' '+cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > 58
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,00 SAY cTxtPrn
		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF
		  *ÀDescarta los indicadores ya recuperados

		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)+SPACE(03)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                      BUSQUEDA DE LA CLASE DE INDICADOR
			 cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			 cCodigoTma := SUBS(aNotMat[j,5],9,4)

			 IF cCodLog # SPACE(04)
			    cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			    IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					  'DE LA CLASE')

			       IF EMPTY(CLA->cCodigoMat)
				  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				  cCodigoTma := SUBS(aNotMat[j,5],9,4)
			       ELSE
				  cCodigoTni := SPACE(02)
				  cCodigoTma := CLA->cCodigoMat
			       ENDIF
			     *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			    ENDIF
			 ENDIF
*                      FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 IF(lEvaInd,cCodigoTev,SPACE(04)),;
					 SPACE(02)}
			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(02)}
			  ENDIF
			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > 58
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,;
					nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,00 SAY cTxtPrn
			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 58 - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= 58
		DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp)

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA OBSERVACION
*       cEstado := cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot)
      *Estado final del estudiante

       cEstado := ''
       IF nNroBis == nTotPer
	  cEstado := cAproboJui(NOT->nAproboNot)
	 *Estado final del estudiante
       ENDIF

       @ PROW()+2,00 SAY 'OBSERVACION: '+SUBRAY_ON+cEstado+SUBRAY_OF

       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL TITULAR
       cTxtPrn := 'Dir. '+cNomTit
       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL TITULAR

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DEL ENCABEZADO DEL BOLETIN            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:45 PM   JUN 27/95 MAR

OBJETIVOS:

1- Imprime el encabezado del boletin para notas y notas y juicios

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabezaBole(lOficio,nLinSpa,cTxtPrn,nNroPag,nTotReg,cNomEst,cCodEst,;
		    cCodGru,nNroLis,nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,;
		    nTipBol,cNomEmp,lPrnEmp,cNroFol,cTxtObs,cNomSec,cTitTop,;
		    cMatMod,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
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
       nNroBis                              // N£mero del bimestre
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nColEnc := 0                   // Columna del Encabezado
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lLibro  := .F.                 // .T. Encabezado del libro
       LOCAL nLinPag := 0                   // L¡neas por p gina
       LOCAL nNroLin := 0                   // N£mero de l¡neas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL
       nNroCol := IF(EMPTY(nNroCol),0,nNroCol)
       IF cNroFol # NIL
	  lLibro := .T.
       ENDIF
*>>>>FIN ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       @ PROW(),00 SAY PCL({"GraphiOn","CondenOf","ProporOf",;
			    "Pica","DraftOf","Roman"})


       cPorcen := IF(cPorcen == NIL,'',cPorcen)
       lPrnEmp := IF(lPrnEmp == NIL,.F.,lPrnEmp)

       IF lPrnEmp
	  @ PROW(),00 SAY PCL("DobAncOn")+cNomEmp+PCL("DobAncOf")

	  IF !EMPTY(cNomSec)
	     DO CASE
	     CASE 'BETHLEMITAS' $ cNomSec
		  @ PROW()+1,00 SAY PCL("DobAncOn")+cNomSec+PCL("DobAncOf")
	     ENDCASE
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

       DO CASE
       CASE lLibro
	    cTxtPrn := 'ALUMNO: '+ALLTRIM(cNomEst)+SPACE(02)+;
		       +cNroFol

       CASE !lLibro
	    cTxtPrn := 'ALUMNO: '+cNomEst+SPACE(02)+;
		       'PERIODO:' +STR(nNroBis,2)+SPACE(01)+;
			SPACE(SCO->nSpaBolCon)+ALLTRIM(SCO->cIsoBolCon)
       ENDCASE

*      nColEnc := IF(EMPTY(nNroCol),nNroCol,nNroCol-8)
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

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       IF nTipBol # 3
	  cTxtPrn := 'AREAS'+SPACE(34)+;
		     'Primer PERIODO Segundo PERIODO Tercer PERIODO '+;
		     'Cuarto PERIODO   '+STR(nPorAcu,3)+'%'+;
		     '        NOTA  Evaluacion'
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	*ÀImpresi¢n del primer encabezado
       ENDIF

       IF nTipBol # 3
	  cTxtPrn := '  Materias'+SPACE(27)+'IH  '+;
		     'N.AS N.AR' +SUBS(cPorcen,1,2)+'%'+SPACE(03)+;
		     'N.AS  N.AR'+SUBS(cPorcen,3,2)+'%'+SPACE(03)+;
		     'N.AS N.AR' +SUBS(cPorcen,5,2)+'%'+SPACE(03)+;
		     'N.AS N.AR' +SUBS(cPorcen,7,2)+'%'+SPACE(03)+;
		     'ACUM'        +SPACE(02)+;
		     'AUS.'        +SPACE(02)+;
		     'PROM'        +SPACE(02)+;
		     'Conceptual'
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	*ÀImpresi¢n del segundo encabezado
       ENDIF
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LA MODALIDAD O ESPECIALIDAD
       cMatMod := IF(cMatMod == NIL,'',cMatMod)
       nNroLin := 2
       IF !EMPTY(cMatMod)
	  SendCodes(PCL("CondenOn"))
	  @ PROW()+1,00 SAY ALLTRIM(cMatMod)
	  nNroLin := 1
       ENDIF
*>>>>FIN IMPRESION DE LA MODALIDAD O ESPECIALIDAD

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
		    IF EMPTY(COA->cTitulECoA)
		    @ PROW()+1,00 SAY 'EXCELENTE(Ee).......: '+aNroLin[i]
		    ELSE
		    @ PROW()+1,00 SAY COA->cTitulECoA+aNroLin[i]
		    ENDIF
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
		    IF EMPTY(COA->cTitulSCoA)
		    @ PROW()+1,00 SAY 'SOBRESALIENTE(Ss)...: '+aNroLin[i]
		    ELSE
		    @ PROW()+1,00 SAY COA->cTitulSCoA+aNroLin[i]
		    ENDIF
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
		    IF EMPTY(COA->cTitulACoA)
		    @ PROW()+1,00 SAY 'ACEPTABLE(Aa).......: '+aNroLin[i]
		    ELSE
		    @ PROW()+1,00 SAY COA->cTitulACoA+aNroLin[i]
		    ENDIF
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
		    IF EMPTY(COA->cTitulICoA)
		    @ PROW()+1,00 SAY 'INSUFICIENTE(Ii)....: '+aNroLin[i]
		    ELSE
		    @ PROW()+1,00 SAY COA->cTitulICoA+aNroLin[i]
		    ENDIF
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
		    IF EMPTY(COA->cTitulDCoA)
		    @ PROW()+1,00 SAY 'DEFICIENTE(Dd)......: '+aNroLin[i]
		    ELSE
		    @ PROW()+1,00 SAY COA->cTitulDCoA+aNroLin[i]
		    ENDIF
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
* TITULO DEL PROGRAMA..: IMPRESION DE UN BOLETIN CON SOLO NOTAS          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 26/95 LUN A
       Colombia, Bucaramanga        INICIO: 02:30 PM   JUN 26/95 LUN

OBJETIVOS:

1- Imprime el boletin para un estudiante con las notas solamente

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoletinNot(cNomEmp,cNomSis,cAnoSys,cNomEst,cNomTit,;
		    nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		    aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES

       LOCAL   i,j,k := 0                   // Contadores
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL cPorMat := ''                  // Porcentaje de la materia
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cAcuAre := ''                  // Acumulado del area
       LOCAL cProAre := ''                  // Promedio del area
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL nEstFinTno := 0                // Estado final de aprobaci¢n
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       nTotImp := IF(nNroBis==4,15,11)
      *L¡neas de los totales de impresi¢n

       nTotCab := IIF(TCO->nLinEspTbl+4 > 10,(TCO->nLinEspTbl+4)-10,0)
      *Total l¡neas del encabezado

       nTotReg := nTotCab+LEN(aNotAre)+LEN(aNotMat)+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO DEL BOLETIN
	    IF lPagina
	       CabezaBole(lOficio,TCO->nLinEspTbl,@cTxtPrn,nNroPag++,;
			  nTotReg,;
			  cNomEst,;
			  NOT->cCodigoEst,;
			  GRU->cCodigoGru,;
			  NOT->(RECNO()),;
			  nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,2)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

**********IMPRESION DE LA NOTA DEL AREA
	    cNroCol := '47637893'
	    @PROW()+1,00 SAY SUBS(aNotAre[i,10],1,36)
	   *Impresi¢n del nombre del area

	    FOR k:=1 TO nNroBis
	       cNota := SUBS(&(aNotAre[i,4]),k*4-3,4)
	       DO CASE
	       CASE VAL(cNota) == 0 .AND. aNotAre[i,4] = 'N'
		    IF 'SN' $ cNota
		       cNota := ' SN '
		    ENDIF
	       CASE VAL(cNota) == 0 .AND. aNotAre[i,4] # 'N'
		    cNota := ' SN '
	       CASE VAL(cNota) < 6.0
		    cNota := SUBS(&(aNotAre[i,4]),k*4-3,4)+'*'
	       ENDCASE
	       @PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY cNota
	    ENDFOR
**********FIN IMPRESION DE LA NOTA DEL AREA

**********IMPRESION DEL ACUMULADO,PROMEDIO Y EVALUACION DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREP'

*--------------IMPRESION DEL ACUMULADO
		 cCodAre := SUBS(aNotAre[i][4],11,2)
		*C¢digo del  rea

		 cCamAcu := 'NOT->cAcum'+cCodAre+'Not'
		*Campo del acumulado

		 cAcuAre := SUBS(&cCamAcu,nNroBis*5-4,5)
		*Acumulado del  rea

		 @PROW(),101  SAY cAcuAre
*--------------FIN IMPRESION DEL ACUMULADO

*--------------IMPRESION DEL PROMEDIO
		 cCamPro := 'NOT->cProm'+cCodAre+'Not'
		*Campo del promedio

		 cProAre := SUBS(&cCamPro,nNroBis*4-3,4)
		*Promedio del  rea

		 @PROW(),113 SAY cProAre+IIF(VAL(cProAre) < 6.0,'*','')
*--------------FIN IMPRESION DEL PROMEDIO

*--------------IMPRESION DE LA EVALUACION CONCEPTUAL
		 DO CASE
		 CASE VAL(cProAre) < 6.0
		      cEvalua := 'INSUFICIENTE'
		 CASE VAL(cProAre) < 8.0
		      cEvalua := 'ACEPTABLE'
		 CASE VAL(cProAre) < 9.0
		      cEvalua := 'BUENO'
		 OTHERWISE
		      cEvalua := 'EXCELENTE'
		 ENDCASE
		 @PROW(),120 SAY cEvalua
*--------------FIN IMPRESION DE LA EVALUACION CONCEPTUAL

	    ENDIF
**********FIN IMPRESION DEL ACUMULADO,PROMEDIO Y EVALUACION DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS SI LA MATERIA VIENE COMO AREA
		    IF SUBS(aNotMat[j,4],11,2) == '00'
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS SI LA MATERIA VIENE COMO AREA

*-----------------IMPRESION DE LA MATERIA E INTESIDAD HORARIA
		    cPorMat := VAL(SUBS(aNotMat[j,4],13,3))
		    cPorMat := IF(cPorMat == 100,;
				  STR(cPorMat,3)+'%',STR(cPorMat,2)+'% ')
		   *Porcentaje aplicado a la materia

		    IF lMatVar
		       @PROW()+1,02 SAY cPorMat+SUBS(aNotMat[j,10],1,30)
		     *ÀMateria Notas o Certificado
		    ELSE
		       @PROW()+1,02 SAY cPorMat+SUBS(aNotMat[j,10],1,30)
		    ENDIF
		   *Impresi¢n del nombre de la materia

		    @PROW()  ,37 SAY aNotMat[j,3]
		   *Impresi¢n de la intensidad horaria
*-----------------FIN IMPRESION DE LA MATERIA E INTESIDAD HORARIA

*-----------------IMPRESION DE LA NOTA DE LA MATERIA
		    cNroCol := '41567287'
		    FOR k:=1 TO nNroBis

			cNota := SUBS(&(aNotMat[j,4]),k*4-3,4)
		       *Nota de la materia

			DO CASE
			CASE VAL(cNota) == 0
			     cNota := ' SN '
			CASE VAL(cNota) < 6.0
			     cNota := SUBS(&(aNotMat[j,4]),k*4-3,4)+'*'
			ENDCASE
			@PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY cNota

		    ENDFOR
*-----------------FIN IMPRESION DE LA NOTA DE LA MATERIA

*-----------------IMPRESION DE LAS AUSENCIAS
		    cCamFal := aNotMat[j,6]
		    @PROW(),108 SAY SUBS(&cCamFal,nNroBis*2-1,2)
*-----------------FIN IMPRESION DE LAS AUSENCIAS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 58 - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= 58
		DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(lOficio,TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,2)
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LOS PROMEDIOS GENERALES
       cNroCol := '47637893'
       @PROW()+2,00 SAY 'PROMEDIO PARA CADA PERIODO ...'
       FOR k := 1 TO nNroBis
	   @PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY;
					      SUBS(NOT->cPromedNot,k*4-3,4)
	  *Impresi¢n del acumulado del periodo
       ENDFOR
       @PROW(),113 SAY SUBS(NOT->cPromedNot,(nNroBis+4)*4-3,4)
      *Impresi¢n del promedio general del alumno
*>>>>FIN IMPRESION DE LOS PROMEDIOS GENERALES

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == 4 .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 DO CASE
		 CASE k == 1
		     cFecHabTno := cFecha(NOT->dFecha1Not)
		 CASE k == 2
		    cFecHabTno := cFecha(NOT->dFecha2Not)
		 ENDCASE
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA OBSERVACION
       cEstado := cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot)
      *Estado final del estudiante

       @ PROW()+2,00 SAY 'OBSERVACION: '+SUBRAY_ON+cEstado+SUBRAY_OF

       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL TITULAR
       cTxtPrn := 'Dir. '+cNomTit
       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL TITULAR

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DE UN BOLETIN CON NOTAS Y JUICIOS     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 26/95 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   JUN 26/95 LUN

OBJETIVOS:

1- Imprime el boletin para un estudiante con las notas y juicios

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoletinNyJ(cNomEmp,cNomSis,cAnoSys,cNomEst,cNomTit,;
		    nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		    aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia
       LOCAL nLenTxt := 0                   // Longitud del Texto

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL cPorMat := ''                  // Porcentaje de la materia
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cAcuAre := ''                  // Acumulado del area
       LOCAL cProAre := ''                  // Promedio del area
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL nTotPer := 0                   // Total de periodos.
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cJuicio := SUBS(&(aNotAre[i,6]),nNroBis*16-15,16)
	     nJuiAre += LEN(ALLTRIM(cJuicio))/4
	  ENDIF
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	  cJuicio := SUBS(&(aNotMat[i,5]),nNroBis*16-15,16)
	  nJuiMat += LEN(ALLTRIM(cJuicio))/4
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       nTotImp := IF(nNroBis==4,15,11)
      *L¡neas de los totales de impresi¢n

       nTotCab := IIF(TCO->nLinEspTbl+4 > 10,(TCO->nLinEspTbl+4)-10,0)
      *Total l¡neas del encabezado

       nTotReg := nTotCab+LEN(aNotAre)+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO DEL BOLETIN
	    IF lPagina
	       CabezaBole(lOficio,TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
			  cNomEst,;
			  NOT->cCodigoEst,;
			  GRU->cCodigoGru,;
			  NOT->(RECNO()),;
			  nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,2)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

**********IMPRESION DE LAS NOTAS DEL AREA
	    cNroCol := '47637893'
	    @PROW()+1,00 SAY aNotAre[i,10]
	   *Impresi¢n del nombre del area

	    FOR k:=1 TO nNroBis
		cNota := SUBS(&(aNotAre[i,4]),k*4-3,4)
		DO CASE
		CASE VAL(cNota) == 0 .AND. aNotAre[i,4] = 'N'
		     IF 'SN' $ cNota
			cNota := ' SN '
		     ENDIF
		CASE VAL(cNota) == 0 .AND. aNotAre[i,4] # 'N'
		     cNota := ' SN '
		CASE VAL(cNota) < 6.0
		     cNota := SUBS(&(aNotAre[i,4]),k*4-3,4)+'*'
		ENDCASE
		@PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY cNota
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LOS JUICIOS
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------VALIDACION Y BUSQUEDA DEL JUICIO
		 cJuicio := SUBS(&(aNotAre[i,6]),nNroBis*16-15,16)
		 FOR j:= 1 TO 4

*                   VALIDACION DEL JUICIO
		      cCodJui := SUBS(cJuicio,j*4-3,4)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*                   FIN VALIDACION DEL JUICIO

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)
		      cCodigoTju := cCodigoTma+cCodJui
		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui

		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
		      @PROW()+1,02 SAY cNombreTju
*   		    FIN BUSQUEDA DEL JUICIO

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > 58
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,@cTxtPrn,;
				    nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,2)
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN VALIDACION Y BUSQUEDA DEL JUICIO

	    ENDIF
**********FIN IMPRESION DE LOS JUICIOS

**********IMPRESION DEL ACUMULADO,PROMEDIO Y EVALUACION DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREP'

*--------------IMPRESION DEL ACUMULADO
		 cCodAre := SUBS(aNotAre[i][4],11,2)
		*C¢digo del  rea

		 cCamAcu := 'NOT->cAcum'+cCodAre+'Not'
		*Campo del acumulado

		 cAcuAre := SUBS(&cCamAcu,nNroBis*5-4,5)
		*Acumulado del  rea

		 @PROW(),101  SAY cAcuAre
*--------------FIN IMPRESION DEL ACUMULADO

*--------------IMPRESION DEL PROMEDIO
		 cCamPro := 'NOT->cProm'+cCodAre+'Not'
		*Campo del promedio

		 cProAre := SUBS(&cCamPro,nNroBis*4-3,4)
		*Promedio del  rea

		 @PROW(),113 SAY cProAre+IIF(VAL(cProAre) < 6.0,'*','')
*--------------FIN IMPRESION DEL PROMEDIO

*--------------IMPRESION DE LA EVALUACION CONCEPTUAL
		 DO CASE
		 CASE VAL(cProAre) < 6.0
		      cEvalua := 'INSUFICIENTE'
		 CASE VAL(cProAre) < 8.0
		      cEvalua := 'ACEPTABLE'
		 CASE VAL(cProAre) < 9.0
		      cEvalua := 'BUENO'
		 OTHERWISE
		      cEvalua := 'EXCELENTE'
		 ENDCASE
		 @PROW(),120 SAY cEvalua
*--------------FIN IMPRESION DE LA EVALUACION CONCEPTUAL

	    ENDIF
**********FIN IMPRESION DEL ACUMULADO,PROMEDIO Y EVALUACION DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------IMPRESION DE LA MATERIA E INTESIDAD HORARIA
		    cPorMat := VAL(SUBS(aNotMat[j,4],13,3))
		    cPorMat := IF(cPorMat == 100,;
				  STR(cPorMat,3)+'%',STR(cPorMat,2)+'% ')
		   *Porcentaje aplicado a la materia

		    IF lMatVar
		       @PROW()+1,02 SAY cPorMat+aNotMat[j,10]
		     *ÀMateria Notas o Certificado
		    ELSE
		       @PROW()+1,02 SAY cPorMat+aNotMat[j,10]
		    ENDIF
		   *Impresi¢n del nombre de la materia

		    @PROW()  ,37 SAY aNotMat[j,3]
		   *Impresi¢n de la intensidad horaria
*-----------------FIN IMPRESION DE LA MATERIA E INTESIDAD HORARIA

*-----------------IMPRESION DE LA NOTA DE LA MATERIA
		    cNroCol := '41567287'
		    FOR k:=1 TO nNroBis

			cNota := SUBS(&(aNotMat[j,4]),k*4-3,4)
		       *Nota de la materia

			DO CASE
			CASE VAL(cNota) == 0
			     cNota := ' SN '
			CASE VAL(cNota) < 6.0
			     cNota := SUBS(&(aNotMat[j,4]),k*4-3,4)+'*'
			ENDCASE
			@PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY cNota

		    ENDFOR
*-----------------FIN IMPRESION DE LA NOTA DE LA MATERIA

*-----------------IMPRESION DE LAS AUSENCIAS
		    cCamFal := aNotMat[j,6]
		    @PROW(),108 SAY SUBS(&cCamFal,nNroBis*2-1,2)
*-----------------FIN IMPRESION DE LAS AUSENCIAS

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := SUBS(&(aNotMat[j,5]),nNroBis*16-15,16)
		    FOR k:= 1 TO 4

*			VALIDACION DEL JUICIO
			  cCodJui := SUBS(cJuicio,k*4-3,4)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*			BUSQUEDA DEL JUICIO
			  cCodigoTma := SUBS(aNotMat[j,5],9,4)
			  cCodigoTju := cCodigoTma+cCodJui
			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui

			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
			  @PROW()+1,04 SAY cNombreTju
*			FIN BUSQUEDA DEL JUICIO

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > 58
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,@cTxtPrn,;
					nNroPag++,;
					nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,cJorTxt,2)
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 58 - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= 58
		DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(lOficio,TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,2)
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LOS PROMEDIOS GENERALES
       cNroCol := '47637893'
       @PROW()+2,00 SAY 'PROMEDIO PARA CADA PERIODO ...'
       FOR k := 1 TO nNroBis
	   @PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY;
					      SUBS(NOT->cPromedNot,k*4-3,4)
	  *Impresi¢n del acumulado del periodo
       ENDFOR
       @PROW(),113 SAY SUBS(NOT->cPromedNot,(nNroBis+4)*4-3,4)
      *Impresi¢n del promedio general del alumno
*>>>>FIN IMPRESION DE LOS PROMEDIOS GENERALES

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == 4 .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHabNot)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
       cEstado := cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot)
      *Estado final del estudiante

       @ PROW()+2,00 SAY 'OBSERVACION: '+SUBRAY_ON+cEstado+SUBRAY_OF
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       nTotPer := TCO->nTotPerTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)

       aMatHab := {}

       IF nNroBis == nTotPer
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''
	  cTxtPrn := 'ACTIVIDADES DE RECUPERACION DE:'
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
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF nNroBis == nTotPer .AND. !EMPTY(&cMaeAct->cObsLibEst)
	  aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General.

       @ PROW()+2,00 SAY 'OBSERVACIONES:'
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+2,00 SAY REPL('-',nLenTxt)
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL TITULAR
       cTxtPrn := 'Dir. '+cNomTit
       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL TITULAR

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DE UN BOLETIN CON JUICIOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 28/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:10 PM   JUN 28/95 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo juicios

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoletinJui(cNomEmp,cNomSis,cAnoSys,cNomEst,cNomTit,;
		    nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		    aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,x := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lPrnEva := .F.                 // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       LOCAL nLenEva := 0                   // Longitud del Nombre de la Evaluaci¢n del Indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin

       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL nNroInd := 0                   // N£mero de Indicador
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
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
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cCampos := ''                  // Variable de Campo

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cCampos := aNotAre[i,6]
	     cJuicio := &cCampos
	     nJuiAre += LEN(aJuicio(@cJuicio))
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='1',.T.,.F.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	   cCampos := aNotMat[i,5]
	   cJuicio := &cCampos
	   nJuiMat += LEN(aJuicio(@cJuicio))
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna

	nEncCol := 3
	nLinTop := nTotCab+nEncCol
      *Total l¡neas del encabezado

       nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,108,IF(lPrnEva,IF(nLenEva>4,nLenEva,06),04),04}
       IF lHayNot .OR. lEvaInd
	  aTitulo := {'IH',cMsgBol,IF(lNotNum,'NOTA',;
				      IF(lPrnEva,'JUICIO','JUIC')),'AUS.'}
       ELSE
	  aTitulo := {'IH',cMsgBol,'AUS.'}
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		 cNota := ALLTRIM(cNota)
		 DO CASE
		 CASE VAL(cNota) == 0 .AND. aNotAre[i,4] = 'N'
		      IF 'SN' $ cNota
			 cNota := ' SN '
		      ENDIF
		 CASE VAL(cNota) == 0 .AND. aNotAre[i,4] # 'N'
		      cNota := ' SN '
		 ENDCASE
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := NEGRA_ON+cNomAre+NEGRA_OF
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				IF(lHayNot,cNota,SPACE(IF(lPrnEva,;
				   IF(nLenEva>4,nLenEva,06),04))),;
				cNroFal}
		 ELSE
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				cNroFal}
		 ENDIF
		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,00 SAY cTxtPrn
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cCampos := aNotAre[i,6]
		 cJuicio := &cCampos
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',cCodigoTev,;
				       'DE LA EVALUACION')
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     IF(lEvaInd,cCodigoTev,SPACE(04)),;
				     SPACE(02)}
		      ELSE
			  aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				      '- '+cNombreTju,;
				      SPACE(02)}
		      ENDIF
		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {SPACE(02),;
					 '  '+cNombreTju,;
					 SPACE(04),;
					 SPACE(02)}
			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(02)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > IIF(lOficio,70,58)
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp)

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,00 SAY cTxtPrn
			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		    DO CASE
		    CASE VAL(cNota) == 0
*			 cNota := ' SN '
		    ENDCASE
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF
		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := NEGRA_ON+cNomMat+NEGRA_OF
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   IF(lHayNot,cNota,SPACE(IF(lPrnEva,;
				   IF(nLenEva>4,nLenEva,06),04))),;
				   cNroFal}
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,00 SAY cTxtPrn
		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cCampos := aNotMat[j,5]
		    cJuicio := &cCampos
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',cCodigoTev,;
					   'DE LA EVALUACION')
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			 ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 IF(lEvaInd,cCodigoTev,SPACE(04)),;
					 SPACE(02)}
			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(02)}
			  ENDIF
			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      IF lHayNot .OR. lEvaInd
				 aRegPrn := {SPACE(02),;
					     '  '+cNombreTju,;
					     SPACE(04),;
					     SPACE(02)}
			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(02)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > IIF(lOficio,70,58)
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,00 SAY cTxtPrn
			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       nLenTxt := LEN(cTxtPrn)
       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
      *Impresi¢n de la £ltima l¡nea
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp)

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
       IF nNroBis == nTotPer
	  cEstado := ALLTRIM(cAproboJui(NOT->nAproboNot))
	 *Estado final del estudiante

	  @ PROW()+1,00 SAY 'OBSERVACION FINAL: '+SUBRAY_ON+cEstado+SUBRAY_OF
       ENDIF
      *Estado final del estudiante
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       aMatHab := {}
       IF nNroBis == nTotPer
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''

	  cTxtPrn := IF(EMPTY(TCO->cTitRecTbl),;
		       'ACTIVIDADES DE RECUPERACION DE',;
			ALLTRIM(TCO->cTitRecTbl))+':'
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
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF nNroBis == nTotPer .AND. !EMPTY(&cMaeAct->cObsLibEst)
	  aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General.

       @ PROW()+2,00 SAY 'OBSERVACIONES:'
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+2,00 SAY REPL('-',nLenTxt)
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL TITULAR
       cTxtPrn := 'Dir. '+cNomTit
       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL TITULAR

/*************************************************************************
* TITULO DEL PROGRAMA..: BOLETIN No. 5                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 28/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:10 PM   JUN 28/95 MIE

OBJETIVOS:

1- Este boletin imprime solo indicadores, agregando el nombre del
   profesor como animador.

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin05(cNomEmp,cNomSis,cAnoSys,cNomEst,cNomTit,;
		   nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,x := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lPrnEva := .F.                 // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       LOCAL nLenEva := 0                   // Longitud del Nombre de la Evaluaci¢n del Indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL nNroInd := 0                   // N£mero de Indicador
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
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

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cJuicio := ALLTRIM(&(aNotAre[i,6]))
	     nJuiAre += LEN(aJuicio(@cJuicio))
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='1',.T.,.F.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	  cJuicio := ALLTRIM(&(aNotMat[i,5]))
	  nJuiMat += LEN(aJuicio(@cJuicio))
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna

	nEncCol := 3
	nLinTop := nTotCab+nEncCol
      *Total l¡neas del encabezado

       nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,108,IF(lPrnEva,IF(nLenEva>4,nLenEva,06),04),04}
       IF lHayNot .OR. lEvaInd
	  aTitulo := {'IH',cMsgBol,IF(lNotNum,'NOTA',;
				      IF(lPrnEva,'VALORACION','VALO')),'AUS.'}
       ELSE
	  aTitulo := {'IH',cMsgBol,'AUS.'}
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabeBole05(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomTit,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nNroBis,cAnoSys,;
			    cJorTxt,cNomEmp,lPrnEmp)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		 cNota := ALLTRIM(cNota)
		 DO CASE
		 CASE VAL(cNota) == 0 .AND. aNotAre[i,4] = 'N'
		      IF 'SN' $ cNota
			 cNota := ' SN '
		      ENDIF
		 CASE VAL(cNota) == 0 .AND. aNotAre[i,4] # 'N'
		      cNota := ' SN '
		 ENDCASE
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := NEGRA_ON+cNomAre+NEGRA_OF
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				IF(lHayNot,cNota,SPACE(IF(lPrnEva,;
				   IF(nLenEva>4,nLenEva,06),04))),;
				cNroFal}
		 ELSE
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				cNroFal}
		 ENDIF
		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT
		    CabeBole05(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomTit,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),;
			       nNroBis,cAnoSys,cJorTxt,;
			       cNomEmp,lPrnEmp)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,00 SAY cTxtPrn
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',cCodigoTev,;
				       'DE LA EVALUACION')
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     IF(lEvaInd,cCodigoTev,SPACE(04)),;
				     SPACE(02)}
		      ELSE
			  aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				      '- '+cNombreTju,;
				      SPACE(02)}
		      ENDIF
		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {SPACE(02),;
					 '  '+cNombreTju,;
					 SPACE(04),;
					 SPACE(02)}
			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(02)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > IIF(lOficio,70,58)
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
			 EJECT
			 CabeBole05(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomTit,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),;
				    nNroBis,cAnoSys,cJorTxt,;
				    cNomEmp,lPrnEmp)

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,00 SAY cTxtPrn
			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		    DO CASE
		    CASE VAL(cNota) == 0
*			 cNota := ' SN '
		    ENDCASE
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF
		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := NEGRA_ON+cNomMat+NEGRA_OF
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   IF(lHayNot,cNota,SPACE(IF(lPrnEva,;
				   IF(nLenEva>4,nLenEva,06),04))),;
				   cNroFal}
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT
		       CabeBole05(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomTit,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),;
				  nNroBis,cAnoSys,cJorTxt,;
				  cNomEmp,lPrnEmp)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,00 SAY cTxtPrn
		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',cCodigoTev,;
					   'DE LA EVALUACION')
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			 ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 IF(lEvaInd,cCodigoTev,SPACE(04)),;
					 SPACE(02)}
			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(02)}
			  ENDIF
			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      IF lHayNot .OR. lEvaInd
				 aRegPrn := {SPACE(02),;
					     '  '+cNombreTju,;
					     SPACE(04),;
					     SPACE(02)}
			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(02)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > IIF(lOficio,70,58)
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
			     EJECT
			     CabeBole05(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomTit,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),;
					nNroBis,cAnoSys,;
					cJorTxt,cNomEmp,lPrnEmp)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,00 SAY cTxtPrn
			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	     ENDIF
	     EJECT
	  ENDIF
	  CabeBole05(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,nTotReg,;
		     cNomTit,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nNroBis,cAnoSys,;
		     cJorTxt,cNomEmp,lPrnEmp)

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA OBSERVACION
*       cEstado := cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot)
      *Estado final del estudiante

       cEstado := ''
       IF nNroBis == nTotPer
	  cEstado := cAproboJui(NOT->nAproboNot)
	 *Estado final del estudiante
       ENDIF

       @ PROW()+2,00 SAY 'OBSERVACION: '+SUBRAY_ON+cEstado+SUBRAY_OF

       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL TITULAR
       cTxtPrn := 'Dir. '+cNomTit
       @ PROW()+4,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL TITULAR


/*************************************************************************
* TITULO DEL PROGRAMA..: ENCABEZADO PARA EL BOLETIN No. 5                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:45 PM   JUN 27/95 MAR

OBJETIVOS:

1- Imprime el encabezado del boletin para notas y notas y juicios

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabeBole05(lOficio,nLinSpa,cTxtPrn,nNroPag,nTotReg,cNomTit,cNomEst,;
		    cCodEst,cCodGru,nNroLis,nNroBis,cAnoSys,cJorTxt,cNomEmp,;
		    lPrnEmp,cNroFol)

*>>>>PARAMETROS DE LA FUNCION
/*     lOficio                              // .F. Tama¤o Carta
       nLinSpa                              // Espacios para el encabezado
       cTxtPrn                              // @Texto de impresion
       nNroPag                              // N£mero de p gina
       nTotReg			            // Total registros a imprimir
       cNomTit                              // Nombre del titular
       cNomEst                              // Nombre del Estudiante
       cCodEst                              // C¢digo del estudiante
       nNroLis                              // N£mero de lista
       nNroBis                              // N£mero del bimestre
       cAnoSys                              // A¤o del sistema
       cJotTxt                              // Jornada escogidad
       cNomEmp                              // Nombre de Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del folio */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES

       LOCAL lLibro  := .F.                 // .T. Encabezado del libro
       LOCAL nLinPag := 0                   // L¡neas por p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL
       IF cNroFol # NIL
	  lLibro := .T.
       ENDIF
*>>>>FIN ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+;
			    PICA+DRAFT_OF+ROMAN_ON

       lPrnEmp := IF(lPrnEmp == NIL,.F.,lPrnEmp)

       IF lPrnEmp
	  @ PROW(),00 SAY DOBANC_ON+cNomEmp+DOBANC_OF
       ENDIF
*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL NOMBRE DEL TITULAR
       cTxtPrn :=    'ANIMADOR: '+cNomTit

       @ PROW()+nLinSpa,00 SAY cTxtPrn
*>>>>FIN IMPRESION DEL NOMBRE DEL TITULAR

*>>>>IMPRESION DEL NOMBRE DEL ALUMNO
       DO CASE
       CASE lLibro
	    cTxtPrn := 'ALUMNO: '+ALLTRIM(cNomEst)+SPACE(02)+;
		       'FOLIO No.. '+cNroFol

       CASE !lLibro
	    cTxtPrn := 'ALUMNO: '+cNomEst+SPACE(04)+;
		       'PERIODO:' +STR(nNroBis,2)
       ENDCASE

       @ PROW()+1,00 SAY cTxtPrn
*>>>>FIN IMPRESION DEL NOMBRE DEL ALUMNO

*>>>>IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA
       nLinPag := IF(lOficio,54,46)
       cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		  'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
			     SUBS(cCodGru,3,2)+SPACE(02)+;
		  'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		  'A¥O:'    +cAnoSys          +SPACE(01)+;
		  'JORNADA:'+cJorTxt          +SPACE(01)+;
		  'P gina No.'+LTRIM(STR(nNroPag))+'/'+;
		  cTotPagina(nTotReg,nLinPag,lOficio)

       @ PROW()+1,00 SAY cTxtPrn
       @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
       RETURN NIL
*>>>>FIN IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA

/*************************************************************************
* TITULO DEL PROGRAMA..: BOLETIN No. 6                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 28/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:10 PM   JUN 28/95 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo juicios

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Dise¤o para el Colegio Bethelemitas de Barranca.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin06(cEmpPal,cNomEmp,cNomSis,cAnoSys,cNomEst,;
		   cNomTit,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cEmpPal                              // Nombre de Empresa Principal
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,x := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lPiePag := .F.                 // .T. Imprime el Pie de P gina
       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lPrnEva := .F.                 // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       LOCAL nLenEva := 0                   // Longitud del Nombre de la Evaluaci¢n del Indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL aFirmas := {}                  // Firmas del Boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL nNroInd := 0                   // N£mero de Indicador
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
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
       LOCAL cTxtTop := ''                  // Texto para el Encabezado
       LOCAL nLenCod := 6                   // Longitud del C¢digo

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cJuicio := ALLTRIM(&(aNotAre[i,6]))
	     nJuiAre += LEN(aJuicio(@cJuicio))
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       cTxtTop := ALLTRIM(SCO->cTxtLibCon)+;
		  ALLTRIM(SCO->cTxtLi1Con)
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='1',.T.,.F.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	  cJuicio := ALLTRIM(&(aNotMat[i,5]))
	  nJuiMat += LEN(aJuicio(@cJuicio))
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna

	nEncCol := 3
	nLinTop := nTotCab+nEncCol
      *Total l¡neas del encabezado

       nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,108,IF(lPrnEva,IF(nLenEva>4,nLenEva,06),04),04}
       IF lHayNot .OR. lEvaInd
	  aTitulo := {'IH',cMsgBol,IF(lNotNum,'NOTA',;
				      IF(lPrnEva,'JUICIO','JUIC')),'AUS.'}
       ELSE
	  aTitulo := {'IH',cMsgBol,'AUS.'}
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabeBole06(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cEmpPal,cNomEmp,lPrnEmp,cTxtTop)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		 cNota := ALLTRIM(cNota)
		 DO CASE
		 CASE VAL(cNota) == 0 .AND. aNotAre[i,4] = 'N'
		      IF 'SN' $ cNota
			 cNota := ' SN '
		      ENDIF
		 CASE VAL(cNota) == 0 .AND. aNotAre[i,4] # 'N'
		      cNota := ' SN '
		 ENDCASE
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := NEGRA_ON+cNomAre+NEGRA_OF
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				IF(lHayNot,cNota,SPACE(IF(lPrnEva,;
				   IF(nLenEva>4,nLenEva,06),04))),;
				cNroFal}
		 ELSE
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
				cNroFal}
		 ENDIF
		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabeBole06(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cEmpPal,cNomEmp,lPrnEmp,cTxtTop)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,00 SAY cTxtPrn
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',cCodigoTev,;
				       'DE LA EVALUACION')
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     IF(lEvaInd,cCodigoTev,SPACE(04)),;
				     SPACE(02)}
		      ELSE
			  aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				      '- '+cNombreTju,;
				      SPACE(02)}
		      ENDIF
		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {SPACE(02),;
					 '  '+cNombreTju,;
					 SPACE(04),;
					 SPACE(02)}
			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(02)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > IIF(lOficio,70,58)
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabeBole06(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cEmpPal,cNomEmp,lPrnEmp,cTxtTop)

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,00 SAY cTxtPrn
			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		    DO CASE
		    CASE VAL(cNota) == 0
*			 cNota := ' SN '
		    ENDCASE
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := NEGRA_ON+cNomMat+NEGRA_OF
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   IF(lHayNot,cNota,SPACE(IF(lPrnEva,;
				   IF(nLenEva>4,nLenEva,06),04))),;
				   cNroFal}
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabeBole06(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cEmpPal,cNomEmp,lPrnEmp,cTxtTop)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,00 SAY cTxtPrn
		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',cCodigoTev,;
					   'DE LA EVALUACION')
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			 ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 IF(lEvaInd,cCodigoTev,SPACE(04)),;
					 SPACE(02)}
			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(02)}
			  ENDIF
			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      IF lHayNot .OR. lEvaInd
				 aRegPrn := {SPACE(02),;
					     '  '+cNombreTju,;
					     SPACE(04),;
					     SPACE(02)}
			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(02)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > IIF(lOficio,70,58)
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			     EJECT
			     CabeBole06(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cEmpPal,cNomEmp,;
					lPrnEmp,cTxtTop)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,00 SAY cTxtPrn
			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	     ENDIF
	     EJECT
	  ENDIF
	  CabeBole06(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cEmpPal,cNomEmp,lPrnEmp,cTxtTop)

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA OBSERVACION
*       cEstado := cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot)
      *Estado final del estudiante

       cEstado := ''
       IF nNroBis == nTotPer
	  cEstado := ALLTRIM(cAproboJui(NOT->nAproboNot))
	 *Estado final del estudiante
       ENDIF

       @ PROW()+2,00 SAY 'OBSERVACION: '+SUBRAY_ON+cEstado+SUBRAY_OF

       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>FIRMANTES DEL BOLETIN
       aFirmas := {{ALLTRIM(SCO->cGerentCon),NIL,ALLTRIM(SCO->cCarGerCon)},;
		   {cNomTit,NIL,'Dir.'}}

       Firmas(n17Stan,4,aFirmas)
      *Impresi¢n firmantes del libro

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
       EJECT
       RETURN NIL
*>>>>FIN FIRMANTES DEL BOLETIN

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DEL ENCABEZADO DEL BOLETIN No. 6      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:45 PM   JUN 27/95 MAR

OBJETIVOS:

1- Imprime el encabezado del boletin para notas y notas y juicios

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabeBole06(lOficio,nLinSpa,cTxtPrn,nNroPag,nTotReg,cNomEst,cCodEst,;
		    cCodGru,nNroLis,nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,;
		    nTipBol,cEmpPal,cNomEmp,lPrnEmp,cTxtObs,cNroFol)

*>>>>PARAMETROS DE LA FUNCION
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
       nNroBis                              // N£mero del bimestre
       cAnoSys                              // A¤o del sistema
       cJotTxt                              // Jornada escogidad
       nTipBol                              // Tipo de boletin
       cEmpPal                              // Empresa Principal
       cNomEmp                              // Nombre de Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cTxtObs                              // Texto de Observaci¢n
       cNroFol                              // N£mero del folio */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lLibro  := .F.                 // .T. Encabezado del libro
       LOCAL nLinPag := 0                   // L¡neas por p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL
       IF cNroFol # NIL
	  lLibro := .T.
       ENDIF
*>>>>FIN ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+;
			    PICA+DRAFT_OF+ROMAN_ON

       cPorcen := IF(cPorcen == NIL,'',cPorcen)
       lPrnEmp := IF(lPrnEmp == NIL,.F.,lPrnEmp)

       IF lPrnEmp
	  @ PROW()  ,00 SAY DOBANC_ON+cNomEmp+DOBANC_OF
	  @ PROW()+1,00 SAY DOBANC_ON+cEmpPal+DOBANC_OF

	  SendCodes(CONDEN_ON)
	  aNroLin := aDivLin(ALLTRIM(cTxtObs),120)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
	  SendCodes(CONDEN_OF)
	*ÀImpresi¢n del Texto despu‚s de la Empresa

       ENDIF
*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL NOMBRE DEL ALUMNO
       cTxtPrn :=    'ALUMNO: '+cNomEst+SPACE(02)+;
		     IF(lLibro,SPACE(01)+'FOLIO No. '+cNroFol,;
			       SPACE(02)+'PERIODO:' +STR(nNroBis,2))

       @ PROW()+nLinSpa,00 SAY cTxtPrn
*>>>>FIN IMPRESION DEL NOMBRE DEL ALUMNO

*>>>>IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA
       nLinPag := IF(lOficio,54,46)
       cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		  'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
			     SUBS(cCodGru,3,2)+SPACE(02)+;
		  'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		  'A¥O:'    +cAnoSys          +SPACE(01)+;
		  'JORNADA:'+cJorTxt          +SPACE(01)+;
		  'P gina No.'+LTRIM(STR(nNroPag))+'/'+;
		  cTotPagina(nTotReg,nLinPag,lOficio)

       @ PROW()+1,00 SAY cTxtPrn
       @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
*>>>>FIN IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       IF nTipBol # 3
	  cTxtPrn := 'AREAS'+SPACE(34)+;
		     'Primer PERIODO Segundo PERIODO Tercer PERIODO '+;
		     'Cuarto PERIODO   '+STR(nPorAcu,3)+'%'+;
		     '        NOTA  Evaluacion'
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	*ÀImpresi¢n del primer encabezado
       ENDIF

       IF nTipBol # 3
	  cTxtPrn := '  Materias'+SPACE(27)+'IH  '+;
		     'N.AS N.AR' +SUBS(cPorcen,1,2)+'%'+SPACE(03)+;
		     'N.AS  N.AR'+SUBS(cPorcen,3,2)+'%'+SPACE(03)+;
		     'N.AS N.AR' +SUBS(cPorcen,5,2)+'%'+SPACE(03)+;
		     'N.AS N.AR' +SUBS(cPorcen,7,2)+'%'+SPACE(03)+;
		     'ACUM'        +SPACE(02)+;
		     'AUS.'        +SPACE(02)+;
		     'PROM'        +SPACE(02)+;
		     'Conceptual'
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	*ÀImpresi¢n del segundo encabezado
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin07(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		 cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			    nColEnc)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		    IF VAL(cNota) > 0
		       cNota := cNotDefJvf(VAL(cNota))
		    ENDIF

		 ELSE

		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			IF VAL(cNotDef) # 0
			   cNotDef := cNotDefJvf(VAL(cNotDef))
			   cNotRec := cNotDefJvf(VAL(cNotRec))
			ENDIF

			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrnBol(lPrnNotPla(lHayNot,;
						     aNotAre[i][17],;
						     nNroBis),;
					  lNotNum,lEvaInd,lPrnEva,;
					  nLenEva,lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			       nColEnc)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,nNroCol SAY cTxtPrn
		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF
	       *ÀDescarta los indicadores ya recuperados.

		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)

		      cCodigoTev := cCodEvaNot(TCO->cEvaIndTbl,;
					       nNroBis,;
					       aNotAre[i,4],;
					       cCodJui,;
					       cCodigoTev,j)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva

			 IF VAL(cCodigoTev) == 0  .AND.;
			    !(':' $ cCodigoTev)  // Modificado Virrey

			    IF lLocCodigo('cCodigoEva','EVA',;
					  SUBS(cCodigoTev,1,1),;
					  'DE LA EVALUACION '+cCodJui)
			       cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			    ELSE
			       cCodigoTev := 'NO EXISTE'
			    ENDIF

			 ENDIF

		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso
			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(02))
			      *Espacio de Intensidad

			       AADD(aRegPrn,cNomCla)
			      *Espacio de Juicio

			       IF EMPTY(cNotAcu)
				  AADD(aRegPrn,SPACE(04))
			       ELSE
				  FOR p := 1 TO nNroBis
				     AADD(aRegPrn,SPACE(02))
				  ENDFOR
			       ENDIF
			     *ÀEspacio de la Nota

			       AADD(aRegPrn,SPACE(02))
			      *Espacio de la Ausencia

			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF
			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := {}
			 AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			 AADD(aRegPrn,'- '+cNombreTju)

			 IF EMPTY(cNotAcu)
			    AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			 ELSE
			    FOR p := 1 TO nNroBis
				AADD(aRegPrn,SPACE(02))
			    ENDFOR
			 ENDIF
			 AADD(aRegPrn,SPACE(04))

		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(02))
			     AADD(aRegPrn,'  '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,SPACE(04))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,nNroCol SAY cTxtPrn
			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,nNroCol SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]  // Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''),,;
					       nColEnc)}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+cTitReS+;
					  SPACE(108-LEN(cTitReS))+;
					  PCL("NegraOf")

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReS)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 y,nNroCol)

			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+;
					  cTitReN+SPACE(108-LEN(cTitReN))+;
					  PCL("NegraOf")

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReN)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 y,nNroCol)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					     nLenEva,lPrnCod,nNroBis,cNotAcu,;
					     REPL(cChrLin,aNroCol[1]),;
					     REPL(cChrLin,aNroCol[2]),;
					     REPL(cChrLin,aNroCol[3]),;
					     REPL(cChrLin,aNroCol[4]))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

		       IF VAL(cNota) > 0
			  cNota := cNotDefJvf(VAL(cNota))
		       ENDIF

		    ELSE

		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis

			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			   IF VAL(cNotDef) > 0
			      cNotDef := cNotDefJvf(VAL(cNotDef))
			      cNotRec := cNotDefJvf(VAL(cNotRec))
			   ENDIF

			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre

		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,02])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,02]+SPACE(108-LEN(aNotMat[j,02]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lPrnNotPla(lHayNot,;
							aNotMat[j][17],;
							nNroBis),;
					     lNotNum,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF

		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
				  nColEnc)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,nNroCol SAY cTxtPrn
		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF
		  *ÀDescarta los indicadores ya recuperados

		    lSiPaso := .F.
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)

			  cCodigoTev := cCodEvaNot(TCO->cEvaIndTbl,;
						   nNroBis,;
						   aNotMat[j,4],;
						   cCodJui,;
						   cCodigoTev,k)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva

			     IF VAL(cCodigoTev) == 0 .AND.;
				!(':' $ cCodigoTev)  // Modificado Virrey

				IF lLocCodigo('cCodigoEva','EVA',;
					      SUBS(cCodigoTev,1,1),;
					      'DE LA EVALUACION '+cCodJui)
				   cCodigoTev := SUBS(EVA->cNombreEva,1,;
						      nLenEva)
				ELSE
				   cCodigoTev := 'NO EXISTE'
				ENDIF

			     ENDIF

			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso
				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cNomCla)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(02))

				   @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := {}
			     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			     AADD(aRegPrn,'- '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      IF lHayNot .OR. lEvaInd

				 aRegPrn := {}
				 AADD(aRegPrn,SPACE(02))
				 AADD(aRegPrn,'  '+cNombreTju)

				 IF EMPTY(cNotAcu)
				    AADD(aRegPrn,SPACE(04))
				 ELSE
				    FOR p := 1 TO nNroBis
					AADD(aRegPrn,SPACE(02))
				    ENDFOR
				 ENDIF
				 AADD(aRegPrn,SPACE(04))

			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''),,;
					nColEnc)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,nNroCol SAY cTxtPrn
			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]  // Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''),,;
						  nColEnc)}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+;
					   cTitReS+SPACE(108-LEN(cTitReS))+;
                                           PCL("NegraOf")

				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReS)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  y,nNroCol)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+;
					   cTitReN+SPACE(108-LEN(cTitReN))+;
                                           PCL("NegraOf")

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReN)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  y,nNroCol)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,;
						lPrnEva,nLenEva,lPrnCod,;
						nNroBis,cNotAcu,;
						REPL(cChrLin,aNroCol[1]),;
						REPL(cChrLin,aNroCol[2]),;
						REPL(cChrLin,aNroCol[3]),;
						REPL(cChrLin,aNroCol[4]))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
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

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
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
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
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
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura y valoraci¢n
   n£merica y boletin sugerido por el Virrey Solis.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin08(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
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
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
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
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

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
       IF aFirmas == NIL
	  cNroFol := NIL
       ELSE
	  cNroFol := 'Folio No.'
       ENDIF
*>>>>FIN ANALISIS DEL LIBRO FINAL

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol8(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		  cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		 ELSE
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrn08(lHayNot,lEvaInd,lPrnEva,nLenEva,;
					  lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,00 SAY cTxtPrn
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF

		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',;
				       SUBS(cCodigoTev,1,1),;
				       'DE LA EVALUACION '+cCodJui)
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso
			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(02))
			      *Espacio de Intensidad

			       AADD(aRegPrn,cNomCla)
			      *Espacio de Juicio

			       IF EMPTY(cNotAcu)
				  AADD(aRegPrn,SPACE(04))
			       ELSE
				  FOR p := 1 TO nNroBis
				     AADD(aRegPrn,SPACE(02))
				  ENDFOR
			       ENDIF
			     *ÀEspacio de la Nota

			       AADD(aRegPrn,SPACE(04))
			     *ÀNota Numerica

			       AADD(aRegPrn,SPACE(02))
			      *Espacio de la Ausencia

			       @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF
			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := {}
			 AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			 AADD(aRegPrn,'- '+cNombreTju)

			 IF EMPTY(cNotAcu)
			    AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			 ELSE
			    FOR p := 1 TO nNroBis
				AADD(aRegPrn,SPACE(02))
			    ENDFOR
			 ENDIF

			 AADD(aRegPrn,SPACE(04))
		       *ÀNota Numerica

			 AADD(aRegPrn,SPACE(04))
		       *ÀAusencia

		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(02))
			     AADD(aRegPrn,'  '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,SPACE(04))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF

			     AADD(aRegPrn,SPACE(04))
			   *ÀNota Numerica

			     AADD(aRegPrn,SPACE(04))

			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,00 SAY cTxtPrn
			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]   // No Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''))}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+;
					  cTitReS+SPACE(108-LEN(cTitReS))+;
                                          PCL("NegraOf")

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReS)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF

				  AADD(aRegPrn,SPACE(04))
				*ÀNota Numerica

				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,y)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+;
					  cTitReN+SPACE(108-LEN(cTitReN))+;
                                          PCL("NegraOf")

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReN)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF

				  AADD(aRegPrn,SPACE(04))
				*ÀNota Numerica

				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,y)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrn08(lHayNot,lEvaInd,lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cChrLin+cChrLin,;
					     REPL(cChrLin,108),;
					     SPACE(01),;
					     SPACE(01))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

		    ELSE
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis
			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre

		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrn08(lHayNot,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,00 SAY cTxtPrn
		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF

		    lSiPaso := .F.
		    FOR k := 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',;
					   SUBS(cCodigoTev,1,1),;
					   'DE LA EVALUACION '+cCodJui)
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso
				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cNomCla)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(02))

				   @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := {}
			     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			     AADD(aRegPrn,'- '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF

			     AADD(aRegPrn,SPACE(04))
			   *ÀNota Numerica

			     AADD(aRegPrn,SPACE(04))

			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      IF lHayNot .OR. lEvaInd

				 aRegPrn := {}
				 AADD(aRegPrn,SPACE(02))
				 AADD(aRegPrn,'  '+cNombreTju)

				 IF EMPTY(cNotAcu)
				    AADD(aRegPrn,SPACE(04))
				 ELSE
				    FOR p := 1 TO nNroBis
					AADD(aRegPrn,SPACE(02))
				    ENDFOR
				 ENDIF

				 AADD(aRegPrn,SPACE(04))
			       *ÀNota Numerica

				 AADD(aRegPrn,SPACE(04))

			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''))

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,00 SAY cTxtPrn
			     @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]   // No Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''))}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+;
					   cTitReS+SPACE(108-LEN(cTitReS))+;
                                           PCL("NegraOf")


				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReS)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF

				   AADD(aRegPrn,SPACE(04))
				 *ÀNota Numerica

				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,y)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+;
					   cTitReN+SPACE(108-LEN(cTitReN))+;
                                           PCL("NegraOf")

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReN)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF

				   AADD(aRegPrn,SPACE(04))
				 *ÀNota Numerica

				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,y)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrn08(lHayNot,lEvaInd,lPrnEva,;
						nLenEva,lPrnCod,nNroBis,;
						cNotAcu,;
						cChrLin+cChrLin,;
						REPL(cChrLin,108),;
						SPACE(01),;
						SPACE(01))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,00 SAY cTxtPrn
	  @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
	  cEstado := cAproboJui(NOT->nAproboNot,;
				SUBS(GRU->cCodigoGru,1,2),;
				     @cTxtObsTap)
	  cEstado := ALLTRIM(cEstado)
       ENDIF

       aNroLin := aDivLin(ALLTRIM('OBSERVACION: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       aMatHab := {}
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))

	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(cTxtObsTap)
	  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n de Recuperacion.

       IF !EMPTY(TCO->cObsBolTbl)
	  aNroLin := aDivLin(ALLTRIM(TCO->cObsBolTbl),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General del Boletin

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
       FOR p := 1 TO nLinObs
	   @ PROW()+2,00 SAY REPL('-',nLenLin)
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
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.)
       ENDIF

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
       EJECT
       RETURN NIL
*>>>>FIN FIRMANTES DEL BOLETIN


/*************************************************************************
* TITULO..: IMPRESION DE LOS INDICADORES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 VIE

OBJETIVOS:

1- Imprime los indicadores de cualquier asignatura

2- Los indicadores pueden ser de las recuperaciones.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndica(aNroCol,aTitulo,cCodMat,cLogros,lIndNiv,lOficio,;
		   lHayNot,lNotNum,lPrnCod,cClaInd,lEvaInd,lPrnEva,;
		   nLenEva,cNivInd,bDerPrn,bCabBol,cNotAcu,nNroPer,;
		   nPerAnt,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNroCol                              // Columnas de los titulos
       aTitulo                              // T¡tulos para el informe
       cCodMat                              // C¢digo de la Materia
       cLogros                              // Indicadores a Imprimir
       lIndNiv                              // .T. Indicadores por nivel
       lOficio                              // .F. Tama¤o carta
       lHayNot                              // .T. Hay Nota final
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       cClaInd                              // Clase de Indicador de Configuraci¢n
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       cNivInd                              // Nivel del Indicador
       bDerPrn                              // Derechos de Impresi¢n
       bCabBol                              // Encabezados del Boletin
       cNotAcu                              // Notas Acumuladas
       nNroPer                              // N£mero del Periodo
       nPerAnt                              // Periodo Anterior
       nNroCol                              // N£mero de Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   k,j,p := 0                   // Contador
       LOCAL nTotLin := 0                   // Total lineas impresas
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL aRegPrn := {}                  // Registro de impresion


       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Descripci¢n del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS INDICADORES
       nNroCol := IF(EMPTY(nNroCol),0,nNroCol)
       IF EMPTY(TCO->nTotLinTbl)
	  nTotLin := IIF(lOficio,70,58)
       ELSE
	  nTotLin := TCO->nTotLinTbl
       ENDIF
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR k := 1 TO nNroInd

***********SEPARACION DEL CODIGO DEL LOGRO
	     cCodInd    := SUBS(cLogros,k*6-5,6)
	     cCodLog    := SUBS(cCodInd,1,4)
	     IF EMPTY(cCodInd)
		LOOP
	     ENDIF
***********FIN SEPARACION DEL CODIGO DEL LOGRO

***********NOTA DEL INDICADOR
	     DO CASE
	     CASE nNroPer == nPerAnt
		  cCodigoTev := SUBS(cCodInd,5,1)
	     CASE nPerAnt < nNroPer
		  cCodigoTev := SUBS(cCodInd,5,1)
		  IF !EMPTY(SUBS(cCodInd,6,1))
		     cCodigoTev := SUBS(cCodInd,6,1)
		  ENDIF
	     OTHERWISE
		  cCodigoTev := '*' // Error
	     ENDCASE
***********FIN NOTA DEL INDICADOR

***********LOCALIZACION DEL CODIGO DE EVALUACION
	     IF lEvaInd .AND. lPrnEva
		IF lLocCodigo('cCodigoEva','EVA',;
			      SUBS(cCodigoTev,1,1),;
			      'DE LA EVALUACION '+cCodInd)
		   cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
		ELSE
		   IF cCodigoTev == '*'
		      cCodigoTev := 'ERR:PAN='+STR(nPerAnt,1)+' PAC='+;
				    STR(nNroPer,1)
		   ELSE
		      cCodigoTev := 'NO EXISTE'
		   ENDIF
		ENDIF
	     ELSE
		cCodigoTev += SPACE(03)
	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION

***********LOCALIZACION DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
	     IF cCodLog # SPACE(04)
		cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
		IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
			      'DE LA CLASE')

*------------------ANALISIS DEL NIVEL PARA EL INDICADOR
		     IF EMPTY(CLA->cCodigoMat)
			IF EMPTY(cNivInd)
			   cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  *Por nivel
			ELSE
			   cCodigoTni := cNivInd
			  *Por Niveles
			ENDIF
		     ELSE
			cCodMat := CLA->cCodigoMat
			cCodigoTni := SPACE(02)
		     ENDIF
		   *ÀAsignaci¢n del nivel para usar indicador nivel o materia
*------------------FIN ANALISIS DEL NIVEL PARA EL INDICADOR

		ENDIF
	    ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodMat+cCodLog,;
			      cCodMat+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodInd
	     cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := JUI->cNombreJui
	     ENDIF
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION DEL INDICADOR
	     aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
				   lEvaInd,lPrnEva,;
				   nLenEva,lPrnCod,;
				   nNroPer,cNotAcu,;
				   cClaInd(cClaInd,cCodigoTcl),;
				   '- '+cNombreTju,;
				   IF(lEvaInd,cCodigoTev,SPACE(02)),;
				   SPACE(02))

	     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
***********FIN IMPRESION DEL INDICADOR

***********IMPRESION DE LOS INDICADORES EXTRAS
	     FOR j := 1 TO TCO->nJuiExtTbl

		 cNombreTju := &('JUI->cExtra'+STR(j,1)+'Jui')
		 cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)

		 aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
				       lEvaInd,lPrnEva,;
				       nLenEva,lPrnCod,;
				       nNroPer,cNotAcu,;
				       SPACE(02),;
				       '  '+cNombreTju,;
				       SPACE(02),;
				       SPACE(02))

		 IF !EMPTY(ALLTRIM(cNombreTju))
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF

	     ENDFOR
***********FIN IMPRESION DE LOS INDICADORES EXTRAS

***********ANALISIS PARA EL CAMBIO DE PAGINA
	     IF PROW() > nTotLin
		EVAL(bDerPrn)
*		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		EJECT
		EVAL(bCabBol)

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		@ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		@ PROW()+1,nNroCol SAY cTxtPrn
		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		@ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	     ENDIF
***********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION DE LOS INDICADORES

/*************************************************************************
* TITULO..: INDICADORES RECUPERADOS O POR RECUPERAR                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 17/2001 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 PM   SEP 17/2001 LUN

OBJETIVOS:

1- Calcula los indicadores Recuperados o por Recuperar

2- Retorna los Indicadores Recuperados o por Recuperar

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IndRecSiNo(cLogros,lEvaInd,cSiRecu,cNoRecu,lPrnAct,cSiIndi)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros                              // Indicadores
       lEvaInd                              // .T. Evaluar el Indicador
       cSiRecu                              // @Indicadores SI Recuperados
       cNoRecu                              // @Indicadores NO Recuperados
       lPrnAct                              // .T. Impresi¢n Activa
       cSiIndi                              // @Indicadores aprobados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL cCodLog := ''                  // C¢digo del Indicador
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cCodRec := ''                  // C¢digo de la Recuperaci¢n
       LOCAL aJuicio := {}                  // Juicios para el periodo

       LOCAL cCodigoTcl := ''               // C¢digo de la Clase del Indicador
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALICACION DE PARAMETROS
       IF lPrnAct == NIL
	  cError('DEBE INDICAR SI LA IMPRESION ESTA ACTIVA')
	  cSiRecu := NIL
	  cNoRecu := NIL
	  RETURN NIL
       ENDIF
*>>>>FIN VALICACION DE PARAMETROS

*>>>>ANALISIS DEL INDICADORES
       cSiRecu := ''
       cNoRecu := ''
       aJuicio := aJuicio(@cLogros,TCO->lNoSortTbl)
       FOR i := 1 TO LEN(aJuicio)

***********LOCALIZACION DEL CODIGO DE EVALUACION POR CLASE DE INDICADOR
	     cCodLog := aJuicio[i]
	     IF .NOT. lEvaInd

		cCodigoTev := SUBS(cCodLog,6,1)

		IF !lLocCodigo('cCodigoEva','EVA',cCodigoTev)
		   IF lPrnAct
		      SET DEVICE TO SCREEN
		      cError('EL CODIGO DE EVALUACION '+cCodigoTev+' '+;
			     'NO EXISTE '+cCodLog)
		      SET DEVICE TO PRINTER
		   ELSE
		      cError('EL CODIGO DE EVALUACION '+cCodigoTev+' '+;
			     'NO EXISTE '+cCodLog)
		   ENDIF
		ENDIF

	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION POR CLASE DE INDICADOR

***********LOCALIZACION DE LA CLASE DEL INDICADOR
	     cCodigoTcl := SUBS(cCodLog,1,1)
	     IF !lLocCodigo('cCodigoCla','CLA',cCodigoTcl)

		IF lPrnAct
		   SET DEVICE TO SCREEN
		   cError('EL CODIGO DE LA CLASE '+cCodLog+' '+;
			  'NO EXISTE')
		   SET DEVICE TO PRINTER
		ELSE
		   cError('EL CODIGO DE LA CLASE '+cCodLog+' '+;
			  'NO EXISTE')
		ENDIF
		cError(cLogros)

	     ENDIF
***********FIN LOCALIZACION DE LA CLASE DEL INDICADOR

***********RECUPERACIONES POR CLASE DE INDICADOR
	     IF .NOT. lEvaInd

*---------------ANALISIS DE RECUPERACIONES
		  IF CLA->lRecupeCla
		     IF EVA->lSiRecuEva
			cSiRecu += cCodLog
		     ELSE
			cNoRecu += cCodLog
		     ENDIF
		  ELSE
		     IF cSiIndi # NIL
			cSiIndi += cCodLog
		     ENDIF
		  ENDIF
*---------------FIN ANALISIS DE RECUPERACIONES

	     ENDIF
***********FIN RECUPERACIONES POR CLASE DE INDICADOR

***********REEVALUACION DEL INDICADOR
	     cCodEva := SUBS(cCodLog,5,1)
	     IF lEvaInd .AND. CLA->cReeEvaCla == '01'
		cCodRec := SUBS(cCodLog,6,1)
		IF !EMPTY(cCodRec)
		   cCodEva := cCodRec
		ENDIF
	     ENDIF
***********FIN REEVALUACION DEL INDICADOR

***********RECUPERACIONES POR CODIGO DE EVALUACION
	     IF lEvaInd

		IF lLocCodigo('cCodigoEva','EVA',cCodEva)

		   IF (EVA->lRecupeEva .AND. CLA->lRecupeCla) .OR.;
		      (EVA->lRecupeEva .AND. !CLA->lRecupeCla)

			IF EMPTY(SUBS(cCodLog,6,1))
			   cNoRecu += cCodLog
			ELSE
			   IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,6,1))
			      IF EVA->lSiRecuEva
				 cSiRecu += cCodLog
			      ELSE
				 cNoRecu += cCodLog
			      ENDIF
			   ENDIF
			ENDIF

		   ELSE

		      IF cSiIndi # NIL
			 cSiIndi += cCodLog
		      ENDIF

		   ENDIF

		ENDIF

	     ENDIF
***********RECUPERACIONES POR CODIGO DE EVALUACION

       NEXT
       RETURN NIL
*>>>>FIN ANALISIS DEL INDICADORES

/*************************************************************************
* TITULO..: COLUMNAS Y ENCABEZADOS DEL BOLETIN                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:00 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Define las columnas y t¡tulos del encabezado de columna del Boletin

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabColBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,;
		   lPrnCod,cMsgBol,aNroCol,aTitulo,nNroPer,;
		   cNotAcu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       cMsgBol                              // Mensaje para el boletin
       aNroCol                              // @Columnas de los titulos
       aTitulo                              // @T¡tulos para el informe
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NUMEROS DE COLUMNAS
       aNroCol := {}
       AADD(aNroCol,02)
      *Columna para la Intensidad Horaria

       AADD(aNroCol,108)
      *Columna para el Nombre del Indicador o Mensaje del Boletin

       IF lPrnEva
	  IF nLenEva > 4
	     AADD(aNroCol,nLenEva)
	  ELSE
	     AADD(aNroCol,06)
	  ENDIF
       ELSE
	  IF EMPTY(cNotAcu)
	     IF lHayNot
		IF lPrnCod
		   AADD(aNroCol,04)
		ELSE
		   AADD(aNroCol,18)
		ENDIF
	     ENDIF
	  ELSE
	     FOR i := 1 TO nNroPer
		 IF lNotNum
*		    AADD(aNroCol,2)
		 ELSE
		    AADD(aNroCol,2)
		 ENDIF
	     ENDFOR
	  ENDIF
       ENDIF
     *ÀColumna para la Evaluaci¢n

       AADD(aNroCol,04)
      *Columna para las Ausencias
*>>>>FIN NUMEROS DE COLUMNAS

*>>>>TITULOS DE COLUMNA
       aTitulo := {}

       AADD(aTitulo,'IH')
      *Intensidad Horaria

       AADD(aTitulo,cMsgBol)
      *Mensaje Boletin

       IF lHayNot .OR. lEvaInd
	  IF lNotNum
	     IF EMPTY(cNotAcu)
		AADD(aTitulo,'NOTA')
	     ELSE
		FOR i := 1 TO nNroPer
*		    AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
		ENDFOR
	     ENDIF
	  ELSE
	     IF lPrnEva
		AADD(aTitulo,'JUICIO')
	     ELSE
		IF EMPTY(cNotAcu)
		   IF lHayNot
		      IF lPrnCod
			AADD(aTitulo,'JUIC')
		      ELSE
			AADD(aTitulo,'JUICIO VALORATIVO')
		      ENDIF
		   ENDIF
		ELSE
		   FOR i := 1 TO nNroPer
		       AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
		   ENDFOR
		ENDIF
	     ENDIF
	  ENDIF
       ENDIF
       AADD(aTitulo,'AUS.')
       RETURN NIL
*>>>>FIN TITULOS DE COLUMNA

/*************************************************************************
* TITULO..: COLUMNAS Y ENCABEZADOS DEL BOLETIN                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:00 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Define las columnas y t¡tulos del encabezado de columna del Boletin
   para el Virrey Solis.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabColBol8(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,;
		    lPrnCod,cMsgBol,aNroCol,aTitulo,nNroPer,;
		    cNotAcu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       cMsgBol                              // Mensaje para el boletin
       aNroCol                              // @Columnas de los titulos
       aTitulo                              // @T¡tulos para el informe
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NUMEROS DE COLUMNAS
       aNroCol := {}
       AADD(aNroCol,02)
      *Columna para la Intensidad Horaria

       AADD(aNroCol,108)
      *Columna para el Nombre del Indicador o Mensaje del Boletin

       IF lPrnEva
	  IF nLenEva > 4
	     AADD(aNroCol,nLenEva)
	  ELSE
	     AADD(aNroCol,06)
	  ENDIF
       ELSE
	  IF EMPTY(cNotAcu)
	     IF lHayNot
		IF lPrnCod
		   AADD(aNroCol,04)   // Nota
		ELSE
		   AADD(aNroCol,18)
		   AADD(aNroCol,04)   // Nota
		ENDIF
	     ENDIF
	  ELSE
	     FOR i := 1 TO nNroPer
		 AADD(aNroCol,2)
	     ENDFOR
	  ENDIF
       ENDIF
     *ÀColumna para la Evaluaci¢n

       AADD(aNroCol,04)
      *Columna para las Ausencias
*>>>>FIN NUMEROS DE COLUMNAS

*>>>>TITULOS DE COLUMNA
       aTitulo := {}

       AADD(aTitulo,'IH')
      *Intensidad Horaria

       AADD(aTitulo,cMsgBol)
      *Mensaje Boletin

       IF lHayNot .OR. lEvaInd
	  IF lNotNum
	     AADD(aTitulo,'JUICIO VALORATIVO')
	     AADD(aTitulo,'NOTA')
	  ELSE
	     IF lPrnEva
		AADD(aTitulo,'JUICIO')
	     ELSE
		IF EMPTY(cNotAcu)
		   IF lHayNot
		      IF lPrnCod
			AADD(aTitulo,'JUIC')
		      ELSE
			AADD(aTitulo,'JUICIO VALORATIVO')
		      ENDIF
		   ENDIF
		ELSE
		   FOR i := 1 TO nNroPer
		       AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
		   ENDFOR
		ENDIF
	     ENDIF
	  ENDIF
       ENDIF

       AADD(aTitulo,'AUS.')
       RETURN NIL
*>>>>FIN TITULOS DE COLUMNA

/*************************************************************************
* TITULO..: REGISTRO DE IMPRESION DEL BOLETIN                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Prepara el registro de impresi¢n del Boletin en un vector.

2- Retorna el vector de impresion

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		    nNroPer,cNotAcu,cColNo1,cColNo2,cColNo3,cColNo4,;
		    cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas
       cColNo1                              // Columna No. 1  Intensidad
       cColNo2                              // Columna No. 2  Materia
       cColNo3                              // Columna No. 3  Nota o Notas
       cColNo4                              // Columna No. 4  Fallas
       cCodMat                              // C¢digo de la Materia. Depuracion */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aRegPrn := {}                  // Registro de Impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REGISTRO DE IMPRESION DEL BOLETIN
       AADD(aRegPrn,cColNo1)  // Intensidad
       AADD(aRegPrn,cColNo2)  // Materia

       IF lHayNot .OR. lEvaInd

	  IF lHayNot

	     IF EMPTY(cNotAcu)
		IF lPrnCod
		   AADD(aRegPrn,cColNo3)   // Notas
		ELSE
		   IF EMPTY(cColNo3)
		      AADD(aRegPrn,'')
		   ELSE
		      IF SUBS(TCO->cCfgBolTbl,2,1) $ cColNo3
			 AADD(aRegPrn,cColNo3)
		      ELSE
			 AADD(aRegPrn,ALLTRIM(cTxtNota(cColNo3)))
		      ENDIF
		   ENDIF
		ENDIF

	     ELSE

		IF lNotNum

		   IF !EMPTY(cColNo3)
		      aRegPrn[2] := ALLTRIM(aRegPrn[2])
		      aRegPrn[2] := SUBS(aRegPrn[2]+SPACE(60),1,60)
		   ENDIF

		   FOR i := 1 TO nNroPer

		       IF !EMPTY(cColNo3)

			  aRegPrn[2] += ' P'+STR(i,1)+'='+;
				cNotDefJvf(VAL(SUBS(cColNo3,i*4-3,4)))+':'+;
					 ALLTRIM(SUBS(cColNo3,i*4-3,4))
		       ENDIF
		   ENDFOR
		   aRegPrn[2] := SUBS(aRegPrn[2]+SPACE(106),1,106)

		ELSE

		   FOR i := 1 TO nNroPer
		       AADD(aRegPrn,ALLTRIM(SUBS(cColNo3,i*4-3,4)))
		   ENDFOR
		ENDIF

	     ENDIF

	  ELSE

	     IF lPrnEva

		IF nLenEva > 4
		   AADD(aRegPrn,SPACE(nLenEva))
		ELSE
		   AADD(aRegPrn,SPACE(06))
		ENDIF

	     ELSE
		AADD(aRegPrn,SPACE(04))
	     ENDIF
	  ENDIF
	  AADD(aRegPrn,cColNo4)  // Intensidad

       ELSE
	  AADD(aRegPrn,cColNo3)
       ENDIF
       RETURN aRegPrn
*>>>>FIN REGISTRO DE IMPRESION DEL BOLETIN

/*************************************************************************
* TITULO..: REGISTRO DE IMPRESION DEL BOLETIN No. 8                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Prepara el registro de impresi¢n del Boletin en un vector.

2- Retorna el vector de impresion

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aRegPrn08(lHayNot,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		   nNroPer,cNotAcu,cColNo1,cColNo2,cColNo3,cColNo4)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas
       cColNo1                              // Columna No. 1  Intensidad
       cColNo2                              // Columna No. 2  Materia
       cColNo3                              // Columna No. 3  Nota o Notas
       cColNo4                              // Columna No. 4  Fallas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aRegPrn := {}                  // Registro de Impresi¢n
       LOCAL cJuiVal := ''                  // Juicio Valorativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REGISTRO DE IMPRESION DEL BOLETIN
       AADD(aRegPrn,cColNo1)  // Intensidad
       AADD(aRegPrn,cColNo2)  // Materia

       IF lHayNot .OR. lEvaInd
	  IF lHayNot
	     IF EMPTY(cNotAcu)
		IF lPrnCod
		   AADD(aRegPrn,cColNo3)   // Notas
		ELSE

		   DO CASE
		   CASE VAL(cColNo3) == 0
			cJuiVal := SPACE(01)

		   CASE VAL(cColNo3) >= 1 .AND. VAL(cColNo3) < 2.0
			cJuiVal := 'D'

		   CASE VAL(cColNo3) >= 2 .AND. VAL(cColNo3) < 3.0
			cJuiVal := 'I'

		   CASE VAL(cColNo3) >= 3 .AND. VAL(cColNo3) < 4.0
			cJuiVal := 'A'

		   CASE VAL(cColNo3) >= 4 .AND. VAL(cColNo3) < 4.5
			cJuiVal := 'S'

		   CASE VAL(cColNo3) >= 4.5 .AND. VAL(cColNo3) <= 5.0
			cJuiVal := 'E'

		   OTHERWISE
			cJuiVal := '*'  // Error
		   ENDCASE

		   AADD(aRegPrn,IF(EMPTY(cJuiVal),'',;
				   ALLTRIM(cTxtNota(cJuiVal))))

		   AADD(aRegPrn,cColNo3)   // Notas

		ENDIF
	     ELSE
		FOR i := 1 TO nNroPer
		    AADD(aRegPrn,ALLTRIM(SUBS(cColNo3,i*4-3,4)))
		ENDFOR
	     ENDIF
	  ELSE
	     IF lPrnEva
		IF nLenEva > 4
		   AADD(aRegPrn,SPACE(nLenEva))
		ELSE
		   AADD(aRegPrn,SPACE(06))
		ENDIF
	     ELSE
		AADD(aRegPrn,SPACE(04))
	     ENDIF
	  ENDIF
	  AADD(aRegPrn,cColNo4)  // Intensidad

       ELSE
	  AADD(aRegPrn,cColNo3)
       ENDIF
       RETURN aRegPrn
*>>>>FIN REGISTRO DE IMPRESION DEL BOLETIN

/*************************************************************************
* TITULO..: INDICADORES SIN INDICADORES RECUPERADOS DEL PERIODO          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2002 MAR A
       Colombia, Bucaramanga        INICIO: 09:30 PM   SEP 24/2002 MAR

OBJETIVOS:

1- Descarta los indicadores que ya se recuperaron en el periodo

2- Retorna los indicadores sin los indicadores que ya se recuperaron

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aJuicio1(aJuicio,lEvaInd,lPrnAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     aJuicio                              // Juicios para el periodo
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnAct                              // .T. Impresi¢n Activa */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL cCodLog := ''                  // C¢digo del Indicador
       LOCAL aIndica := {}                  // Indicadores

       LOCAL cCodigoTcl := ''               // C¢digo de la Clase del Indicador
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL INDICADORES
       FOR i := 1 TO LEN(aJuicio)

***********LOCALIZACION DEL CODIGO DE EVALUACION POR CLASE DE INDICADOR
	     cCodLog := aJuicio[i]
	     IF .NOT. lEvaInd

		cCodigoTev := SUBS(cCodLog,6,1)
		IF !lLocCodigo('cCodigoEva','EVA',;
			       SUBS(cCodigoTev,1,1))
		   IF lPrnAct
		      SET DEVICE TO SCREEN
		      cError('EL CODIGO DE EVALUACION '+cCodigoTev+' '+;
			     'NO EXISTE '+cCodLog)
		      SET DEVICE TO PRINTER
		   ELSE
		      cError('EL CODIGO DE EVALUACION '+cCodigoTev+' '+;
			     'NO EXISTE '+cCodLog)
		   ENDIF
		ENDIF

	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION POR CLASE DE INDICADOR

***********LOCALIZACION DE LA CLASE DEL INDICADOR
	     IF .NOT. lEvaInd
		cCodigoTcl := SUBS(cCodLog,1,1)
		IF !lLocCodigo('cCodigoCla','CLA',cCodigoTcl)
		   IF lPrnAct
		      SET DEVICE TO SCREEN
		      cError('EL CODIGO DE LA CLASE '+cCodigoTcl+' '+;
			     'NO EXISTE')
		      SET DEVICE TO PRINTER
		   ELSE
		      cError('EL CODIGO DE LA CLASE '+cCodigoTcl+' '+;
			     'NO EXISTE')
		   ENDIF
		ENDIF
	     ENDIF
***********FIN LOCALIZACION DE LA CLASE DEL INDICADOR

***********RECUPERACIONES POR CLASE DE INDICADOR
	     IF .NOT. lEvaInd

*---------------ANALISIS DE RECUPERACIONES
		  IF CLA->lRecupeCla
		     IF !EVA->lSiRecuEva
			AADD(aIndica,cCodLog)
		     ENDIF
		  ELSE
		     AADD(aIndica,cCodLog)
		  ENDIF
*---------------FIN ANALISIS DE RECUPERACIONES

	     ENDIF
***********FIN RECUPERACIONES POR CLASE DE INDICADOR

***********RECUPERACIONES POR CODIGO DE EVALUACION
	     IF lEvaInd
		IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,5,1)).AND.;
		   EVA->lRecupeEva

		   IF EMPTY(SUBS(cCodLog,6,1))
		      AADD(aIndica,cCodLog)
		   ELSE
		      IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,6,1))
			 IF !EVA->lSiRecuEva
			    AADD(aIndica,cCodLog)
			 ENDIF
		      ENDIF
		   ENDIF
		ELSE
		   AADD(aIndica,cCodLog)
		ENDIF
	     ENDIF
***********RECUPERACIONES POR CODIGO DE EVALUACION

       NEXT
       RETURN aIndica
*>>>>FIN ANALISIS DEL INDICADORES

/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura y valoraci¢n
   n£merica y boletin sugerido por la Sabiduria.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin09(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final
       nNroCol                              // N£mero de la Columna
       nColEnc                              // Columna del Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroFol := NIL                 // N£mero de Folio
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

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
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol9(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		  cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			    nColEnc)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		 ELSE
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrn09(lHayNot,lEvaInd,lPrnEva,nLenEva,;
					  lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			       nColEnc)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,nNroCol SAY cTxtPrn
		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF

		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',;
				       SUBS(cCodigoTev,1,1),;
				       'DE LA EVALUACION '+cCodJui)
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso
			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(02))
			      *Espacio de Intensidad

			       AADD(aRegPrn,cNomCla)
			      *Espacio de Juicio

			       IF EMPTY(cNotAcu)
				  AADD(aRegPrn,SPACE(04))
			       ELSE
				  FOR p := 1 TO nNroBis
				     AADD(aRegPrn,SPACE(02))
				  ENDFOR
			       ENDIF
			     *ÀEspacio de la Nota

			       AADD(aRegPrn,SPACE(02))
			      *Espacio de la Ausencia

			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF
			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := {}
			 AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			 AADD(aRegPrn,'- '+cNombreTju)

			 IF EMPTY(cNotAcu)
			    AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			 ELSE
			    FOR p := 1 TO nNroBis
				AADD(aRegPrn,SPACE(02))
			    ENDFOR
			 ENDIF
			 AADD(aRegPrn,SPACE(04))
			 AADD(aRegPrn,SPACE(04))

		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(02))
			     AADD(aRegPrn,'  '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,SPACE(04))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,nNroCol SAY cTxtPrn
			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,nNroCol SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]  // Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''),,;
					       nColEnc)}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
			       cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReS)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica9(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)

			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
			       cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReN)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica9(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrn09(lHayNot,lEvaInd,lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cChrLin+cChrLin,;
					     REPL(cChrLin,108),;
					     SPACE(01),;
					     SPACE(01))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

		    ELSE
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis
			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrn09(lHayNot,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
				  nColEnc)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,nNroCol SAY cTxtPrn
		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF

		    lSiPaso := .F.
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',;
					   SUBS(cCodigoTev,1,1),;
					   'DE LA EVALUACION '+cCodJui)
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel

				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso
				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cNomCla)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(02))

				   @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := {}
			     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			     AADD(aRegPrn,'- '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      IF lHayNot .OR. lEvaInd

				 aRegPrn := {}
				 AADD(aRegPrn,SPACE(02))
				 AADD(aRegPrn,'  '+cNombreTju)

				 IF EMPTY(cNotAcu)
				    AADD(aRegPrn,SPACE(04))
				 ELSE
				    FOR p := 1 TO nNroBis
					AADD(aRegPrn,SPACE(02))
				    ENDFOR
				 ENDIF
				 AADD(aRegPrn,SPACE(04))
				 AADD(aRegPrn,SPACE(04))

			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''),,;
					nColEnc)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,nNroCol SAY cTxtPrn
			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]  // Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''),,;
						  nColEnc)}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
				cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReS)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))
				 *ÀNota

				   AADD(aRegPrn,SPACE(04))
				 *ÀAusencia

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica9(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
				cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReN)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))
				 *ÀNota

				   AADD(aRegPrn,SPACE(04))
				 *ÀAusencia

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica9(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrn09(lHayNot,lEvaInd,lPrnEva,;
						nLenEva,lPrnCod,nNroBis,;
						cNotAcu,;
						cChrLin+cChrLin,;
						REPL(cChrLin,108),;
						SPACE(01),;
						SPACE(01))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
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

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
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
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
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
* TITULO..: COLUMNAS Y ENCABEZADOS DEL BOLETIN                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:00 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Define las columnas y t¡tulos del encabezado de columna del Boletin
   para la Sabiduria.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabColBol9(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,;
		    lPrnCod,cMsgBol,aNroCol,aTitulo,nNroPer,;
		    cNotAcu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       cMsgBol                              // Mensaje para el boletin
       aNroCol                              // @Columnas de los titulos
       aTitulo                              // @T¡tulos para el informe
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NUMEROS DE COLUMNAS
       aNroCol := {}
       AADD(aNroCol,02)
      *Columna para la Intensidad Horaria

       AADD(aNroCol,108)
      *Columna para el Nombre del Indicador o Mensaje del Boletin

       IF lPrnEva
	  IF nLenEva > 4
	     AADD(aNroCol,nLenEva)
	  ELSE
	     AADD(aNroCol,06)
	  ENDIF
       ELSE
	  IF EMPTY(cNotAcu)
	     IF lHayNot
		IF lPrnCod
		   AADD(aNroCol,04)   // Nota
		ELSE
		   AADD(aNroCol,18)
		   AADD(aNroCol,04)   // Nota
		ENDIF
	     ENDIF
	  ELSE
	     FOR i := 1 TO nNroPer
		 AADD(aNroCol,2)
	     ENDFOR
	  ENDIF
       ENDIF
     *ÀColumna para la Evaluaci¢n

       AADD(aNroCol,04)
      *Columna para las Ausencias
*>>>>FIN NUMEROS DE COLUMNAS

*>>>>TITULOS DE COLUMNA
       aTitulo := {}

       AADD(aTitulo,'IH')
      *Intensidad Horaria

       AADD(aTitulo,cMsgBol)
      *Mensaje Boletin

       IF lHayNot .OR. lEvaInd
	  IF lNotNum
	     AADD(aTitulo,'JUICIO VALORATIVO')
	     AADD(aTitulo,'NOTA')
	  ELSE
	     IF lPrnEva
		AADD(aTitulo,'JUICIO')
	     ELSE
		IF EMPTY(cNotAcu)
		   IF lHayNot
		      IF lPrnCod
			AADD(aTitulo,'JUIC')
		      ELSE
			AADD(aTitulo,'JUICIO VALORATIVO')
		      ENDIF
		   ENDIF
		ELSE
		   FOR i := 1 TO nNroPer
		       AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
		   ENDFOR
		ENDIF
	     ENDIF
	  ENDIF
       ENDIF

       AADD(aTitulo,'AUS.')
       RETURN NIL
*>>>>FIN TITULOS DE COLUMNA

/*************************************************************************
* TITULO..: REGISTRO DE IMPRESION DEL BOLETIN No. 9                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Prepara el registro de impresi¢n del Boletin en un vector.

2- Retorna el vector de impresion

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aRegPrn09(lHayNot,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		   nNroPer,cNotAcu,cColNo1,cColNo2,cColNo3,cColNo4)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas
       cColNo1                              // Columna No. 1  Intensidad
       cColNo2                              // Columna No. 2  Materia
       cColNo3                              // Columna No. 3  Nota o Notas
       cColNo4                              // Columna No. 4  Fallas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aRegPrn := {}                  // Registro de Impresi¢n
       LOCAL cJuiVal := ''                  // Juicio Valorativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA NOTA VACIA
       IF VAL(cColNo3) == 0
	  cColNo3 := ''
       ENDIF
*>>>>FIN VALIDACION DE LA NOTA VACIA

*>>>>REGISTRO DE IMPRESION DEL BOLETIN
       AADD(aRegPrn,cColNo1)  // Intensidad
       AADD(aRegPrn,cColNo2)  // Materia

       IF lHayNot .OR. lEvaInd
	  IF lHayNot
	     IF EMPTY(cNotAcu)
		IF lPrnCod
		   AADD(aRegPrn,cColNo3)   // Notas
		ELSE

		   cJuiVal := cNotDefJvf(VAL(cColNo3))

		   AADD(aRegPrn,IF(EMPTY(cJuiVal),'',;
				   ALLTRIM(cTxtNota(cJuiVal))))

		   AADD(aRegPrn,cColNo3)   // Notas

		ENDIF
	     ELSE
		FOR i := 1 TO nNroPer
		    AADD(aRegPrn,ALLTRIM(SUBS(cColNo3,i*4-3,4)))
		ENDFOR
	     ENDIF
	  ELSE
	     IF lPrnEva
		IF nLenEva > 4
		   AADD(aRegPrn,SPACE(nLenEva))
		ELSE
		   AADD(aRegPrn,SPACE(06))
		ENDIF
	     ELSE
		AADD(aRegPrn,SPACE(04))
	     ENDIF
	  ENDIF
	  AADD(aRegPrn,cColNo4)  // Intensidad

       ELSE
	  AADD(aRegPrn,cColNo3)
       ENDIF
       RETURN aRegPrn
*>>>>FIN REGISTRO DE IMPRESION DEL BOLETIN

/*************************************************************************
* TITULO..: IMPRESION DE LOS INDICADORES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 VIE

OBJETIVOS:

1- Imprime los indicadores de cualquier asignatura

2- Los indicadores pueden ser de las recuperaciones.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndica9(aNroCol,aTitulo,cCodMat,cLogros,lIndNiv,lOficio,;
		    lHayNot,cClaInd,lEvaInd,lPrnEva,nLenEva,cNivInd,;
		    bDerPrn,bCabBol,cNotAcu,nNroPer,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNroCol                              // Columnas de los titulos
       aTitulo                              // T¡tulos para el informe
       cCodMat                              // C¢digo de la Materia
       cLogros                              // Indicadores a Imprimir
       lIndNiv                              // .T. Indicadores por nivel
       lOficio                              // .F. Tama¤o carta
       lHayNot                              // .T. Hay Nota final
       cClaInd                              // Clase de Indicador de Configuraci¢n
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       cNivInd                              // Nivel del Indicador
       bDerPrn                              // Derechos de Impresi¢n
       bCabBol                              // Encabezados del Boletin
       cNotAcu                              // Notas Acumuladas
       nNroPer                              // N£mero del Periodo
       nNroCol                              // N£mero de Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   k,j,p := 0                   // Contador
       LOCAL nTotLin := 0                   // Total lineas impresas
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL aRegPrn := {}                  // Registro de impresion


       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Descripci¢n del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS INDICADORES
       IF EMPTY(TCO->nTotLinTbl)
	  nTotLin := IIF(lOficio,70,58)
       ELSE
	  nTotLin := TCO->nTotLinTbl
       ENDIF
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR k:= 1 TO nNroInd

***********SEPARACION DEL CODIGO DEL LOGRO
	     cCodInd    := SUBS(cLogros,k*6-5,6)
	     cCodLog    := SUBS(cCodInd,1,4)
	     cCodigoTev := SUBS(cCodInd,5,1)
	     IF EMPTY(cCodInd)
		LOOP
	     ENDIF
***********FIN SEPARACION DEL CODIGO DEL LOGRO

***********LOCALIZACION DEL CODIGO DE EVALUACION
	     IF lEvaInd .AND. lPrnEva
		IF lLocCodigo('cCodigoEva','EVA',;
			      SUBS(cCodigoTev,1,1),;
			      'DE LA EVALUACION '+cCodInd)
		   cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
		ELSE
		   cCodigoTev := 'NO EXISTE'
		ENDIF
	     ELSE
		cCodigoTev += SPACE(03)
	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION

***********LOCALIZACION DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
	     IF cCodLog # SPACE(04)
		cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
		IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
			      'DE LA CLASE')

*------------------ANALISIS DEL NIVEL PARA EL INDICADOR
		     IF EMPTY(CLA->cCodigoMat)
			IF EMPTY(cNivInd)
			   cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  *Por nivel
			ELSE
			   cCodigoTni := cNivInd
			  *Por Niveles
			ENDIF
		     ELSE
			cCodMat := CLA->cCodigoMat
			cCodigoTni := SPACE(02)
		     ENDIF
		   *ÀAsignaci¢n del nivel para usar indicador nivel o materia
*------------------FIN ANALISIS DEL NIVEL PARA EL INDICADOR

		ENDIF
	    ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodMat+cCodLog,;
			      cCodMat+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodInd
	     cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := JUI->cNombreJui
	     ENDIF
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION DEL INDICADOR
	     aRegPrn := {}
	     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
	     AADD(aRegPrn,'- '+cNombreTju)

	     IF lHayNot .OR. lEvaInd
		IF EMPTY(cNotAcu)
		   AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
		ELSE
		   FOR p := 1 TO nNroPer
		       AADD(aRegPrn,SPACE(02))
		   ENDFOR
		ENDIF
	     ENDIF
	     AADD(aRegPrn,SPACE(02))
	     AADD(aRegPrn,SPACE(02))

	     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
***********FIN IMPRESION DEL INDICADOR

***********IMPRESION DE LOS INDICADORES EXTRAS
	     aRegPrn := {}
	     AADD(aRegPrn,SPACE(02))

	     FOR j := 1 TO TCO->nJuiExtTbl

		 cNombreTju := &('JUI->cExtra'+STR(j,1)+'Jui')
		 AADD(aRegPrn,'  '+cNombreTju)

		 IF lHayNot .OR. lEvaInd
		    IF EMPTY(cNotAcu)
		       AADD(aRegPrn,SPACE(04))
		    ELSE
		       FOR p := 1 TO nNroPer
			   AADD(aRegPrn,SPACE(02))
		       ENDFOR
		    ENDIF
		 ENDIF
		 AADD(aRegPrn,SPACE(02))
		 AADD(aRegPrn,SPACE(02))

		 IF !EMPTY(cNombreTju)
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF

	     ENDFOR
***********FIN IMPRESION DE LOS INDICADORES EXTRAS

***********ANALISIS PARA EL CAMBIO DE PAGINA
	     IF PROW() > nTotLin
		EVAL(bDerPrn)
*		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		EJECT
		EVAL(bCabBol)

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		@ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		@ PROW()+1,nNroCol SAY cTxtPrn
		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		@ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	     ENDIF
***********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION DE LOS INDICADORES

/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/2005 MAR A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 15/2005 MAR

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin10(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final
       nNroCol                              // N£mero de la Columna
       nColEnc                              // Columna del Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
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
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
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
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		 cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			    nColEnc)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		 ELSE
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					  nLenEva,lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			       nColEnc)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,nNroCol SAY cTxtPrn
		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF

		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',;
				       SUBS(cCodigoTev,1,1),;
				       'DE LA EVALUACION '+cCodJui)
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso

			       aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
						     lEvaInd,lPrnEva,;
						     nLenEva,lPrnCod,;
						     nNroBis,cNotAcu,;
						     SPACE(02),;
						     cNomCla,;
						     SPACE(02),;
						     SPACE(02))

			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF

			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
					       lEvaInd,lPrnEva,;
					       nLenEva,lPrnCod,;
					       nNroBis,cNotAcu,;
					       cClaInd(cClaInd,cCodigoTcl),;
					       '- '+cNombreTju,;
					       SPACE(02),;
					       SPACE(02))
		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)

			  IF lHayNot .OR. lEvaInd

			     aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
						   lEvaInd,lPrnEva,;
						   nLenEva,lPrnCod,;
						   nNroBis,cNotAcu,;
						   SPACE(02),;
						   '  '+cNombreTju,;
						   SPACE(02),;
						   SPACE(02))
			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,nNroCol SAY cTxtPrn
			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,nNroCol SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]  // Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''),,;
					       nColEnc)}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
			       cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
							lEvaInd,lPrnEva,;
							nLenEva,lPrnCod,;
							nNroBis,cNotAcu,;
							SPACE(02),;
							cTitReS,;
							SPACE(02),;
							SPACE(02))
			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)

			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
			       cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
							lEvaInd,lPrnEva,;
							nLenEva,lPrnCod,;
							nNroBis,cNotAcu,;
							SPACE(02),;
							cTitReN,;
							SPACE(02),;
							SPACE(02))
			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					     nLenEva,lPrnCod,nNroBis,cNotAcu,;
					     cChrLin+cChrLin,;
					     REPL(cChrLin,108),;
					     SPACE(01),;
					     SPACE(01))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

		    ELSE
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis
			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
				  nColEnc)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,nNroCol SAY cTxtPrn
		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF

		    lSiPaso := .F.
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',;
					   SUBS(cCodigoTev,1,1),;
					   'DE LA EVALUACION '+cCodJui)
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso

				   aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
							 lEvaInd,lPrnEva,;
							 nLenEva,lPrnCod,;
							 nNroBis,cNotAcu,;
							 SPACE(02),;
							 cNomCla,;
							 SPACE(02),;
							 SPACE(02))

				   @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
						   lEvaInd,lPrnEva,;
						   nLenEva,lPrnCod,;
						   nNroBis,cNotAcu,;
						   cClaInd(cClaInd,cCodigoTcl),;
						   '- '+cNombreTju,;
						   SPACE(02),;
						   SPACE(02))
			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)

			      IF lHayNot .OR. lEvaInd

				 aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
						       lEvaInd,lPrnEva,;
						       nLenEva,lPrnCod,;
						       nNroBis,cNotAcu,;
						       SPACE(02),;
						       '  '+cNombreTju,;
						       SPACE(02),;
						       SPACE(02))
			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''),,;
					nColEnc)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,nNroCol SAY cTxtPrn
			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]  // Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''),,;
						  nColEnc)}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
				cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
							 lEvaInd,lPrnEva,;
							 nLenEva,lPrnCod,;
							 nNroBis,cNotAcu,;
							 SPACE(02),;
							 cTitReS,;
							 SPACE(02),;
							 SPACE(02))
				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
				cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := aRegPrnBol(lHayNot,lNotNum,;
							 lEvaInd,lPrnEva,;
							 nLenEva,lPrnCod,;
							 nNroBis,cNotAcu,;
							 SPACE(02),;
							 cTitReN,;
							 SPACE(02),;
							 SPACE(02))
				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,;
						lPrnEva,nLenEva,lPrnCod,;
						nNroBis,cNotAcu,;
						cChrLin+cChrLin,;
						REPL(cChrLin,108),;
						SPACE(01),;
						SPACE(01))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
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

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
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
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
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
* TITULO..: BOLETIN PARA LA EVALUACION CUALITATIVA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 28/2006 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAR 28/2006 MAR

OBJETIVOS:

1- Imprime el boletin para un estudiante, con indicadores, control de
   recuperaciones,porcentaje de evaluaci¢n del indicador tiende a hacer
   el boletin estandar para todas las variantes de la evaluaci¢n cualitativa.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin98(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final
       nNroCol                              // N£mero de la Columna
       nColEnc                              // Columna del Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
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
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
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
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		 cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			    nColEnc)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

cNota := cNotDefJvf(VAL(cNota))

		 ELSE
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					  nLenEva,lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			       nColEnc)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,nNroCol SAY cTxtPrn
		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF

		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',;
				       SUBS(cCodigoTev,1,1),;
				       'DE LA EVALUACION '+cCodJui)
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso
			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(02))
			      *Espacio de Intensidad

			       AADD(aRegPrn,cNomCla)
			      *Espacio de Juicio

			       IF EMPTY(cNotAcu)
				  AADD(aRegPrn,SPACE(04))
			       ELSE
				  FOR p := 1 TO nNroBis
				     AADD(aRegPrn,SPACE(02))
				  ENDFOR
			       ENDIF
			     *ÀEspacio de la Nota

			       AADD(aRegPrn,SPACE(02))
			      *Espacio de la Ausencia

			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF
			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := {}
			 AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			 AADD(aRegPrn,'- '+cNombreTju)

			 IF EMPTY(cNotAcu)
			    AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			 ELSE
			    FOR p := 1 TO nNroBis
				AADD(aRegPrn,SPACE(02))
			    ENDFOR
			 ENDIF
			 AADD(aRegPrn,SPACE(04))

		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(02))
			     AADD(aRegPrn,'  '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,SPACE(04))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,nNroCol SAY cTxtPrn
			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,nNroCol SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]  // Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''),,;
					       nColEnc)}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
			       cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReS)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)

			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
			       cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReN)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					     nLenEva,lPrnCod,nNroBis,cNotAcu,;
					     cChrLin+cChrLin,;
					     REPL(cChrLin,108),;
					     SPACE(01),;
					     SPACE(01))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

cNota := cNotDefJvf(VAL(cNota))


		    ELSE
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis
			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
				  nColEnc)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,nNroCol SAY cTxtPrn
		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF

		    lSiPaso := .F.
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',;
					   SUBS(cCodigoTev,1,1),;
					   'DE LA EVALUACION '+cCodJui)
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso
				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cNomCla)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(02))

				   @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := {}
			     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			     AADD(aRegPrn,'- '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      IF lHayNot .OR. lEvaInd

				 aRegPrn := {}
				 AADD(aRegPrn,SPACE(02))
				 AADD(aRegPrn,'  '+cNombreTju)

				 IF EMPTY(cNotAcu)
				    AADD(aRegPrn,SPACE(04))
				 ELSE
				    FOR p := 1 TO nNroBis
					AADD(aRegPrn,SPACE(02))
				    ENDFOR
				 ENDIF
				 AADD(aRegPrn,SPACE(04))

			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''),,;
					nColEnc)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,nNroCol SAY cTxtPrn
			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]  // Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''),,;
						  nColEnc)}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
				cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReS)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
				cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReN)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,;
						lPrnEva,nLenEva,lPrnCod,;
						nNroBis,cNotAcu,;
						cChrLin+cChrLin,;
						REPL(cChrLin,108),;
						SPACE(01),;
						SPACE(01))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
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

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
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
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
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
* TITULO..: NOTA CODIGO DE EVALUACION		                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 23/2007 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   MAR 23/2007 VIE

OBJETIVOS:

1- Lee la nota del c¢digo de evaluaci¢n.

2- Retorna el c¢digo de evaluaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodEvaNot(cEvaInd,nNroPer,cCamNot,cCodInd,cCodEva,nNroInd)

*>>>>DESCRIPCION DE PARAMETROS
/*     cEvaInd                              // Evaluaci¢n del Indicador
       nNroPer                              // N£mero del Periodo
       cCamNot                              // Campo de Notas
       cCodInd                              // C¢digo del Indicador
       cCodEva                              // C¢digo de Evaluaci¢n
       nNroInd                              // N£mero del Indicador */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNtIndi := ''                  // Notas del Indicador
       LOCAL cNotInd := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n del Indicador

       LOCAL nLenJnt := 8                   // Longitud del C¢digo de la Nota de la Recuperaci¢n del Indicador
       LOCAL cCamJnt := ''                  // Campo nota de los indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOTA CODIGO DE EVALUACION
       lLocCodigo('cCodigoCla','CLA',SUBS(cCodInd,1,1))

       IF SUBS(cEvaInd,nNroPer,1) == '2'

	  cCamJnt := 'NOT->cN'+STR(nNroPer,1)+SUBS(cCamNot,9,4)+'Not'
	  cNtIndi := SUBS(&cCamJnt,nNroInd*nLenJnt-(nLenJnt-1),nLenJnt)
	  cNotInd := SUBS(cNtIndi,1,4)
	  cNotRec := SUBS(cNtIndi,5,4)

	  DO CASE  // Space(01) Jvf
	  CASE SUBS(CLA->cPrnJntCla,nNroPer,1) == '1' // N£merico
	       cCodEva := cNotInd
	       IF !EMPTY(cNotRec)
		  cCodEva := cNotRec
	       ENDIF

	  CASE SUBS(CLA->cPrnJntCla,nNroPer,1) == '2' // Jvf:N£merico

	       IF !EMPTY(cNotRec)
		  cCodEva := cCodEva+':'+ALLTRIM(cNotRec)
	       ELSE
		  cCodEva := cCodEva+':'+ALLTRIM(cNotInd)
	       ENDIF

	  ENDCASE

       ENDIF
       RETURN cCodEva
*>>>>FIN NOTA CODIGO DE EVALUACION

/*************************************************************************
* TITULO..: ENCABEZADO DEL BOLETIN                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2008 MAR A
       Colombia, Bucaramanga        INICIO: 09:45 AM   OCT 21/2008 MAR

OBJETIVOS:

1- Permite imprimir diferentes encabezados para los boletines.

2- Imprime los encabezados de columna.

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabPrnBol(aP1,aP2,aP3,;
		   aDetInf,aCabBol,;
		   cFecPrn,cHorPrn,cDiaPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       aCabBol				    // Detalles Encabezado Boletin
       cFecPrn                              // @Fecha de Impresi¢n
       cHorPrn                              // @Hora de Impresi¢n
       cDiaPrn                              // @D¡a de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL xIniPrm := NIL                 // Inicializaci¢n del Parametro
       LOCAL nCabIso := 0                   // Encabezado Iso
       LOCAL nNroPag := 0                   // N£mero de P gina.
*>>>>FINDECLARACION DE VARIABLES

*>>>>NUMERO DE PAGINA
       nNroPag := xPrm(aDetInf,'nNroPag')           // N£mero de p gina
       nNroPag := IF(nNroPag==NIL,NIL,++nNroPag)
       nParameSet(aDetInf,'nNroPag',nNroPag)
*>>>>FIN NUMERO DE PAGINA

*>>>>ENCABEZADOS DE LOS INFORMES
       xIniPrm := 0
       nCabIso := xPrm(aDetInf,'nCabIso',xIniPrm)   // Encabezado Iso

       DO CASE
       CASE nCabIso == 00
	    CabBol000(aP1,aP2,aP3,;
		      aDetInf,aCabBol,;
		      @cFecPrn,@cHorPrn,@cDiaPrn)
	  *ÀEncabezado por defecto

       OTHERWISE
	    CabBol000(aP1,aP2,aP3,;
		      aDetInf,aCabBol,;
		      @cFecPrn,@cHorPrn,@cDiaPrn)
	  *ÀEncabezado por defecto
       ENDCASE
       RETURN NIL
*>>>>FIN ENCABEZADOS DE LOS INFORMES

/*************************************************************************
* TITULO..: ENCABEZADO DEL BOLETIN No. 00                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2008 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   OCT 21/2008 MAR

OBJETIVOS:

1- Este encabezado es el por defecto para los Boletines

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabBol000(aP1,aP2,aP3,;
		   aDetInf,aCabBol,;
		   cFecPrn,cHorPrn,cDiaPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       aCabBol				    // Detalles Encabezado Boletin
       cFecPrn                              // @Fecha de Impresi¢n
       cHorPrn                              // @Hora de Impresi¢n
       cDiaPrn                              // @D¡a de Impresi¢n */
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

*>>>>DETALLES DEL INFORME
       LOCAL lTamAnc := xPrm(aDetInf,'lTamAnc') // .T. Tama¤o ancho
       LOCAL nColPrn := xPrm(aDetInf,'nColPrn') // Columna de impresi¢n

       LOCAL aTitIso := xPrm(aDetInf,'aTitIso') // T¡tulos del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso') // C¢digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso') // Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso') // Versi¢n del Iso

       LOCAL nNroPag := xPrm(aDetInf,'nNroPag') // N£mero p gina a imprimir
       LOCAL cTotPag := xPrm(aDetInf,'cTotPag') // Total p ginas a imprimir

       LOCAL aCabSec := xPrm(aDetInf,'aCabSec') // Encabezado Secundario
       LOCAL cCodIni := xPrm(aDetInf,'cCodIni')	// C¢digos iniciales de impresi¢n
       LOCAL xCabCol :=	xPrm(aDetInf,'xCabCol')	// Encabezados de columna
       LOCAL cCodFin := xPrm(aDetInf,'cCodFin') // C¢digos de impresora finales
*>>>>FIN DETALLES DEL INFORME

*>>>>DETALLES DEL ENCABEZADO
       LOCAL nNroPer := xPrm(aCabBol,'nNroPer') // N£mero del Periodo

       LOCAL nColEnc := xPrm(aCabBol,'nColEnc') // N£mero de Columnas para el encabezado del Boletin
       LOCAL nColBol := xPrm(aCabBol,'nColBol') // N£mero de Columnas para el cuerpo del Boletin

       LOCAL nLinEsp := xPrm(aCabBol,'nLinEsp') // N£mero de l¡neas del encabezado del boletin
       LOCAL lPrnEmp := xPrm(aCabBol,'lPrnEmp') // .T. Imprimir la Empresa en el Boletin
       LOCAL cNroFol := xPrm(aCabBol,'cNroFol') // N£mero del folio
       LOCAL cTxtTop := xPrm(aCabBol,'cTxtTop') // Texto Top del Boletin o libro
       LOCAL cTitTop := xPrm(aCabBol,'cTitTop') // Titulo Top del Boletin o libro

       LOCAL cCodEst := xPrm(aCabBol,'cCodEst') // C¢digo del Estudiante
       LOCAL cNomEst := xPrm(aCabBol,'cNomEst') // Nombre del Estudiante
       LOCAL cCodGru := xPrm(aCabBol,'cCodGru') // C¢digo del Grupo
       LOCAL nNroLis := xPrm(aCabBol,'nNroLis') // N£mero de Lista
*>>>>FIN DETALLES DEL ENCABEZADO

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL lLibro  := .F.                 // .T. Encabezado del libro
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nLinPag := 0                   // L¡neas por p gina
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
       LOCAL nTotReg := 0                   // Total Registros
       LOCAL lOficio := .F.                 // .T. Tama¤o Carta .F. Tama¤o Oficio

       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL nPosIso := 0                   // Posici¢n del Iso
       LOCAL cIsoTem := ''                  // C¢digo Iso
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL
       IF !EMPTY(cNroFol)
	  lLibro := .T.
       ENDIF
*>>>>FIN ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       SendCodes(PCL({'GraphiOn','CondenOf',;
		      'ProporOf','Pica',;
		      'DraftOf','Roman'}))

       IF lPrnEmp
	  @ PROW(),nColEnc SAY PCL("DobAncOn")+cNomEmp+PCL("DobAncOf")

	  IF !EMPTY(cNomSec)
	     DO CASE
	     CASE 'BETHLEMITAS' $ cNomSec
		  @ PROW()+1,nColEnc SAY PCL("DobAncOn")+cNomSec+;
					 PCL("DobAncOf")
	     ENDCASE
	  ENDIF

	  SendCodes(PCL("CondenOn"))
	  aNroLin := aDivLin(ALLTRIM(cTxtTop),120)

	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nColBol SAY aNroLin[i]
	  NEXT
	  SendCodes(PCL("CondenOf"))
	*ÀImpresi¢n del Texto despu‚s de la Empresa
       ENDIF
*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL TITULO SUPERIOR
       cTitTop := IF(cTitTop == NIL,'',cTitTop)
       IF !EMPTY(cTitTop)
	  cTitTop := ALLTRIM(cTitTop)
	  @ PROW()+nLinEsp,(80-LEN(cTitTop))/2 SAY cTitTop
	  nLinEsp := 2
       ENDIF
*>>>>FIN IMPRESION DEL TITULO SUPERIOR

*>>>>IMPRESION DEL NOMBRE DEL ALUMNO
       IF !EMPTY(SCO->cIsoBolCon)
	  cNomEst := SUBS(cNomEst+SPACE(36),1,36)
       ENDIF

       cTxtPrn :=    'ALUMNO: '+cNomEst+SPACE(02)+;
		     IF(lLibro,SPACE(01)+cNroFol,;
			       SPACE(02)+'PERIODO:'+STR(nNroPer,2))+;
			       SPACE(01)+;
			       SPACE(SCO->nSpaBolCon)+ALLTRIM(SCO->cIsoBolCon)

       @ PROW()+nLinEsp,nColEnc SAY cTxtPrn
*>>>>FIN IMPRESION DEL NOMBRE DEL ALUMNO

*>>>>IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA
       nLinPag := IF(lOficio,54,46)

       IF EMPTY(nTotReg)
	  cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		     'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
				SUBS(cCodGru,3,2)+SPACE(01)+;
		     'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		     'A¥O:'    +cAnoUsr	         +SPACE(01)+;
		     'JORNADA:'+cJorTxt          +SPACE(01)+;
		     'P gina No.'+LTRIM(STR(nNroPag))
       ELSE
	  cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		     'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
				SUBS(cCodGru,3,2)+SPACE(02)+;
		     'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		     'A¥O:'    +cAnoUsr	         +SPACE(01)+;
		     'JORNADA:'+cJorTxt          +SPACE(01)+;
		     'P gina No.'+LTRIM(STR(nNroPag))+'/'+;
		     cTotPagina(nTotReg,nLinPag,lOficio)
       ENDIF

       @ PROW()+1,nColEnc SAY cTxtPrn
       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})
*>>>>FIN IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA

*>>>>IMPRESION DE LA DESCRIPCION DE LA ESCALA EVALUATIVA
       nNroLin := 2
       IF nNroPag == 1
	  IF !EMPTY(COA->cDescrECoA)
	     @ PROW()+nNroLin,nColBol SAY REPL('-',122)
	     SendCodes(PCL("CondenOn"))
	     @ PROW()+1,nColBol SAY PCL("NegraOn")+;
				    'ESCALA EVALUATIVA...:'+;
				    PCL("NegraOf")


	     aNroLin := aDivLin(ALLTRIM(COA->cDescrECoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,nColBol SAY 'EXCELENTE(Ee).......: '+;
					   aNroLin[i]
		 ELSE
		    @ PROW()+1,nColBol SAY '                      '+;
					   aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrSCoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrSCoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,nColBol SAY 'SOBRESALIENTE(Ss)...: '+;
				       aNroLin[i]
		 ELSE
		    @ PROW()+1,nColBol SAY '                      '+;
				       aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrACoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrACoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,nColBol SAY 'ACEPTABLE(Aa).......: '+;
					    aNroLin[i]
		 ELSE
		    @ PROW()+1,nColBol SAY '                      '+;
					   aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrICoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrICoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,nColBol SAY 'INSUFICIENTE(Ii)....: '+;
					   aNroLin[i]
		 ELSE
		    @ PROW()+1,nColBol SAY '                      '+;
					   aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrDCoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrDCoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,nColBol SAY 'DEFICIENTE(Dd)......: '+;
					   aNroLin[i]
		 ELSE
		    @ PROW()+1,nColBol SAY '                      '+;
					   aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF
       ENDIF
*>>>>FIN IMPRESION DE LA DESCRIPCION DE LA ESCALA EVALUATIVA

*>>>>ENCABEZADO SECUNDARIO
       IF !EMPTY(aCabSec)
	  @ PROW()+2,nColBol SAY aCabSec[1]
	  FOR i := 2 TO LEN(aCabSec)
	     @ PROW()+1,nColBol SAY aCabSec[i]
	  ENDFOR
       ENDIF
*>>>>ENCABEZADO SECUNDARIO

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       cCodIni := xPrm(aDetInf,'cCodIni')
       cCodFin := xPrm(aDetInf,'cCodFin')

       @ PROW(),01 SAY cCodIni
       IF VALTYPE(xCabCol) == 'C'
	  @ PROW()+1,nColBol SAY REPL('-',LEN(xCabCol))
	  @ PROW()+1,nColBol SAY xCabCol
	  @ PROW()+1,nColBol SAY REPL('-',LEN(xCabCol))
       ELSE
	  @ PROW()+1,nColBol SAY REPL('-',LEN(xCabCol[1]))
	  FOR i := 1 TO LEN(xCabCol)
	      @ PROW()+1,nColBol SAY xCabCol[i]
	  ENDFOR
	  @ PROW()+1,nColBol SAY REPL('-',LEN(xCabCol[1]))
       ENDIF
       @ PROW(),00 SAY cCodFin
       RETURN NIL
*>>>>FIN IMPRESION DEL ENCABEZADO DE COLUMNA

/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura y valoraci¢n
   n£merica y boletin sugerido por la Belemithas Barranca.2010.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin12(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final
       nNroCol                              // N£mero de la Columna
       nColEnc                              // Columna del Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroFol := NIL                 // N£mero de Folio
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

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
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBo12(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		  cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			    nColEnc)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		 ELSE
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrn12(lHayNot,lEvaInd,lPrnEva,nLenEva,;
					  lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			       nColEnc)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,nNroCol SAY cTxtPrn
		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF

		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva
			 IF lLocCodigo('cCodigoEva','EVA',;
				       SUBS(cCodigoTev,1,1),;
				       'DE LA EVALUACION '+cCodJui)
			    cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			 ELSE
			    cCodigoTev := 'NO EXISTE'
			 ENDIF
		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso
			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(02))
			      *Espacio de Intensidad

			       AADD(aRegPrn,cNomCla)
			      *Espacio de Juicio

			       IF EMPTY(cNotAcu)
				  AADD(aRegPrn,SPACE(04))
			       ELSE
				  FOR p := 1 TO nNroBis
				     AADD(aRegPrn,SPACE(02))
				  ENDFOR
			       ENDIF
			     *ÀEspacio de la Nota

			       AADD(aRegPrn,SPACE(02))
			      *Espacio de la Ausencia

			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF
			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := {}
			 AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			 AADD(aRegPrn,'- '+cNombreTju)

			 IF EMPTY(cNotAcu)
			    AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			 ELSE
			    FOR p := 1 TO nNroBis
				AADD(aRegPrn,SPACE(02))
			    ENDFOR
			 ENDIF
			 AADD(aRegPrn,SPACE(04))
			 AADD(aRegPrn,SPACE(04))

		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(02))
			     AADD(aRegPrn,'  '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,SPACE(04))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,nNroCol SAY cTxtPrn
			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,nNroCol SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]  // Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''),,;
					       nColEnc)}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
			       cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReS)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndic12(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)

			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
			       cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReN)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndic12(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 nNroCol)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrn12(lHayNot,lEvaInd,lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cChrLin+cChrLin,;
					     REPL(cChrLin,108),;
					     SPACE(01),;
					     SPACE(01))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

		    ELSE
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis
			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)
			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre
		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrn12(lHayNot,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
				  nColEnc)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,nNroCol SAY cTxtPrn
		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF

		    lSiPaso := .F.
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva
			     IF lLocCodigo('cCodigoEva','EVA',;
					   SUBS(cCodigoTev,1,1),;
					   'DE LA EVALUACION '+cCodJui)
				cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			     ELSE
				cCodigoTev := 'NO EXISTE'
			     ENDIF
			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel

				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso
				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cNomCla)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(02))

				   @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := {}
			     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			     AADD(aRegPrn,'- '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      IF lHayNot .OR. lEvaInd

				 aRegPrn := {}
				 AADD(aRegPrn,SPACE(02))
				 AADD(aRegPrn,'  '+cNombreTju)

				 IF EMPTY(cNotAcu)
				    AADD(aRegPrn,SPACE(04))
				 ELSE
				    FOR p := 1 TO nNroBis
					AADD(aRegPrn,SPACE(02))
				    ENDFOR
				 ENDIF
				 AADD(aRegPrn,SPACE(04))
				 AADD(aRegPrn,SPACE(04))

			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''),,;
					nColEnc)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,nNroCol SAY cTxtPrn
			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]  // Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''),,;
						  nColEnc)}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+cTitReS+PCL("NegraOf")
				cTitReS := cTitReS+SPACE(108-LEN(cTitReS))

				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReS)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))
				 *ÀNota

				   AADD(aRegPrn,SPACE(04))
				 *ÀAusencia

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndic12(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+cTitReN+PCL("NegraOf")
				cTitReN := cTitReN+SPACE(108-LEN(cTitReN))

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReN)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))
				 *ÀNota

				   AADD(aRegPrn,SPACE(04))
				 *ÀAusencia

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndic12(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  nNroCol)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrn12(lHayNot,lEvaInd,lPrnEva,;
						nLenEva,lPrnCod,nNroBis,;
						cNotAcu,;
						cChrLin+cChrLin,;
						REPL(cChrLin,108),;
						SPACE(01),;
						SPACE(01))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
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

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
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
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
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
* TITULO..: COLUMNAS Y ENCABEZADOS DEL BOLETIN                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:00 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Define las columnas y t¡tulos del encabezado de columna del Boletin
   para la Sabiduria.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabColBo12(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,;
		    lPrnCod,cMsgBol,aNroCol,aTitulo,nNroPer,;
		    cNotAcu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       cMsgBol                              // Mensaje para el boletin
       aNroCol                              // @Columnas de los titulos
       aTitulo                              // @T¡tulos para el informe
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NUMEROS DE COLUMNAS
       aNroCol := {}
       AADD(aNroCol,02)
      *Columna para la Intensidad Horaria

       AADD(aNroCol,108)
      *Columna para el Nombre del Indicador o Mensaje del Boletin

       IF lPrnEva
	  IF nLenEva > 4
	     AADD(aNroCol,nLenEva)
	  ELSE
	     AADD(aNroCol,06)
	  ENDIF
       ELSE
	  IF EMPTY(cNotAcu)
	     IF lHayNot
		IF lPrnCod
		   AADD(aNroCol,04)   // Nota
		ELSE
		   AADD(aNroCol,18)
		   AADD(aNroCol,04)   // Nota
		ENDIF
	     ENDIF
	  ELSE
	     FOR i := 1 TO nNroPer
		 AADD(aNroCol,2)
	     ENDFOR
	  ENDIF
       ENDIF
     *ÀColumna para la Evaluaci¢n

       AADD(aNroCol,04)
      *Columna para las Ausencias
*>>>>FIN NUMEROS DE COLUMNAS

*>>>>TITULOS DE COLUMNA
       aTitulo := {}

       AADD(aTitulo,'IH')
      *Intensidad Horaria

       AADD(aTitulo,cMsgBol)
      *Mensaje Boletin

       IF lHayNot .OR. lEvaInd
	  IF lNotNum
	     AADD(aTitulo,'DESEMPE¥O')
	     AADD(aTitulo,'PORC')
	  ELSE
	     IF lPrnEva
		AADD(aTitulo,'JUICIO')
	     ELSE
		IF EMPTY(cNotAcu)
		   IF lHayNot
		      IF lPrnCod
			AADD(aTitulo,'JUIC')
		      ELSE
			AADD(aTitulo,'JUICIO VALORATIVO')
		      ENDIF
		   ENDIF
		ELSE
		   FOR i := 1 TO nNroPer
		       AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
		   ENDFOR
		ENDIF
	     ENDIF
	  ENDIF
       ENDIF

       AADD(aTitulo,'AUS.')
       RETURN NIL
*>>>>FIN TITULOS DE COLUMNA

/*************************************************************************
* TITULO..: REGISTRO DE IMPRESION DEL BOLETIN No. 9                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Prepara el registro de impresi¢n del Boletin en un vector.

2- Retorna el vector de impresion

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aRegPrn12(lHayNot,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		   nNroPer,cNotAcu,cColNo1,cColNo2,cColNo3,cColNo4)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas
       cColNo1                              // Columna No. 1  Intensidad
       cColNo2                              // Columna No. 2  Materia
       cColNo3                              // Columna No. 3  Nota o Notas
       cColNo4                              // Columna No. 4  Fallas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aRegPrn := {}                  // Registro de Impresi¢n
       LOCAL cJuiVal := ''                  // Juicio Valorativo
       LOCAL cPorcen := ''                  // Porcentaje
       LOCAL cTxtNot := ''                  // Texto de la Nota
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA NOTA VACIA
       IF VAL(cColNo3) == 0
	  cColNo3 := ''
       ENDIF
*>>>>FIN VALIDACION DE LA NOTA VACIA

*>>>>REGISTRO DE IMPRESION DEL BOLETIN
       AADD(aRegPrn,cColNo1)  // Intensidad
       AADD(aRegPrn,cColNo2)  // Materia

       IF lHayNot .OR. lEvaInd
	  IF lHayNot
	     IF EMPTY(cNotAcu)
		IF lPrnCod
		   AADD(aRegPrn,cColNo3)   // Notas
		ELSE
		   cJuiVal := cNotDefJvf(VAL(cColNo3))

		   cTxtNot := IF(EMPTY(cJuiVal),'',;
				 ALLTRIM(cTxtNota(cJuiVal)))

DO CASE
CASE ALLTRIM(cJuiVal) == 'I'
     cTxtNot := 'BAJO '+cTxtNot
CASE ALLTRIM(cJuiVal) == 'D'
     cTxtNot := 'BAJO '+cTxtNot
ENDCASE


		   AADD(aRegPrn,cTxtNot)

IF VAL(cColNo3) > 0
   cPorcen := VAL(cColNo3) * 10
   IF cPorcen == 100
      cPorcen := '100%'
   ELSE
      cPorcen := STR(cPorcen,2,0)+'%'
   ENDIF
   cColNo3 := cPorcen
ENDIF

		   AADD(aRegPrn,cColNo3)   // Notas

		ENDIF
	     ELSE
		FOR i := 1 TO nNroPer
		    AADD(aRegPrn,ALLTRIM(SUBS(cColNo3,i*4-3,4)))
		ENDFOR
	     ENDIF
	  ELSE
	     IF lPrnEva
		IF nLenEva > 4
		   AADD(aRegPrn,SPACE(nLenEva))
		ELSE
		   AADD(aRegPrn,SPACE(06))
		ENDIF
	     ELSE
		AADD(aRegPrn,SPACE(04))
	     ENDIF
	  ENDIF
	  AADD(aRegPrn,cColNo4)  // Intensidad

       ELSE
	  AADD(aRegPrn,cColNo3)
       ENDIF
       RETURN aRegPrn
*>>>>FIN REGISTRO DE IMPRESION DEL BOLETIN

/*************************************************************************
* TITULO..: IMPRESION DE LOS INDICADORES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 VIE

OBJETIVOS:

1- Imprime los indicadores de cualquier asignatura

2- Los indicadores pueden ser de las recuperaciones.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndic12(aNroCol,aTitulo,cCodMat,cLogros,lIndNiv,lOficio,;
		    lHayNot,cClaInd,lEvaInd,lPrnEva,nLenEva,cNivInd,;
		    bDerPrn,bCabBol,cNotAcu,nNroPer,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNroCol                              // Columnas de los titulos
       aTitulo                              // T¡tulos para el informe
       cCodMat                              // C¢digo de la Materia
       cLogros                              // Indicadores a Imprimir
       lIndNiv                              // .T. Indicadores por nivel
       lOficio                              // .F. Tama¤o carta
       lHayNot                              // .T. Hay Nota final
       cClaInd                              // Clase de Indicador de Configuraci¢n
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       cNivInd                              // Nivel del Indicador
       bDerPrn                              // Derechos de Impresi¢n
       bCabBol                              // Encabezados del Boletin
       cNotAcu                              // Notas Acumuladas
       nNroPer                              // N£mero del Periodo
       nNroCol                              // N£mero de Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   k,j,p := 0                   // Contador
       LOCAL nTotLin := 0                   // Total lineas impresas
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL aRegPrn := {}                  // Registro de impresion


       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Descripci¢n del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS INDICADORES
       IF EMPTY(TCO->nTotLinTbl)
	  nTotLin := IIF(lOficio,70,58)
       ELSE
	  nTotLin := TCO->nTotLinTbl
       ENDIF
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR k:= 1 TO nNroInd

***********SEPARACION DEL CODIGO DEL LOGRO
	     cCodInd    := SUBS(cLogros,k*6-5,6)
	     cCodLog    := SUBS(cCodInd,1,4)
	     cCodigoTev := SUBS(cCodInd,5,1)
	     IF EMPTY(cCodInd)
		LOOP
	     ENDIF
***********FIN SEPARACION DEL CODIGO DEL LOGRO

***********LOCALIZACION DEL CODIGO DE EVALUACION
	     IF lEvaInd .AND. lPrnEva
		IF lLocCodigo('cCodigoEva','EVA',;
			      SUBS(cCodigoTev,1,1),;
			      'DE LA EVALUACION '+cCodInd)
		   cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
		ELSE
		   cCodigoTev := 'NO EXISTE'
		ENDIF
	     ELSE
		cCodigoTev += SPACE(03)
	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION

***********LOCALIZACION DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
	     IF cCodLog # SPACE(04)
		cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
		IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
			      'DE LA CLASE')

*------------------ANALISIS DEL NIVEL PARA EL INDICADOR
		     IF EMPTY(CLA->cCodigoMat)
			IF EMPTY(cNivInd)
			   cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  *Por nivel
			ELSE
			   cCodigoTni := cNivInd
			  *Por Niveles
			ENDIF
		     ELSE
			cCodMat := CLA->cCodigoMat
			cCodigoTni := SPACE(02)
		     ENDIF
		   *ÀAsignaci¢n del nivel para usar indicador nivel o materia
*------------------FIN ANALISIS DEL NIVEL PARA EL INDICADOR

		ENDIF
	    ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodMat+cCodLog,;
			      cCodMat+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodInd
	     cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := JUI->cNombreJui
	     ENDIF
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION DEL INDICADOR
	     aRegPrn := {}
	     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
	     AADD(aRegPrn,'- '+cNombreTju)

	     IF lHayNot .OR. lEvaInd
		IF EMPTY(cNotAcu)
		   AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
		ELSE
		   FOR p := 1 TO nNroPer
		       AADD(aRegPrn,SPACE(02))
		   ENDFOR
		ENDIF
	     ENDIF
	     AADD(aRegPrn,SPACE(02))
	     AADD(aRegPrn,SPACE(02))

	     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
***********FIN IMPRESION DEL INDICADOR

***********IMPRESION DE LOS INDICADORES EXTRAS
	     aRegPrn := {}
	     AADD(aRegPrn,SPACE(02))

	     FOR j := 1 TO TCO->nJuiExtTbl

		 cNombreTju := &('JUI->cExtra'+STR(j,1)+'Jui')
		 AADD(aRegPrn,'  '+cNombreTju)

		 IF lHayNot .OR. lEvaInd
		    IF EMPTY(cNotAcu)
		       AADD(aRegPrn,SPACE(04))
		    ELSE
		       FOR p := 1 TO nNroPer
			   AADD(aRegPrn,SPACE(02))
		       ENDFOR
		    ENDIF
		 ENDIF
		 AADD(aRegPrn,SPACE(02))
		 AADD(aRegPrn,SPACE(02))

		 IF !EMPTY(cNombreTju)
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF

	     ENDFOR
***********FIN IMPRESION DE LOS INDICADORES EXTRAS

***********ANALISIS PARA EL CAMBIO DE PAGINA
	     IF PROW() > nTotLin
		EVAL(bDerPrn)
*		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		EJECT
		EVAL(bCabBol)

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		@ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		@ PROW()+1,nNroCol SAY cTxtPrn
		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		@ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	     ENDIF
***********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION DE LOS INDICADORES

/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura.

2- Boletin sugerido Colegio San Jose, Solo notas

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Boletin13(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,;
		   cTitDos,nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,;
		   aNotAre,aNotMat,aFirmas,nColEnc,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
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
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
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
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
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
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		 cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			    nColEnc)
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    lPagina := .F.
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 IF aNotAre[i][13]  // .T. Modalidad
		    cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(01)
		    IF EMPTY(cJuicio)
		       LOOP
		    ENDIF
		    cJuicio := ''
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*--------------LECTURA DE LA NOTA DEL AREA
		 cNota := ''
		 IF EMPTY(cNotAcu)

		    cNota := SUBS(&(aNotAre[i,4]),nNroBis*4-3,4)
		    cNota := ALLTRIM(cNota)
		   *Nota de la materia

		    IF VAL(cNota) > 0
		       cNota := cNotDefJvf(VAL(cNota))
		    ENDIF

		 ELSE

		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroBis

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			IF VAL(cNotDef) # 0
			   cNotDef := cNotDefJvf(VAL(cNotDef))
			   cNotRec := cNotDefJvf(VAL(cNotRec))
			ENDIF

			IF lRecNot
			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF
			ELSE
			   cNota += cNotDef
			ENDIF

		    ENDFOR
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		    FOR k := 1 TO nNroBis
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------IMPRESION DEL REGISTRO DEL AREA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomAre := aNotAre[i,10]
		 IF lNegAre
		    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := aRegPrnBol(lPrnNotPla(lHayNot,;
						     aNotAre[i][17],;
						     nNroBis),;
					  lNotNum,lEvaInd,lPrnEva,;
					  nLenEva,lPrnCod,nNroBis,cNotAcu,;
					  cIntens,;
					  cNomAre+SPACE(108-LEN(aNotAre[i,10])),;
					  cNota,;
					  cNroFal)
		 ELSE
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,10])))
		    AADD(aRegPrn,cNroFal)
		 ENDIF
		@ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > nTotLin
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		    EJECT
		    CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			       nTotReg,;
			       cNomEst,;
			       NOT->cCodigoEst,;
			       GRU->cCodigoGru,;
			       NOT->(RECNO()),nPorAcu,;
			       cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
			       cNomEmp,lPrnEmp,cNroFol,,,;
			       IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
			       nColEnc)

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})


		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,nNroCol SAY cTxtPrn
		    @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		    @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := ALLTRIM(&(aNotAre[i,6]))+SPACE(02)
		 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)
		 IF TCO->nRecPerTbl==1
		    aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		 ENDIF
	       *ÀDescarta los indicadores ya recuperados.

  aJuicio := {}
*ÀNo imprime los indicadores
		 lSiPaso := .F.
		 FOR j:= 1 TO LEN(aJuicio)

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := aJuicio[j]
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)

		      cCodigoTev := cCodEvaNot(TCO->cEvaIndTbl,;
					       nNroBis,;
					       aNotAre[i,4],;
					       cCodJui,;
					       cCodigoTev,j)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
		      IF lEvaInd .AND. lPrnEva

			 IF VAL(cCodigoTev) == 0  .AND.;
			    !(':' $ cCodigoTev)  // Modificado Virrey

			    IF lLocCodigo('cCodigoEva','EVA',;
					  SUBS(cCodigoTev,1,1),;
					  'DE LA EVALUACION '+cCodJui)
			       cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
			    ELSE
			       cCodigoTev := 'NO EXISTE'
			    ENDIF

			 ENDIF

		      ELSE
			 cCodigoTev += SPACE(03)
		      ENDIF
*                   FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					  "**INDICADORES**",CLA->cNomBolCla)

			    nLenTxt := LEN(ALLTRIM(cNomCla))
			    cChrIni := ALLTRIM(CLA->cChrIniCla)
			    cChrFin := ALLTRIM(CLA->cChrFinCla)

			    IF !EMPTY(CLA->cChrIniCla) .AND.;
			       !EMPTY(CLA->cChrFinCla)
			       cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
			       cNomCla := ALLTRIM(cNomCla)+;
					  SPACE(108-nLenTxt)
			    ENDIF

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := cNomInd(JUI->cNombreJui,;
					       CLA->lMinuscCla,;
					       CLA->cTipPrnCla,.T.)
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION CLASE DE INDICADOR
		      IF lHayNot .AND. !lEvaInd

			 IF !lSiPaso
			    cCodAnt := cCodigoTcl
			 ENDIF

			 IF cCodAnt $ CLA->cCodClaCla
			    IF !lSiPaso
			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(02))
			      *Espacio de Intensidad

			       AADD(aRegPrn,cNomCla)
			      *Espacio de Juicio

			       IF EMPTY(cNotAcu)
				  AADD(aRegPrn,SPACE(04))
			       ELSE
				  FOR p := 1 TO nNroBis
				     AADD(aRegPrn,SPACE(02))
				  ENDFOR
			       ENDIF
			     *ÀEspacio de la Nota

			       AADD(aRegPrn,SPACE(02))
			      *Espacio de la Ausencia

			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			    ENDIF
			    IF j < LEN(aJuicio)
			       IF SUBS(aJuicio[j+1],1,1) == cCodAnt
				  lSiPaso := .T.
			       ELSE
				  lSiPaso := .F.
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN IMPRESION CLASE DE INDICADOR

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd

			 aRegPrn := {}
			 AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			 AADD(aRegPrn,'- '+cNombreTju)

			 IF EMPTY(cNotAcu)
			    AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			 ELSE
			    FOR p := 1 TO nNroBis
				AADD(aRegPrn,SPACE(02))
			    ENDFOR
			 ENDIF
			 AADD(aRegPrn,SPACE(04))

		      ELSE
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     SPACE(04)}
		      ENDIF
		      @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  cNombreTju := cNomInd(cNombreTju,;
						CLA->lMinuscCla,;
						CLA->cTipPrnCla,.T.)
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(02))
			     AADD(aRegPrn,'  '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,SPACE(04))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(04)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > nTotLin
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
			 EJECT
			 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				    nTotReg,;
				    cNomEst,;
				    NOT->cCodigoEst,;
				    GRU->cCodigoGru,;
				    NOT->(RECNO()),nPorAcu,;
				    cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				    cNomEmp,lPrnEmp,cNroFol,,,;
				    IF(nNroBis==nTotPer,TCO->cTitBolTbl,''))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			 @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,nNroCol SAY cTxtPrn
			 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			 @ PROW()  ,nNroCol SAY PCL({"NegraOf","DobGolOf"})
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

*--------------ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA
		 IF nNroBis > 1 .AND. !aNotAre[i,15]  // Recuperable

*:::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION AREA
		      bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						nLenPrn,lOficio,lPiePag)}
		     *Impresi¢n de los Derechos de Autor

		      bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					       cTxtPrn,;
					       nNroPag++,nTotReg,;
					       cNomEst,NOT->cCodigoEst,;
					       GRU->cCodigoGru,;
					       NOT->(RECNO()),nPorAcu,;
					       cPorcen,nNroBis,cAnoSys,;
					       cJorTxt,3,cNomEmp,lPrnEmp,;
					       cNroFol,,,;
					       IF(nNroBis==nTotPer,;
					       TCO->cTitBolTbl,''),,;
					       nColEnc)}
		     *Impresi¢n del Encabezado del Boletin
*:::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION AREA

*:::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA
		      FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*.........................INDICADORES POR SI/NO RECUPERAR AREA
			    cCamJuiNot := aNotAre[i,6]
			    cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			       cIndAnt := &cCamJuiNot
			       cSiRecu := ''
			       cNoRecu := ''
			    IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*.........................FIN INDICADORES POR SI/NO RECUPERAR AREA

*.........................IMPRESION DE LOS INDICADORES RECUPERADOS AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
			       !EMPTY(cSiRecu)
			       cTitReS := ALLTRIM(TCO->cTitReSTbl)
			       IF EMPTY(cTitReS)
				  cTitReS := '** INDICADORES RECUPERADOS '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReS := PCL("NegraOn")+cTitReS+;
					  SPACE(108-LEN(cTitReS))+;
					  PCL("NegraOf")

			       nNroPos := AT('NO.#',cTitReS)
			       IF nNroPos # 0
				  cTitReS := STUFF(cTitReS,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReS)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReS,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cSiRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 SPACE(09),lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 y,nNroCol)

			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS AREA

*.........................IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
			    IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
			       !EMPTY(cNoRecu) .AND. y < nNroBis
			       cTitReN := ALLTRIM(TCO->cTitReNTbl)
			       IF EMPTY(cTitReN)
				  cTitReN := '** INDICADORES POR RECUPERAR '+;
					     'PERIODO NO.# **'
			       ENDIF
			       cTitReN := PCL("NegraOn")+;
					  cTitReN+SPACE(108-LEN(cTitReN))+;
					  PCL("NegraOf")

			       nNroPos := AT('NO.#',cTitReN)
			       IF nNroPos # 0
				  cTitReN := STUFF(cTitReN,;
						   nNroPos,4,'No.'+STR(y,1))
			       ENDIF

			       IF lHayNot .OR. lEvaInd

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(02))
				  AADD(aRegPrn,cTitReN)

				  IF EMPTY(cNotAcu)
				     AADD(aRegPrn,SPACE(04))
				  ELSE
				     FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				     ENDFOR
				  ENDIF
				  AADD(aRegPrn,SPACE(04))

			       ELSE
				  aRegPrn := {SPACE(02),;
					      cTitReN,;
					      SPACE(02)}
			       ENDIF
			       @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			       PrnIndica(aNroCol,aTitulo,;
					 SUBS(aNotAre[i,6],9,4),;
					 cNoRecu,lIndNiv,lOficio,;
					 lHayNot,lNotNum,lPrnCod,;
					 cClaInd,lEvaInd,;
					 lPrnEva,nLenEva,;
					 cCodigoTni,bDerPrn,;
					 bCabBol,cNotAcu,nNroBis,;
					 y,nNroCol)
			    ENDIF
*.........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		      NEXT
*:::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES AREA

		 ENDIF
*--------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS DEL AREA

*--------------IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin)
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					     nLenEva,lPrnCod,nNroBis,cNotAcu,;
					     REPL(cChrLin,aNroCol[1]),;
					     REPL(cChrLin,aNroCol[2]),;
					     REPL(cChrLin,aNroCol[3]),;
					     REPL(cChrLin,aNroCol[4]))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*--------------FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    IF aNotMat[j][13]  // .T. Modalidad
		       cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(01)
		       IF EMPTY(cJuicio)
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*-----------------LECTURA DE LA NOTAS DE LA MATERIA
		    cNota := ''
		    IF EMPTY(cNotAcu)

		       cNota := SUBS(&(aNotMat[j,4]),nNroBis*4-3,4)
		       cNota := ALLTRIM(cNota)
		      *Nota de la materia

		       IF VAL(cNota) > 0
			  cNota := cNotDefJvf(VAL(cNota))
		       ENDIF

		    ELSE

		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroBis

			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			   IF VAL(cNotDef) > 0
			      cNotDef := cNotDefJvf(VAL(cNotDef))
			      cNotRec := cNotDefJvf(VAL(cNotRec))
			   ENDIF

			   IF lRecNot
			      IF !EMPTY(cNotRec)
				 cNota += ALLTRIM(cNotDef)+;
					  LOWER(ALLTRIM(cNotRec))+SPACE(02)
			      ELSE
				 cNota += cNotDef
			      ENDIF
			   ELSE
			      cNota += cNotDef
			   ENDIF
		       ENDFOR
		    ENDIF
*-----------------FIN LECTURA DE LA NOTAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF SUBS(TCO->cTotAusTbl,nNroBis,1) == '1'
		       FOR k := 1 TO nNroBis
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroBis*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre

		       IF lMatVar
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,02])
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := ALLTRIM(aNotAre[i,10])+' : '+;
				     ALLTRIM(aNotMat[j,10])
		       ENDIF

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		       cNomMat := SUBS(cNomMat,1,108)
		    ELSE
		       IF lMatVar
			  cNomMat := aNotMat[j,02]+SPACE(108-LEN(aNotMat[j,02]))
			*ÀMateria Notas o Certificado
		       ELSE
			  cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
		       ENDIF
		    ENDIF

		    IF lNegAre
		       cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnBol(lPrnNotPla(lHayNot,;
							aNotMat[j][17],;
							nNroBis),;
					     lNotNum,lEvaInd,;
					     lPrnEva,nLenEva,;
					     lPrnCod,nNroBis,cNotAcu,;
					     cIntens,;
					     cNomMat,;
					     cNota,;
					     cNroFal)
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF

		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > nTotLin
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
		       EJECT
		       CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				  nTotReg,;
				  cNomEst,;
				  NOT->cCodigoEst,;
				  GRU->cCodigoGru,;
				  NOT->(RECNO()),nPorAcu,;
				  cPorcen,nNroBis,cAnoSys,cJorTxt,3,;
				  cNomEmp,lPrnEmp,cNroFol,,,;
				  IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
				  nColEnc)

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,nNroCol SAY cTxtPrn
		       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		       @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := ALLTRIM(&(aNotMat[j,5]))+SPACE(02)
		    aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

		    IF TCO->nRecPerTbl==1
		       aJuicio := aJuicio1(aJuicio,lEvaInd,.T.)
		    ENDIF
		  *ÀDescarta los indicadores ya recuperados

  aJuicio := {}
*ÀNo imprime los indicadores

		    lSiPaso := .F.
		    FOR k:= 1 TO LEN(aJuicio)

*			VALIDACION DEL JUICIO
			  cCodJui    := aJuicio[k]
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)

			  cCodigoTev := cCodEvaNot(TCO->cEvaIndTbl,;
						   nNroBis,;
						   aNotMat[j,4],;
						   cCodJui,;
						   cCodigoTev,k)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                       BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR
			  IF lEvaInd .AND. lPrnEva

			     IF VAL(cCodigoTev) == 0 .AND.;
				!(':' $ cCodigoTev)  // Modificado Virrey

				IF lLocCodigo('cCodigoEva','EVA',;
					      SUBS(cCodigoTev,1,1),;
					      'DE LA EVALUACION '+cCodJui)
				   cCodigoTev := SUBS(EVA->cNombreEva,1,;
						      nLenEva)
				ELSE
				   cCodigoTev := 'NO EXISTE'
				ENDIF

			     ENDIF

			  ELSE
			     cCodigoTev += SPACE(03)
			  ENDIF
*                       FIN BUSQUEDA DEL CODIGO DE EVALUACION DEL INDICADOR

*                       BUSQUEDA DE LA CLASE DE INDICADOR
			  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  cCodigoTma := SUBS(aNotMat[j,11],3,4)

			  IF cCodLog # SPACE(04)
			     cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			     IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					   'DE LA CLASE')

				cNomCla := IF(EMPTY(CLA->cNomBolCla),;
					      "**INDICADORES**",CLA->cNomBolCla)

				nLenTxt := LEN(ALLTRIM(cNomCla))
				cChrIni := ALLTRIM(CLA->cChrIniCla)
				cChrFin := ALLTRIM(CLA->cChrFinCla)

				IF !EMPTY(CLA->cChrIniCla) .AND.;
				   !EMPTY(CLA->cChrFinCla)
				   cNomCla := &cChrIni+ALLTRIM(cNomCla)+&cChrFin
				   cNomCla := ALLTRIM(cNomCla)+;
					      SPACE(108-nLenTxt)
				ENDIF

				IF EMPTY(CLA->cCodigoMat)
				   IF EMPTY(SUBS(aNotMat[j,11],1,2))
				      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				     *Por nivel
				   ELSE
				      cCodigoTni := SUBS(aNotMat[j,11],1,2)
				     *Por Niveles
				   ENDIF
				ELSE
				   cCodigoTni := SPACE(02)
				   cCodigoTma := CLA->cCodigoMat
				ENDIF
			      *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			     ENDIF
			  ENDIF
*                       FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := cNomInd(JUI->cNombreJui,;
						   CLA->lMinuscCla,;
						   CLA->cTipPrnCla,.T.)
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION CLASE DE INDICADOR
			  IF lHayNot .AND. !lEvaInd

			     IF !lSiPaso
				cCodAnt := cCodigoTcl
			     ENDIF

			     IF cCodAnt $ CLA->cCodClaCla
				IF !lSiPaso
				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cNomCla)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					 AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(02))

				   @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
				ENDIF
				IF k < LEN(aJuicio)
				   IF SUBS(aJuicio[k+1],1,1) == cCodAnt
				      lSiPaso := .T.
				   ELSE
				      lSiPaso := .F.
				   ENDIF
				ENDIF
			     ENDIF
			  ENDIF
*                       FIN IMPRESION CLASE DE INDICADOR

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd

			     aRegPrn := {}
			     AADD(aRegPrn,cClaInd(cClaInd,cCodigoTcl))
			     AADD(aRegPrn,'- '+cNombreTju)

			     IF EMPTY(cNotAcu)
				AADD(aRegPrn,IF(lEvaInd,cCodigoTev,SPACE(04)))
			     ELSE
				FOR p := 1 TO nNroBis
				    AADD(aRegPrn,SPACE(02))
				ENDFOR
			     ENDIF
			     AADD(aRegPrn,SPACE(04))

			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(04)}
			  ENDIF
			  @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      cNombreTju := cNomInd(cNombreTju,;
						    CLA->lMinuscCla,;
						    CLA->cTipPrnCla,.T.)
			      IF lHayNot .OR. lEvaInd

				 aRegPrn := {}
				 AADD(aRegPrn,SPACE(02))
				 AADD(aRegPrn,'  '+cNombreTju)

				 IF EMPTY(cNotAcu)
				    AADD(aRegPrn,SPACE(04))
				 ELSE
				    FOR p := 1 TO nNroBis
					AADD(aRegPrn,SPACE(02))
				    ENDFOR
				 ENDIF
				 AADD(aRegPrn,SPACE(04))

			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(04)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > nTotLin
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,;
					 lOficio,lPiePag)
			     EJECT
			     CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,;
					nNroPag++,nTotReg,;
					cNomEst,;
					NOT->cCodigoEst,;
					GRU->cCodigoGru,;
					NOT->(RECNO()),nPorAcu,;
					cPorcen,nNroBis,cAnoSys,;
					cJorTxt,3,cNomEmp,lPrnEmp,;
					cNroFol,,,IF(nNroBis==nTotPer,;
					TCO->cTitBolTbl,''),,;
					nColEnc)

			     cTxtPrn := cRegPrint(aTitulo,aNroCol)
*			     @ PROW(),00 SAY DRAFT_ON+CONDEN_ON
			     @ PROW(),nNroCol SAY PCL({"DraftOn","CondenOn"})

			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
			     @ PROW()+1,nNroCol SAY cTxtPrn
			     @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

*			     @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
			     @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

*-----------------ANALISIS DE LOS INDICADORES RECUPERADOS MATERIA
		    IF nNroBis > 1 .AND. !aNotMat[j,15]  // Recuperable

*::::::::::::::::::::::DEFINICION DE BLOQUES DE FUNCION
			 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
						   nLenPrn,lOficio,lPiePag)}
			*Impresi¢n de los Derechos de Autor

			 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
						  cTxtPrn,;
						  nNroPag++,nTotReg,;
						  cNomEst,NOT->cCodigoEst,;
						  GRU->cCodigoGru,;
						  NOT->(RECNO()),nPorAcu,;
						  cPorcen,nNroBis,cAnoSys,;
						  cJorTxt,3,cNomEmp,lPrnEmp,;
						  cNroFol,,,;
						  IF(nNroBis==nTotPer,;
						  TCO->cTitBolTbl,''),,;
						  nColEnc)}
			*Impresi¢n del Encabezado del Boletin
*::::::::::::::::::::::FIN DEFINICION DE BLOQUES DE FUNCION

*::::::::::::::::::::::ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		       FOR y := 1 TO IF(TCO->nRecPerTbl==0,nNroBis-1,nNroBis)

*..........................INDICADORES POR SI/NO RECUPERAR. MATERIA
			     cCamJuiNot := aNotMat[j,5]
			     cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
				cIndAnt := &cCamJuiNot
				cSiRecu := ''
				cNoRecu := ''
			     IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*..........................FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*..........................IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,4,1)) .AND.;
				!EMPTY(cSiRecu)

				cTitReS := ALLTRIM(TCO->cTitReSTbl)
				IF EMPTY(cTitReS)
				   cTitReS := '** INDICADORES RECUPERADOS '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReS := PCL("NegraOn")+;
					   cTitReS+SPACE(108-LEN(cTitReS))+;
                                           PCL("NegraOf")

				nNroPos := AT('NO.#',cTitReS)
				IF nNroPos # 0
				   cTitReS := STUFF(cTitReS,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReS)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReS,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cSiRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  SPACE(09),lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  y,nNroCol)
			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES RECUPERADOS. MATERIA

*..........................IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA
			     IF EMPTY(SUBS(TCO->cCfgBolTbl,5,1)) .AND.;
				!EMPTY(cNoRecu) .AND. y < nNroBis
				cTitReN := ALLTRIM(TCO->cTitReNTbl)
				IF EMPTY(cTitReN)
				   cTitReN := '** INDICADORES POR RECUPERAR '+;
					      'PERIODO NO.# **'
				ENDIF
				cTitReN := PCL("NegraOn")+;
					   cTitReN+SPACE(108-LEN(cTitReN))+;
                                           PCL("NegraOf")

				nNroPos := AT('NO.#',cTitReN)
				IF nNroPos # 0
				   cTitReN := STUFF(cTitReN,;
						    nNroPos,4,'No.'+STR(y,1))
				ENDIF

				IF lHayNot .OR. lEvaInd

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(02))
				   AADD(aRegPrn,cTitReN)

				   IF EMPTY(cNotAcu)
				      AADD(aRegPrn,SPACE(04))
				   ELSE
				      FOR p := 1 TO nNroBis
					  AADD(aRegPrn,SPACE(02))
				      ENDFOR
				   ENDIF
				   AADD(aRegPrn,SPACE(04))

				ELSE
				   aRegPrn := {SPACE(02),;
					       cTitReN,;
					       SPACE(02)}
				ENDIF
				@PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

				IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				   cMatRec := SUBS(aNotMat[j,11],3,4)
				ELSE
				   cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
				ENDIF

				PrnIndica(aNroCol,aTitulo,cMatRec,;
					  cNoRecu,lIndNiv,lOficio,;
					  lHayNot,lNotNum,lPrnCod,;
					  cClaInd,lEvaInd,;
					  lPrnEva,nLenEva,;
					  SUBS(aNotMat[j,11],1,2),;
					  bDerPrn,bCabBol,cNotAcu,nNroBis,;
					  y,nNroCol)

			     ENDIF
*..........................FIN IMPRESION DE LOS INDICADORES POR RECUPERAR. MATERIA

		       NEXT
*::::::::::::::::::::::FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

		    ENDIF
*-----------------FIN ANALISIS DE LOS INDICADORES RECUPERADOS. MATERIA

*-----------------IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin)
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrnBol(lHayNot,lNotNum,lEvaInd,;
						lPrnEva,nLenEva,lPrnCod,;
						nNroBis,cNotAcu,;
						REPL(cChrLin,aNroCol[1]),;
						REPL(cChrLin,aNroCol[2]),;
						REPL(cChrLin,aNroCol[3]),;
						REPL(cChrLin,aNroCol[4]))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*-----------------FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

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
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     IF(nNroBis==nTotPer,TCO->cTitBolTbl,''),,;
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

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
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
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
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

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
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