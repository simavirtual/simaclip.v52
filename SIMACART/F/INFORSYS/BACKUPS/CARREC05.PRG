/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 05                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2008 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   MAR 04/2008 MAR

OBJETIVOS:

1- Recibo No. 05 impresora codigo de barras

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCarRec05(aP1,aP2,aP3,;
		   nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,nMesIni,nMesFin,lPrnGru,;
		   nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,nVlrCo5,nVlrCo6,;
		   nVlrCo7,nVlrCo8,nVl2Co1,nVl2Co2,nVl2Co3,nVl2Co4,;
		   nVl2Co5,nVl2Co6,nVl2Co7,nVl2Co8,lHayBec,nVlrBec,;
		   nDescue,nPagPar,nRecarg,nDesGen,nRecGen,cConGen,;
		   nFavDes,nSdoFav)

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

       LOCAL cTitNro := ''                  // Titulo de la Factura
       LOCAL cCenCos := ''                  // Centro de Costo

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
       LOCAL nVlrTo2 := 0                   // Valor Total del recibo del valor2
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL lDesGen := .F.                 // .T. Hay Descuento General
       LOCAL lHayDes := .F.                 // .T. Hay Descuentos
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nTipDes := 0                   // Tipo de descuento

       LOCAL nPorBec := 0                   // Porcentaje de la beca
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL nVl2Mes := 0                   // Valor del mes del valor2
       LOCAL nNroCop := 0                   // N£mero de Copias
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

*>>>>IMPRESION DEL FORMATO DEL RECIBO
       Post('!R!')
       Post('SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')

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

       Post('FSET 1p6v;')
       Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
       Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
       Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

       Post('FSET 1p6v;')
       Post('MZP 17.5,2.9;  TEXT "'+xPrm(aP3,'cCodIso')+'";')
       Post('MZP 17.5,11.9; TEXT "'+xPrm(aP3,'cCodIso')+'";')
       Post('MZP 17.5,20.3; TEXT "'+xPrm(aP3,'cCodIso')+'";')
*>>>>FIN IMPRESION DEL FORMATO DEL RECIBO

*>>>>NUMERO DEL RECIBO
       IF SCO->lHayNroCon

	  Post('FSET 1p10v;')

	  cTitNro := IF(EMPTY(SCO->cTitNroCon),;
			'RECIBO No.',;
			ALLTRIM(SCO->cTitNroCon))

	  cCenCos := ALLTRIM(SCO->cCenCosCon)
	  IF EMPTY(SCO->cCenCosCon)
	     Post('MZP 15.0,3.5;  TEXT "'+cTitNro+SCO->cCodEmpCon+'-'+cNroFac+'";')
	     Post('MZP 15.0,12.5; TEXT "'+cTitNro+SCO->cCodEmpCon+'-'+cNroFac+'";')
	     Post('MZP 15.0,20.7; TEXT "'+cTitNro+SCO->cCodEmpCon+'-'+cNroFac+'";')
	  ELSE
	     Post('MZP 15.0,3.5;  TEXT "'+cTitNro+cCenCos+'-'+cNroFac+'";')
	     Post('MZP 15.0,12.5; TEXT "'+cTitNro+cCenCos+'-'+cNroFac+'";')
	     Post('MZP 15.0,20.7; TEXT "'+cTitNro+cCenCos+'-'+cNroFac+'";')
	  ENDIF

       ENDIF
*>>>>FIN NUMERO DEL RECIBO

*>>>>NOMBRE DEL BANCO
       Post('FSET 1p7v;')
       Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
       Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
       Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
*>>>>FIN NOMBRE DEL BANCO

*>>>>CUENTA DEL BANCO
/*
       Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
       Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
       Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
*/
       Post('MZP 10.5,3.9;  TEXT "'+RTRIM(cCtaBan)+'";')
       Post('MZP 10.5,12.9; TEXT "'+RTRIM(cCtaBan)+'";')
       Post('MZP 0.3 ,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
*>>>>FIN CUENTA DEL BANCO

*>>>>NOMBRE DEL ESTUDIANTE
       cNomEst := cNomFac(cMaeAct,cCodEst,cNomEst)
       cNomEst := SUBS(cNomEst+SPACE(67),1,67)

       Post('MZP 0.3,4.3; TEXT "NOMBRE"; MZP 3.9,4.3; TEXT "'+cNomEst+'";')
       Post('MZP 0.3,13.3;TEXT "NOMBRE"; MZP 3.9,13.3;TEXT "'+cNomEst+'";')
       Post('MZP 0.3,21.5;TEXT "NOMBRE"; MZP 4.0,21.5;TEXT "'+cNomEst+'";')
*>>>>FIN NOMBRE DEL ESTUDIANTE

*>>>>CODIGO DEL ESTUDIANTE
       Post('MZP 0.3,4.7; TEXT "CODIGO ESTUDIANTE"; MZP 0.5,5.1; TEXT "'+cCodFac+'";')
       Post('MZP 0.3,13.7;TEXT "CODIGO ESTUDIANTE"; MZP 0.5,14.1;TEXT "'+cCodFac+'";')
       Post('MZP 0.3,24.0;TEXT "CODIGO"; MZP 2.5,24.0;TEXT "'+cCodFac+'";')
*>>>>FIN CODIGO DEL ESTUDIANTE

*>>>>CURSO DEL ESTUDIANTE
       Post('MZP 5.5,4.7; TEXT "CURSO"; MZP 5.7,5.1; TEXT "'+cCurso+'";')
       Post('MZP 5.5,13.7;TEXT "CURSO"; MZP 5.7,14.1;TEXT "'+cCurso+'";')
       Post('MZP 0.3,24.5;TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')
*>>>>FIN CURSO DEL ESTUDIANTE

*>>>>FECHA DE FACTURACION
       Post('MZP 10.5,4.7; TEXT "FACTURADO"; MZP 10.7,5.1; TEXT "'+cFecha(DATE())+'";')
       Post('MZP 10.5,13.7;TEXT "FACTURADO"; MZP 10.7,14.1;TEXT "'+cFecha(DATE())+'";')
       Post('MZP  0.3,21.1;TEXT "FACTURADO"; MZP 3.9,21.1;TEXT "'+cFecha(DATE())+'";')
*>>>>FIN FECHA DE FACTURACION

*>>>>MESES A PAGAR
       Post('MZP 15.5,4.7; TEXT "MES(ES) A PAGAR"; MZP 15.7,5.1; TEXT "'+cMeses+'";')
       Post('MZP 15.5,13.7;TEXT "MES(ES) A PAGAR"; MZP 15.7,14.1;TEXT "'+cMeses+'";')
       Post('MZP 13.5,21.1;TEXT "MES(ES) A PAGAR"; MZP 17.5,21.1;TEXT "'+cMeses+'";')
*>>>>FIN MESES A PAGAR

*>>>>ENCABEZADOS DE COLUMNA
       Post('MZP 1.5,5.5; TEXT "CONCEPTO";')
       Post('MZP 1.5,14.5;TEXT "CONCEPTO";')

       Post('MZP 6.5,5.5; TEXT "MORA";')
       Post('MZP 6.5,14.5;TEXT "MORA";')

       Post('MZP 11.5,5.5; TEXT "VALOR MES";')
       Post('MZP 11.5,14.5;TEXT "VALOR MES";')

       Post('MZP 16.5,5.5; TEXT "TOTAL";')
       Post('MZP 16.5,14.5;TEXT "TOTAL";')
*>>>>FIN ENCABEZADOS DE COLUMNA

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
	    nVlrMes := nConRec05(nMesIni,nMesIni,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis,;
				 @nVl2Co1,@nVl2Co2,@nVl2Co3,@nVl2Co4,;
				 @nVl2Co5,@nVl2Co6,@nVl2Co7,@nVl2Co8,;
				 @nVl2Mes)
	   *Impresi¢n de conceptos
ELSE
	    nVlrMes := nConRec05(nMesIni,nMesIni,cCodGru,cConcep,;
				 0,NIL,;
				 lHayDes,nNroLen,@nVlrCo1,;
				 @nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,;
				 @nVlrCo8,@lHayBec,@nVlrBec,nSdoFav,nNroLis,;
				 @nVl2Co1,@nVl2Co2,@nVl2Co3,@nVl2Co4,;
				 @nVl2Co5,@nVl2Co6,@nVl2Co7,@nVl2Co8,;
				 @nVl2Mes)
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

	    nVlrTo2 := nVl2Mes+;
		       IF(CAA->nMesAmnCaA==nMesIni,0,;
			  CLI->nSdoActCli+CLI->nSdoMorCli)
ELSE
   nVlrTot := nVlrMes
   nVlrTo2 := nVl2Mes
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
	    nVlrMes := nConRec05(nMesIni,nMesFin,cCodGru,cConcep,;
				 CLI->nSdoActCli+CLI->nSdoMorCli,;
				 @nVlrPen,lHayDes,nNroLen,;
                                 @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				 @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				 @lHayBec,NIL,nSdoFav,nNroLis,;
				 @nVl2Co1,@nVl2Co2,@nVl2Co3,@nVl2Co4,;
				 @nVl2Co5,@nVl2Co6,@nVl2Co7,@nVl2Co8,;
				 @nVl2Mes)
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
       IF nNroLis # 0
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
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO DEL SALDO A FAVOR

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       DO CASE
       CASE CAA->nMtdFacCaA == 1

	    Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	    Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	    Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")+'";')
	    Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")+'";')

       OTHERWISE
	    Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	    Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	    Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	    Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
       ENDCASE
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

	  DO CASE
	  CASE CAA->nMtdFacCaA == 1
		Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
		Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

		Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
		Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	  OTHERWISE
		Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
		Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

		Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
		Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	  ENDCASE
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

       DO CASE
       CASE CAA->nMtdFacCaA == 1
	    Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	    Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")+'";')
       OTHERWISE
	    Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	    Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")+'";')
       ENDCASE

       DO CASE
       CASE CAA->nMtdFacCaA == 1
	    IF lPagExt
	       Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')
	       Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	    ELSE
	       Post('MZP 6.2,24.3;TEXT "FECHA LIMITE OPORTUNA    "; MZP 10.5,24.3; TEXT "'+cFecha(dPagOpo)+'";')
	       Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTo2+nSdoFav,"***,***,***")+'";')
	    ENDIF
       OTHERWISE
	    IF lPagExt
	       Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')
	       Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt+nSdoFav,"***,***,***")+'";')
	    ELSE
	       Post('MZP 6.2,24.3;TEXT "FECHA LIMITE OPORTUNA    "; MZP 10.5,24.3; TEXT "'+cFecha(dPagOpo)+'";')
	       Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nSdoFav,"***,***,***")+'";')
	    ENDIF
       ENDCASE

       cCodEan := SCO->cCodEanCon

       DO CASE
       CASE CAA->nMtdFacCaA == 1
	    cVlrBar := STR(nVlrTo2+nSdoFav,10)
       OTHERWISE
	    cVlrBar := STR(nVlrTot+nSdoFav,10)
       ENDCASE
       lCorrecion(@cVlrBar,.T.)

       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')


       DO CASE
       CASE CAA->nMtdFacCaA == 1
	    cVlrBar := STR(nVlrTot+nSdoFav,10)
       OTHERWISE
	    cVlrBar := STR(nVlrTot+nVlrInt+nSdoFav,10)
       ENDCASE
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF lPagExt
	  Post('MZP 10.0,26.3; TEXT"'+cTxtExt+'";')
       ELSE
	  Post('MZP 10.0,26.3; TEXT"'+cTxtOpo+'";')
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
       ELSE
	  Post('Barc 42, N,'+'"'+cBarOpo+'"'+',180,180,3,6,9,12,3,6,9,12;')
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

FUNCTION nConRec05(nMesIni,nMesFin,cCodGru,cConcep,nSdoAct,nVlrPen,;
		   lHayDes,nNroLen,nVlrCo1,nVlrCo2,nVlrCo3,nVlrCo4,;
		   nVlrCo5,nVlrCo6,nVlrCo7,nVlrCo8,lHayBec,nVlrBec,;
		   nSdoFav,nNroLis,;
		   nVl2Co1,nVl2Co2,nVl2Co3,nVl2Co4,;
		   nVl2Co5,nVl2Co6,nVl2Co7,nVl2Co8,nTotal2)

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
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable

       LOCAL nValor1 := 0                   // Valor1 del Concepto para el recibo
       LOCAL nValor2 := 0                   // Valor2 del Concepto para el recibo
       LOCAL nVl1Con := 0                   // Valor1 del Concepto para la Facturaci¢n
       LOCAL nVl2Con := 0                   // Valor1 del Concepto para la Facturaci¢n
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nSubTo2 := 0                   // SubTotal del recibo del valor2
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nVlrTo2 := 0                   // Valor Total del Recibo del valor2
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

       nVl2Co1 := 0; nVl2Co2 := 0; nVl2Co3 := 0; nVl2Co4 := 0
       nVl2Co5 := 0; nVl2Co6 := 0; nVl2Co7 := 0; nVl2Co8 := 0
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
	    nValor1 := 0
	    nValor2 := 0
	    nVl1Con := 0
	    nVl2Con := 0

	    IF nNroLis # 0 .AND. cCodigoTco <> SPACE(02)

	       nValor1 := nValorTar(cCodGru,cCodigoTco,@cNombreTco,@nValor2)

	       nVl1Con := nValor1
	       nVl2Con := nValor2

	       IF nValor1 == 0
		  RETURN 'Error'
	       ENDIF
	    ENDIF
**********FIN LECTURA DE LA TARIFA Y DESCRIPCION DEL CONCEPTO

**********LECTURA DEL VALOR DEL CONCEPTO Y DESCRIPCION PARA SOLO FACTURAR
	    IF nNroLis == 0 .AND. cCodigoTco <> SPACE(02)

	       IF !lLocCodigo('cCodigoCon','CON',cCodigoTco)
		  cNombreTco := 'No Existe Con:'+cCodigoTco
		  nValor1 := 0
		  RETURN 'Error'
	       ELSE
		  cNombreTco := CON->cNombreCon
		  nValor1 := CON->nValorCon
		  IF nValor1 == 0
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
	    cFilas1 := '6.4;6.8;7.2;7.6;8.0;8.4;8.8'
	    cFilas2 := '15.4;15.8;16.2;16.6;17.0;17.4;17.8'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)
	    IF i = 1
	       nSubTot := IF(CAA->nMesAmnCaA==nMesIni,;
			     0,nSdoAct)+nValor1

	       nSubTo2 := IF(CAA->nMesAmnCaA==nMesIni,;
			     0,nSdoAct)+nValor2

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
				  'TEXT "'+TRANS(nValor1,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor1,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES A COBRAR CON SALDO

**********ACUMULACION DE LOS VALORES A COBRAR SIN SALDO
	    IF i <> 1

	       nSubTot := nValor1
	       nSubTo2 := nValor2

	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValor1,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValor1,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')

	    ENDIF
	    nVlrTot := nVlrTot + nSubTot
	    nVlrTo2 := nVlrTo2 + nSubTo2
	   *Suma del total a pagar
**********FIN ACUMULACION DE LOS VALORES A COBRAR SIN SALDO

	  i := i + 1

       ENDDO
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES
       IF nSdoAct # 0 .AND. EMPTY(cConcep)
	  nTotal := 0
	  nTotal2 := 0
       ELSE
	  nTotal := nVlrTot-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
	  nTotal2 := nVlrTo2-IF(CAA->nMesAmnCaA==nMesIni,0,nSdoAct)
       ENDIF
       RETURN nTotal
*>>>>FIN IMPRESION DEL SALDO EN MORA SIN CONCEPTOS PARA EL MES
