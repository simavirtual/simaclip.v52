/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: FACTURACION DEL MES                     MODULO No. 252

**************************************************************************
* TITULO..: FACTURACION DEL MES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 16/98 JUE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   JUL 16/98 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir el total de la facturaci¢n incluyendo los pagos
   extemporaneos y los pagos por anticipos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_251(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nFacMes := 0                   // C¢digo Facturaci¢n del Mes
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
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimCar,'SCA',NIL,lSiRed,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('SCA',PathSis+'\'+fSimCar,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE SCA->nFacMesCar > 1
	    cError('CODIGO DE FACTURACION DEL MES NO HABILITADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('SCA',PathSis+'\'+fSimCar,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
       nFacMes := SCA->nFacMesCar
       CloseDbf('SCA',PathSis+'\'+fSimCar,nModCry)
       CloseAll()
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LA FACTURACION DEL MES
       DO CASE
       CASE nFacMes == 0

	    FactMes01(aParam1,aParam2,aParam3)
	  *ÀFacturaci¢n CON Resumen.

       CASE nFacMes == 1

	    FactMes02(aParam1,aParam2,aParam3)
	  *ÀFacturaci¢n SIN resumen.

       ENDCASE
       CloseDbf('SCA',PathSis+'\'+fSimCar,nModCry)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION DEL MES

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: VALOR DE LOS ABONOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   MAR 25/99 JUE

OBJETIVOS:

1- Calcula el valor de los abonos del mes.

2- Calcula el valor de los abonos de otros meses.

3- Debe estar en uso el archivo de Descuentos y ubicado en el primer
   registro del abono del estudiante.

4- Debe estar en uso el archivo de pagos y ubicado en registro del
   estudiante.

5- Retorna por referencia los abonos del mes y los abonos de otros meses.

6- Retorna Nil.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VlrAbonos(cCodEst,nMesIni,nAboMes,nAboOtr,nDeuInt,lSdoAnt)

*>>>>PARARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del Estudiante
       nMesIni                              // Mes Inicial del pago
       nAboMes                              // @ Abonos del Mes
       nAboOtr                              // @ Abonos de otros Meses
       nDeuInt                              // @ Deuda Anterior para calcular los intereses por cobrar
       lSdoAnt                              // @ .T. Tomar saldo anterior */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL lHayAbo := .F.                 // .T. Hay Abono
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL ABONO
       nDeuInt := 0
       DO WHILE DES->(FOUND())

**********ANALISIS SI EL ABONO DE OTRO MES AFECTO AL MES ACTUAL
	    lHayAbo := .F.
	    IF DES->nNroMesDes # nMesIni

*--------------ANALISIS DE LA FORMA DE PAGO
		 DO CASE

		 CASE PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'

		      DO CASE
		      CASE DES->nNroMesDes-1 == nMesIni

*..........................EL ABONO ES POSTERIOR AL MES ACTUAL
			     nRegAct := PAG->(RECNO())
			     nDeuAnt := PAG->nSdoAntPag+PAG->nVlrMesPag
			     IF lLocCodPag(cCodEst,nMesIni+1,.F.)

*                               ANALISIS DEL ABONO
				  IF PAG->nSdoAntPag # PAG->nSdAbonPag .AND.;
				     PAG->nSdoAntPag == nDeuAnt
				     lHayAbo := .T.
				  ELSE
				     lSdoAnt := .T.
				  ENDIF
*                               FIN ANALISIS DEL ABONO

			     ENDIF
			     GO nRegAct
*..........................FIN EL ABONO ES POSTERIOR AL MES ACTUAL

		      CASE DES->nNroMesDes+1 == nMesIni

*..........................EL ABONO ES ANTERIOR AL MES ACTUAL
			     nRegAct := PAG->(RECNO())
			     nDeuAnt := PAG->nSdoAntPag
			     IF lLocPagAnt(cCodEst,nMesIni-1,.F.)

*                               ANALISIS DEL ABONO
				  IF PAG->nSdoAntPag # PAG->nSdAbonPag .AND.;
				     PAG->nSdoAntPag+PAG->nVlrMesPag == nDeuAnt
				     lHayAbo := .F.
				     lSdoAnt := .T.
				  ENDIF
*                               FIN ANALISIS DEL ABONO

			     ENDIF
			     GO nRegAct
*..........................FIN EL ABONO ES ANTERIOR AL MES ACTUAL

		      ENDCASE


		 CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag == '*'

		      DO CASE
		      CASE DES->nNroMesDes-1 == nMesIni

*..........................EL ABONO ES POSTERIOR AL MES ACTUAL
			     nRegAct := PAG->(RECNO())
			     nDeuAnt := PAG->nSdoAntPag+PAG->nVlrMesPag
			     IF lLocCodPag(cCodEst,nMesIni+1,.F.)

*                               ANALISIS DEL ABONO
				  IF PAG->nSdoAntPag # PAG->nSdAbonPag .AND.;
				     PAG->nSdoAntPag == nDeuAnt
				     lHayAbo := .T.
				  ELSE
				     lSdoAnt := .T.
				  ENDIF
*                               FIN ANALISIS DEL ABONO
			     ENDIF
			     GO nRegAct
*..........................FIN EL ABONO ES POSTERIOR AL MES ACTUAL

		      CASE DES->nNroMesDes+1 == nMesIni

*..........................EL ABONO ES ANTERIOR AL MES ACTUAL
			     nRegAct = PAG->(RECNO())
			     nDeuAnt := PAG->nSdoAntPag
			     IF lLocPagAnt(cCodEst,nMesIni-1,.F.)

*                               ANALISIS DEL ABONO
				  IF PAG->nSdoAntPag # PAG->nSdAbonPag .AND.;
				     PAG->nSdoAntPag+PAG->nVlrMesPag == nDeuAnt
				     lHayAbo := .F.
				     lSdoAnt := .T.
				  ENDIF
*                               FIN ANALISIS DEL ABONO

			     ENDIF
			     GO nRegAct
*..........................FIN EL ABONO ES ANTERIOR AL MES ACTUAL

		      ENDCASE

		 ENDCASE
*--------------FIN ANALISIS DE LA FORMA DE PAGO

	    ENDIF
**********FIN ANALISIS SI EL ABONO DE OTRO MES AFECTO AL MES ACTUAL

**********CALCULO DEL TOTAL DE ABONOS
	    IF DES->nNroMesDes == nMesIni .AND.;
	       MONTH(DES->dFechaDes) == MONTH(PAG->dPagExtPag)

*--------------ABONOS PARA EL MES ACTUAL
		 nAboMes +=  DES->nValorDes
		 IF DES->dFechaDes <= PAG->dPagExtPag
		    nDeuInt := PAG->nSdoAntPag
		 ELSE
		    nDeuInt := PAG->nSdAbonPag
		 ENDIF
*--------------FIN ABONOS PARA EL MES ACTUAL

	    ELSE

*--------------ABONOS DE OTROS MESES
		 IF lHayAbo
		    nAboOtr += DES->nValorDes
		    nDeuInt := PAG->nSdAbonPag
		 ENDIF
*--------------FIN ABONOS DE OTROS MESES

	    ENDIF
**********FIN CALCULO DEL TOTAL DE ABONOS

	  SELECT DES
	  CONTINUE
	  LOOP
       ENDDO
       RETURN NIL
*>>>>FIN ANALISIS DEL ABONO


/*************************************************************************
* TITULO..: CALCULO DE LOS ANTICIPOS POR CONCEPOS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 27/2000 MIE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   SEP 27/2000 MIE

OBJETIVOS:

1)- Permite calcular los anticipos descriminados por conceptos.

2)- Retorna el valor de los anticipos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Anticipos(aFacMes,nTotMes,aAntici,cIniFin,cConcep,cConSel)

*>>>>DESCRIPCION DE PARAMETROS
/*     aFacMes                              // Facturacion del mes
       nTotMes                              // Total de Meses del Anticipo
       aAntici                              // Anticipos
       cIniFin                              // Mes Inicial y final de cada concepto
       cConcep                              // Conceptos facturados
       cConSel                              // Conceptos selecionados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLRACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aAntEst[16]		    // Valor de los Anticipos del Mes
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nNroCon := 0                   // N£mero del Concepto


       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLRACION DE VARIABLES

*>>>>CALCULO DEL VALOR DE LOS ANTICIPOS
       AFILL(aAntEst,0)
       FOR i := 1 TO LEN(aFacMes)

	   cCodigoTco := SUBS(cConSel,i*2-1,2)


	   IF !EMPTY(cIniFin)


	      nNroCon := AT(cCodigoTco,cConcep)

	      IF nNroCon # 0
		 nNroCon := (nNroCon+1)/2
		 nMesIni := 0
		 nMesFin := 0
		 cIniFinPag(nNroCon,cIniFin,@nMesIni,@nMesFin)
		 nTotMes := nNroMesFac(nMesIni,nMesFin)-1
	      ENDIF
	   ENDIF

	   IF lLocCodigo('cCodigoCon','CON',cCodigoTco)
	      IF CON->lDesEfeDes
		 aAntEst[i] := -(aFacMes[i]*nTotMes)
	      ELSE
		 aAntEst[i] := aFacMes[i]*nTotMes
	      ENDIF
	   ELSE
	      aAntEst[i] := aFacMes[i]*nTotMes
	   ENDIF
	 *ÀModificado

	   IF .NOT. EMPTY(aAntici)
	      aAntici[i] += aAntEst[i]
	   ENDIF

       ENDFOR
       RETURN aAntEst
*>>>>FIN CALCULO DEL VALOR DE LOS ANTICIPOS

/*************************************************************************
* TITULO..: CALCULO DE LOS ANTICIPOS POR CONCEPOS VARIABLES              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 27/2000 MIE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   SEP 27/2000 MIE

OBJETIVOS:

1)- Permite calcular los anticipos descriminados por conceptos.

2)- Retorna el valor de los anticipos

NOTA:

Se debe modificar el codigo donde aparezca Anticipos(...) por:

IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses
   ... := AnticiVar(...)
ELSE
   ... := Anticipos(...)
ENDIF




*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AnticiVar(cCodGru,aFacMes,nMesIni,nMesFin,aAntici,cIniFin,cConcep,cConSel)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       aFacMes                              // Facturacion del mes
       nMesIni                              // Mes Inicial
       nMesFin                              // Mes Final
       aAntici                              // Anticipos
       cIniFin                              // Mes Inicial y final de cada concepto
       cConcep                              // Conceptos facturados
       cConSel                              // Conceptos selecionados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLRACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aAntEst[16]		    // Valor de los Anticipos del Mes
       LOCAL nIniMes := 0                   // Mes Inicial
       LOCAL nFinMes := 0                   // Mes Final
       LOCAL nNroCon := 0                   // N£mero del Concepto


       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLRACION DE VARIABLES

*>>>>CALCULO DEL VALOR DE LOS ANTICIPOS
       AFILL(aAntEst,0)
       FOR i := 1 TO LEN(aFacMes)

	   IF !EMPTY(cIniFin)

	      cCodigoTco := SUBS(cConSel,i*2-1,2)
	      nNroCon := AT(cCodigoTco,cConcep)

	      IF nNroCon # 0

		 nNroCon := (nNroCon+1)/2
		 nIniMes := 0
		 nFinMes := 0

		 cIniFinPag(nNroCon,cIniFin,@nIniMes,@nFinMes)
		 IF nIniMes # nFinMes
		    nIniMes++  // Mes Inicial del Anticipo
		 ENDIF


		 IF aFacMes[i] # 0 .AND. nIniMes # nFinMes
		    aAntEst[i] := nTarIniFin(cCodGru,nIniMes,nFinMes,cCodigoTco)
		 ENDIF
	      ENDIF

	   ELSE
	      IF aFacMes[i] # 0

		 IF nMesIni # nMesFin
		    nMesIni++
		 ENDIF
	       *ÀMes inicial del anticipo

		 aAntEst[i] := nTarIniFin(cCodGru,nMesIni,nMesFin,cConcep)
	      ENDIF
	   ENDIF

	   IF .NOT. EMPTY(aAntici)
	      aAntici[i] += aAntEst[i]
	   ENDIF

       ENDFOR
       RETURN aAntEst
*>>>>FIN CALCULO DEL VALOR DE LOS ANTICIPOS


FUNCTION RegSdoAct(nVlrSdo,nVlrDeu,nIntCob,nIntMes,;
		   nIntAnt,aVlrGru,aVlrNiv,aVlrTot)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrSdo			            // Saldo de la Deuda
       nVlrDeu			            // Deuda sin intereses
       nIntCob                              // Intereses por Cobrar
       nIntMes                              // Inteseses por Cobrar del Mes
       nIntAnt                              // Inteseses por Cobrar Anteriores
       aVlrGru                              // Valor por Grupos
       aVlrNiv                              // Valor por Niveles
       aVlrTot                              // Valor Total */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>SALDO ACTUAL
       aVlrGru[1] += nVlrSdo
       aVlrNiv[1] += nVlrSdo
       aVlrTot[1] += nVlrSdo
*>>>>FIN SALDO ACTUAL

*>>>>DEUDA SIN INTERESES
       aVlrGru[2] += nVlrDeu
       aVlrNiv[2] += nVlrDeu
       aVlrTot[2] += nVlrDeu
*>>>>FIN DEUDA SIN INTERESES

*>>>>INTERESES POR COBRAR
       aVlrGru[3] += nIntCob
       aVlrNiv[3] += nIntCob
       aVlrTot[3] += nIntCob
*>>>>FIN INTERESES POR COBRAR

*>>>>INTERESES POR COBRAR DEL MES
       aVlrGru[4] += nIntMes
       aVlrNiv[4] += nIntMes
       aVlrTot[4] += nIntMes
*>>>>FIN INTERESES POR COBRAR DEL MES

*>>>>INTERESES POR COBRAR ANTERIORES
       aVlrGru[5] += nIntAnt
       aVlrNiv[5] += nIntAnt
       aVlrTot[5] += nIntAnt
       RETURN NIL
*>>>>FIN INTERESES POR COBRAR ANTERIORES

/*************************************************************************
* TITULO DE LA FUNCION..: VALOR DE LOS ABONOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   MAR 25/99 JUE

OBJETIVOS:

1- Calcula el valor de los abonos del mes.

2- Calcula el valor de los abonos de otros meses.

3- Debe estar en uso el archivo de Descuentos y ubicado en el primer
   registro del abono del estudiante.

4- Debe estar en uso el archivo de pagos y ubicado en registro del
   estudiante.

5- Retorna por referencia los abonos del mes y los abonos de otros meses.

6- Retorna el valor de los abonos del mes.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrAbo(cCodEst,cAnoUsr,nMesIni,nDeuInt,nAboOtr,nAboDes,;
		 nAboFin,nOtrFin,nDesFin,lPrnFec,dFecPrn,aRegEst,lHayAbo)

*>>>>PARARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del Estudiante
       cAnoUsr                              // A¤o del Usuario
       nMesIni                              // Mes Inicial del pago
       nDeuInt                              // @ Deuda Anterior para calcular los intereses por cobrar
       nAboOtr                              // @ Abonos de otros Meses
       nAboDes                              // @Abonos como Descuentos
       nAboFin                              // @ Total abonos de fin de Mes
       nOtrFin                              // @ Total abonos Otros Meses
       nDesFin                              // @ Total abonos descuentos de fin de Mes
       lPrnFec                              // .T. Fecha de Corte
       dFecPrn                              // Fecha de Corte
       aRegEst                              // Valor del Estudiante
       lHayAbo			            // .T. Hay Abonos */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE nDEUANT 1                    // Deuda Anterior
       #DEFINE nMORANT 2                    // Mora Anterior
       #DEFINE nVLRMES 3                    // Valor del Mes

       LOCAL nActPag := 0                   // Registro Actual
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL lSwPaso := .T.                 // Sw de control de flujo.
       LOCAL lSiorNo := .T.                 // Sw de control de flujo.
       LOCAL lFAboOk := .T.                 // Fecha de Abono de Acuerdo al Corte
       LOCAL lFinAbo := .F.                 // .T. Hay Abonos de fin de Mes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL ABONO
       nAboDes := 0
       lPrnFec := IF(lPrnFec == NIL,.F.,lPrnFec)
       dFecPrn := IF(dFecPrn == NIL,CTOD('00/00/00'),dFecPrn)
       nAboFin := IF(nAboFin == NIL,0,nAboFin)
       nOtrFin := IF(nOtrFin == NIL,0,nOtrFin)
       nDesFin := IF(nDesFin == NIL,0,nDesFin)
       lHayAbo := .F.

       DO WHILE DES->(FOUND())

**********ANALISIS DE LA FECHA DE PAGO
	    lFAboOk := .T.
	    IF lPrnFec
	       IF DES->dFechaDes > dFecPrn
		  lFAboOk := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA FECHA DE PAGO

**********ANALISIS DEL PAGO DEL FIN DEL MES
	    lFinAbo := .F.
	    IF !lPrnFec .AND.;
	       YEAR(DES->dFechaDes) == VAL(cAnoUsr) .AND.;
	       MONTH(DES->dFechaDes) <= nMesIni
	       lFinAbo := .T.
	    ENDIF
**********FIN ANALISIS DEL PAGO DEL FIN DEL MES

**********ANALISIS DEL ABONOS A¥OS ANTERIORES
	    IF lFAboOk
	       IF DES->nValorDes > DES->nSdoAnoDes+DES->nMorAnoDes
		  lHayAbo := .T.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL ABONOS A¥OS ANTERIORES

**********CALCULO DE LA DEUDA PARA CALCULAR INTERESES DEL MES
	    IF PAG->nMesAmnPag # nMesIni

*--------------ANALISIS DE LA FECHA DEL ABONO
		 IF DES->dFechaDes <= PAG->dPagExtPag
		    nDeuInt := PAG->nSdoAntPag+nVlrMes()
		 ELSE
		    nDeuInt := PAG->nSdoExtPag+nVlrMes()
		 ENDIF
*--------------FIN ANALISIS DE LA FECHA DEL ABONO

	    ELSE
	       nDeuInt := nVlrMes()
	    ENDIF
**********FIN CALCULO DE LA DEUDA PARA CALCULAR INTERESES DEL MES

**********TOTAL DE ABONOS PARA EL MES
	    IF DES->nNroMesDes == nMesIni
	       IF DES->lDesEfeDes
		  IF lFAboOk
		     nAboDes += DES->nValorDes
		     IF lFinAbo
			nDesFin += DES->nValorDes
		     ENDIF
		  ELSE
		     IF lSwPaso
			aRegEst[nDEUANT] := DES->nSdoAntPag+DES->nSdoAnoPag
			aRegEst[nMORANT] := DES->nMorAntPag+DES->nMorAnoPag
			aRegEst[nVLRMES] := DES->nVlrMesPag
			lSwPaso := .F.
		     ENDIF
		  ENDIF
	       ELSE
		  IF lFAboOk
		     nTotAbo += DES->nValorDes
		     IF lFinAbo
			nAboFin += DES->nValorDes
		     ENDIF
		  ELSE
		     IF lSwPaso
			aRegEst[nDEUANT] := DES->nSdoAntPag+DES->nSdoAnoPag
			aRegEst[nMORANT] := DES->nMorAntPag+DES->nMorAnoPag
			aRegEst[nVLRMES] := DES->nVlrMesPag
			lSwPaso := .F.
		     ENDIF
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN TOTAL DE ABONOS PARA EL MES

**********TOTAL DE ABONOS OTROS MESES
	    IF DES->nMesModDes == nMesIni
	       IF lFAboOk
		  nAboOtr += DES->nAboOtrDes
		  IF lFinAbo
		     nOtrFin += DES->nValorDes
		  ENDIF
	       ELSE
		  IF lSwPaso
		     aRegEst[nDEUANT] := DES->nSdoAntDes+DES->nSdoAnoDes
		     aRegEst[nMORANT] := DES->nMorAntDes+DES->nMorAnoDes
		     aRegEst[nVLRMES] := DES->nVlrMesDes
		     lSwPaso := .F.
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN TOTAL DE ABONOS OTROS MESES

	  SELECT DES
	  CONTINUE
	  LOOP
       ENDDO
       RETURN nTotAbo
*>>>>FIN ANALISIS DEL ABONO



