/*************************************************************************
* TITULO DE LA FUNCION..: RUTINA DOBLE DIGITO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 15/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:00 PM   DIC 15/98 MAR

OBJETIVOS:

1- Implementa el algoritmo Doble D¡gito de Chequeo seg£n Davivienda

2- Retorna del Doble Digito de Chequeo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDigChe02(cNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     cNumero                              // N£mero a Calcular el digito */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroTem := 0                   // N£mero Temporal de Calculo
       LOCAL cNroTem := ''                  // N£mero Temporal de Calculo
       LOCAL  nTotal := 0                   // Total de la Sumatoria
       LOCAL nNroChe := 0                   // N£mero de Chequeo
       LOCAL cNroUno := ''                  // Primer Digito de Chequeo
       LOCAL cNroDos := ''                  // Segundo Digito de Chequeo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>NOMBRE DEL METODO
       IF VAL(cNumero) == 0
	  RETURN 'DOBLE DIGITO. DAVIVIENDA'
       ENDIF
*>>>>FIN NOMBRE DEL METODO

*>>>>INVESION DEL NUMERO
       cNumero := ALLTRIM(cNumero)
       FOR i := LEN(cNumero) TO 1 STEP -1
	   cNroTem += SUBS(cNumero,i,1)
       ENDFOR
       cNumero := cNroTem
*>>>>FIN INVESION DEL NUMERO

*>>>>CALCULO DEL PRIMER DIGITO DE CHEQUEO
       FOR i := 1 TO LEN(cNumero)

	   nNroTem := VAL(SUBS(cNumero,i,1))*IF(lPar(i),1,2)

	   IF nNroTem > 9

	      cNroTem := ALLTRIM(STR(nNroTem,nNroTem,0))
	      FOR j := 1 TO LEN(cNroTem)
		  nNroTem := VAL(SUBS(cNroTem,j,1))
		  nTotal += nNroTem
	      ENDFOR

	   ELSE
	      nTotal += nNroTem
	   ENDIF

       ENDFOR
       IF nTotal > 9
	  cNroUno := SUBS(STR(nTotal,2,0),2,1)
       ELSE
	  cNroUno := STR(nTotal,1,0)
       ENDIF
*>>>>FIN CALCULO DEL PRIMER DIGITO DE CHEQUEO

*>>>>CALCULO DEL SEGUNDO DIGITO DE CHEQUEO
       nTotal := 0
       FOR i := 1 TO LEN(cNumero)

	   nNroTem := VAL(SUBS(cNumero,i,1))*IF(lPar(i),3,1)

	   IF nNroTem > 9

	      cNroTem := ALLTRIM(STR(nNroTem,nNroTem,0))
	      FOR j := 1 TO LEN(cNroTem)
		  nNroTem := VAL(SUBS(cNroTem,j,1))
		  nTotal += nNroTem
	      ENDFOR

	   ELSE
	      nTotal += nNroTem
	   ENDIF

       ENDFOR
       IF nTotal > 9
	  cNroDos := SUBS(STR(nTotal,2,0),2,1)
       ELSE
	  cNroDos := STR(nTotal,1,0)
       ENDIF
       RETURN cNroUno+cNroDos
*>>>>FIN CALCULO DEL SEGUNDO DIGITO DE CHEQUEO