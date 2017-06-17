/*************************************************************************
* TITULO ..: IMPRESION DEL ANEXO A LA AUTORIZACION DE RETIROS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 22/2001 VIE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   JUN 22/2001 VIE

OBJETIVOS:

1- Imprime los estudiantes que deben ser retirados de la Central de Riesgo
   seg£n la Carta de Autorizaci¢n del Retiro.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Ot1Mor033(aParam1,aParam2,aParam3,;
		   cEmpCob,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

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

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cNombre := ''                  // Nombre del Reportado
       LOCAL cNroNit := ''                  // N£mero de la Cedula
       LOCAL cTipNit := ''                  // Tipo de Documento
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cNroRep := ''                  // N£mero de Reportes
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
       IF MOR->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := MOR->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   'RETIRO DE LA CENTRAL DE RIEGOS.'+;
		   IF(EMPTY(cEmpCob),'',ALLTRIM(cEmpCob)),;
		   'ANEXO A LA CARTA CON AUTORIZACION No. '+;
		   SCO->cCodEmpCon+'-'+;
		   ALLTRIM(STR(CAR->nAutRetCar1,8)),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {24,40,12,06,06,40,12}
       aTitulo := {'DOCUMENTO',;
		   'PERSONAS REPORTADAS A RETIRAR',;
		   'PARENTESCO',;
		   'CODIGO',;
		   'GRUPO',;
		   'ESTUDIANTE'}
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
       IF !Printer_on(CAR->lPrnArcCar)
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

       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO. REG: '+;
			STR(MOR->(RECNO()),5)+'/'+;
			STR(MOR->(RECCOUNT()),5),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********AVANCE DEL SIGUIENTE REGISTRO
	    IF !MOR->lSiRepoMor
	       MOR->(DBSKIP())
	       IF MOR->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DE CLIENTES Y PAGOS
	    lLocCodigo('cCodigoEst','CLI',MOR->cCodigoEst)
	    nMesIni := VAL(SUBS(CLI->cHayRepCli,1,2))
	    lLocCodPag(MOR->cCodigoEst,nMesIni,.F.)
**********FIN LOCALIZACION DE CLIENTES Y PAGOS

**********VALIDACION DE LA CEDULA REPORTADA
	    cNombre := ''
	    cNroNit := ''
	    cTipNit := ''

	    DO CASE
	    CASE PAG->nNomFacEst == 0 .OR. PAG->nNomFacEst == 1
		 cNombre := RTRIM(&cMaeAct->cApePadEst)+' '+;
			    RTRIM(&cMaeAct->cNomPadEst)

		 cNroNit := &cMaeAct->cPadNitEst
		 cTipNit := &cMaeAct->cPadTntEst

	    CASE PAG->nNomFacEst == 2
		 cNombre := RTRIM(&cMaeAct->cApeMadEst)+' '+;
			    RTRIM(&cMaeAct->cNomMadEst)

		 cNroNit := &cMaeAct->cMadNitEst
		 cTipNit := &cMaeAct->cMadTntEst

	    CASE PAG->nNomFacEst == 3
		 cNombre := RTRIM(&cMaeAct->cApeAcuEst)+' '+;
			    RTRIM(&cMaeAct->cNomAcuEst)

		 cNroNit := &cMaeAct->cAcuNitEst
		 cTipNit := &cMaeAct->cAcuTntEst
	    ENDCASE
**********FIN VALIDACION DE LA CEDULA REPORTADA

**********IMPRESION DEL REGISTRO
	    aTitulo := {cTipNit+'No. '+cNroNit,;
			cSUBS(cNombre,40),;
			cTipNomRep(PAG->nNomFacEst),;
			&cMaeAct->cCodigoEst,;
			&cMaeAct->cCodigoGru,;
			cSUBS(cNombreTes,40)}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********GRABACION DEL CONTROL DEL REPORTE
	    IF CLI->(lRegLock(lShared,.F.))
	       cNroRep := SUBS(CLI->cHayRepCli,5,1)
	       IF cNroRep # 'R'
		  IF VAL(cNroRep) > 9
		     cNroRep := 'R'
		  ELSE
		     cNroRep := VAL(cNroRep) + 1
		     cNroRep := STR(cNroRep,1,0)
		  ENDIF
	       ENDIF
	       REPL CLI->cHayRepCli WITH STUFF(CLI->cHayRepCli,5,1,cNroRep)
	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL CONTROL DEL REPORTE

**********GRABACION DEL CONTROL DEL REPORTE
	    IF PAG->(lRegLock(lShared,.F.))
	       REPL PAG->dFecRetMor WITH DATE()
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL CONTROL DEL REPORTE

**********AVANCE DEL SIGUIENTE REGISTRO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
	    SELECT MOR
	    MOR->(DBSKIP())
	    IF MOR->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       IF !EMPTY(oBrowse)
	  MOR->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS