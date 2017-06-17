/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: CALCULOS               MODULO No. 205

**************************************************************************
* NOMBRE DEL PROGRAMA..: CONTA205.PRG                                    *
* TITULO DEL PROGRAMA..: CALCULOS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 PM   MAY 27/95 MAR


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Calcula las notas de las  reas, acumulados de acuerdo a los porcentajes
   especificados y determina los puestos de los estudiantes.

2- Retorna NiL

SINTAXIS:

  Conta_205(nFilInf,aColSup[nOpcion],nFilPal,;
	    cNomEmp,cNomSis,cAnoUsr,cMaeAlu,;
	    cMaeAct,cPatSis,cPatInt,lIntUno,cNomUsr)
 *Calculos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_205(nFilInf,nColInf,nFilPal,cNomEmp,cNomSis,cAnoUsr,;
		   cMaeAlu,cMaeAct,cPatSis,cPatInt,lIntUno,cNomUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior del Men£
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cPatSis                              // Path del sistema
       cPatInt                              // Path de integraci¢n
       lIntUno                              // .T. Sistema Integrado
       cNomUsr                              // Nombre del Usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivo compartido
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // Path del sistemas
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL   i,j,k := 0                   // Contadores
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aStrNot := {}                  // Estructura de las notas
       LOCAL aCamMat := {}                  // Campos de las materias
       LOCAL aAreasP := {}                  // Campos de areas promediables

       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nBisAnt := 0                   // Bimestre anterior

       LOCAL cPorAno := ''                  // Porcentajes para a¤o
       LOCAL nPorBim := 0                   // Porcentaje para el bimestre
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL nPorMat := 0                   // Porcentaje de la materia

       LOCAL cPorMat := ''                  // Porcentaje Materia

       LOCAL cCamMat := ''                  // Campo de la materia
       LOCAL cCamAre := ''                  // Campo del  rea
       LOCAL cCamPro := ''                  // Campo del promedio


       LOCAL cCodAre := ''                  // C¢digo del  rea
       LOCAL   cNota := ''                  // Nota de materia o  rea
       LOCAL nNotAre := 0                   // Nota del  rea
       LOCAL nDefAre := 0                   // Definitiva del  rea

       LOCAL nProAre := 0                   // Promedio del  rea
       LOCAL nNotPro := 0                   // Nota promedio del  rea
       LOCAL nProBis := 0                   // Promedio del bimestre
       LOCAL nProAcu := 0                   // Promedio acumulado
       LOCAL nProGru := 0                   // Promedio del grupo
       LOCAL nAluGru := 0                   // Alumnos del grupo

       LOCAL cCamAcA := ''                  // Campo del acumulado Area
       LOCAL nAntAre := 0                   // Acumulado anterior  rea
       LOCAL nAcuAre := 0                   // Valor acumulado area
       LOCAL nArePed := 0                   // Areas perdidas

       LOCAL cCamAcM := 0                   // Campo del acumuldo materia
       LOCAL nAntMat := 0                   // Acumulado anterior meteria
       LOCAL nAcuMat := 0                   // Valor acumulado materia

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL nAproboTno := 1                // Estado final del estudiante
       LOCAL cMatHabTno := ''               // Areas a habilitar

       CLOSE ALL
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECCION DEL PATH DEL SISTEMA
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatSis := cPatSis+'\JAR'
       CASE 'PRI' $ cMaeAct
	    cPatSis := cPatSis+'\PRI'
       CASE 'BTO' $ cMaeAct
	    cPatSis := cPatSis+'\BTO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+FileEmp,'EMP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE EMP->(RECCOUNT()) == 0
	    cError('NO EXISTE DATOS GRABADOS DE LA EMPRESA')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CALCULO DE LA DEFINITIVA DE LAS AREAS
       cPorAno := EMP->cPorcenEmp
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+'PLAN'+SUBS(GRU->cCodigoGru,1,2)+;
			 cAnoSis+ExtFile,'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO TERCERO '+;
				     'CUARTO  QUINTO  SEXTO   SEPTIMO '+;
				     'OCTAVO  NOVENO  DECIMO  UNDECIMO',;
			       (VAL(SUBS(GRU->cCodigoGru,1,2))+1)*8-7,8)))

		CLOSE ALL
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     IF PLA->(RECCOUNT()) == 0
		cError('NO EXISTEN PLAN ACADEMICO PARA ESTE GRUPO')
		CLOSE PLA
		LOOP
	     ENDIF
	     SET FILTER TO SUBS(PLA->cCodigoMat,3,2) <> '00'
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DE CAMPOS DE AREAS,ACUMULADOS,PROMEDIOS Y MATERIAS
	    aStrNot := DBSTRUCT()
	    aCamMat := {}
	    aAreasP := {}
	    FOR i:=1 TO LEN(aStrNot)

	      IF SUBS(aStrNot[i][1],2,4) == 'AREP'
		 cCodigoTma := SUBS(aStrNot[i][1],6,2)
		 AADD(aAreasP,{'NOT->cAreP'+cCodigoTma+'Not',;
			       'NOT->cAcum'+cCodigoTma+'Not',;
			       'NOT->cProm'+cCodigoTma+'Not'})
	      ENDIF

	      IF SUBS(aStrNot[i][1],2,2) == 'NT'
		 cCodigoTma := SUBS(aStrNot[i][1],4,4)
		 AADD(aCamMat,{'NOT->'+aStrNot[i][1],;
			       'NOT->cAc'+cCodigoTma+'Not'})
	      ENDIF

	    ENDFOR
	    nAluGru := 0
	    nProGru := 0
**********FIN LOCALIZACION DE CAMPOS DE AREAS,ACUMULADOS,PROMEDIOS Y MATERIAS

**********CALCULO DE LAS NOTAS DE LOS ESTUDIANTE
	    nNroFil := nMarco(nFilPal+1,'PROMEDIOS DE LOS ESTUDIANTES '+;
					'DEL GRUPO: '+GRU->cCodigoGru)
	    SELECT NOT
	    GO TOP
	    DO WHILE .NOT. NOT->(EOF())

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstados('ºCALCULADO PARA EL GRUPO: '+GRU->cCodigoGru+;
			      'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			       NOT->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,'ALU')
		    cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
				  RTRIM(ALU->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF ALU->lRetiroEst
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
		 nAluGru++
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------CALCULO DE LA DEFINITIVA, PROMEDIO Y ACUMULADO
		 nPorBim := VAL(SUBS(cPorAno,nNroBis*2-1,2))/100
		*Porcentaje para el bimestre

		 FOR i:= 1 TO LEN(aAreasP)

*                   CALCULO DE LA NOTA DEL AREA
		      cCodAre := SUBS(aAreasP[i][1],11,2)
		      nDefAre := 0
		      FOR j:=1 TO LEN(aCamMat)

			*LECTURA DE LA NOTA DE LA MATERIA
			   IF SUBS(aCamMat[j,1],7,4) == 'NT'+cCodAre

			      nPorMat := VAL(SUBS(aCamMat[j,1],13,3))/100
			     *Porcentaje de la materia

			      cCamMat := aCamMat[j,1]
			      cNota := SUBS(&cCamMat,nNroBis*4-3,4)
			     *Lectura de la nota

			      nDefAre += VAL(cNota)*nPorMat
			     *C lculo de nota del  rea

			   ENDIF
			*FIN LECTURA DE LA NOTA DE LA MATERIA

			*CALCULO DEL ACUMULADO DE LA MATERIA
			   IF SUBS(aCamMat[j,1],7,4) == 'NT'+cCodAre

			      SET DECIMALS TO 2
			      nAcuMat := VAL(cNota)*nPorBim
			      SET DECIMALS TO 4

			      nBisAnt := IIF(nNroBis == 1,nNroBis,nNroBis-1)

			      cCamAcM := aCamMat[j,2]
			      nAntMat := VAL(SUBS(&cCamAcM,nBisAnt*5-4,5))

			      nAcuMat := IIF(nNroBis == 1,nAcuMat,;
							  nAntMat+nAcuMat)

			      SELECT NOT
			      IF NOT->(lRegLock(.F.))
				 REPL &cCamAcM WITH;
				      STUFF(&cCamAcM,nNroBis*5-4,5,;
						     STR(nAcuMat,5,2))
			      ELSE
				 cError('NO SE PUEDE GRABAR LAS NOTAS')
			      ENDIF
			      DBUNLOCK()
			    *ÀGrabaci¢n del acumulado de la materia

			   ENDIF
		       *FIN CALCULO DEL ACUMULADO DE LA MATERIA

		      ENDFOR
		      nDefAre := VAL(SUBS(STR(nDefAre,5,2),1,4))
		     *Truncamiento de la nota
*                   FIN CALCULO DE LA NOTA DEL AREA

*                   CALCULO DEL ACUMULADO DEL AREA Y MATERIA
		      SET DECIMALS TO 2
		      nAcuAre := nDefAre*nPorBim
		      SET DECIMALS TO 4

		      nBisAnt := IIF(nNroBis == 1,nNroBis,nNroBis-1)

		      cCamAcA := aAreasP[i,2]
		      nAntAre := VAL(SUBS(&cCamAcA,nBisAnt*5-4,5))

		      nAcuAre := IIF(nNroBis == 1,nAcuAre,nAntAre+nAcuAre)
*                   FIN CALCULO DEL ACUMULADO DEL AREA Y MATERIA

*                   CALCULO DEL PROMEDIO DEL AREA
		      nPorAcu := 0
		      FOR k := 1 TO nNroBis
			  nPorAcu += VAL(SUBS(cPorAno,k*2-1,2))/100
		      ENDFOR
		    *ÀCalculo del promedio acumulado

		      nProAre := VAL(SUBS(STR(nAcuAre/nPorAcu,5,2),1,4))
		     *Calculo de la nota promedio truncada a 2 decimales
*                   FIN CALCULO DEL PROMEDIO DEL AREA

*                   GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA
		      nDefAre := STR(nDefAre,4,1)
		      nAcuAre := STR(nAcuAre,5,2)
		      nProAre := STR(nProAre,4,1)
		    *ÀConversi¢n a caracteres

		      cCamAre := aAreasP[i,1]
		      cCamPro := aAreasP[i,3]
		    *ÀNombre de los campos

		      SELECT NOT
		      IF NOT->(lRegLock(.F.))
			 REPL &cCamAre WITH;
			      STUFF(&cCamAre,nNroBis*4-3,4,nDefAre)

			 REPL &cCamAcA WITH;
			      STUFF(&cCamAcA,nNroBis*5-4,5,nAcuAre)

			 REPL &cCamPro WITH;
			      STUFF(&cCamPro,nNroBis*4-3,4,nProAre)
		      ELSE
			 cError('NO SE PUEDE GRABAR LAS NOTAS')
		      ENDIF
		      DBUNLOCK()
*                   FIN GRABACION DEL ACUMULADO,PROMEDIO Y NOTA DEFINTIVA

		 ENDFOR
*--------------FIN CALCULO DE LA DEFINITIVA, PROMEDIO Y ACUMULADO

*--------------ACUMALACION PARA PROMEDIOS GENERALES Y APROBACION DEL A¥O
		 nProBis := 0
		 nProAcu := 0
		 nArePed := 0
		 cMatHabTno := NOT->cMatHabNot

		 FOR i:= 1 TO LEN(aAreasP)

*                   ACUMALACION PARA PROMEDIOS
		      cCamAre := aAreasP[i,1]
		      cCamAcA := aAreasP[i,2]
		      cCamPro := aAreasP[i,3]
		    *ÀNombre de los campos

		      nNotAre := VAL(SUBS(&cCamAre,nNroBis*4-3,4))
		      nProBis += nNotAre

		      nNotPro := VAL(SUBS(&cCamPro,nNroBis*4-3,4))
		     *Nota promedio del area

		      nProAcu += nNotPro
*                   FIN ACUMALACION PARA PROMEDIOS

*                   ANALISIS DE LAS AREAS PERDIDAS
		      nAcuAre := VAL(SUBS(&cCamAcA,nNroBis*5-4,5))
		      IF nNroBis == 4
			 IF nAcuAre < 6.0
			    nArePed++
			    IF nArePed <= 2
			       cMatHabTno := STUFF(cMatHabTno,nArePed*4-3,4,;
						   SUBS(cCamAre,11,2)+'00')
			    ENDIF
			 ENDIF
		      ENDIF
*                   FIN ANALISIS DE LAS AREAS PERDIDAS

		 ENDFOR
*--------------FIN ACUMALACION PARA PROMEDIOS GENERALES Y APROBACION DEL A¥O

*--------------CALCULO DE LOS PROMEDIOS GENERALES
		 nProBis := SUBS(STR(nProBis/LEN(aAreasP),5,2),1,4)
		*Calculo truncado a 2 decimales

		 nProAcu := SUBS(STR(nProAcu/LEN(aAreasP),5,2),1,4)
		*Calculo truncado a 2 decimales

		 nProGru += VAL(nProBis)
		*Suma para promedio del grupo
*--------------FIN CALCULO DE LOS PROMEDIOS GENERALES

*--------------ANALISIS PARA LA APROBACION DEL A¥O
		 nAproboTno := 0
		 IF nNroBis == 4
		    DO CASE
		       CASE nArePed > 2
			    nAproboTno := 1
			   *Reprobado

			    cMatHabTno := cSpaces("NOT","cMatHabNot")
			  *ÀBorrado de las primeras areas p‚rdidas

		       CASE nArePed == 0
			    nAproboTno := 2
			   *Aprobado

		       CASE nArePed <= 2 .AND. VAL(nProAcu) >= 7.00
			    nAproboTno := 3
			   *Aprobado por promedio

			    cMatHabTno := cSpaces("NOT","cMatHabNot")
			  *ÀBorrado de las primeras areas p‚rdidas

		       CASE nArePed <= 2 .AND. VAL(nProAcu) < 7.00
			    nAproboTno := 4
			   *Habilita

		       OTHERWISE
			    nAproboTno := 0
		    ENDCASE
		 ENDIF
*--------------FIN ANALISIS PARA LA APROBACION DEL A¥O

*--------------GRABACION DE LOS PROMEDIOS GENERALES Y ESTADO FINAL
		 SELECT NOT
		 IF NOT->(lRegLock(.F.))
		    REPL NOT->cPromedNot WITH;
			 STUFF(NOT->cPromedNot,nNroBis*4-3,4,nProBis)

		    REPL NOT->cPromedNot WITH;
			 STUFF(NOT->cPromedNot,(nNroBis+4)*4-3,4,nProAcu)
		  *ÀPromedios generales

		    REPL NOT->nAproboNot WITH nAproboTno
		    REPL NOT->cMatHabNot WITH cMatHabTno
		  *ÀDetalles de la habilitaci¢n

		 ELSE
		    cError('NO SE PUEDE GRABAR LOS PROMEDIOS')
		 ENDIF
		 DBUNLOCK()
*--------------FIN GRABACION DE LOS PROMEDIOS GENERALES Y ESTADO FINAL

*--------------VISUALIZACION DEL ESTUDIANTE GRABADO
		 nNroFil++
		 @ nNroFil,01 SAY cNombreTes+' ... PROMEDIO: '+nProBis
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,;
				      'PROMEDIOS DE LOS ESTUDIANTES '+;
				      'DEL GRUPO: '+GRU->cCodigoGru)
		 ENDIF
*--------------FIN VISUALIZACION DEL ESTUDIANTE GRABADO

	       SELECT NOT
	       SKIP

	    ENDDO
	    CLOSE PLA
	    CLOSE NOT
**********CALCULO DE LAS NOTAS DE LOS ESTUDIANTE

**********GRABACION DEL PROMEDIO DEL GRUPO
	    SELECT GRU
	    IF GRU->(lRegLock(.F.))
	       REPL GRU->cPromedGru WITH STUFF(GRU->cPromedGru,;
				    nNroBis*4-3,4,STR(nProGru/nAluGru,4,1))
	       REPL GRU->nNroAluGru WITH nAluGru
	    ELSE
	       cError('NO SE PUEDE GRABAR EL PROMEDIO DEL GRUPO')
	    ENDIF
	    DBUNLOCK()
**********FIN GRABACION DEL PROMEDIO DEL GRUPO

**********DETERMINACION DE LOS PUESTOS
	    IF !lPuestos(cPatSis,cNomUsr,GRU->cCodigoGru,;
			 nNroBis,cAnoSis,cNomSis)
	       cError('NO SE PUDO GRABAR LOS PUESTOS '+;
		      'PARA EL GRUPO '+GRU->cCodigoGru)
	    ENDIF
**********FIN DETERMINACION DE LOS PUESTOS

	  SELECT GRU
	  SKIP

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>CALCULO DE LA DEFINITIVA DE LAS AREAS
