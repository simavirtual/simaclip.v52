/*************************************************************************
* TITULO ..: IMPRESION FORMATO DE ACTUALIZACION                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2001 MAR A
       Colombia, Bucaramanga        INICIO: 05:15 PM   JUN 05/2001 MAR

OBJETIVOS:

1- Imprime un formato para la Actualizaci¢n de la Informaci¢n de los
   estudiantes que tiene su informaci¢n Desactualizada.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor033(aParam1,aParam2,aParam3,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lTodos  := .T.                 // .T. Imprime Todos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
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

*>>>>VALIDACION DEL CONTENIDO
       IF MOR->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
       lTodos := lPregunta('DESEA IMPRIMIR EL FORMATO PARA '+;
			   'TODOS LOS ESTUDIANTES? Si No')
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DE DECISION
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT MOR
       IF lTodos
	  GO TOP
       ENDIF
       DO WHILE .NOT. MOR->(EOF())

**********VISUALIZACION DE AVANCE
	    SET DEVICE TO SCREEN
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)
	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
	    SET DEVICE TO PRINT
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL FORMATO DE ACTUALIZACION
	    IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       FrmActInf(cMaeAct)
	       IF !lTodos
		  EXIT
	       ENDIF
	    ELSE
	       SET DEVICE TO SCREEN
	       cError('EL CODIGO: '+MOR->cCodigoEst+' NO EXISTE')
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN IMPRESION DEL FORMATO DE ACTUALIZACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT MOR
	    MOR->(DBSKIP())
	    IF MOR->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       SET DEVICE TO PRINT
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN

       RESTSCREEN(0,0,24,79,cSavPan)
       IF !EMPTY(oBrowse)
	  MOR->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL PLAN ACADEMICO