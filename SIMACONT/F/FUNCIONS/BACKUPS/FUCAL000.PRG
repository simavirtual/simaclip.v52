/*************************************************************************
* TITULO..: CALCULOS POR GRUPOS. METODO No. 000                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 22/2008 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 AM   SEP 22/2008 LUN

OBJETIVOS:

1- Recorre todos los estudiantes del grupo para realizar los c lculos

2- RETORNA NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalNot000(aP1,aP2,aP3,nNroPer,nTotPer,;
		   aNotAre,aNotMat,lNotFin,aHayErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nNroPer			            // N£mero del Periodo
       nTotPer                              // Total Periodos
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       lNotFin                              // .T. Calcular la nota de fin de a¤o.
       aHayErr			            // @Hay Errores */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

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

*>>>>CALCULO DE LAS NOTAS DE LOS ESTUDIANTE
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
	    AreMat000(lShared,GRU->cCodigoGru,aNotAre,aNotMat,;
		      nNroPer,nTotPer,lNotFin,aHayErr)
**********FIN CALCULOS AREAS MATERIAS

	  NOT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS

/*************************************************************************
* TITULO..: CALCULOS AREAS MATERIAS. METODO No. 000                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 22/2008 LUN A
       Colombia, Bucaramanga        INICIO: 10:15 AM   SEP 22/2008 LUN

OBJETIVOS:

1- Recorre todas las areas y materias para realizar el c lculo

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AreMat000(lShared,cCodGru,aNotAre,aNotMat,nNroPer,nTotPer,;
		   lNotFin,aHayErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cCodGru                              // C¢digo del Grupo
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodos
       lNotFin                              // .T. Calcular la nota de fin de a¤o.
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
       nPorBim := VAL(SUBS(cPorcen,nNroPer*2-1,2))/100
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
		      cNotDef := cDefRecNot(cCamNotDef,nNroPer)
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

*==============CALCULO DEL ACUMULADO DE LA MATERIA
		 IF SUBS(cCamNotDef,7,4) == 'NT'+cCodAre

*:::::::::::::::::::ACUMULADO DE LA MATERIA POR PROMEDIO
		      cCamNotAcM := aCamMat[j,2]
		      IF EMPTY(cPorcen)

*........................RECORRIDO POR PERIODOS
			   nAcuMat := 0
			   nTotNot := 0
			   FOR y := 1 TO nNroPer

*                              SUMATORIA DE LA NOTA
				 cNotDef := cDefRecNot(cCamNotDef,y)
			       *ÀNota de la materia

				 IF VAL(cNotDef) # 0
				    nAcuMat += VAL(cNotDef)
				    nTotNot++
				 ENDIF
*                              FIN SUMATORIA DE LA NOTA

			   ENDFOR
			   nAcuMat := nAcuMat/nTotNot
*........................FIN RECORRIDO POR PERIODOS

		      ENDIF
*:::::::::::::::::::FIN ACUMULADO DE LA MATERIA POR PROMEDIO

*:::::::::::::::::::ACUMULADO DE LA MATERIA POR PORCENTAJE
		      IF !EMPTY(cPorcen)

			 SET DECIMALS TO 2
			 nAcuMat := VAL(cNotDef)*nPorBim
			 SET DECIMALS TO 4

			 nBisAnt := IIF(nNroPer == 1,nNroPer,nNroPer-1)

			 nAntMat := VAL(SUBS(&cCamNotAcM,nBisAnt*5-4,5))

			 nAcuMat := IIF(nNroPer == 1,nAcuMat,;
						     nAntMat+nAcuMat)

		      ENDIF
*:::::::::::::::::::FIN ACUMULADO DE LA MATERIA POR PORCENTAJE

*:::::::::::::::::::CALCULO DE LA NOTA FINAL DEL A¥O DE LA MATERIA
		      cNotFin := ''
		      IF lNotFin
			 cNotFin := STR(nAcuMat,4,1)
		      ENDIF
*:::::::::::::::::::FIN CALCULO DE LA NOTA FINAL DEL A¥O DE LA MATERIA

*:::::::::::::::::::GRABACION DEL ACUMULADO DE LA MATERIA
		      SELECT NOT
		      IF NOT->(lRegLock(lShared,.F.))

			 REPL &cCamNotAcM WITH;
			      STUFF(&cCamNotAcM,nNroPer*5-4,5,;
					     STR(nAcuMat,5,2))

			 IF VAL(cNotFin) # 0
			    REPL &cCamNotDef WITH;
				 STUFF(&cCamNotDef,nTotPer*4-3,4,cNotFin)
			 ENDIF

			 NOT->(DBCOMMIT())
		      ELSE
			 cError('NO SE PUEDE GRABAR LAS NOTAS')
		      ENDIF
		      IF lShared
			 NOT->(DBUNLOCK())
		      ENDIF
*:::::::::::::::::::FIN GRABACION DEL ACUMULADO DE LA MATERIA

		 ENDIF
*==============FIN CALCULO DEL ACUMULADO DE LA MATERIA

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS

**********NOTA DEL AREA POR PROMEDIO
	    IF !lPorcen
	       nDefAre := nDefAre/nTotMat
	    ENDIF

	    nDefAre := VAL(SUBS(STR(nDefAre,5,2),1,4))
	   *Truncamiento de la nota
**********FIN NOTA DEL AREA POR PROMEDIO

**********CALCULO DEL PROMEDIO Y ACUMULADO DEL AREA
	    cCamAre := aAreasP[i,1]
	    cCamAcA := aAreasP[i,2]

	    nAcuAre := 0
	    nProAre := 0

	    PromedArea(cPorcen,nNroPer,;
		       cCamAre,cCamAcA,;
		       nDefAre,@nAcuAre,@nProAre)


	    nDefAre := STR(nDefAre,4,1)
	    nAcuAre := STR(nAcuAre,5,2)
	    nProAre := STR(nProAre,4,1)
	  *ÀConversi¢n a caracteres
**********FIN CALCULO DEL PROMEDIO Y ACUMULADO DEL AREA

**********CALCULO DE LA NOTA FINAL DEL A¥O AREA PROMEDIABLE
	    cNotFin := ''
	    IF lNotFin
	       cNotFin := nProAre
	    ENDIF
**********FIN CALCULO DE LA NOTA FINAL DEL A¥O AREA PROMEDIABLE

**********GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA
	    cCamAre := aAreasP[i,1]
	    cCamPro := aAreasP[i,3]
	    cNotAre := aAreasP[i,4]
	  *ÀNombre de los campos

	    SELECT NOT
	    IF NOT->(lRegLock(lShared,.F.))
	       REPL &cCamAre WITH;
		    STUFF(&cCamAre,nNroPer*4-3,4,nDefAre)

	       IF VAL(cNotFin) # 0
		  REPL &cCamAre WITH;
		       STUFF(&cCamAre,nTotPer*4-3,4,cNotFin)

		  REPL &cNotAre WITH;
		       STUFF(&cNotAre,nTotPer*4-3,4,cNotFin)

	       ENDIF

	       REPL &cCamAcA WITH;
		    STUFF(&cCamAcA,nNroPer*5-4,5,nAcuAre)

	       REPL &cCamPro WITH;
		    STUFF(&cCamPro,nNroPer*4-3,4,nProAre)

	       REPL &cNotAre WITH;
		    STUFF(&cNotAre,nNroPer*4-3,4,nDefAre)

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
*>>>>FIN RECORRIDO POR AREAS PROMEDIABLES

*>>>>ACUMALACION PARA PROMEDIOS GENERALES Y APROBACION DEL A¥O
       nProBis := 0
       nProAcu := 0
       nArePed := 0

       FOR i:= 1 TO LEN(aAreasP)

**********ACUMALACION PARA PROMEDIOS
	    cCamAre := aAreasP[i,1]
	    cCamAcA := aAreasP[i,2]
	    cCamPro := aAreasP[i,3]
	  *ÀNombre de los campos

	    nNotAre := VAL(SUBS(&cCamAre,nNroPer*4-3,4))
	    nProBis += nNotAre

	    nNotPro := VAL(SUBS(&cCamPro,nNroPer*4-3,4))
	   *Nota promedio del area

	    nProAcu += nNotPro
**********FIN ACUMALACION PARA PROMEDIOS

       ENDFOR
*>>>>ACUMALACION PARA PROMEDIOS GENERALES Y APROBACION DEL A¥O

*>>>>CALCULO DE LOS PROMEDIOS GENERALES
       nProBis := SUBS(STR(nProBis/LEN(aAreasP),5,2),1,4)
      *Calculo truncado a 2 decimales

       nProAcu := SUBS(STR(nProAcu/LEN(aAreasP),5,2),1,4)
      *Calculo truncado a 2 decimales

       nProGru += VAL(nProBis)
      *Suma para promedio del grupo
*>>>>FIN CALCULO DE LOS PROMEDIOS GENERALES

*>>>>GRABACION DE LOS PROMEDIOS GENERALES Y ESTADO FINAL
       SELECT NOT
       IF NOT->(lRegLock(lShared,.F.))
	  REPL NOT->cPromedNot WITH;
	       STUFF(NOT->cPromedNot,nNroPer*4-3,4,nProBis)

	  REPL NOT->cPromedNot WITH;
	       STUFF(NOT->cPromedNot,(nNroPer+4)*4-3,4,nProAcu)
	*ÀPromedios generales

	  NOT->(DBCOMMIT())
       ELSE
	  cError('NO SE PUEDE GRABAR LOS PROMEDIOS')
       ENDIF
       IF lShared
	  NOT->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DE LOS PROMEDIOS GENERALES Y ESTADO FINAL

*>>>>NOTA FINAL DEL A¥O DE LAS AREAS NO PROMEDIABLES
       IF lNotFin

	  FOR i:= 1 TO LEN(aAreasN)

*************CALCULO DEL PROMEDIO Y ACUMULADO DEL AREA
	       cCamAre := aAreasN[i,1]
	       cCamAcA := ''

	       nAcuAre := 0
	       nProAre := 0
	       nDefAre := 0

	       PromedArea(cPorcen,nNroPer,;
			  cCamAre,cCamAcA,;
			  nDefAre,@nAcuAre,@nProAre)

	       nProAre := STR(nProAre,4,1)
	     *ÀConversi¢n a caracteres

	       cNotFin := nProAre
*************FIN CALCULO DEL PROMEDIO Y ACUMULADO DEL AREA

*************GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA
	       SELECT NOT
	       IF NOT->(lRegLock(lShared,.F.))

		  IF VAL(cNotFin) # 0
		     REPL &cCamAre WITH;
			  STUFF(&cCamAre,TCO->nTotPerTbl*4-3,4,cNotFin)
		  ENDIF
		  NOT->(DBCOMMIT())

	       ELSE
		  cError('NO SE PUEDE GRABAR LAS NOTAS')
	       ENDIF

	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF
*************FIN GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA

	  ENDFOR

       ENDIF
       RETURN NIL
*>>>>FIN NOTA FINAL DEL A¥O DE LAS AREAS NO PROMEDIABLES

/*************************************************************************
* TITULO..: LECTURA DE LA DEFINITVA DEL CAMPO DE NOTAS                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 08/2006 MIE A
       Colombia, Bucaramanga        INICIO: 11:45 PM   NOV 08/2006 MIE

OBJETIVOS:

1- Lee la nota definitiva del area o asignatura del archivo de notas.

2- Lee la nota de recuperaci¢n del area o asignutara del archivo de notas

3- Reemplaza la nota definitiva por la nota de recuperaci¢n si existe.

4- El campo de la nota debe pasarse con el alias del archivo

5- Retorna la nota definitiva

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDefRecNot(cCampo,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCampo                               // Campo de la nota
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNotDef := ''                  // Nota definitiva

       LOCAL cCamRec := ''                  // Campo de la Recuperaci¢n
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA NOTA
       cNotDef := SUBS(&cCampo,nNroPer*4-3,4)
     *ÀNota definitiva

       cCamRec := SUBS(cCampo,1,12)+'Rec'
       cNotRec := SUBS(&cCamRec,nNroPer*4-3,4)

       IF VAL(cNotRec) # 0
	  cNotDef := cNotRec
       ENDIF
       RETURN cNotDef
*>>>>FIN LECTURA DE LA NOTA

/*************************************************************************
* TITULO..: PROMEDIO DEL AREA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 08/2006 MIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   NOV 08/2006 MIE

OBJETIVOS:

1- Calcula el promedio y acumulado del  rea utilizando el m‚todo de
   porcentajes o promedio.

2- Retorna el promedio del  rea.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PromedArea(cPorcen,nNroPer,cCamAre,cCamAcA,nDefAre,nAcuAre,nProAre)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPorcen			            // Porcentajes de los periodos
       nNroPer                              // N£mero del periodo
       cCamAre                              // Campo del area
       cCamAcA                              // Campo del acumulado
       nDefAre                              // Definitiva del Area
       nAcuAre                              // @Acumulado del Area
       nProAre                              // @Promedio del Area */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL nPerAnt := 0                   // Periodo anterior
       LOCAL nAntAre := 0                   // Acumulado anterior  rea

       LOCAL nPorBim := 0                   // Porcentaje del bimestre
       LOCAL cNotDef := ''                  // Nota definitiva
       LOCAL nPorAcu := 0                   // Porcentaje acumulado

       LOCAL nTotNot := 0                   // Total de Notas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL ACUMULADO DEL AREA POR PORCENTAJES
       IF !EMPTY(cPorcen)

	  nPorBim := VAL(SUBS(cPorcen,nNroPer*2-1,2))/100
	 *Porcentaje para el bimestre

	  SET DECIMALS TO 2
	  nAcuAre := nDefAre*nPorBim
	  SET DECIMALS TO 4

	  nPerAnt := IIF(nNroPer == 1,nNroPer,nNroPer-1)

	  nAntAre := VAL(SUBS(&cCamAcA,nPerAnt*5-4,5))

	  nAcuAre := IIF(nNroPer == 1,nAcuAre,nAntAre+nAcuAre)

       ENDIF
*>>>>FIN CALCULO DEL ACUMULADO DEL AREA POR PORCENTAJES

*>>>>CALCULO DEL PROMEDIO DEL AREA POR PORCENTAJES
       IF !EMPTY(cPorcen)

	  nPorAcu := 0
	  FOR i := 1 TO nNroPer
	      nPorAcu += VAL(SUBS(cPorcen,i*2-1,2))/100
	  ENDFOR
	*ÀCalculo del promedio acumulado

	  nProAre := VAL(SUBS(STR(nAcuAre/nPorAcu,5,2),1,4))
	 *Calculo de la nota promedio truncada a 2 decimales

       ENDIF
*>>>>FIN CALCULO DEL PROMEDIO DEL AREA POR PORCENTAJES

*>>>>CALCULO DEL PROMEDIO DEL AREA POR PROMEDIO
       IF EMPTY(cPorcen)

**********RECORRIDO POR PERIODOS
	    nTotNot := 0
	    FOR i := 1 TO nNroPer

*===============NOTA DEL AREA
		  IF i == nNroPer .AND. nDefAre # 0
		     cNotDef := STR(nDefAre,5,2)
		  ELSE
		     cNotDef := cDefRecNot(cCamAre,i)
		  ENDIF
*===============FIN NOTA DEL AREA

*===============SUMATORIA DE LA NOTA
		  IF VAL(cNotDef) # 0
		     nProAre += VAL(cNotDef)
		     nTotNot++
		  ENDIF
*===============FIN SUMATORIA DE LA NOTA

	    ENDFOR
	    nProAre := nProAre/nTotNot
	    nAcuAre := nProAre
**********FIN RECORRIDO POR PERIODOS

       ENDIF
       RETURN NIL
*>>>>FIN CALCULO DEL PROMEDIO DEL AREA POR PROMEDIO


