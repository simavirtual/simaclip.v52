/*************************************************************************
* TITULO..: INDICE DE CUMPLIMIENTO. POR GRUPO. METODO No. 103            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 02:10 PM  MAR 19/2009 JUE
       Colombia, Bucaramanga        FINAL : 02:15 PM  MAR 19/2009 JUE

OBJETIVOS:

1- Recorre todos los estudiantes del grupo para realizar los c lculos

2- Calcala el ¡ndice de cumplimiento. Variable

3- Propuesto por el Colegio Salle - Bucaramanga

5- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalNot103(aP1,aP2,aP3,nNroPer,nTotPer,aNotAre,aNotMat,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nNroPer			            // N£mero del Periodo
       nTotPer                              // Total Periodos
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aTotErr			            // Hay Error */
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR NOTAS
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF lRetiroTes
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********CALCULOS AREAS MATERIAS
	    AreMat103(lShared,GRU->cCodigoGru,aNotAre,aNotMat,;
		      nNroPer,nTotPer,aTotErr)
**********FIN CALCULOS AREAS MATERIAS

	  NOT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS

/*************************************************************************
* TITULO..: INDICE DE CUMPLIMIENTO. AREAS Y MATERIAS. METODO No. 102     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 02:15 PM  MAR 19/2009 JUE
       Colombia, Bucaramanga        FINAL : 02:20 PM  MAR 19/2009 JUE

OBJETIVOS:

1- Recorre todas las areas y materias para realizar el c lculo

2- Calcala el ¡ndice de cumplimiento. Variable

3- Propuesto por el Colegio Salle - Bucaramanga

4- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AreMat103(lShared,cCodGru,aNotAre,aNotMat,nNroPer,nTotPer,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cCodGru                              // C¢digo del Grupo
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodos
       aTotErr			            // Hay Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador

       LOCAL cNotAre := ''                  // Nota del Area
       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL lJvfCalTma := .F.              // .F. Calcula el Juicio Valorativo .T. No Calcula el Juicio Valorativo

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCamDefNot := ''               // Campo notas definitivas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       FOR i := 1 TO LEN(aNotAre)

**********ANALISIS AREA NO PROMEDIABLE
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	       LOOP
	    ENDIF
**********FIN ANALISIS AREA NO PROMEDIABLE

**********ANALISIS DE DECISION
	    lJvfCalTma := !aNotAre[i,19]
	    IF .NOT. lJvfCalTma
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********RECORRIDO POR MATERIAS
	    FOR j := 1 TO LEN(aNotMat)

*===============ANALISIS MATERIA DEL AREA
		  IF aNotAre[i,2] # aNotMat[j,1]
		     LOOP
		  ENDIF
*===============FIN ANALISIS MATERIA DEL AREA

*===============ANALISIS DE DECISION
		  lJvfCalTma := !aNotMat[j,19]
		  IF .NOT. lJvfCalTma
		     LOOP
		  ENDIF
*===============FIN ANALISIS DE DECISION

*===============NOTA DEL AREA
		  cCodigoTma := SUBS(aNotMat[j,4],9,4)

		  cNotAre := cJvfAre103(cCodGru,aNotAre,aNotMat,;
					nNroPer,;
					nTotPer,;
					cCodigoTma,@aTotErr)

		  cNotDef := ALLTRIM(cNotAre)+SPACE(03)
*===============FIN NOTA DEL AREA

*===============GRABACION DE LA NOTA DEL AREA
		  cCamDefNot := 'NOT->cNt'+SUBS(cCodigoTma,1,2)+'00'+'100'

		  SELECT NOT
		  IF NOT->(lRegLock(lShared,.F.))

		     REPL &cCamDefNot WITH;
			  STUFF(&cCamDefNot,nNroPer*4-3,4,cNotAre)
		   *ÀNota del Area

		     NOT->(DBCOMMIT())
		  ELSE
		     cError('NO SE PUEDE GRABAR LAS NOTAS')
		  ENDIF
		  IF lShared
		     NOT->(DBUNLOCK())
		  ENDIF
*===============FIN GRABACION DE LA NOTA DEL AREA

	    ENDFOR
**********RECORRIDO POR MATERIAS

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS

/*************************************************************************
* TITULO..: CALCULO DE LA NOTA DEL AREA. INDICE DE CUMPLIMIENTO          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 02:20 PM  MAR 19/2009 JUE
       Colombia, Bucaramanga        FINAL : 02:25 PM  MAR 19/2009 JUE

OBJETIVOS:

1- Calcula la nota del Area, seg£n el indice de cumplimiento. variable

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJvfAre103(cCodGru,aNotAre,aNotMat,nNroPer,nTotPer,cCodAre,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodos
       cCodAre                              // C¢digo del Area
       aTotErr			            // Hay Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aHayErr := ''                  // Detalles del Error

       LOCAL i,j := 0                       // Contadores

       LOCAL nTotMat := 0                   // Total Materias
       LOCAL nIntMat := 0                   // Intensidad Horaria Materia
       LOCAL nIntAre := 0                   // Intensidad Horaria Area

       LOCAL cIndic1 := ''                  // Indicadores del Periodo No.1
       LOCAL cIndic2 := ''                  // Indicadores del Periodo No.2
       LOCAL cIndic3 := ''                  // Indicadores del Periodo No.3
       LOCAL cIndic4 := ''                  // Indicadores del Periodo No.4
       LOCAL cIndic5 := ''                  // Indicadores del Periodo No.5

       LOCAL cNotDef := ''                  // Nota Defitiva
       LOCAL cNotMat := ''                  // Nota de la Materia
       LOCAL cNotAre := ''                  // Nota del Area

       LOCAL nIndice := 0                   // Indice de Cumplimiento
       LOCAL lHayDef := .T.                 // .T. Hay nota definitiva
       LOCAL nCumMat := 0                   // Indice de Cumplimiento de la Materia
       LOCAL nTotCum := 0                   // Total del Indice de Cumplimiento del Area
       LOCAL nCumAre := 0                   // Indice de Cumplimiento del Area
       LOCAL cCumAre := ''                  // Indice de Cumplimiento del Area

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       FOR i := 1 TO LEN(aNotAre)

***********ANALISIS DEL AREA
	     IF aNotAre[i][2] # SUBS(cCodAre,1,2)
		LOOP
	     ENDIF
***********FIN ANALISIS DEL AREA

***********ANALISIS AREA NO PROMEDIABLE
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN'

		cCodigoTma := cCodAre

*===============CAMPO DE INDICADORES
		  cIndic1 := &('NOT->cJ1'+cCodigoTma+'Not')
		  cIndic2 := &('NOT->cJ2'+cCodigoTma+'Not')
		  cIndic3 := &('NOT->cJ3'+cCodigoTma+'Not')
		  cIndic4 := &('NOT->cJ4'+cCodigoTma+'Not')
		  cIndic5 := &('NOT->cJ5'+cCodigoTma+'Not')
*===============FIN CAMPO DE INDICADORES

*===============INDICE DE CUMPLIMIENTO
		  cNotDef := cJvfCal103(cIndic1,;
					cIndic2,;
					cIndic3,;
					cIndic4,;
					cIndic5,;
					nNroPer,nTotPer,;
					@nIndice,cCodigoTma)+SPACE(03)

		  cNotDef := ALLTRIM(cNotDef)

		  cNotAre := SUBS(cNotDef+SPACE(04),1,4)
*===============FIN INDICE DE CUMPLIMIENTO

		 EXIT

	     ENDIF
***********FIN ANALISIS AREA NO PROMEDIABLE

***********RECORRIDO POR MATERIAS
	     nIntAre := 0
	     nTotMat := 0
	     nTotCum := 0
	     lHayDef := .T.

	     FOR j := 1 TO LEN(aNotMat)

*===============ANALISIS MATERIA DEL AREA
		  IF aNotAre[i,2] # aNotMat[j,1]
		     LOOP
		  ENDIF
*===============FIN ANALISIS MATERIA DEL AREA

*===============ANALISIS SI LA MATERIA VIENE COMO AREA
		  cCodigoTma := SUBS(aNotMat[j,4],9,4)
		  IF SUBS(cCodigoTma,3,2) == '00'
		     LOOP
		  ENDIF
*===============FIN ANALISIS SI LA MATERIA VIENE COMO AREA

*===============CAMPO DE INDICADORES
		  cIndic1 := &('NOT->cJ1'+cCodigoTma+'Not')
		  cIndic2 := &('NOT->cJ2'+cCodigoTma+'Not')
		  cIndic3 := &('NOT->cJ3'+cCodigoTma+'Not')
		  cIndic4 := &('NOT->cJ4'+cCodigoTma+'Not')
		  cIndic5 := &('NOT->cJ5'+cCodigoTma+'Not')

		  cNotMat := SUBS(&(aNotMat[j,4]),nNroPer*4-3,4)
*===============FIN CAMPO DE INDICADORES

*===============INDICE DE CUMPLIMIENTO
		  nIndice := 0
		  cNotDef := cJvfCal103(cIndic1,;
					cIndic2,;
					cIndic3,;
					cIndic4,;
					cIndic5,;
					nNroPer,nTotPer,;
					@nIndice,cCodigoTma)+SPACE(03)
*===============FIN INDICE DE CUMPLIMIENTO

/*
*===============VALIDACION DE LA NOTA
		  DO CASE
		  CASE ALLTRIM(cNotMat) # ALLTRIM(cNotDef)

		       cHayErr := 'Notas diferentes.'
		       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

		       aHayErr := {}
		       AADD(aHayErr,{'cCodEst',NOT->cCodigoEst})         // C¢digo del Estudiante
		       AADD(aHayErr,{'cCodGru',GRU->cCodigoGru})         // C¢digo del Grupo
		       AADD(aHayErr,{'cNroLis',NOT->(STR(RECNO(),2))})   // Numero de lista
		       AADD(aHayErr,{'cCodMat',cCodigoTma})              // C¢digo de la materia
		       AADD(aHayErr,{'cNotDef',cNotDef})                 // Nota
		       AADD(aHayErr,{'cNotCal',cNotMat})                 // Nota Calculada
		       AADD(aHayErr,{'cHayErr',cHayErr})                 // Detalle del Error
		     *ÀHay Error

		       AADD(aTotErr,aHayErr)

		  ENDCASE
*===============FIN VALIDACION DE LA NOTA
*/

*===============ANALISIS DE EVALUACION
		  nIntMat := VAL(aNotMat[j,3])
		  IF nIntMat # 0 .AND. nIndice == 0

		     IF EMPTY(cIndic1+cIndic2+cIndic3+cIndic4+cIndic5)
			cHayErr := 'No tinen indcadores '+;
				   'en ning£n periodo. '+;
				   'NO SE CALCULA EL AREA'
		     ELSE
			cHayErr := 'Intensidad:'+aNotMat[j,3]+' '+;
				   'Indice== 0. NO SE CALCULA EL AREA'
		     ENDIF

		     cHayErr := SUBS(cHayErr+SPACE(80),1,80)

		     aHayErr := {}
		     AADD(aHayErr,{'cCodEst',NOT->cCodigoEst})         // C¢digo del Estudiante
		     AADD(aHayErr,{'cCodGru',GRU->cCodigoGru})         // C¢digo del Grupo
		     AADD(aHayErr,{'cNroLis',NOT->(STR(RECNO(),2))})   // Numero de lista
		     AADD(aHayErr,{'cCodMat',cCodigoTma})              // C¢digo de la materia
		     AADD(aHayErr,{'cNotDef',''})                      // Nota
		     AADD(aHayErr,{'cNotCal',cNotDef})                 // Nota Calculada
		     AADD(aHayErr,{'cHayErr',cHayErr})                 // Detalle del Error
		   *ÀHay Error

		     AADD(aTotErr,aHayErr)

		     lHayDef := .F.
		     LOOP
		  ENDIF
*===============FIN ANALISIS DE EVALUACION

*===============INTENSIDAD HORARIA
		  nIntAre += nIntMat
		  nTotMat++

		  nIndice := nIndice/100
		  nCumMat := nIndice*nIntMat
		  nTotCum += nCumMat
*===============FIN INTENSIDAD HORARIA

	     ENDFOR
***********FIN RECORRIDO POR MATERIAS

***********NOTA DEL AREA
	     IF nTotMat > 0

		nCumAre := (nTotCum/nIntAre)*100

		cCumAre := STR(nCumAre,5,2)
		IF cCumAre == '50.00'
		   nCumAre := VAL(cCumAre)
		ENDIF
	      *ÀError en la comparaci¢n codigo:207022 Area:08

		IF nCumAre == 0
		   cNotAre := 'D'
		ELSE
		   cNotAre := cNotDefJvf(nCumAre)
		ENDIF

		IF nCumAre # 0 .AND. EMPTY(cNotAre)

		   cHayErr := 'Indice de Cumpliento de Area'+;
			      'y no tiene nota.'
		   cHayErr := SUBS(cHayErr+SPACE(80),1,80)

		   aHayErr := {}
		   AADD(aHayErr,{'cCodEst',NOT->cCodigoEst})         // C¢digo del Estudiante
		   AADD(aHayErr,{'cCodGru',GRU->cCodigoGru})         // C¢digo del Grupo
		   AADD(aHayErr,{'cNroLis',NOT->(STR(RECNO(),2))})   // Numero de lista
		   AADD(aHayErr,{'cCodMat',cCodigoTma})              // C¢digo de la materia
		   AADD(aHayErr,{'cNotDef',''})                      // Nota
		   AADD(aHayErr,{'cNotCal',cNotAre})                 // Nota Calculada
		   AADD(aHayErr,{'cHayErr',cHayErr})                 // Detalle del Error
		 *ÀHay Error

		   AADD(aTotErr,aHayErr)

		ENDIF

	     ELSE
		cNotAre := SPACE(04)
	     ENDIF
	     cNotAre := SUBS(cNotAre+SPACE(04),1,4)
***********FIN NOTA DEL AREA

***********LINEA DE ESTADO
	     LineaEstado('INDICE DE CUMPLIMIENTO:'+;
			 'ºGRUPO:'+cCodGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
				 NOT->(STR(RECCOUNT(),2))+;
			 'ºCODIGO:'+NOT->cCodigoEst+;
			 'ºMATERIA:'+cCodigoTma+;
			 'ºNOTA:'+cNotAre,'')
***********FIN LINEA DE ESTADO

       ENDFOR

       RETURN cNotAre
*>>>>FIN RECORRIDO POR AREAS