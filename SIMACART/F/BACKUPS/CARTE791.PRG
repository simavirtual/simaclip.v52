/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: DIGITO DE CHEQUEO                        MODULO No. 791

**************************************************************************
* TITULO..: CALCULO DE DIGITOS DE CHEQUEO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/98 MAR A
       Bucaramanga, Colombia        INICIO: 01:00 PM   OCT 06/98 MAR

REQUERIMIENTOS:

1- Ejucutar la funci¢n de acuerdo a su sintaxis

OBJETIVOS:

1- Permite calcular el digito de Chequeo seg£n los algor¡tmos implementados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_791(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar L¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cNumero := ''                  // N£mero a calcular
       LOCAL GetList := {}                  // Variable del Sistema
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
       SET FIXED OFF
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileBan,'BAN',NIL,lShared,nModCry})
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

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',CAA->cCodigoBan)
	  cError('NO EXISTE EL BANCO QUE FIGURA EN LA CONFIGURACION')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       IF EMPTY(BAN->nDigVerBan)
	  cError('NO SE ESTA ACTIVADO EL DIGITO DE CHEQUEO PARA LA FACTURACION')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
*>>>>FIN LOCALIZACION DEL BANCO

*>>>>IMPRESION DE LOS DIGITOS DE CHEQUEO
       nNroFil := nMarco(nFilPal+1,'METODO PARA EL DIGITO DE CHEQUEO: '+;
			 EVAL(bDigChe,'0'),22,'°')

       DO WHILE .T.

**********LECTURA DEL NUMERO
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cNumero := SPACE(10)
	    @ nNroFil,01 GET cNumero PICT '9999999999'
	    READ
	    IF EMPTY(cNumero)
	       EXIT
	    ENDIF
**********FIN LECTURA DEL NUMERO

**********INCREMENTO DE LAS FILAS
	    @ nNroFil,13 SAY 'DIGITO '+EVAL(bDigChe,cNumero)
	    nNroFil++
	    IF nNroFil > 20
	       nNroFil := nMarco(nFilPal+1,;
			  'POR FAVOR ENTRE LOS NUMEROS A CALCULAR',22,'°')

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)
       SET FIXED ON
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DIGITOS DE CHEQUEO

