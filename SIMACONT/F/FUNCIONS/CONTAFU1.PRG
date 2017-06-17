/*                   SISTEMA DE CONTABILIDAD ACADEMICA
		     BIBLIOTECAS DE FUNCIONES GENERALES

REQUERIMIENTOS:

- Compilar: clipper ContaFun /w/m/b

OBJETIVOS:

- Funciones aplicadas para los procesos que las requieran

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL NUMERO DEL BIMESTRE                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 31/95 MIE A
       Colombia, Bucaramanga        INICIO: 10:05 AM   MAY 31/95 MIE

OBJETIVOS:

1- Lectura y valida el n£mero del bimestre

2- Retorna .T. si se leyo el bimestre

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeNroBis(nNroFil,nNroCol,nFilPal)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA Y CONFIRMACION DEL NUMERO DEL BIMESTRE
       cSavLin := SAVESCREEN(nNroFil,nNroCol,nNroFil,79)
       DO WHILE .T.

***********CAPTURA DE NUMERO DEL BIMESTRE
	     nNroBis := 0
	     @ nNroFil,nNroCol SAY "ENTRE EL PERIODO:";
			       GET nNroBis;
			       VALID lValNroBis(nNroBis);
			       PICT '9'
	     READ
***********FIN CAPTURA DE NUMERO DEL BIMESTRE

***********CONFIRMACION DEL NUMERO DEL BIMESTRE
	     IF nNroBis # 0
		IF lPregunta('DESEA CORREGIR EL BIMESTRE? Si No')
		   LOOP
		ENDIF
	     ENDIF
	     EXIT
***********FIN CONFIRMACION DEL NUMERO DEL BIMESTRE

       ENDDO
       IF nNroBis <> 0
	  @ nFilPal,65 SAY 'PERIODO No. '+STR(nNroBis,1)
       ENDIF
       RESTSCREEN(nNroFil,nNroCol,nNroFil,79,cSavLin)
       RETURN nNroBis
*>>>>CAPTURA Y CONFIRMACION DEL NUMERO DEL BIMESTRE


/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL NUMERO DEL BIMESTRE             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 22/95 LUN A
       Colombia, Bucaramanga        INICIO: 09:22 AM   MAY 22/95 LUN

OBJETIVOS:

1- Realiza la validaci¢n del n£mero del bimestre

2- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValNroBis(nNroBis)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroBis				    // N£mero del bimestre */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF nNroBis > 5
	  lHayErr := .F.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO