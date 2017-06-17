/*                        SIMA - CARTERA ACADEMICA
	   BIBLIOTECAS DE FUNCIONES PARA LOS RECIBOS DE ABONOS


REQUERIMIENTOS:

- Compilar: clipper FuncsAbo /w/m/b

OBJETIVOS:

- Funciones aplicadas para todos los recibos de facturaci¢n de los
  abonos de los diferentes colegios.

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DEL PROGRAMA..: LECTURA DEL VALOR DEL ABONO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/96 LUN A
       Bucaramanga, Colombia        INICIO: 12:40 PM   JUL 08/96 LUN

OBJETIVOS:

1- Permite leer los detalles del abono

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Imprime los conceptos por cobrar del recibo de pago sencillo o por
   adelantado de acuerdo como se pasen los param‚tros de la funci¢n.

4- Retorna el valor del descuento

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrAbono(nNroFil,nNroCol,cCodEst,cNomEst,;
		   cCodGru,nMesAbo,nSaldo,cDescri)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del grupo
       nMesAbo                              // Mes del Abono
       nSaldo                               // Saldo del Estudiante
       cDescri                              // @Descripcion del abono */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrAbo := 0                   // Valor del Abono
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL ABONO
       @ nNroFil,nNroCol   SAY 'NOMBRE: '+cNomEst
       @ nNroFil+1,nNroCol-1 SAY '°CODIGO: '+cCodEst+SPACE(01)+'GRUPO: '+cCodGru

       @ nNroFil+3,nNroCol SAY 'DEUDA: '+TRANS(nSaldo,'99,999,999')
       @ nNroFil+4,nNroCol SAY 'ABONO: ' GET nVlrAbo PICT '99999999';
					 VALID !(nSaldo - nVlrAbo) < 0
       READ
       @ nNroFil+5,nNroCol+7 SAY '---------'
       @ nNroFil+6,nNroCol   SAY 'SALDO: '
       @ nNroFil+6,nNroCol+7 SAY nSaldo - nVlrAbo PICT '9,999,999'

       @ nNroFil+8,nNroCol SAY 'DESCRIPCION'
       @ nNroFil+9,nNroCol GET cDescri PICT '@!'
       READ

       RETURN nVlrAbo
*>>>>FIN DETALLES DEL ABONO

/*************************************************************************
* TITULO DE LA FUNCION..: RECIBO DE ABONO No. 01                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 12:55 AM   JUN 19/96 MIE

OBJETIVOS:

1- Recibo No. 01 dise¤o para el Colegio la Salle

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecAbo01(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,cJorTxt,;
		  cCodIso,nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,;
		  cNomBan,cCtaBan,cLugBan,dPagOpo,dPagExt,cMensaj,;
		  nMesIni,nVlrAbo,nSdoAct,lPrePrn,lPrnGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cJorTxt                              // Jornada escogida
       cCodIso                              // C¢digo Iso
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nNroLen := 0                  // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cMesIni := ''                  // Mes inicial de pago
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SendCodes(PCL('CondenOn'))
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
	  @ PROW(),02            SAY cEmpPal+SPACE(02)+cCodIso
	  @ PROW(),nNroLen       SAY cEmpPal+SPACE(02)+cCodIso
	  @ PROW(),(nNroLen*2)-2 SAY cEmpPal+SPACE(02)+cCodIso

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

       IF lPrePrn
	  Linea_Recibo(cCodFac+;
		       SPACE(11)+;
		       cConverNiv(SUBS(cCodGru,1,2))+SUBS(cCodGru,3,2)+;
		       SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)+;
		       SPACE(06)+;
		       cFecha(DATE())+;
		       SPACE(05)+;
		       cMes(nMesIni,3),;
		       2,nNroLen)
       ELSE
	  Linea_Recibo('CODIGO: '+cCodEst+'14'+cMesIni+SPACE(01)+;
		       'GRUPO:'+cConverNiv(SUBS(cCodGru,1,2))+;
					    SUBS(cCodGru,3,2)+;
		       SUBS(cJorTxt,1,1)+'-'+STR(nNroLis,2)+;
		       SPACE(01)+'FACT:'+cFecha(DATE()))
       ENDIF
*>>>>FIN IMPRESION DE LOS DATOS DEL ESTUDIANTE

*>>>>IMPRESION DE LOS ENCABEZADOS DE COLUMNA
       IF !lPrePrn
	  cLinea := REPL ('-',48)
	  Linea_Recibo(cLinea,1,nNroLen)
	*ÀPrimera linea separadora

	  Linea_Recibo('|DESCRIPCION     '+;
		       '|   '+cMes(nMesIni,3)+SPACE(03)+;
		       '| ATRASOS '+;
		       '|  SALDO  |')

	  Linea_Recibo(cLinea,1,nNroLen)
	 *Segunda linea separadora
      ENDIF
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
      IF lPrePrn
	 @ PROW()+2,02 SAY ''
	*L¡neas de espaciado para la forma preimpresa
      ENDIF
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       DetAbo01(nMesIni,nSdoAct,nVlrAbo,lPrePrn,nNroLen)
      *Impresi¢n de conceptos
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

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
	  cMsgTxt  := SPACE(14)+'ABONO'+SPACE(36)+;
		      TRANSFORM(nVlrAbo,"***,***,***")
       ELSE
	  cMsgTxt  := 'ABONO AL SALDO ..$'+TRANSFORM(nVlrAbo,"***,***,***")
       ENDIF
       Linea_Recibo(cMsgTxt,1,nNroLen)
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF lPrePrn
	  cMsgTxt := ''
       ELSE
	  cMsgTxt := 'FECHA DE PAGO....'+cFecha(DATE())
       ENDIF
       Linea_Recibo(cMsgTxt,1,nNroLen)

       @ PROW()+IF(lPrePrn,5,1),(180-LEN(cMensaj))/2 SAY cMensaj
      *Impresion del mensaje de la facturacion

       SET FIXED ON
       RETURN NIL
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA

/*************************************************************************
* TITULO DEL PROGRAMA..: CONCEPTOS A COBRAR RECIBO No. 01                *
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

FUNCTION DetAbo01(nNroMes,nSdoAct,nVlrAbo,lPrePrn,nNroLen)

*>>>>PARAMATROS DE LA FUNCION
/*     nNroMes                              // Mes del Abono
       nSdoAct                              // Saldo Actual
       nVlrAbo                              // Valor del Abono
       lPrePrn                              // .T. Recibo PreImpreso
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
       lPrePrn := IF(lPrePrn == NIL,.F.,lPrePrn)
       nNroLen := IF(nNroLen == NIL,57,nNroLen)
       cConcep := cSpaces('CAA','cConPenCaA')
       IF lPrePrn
	  nNroCon := (LEN(cConcep)/2)+3
       ELSE
	  nNroCon := LEN(cConcep)/2
       ENDIF
*>>>>FIN CALCULO DE LOS CONCEPTOS

*>>>>IMPRESION DE LOS CONCEPTOS
       cBlanco := '|                |         |         |         |'
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LOS DETALLES DEL ABONO
	    IF i == 1
	       IF lPrePrn
		  cMsgTxt := 'ABONO AL SALDO'+SPACE(16)+;
			     TRANS(nSdoAct,'9,999,999')+;
			     SPACE(05)+;
			     TRANS(nVlrAbo,'9,999,999')+;
			     SPACE(05)+;
			     TRANS(nSdoAct-nVlrAbo,'9,999,999')
	       ELSE
		   cMsgTxt := '|ABONO AL SALDO'+SPACE(02)+'|'+;
			      TRANS(nVlrAbo,'9,999,999')+'|'+;
			      TRANS(nSdoAct,'9,999,999')+'|'+;
			      TRANS(nSdoAct-nVlrAbo,'9,999,999')+'|'
	       ENDIF

	       Linea_Recibo(cMsgTxt,1,nNroLen)

	    ENDIF
**********FIN IMPRESION DE LOS DETALLES DEL ABONO

**********IMPRESION DE LA LINEA EN BLANCO
	    IF i # 1
	       IF lPrePrn
		  @ PROW()+1,02 SAY ''
	       ELSE
		  Linea_Recibo(cBlanco,1,nNroLen)
	       ENDIF
	    ENDIF
**********FIN IMPRESION DE LA LINEA EN BLANCO

	  i := i + 1

       ENDDO
       RETURN NIL
*>>>>IMPRESION DE LOS CONCEPTOS


/*************************************************************************
* TITULO DE LA FUNCION..: RECIBO DE ABONO No. 02                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/96 MIE A
       Bucaramanga, Colombia        INICIO: 12:55 AM   JUN 19/96 MIE

OBJETIVOS:

1- Recibo No. 02 dise¤o para los Colegios: La Merced,Las Bethlemitas

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecAbo02(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		  cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		  cCtaBan,cLugBan,dPagOpo,dPagExt,cMensaj,nMesIni,nVlrAbo,;
		  nSdoAct,lPrePrn,lPrnGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
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
*>>>>FIN PARAMETROS DE LA FUNCION

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
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AVANCE DE LINEAS
       SendCodes(PCL('CondenOn'))
       SETPRC(0,0)
       nNroLen := 69
       SendCodes(AVANCE)
       nAvance := 0
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

       DetAbo02(nMesIni,nSdoAct,nVlrAbo,nNroLen)
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

FUNCTION DetAbo02(nNroMes,nSdoAct,nVlrAbo,nNroLen)

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
       cConcep := cSpaces('CAA','cConPenCaA')
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

/*************************************************************************
* TITULO..: RECIBO DE ABONO No. 03                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2000 LUN A
       Bucaramanga, Colombia        INICIO: 08:30 AM   SEP 14/2000 LUN

OBJETIVOS:

1- Recibo No. 03 dise¤o para el Colegio la Salle con colilla

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecAbo03(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		  cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		  cCtaBan,cLugBan,dPagOpo,dPagExt,cMensaj,nMesIni,nVlrAbo,;
		  nSdoAct,lPrnGru,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
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
*>>>>FIN PARAMETROS DE LA FUNCION

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
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL LIMITE DE LA FACTURACION
       SendCodes(PCL('CondenOn'))
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
       lCorrecion(@cMesIni)
       IF !EMPTY(BAN->nDigVerBan)
	  bDigChe := &("{|n|cDigChe"+PADL(BAN->nDigVerBan,2,'0')+"(n)}")
	  cCodFac := cCodEst+'14'+cMesIni+;
		     EVAL(bDigChe,cCodEst+'14'+cMesIni)
       ELSE
	  cCodFac := cCodEst+'14'+cMesIni+SPACE(02)
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

*>>>>IMPRESION DEL ENCABEZADO DEL RECIBO
       @ PROW()+nAvance,02    SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),nNroLen       SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
       @ PROW(),(nNroLen*2)-2 SAY RTRIM(cNomBan)+SPACE(36)+RTRIM(cCtaBan)
     *ÀBanco o Corporaci¢n, Cuenta No

       nRecNro := IF(EMPTY(nRecNro),3,nRecNro)
       IF nRecNro == 3
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen,SPACE(nLenRes-5)+cNroFac+' ABO')
	*ÀCon colilla
       ELSE
	  Linea_Recibo(RTRIM(cNomEmp),2,nNroLen)
	*ÀSin colilla
       ENDIF
     *ÀColegio,Resumen

       IF nRecNro == 3
	  Linea_Recibo(cNomEst,2,nNroLen,SPACE(nLenRes)+cCodFac)
	*ÀCon colilla
       ELSE
	  Linea_Recibo(cNomEst,2,nNroLen)
	*ÀSin colilla
       ENDIF
     *ÀNombre,C¢digo

       IF nRecNro == 3
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso +SPACE(06)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen,SPACE(nLenRes)+cCurso)
	*ÀCon colilla
       ELSE
	  Linea_Recibo(cCodFac+SPACE(11)+;
		       cCurso +SPACE(06)+;
		       cFecha(DATE())+SPACE(05)+;
		       cMeses,2,nNroLen)
	*ÀSin colilla
       ENDIF
     *ÀCodigo,Curso,Facturado,Mes(es),curso
*>>>>FIN IMPRESION DEL ENCABEZADO DEL RECIBO

*>>>>LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA
       @ PROW()+2,02 SAY ''
      *L¡neas de espaciado para la forma preimpresa
*>>>>FIN LINEAS DE ESPACIADO PARA LA FORMA PREIMPRESA

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       DetAbo03(nMesIni,nSdoAct,nVlrAbo,nNroLen)
      *Impresi¢n de conceptos
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       cMsgTxt  := SPACE(14)+'ABONO PAGUESE HASTA '+;
		   cFecha(dPagOpo,3)+SPACE(10)+;
		   TRANSFORM(nVlrAbo,"***,***,***")

       IF nRecNro == 3
	  Linea_Recibo(cMsgTxt,1,nNroLen,SPACE(nLenRes+1)+;
		       TRANSFORM(nVlrAbo,"***,***,***"))
	*ÀCon colilla
       ELSE
	  Linea_Recibo(cMsgTxt,1,nNroLen)
	*ÀSin colilla
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       cMsgTxt := ''
       Linea_Recibo(cMsgTxt,1,nNroLen)

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
* TITULO..: CONCEPTOS A COBRAR RECIBO No. 03                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2000 LUN A
       Bucaramanga, Colombia        INICIO: 10:00 AM   SEP 14/2000 LUN

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

FUNCTION DetAbo03(nNroMes,nSdoAct,nVlrAbo,nNroLen)

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

*>>>>IMPRESION DE LOS CONCEPTOS
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LOS DETALLES DEL ABONO
	    IF i == 1
	       cMsgTxt := 'ABONO AL SALDO'+SPACE(16)+;
			  TRANS(nSdoAct,'9,999,999')+;
			  SPACE(05)+;
			  TRANS(nVlrAbo,'9,999,999')+;
			  SPACE(05)+;
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

/*************************************************************************
* TITULO..: RECIBO DE ABONO No. 05                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2000 LUN A
       Bucaramanga, Colombia        INICIO: 08:30 AM   SEP 14/2000 LUN

OBJETIVOS:

1- Recibo No. 05 impresora c¢digo de barras.

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecAbo05(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		  cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		  cCtaBan,cLugBan,dPagOpo,dPagExt,cMensaj,nMesIni,nVlrAbo,;
		  nSdoAct,lPrnGru,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
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
*>>>>FIN PARAMETROS DE LA FUNCION

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

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       DetAbo05(nMesIni,nSdoAct,nVlrAbo,nNroLen)
      *Impresi¢n de conceptos
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 5
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ELSE
	  Post('MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF nRecNro == 5
	  Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ELSE
	  Post('MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
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

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ELSE
	  Post('MZP 10.5,21.8; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrAbo,10)
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

       cVlrBar := STR(nVlrAbo,10)
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

FUNCTION DetAbo05(nNroMes,nSdoAct,nVlrAbo,nNroLen)

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

*>>>>IMPRESION DE LOS CONCEPTOS
       i := 1
       DO WHILE i <= nNroCon

**********IMPRESION DE LOS DETALLES DEL ABONO
	    IF i == 1
	       Post('MZP 0.3,6.4;'  +'TEXT "ABONO AL SALDO";')
	       Post('MZP 0.3,15.4;' +'TEXT "ABONO AL SALDO";')
	       Post('MZP 8.5,6.4;'  +'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
	       Post('MZP 8.5,15.4;' +'TEXT "'+TRANS(nSdoAct,'9,999,999')+'";')
	       Post('MZP 13.5,6.4;' +'TEXT "'+TRANS(nVlrAbo,'9,999,999')+'";')
	       Post('MZP 13.5,15.4;'+'TEXT "'+TRANS(nVlrAbo,'9,999,999')+'";')
	       Post('MZP 18.5,6.4;' +'TEXT "'+TRANS(nSdoAct-nVlrAbo,'9,999,999')+'";')
	       Post('MZP 18.5,15.4;'+'TEXT "'+TRANS(nSdoAct-nVlrAbo,'9,999,999')+'";')
	    ENDIF
**********FIN IMPRESION DE LOS DETALLES DEL ABONO

	  i := i + 1

       ENDDO
       RETURN NIL
*>>>>IMPRESION DE LOS CONCEPTOS

/*************************************************************************
* TITULO..: RECIBO DE ABONO No. 07                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 25/2006 MAR A
       Bucaramanga, Colombia        INICIO: 05:30 AM   ABR 25/2006 MAR

OBJETIVOS:

1- Dise¤ado para la comunidad de la salle

1- Recibo No. 07 impresora c¢digo de barras.

2- Imprime el recibo para pagar el abono al saldo.

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecAbo06(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
		  cJorTxt,nNroFac,cCodEst,cNomEst,cCodGru,nNroLis,cNomBan,;
		  cCtaBan,cLugBan,dPagOpo,dPagExt,cMensaj,nMesIni,nVlrAbo,;
		  nSdoAct,lPrnGru,nRecNro)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE  AVANCES CHR(27)+'J'+CHR(100)// 1/216" Avance de L¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cLinea  := ''                  // L¡nea separadora del recibo
       LOCAL nLenRes := 18                  // Longitud del Resumen
       LOCAL nNroLen := 0                   // Longitud del recibo
       LOCAL nAvance := 0                   // L¡neas de avances

       LOCAL cCodMzp := ''                  // C¢digos de las coordenadas de impresi¢n
       LOCAL nTotPrn := 3                   // Total de Impresiones

       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNroRef := ''                  // N£mero de la Referencia
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
       ELSE
	  nNroFac := 0
	  cNroFac := STR(nNroFac,8)
	  lCorrecion(@cNroFac,.T.)
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
	  cCodFac := cCodEst+'14'+cMesIni+SPACE(02)
       ENDIF
       cCodFac := cCodEst+'14'+cMesIni     // Adicionado
*>>>>FIN CALCULO DEL DIGITO DE CHEQUEO

*>>>>NUMERO DE LA REFERENCIA UCC128
       cCodEmp := STR(SCO->nCodEmpCon,2)
       lCorrecion(@cCodEmp,.T.)

       cCodFac := cCodEst+'14'+cMesIni     // Adicionado

       cNroRef := cCodFac+CAR->cCodFacCar
*>>>>FIN NUMERO DE LA REFERENCIA UCC128

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

	  Post('FSET 1p4v;')
	  Post('MZP 0.3,3.5;  TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,12.5; TEXT "NIT '+cNitEmp+'";')
	  Post('MZP 0.3,20.7; TEXT "NIT '+cNitEmp+'";')

/*
	  Post('FSET 1p6v;')
	  Post('MZP 2.0,3.5;  TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,12.5; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
	  Post('MZP 2.0,20.7; TEXT "ASIMILADOS A GRANDES CONTRIBUYENTES - AGENTES RETENEDORES";')
*/
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

*>>>>IMPRESION PARTE DEL RECIBO SENCILLO
       DetAbo06(nSdoAct,nVlrAbo)
      *Impresi¢n de conceptos
*>>>>FIN IMPRESION PARTE DEL RECIBO SENCILLO

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA
       IF nRecNro == 8
	  Post('MZP 0.3,9.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,9.3; TEXT "'+cFecha(dPagOpo)+'";')
	  Post('MZP 0.3,18.3; TEXT "FECHA LIMITE OPORTUNA"; MZP 6.5,18.3; TEXT "'+cFecha(dPagOpo)+'";')

	  Post('MZP 13.0,9.3; TEXT "PAGUE $"; MZP 18.5,9.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 13.0,18.3;TEXT "PAGUE $"; MZP 18.5,18.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.5;'+;
		     '6.5,18.1;'+;
		     '10.5,22.1;'
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha pago oportuno

	  cCodMzp := '18.5,9.5;'+;
		     '18.5,18.1;'+;
		     '18.5,22.1;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrAbo,"***,***,***"),nTotPrn)
	*ÀValor del abono en pago oportuno

       ENDIF
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA OPORTUNA

*>>>>IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA
       IF nRecNro == 8
	  Post('MZP 0.3,9.7; TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,9.7; TEXT "'+cFecha(dPagExt)+'";')
	  Post('MZP 0.3,18.7;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 6.5,18.7; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 13.0,9.7; TEXT "PAGUE $"; MZP 18.5,9.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 13.0,18.7;TEXT "PAGUE $"; MZP 18.5,18.7; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ELSE

	  cCodMzp := '6.5,9.9;'+;
		     '6.5,18.7;'+;
		     '10.5,24.5;'
	  LineaMzp(cCodMzp,cFecha(dPagOpo),nTotPrn)
	*ÀFecha Pago Extemporaneo

	  cCodMzp := '18.5,9.9;'+;
		     '18.5,18.7;'+;
		     '18.5,24.5;'
	  LineaMzp(cCodMzp,TRANSFORM(nVlrAbo,"***,***,***"),nTotPrn)
	*ÀValor del abono en fecha Extemporanea.
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
	  Post('MZP 6.2,24.3;TEXT "FECHA LIMITE EXTEMPORANEA"; MZP 10.5,24.3; TEXT "'+cFecha(dPagExt)+'";')

	  Post('MZP 14.9,21.8;TEXT "PAGUE $"; MZP 18.5,21.8; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
	  Post('MZP 14.9,24.3;TEXT "PAGUE $"; MZP 18.5,24.3; TEXT "'+TRANSFORM(nVlrAbo,"***,***,***")+'";')
       ENDIF

       cCodEan := SCO->cCodEanCon

       cVlrBar := STR(nVlrAbo,10)
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

       cVlrBar := STR(nVlrAbo,10)
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

FUNCTION DetAbo06(nSdoAct,nVlrAbo)

*>>>>PARAMATROS DE LA FUNCION
/*     nSdoAct                              // Saldo Actual
       nVlrAbo                              // Valor del Abono */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>IMPRESION DE LOS DETALLES DEL ABONO
       Post('MZP 0.3,6.4;   TEXT "ABONO AL SALDO";')
       Post('MZP 0.3,15.4;  TEXT "ABONO AL SALDO";')

       Post('MZP 8.5,6.4;   TEXT "'+TRANS(nSdoAct,'99,999,999')+'";')
       Post('MZP 8.5,15.4;  TEXT "'+TRANS(nSdoAct,'99,999,999')+'";')

       Post('MZP 13.5,6.4;  TEXT "'+TRANS(nVlrAbo,'99,999,999')+'";')
       Post('MZP 13.5,15.4; TEXT "'+TRANS(nVlrAbo,'99,999,999')+'";')

       Post('MZP 18.5,6.4;  TEXT "'+TRANS(nSdoAct-nVlrAbo,'99,999,999')+'";')
       Post('MZP 18.5,15.4; TEXT "'+TRANS(nSdoAct-nVlrAbo,'99,999,999')+'";')

       RETURN NIL
*>>>>FIN IMPRESION DE LOS DETALLES DEL ABONO
