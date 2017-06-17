/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: FACTURACION            MODULO No. 152

**************************************************************************
* TITULO..: APLICACION DE LOS ABONOS SEGUN VALOR DE RECARGO              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 16/2001 MAR A
       Bucaramanga, Colombia        INICIO: 06:00 PM   ENE 16/2001 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite aplicar o descontar del saldo el abono teniendo en cuenta
   el valor de recargo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_152(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       #DEFINE MESANT   1
       #DEFINE MESACT   2
       #DEFINE SDOANT   1
       #DEFINE MORANT   2
       #DEFINE VLRMES   3
       #DEFINE VLRPAG   4
       #DEFINE ESTADO   5
       #DEFINE PAGOPO   6
       #DEFINE PAGEXT   7

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL lMesAct := .F.                 // .T. Mes Actual
       LOCAL nMesAct := 0                   // Mes Actual
       LOCAL nVlrMes := 0                   // Valor del mes
       LOCAL nMesAnt := 0                   // Mes Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nSdoAnt := 0                   // Saldo Anterior
       LOCAL nIntMes := 0                   // Intereses del Mes
       LOCAL nPorAnt := 0                   // Porcentaje Anterior
       LOCAL nSaldo  := 0                   // Saldo
       LOCAL nSdoCli := 0                   // Saldo del Cliente
       LOCAL nMorCli := 0                   // Mora del Cliente
       LOCAL nIntInt := 0                   // Intereses
       LOCAL dExtAnt := CTOD("00/00/00")    // Extemporaneo Anterior
       LOCAL dExtAct := CTOD("00/00/00")    // Extemporaneo Actual

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero Fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nRegAnt := 0                   // Registro Anterior
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL nIntCli := 0                   // Interes Acumulado del Saldo Actual
       LOCAL nIntAct := 0                   // Interes Acumulado del Mes Actual
       LOCAL nIntAnt := 0                   // Interes Acumulado del Mes Anterior
       LOCAL aRegPag := {}                  // Detalles del Registro de Pagos
       LOCAL nVlrAbo := 0                   // Valor abonado
       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL lPrnGru := .T.                 // Impresi¢n por grupos
       LOCAL cCabeza := ''                  // Encabezado de Columna
       LOCAL dFecAbo := CTOD('00/00/00')    // Fecha del Abono
       LOCAL nIniAnt := 0                   // Mes Inicial Anterior del pago
       LOCAL nDesEfe := 0                   // Descuento de Efectivo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Saldo mora actual
       LOCAL nVlrMesTpa := 0                // Valor del Mes
       LOCAL nMorAntTpa := 0                // Mora Anterior
       LOCAL nSdoAntTpa := 0                // Saldo Anterior
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL nVlrPagTpa := 0                // Valor total por pagar
       LOCAL nNroMesTde := 0                // Mes para el descuento
       LOCAL cDescriTde := ''               // Descripci¢n del descuento
       LOCAL cCodigoTfp := ''               // C¢digo de la forma de pago
       LOCAL cNroFpgTpa := ''               // N£mero de la forma de pago
       LOCAL cTituloTfp := ''               // T¡tulo de la forma de pago
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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nNroMesTde := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes para el registro del abono al saldo',.T.)
       RESTORE SCREEN
       IF nNroMesTde == 0
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileFpg,'FPG',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilInf+1)
       cCabeza := cRegPrint({'CODIGO',;
			     'F.ABONO',;
			     'DESCRIPCION',;
			     'DEUDA',;
			     'ABONO',;
			     'SALDO'},;
			    {06,10,28,10,08,10},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       lPrnGru := .F.
       FileCli := ''
       FilePag := ''
       DO WHILE .T.

**********CIERRE DE ARCHIVOS
	    IF SELECT('CLI') # 0
	       CloseDbf('CLI',FileCli,nModCry)
	    ENDIF

	    IF SELECT('PAG') # 0
	       CloseDbf('PAG',FilePag,nModCry)
	    ENDIF
**********FIN CIERRE DE ARCHIVOS

cError('VALOR DEL RECARGO')

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ABONOS PARA EL MES DE '+cMes(nNroMesTde,3),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cNombreEst)+' '+;
			  RTRIM(&cNalias->cApelliEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

/*
**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst
	       cError(cNombreTes+' DEL GRUPO '+&cNalias->cCodigoGru+;
		     ' ESTA RETIRADO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
*/

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ABONO PARA EL MES DE '+cMes(nNroMesTde,3)+;
			'ºGRUPO: '+&cNalias->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30),;
			cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(cNombreTes+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       cError(cNombreTes+' NO PERTENCE AL GRUPO: '+;
		      &cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********VALIDACION DE LA DEUDA
	    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0
	       cError(cNombreTes+' NO TIENE DEUDAS PENDIENTES')
	       LOOP
	    ENDIF
	    nIntCli := ROUND((CLI->nSdoMorCli*100)/CLI->nSdoActCli,0)
**********FIN VALIDACION DE LA DEUDA

**********MES DEL ABONO ES EL MES ACTUAL
	    nMesAct := LEN(RTRIM(CLI->cMesPagCli))
	    nMesAnt := nMesAct-1
	    IF nMesAct == nNroMesTde
	       lMesAct := .T.
	    ELSE
	       lMesAct := .F.
	    ENDIF
**********FIN MES DEL ABONO ES EL MES ACTUAL

**********VALIDACION DEL MES DEL ABONO
	    IF !(nMesAnt == nNroMesTde .OR. nMesAct == nNroMesTde)

	       IF nNroMesTde > nMesAct
		  cError('NO SE PUEDE ABONAR A UN MES POSTERIOR A '+;
			 cMes(nMesAct,10))
	       ELSE
		  cError('NO SE PUEDE ABONAR A UN MES ANTERIOR A '+;
			 cMes(nMesAnt,10))
	       ENDIF
	       LOOP

	    ENDIF
**********FIN VALIDACION DEL MES DEL ABONO

**********LECTURA Y VALIDACION DE LA FECHA DEL ABONO
	    dFecAbo := CTOD('00/00/00')
	    @nNroFil,aNroCol[2] GET dFecAbo
	    READ
**********FIN LECTURA Y VALIDACION DE LA FECHA DEL ABONO

**********VALIDACION DE LAS LECTURAS
	    lHayErr := .T.
	    DO CASE
	    CASE EMPTY(dFecAbo)
		 cError('DEBE INGRESAR LA FECHA DEL ABONO')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LAS LECTURAS

**********LOCALIZACION DEL ANTERIOR RECIBO FACTURADO
	    nRegAnt := 0
	    SELECT PAG
	    LOCATE FOR PAG->cCodigoEst == cCodigoTes .AND.;
		       PAG->nMesIniPag == nMesAnt

	    IF !FOUND()
	       cError('NO EXISTE EL RECIBO DE '+cMes(nMesAnt,10)+;
		      ' DE '+cNombreTes)
	       LOOP
	    ENDIF
	    nRegAnt    := PAG->(RECNO())
	    dExtAnt    := PAG->dPagExtPag
	    nSdoAnt    := PAG->nSdoAntPag+PAG->nMorAntPag
	    IF PAG->lIntPenPag
	       nIntAnt    := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	    ENDIF
	    nMorAntTpa := PAG->nMorAntPag
**********FIN LOCALIZACION DEL ANTERIOR RECIBO FACTURADO

**********VALIDACION DE LA FORMA DE PAGO
	    IF dFecAbo > PAG->dPagExtPag .AND. PAG->cEstadoPag = '*'

	       cError('PRIMERO DEBE INDICAR LA FORMA DE PAGO '+;
		      'DEL MES DE '+cMes(nMesAnt))
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LA FORMA DE PAGO

**********LECTURA Y VALIDACION DEL SALDO PARA ABONAR
	    nSdoActTcl := 0
	    nSdoMorTcl := 0
	    IF !lMesAct .AND. dFecAbo <= PAG->dPagExtPag

	       nSdoActTcl := PAG->nSdoAntPag
	       nSdoMorTcl := PAG->nMorAntPag
	      *Saldos para abono por fecha oportuna

	       IF nSdoActTcl+nSdoMorTcl == 0
		  cError(cNombreTes+' EN '+cMes(nMesAnt,10)+;
			 ' NO QUEDO CON DEUDAS ATRASADAS')
		  LOOP
	       ENDIF
	     *ÀValidaci¢n del saldo

	    ENDIF
**********FIN LECTURA DEL SALDO PARA ABONAR

**********VALIDACION DEL SALDO DEL ANTERIOR MES
	    IF !lMesAct .AND. nNroMesTde # CAA->nMesAmnCaA .AND.;
	       (PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A')

	       cError(cNombreTes+' PAGO EL MES DE '+cMes(nNroMesTde,10))

	       LOOP

	    ENDIF
**********FIN VALIDACION DEL SALDO DEL ANTERIOR MES

**********LOCALIZACION DEL ULTIMO RECIBO FACTURADO
	    nRegAct := 0
	    SELECT PAG
	    LOCATE FOR PAG->cCodigoEst == cCodigoTes .AND.;
		       PAG->nMesIniPag == nMesAct

	    IF !FOUND()
	       cError('NO EXISTE EL RECIBO DE '+cMes(nMesAct,10)+;
		      ' DE '+cNombreTes)
	       LOOP
	    ENDIF
	    nRegAct := PAG->(RECNO())
	    dExtAct := PAG->dPagExtPag
	    IF PAG->lIntPenPag
	       nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	       nIntInt := (CLI->nSdoMorCli*100)/PAG->nMorAntPag
	       nPorAnt := (PAG->nMorAntPag*100)/nMorAntTpa
	    ENDIF
**********FIN LOCALIZACION DEL ULTIMO RECIBO FACTURADO

**********VALIDACION DE LA FORMA DE PAGO
	    IF dFecAbo > PAG->dPagExtPag .AND. PAG->cEstadoPag = '*'

	       cError('PRIMERO DEBE INDICAR LA FORMA DE PAGO '+;
		      'DEL MES DE '+cMes(nMesAct))
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LA FORMA DE PAGO

**********LECTURA DEL SALDO PARA EL ABONO
	    IF lMesAct
	       IF dFecAbo <= PAG->dPagExtPag
		  nSdoActTcl := PAG->nSdoAntPag
		  nSdoMorTcl := PAG->nMorAntPag
		 *Saldos para abono por fecha oportuna
	       ELSE
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
		 *Saldos para abono por fecha extemporanea
	       ENDIF
	    ELSE
	       IF dFecAbo > dExtAnt
		     lMesAct := .T.
		  nSdoActTcl := PAG->nSdoAntPag
		  nSdoMorTcl := PAG->nMorAntPag
		 *Saldos para abono por fecha extemporanea
	       ENDIF
	    ENDIF
**********FIN LECTURA DEL SALDO PARA EL ABONO

**********VALIDACION DEL SALDO
	    DO CASE
	    CASE nSdoActTcl+nSdoMorTcl == 0

		 cError(cNombreTes+' EN '+cMes(nMesAct,10)+;
			' NO QUEDO CON DEUDAS ATRASADAS')
		 LOOP

/*
	    CASE (lMesAct  .AND. PAG->nSdoAntPag+PAG->nMorAntPag == 0) .OR.;
		 (!lMesAct .AND. nSdoAnt == 0 .AND. PAG->cEstadoPag == '*')

		 cError('NO SE ACEPTAN ABONOS PARA UN SOLO MES DE ATRASO')
		 LOOP */

	    ENDCASE
**********FIN VALIDACION DEL SALDO

**********LECTURA DE LOS DETALLES DEL ABONO
	    cDescriTde := SUBS('ABONO AL SALDO'+SPACE(40),1,40)
	    nVlrAbo := 0
	    @ nNroFil,aNroCol[4] SAY nSdoActTcl+;
				     nSdoMorTcl   PICT '9,999,999'

	    @ nNroFil,aNroCol[3] GET cDescriTde   PICT '@!s28'
	    @ nNroFil,aNroCol[5] GET nVlrAbo      PICT '9999999';
				     VALID nSdoActTcl+nSdoMorTcl >= nVlrAbo
	    READ
	    @ nNroFil,aNroCol[6] SAY nSdoActTcl+;
				     nSdoMorTcl-;
				     nVlrAbo      PICT '9,999,999'
**********FIN LECTURA DE LOS DETALLES DEL ABONO

**********VALIDACION DE LAS LECTURAS
	    lHayErr := .T.
	    DO CASE
	    CASE EMPTY(cDescriTde)
		 cError('DEBE INGRESAR LA DESCRIPCION DEL ABONO')

	    CASE EMPTY(nVlrAbo)
		 cError('NO INGRESO EL VALOR DEL ABONO')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LAS LECTURAS

**********PREGUNTA DE DECISION
	    nDesEfe := nLeeOpcion('1<ABONO> 2<DESCUENTO> 3<NO GRABAR>?',3,'0')
	    IF nDesEfe == 3
	       LOOP
	    ENDIF
	    IF !lPregunta('DESEA APLICAR EL '+;
			  IF(nDesEfe==1,'ABONO','DESCUENTO')+' AL SALDO? No Si')
	       cError('NO SE DESCONTO EL '+;
		      IF(nDesEfe==1,'ABONO','DESCUENTO'))
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********LECTURA Y VALIDACION DEL TIPO DE PAGO
	    cCodigoTfp := ''
	    IF CAA->lForPagCaA .AND. nDesEfe == 1
	       cSavLin := SAVESCREEN(21,00,21,79)
	       cCodigoTfp := cSpaces('DES','cCodigoFpg')
	       @ 21,20 SAY 'INGRESE EL TIPO DE PAGO';
		       GET cCodigoTfp PICT '@!';
		       VALID lValidaFpg(10,20,@cCodigoTfp)
	       READ
	       RESTSCREEN(21,00,21,79,cSavLin)
	    ENDIF
**********FIN LECTURA Y VALIDACION DEL TIPO DE PAGO

**********LECTURA DEL NUMERO DE LA FORMA DE PAGO
	    cNroFpgTpa := ''
	    IF CAA->lForPagCaA .AND. nDesEfe == 1

	       cNroFpgTpa := cSpaces('DES','cNroFpgDes')
	       IF lLocCodigo('cCodigoFpg','FPG',cCodigoTfp)

		  cTituloTfp := 'INGRESE EL NUMERO '+ALLTRIM(FPG->cTituloFpg)
		  IF FPG->lLeeNroFpg
		     cSavLin := SAVESCREEN(21,00,21,79)
		     @ 21,20 SAY cTituloTfp GET cNroFpgTpa PICT '@!'
		     READ
		     RESTSCREEN(21,00,21,79,cSavLin)
		  ENDIF

	       ENDIF

	    ENDIF
**********FIN LECTURA DEL NUMERO DE LA FORMA DE PAGO

**********GRABACION DE LOS DETALLES DEL ABONO
	    IF DES->(lRegLock(lShared,.T.))

*--------------GRABACION DE LOS DETALLES PARA CADA MES AFECTADO
		 FOR i := 1 TO 2

*...................UBICACION DE LOS MESES AFECTADOS
		      SELECT PAG
		      IF i == 1
			 GO nRegAct
			 IF nNroMesTde # PAG->nMesIniPag
			    GO nRegAnt
			 ENDIF
		      ELSE
			 GO nRegAct
			 IF nNroMesTde == PAG->nMesIniPag
			    GO nRegAnt
			 ENDIF
		      ENDIF
		      SELECT DES
*...................FIN UBICACION DE LOS MESES AFECTADOS

*...................GRABACION DEL DETALLE DEL ABONO
		      IF i == 1

*                        MES DEL ABONO
			   IF PAG->cEstadoPag # 'P' .AND.;
			      PAG->cEstadoPag # 'A'
			      REPL DES->cCodigoEst WITH cCodigoTes
			      REPL DES->nNroFacCaA WITH nNroFac
			      REPL DES->nNroMesDes WITH nNroMesTde
			      REPL DES->nTipDesDes WITH 3
			      REPL DES->lDesEfeDes WITH IF(nDesEfe=1,.F.,.T.)
			      REPL DES->cDescriDes WITH cDescriTde
			      REPL DES->nValorDes  WITH nVlrAbo
			      REPL DES->dFechaDes  WITH dFecAbo
			      REPL DES->nSdoAntPag WITH PAG->nSdoAntPag
			      REPL DES->nMorAntPag WITH PAG->nMorAntPag
			      REPL DES->nVlrMesPag WITH PAG->nVlrMesPag
			      REPL DES->nVlrMorPag WITH PAG->nVlrMorPag
			      REPL DES->cCodigoFpg WITH cCodigoTfp
			      REPL DES->cNroFpgDes WITH cNroFpgTpa
			      REPL DES->cNomUsrDes WITH cNomUsr
			      REPL DES->dFecUsrDes WITH DATE()
			      REPL DES->cHorUsrDes WITH TIME()
			   ENDIF
*                        FIN MES DEL ABONO

		      ELSE

*			 MES QUE AFECTO EL ABONO
			   IF PAG->cEstadoPag # 'P' .AND.;
			      PAG->cEstadoPag # 'A'
			      REPL DES->nMesModDes WITH PAG->nMesIniPag
			      REPL DES->nSdoAntDes WITH PAG->nSdoAntPag
			      REPL DES->nMorAntDes WITH PAG->nMorAntPag
			      REPL DES->nVlrMesDes WITH PAG->nVlrMesPag
			      REPL DES->nVlrMorDes WITH PAG->nVlrMorPag
			   ENDIF
*			 FIN MES QUE AFECTO EL ABONO

		      ENDIF
		      DES->(DBCOMMIT())
*...................FIN GRABACION DEL DETALLE DEL ABONO

		 ENDFOR
*--------------GRABACION DE LOS DETALLES PARA CADA MES AFECTADO

	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL ABONO')
	    ENDIF

	    IF lShared
	       DES->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL ABONO

**********ACTUALIZACION DEL MES ACTUAL DEL MES ACTUAL
	    SELECT PAG
	    IF lMesAct

*--------------ACTUALIZACION PARA EL RECIBO ACTUAL
		 GO nRegAct
		 IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'

		    nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo
		    IF dFecAbo <= PAG->dPagExtPag
		       IF nSaldo <= nSdoMorTcl
			  nSdoAnt := 0
			  nMorAnt := nSaldo
		       ELSE
			  nSdoAnt := nSaldo - nSdoMorTcl
			  nMorAnt := nSdoMorTcl
		       ENDIF
		       nVlrMes := PAG->nVlrMesPag
		       nIntMes := PAG->nVlrMorPag
		    ELSE
		       IF PAG->nMesIniPag == CAA->nMesAmnCaA
			  *Pendiente
		       ELSE
			  IF nSaldo <= nSdoMorTcl
			     nSdoCli := 0
			     nMorCli := nSaldo
			     IF nMorCli <= PAG->nVlrMorPag
				nMorAnt := nMorCli
			     ELSE
				nMorAnt := PAG->nVlrMorPag
			     ENDIF
			     nIntMes := nMorCli - nMorAnt
			     nVlrMes := 0
			     nSdoAnt := nSdoCli-nVlrMes
			  ELSE
			     nSdoCli := nSaldo - nSdoMorTcl
			     nMorCli := nSdoMorTcl
			     IF nMorCli <= PAG->nVlrMorPag
				nIntMes := nMorCli
			     ELSE
				nIntMes := PAG->nVlrMorPag
			     ENDIF
			     nMorAnt := nMorCli - nIntMes
			     IF nSdoCli <= PAG->nVlrMesPag
				nVlrMes := nSdoCli
			     ELSE
				nVlrMes := PAG->nVlrMesPag
			     ENDIF
			     nSdoAnt := nSdoCli-nVlrMes
			  ENDIF
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ACTUALIZACION PARA EL RECIBO ACTUAL

	    ENDIF
**********FIN ACTUALIZACION DEL MES ACTUAL DEL MES ACTUAL

**********ACTUALIZACION DEL MES ANTERIOR DEL MES ANTERIOR
	    IF !lMesAct
	       GO nRegAnt
	       IF dFecAbo <= PAG->dPagExtPag
		  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo
		  IF nSaldo <= nSdoMorTcl
		     nSdoAnt := 0
		     nMorAnt := nSaldo
		  ELSE
		     nMorAnt := nSdoMorTcl
		     nSdoAnt := nSaldo-nMorAnt
		  ENDIF
		  nVlrMes := PAG->nVlrMesPag
		  nIntMes := PAG->nVlrMorPag
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL MES ANTERIOR DEL MES ANTERIOR

**********GRABACION DEL REGISTO DE PAGOS
	    IF PAG->(lRegLock(lShared,.F.)) .AND.;
	       PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT
		 IF DES->dFechaDes > PAG->dPagExtPag
		    IF PAG->nSdoExtPag == 0
		       REPL PAG->nSdoExtPag WITH PAG->nSdoAntPag
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS
		 IF PAG->nSdAbonPag == 0 .AND. PAG->nMoAbonPag == 0
		    REPL PAG->nSdAbonPag WITH PAG->nSdoAntPag
		    REPL PAG->nMoAbonPag WITH PAG->nMorAntPag
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABANOS

*--------------GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO
		 REPL PAG->nSdoAntPag WITH nSdoAnt
		 REPL PAG->nMorAntPag WITH nMorAnt
		 REPL PAG->nVlrMesPag WITH nVlrMes
		 REPL PAG->nVlrMorPag WITH nIntMes
*--------------FIN GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO

*--------------GRABACION DEL VALOR A PAGAR
		 IF PAG->nMesIniPag == CAA->nMesAmnCaA
		    REPL PAG->nVlrPagPag WITH nVlrMes
		 ELSE
		    REPL PAG->nVlrPagPag WITH nSdoAnt+nMorAnt+nVlrMes
		 ENDIF
*--------------FIN GRABACION DEL VALOR A PAGAR

	       PAG->(DBCOMMIT())

	    ELSE
	       IF PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'
		  cError('NO SE GRABAN LOS DETALLES DEL PAGO MES ACTUAL')
	       ENDIF
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTO DE PAGOS

**********ACTUALIZACION DEL MES ACTUAL DEL MES ANTERIOR
	    IF lMesAct

*--------------ACTUALIZACION PARA EL RECIBO ACTUAL
		 nSdoAntTpa := PAG->nSdoAntPag
		 nMorAntTpa := PAG->nMorAntPag
		 GO nRegAnt

		 IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'
		    IF PAG->nMesIniPag == CAA->nMesAmnCaA
		       *Pendiente
		    ELSE
		       IF nSdoAntTpa <= PAG->nVlrMesPag
			  nVlrMes := nSdoAntTpa
		       ELSE
			  nVlrMes := PAG->nVlrMesPag
		       ENDIF
		       nSdoAnt := nSdoAntTpa-nVlrMes

		       IF nMorAntTpa < PAG->nVlrMorPag
			  nMorAnt := nMorAntTpa
			  nIntMes := 0
		       ELSE
                          nMorAnt := nMorAntTpa-nIntMes
			  nIntMes := PAG->nVlrMorPag
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ACTUALIZACION PARA EL RECIBO ACTUAL

	    ENDIF
**********FIN ACTUALIZACION DEL MES ACTUAL DEL MES ANTERIOR

**********ACTUALIZACION DEL MES ANTERIOR DEL MES ACTUAL
	    IF !lMesAct

	       nSdoAntTpa := PAG->nSdoAntPag
	       nMorAntTpa := PAG->nMorAntPag
	       nVlrMesTpa := PAG->nVlrMesPag

	       GO nRegAct
	       IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'
		  IF dFecAbo <= PAG->dPagExtPag
		     nSdoAnt := nSdoAntTpa+nVlrMesTpa
		     nIntMes := PAG->nVlrMorPag
		     nMorAnt := nMorAntTpa+nIntMes
		     nVlrMes := PAG->nVlrMesPag
		  ELSE
		     nMorAnt := nMorAntTpa-nIntMes
		     nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
		     nVlrMes := nSdoAntTpa-nSdoAnt
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL MES ANTERIOR DEL MES ACTUAL

**********GRABACION DEL REGISTO DE PAGOS
	    IF PAG->(lRegLock(lShared,.F.)) .AND.;
	       PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT
		 IF DES->dFechaDes > PAG->dPagExtPag
		    IF PAG->nSdoExtPag == 0
		       REPL PAG->nSdoExtPag WITH PAG->nSdoAntPag
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS
		 IF PAG->nSdAbonPag == 0 .AND. PAG->nMoAbonPag == 0
		    REPL PAG->nSdAbonPag WITH PAG->nSdoAntPag
		    REPL PAG->nMoAbonPag WITH PAG->nMorAntPag
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABANOS

*--------------GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO
		 REPL PAG->nSdoAntPag WITH nSdoAnt
		 REPL PAG->nMorAntPag WITH nMorAnt
		 REPL PAG->nVlrMesPag WITH nVlrMes
		 REPL PAG->nVlrMorPag WITH nIntMes
*--------------FIN GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO

*--------------GRABACION DEL VALOR A PAGAR
		 IF PAG->nMesIniPag == CAA->nMesAmnCaA
		    REPL PAG->nVlrPagPag WITH nVlrMes
		 ELSE
		    REPL PAG->nVlrPagPag WITH nSdoAnt+nMorAnt+nVlrMes
		 ENDIF
*--------------FIN GRABACION DEL VALOR A PAGAR

	       PAG->(DBCOMMIT())

	    ELSE
	       IF PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'
		  cError('NO SE GRABAN LOS DETALLES DEL PAGO MES ACTUAL')
	       ENDIF
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
	    GO nRegAct
**********FIN GRABACION DEL REGISTO DE PAGOS

**********GRABACION DEL SALDO ACTUAL
	    SELECT CLI
	    IF CLI->(lRegLock(lShared,.F.))

	       IF PAG->cEstadoPag == '*'
		  REPL CLI->nSdoActCli WITH PAG->nSdoAntPag
		  REPL CLI->nSdoMorCli WITH PAG->nMorAntPag
	       ELSE
		  REPL CLI->nSdoActCli WITH PAG->nSdoAntPag+PAG->nVlrMesPag

		  IF PAG->nMesIniPag == CAA->nMesAmnCaA
		     REPL CLI->nSdoMorCli WITH PAG->nMorAntPag+;
					       ROUND((ABS(PAG->nVlrPagPag)*;
						      PAG->nIntMorPag)/100,0)
		  ELSE
		     REPL CLI->nSdoMorCli WITH PAG->nMorAntPag+PAG->nVlrMorPag
		  ENDIF
	       ENDIF

	       IF CLI->nSdoActCli == 0
		  REPL CLI->cMesPagCli WITH STUFF(CLI->cMespagCli,;
					    nMesAct,1,'P')
	       ENDIF
	    ELSE
	       cError('NO SE ACTUALIZA EL ABONO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL SALDO ACTUAL

**********UBICACION DEL MES DEL ABONO EN PAGOS
	    SELECT PAG
	    GO nRegAnt
	    IF nNroMesTde # PAG->nMesIniPag
	       GO nRegAct
	    ENDIF
**********FIN UBICACION DEL MES DEL ABONO EN PAGOS

**********GRABACION DEL ABONO EN PAGOS
	    IF PAG->(lRegLock(lShared,.F.))
*	       IF nDesEfe == 1 // Abono
		  REPL PAG->nAbonosPag WITH PAG->nAbonosPag+nVlrAbo
*	       ELSE
*		  REPL PAG->nVlrDesPag WITH PAG->nVlrDesPag+nVlrAbo
*	       ENDIF
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO DE PAGOS')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL ABONO EN PAGOS

**********UBICACION DEL ULTIMO MES DE PAGO
	    SELECT PAG
	    GO nRegAct
**********FIN UBICACION DEL ULTIMO MES DE PAGO

**********GRABACION DEL ABONO DEL OTRO MES
	    IF DES->(lRegLock(lShared,.F.))
	       IF PAG->nMesIniPag == DES->nNroMesDes
		  REPL DES->nAboOtrDes WITH DES->nSdoAntPag+DES->nMorAntPag-;
					    PAG->nSdoAntPag-PAG->nMorAntPag
	       ELSE
		  REPL DES->nAboOtrDes WITH DES->nSdoAntDes+DES->nMorAntDes-;
					    PAG->nSdoAntPag-PAG->nMorAntPag
	       ENDIF
	       DES->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO DE PAGOS')
	    ENDIF
	    IF lShared
	       DES->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL ABONO DEL OTRO MES

***********CONTROL DE LA FILA DE VISUALIZACION
	     nNroFil++
	     IF nNroFil > 20

*---------------VISUALIZACION DEL ULTIMO CLIENTE
		  nNroFil := nMarco(nFilInf+1)
		  @ nNroFil-2,01 SAY cCabeza

		  @ nNroFil,aNroCol[1] SAY cCodigoTes PICT "999999";
						      COLOR "I"
		  @ nNroFil,aNroCol[2] SAY dFecAbo    PICT "@D";
						      COLOR "I"
		  @ nNroFil,aNroCol[3] SAY SUBS(cDescriTde,1,30);
						      COLOR "I"
		  @ nNroFil,aNroCol[5] SAY nVlrAbo    PICT '9999999';
						      COLOR "I"
		  @ nNroFil,aNroCol[6] SAY CLI->nSdoactCli;
						      PICT "9,999,999";
						      COLOR "I"
		  nNroFil++
*---------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	     ENDIF
***********CONTROL DE LA FILA DE VISUALIZACION

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION