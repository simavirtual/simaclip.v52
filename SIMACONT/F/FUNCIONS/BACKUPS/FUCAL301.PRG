/*************************************************************************
* TITULO..: INDICADORES PROMOCIONALES POR GRUPO. METODO No. 301          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 16/2008 MAR A
       Colombia, Bucaramanga        INICIO: 09:00 AM   SEP 16/2008 MAR

OBJETIVOS:

1- Recorre todos los estudiantes del grupo para realizar los c lculos

2- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalNot301(aP1,aP2,aP3,nNroPer,nTotPer,aNotAre,aNotMat,aHayErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nNroPer			            // N£mero del Periodo
       nTotPer                              // Total Periodos
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aHayErr			            // @Hay Errores */
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

**********LINEA DE ESTADO
	    LineaEstado('GRUPO:'+GRU->cCodigoGru+;
			'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
				NOT->(STR(RECCOUNT(),2))+;
			'ºCODIGO:'+NOT->cCodigoEst+;
			'ºMATERIA:'+SPACE(04)+;
			'ºNOTA:'+SPACE(04),'')
**********FIN LINEA DE ESTADO

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
	    AreMat301(lShared,GRU->cCodigoGru,aNotAre,aNotMat,;
		      nNroPer,nTotPer,aHayErr)
**********FIN CALCULOS AREAS MATERIAS

	  NOT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS

/*************************************************************************
* TITULO..: CALCULOS AREAS MATERIAS. METODO No. 301                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 17/2008 MAR A
       Colombia, Bucaramanga        INICIO: 03:35 AM   SEP 17/2008 MAR

OBJETIVOS:

1- Recorre todas las areas y materias para realizar el c lculo.

2- Calcula la nota del Area promediable de acuerdo a las asignaturas que
   lo conforman.

3- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AreMat301(lShared,cCodGru,aNotAre,aNotMat,nNroPer,nTotPer,aHayErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cCodGru                              // C¢digo del Grupo
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodos
       aHayErr                              // Hay Errores */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,y := 0                   // Contadores

       LOCAL aStrNot := {}                  // Estructura de las notas
       LOCAL aCamMat := {}                  // Campos de las materias
       LOCAL aAreasP := {}                  // Campos de areas promediables
       LOCAL aAreasN := {}                  // Campos de areas NO promediables

       LOCAL nBisAnt := 0                   // Bimestre anterior
       LOCAL cPorcen := ''		    // Porcentajes para a¤o
       LOCAL lPorcen := .F.                 // .T. Calculos por porcentaje de area para el periodo
       LOCAL nPorBim := 0                   // Porcentaje para el bimestre

       LOCAL cCodAre := ''                  // C¢digo del  rea
       LOCAL nNotAre := 0                   // Nota del  rea
       LOCAL nDefAre := 0                   // Definitiva del  rea
       LOCAL nTotMat := 0                   // N£mero de materias

       LOCAL nPorMat := 0                   // Porcentaje de la materia
       LOCAL cNotDef := ''                  // Nota de materia o  rea
       LOCAL nAcuMat := 0                   // Valor acumulado materia
       LOCAL nTotNot := 0                   // N£mero de notas

       LOCAL cNotFin := ''                  // Nota final del a¤o

       LOCAL nAntMat := 0                   // Acumulado anterior meteria

       LOCAL cNotAre := ''                  // Campo Nota del  rea
       LOCAL nAcuAre := 0                   // Valor acumulado area
       LOCAL nProAre := 0                   // Promedio del  rea
       LOCAL nArePed := 0                   // Areas perdidas
       LOCAL nNotPro := 0                   // Nota promedio del  rea
       LOCAL nProGru := 0                   // Promedio del grupo

       LOCAL cCamAre := ''                  // Campo del  rea
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamAcA := ''                  // Campo del acumulado Area

       LOCAL nProBis := 0                   // Promedio del bimestre
       LOCAL nProAcu := 0                   // Promedio acumulado

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotAcM := 0                // Campo del acumuldo materia

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DE CAMPOS DE AREAS,ACUMULADOS,PROMEDIOS Y MATERIAS
       SELECT NOT
       aStrNot := DBSTRUCT()
       aCamMat := {}
       aAreasP := {}
       FOR i := 1 TO LEN(aStrNot)

	 IF SUBS(aStrNot[i][1],2,4) == 'AREP' .AND.;
	    SUBS(aStrNot[i][1],8,3) == 'NOT'

	    cCodigoTma := SUBS(aStrNot[i][1],6,2)
	    AADD(aAreasP,{'NOT->cAreP'+cCodigoTma+'Not',;
			  'NOT->cAcum'+cCodigoTma+'Not',;
			  'NOT->cProm'+cCodigoTma+'Not',;
			  'NOT->cNt'+cCodigoTma+'00'+'100'})

	 ENDIF

	 IF SUBS(aStrNot[i][1],2,4) == 'AREN' .AND.;
	    SUBS(aStrNot[i][1],8,3) # 'REC'

	    cCodigoTma := SUBS(aStrNot[i][1],6,2)
	    AADD(aAreasN,{'NOT->cAreN'+cCodigoTma+'Not'})

	 ENDIF

	 IF SUBS(aStrNot[i][1],2,2) == 'NT' .AND.;
	    SUBS(aStrNot[i][1],6,2)  # '00' .AND.;
	    SUBS(aStrNot[i][1],8,3)  # 'REC'

	    cCodigoTma := SUBS(aStrNot[i][1],4,4)
	    AADD(aCamMat,{'NOT->'+aStrNot[i][1],;
			  'NOT->cAc'+cCodigoTma+'Not'})
	 ENDIF

       ENDFOR
*>>>>LOCALIZACION DE CAMPOS DE AREAS,ACUMULADOS,PROMEDIOS Y MATERIAS

*>>>>RECORRIDO POR AREAS PROMEDIABLES
       cPorcen := TCO->cPorcenTbl
       nPorBim := VAL(SUBS(cPorcen,nTotPer*2-1,2))/100
      *Porcentaje para el bimestre

       FOR i := 1 TO LEN(aAreasP)

**********CALCULO DE LA NOTA DEL AREA
	    cCodAre := SUBS(aAreasP[i][1],11,2)
	    nDefAre := 0
	    nTotMat := 0
	    lPorcen := .T.
**********FIN CALCULO DE LA NOTA DEL AREA

**********RECORRIDO POR MATERIAS
	    FOR j := 1 TO LEN(aCamMat)

		cCamNotDef := aCamMat[j,1]

*==============ANALISIS SI LA MATERIA VIENE COMO AREA
		 cCodigoTma := SUBS(aCamMat[j,2],9,4)
		 IF SUBS(cCodigoTma,3,2) == '00'
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI LA MATERIA VIENE COMO AREA

*==============LECTURA DE LA NOTA DE LA MATERIA
		 IF SUBS(aCamMat[j,1],7,4) == 'NT'+cCodAre

*-------------------ANALISIS DEL METODO PARA EL AREA
		      nPorMat := VAL(SUBS(cCamNotDef,13,3))/100
		     *Porcentaje de la materia

		      IF nPorMat == 1
			 lPorcen := .F.
		      ENDIF
		    *ÀPor promedio.
*-------------------FIN ANALISIS DEL METODO PARA EL AREA

*-------------------NOTA DE LA MATERIA
		      cNotDef := cDefRecNot(cCamNotDef,nTotPer)
		    *ÀNota de la materia

		      IF lPorcen

			 nDefAre += VAL(cNotDef)*nPorMat
			*Nota del area por porcentaje

		      ELSE

			 IF VAL(cNotDef) # 0
			    nDefAre += VAL(cNotDef)
			    nTotMat++
			 ENDIF
		       *ÀSumatoria de la nota para el promedio

		      ENDIF
*-------------------FIN NOTA DE LA MATERIA

		 ENDIF
*==============FIN LECTURA DE LA NOTA DE LA MATERIA

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS

**********NOTA DEL AREA POR PROMEDIO
	    IF !lPorcen
	       nDefAre := nDefAre/nTotMat
	    ENDIF

	    nDefAre := STR(nDefAre,4,1)
	   *Truncamiento de la nota
**********FIN NOTA DEL AREA POR PROMEDIO

**********GRABACION DE LA NOTA DEFINTIVA
	    cNotAre := aAreasP[i,4]
	  *ÀNombre de los campos

	    SELECT NOT
	    IF NOT->(lRegLock(lShared,.F.))

	       IF VAL(nDefAre) # 0
		  REPL &cNotAre WITH;
		       STUFF(&cNotAre,nTotPer*4-3,4,nDefAre)
	       ENDIF
	       NOT->(DBCOMMIT())

	    ELSE
	       cError('NO SE PUEDE GRABAR LAS NOTAS')
	    ENDIF
	    IF lShared
	       NOT->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA

***********LINEA DE ESTADO
	     LineaEstado('GRUPO:'+cCodGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
				 NOT->(STR(RECCOUNT(),2))+;
			 'ºCODIGO:'+NOT->cCodigoEst+;
			 'ºAREA:'+cCodAre+'00'+;
			 'ºNOTA:'+nDefAre,'')
***********FIN LINEA DE ESTADO

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS PROMEDIABLES

/*************************************************************************
* TITULO..: NOTA DE LOS INDICADORES PROMOCIONALES. METODO No. 301        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 16/2008 MAR A
       Colombia, Bucaramanga        INICIO: 03:35 AM   SEP 16/2008 MAR

OBJETIVOS:

1- Calcula los Indicadores promocionales.

2- Calcula la nota de los indicadores promocionales

3- Retorna los indicadores promocionales


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNotSin301(cCodGru,cCodMat,nTotPer,;
		    cIndica1,cIndica2,cIndica3,cIndica4,cIndica5,;
		    cNotInd1,cNotInd2,cNotInd3,cNotInd4,cNotInd5)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodAre                               // C¢digo del Area
       cCodMat                               // C¢digo de la Materia
       nTotPer                               // Total Periodos
       cIndica1                              // Indicadores Per¡odo No.1
       cIndica2                              // Indicadores Per¡odo No.2
       cIndica3                              // Indicadores Per¡odo No.3
       cIndica4                              // Indicadores Per¡odo No.4
       cIndica5                              // @Indicadores Per¡odo No.5
       cNotInd1                              // Notas Indicadores Per¡odo No.1
       cNotInd2                              // Notas Indicadores Per¡odo No.2
       cNotInd3                              // Notas Indicadores Per¡odo No.3
       cNotInd4                              // Notas Indicadores Per¡odo No.4
       cNotInd5                              // @Notas Indicadores Per¡odo No.5 */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,y := 0                   // Contadores
       LOCAL aSinMat := {}                  // Sub Indicadores de la materia
       LOCAL cCodInd := ''                  // C¢digo del Indicador Promocional
       LOCAL aSubInd := {}                  // Sub Indicadores
       LOCAL cSubInd := ''                  // C¢digo del Sub Indicador

       LOCAL cCodLog := ''                  // C¢digo del Indicador

       LOCAL cNotInd := ''                  // Nota del Indicador

       LOCAL nTotSub := 0                   // Total Notas del SubIndicador
       LOCAL nNroSub := 0                   // N£mero de SubIndicadores

       LOCAL nTotNot := 0                   // Total Notas Promocionales
       LOCAL nNroNot := 0                   // N£mero de Notas Promocionales

       LOCAL cNotLog := ''                  // Nota del Indicador Promocional
       LOCAL cNotSub := ''                  // Nota del SubIndicador

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n

       LOCAL cCodEva := ''                  // Nota del Indicador
       LOCAL cRecEva := ''                  // Nota de la Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INDICADORES PROMOCIONALES
       aSinMat := aSinIndGru(cCodGru,cCodMat)
       FOR i := 1 TO LEN(aSinMat)

***********SUBINDICADORES
	     cCodInd := aSinMat[i,1]
	     aSubInd := aSinMat[i,2]

	     nTotSub := 0
	     nNroSub := 0

	     FOR j := 1 TO LEN(aSubInd)

*================RECORRIDO POR PERIODOS
		   cSubInd := aSubInd[j]

		   FOR k := 1 TO nTotPer-1

*----------------------SUBINDICADOR APLICADO

			 cNotInd := ''
			 DO CASE
			 CASE k == 1  // Primer Periodo

*:::::::::::::::::::::::::::::BUSQUEDA DEL SUBINDICADOR
				FOR y := 1 TO 20

				    cCodLog := SUBS(cIndica1,y*6-5,6)

				    IF SUBS(cCodLog,1,4) == cSubInd
				       cNotInd := SUBS(cNotInd1,y*8-7,8)
				       EXIT
				    ENDIF

				ENDFOR

				IF SUBS(cCodLog,1,4) == cSubInd
				   EXIT
				ENDIF
*:::::::::::::::::::::::::::::FIN BUSQUEDA DEL SUBINDICADOR

			 CASE k == 2  // Segundo Periodo

*:::::::::::::::::::::::::::::BUSQUEDA DEL SUBINDICADOR
				FOR y := 1 TO 20

				    cCodLog := SUBS(cIndica2,y*6-5,6)

				    IF SUBS(cCodLog,1,4) == cSubInd
				       cNotInd := SUBS(cNotInd2,y*8-7,8)
				       EXIT
				    ENDIF

				ENDFOR

				IF SUBS(cCodLog,1,4) == cSubInd
				   EXIT
				ENDIF
*:::::::::::::::::::::::::::::FIN BUSQUEDA DEL SUBINDICADOR

			 CASE k == 3  // Tercer Periodo

*:::::::::::::::::::::::::::::BUSQUEDA DEL SUBINDICADOR
				FOR y := 1 TO 20

				    cCodLog := SUBS(cIndica3,y*6-5,6)

				    IF SUBS(cCodLog,1,4) == cSubInd
				       cNotInd := SUBS(cNotInd3,y*8-7,8)
				       EXIT
				    ENDIF

				ENDFOR

				IF SUBS(cCodLog,1,4) == cSubInd
				   EXIT
				ENDIF
*:::::::::::::::::::::::::::::FIN BUSQUEDA DEL SUBINDICADOR

			 CASE k == 4  // Cuarto Periodo

*:::::::::::::::::::::::::::::BUSQUEDA DEL SUBINDICADOR
				FOR y := 1 TO 20

				    cCodLog := SUBS(cIndica4,y*6-5,6)

				    IF SUBS(cCodLog,1,4) == cSubInd
				       cNotInd := SUBS(cNotInd4,y*8-7,8)
				       EXIT
				    ENDIF

				ENDFOR

				IF SUBS(cCodLog,1,4) == cSubInd
				   EXIT
				ENDIF
*:::::::::::::::::::::::::::::FIN BUSQUEDA DEL SUBINDICADOR

			 ENDCASE
*----------------------FIN SUBINDICADOR APLICADO

		   ENDFOR
*================FIN RECORRIDO POR PERIODOS

*================NOTA DEL SUBINDICADOR
		   cNotSub := SUBS(cNotInd,1,4)
		   cNotRec := SUBS(cNotInd,5,8)

		   IF !EMPTY(cNotRec)
		      cNotSub := cNotRec
		   ENDIF

		   IF VAL(cNotSub) > 0
		      nTotSub += VAL(cNotSub)
		      nNroSub++
		   ENDIF
*================NOTA DEL SUBINDICADOR

	     ENDFOR
***********SUBINDICADORES

***********NOTA DEFINITIVA INDICADOR PROMOCIONAL
	     cNotLog := SPACE(04)
	     IF nTotSub > 0
		cNotLog := nTotSub/nNroSub
		IF cNotLog == 10
		   cNotLog := '10.0'
		ELSE
		   cNotLog := SUBS(STR(cNotLog,4,1),1,4)
		ENDIF

		cCodEva := cNotDefJvf(VAL(cNotLog))
		cRecEva := SPACE(01)

		cIndica5 := STUFF(cIndica5,i*6-5,6,cCodInd+cCodEva+cRecEva)
		cNotInd5 := STUFF(cNotInd5,i*8-7,8,cNotLog+SPACE(04))

		nTotNot += VAL(cNotLog)
		nNroNot++
	     ENDIF
***********FIN NOTA DEFINITIVA INDICADOR PROMOCIONAL

       ENDFOR
*>>>>FIN INDICADORES PROMOCIONALES

*>>>>NOTA DEFINITIVA
       cNotDef := SPACE(04)
       IF nTotNot > 0
	  cNotDef := STR(nTotNot/nNroNot,4,1)
	  IF VAL(cNotDef) == 10
	     cNotDef := '10.0'
	  ENDIF
       ENDIF
       RETURN cNotDef
*>>>>FIN NOTA DEFINITIVA

