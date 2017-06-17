/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: MOROSOS SOLO MES ACTUAL

**************************************************************************
* TITULO.: ESTUDIANTES MOROSOS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 18/2014 MAR A
       Bucaramanga, Colombia	    INICIO: 12:00 PM   NOV 18/2014 MAR

OBJETIVOS:

1- Permite imprimir los estudiantes del solo mes actual

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_417(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
       LOCAL nLicAct := xPrm(aP1,'nLicAct') // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CART.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
     *ÀVariables de informe

       LOCAL     i,j := 0                   // Contadores
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL lPagRec := .F.                 // .T. Pago el recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nIntNoP := 0                   // Valor de los intereses no pago
       LOCAL nTotPag := 0                   // Total a Pagar
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis)
	      cError('ABRIENDO ARCHIVOS')
	      CloseAll()
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN NIL
	   ENDIF

	   SELECT GRU
	   GO TOP
	   DO WHILE .NOT. (GRU->(EOF()))

	      IF FUE->(lRegLock(lShared,.T.))
		 REPL FUE->cCodigoGru WITH GRU->cCodigoGru
		 FUE->(DBCOMMIT())
	      ELSE
		 cError('NO SE GRABA LA FORMA DE PAGO')
	      ENDIF
	      IF lShared
		 FUE->(DBUNLOCK())
	      ENDIF

	      SELECT GRU
	      SKIP

	   ENDDO

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis)    .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared).OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := GRU->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'ESTUDIANTES MOROSOS',;
		   'DEBEN UN SOLO MES Y NO LO HAN PAGADO',;
		   'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitulo := {}

       AADD(aNroCol,08)
       AADD(aTitulo,'CURSO ')

       AADD(aNroCol,06)
       AADD(aTitulo,'CODIGO')

       AADD(aNroCol,40)
       AADD(aTitulo,'NOMBRE DEL ESTUDIANTE')

       AADD(aNroCol,04)
       AADD(aTitulo,'MES')

       AADD(aNroCol,12)
       AADD(aTitulo,'F.OPO')

       AADD(aNroCol,12)
       AADD(aTitulo,'VLROPO')

       AADD(aNroCol,12)
       AADD(aTitulo,'F.EXT')

       AADD(aNroCol,12)
       AADD(aTitulo,'VLREXT')

       AADD(aNroCol,12)
       AADD(aTitulo,'NO PAGO')

       AADD(aNroCol,06)
       AADD(aTitulo,'ESTADO')

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
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn = SUBS(CAR->cSerFacCar,1,1)+'solomes'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('GRUPO: '+GRU->cCodigoGru+;
			'ºNo. '+STR(GRU->(RECNO()),2)+'/'+;
				STR(GRU->(RECCOUNT()),2),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO


**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LOS GRUPOS
	    SELECT CLI
	    CLI->(DBGOTOP())
	    DO WHILE .NOT. CLI->(EOF())

*--------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		 lRetadoTes := .F.
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,;
				       cMaeAlu,@cMaeAct,.F.)
		 IF lHayAlu
		    cCodigoTes := &cMaeAct->cCodigoEst
		    IF &cMaeAct->lRetiroEst
		       lRetadoTes := .T.
		    ENDIF
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  &cMaeAct->cNombreEst
		    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 ENDIF
*--------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------LOCALIZACION DEL ULTIMO RECIBO
		 IF nUltRecPag(CLI->cCodigoEst) == 0
		    nMesIni := 0
		 ELSE
		    nMesIni := PAG->nMesIniPag
		 ENDIF
*--------------FIN LOCALIZACION DEL ULTIMO RECIBO

*--------------LOCALIZACION DEL PAGO
		 lHayPag := .F.
		 IF lHayAlu
		    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO

*--------------IMPRESION DEL REGISTRO
		 IF lHayAlu .AND. lHayPag

		    lPagRec := CLI->nSdoActCli+CLI->nSdoMorCli == 0 .AND.;
			       !EMPTY(PAG->dFecPagPag)              .AND.;
			       (PAG->cEstadoPag == 'P' .OR.;
				PAG->cEstadoPag == 'A')

		    IF !lPagRec .AND. PAG->nSdoAntPag+PAG->nMorAntPag == 0

		       nVlrInt := nIntMesPag(CAA->lIntPenCaA,;
					     PAG->nSdoAntPag,;
					     PAG->nVlrMesPag,;
					     PAG->nMesIniPag,;
					     CAA->nMesAmnCaA)

		       nIntNoP := nIntMesNoP(CAA->lIntPenCaA,;
					     PAG->nSdoAntPag,;
					     PAG->nVlrMesPag,;
					     PAG->nMesIniPag,;
					     CAA->nMesAmnCaA)

		       nTotPag := PAG->nSdoAntPag+;
				  PAG->nMorAntPag+;
				  PAG->nVlrMesPag

		       aTitulo := {}
		       AADD(aTitulo,&cMaeAct->cCodigoGru)
		       AADD(aTitulo,&cMaeAct->cCodigoEst)
		       AADD(aTitulo,cNombreTes)
		       AADD(aTitulo,cMes(PAG->nMesIniPag,3))

		       IF PAG->cEstadoPag == 'D'

			  AADD(aTitulo,'')  // F.OPO
			  AADD(aTitulo,'')

			  AADD(aTitulo,'')  // F.EXT
			  AADD(aTitulo,'')

			  AADD(aTitulo,TRANS(nTotPag+nIntNoP,"####,###,###"))
			  AADD(aTitulo,PAG->cEstadoPag)

		       ELSE

			  IF DATE()  <= PAG->dPagOpoPag
			     AADD(aTitulo,cFecha(PAG->dPagOpoPag,3))  // F.OPO
			     AADD(aTitulo,TRANS(nTotPag,"####,###,###"))
			  ELSE
			     AADD(aTitulo,'')
			     AADD(aTitulo,'')
			  ENDIF

			  IF DATE() <= PAG->dPagExtPag
			     AADD(aTitulo,cFecha(PAG->dPagExtPag,3))  // F.EXT
			     AADD(aTitulo,TRANS(nTotPag+nVlrInt,"####,###,###"))
			  ELSE
			     AADD(aTitulo,'')
			     AADD(aTitulo,'')
			  ENDIF

			  AADD(aTitulo,TRANS(nTotPag+nIntNoP,"####,###,###"))
			  AADD(aTitulo,'')

		       ENDIF


		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		    ENDIF

		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO

	       CLI->(DBSKIP())
	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

	  GRU->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

