/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: FACTURACION            MODULO No. 151

**************************************************************************
* TITULO..: APLICACION DE LOS ABONOS SEGUN INTERES POR MORA              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/96 JUE A
       Bucaramanga, Colombia        INICIO: 03:40 PM   SEP 19/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite aplicar o descontar del saldo el abono teniendo en cuenta
   el Interes por mora.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_151(aParam1,aParam2,aParam3)

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

       LOCAL     i,x := 0                   // Contador
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
       LOCAL nDesEfe := 0                   // Opci¢n del Descuento

       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo
       LOCAL lHayCon := ''                  // .T. Hay Conceptos facturados

       LOCAL aMesAnt := {}                  // Registros Mes Anterior
       LOCAL aMesAct := {}                  // Registros Mes actual
       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL nDeuAbo := 0                   // Deuda con abono
       LOCAL nMorAbo := 0                   // Mora con abono
       LOCAL aMsgErr := {}                  // Mensajes de Error
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
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
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

*>>>>LOCALIZACION ITEM DEL PAZ Y SALVO
       nCodPaz := 0
       IF lLocCodigo('nNroTipPaz','PAZ',1)
	  nCodPaz := PAZ->nCodigoPaz
       ENDIF
       IF EMPTY(nCodPaz)
	  cError('NO ESTA HABILITADO EL ITEM DE LOS PAZ Y SALVOS')
       ENDIF
*>>>>FIN LOCALIZACION ITEM DEL PAZ Y SALVO

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

**********VALIDACION DEL MES DEL ABONO
	    IF nNroMesTde # nMesUltPag(cCodigoTes)
	       cError(cMes(nNroMesTde)+' NO ES EL ULTIMO RECIBO FACTURADO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL MES DEL ABONO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(cNombreTes+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********VALIDACION DEL ESTADO DE CUENTA
	    aMsgErr := aValCtaEst(cCodigoTes,.F.)

	    IF LEN(aMsgErr) > 0

	       cError('FAVOR REVISAR EL ESTADO DE CUENTA DEL ESTUDIANTE')

	       FOR x := 1 TO LEN(aMsgErr)
		   cError(aMsgErr[x])
	       ENDFOR
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL ESTADO DE CUENTA

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

/*          Ejemplo No.2. Manual del tesorero
	    1)- Calcular el porcentaje de la proporci¢n de la deuda actual
		y los intereses por cobrar: */

	    nIntCli := ROUND((CLI->nSdoMorCli*100)/CLI->nSdoActCli,0)
	  *ÀDocumentado
**********FIN VALIDACION DE LA DEUDA

**********MES DEL ABONO ES EL MES ACTUAL
	    nMesAnt := 0
	    nMesAct := nRecUltAnt(CLI->cCodigoEst,@nMesAnt)
	    IF nMesAct == nNroMesTde
	       lMesAct := .T.
	    ELSE
	       lMesAct := .F.
	    ENDIF
**********FIN MES DEL ABONO ES EL MES ACTUAL

**********VALIDACION DEL MES ACTUAL
	    IF !lMesAct

	       IF nNroMesTde > nMesAct
		  cError('NO SE PUEDE ABONAR A UN MES POSTERIOR A '+;
			 cMes(nMesAct,10))
	       ELSE
		  cError('NO SE PUEDE ABONAR A UN MES ANTERIOR A '+;
			 cMes(nMesAct,10))
	       ENDIF
	       LOOP

	    ENDIF
**********FIN VALIDACION DEL MES ACTUAL

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
	    cSavLin := SAVESCREEN(22,00,22,79)
	    centrar('Digite las Fechas en el Formato: MM/DD/AAAA',22)

	    dFecAbo := CTOD('00/00/00')
	    @nNroFil,aNroCol[2] GET dFecAbo
	    READ
	    RESTSCREEN(22,00,22,79,cSavLin)
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

	    IF YEAR(dFecAbo) # VAL(cAnoUsr)
	       cError('EL A¥O DE LA FECHA DEL ABONO ES DIFERENTE AL A¥O ACTUAL = '+cAnoUsr)
	       IF !lPregunta('DESEA CONTINUAR? No Si')
		  LOOP
	       ENDIF
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
	    nIntAnt    := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
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
	    nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	    nIntInt := (CLI->nSdoMorCli*100)/PAG->nMorAntPag
	    nPorAnt := (PAG->nMorAntPag*100)/nMorAntTpa
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
				     nSdoMorTcl   PICT '99,999,999'

	    @ nNroFil,aNroCol[3] GET cDescriTde   PICT '@!s28'
	    @ nNroFil,aNroCol[5] GET nVlrAbo      PICT '99999999';
				     VALID nSdoActTcl+nSdoMorTcl >= nVlrAbo
	    READ
	    @ nNroFil,aNroCol[6] SAY nSdoActTcl+;
				     nSdoMorTcl-;
				     nVlrAbo      PICT '99,999,999'
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

**********APLICACION DEL ABONO
	    nRegPag := PAG->(RECNO())
	    nDeuAbo := 0
	    nMorAbo := 0
	    IF !lAbono(cCodigoTes,cNombreTes,nNroMesTde,dFecAbo,nVlrAbo,;
		       CLI->nSdoActCli,CLI->nSdoMorCli,@nDeuAbo,@nMorAbo,;
		       @aMesAnt,@aMesAct,@cMsgErr)
	       cError(cMsgErr,'Abono')
	       LOOP
	    ENDIF
	    PAG->(DBGOTO(nRegPag))
**********FIN APLICACION DEL ABONO

**********GRABACION DE LOS DETALLES DEL ABONO
	    lHayCon := .T.
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

**********ACTUALIZACION DEL MES ACTUAL
	    SELECT PAG
	    IF lMesAct

*--------------ACTUALIZACION PARA EL RECIBO ACTUAL
		 GO nRegAct
		 IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'

		    IF dFecAbo <= PAG->dPagExtPag
		       nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo

		       nSdoAnt := ROUND((nSaldo*100)/(100+nIntAct),0)
		       nMorAnt := ROUND((nSdoAnt*nIntAct)/100,0)
		       nVlrMes := PAG->nVlrMesPag

		       DO CASE
		       CASE nSaldo > nSdoAnt+nMorAnt
			    IF ABS(nSaldo-nSdoAnt-nMorAnt) == 1
			       nMorAnt += nSaldo-nSdoAnt-nMorAnt
			    ENDIF
		       CASE nSaldo < nSdoAnt+nMorAnt
			    IF ABS(nSdoAnt+nMorAnt-nSaldo) == 1
			       nMorAnt -= nSdoAnt+nMorAnt-nSaldo
			    ENDIF
		       ENDCASE

		       GO nRegAnt   // Modificado Bethelemitas
		       nIntMes := ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)
		       GO nRegAct   // Modificado Bethelemitas

		    ELSE
		       IF PAG->nMesIniPag == CAA->nMesAmnCaA
			  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo
			  nSdoCli := ROUND((nSaldo*100)/(100+nIntCli),0)
			  nMorCli := nSaldo-nSdoCli
			  nMorAnt := ROUND((nMorCli*100)/nIntInt,0)
			  nIntMes := nMorCli - nMorAnt
			  nVlrMes := ROUND((nIntMes*100)/PAG->nIntMorPag,0)
			  nSdoAnt := nSdoCli-nVlrMes

			  nIntMes := ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)

		       ELSE

/*                        Ejemplo No.2. Manual del tesorero
			  2)- Restar el abono del Saldo Actual
			      para calcular el nuevo saldo:  */

			  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo
			*ÀDocumentado

			  GO nRegAnt   // Modificado Bethelemitas
			  IF PAG->cEstadoPag == '*' .OR.;
			     PAG->cEstadoPag == 'D'

			     GO nRegAct   // Modificado Bethelemitas

/*                           Ejemplo No.2. Manual del tesorero
			     3)- Calcular la deuda actual a partir del
				 nuevo saldo: */

			     nSdoCli := ROUND((nSaldo*100)/(100+nIntCli),0)
			   *ÀDocumentado

/*                           Ejemplo No.2. Manual del tesorero
			     4)- Por diferencia calcular el nuevo
				 interes por cobrar actual: */

			     nMorCli := nSaldo-nSdoCli
			   *ÀDocumentado

/*                           Ejemplo No.2. Manual del Tesorero
			     5)- Calcular el inter‚s por cobrar el mes: */

			     nIntMes := ROUND((nSdoCli*PAG->nIntMorPag)/100,0)
			   *ÀDocumentado

/*                           Ejemplo No.2. Manual del Tesorero
			     6)- Por diferencia calcular el
				 interes por cobrar anterior: */

			     nMorAnt := nMorCli-nIntMes
			   *ÀDocumentado

			     IF PAG->nIntMorPag == 0 .AND.;
				!PAG->lConcepPag
				lHayCon := .F.
			     ELSE
				lHayCon := .T.
			     ENDIF

			     IF .NOT. lHayCon
				nSdoAnt := nSdoCli
			     ELSE
				nSdoAnt := ROUND((nMorAnt*100)/nIntAct,0)
			     ENDIF
			   *ÀDeuda Anterior del mes. Modificado

			     nVlrMes := nSdoCli-nSdoAnt
			   *ÀValor del mes

			     nIntMes := ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)
			   *ÀInteres del mes

			  ELSE

			     GO nRegAct   // Modificado Bethelemitas
			     nMorAnt := 0
			     nSdoAnt := 0
			     nIntMes := 0
			     nSdoCli := ROUND((nSaldo*100)/(100+PAG->nIntMorPag),0)
			     nMorCli := nSaldo-nSdoCli
			     nVlrMes := nSdoCli
			  ENDIF

		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ACTUALIZACION PARA EL RECIBO ACTUAL

	    ENDIF
**********FIN ACTUALIZACION DEL MES ACTUAL

**********ACTUALIZACION DEL MES ANTERIOR
	    IF !lMesAct
	       GO nRegAnt
	       IF dFecAbo <= PAG->dPagExtPag
		  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo

		  nSdoAnt := ROUND((nSaldo*100)/(100+nIntAnt),0)
		  nMorAnt := ROUND((nSdoAnt*nIntAnt)/100,0)
		  DO CASE
		  CASE nSaldo > nSdoAnt+nMorAnt
		       IF ABS(nSaldo-nSdoAnt-nMorAnt) == 1
			  nMorAnt += nSaldo-nSdoAnt-nMorAnt
		       ENDIF
		  CASE nSaldo < nSdoAnt+nMorAnt
		       IF ABS(nSdoAnt+nMorAnt-nSaldo) == 1
			  nMorAnt -= nSdoAnt+nMorAnt-nSaldo
		       ENDIF
		  ENDCASE
		  nVlrMes := PAG->nVlrMesPag
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL MES ANTERIOR

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

*--------------ANALISIS DEL ABONO
		 DO CASE
		 CASE PAG->(RECNO()) == aMesAnt[4]
		      nSdoAnt := aMesAnt[1]
		      nMorAnt := aMesAnt[2]
		      nVlrMes := aMesAnt[3]

		 CASE PAG->(RECNO()) == aMesAct[4]
		      nSdoAnt := aMesAct[1]
		      nMorAnt := aMesAct[2]
		      nVlrMes := aMesAct[3]
		 ENDCASE
*--------------FIN ANALISIS DEL ABONO

*--------------GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO
		 REPL PAG->nSdoAntPag WITH nSdoAnt
		 REPL PAG->nMorAntPag WITH nMorAnt
		 REPL PAG->nVlrMesPag WITH nVlrMes
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

**********ACTUALIZACION DEL MES ACTUAL
	    IF lMesAct

*--------------ACTUALIZACION PARA EL RECIBO ACTUAL
		 nSdoAntTpa := PAG->nSdoAntPag
		 nMorAntTpa := PAG->nMorAntPag
		 GO nRegAnt

		 IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'
		    IF dFecAbo <= PAG->dPagExtPag
		       nMorAnt := nMorAntTpa-nIntMes
		       nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
		       nVlrMes := nSdoAntTpa-nSdoAnt
		    ELSE
		       IF PAG->nMesIniPag == CAA->nMesAmnCaA
			  nMorAnt := ROUND((nMorAntTpa*100)/nPorAnt,0)
			  nIntMes := nMorAntTpa - nMorAnt
			  nVlrMes := ROUND((nIntMes*100)/PAG->nIntMorPag,0)
			  nSdoAnt := nSdoAntTpa - nVlrMes
		       ELSE
			  nMorAnt := nMorAntTpa-nIntMes

			  IF .NOT. lHayCon
			      nMorAnt := nMorAnt - nMorCli
			  ENDIF
			*ÀCaso de facturaci¢n sin conceptos y intereses 0%

			  nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
			  nVlrMes := nSdoAntTpa-nSdoAnt
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ACTUALIZACION PARA EL RECIBO ACTUAL

	    ENDIF
**********FIN ACTUALIZACION DEL MES ACTUAL

**********ACTUALIZACION DEL MES ANTERIOR
	    IF !lMesAct

	       nSdoAntTpa := PAG->nSdoAntPag
	       nMorAntTpa := PAG->nMorAntPag
	       nVlrMesTpa := PAG->nVlrMesPag

	       GO nRegAct
	       IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'
		  IF dFecAbo <= PAG->dPagExtPag
		     nSdoAnt := nSdoAntTpa+nVlrMesTpa
		     nMorAnt := nMorAntTpa+;
				ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)
		     nVlrMes := PAG->nVlrMesPag
		  ELSE
		     nMorAnt := nMorAntTpa-nIntMes
		     nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
		     nVlrMes := nSdoAntTpa-nSdoAnt
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL MES ANTERIOR

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

*--------------ANALISIS DEL ABONO
		 DO CASE
		 CASE PAG->(RECNO()) == aMesAnt[4]
		      nSdoAnt := aMesAnt[1]
		      nMorAnt := aMesAnt[2]
		      nVlrMes := aMesAnt[3]

		 CASE PAG->(RECNO()) == aMesAct[4]
		      nSdoAnt := aMesAct[1]
		      nMorAnt := aMesAct[2]
		      nVlrMes := aMesAct[3]
		 ENDCASE
*--------------FIN ANALISIS DEL ABONO

*--------------GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO
		 REPL PAG->nSdoAntPag WITH nSdoAnt
		 REPL PAG->nMorAntPag WITH nMorAnt
		 REPL PAG->nVlrMesPag WITH nVlrMes
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
		     nIntMes := nIntMesNew(ABS(PAG->nVlrPagPag))
		  ELSE
		     nIntMes := nIntMesNew(CLI->nSdoActCli)
		  ENDIF
		  REPL CLI->nSdoMorCli WITH PAG->nMorAntPag+nIntMes
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

**********GRABACION DEL PAZ Y SALVO
	    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0 .AND.;
	       nCodPaz # 0

	       SELECT &cNalias
	       IF lRegLock(lShared,.F.)
		  cCampos := cNalias+'->cPazSdoEst'
		  REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,SPACE(01))
		  DBCOMMIT()
	       ELSE
		  cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	       ENDIF
	       IF lShared
		  DBUNLOCK()
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

/* REVISAR OJO
**********VALIDACION DEL ESTADO DE CUENTA
	    IF LEN(aValCtaEst(cCodigoTes,.F.)) # 0
	       cError('ELIMINE EL ABONO APLICADO',;
		      'EL ABONO APLICADO DESCUADRO EL ESTADO DE CUENTA')
	    ENDIF
**********FIN VALIDACION DEL ESTADO DE CUENTA
*/

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
						      PICT "99,999,999";
						      COLOR "I"
		  nNroFil++
*---------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	     ENDIF
***********CONTROL DE LA FILA DE VISUALIZACION

**********VALIDACION DEL ESTADO DE CUENTA DESPUES DEL ABONO
	    aMsgErr := aValCtaEst(cCodigoTes,.F.)

	    IF LEN(aMsgErr) > 0

	       cError('EL ABONO QUEDO MAL APLICADO. FAVOR REVISAR')

	       FOR x := 1 TO LEN(aMsgErr)
		   cError(aMsgErr[x])
	       ENDFOR
	    ENDIF
**********FIN VALIDACION DEL ESTADO DE CUENTA

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

       ENDDO
       SET DEVICE TO SCREEN
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION