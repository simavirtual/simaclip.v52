/*************************************************************************
* TITULO ..: ESTUDIANTES MOROSOS DETALLADO. RESUMEN                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 15/2009 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 PM   SEP 15/2009 MAR

OBJETIVOS:

1- Imprime los Estudiantes morosos con su evaluaci¢n con informaci¢n
   detallada para poder realizar gestion de recuperaci¢n de Cartera.

2- Imprime en forma de resumen.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor09A(aP1,aP2,aP3,;
		   oBrowse,cMesIni,lMorAct,lMorDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo
       cMesIni                              // Mes Inical del pago
       lMorAct                              // Moroso Actual
       lMorDia                              // Mora por Dias */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
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
       LOCAL cTipDeu := ''                  // Tipo de Deuda
       LOCAL cDesMor := ''                  // Descrici¢n de la Mora
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nTotSdo := 0                   // Total Saldo Actual
       LOCAL nTotDeu := 0                   // Total Deuda Actual
       LOCAL nTotMor := 0                   // Total Mora Actual
       LOCAL nTotRep := 0                   // Total Reportado
       LOCAL cNotMor := ''                  // Evaluaci¢n del Moroso
       LOCAL cObsTxt := ''                  // Observaci¢n
       LOCAL cForPag := ''                  // Forma de Pago
       LOCAL aTotNot[6]                     // Total de la Mora por Notas
       LOCAL aTotRep[6]                     // Total Reportados por Notas
       LOCAL aPorcen[6]                     // Porcentajes

       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL nTipPer := 0                   // Tipo de Persona
       LOCAL cNomPer := ''                  // Nombre de la Persona
       LOCAL cNitPer := ''                  // Documento de la persona
       LOCAL nDiaIni := 0                   // D¡a mora inicial
       LOCAL nDiaFin := 0                   // D¡a mora final
       LOCAL aTotDia := {}                  // Total por edades

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomMadTes := ''               // Nombre de la Madre
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF MOR->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
       AFILL(aTotNot,0)
       AFILL(aTotRep,0)
       AFILL(aPorcen,0)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LECTURA DE LA EDAD DE LA CARTERA
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(1)
       TitBuscar(20,@nNroFil,@nNroCol,'DIAS',;
				      'EDAD DE LA CARTERA',15)

       DO WHILE .T.
	  nDiaIni := 30
	  nDiaFin := 360
	  @ nNroFil,nNroCol   SAY 'INICIAL :' GET nDiaIni PICT '999'
	  @ nNroFil+1,nNroCol SAY 'FINAL   :' GET nDiaFin PICT '999'
	  READ

	  lHayErr := .T.
	  DO CASE
	  CASE MOD(nDiaIni,30) # 0
	       cError('EL DIA INICIAL DEBE SER MULTIPLO DE 30')

	  CASE MOD(nDiaFin,30) # 0
	       cError('EL DIA FINAL DEBE SER MULTIPLO DE 30')

	  CASE nDiaIni > nDiaFin
	       cError('LOS DIAS INICIALES SON MAYORES A LOS DIAS FINALES')

	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE

	  IF lHayErr
	     LOOP
	  ENDIF
	  EXIT
       ENDDO
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nDiaIni == 0 .OR. nDiaFin == 0
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA EDAD DE LA CARTERA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := MOR->(RECCOUNT())+nLinTot

       aCabeza := {cNomEmp,cNomSis+'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   'RESUMEN DE ESTUDIANTES MOROSOS',;
		   'A FECHA: '+cFecha(MOR->dFecUsrMor)+;
		   ' A LAS '+cHoraSys(MOR->cHorUsrMor),;
		   'DIAS EN MORA:'+;
		   ALLTRIM(STR(nDiaIni,4))+' A '+;
		   ALLTRIM(STR(nDiaFin,4)),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}



       cCodIni := PCL({'DraftOn','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,42,12,14,40}
       aTitulo := {'No',;
		   'CODIGO',;
		   'GRUPO',;
		   'APELLIDOS Y NOMBRES',;
		   'SALDO ACTUAL',;
		   'EDAD CARTERA',;
		   'OBSERVACIONES       '}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
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
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'c'+ALLTRIM(STR(nDiaIni,4))+'-'+ALLTRIM(STR(nDiaFin,4))
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR MOROSOS
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT MOR
       MOR->(DBGOTOP())
       DO WHILE .NOT. MOR->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('CODIGO: '+MOR->cCodigoEst+'º'+;
			'REGISTRO: '+STR(MOR->(RECNO()),5)+'/'+;
				     STR(MOR->(RECCOUNT()),5),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE DECISION
	    IF !(MOR->nDiaMorMor >= nDiaIni .AND.;
		 MOR->nDiaMorMor <= nDiaFin)

	       SELECT MOR
	       MOR->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS DEL TIPO DE MOROSO
	    cTipDeu := TipoMora(MOR->cMesPagCli)
	    nSdoAct := MOR->nSdoActCli+MOR->nSdoMorCli
	    cNotaCli(MOR->cCodigoEst,;
		     &cMaeAct->cCodigoGru,;
		     ALLTRIM(CAA->cConPenCaA)+;
		     ALLTRIM(&cMaeAct->cConcepEst),;
		     nSdoAct,;
		     cTipDeu,;
		     MOR->cMesPagCli,@cNotMor)
**********FIN ANALISIS DEL TIPO DE MOROSO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)

	       cNomMadTes := RTRIM(&cMaeAct->cNomMadEst)+' '+;
			     RTRIM(&cMaeAct->cApeMadEst)

	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	       cNomMadTes := cNombreTes
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,41)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

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

**********ANALISIS DEL RETIRO
	    IF &cMaeAct->lRetiroEst
	       cObsTxt := 'RETIRADO. '+ALLTRIM(MOR->cObservMor)
	    ELSE
	       cObsTxt := ALLTRIM(MOR->cObservMor)
	    ENDIF
**********FIN ANALISIS DEL RETIRO

**********CALCULO DEL TOTAL DE REPORTADOS
	    IF 'Reportado'   $ cObsTxt .OR.;
	       'REPORTADO'   $ cObsTxt .OR.;
	       'ACTUALIZADO' $ cObsTxt

	       nTotRep += MOR->nSdoActCli+MOR->nSdoMorCli
	       cObsTxt := cObsTxt+'.'
	    ENDIF
**********FIN CALCULO DEL TOTAL DE REPORTADOS

**********DETALLES DEL REGISTRO
	    cObsTxt := ALLTRIM(cObsTxt)+' '+MOR->cConcepMor
	    cObsTxt := ALLTRIM(cObsTxt)+SPACE(40)
	    cObsTxt := cSUBS(cObsTxt,40)

	    aTitulo := {}
	    AADD(aTitulo,STR(MOR->(RECNO()),4))
	    AADD(aTitulo,MOR->cCodigoEst)
	    AADD(aTitulo,&cMaeAct->cCodigoGru)
	    AADD(aTitulo,IF(MOR->lInfActMor,SPACE(01),'?')+cNombreTes)
	    AADD(aTitulo,TRANS(MOR->nSdoActCli+;
			       MOR->nSdoMorCli,"####,###,###"))
	    AADD(aTitulo,ALLTRIM(STR(MOR->nDiaMorMor,4)))
	    AADD(aTitulo,cObsTxt)

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN DETALLES DEL REGISTRO

**********LOCALIZACION DE LOS DIAS EN MORA
	    IF EMPTY(aTotDia)
	       AADD(aTotDia,{MOR->nDiaMorMor,;  // 1. Dias en mora
				  0,;           // 2. Deuda
				  0})           // 3. Mora
	       i := LEN(aTotDia)
	    ELSE
	       i := ASCAN(aTotDia,{|aArr|aArr[1] == MOR->nDiaMorMor})
	       IF i == 0
		  AADD(aTotDia,{MOR->nDiaMorMor,;  // 1. Dias en mora
				     0,;           // 2. Deuda
				     0})           // 3. Mora
		   i := LEN(aTotDia)
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DE LOS DIAS EN MORA

**********TOTALES
	    aTotDia[i,2] += MOR->nSdoActCli	   // 2. Deuda
	    aTotDia[i,3] += MOR->nSdoMorCli	   // 3. Mora

	    nTotSdo += MOR->nSdoActCli+MOR->nSdoMorCli
	    nTotDeu += MOR->nSdoActCli
	    nTotMor += MOR->nSdoMorCli
**********FIN TOTALES

	  SELECT MOR
	  MOR->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO POR MOROSOS

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
	  @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotSdo,"####,###,###")+' = '+;
					     'DEUDA '+;
					     ALLTRIM(TRANS(nTotDeu,"####,###,###"))+' + '+;
					     'MORA '+;
					     ALLTRIM(TRANS(nTotMor,"####,###,###"))


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

*>>>>ENCABEZADOS DE TOTALES
       IF !lMorDia

	  aNroCol := {04,14,14,14}
	  aTitulo := {'EDAD',;
		      'SALDO',;
		      'DEUDA',;
		      'MORA'}
	  cCabCol := cRegPrint(aTitulo,aNroCol)

	  lPrnReg(02,nColCab,REPL('=',LEN(cCabCol)),bPagina,bDerAut,bCabeza)
	  lPrnReg(01,nColCab,cCabCol,bPagina,bDerAut,bCabeza)
	  lPrnReg(01,nColCab,REPL('=',LEN(cCabCol)),bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN ENCABEZADOS DE TOTALES

*>>>>CARTERA POR EDADES
       IF !lMorDia

	  aTotDia := ASORT(aTotDia,,,{|x,y|x[1] < y[1]})
	  FOR i := 1 TO LEN(aTotDia)

	      aTitulo := {}
	      AADD(aTitulo,STR(aTotDia[i,1],4))
	      AADD(aTitulo,TRANS(aTotDia[i,2]+;
				 aTotDia[i,3],'####,###,###'))
	      AADD(aTitulo,TRANS(aTotDia[i,2],'####,###,###'))
	      AADD(aTitulo,TRANS(aTotDia[i,3],'####,###,###'))

	      cTxtPrn := cRegPrint(aTitulo,aNroCol)
	      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	  ENDFOR

       ENDIF
*>>>>FIN CARTERA POR EDADES

*>>>>TOTALES
       IF !lMorDia

	  aTitulo := {}
	  AADD(aTitulo,REPL('-',aNroCol[1]))
	  AADD(aTitulo,REPL('-',aNroCol[2]))
	  AADD(aTitulo,REPL('-',aNroCol[3]))
	  AADD(aTitulo,REPL('-',aNroCol[4]))

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	  aTitulo := {}
	  AADD(aTitulo,'TOT.')
	  AADD(aTitulo,TRANS(nSuma(aTotDia,2)+;
			     nSuma(aTotDia,3),'####,###,###'))
	  AADD(aTitulo,TRANS(nSuma(aTotDia,2),'####,###,###'))
	  AADD(aTitulo,TRANS(nSuma(aTotDia,3),'####,###,###'))

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       MOR->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS