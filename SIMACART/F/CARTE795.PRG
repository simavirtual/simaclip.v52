/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES. VARIOS
SUBMODULO...: VALOR POR GRUPOS

**************************************************************************
* NOMBRE..: VALOR POR GRUPOS                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2005 MIE A
       Bucaramanga, Colombia        INICIO: 03:30 AM   ABR 20/2005 MIE

OBJETIVOS:

1- Imprime una relaci¢n detallada de facilitar los reportes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_795(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE 'inkey.ch'                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse del archivo
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 'GRU'+cMaeAct+cAnoSis+ExtFile,'GRU',;
			 NIL,lShared,nModCry})
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
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINICION DEL BROWSE
       SELECT GRU
       cTitSup := '<< CURSOS DE '+cMaeAct+;
		  ' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
      *ÀT¡tulo Superior del Browse

       aCampos := {{{"GRUPO","cCodigoGru"},{NIL}},;
		   {{"VALOR TEMPORAL","nVlrTemGru"},;
		    {{'MODI',.T.},{'ALIAS','GRU'},;
		     {'FIELD','nVlrTemGru'},{'PICTURE','9999999.99'}}}}
     *ÀDefinici¢n de Campos

       cTitInf := '<F9>Otros <ESC>Abandonar'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINICION DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       SELECT GRU

       SETKEY(K_F9,{||VrlTemGru(lShared,oBrowse)})
     *ÀGrabar valores temporales

       GRU->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO

/*************************************************************************
* NOMBRE..: FIJAR LOS VALORES TEMPORALES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2005 MIE A
       Bucaramanga, Colombia        INICIO: 03:30 AM   ABR 20/2005 MIE

OBJETIVOS:

1- Imprime una relaci¢n detallada de facilitar los reportes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VrlTemGru(lShared,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lGrabar := .F.                 // Grabar el registro

       LOCAL cGruIni := ''                  // Grupo Inicial
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nVlrTem := 0                   // Valor Temporal

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       nNroFil := nMarco(3,'POR FAVOR INGRESE LOS VALORES',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cGruIni := cSpaces('GRU','cCodigoGru')
	       cGruFin := cSpaces('GRU','cCodigoGru')
	       nVlrTem := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'VALOR DEL CONCEPTO :';
				GET nVlrTem  PICT '9999999.99'

	    @ nNroFil+1,nNroCol SAY 'GRUPO INICIAL      :';
				GET cGruIni PICT '9999';
			     VALID lValGrupo(ROW(),COL()-4,@cGruIni,@nRegIni)

	    @ nNroFil+2,nNroCol SAY 'GRUPO FINAL        :';
				GET cGruFin PICT '9999';
			     VALID lValGrupo(ROW(),COL()-4,@cGruFin,@nRegFin)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cGruIni == cSpaces('GRU','cCodigoGru') .OR.;
		 cGruFin == cSpaces('GRU','cCodigoGru')

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE ASIGNAN VALORES')

	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR LOS VALORES PARA LOS GRUPOS '+;
			    'ESCOGIDOS? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegIni
       DO WHILE RECNO() <= nRegFin .AND. lGrabar

**********GRABACION DEL REGISTRO
	    IF GRU->(lRegLock(lShared,.F.))

	       REPL GRU->nVlrTemGru WITH nVlrTem
	       GRU->(DBCOMMIT())

	    ENDIF

	    IF lShared
	       GRU->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    GRU->(DBSKIP())

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       GRU->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS
