/*************************************************************************
* TITULO ..: IMPRESION DE LOS ESTUDIANTES MOROSOS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 29/99 DOM A
       Colombia, Bucaramanga        INICIO: 07:30 PM   AGO 29/99 DOM

OBJETIVOS:

1- Imprime los Estudiantes morosos con su evaluaci¢n

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor011(aParam1,aParam2,aParam3,;
		   oBrowse,cMesIni,lMorAct,lMorDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       cMesIni                              // Mes Inical del pago
       lMorAct                              // Moroso Actual
       lMorDia                              // Mora por Dias */
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL     i,j := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cTipMor := ''                  // Tipo de Moroso
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL nSdoAnt := 0                   // Saldo Anterior
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nVlrDif := 0                   // Valor de la Diferencia
       LOCAL nTotSdo := 0                   // Total Saldo Actual
       LOCAL nTotDeu := 0                   // Total Deuda Actual
       LOCAL nTotMor := 0                   // Total Mora Actual
       LOCAL nTotRep := 0                   // Total Reportado
       LOCAL cNotMor := ''                  // Evaluaci¢n del Moroso
       LOCAL cObsTxt := ''                  // Observaci¢n
       LOCAL lNomFac := .F.                 // Nombre de la Facturaci¢n
       LOCAL aTotNot[6]                     // Total de la Mora por Notas
       LOCAL aTotRep[6]                     // Total Reportados por Notas
       LOCAL aPorcen[6]                     // Porcentajes
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomMadTes := ''               // Nombre de la Madre
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
       AFILL(aTotNot,0)
       AFILL(aTotRep,0)
       AFILL(aPorcen,0)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>SELECCION DE TIPO DE MOROSO
       IF .NOT. lMorDia
	  IF lPregunta('DESEA IMPRIMIR DE ACUERDO A LA EVALUACION '+;
		       'DE LOS MOROSOS? No Si')
	     cSavPan := SAVESCREEN(0,0,24,79)
	     TitBuscar(10,@nNroFil,@nNroCol,,'EVALUACION')
	     cTipMor := cLeeTipMor(nNroFil,nNroCol,nNroFil+2,nNroCol-2)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     IF EMPTY(cTipMor)
		cError('ESCOGIO TODOS LOS TIPOS DE MOROSOS')
	     ENDIF
	  ENDIF
       ENDIF
       IF !lMorDia .AND. lMorAct
	  lNomFac := lPregunta('DESEA IMPRIMIR CON LOS NOMBRES '+;
			       'DE LOS PADRES O ACUDIENTES? No Si')
       ENDIF
*>>>>FIN SELECCION DE TIPO DE MOROSO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := MOR->(RECCOUNT())+nLinTot
       IF lMorDia
	  aCabeza := {cNomEmp,cNomSis,;
		      'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		      'ANALISIS DE LA CARTERA POR DIAS ',;
		      '',;
		      nNroPag++,;
		      cTotPagina(nTotReg),lTamAnc}
       ELSE
	  IF lMorAct
	     aCabeza := {cNomEmp,cNomSis,;
			 'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
			 IF(lNomFac,'PADRES O ACUDIENTES','ESTUDIANTES')+' '+;
			 'MOROSOS A LA FECHA ',;
			 cFecha(MOR->dFecUsrMor)+;
			 ' A LAS '+cHoraSys(MOR->cHorUsrMor),;
			 nNroPag++,;
			 cTotPagina(nTotReg),lTamAnc}
	  ELSE
	     aCabeza := {cNomEmp,cNomSis,;
			 'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
			 'ESTUDIANTES MOROSOS',;
			 'CORRESPONDIENTE A RECIBOS DE '+cMes(VAL(cMesIni),10),;
			 nNroPag++,;
			 cTotPagina(nTotReg),lTamAnc}
	  ENDIF
       ENDIF
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF lMorDia
	  aNroCol := {14,24,14,14}
	  aTitulo := {'SALDO ANTERIOR','PAGOS O DEUDA','SALDO ACTUAL','FECHA'}
       ELSE
	  IF lNomFac
	     aNroCol := {04,06,06,42,12,42,14}
	     aTitulo := {'No',;
			 'CODIGO',;
			 'GRUPO',;
			 'PADRES O ACUDIENTES',;
			 'SALDO ACTUAL',;
			 'NOMBRE DE LA MADRE',;
			 'EVALUACION'}
	  ELSE
	     aNroCol := {04,06,06,40,12,18,14,14,40}
	     aTitulo := {'No',;
			 'CODIGO',;
			 'GRUPO',;
			 'APELLIDOS Y NOMBRES',;
			 'SALDO ACTUAL',;
			 'NOMBRE DE LA MADRE',;
			 'TELEFONO CASA',;
			 'EVALUACION',;
			 'DETALLES DEL REPORTE'}
	  ENDIF
       ENDIF
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := IF(lMorDia,.T.,.F.)
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(SCA->cSerFacCar,1,1)+'MORACT'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       Termometro(10)
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
	    LineaEstado('REGISTRO:'+MOR->(STR(RECNO(),4))+'/'+;
				    MOR->(STR(RECCOUNT(),4)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lMorDia
	       IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				RTRIM(&cMaeAct->cNombreEst)

		  cNomMadTes := RTRIM(&cMaeAct->cNomMadEst)+' '+;
				RTRIM(&cMaeAct->cApeMadEst)

	       ELSE
		  cNombreTes := 'EL ALUMNO NO EXISTE'
		  cNomMadTes := cNombreTes
	       ENDIF

	       IF lNomFac
		  cNombreTes := cNomFacMae(cMaeAct,CAA->nNomFacCaA)
	       ENDIF

	       IF lNomFac
		  cNombreTes := SUBS(cNombreTes+SPACE(40),1,41)
		  cNomMadTes := SUBS(cNomMadTes+SPACE(40),1,40)
	       ELSE
		  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		  cNomMadTes := SUBS(cNomMadTes+SPACE(18),1,18)
	       ENDIF
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL TIPO DE MOROSO
	    nSdoAct := MOR->nSdoActCli+MOR->nSdoMorCli
	    cNotaCli(MOR->cCodigoEst,;
		     &cMaeAct->cCodigoGru,;
		     ALLTRIM(CAA->cConPenCaA)+;
		     ALLTRIM(&cMaeAct->cConcepEst),;
		     nSdoAct,;
		     TipoMora(MOR->cMesPagCli),;
		     MOR->cMesPagCli,@cNotMor)
**********FIN ANALISIS DEL TIPO DE MOROSO

**********TOTALIZACION DEL SALDO ACTUAL
	    DO CASE
	    CASE SUBS(cNotMor,1,1) == 'E'
		 aTotNot[1] += nSdoAct
		 aTotRep[1] += IF(MOR->lHayRepMor,nSdoAct,0)
	    CASE SUBS(cNotMor,1,1) == 'B'
		 aTotNot[2] += nSdoAct
		 aTotRep[2] += IF(MOR->lHayRepMor,nSdoAct,0)
	    CASE SUBS(cNotMor,1,1) == 'A'
		 aTotNot[3] += nSdoAct
		 aTotRep[3] += IF(MOR->lHayRepMor,nSdoAct,0)
	    CASE SUBS(cNotMor,1,1) == 'R'
		 aTotNot[4] += nSdoAct
		 aTotRep[4] += IF(MOR->lHayRepMor,nSdoAct,0)
	    CASE SUBS(cNotMor,1,1) == 'I'
		 aTotNot[5] += nSdoAct
		 aTotRep[5] += IF(MOR->lHayRepMor,nSdoAct,0)
	    CASE SUBS(cNotMor,1,1) == 'D'
		 aTotNot[6] += nSdoAct
		 aTotRep[6] += IF(MOR->lHayRepMor,nSdoAct,0)
	    ENDCASE
**********FIN TOTALIZACION DEL SALDO ACTUAL

**********PREPARACION DEL REGISTRO
	    IF lMorDia

*--------------CALCULO DE LA DIFERENCIA ENTRE SALDOS
		 nRegAct := MOR->(RECNO())
		 nSdoAct := MOR->nSdoActCli+MOR->nSdoMorCli
		 MOR->(DBSKIP())
		 nSdoAnt := 0

		 IF .NOT. MOR->(EOF())
		    nSdoAnt := MOR->nSdoActCli+MOR->nSdoMorCli
		 ENDIF
		 GO nRegAct

		 IF nSdoAct < nSdoAnt
		    lHayPag := .T.
		    nVlrDif := nSdoAnt - nSdoAct
		 ELSE
		    lHayPag := .F.
		    nVlrDif := nSdoAct - nSdoAnt
		 ENDIF
*--------------FIN CALCULO DE LA DIFERENCIA ENTRE SALDOS

*--------------DETALLES DEL REGISTRO
		 aTitulo := {TRANS(nSdoAnt,"####,###,###"),;
			     IF(lHayPag,'-PAGOS','+DEUDA')+;
			     TRANS(nVlrDif,"####,###,###"),;
			     TRANS(nSdoAct,"####,###,###"),;
			     'A '+cFecha(MOR->dFecUsrMor)}
*--------------FIN DETALLES DEL REGISTRO

	    ELSE

*--------------ANALISIS DEL RETIRO
		 IF &cMaeAct->lRetiroEst
		    cObsTxt := 'RETIRADO. '+ALLTRIM(MOR->cObservMor)
		 ELSE
		    cObsTxt := ALLTRIM(MOR->cObservMor)
		 ENDIF
*--------------FIN ANALISIS DEL RETIRO

*--------------CALCULO DEL TOTAL DE REPORTADOS
		 IF 'Reportado'   $ cObsTxt .OR.;
		    'REPORTADO'   $ cObsTxt .OR.;
		    'ACTUALIZADO' $ cObsTxt

		    nTotRep += MOR->nSdoActCli+MOR->nSdoMorCli
		    cObsTxt := cObsTxt+'.'
		 ENDIF
*--------------FIN CALCULO DEL TOTAL DE REPORTADOS

*--------------DETALLES DEL REGISTRO
		 cObsTxt := cSUBS(cObsTxt,40)
		 aTitulo := {}
		 AADD(aTitulo,STR(MOR->(RECNO()),4))
		 AADD(aTitulo,MOR->cCodigoEst)
		 AADD(aTitulo,&cMaeAct->cCodigoGru)
		 AADD(aTitulo,IF(MOR->lInfActMor,SPACE(01),'?')+cNombreTes)
		 AADD(aTitulo,TRANS(MOR->nSdoActCli+;
				    MOR->nSdoMorCli,"####,###,###"))
		 AADD(aTitulo,cNomMadTes)
		 IF !lNomFac
		    AADD(aTitulo,&cMaeAct->cTelefnEst)
		 ENDIF
		 AADD(aTitulo,IF(lEstNuevo(MOR->cCodigoEst,cAnoUsr),'*','')+;
			      cSUBS(cNotMor,12))
		 IF !lNomFac
		    AADD(aTitulo,cObsTxt)
		 ENDIF
*--------------FIN DETALLES DEL REGISTRO

	    ENDIF
**********FIN PREPARACION DEL REGISTRO

**********ANALISIS DE LA IMPRESION DEL REGISTRO
	    IF EMPTY(cTipMor)

	       nTotSdo += MOR->nSdoActCli+MOR->nSdoMorCli
	       nTotDeu += MOR->nSdoActCli
	       nTotMor += MOR->nSdoMorCli

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ELSE
	       FOR i := 1 TO LEN(cTipMor)
		 IF SUBS(cNotMor,1,1) $ cTipMor

		    nTotSdo += MOR->nSdoActCli+MOR->nSdoMorCli
		    nTotDeu += MOR->nSdoActCli
		    nTotMor += MOR->nSdoMorCli

			  j++
		    aTitulo[1] := STR(j,4)
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		    EXIT
		 ENDIF
	       ENDFOR
	    ENDIF
**********FIN ANALISIS DE LA IMPRESION DEL REGISTRO

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
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DE LOS TOTALES
       IF !lMorDia
	  @ PROW()+1,nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       ENDIF
       IF !lMorAct
	  @ PROW()  ,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
	  @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       ENDIF

       IF !lMorDia
	  @ PROW()+1,00 SAY 'TOTALES ...'
	  @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotSdo,"####,###,###")
	  IF !lMorAct
	     @ PROW()  ,nColTxt(aNroCol,06) SAY 'REPORTADOS = '+;
				       ALLTRIM(TRANS(nTotRep,"####,###,###"))
	  ENDIF
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>CALCULO DE LOS PORCENTAJES
       FOR i := 1 TO LEN(aTotNot)
	 IF !EMPTY(aTotNot[i])
	    aPorcen[i] := (100*aTotNot[i])/nSuma(aTotNot)
	    aPorcen[i] := STR(aPorcen[i],3,0)+'% '
	 ENDIF
       ENDFOR
*>>>>FIN CALCULO DE LOS PORCENTAJES

*>>>>IMPRESION DE LA DUEDA SEGUN LA EVALUACION
       IF !lMorDia .AND. EMPTY(cTipMor)
	  @ PROW()+2,00 SAY 'EVALUACION'+;
			    IF(!lMorAct,SPACE(23)+'REPORTADOS','')

	  IF !EMPTY(aTotNot[1])
	     @ PROW()+1,00 SAY 'EXCELENTE....'+aPorcen[1]+;
				TRANS(aTotNot[1],"####,###,###")+;
				IF (!lMorAct,SPACE(01)+;
				     TRANS(aTotRep[1],"####,###,###"),'')
	  ENDIF
	  IF !EMPTY(aTotNot[2])
	     @ PROW()+1,00 SAY 'BUENO........'+aPorcen[2]+;
			       TRANS(aTotNot[2],"####,###,###")+;
			       IF (!lMorAct,SPACE(01)+;
				     TRANS(aTotRep[2],"####,###,###"),'')
	  ENDIF
	  IF !EMPTY(aTotNot[3])
	     @ PROW()+1,00 SAY 'ACEPTABLES...'+aPorcen[3]+;
			       TRANS(aTotNot[3],"####,###,###")+;
			       IF (!lMorAct,SPACE(01)+;
				    TRANS(aTotRep[3],"####,###,###"),'')
	  ENDIF
	  IF !EMPTY(aTotNot[4])
	     @ PROW()+1,00 SAY 'REGULAR......'+aPorcen[4]+;
			       TRANS(aTotNot[4],"####,###,###")+;
			       IF (!lMorAct,SPACE(01)+;
				    TRANS(aTotRep[4],"####,###,###"),'')
	  ENDIF
	  IF !EMPTY(aTotNot[5])
	     @ PROW()+1,00 SAY 'INSUFICIENTE.'+aPorcen[5]+;
			       TRANS(aTotNot[5],"####,###,###")+;
			       IF (!lMorAct,SPACE(01)+;
				    TRANS(aTotRep[5],"####,###,###"),'')
	  ENDIF

	  IF !EMPTY(aTotNot[6])
	     @ PROW()+1,00 SAY 'DEFICIENTE...'+aPorcen[6]+;
			       TRANS(aTotNot[6],"####,###,###")+;
			       IF (!lMorAct,SPACE(01)+;
				    TRANS(aTotRep[6],"####,###,###"),'')
	  ENDIF
	  @ PROW()+1,00 SAY SPACE(18)+REPL('-',12)+;
			    IF (!lMorAct,SPACE(01)+REPL('-',12),'')

	  @ PROW()+1,00 SAY 'TOTAL........'+SPACE(05)+;
			    TRANS(nSuma(aTotNot),"####,###,###")+;
			    IF (!lMorAct,SPACE(01)+;
				 TRANS(nSuma(aTotRep),"####,###,###"),'')
       ENDIF
*>>>>FIN IMPRESION DE LA DUEDA SEGUN LA EVALUACION

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       IF !EMPTY(oBrowse)
	  MOR->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS