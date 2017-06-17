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
* TITULO..: RECIBO DE MATRICULA O PENSION  No. 01                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:40 PM   AGO 14/96 MIE

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula seg£n los parametros pasados.

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr01(lShared,cEmpPal,cNitEmp,cNomEmp,cJorTxt,nNroFac,;
		    cCodEst,cNomEst,cCodGru,cNomBan,cCtaBan,cLugBan,;
		    cConcep,nIntMor,dPagOpo,dPagExt,lPagExt,cMensaj,;
		    nVlrMes,aVlrCon,nMesIni,nMesFin,lPrePrn,lPrnGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrePrn                              // .T. Forma Pre Impresa
       lPrnGru                              // .T. Impresi¢n por grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SETPRC(0,0)
       lPrePrn := IF(lPrePrn == NIL,.F.,lPrePrn)
       nNroLen := IF(lPrePrn,74,57)

       IF ANO->lHayNroAno .AND. !lPrePrn
	  IF ANO->nNroFacAno >= 999999999
	     SET DEVICE TO SCREEN
	     cError('SE EXCEDIO EL LIMITE DE LA FACTURACION')
	     SET DEVICE TO PRINT
	     SET FIXED ON
	     RETURN 'C'
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA FACTURACION

*>>>>ASIGNACION DEL NUMERO DE LA FACTURA
       IF ANO->lHayNroAno .AND. !lPrePrn
	  IF ANO->(lRegLock(lShared,.F.))

	     nNroFac := ANO->nNroFacAno+1
	    *Lectura del n£mero de la factura

	     REPL ANO->nNroFacAno WITH ANO->nNroFacAno+1
	     ANO->(DBCOMMIT())
	     IF lShared
		ANO->(DBUNLOCK())
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
		       IF(ANO->lHayNroAno,'No. '+PADL(nNroFac,9,'0'),''))
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
	  Linea_Recibo(cNomEst,IF(lPrePrn,2,1),nNroLen)
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

       IF lPrePrn
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)+;
		       SPACE(11)+;
		       cFecha(DATE())+;
		       SPACE(05)+;
		       IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				       cMes(nMesFin,3),'MATRICULA'),;
		       IF(lPrePrn,2,1),nNroLen)
       ELSE
	  Linea_Recibo('CODIGO: '+cCodFac+SPACE(02)+;
		       'NIVEL: '+cConverNiv(SUBS(cCodGru,1,2))+;
		       SUBS(cJorTxt,1,1)+SPACE(02)+;
		       'FACT:'+cFecha(DATE()))
       ENDIF
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       IF !lPrePrn
	  cLinea := REPL ('-',48)
	  Linea_Recibo(cLinea)
	*ÀPrimera linea separadora

	  Linea_Recibo('|DESCRIPCION     '+;
		       '| ATRASOS |'+;
		       IF(nMesIni # 13,IF(nMesIni==nMesFin,cMes(nMesIni,9),;
							   cMes(nMesFin,9)),;
			  'MATRICULA')+;
		       '|  TOTAL  |')

	  Linea_Recibo(cLinea)
	 *Segunda linea separadora
      ENDIF
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon01(@aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,;
			    lPrePrn,nNroLen)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION ULTIMA LINEA DE CONCEPTO
       IF nMesIni # 13 .AND. !lPrePrn
	  Linea_Recibo('|DE '+cMes(nMesIni,3)+'-'+cMes(nMesFin,3)+;
		       SPACE(06)+'|'+;
		       SPACE(09)+'|'+SPACE(09)+'|'+SPACE(09)+'|')
       ENDIF
*>>>>FIN IMPRESION ULTIMA LINEA DE CONCEPTO

*>>>>IMPRESION DE LA TERCERA LINEA SEPARADORA
       IF !lPrePrn
	  @ PROW()+1,02          SAY REPL ('-',18)+' ALUMNO  '+REPL ('-',21)
	  @ PROW(),nNroLen       SAY REPL ('-',18)+' BANCO   '+REPL ('-',21)
	  @ PROW(),(nNroLen*2)-2 SAY REPL ('-',18)+' COLEGIO '+REPL ('-',21)
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

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF lPrePrn
	  cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
		     TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
       ELSE
	  cMsgTxt := ''
	  IF lPagExt
	     cMsgTxt := 'HASTA '+cFecha(dPagExt)+' ..PAGUE $'+;
			TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
	  ENDIF
       ENDIF
       Linea_Recibo(cMsgTxt,1,nNroLen)

       @ PROW()+IF(lPrePrn,5,1),(180-LEN(cMensaj))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       SET FIXED ON
       RETURN nVlrTot
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:45 PM   AGO 14/96 MIE

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

FUNCTION nVlrCon01(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,lPrePrn,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
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

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      lPrePrn := IF(lPrePrn == NIL,.F.,lPrePrn)
      nNroLen := IF(nNroLen == NIL,57,nNroLen)
      IF lPrePrn
	 @ PROW()+2,02 SAY ''
	*L¡neas de espaciado para la forma preimpresa
      ENDIF
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       IF lPrePrn
	  nNroCon := (LEN(cConcep)/2)+3
       ELSE
	  cConcep := IF(nMesIni # 13,cConcep,cConcep+SPACE(02))
	  nNroCon := (LEN(cConcep)/2)
       ENDIF
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       cBlanco := '|                |         |         |         |'
       aVlrCon := {}
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
	    IF cCodigoTco <> SPACE(02)
	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       IF lPrePrn
		  cMsgTxt := cNombreTco+SPACE(07)+;
			     SPACE(20)+;
			     TRANS(nValorTco,'*,***,***')+;
			     SPACE(05)+;
			     TRANS(nSubTot,'*,***,***')
	       ELSE
		  cMsgTxt :='|'+cNombreTco+;
			    '|         |'+TRANS(nValorTco,'*,***,***')+;
			    '|'+TRANS(nSubTot,'*,***,***')+'|'
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
* TITULO..: RECIBO DE MATRICULA O PENSION  No. 02                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:40 PM   AGO 14/96 MIE

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula seg£n los parametros pasados.

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr02(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,aVlrCon,nMesIni,nMesFin,;
		   lPrePrn,lPrnGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar la Fecha Extemporanea
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrePrn                              // .T. Forma Pre Impresa
       lPrnGru                              // .T. Impresi¢n por grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*      #DEFINE  AVANCES CHR(27)+'J'+CHR(130)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // C¢digo de la factura
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL bDigChe := NIL                 // Code Bloc Digito de Chequeo.
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

*>>>>AVANCE DE LINEAS
      SETPRC(0,0)
      nNroLen := 69
      SendCodes(AVANCES)
      nAvance := 0
*>>>>FIN AVANCE DE LINEAS

*>>>>IMPRESION DEL NOMBRE Y CURSO
       cNomEst := SUBS(cNomEst+SPACE(50),1,50)

       cMsgTxt := cNomEst+SPACE(01)+;
		  cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)

       @ PROW()+nAvance,02    SAY cMsgTxt
       @ PROW(),nNroLen       SAY cMsgTxt
       @ PROW(),(nNroLen*2)-2 SAY cMsgTxt
*>>>>FIN IMPRESION DEL NOMBRE Y CURSO

*>>>>NOMBRE DEL BANCO
       lPrePrn := .F.
       IF ANO->nRecNroAno == 03
	  cNomBan := SPACE(LEN(cNomBan))
	  cCtaBan := SPACE(LEN(cCtaBan))
	  cMensaj := SPACE(01)
       ENDIF
       Linea_Recibo(SPACE(15)+cNomBan,1,nNroLen)
*>>>>FIN NOMBRE DEL BANCO

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
		    SPACE(07)+;
		    DTOC(DATE())+;
		    SPACE(02)+;
		    IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				    cMes(nMesFin,3),'MATRICULA'),;
		    IF(lPrePrn,2,1),nNroLen)
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon02(@aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,;
			    lPrePrn,nNroLen)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := SPACE(10)+cFecha(dPagOpo)+SPACE(29)+;
		      TRANSFORM(nVlrTot,"***,***,***")
       Linea_Recibo(cMsgTxt,1,nNroLen)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       cMsgTxt := SPACE(10)+cFecha(dPagExt)+SPACE(29)+;
		  TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
       Linea_Recibo(cMsgTxt,1,nNroLen)

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

*>>>>GRABACION DEL CONTROL DEL RECIBO
       IF SCO->lHayNroCon
	  SaveRegRec(lShared,cNomUsr,cAnoUsr,;
		     nNroFac,;
		     cCodEst,;
		     nMesIni,;
		     IF(nMesFin == NIL,nMesIni,nMesFin),;
		     nVlrTot,;
		     1,;   // Copia Original
		     ANO->cCodBanAno,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:45 PM   AGO 14/96 MIE

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

FUNCTION nVlrCon02(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,lPrePrn,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
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

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      nNroLen := 69

      SendCodes(CHR(27)+'J'+CHR(60))
     *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       nNroCon := (LEN(cConcep)/2)+1
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       aVlrCon := {}

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

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       cMsgTxt := cNombreTco+SPACE(07)+;
			  SPACE(18)+;
			  TRANS(nValorTco,'*,***,***')+;
			  SPACE(02)+;
			  TRANS(nSubTot,'*,***,***')
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
* TITULO..: RECIBO DE MATRICULA O PENSION Nros. 03 y 04                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 25/2000 VIE A
       Bucaramanga, Colombia        INICIO: 03:40 PM   AGO 25/2000 VIE

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula dise¤o para el Colegio la
   Salle con Colilla

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr03(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,aVlrCon,nMesIni,nMesFin,;
		   lPrnGru,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrnGru                              // .T. Impresi¢n por grupos
       nRecNro                              // N£mero del Recibo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*      #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
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
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
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

*>>>>AVANCE DE LINEAS
       nAvance := 4
       IF lPrnGru
	  SendCodes(AVANCES)
	  nAvance := 0
       ENDIF
*>>>>FIN AVANCE DE LINEAS

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)

       cMeses := IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				 cMes(nMesFin,3),'MATRICULA')
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

*>>>>IMPRESION DEL ENCABEZADO DEL RECIBO
       @ PROW()+nAvance,02    SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),nNroLen       SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),(nNroLen*2)-2 SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
     *ÀBanco o Corporaci¢n, Cuenta No

       nRecNro := IF(EMPTY(nRecNro),3,nRecNro)
       IF nRecNro == 3
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen,SPACE(nLenRes-4)+cNroFac)
	*ÀCon colilla
       ELSE
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen)
	*ÀSin colilla
       ENDIF
      *Colegio,Resumen

       IF nRecNro == 3
	  Linea_Recibo(cNomEst,2,nNroLen,SPACE(nLenRes)+cCodFac)
	*ÀCon colilla
       ELSE
	  Linea_Recibo(cNomEst,2,nNroLen)
	*ÀSin colilla
       ENDIF
      *Nombre,C¢digo

       IF nRecNro == 3
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso+SPACE(11)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen,SPACE(nLenRes)+cCurso)
	*ÀCon colilla
       ELSE
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso+SPACE(11)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen)
	*ÀSin colilla
       ENDIF
      *Codigo,Curso,Facturado,Mes(es),Resumen
*>>>>FIN IMPRESION DEL ENCABEZADO DEL RECIBO

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon03(@aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,nNroLen)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt := SPACE(14)+cFecha(dPagOpo)+SPACE(30)+;
		  TRANSFORM(nVlrTot,"***,***,***")

       IF nRecNro == 3
	  Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
		       TRANSFORM(nVlrTot,"***,***,***"))
	*ÀCon Colilla
       ELSE
	  Linea_Recibo(cMsgTxt,1,nNroLen)
	*ÀSin Colilla
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       cMsgTxt := SPACE(14)+cFecha(dPagExt)+SPACE(30)+;
		  TRANSFORM(nVlrTot+nVlrInt,"***,***,***")

       IF nRecNro == 3
	  Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
		       TRANSFORM(nVlrTot+nVlrInt,"***,***,***"))
	*ÀCon Colilla
       ELSE
	  Linea_Recibo(cMsgTxt,1,nNroLen)
	*ÀSin Colilla
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
		     nVlrTot,;
		     1,;   // Copia Original
		     ANO->cCodBanAno,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:45 PM   AGO 14/96 MIE

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

FUNCTION nVlrCon03(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nNroLen                              // Longitud del Recibo */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nNroCon := 0                   // N£mero de Conceptos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
       LOCAL  nValorTco := ''               // Valor del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      nNroLen := IF(nNroLen == NIL,57,nNroLen)
      @ PROW()+2,02 SAY ''
     *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       nNroCon := (LEN(cConcep)/2)+3
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       aVlrCon := {}
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

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       cMsgTxt := cNombreTco+SPACE(07)+;
			  SPACE(20)+;
			  TRANS(nValorTco,'*,***,***')+;
			  SPACE(05)+;
			  TRANS(nSubTot,'*,***,***')
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
* TITULO..: RECIBO DE MATRICULA O PENSION Nros. 05 y 06                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   FEB 28/2003 VIE

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula dise¤o para la impresora
   Kiosera

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr05(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,aVlrCon,nMesIni,nMesFin,;
		   lPrnGru,nRecNro,nDescue,nPagPar,nRecarg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrnGru                              // .T. Impresi¢n por grupos
       nRecNro                              // N£mero del Recibo
       nDescue                              // @Valor del Descuento
       nPagPar                              // @Pago Parcial
       nRecarg                              // @Valor del Recargo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL lHayDes := .F.                 // .T. Hay Descuentos
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nTipDes := 0                   // Tipo de descuento
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

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)

       cMeses := IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				 cMes(nMesFin,3),'MATRICULA')
*>>>>FIN CALCULO DEL CURSO Y MES(ES)

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


	  CASE nTipDes == 2    // Recargo

	       nDescue := 0
	       nRecarg := DES->nValorDes

	  ENDCASE
       ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS

*>>>>IMPRESION DEL DESCUENTO O DEL RECARGO
       IF lHayDes

	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4

	       IF nTipDes == 1
		  cMsgTxt := 'DESCUENTO'
		  IF ANO->lNomConDes
		     cMsgTxt := DES->cNombreCon
		  ENDIF
	       ELSE
		  cMsgTxt := 'P PARCIAL'
	       ENDIF

	  CASE nTipDes == 2

	       cMsgTxt := 'RECARGO  '
	       IF ANO->lNomConDes
		  cMsgTxt := DES->cNombreCon
	       ENDIF

	  ENDCASE

	  Post('MZP 0.3,6.0; TEXT "'+cMsgTxt+'";')
	  Post('MZP 0.3,15.0;TEXT "'+cMsgTxt+'";')

	  Post('MZP 13.5,6.0; TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')
	  Post('MZP 13.5,15.0;TEXT "'+TRANS(nVlrDes,'9,999,999')+'";')

       ENDIF
*>>>>FIN IMPRESION DEL DESCUENTO O DEL RECARGO

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon05(@aVlrCon,nMesIni,nMesFin,;
			    cCodGru,cConcep,nNroLen,lHayDes)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>REALIZACION DEL DESCUENTO O RECARGO
       IF lHayDes
	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4
	     nVlrTot := ROUND(nVlrTot - nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes - nVlrDes,0)
	  CASE nTipDes == 2
	     nVlrTot := ROUND(nVlrTot + nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes + nVlrDes,0)
	  ENDCASE
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO O RECARGO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 5
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
       ELSE
	  Post('MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF nRecNro == 5
	  Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
	  Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ELSE
	  Post('MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
	  Post('MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ENDIF

       Post('MZP 0.3,10.1; TEXT "'+cMensaj+'";')
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

*>>>>IMPRESION PARTE DEL BANCO
       Post('FSET 1p6v;')

       IF nRecNro == 5
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ELSE
	  Post('MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ENDIF

       cCodEan := IF(EMPTY(BAN->cEanCtaBan),SCO->cCodEanCon,BAN->cEanCtaBan)

       cVlrBar := STR(nVlrTot,10)
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

       cVlrBar := STR(nVlrTot+nVlrInt,10)
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
		     nVlrTot,;
		     1,;   // Copia Original
		     ANO->cCodBanAno,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   FEB 28/2003 VIE

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

FUNCTION nVlrCon05(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,nNroLen,lHayDes)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nNroLen                              // Longitud del Recibo
       lHayDes                              // .T. Hay Descuento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
       LOCAL  nValorTco := ''               // Valor del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      nNroLen := IF(nNroLen == NIL,57,nNroLen)
      @ PROW()+2,02 SAY ''
     *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       nNroCon := (LEN(cConcep)/2)+IF(lHayDes,2,3)
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       aVlrCon := {}

       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    cFilas1 := '6.4;6.8;7.2;7.6;8.0;8.4;8.8'
	    cFilas2 := '15.4;15.8;16.2;16.6;17.0;17.4;17.8'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)

	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValorTco,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValorTco,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES DE LOS CONCEPTOS

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nVlrTot := nVlrTot + nSubTot
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

	  i := i + 1

       ENDDO
       RETURN nVlrTot
*>>>>IMPRESION DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: RECIBO DE MATRICULA O PENSION Nros. 07 y 08                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   FEB 28/2003 VIE

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula dise¤o para la impresora
   Kiosera, dise¤o para la comunidad de la Salle.

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr07(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,cCodIso,nNroFac,cCodEst,cNomEst,cCodGru,;
		   cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,;
		   dPagExt,lPagExt,cMensaj,nVlrMes,aVlrCon,nMesIni,;
		   nMesFin,lPrnGru,nRecNro,nDescue,nPagPar,nRecarg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
       cCodIso                              // C¢digo Iso
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrnGru                              // .T. Impresi¢n por grupos
       nRecNro                              // N£mero del Recibo
       nDescue                              // @Valor del Descuento
       nPagPar                              // @Pago Parcial
       nRecarg                              // @Valor del Recargo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cTitNro := ''                  // Titulo de la Factura
       LOCAL cCenCos := ''                  // Centro de Costo
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
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar

       LOCAL lHayDes := .F.                 // .T. Hay Descuentos
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nTipDes := 0                   // Tipo de descuento
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

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+cMesIni+cMesFin

       cNroRef := cCodFac+cAnoUsr+cCodEmp+cNroFac
     *ÀNo lo lee bien el banco

       cNroRef := cCodFac
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)

       cMeses := IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				 cMes(nMesFin,3),'MATRICULA')
*>>>>FIN CALCULO DEL CURSO Y MES(ES)


*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')
       IF nRecNro == 7
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
	  Post('MZP 17.0,19.2; TEXT "COLEGIO";')
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
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp +'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

/*
	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
*/

	  Post('FSET 1p6v;')
	  Post('MZP 17.5,2.9;  TEXT "'+cCodIso+'";')
	  Post('MZP 17.5,11.9; TEXT "'+cCodIso+'";')
	  Post('MZP 17.5,20.3; TEXT "'+cCodIso+'";')

       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 7

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
       IF nRecNro == 7
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

       IF nRecNro == 7
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

       IF nRecNro == 7
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

       IF nRecNro == 7
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


	  CASE nTipDes == 2    // Recargo

	       nDescue := 0
	       nRecarg := DES->nValorDes

	  ENDCASE
       ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE TIENE DESCUENTOS

*>>>>IMPRESION DEL DESCUENTO O DEL RECARGO
       IF lHayDes

	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4

	       IF nTipDes == 1
		  cMsgTxt := 'DESCUENTO'
		  IF ANO->lNomConDes
		     cMsgTxt := DES->cNombreCon
		  ENDIF
	       ELSE
		  cMsgTxt := 'P PARCIAL'
	       ENDIF

	  CASE nTipDes == 2

	       cMsgTxt := 'RECARGO  '
	       IF ANO->lNomConDes
		  cMsgTxt := DES->cNombreCon
	       ENDIF

	  ENDCASE

	  IF nRecNro == 7  // Formato Impreso

	     cCodMzp := '0.3,5.9;'+;
			'0.3,14.9;'

	     LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	   *ÀDescripcion Descuento,Recargo,Pago Parcial

	     cCodMzp := '13.5,5.9;'+;
			'13.5,14.9;'
	     LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	   *ÀValor del Descuento,Recargo,Pago Parcial

	  ELSE

	     cCodMzp := '0.3,6.3;'+;
			'0.3,14.9;'
	     LineaMzp(cCodMzp,cMsgTxt,nTotPrn-1)
	   *ÀDescripcion Descuento,Recargo,Pago Parcial

	     cCodMzp := '13.5,6.3;'+;
			'13.5,14.9;'
	     LineaMzp(cCodMzp,TRANS(nVlrDes,'9,999,999'),nTotPrn-1)
	   *ÀValor del Descuento,Recargo,Pago Parcial

	  ENDIF

       ENDIF
*>>>>FIN IMPRESION DEL DESCUENTO O DEL RECARGO

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon07(@aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,;
			    nNroLen,nRecNro)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>REALIZACION DEL DESCUENTO O RECARGO
       IF lHayDes
	  DO CASE
	  CASE nTipDes == 1 .OR. nTipDes == 4
	     nVlrTot := ROUND(nVlrTot - nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes - nVlrDes,0)
	  CASE nTipDes == 2
	     nVlrTot := ROUND(nVlrTot + nVlrDes,0)
	     nVlrMes := ROUND(nVlrMes + nVlrDes,0)
	  ENDCASE
       ENDIF
*>>>>FIN REALIZACION DEL DESCUENTO O RECARGO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 7
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.7,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.7,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.7,9.5;'+;
		     '6.7,18.1;'+;
		     '10.5,22.1;'
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha pago oportuno

	  cCodMzp := '18.5,9.5;'+;
		     '18.5,18.1;'+;
		     '18.5,22.1;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot,"***,***,***"),nTotPrn)
	*ÀValor para el pago oportuno

       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF nRecNro == 7
	  Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.7,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.7,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
	  Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.7,9.9;'+;
		     '6.7,18.7;'+;
		     '10.5,24.5;'
	  LineaMzp(cCodMzp,cFecha(dPagExt),nTotPrn)
	*ÀFecha Pago Extemporaneo

	  cCodMzp := '18.5,9.9;'+;
		     '18.5,18.7;'+;
		     '18.5,24.5;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nVlrInt,"***,***,***"),nTotPrn)
	*ÀValor a pagar en fecha Extemporanea.

       ENDIF


       IF nRecNro == 7

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

       IF nRecNro == 7
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ENDIF

       cCodEan := IF(EMPTY(BAN->cEanCtaBan),SCO->cCodEanCon,BAN->cEanCtaBan)

       cVlrBar := STR(nVlrTot,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 7
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE
	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  LineaMzp(cCodMzp,cTxtOpo,nTotPrn,1)
	*ÀTexto del C¢digo de Barras para el pago oportuno.
       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 7
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
		     nVlrTot,;
		     1,;   // Copia Original
		     ANO->cCodBanAno,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   FEB 28/2003 VIE

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

FUNCTION nVlrCon07(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,nNroLen,nNroRec)

*>>>>PARAMATROS DE LA FUNCION
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nNroLen                              // Longitud del Recibo
       nNroRec                              // N£mero del Recibo */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
       LOCAL  nValorTco := ''               // Valor del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      nNroLen := IF(nNroLen == NIL,57,nNroLen)
      @ PROW()+2,02 SAY ''
     *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       nNroCon := (LEN(cConcep)/2)+3
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       aVlrCon := {}

       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF nNroRec == 7 // Formato Impreso

	       cFilas1 := '6.4;7.0;7.2;7.6;8.0;8.4;8.8;'
	       cFilas2 := '15.3;15.7;16.1;16.5;16.9;17.3;17.7;'

	    ELSE

	       cFilas1 := '6.6;6.8;7.2;7.6;8.0;8.4;8.8;'
	       cFilas2 := '15.3;15.7;16.1;16.5;16.9;17.3;17.7;'

	    ENDIF

	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)

	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValorTco,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValorTco,'9,999,999')+'";')

	       Post('MZP 18.5,'+cFilUno+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	       Post('MZP 18.5,'+cFilDos+;
				  'TEXT "'+TRANS(nSubTot,'9,999,999')+'";')
	    ENDIF
**********FIN ACUMULACION DE LOS VALORES DE LOS CONCEPTOS

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nVlrTot := nVlrTot + nSubTot
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

	  i := i + 1

       ENDDO
       RETURN nVlrTot
*>>>>IMPRESION DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: RECIBO DE MATRICULA O PENSION  No. 09                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2008 MAR A
       Bucaramanga, Colombia        INICIO: 10:30 AM   MAR 11/2008 MAR

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula seg£n los parametros pasados.

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr09(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,cNomBan,;
		   cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,dPagExt,;
		   lPagExt,cMensaj,nVlrMes,aVlrCon,nMesIni,nMesFin,;
		   lPrePrn,lPrnGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar la Fecha Extemporanea
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrePrn                              // .T. Forma Pre Impresa
       lPrnGru                              // .T. Impresi¢n por grupos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
*      #DEFINE  AVANCES CHR(27)+'J'+CHR(130)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // C¢digo de la factura
       LOCAL cMesIni := ''                  // Mes inicial de pago
       LOCAL cMesFin := ''                  // Mes final de pago
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
       LOCAL bDigChe := NIL                 // Code Bloc Digito de Chequeo.
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

*>>>>AVANCE DE LINEAS
      SETPRC(0,0)
      nNroLen := 69
      SendCodes(AVANCES)
      nAvance := 0
      nAvance := 4
*>>>>FIN AVANCE DE LINEAS

*>>>>IMPRESION DEL NOMBRE Y CURSO
       cNomEst := SUBS(cNomEst+SPACE(50),1,50)

       cMsgTxt := cNomEst+SPACE(01)+;
		  cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)

       @ PROW()+nAvance,02    SAY cMsgTxt
       @ PROW(),nNroLen       SAY cMsgTxt
       @ PROW(),(nNroLen*2)-2 SAY cMsgTxt
*>>>>FIN IMPRESION DEL NOMBRE Y CURSO

*>>>>NOMBRE DEL BANCO
       lPrePrn := .F.
       IF ANO->nRecNroAno == 03
	  cNomBan := SPACE(LEN(cNomBan))
	  cCtaBan := SPACE(LEN(cCtaBan))
	  cMensaj := SPACE(01)
       ENDIF
       Linea_Recibo(SPACE(15)+cNomBan,1,nNroLen)
*>>>>FIN NOMBRE DEL BANCO

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
		    SPACE(07)+;
		    DTOC(DATE())+;
		    SPACE(02)+;
		    IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				    cMes(nMesFin,3),'MATRICULA'),;
		    IF(lPrePrn,2,1),nNroLen)
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon09(@aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,;
			    lPrePrn,nNroLen)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := SPACE(10)+cFecha(dPagOpo)+SPACE(29)+;
		      TRANSFORM(nVlrTot,"***,***,***")
       Linea_Recibo(cMsgTxt,1,nNroLen)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       cMsgTxt := SPACE(10)+cFecha(dPagExt)+SPACE(29)+;
		  TRANSFORM(nVlrTot+nVlrInt,"***,***,***")
       Linea_Recibo(cMsgTxt,1,nNroLen)

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

*>>>>GRABACION DEL CONTROL DEL RECIBO
       IF SCO->lHayNroCon
	  SaveRegRec(lShared,cNomUsr,cAnoUsr,;
		     nNroFac,;
		     cCodEst,;
		     nMesIni,;
		     IF(nMesFin == NIL,nMesIni,nMesFin),;
		     nVlrTot,;
		     1,;   // Copia Original
		     ANO->cCodBanAno,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 MIE A
       Bucaramanga, Colombia        INICIO: 01:45 PM   AGO 14/96 MIE

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

FUNCTION nVlrCon09(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,lPrePrn,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
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

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      nNroLen := 69

      SendCodes(CHR(27)+'J'+CHR(60))
     *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       nNroCon := (LEN(cConcep)/2)+1
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       aVlrCon := {}

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

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)

	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)

	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       cMsgTxt := cNombreTco+SPACE(07)+;
			  SPACE(18)+;
			  TRANS(nValorTco,'*,***,***')+;
			  SPACE(02)+;
			  TRANS(nSubTot,'*,***,***')
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
* TITULO..: RECIBO DE MATRICULA O PENSION Nros. 10 y 11                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   FEB 28/2003 VIE

OBJETIVOS:

1- Permite imprimir el recibo de matr¡cula dise¤o para la impresora
   Kiosera, dise¤o para la comunidad de la Salle.

2- Permite imprimir opcionalmente los recibos de pensi¢n sencillos
   o recibos por adelantado de acuerdo como se pasen los parametros
   de la funci¢n.

3- Sintaxis: MZP Columna,Fila Unidad de medida:Cms  Ej: MZP 6,2

4- Retorna por referencia los param‚tros de la funci¢n marcados con @

5- Retorna el total de recibo


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRecMtr10(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,cCodIso,nNroFac,cCodEst,cNomEst,cCodGru,;
		   cNomBan,cCtaBan,cLugBan,cConcep,nIntMor,dPagOpo,;
		   dPagExt,lPagExt,cMensaj,nVlrMes,aVlrCon,nMesIni,;
		   nMesFin,lPrnGru,nRecNro,aColMzp)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
       cCodIso                              // C¢digo Iso
       nNroFac                              // N£mero de la factura. Consecutivo
       cCodEst			            // C¢digo del estudiante
       cNomEst				    // Nombre del Estudiante
       cCodGru                              // Grupo del Estudiante
       cNomBan		                    // Nombre del Banco
       cCtaBan		                    // N£mero de la cuenta
       cLugBan		                    // Lugar del Banco
       cConcep                              // Conceptos por cobrar
       nIntMor                              // Intereses por mora
       dPagOpo                              // Fecha pago oportuno
       dPagExt                              // Fecha pago Extemporaneo
       lPagExt                              // Visualizar el pago Extemporaneo
       cMensaj                              // Mensaje para facturacion
       nVlrMes                              // Valor recibo para un mes
       aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Mes Final del pago
       lPrnGru                              // .T. Impresi¢n por grupos
       nRecNro                              // N£mero del Recibo
       aColMzp                              // Columnas y Filas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cTitNro := ''                  // Titulo de la Factura
       LOCAL cCenCos := ''                  // Centro de Costo
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
       LOCAL nVlrTot := 0                   // Valor Total del recibo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrPag := 0                   // Valor del mes a pagar
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

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+cMesIni+cMesFin

       cNroRef := cCodFac+cAnoUsr+cCodEmp+cNroFac
     *ÀNo lo lee bien el banco

       cNroRef := cCodFac
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

*>>>>CALCULO DEL CURSO Y MES(ES)
       cCurso := cConverNiv(SUBS(cCodGru,1,2))+SUBS(cJorTxt,1,1)

       cMeses := IF(nMesIni # 13,cMes(nMesIni,3)+'-'+;
				 cMes(nMesFin,3),'MATRICULA')
*>>>>FIN CALCULO DEL CURSO Y MES(ES)


*>>>>IMPRESION DEL RECIBO
       Post('!R!')
       Post('SCU;SCF;SCP;UOM 300;')
       Post('UNIT C;')
       IF nRecNro == 10
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
	  Post('MZP 17.0,19.2; TEXT "COLEGIO";')

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
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp +'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

/*
	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
*/

	  Post('FSET 1p6v;')
	  Post('MZP 17.5,2.9;  TEXT "'+cCodIso+'";')
	  Post('MZP 17.5,11.9; TEXT "'+cCodIso+'";')
	  Post('MZP 17.5,20.3; TEXT "'+cCodIso+'";')

       ENDIF
*>>>>IMPRESION DEL RECIBO

*>>>>IMPRESION DEL ENCABEZADO
       IF nRecNro == 10

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

       ELSE

	  Post('FSET 1p7v;')

	  cCodMzp := '7.0,3.4;' +;
		     '7.0,12.0;'+;
		     '7.0,20.5;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'NomEmp')
	  ENDIF
	  LineaMzp(cCodMzp,cNomEmp,nTotPrn)
	*ÀNombre de la Empresa

	  cCodMzp := '17.0,3.7;'+;
		     '17.0,12.3;'+;
		     '17.0,20.8;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'NroFac')
	  ENDIF
	  LineaMzp(cCodMzp,SCO->cCodEmpCon+'-'+cNroFac,nTotPrn)
	*ÀN£mero de la factura

       ENDIF

       Post('FSET 1p7v;')
       IF nRecNro == 10
	  Post('MZP 0.3,3.9;  TEXT "BANCO";MZP 3.9,3.9; TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,12.9; TEXT "BANCO";MZP 3.9,12.9;TEXT "'+RTRIM(cNomBan)+'";')
	  Post('MZP 0.3,22.4; TEXT "BANCO";MZP 2.5,22.4;TEXT "'+RTRIM(cNomBan)+'";')
       ELSE

	  cCodMzp := '4.0,4.2;'+;
		     '4.0,12.8;'+;
		     '2.5,22.6;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'Banco ')
	  ENDIF
	  LineaMzp(cCodMzp,RTRIM(cNomBan),nTotPrn)
	*ÀNombre del Banco

       ENDIF

       IF nRecNro == 10
	  Post('MZP 10.5,3.9;  TEXT "CUENTA"; MZP 14.0,3.9; TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 10.5,12.9; TEXT "CUENTA"; MZP 14.0,12.9;TEXT "'+RTRIM(cCtaBan)+'";')
	  Post('MZP 0.3 ,22.9; TEXT "CUENTA"; MZP 2.5,22.9; TEXT "'+RTRIM(cCtaBan)+'";')
       ELSE
	  cCodMzp := '14.0,4.2;'+;
		     '14.0,12.8;'+;
		     '2.5,23.2;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'CtaBan')
	  ENDIF
	  LineaMzp(cCodMzp,RTRIM(cCtaBan),nTotPrn)
	*ÀN£mero de la cuenta del Banco
       ENDIF

       IF nRecNro == 10
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
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'NomEst')
	  ENDIF
	  LineaMzp(cCodMzp,cNomEst,nTotPrn)
	*ÀNombre del Estudiante

	  cCodMzp := '0.5,5.4;'+;
		     '0.5,14.0;'+;
		     '2.5,24.1;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'CodFac')
	  ENDIF
	  LineaMzp(cCodMzp,cCodFac,nTotPrn)
	*ÀC¢digo de la Factura

	  cCodMzp := '5.7,5.4;'+;
		     '5.7,14.0;'+;
		     '2.5,24.6;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'Curso')
	  ENDIF
	  LineaMzp(cCodMzp,cCurso,nTotPrn)
	*ÀCurso del Estudiante

	  cCodMzp := '10.7,5.4;'+;
		     '10.7,14.0;'+;
		     '3.9,21.3;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'FecExp')
	  ENDIF
	  LineaMzp(cCodMzp,cFecha(DATE()),nTotPrn)
	*ÀFecha de Expedici¢n

	  cCodMzp := '15.7,5.4;'+;
		     '15.7,14.0;'+;
		     '17.5,21.3;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'Meses')
	  ENDIF
	  LineaMzp(cCodMzp,cMeses,nTotPrn)
	*ÀPeriodo facturado

       ENDIF

       IF nRecNro == 10
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

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nVlrMes := nVlrCon10(@aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,nNroLen)
      *Impresi¢n de conceptos

       IF VALTYPE(nVlrMes) == 'C'
	  RETURN 'Error'
       ENDIF

       IF nMesIni == 13
	  nVlrTot := nVlrMes
       ELSE
	  nVlrTot := nVlrMes * (nMesFin - nMesIni + 1)
       ENDIF
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 10
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.5;'+;
		     '6.5,18.1;'+;
		     '10.5,22.1;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'FecOpo')
	  ENDIF
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha pago oportuno

	  cCodMzp := '18.5,9.5;'+;
		     '18.5,18.1;'+;
		     '18.5,22.1;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'VlrOpo')
	  ENDIF
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot,"***,***,***"),nTotPrn)
	*ÀValor para el pago oportuno

       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>VALOR DE LOS INTERESES
       IF nMesIni == 13
	  IF ANO->lIntMatAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorMatAno
	  ENDIF
       ELSE
	  IF ANO->lIntPenAno
	     nVlrInt := ROUND((nVlrMes*nIntMor)/100,0)
	  ELSE
	     nVlrInt := ANO->nMorPenAno
	  ENDIF
       ENDIF
*>>>>FIN VALOR DE LOS INTERESES

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF nRecNro == 10
	  Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
	  Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.9;'+;
		     '6.5,18.7;'+;
		     '10.5,24.5;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'FecExt')
	  ENDIF
	  LineaMzp(cCodMzp,cFecha(dPagExt),nTotPrn)
	*ÀFecha Pago Extemporaneo

	  cCodMzp := '18.5,9.9;'+;
		     '18.5,18.7;'+;
		     '18.5,24.5;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'VlrExt')
	  ENDIF
	  LineaMzp(cCodMzp,TRANSFORM(nVlrTot+nVlrInt,"***,***,***"),nTotPrn)
	*ÀValor a pagar en fecha Extemporanea.

       ENDIF

/*
       cMensaj := ''
       cCodMzp := '0.3,10.2;'
       LineaMzp(cCodMzp,cMensaj,1)
      *Impresion del mensaje de la facturacion
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

       IF nRecNro == 10
	  Post('MZP 6.2,21.8; TEXT "FECHA LIMITE OPORTUNA"; MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrTot,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrTot+nVlrInt,"***,***,***")+'";')
       ENDIF

       cCodEan := IF(EMPTY(BAN->cEanCtaBan),SCO->cCodEanCon,BAN->cEanCtaBan)

       cVlrBar := STR(nVlrTot,10)
       lCorrecion(@cVlrBar,.T.)
       cBarOpo := ''
       cTxtOpo := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagOpo,2),@cBarOpo)
     *ÀC¢digo de Barras pago Oportuno

       Post('FSET 1P6v;')
       IF nRecNro == 10
	  Post('MZP 10.0,23.9; TEXT"'+cTxtOpo+'";')
       ELSE
	  cCodMzp := '8.5,24.2;8.5,26.7;'
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'BarOpo')
	  ENDIF
	  LineaMzp(cCodMzp,cTxtOpo,nTotPrn,1)
	*ÀTexto del C¢digo de Barras para el pago oportuno.
       ENDIF

       cVlrBar := STR(nVlrTot+nVlrInt,10)
       lCorrecion(@cVlrBar,.T.)

       cBarExt := ''
       cTxtExt := cEanUcc128(cCodEan,cNroRef,cVlrBar,;
			     cFecNum(dPagExt,2),@cBarExt)
     *ÀC¢digo de Barras pago Extemporanea

       IF nRecNro == 10
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
	  IF ANO->lPreMzpAno
	     cCodMzp := xPrm(aColMzp,'BarExt')
	  ENDIF
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
		     nVlrTot,;
		     1,;   // Copia Original
		     ANO->cCodBanAno,;
		     SCO->cCodEmpCon)
       ENDIF
       RETURN nVlrTot
*>>>>FIN GRABACION DEL CONTROL DEL RECIBO

/*************************************************************************
* TITULO..: IMPRIME LOS CONCEPTO A COBRAR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 10:00 AM   FEB 28/2003 VIE

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

FUNCTION nVlrCon10(aVlrCon,nMesIni,nMesFin,cCodGru,cConcep,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     aVlrCon                              // Valor de los Conceptos
       nMesIni                              // Mes inicial de pago
       nMesFin                              // Mes final de pago
       cCodGru                              // C¢digo del grupo
       cConcep                              // Conceptos por cobrar
       nNroLen                              // Longitud del Recibo */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nValor  := 0                   // Valor del Concepto
       LOCAL nSubTot := 0                   // SubTotal del recibo
       LOCAL nVlrTot := 0                   // Valor Total del Recibo
       LOCAL nNroCon := 0                   // N£mero de Conceptos
       LOCAL cFilas1 := ''                  // Filas Desprendible No. 1
       LOCAL cFilas2 := ''                  // Filas Desprendible No. 2
       LOCAL cFilUno := ''                  // N£mero Fila Uno
       LOCAL cFilDos := ''                  // N£mero Fila Dos

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL cNombreTco := ''               // Nombre del concepto
       LOCAL  nValorTco := ''               // Valor del concepto
*>>>>IMPRESION DE LOS CONCEPTOS

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      nNroLen := IF(nNroLen == NIL,57,nNroLen)
      @ PROW()+2,02 SAY ''
     *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>CALCULO DE LOS CONCEPTOS
       nNroCon := (LEN(cConcep)/2)+3
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       aVlrCon := {}

       SELECT CON
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LA LINEA EN BLANCO
	    cCodigoTco := SPACE(02)
	    IF i <= 7
	       cCodigoTco := SUBS(cConcep,i*2-1,2)
	      *Lectura del concepto a cobrar
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

**********LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       nValorTco := nValorTar(cCodGru,cCodigoTco,@cNombreTco)
	       IF nValorTco == 0
		  RETURN 'Error'
	       ENDIF
	       AADD(aVlrCon,nValorTco)
	    ENDIF
	    cNombreTco := cNombreTco +;
			  SPACE(16-LEN(cNombreTco))
	   *Agrega espacios para no descuadrar facturacion

	    IF !EMPTY(CON->cNomExtCon)
	       cNombreTco := ALLTRIM(cNombreTco)+' '+;
			     ALLTRIM(CON->cNomExtCon)
	    ENDIF
**********FIN LECTURA DEL VALOR Y DESCRIPCION DEL CONCEPTO

**********ACUMULACION DE LOS VALORES DE LOS CONCEPTOS
	    cFilas1 := '6.7;7.1;7.5;7.9;8.3;8.7;9.1;'
	    cFilas2 := '15.3;15.7;16.1;16.5;16.9;17.3;17.7;'
	    cFilUno := SUBS(cFilas1,i*4-3,4)
	    cFilDos := SUBS(cFilas2,i*5-4,5)

	    IF cCodigoTco <> SPACE(02)
	       nSubTot := nValorTco
	       Post('MZP 0.3,'+cFilUno+;
				  'TEXT "'+cNombreTco+'";')
	       Post('MZP 0.3,'+cFilDos+;
				  'TEXT "'+cNombreTco+'";')

	       Post('MZP 13.5,'+cFilUno+;
				  'TEXT "'+TRANS(nValorTco,'9,999,999')+'";')
	       Post('MZP 13.5,'+cFilDos+;
				  'TEXT "'+TRANS(nValorTco,'9,999,999')+'";')

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
**********FIN ACUMULACION DE LOS VALORES DE LOS CONCEPTOS

**********IMPRESION DEL VALOR DEL CONCEPTO
	    IF cCodigoTco <> SPACE(02)
	       IF CON->lDesEfeDes
		  nVlrTot := nVlrTot - nSubTot
	       ELSE
		  nVlrTot := nVlrTot + nSubTot
	       ENDIF
	      *Suma del total a pagar
	    ENDIF
**********FIN IMPRESION DEL VALOR DEL CONCEPTO

	  i := i + 1

       ENDDO
       RETURN nVlrTot
*>>>>IMPRESION DE LOS CONCEPTOS