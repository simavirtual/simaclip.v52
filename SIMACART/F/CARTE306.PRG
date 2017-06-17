/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : CONSULTAS
SUBMODULO...: CONTABILIDAD

**************************************************************************
* NOMBRE ..: CONTABILIDAD                                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/2006 LUN A
       Bucaramanga, Colombia        INICIO: 08:30 PM   MAR 06/2006 LUN

OBJETIVOS:

1- Permite confirmar la conciliaci¢n de la contabilidad con la cartera.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_306(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL       i := 0                   // Contador
       LOCAL nNroMes := 0                   // Mes para conciliar
       LOCAL   nSuma := 0                   // Suma de Caracteres
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE LA CONCILIACION CON LA CONTABILIDAD
       IF DAY(DATE()) > CAA->nDiaConCaA

**********VALIDACION DEL MES A CONCILIAR
	    nNroMes := MONTH(DATE())
	    DO CASE
	    CASE VAL(cAnoUsr) == YEAR(DATE()) .AND. nNroMes > 1
		 nNroMes--
	    CASE VAL(cAnoUsr) # YEAR(DATE())
		 nNroMes := 12
	    ENDCASE
**********FIN VALIDACION DEL MES A CONCILIAR

**********GRABACION DE LA CONCILIACION
	    FOR i := 1 TO nNroMes
		IF SUBS(CAA->cValConCaA,i,1) # '1'

		   IF !lPregunta('DESEA CONFIRMAR LA CONCILIACION'+' '+;
				'CONTABLE DEL MES DE '+cMes(i)+'?No Si')
		      EXIT
		   ENDIF

		   IF CAA->(lRegLock(lShared,.F.))
		      REPL CAA->cValConCaA WITH STUFF(CAA->cValConCaA,i,1,'1')
		      CAA->(DBCOMMIT())
		   ELSE
		      cError('NO SE REGISTRO DE LA CONFIGURACION GENERAL')
		   ENDIF
		   IF lShared
		      CAA->(DBUNLOCK())
		   ENDIF

		ENDIF
	    ENDFOR
**********FIN GRABACION DE LA CONCILIACION

**********GRABACION DE LA VALIDACION DE LA GRABACION
	    nSuma := 0
	    FOR i := 1 TO 12
		nSuma += VAL(SUBS(CAA->cValConCaA,i,1))
	    ENDFOR

	    IF CAA->(lRegLock(lShared,.F.))
	       REPL CAA->cValConCaA WITH;
		    STUFF(CAA->cValConCaA,13,2,STR(nSuma,2))
	       CAA->(DBCOMMIT())
	    ELSE
	       cError('NO SE REGISTRO DE LA CONFIGURACION GENERAL')
	    ENDIF
	    IF lShared
	       CAA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA VALIDACION DE LA GRABACION

       ENDIF
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN VALIDACION DE LA CONCILIACION CON LA CONTABILIDAD


RETURN NIL

