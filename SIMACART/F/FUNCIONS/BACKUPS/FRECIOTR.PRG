/*                        SIMA - CARTERA ACADEMICA
	   BIBLIOTECAS DE FUNCIONES PARA LOS RECIBOS DE OTRA FACTURACION


REQUERIMIENTOS:

- Compilar: clipper FReciOtr /w/m/b

OBJETIVOS:

- Funciones aplicadas para todos los recibos de facturaci¢n por
  conceptos diferentes a pension y que no afectan ning£n registro.

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: RECIBO OTROS CONCEPTOS No. 01                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 12:55 AM   JUN 19/96 MIE

OBJETIVOS:

1- Recibo No. 01 dise¤o para el Colegio la Salle.

2- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecOtr01(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,cJorTxt,;
		   nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   cMensaj,nVlrMes,nMesIni,lPrePrn,lPrnGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
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
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       nMesIni                              // Mes inicial del pago
       lPrePrn                              // .T. Forma Pre Impresa
       lPrnGru                              // .T. Impresi¢n por grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas

       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
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

	     REPL CAA->nNroFacCaA WITH CAA->nNroFacCaA+1
	     CAA->(DBCOMMIT())
	     IF lShared
		CAA->(DBUNLOCK())
	     ENDIF
	   *ÀGrabaci¢n de n£mero asignado

	  ENDIF
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>IMPRESION DE LA EMPRESA PRINCIPAL Y SU NIT
       IF !lPrePrn
	  @ PROW(),02            SAY cEmpPal
	  @ PROW(),nNroLen       SAY cEmpPal
	  @ PROW(),(nNroLen*2)-2 SAY cEmpPal

	  Linea_Recibo('NIT: '+cNitEmp+SPACE(19)+;
		       IF(CAA->lHayNroCaA,'No. '+PADL(nNroFac,9,'0'),''))
       ENDIF
*>>>>FIN IMPRESION DE LA EMPRESA PRINCIPAL Y SU NIT

*>>>>AVANCE DE LINEAS
      IF lPrePrn
	 nAvance := 4
	 IF lPrnGru
	    SendCodes(AVANCES)
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

       IF lPrePrn
	  Linea_Recibo(cCodEst+'1515'+;
		       SPACE(13)+;
		       cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		       SUBS(cJorTxt,1,1)+;
		       SPACE(09)+;
		       cFecha(DATE())+;
		       SPACE(05)+;
		       cMes(nMesIni,3),;
		       2,nNroLen)
       ELSE
	  Linea_Recibo('CODIGO: '+cCodEst+'1515'+SPACE(01)+;
		       'GRUPO:'+cConverNiv(SUBS(cCodGru,1,2))+;
					    SUBS(cCodGru,3,2)+;
		       SUBS(cJorTxt,1,1)+;
		       SPACE(03)+'FACT:'+cFecha(DATE()))
       ENDIF
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       IF !lPrePrn
	  cLinea := REPL ('-',48)
	  Linea_Recibo(cLinea)
	*ÀPrimera linea separadora

	  Linea_Recibo('|DESCRIPCION     '+;
		       '| ATRASOS | '+SPACE(02)+;
		       cMes(nMesIni,3)+SPACE(02)+;
		      ' |  TOTAL  |')

	  Linea_Recibo(cLinea)
	 *Segunda linea separadora
      ENDIF
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      IF lPrePrn
	 @ PROW()+2,02 SAY ''
	*L¡neas de espaciado para la forma preimpresa
      ENDIF
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nOtrCon01(cConcep,lPrePrn,nNroLen)
      *Impresi¢n de conceptos

       nVlrTot := nVlrMes
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DE LA TERCERA LINEA SEPARADORA
       IF !lPrePrn
	  @ PROW()+1,02          SAY REPL ('-',18)+' ALUMNO  '+;
				     REPL ('-',21)
	  @ PROW(),nNroLen       SAY REPL ('-',18)+' BANCO   '+;
				     REPL ('-',21)
	  @ PROW(),(nNroLen*2)-2 SAY REPL ('-',18)+' COLEGIO '+;
				     REPL ('-',21)
       ENDIF
*>>>>FIN IMPRESION DE LA TERCERA LINEA SEPARADORA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF lPrePrn
	  cMsgTxt  := SPACE(14)+cFecha(dPagOpo)+SPACE(30)+;
		      TRANSFORM(nVlrTot,"***,***,***")
       ELSE
	  cMsgTxt  := 'HASTA '+cFecha(dPagOpo)+' ..PAGUE $'+;
		      TRANSFORM(nVlrTot,"***,***,***")
       ENDIF
       Linea_Recibo(cMsgTxt,1,nNroLen)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       nVlrPag := nVlrTot
       nVlrInt := ROUND((ABS(nVlrPag)*nIntMor)/100,0)
      *Calculo de los intereses

       IF lPrePrn
	  cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
		     TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
       ELSE
	  cMsgTxt := 'HASTA '+cFecha(dPagExt)+' ..PAGUE $'+;
		     TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
       ENDIF
       Linea_Recibo(cMsgTxt,1,nNroLen)

       @ PROW()+IF(lPrePrn,5,1),(180-LEN(cMensaj))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       SET FIXED ON
       RETURN nVlrTot
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA

/*************************************************************************
* TITULO DEL PROGRAMA..: CONCEPTOS A COBRAR OTRO RECIBO No. 01           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:00 PM   JUN 19/96 MIE

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

FUNCTION nOtrCon01(cConcep,lPrePrn,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     cConcep                              // Conceptos por cobrar
       lPrePrn                              // .T. Recibo PreImpreso
       nNroLen                              // Longitud del Recibo */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cBlanco := ''                  // Linea en Blanco
       LOCAL nValor  := 0                   // Valor del Concepto
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nNroCon := 0                   // N£mero de Conceptos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
       LOCAL  nValorTco := ''               // Valor del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>CALCULO DE LOS CONCEPTOS
       lPrePrn := IF(lPrePrn == NIL,.F.,lPrePrn)
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       IF lPrePrn
	  nNroCon := (LEN(cConcep)/2)+3
       ELSE
	  nNroCon := LEN(cConcep)/2
       ENDIF
*>>>>FIN CALCULO DE LOS CONCEPTOS

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

**********LOCALIZACION DEL CONCEPTO
	    nValorTco := 0
	    IF lLocCodigo('cCodigoCon','CON',cCodigoTco)
		nValorTco := CON->nValorCon
	       cNombreTco := CON->cNombreCon
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LOCALIZACION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       IF lPrePrn
		  cMsgTxt := cNombreTco+SPACE(07)+;
			     SPACE(09)+;
			     SPACE(11)+;
			     TRANS(nValor,'9,999,999')+;
			     SPACE(05)+;
			     TRANS(nSubTot,'9,999,999')
	       ELSE
		   cMsgTxt :='|'+cNombreTco+;
			     '|         |'+TRANS(nValorTco,'9,999,999')+;
			     '|'+TRANS(nSubTot,'9,999,999')+'|'

	       ENDIF
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES DE LOS CONCEPTOS

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)

	       Linea_Recibo(cMsgTxt,1,nNroLen)

	       nVlrTot := nVlrTot + nSubTot
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

	  i := i + 1

       ENDDO
       RETURN nVlrTot
*>>>>IMPRESION DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 02                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 01/2006 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   FEB 01/2006 VIE

OBJETIVOS:

1- Recibo No. 02 dise¤o para la comunidad de la Salle.

2- Permite imprimir los recibos de consignaciones para la impresora
   kiosera Mita

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecOtr02(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   nNroFac,cNomBan,cCtaBan,cLugBan,dPagOpo,dPagExt,;
		   cCodRef,cConcep,nVlrTot)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       nNroFac                              // N£mero de la factura. Consecutivo
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       cCodRef                              // C¢digo de la Referencia
       cConcep                              // Concepto a consignar
       nVlrTot			            // @Valor recibo para un mes */
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

       LOCAL cCodMzp := ''                  // C¢digos de las coordenadas de impresi¢n
       LOCAL nTotPrn := 3                   // Total de Impresiones

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cCurso  := ''                  // Curso del Estudiante
       LOCAL cMeses  := ''                  // Meses de Pago
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL lPorAde := .F.                 // .T. = Recibo por Adelantado
       LOCAL nVlrPen := 0                   // Valor de la pension
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
	  cNroFac := cNroFac
	 *Lectura del n£mero de la factura
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

*>>>>IMPRESION DEL ENCABEZADO
       Post('!R!')
       Post('RES;SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')

       Post('FSET 1p7v;')

       cCodMzp := '7.0,3.4;' +;
		  '7.0,12.0;'+;
		  '7.0,20.5;'
       LineaMzp(cCodMzp,cNomEmp,nTotPrn)
     *ÀNombre de la Empresa

       cCodMzp := '17.0,3.7;'+;
		  '17.0,12.3;'+;
		  '17.0,20.8;'
       LineaMzp(cCodMzp,cNroFac,nTotPrn)
     *ÀN£mero de la factura

       Post('FSET 1p7v;')
       cCodMzp := '4.0,4.2;'+;
		  '4.0,12.8;'+;
		  '2.5,22.6;'
       LineaMzp(cCodMzp,RTRIM(cNomBan),nTotPrn)
     *ÀNombre del Banco

       cCodMzp := '14.0,4.2;'+;
		  '14.0,12.8;'+;
		  '2.5,23.2;'
       LineaMzp(cCodMzp,RTRIM(cCtaBan),nTotPrn)
     *ÀN£mero de la cuenta del Banco

       cCodMzp := '4.0,4.6;'+;
		  '4.0,13.2;'+;
		  '4.0,21.7;'
       LineaMzp(cCodMzp,'CONSIGNACION',nTotPrn)
     *ÀNombre del Estudiante

       cCodMzp := '0.5,5.4;'+;
		  '0.5,14.0;'+;
		  '2.5,24.1;'
       LineaMzp(cCodMzp,cCodRef,nTotPrn)
     *ÀC¢digo de la Factura

       cCodMzp := '5.7,5.4;'+;
		  '5.7,14.0;'+;
		  '2.5,24.6;'
       LineaMzp(cCodMzp,'',nTotPrn)
     *ÀCurso del Estudiante

       cCodMzp := '10.7,5.4;'+;
		  '10.7,14.0;'+;
		  '3.9,21.3;'
       LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
     *ÀFecha de Expedici¢n

       cCodMzp := '15.7,5.4;'+;
		  '15.7,14.0;'+;
		  '17.5,21.3;'
       LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
     *ÀPeriodo facturado
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>CONCEPTO CONSIGNADO
       cCodMzp := '0.3,6.3;'+;
		  '0.3,14.9;'
       LineaMzp(cCodMzp,cConcep,nTotPrn-1)
     *ÀDescripcion Descuento,Recargo,Pago Parcial

       cCodMzp := '13.5,6.3;'+;
		  '13.5,14.9;'
       LineaMzp(cCodMzp,TRANS(nVlrTot,'9,999,999'),nTotPrn-1)
     *ÀValor del Concepto
*>>>>FIN CONCEPTO CONSIGNADO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cCodMzp := '6.5,9.5;'+;
		  '6.5,18.1;'+;
		  '10.5,22.1;'
       LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
     *ÀFecha pago oportuno

       cCodMzp := '18.5,9.5;'+;
		  '18.5,18.1;'+;
		  '18.5,22.1;'
       LineaMzp(cCodMzp,TRANSFORM(nVlrTot,"***,***,***"),nTotPrn)
     *ÀValor para el pago oportuno
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       cCodMzp := '6.5,9.9;'+;
		  '6.5,18.7;'+;
		  '10.5,24.5;'
       LineaMzp(cCodMzp,cFecha(dPagExt),nTotPrn)
     *ÀFecha Pago Extemporaneo

       cCodMzp := '18.5,9.9;'+;
		  '18.5,18.7;'+;
		  '18.5,24.5;'
       LineaMzp(cCodMzp,TRANSFORM(nVlrTot,"***,***,***"),nTotPrn)
     *ÀValor a pagar en fecha Extemporanea.

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

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrTot,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cCodRef,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')

       cCodMzp := '8.5,24.2;8.5,26.7;'
       LineaMzp(cCodMzp,cTxtOpo,nTotPrn,1)
     *ÀTexto del C¢digo de Barras para el pago oportuno.

       cVlrBar := STR(nVlrTot,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cCodRef,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

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

       Post('RPU;RPF;RPP;')
       Post('Endm;')

       Post('EXIT;')
*>>>>FIN IMPRESION PARTE DEL BANCO

*>>>>GRABACION DEL CONTROL DEL RECIBO
       IF SCO->lHayNroCon

	  SaveRegRec(lShared,cNomUsr,cAnoUsr,;
		     nNroFac,;
		     'CONSIG',;
		     0,;
		     0,;
		     nVlrTot,;
		     1,;
		     CAA->cCodigoBan,;
		     SCO->cCodEmpCon,;
		     'REF: '+cCodRef)

       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: RECIBO DE PAGO No. 08                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2014 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   NOV 19/2024 VIE

OBJETIVOS:

1- Recibo en c¢digos de barras. Colegios de la Salle

2- Imprime el recibo de pago con c¢digo de barras utilizando
   el lenguaje PRESCRIBE de las impresoras Kiosera.

3- Imprime el recibo SIN formato preimpreso

4- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecOtr08(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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

       LOCAL cRefRec := xPrm(aP3,'cRefRec') // Referencia del Recibo

       LOCAL cNomBan := xPrm(aP3,'cNomBan') // Nombre del Banco
       LOCAL cCtaBan := xPrm(aP3,'cCtaBan') // Cuenta del Banco

       LOCAL aConRec := xPrm(aP3,'aConRec') // Conceptos del recibo

       LOCAL dFecOpo := xPrm(aP3,'dFecOpo') // Fecha Oportuna
       LOCAL dFecExt := xPrm(aP3,'dFecExt') // Fecha Extemporanea

       LOCAL nVlrOpo := xPrm(aP3,'nVlrOpo') // Valor pago oportuno
       LOCAL nVlrExt := xPrm(aP3,'nVlrExt') // Valor pago extemporaneo

       LOCAL cTxtUno := xPrm(aP3,'cTxtUno')
       LOCAL cTxtDos := xPrm(aP3,'cTxtDos')
*>>>>DECLARACION PARAMETROS DEL RECIBO

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFac := 0                   // N£mero de la Factura
       LOCAL cNroFac := ''                  // N£mero de la Factura

       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago

       LOCAL cRefBar := ''                  // Referencia C¢digo Barras
       LOCAL cMeses  := ''                  // Meses a pagar
       LOCAL cFecFac := ''                  // Fecha de Facturaci¢n

       LOCAL cVlrBar := ''                  // Valor para c¢digo de Barras
       LOCAL cBarOpo := ''                  // C¢digo Barra Oportuno
       LOCAL cBarExt := ''                  // C¢digo Barra Extemporanea
       LOCAL cTxtOpo := ''                  // Texto Oportuno
       LOCAL cTxtExt := ''                  // Texto Extemporaneo

       LOCAL aPrmRec := {}                  // Parametros del Recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)

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
	  cNroFac := cNroFac
	 *Lectura del n£mero de la factura
       ENDIF
*>>>>FIN ASIGNACION DEL NUMERO DE LA FACTURA

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

*>>>>DETALLES DEL RECIBO
       cMesIni := STR(nMesIni,2)
       cMesFin := STR(nMesFin,2)
       lCorrecion(@cMesIni)
       lCorrecion(@cMesFin)

       cNroFac := SCO->cCodEmpCon+'-'+cNroFac

       IF EMPTY(cRefRec)
	 cRefRec := cCodEst+cMesIni+cMesFin
       ENDIF
       cRefBar := cRefRec

       cFecFac := cFecha(DATE())+' - CONSIGNACION'

       IF EMPTY(cRefRec)
	  cMeses := cAnoUsr+':'+;
		    cCodFac+':'+;
		    cMes(nMesIni,3)+'-'+;
		    cMes(nMesFin,3)
       ELSE
	  cMeses := cAnoUsr
       ENDIF

       cVlrBar := STR(nVlrOpo,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cRefBar,cVlrBar,;
			     cFecNum(dFecOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       cVlrBar := STR(nVlrExt,10)
       lCorrecion(@cVlrBar,.T.)
       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cRefBar,cVlrBar,;
			     cFecNum(dFecExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea
*>>>>FIN DETALLES DEL RECIBO

*>>>>IMPRESION DEL RECIBO
       aPrmRec := {}
       AADD(aPrmRec,{'cNomEmp',cNomEmp})
       AADD(aPrmRec,{'cEmpPal',cEmpPal})
       AADD(aPrmRec,{'cNitEmp',cNitEmp})
       AADD(aPrmRec,{'cCodIso',cCodIso})
       AADD(aPrmRec,{'cNroFac',cNroFac})

       AADD(aPrmRec,{'cNomBan',cNomBan})
       AADD(aPrmRec,{'cCtaBan',cCtaBan})
       AADD(aPrmRec,{'cNomEst',cNomEst})
       AADD(aPrmRec,{'cRefRec',cRefRec})

       IF EMPTY(cRefRec)
	  AADD(aPrmRec,{'cCurso',cNomNiv(SUBS(cCodGru,1,2))})
       ELSE
	  AADD(aPrmRec,{'cCurso',''})
       ENDIF

       AADD(aPrmRec,{'cFecFac',cFecFac})
       AADD(aPrmRec,{'cMeses',cMeses})
       AADD(aPrmRec,{'aConRec',aConRec})

       AADD(aPrmRec,{'cFecOpo',cFecha(dFecOpo)})
       AADD(aPrmRec,{'cFecExt',cFecha(dFecExt)})

       AADD(aPrmRec,{'cVlrOpo',TRANSFORM(nVlrOpo,"***,***,***")})
       AADD(aPrmRec,{'cVlrExt',TRANSFORM(nVlrExt,"***,***,***")})

       AADD(aPrmRec,{'cBarOpo',cBarOpo})
       AADD(aPrmRec,{'cBarExt',cBarExt})

       AADD(aPrmRec,{'cTxtOpo',cTxtOpo})
       AADD(aPrmRec,{'cTxtExt',cTxtExt})

       AADD(aPrmRec,{'cTxtUno',cTxtUno})
       AADD(aPrmRec,{'cTxtDos',cTxtDos})

       FrmRec08(aPrmRec)

       RETURN nVlrOpo
*>>>>FIN IMPRESION DEL RECIBO
