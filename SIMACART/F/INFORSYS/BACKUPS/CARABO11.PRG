/*************************************************************************
* TITULO..: RECIBO DE ABONO No. 11                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2008 MAR A
       Bucaramanga, Colombia        INICIO: 10:00 AM   MAR 11/2008 MAR

OBJETIVOS:

1- Recibo No. 11 dise¤o para los Colegios: Las Bethlemitas. Iso

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecAbo_11(aP1,aP2,aP3,;
		   nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		   cCtaBan,cLugBan,dPagOpo,dPagExt,cMensaj,nMesIni,nVlrAbo,;
		   nSdoAct,lPrePrn,lPrnGru)

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
       lPrePrn                              // .T. Forma Pre Impresa
       lPrnGru                              // .T. Impresi¢n por grupos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
*       #DEFINE  AVANCE CHR(27)+'J'+CHR(110)// 1/216" Avance de L¡neas
       #DEFINE  AVANCE CHR(27)+'J'+CHR(130)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                  // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes inicial de pago
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

*>>>>AVANCE DE LINEAS
      SET FIXED OFF
      SETPRC(0,0)
      nNroLen := 69
      SendCodes(AVANCE)
      nAvance := 0
      nAvance := 4
*>>>>FIN AVANCE DE LINEAS

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

*>>>>IMPRESION DEL NOMBRE Y CURSO
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
       lCorrecion(@cMesIni)

       IF !EMPTY(BAN->nDigVerBan)
	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+'14'+cMesIni+;
		     EVAL(bDigChe,cCodEst+'14'+cMesIni)
       ELSE
	  cCodFac := cCodEst+'14'+cMesIni+SPACE(02)
       ENDIF
     *ÀCalculo del digito de Chequeo

       Linea_Recibo(cCodFac+;
		    SPACE(03)+;
		    cCtaBan+;
		    SPACE(07)+;
		    cFecha(DATE())+;
		    SPACE(02)+;
		    cMes(nMesIni,3)+'-'+;
		    cMes(nMesIni,3),;
		    1,nNroLen)
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       SendCodes(CHR(27)+'J'+CHR(60))
      *Avance de L¡neas a 1/216

       DetAbo_11(nMesIni,nSdoAct,nVlrAbo,nNroLen)
      *Impresi¢n de conceptos
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := SPACE(10)+'ABONO AL SALDO'+SPACE(26)+;
		   TRANSFORM(nVlrAbo,"***,***,***")
       Linea_Recibo(cMsgTxt,2,nNroLen)

       cMsgTxt := ''
       Linea_Recibo(cMsgTxt,1,nNroLen)

       @ PROW()+1,(180-LEN(ALLTRIM(cMensaj)))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       SET FIXED ON
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

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
* TITULO DEL PROGRAMA..: CONCEPTOS A COBRAR RECIBO No. 02                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:00 PM   JUN 19/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de conceptos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Imprime los conceptos por cobrar del recibo de pago sencillo o por
   adelantado de acuerdo como se pasen los param‚tros de la funci¢n.

4- Esta funci¢n forma parte del funci¢n

5- Retorna El valor total de recibo sin intereses

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DetAbo_11(nNroMes,nSdoAct,nVlrAbo,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     nNroMes                              // Mes del Abono
       nSdoAct                              // Saldo Actual
       nVlrAbo                              // Valor del Abono
       nNroLen                              // Longitud del Recibo */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cBlanco := ''                  // Linea en Blanco
       LOCAL cConcep := ''                  // Conceptos para controlar LEN
       LOCAL nNroCon := 0                   // N£mero de Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS CONCEPTOS
       cConcep := SPACE(08)
       nNroCon := (LEN(cConcep)/2)
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LOS DETALLES DEL ABONO
	    IF i == 1
	       cMsgTxt := 'ABONO AL SALDO  '+SPACE(14)+;
			  TRANS(nSdoAct,'9,999,999')+;
			  SPACE(03)+;
			  TRANS(nVlrAbo,'9,999,999')+;
			  SPACE(01)+;
			  TRANS(nSdoAct-nVlrAbo,'9,999,999')

	       Linea_Recibo(cMsgTxt,1,nNroLen)
	    ENDIF
**********FIN IMPRESION DE LOS DETALLES DEL ABONO

**********IMPRESION DE LA LINEA EN BLANCO
	    IF i # 1
	       @ PROW()+1,02 SAY ''
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

	  i := i + 1

       ENDDO
       RETURN NIL
*>>>>IMPRESION DE LOS CONCEPTOS