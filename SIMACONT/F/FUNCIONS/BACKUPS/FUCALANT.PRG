/*************************************************************************
* TITULO DE LA FUNCION..: CALCULOS DE LAS NOTAS POR GRUPO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 PM   MAY 27/95 MAR

OBJETIVOS:

0- Esta funci¢n la guarde como c¢digo de los calculo cuando las notas eran
   solamente numericas. Cuando se retome toca revisar todo el c¢digo.

1- Calcula las notas de las  reas, acumulados de acuerdo a los porcentajes
   especificados y determina los puestos de los estudiantes.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna retorna el promedio del grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCalNot99(lShared,cNomSis,nFilPal,nNroPer,cPorAno,aCamMat,aAreasP,;
		   nAluGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       cNomSis                              // Nombre del sistema
       nFilPal                              // Fila marco de impresi¢n
       nNroPer			      // N£mero del bimestre
       cPorAno                              // Porcentajes para a¤o
       aCamMat                              // Campos de las materias
       aAreasP                              // Campos de areas promediables
       nAluGru                              // @Alumnos del grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores
       LOCAL nNroFil := 0                   // N£mero de la fila

       LOCAL nBisAnt := 0                   // Bimestre anterior
       LOCAL nPorBim := 0                   // Porcentaje para el bimestre
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL nPorMat := 0                   // Porcentaje de la materia

       LOCAL cCamMat := ''                  // Campo de la materia
       LOCAL cCamAre := ''                  // Campo del  rea
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cNotAre := ''                  // Campo Nota del  rea


       LOCAL cCodAre := ''                  // C¢digo del  rea
       LOCAL   cNota := ''                  // Nota de materia o  rea
       LOCAL nNotAre := 0                   // Nota del  rea
       LOCAL nDefAre := 0                   // Definitiva del  rea

       LOCAL nProAre := 0                   // Promedio del  rea
       LOCAL nNotPro := 0                   // Nota promedio del  rea
       LOCAL nProBis := 0                   // Promedio del bimestre
       LOCAL nProAcu := 0                   // Promedio acumulado
       LOCAL nProGru := 0                   // Promedio del grupo

       LOCAL cCamAcA := ''                  // Campo del acumulado Area
       LOCAL nAntAre := 0                   // Acumulado anterior  rea
       LOCAL nAcuAre := 0                   // Valor acumulado area
       LOCAL nArePed := 0                   // Areas perdidas

       LOCAL cCamAcM := 0                   // Campo del acumuldo materia
       LOCAL nAntMat := 0                   // Acumulado anterior meteria
       LOCAL nAcuMat := 0                   // Valor acumulado materia
       LOCAL nAcuHab := 0                   // Acumulado Area que habilita
       LOCAL cObsFin := ''                  // Observaci¢n final

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL nAproboTno := 1                // Estado final del estudiante
       LOCAL cMatHabTno := ''               // Areas a habilitar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LAS NOTAS DE LOS ESTUDIANTE
       nAluGru := 0
       nNroFil := nMarco(nFilPal+1,'PROMEDIOS DE LOS ESTUDIANTES '+;
				   'DEL GRUPO: '+GRU->cCodigoGru)
       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('ºCALCULADO PARA EL GRUPO: '+GRU->cCodigoGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			  NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,'ALU')
	       cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			     RTRIM(ALU->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := ALU->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= ALU->nPerRetEst
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
	    nAluGru++
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********CALCULO DE LA DEFINITIVA, PROMEDIO Y ACUMULADO DEL AREA
	    nPorBim := VAL(SUBS(cPorAno,nNroPer*2-1,2))/100
	   *Porcentaje para el bimestre

	    FOR i:= 1 TO LEN(aAreasP)

*--------------CALCULO DE LA NOTA DEL AREA
		 cCodAre := SUBS(aAreasP[i][1],11,2)
		 nDefAre := 0
		 FOR j:=1 TO LEN(aCamMat)

*                    ANALISIS SI LA MATERIA VIENE COMO AREA
		       IF SUBS(aCamMat[j,2],11,2) == '00'
			  LOOP
		       ENDIF
*                    FIN ANALISIS SI LA MATERIA VIENE COMO AREA

*		    LECTURA DE LA NOTA DE LA MATERIA
		      IF SUBS(aCamMat[j,1],7,4) == 'NT'+cCodAre

			 nPorMat := VAL(SUBS(aCamMat[j,1],13,3))/100
			*Porcentaje de la materia

			 cCamMat := aCamMat[j,1]
			 cNota := SUBS(&cCamMat,nNroPer*4-3,4)
			*Lectura de la nota

			 nDefAre += VAL(cNota)*nPorMat
			*C lculo de nota del  rea

		      ENDIF
*		    FIN LECTURA DE LA NOTA DE LA MATERIA

*		    CALCULO DEL ACUMULADO DE LA MATERIA
		      IF SUBS(aCamMat[j,1],7,4) == 'NT'+cCodAre

			 SET DECIMALS TO 2
			 nAcuMat := VAL(cNota)*nPorBim
			 SET DECIMALS TO 4

			 nBisAnt := IIF(nNroPer == 1,nNroPer,nNroPer-1)

			 cCamAcM := aCamMat[j,2]
			 nAntMat := VAL(SUBS(&cCamAcM,nBisAnt*5-4,5))

			 nAcuMat := IIF(nNroPer == 1,nAcuMat,;
						     nAntMat+nAcuMat)

			 SELECT NOT
			 IF NOT->(lRegLock(lShared,.F.))
			    REPL &cCamAcM WITH;
				 STUFF(&cCamAcM,nNroPer*5-4,5,;
						STR(nAcuMat,5,2))
			    NOT->(DBCOMMIT())
			 ELSE
			    cError('NO SE PUEDE GRABAR LAS NOTAS')
			 ENDIF
			 IF lShared
			    NOT->(DBUNLOCK())
			 ENDIF
		       *ÀGrabaci¢n del acumulado de la materia

		      ENDIF
*		    FIN CALCULO DEL ACUMULADO DE LA MATERIA

		 ENDFOR
		 nDefAre := VAL(SUBS(STR(nDefAre,5,2),1,4))
		*Truncamiento de la nota
*--------------FIN CALCULO DE LA NOTA DEL AREA

*--------------CALCULO DEL ACUMULADO DEL AREA
		 SET DECIMALS TO 2
		 nAcuAre := nDefAre*nPorBim
		 SET DECIMALS TO 4

		 nBisAnt := IIF(nNroPer == 1,nNroPer,nNroPer-1)

		 cCamAcA := aAreasP[i,2]
		 nAntAre := VAL(SUBS(&cCamAcA,nBisAnt*5-4,5))

		 nAcuAre := IIF(nNroPer == 1,nAcuAre,nAntAre+nAcuAre)
*--------------FIN CALCULO DEL ACUMULADO DEL AREA

*--------------CALCULO DEL PROMEDIO DEL AREA
		 nPorAcu := 0
		 FOR k := 1 TO nNroPer
		     nPorAcu += VAL(SUBS(cPorAno,k*2-1,2))/100
		 ENDFOR
	       *ÀCalculo del promedio acumulado

		 nProAre := VAL(SUBS(STR(nAcuAre/nPorAcu,5,2),1,4))
		*Calculo de la nota promedio truncada a 2 decimales
*--------------FIN CALCULO DEL PROMEDIO DEL AREA

*--------------GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA
		 nDefAre := STR(nDefAre,4,1)
		 nAcuAre := STR(nAcuAre,5,2)
		 nProAre := STR(nProAre,4,1)
	       *ÀConversi¢n a caracteres

		 cCamAre := aAreasP[i,1]
		 cCamPro := aAreasP[i,3]
		 cNotAre := aAreasP[i,4]
	       *ÀNombre de los campos

		 SELECT NOT
		 IF NOT->(lRegLock(lShared,.F.))
		    REPL &cCamAre WITH;
			 STUFF(&cCamAre,nNroPer*4-3,4,nDefAre)

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
*--------------FIN GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA

	    ENDFOR
**********FIN CALCULO DE LA DEFINITIVA, PROMEDIO Y ACUMULADO DEL AREA

**********ACUMALACION PARA PROMEDIOS GENERALES Y APROBACION DEL A¥O
	    nProBis := 0
	    nProAcu := 0
	    nArePed := 0
	    cMatHabTno := NOT->cMatHabNot

	    FOR i:= 1 TO LEN(aAreasP)

*--------------ACUMALACION PARA PROMEDIOS
		 cCamAre := aAreasP[i,1]
		 cCamAcA := aAreasP[i,2]
		 cCamPro := aAreasP[i,3]
	       *ÀNombre de los campos

		 nNotAre := VAL(SUBS(&cCamAre,nNroPer*4-3,4))
		 nProBis += nNotAre

		 nNotPro := VAL(SUBS(&cCamPro,nNroPer*4-3,4))
		*Nota promedio del area

		 nProAcu += nNotPro
*--------------FIN ACUMALACION PARA PROMEDIOS

*--------------ANALISIS DE LAS AREAS PERDIDAS
		 nAcuAre := VAL(SUBS(&cCamAcA,nNroPer*5-4,5))
		 IF nNroPer == 4
		    IF nAcuAre < 6.0
		       nArePed++
		       IF nArePed <= 2
			  cMatHabTno := STUFF(cMatHabTno,nArePed*4-3,4,;
					      SUBS(cCamAre,11,2)+'00')
			  nAcuHab := nAcuAre
			 *Acumulado area que habilita
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DE LAS AREAS PERDIDAS

	    ENDFOR
**********FIN ACUMALACION PARA PROMEDIOS GENERALES Y APROBACION DEL A¥O

**********CALCULO DE LOS PROMEDIOS GENERALES
	    nProBis := SUBS(STR(nProBis/LEN(aAreasP),5,2),1,4)
	   *Calculo truncado a 2 decimales

	    nProAcu := SUBS(STR(nProAcu/LEN(aAreasP),5,2),1,4)
	   *Calculo truncado a 2 decimales

	    nProGru += VAL(nProBis)
	   *Suma para promedio del grupo
**********FIN CALCULO DE LOS PROMEDIOS GENERALES

**********ANALISIS PARA LA APROBACION DEL A¥O
	       cObsFin := ''
	    nAproboTno := 0
	    IF nNroPer == 4
	       DO CASE
		  CASE nArePed > 2
			  cObsFin := ' REPROBO'
		       nAproboTno := 1
		      *Reprobado

		       cMatHabTno := cSpaces("NOT","cMatHabNot")
		     *ÀBorrado de las primeras areas p‚rdidas

		  CASE nArePed == 0
		       nAproboTno := 2
		      *Aprobado

		       cMatHabTno := cSpaces("NOT","cMatHabNot")
		     *ÀBorrado de las primeras areas p‚rdidas

		  CASE nArePed == 1 .AND. nAcuHab >= VAL(TCO->cMinHabTbl) .AND.;
		       VAL(nProAcu) >= TCO->nProMinTbl

		       nAproboTno := 3
		      *Aprobado por promedio

		       cMatHabTno := cSpaces("NOT","cMatHabNot")
		     *ÀBorrado de las primeras areas p‚rdidas

		  CASE nArePed == 2
			  cObsFin := ' HABILITA'
		       nAproboTno := 4
		      *Habilita

		  CASE nArePed == 1 .AND. VAL(nProAcu) < TCO->nProMinTbl
			  cObsFin := ' HABILITA'
		       nAproboTno := 4
		      *Habilita
						    
		  CASE nArePed == 1 .AND. nAcuHab < VAL(TCO->cMinHabTbl) .AND.;
		       VAL(nProAcu) >= TCO->nProMinTbl

			  cObsFin := ' HABILITA'
		       nAproboTno := 4
		      *Habilita

		  OTHERWISE
		       nAproboTno := 0
	       ENDCASE
	    ENDIF
**********FIN ANALISIS PARA LA APROBACION DEL A¥O

**********GRABACION DE LOS PROMEDIOS GENERALES Y ESTADO FINAL
	    SELECT NOT
	    IF NOT->(lRegLock(lShared,.F.))
	       REPL NOT->cPromedNot WITH;
		    STUFF(NOT->cPromedNot,nNroPer*4-3,4,nProBis)

	       REPL NOT->cPromedNot WITH;
		    STUFF(NOT->cPromedNot,(nNroPer+4)*4-3,4,nProAcu)
	     *ÀPromedios generales

/* ojo
	       REPL NOT->nAproboNot WITH nAproboTno
	       REPL NOT->cMatHabNot WITH cMatHabTno
	     *ÀDetalles de la habilitaci¢n
*/

	       NOT->(DBCOMMIT())
	    ELSE
	       cError('NO SE PUEDE GRABAR LOS PROMEDIOS')
	    ENDIF
	    IF lShared
	       NOT->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS PROMEDIOS GENERALES Y ESTADO FINAL

**********VISUALIZACION DEL ESTUDIANTE GRABADO
	    nNroFil++
	    @ nNroFil,01 SAY cNombreTes+' ... PROMEDIO: '+nProBis+cObsFin

	    IF nNroFil == 21
	       nNroFil := nMarco(nFilPal+1,;
				 'PROMEDIOS DE LOS ESTUDIANTES '+;
				 'DEL GRUPO: '+GRU->cCodigoGru)
	    ENDIF
**********FIN VISUALIZACION DEL ESTUDIANTE GRABADO

	  SELECT NOT
	  SKIP

       ENDDO
       SET DECIMALS    TO 2                 // Cifras decimales
       CLOSE PLA
       CLOSE NOT
       RETURN nProGru/nAluGru
*>>>>CALCULO DE LAS NOTAS DE LOS ESTUDIANTE