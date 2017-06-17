/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: jun 11/2009 DIA A
       Colombia, Bucaramanga        INICIO:  11:03 AM  jun 11/2009 DIA

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfDes(lShared,nModCry,PathArc,fArchvo,aStrDbf,bInsReg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo
       bInsReg                              // Insertar Registros */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL     j,i := 0                   // Contador
       LOCAL cTipVeh := ''                  // Tipo de Categor¡a
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'nIdeCodDes','Numeric'  ,16,0}) // Ide del Registro
      *Llave Principal

       AADD(aDbfStr,{'cTipVehCat','Character',02,0}) // Tipo de Vehiculo
       AADD(aDbfStr,{'nNroHorDes','Numeric',02,0}) // N£mero de Hora
       AADD(aDbfStr,{'lDesMinDes','Logical',01,0}) // .T. Descontar Minutos .F. No descontar minutos

       AADD(aDbfStr,{'cNomUsrDes','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrDes','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrDes','Character',10,0}) // Hora del Usuario
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
          aStrDbf := aDbfStr
          RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathArc) == 0
            DBCREATE(fArchvo,aDbfStr,'DBFNTX')

       CASE nCd(PathArc) == -3
            cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE nCd(PathArc) == -5
            cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       nCd(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'DES',NIL,lShared,nModCry)
	  WAIT 'ABRIENDO EL ARCHIVO.DESCUENTOS PARQUEADERO'
	  CloseDbf('DES',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       FOR i := 1 TO 2

	 cTipVeh := STR(i,2)
	 lCorrecion(@cTipVeh)

	 FOR j := 0 TO 24
	     IF DES->(lRegLock(lShared,.T.))
		REPL DES->nNroHorDes WITH j
		REPL DES->cTipVehCat WITH cTipVeh
		REPL DES->cNomUsrDes WITH 'system'
		REPL DES->dFecUsrDes WITH DATE()
		REPL DES->cHorUsrDes WITH TIME()
		REPL DES->nIdeCodDes WITH RECNO()
		DES->(DBCOMMIT())
	     ELSE
		WAIT 'NO SE GRABA LOS REGISTROS DE DESCUENTOS'
	     ENDIF
	 ENDFOR

       ENDFOR
       IF lShared
	  DES->(DBUNLOCK())
       ENDIF
       CloseDbf('DES',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO