/*************************************************************************
* TITULO ..: IMPRESION DE LOS ESTUDIANTES PARA COBRO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 29/99 DOM A
       Colombia, Bucaramanga        INICIO: 07:30 PM   AGO 29/99 DOM

OBJETIVOS:

1- Imprime los Estudiantes que va a ser enviados para cobros externo.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrCob011(aParam1,aParam2,aParam3,;
		   oBrowse,cMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       cMesIni                              // Mes Inical del pago */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nTotSdo := 0                   // Total Saldo Actual
       LOCAL nTotDeu := 0                   // Total Deuda Actual
       LOCAL nTotMor := 0                   // Total Mora Actual
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
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
       IF COB->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := COB->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'COBRO JURIDICO. JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   'RELACION DE ESTUDIANTES MOROSOS',;
		   'CORRESPONDIENTE AL MES DE '+cMes(VAL(cMesIni),10),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,06,12,12,12,40}
       aTitulo := {'CODIGO',;
		   'GRUPO',;
		   'APELLIDOS Y NOMBRES ',;
		   'MESES',;
		   'SALDO ACTUAL',;
		   'DEUDA ACTUAL',;
		   'MORA ACTUAL',;
		   'OBSERVACION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT COB
       GO TOP
       DO WHILE .NOT. COB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( COB->(RECNO()) / COB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodMae(COB->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********TOTALIZACION DEL SALDO ACTUAL
	    nTotSdo += COB->nSdoAntPag+COB->nMorAntPag
	    nTotDeu += COB->nSdoAntPag
	    nTotMor += COB->nMorAntPag
**********FIN TOTALIZACION DEL SALDO ACTUAL

**********IMPRESION DEL REGISTRO
	    aTitulo := {COB->cCodigoEst,;
			&cMaeAct->cCodigoGru,;
			cNombreTes,;
			SUBS(COB->cRegTxtCob,31,2),;
			TRANS(COB->nSdoAntPag+COB->nMorAntPag,"####,###,###"),;
			TRANS(COB->nSdoAntPag,"####,###,###"),;
			TRANS(COB->nMorAntPag,"####,###,###"),;
			IF(COB->lInfActCob,IF(COB->lRegGraCob,;
					      'REPORTADO','NO REPORTADO'),;
					   'FALTA ACTUALIZAR DATOS')}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT COB
	    COB->(DBSKIP())
	    IF COB->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       @ PROW()  ,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotSdo,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotDeu,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotMor,"####,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       IF !EMPTY(oBrowse)
	  COB->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS