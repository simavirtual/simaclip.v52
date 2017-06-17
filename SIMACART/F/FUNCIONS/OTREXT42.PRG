/*************************************************************************
* TITULO ..: ACTUALIZACION DE CODIGOS DE LOS ESTUDIANTES                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 17/99 MAR A
       Colombia, Bucaramanga        INICIO: 05:45 PM   AGO 17/99 MAR

OBJETIVOS:

1- Actualiza los c¢digos de los estudiantes de acuerdo a las referencias

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt42(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nNroFil := 0                   // N£mero de la Fila
     *ÀVariables espec¡ficas

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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
       PathCarAno(lShared,cPatSis,cAnoUsr,;
		  @cIntUno,@cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTUALIZACION DE LOS CODIGOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REGISTRO: '+STR(TRA->(RECNO()),5)+'/'+;
				     STR(TRA->(RECCOUNT()),5)+'º'+;
			'REFERENCIA: '+TRA->cCodRefTra,cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACTUALIZACION DEL CODIGO DEL ESTUDIANTE
	    SELECT TRA
	    IF TRA->(lRegLock(lShared,.F.))
	       REPL TRA->cCodigoEst WITH SUBS(TRA->cCodRefTra,1,6)
	       TRA->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       TRA->(DBUNLOCK())
	    ENDIF
**********FIN ACTUALIZACION DEL CODIGO DEL ESTUDIANTE

	  TRA->(DBSKIP())

       ENDDO
*>>>>FIN ACTUALIZACION DE LOS CODIGOS

*>>>>CIERRE DE ARCHIVOS
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN CIERRE DE ARCHIVOS