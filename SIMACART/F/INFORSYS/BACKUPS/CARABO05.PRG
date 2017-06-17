/*************************************************************************
* TITULO..: RECIBO DE ABONO No. 05                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2008 MAR A
       Colombia, Bucaramanga        INICIO: 09:30 PM   MAR 04/2008 MAR

OBJETIVOS:

1- Recibo No. 05 impresora c¢digo de barras.

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CarAbo_05(aP1,aP2,aP3,;
		   nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,;
		   cNomBan,cCtaBan,cLugBan,dPagOpo,dPagExt,;
		   cMensaj,nMesIni,nVlrAbo,nSdoAct,lPrnGru,;
		   nRecNro)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       nNroFac                              // @N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       nNroLis                              // N£mero de lista
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nMesIni                              // Mes del abono
       nVlrAbo                              // Valor del Abono
       nSdoAct                              // Saldo del Estudiante
       lPrnGru                              // .T. Impresi¢n por grupos
       nRecNro                              // N£mero del Recibo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago

       LOCAL cCodEan := ''                  // C¢digo EAN-13
       LOCAL cCodBar := ''                  // C¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo
       LOCAL cVlrBar := ''                  // Valor de la Barra

       LOCAL cTitNro := ''                  // Titulo de la Factura
       LOCAL cCenCos := ''                  // Centro de Costo
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
       lCorrecion(@cMesIni)
       IF !EMPTY(BAN->nDigVerBan)
	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+'14'+cMesIni+;
		     EVAL(bDigChe,cCodEst+'14'+cMesIni)
       ELSE
	  cCodFac := cCodEst+'14'+cMesIni
       ENDIF
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

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

       cMeses := cMes(nMesIni,3)
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

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
       Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
       Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
       Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
*>>>>FIN CUENTA DEL BANCO

*>>>>NOMBRE DEL ESTUDIANTE
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
       Post('MZP 0.3,24.5; TEXT "CURSO";MZP 2.5,24.5;TEXT "'+cCurso+'";')
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

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       DetAbo_05(nMesIni,nSdoAct,nVlrAbo,nNroLen)
      *Impresi¢n de conceptos
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
       Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

       Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
       Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

       Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')

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

       Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
       Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

       Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrAbo,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')

       cVlrBar := STR(nVlrAbo,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cCodFac,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

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

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

*>>>>GRABACION DEL CONTROL DEL RECIBO
       IF SCO->lHayNroCon
	  SaveRegRec(lShared,cNomUsr,cAnoUsr,;
		     nNroFac,;
		     cCodEst,;
		     14,;
		     nMesIni,;
		     nVlrAbo,;
		     1,;
		     CAA->cCodigoBan,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: CONCEPTOS A COBRAR RECIBO No. 05                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2000 LUN A
       Bucaramanga, Colombia        INICIO: 10:00 AM   SEP 14/2000 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite facturar los detalles del abono

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DetAbo_05(nNroMes,nSdoAct,nVlrAbo,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     nNroMes                              // Mes del Abono
       nSdoAct                              // Saldo Actual
       nVlrAbo                              // Valor del Abono
       nNroLen                              // Longitud del Recibo */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cConcep := ''                  // Conceptos para controlar LEN
       LOCAL nNroCon := 0                   // N£mero de Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS CONCEPTOS
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       cConcep := cSpaces('CAA','cConPenCaA')
       nNroCon := (LEN(cConcep)/2)+3
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS DETALLES DEL ABONO
       Post('MZP 0.3,6.4;'  +'TEXT "ABONO AL SALDO";')
       Post('MZP 0.3,15.4;' +'TEXT "ABONO AL SALDO";')
       Post('MZP 8.5,6.4;'  +'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
       Post('MZP 8.5,15.4;' +'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
       Post('MZP 13.5,6.4;' +'TEXT "'+TRANS(nVlrAbo,'9,999,999')+'";')
       Post('MZP 13.5,15.4;'+'TEXT "'+TRANS(nVlrAbo,'9,999,999')+'";')
       Post('MZP 18.5,6.4;' +'TEXT "'+TRANS(nSdoAct-nVlrAbo,'9,999,999')+'";')
       Post('MZP 18.5,15.4;'+'TEXT "'+TRANS(nSdoAct-nVlrAbo,'9,999,999')+'";')
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DETALLES DEL ABONO

