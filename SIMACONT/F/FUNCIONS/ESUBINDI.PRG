/*************************************************************************
* TITULO..: CLASIFICACION DE LOS INDICADORES DEL GRUPO.                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 16/2008 MAR A
       Colombia, Bucaramanga        INICIO:  09:30 AM  SEP 16/2008 MAR

OBJETIVOS:

1- Crea un vector con la clasificaci¢n de los indicadores de una materia
   pertenecientes a un grupo especifico.

2- Retorna el vector con la clasificaci¢n de los indicadores.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aSinIndGru(cCodGru,cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aSinMat := {}                  // Sub Indicadores de la materia

       LOCAL cCodCla := ''                  // C¢digo de la Clase
       LOCAL cSubCod := ''                  // C¢digo de la Clase en el cual esta subdividido
       LOCAL nSubCod := 1                   // N£mero total de Sub C¢digos de Clase de indicadores
       LOCAL aSubInd := {}                  // Sub Indicadores
       LOCAL cSubInd := ''                  // Sub Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       SELECT SIN
       SET FILTER TO SIN->cCodGruSin == cCodGru .AND.;
		     SIN->cCodMatSin == cCodMat

       SIN->(DBGOTOP())
       IF SIN->(EOF())
	  cError('NO EXISTE CLASIFICACION DE INDICADORES',;
		 'GRUPO:'+cCodGru,'MATERIA:'+cCodMat)
	  SET FILTER TO
	  RETURN aSinMat
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>LOCALIZACION DEL CODIGO PROMOCIONAL
       IF lLocCodigo('nSubCodCla','CLA',nSubCod)
	  cCodCla := CLA->cCodigoCla
	  cSubCod := CLA->cSubCodCla
       ENDIF

       IF EMPTY(cCodCla) .OR. EMPTY(cSubCod)
	  cError('NO EXISTE LA CLASE DEL INDICADOR PROMOCIONAL')
	  RETURN aSinMat
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO PROMOCIONAL

*>>>>RECORRIDO DEL ARCHIVO
       SELECT SIN
       SIN->(DBGOTOP())
       DO WHILE .NOT. SIN->(EOF())

**********VALIDACION DEL CODIGO PROMOCIONAL
	    IF SUBS(SIN->cCodLogSin,1,1) # cCodCla
	       SIN->(DBSKIP())
	       LOOP
	    ENDIF
	    IF EMPTY(SIN->cCodIndSin)
	       SIN->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO PROMOCIONAL

**********RECORRIDO DE LOS SUBINDICADORES
	    aSubInd := {}
	    FOR i := 1 TO LEN(ALLTRIM(SIN->cCodIndSin))/4
		cSubInd := SUBS(SIN->cCodIndSin,i*4-3,4)
		AADD(aSubInd,cSubInd)
	    ENDFOR
	    AADD(aSinMat,{SIN->cCodLogSin,aSubInd})
**********FIN RECORRIDO DE LOS SUBINDICADORES

	  SIN->(DBSKIP())

       ENDDO
       RETURN aSinMat
*>>>>FIN RECORRIDO DEL ARCHIVO
