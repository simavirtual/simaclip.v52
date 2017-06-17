/*************************************************************************
* TITULO DE LA FUNCION..: VALOR DE LOS ABONOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   MAR 25/99 JUE

OBJETIVOS:

1- Calcula el valor de los abonos del mes.

2- Calcula el valor de los abonos de otros meses.

3- Debe estar en uso el archivo de Descuentos y ubicado en el primer
   registro del abono del estudiante.

4- Debe estar en uso el archivo de pagos y ubicado en registro del
   estudiante.

5- Retorna por referencia los abonos del mes y los abonos de otros meses.

6- Retorna el valor de los abonos del mes.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrAbo(cCodEst,nMesIni,nDeuInt,nAboOtr,nAboDes,lPrnFec,dFecPrn)

*>>>>PARARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del Estudiante
       nMesIni                              // Mes Inicial del pago
       nDeuInt                              // @ Deuda Anterior para calcular los intereses por cobrar
       nAboOtr                              // @ Abonos de otros Meses
       nAboDes                              // @Abonos como Descuentos
       lPrnFec                              // .T. Fecha de Corte
       dFecPrn                              // Fecha de Corte */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nActPag := 0                   // Registro Actual
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL lFAboOk := .T.                 // Fecha de Abono de Acuerdo al Corte
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL ABONO
       nAboDes := 0
       lPrnFec := IF(lPrnFec == NIL,.F.,lPrnFec)
       dFecPrn := IF(dFecPrn == NIL,CTOD('00/00/00'),dFecPrn)
       DO WHILE DES->(FOUND())

**********ANALISIS DE LA FECHA DE PAGO
	    lFAboOk := .T.
	    IF lPrnFec
	       IF DES->dFechaDes > dFecPrn
		  lFAboOk := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA FECHA DE PAGO

**********CALCULO DE LA DEUDA PARA CALCULAR INTERESES DEL MES
	    IF PAG->nMesAmnPag # nMesIni

*--------------ANALISIS DE LA FECHA DEL ABONO
		 IF DES->dFechaDes <= PAG->dPagExtPag
		    nDeuInt := PAG->nSdoAntPag+nVlrMes()
		 ELSE
		    nDeuInt := PAG->nSdoExtPag+nVlrMes()
		 ENDIF
*--------------FIN ANALISIS DE LA FECHA DEL ABONO

	    ELSE
	       nDeuInt := nVlrMes()
	    ENDIF
**********FIN CALCULO DE LA DEUDA PARA CALCULAR INTERESES DEL MES

**********TOTAL DE ABONOS PARA EL MES
	    IF DES->nNroMesDes == nMesIni
	       IF DES->lDesEfeDes
		  nAboDes += DES->nValorDes
	       ELSE
		  nTotAbo += DES->nValorDes
	       ENDIF
	    ENDIF
**********FIN TOTAL DE ABONOS PARA EL MES

**********TOTAL DE ABONOS OTROS MESES
	    IF DES->nMesModDes == nMesIni .AND. lFAboOk
	       nAboOtr += DES->nAboOtrDes
	    ENDIF
**********FIN TOTAL DE ABONOS OTROS MESES

	  SELECT DES
	  CONTINUE
	  LOOP
       ENDDO
       RETURN nTotAbo
*>>>>FIN ANALISIS DEL ABONO