/*************************************************************************
* TITULO ..: CANCELACION DE LOS RECIBOS PAGADOS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/95 JUE A
       Bucaramanga, Colombia        INICIO: 02:35 PM   JUN 15/95 JUE

OBJETIVOS:

1- Lee el archivo transferido del modem y actualiza el saldo de solo los
   recibos que aparecen pagados.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra011(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del D¡a */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL nTotReg := 0                   // Total Registros
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL cCodFac := ''                  // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL nCodPag := 0                   // C¢digo del Pago.
       LOCAL nLenRef := 0                   // Longitud de la Referencia
       LOCAL cCodMtv := ''                  // C¢digo del motivo
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables temporales de Campos
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

*>>>>DOCUMENTACION DE VARIABLES
/*     nCodPag. C¢digo del pago:
       0 => C¢digo de pago a no procesar
       1 => Recibo de matr¡culas
       2 => Recibo de servicios educativos */
*>>>>FIN DOCUMENTACION DE VARIABLES

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF EMPTY(cNroDia)
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ELSE
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
       ENDCASE
       nTotReg := TRA->(RECCOUNT())
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

/*
*>>>>INDEXACION DEL ARCHIVO
       IF !FILE(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxTra)

	  SELECT TRA
	  INDEX ON TRA->cCodigoEst;
		TO &(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxTra)

       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO
*/

*>>>>VALIDACION DEL MES DE AMNISTIA
       IF CAA->nMesAmnCaA == VAL(cNroMes)
	  cError('EL MES DE AMNISTIA SE DEBE PROCESAR MANUALMENTE',;
		 'PARA EVITAR ERRORES')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES DE AMNISTIA

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE LOS ENCABEZADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilPal+1)
       cCabeza := cRegPrint({'CODIGO',;
			     'NOMBRE',;
			     'SALDO ACTUAL',;
			     'VALOR A PAGAR ',;
			     'TOTAL PAGADO  ',;
			     'FORMA '},;
			    {06,18,12,12,14,06},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>SELECION DEL PATH
       IF .NOT. EMPTY(CAA->cAnoAluCaA)
	  cAnoUsr := CAA->cAnoAluCaA
	  cPatSis := cAnoUsr+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
       cCodFac := CAR->cCodFacCar
*>>>>FIN SELECION DEL PATH

/*
*>>>>ANALISIS DE DECISION
       SELECT TRA
       GO TOP

       cCodFac := CAR->cCodFacCar
       IF TRA->cCodFacCar # CAR->cCodFacCar
	  IF TRA->cCodFacCar # BAN->cCodFacCar
	     cError('EL CODIGO DEL SERVICIO NO COINCIDE')
	  ELSE
	     cCodFac := BAN->cCodFacCar
	  ENDIF
       ENDIF
*>>>>ANALISIS DE DECISION
*/

*>>>>CANCELACION DE LOS RECIBOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

	  nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
	  nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

**********IMPRESION DE LA LINEA DE ESTADO
	    nNroReg++
	    LineaEstado('REFERENCIA: '+TRA->cCodigoEst+;
			STR(nMesIniTtr,2)+;
			STR(nMesFinTtr,2)+;
			'ºREGISTRO: '+STR(nNroReg,5)+'/'+;
			  STR(nTotReg,5),cNomSis)
**********IMPRESION DE LA LINEA DE ESTADO

**********MOTIVO DE LA TRANSACION
	    cCodMtv := ''
	    IF !EMPTY(BAN->nPosJorBan)
	       cCodMtv := ALLTRIM(SUBS(TRA->Registro,;
				  BAN->nMotivoBan,BAN->nLenMtvBan))
	    ENDIF
**********FIN MOTIVO DE LA TRANSACION

**********ANALISIS DE LOS PAGOS A PROCESAR
	    cCodRef := SUBS(TRA->cCodRefTra+;
			    SPACE(BAN->nLenRefBan),1,BAN->nLenRefBan)

	    nCodPag := 0
	    DO CASE
	    CASE LEN(cCodRef) == BAN->nLenRefBan .AND.;
		 nMesIniTtr == 13

		 nCodPag := 1  // Pago de Matricula

	    CASE LEN(cCodRef) == BAN->nLenRefBan .AND.;
		 TRA->cCodFacCar == cCodFac .AND.;
		 (nMesIniTtr >= 1 .AND. nMesIniTtr <= 12) .AND.;
		 (nMesFinTtr >= 1 .AND. nMesFinTtr <= 12)

		 nCodPag := 2  // Pago de Servicios Educativos

	    CASE LEN(cCodRef) == BAN->nLenRefBan .AND.;
		 nMesIniTtr == 14 .AND.;
		 nMesFinTtr >= 1  .AND.;
		 nMesFinTtr <= 12
		 ObservTra(lShared,'ABONO')

	    OTHERWISE

*----------------LOCALIZACION DE CONSIGNACIONES POR OTROS CONCEPTOS
		   SELECT CMV
		   CMV->(DBGOTOP())
		   LOCATE FOR ALLTRIM(SUBS(CMV->cCodRefTra,1,;
			      BAN->nLenRefBan)) == ALLTRIM(cCodRef)
		   IF FOUND()
		      ObservTra(lShared,LOWER(CMV->cNombreCmv))
		   ELSE
		      LOCATE FOR ALLTRIM(CMV->cMotivoTra) == ALLTRIM(cCodMtv)
		      IF FOUND()
			 ObservTra(lShared,CMV->cNombreCmv)
		      ELSE
			 ObservTra(lShared,'?')
		      ENDIF
		   ENDIF
*----------------LOCALIZACION DE CONSIGNACIONES POR OTROS CONCEPTOS

*----------------GRABACION DEL CONCEPTO DEL MOVIMIENTO
		   IF TRA->nCodigoCmv == 0
		      IF TRA->(lRegLock(lShared,.F.))

			 REPL TRA->nCodigoCmv WITH nCodigoCmv(MONTH(TRA->dFechaTra),;
							      cCodRef,;
							      BAN->nLenRefBan,;
							      ,,cCodMtv)

			 TRA->(DBCOMMIT())
		      ELSE
			 cError('NO SE GRABA EL REGISTRO')
		      ENDIF
		      IF lShared
			 TRA->(DBUNLOCK())
		      ENDIF
		   ENDIF
*----------------FIN GRABACION DEL CONCEPTO DEL MOVIMIENTO

	    ENDCASE
	    SELECT TRA
	    IF nCodPag == 0
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE LOS PAGOS A PROCESAR

**********PROCESAMIENTO DE LOS CODIGOS DE PAGO
	    DO CASE
	    CASE nCodPag == 1  // Matr¡cula
		 CodPag01(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,;
			  cMaeAct,cNroMes,oBrowse,cModem ,cSavPan,;
			  @nNroFil,aNroCol,cCodFac)

	    CASE nCodPag == 2  // Recibos
		 CodPag02(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,;
			  cMaeAct,cNroMes,oBrowse,cModem ,cSavPan,;
			  @nNroFil,aNroCol,cCodFac)
	    ENDCASE
**********FIN PROCESAMIENTO DE LOS CODIGOS DE PAGO

**********CONTROL DE LA FILA DE VISUALIZACION
	    IF nNroFil > 20

*--------------VISUALIZACION DEL ULTIMO CLIENTE
		 nNroFil := nMarco(nFilPal+1)
		 @ nNroFil-2,01 SAY cCabeza
		 nNroFil++
*--------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	    ENDIF
**********FIN CONTROL DE LA FILA DE VISUALIZACION

	  SELECT TRA
	  TRA->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN CANCELACION DE LOS RECIBOS

/*************************************************************************
* TITULO ..: CANCELACION DE LOS RECIBOS DE MATRICULA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2000 MAR A
       Colombia, Bucaramanga        INICIO: 03:50 PM   NOV 28/2000 MAR

OBJETIVOS:

1- Cancela los recibos de pago de la matr¡cula

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CodPag01(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cNroMes,oBrowse,cModem,cSavPan,nNroFil,aNroCol,cCodFac)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cSavPan                              // Salvar Pantalla
       nNroFil                              // N£mero de la Fila
       aNroCol                              // Numeros de Columna
       cCodFac                              // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL       i := 0                   // Contador
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL aRegAct := {}                  // Registro Actual
       LOCAL nMesFin := 0                   // Mes Final de la Matr¡cula
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL nSdoActTcl := 0                // Saldo del cliente
       LOCAL nSdoMorTcl := 0                // Saldo de la mora
       LOCAL cEstadoTpa := ''               // Forma de pago

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION O BUSQUEDA DEL ESTUDIANTE
       cMaeAct := 'ADM'
       IF !lLocCodigo('cCodigoEst','ADM',TRA->cCodigoEst)
	  IF !lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	     RETURN NIL
	  ENDIF
       ENDIF
       ObservTra(lShared,'MATRICULA')
       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
		     RTRIM(&cMaeAct->cNombreEst)
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
*>>>>FIN LOCALIZACION O BUSQUEDA DEL ESTUDIANTE

*>>>>LOCALIZACION DEL PAGO
       nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
       nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

       nMesFin := nMesFinTtr
       SELECT PMT
       GO TOP
       LOCATE FOR PMT->cCodigoEst == TRA->cCodigoEst .AND.;
		  PMT->nMesIniPag == 13              .AND.;
		  PMT->nMesFinPag == nMesFin         .AND.;
		  PMT->cMatricPag == '1'

       IF .NOT. FOUND()

	  ObservTra(lShared,'No se le genero recibo de MATRICULA')

	  cError('NO SE LE GENERO RECIBO DE MATRICULA A '+cNombreTes+;
		 'CODIGO: '+TRA->cCodigoEst)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO

/*
*>>>>LOCALIZACION DEL PAGO
       IF !lSekCodigo(TRA->cCodigoEst+'1','PMT')

	  ObservTra(lShared,'NO SE LE GENERO RECIBO DE MATRICULA')

	  cError('NO SE LE GENERO RECIBO DE MATRICULA A '+cNombreTes+;
		 'CODIGO: '+TRA->cCodigoEst)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO
*/

*>>>>ANALISIS DEL PAGO
       nVlrTra := 0
       aRegAct := {}
       DO WHILE PMT->cCodigoEst == TRA->cCodigoEst .AND.;
		nMesIniTtr == 13 .AND. nMesFinTtr == nMesFin

	  nVlrTra += TRA->nValorTra
	  AADD(aRegAct,TRA->(RECNO()))
	  TRA->(DBSKIP())

       ENDDO
       IF EMPTY(aRegAct)
	  cError('EN EL VECTOR DE LOS PAGOS')
	  IF !lPregunta('DESEA CONTINUAR? No Si')

	     RETURN NIL
	  ENDIF
       ENDIF
       SELECT TRA
       GO aRegAct[1]
*>>>>FIN ANALISIS DEL PAGO

*>>>>CALCULO DE LOS INTERESES
       IF PMT->lIntPenPag
	  nVlrInt := ROUND((ABS(PMT->nVlrMesPag)*PMT->nIntmorPag)/100,0)
       ELSE
	  nVlrInt := PMT->nVlrMorPag
       ENDIF
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DEL PAGO DEL RECIBO
       nForPag := 3
       IF TRA->dFechaTra > PMT->dPagOpoPag
	  IF nVlrTra == PMT->nVlrPagPag+nVlrInt
	     nForPag := 2
	  ENDIF
       ELSE
	  IF nVlrTra == PMT->nVlrPagPag
	     nForPag := 1
	  ENDIF
       ENDIF
      *1<PAGO OPO> 2<PAG EXT> 3<NO PAGO>
*>>>>FIN ANALISIS DEL PAGO DEL RECIBO

*>>>>LOCALIZACION DEL TIPO DE MOVIMIENTO
       IF !lLocCodigo('cCodigoTra','TMV',TRA->cCodigoTra)

	  ObservTra(lShared,'No Existe la Transaci¢n '+TMV->cCodigoTra)
	  cError('NO EXISTE LA TRANSACION '+TMV->cCodigoTra)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL TIPO DE MOVIMIENTO

*>>>>VALIDACION FINAL
       lHayErr := .T.
       DO CASE
       CASE nForPag # 3 .AND. !TMV->lSumarTra

	    ObservTra(lShared,'* '+ALLTRIM(TMV->cNombreTmv))
	    cError(ALLTRIM(TMV->cNombreTmv))

       CASE PMT->nVlrpagPag == 0
	    ObservTra(lShared,'No Tuvo que Cancelar Ning£n Valor')

       CASE nForPag == 3
	    IF EMPTY(TRA->nValidaTra)
	       ObservTra(lShared,'* NO le Coincide el Valor Pagado')
	       cError('NO LE COINCIDE EL VALOR PAGADO')
	    ENDIF
       OTHERWISE
	   lHayErr := .F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION FINAL

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE nForPag       == 1
	     cEstadoTpa := 'PAGO OPO'
	     cForPag      := 'P'

       CASE nForPag       == 2
	     cEstadoTpa := 'PAGO EXT'
	     cForPag      := 'A'
       ENDCASE
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

*>>>>GRABACION DE LA FORMA DE PAGO
       SELECT PMT
       IF PMT->(lRegLock(lSiRed,.F.))
	  REPL PMT->dFecPagPag WITH TRA->dFechaTra
	  REPL PMT->cEstadoPag WITH cForPag
	  REPL PMT->cNomUsrPag WITH BAN->cCodigoBan+'BANCO'
	  REPL PMT->dFecUsrPag WITH DATE()
	  REPL PMT->cHorUsrPag WITH TIME()
       ELSE
	  cError('NO SE GRABA LA FORMA DE PAGO')
       ENDIF
*>>>>FIN GRABACION DE LA FORMA DE PAGO

*>>>>GRABACION DE LA VALIDACION DEL REGISTRO
       SELECT TRA
       FOR i := 1 TO LEN(aRegAct)
	   GO aRegAct[i]
	   IF TRA->(lRegLock(lShared,.F.))
	      IF TRA->nValidaTra < 100
		 REPL TRA->nValidaTra WITH ++TRA->nValidaTra
	      ENDIF
	   ELSE
	      cError('NO SE GRABA LA FORMA DE PAGO')
	   ENDIF
       ENDFOR
       GO aRegAct[1]
      *Registro Actual
*>>>>FIN GRABACION DE LA VALIDACION DEL REGISTRO

*>>>>IMPRESION DE LOS DETALLES DEL PAGO
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
       @ nNroFil,aNroCol[1] SAY PMT->cCodigoEst
       @ nNroFil,aNroCol[2] SAY cNombreTes
       @ nNroFil,aNroCol[3] SAY 'MATRICULA'
       @ nNroFil,aNroCol[4] SAY PMT->nVlrPagPag+;
			    IF(cForPag == 'A',nVlrInt,0) PICT "$###,###.99"
       @ nNroFil,aNroCol[5] SAY nVlrTra                  PICT "$###,###.99"
       SET COLOR TO I
       @ nNroFil,aNroCol[6] SAY cEstadoTpa
       SET COLOR TO
       nNroFil++
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DETALLES DEL PAGO

/*************************************************************************
* TITULO ..: CANCELACION DE LOS RECIBOS DE PAGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2000 MAR A
       Colombia, Bucaramanga        INICIO: 10:20 AM   NOV 28/2000 MAR

OBJETIVOS:

1- Cancela los recibos de pago por los servicios educativos

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CodPag02(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cNroMes,oBrowse,cModem,cSavPan,nNroFil,aNroCol,cCodFac)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cSavPan                              // Salvar Pantalla
       nNroFil                              // N£mero de la Fila
       aNroCol                              // Numeros de Columna
       cCodFac                              // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL       i := 0                   // Contador
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL aRegAct := {}                  // Registro Actual
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo

       LOCAL nNroPos := 0                   // N£mero de posici¢n del concepto
       LOCAL nMesFin := 0                   // Mes Final del Pago
       LOCAL nMesUlt := 0                   // Mes Ultimo de Facturaci¢n

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL nSdoActTcl := 0                // Saldo del cliente
       LOCAL nSdoMorTcl := 0                // Saldo de la mora
       LOCAL nSdoAnoTcl := 0                // Saldo A¤o Anterior
       LOCAL nMorAnoTcl := 0                // Mora A¤o Anterior
       LOCAL cEstadoTpa := ''               // Forma de pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION ITEM DEL PAZ Y SALVO
       nCodPaz := 0
       IF lLocCodigo('nNroTipPaz','PAZ',1)
	  nCodPaz := PAZ->nCodigoPaz
       ENDIF
       IF EMPTY(nCodPaz)
	  cError('NO ESTA HABILITADO EL ITEM DE LOS PAZ Y SALVOS')
       ENDIF
*>>>>FIN LOCALIZACION ITEM DEL PAZ Y SALVO

*>>>>BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
       IF !lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	  RETURN NIL
       ENDIF
       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
		     RTRIM(&cMaeAct->cNombreEst)
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
       cCodigoTgr := &cMaeAct->cCodigoGru
*>>>>FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

*>>>>ANALISIS DEL RECIBO DE PAGO
       nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
       nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

       IF nMesIniTtr == nMesFinTtr
	  ObservTra(lShared,'RECIBO DE '+cMes(nMesIniTtr,3))
       ELSE
	  ObservTra(lShared,'RECIBO DE '+cMes(nMesIniTtr,3)+;
		    ' A '+cMes(nMesFinTtr,3))

       ENDIF
*>>>>FIN ANALISIS DEL RECIBO DE PAGO

*>>>>PREPARACION DE LAS VARIABLES DE ARCHIVO
       FileCli := cPatSis+'\CLIENTES\CL'+;
		  cCodigoTgr+cAnoSis+ExtFile

       FilePag := cPatSis+'\PAGOS\PA'+;
		  cCodigoTgr+cAnoSis+ExtFile
*>>>>FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CLI->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLIENTES GRABADOS')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN PAGOS REGISTRADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION EN CLIENTES
       IF !lLocCodigo('cCodigoEst','CLI',TRA->cCodigoEst)

	  ObservTra(lShared,'OJO NO Existe en los Clientes del Grupo: '+;
		   cCodigoTgr)

	  cError(cNombreTes+' NO EXISTE EN LOS '+;
		 'CLIENTES DEL GRUPO: '+cCodigoTgr)

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION EN CLIENTES


*>>>>VALIDACION DEL MES ACTUAL
       nMesUlt := nMesUltPag(TRA->cCodigoEst)

       IF nMesIniTtr # nMesUlt .AND.;
	  nMesIniTtr == nMesFinTtr

	  ObservTra(lShared,'! PAGO '+cMes(nMesIniTtr)+' '+;
		    'EN EL MES DE '+cMes(VAL(cNroMes)))

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES ACTUAL

*>>>>LOCALIZACION DEL PAGO
       IF !lLocCodPag(TRA->cCodigoEst,nMesIniTtr,.F.)

	  ObservTra(lShared,'! No se le Genero Recibo de Pago')

	  cError('NO SE LE GENERO RECIBO DE '+cMes(nMesIniTtr),;
		  cNombreTes,'CODIGO: '+TRA->cCodigoEst)

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO


*>>>>ANALISIS DEL PAGO
       nVlrTra := 0
       aRegAct := {}
       DO WHILE CLI->cCodigoEst == TRA->cCodigoEst .AND.;
		TRA->cCodFacCar == cCodFac .AND.;
		!(nMesIniTtr < 1 .OR. nMesIniTtr > 12  .OR.;
		  nMesFinTtr < 1 .OR. nMesFinTtr > 12)

	  nVlrTra += TRA->nValorTra
	  AADD(aRegAct,TRA->(RECNO()))
	  TRA->(DBSKIP())

       ENDDO
       IF EMPTY(aRegAct)
	  cError('EN EL VECTOR DE LOS PAGOS')
	  IF !lPregunta('DESEA CONTINUAR? No Si')
	     CloseDbf('CLI',FileCli,nModCry)
	     CloseDbf('PAG',FilePag,nModCry)

	     RETURN NIL
	  ENDIF
       ENDIF
       SELECT TRA
       GO aRegAct[1]
*>>>>FIN ANALISIS DEL PAGO

*>>>>CALCULO DE LOS INTERESES
       nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
			     PAG->nMesIniPag,;
			     CAA->nMesAmnCaA)
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DEL PAGO DEL RECIBO
       nForPag := 3
       IF TRA->dFechaTra > PAG->dPagOpoPag
	  IF nVlrTra == PAG->nVlrPagPag+nVlrInt
	     nForPag := 2
	  ENDIF
       ELSE
	  IF nVlrTra == PAG->nVlrPagPag
	     nForPag := 1
	  ENDIF
       ENDIF
      *1<PAGO OPO> 2<PAG EXT> 3<NO PAGO>
*>>>>FIN ANALISIS DEL PAGO DEL RECIBO

*>>>>LOCALIZACION DEL TIPO DE MOVIMIENTO
       IF !lLocCodigo('cCodigoTra','TMV',TRA->cCodigoTra)

	  ObservTra(lShared,'! No Existe la Trnasaci¢n '+TMV->cCodigoTra)
	  cError('NO EXISTE LA TRANSACION '+TMV->cCodigoTra)

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL TIPO DE MOVIMIENTO

*>>>>VALIDACION FINAL
       lHayErr := .T.
       DO CASE
       CASE nForPag # 3 .AND. !TMV->lSumarTra

	    ObservTra(lShared,'* '+ALLTRIM(TMV->cNombreTmv))
	    cError(ALLTRIM(TMV->cNombreTmv))

       CASE CLI->nSdoactCli == 0 .AND. '*' $ CLI->cMespagCli
	    ObservTra(lShared,'No se Facturo Despu‚s de la Correci¢n')

       CASE PAG->nVlrpagPag == 0
	    ObservTra(lShared,'NO Tuvo que Cancelar Ning£n Valor')

       CASE nForPag == 3
	    IF EMPTY(TRA->nValidaTra)
	       ObservTra(lShared,'* NO le Coincide el Valor Pagado')
	       cError('NO LE COINCIDE EL VALOR PAGADO')
	    ENDIF
       OTHERWISE
	   lHayErr := .F.
       ENDCASE
       IF lHayErr

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION FINAL

*>>>>ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO
       IF nForPag == 1 .OR. nForPag == 2  // Pago el recibo
	  nSdoAnoTcl := 0
	  nMorAnoTcl := 0
	  nSdoActTcl := 0
	  nSdoMorTcl := 0
       ENDIF
*>>>>FIN ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE nForPag       == 1
	     cEstadoTpa := 'PAGO OPO'
	     cForPag      := 'P'

       CASE nForPag       == 2
	     cEstadoTpa := 'PAGO EXT'
	     cForPag      := 'A'
       ENDCASE
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

*>>>>GRABACION DE LA FORMA DE PAGO
       IF PAG->(lRegLock(lShared,.F.))
	  REPL PAG->dFecPagPag WITH TRA->dFechaTra
	  REPL PAG->cEstadoPag WITH cForPag
	  REPL PAG->cCodigoBan WITH BAN->cCodigoBan
	  REPL PAG->cNomUsrPag WITH BAN->cCodigoBan+'BANCO'
	  REPL PAG->dFecUsrPag WITH DATE()
	  REPL PAG->cHorUsrPag WITH TIME()
       ELSE
	  cError('NO SE GRABA LA FORMA DE PAGO')
       ENDIF
*>>>>FIN GRABACION DE LA FORMA DE PAGO

*>>>>GRABACION DE LA FORMA DE PAGO
       cMesPagCoE(lShared,;
		  CLI->cCodigoEst,;
		  ALLTRIM(PAG->cConSdoPag)+;
		  ALLTRIM(PAG->cConcepPag),;
		  PAG->nMesIniPag,;
		  PAG->cIniFinPag,;
		  cForPag)
*>>>>FIN GRABACION DE LA FORMA DE PAGO

*>>>>MES FINAL FACTURACION POR CONCEPTOS
       nMesFin := PAG->nMesFinPag
       nNroPos := AT('PE',PAG->cConcepPag)
       IF nNroPos # 0 .AND. !EMPTY(PAG->cIniFinPag)

	  nNroPos := ((nNroPos+1)/2)+1
	 *Posici¢n mes final
	  nMesFin := VAL(SUBS(PAG->cIniFinPag,nNroPos*2-1,2))

       ENDIF
*>>>>FIN MES FINAL FACTURACION POR CONCEPTOS

*>>>>GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES
       IF CLI->(lRegLock(lShared,.F.))

	  REPL CLI->nSdoAnoCli WITH nSdoAnoTcl
	  REPL CLI->nMorAnoCli WITH nMorAnoTcl

	  REPL CLI->nSdoActCli WITH nSdoActTcl
	  REPL CLI->nSdoMorCli WITH nSdoMorTcl

	  IF nForPag == 1 .OR. nForPag == 2

	       FOR i := PAG->nMesIniPag TO nMesFin
		   REPL CLI->cMesPagCli;
			WITH STUFF(CLI->cMesPagCli,i,1,cForPag)
	       NEXT
	      *Graba control de meses pagados

	       IF CLI->nSdoActCli+CLI->nSdoMorCli == 0
		  REPL CLI->cConSdoCli WITH ''
	       ELSE
		  IF EMPTY(PAG->cConcepPag)
		     REPL CLI->cConSdoCli WITH PAG->cConSdoPag
		  ELSE
		     REPL CLI->cConSdoCli WITH PAG->cConcepPag
		  ENDIF
	       ENDIF
	     *ÀGrabaci¢n de los conceptos del saldo

	  ENDIF
       ELSE
	  cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
       ENDIF
*>>>>FIN GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES

*>>>>GRABACION DE LA VALIDACION DEL REGISTRO
       SELECT TRA
       FOR i := 1 TO LEN(aRegAct)
	   GO aRegAct[i]
	   IF TRA->(lRegLock(lShared,.F.))
	      IF TRA->nValidaTra < 100
		 REPL TRA->nValidaTra WITH ++TRA->nValidaTra
	      ENDIF
	   ELSE
	      cError('NO SE GRABA LA FORMA DE PAGO')
	   ENDIF
       ENDFOR
       GO aRegAct[1]
      *Registro Actual
*>>>>FIN GRABACION DE LA VALIDACION DEL REGISTRO

*>>>>GRABACION DEL PAZ Y SALVO
       IF nCodPaz # 0
	  SELECT &cMaeAct
	  IF lRegLock(lShared,.F.)
	     cCampos := cMaeAct+'->cPazSdoEst'
	     REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,SPACE(01))
	     DBCOMMIT()
	  ELSE
	     cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	  ENDIF
	  IF lShared
	     DBUNLOCK()
	  ENDIF
       ENDIF
*>>>>FIN GRABACION DEL PAZ Y SALVO

*>>>>IMPRESION DE LOS DETALLES DEL PAGO
       SELECT TRA
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
       @ nNroFil,aNroCol[1] SAY CLI->cCodigoEst
       @ nNroFil,aNroCol[2] SAY cNombreTes
       @ nNroFil,aNroCol[3] SAY CLI->nSdoactCli          PICT "9999,999.99"
       @ nNroFil,aNroCol[4] SAY PAG->nVlrPagPag+;
			    IF(cForPag == 'A',nVlrInt,0) PICT "$###,###.99"
       @ nNroFil,aNroCol[5] SAY nVlrTra                  PICT "$###,###.99"
       SET COLOR TO I
       @ nNroFil,aNroCol[6] SAY cEstadoTpa
       SET COLOR TO

       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       nNroFil++
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DETALLES DEL PAGO
