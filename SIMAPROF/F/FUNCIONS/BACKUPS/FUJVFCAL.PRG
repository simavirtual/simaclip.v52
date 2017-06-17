/*************************************************************************
* TITULO..: CALCULO DEL JVF POR FORMULA. CODIGO: 101                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/2003 ???
       Colombia, Bucaramanga        INICIO: 09:00 AM   MAR 14/2003 ???

OBJETIVOS:

1- Permite calcular el juicio valorativo final por formula, dise¤ado para
   el colegio la salle.

2- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIndicJv01(cIndic1,cIndic2,cIndic3,cIndic4,cIndic5,nNroPer,nTotPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cIndic1                              // Indicadores Periodo 1
       cIndic1                              // Indicadores Periodo 2
       cIndic1                              // Indicadores Periodo 3
       cIndic1                              // Indicadores Periodo 4
       cIndic1                              // Indicadores Periodo 5
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total de Periodos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroLog := 0                   // N£mero de Logros
       LOCAL nNoLogr := 0                   // N£mero de No Logros
       LOCAL nNoLogA := 0                   // N£mero de No Logros Anteriores
       LOCAL cIndica := ''                  // Indicadores del Periodo
       LOCAL     d,p := ''                  // Porcentaje de logro
       LOCAL cJuiVal := ''                  // Juicio Valorativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE INDICADORES
       FOR i := 1 TO nNroPer
	   IF i == nNroPer

	      DO CASE
	      CASE i == 1
		   NoSiLog(cIndic1,@nNoLogr,@nNroLog)

	      CASE i == 2
		   NoSiLog(cIndic2,@nNoLogr,@nNroLog)

	      CASE i == 3
		   NoSiLog(cIndic3,@nNoLogr,@nNroLog)

	      CASE i == 4
		   NoSiLog(cIndic4,@nNoLogr,@nNroLog)

	      CASE i == 5
		   NoSiLog(cIndic5,@nNoLogr,@nNroLog)
	      ENDCASE

	   ELSE

	      DO CASE
	      CASE i == 1
		   NoSiLog(cIndic1,@nNoLogA)

	      CASE i == 2
		   NoSiLog(cIndic2,@nNoLogA)

	      CASE i == 3
		   NoSiLog(cIndic3,@nNoLogA)

	      CASE i == 4
		   NoSiLog(cIndic4,@nNoLogA)

	      CASE i == 5
		   NoSiLog(cIndic5,@nNoLogA)
	      ENDCASE
	   ENDIF

       ENDFOR
*>>>>FIN CALCULO DE INDICADORES

*>>>>CALCULO DEL JUICIO VALORATIVO
       d := nNoLogr + nNoLogA
       p := d/(d+nNroLog)*100
       p := 100 - p

       DO CASE
       CASE p == 100 .and. (d+nNroLog) # 0
	    cJuiVal := 'E'

       CASE p == 0 .AND. (d+nNroLog) == 0
	    cJuiVal := SPACE(01)

       CASE p >= 0 .AND. p < 50
	    cJuiVal := 'D'

       CASE p >= 50 .AND. p < 66.6
	    cJuiVal := 'I'

       CASE p >= 66.6 .AND. p < 83.3
	    cJuiVal := 'A'

       CASE p >= 83.3 .AND. p < 99.9
	    cJuiVal := 'S'

       OTHERWISE
	    cJuiVal := SPACE(01)
       ENDCASE
       RETURN cJuiVal
*>>>>FIN CALCULO DEL JUICIO VALORATIVO


FUNCTION NoSiLog(cLogros,nNoLogr,nNroLog)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros			      // Indicadores del periodo
       nNoLogr                        // @ N£mero de No Logros
       nNroLog                        // @ N£mero de Logros */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cIndica := ''                  // Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL JUICIO VALORATIVO
       nNroLog := IF(EMPTY(nNroLog),0,nNroLog)
       nNoLogr := IF(EMPTY(nNoLogr),0,nNoLogr)

       FOR i := 1 TO 20
	   cIndica := SUBS(cLogros,i*6-5,6)
	   cCodCla := SUBS(cIndica,1,1)
	   cNotRec := ALLTRIM(SUBS(cIndica,6,1))

	   DO CASE
	   CASE cCodCla == '1'
		nNroLog++
	   CASE cCodCla == '2' .AND. (EMPTY(cNotRec) .OR. cNotRec == 'N')
		nNoLogr++
	   ENDCASE
       ENDFOR
       RETURN NIL
*>>>>FIN CALCULO DEL JUICIO VALORATIVO

/*************************************************************************
* TITULO..: CALCULO DEL JVF POR INDICE DE CUMPLIMIENTO. CODIGO: 102      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 27/2008 MIE
       Colombia, Bucaramanga        INICIO: 08:00 AM   FEB 27/2008 MIE

OBJETIVOS:

1- Permite calcular el jvf por indice de cumplimiento.

2- La fuente de los intervalos se encuentra en la agenda 2008 p gs 21,22

3- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJvfCal102(cIndic1,cIndic2,cIndic3,cIndic4,cIndic5,;
		    nNroPer,nTotPer,nIndice,cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cIndic1                              // Indicadores Periodo 1
       cIndic1                              // Indicadores Periodo 2
       cIndic1                              // Indicadores Periodo 3
       cIndic1                              // Indicadores Periodo 4
       cIndic1                              // Indicadores Periodo 5
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodo
       nIndice                              // @Indice de Cumplimiento
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nSiLogr := 0                   // N£mero de Logros
       LOCAL nNoLogr := 0                   // N£mero de No Logros
       LOCAL nTotInd := 0                   // Total de Indicadores
       LOCAL cJuiVal := ''                  // Juicio Valorativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE INDICADORES SI/NO APROBADOS
       FOR i := 1 TO nNroPer

	   DO CASE
	   CASE i == 1
		NoSiLog102(cIndic1,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer)

	   CASE i == 2
		NoSiLog102(cIndic2,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer)

	   CASE i == 3
		NoSiLog102(cIndic3,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer)

	   CASE i == 4
		NoSiLog102(cIndic4,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer)

	   CASE i == 5
		NoSiLog102(cIndic5,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer)
	   ENDCASE

       ENDFOR
*>>>>FIN CALCULO DE INDICADORES SI/NO APROBADOS

*>>>>CALCULO DEL INDICE DE CUMPLIMIENTO
       nIndice := 0
       nTotInd := nSiLogr+nNoLogr
       IF nTotInd == 0
	  nIndice := 0
       ELSE
	  nIndice := (nSiLogr/nTotInd)*100
       ENDIF

       cJuiVal := cNotDef102(nNroPer,nIndice)

       RETURN cJuiVal
*>>>>FIN CALCULO DEL INDICE DE CUMPLIMIENTO

/*************************************************************************
* TITULO..: CALCULO LA NOTA DEFINITIVA DEL METODO CODIGO: 102            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 27/2008 MIE
       Colombia, Bucaramanga        INICIO: 08:00 AM   FEB 27/2008 MIE

OBJETIVOS:

1- Calcula la nota definitiva de acuerdo al intervalo.

2- La fuente de los intervalos se encuentra en la agenda 2008 p gs 21,22

3- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNotDef102(nNroPer,nIndice)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroPer                              // N£mero del Periodo
       nIndice                              // Indice de Cumplimiento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cJuiVal := ''                  // Juicio Valorativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL JUICIO VALORATIVO
       IF nNroPer == 1

**********INTERVALO PRIMER PERIODO
	    DO CASE
	    CASE nIndice == 0
		 cJuiVal := SPACE(01)

	    CASE nIndice == 100
		 cJuiVal := 'E'

	    CASE nIndice >= 0 .AND. nIndice <= 49.99
		 cJuiVal := 'D'

	    CASE nIndice >= 50.00 .AND. nIndice <= 66.59
		 cJuiVal := 'I'

	    CASE nIndice >= 66.60 .AND. nIndice <= 83.29
		 cJuiVal := 'A'

	    CASE nIndice >= 83.30 .AND. nIndice <= 99.99
		 cJuiVal := 'S'

	    OTHERWISE
		 cJuiVal := SPACE(01)
	    ENDCASE
**********FIN INTERVALO PRIMER PERIODO

       ELSE

**********INTERVALO DEMAS PERIODOS
	    DO CASE
	    CASE nIndice == 0
		 cJuiVal := SPACE(01)

	    CASE nIndice == 100
		 cJuiVal := 'E'

	    CASE nIndice >= 0 .AND. nIndice <= 49.99
		 cJuiVal := 'D'

	    CASE nIndice >= 50.00 .AND. nIndice <= 79.99
		 cJuiVal := 'I'

	    CASE nIndice >= 80.00 .AND. nIndice <= 89.99
		 cJuiVal := 'A'

	    CASE nIndice >= 90.00 .AND. nIndice <= 99.99
		 cJuiVal := 'S'

	    OTHERWISE
		 cJuiVal := SPACE(01)

		 nIndice := STR(nIndice,5,2)
		 IF nIndice == '90.00'
		    cJuiVal := 'S'
		 ENDIF
	       *ÀError. no valida CASE nIndice >= 90.00 .AND. nIndice <= 99.99 cuando vale 90.00

	    ENDCASE
**********FIN INTERVALO DEMAS PERIODOS

       ENDIF

       RETURN cJuiVal
*>>>>FIN CALCULO DEL JUICIO VALORATIVO

/*************************************************************************
* TITULO..: CALCULO DE INDICADORES SI/NO APROBADOS. CODIGO: 102          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 27/2008 MIE
       Colombia, Bucaramanga        INICIO: 10:00 AM   FEB 27/2008 MIE

OBJETIVOS:

1- Permite calcular la cantidad de indicadores aprobados y no aprobados

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NoSiLog102(cLogros,nNoLogr,nSiLogr,nPerAnt,nPerAct,nTotPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros			      // Indicadores del periodo
       nNoLogr                        // @ N£mero de No Logros
       nSiLogr			      // @ N£mero de Si Logros
       nPerAnt                        // Periodo Anterior
       nPerAct                        // Periodo Actual
       nTotPer                        // Total Periodos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodInd := ''                  // Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cNotInd := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL JUICIO VALORATIVO
       nSiLogr := IF(EMPTY(nSiLogr),0,nSiLogr)
       nNoLogr := IF(EMPTY(nNoLogr),0,nNoLogr)

       FOR i := 1 TO 20
	   cCodInd := SUBS(cLogros,i*6-5,6)
	   cCodCla := SUBS(cCodInd,1,1)
	   cNotInd := UPPER(ALLTRIM(SUBS(cCodInd,5,1)))
	   cNotRec := UPPER(ALLTRIM(SUBS(cCodInd,6,1)))

	   DO CASE
	   CASE cCodCla == '1'  // INDICADORES

****************PERIODO ACTUAL
		  IF nPerAnt == nPerAct

*====================INDICADOR APROBADO
		       IF cNotInd == 'S'
			  nSiLogr++
		       ENDIF
*====================FIN INDICADOR APROBADO

*====================INDICADOR NO APROBADO
		       IF cNotInd == 'N'

*-------------------------SIN RECUPERACIONES
			    IF nPerAct # nTotPer
			       nNoLogr++
			    ENDIF
*-------------------------FIN SIN RECUPERACIONES

*-------------------------CON RECUPERACIONES
			    IF nPerAct == nTotPer

			       IF cNotRec == 'S'
				  nSiLogr++
			       ELSE
				  nNoLogr++
			       ENDIF

			    ENDIF
*-------------------------FIN CON RECUPERACIONES

		       ENDIF
*====================FIN INDICADOR NO APROBADO

		  ENDIF
****************FIN PERIODO ACTUAL

****************PERIODO ANTERIOR
		  IF nPerAnt < nPerAct

*====================INDICADOR APROBADO
		       IF cNotInd == 'S'
			  nSiLogr++
		       ENDIF
*====================FIN INDICADOR APROBADO

*====================INDICADOR NO APROBADO
		       IF cNotInd == 'N'
			  IF cNotRec == 'S'
			     nSiLogr++
			  ELSE
			     nNoLogr++
			  ENDIF
		       ENDIF
*====================FIN INDICADOR NO APROBADO

		  ENDIF
****************FIN PERIODO ANTERIOR

	   CASE cCodCla == '5'  // ACTITUDINALES

****************PERIODO ACTUAL
		  IF nPerAnt == nPerAct

*====================INDICADOR APROBADO
		       IF cNotInd == 'S'
			  nSiLogr++
		       ENDIF
*====================FIN INDICADOR APROBADO

*====================INDICADOR NO APROBADO
		       IF cNotInd == 'N'

*-------------------------SIN RECUPERACIONES
			    IF nPerAct # nTotPer
			       nNoLogr++
			    ENDIF
*-------------------------FIN SIN RECUPERACIONES

*-------------------------CON RECUPERACIONES
			    IF nPerAct == nTotPer

			       IF cNotRec == 'S'
				  nSiLogr++
			       ELSE
				  nNoLogr++
			       ENDIF

			    ENDIF
*-------------------------FIN CON RECUPERACIONES

		       ENDIF
*====================FIN INDICADOR NO APROBADO

		  ENDIF
****************FIN PERIODO ACTUAL

****************PERIODO ANTERIOR
		  IF nPerAnt < nPerAct

*====================INDICADOR APROBADO
		       IF cNotInd == 'S'

			  IF cNotRec == 'N'
			     nNoLogr++
			  ELSE
			     nSiLogr++
			  ENDIF

		       ENDIF
*====================FIN INDICADOR APROBADO

*====================INDICADOR NO APROBADO
		       IF cNotInd == 'N'
			  IF cNotRec == 'S'
			     nSiLogr++
			  ELSE
			     nNoLogr++
			  ENDIF
		       ENDIF
*====================FIN INDICADOR NO APROBADO

		  ENDIF
****************FIN PERIODO ANTERIOR

	   ENDCASE

       ENDFOR
*>>>>FIN CALCULO DEL JUICIO VALORATIVO

*>>>>>VERIFICACION
/*
	cError('nSiLogr='+STR(nSiLogr,2),;
	       'nNoLogr='+STR(nNoLogr,2),;
	       'i='+STR(nPerAnt,1)+':nPerAct='+STR(nPerAct,1))
*/
       RETURN NIL
*>>>>>FIN VERIFICACION

/*************************************************************************
* TITULO..: CALCULO DEL JVF POR PROMEDIO 2 NIVELES. CODIGO: 201          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 29/2008 VIE
       Colombia, Bucaramanga        INICIO: 02:30 AM   FEB 29/2008 VIE

OBJETIVOS:

1- Calcula la nota de cada logro.

2- Calcula el juicio valorativo del promedio de los logros aplicados

3- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJvfCal201(cLogros,cNotInd,nNroPer,nTotPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros                              // Logros aplicados
       cNotInd				    // Nota de los Indicadores
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total de Periodos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo

       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cCodEva := ''                  // Nota del Indicador
       LOCAL cRecEva := ''                  // Nota de la Recuperaci¢n

       LOCAL cIndNot := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de Recupuraci¢n del Indicador

       LOCAL cClaAnt := ''                  // Clase de Indicador Anterior

       LOCAL nTotLog := 0                   // Total Logros
       LOCAL nNroLog := 0                   // N£mero de Logros
       LOCAL nTotInd := 0                   // Total Indicadores
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cNotLog := ''                  // Nota del Logro
       LOCAL cNotDef := ''                  // Nota Definitiva
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE LOS INDICADORES
       cClaAnt := SUBS(cLogros,1,1)
       FOR i := 1 TO LEN(cLogros)/6

***********LECTURA DEL CODIGO DEL INDICADOR
	     cCodigo := SUBS(cLogros,i*6-5,6)

	     cCodInd := SUBS(cCodigo,1,4)
	     cCodCla := SUBS(cCodInd,1,1)
	     cCodEva := SUBS(cCodigo,5,1)
	     cRecEva := SUBS(cCodigo,6,1)

	     cCodigo := SUBS(cNotInd,i*8-7,8)
	     cIndNot := SUBS(cCodigo,1,4)
	     cNotRec := SUBS(cCodigo,5,4)
***********FIN LECTURA DEL CODIGO DEL INDICADOR

***********ANALISIS DEL INDICADOR
	     IF cCodCla == '2'
		nTotInd += VAL(cIndNot)
		nNroInd++
	     ENDIF
***********FIN ANALISIS DEL INDICADOR

***********ANALISIS DEL LOGRO
	     IF cClaAnt # cCodCla .AND. cCodCla == '1'

		cNotLog := STR(nTotInd/nNroInd,4,1)
		cCodEva	:= cNotDefJvf(VAL(cNotLog))

		cLogros := STUFF(cLogros,(i*6-5)+4,1,cCodEva)

		cNotInd := STUFF(cNotInd,i*8-7,4,cNotLog)

		nTotLog += VAL(cNotLog)
		nNroLog++

		nNroInd := 0
		nTotInd := 0

	     ENDIF
***********FIN ANALISIS DEL LOGRO

       ENDFOR
*>>>>FIN RECORRIDO DE LOS INDICADORES

*>>>>CALCULO DE LA NOTA DEFINITIVA
       cNotDef := STR(nTotLog/nNroLog,4,1)
       RETURN cNotDef
*>>>>FIN CALCULO DE LA NOTA DEFINITIVA


/*************************************************************************
* TITULO..: CALCULO DEL JVF POR PROMEDIO 3 NIVELES. CODIGO: 301          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 29/2008 VIE
       Colombia, Bucaramanga        INICIO: 02:30 AM   FEB 29/2008 VIE

OBJETIVOS:

1- Calcula la nota de cada logro.

2- Calcula el juicio valorativo del promedio de los logros aplicados

3- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJvfCal301(cLogros,cNotInd,nNroPer,nTotPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros                              // Logros aplicados
       cNotInd				    // Nota de los Indicadores
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total de Periodos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo

       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cCodEva := ''                  // Nota del Indicador
       LOCAL cRecEva := ''                  // Nota de la Recuperaci¢n

       LOCAL cIndNot := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de Recupuraci¢n del Indicador

       LOCAL cClaAnt := ''                  // Clase de Indicador Anterior

       LOCAL nTotLog := 0                   // Total Logros
       LOCAL nNroLog := 0                   // N£mero de Logros
       LOCAL nTotInd := 0                   // Total Indicadores
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cNotLog := ''                  // Nota del Logro
       LOCAL cNotDef := ''                  // Nota Definitiva
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE LOS INDICADORES
       cClaAnt := SUBS(cLogros,1,1)
       FOR i := 1 TO LEN(cLogros)/6

***********LECTURA DEL CODIGO DEL INDICADOR
	     cCodigo := SUBS(cLogros,i*6-5,6)

	     cCodInd := SUBS(cCodigo,1,4)
	     cCodCla := SUBS(cCodInd,1,1)
	     cCodEva := SUBS(cCodigo,5,1)
	     cRecEva := SUBS(cCodigo,6,1)

	     cCodigo := SUBS(cNotInd,i*8-7,8)
	     cIndNot := SUBS(cCodigo,1,4)
	     cNotRec := SUBS(cCodigo,5,4)
***********FIN LECTURA DEL CODIGO DEL INDICADOR

***********ANALISIS DEL INDICADOR
	     IF cCodCla == '3'
		nTotInd += VAL(cIndNot)
		nNroInd++
	     ENDIF
***********FIN ANALISIS DEL INDICADOR

***********ANALISIS DEL LOGRO
	     IF cClaAnt # cCodCla .AND. cCodCla == '2'

		cNotLog := STR(nTotInd/nNroInd,4,1)
		cCodEva	:= cNotDefJvf(VAL(cNotLog))

		cLogros := STUFF(cLogros,(i*6-5)+4,1,cCodEva)

		cNotInd := STUFF(cNotInd,i*8-7,4,cNotLog)

		nTotLog += VAL(cNotLog)
		nNroLog++

		nNroInd := 0
		nTotInd := 0

	     ENDIF
***********FIN ANALISIS DEL LOGRO

       ENDFOR
*>>>>FIN RECORRIDO DE LOS INDICADORES

*>>>>CALCULO DE LA NOTA DEFINITIVA
       cNotDef := STR(nTotLog/nNroLog,4,1)
       RETURN cNotDef
*>>>>FIN CALCULO DE LA NOTA DEFINITIVA

/*************************************************************************
* TITULO..: CALCULO DEL JVF POR PROMEDIO 3 NIVELES.VARIABLE. CODIGO: 302 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 11:45 AM  MAR 24/2009 MAR
       Colombia, Bucaramanga        FINAL : 04:30 PM  MAR 25/2009 MIE

OBJETIVOS:

1- Calcula la nota de cada logro.

2- Calcula el juicio valorativo del promedio de los logros aplicados

3- Para los c lculos utiliza la clase de indicadores para determinar
   sobre que logros o indicadores actuar, por esto que se se denomina
   como un calculoa VARIABLE.

4- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJvfCal302(cLogros,cNotInd,nNroPer,nTotPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros                              // Logros aplicados
       cNotInd				    // Nota de los Indicadores
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total de Periodos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error */

       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo

       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cCodEva := ''                  // Nota del Indicador
       LOCAL cRecEva := ''                  // Nota de la Recuperaci¢n

       LOCAL cIndNot := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de Recupuraci¢n del Indicador

       LOCAL nTotLog := 0                   // Total Logros
       LOCAL nNroLog := 0                   // N£mero de Logros
       LOCAL nTotInd := 0                   // Total Indicadores
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cNotLog := ''                  // Nota del Logro
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL nNotVer := 0                   // Nota de Verificaci¢n
       LOCAL nPorVer := 0                   // Porcentaje de verificaci¢n
       LOCAL nPorLog := 0                   // Porcentjae del Logro
       LOCAL nProLog := 0                   // Promedio de los logros
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE LOS INDICADORES
       FOR i := 1 TO LEN(cLogros)/6

***********LECTURA DEL CODIGO DEL INDICADOR
	     cCodigo := SUBS(cLogros,i*6-5,6)

	     cCodInd := SUBS(cCodigo,1,4)
	     cCodCla := SUBS(cCodInd,1,1)
	     cCodEva := SUBS(cCodigo,5,1)
	     cRecEva := SUBS(cCodigo,6,1)

	     cCodigo := SUBS(cNotInd,i*8-7,8)
	     cIndNot := SUBS(cCodigo,1,4)
	     cNotRec := SUBS(cCodigo,5,4)
***********FIN LECTURA DEL CODIGO DEL INDICADOR

***********LOCALIZACION DE LA CLASE DE INDICADORES
	     IF !lLocCodigo('cCodigoCla','CLA',cCodCla)

		cError('CODIGO:'+SUBS(cCodInd,1,4),;
		       'LA CLASE DE INDICADOR NO EXISTE')

		lHayErr := .T.
		LOOP
	     ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADORES

***********ANALISIS DEL INDICADOR
	     IF UPPER(CLA->cFormulCla) == 'I'  // Indicador
		nTotInd += VAL(cIndNot)
		nNroInd++
	     ENDIF
***********FIN ANALISIS DEL INDICADOR

***********ANALISIS DEL LOGRO
	     IF UPPER(CLA->cFormulCla) == 'L'  // Logro

		cNotLog := STR(nTotInd/nNroInd,4,1)
		cCodEva	:= cNotDefJvf(VAL(cNotLog))

		cLogros := STUFF(cLogros,(i*6-5)+4,1,cCodEva)

		cNotInd := STUFF(cNotInd,i*8-7,4,cNotLog)

		nTotLog += VAL(cNotLog)
		nNroLog++

		nNroInd := 0
		nTotInd := 0

		nPorLog := CLA->nPorIndCla
	      *ÀPorcentaje de los logros


	     ENDIF
***********FIN ANALISIS DEL LOGRO

***********NOTA DE VERIFICACION
	     IF UPPER(CLA->cFormulCla) == 'V'  // Verificaci¢n

		nNotVer := VAL(cIndNot)
	      *ÀNota de la verificaci¢n.

		nPorVer := CLA->nPorIndCla
	      *ÀPorcentaje de la verificaci¢n

	     ENDIF
***********FIN NOTA DE VERIFICACION

       ENDFOR
*>>>>FIN RECORRIDO DE LOS INDICADORES

*>>>>CALCULO DE LA NOTA DEFINITIVA
       nProLog := nTotLog/nNroLog

       nProLog := (nProLog*nPorLog)/100
       nNotVer := (nNotVer*nPorVer)/100

       cNotDef := STR(nProLog+nNotVer,4,1)
       RETURN cNotDef
*>>>>FIN CALCULO DE LA NOTA DEFINITIVA

/*************************************************************************
* TITULO..: CALCULO DEL JVF POR INDICE DE CUMPLIMIENTO. CODIGO: 103      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 07:30 AM  MAR 16/2009 MIE
       Colombia, Bucaramanga        FINAL : 07:40 AM  MAR 16/2009 MIE

OBJETIVOS:

1- Permite calcular el jvf por indice de cumplimiento, de acuerdo a los
   logros e indicadores que est n activados en la tabla de clase de
   indicadores para que se tengan en cuenta en los c lculos.

2- La fuente de los intervalos es tomada de la tabla de juicios valorativos

3- Retorna el juicio valorativo final.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJvfCal103(cIndic1,cIndic2,cIndic3,cIndic4,cIndic5,;
		    nNroPer,nTotPer,nIndice,cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cIndic1                              // Indicadores Periodo 1
       cIndic1                              // Indicadores Periodo 2
       cIndic1                              // Indicadores Periodo 3
       cIndic1                              // Indicadores Periodo 4
       cIndic1                              // Indicadores Periodo 5
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodo
       nIndice                              // @Indice de Cumplimiento
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nSiLogr := 0                   // N£mero de Logros
       LOCAL nNoLogr := 0                   // N£mero de No Logros
       LOCAL nTotInd := 0                   // Total de Indicadores
       LOCAL cJuiVal := ''                  // Juicio Valorativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE INDICADORES SI/NO APROBADOS
       FOR i := 1 TO nNroPer

	   DO CASE
	   CASE i == 1
		NoSiLog103(cIndic1,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer,;
			   @lHayErr)

	   CASE i == 2
		NoSiLog103(cIndic2,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer,;
			   @lHayErr)

	   CASE i == 3
		NoSiLog103(cIndic3,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer,;
			   @lHayErr)

	   CASE i == 4
		NoSiLog103(cIndic4,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer,;
			   @lHayErr)

	   CASE i == 5
		NoSiLog103(cIndic5,@nNoLogr,@nSiLogr,i,nNroPer,nTotPer,;
			   @lHayErr)

	   ENDCASE

       ENDFOR
*>>>>FIN CALCULO DE INDICADORES SI/NO APROBADOS

*>>>>CALCULO DEL INDICE DE CUMPLIMIENTO
       nIndice := 0
       nTotInd := nSiLogr+nNoLogr
       IF nTotInd == 0
	  nIndice := 0
       ELSE
	  nIndice := (nSiLogr/nTotInd)*100
       ENDIF

       IF lHayErr
	  cJuiVal := SPACE(01)
       ELSE
	  IF nTotInd # 0 .AND. nIndice == 0
	     cJuiVal := 'D'
	  ELSE
	     cJuiVal := cNotDefJvf(nIndice)
	  ENDIF
       ENDIF

       RETURN cJuiVal
*>>>>FIN CALCULO DEL INDICE DE CUMPLIMIENTO

/*************************************************************************
* TITULO..: CALCULO DE INDICADORES SI/NO APROBADOS. CODIGO: 103          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       INICIO: 07:40 AM  MAR 16/2009 MIE
       Colombia, Bucaramanga        FINAL : 08:30 AM  MAR 16/2009 MIE

OBJETIVOS:

1- Permite calcular la cantidad de indicadores aprobados y no aprobados

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NoSiLog103(cLogros,nNoLogr,nSiLogr,nPerAnt,nPerAct,nTotPer,lHayErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros			      // Indicadores del periodo
       nNoLogr                        // @ N£mero de No Logros
       nSiLogr			      // @ N£mero de Si Logros
       nPerAnt                        // Periodo Anterior
       nPerAct                        // Periodo Actual
       nTotPer                        // Total Periodos
       lHayErr                        // .T. Hay Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodInd := ''                  // Indicador
       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cNotInd := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL JUICIO VALORATIVO
       nSiLogr := IF(EMPTY(nSiLogr),0,nSiLogr)
       nNoLogr := IF(EMPTY(nNoLogr),0,nNoLogr)

       FOR i := 1 TO 20

***********LECTURA DEL LOGRO O INDICADOR
	     cCodInd := SUBS(cLogros,i*6-5,6)
	     cCodCla := SUBS(cCodInd,1,1)
	     cNotInd := UPPER(ALLTRIM(SUBS(cCodInd,5,1)))
	     cNotRec := UPPER(ALLTRIM(SUBS(cCodInd,6,1)))

	     IF EMPTY(SUBS(cCodInd,1,4))
		LOOP
	     ENDIF
***********FIN LECTURA DEL LOGRO O INDICADOR

***********LOCALIZACION DE LA CLASE DE INDICADORES
	     lHayErr := .F.

	     IF !lLocCodigo('cCodigoCla','CLA',cCodCla)

		cError('CODIGO:'+SUBS(cCodInd,1,4),;
		       'LA CLASE DE INDICADOR NO EXISTE')

		nNoLogr := 0
		nSiLogr := 0

		lHayErr := .T.

		RETURN lHayErr

	     ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADORES

***********ANALISIS DEL INDICADOR
	     IF UPPER(CLA->cFormulCla) == 'I'  // Indicador

*===============PERIODO ACTUAL
		  IF nPerAnt == nPerAct

*--------------------INDICADOR APROBADO
		       IF cNotInd == 'S'
			  nSiLogr++
		       ENDIF
*--------------------FIN INDICADOR APROBADO

*--------------------INDICADOR NO APROBADO
		       IF cNotInd == 'N'

*:::::::::::::::::::::::::SIN RECUPERACIONES
			    IF nPerAct # nTotPer
			       nNoLogr++
			    ENDIF
*:::::::::::::::::::::::::FIN SIN RECUPERACIONES

*:::::::::::::::::::::::::CON RECUPERACIONES
			    IF nPerAct == nTotPer

			       DO CASE
			       CASE cNotRec == 'N'
				    nNoLogr++
			       CASE cNotRec == 'S'
				    nSiLogr++
			       OTHERWISE
				    nNoLogr++
			       ENDCASE

			    ENDIF
*:::::::::::::::::::::::::FIN CON RECUPERACIONES

		       ENDIF
*--------------------FIN INDICADOR NO APROBADO

		  ENDIF
*===============FIN PERIODO ACTUAL

*===============PERIODO ANTERIOR
		  IF nPerAnt < nPerAct

*====================INDICADOR APROBADO
		       IF cNotInd == 'S'

			  IF CLA->cReeEvaCla == '01'  // Reevaluar

			     DO CASE
			     CASE cNotRec == 'N'
				  nNoLogr++
			     CASE cNotRec == 'S'
				  nSiLogr++
			     OTHERWISE
				  nSiLogr++
			     ENDCASE

			  ELSE
			     nSiLogr++
			  ENDIF

		       ENDIF
*====================FIN INDICADOR APROBADO

*====================INDICADOR NO APROBADO
		       IF cNotInd == 'N'

			  DO CASE
			  CASE cNotRec == 'N'
			       nNoLogr++
			  CASE cNotRec == 'S'
			       nSiLogr++
			  OTHERWISE
			       nNoLogr++
			  ENDCASE

		       ENDIF
*====================FIN INDICADOR NO APROBADO

		  ENDIF
*===============FIN PERIODO ANTERIOR

	     ENDIF
***********FIN ANALISIS DEL INDICADOR

       ENDFOR
       RETURN NIL
*>>>>FIN CALCULO DEL JUICIO VALORATIVO