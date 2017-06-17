/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 11                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/97 LUN A
       Colombia, Bucaramanga        INICIO: 12:05 PM   FEB 16/97 LUN

OBJETIVOS:

1- Recibo No. 11 dise¤o para el Colegio de las Bethlemitas de Barranca

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de un formato preimpreso que dise¤o el colegio con el logo de ISO y
   que disminuye la cantidad de conceptos facturados.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCarRec11(aP1,aP2,aP3,;
		   nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,nMesIni,nMesFin,lPrnGru,;
		   nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,nVlrCo5,nVlrCo6,;
		   nVlrCo7,nVlrCo8,lHayBec,nVlrBec,nDescue,nPagPar,;
		   nRecarg,nDesGen,nRecGen,cConGen,nFavDes,nSdoFav)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       nNroLis                              // N£mero de lista
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // @Valor recibo para un mes
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrePrn                              // .T. Forma Pre Impresa
       lPrnGru                              // .T. Impresi¢n por grupos
       nVlrCo1                              // @Valor Concepto No. 1
       nVlrCo2                              // @Valor Concepto No. 2
       nVlrCo3                              // @Valor Concepto No. 3
       nVlrCo4                              // @Valor Concepto No. 4
       nVlrCo5                              // @Valor Concepto No. 5
       nVlrCo6                              // @Valor Concepto No. 6
       nVlrCo7                              // @Valor Concepto No. 7
       nVlrCo8                              // @Valor Concepto No. 8
       lHayBec                              // @.T. Se aplico la Beca
       nVlrBec                              // @Valor de la Beca
       nDescue                              // @Valor del Descuento
       nPagPar                              // @Pago Parcial
       nRecarg                              // @Valor del Recargo
       nDesGen                              // @Descuento General
       nRecGen                              // @Recargo General
       cConGen                              // @Concepto General
       nFavDes                              // @Saldo a Favor a Descontar
       nSdoFav                              // Saldo a Favor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #DEFINE AVANCES2 CHR(27)+'J'+CHR(110)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nVlrPen := 0                   // Valor de la pension
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL lDesGen := .F.                 // .T. Hay Descuento General
       LOCAL lHayDes := .F.                 // .T. Hay Descuentos
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nTipDes := 0                   // Tipo de descuento

       LOCAL nPorBec := 0                   // Porcentaje de la beca
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL nNroCop := 0                   // N£mero de Copias
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nSdoAno := 0                   // A¤o Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
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
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SET FIXED OFF
       IF SCO->lHayNroCon
	  IF SCO->nNroFacCon >= 999999999
	     SET DEVICE TO SCREEN
	     cError('SE EXCEDIO EL LIMITE DE LA FACTURACION')
	     SET DEVICE TO PRINT
	     SET FIXED ON
	     RETURN 'C'
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA FACTURACION

*>>>>ASIGNACION DEL NUMERO DE LA FACTURA
       IF SCO->lHayNroCon
	  nNroFac := SCO->nNroFacCon+1
	  cNroFac := STR(nNroFac,9)
	  lCorrecion(@cNroFac,.T.)
	  cNroFac := SCO->cCodEmpCon+'-'+cNroFac
	 *Lectura del n£mero de la factura
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>AVANCE DE LINEAS
      SETPRC(0,0)
      nNroLen := 69
      SendCodes(AVANCES2)
      nAvance := 0
      nAvance := 4
*>>>>FIN AVANCE DE LINEAS

*>>>>IMPRESION DEL NOMBRE Y CURSO
       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(50),1,50)

       cMsgTxt := cNomEst+SPACE(01)+;
		  cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		  SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       @ PROW()+nAvance,02    SAY cMsgTxt
       @ PROW(),nNroLen       SAY cMsgTxt
       @ PROW(),(nNroLen*2)-2 SAY cMsgTxt
       Linea_Recibo(SPACE(15)+cNomBan,1,nNroLen)
*>>>>FIN IMPRESION DEL NOMBRE Y CURSO

*>>>>IMPRESION DE LOS DATOS DEL ESTUDIANTE
       cMesIni := STR(nMesIni,2)
       cMesFin := IF(nMesFin == NIL,cMesIni,STR(nMesFin,2))
       lCorrecion(@cMesIni)
       lCorrecion(@cMesFin)

       IF !EMPTY(BAN->nDigVerBan)
	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+cMesIni+cMesFin+;
		     EVAL(bDigChe,cCodEst+cMesIni+cMesFin)
       ELSE
	  cCodFac := cCodEst+cMesIni+cMesFin+SPACE(02)
       ENDIF
     *ÀCalculo del digito de Chequeo

       Linea_Recibo(cCodFac+SPACE(03)+;
		    cCtaBan+;
		    SPACE(02)+;
		    DTOC(DATE())+;
		    SPACE(02)+;
		    cMes(nMesIni,3)+'-'+;
		    IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3)),;
		    1,nNroLen)
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS GENERALES
       nVlrDes := 0
       nTipDes := 0

       lDesGen := .F.
       nDesGen := 0
       nRecGen := 0
       cConGen := ''

IF nNroLis # 0
       IF SUBS(CLI->cHayNovCli,nMesIni,1) = '1'

	  cConGen := CAA->cConGenCaA
	  DO CASE
	  CASE CAA->nDesGenCaA # 0 .AND. CAA->nRecGenCaA == 0

	       lDesGen := .T.
	       nDesGen := CAA->nDesGenCaA
	       nRecGen := 0

	       lHayDes := .T.
	       nVlrDes := nDesGen
	       nTipDes := 1

	  CASE CAA->nDesGenCaA == 0 .AND. CAA->nRecGenCaA # 0

	       lDesGen := .T.
	       nDesGen := 0
	       nRecGen := CAA->nRecGenCaA

	       lHayDes := .T.
	       nVlrDes := nRecGen
	       nTipDes := 2
	  ENDCASE

       ENDIF
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS GENERALES

*>>>>ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS
       nDescue := 0
       nPagPar := 0
       nRecarg := 0

IF nNroLis # 0
       lHayDes := lSekCodDes(cCodEst,nMesIni,.F.)
       IF lHayDes

	  nVlrDes := DES->nValorDes
	  nTipDes := DES->nTipDesDes

	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4

	       IF nTipDes == 1
		  nDescue := DES->nValorDes
	       ELSE
		  nPagPar := DES->nValorDes
	       ENDIF
	       nRecarg := 0

	       DO CASE
	       CASE nDesGen # 0
		    nVlrDes := nVlrDes + nDesGen
	       CASE nRecGen # 0
		    nVlrDes := nVlrDes - nRecGen
	       ENDCASE
	     *ÀAplicaci¢n de descuentos o recargos generales

	  CASE nTipDes == 2

	       nDescue := 0
	       nRecarg := DES->nValorDes

	       DO CASE
	       CASE nDesGen # 0
		    nVlrDes := nVlrDes - nDesGen
	       CASE nRecGen # 0
		    nVlrDes := nVlrDes + nRecGen
	       ENDCASE
	     *ÀAplicaci¢n de descuentos o recargos generales

	  ENDCASE
       ELSE
	  lHayDes := lDesGen
       ENDIF
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS

*>>>>ANALISIS SI EL ESTUDIANTE TIENE BECA
       nPorBec := 0
       nVlrBec := 0
IF nNroLis # 0
       lHayBec := lTieneBeca(nMesIni,IF(nMesFin == NIL,nMesIni,nMesFin))
       IF lHayBec
	  nPorBec := CLI->nPorBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       SendCodes(CHR(27)+'J'+CHR(60))
      *Avance de L¡neas a 1/216

IF nNroLis # 0
       nSdoAct := CLI->nSdoActCli+CLI->nSdoMorCli
       nSdoAno := CLI->nSdoAnoCli+CLI->nMorAnoCli
ENDIF

       IF !lPorAde

**********IMPRESION DEL DESCUENTO O DEL RECARGO
	    IF lHayDes

	       DO CASE
	       CASE nTipDes == 1 .OR. nTipDes == 4
		    IF nTipDes == 1
		       cMsgTxt := 'DESCUENTO'
		    ELSE
		       cMsgTxt := 'P PARCIAL'
		    ENDIF
	       CASE nTipDes == 2
		    cMsgTxt := 'RECARGO  '
	       ENDCASE

	       cMsgTxt += SPACE(21)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)

IF nNroLis # 0
	    nVlrMes := nConRec11(nMesIni,nMesIni,cCodGru,cConcep,;
				 nSdoAct,nSdoAno,NIL,lHayDes,nNroLen,;
				 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,@nVlrBec,nNroLis)
	   *Impresi¢n de conceptos
ELSE
    nVlrMes := nConRec11(nMesIni,nMesIni,cCodGru,cConcep,;
			 0,0,NIL,;
			 lHayDes,nNroLen,@nVlrCo1,@nVlrCo2,;
			 @nVlrCo3,@nVlrCo4,@nVlrCo5,@nVlrCo6,;
			 @nVlrCo7,@nVlrCo8,@lHayBec,@nVlrBec,nNroLis)
   *Impresi¢n de conceptos
    lHayBec := .F.
    nVlrBec := 0
ENDIF

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF

IF nNroLis # 0
	    nVlrTot := nVlrMes+;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
ELSE
   nVlrTot := nVlrMes
ENDIF
**********FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

       ENDIF
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION PARTE DEL RECIBO POR ADELANTADO
       IF lPorAde

**********IMPRESION DEL DESCUENTO O DEL RECARGO
	    IF lHayDes

	       DO CASE
	       CASE nTipDes == 1 .OR. nTipDes == 4
		    IF nTipDes == 1
		       cMsgTxt := 'DESCUENTO'
		    ELSE
		       cMsgTxt := 'P PARCIAL'
		    ENDIF
	       CASE nTipDes == 2
		    cMsgTxt := 'RECARGO  '
	       ENDCASE
	       cMsgTxt += SPACE(33)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)
	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nConRec11(nMesIni,nMesFin,cCodGru,cConcep,;
				 nSdoAct,nSdoAno,@nVlrPen,lHayDes,nNroLen,;
				 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,nNroLis)
	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********REALIZACION DEL DESCUENTO POR BECA
	    nVlrTot := nVlrMes * (nMesFin - nMesIni + 1) +;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
	   *Total del Recibo sin descuentos y sin becas

	    IF lHayBec

	       IF !EMPTY(CLI->nPorBecCli)
		  nVlrBec := ROUND((nVlrPen * nPorBec)/100,0)
	       ELSE
		  nVlrBec := CLI->nVlrBecCli
	       ENDIF
	     *ÀC lculo del valor de beca para un mes

	       IF lTieneBeca(nMesIni,nMesIni)
		  nVlrMes -= nVlrBec
		  nVlrCo1 := nVlrPen
	       ENDIF
	      *Descuento de la beca para el primer mes

	       nVlrBec := nVlrBec * nNroBecas(nMesIni,nMesFin)
	      *Valor total de las becas

	       nVlrTot -= nVlrBec
	      *Descuento por becas

	    ENDIF
**********FIN REALIZACION DEL DESCUENTO POR BECA

       ENDIF
*>>>>IMPRESION PARTE DEL RECIBO POR ADELANTADO

*>>>>REALIZACION DEL DESCUENTO O RECARGO
       nVlrPag := nVlrMes
       IF lHayDes
	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4
	     nVlrTot := ROUND(nVlrTot - nVlrDes,0)
	     nVlrPag := ROUND(nVlrMes - nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes - nVlrDes,0)
	  CASE nTipDes == 2
	     nVlrTot := ROUND(nVlrTot + nVlrDes,0)
	     nVlrPag := ROUND(nVlrMes + nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes + nVlrDes,0)
	  ENDCASE
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO O RECARGO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
IF nNroLis # 0
       nVlrTot += CLI->nSdoAnoCli+CLI->nMorAnoCli
ENDIF
       cMsgTxt := SPACE(10)+cFecha(dPagOpo)+SPACE(29)+;
		  TRANSFORM(nVlrTot,"***,***,***")
       Linea_Recibo(cMsgTxt,1,nNroLen)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
	  
*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,;
				CLI->nSdoActCli+CLI->nSdoAnoCli)+;
				ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  cMsgTxt := SPACE(10)+cFecha(dPagExt)+SPACE(29)+;
		     TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
	  Linea_Recibo(cMsgTxt,1,nNroLen)
       ENDIF

       @ PROW()+1,(180-LEN(ALLTRIM(cMensaj)))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       SET FIXED ON
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA

*>>>>GRABACION DEL INCREMENTO DEL NUMERO DEL RECIBO
       IF SCO->lHayNroCon
	  IF SCO->(lRegLock(IF(lShared,lShared,!lShared),.F.))
	     REPL SCO->nNroFacCon WITH SCO->nNroFacCon+1
	     SCO->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO')
	  ENDIF
	  IF lShared
	     SCO->(DBUNLOCK())
	  ENDIF
       ENDIF
*>>>>FIN GRABACION DEL INCREMENTO DEL NUMERO DEL RECIBO

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>GRABACION DEL CONTROL DEL RECIBO
       IF SCO->lHayNroCon
	  SaveRegRec(lShared,cNomUsr,cAnoUsr,;
		     nNroFac,;
		     cCodEst,;
		     nMesIni,;
		     IF(nMesFin == NIL,nMesIni,nMesFin),;
		     nVlrTot+nSdoFav,;
		     IF(nNroCop>1,2,1),;
		     CAA->cCodigoBan,;
		     SCO->cCodEmpCon)

       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO DEL PROGRAMA..: CONCEPTOS A COBRAR No. 02                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/97 LUN A
       Colombia, Bucaramanga        INICIO: 12:05 PM   FEB 16/97 LUN


OBJETIVOS:

1- Debe estar en uso el archivo de conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Imprime los conceptos por cobrar del recibo de pago sencillo o por
   adelantado de acuerdo como se pasen los param‚tros de la funci¢n.

4- Esta funci¢n forma parte del funci¢n nVlrRecibo

5- Retorna El valor total de recibo sin intereses

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nConRec11(nMesIni,nMesFin,cCodGru,cConcep,nSdoAct,;
		   nSdoAno,nVlrPen,lHayDes,nNroLen,nVlrCo1,;
		   nVlrCo2,nVlrCo3,nVlrCo4,nVlrCo5,nVlrCo6,;
		   nVlrCo7,nVlrCo8,lHayBec,nVlrBec,nNroLis)

*>>>>PARAMATROS DE LA FUNCION
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
       nSdoAno                              // Saldo A¤o Anterior + Mora
       nVlrPen                              // @Valor de la pensi¢n (Adelantado)
       lHayDes                              // .T. Hay Descuento
       nNroLen                              // Longitud del Recibo
       nVlrCo1                              // @Valor Concepto No. 1
       nVlrCo2                              // @Valor Concepto No. 2
       nVlrCo3                              // @Valor Concepto No. 3
       nVlrCo4                              // @Valor Concepto No. 4
       nVlrCo5                              // @Valor Concepto No. 5
       nVlrCo6                              // @Valor Concepto No. 6
       nVlrCo7                              // @Valor Concepto No. 7
       nVlrCo8                              // @Valor Concepto No. 8
       lHayBec                              // @.T. Se aplico la Beca
       nVlrBec                              // @Valor de la Beca
       nNroLis                              // N£mero de Lista */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cBlanco := ''                  // Linea en Blanco
       LOCAL nValor  := 0                   // Valor del Concepto para el recibo
       LOCAL nVlrCon := 0                   // Valor del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nTotal  := 0                   // Valor Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nVlrPen == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DE LOS CONCEPTOS
       lHayBec := .F.
       nNroCon := (LEN(cConcep)/2)+IF(lHayDes,0,1)
       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       nSdoAct += nSdoAno
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 3
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       @ PROW()+1,02 SAY ''
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO
	    nVlrCon := 0
	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)
	       nValor := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       nVlrCon := nValor
	       IF nValor == 0
		  RETURN 'Error'
	       ENDIF
	    ENDIF
**********FIN LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO

**********LECTURA DEL VALOR DEL CONCEPTO Y DESCRIPCION PARA SOLO FACTURAR
	    IF nNroLis == 0 .AND. cCodigoTco <> SPACE(02)

	       IF !lLocCodigo('cCodigoCon','CON',cCodigoTco)
		  cNombreTco := 'No Existe Con:'+cCodigoTco
		  nValor := 0
		  RETURN 'Error'
	       ELSE
		  cNombreTco := CON->cNombreCon
		  nValor := CON->nValorCon
		  IF nValor == 0
		     RETURN 'Error'
		  ENDIF
	       ENDIF

	    ENDIF
	    cNombreTco := ALLTRIM(cNombreTco)
**********FIN LECTURA DEL VALOR DEL CONCEPTO Y DESCRIPCION PARA SOLO FACTURAR

**********PREPARACION DEL NOMBRE DEL CONCEPTO
	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)
	       IF CON->lBecadoCon

*-----------------VALOR PENSION PARA DESCONTAR BECA
		    IF lPorAde
		       nVlrPen += nValor
		    ENDIF
*-----------------FIN VALOR PENSION PARA DESCONTAR BECA

*-----------------ANALISIS SI TIENE BECA
		    IF lTieneBeca(nMesIni,nMesFin)

*                      ANALSIS SI PERTENECE AL FONDO
			 lHayBec := .T.
			 IF LEN(cNombreTco) >= 11
			    cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			 ELSE
			    cNombreTco += ' BECA'
			 ENDIF
*                      FIN ANALSIS SI PERTENECE AL FONDO

*                      DESCUENTO POR BECA
			 IF !lPorAde
			    IF !EMPTY(CLI->nPorBecCli)
			       nVlrBec := ROUND((nValor*CLI->nPorBecCli)/100,0)
			    ELSE
			       nVlrBec := CLI->nVlrBecCli
			    ENDIF
			    nValor := nValor-nVlrBec
			 ENDIF
*                      FIN DESCUENTO POR BECA

		    ENDIF
*-----------------FIN ANALISIS SI TIENE BECA

	       ENDIF

	    ENDIF
	    cNombreTco := cNombreTco+SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN PREPARACION DEL NOMBRE DEL CONCEPTO

**********ASIGNACION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       DO CASE
	       CASE i == 1
		    nVlrCo1 := nVlrCon

	       CASE i == 2
		    nVlrCo2 := nVlrCon

	       CASE i == 3
		    nVlrCo3 := nVlrCon

	       CASE i == 4
		    nVlrCo4 := nVlrCon

	       CASE i == 5
		    nVlrCo5 := nVlrCon

	       CASE i == 6
		    nVlrCo6 := nVlrCon

	       CASE i == 7
		    nVlrCo7 := nVlrCon

	       CASE i == 8
		    nVlrCo8 := nVlrCon

	       OTHERWISE
		    RETURN 'Error'
	       ENDCASE
	    ENDIF
**********FIN ASIGNACION DEL VALOR DEL CONCEPTO

**********ACUMULACION DE LOS VALORES A COBRAR CON SALDO
	    IF cCodigoTco <> SPACE(02)
	       IF i = 1
		  nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
				0,nSdoAct)+nValor
		  IF nSdoAno == 0
		     cMsgTxt := cNombreTco+SPACE(14)+;
				IF(CAA->nMesAmnCaA==nMesIni,;
				   'PENDIENTE',;
				   TRANS(nSdoAct,'9,999,999'))+;
				SPACE(03)+;
				TRANS(nValor,'9,999,999')+;
				SPACE(01)+;
				TRANS(nSubTot,'9,999,999')
		  ELSE
		     cMsgTxt := cCodigoTco+'-A¥O ANT'+SPACE(20)+;
				IF(CAA->nMesAmnCaA==nMesIni,;
				   'PENDIENTE',;
				   TRANS(nSdoAct,'9,999,999'))+;
				SPACE(03)+;
				TRANS(nValor,'9,999,999')+;
				SPACE(01)+;
				TRANS(nSubTot,'9,999,999')
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF cCodigoTco <> SPACE(02)
	       IF i <> 1
		  nSubTot := nValor
		  cMsgTxt := cNombreTco+SPACE(14)+;
			     SPACE(09)+;
			     SPACE(03)+;
			     TRANS(nValor,'9,999,999')+;
			     SPACE(01)+;
			     TRANS(nSubTot,'9,999,999')
	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)

	       Linea_Recibo(cMsgTxt,1,nNroLen)

	       nVlrTot := nVlrTot + nSubTot
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

	  i := i + 1

       ENDDO
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES
       IF nSdoAct # 0 .AND. EMPTY(cConcep)
	  nTotal := 0
       ELSE
	  nTotal := nVlrTot-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
       ENDIF
       RETURN nTotal
*>>>>FIN IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES