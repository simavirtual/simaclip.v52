/*************************************************************************
* TITULO ..: CARTERA POR EDADES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 05/2006 JUE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   OCT 05/2006 JUE

OBJETIVOS:

1- Imprime el saldo actual de cada estudiante de acuerdo a la edad
   de la mora

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor044(aParam1,aParam2,aParam3,;
		   oBrowse,lPazSav,cMesIni,;
		   lMorAct,dFecDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       lPazSav                              // Paz y Salvo
       cMesIni                              // Mes Inical del pago
       lMorAct                              // .T. Moroso Actual
       dFecDia                              // Fecha del Proceso Diario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
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

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀVariables Gestion Documental

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nDiaIni := 0                   // D¡a mora inicial
       LOCAL nDiaFin := 0                   // D¡a mora final
       LOCAL aTotDia := {}                  // Total por edades
       LOCAL nMesSdo := 0                   // Mes del Saldo

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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

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
       nMesSdo := nMesSdoMor(cNomSis)
*>>>>FIN LECTURA DE LA EDAD DE LA CARTERA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 3024
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<CONSULTAS><CARTERA ACTUAL>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aMezIso,{'<nMesSdo>',cMes(nMesSdo)})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'CARTERA RECIBOS DE <nMesSdo>')     // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCA->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'mora'+cAnoUsr
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.T.,2,;
				 bInsIso,PathPrn)

	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   'DIAS EN MORA:'+ALLTRIM(STR(nDiaIni,4))+' A '+;
		   ALLTRIM(STR(nDiaFin,4))+' '+;
		   'A¥O:'+cAnoUsr+' JORNADA '+cJorTxt,;
		   'A '+cFecha(MOR->dFecUsrMor)+;
		   ' A LAS '+cHoraSys(MOR->cHorUsrMor)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,04)
       AADD(aTitPrn,'EDAD')

       AADD(aNroCol,14)
       AADD(aTitPrn,'SALDO')

       AADD(aNroCol,14)
       AADD(aTitPrn,'DEUDA')

       AADD(aNroCol,14)
       AADD(aTitPrn,'MORA')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       IF nOpcPrn == 6
	  FilePrn := PathDoc+'\mora'+cAnoUsr+'.xls'
       ENDIF
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPieIso(aPieIso))}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>RECORRIDO POR REGISTROS
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
**********FIN TOTALES

	  SELECT MOR
	  MOR->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR REGISTROS

*>>>>CARTERA POR EDADES
       aTotDia := ASORT(aTotDia,,,{|x,y|x[1] < y[1]})
       FOR i := 1 TO LEN(aTotDia)

	   aRegPrn := {}
	   AADD(aRegPrn,STR(aTotDia[i,1],4))
	   IF nOpcPrn == 6
	      AADD(aRegPrn,STR(aTotDia[i,2]+aTotDia[i,3],10,0))
	      AADD(aRegPrn,STR(aTotDia[i,2],10,0))
	      AADD(aRegPrn,STR(aTotDia[i,3],10,0))
	   ELSE
	      AADD(aRegPrn,TRANS(aTotDia[i,2]+;
				 aTotDia[i,3],'####,###,###'))
	      AADD(aRegPrn,TRANS(aTotDia[i,2],'####,###,###'))
	      AADD(aRegPrn,TRANS(aTotDia[i,3],'####,###,###'))
	   ENDIF

	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       ENDFOR
*>>>>FIN CARTERA POR EDADES

*>>>>TOTALES
       aRegPrn := {}
       AADD(aRegPrn,REPL('-',aNroCol[1]))
       AADD(aRegPrn,REPL('-',aNroCol[2]))
       AADD(aRegPrn,REPL('-',aNroCol[3]))
       AADD(aRegPrn,REPL('-',aNroCol[4]))

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       aRegPrn := {}
       AADD(aRegPrn,'TOT.')
       IF nOpcPrn == 6
	  AADD(aRegPrn,STR(nSuma(aTotDia,2)+nSuma(aTotDia,3),10,0))
	  AADD(aRegPrn,STR(nSuma(aTotDia,2),10,0))
	  AADD(aRegPrn,STR(nSuma(aTotDia,3),10,0))
       ELSE
	  AADD(aRegPrn,TRANS(nSuma(aTotDia,2)+;
			     nSuma(aTotDia,3),'####,###,###'))
	  AADD(aRegPrn,TRANS(nSuma(aTotDia,2),'####,###,###'))
	  AADD(aRegPrn,TRANS(nSuma(aTotDia,3),'####,###,###'))
       ENDIF

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*>>>>FIN TOTALES

*>>>>IMPRESION DERECHOS
       SET DEVICE TO PRINT
       EVAL(bDerAut)
       EJECT
      *Derechos de Autor

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO ..: MES DEL SALDO                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 30/2007 JUE A
       Colombia, Bucaramanga        INICIO: 06:20 PM   JUL 30/2007 JUE

OBJETIVOS:

1- Calcula el mes del saldo.

2- Retorna el mes del saldo.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMesSdoMor(cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL       i := 0                   // Contador
       LOCAL nMesSdo := 0                   // Mes del saldo
       LOCAL aMesSdo := {}                  // Meses del saldo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SELECT MOR
       MOR->(DBGOTOP())
       DO WHILE .NOT. MOR->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REGISTRO: '+STR(MOR->(RECNO()),5)+'/'+;
				     STR(MOR->(RECCOUNT()),5),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DE LOS DIAS EN MORA
	    IF EMPTY(aMesSdo)

	       AADD(aMesSdo,{MOR->nMesMorMor,;  // 1. Mes del Saldo
				  0})           // 2. Contador
	       i := LEN(aMesSdo)
	    ELSE
	       i := ASCAN(aMesSdo,{|aArr|aArr[1] == MOR->nMesMorMor})
	       IF i == 0
		  AADD(aMesSdo,{MOR->nMesMorMor,;  // 1. Mes del Saldo
				     0})           // 2. Contador
		  i := LEN(aMesSdo)
	       ENDIF
	    ENDIF
	    aMesSdo[i,2]++                         // 2. Contador
**********FIN LOCALIZACION DE LOS DIAS EN MORA

	  SELECT MOR
	  MOR->(DBSKIP())

       ENDDO
       MOR->(DBGOTOP())
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO POR REGISTROS

*>>>>LECTURA DEL MES DEL SALDO
       aMesSdo := ASORT(aMesSdo,,,{|x,y|x[2] > y[2]})
       nMesSdo := aMesSdo[1,1]
       RETURN nMesSdo
*>>>>FIN LECTURA DEL MES DEL SALDO