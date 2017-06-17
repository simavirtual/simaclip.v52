/*                       SIMA - MATRICULA ACADEMICA
	   BIBLIOTECAS DE FUNCIONES PARA LOS RECIBOS DE FACTURACION


REQUERIMIENTOS:

- Compilar: clipper FuncsRec /w/m/b

OBJETIVOS:

- Funciones aplicadas para todos los recibos de facturaci¢n de los
  diferentes colegios.

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: RECIBO DE PAGO No. 01                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
       Colombia, Bucaramanga        INICIO: 05:05 PM   AGO 13/94 SAB

OBJETIVOS:

1- Recibo No. 01 dise¤o para el Colegio la Salle

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo01(aRecFac,lShared,cEmpPal,cNitEmp,cNomEmp,cJorTxt,cCodIso,;
		   nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,nMesIni,nMesFin,lPrePrn,;
		   lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,nVlrCo5,;
		   nVlrCo6,nVlrCo7,nVlrCo8,nVl2Co1,nVl2Co2,nVl2Co3,;
		   nVl2Co4,nVl2Co5,nVl2Co6,nVl2Co7,nVl2Co8,lHayBec,;
		   nVlrBec,nDescue,nPagPar,nRecarg,nDesGen,nRecGen,;
		   cConGen,nFavDes,nSdoFav)

*>>>>DESCRIPCION DE PARAMETROS
/*     aRecFac                              // Recibo Facturado
       lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cJorTxt                              // Jornada escogida
       cCodIso                              // C¢digo del Iso
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
       nVl2Co1                              // @Valor2 Concepto No. 1
       nVl2Co2                              // @Valor2 Concepto No. 2
       nVl2Co3                              // @Valor2 Concepto No. 3
       nVl2Co4                              // @Valor2 Concepto No. 4
       nVl2Co5                              // @Valor2 Concepto No. 5
       nVl2Co6                              // @Valor2 Concepto No. 6
       nVl2Co7                              // @Valor2 Concepto No. 7
       nVl2Co8                              // @Valor2 Concepto No. 8
       lHayBec                              // @.T. Se aplico la Beca
       nVlrBec                              // @Valor de la Beca
       nDescue                              // @Valor del Descuento
       nPagPar                              // @Pago Parcial
       nRecarg                              // @Valor del Recargo
       nDesGen                              // @Descuento General
       nRecGen                              // @Recargo General
       cConGen                              // @Concepto General
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #DEFINE AVANCES1 CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cMeses  := ''                  // Meses de Pago
       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nVlrPen := 0                   // Valor de la pension
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrTo2 := 0                   // Valor Total del recibo del valor2
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL lDesGen := .F.                 // .T. Hay Descuento General
       LOCAL lHayDes := .F.                 // .T. Hay Descuentos
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nTipDes := 0                   // Tipo de descuento

       LOCAL nPorBec := 0                   // Porcentaje de la beca
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL nVl2Mes := 0                   // Valor del mes del valor2

       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       lPrePrn := IF(lPrePrn == NIL,.F.,lPrePrn)
       nNroLen := IF(lPrePrn,74,57)

       IF CAA->lHayNroCaA .AND. !lPrePrn
	  IF CAA->nNroFacCaA >= 999999999999
	     SET DEVICE TO SCREEN
	     cError('SE EXCEDIO EL LIMITE DE LA FACTURACION')
	     SET DEVICE TO PRINT
	     SET FIXED ON
	     RETURN 'C'
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA FACTURACION

*>>>>ASIGNACION DEL NUMERO DE LA FACTURA
       IF CAA->lHayNroCaA .AND. !lPrePrn
	  IF CAA->(lRegLock(lShared,.F.))

	     nNroFac := CAA->nNroFacCaA+1
	    *Lectura del n£mero de la factura

	     cNroFac := STR(nNroFac,8)
	     lCorrecion(@cNroFac,.T.)

	     REPL CAA->nNroFacCaA WITH CAA->nNroFacCaA+1
	     CAA->(DBCOMMIT())
	     IF lShared
		CAA->(DBUNLOCK())
	     ENDIF
	   *ÀGrabaci¢n de n£mero asignado

	  ENDIF
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>IMPRESION DE LA EMPRESA PRINCIPAL Y SU NIT
       IF !lPrePrn
	  @ PROW(),02            SAY cEmpPal+SPACE(02)+cCodIso
	  @ PROW(),nNroLen       SAY cEmpPal+SPACE(02)+cCodIso
	  @ PROW(),(nNroLen*2)-2 SAY cEmpPal+SPACE(02)+cCodIso

	  Linea_Recibo('NIT: '+cNitEmp+SPACE(16)+;
		       IF(CAA->lHayNroCaA,'No. '+PADL(nNroFac,12,'0'),''))
       ENDIF
*>>>>FIN IMPRESION DE LA EMPRESA PRINCIPAL Y SU NIT

*>>>>AVANCE DE LINEAS
      IF lPrePrn
	 nAvance := 4
	 IF lPrnGru
	    SendCodes(AVANCES1)
	    nAvance := 0
	 ENDIF
      ENDIF
*>>>>FIN AVANCE DE LINEAS

*>>>>IMPRESION DEL BANCO
       @ PROW()+IF(lPrePrn,nAvance,1),02;
				   SAY RTRIM(cNomBan)+;
				       IF(lPrePrn,SPACE(36),SPACE(01))+;
				       RTRIM(cCtaBan)
       @ PROW(),nNroLen            SAY RTRIM(cNomBan)+;
				       IF(lPrePrn,SPACE(36),SPACE(01))+;
				       RTRIM(cCtaBan)
       @ PROW(),(nNroLen*2)-2      SAY RTRIM(cNomBan)+;
				       IF(lPrePrn,SPACE(36),SPACE(01))+;
				       RTRIM(cCtaBan)
*>>>>FIN IMPRESION DEL BANCO

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       Linea_Recibo(RTRIM(cNomEmp),IF(lPrePrn,2,1),nNroLen)
*>>>>FIN IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DE LOS DATOS DEL ESTUDIANTE
       IF lPrePrn
	  Linea_Recibo(cNomEst,2,nNroLen)
       ELSE
	  Linea_Recibo('ALUMNO: '+cNomEst)
       ENDIF

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

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))

       IF lPrePrn

	  Linea_Recibo(cCodFac+;
		       SPACE(11)+;
		       cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		       SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)+;
		       SPACE(06)+;
		       cFecha(DATE())+;
		       SPACE(05)+;
		       cMes(nMesIni,3)+'-'+;
		       IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3)),;
		       2,nNroLen)
       ELSE
	  Linea_Recibo('CODIGO: '+cCodEst+cMesIni+cMesFin+SPACE(01)+;
		       'GRUPO:'+cConverNiv(SUBS(cCodGru,1,2))+;
					    SUBS(cCodGru,3,2)+;
		       SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)+;
		       SPACE(01)+'FECHA'+cFecha(DATE()))
       ENDIF
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       IF !lPrePrn
	  cLinea := REPL ('-',48)
	  Linea_Recibo(cLinea)
	*ÀPrimera linea separadora

	  Linea_Recibo('|DESCRIPCION     '+;
		       '| ATRASOS | '+SPACE(02)+;
			IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))+;
			SPACE(02)+;
		      ' |  TOTAL  |')


	  Linea_Recibo(cLinea)
	 *Segunda linea separadora
      ENDIF
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*>>>>ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS GENERALES
       nVlrDes := 0
       nTipDes := 0

       lDesGen := .F.
       nDesGen := 0
       nRecGen := 0
       cConGen := ''

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
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS GENERALES

*>>>>ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS
       nDescue := 0
       nPagPar := 0
       nRecarg := 0

       lHayDes := lSekCodDes(cCodEst,nMesIni,.F.)
       IF lHayDes

	  nVlrDes := DES->nValorDes
	  nTipDes := DES->nTipDesDes

	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS

*>>>>ANALISIS SI EL ESTUDIANTE TIENE BECA
       nPorBec := 0
       nVlrBec := 0
       lHayBec := lTieneBeca(nMesIni,IF(nMesFin == NIL,nMesIni,nMesFin))
       IF lHayBec
	  nPorBec := CLI->nPorBecCli
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      IF lPrePrn
	 @ PROW()+2,02 SAY ''
	*L¡neas de espaciado para la forma preimpresa
      ENDIF
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       IF !lPorAde

**********IMPRESION DEL DESCUENTO O DEL RECARGO
	    IF lHayDes

	       DO CASE
	       CASE nTipDes == 1 .OR. nTipDes == 4
		    IF nTipDes == 1
		       cMsgTxt := IF(lPrePrn,'DESCUENTO','|DESCUENTO')
		    ELSE
		       cMsgTxt := IF(lPrePrn,'P PARCIAL','|P PARCIAL')
		    ENDIF
	       CASE nTipDes == 2
		    cMsgTxt := IF(lPrePrn,'RECARGO  ','|RECARGO  ')
	       ENDCASE

	       IF lPrePrn
		  cMsgTxt += SPACE(49)+TRANS(nVlrDes,'9,999,999')
	       ELSE
		  cMsgTxt += SPACE(07)+'|'+SPACE(09)+'|'+SPACE(09)+'|'+;
			  TRANS(nVlrDes,'9,999,999')   +'|'
	       ENDIF
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
	    nVlrMes := nVlrCon01(aRecFac,nMesIni,nMesIni,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,lPrePrn,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,;
				 @nVl2Co1,@nVl2Co2,@nVl2Co3,@nVl2Co4,;
				 @nVl2Co5,@nVl2Co6,@nVl2Co7,@nVl2Co8,;
				 @nVl2Mes)

	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
			       
	    nVlrTot := nVlrMes+;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)

	    nVlrTo2 := nVl2Mes+;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
**********FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

**********IMPRESION DE LA TERCERA LINEA SEPARADORA
	    IF !lPrePrn
	       @ PROW()+1,02          SAY REPL ('-',18)+' ALUMNO  '+;
					  REPL ('-',21)
	       @ PROW(),nNroLen       SAY REPL ('-',18)+' BANCO   '+;
					  REPL ('-',21)
	       @ PROW(),(nNroLen*2)-2 SAY REPL ('-',18)+' COLEGIO '+;
					  REPL ('-',21)
	    ENDIF
**********FIN IMPRESION DE LA TERCERA LINEA SEPARADORA

       ENDIF
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION PARTE DEL RECIBO POR ADELANTADO
       IF lPorAde

**********IMPRESION DEL DESCUENTO O DEL RECARGO
	    IF lHayDes .AND. lPrePrn

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
	       cMsgTxt += SPACE(49)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon01(aRecFac,nMesIni,nMesFin,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,lPrePrn,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,;
				 @nVl2Co1,@nVl2Co2,@nVl2Co3,@nVl2Co4,;
				 @nVl2Co5,@nVl2Co6,@nVl2Co7,@nVl2Co8,;
				 @nVl2Mes)

	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********IMPRESION DEL SALDO A FAVOR
	    IF !lPrePrn
	       IF nSdoFav # 0
		  cMsgTxt := '|SALDO A FAVOR   |'
		  cMsgTxt += SPACE(09)+'|'+SPACE(09)+'|'+;
			     TRANS(nSdoFav,'*,***,***')+'|'
		  Linea_Recibo(cMsgTxt)
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL SALDO A FAVOR

**********IMPRESION DE MESES COBRADOS
	    IF !lPrePrn
	       cMsgTxt = IF(lPrePrn,'DE ','|DE ')+;
			 cMes(nMesIni,3)+'-'+cMes(nMesFin,3)
	    ENDIF
**********FIN IMPRESION DE MESES COBRADOS

**********IMPRESION DEL DESCUENTO O RECARGO
	    IF !lPrePrn

	       IF lHayDes

		  DO CASE
		  CASE nTipDes == 1 .OR. nTipDes == 4
		       IF nTipDes == 1
			  cMsgTxt += ' DESCU|'
		       ELSE
			  cMsgTxt += ' PAGOP|'
		       ENDIF
		  CASE nTipDes == 2
		       cMsgTxt += ' RECAR|'
		  ENDCASE

		  cMsgTxt += SPACE(09)+'|'+SPACE(09)+'|'+;
			     TRANS(nVlrDes,'*,***,***')+'|'
	       ELSE
		  cMsgTxt += SPACE(06)+'|'
		  cMsgTxt += SPACE(09)+'|'+SPACE(09)+'|'+SPACE(09)+'|'
	       ENDIF
	       Linea_Recibo(cMsgTxt)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O RECARGO

**********IMPRESION DE LA TERCERA LINEA SEPARADORA
	    IF !lPrePrn
	       @ PROW()+1,02          SAY REPL ('-',18)+' ALUMNO  '+;
					  REPL ('-',21)
	       @ PROW(),nNroLen       SAY REPL ('-',18)+' BANCO   '+;
					  REPL ('-',21)
	       @ PROW(),(nNroLen*2)-2 SAY REPL ('-',18)+' COLEGIO '+;
					  REPL ('-',21)
	    ENDIF
**********FIN IMPRESION DE LA TERCERA LINEA SEPARADORA

**********REALIZACION DEL DESCUENTO POR BECA
	    nVlrTot := nVlrMes * (nMesFin - nMesIni + 1) +;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)

	    nVlrTo2 := nVl2Mes * (nMesFin - nMesIni + 1) +;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
	  *ÀTotal del Recibo sin descuentos y sin becas

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
	       nVlrTo2 -= nVlrBec
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
	     nVlrTo2 := ROUND(nVlrTo2 - nVlrDes,0)

	     nVlrPag := ROUND(nVlrMes - nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes - nVlrDes,0)

	  CASE nTipDes == 2

	     nVlrTot := ROUND(nVlrTot + nVlrDes,0)
	     nVlrTo2 := ROUND(nVlrTo2 + nVlrDes,0)

	     nVlrPag := ROUND(nVlrMes + nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes + nVlrDes,0)

	  ENDCASE
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO O RECARGO

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF ClI->nSdoFavCli # 0
	  IF nVlrTot >= CLI->nSdoFavCli
	     nFavDes := CLI->nSdoFavCli
	  ELSE
	     nFavDes := nVlrTot
	  ENDIF
	  nVlrTot := ROUND(nVlrTot - nFavDes,0)
	  nVlrTo2 := ROUND(nVlrTo2 - nFavDes,0)

	  nVlrPag := ROUND(nVlrMes - nFavDes,0)
	  nVlrMes := ROUND(nVlrMes - nFavDes,0)
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       DO CASE
       CASE CAA->nMtdFacCaA == 1

	    IF lPrePrn
	       cMsgTxt  := SPACE(14)+cFecha(dPagOpo)+SPACE(30)+;
			   TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")
	    ELSE
	       cMsgTxt  := 'HASTA '+cFecha(dPagOpo)+' ..PAGUE $'+;
			   TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")
	    ENDIF

       OTHERWISE
	    IF lPrePrn
	       cMsgTxt  := SPACE(14)+cFecha(dPagOpo)+SPACE(30)+;
			   TRANSFORM(nVlrTot+nSdoFav,"***,***,***")
	    ELSE
	       cMsgTxt  := 'HASTA '+cFecha(dPagOpo)+' ..PAGUE $'+;
			   TRANSFORM(nVlrTot+nSdoFav,"***,***,***")
	    ENDIF
       ENDCASE
       Linea_Recibo(cMsgTxt,1,nNroLen)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
			     ABS(nVlrPag))*nIntMor)/100,0)
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt

	  DO CASE
	  CASE CAA->nMtdFacCaA == 1
	       IF lPrePrn
		  cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
			     TRANSFORM(nVlrTot+nSdoFav,"***,***,***")
	       ELSE
		  cMsgTxt := 'HASTA '+cFecha(dPagExt)+' ..PAGUE $'+;
			     TRANSFORM(nVlrTot+nSdoFav,"***,***,***")
	       ENDIF
	  OTHERWISE
	       IF lPrePrn
		  cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
			     TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")
	       ELSE
		  cMsgTxt := 'HASTA '+cFecha(dPagExt)+' ..PAGUE $'+;
			     TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")
	       ENDIF
	  ENDCASE
	  Linea_Recibo(cMsgTxt,1,nNroLen)
       ENDIF

       @ PROW()+IF(lPrePrn,5,1),(180-LEN(cMensaj))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       SET FIXED ON
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA

*>>>>GRABACION DEL RECIBO FACTURADO
       AADD(aRecFac,{'lShared',lShared})

       AADD(aRecFac,{'cCodEst',cCodEst})
       AADD(aRecFac,{'nMesIni',nMesIni})
       AADD(aRecFac,{'nMesFin',nMesIni})
       AADD(aRecFac,{'cEmpPal',cEmpPal})
       AADD(aRecFac,{'cNroNit',cNitEmp})
       AADD(aRecFac,{'cNroFac',cNroFac})
       AADD(aRecFac,{'cNomBan',cNomBan})
       AADD(aRecFac,{'cNroCta',cCtaBan})
       AADD(aRecFac,{'cNombre',cNomEst})
       AADD(aRecFac,{'cCodRef',cCodFac})
       AADD(aRecFac,{'cCodGru',cCodGru})
       AADD(aRecFac,{'cFecFac',cFecha(DATE())})
       AADD(aRecFac,{'cPagOpo',cFecha(dPagOpo)})
       AADD(aRecFac,{'cPagExt',cFecha(dPagExt)})
       AADD(aRecFac,{'cPerFac',cMeses})

/*
       AADD(aRecFac,{'cNomCo1',})
       AADD(aRecFac,{'cVlrMo1',})
       AADD(aRecFac,{'cVlrMe1',})
       AADD(aRecFac,{'cVlrTo1',})
       AADD(aRecFac,{'cNomCo2',})
       AADD(aRecFac,{'cVlrMo2',})
       AADD(aRecFac,{'cVlrMe2',})
       AADD(aRecFac,{'cVlrTo2',})
       AADD(aRecFac,{'cNomCo3',})
       AADD(aRecFac,{'cVlrMo3',})
       AADD(aRecFac,{'cVlrMe3',})
       AADD(aRecFac,{'cVlrTo3',})
       AADD(aRecFac,{'cNomCo4',})
       AADD(aRecFac,{'cVlrMo4',})
       AADD(aRecFac,{'cVlrMe4',})
       AADD(aRecFac,{'cVlrTo4',})
       AADD(aRecFac,{'cNomCo5',})
       AADD(aRecFac,{'cVlrMo5',})
       AADD(aRecFac,{'cVlrMe5',})
       AADD(aRecFac,{'cVlrTo5',})
       AADD(aRecFac,{'cNomCo6',})
       AADD(aRecFac,{'cVlrMo6',})
       AADD(aRecFac,{'cVlrMe6',})
       AADD(aRecFac,{'cVlrTo6',})
       AADD(aRecFac,{'cNomCo7',})
       AADD(aRecFac,{'cVlrMo7',})
       AADD(aRecFac,{'cVlrMe7',})
       AADD(aRecFac,{'cVlrTo7',})
       AADD(aRecFac,{'cNomCo8',})
       AADD(aRecFac,{'cVlrMo8',})
       AADD(aRecFac,{'cVlrMe8',})
       AADD(aRecFac,{'cVlrTo8',})
       AADD(aRecFac,{'cNomCo9',})
       AADD(aRecFac,{'cVlrMo9',})
       AADD(aRecFac,{'cVlrMe9',})
       AADD(aRecFac,{'cVlrTo9',})
*/

       AADD(aRecFac,{'cVlrOpo',TRANSFORM(nVlrTot+nSdoFav,"***,***,***")})
       AADD(aRecFac,{'cVlrExt',TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")})
       AADD(aRecFac,{'cBarOpo',cTxtOpo})
       AADD(aRecFac,{'cBarExt',cTxtExt})
       AADD(aRecFac,{'cTxtUno',CAA->cTxtUnoCaA})
       AADD(aRecFac,{'cTxtDos',CAA->cTxtDosCaA})

       AADD(aRecFac,{'cNomUsr','system'})
       AADD(aRecFac,{'dFecUsr',DATE()})
       AADD(aRecFac,{'cHorUsr',TIME()})

       SaveRegRfa(aRecFac)

       RETURN nVlrTot
*>>>>FIN GRABACION DEL RECIBO FACTURADO

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRIME LOS CONCEPTO A COBRAR                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
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

FUNCTION nVlrCon01(aRecFac,nMesIni,nMesFin,cCodGru,cConcep,;
		   nSdoAct,nVlrPen,lHayDes,lPrePrn,;
		   nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,;
		   nVlrCo4,nVlrCo5,nVlrCo6,nVlrCo7,;
		   nVlrCo8,lHayBec,nVlrBec,nSdoFav,;
		   nVl2Co1,nVl2Co2,nVl2Co3,nVl2Co4,;
		   nVl2Co5,nVl2Co6,nVl2Co7,nVl2Co8,;
		   nTotal2)

*>>>>DESCRIPCION DE PARAMETROS
/*     aRecFac                              // Recibos facturados
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
       nVlrPen                              // @Valor de la pensi¢n (Adelantado)
       lHayDes                              // .T. Hay Descuento
       lPrePrn                              // .T. Recibo PreImpreso
       nNroLen                              // Longitud del Recibo
       nVlrCo1                              // @Valor1 Concepto No. 1
       nVlrCo2                              // @Valor1 Concepto No. 2
       nVlrCo3                              // @Valor1 Concepto No. 3
       nVlrCo4                              // @Valor1 Concepto No. 4
       nVlrCo5                              // @Valor1 Concepto No. 5
       nVlrCo6                              // @Valor1 Concepto No. 6
       nVlrCo7                              // @Valor1 Concepto No. 7
       nVlrCo8                              // @Valor1 Concepto No. 8
       lHayBec                              // @.T. Se aplico la Beca
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor
       nVl2Co1                              // @Valor2 Concepto No. 1
       nVl2Co2                              // @Valor2 Concepto No. 2
       nVl2Co3                              // @Valor2 Concepto No. 3
       nVl2Co4                              // @Valor2 Concepto No. 4
       nVl2Co5                              // @Valor2 Concepto No. 5
       nVl2Co6                              // @Valor2 Concepto No. 6
       nVl2Co7                              // @Valor2 Concepto No. 7
       nVl2Co8                              // @Valor2 Concepto No. 8
       nTotal2                              // @Valot Total del Recibo del valor2 */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cBlanco := ''                  // Linea en Blanco
       LOCAL nValor1 := 0                   // Valor1 del Concepto para el recibo
       LOCAL nValor2 := 0                   // Valor2 del Concepto para el recibo
       LOCAL nVl1Con := 0                   // Valor1 del Concepto para la Facturaci¢n
       LOCAL nVl2Con := 0                   // Valor1 del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nSubTo2 := 0                   // SubTotal del recibo del valor2
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nVlrTo2 := 0                   // Valor Total del Recibo del valor2
       LOCAL nTotal  := 0                   // Valot Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       nTotal2 := 0
       IF nVlrPen == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DE LOS CONCEPTOS
       lHayBec := .F.
       lPrePrn := IF(lPrePrn == NIL,.F.,lPrePrn)
       nNroLen := IF(nNroLen == NIL,57,nNroLen)

       IF lPrePrn
	  nNroCon := (LEN(cConcep)/2)+IF(lHayDes,2,3)
       ELSE
	  nNroCon := LEN(cConcep)/2+IF(nSdoFav==0,0,-1)
       ENDIF
       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0

       nVl2Co1 := 0; nVl2Co2 := 0; nVl2Co3 := 0; nVl2Co4 := 0
       nVl2Co5 := 0; nVl2Co6 := 0; nVl2Co7 := 0; nVl2Co8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>INICIALIZACION
       AADD(aRecFac,{'cNomCo1',' '})
       AADD(aRecFac,{'cVlrMo1',' '})
       AADD(aRecFac,{'cVlrMe1',' '})
       AADD(aRecFac,{'cVlrTo1',' '})

       AADD(aRecFac,{'cNomCo2',' '})
       AADD(aRecFac,{'cVlrMo2',' '})
       AADD(aRecFac,{'cVlrMe2',' '})
       AADD(aRecFac,{'cVlrTo2',' '})

       AADD(aRecFac,{'cNomCo3',' '})
       AADD(aRecFac,{'cVlrMo3',' '})
       AADD(aRecFac,{'cVlrMe3',' '})
       AADD(aRecFac,{'cVlrTo3',' '})

       AADD(aRecFac,{'cNomCo4',' '})
       AADD(aRecFac,{'cVlrMo4',' '})
       AADD(aRecFac,{'cVlrMe4',' '})
       AADD(aRecFac,{'cVlrTo4',' '})

       AADD(aRecFac,{'cNomCo5',' '})
       AADD(aRecFac,{'cVlrMo5',' '})
       AADD(aRecFac,{'cVlrMe5',' '})
       AADD(aRecFac,{'cVlrTo5',' '})

       AADD(aRecFac,{'cNomCo6',' '})
       AADD(aRecFac,{'cVlrMo6',' '})
       AADD(aRecFac,{'cVlrMe6',' '})
       AADD(aRecFac,{'cVlrTo6',' '})

       AADD(aRecFac,{'cNomCo7',' '})
       AADD(aRecFac,{'cVlrMo7',' '})
       AADD(aRecFac,{'cVlrMe7',' '})
       AADD(aRecFac,{'cVlrTo7',' '})

       AADD(aRecFac,{'cNomCo8',' '})
       AADD(aRecFac,{'cVlrMo8',' '})
       AADD(aRecFac,{'cVlrMe8',' '})
       AADD(aRecFac,{'cVlrTo8',' '})

       AADD(aRecFac,{'cNomCo9',' '})
       AADD(aRecFac,{'cVlrMo9',' '})
       AADD(aRecFac,{'cVlrMe9',' '})
       AADD(aRecFac,{'cVlrTo9',' '})
*>>>>INICIALIZACION

*>>>>IMPRESION DE LOS CONCEPTOS
       cBlanco := '|                |         |         |         |'
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       IF lPrePrn
		  @ PROW()+1,02 SAY ''
	       ELSE
		  Linea_Recibo(cBlanco)
	       ENDIF
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    nValor1 := 0
	    nValor2 := 0
	    nVl1Con := 0
	    nVl2Con := 0
	    IF cCodigoTco <> SPACE(02)

	       IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses
		  nValor1 := nVlrTarMes(cCodGru,nMesIni,;
				       cCodigoTco,@cNombreTco)
	       ELSE
		  nValor1 := nValorTar(cCodGru,cCodigoTco,@cNombreTco,@nValor2)
	       ENDIF

	       nVl1Con := nValor1
	       nVl2Con := nValor2

	       IF nValor1 == 0

		  nValor1 := nVlrHon(CLI->nSdoActCli)
		  nVl1Con := nValor1
		  nVl2Con := nValor2

		  IF nValor1 == 0
		     RETURN 'Error'
		  ENDIF

	       ENDIF
	    ENDIF
	    cNombreTco := ALLTRIM(cNombreTco)
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********PREPARACION DEL NOMBRE DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       IF CON->lBecadoCon

*-----------------VALOR PENSION PARA DESCONTAR BECA
		    IF lPorAde
		       nVlrPen += nValor1
		    ENDIF
*-----------------FIN VALOR PENSION PARA DESCONTAR BECA

*-----------------ANALISIS SI TIENE BECA
		    IF lTieneBeca(nMesIni,nMesFin)

*                      ANALSIS SI PERTENECE AL FONDO
			 lHayBec := .T.
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
			 ENDIF
*                      FIN ANALSIS SI PERTENECE AL FONDO

*                      DESCUENTO POR BECA
			 IF !lPorAde
			    IF !EMPTY(CLI->nPorBecCli)
			       nVlrBec := ROUND((nValor1*CLI->nPorBecCli)/100,0)
			    ELSE
			       nVlrBec := CLI->nVlrBecCli
			    ENDIF
			    nValor1 := nValor1-nVlrBec
			    nValor2 := nValor2-nVlrBec
			 ENDIF
*                      FIN DESCUENTO POR BECA

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
		    ENDIF
*-----------------FIN ANALISIS SI TIENE BECA

	       ENDIF

	    ENDIF
	    cNombreTco := cNombreTco+SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion

	    IF !EMPTY(CON->cNomExtCon)
	       cNombreTco := ALLTRIM(cNombreTco)+' '+;
			     ALLTRIM(CON->cNomExtCon)
	    ENDIF
**********FIN PREPARACION DEL NOMBRE DEL CONCEPTO

**********ASIGNACION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)

	       DO CASE
	       CASE i == 1
		    nVlrCo1 := nVl1Con
		    nVl2Co1 := nVl2Con

	       CASE i == 2
		    nVlrCo2 := nVl1Con
		    nVl2Co2 := nVl2Con

	       CASE i == 3
		    nVlrCo3 := nVl1Con
		    nVl2Co3 := nVl2Con

	       CASE i == 4
		    nVlrCo4 := nVl1Con
		    nVl2Co4 := nVl2Con

	       CASE i == 5
		    nVlrCo5 := nVl1Con
		    nVl2Co5 := nVl2Con

	       CASE i == 6
		    nVlrCo6 := nVl1Con
		    nVl2Co6 := nVl2Con

	       CASE i == 7
		    nVlrCo7 := nVl1Con
		    nVl2Co7 := nVl2Con

	       CASE i == 8
		    nVlrCo8 := nVl1Con
		    nVl2Co8 := nVl2Con

	       OTHERWISE
		    RETURN 'Error'
	       ENDCASE
	    ENDIF
**********FIN ASIGNACION DEL VALOR DEL CONCEPTO

**********ACUMULACION DE LOS VALORES A COBRAR CON SALDO
	    IF cCodigoTco <> SPACE(02)
	       IF i = 1

		  nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
				0,nSdoAct)+nValor1

		  nSubTo2 := IF(CAA->nMesAmnCaA==nMesIni,;
				0,nSdoAct)+nValor2

		  IF lPrePrn

		     cMsgTxt := cNombreTco+SPACE(14)+;
				IF(CAA->nMesAmnCaA==nMesIni,;
				   'PENDIENTE',;
				   TRANS(nSdoAct,'9,999,999'))+;
				SPACE(05)+;
				TRANS(nValor1,'9,999,999')+;
				SPACE(05)+;
				TRANS(nSubTot,'9,999,999')
		  ELSE

		      cMsgTxt :='|'+cNombreTco+;
				'|'+IF(CAA->nMesAmnCaA==nMesIni,;
				      'PENDIENTE',;
				      TRANS(nSdoAct,'9,999,999'))+;
				'|'+TRANS(nValor1,'9,999,999')+;
				'|'+TRANS(nSubTot,'9,999,999')+'|'
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF cCodigoTco <> SPACE(02)
	       IF i <> 1
		  nSubTot := nValor1
		  nSubTo2 := nValor2
		  IF lPrePrn
		     IF CON->lDesEfeDes
			cMsgTxt := cNombreTco+SPACE(08)+;
				   SPACE(09)+;
				   SPACE(11)+;
				   TRANS(nValor1,'9,999,999')+;
				   SPACE(05)+;
				   TRANS(nSubTot,'9,999,999')
		     ELSE
			cMsgTxt := cNombreTco+SPACE(08)+;
				   SPACE(09)+;
				   SPACE(11)+;
				   TRANS(nValor1,'9,999,999')+;
				   SPACE(04)+'-'+;
				   TRANS(nSubTot,'9,999,999')
		     ENDIF

		  ELSE
		     IF CON->lDesEfeDes
			cMsgTxt := '|'+cNombreTco+;
				   '|         |'+TRANS(nValor1,'9,999,999')+;
				   '|-'+TRANS(nSubTot,'9,999,999')+'|'
		     ELSE
			cMsgTxt := '|'+cNombreTco+;
				   '|         |'+TRANS(nValor1,'9,999,999')+;
				   '|'+TRANS(nSubTot,'9,999,999')+'|'
		     ENDIF
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)

	       Linea_Recibo(cMsgTxt,1,nNroLen)

	       IF CON->lDesEfeDes
		  nVlrTot := nVlrTot - nSubTot
	       ELSE
		  nVlrTot := nVlrTot + nSubTot
	       ENDIF
	       nVlrTo2 := nVlrTo2 + nSubTo2
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

**********CONCEPTOS FACTURADOS DEL RECIBO
	    IF cCodigoTco <> SPACE(02)

	       DO CASE
	       CASE i == 1

		    nParameSet(aRecFac,'cNomCo1',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo1',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe1',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo1',TRANS(nSubTot,'9,999,999'))


	       CASE i == 2

		    nParameSet(aRecFac,'cNomCo2',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo2',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe2',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo2',TRANS(nSubTot,'9,999,999'))

	       CASE i == 3

		    nParameSet(aRecFac,'cNomCo3',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo3',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe3',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo3',TRANS(nSubTot,'9,999,999'))

	       CASE i == 4

		    nParameSet(aRecFac,'cNomCo4',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo4',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe4',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo4',TRANS(nSubTot,'9,999,999'))

	       CASE i == 5

		    nParameSet(aRecFac,'cNomCo5',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo5',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe5',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo5',TRANS(nSubTot,'9,999,999'))

	       CASE i == 6

		    nParameSet(aRecFac,'cNomCo6',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo6',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe6',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo6',TRANS(nSubTot,'9,999,999'))

	       CASE i == 7

		    nParameSet(aRecFac,'cNomCo7',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo7',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe7',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo7',TRANS(nSubTot,'9,999,999'))

	       CASE i == 8

		    nParameSet(aRecFac,'cNomCo8',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo8',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe8',TRANS(nValor1,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo8',TRANS(nSubTot,'9,999,999'))

	       ENDCASE
	    ENDIF
**********FIN CONCEPTOS FACTURADOS DEL RECIBO

	  i := i + 1

       ENDDO
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES
       IF nSdoAct # 0 .AND. EMPTY(cConcep)
	  nTotal  := 0
	  nTotal2 := 0
       ELSE
	  nTotal  := nVlrTot-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
	  nTotal2 := nVlrTo2-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
       ENDIF
       RETURN nTotal
*>>>>FIN IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES

/*************************************************************************
* TITULO DE LA FUNCION..: RECIBO DE PAGO No. 02                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/97 LUN A
       Colombia, Bucaramanga        INICIO: 12:05 PM   FEB 16/97 LUN

OBJETIVOS:

1- Recibo No. 02 dise¤o para los Colegios: La Merced,Las Bethlemitas

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo02(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		   nNroLis,cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,;
		   dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		   nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
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
*>>>>FIN PARAMETROS DE LA FUNCION

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
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
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
	    nVlrMes := nVlrCon02(nMesIni,nMesIni,cCodGru,cConcep,;
				 nSdoAct,nSdoAno,NIL,lHayDes,nNroLen,;
				 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,@nVlrBec,nNroLis)
	   *Impresi¢n de conceptos
ELSE
    nVlrMes := nVlrCon02(nMesIni,nMesIni,cCodGru,cConcep,;
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
	    nVlrMes := nVlrCon02(nMesIni,nMesFin,cCodGru,cConcep,;
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

FUNCTION nVlrCon02(nMesIni,nMesFin,cCodGru,cConcep,nSdoAct,;
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
	    IF i <= 7
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

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 03                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
       Colombia, Bucaramanga        INICIO: 05:05 PM   AGO 13/94 SAB

OBJETIVOS:

1- Recibo No. 03 dise¤o para el Colegio la Salle con Colilla

2- Soporte el Recibo No. 04 == No. 03 pero sin colilla.

3- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

4- Retorna por referencia los param‚tros de la funci¢n marcados con @

5- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo03(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		   nNroLis,cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,;
		   dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		   nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE AVANCES3 CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)

       nNroLen := 74

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

*>>>>CALCULO DEL DIGITO DE CHEQUEO
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
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>AVANCE DE LINEAS
       nAvance := 4
       IF lPrnGru
	  SendCodes(AVANCES3)
	  nAvance := 0
       ENDIF
*>>>>FIN AVANCE DE LINEAS

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>IMPRESION DEL ENCABEZADO DEL RECIBO
       @ PROW()+nAvance,02    SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),nNroLen       SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),(nNroLen*2)-2 SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
     *ÀBanco o Corporaci¢n, Cuenta No

       nRecNro := IF(EMPTY(nRecNro),3,nRecNro)
       IF nRecNro == 3
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen,SPACE(nLenRes-4)+;
		      cNroFac+'-'+TRANS(nNroCop,"99"))
	*ÀCon colilla
       ELSE
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen)
	*Sin colilla
       ENDIF
      *Colegio,Resumen

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)
       IF nRecNro == 3
	  Linea_Recibo(cNomEst,2,nNroLen,SPACE(nLenRes)+cCodFac)
	 *Con Colilla
       ELSE
	  Linea_Recibo(cNomEst,2,nNroLen)
	 *Sin Colilla
       ENDIF
      *Nombre,Referencia

       IF nRecNro == 3
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso +SPACE(06)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen,SPACE(nLenRes)+cCurso)
	 *Con Colilla
       ELSE
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso +SPACE(06)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen)
	 *Sin Colilla
       ENDIF
      *Codigo,Curso,Facturado,Mes(es)
*>>>>FIN IMPRESION DEL ENCABEZADO DEL RECIBO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
       @ PROW()+2,02 SAY ''
      *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
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

	       cMsgTxt += SPACE(49)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon03(nMesIni,nMesIni,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos
ELSE
    nVlrMes := nVlrCon03(nMesIni,nMesIni,cCodGru,cConcep,;
			 0,NIL,;
			 lHayDes,nNroLen,@nVlrCo1,;
			 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
			 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
			 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
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
	       cMsgTxt += SPACE(49)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon03(nMesIni,nMesFin,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis)
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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := SPACE(14)+cFecha(dPagOpo)+SPACE(30)+;
		   TRANSFORM(nVlrTot+nSdoFav,"***,***,***")

       IF nRecNro == 3
	  Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
		       TRANSFORM(nVlrTot+nSdoFav,"***,***,***"))
	*ÀCon Colilla
       ELSE
	  Linea_Recibo(cMsgTxt,1,nNroLen)
	*ÀSin Colilla
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
		     TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")

	  IF nRecNro == 3
	     Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
			  TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***"))
	   *ÀCon colilla
	  ELSE
	     Linea_Recibo(cMsgTxt,1,nNroLen)
	    *Sin colilla
	  ENDIF
       ENDIF

       @ PROW()+5,(180-LEN(cMensaj))/2 SAY cMensaj
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
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
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

FUNCTION nVlrCon03(nMesIni,nMesFin,cCodGru,cConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis)

*>>>>PARAMATROS DE LA FUNCION
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
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
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
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
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       nNroCon := (LEN(cConcep)/2)+IF(lHayDes,2,3)

       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
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
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
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

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
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

		  cMsgTxt := cNombreTco+SPACE(14)+;
			     IF(CAA->nMesAmnCaA==nMesIni,;
				'PENDIENTE',;
				TRANS(nSdoAct,'9,999,999'))+;
			     SPACE(05)+;
			     TRANS(nValor,'9,999,999')+;
			     SPACE(05)+;
			     TRANS(nSubTot,'9,999,999')
	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF cCodigoTco <> SPACE(02)
	       IF i <> 1
		  nSubTot := nValor
		  cMsgTxt := cNombreTco+SPACE(08)+;
			     SPACE(09)+;
			     SPACE(11)+;
			     TRANS(nValor,'9,999,999')+;
			     SPACE(05)+;
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

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 05                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 08:30 PM   DIC 27/2002 VIE

OBJETIVOS:

1- Recibo No. 05 impresora codigo de barras

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo05(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		   nNroLis,cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,;
		   dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		   nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       nNroLen := 74

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

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       cMesIni := STR(nMesIni,2)
       cMesFin := IF(nMesFin == NIL,cMesIni,STR(nMesFin,2))
       lCorrecion(@cMesIni)
       lCorrecion(@cMesFin)

       IF !EMPTY(BAN->nDigVerBan)
	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+cMesIni+cMesFin+;
		     EVAL(bDigChe,cCodEst+cMesIni+cMesFin)
       ELSE
	  cCodFac := cCodEst+cMesIni+cMesFin
       ENDIF
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')
       IF nRecNro == 5
	  Post('MZP 0.0,2.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,3.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,3.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,3.6;BOX 3.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,4.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,5.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,9.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,9.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,9.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,10.5; TEXT "ALUMNO";')

	  Post('CMNT "BOLANTE COLEGIO";')
	  Post('MZP 0.0,11.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,12.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,14.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,18.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,18.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,18.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,19.3; TEXT "COLEGIO";')

	  Post('CMNT "BOLANTE BANCO";')
	  Post('MZP 0.0,20.0; BOX 20.33,6.5;')
	  Post('MZP 0.0,20.8; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 3.33,0.4;')
	  Post('MZP 0.0,21.6; BOX 6.0,4.9;')
	  Post('MZP 0.0,21.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.6; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,23.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,24.1; BOX 6.0,0.5;')

	  Post('MZP 6.0,21.6; BOX 14.33,0.3;')
	  Post('MZP 6.0,21.6; BOX 8.5,0.3;')
	  Post('MZP 6.0,24.1; BOX 14.33,0.3;')
	  Post('MZP 6.0,24.1; BOX 8.5,0.3;')

	  Post('MZP 17.0,27.0; TEXT "BANCO";')
	  Post('FSET 1p5v;')
	  Post('CMNT "BOLANTE ALUMNO";')

	  Post('FSET 1p10v;')
	  Post('MZP 0.3,2.8;  TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,11.8; TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,20.3; TEXT "'+cNomEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 0.3,3.2;  TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,12.2; TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,20.5; TEXT "'+cEmpPal+'";')

	  Post('FSET 1p4v;')
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 5
	  Post('FSET 1p10v;')
	  Post('MZP 15.0,3.5;  TEXT "RECIBO No.'+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "RECIBO No.'+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "RECIBO No.'+cNroFac+'";')
       ELSE
/*	  Post('MZP 15.0,3.5;  TEXT "          '+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "          '+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "          '+cNroFac+'";') */
       ENDIF

       Post('FSET 1p7v;')
       IF nRecNro == 5
	  Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ELSE
	  Post('MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ENDIF

       IF nRecNro == 5
	  Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ELSE
	  Post('MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ENDIF

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)

       IF nRecNro == 5
	  Post('MZP 0.3,4.3; TEXT "NOMBRE"; MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,13.3;TEXT "NOMBRE"; MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,21.5;TEXT "NOMBRE"; MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.3,4.7; TEXT "CODIGO ESTUDIANTE"; MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,13.7;TEXT "CODIGO ESTUDIANTE"; MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,24.0;TEXT "CODIGO"; MZP 2.5,24.0;TEXT "'+cCodFac+'";')


	  Post('MZP 5.5,4.7; TEXT "CURSO"; MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.5,13.7;TEXT "CURSO"; MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 0.3,24.5; TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.5,4.7; TEXT "FACTURADO"; MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.5,13.7;TEXT "FACTURADO"; MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP  0.3,21.1;TEXT "FACTURADO"; MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.5,4.7; TEXT "MES(ES) A PAGAR"; MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.5,13.7;TEXT "MES(ES) A PAGAR"; MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 13.5,21.1;TEXT "MES(ES) A PAGAR"; MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ELSE
	  Post('MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 2.5,24.0;TEXT "'+cCodFac+'";')


	  Post('MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ENDIF

       IF nRecNro == 5
	  Post('MZP 1.5,5.5; TEXT "CONCEPTO";')
	  Post('MZP 1.5,14.5;TEXT "CONCEPTO";')

	  Post('MZP 6.5,5.5; TEXT "MORA";')
	  Post('MZP 6.5,14.5;TEXT "MORA";')

	  Post('MZP 11.5,5.5; TEXT "VALOR MES";')
	  Post('MZP 11.5,14.5;TEXT "VALOR MES";')

	  Post('MZP 16.5,5.5; TEXT "TOTAL";')
	  Post('MZP 16.5,14.5;TEXT "TOTAL";')
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
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

	       Post('MZP 0.3,6.0; TEXT "'+cMsgTxt+'";')
	       Post('MZP 0.3,15.0;TEXT "'+cMsgTxt+'";')

	       Post('MZP 13.5,6.0; TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')
	       Post('MZP 13.5,15.0;TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon05(nMesIni,nMesIni,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos
ELSE
	    nVlrMes := nVlrCon05(nMesIni,nMesIni,cCodGru,cConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
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

	       Post('MZP 0.3,6.0; TEXT "'+cMsgTxt+'";')
	       Post('MZP 0.3,15.0;TEXT "'+cMsgTxt+'";')

	       Post('MZP 13.5,6.0; TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')
	       Post('MZP 13.5,15.0;TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon05(nMesIni,nMesFin,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis)
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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 5
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ELSE
	  Post('MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  IF nRecNro == 5
	     Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ELSE
	     Post('MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ENDIF
       ENDIF

       Post('MZP 0.3,10.1; TEXT "'+cMensaj+'";')

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

*>>>>IMPRESION PARTE DEL BANCO
       Post('FSET 1p6v;')

       IF nRecNro == 5
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
       ELSE
	  Post('MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrTot+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 5
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE
	  Post('MZP 8.5,23.9; TEXT"'+cTxtOpo+'";')
       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 5
	  Post('MZP 10.0,26.3; TEXT"'+cTxtExt+'";')

	  Post('UNIT C;')
	  Post('MZP 9.0,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 9.0,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ELSE
	  Post('MZP 8.5,26.3; TEXT"'+cTxtExt+'";')

	  Post('UNIT C;')
	  Post('MZP 7.5,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 7.5,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ENDIF

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

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
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   DIC 27/2002 VIE

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

FUNCTION nVlrCon05(nMesIni,nMesFin,cCodGru,cConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis)

*>>>>PARAMATROS DE LA FUNCION
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
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
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto para el recibo
       LOCAL nVlrCon := 0                   // Valor del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nTotal  := 0                   // Valor Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos

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
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       nNroCon := (LEN(cConcep)/2)+IF(lHayDes,2,3)

       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       i := i + 1
	       LOOP
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
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
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

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
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
	    cFilas1 := '6.4;6.8;7.2;7.6;8.0;8.4;8.8'
	    cFilas2 := '15.4;15.8;16.2;16.6;17.0;17.4;17.8'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)
	    IF i = 1
	       nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
			     0,nSdoAct)+nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       IF CAA->nMesAmnCaA==nMesIni
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "PENDIENTE";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "PENDIENTE";')
	       ELSE
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
	       ENDIF

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF i <> 1
	       nSubTot := nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')

	    ENDIF
	    nVlrTot := nVlrTot + nSubTot
	   *Suma del total a pagar
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

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

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 06                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 11/2005 LUN A
       Colombia, Bucaramanga        INICIO: 01:15 PM   ENE 11/2005 LUN

OBJETIVOS:

1- Recibo No. 06 dise¤o para el Colegio la Salle con Colilla que permite
   la facturaci¢n por conceptos

2- Soporte el Recibo No. 04 == No. 03 pero sin colilla. que permite la
   facturaci¢n por conceptos.

3- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

4- Retorna por referencia los param‚tros de la funci¢n marcados con @

5- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo06(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		   nNroLis,cNomBan,cCtaBan,cLugBan,aConcep,nIntMor,;
		   dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		   nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       nNroLis                              // N£mero de lista
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       aConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // @Valor recibo para un mes
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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

       LOCAL nIniPen := 0                   // Mes Inicial de la pensi¢n
       LOCAL nFinPen := 0                   // Mes Final de la pensi¢n
       LOCAL nPorBec := 0                   // Porcentaje de la beca
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL nNroCop := 0                   // N£mero de Copias
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       nNroLen := 74

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

*>>>>CALCULO DEL DIGITO DE CHEQUEO
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
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>AVANCE DE LINEAS
       nAvance := 4
       IF lPrnGru
	  SendCodes(AVANCES)
	  nAvance := 0
       ENDIF
*>>>>FIN AVANCE DE LINEAS

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>IMPRESION DEL ENCABEZADO DEL RECIBO
       @ PROW()+nAvance,02    SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),nNroLen       SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),(nNroLen*2)-2 SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
     *ÀBanco o Corporaci¢n, Cuenta No

       nRecNro := IF(EMPTY(nRecNro),3,nRecNro)
       IF nRecNro == 3
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen,SPACE(nLenRes-4)+;
		      cNroFac+'-'+TRANS(nNroCop,"99"))
	*ÀCon colilla
       ELSE
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen)
	*Sin colilla
       ENDIF
      *Colegio,Resumen

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)
       IF nRecNro == 3
	  Linea_Recibo(cNomEst,2,nNroLen,SPACE(nLenRes)+cCodFac)
	 *Con Colilla
       ELSE
	  Linea_Recibo(cNomEst,2,nNroLen)
	 *Sin Colilla
       ENDIF
      *Nombre,Referencia

       IF nRecNro == 3
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso +SPACE(06)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen,SPACE(nLenRes)+cCurso)
	 *Con Colilla
       ELSE
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso +SPACE(06)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen)
	 *Sin Colilla
       ENDIF
      *Codigo,Curso,Facturado,Mes(es)
*>>>>FIN IMPRESION DEL ENCABEZADO DEL RECIBO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
       @ PROW()+2,02 SAY ''
      *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
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

	       cMsgTxt += SPACE(49)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon06(nMesIni,nMesIni,cCodGru,aConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos
ELSE
    nVlrMes := nVlrCon06(nMesIni,nMesIni,cCodGru,aConcep,;
			 0,NIL,;
			 lHayDes,nNroLen,@nVlrCo1,;
			 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
			 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
			 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
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
	       cMsgTxt += SPACE(49)+TRANS(nVlrDes,'9,999,999')
	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon06(nMesIni,nMesFin,cCodGru,aConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********REALIZACION DEL DESCUENTO POR BECA
	    nIniPen := 0
	    nFinPen := 0
	    nVlrTot := nVlrRec(aConcep,@nIniPen,@nFinPen) +;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
	   *Total del Recibo sin descuentos y sin becas

	    IF lHayBec

	       IF !EMPTY(CLI->nPorBecCli)
		  nVlrBec := ROUND((nVlrPen * nPorBec)/100,0)
	       ELSE
		  IF nVlrPen # 0
		     nVlrBec := CLI->nVlrBecCli
		  ENDIF
	       ENDIF
	     *ÀC lculo del valor de beca para un mes

	       IF lTieneBeca(nMesIni,nMesIni)
		  nVlrMes -= nVlrBec
		  IF nVlrPen # 0
		     nVlrCo1 := nVlrPen
		  ENDIF
	       ENDIF
	      *Descuento de la beca para el primer mes

	       nVlrBec := nVlrBec * nNroBecas(nIniPen,nFinPen)
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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := SPACE(14)+cFecha(dPagOpo)+SPACE(30)+;
		   TRANSFORM(nVlrTot+nSdoFav,"***,***,***")

       IF nRecNro == 3
	  Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
		       TRANSFORM(nVlrTot+nSdoFav,"***,***,***"))
	*ÀCon Colilla
       ELSE
	  Linea_Recibo(cMsgTxt,1,nNroLen)
	*ÀSin Colilla
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
		     TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")

	  IF nRecNro == 3
	     Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
			  TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***"))
	   *ÀCon colilla
	  ELSE
	     Linea_Recibo(cMsgTxt,1,nNroLen)
	    *Sin colilla
	  ENDIF
       ENDIF

       @ PROW()+5,(180-LEN(cMensaj))/2 SAY cMensaj
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
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
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

FUNCTION nVlrCon06(nMesIni,nMesFin,cCodGru,aConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis)

*>>>>PARAMATROS DE LA FUNCION
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       aConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
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
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto para el recibo
       LOCAL nVlrCon := 0                   // Valor del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nTotal  := 0                   // Valor Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL nRegCon := 0                   // Registro del Concepto

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
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       nNroCon := 7+IF(lHayDes,2,3)

       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= LEN(aConcep)
	       cCodigoTco := aConcep[i,1]  // cCodigoTco
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       @ PROW()+1,02 SAY ''
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO
	    nVlrCon := 0
	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)

		   nValor := aConcep[i,4]  // nValorTar
	       cNombreTco := aConcep[i,5]  // cNombreTco

	       nRegCon := aConcep[i,6]     // RecNo del Concepto
	       CON->(DBGOTO(nRegCon))

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
		       IF cCodigoTco == 'PE'
			  nVlrPen += nValor
		       ENDIF
		    ENDIF
*-----------------FIN VALOR PENSION PARA DESCONTAR BECA

*-----------------ANALISIS SI TIENE BECA
		    IF lTieneBeca(nMesIni,nMesFin)

*                      ANALSIS SI PERTENECE AL FONDO
			 lHayBec := .T.
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
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

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
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

		  cMsgTxt := cNombreTco+SPACE(14)+;
			     IF(CAA->nMesAmnCaA==nMesIni,;
				'PENDIENTE',;
				TRANS(nSdoAct,'9,999,999'))+;
			     SPACE(05)+;
			     TRANS(nValor,'9,999,999')+;
			     SPACE(05)+;
			     TRANS(nSubTot,'9,999,999')
	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF cCodigoTco <> SPACE(02)
	       IF i <> 1
		  nSubTot := nValor
		  cMsgTxt := cNombreTco+SPACE(08)+;
			     SPACE(09)+;
			     SPACE(11)+;
			     TRANS(nValor,'9,999,999')+;
			     SPACE(05)+;
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
       IF nSdoAct # 0 .AND. LEN(aConcep) == 0
	  nTotal := 0
       ELSE
	  nTotal := nVlrTot-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
       ENDIF
       RETURN nTotal
*>>>>FIN IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 07                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 01/2006 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   FEB 01/2006 VIE

OBJETIVOS:

1- Recibo No. 07 impresora codigo de barras que permite la facturaci¢n por
   conceptos.

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo07(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		   nNroLis,cNomBan,cCtaBan,cLugBan,aConcep,nIntMor,;
		   dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		   nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       nNroLis                              // N£mero de lista
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       aConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // @Valor recibo para un mes
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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

       LOCAL nIniPen := 0                   // Mes Inicial de la pensi¢n
       LOCAL nFinPen := 0                   // Mes Final de la pensi¢n
       LOCAL nPorBec := 0                   // Porcentaje de la beca
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL nNroCop := 0                   // N£mero de Copias
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       nNroLen := 74

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

*>>>>CALCULO DEL DIGITO DE CHEQUEO
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
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')
       IF nRecNro == 5
	  Post('MZP 0.0,2.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,3.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,3.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,3.6;BOX 3.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,4.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,5.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,9.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,9.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,9.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,10.5; TEXT "ALUMNO";')

	  Post('CMNT "BOLANTE COLEGIO";')
	  Post('MZP 0.0,11.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,12.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,14.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,18.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,18.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,18.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,19.3; TEXT "COLEGIO";')

	  Post('CMNT "BOLANTE BANCO";')
	  Post('MZP 0.0,20.0; BOX 20.33,6.5;')
	  Post('MZP 0.0,20.8; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 3.33,0.4;')
	  Post('MZP 0.0,21.6; BOX 6.0,4.9;')
	  Post('MZP 0.0,21.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.6; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,23.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,24.1; BOX 6.0,0.5;')

	  Post('MZP 6.0,21.6; BOX 14.33,0.3;')
	  Post('MZP 6.0,21.6; BOX 8.5,0.3;')
	  Post('MZP 6.0,24.1; BOX 14.33,0.3;')
	  Post('MZP 6.0,24.1; BOX 8.5,0.3;')

	  Post('MZP 17.0,27.0; TEXT "BANCO";')
	  Post('FSET 1p5v;')
	  Post('CMNT "BOLANTE ALUMNO";')

	  Post('FSET 1p10v;')
	  Post('MZP 0.3,2.8;  TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,11.8; TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,20.3; TEXT "'+cNomEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 0.3,3.2;  TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,12.2; TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,20.5; TEXT "'+cEmpPal+'";')

	  Post('FSET 1p4v;')
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 5
	  Post('FSET 1p10v;')
	  Post('MZP 15.0,3.5;  TEXT "RECIBO No.'+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "RECIBO No.'+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "RECIBO No.'+cNroFac+'";')
       ELSE
/*	  Post('MZP 15.0,3.5;  TEXT "          '+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "          '+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "          '+cNroFac+'";') */
       ENDIF

       Post('FSET 1p7v;')
       IF nRecNro == 5
	  Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ELSE
	  Post('MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ENDIF

       IF nRecNro == 5
	  Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ELSE
	  Post('MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ENDIF

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)

       IF nRecNro == 5
	  Post('MZP 0.3,4.3; TEXT "NOMBRE"; MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,13.3;TEXT "NOMBRE"; MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,21.5;TEXT "NOMBRE"; MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.3,4.7; TEXT "CODIGO ESTUDIANTE"; MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,13.7;TEXT "CODIGO ESTUDIANTE"; MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,24.0;TEXT "CODIGO"; MZP 2.5,24.0;TEXT "'+cCodFac+'";')


	  Post('MZP 5.5,4.7; TEXT "CURSO"; MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.5,13.7;TEXT "CURSO"; MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 0.3,24.5; TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.5,4.7; TEXT "FACTURADO"; MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.5,13.7;TEXT "FACTURADO"; MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP  0.3,21.1;TEXT "FACTURADO"; MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.5,4.7; TEXT "MES(ES) A PAGAR"; MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.5,13.7;TEXT "MES(ES) A PAGAR"; MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 13.5,21.1;TEXT "MES(ES) A PAGAR"; MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ELSE
	  Post('MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 2.5,24.0;TEXT "'+cCodFac+'";')


	  Post('MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ENDIF

       IF nRecNro == 5
	  Post('MZP 1.5,5.5; TEXT "CONCEPTO";')
	  Post('MZP 1.5,14.5;TEXT "CONCEPTO";')

	  Post('MZP 6.5,5.5; TEXT "MORA";')
	  Post('MZP 6.5,14.5;TEXT "MORA";')

	  Post('MZP 11.5,5.5; TEXT "VALOR MES";')
	  Post('MZP 11.5,14.5;TEXT "VALOR MES";')

	  Post('MZP 16.5,5.5; TEXT "TOTAL";')
	  Post('MZP 16.5,14.5;TEXT "TOTAL";')
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
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

	       Post('MZP 0.3,6.0; TEXT "'+cMsgTxt+'";')
	       Post('MZP 0.3,15.0;TEXT "'+cMsgTxt+'";')

	       Post('MZP 13.5,6.0; TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')
	       Post('MZP 13.5,15.0;TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon07(nMesIni,nMesIni,cCodGru,aConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos
ELSE
	    nVlrMes := nVlrCon07(nMesIni,nMesIni,cCodGru,aConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
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

	       Post('MZP 0.3,6.0; TEXT "'+cMsgTxt+'";')
	       Post('MZP 0.3,15.0;TEXT "'+cMsgTxt+'";')

	       Post('MZP 13.5,6.0; TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')
	       Post('MZP 13.5,15.0;TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon07(nMesIni,nMesFin,cCodGru,aConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********REALIZACION DEL DESCUENTO POR BECA
	    nIniPen := 0
	    nFinPen := 0
	    nVlrTot := nVlrRec(aConcep,@nIniPen,@nFinPen) +;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
	   *Total del Recibo sin descuentos y sin becas

	    IF lHayBec

	       IF !EMPTY(CLI->nPorBecCli)
		  nVlrBec := ROUND((nVlrPen * nPorBec)/100,0)
	       ELSE
	          IF nVlrPen # 0
		     nVlrBec := CLI->nVlrBecCli
		  ENDIF
	       ENDIF
	     *ÀC lculo del valor de beca para un mes

	       IF lTieneBeca(nMesIni,nMesIni)
		  nVlrMes -= nVlrBec
		  IF nVlrPen # 0
		     nVlrCo1 := nVlrPen
		  ENDIF
	       ENDIF
	      *Descuento de la beca para el primer mes

	       nVlrBec := nVlrBec * nNroBecas(nIniPen,nFinPen)
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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 5
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ELSE
	  Post('MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  IF nRecNro == 5
	     Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ELSE
	     Post('MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ENDIF
       ENDIF

       Post('MZP 0.3,10.1; TEXT "'+cMensaj+'";')

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

*>>>>IMPRESION PARTE DEL BANCO
       Post('FSET 1p6v;')

       IF nRecNro == 5
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
       ELSE
	  Post('MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrTot+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 5
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE
	  Post('MZP 8.5,23.9; TEXT"'+cTxtOpo+'";')
       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 5
	  Post('MZP 10.0,26.3; TEXT"'+cTxtExt+'";')

	  Post('UNIT C;')
	  Post('MZP 9.0,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 9.0,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ELSE
	  Post('MZP 8.5,26.3; TEXT"'+cTxtExt+'";')

	  Post('UNIT C;')
	  Post('MZP 7.5,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 7.5,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ENDIF

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

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
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   DIC 27/2002 VIE

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

FUNCTION nVlrCon07(nMesIni,nMesFin,cCodGru,aConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis)

*>>>>PARAMATROS DE LA FUNCION
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       aConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
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
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto para el recibo
       LOCAL nVlrCon := 0                   // Valor del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos
       LOCAL nRegCon := 0                   // Registro del Concepto

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
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       nNroCon := 7+IF(lHayDes,2,3)

       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= LEN(aConcep)
	       cCodigoTco := aConcep[i,1]  // cCodigoTco
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       i := i + 1
	       LOOP
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO
	    nVlrCon := 0
	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)

		   nValor := aConcep[i,4]  // nValorTar
	       cNombreTco := aConcep[i,5]  // cNombreTco

	       nRegCon := aConcep[i,6]     // RecNo del Concepto
	       CON->(DBGOTO(nRegCon))

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
		       IF cCodigoTco == 'PE'
			  nVlrPen += nValor
		       ENDIF
		    ENDIF
*-----------------FIN VALOR PENSION PARA DESCONTAR BECA

*-----------------ANALISIS SI TIENE BECA
		    IF lTieneBeca(nMesIni,nMesFin)

*                      ANALSIS SI PERTENECE AL FONDO
			 lHayBec := .T.
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
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

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
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
	    cFilas1 := '6.4;6.8;7.2;7.6;8.0;8.4;8.8'
	    cFilas2 := '15.4;15.8;16.2;16.6;17.0;17.4;17.8'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)
	    IF i = 1
	       nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
			     0,nSdoAct)+nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       IF CAA->nMesAmnCaA==nMesIni
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "PENDIENTE";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "PENDIENTE";')
	       ELSE
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
	       ENDIF

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF i <> 1
	       nSubTot := nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')

	    ENDIF
	    nVlrTot := nVlrTot + nSubTot
	   *Suma del total a pagar
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

	  i := i + 1

       ENDDO
       RETURN nVlrTot-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
*>>>>IMPRESION DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 08                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 08:30 PM   DIC 27/2002 VIE

OBJETIVOS:

1- Recibo en c¢digos de barras. Colegios de la Salle

2- Imprime el recibo de pago con c¢digo de barras utilizando
   el lenguaje PRESCRIBE de las impresoras Kiosera.

3- Recibo No. 08 imprime el recibo SIN formato preimpreso

4- Recibo No. 09 imprime el recibo CON formato preimpreso

5- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

6- Retorna por referencia los param‚tros de la funci¢n marcados con @

7- Retorna el total de recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo08(aRecFac,nDiaMor,;
		   lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,cCodIso,nNroFac,cCodEst,cNomEst,;
		   cCodGru,nNroLis,cNomBan,cCtaBan,cLugBan,cConcep,;
		   nIntMor,dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,;
		   nMesIni,nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,;
		   nVlrCo4,nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,;
		   nVlrBec,nDescue,nPagPar,nRecarg,nDesGen,nRecGen,;
		   cConGen,nFavDes,nSdoFav,nRecNro)

*>>>>DESCRIPCION DE PARAMETROS
/*     aRecFac                              // Recibo Facturado
       nDiaMor                              // Dias en Mora
       lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cCodIso                              // C¢digo Iso
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodMzp := ''                  // C¢digos de las coordenadas de impresi¢n
       LOCAL nTotPrn := 3                   // Total de Impresiones
       LOCAL cNroRef := ''                  // N£mero de la Referencia
       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL cCodSer := xPrm(aRecFac,'cCodFac') // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE
       SET FIXED OFF
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       nNroLen := 74

       IF SCO->lHayNroCon
	  IF SCO->nNroFacCon >= 99999999
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
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
       ELSE
	  nNroFac := 0
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       cMesIni := STR(nMesIni,2)
       cMesFin := IF(nMesFin == NIL,cMesIni,STR(nMesFin,2))
       lCorrecion(@cMesIni)
       lCorrecion(@cMesFin)

       IF !EMPTY(BAN->nDigVerBan)

	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+cMesIni+cMesFin+;
		     EVAL(bDigChe,cCodEst+cMesIni+cMesFin)

	  cCodFac := cCodEst+cMesIni+cMesFin
       ELSE
	  cCodFac := cCodEst+cMesIni+cMesFin
       ENDIF
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+cMesIni+cMesFin

       cNroRef := cCodFac+cAnoUsr+cCodEmp+cNroFac
       cNroRef := cCodFac+cCodSer
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('RES;SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')

       IF nRecNro == 8
	  Post('MZP 0.0,2.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,3.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,3.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,3.6;BOX 3.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,4.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,5.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,9.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,9.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,9.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,10.2; TEXT "ALUMNO";')
	  Post('MZP 0.0,11.2; TEXT ">-------------------------------------------------------------------------------<";')

	  Post('CMNT "BOLANTE COLEGIO";')
	  Post('MZP 0.0,11.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,12.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,14.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,18.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,18.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,18.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,19.3; TEXT "COLEGIO";')
	  Post('MZP 0.0,19.7; TEXT ">-------------------------------------------------------------------------------<";')

	  Post('CMNT "BOLANTE BANCO";')
	  Post('MZP 0.0,20.0; BOX 20.33,6.5;')
	  Post('MZP 0.0,20.8; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 3.33,0.4;')
	  Post('MZP 0.0,21.6; BOX 6.0,4.9;')
	  Post('MZP 0.0,21.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.6; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,23.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,24.1; BOX 6.0,0.5;')

	  Post('MZP 6.0,21.6; BOX 14.33,0.3;')
	  Post('MZP 6.0,21.6; BOX 8.5,0.3;')
	  Post('MZP 6.0,24.1; BOX 14.33,0.3;')
	  Post('MZP 6.0,24.1; BOX 8.5,0.3;')

	  Post('MZP 17.0,27.0; TEXT "BANCO";')
	  Post('FSET 1p5v;')
	  Post('CMNT "BOLANTE ALUMNO";')

	  Post('FSET 1p10v;')
	  Post('MZP 0.3,2.8;  TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,11.8; TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,20.3; TEXT "'+cNomEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 0.3,3.2;  TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,12.2; TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,20.5; TEXT "'+cEmpPal+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

/*
	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
*/
	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "'+cCodIso+'";')
	  Post('MZP 2.0,12.5; TEXT "'+cCodIso+'";')
	  Post('MZP 2.0,20.7; TEXT "'+cCodIso+'";')


       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 8
	  Post('FSET 1p10v;')
	  Post('MZP 15.0,3.5;  TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
       ELSE
	  Post('FSET 1p7v;')

	  cCodMzp := '7.0,3.4;' +;
		     '7.0,12.0;'+;
		     '7.0,20.5;'
	  LineaMzp(cCodMzp,cNomEmp,nTotPrn)
	*ÀNombre de la Empresa

	  cCodMzp := '17.0,3.7;'+;
		     '17.0,12.3;'+;
		     '17.0,20.8;'
	  LineaMzp(cCodMzp,SCO->cCodEmpCon+'-'+cNroFac,nTotPrn)
	*ÀN£mero de la factura

       ENDIF

       Post('FSET 1p7v;')
       IF nRecNro == 8
	  Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ELSE

	  cCodMzp := '4.0,4.2;'+;
		     '4.0,12.8;'+;
		     '2.5,22.6;'
	  LineaMzp(cCodMzp,RTRIM(cNomBan),nTotPrn)
	*ÀNombre del Banco

       ENDIF

       IF nRecNro == 8
	  Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ELSE

	  cCodMzp := '14.0,4.2;'+;
		     '14.0,12.8;'+;
		     '2.5,23.2;'
	  LineaMzp(cCodMzp,RTRIM(cCtaBan),nTotPrn)
	*ÀN£mero de la cuenta del Banco

       ENDIF


       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)


       IF nRecNro == 8
	  Post('MZP 0.3,4.3; TEXT "NOMBRE"; MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,13.3;TEXT "NOMBRE"; MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,21.5;TEXT "NOMBRE"; MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.3,4.7; TEXT "CODIGO ESTUDIANTE"; MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,13.7;TEXT "CODIGO ESTUDIANTE"; MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,24.0;TEXT "CODIGO"; MZP 2.5,24.0;TEXT "'+cCodFac+'";')

	  Post('MZP 5.5,4.7; TEXT "CURSO"; MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.5,13.7;TEXT "CURSO"; MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 0.3,24.5; TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.5,4.7; TEXT "FACTURADO"; MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.5,13.7;TEXT "FACTURADO"; MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP  0.3,21.1;TEXT "FACTURADO"; MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.5,4.7; TEXT "MES(ES) A PAGAR"; MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.5,13.7;TEXT "MES(ES) A PAGAR"; MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 13.5,21.1;TEXT "MES(ES) A PAGAR"; MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ELSE

	  cCodMzp := '4.0,4.6;'+;
		     '4.0,13.2;'+;
		     '4.0,21.7;'
	  LineaMzp(cCodMzp,cNomEst,nTotPrn)
	*ÀNombre del Estudiante

	  cCodMzp := '0.5,5.4;'+;
		     '0.5,14.0;'+;
		     '2.5,24.1;'
	  LineaMzp(cCodMzp,cCodFac,nTotPrn)
	*ÀC¢digo de la Factura

	  cCodMzp := '5.7,5.4;'+;
		     '5.7,14.0;'+;
		     '2.5,24.6;'
	  LineaMzp(cCodMzp,cCurso,nTotPrn)
	*ÀCurso del Estudiante

	  cCodMzp := '10.7,5.4;'+;
		     '10.7,14.0;'+;
		     '3.9,21.3;'
	  LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
	*ÀFecha de Expedici¢n

	  cCodMzp := '15.7,5.4;'+;
		     '15.7,14.0;'+;
		     '17.5,21.3;'
	  LineaMzp(cCodMzp,cMeses,nTotPrn)
	*ÀPeriodo facturado
       ENDIF

       IF nRecNro == 8
	  Post('MZP 1.5,5.5; TEXT "CONCEPTO";')
	  Post('MZP 1.5,14.5;TEXT "CONCEPTO";')

	  Post('MZP 6.5,5.5; TEXT "MORA";')
	  Post('MZP 6.5,14.5;TEXT "MORA";')

	  Post('MZP 11.5,5.5; TEXT "VALOR MES";')
	  Post('MZP 11.5,14.5;TEXT "VALOR MES";')

	  Post('MZP 16.5,5.5; TEXT "TOTAL";')
	  Post('MZP 16.5,14.5;TEXT "TOTAL";')
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       IF !lPorAde

**********IMPRESION DEL DESCUENTO O DEL RECARGO
	    IF lHayDes

	       DO CASE
	       CASE nTipDes == 1 .OR. nTipDes == 4
		    IF nTipDes == 1
		       cMsgTxt := 'DESCUENTO'
		       IF CAA->lNomConDes
			  cMsgTxt := DES->cNombreCon
		       ENDIF
		    ELSE
		       cMsgTxt := 'P PARCIAL'
		    ENDIF
	       CASE nTipDes == 2
		       cMsgTxt := 'RECARGO  '
		       IF CAA->lNomConDes
			  cMsgTxt := DES->cNombreCon
		       ENDIF
	       ENDCASE

	       IF CAA->lNomConDes
	       ENDIF

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon08(nMesIni,nMesIni,cCodGru,@cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis,;
				 aRecFac,nDiaMor)
	   *Impresi¢n de conceptos

ELSE
	    nVlrMes := nVlrCon08(nMesIni,nMesIni,cCodGru,@cConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis,;
				 aRecFac,nDiaMor)
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

*>>>>SALDO ACTUAL PENDIENTE RETIRADO
       IF nVlrMes == 0 .AND.;
	  CLI->nSdoActCli+CLI->nSdoMorCli > 0 .AND.;
	  EMPTY(cConcep)

	  Post('MZP 0.3,6.7; TEXT "SALDO EN MORA";')
	  Post('MZP 0.3,15.3; TEXT "SALDO EN MORA";')
	*ÀCONCEPTO

	  Post('MZP 8.5,6.7; '+;
	       'TEXT "'+TRANS(CLI->nSdoActCli+CLI->nSdoMorCli,'9,999,999')+'";')
	  Post('MZP 8.5,15.3; '+;
	       'TEXT "'+TRANS(CLI->nSdoActCli+CLI->nSdoMorCli,'9,999,999')+'";')
	*ÀMORA

	  Post('MZP 13.5,6.7;  TEXT "0";')
	  Post('MZP 13.5,15.3; TEXT "0";')
	*ÀVALOR MES

	  Post('MZP 18.5,6.7; '+;
	       'TEXT "'+TRANS(CLI->nSdoActCli+CLI->nSdoMorCli,'9,999,999')+'";')
	  Post('MZP 18.5,15.3; '+;
	       'TEXT "'+TRANS(CLI->nSdoActCli+CLI->nSdoMorCli,'9,999,999')+'";')
	*ÀTOTAL

	 nParameSet(aRecFac,'cNomCo1','SALDO EN MORA')
	 nParameSet(aRecFac,'cVlrMo1',TRANS(CLI->nSdoActCli+CLI->nSdoMorCli,'9,999,999'))
	 nParameSet(aRecFac,'cVlrMe1',TRANS(0,'9,999,999'))
	 nParameSet(aRecFac,'cVlrTo1',TRANS(CLI->nSdoActCli+CLI->nSdoMorCli,'9,999,999'))

       ENDIF
*>>>>FIN SALDO ACTUAL PENDIENTE RETIRADO

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

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon08(nMesIni,nMesFin,cCodGru,@cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis,;
				 aRecFac,nDiaMor)
	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********REALIZACION DEL DESCUENTO POR BECA
	    IF CAA->nMtdFacCaA == 2
	       nVlrTot := nTarIniFin(cCodGru,nMesIni,nMesFin,cConcep)+;
			    CLI->nSdoActCli+CLI->nSdoMorCli
	    ELSE
	       nVlrTot := nVlrMes * (nMesFin - nMesIni + 1) +;
			  IF(CAA->nMesAmnCaA==nMesIni,0,;
			     CLI->nSdoActCli+CLI->nSdoMorCli)
	      *Total del Recibo sin descuentos y sin becas
	    ENDIF

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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 8
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.5;'+;
		     '6.5,18.1;'+;
		     '10.5,22.1;'
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha pago oportuno

	  cCodMzp := '18.5,9.5;'+;
		     '18.5,18.1;'+;
		     '18.5,22.1;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nSdoFav,"***,***,***"),nTotPrn)
	*ÀValor para el pago oportuno

       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  IF nRecNro == 8

	     Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ELSE

	     cCodMzp := '6.5,9.9;'+;
			'6.5,18.7;'+;
			'10.5,24.5;'
	     LineaMzp(cCodMzp,cFecha(dPagExt),nTotPrn)
	   *ÀFecha Pago Extemporaneo

	     cCodMzp := '18.5,9.9;'+;
			'18.5,18.7;'+;
			'18.5,24.5;'
	     LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***"),nTotPrn)
	   *ÀValor a pagar en fecha Extemporanea.

	  ENDIF
       ENDIF

       IF nRecNro == 8

	  DO CASE
	  CASE cNitEmp == '8600099850'
	       Post('MZP 0.3,10.2; TEXT "SOLO SE RECIBEN PAGOS EN EFECTIVO O CHEQUES DE GERENCIA.";')
	       Post('MZP 0.3,10.5; TEXT "LA CONGREGACION DE LOS HERMANOS DE LAS ESCUELAS CRISTIANAS REALIZA EL REPORTE DE HABITO DE PAGO DE TODOS LOS CONTRATANTES AL OPERADOR";')
	       Post('MZP 0.3,10.8; TEXT "DE INFORMACION DATACREDITO. RECUERDE QUE EL NO PAGO DE LOS SERVICIOS EDUCATIVOS SE REFLEJARA EN SU HISTORIA DE CREDITO. LEY 1266 DE 2008.";')
	  ENDCASE

       ENDIF


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

*>>>>IMPRESION PARTE DEL BANCO
       Post('FSET 1p6v;')

       IF nRecNro == 8
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  IF lPagExt
	     Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ENDIF
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrTot+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 8
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE

	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtOpo,nTotPrn,1)
	*ÀTexto del C¢digo de Barras para el pago oportuno.

       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 8

	  IF lPagExt
	     Post('MZP 10.0,26.5; TEXT"'+cTxtExt+'";')
	  ENDIF

	  Post('UNIT C;')
	  Post('MZP 9.0,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 9.0,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  IF lPagExt
	     Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
	  ENDIF

       ELSE

	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtExt,nTotPrn,2)
	*ÀTexto del C¢digo de Barras para el pago Extemporaneo

	  Post('UNIT C;')

	  cCodMzp := '7.5,22.5;7.5,24.9;'
	  Post('MZP '+cPosMzpXY(cCodMzp,1))
	*ÀCoordenadas para el c¢digo de Barras Oportuno

	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')

	  cCodMzp := '7.5,22.5;7.5,24.9;'
	  Post('MZP '+cPosMzpXY(cCodMzp,2))
	*ÀCoordenadas para el c¢digo de Barras Extemporaneo

	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ENDIF

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

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
       nMesFin := IF(nMesFin==NIL,nMesIni,nMesFin)
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

*>>>>GRABACION DEL RECIBO FACTURADO
       AADD(aRecFac,{'lShared',lShared})

       AADD(aRecFac,{'cCodEst',cCodEst})
       AADD(aRecFac,{'nMesIni',nMesIni})
       AADD(aRecFac,{'nMesFin',nMesFin})
       AADD(aRecFac,{'cEmpPal',cEmpPal})
       AADD(aRecFac,{'cNroNit',cNitEmp})
       AADD(aRecFac,{'cNomEmp',cNomEmp})
       AADD(aRecFac,{'cNroFac',cNroFac})
       AADD(aRecFac,{'cNomBan',cNomBan})
       AADD(aRecFac,{'cNroCta',cCtaBan})
       AADD(aRecFac,{'cCodEan',cCodEan})
       AADD(aRecFac,{'cNombre',cNomEst})
       AADD(aRecFac,{'cCodRef',cCodFac})
       AADD(aRecFac,{'cCodGru',cCodGru})
       AADD(aRecFac,{'cFecFac',cFecha(DATE())})
       AADD(aRecFac,{'cPagOpo',cFecha(dPagOpo)})
       AADD(aRecFac,{'cPagExt',cFecha(dPagExt)})
       AADD(aRecFac,{'cPerFac',cMeses})

/*
       AADD(aRecFac,{'cNomCo1',})
       AADD(aRecFac,{'cVlrMo1',})
       AADD(aRecFac,{'cVlrMe1',})
       AADD(aRecFac,{'cVlrTo1',})
       AADD(aRecFac,{'cNomCo2',})
       AADD(aRecFac,{'cVlrMo2',})
       AADD(aRecFac,{'cVlrMe2',})
       AADD(aRecFac,{'cVlrTo2',})
       AADD(aRecFac,{'cNomCo3',})
       AADD(aRecFac,{'cVlrMo3',})
       AADD(aRecFac,{'cVlrMe3',})
       AADD(aRecFac,{'cVlrTo3',})
       AADD(aRecFac,{'cNomCo4',})
       AADD(aRecFac,{'cVlrMo4',})
       AADD(aRecFac,{'cVlrMe4',})
       AADD(aRecFac,{'cVlrTo4',})
       AADD(aRecFac,{'cNomCo5',})
       AADD(aRecFac,{'cVlrMo5',})
       AADD(aRecFac,{'cVlrMe5',})
       AADD(aRecFac,{'cVlrTo5',})
       AADD(aRecFac,{'cNomCo6',})
       AADD(aRecFac,{'cVlrMo6',})
       AADD(aRecFac,{'cVlrMe6',})
       AADD(aRecFac,{'cVlrTo6',})
       AADD(aRecFac,{'cNomCo7',})
       AADD(aRecFac,{'cVlrMo7',})
       AADD(aRecFac,{'cVlrMe7',})
       AADD(aRecFac,{'cVlrTo7',})
       AADD(aRecFac,{'cNomCo8',})
       AADD(aRecFac,{'cVlrMo8',})
       AADD(aRecFac,{'cVlrMe8',})
       AADD(aRecFac,{'cVlrTo8',})
       AADD(aRecFac,{'cNomCo9',})
       AADD(aRecFac,{'cVlrMo9',})
       AADD(aRecFac,{'cVlrMe9',})
       AADD(aRecFac,{'cVlrTo9',})
*/

       AADD(aRecFac,{'cVlrOpo',TRANSFORM(nVlrTot+nSdoFav,"***,***,***")})
       AADD(aRecFac,{'cVlrExt',TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")})
       AADD(aRecFac,{'cBarOpo',cTxtOpo})
       AADD(aRecFac,{'cBarExt',cTxtExt})
       AADD(aRecFac,{'cTxtUno','SOLO SE RECIBEN PAGOS EN EFECTIVO O CHEQUES DE GERENCIA'})
       AADD(aRecFac,{'cTxtDos','"LA CONGREGACION DE LOS HERMANOS DE LAS ESCUELAS ..."'})

       AADD(aRecFac,{'cNomUsr',cNomUsr})
       AADD(aRecFac,{'dFecUsr',DATE()})
       AADD(aRecFac,{'cHorUsr',TIME()})

       SaveRegRfa(aRecFac)

       RETURN nVlrTot
*>>>>FIN GRABACION DEL RECIBO FACTURADO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   DIC 27/2002 VIE

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

FUNCTION nVlrCon08(nMesIni,nMesFin,cCodGru,cConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis,aRecFac,nDiaMor)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // @Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
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
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor
       nNroLis                              // N£mero de lista
       aRecFac                              // Recibos Facturados
       nDiaMor                              // Dias en Mora        */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto para el recibo
       LOCAL nVlrCon := 0                   // Valor del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL  nTotal := 0                   // Valor Total del Recibo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos
       LOCAL nVlrHon := 0                   // Valor Honorarios de Cobranza

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
       cConcep := cValConFac(cConcep,CLI->nSdoActCli,nDiaMor)

       lHayBec := .F.
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       nNroCon := (LEN(cConcep)/2)+IF(lHayDes,2,3)

       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>INICIALIZACION
       AADD(aRecFac,{'cNomCo1',' '})
       AADD(aRecFac,{'cVlrMo1',' '})
       AADD(aRecFac,{'cVlrMe1',' '})
       AADD(aRecFac,{'cVlrTo1',' '})

       AADD(aRecFac,{'cNomCo2',' '})
       AADD(aRecFac,{'cVlrMo2',' '})
       AADD(aRecFac,{'cVlrMe2',' '})
       AADD(aRecFac,{'cVlrTo2',' '})

       AADD(aRecFac,{'cNomCo3',' '})
       AADD(aRecFac,{'cVlrMo3',' '})
       AADD(aRecFac,{'cVlrMe3',' '})
       AADD(aRecFac,{'cVlrTo3',' '})

       AADD(aRecFac,{'cNomCo4',' '})
       AADD(aRecFac,{'cVlrMo4',' '})
       AADD(aRecFac,{'cVlrMe4',' '})
       AADD(aRecFac,{'cVlrTo4',' '})

       AADD(aRecFac,{'cNomCo5',' '})
       AADD(aRecFac,{'cVlrMo5',' '})
       AADD(aRecFac,{'cVlrMe5',' '})
       AADD(aRecFac,{'cVlrTo5',' '})

       AADD(aRecFac,{'cNomCo6',' '})
       AADD(aRecFac,{'cVlrMo6',' '})
       AADD(aRecFac,{'cVlrMe6',' '})
       AADD(aRecFac,{'cVlrTo6',' '})

       AADD(aRecFac,{'cNomCo7',' '})
       AADD(aRecFac,{'cVlrMo7',' '})
       AADD(aRecFac,{'cVlrMe7',' '})
       AADD(aRecFac,{'cVlrTo7',' '})

       AADD(aRecFac,{'cNomCo8',' '})
       AADD(aRecFac,{'cVlrMo8',' '})
       AADD(aRecFac,{'cVlrMe8',' '})
       AADD(aRecFac,{'cVlrTo8',' '})

       AADD(aRecFac,{'cNomCo9',' '})
       AADD(aRecFac,{'cVlrMo9',' '})
       AADD(aRecFac,{'cVlrMe9',' '})
       AADD(aRecFac,{'cVlrTo9',' '})
*>>>>INICIALIZACION

*>>>>IMPRESION DE LOS CONCEPTOS
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       i := i + 1
	       LOOP
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO
	    nVlrCon := 0
	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)

	       IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses
		  nValor := nVlrTarMes(cCodGru,nMesIni,;
				       cCodigoTco,@cNombreTco)
	       ELSE
		  nValor := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       ENDIF

	       nVlrCon := nValor
	       IF nValor == 0

		   nValor := nVlrHon(CLI->nSdoActCli)

		   nVlrCon := nValor
		   IF nValor == 0
		      RETURN 'Error'
		   ENDIF

		  
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
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
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

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
		    ENDIF
*-----------------FIN ANALISIS SI TIENE BECA

	       ENDIF

	    ENDIF
	    cNombreTco := cNombreTco+SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion

	    IF !EMPTY(CON->cNomExtCon)
	       cNombreTco := ALLTRIM(cNombreTco)+' '+;
			     ALLTRIM(CON->cNomExtCon)
	    ENDIF
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
	    cFilas1 := '6.7;7.1;7.5;7.9;8.3;8.7;9.1;'
	    cFilas2 := '15.3;15.7;16.1;16.5;16.9;17.3;17.7;'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)
	    IF i = 1
	       nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
			     0,nSdoAct)+nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       IF CAA->nMesAmnCaA==nMesIni
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "PENDIENTE";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "PENDIENTE";')
	       ELSE
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
	       ENDIF

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF i <> 1
	       nSubTot := nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       IF CON->lDesEfeDes
		  Post('MZP 18.5,'+cFilUno+;
				     'TEXT "'+'-'+TRANS(nSubTot,'9,999,999')+'";')
		  Post('MZP 18.5,'+cFilDos+;
				     'TEXT "'+'-'+TRANS(nSubTot,'9,999,999')+'";')
	       ELSE
		  Post('MZP 18.5,'+cFilUno+;
				     'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
		  Post('MZP 18.5,'+cFilDos+;
				     'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       ENDIF

	    ENDIF

	    IF CON->lDesEfeDes
	       nVlrTot := nVlrTot - nSubTot
	    ELSE
	       nVlrTot := nVlrTot + nSubTot
	    ENDIF
	   *Suma del total a pagar
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

**********CONCEPTOS FACTURADOS DEL RECIBO
	    IF cCodigoTco <> SPACE(02)

	       DO CASE
	       CASE i == 1

		    nParameSet(aRecFac,'cNomCo1',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo1',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe1',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo1',TRANS(nSubTot,'9,999,999'))


	       CASE i == 2

		    nParameSet(aRecFac,'cNomCo2',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo2',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe2',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo2',TRANS(nSubTot,'9,999,999'))

	       CASE i == 3

		    nParameSet(aRecFac,'cNomCo3',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo3',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe3',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo3',TRANS(nSubTot,'9,999,999'))

	       CASE i == 4

		    nParameSet(aRecFac,'cNomCo4',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo4',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe4',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo4',TRANS(nSubTot,'9,999,999'))

	       CASE i == 5

		    nParameSet(aRecFac,'cNomCo5',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo5',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe5',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo5',TRANS(nSubTot,'9,999,999'))

	       CASE i == 6

		    nParameSet(aRecFac,'cNomCo6',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo6',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe6',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo6',TRANS(nSubTot,'9,999,999'))

	       CASE i == 7

		    nParameSet(aRecFac,'cNomCo7',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo7',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe7',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo7',TRANS(nSubTot,'9,999,999'))

	       CASE i == 8

		    nParameSet(aRecFac,'cNomCo8',cNombreTco)
		    nParameSet(aRecFac,'cVlrMo8',IF(CAA->nMesAmnCaA==nMesIni,;
						   'PENDIENTE',;
						   TRANS(nSdoAct,'9,999,999')))
		    nParameSet(aRecFac,'cVlrMe8',TRANS(nValor,'9,999,999'))
		    nParameSet(aRecFac,'cVlrTo8',TRANS(nSubTot,'9,999,999'))

	       ENDCASE
	    ENDIF
**********FIN CONCEPTOS FACTURADOS DEL RECIBO

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

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 10                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 01/2006 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   FEB 01/2006 VIE

OBJETIVOS:

1- Recibo No. 10 impresora codigo de barras que permite la facturaci¢n por
   conceptos.

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo10(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		   nNroLis,cNomBan,cCtaBan,cLugBan,aConcep,nIntMor,;
		   dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		   nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       nNroLis                              // N£mero de lista
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       aConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // @Valor recibo para un mes
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodMzp := ''                  // C¢digos de las coordenadas de impresi¢n
       LOCAL nTotPrn := 3                   // Total de Impresiones

       LOCAL cNroRef := ''                  // N£mero de la Referencia
       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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

       LOCAL nIniPen := 0                   // Mes Inicial de la pensi¢n
       LOCAL nFinPen := 0                   // Mes Final de la pensi¢n
       LOCAL nPorBec := 0                   // Porcentaje de la beca
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL nNroCop := 0                   // N£mero de Copias
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       nNroLen := 74

       IF SCO->lHayNroCon
	  IF SCO->nNroFacCon >= 99999999
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
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>CALCULO DEL DIGITO DE CHEQUEO
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
       cCodFac := cCodEst+cMesIni+cMesFin   // Adicionada
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+cMesIni+cMesFin

       cNroRef := cCodFac+cAnoUsr+cCodEmp+cNroFac
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')
       IF nRecNro == 8
	  Post('MZP 0.0,2.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,3.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,3.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,3.6;BOX 3.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,4.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,5.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,9.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,9.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,9.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,10.5; TEXT "ALUMNO";')

	  Post('CMNT "BOLANTE COLEGIO";')
	  Post('MZP 0.0,11.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,12.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,14.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,18.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,18.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,18.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,19.3; TEXT "COLEGIO";')

	  Post('CMNT "BOLANTE BANCO";')
	  Post('MZP 0.0,20.0; BOX 20.33,6.5;')
	  Post('MZP 0.0,20.8; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 3.33,0.4;')
	  Post('MZP 0.0,21.6; BOX 6.0,4.9;')
	  Post('MZP 0.0,21.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.6; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,23.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,24.1; BOX 6.0,0.5;')

	  Post('MZP 6.0,21.6; BOX 14.33,0.3;')
	  Post('MZP 6.0,21.6; BOX 8.5,0.3;')
	  Post('MZP 6.0,24.1; BOX 14.33,0.3;')
	  Post('MZP 6.0,24.1; BOX 8.5,0.3;')

	  Post('MZP 17.0,27.0; TEXT "BANCO";')
	  Post('FSET 1p5v;')
	  Post('CMNT "BOLANTE ALUMNO";')

	  Post('FSET 1p10v;')
	  Post('MZP 0.3,2.8;  TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,11.8; TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,20.3; TEXT "'+cNomEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 0.3,3.2;  TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,12.2; TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,20.5; TEXT "'+cEmpPal+'";')

	  Post('FSET 1p4v;')
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 8
	  Post('FSET 1p10v;')
	  Post('MZP 15.0,3.5;  TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
       ELSE
	  Post('FSET 1p7v;')

	  cCodMzp := '7.0,3.4;' +;
		     '7.0,12.0;'+;
		     '7.0,20.5;'
	  LineaMzp(cCodMzp,cNomEmp,nTotPrn)
	*ÀNombre de la Empresa

	  cCodMzp := '17.0,3.7;'+;
		     '17.0,12.3;'+;
		     '17.0,20.8;'
	  LineaMzp(cCodMzp,SCO->cCodEmpCon+'-'+cNroFac,nTotPrn)
	*ÀN£mero de la factura

       ENDIF

       Post('FSET 1p7v;')
       IF nRecNro == 8
	  Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ELSE
	  cCodMzp := '4.0,4.2;'+;
		     '4.0,12.8;'+;
		     '2.5,22.6;'
	  LineaMzp(cCodMzp,RTRIM(cNomBan),nTotPrn)
	*ÀNombre del Banco
       ENDIF

       IF nRecNro == 8
	  Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ELSE
	  cCodMzp := '14.0,4.2;'+;
		     '14.0,12.8;'+;
		     '2.5,23.2;'
	  LineaMzp(cCodMzp,RTRIM(cCtaBan),nTotPrn)
	*ÀN£mero de la cuenta del Banco

       ENDIF

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)

       IF nRecNro == 8
	  Post('MZP 0.3,4.3; TEXT "NOMBRE"; MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,13.3;TEXT "NOMBRE"; MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,21.5;TEXT "NOMBRE"; MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.3,4.7; TEXT "CODIGO ESTUDIANTE"; MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,13.7;TEXT "CODIGO ESTUDIANTE"; MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,24.0;TEXT "CODIGO"; MZP 2.5,24.0;TEXT "'+cCodFac+'";')


	  Post('MZP 5.5,4.7; TEXT "CURSO"; MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.5,13.7;TEXT "CURSO"; MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 0.3,24.5; TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.5,4.7; TEXT "FACTURADO"; MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.5,13.7;TEXT "FACTURADO"; MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP  0.3,21.1;TEXT "FACTURADO"; MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.5,4.7; TEXT "MES(ES) A PAGAR"; MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.5,13.7;TEXT "MES(ES) A PAGAR"; MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 13.5,21.1;TEXT "MES(ES) A PAGAR"; MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ELSE

	  cCodMzp := '4.0,4.6;'+;
		     '4.0,13.2;'+;
		     '4.0,21.7;'
	  LineaMzp(cCodMzp,cNomEst,nTotPrn)
	*ÀNombre del Estudiante

	  cCodMzp := '0.5,5.4;'+;
		     '0.5,14.0;'+;
		     '2.5,24.1;'
	  LineaMzp(cCodMzp,cCodFac,nTotPrn)
	*ÀC¢digo de la Factura

	  cCodMzp := '5.7,5.4;'+;
		     '5.7,14.0;'+;
		     '2.5,24.6;'
	  LineaMzp(cCodMzp,cCurso,nTotPrn)
	*ÀCurso del Estudiante

	  cCodMzp := '10.7,5.4;'+;
		     '10.7,14.0;'+;
		     '3.9,21.3;'
	  LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
	*ÀFecha de Expedici¢n

	  cCodMzp := '15.7,5.4;'+;
		     '15.7,14.0;'+;
		     '17.5,21.3;'
	  LineaMzp(cCodMzp,cMeses,nTotPrn)
	*ÀPeriodo facturado

       ENDIF

       IF nRecNro == 8
	  Post('MZP 1.5,5.5; TEXT "CONCEPTO";')
	  Post('MZP 1.5,14.5;TEXT "CONCEPTO";')

	  Post('MZP 6.5,5.5; TEXT "MORA";')
	  Post('MZP 6.5,14.5;TEXT "MORA";')

	  Post('MZP 11.5,5.5; TEXT "VALOR MES";')
	  Post('MZP 11.5,14.5;TEXT "VALOR MES";')

	  Post('MZP 16.5,5.5; TEXT "TOTAL";')
	  Post('MZP 16.5,14.5;TEXT "TOTAL";')
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
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

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon10(nMesIni,nMesIni,cCodGru,aConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos
ELSE
	    nVlrMes := nVlrCon10(nMesIni,nMesIni,cCodGru,aConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
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

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon10(nMesIni,nMesFin,cCodGru,aConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********REALIZACION DEL DESCUENTO POR BECA
	    nIniPen := 0
	    nFinPen := 0
	    nVlrTot := nVlrRec(aConcep,@nIniPen,@nFinPen) +;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
	   *Total del Recibo sin descuentos y sin becas

	    IF lHayBec

	       IF !EMPTY(CLI->nPorBecCli)
		  nVlrBec := ROUND((nVlrPen * nPorBec)/100,0)
	       ELSE
	          IF nVlrPen # 0
		     nVlrBec := CLI->nVlrBecCli
		  ENDIF
	       ENDIF
	     *ÀC lculo del valor de beca para un mes

	       IF lTieneBeca(nMesIni,nMesIni)
		  nVlrMes -= nVlrBec
		  IF nVlrPen # 0
		     nVlrCo1 := nVlrPen
		  ENDIF
	       ENDIF
	      *Descuento de la beca para el primer mes

	       nVlrBec := nVlrBec * nNroBecas(nIniPen,nFinPen)
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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 8
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.5;'+;
		     '6.5,18.1;'+;
		     '10.5,22.1;'
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha pago oportuno

	  cCodMzp := '18.5,9.5;'+;
		     '18.5,18.1;'+;
		     '18.5,22.1;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nSdoFav,"***,***,***"),nTotPrn)
	*ÀValor para el pago oportuno

       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  IF nRecNro == 8
	     Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ELSE

	     cCodMzp := '6.5,9.9;'+;
			'6.5,18.7;'+;
			'10.5,24.5;'
	     LineaMzp(cCodMzp,cFecha(dPagExt),nTotPrn)
	   *ÀFecha Pago Extemporaneo

	     cCodMzp := '18.5,9.9;'+;
			'18.5,18.7;'+;
			'18.5,24.5;'
	     LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***"),nTotPrn)
	   *ÀValor a pagar en fecha Extemporanea.

	  ENDIF
       ENDIF

*       cMensaj := ''
*       Post('MZP 0.3,10.1; TEXT "'+cMensaj+'";')

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

*>>>>IMPRESION PARTE DEL BANCO
       Post('FSET 1p6v;')

       IF nRecNro == 8
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrTot+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 8
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE

	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtOpo,nTotPrn,1)
	*ÀTexto del C¢digo de Barras para el pago oportuno.

       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 8
	  Post('MZP 10.0,26.3; TEXT"'+cTxtExt+'";')

	  Post('UNIT C;')
	  Post('MZP 9.0,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 9.0,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ELSE

	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtExt,nTotPrn,2)
	*ÀTexto del C¢digo de Barras para el pago Extemporaneo

	  Post('UNIT C;')

	  cCodMzp := '7.5,22.5;7.5,24.9;'
	  Post('MZP '+cPosMzpXY(cCodMzp,1))
	*ÀCoordenadas para el c¢digo de Barras Oportuno

	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')

	  cCodMzp := '7.5,22.5;7.5,24.9;'
	  Post('MZP '+cPosMzpXY(cCodMzp,2))
	*ÀCoordenadas para el c¢digo de Barras Extemporaneo

	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ENDIF

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

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
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   DIC 27/2002 VIE

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

FUNCTION nVlrCon10(nMesIni,nMesFin,cCodGru,aConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis)

*>>>>PARAMATROS DE LA FUNCION
/*     nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       aConcep                              // Conceptos por cobrar
       nSdoAct                              // Saldo Actual + Mora
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
       nVlrBec                              // @ Valor de la Beca
       nSdoFav                              // Saldo a Favor */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto para el recibo
       LOCAL nVlrCon := 0                   // Valor del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL  nTotal := 0                   // Valor Total del Concepto
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos
       LOCAL nRegCon := 0                   // Registro del Concepto

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
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       nNroCon := 7+IF(lHayDes,2,3)

       nVlrCo1 := 0; nVlrCo2 := 0; nVlrCo3 := 0; nVlrCo4 := 0
       nVlrCo5 := 0; nVlrCo6 := 0; nVlrCo7 := 0; nVlrCo8 := 0
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= LEN(aConcep)
	       cCodigoTco := aConcep[i,1]  // cCodigoTco
	      *Lectura del concepto a cobrar
	    ENDIF

	    IF cCodigoTco == SPACE(02)
	       i := i + 1
	       LOOP
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO
	    nVlrCon := 0
	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)

		   nValor := aConcep[i,4]  // nValorTar
	       cNombreTco := aConcep[i,5]  // cNombreTco

	       nRegCon := aConcep[i,6]     // RecNo del Concepto
	       CON->(DBGOTO(nRegCon))

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
		       IF cCodigoTco == 'PE'
			  nVlrPen += nValor
		       ENDIF
		    ENDIF
*-----------------FIN VALOR PENSION PARA DESCONTAR BECA

*-----------------ANALISIS SI TIENE BECA
		    IF lTieneBeca(nMesIni,nMesFin)

*                      ANALSIS SI PERTENECE AL FONDO
			 lHayBec := .T.
			 IF CLI->lFondosCli
			    cNombreTco += ' FONDO-BE'
			 ELSE
			    IF LEN(cNombreTco) >= 11
			       cNombreTco := SUBS(cNombreTco,1,11)+' BECA'
			    ELSE
			       cNombreTco += ' BECA'
			    ENDIF
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

		    ELSE
		       IF CLI->lFondosCli
			  cNombreTco += ' FONDO'
		       ENDIF
		     *ÀPertence al fondo y no tiene beca
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
	    cFilas1 := '6.7;7.1;7.5;7.9;8.3;8.7;9.1;'
	    cFilas2 := '15.3;15.7;16.1;16.5;16.9;17.3;17.7;'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)
	    IF i = 1
	       nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
			     0,nSdoAct)+nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       IF CAA->nMesAmnCaA==nMesIni
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "PENDIENTE";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "PENDIENTE";')
	       ELSE
		  Post('MZP 8.5,'+cFilUno+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
		  Post('MZP 8.5,'+cFilDos+;
				     'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
	       ENDIF

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF i <> 1
	       nSubTot := nValor

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')

	    ENDIF
	    nVlrTot := nVlrTot + nSubTot
	   *Suma del total a pagar
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

	  i := i + 1

       ENDDO
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES
       IF nSdoAct # 0 .AND. LEN(aConcep) == 0
	  nTotal := 0
       ELSE
	  nTotal := nVlrTot-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
       ENDIF
       RETURN nTotal
*>>>>FIN IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES

/*************************************************************************
* TITULO..: VALOR DEL RECIBO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2005 DOM A
       Bucaramanga, Colombia	    INICIO: 02:30 PM   ENE 16/2005 DOM

OBJETIVOS:

1- Calcula el valor total del recibo

2- Retorna el valor total del recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrRec(aConcep,nIniPen,nFinPen)

*>>>>DECLARACION DE PARAMETROS
/*     aConcep                              // Conceptos a facturar
       nIniPen                              // @Mes Inicial de la pension
       nFinPen                              // @Mes Final de la pension */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nVlrRec := 0                   // Valor del Recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS MESES FACTURADOS
       nIniPen := 0
       nFinPen := 0
       FOR i := 1 TO LEN(aConcep)

	   nMesIni := aConcep[i,2]
	   nMesFin := aConcep[i,3]
	   nVlrCon := aConcep[i,4]
	   nVlrRec += (nMesFin-nMesIni+1) * nVlrCon

	   IF aConcep[i,1] == 'PE'
	      nIniPen := nMesIni
	      nFinPen := nMesFin
	   ENDIF

       NEXT
       RETURN nVlrRec
*>>>>FIN CALCULO DE LOS MESES FACTURADOS

/*************************************************************************
* TITULO..: NOMBRE PARA LA FACTURA                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 27/2001 JUE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   MAR 27/2001 JUE

OBJETIVOS:

1- Escoge el nombre de la factura

2- Retorna el nombre

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomFac(cMaeAct,cCodEst,cNomEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     cMaeAct                              // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomFac := ''                  // Nombre para el Recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NOMBRE PARA EL RECIBO
       IF &cMaeAct->cCodigoEst == cCodEst
	  DO CASE
	  CASE CAA->nNomFacCaA == 0  // Solo el Estudiante
	       cNomFac := cNomEst

	  CASE CAA->nNomFacCaA == 1  // Alumno:Padre
	       cNomFac := ALLTRIM(&cMaeAct->cNombreEst)+' Y/O '+;
			  cNomFacMae(cMaeAct,CAA->nNomFacCaA)

	  CASE CAA->nNomFacCaA == 2  // Alumno:Madre
	       cNomFac := ALLTRIM(&cMaeAct->cNombreEst)+' Y/O '+;
			  cNomFacMae(cMaeAct,CAA->nNomFacCaA)

	  CASE CAA->nNomFacCaA == 3  // Alumno:Acudiente
	       cNomFac := ALLTRIM(&cMaeAct->cNombreEst)+' Y/O '+;
			  cNomFacMae(cMaeAct,CAA->nNomFacCaA)

	  CASE CAA->nNomFacCaA == 4  // Solo Padre
	       cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)

	  CASE CAA->nNomFacCaA == 5  // Solo Madre
	       cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)

	  CASE CAA->nNomFacCaA == 6  // Solo Acudiente
	       cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)
	  ENDCASE
       ELSE
	  cNomFac := cNomEst+'.'
       ENDIF
       RETURN cNomFac
*>>>>FIN SELECCION DEL NOMBRE PARA EL RECIBO

/*************************************************************************
* TITULO..: RECIBO DE PAGO GENERICO                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 06/2007 VIE A
       Colombia, Bucaramanga        INICIO: 08:30 AM   JUL 06/2007 VIE

OBJETIVOS:

1- Calcula toda la informacion para la impresi¢n de los recibos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		 cMaeAct,cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,;
		 nNroLis,cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,;
		 dPagOpo,dPagExt,lPagExt,cMensaj,nVlrMes,nMesIni,;
		 nMesFin,lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		 nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		 nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		 nFavDes,nSdoFav,nRecNro)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
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
       nFavDes                              // @Saldo a Favor Descontado
       nSdoFav                              // Saldo a Favor
       nRecNro                              // N£mero del Recibo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodMzp := ''                  // C¢digos de las coordenadas de impresi¢n
       LOCAL nTotPrn := 3                   // Total de Impresiones
       LOCAL cNroRef := ''                  // N£mero de la Referencia
       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
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
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       IF SCO->lHayNroCon
	  IF SCO->nNroFacCon >= 99999999
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
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       cMesIni := STR(nMesIni,2)
       cMesFin := IF(nMesFin == NIL,cMesIni,STR(nMesFin,2))
       lCorrecion(@cMesIni)
       lCorrecion(@cMesFin)

       IF !EMPTY(BAN->nDigVerBan)

	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+cMesIni+cMesFin+;
		     EVAL(bDigChe,cCodEst+cMesIni+cMesFin)

	  cCodFac := cCodEst+cMesIni+cMesFin
       ELSE
	  cCodFac := cCodEst+cMesIni+cMesFin
       ENDIF
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+cMesIni+cMesFin

       cNroRef := cCodFac+cAnoUsr+cCodEmp+cNroFac
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>DETALLES DEL RECIBO
       LineaMzp(cCodMzp,cNomEmp,nTotPrn)
     *ÀNombre de la Empresa

       LineaMzp(cCodMzp,SCO->cCodEmpCon+'-'+cNroFac,nTotPrn)
     *ÀN£mero de la factura

       LineaMzp(cCodMzp,RTRIM(cNomBan),nTotPrn)
     *ÀNombre del Banco

       LineaMzp(cCodMzp,RTRIM(cCtaBan),nTotPrn)
     *ÀN£mero de la cuenta del Banco

       LineaMzp(cCodMzp,cNomEst,nTotPrn)
     *ÀNombre del Estudiante

       LineaMzp(cCodMzp,cCurso,nTotPrn)
     *ÀCurso del Estudiante

       LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
     *ÀFecha de Expedici¢n

       LineaMzp(cCodMzp,cMeses,nTotPrn)
     *ÀPeriodo facturado

*OJO VOY AQUI
*>>>>FIN DETALLES DEL RECIBO

*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('RES;SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')

       IF nRecNro == 8
	  Post('MZP 0.0,2.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,3.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,3.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,3.6;BOX 3.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,4.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,4.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,4.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,5.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,5.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,9.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,9.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,9.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,10.5; TEXT "ALUMNO";')

	  Post('CMNT "BOLANTE COLEGIO";')
	  Post('MZP 0.0,11.5; BOX 20.33,7.3;')
	  Post('MZP 0.0,12.6; BOX 20.33,0.4;')
	  Post('MZP 0.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 10.0,12.6; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,13.0; BOX 3.33,0.4;')
	  Post('MZP 0.0,13.4; BOX 20.33,0.8;')
	  Post('MZP 0.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 5.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 10.0,13.4; BOX 5.0,0.8;')
	  Post('MZP 0.0,14.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 5.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 10.0,14.2; BOX 5.0,3.8;')
	  Post('MZP 0.0,18.0; BOX 20.33,0.4;')
	  Post('MZP 0.0,18.0; BOX 6.5,0.8;')
	  Post('MZP 12.5,18.0; BOX 2.5,0.8;')
	  Post('MZP 17.0,19.3; TEXT "COLEGIO";')

	  Post('CMNT "BOLANTE BANCO";')
	  Post('MZP 0.0,20.0; BOX 20.33,6.5;')
	  Post('MZP 0.0,20.8; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 20.33,0.4;')
	  Post('MZP 0.0,21.2; BOX 3.33,0.4;')
	  Post('MZP 0.0,21.6; BOX 6.0,4.9;')
	  Post('MZP 0.0,21.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,22.1; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.6; BOX 2.0,1.0;')
	  Post('MZP 0.0,23.1; BOX 6.0,0.5;')
	  Post('MZP 0.0,23.6; BOX 6.0,0.5;')
	  Post('MZP 0.0,24.1; BOX 6.0,0.5;')

	  Post('MZP 6.0,21.6; BOX 14.33,0.3;')
	  Post('MZP 6.0,21.6; BOX 8.5,0.3;')
	  Post('MZP 6.0,24.1; BOX 14.33,0.3;')
	  Post('MZP 6.0,24.1; BOX 8.5,0.3;')

	  Post('MZP 17.0,27.0; TEXT "BANCO";')
	  Post('FSET 1p5v;')
	  Post('CMNT "BOLANTE ALUMNO";')

	  Post('FSET 1p10v;')
	  Post('MZP 0.3,2.8;  TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,11.8; TEXT "'+cNomEmp+'";')
	  Post('MZP 0.3,20.3; TEXT "'+cNomEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 0.3,3.2;  TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,12.2; TEXT "'+cEmpPal+'";')
	  Post('MZP 0.3,20.5; TEXT "'+cEmpPal+'";')

	  Post('FSET 1p4v;')
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 8
	  Post('FSET 1p10v;')
	  Post('MZP 15.0,3.5;  TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  Post('MZP 15.0,12.5; TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  Post('MZP 15.0,20.7; TEXT "RECIBO No.'+SCO->cCodEmpCon+'-'+cNroFac+'";')
       ELSE
	  Post('FSET 1p7v;')

	  cCodMzp := '7.0,3.4;' +;
		     '7.0,12.0;'+;
		     '7.0,20.5;'
	  LineaMzp(cCodMzp,cNomEmp,nTotPrn)
	*ÀNombre de la Empresa

	  cCodMzp := '17.0,3.7;'+;
		     '17.0,12.3;'+;
		     '17.0,20.8;'
	  LineaMzp(cCodMzp,SCO->cCodEmpCon+'-'+cNroFac,nTotPrn)
	*ÀN£mero de la factura

       ENDIF

       Post('FSET 1p7v;')
       IF nRecNro == 8
	  Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ELSE

	  cCodMzp := '4.0,4.2;'+;
		     '4.0,12.8;'+;
		     '2.5,22.6;'
	  LineaMzp(cCodMzp,RTRIM(cNomBan),nTotPrn)
	*ÀNombre del Banco

       ENDIF

       IF nRecNro == 8
	  Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ELSE

	  cCodMzp := '14.0,4.2;'+;
		     '14.0,12.8;'+;
		     '2.5,23.2;'
	  LineaMzp(cCodMzp,RTRIM(cCtaBan),nTotPrn)
	*ÀN£mero de la cuenta del Banco

       ENDIF

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)

       IF nRecNro == 8
	  Post('MZP 0.3,4.3; TEXT "NOMBRE"; MZP 3.9,4.3; TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,13.3;TEXT "NOMBRE"; MZP 3.9,13.3;TEXT "'+cNomEst+'";')
	  Post('MZP 0.3,21.5;TEXT "NOMBRE"; MZP 4.0,21.5;TEXT "'+cNomEst+'";')

	  Post('MZP 0.3,4.7; TEXT "CODIGO ESTUDIANTE"; MZP 0.5,5.1; TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,13.7;TEXT "CODIGO ESTUDIANTE"; MZP 0.5,14.1;TEXT "'+cCodFac+'";')
	  Post('MZP 0.3,24.0;TEXT "CODIGO"; MZP 2.5,24.0;TEXT "'+cCodFac+'";')

	  Post('MZP 5.5,4.7; TEXT "CURSO"; MZP 5.7,5.1; TEXT "'+cCurso+'";')
	  Post('MZP 5.5,13.7;TEXT "CURSO"; MZP 5.7,14.1;TEXT "'+cCurso+'";')
	  Post('MZP 0.3,24.5; TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')

	  Post('MZP 10.5,4.7; TEXT "FACTURADO"; MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
	  Post('MZP 10.5,13.7;TEXT "FACTURADO"; MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
	  Post('MZP  0.3,21.1;TEXT "FACTURADO"; MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')

	  Post('MZP 15.5,4.7; TEXT "MES(ES) A PAGAR"; MZP 15.7,5.1; TEXT "'+cMeses+'";')
	  Post('MZP 15.5,13.7;TEXT "MES(ES) A PAGAR"; MZP 15.7,14.1;TEXT "'+cMeses+'";')
	  Post('MZP 13.5,21.1;TEXT "MES(ES) A PAGAR"; MZP 17.5,21.1;TEXT "'+cMeses+'";')
       ELSE

	  cCodMzp := '4.0,4.6;'+;
		     '4.0,13.2;'+;
		     '4.0,21.7;'
	  LineaMzp(cCodMzp,cNomEst,nTotPrn)
	*ÀNombre del Estudiante

	  cCodMzp := '0.5,5.4;'+;
		     '0.5,14.0;'+;
		     '2.5,24.1;'
	  LineaMzp(cCodMzp,cCodFac,nTotPrn)
	*ÀC¢digo de la Factura

	  cCodMzp := '5.7,5.4;'+;
		     '5.7,14.0;'+;
		     '2.5,24.6;'
	  LineaMzp(cCodMzp,cCurso,nTotPrn)
	*ÀCurso del Estudiante

	  cCodMzp := '10.7,5.4;'+;
		     '10.7,14.0;'+;
		     '3.9,21.3;'
	  LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
	*ÀFecha de Expedici¢n

	  cCodMzp := '15.7,5.4;'+;
		     '15.7,14.0;'+;
		     '17.5,21.3;'
	  LineaMzp(cCodMzp,cMeses,nTotPrn)
	*ÀPeriodo facturado
       ENDIF

       IF nRecNro == 8
	  Post('MZP 1.5,5.5; TEXT "CONCEPTO";')
	  Post('MZP 1.5,14.5;TEXT "CONCEPTO";')

	  Post('MZP 6.5,5.5; TEXT "MORA";')
	  Post('MZP 6.5,14.5;TEXT "MORA";')

	  Post('MZP 11.5,5.5; TEXT "VALOR MES";')
	  Post('MZP 11.5,14.5;TEXT "VALOR MES";')

	  Post('MZP 16.5,5.5; TEXT "TOTAL";')
	  Post('MZP 16.5,14.5;TEXT "TOTAL";')
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
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

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon08(nMesIni,nMesIni,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
	   *Impresi¢n de conceptos
ELSE
	    nVlrMes := nVlrCon08(nMesIni,nMesIni,cCodGru,cConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis)
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

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon08(nMesIni,nMesFin,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis)
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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 8
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.5;'+;
		     '6.5,18.1;'+;
		     '10.5,22.1;'
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha pago oportuno

	  cCodMzp := '18.5,9.5;'+;
		     '18.5,18.1;'+;
		     '18.5,22.1;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nSdoFav,"***,***,***"),nTotPrn)
	*ÀValor para el pago oportuno

       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF CAA->lIntPenCaA
	  IF nNroLis # 0
	     nVlrInt := ROUND(((IF(CAA->nMesAmnCaA==nMesIni,0,CLI->nSdoActCli)+;
				   ABS(nVlrPag))*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
	  ENDIF
       ELSE
	  nVlrInt := IF(nVlrTot == 0,0,CAA->nVlrMorCaA)
       ENDIF
      *Calculo de los intereses

       IF lPagExt
	  IF nRecNro == 8
	     Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	     Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	     Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	     Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ELSE

	     cCodMzp := '6.5,9.9;'+;
			'6.5,18.7;'+;
			'10.5,24.5;'
	     LineaMzp(cCodMzp,cFecha(dPagExt),nTotPrn)
	   *ÀFecha Pago Extemporaneo

	     cCodMzp := '18.5,9.9;'+;
			'18.5,18.7;'+;
			'18.5,24.5;'
	     LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***"),nTotPrn)
	   *ÀValor a pagar en fecha Extemporanea.

	  ENDIF
       ENDIF

/*
       cMensaj := ''
       cCodMzp := '0.3,10.2;'
       LineaMzp(cCodMzp,cMensaj,1)
*/

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

*>>>>IMPRESION PARTE DEL BANCO
       Post('FSET 1p6v;')

       IF nRecNro == 8
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrTot+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 8
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE

	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtOpo,nTotPrn,1)
	*ÀTexto del C¢digo de Barras para el pago oportuno.

       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt+nSdoFav,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 8

	  Post('MZP 10.0,26.5; TEXT"'+cTxtExt+'";')

	  Post('UNIT C;')
	  Post('MZP 9.0,22.1;')
	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')
	  Post('MZP 9.0,24.6;')
	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')

       ELSE

	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtExt,nTotPrn,2)
	*ÀTexto del C¢digo de Barras para el pago Extemporaneo

	  Post('UNIT C;')

	  cCodMzp := '7.5,22.5;7.5,24.9;'
	  Post('MZP '+cPosMzpXY(cCodMzp,1))
	*ÀCoordenadas para el c¢digo de Barras Oportuno

	  Post('FONT 7;')
	  Post('UNIT D;')

	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')

	  Post('UNIT C;')

	  cCodMzp := '7.5,22.5;7.5,24.9;'
	  Post('MZP '+cPosMzpXY(cCodMzp,2))
	*ÀCoordenadas para el c¢digo de Barras Extemporaneo

	  Post('FONT 7;')
	  Post('Unit D;')
	  Post('Barc 42, N,'+'"'+cBarExt+'"'+',180,180,3,6,9,12,3,6,9,12;')
       ENDIF

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

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
* TITULO..: RECIBO DE PAGO No. 99                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 20/2014 VIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   NOV 20/2024 VIE

OBJETIVOS:

1- Recibo dise¤ado con base al recibo No.08 de los colegios de la Salle

2- Imprime el recibo de pago con c¢digo de barras utilizando
   el lenguaje PRESCRIBE de las impresoras Kiosera.

3- Imprime el recibo SIN formato preimpreso

4- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecibo99(aP1,aP2,aP3,aRecFac,;
		   nDiaMor,nNroFac,nNroLis,cConcep,nIntMor,lPagExt,nVlrMes,;
		   lPrnGru,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,nVlrCo5,nVlrCo6,;
		   nVlrCo7,nVlrCo8,lHayBec,nVlrBec,nDescue,nPagPar,nRecarg,;
		   nDesGen,nRecGen,cConGen,nFavDes,nSdoFav)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aRecFac                              // Recibo Facturado */
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

*>>>>DECLARACION PARAMETROS DEL RECIBO
       LOCAL cCodEan := xPrm(aP3,'cCodEan') // C¢digo EAN13 para el recaudo
       LOCAL cCodFac := xPrm(aP3,'cCodFac') // C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION, 03->RESTAURANTE,04->TRANSPORTE

       LOCAL cCodIso := xPrm(aP3,'cCodIso') // C¢digo Iso

       LOCAL cCodEst := xPrm(aP3,'cCodEst') // C¢digo del Estudiante
       LOCAL cCodGru := xPrm(aP3,'cCodGru') // C¢digo del Grupo
       LOCAL cNomEst := xPrm(aP3,'cNomEst') // Nombre del Estudiante
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nMesFin := xPrm(aP3,'nMesFin') // Mes Finale

       LOCAL cNomBan := xPrm(aP3,'cNomBan') // Nombre del Banco
       LOCAL cCtaBan := xPrm(aP3,'cCtaBan') // Cuenta del Banco

       LOCAL dFecOpo := xPrm(aP3,'dFecOpo') // Fecha Oportuna
       LOCAL dFecExt := xPrm(aP3,'dFecExt') // Fecha Extemporanea

       LOCAL nVlrOpo := xPrm(aP3,'nVlrOpo') // Valor pago oportuno
       LOCAL nVlrExt := xPrm(aP3,'nVlrExt') // Valor pago extemporaneo

       LOCAL cTxtUno := xPrm(aP3,'cTxtUno')
       LOCAL cTxtDos := xPrm(aP3,'cTxtDos')
*>>>>DECLARACION PARAMETROS DEL RECIBO

       LOCAL cCodMzp := ''                  // C¢digos de las coordenadas de impresi¢n
       LOCAL nTotPrn := 3                   // Total de Impresiones
       LOCAL cMsgTxt := ''                  // Texto variable

       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL cNroRef := ''                  // N£mero de la Referencia
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL nNroCop := 0                   // N£mero de Copias
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar

       LOCAL lDesGen := .F.                 // .T. Hay Descuento General
       LOCAL lHayDes := .F.                 // .T. Hay Descuentos
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nTipDes := 0                   // Tipo de descuento

       LOCAL nVlrPen := 0                   // Valor de la pension
       LOCAL nPorBec := 0                   // Porcentaje de la beca


*>>>>DECLARACION DE VARIABLES
*       LOCAL nNroFac := 0                   // N£mero de la Factura
       LOCAL cNroFac := ''                  // N£mero de la Factura

       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago

       LOCAL cCodRef := ''                  // Codigo de la referencia
       LOCAL cMeses  := ''                  // Meses a pagar

       LOCAL cVlrBar := ''                  // Valor para c¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo

       LOCAL aPrmRec := {}                  // Parametros del Recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       nNroLen := 74

       IF SCO->lHayNroCon
	  IF SCO->nNroFacCon >= 99999999
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
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
       ELSE
	  nNroFac := 0
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>CALCULO DEL DIGITO DE CHEQUEO
       cMesIni := STR(nMesIni,2)
       cMesFin := IF(nMesFin == NIL,cMesIni,STR(nMesFin,2))
       lCorrecion(@cMesIni)
       lCorrecion(@cMesFin)

       IF !EMPTY(BAN->nDigVerBan)

	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+cMesIni+cMesFin+;
		     EVAL(bDigChe,cCodEst+cMesIni+cMesFin)

	  cCodFac := cCodEst+cMesIni+cMesFin
       ELSE
	  cCodFac := cCodEst+cMesIni+cMesFin
       ENDIF
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+cMesIni+cMesFin

       cNroRef := cCodFac+cAnoUsr+cCodEmp+cNroFac
       cNroRef := cCodFac
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

*>>>>DETERMINACION DEL RECIBO POR ADELANTADO
       IF nMesFin == NIL
	  lPorAde := .F.
       ELSE
	  lPorAde := .T.
       ENDIF
*>>>>FIN DETERMINACION DEL RECIBO POR ADELANTADO

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		 SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)

       cMeses := cMes(nMesIni,3)+'-'+;
		 IF(lPorAde,cMes(nMesFin,3),cMes(nMesIni,3))
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>ANALISIS DEL NUMERO DE COPIAS
       IF nNroLis # 0
	  nNroCop := VAL(cCopias(nMesIni))
       ELSE
	  nNroCop := 0
       ENDIF
*>>>>FIN ANALISIS DEL NUMERO DE COPIAS

       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)

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
	  CASE nTipDes == 1 .OR. nTipDes == 4    // Descuento o Pago Parcial

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

	  CASE nTipDes == 2    // Recargo

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
	  nVlrBec := CLI->nVlrBecCli
       ENDIF
ELSE
   lHayBec := .F.
ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE BECA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       IF !lPorAde

**********IMPRESION DEL DESCUENTO O DEL RECARGO
	    IF lHayDes

	       DO CASE
	       CASE nTipDes == 1 .OR. nTipDes == 4
		    IF nTipDes == 1
		       cMsgTxt := 'DESCUENTO'
		       IF CAA->lNomConDes
			  cMsgTxt := DES->cNombreCon
		       ENDIF
		    ELSE
		       cMsgTxt := 'P PARCIAL'
		    ENDIF
	       CASE nTipDes == 2
		       cMsgTxt := 'RECARGO  '
		       IF CAA->lNomConDes
			  cMsgTxt := DES->cNombreCon
		       ENDIF
	       ENDCASE

	       IF CAA->lNomConDes
	       ENDIF

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DEL VALOR DE LOS CONCEPTOS
	    lHayBec := .F.
	    nSdoFav := IF(nSdoFav == NIL,0,nSdoFav)
IF nNroLis # 0
	    nVlrMes := nVlrCon08(nMesIni,nMesIni,cCodGru,@cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis,;
				 aRecFac,nDiaMor)
	   *Impresi¢n de conceptos

ELSE
	    nVlrMes := nVlrCon08(nMesIni,nMesIni,cCodGru,@cConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis,;
				 aRecFac,nDiaMor)
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

	       cCodMzp := '0.3,6.3;'+;
			  '0.3,14.9;'
	       LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	     *ÀDescripcion Descuento,Recargo,Pago Parcial

	       cCodMzp := '13.5,6.3;'+;
			  '13.5,14.9;'
	       LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	     *ÀValor del Descuento,Recargo,Pago Parcial

	    ENDIF
**********FIN IMPRESION DEL DESCUENTO O DEL RECARGO

**********IMPRESION DE LOS CONCEPTOS
	    nVlrPen := 0
	    lHayBec := .F.
	    nVlrMes := nVlrCon08(nMesIni,nMesFin,cCodGru,@cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis,;
				 aRecFac,nDiaMor)
	   *Impresi¢n de conceptos

	    IF VALTYPE(nVlrMes) == 'C'
	       SET FIXED ON
	       RETURN 'Error'
	    ENDIF
**********FIN IMPRESION DE LOS CONCEPTOS

**********REALIZACION DEL DESCUENTO POR BECA
	    IF CAA->nMtdFacCaA == 2
	       nVlrTot := nTarIniFin(cCodGru,nMesIni,nMesFin,cConcep)+;
			    CLI->nSdoActCli+CLI->nSdoMorCli
	    ELSE
	       nVlrTot := nVlrMes * (nMesFin - nMesIni + 1) +;
			  IF(CAA->nMesAmnCaA==nMesIni,0,;
			     CLI->nSdoActCli+CLI->nSdoMorCli)
	      *Total del Recibo sin descuentos y sin becas
	    ENDIF

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

*>>>>REALIZACION DEL DESCUENTO DEL SALDO A FAVOR
       IF nNroLis # 0
	  IF ClI->nSdoFavCli # 0
	     IF nVlrTot >= CLI->nSdoFavCli
		nFavDes := CLI->nSdoFavCli
	     ELSE
		nFavDes := nVlrTot
	     ENDIF
	     nVlrTot := ROUND(nVlrTot - nFavDes,0)
	     nVlrPag := ROUND(nVlrMes - nFavDes,0)
	     nVlrMes := ROUND(nVlrMes - nFavDes,0)
	  ENDIF
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

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
       nMesFin := IF(nMesFin==NIL,nMesIni,nMesFin)
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

*>>>>GRABACION DEL RECIBO FACTURADO
       AADD(aRecFac,{'lShared',lShared})

       AADD(aRecFac,{'cCodEst',cCodEst})
       AADD(aRecFac,{'nMesIni',nMesIni})
       AADD(aRecFac,{'nMesFin',nMesFin})
       AADD(aRecFac,{'cEmpPal',cEmpPal})
       AADD(aRecFac,{'cNroNit',cNitEmp})
       AADD(aRecFac,{'cNomEmp',cNomEmp})
       AADD(aRecFac,{'cNroFac',cNroFac})
       AADD(aRecFac,{'cNomBan',cNomBan})
       AADD(aRecFac,{'cNroCta',cCtaBan})
       AADD(aRecFac,{'cCodEan',cCodEan})
       AADD(aRecFac,{'cNombre',cNomEst})
       AADD(aRecFac,{'cCodRef',cCodFac})
       AADD(aRecFac,{'cCodGru',cCodGru})
       AADD(aRecFac,{'cFecFac',cFecha(DATE())})
       AADD(aRecFac,{'cPagOpo',cFecha(dFecOpo)})
       AADD(aRecFac,{'cPagExt',cFecha(dFecExt)})
       AADD(aRecFac,{'cPerFac',cMeses})

/*
       AADD(aRecFac,{'cNomCo1',})
       AADD(aRecFac,{'cVlrMo1',})
       AADD(aRecFac,{'cVlrMe1',})
       AADD(aRecFac,{'cVlrTo1',})
       AADD(aRecFac,{'cNomCo2',})
       AADD(aRecFac,{'cVlrMo2',})
       AADD(aRecFac,{'cVlrMe2',})
       AADD(aRecFac,{'cVlrTo2',})
       AADD(aRecFac,{'cNomCo3',})
       AADD(aRecFac,{'cVlrMo3',})
       AADD(aRecFac,{'cVlrMe3',})
       AADD(aRecFac,{'cVlrTo3',})
       AADD(aRecFac,{'cNomCo4',})
       AADD(aRecFac,{'cVlrMo4',})
       AADD(aRecFac,{'cVlrMe4',})
       AADD(aRecFac,{'cVlrTo4',})
       AADD(aRecFac,{'cNomCo5',})
       AADD(aRecFac,{'cVlrMo5',})
       AADD(aRecFac,{'cVlrMe5',})
       AADD(aRecFac,{'cVlrTo5',})
       AADD(aRecFac,{'cNomCo6',})
       AADD(aRecFac,{'cVlrMo6',})
       AADD(aRecFac,{'cVlrMe6',})
       AADD(aRecFac,{'cVlrTo6',})
       AADD(aRecFac,{'cNomCo7',})
       AADD(aRecFac,{'cVlrMo7',})
       AADD(aRecFac,{'cVlrMe7',})
       AADD(aRecFac,{'cVlrTo7',})
       AADD(aRecFac,{'cNomCo8',})
       AADD(aRecFac,{'cVlrMo8',})
       AADD(aRecFac,{'cVlrMe8',})
       AADD(aRecFac,{'cVlrTo8',})
       AADD(aRecFac,{'cNomCo9',})
       AADD(aRecFac,{'cVlrMo9',})
       AADD(aRecFac,{'cVlrMe9',})
       AADD(aRecFac,{'cVlrTo9',})
*/

       AADD(aRecFac,{'cVlrOpo',TRANSFORM(nVlrTot+nSdoFav,"***,***,***")})
       AADD(aRecFac,{'cVlrExt',TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")})
       AADD(aRecFac,{'cBarOpo',cTxtOpo})
       AADD(aRecFac,{'cBarExt',cTxtExt})
       AADD(aRecFac,{'cTxtUno','SOLO SE RECIBEN PAGOS EN EFECTIVO O CHEQUES DE GERENCIA'})
       AADD(aRecFac,{'cTxtDos','"LA CONGREGACION DE LOS HERMANOS DE LAS ESCUELAS ..."'})

       AADD(aRecFac,{'cNomUsr',cNomUsr})
       AADD(aRecFac,{'dFecUsr',DATE()})
       AADD(aRecFac,{'cHorUsr',TIME()})

       SaveRegRfa(aRecFac)

       RETURN nVlrTot
*>>>>FIN GRABACION DEL RECIBO FACTURADO