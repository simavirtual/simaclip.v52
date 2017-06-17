/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: CANCELACION DE RECIBOS MODULO No. 202

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE202.PRG                                    *
* TITULO DEL PROGRAMA..: CANCELACION RECIBOS DE PAGO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 14/94 MAR
						       JUN 14/94 MAR
REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite cancelar los recibos de pago para un mes respectivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_202(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL nVlrMes := 0                   // Valor del mes sin abonos
       LOCAL nVlrPag := 0                   // Valor del pago
       LOCAL nVlrBec := 0                   // Valor de la Beca
       LOCAL nPagAbo := 0                   // Valor del pago sin abonos
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL nIntAnt := 0                   // Intereses del A¤o Anterior
       LOCAL nIntAbo := 0                   // Valor Intereses sin abonos

       LOCAL nNroPos := 0                   // N£mero de posici¢n del concepto
       LOCAL       i := 0                   // Contador
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo
       LOCAL nMesFin := 0                   // Mes Final del Pago
       LOCAL nIniUlt := 0                   // Mes Ultimo del Pago
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo de estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL nSdoAnoTcl := 0                // Saldo del A¤o Anterior
       LOCAL nMorAnoTcl := 0                // Mora del A¤o Anterior
       LOCAL nSdoActTcl := 0                // Saldo del cliente
       LOCAL nSdoMorTcl := 0                // Saldo de la mora
       LOCAL nSdAbonTcl := 0                // Saldo del Cliente sin abonos
       LOCAL nMoAbonTcl := 0                // Saldo de la mora sin abonos

       LOCAL nMesIniTpa := 0                // Mes inicial del pago
       LOCAL dFecPagTpa := CTOD('00/00/00') // Fecha de pago
       LOCAL cEstadoTpa := ''               // Forma de pago
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
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
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTORE SCREEN
       IF nMesIniTpa == 0
	  CloseAll()
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
			 FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileFpg,'FPG',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
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

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN BANCOS GRABADOS')

       CASE SUBS(CAA->cValConCaA,nMesIniTpa,1) # SPACE(01)

	    cError('EL RECIBO DE '+cMes(nMesIniTpa,10)+' '+;
		   'YA SE REPORTO A CONTABILIDAD')


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

*>>>>IMPRESION DE LA LINEA DE ESTADO
       LineaEstado('MES DE PROCESO: '+cMes(nMesIniTpa,10)+;
		   IF(CAA->nMesAmnCaA == nMesIniTpa,'.(AMNISTIA)',''),cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilInf+1)
       cCabeza := cRegPrint({'CODIGO',;
			     'NOMBRE',;
			     'SALDO ACTUAL',;
			     'PAGO EXT % ',;
			     'PAGO OPO   ',;
			     'FORMA '},;
			    {06,18,12,12,14,06},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>CANCELACION DE LOS RECIBOS
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

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')

	    CASE PAG->(RECCOUNT()) == 0
		 cError('NO EXISTEN PAGOS REGISTRADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(cNombreTes+' NO EXISTE EN LOS CLIENTES '+;
		      'DEL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL CLIENTE PERTENCE AL GRUPO
	    IF CLI->lRetGruCli
	       cError(cNombreTes+' NO PERTENCE AL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CLIENTE PERTENCE AL GRUPO

**********VALIDACION DE LA NO FACTURACION DESPUES DE CORRECION
	    IF CAA->nMesAmnCaA # nMesIniTpa

	       DO CASE
	       CASE CAA->nMesAmnCaA-1 # nMesIniTpa

		    IF CLI->nSdoactCli == 0 .AND. '*' $ CLI->cMespagCli

		       cError('A '+cNombreTes+;
			      ' NO SE FACTURO DESPUES DE LA '+;
			      'CORRECION DE LA FORMA DE PAGO')
		       LOOP
		    ENDIF
	       ENDCASE

	    ELSE
	       IF AT('*',CLI->cMesPagCli) < nMesIniTpa .AND.;
		  AT('*',CLI->cMesPagCli) # 0

		  cError('PRIMERO DEBE INDICAR LA FORMA DE PAGO DEL RECIBO '+;
			 'DEL MES DE '+cMes(AT('*',CLI->cMesPagCli),10))
		  LOOP
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE LA NO FACTURACION DESPUES DE CORRECION

**********LOCALIZACION DEL ULTIMO RECIBO
	    IF nUltRecPag(CLI->cCodigoEst) == 0
	       cError('NO SE LE GENERO RECIBO DE PAGO A '+cNombreTes)
	       LOOP
	    ENDIF
	    nIniUlt := PAG->nMesIniPag
**********FIN LOCALIZACION DEL ULTIMO RECIBO

**********LOCALIZACION DEL CODIGO DEL PAGO
	    IF !lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)
	       cError('NO SE LE GENERO RECIBO DE PAGO A '+cNombreTes)
	       LOOP
	    ENDIF
**********FIN LECTURA DE LOS DETALLES DEL PAGO

**********MES FINAL FACTURACION POR CONCEPTOS. PENSION
	    nMesFin := PAG->nMesFinPag

	    nNroPos := AT('PE',PAG->cConcepPag)
	    IF nNroPos # 0 .AND. !EMPTY(PAG->cIniFinPag)

	       nNroPos := ((nNroPos+1)/2)+1
	      *Posici¢n mes final de la pension

	       nMesFin := VAL(SUBS(PAG->cIniFinPag,nNroPos*2-1,2))
	      *Mes final de la pension

	    ENDIF
**********FIN MES FINAL FACTURACION POR CONCEPTOS. PENSION

**********VALIDACION DE LA CANCELACION DE MESES ANTERIORES
	    IF nIniUlt-1 # PAG->nMesIniPag .AND. nIniUlt # PAG->nMesIniPag

	       cError(cMes(PAG->nMesIniPag,10)+' NO ES EL MES ANTERIOR '+;
		      'A LA FACTURACION DE '+cMes(nIniUlt,10))
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LA CANCELACION DE MESES ANTERIORES

/*
**********VALIDACION DE LA CANCELACION DE MESES ANTERIORES
	    DO CASE
	    CASE CAA->nMesAmnCaA == nMesIniTpa

		 IF AT('*',CLI->cMespagCli) == CAA->nMesAmnCaA-1

		    cError('DEBE INDICARLE LA FORMA DE PAGO DEL MES DE '+;
			   cMes(CAA->nMesAmnCaA-1,10),;
			   'Error. A '+cNombreTes)
		    LOOP
		 ENDIF

	    CASE CAA->nMesAmnCaA-1 # nMesIniTpa

		 IF LEN(RTRIM(CLI->cMesPagCli)) # PAG->nMesIniPag .AND.;
		    LEN(RTRIM(CLI->cMesPagCli)) # PAG->nMesFinPag

		    cError('DEBE INDICARLE LA FORMA DE PAGO DEL MES DE '+;
			   cMes(LEN(RTRIM(CLI->cMesPagCli)),10),;
			   'Error. A '+cNombreTes)
		    LOOP
		 ENDIF

	    ENDCASE
**********FIN VALIDACION DE LA CANCELACION DE MESES ANTERIORES
*/

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('MES DE PROCESO: '+cMes(PAG->nMesIniPag)+;
			IF(CAA->nMesAmnCaA == nMesIniTpa,'.(AMNISTIA)','')+;
			 'ºEL CLIENTE PERTENECE AL GRUPO: '+;
			 &cNalias->cCodigoGru,;
			 cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE LA FORMA DE PAGO
	    DO CASE
	    CASE PAG->cEstadoPag == 'P'
		 cEstadoTpa := 'PAGO OPO'

	    CASE PAG->cEstadoPag == 'A'
		 cEstadoTpa := 'PAGO EXT'

	    CASE PAG->cEstadoPag == 'D'
		 cEstadoTpa := 'NO PAGO '

	    CASE PAG->cEstadoPag == '*'
		 cEstadoTpa := 'DEUDOR  '

	    OTHERWISE
		 cEstadoTpa := 'ERROR   '
	    ENDCASE
**********FIN ANALISIS DE LA FORMA DE PAGO

**********VALOR DE LOS CONCEPTOS
	    nVlrMes := 0
	    FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

		cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)
		nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
		nVlrMes += PAG->&('nVlrCo'+STR(nNroPos,1)+'Pag')

	    ENDFOR
**********FIN VALOR DE LOS CONCEPTOS

**********CALCULO DE LOS INTERESES
	    IF PAG->nMesIniPag == PAG->nMesFinPag
	       nVlrPag := PAG->nVlrMesPag+PAG->nSdoAntPag+PAG->nMorAntPag

	       IF PAG->nMesAmnPag == nMesIniTpa
		  nPagAbo := nVlrMes  //m
	       ELSE
		  nPagAbo := nVlrMes+PAG->nSdAbonPag+PAG->nMoAbonPag  //m
	       ENDIF

	    ELSE
	       nVlrPag := PAG->nVlrMesPag+PAG->nSdoAntPag+PAG->nMorAntPag

	       IF PAG->nMesAmnPag == nMesIniTpa
		  nPagAbo := nVlrMes  //m
	       ELSE
		  nPagAbo := nVlrMes+PAG->nSdAbonPag+PAG->nMoAbonPag  //m
	       ENDIF
	    ENDIF

	    IF CAA->lIntPenCaA
	       IF CAA->nMesAmnCaA == nMesIniTpa

		  nVlrInt := ROUND((ABS(nVlrPag)*PAG->nIntMorPag)/100,0)
		  nIntAnt := ROUND((PAG->nSdoAnoPag*PAG->nIntMorPag)/100,0)
		  nIntAbo := ROUND((nPagAbo*PAG->nIntMorPag)/100,0) //m

	       ELSE
		  nVlrInt := ROUND(((ABS(nVlrPag)-PAG->nMorAntPag)*;
				     PAG->nIntMorPag)/100,0)

		  nIntAnt := ROUND((PAG->nSdoAnoPag*PAG->nIntMorPag)/100,0)

		  nIntAbo := ROUND(((nPagAbo-PAG->nMoAbonPag)*;
				     PAG->nIntMorPag)/100,0) //m
	       ENDIF
	    ELSE
	       nVlrInt := PAG->nVlrMorPag
	       nIntAnt := 0
	    ENDIF
	   *Calculo de los intereses
**********FIN CALCULO DE LOS INTERESES

**********IMPRESION DE LOS DETALLES DEL PAGO
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY CLI->nSdoAnoCli+;
				     CLI->nMorAnoCli+;
				     CLI->nSdoActCli+;
				     CLI->nSdoMorCli;
				      PICT "99999,999.99"
	    @ nNroFil,aNroCol[4] SAY PAG->nVlrPagPag+nVlrInt PICT "$####,###.99"
	    @ nNroFil,aNroCol[5] SAY PAG->nVlrPagPag	 PICT "$####,###.99"
	    SET COLOR TO I
	    @ nNroFil,aNroCol[6] SAY cEstadoTpa
	    SET COLOR TO
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

**********LECTURA DE LA FORMA DE PAGO
	   IF !CAA->lLeeFecCaA
	      nForPag := nLeeOpcion('ENTRE LA FORMA DE PAGO: '+;
			'1<PAGO OPO> 2<PAG EXT> 3<NO PAGO> 4<ABANDONAR>?',4,'0')
	      *Lee la forma de pago

	      IF nForPag == 4
		 LOOP
	      ENDIF
	   ENDIF
**********FIN LECTURA DE LA FORMA DE PAGO

**********LECTURA Y VALIDACION DE LA FECHA DE PAGO
	    IF CAA->lLeeFecCaA

*--------------LECTURA DE LA FORMA DE PAGO
		 nForPag := nLeeOpcion('ENTRE LA FORMA DE PAGO: '+;
			   '1<PAGO> 2<NO PAGO> 3<ABANDONAR>?',3,'0')
		 IF nForPag == 3
		    LOOP
		 ENDIF
*--------------FIN LECTURA DE LA FORMA DE PAGO

*--------------LECTURA DE LA FECHA DE PAGO
		 dFecPagTpa := PAG->dFecPagPag
		 DO CASE
		 CASE nForPag == 1

		      cSavLin := SAVESCREEN(21,00,21,79)
		      @ 21,20 SAY 'ENTRE LA FECHA DE PAGO:(MM/DD/AA)';
			      GET dFecPagTpa
		      READ
		      RESTSCREEN(21,00,21,79,cSavLin)

		      IF EMPTY(dFecPagTpa)
			 LOOP
		      ENDIF

		      IF YEAR(dFecPagTpa) # VAL(cAnoUsr)
			 cError('EL A¥O DE LA FECHA DEL PAGO ES DIFERENTE AL A¥O ACTUAL = '+cAnoUsr)
			 IF !lPregunta('DESEA CONTINUAR? No Si')
			    LOOP
			 ENDIF
		      ENDIF

		      IF dFecPagTpa <= PAG->dPagOpoPag
			 nForPag := 1
		      ELSE
			 nForPag := 2
		      ENDIF

		 CASE nForPag == 2
		      nForPag := 3
*		      dFecPagTpa := CTOD('00/00/00')
		 ENDCASE
*--------------FIN LECTURA DE LA FECHA DE PAGO

	    ENDIF
**********FIN LECTURA Y VALIDACION DE LA FECHA DE PAGO

**********LECTURA DEL BANCO EN EL QUE PAGO
	    IF BAN->(RECCOUNT()) > 1
	       nSelBanco(nFilInf+1,nColInf-1)
	    ELSE
	       SELECT BAN
	       GO TOP
	    ENDIF
**********FIN LECTURA DEL BANCO EN EL QUE PAGO

**********LECTURA Y VALIDACION DEL TIPO DE PAGO
	    cCodigoTfp := ''
	    IF CAA->lForPagCaA .AND. (nForPag == 1 .OR. nForPag == 2)
	       cSavLin := SAVESCREEN(21,00,21,79)
	       cCodigoTfp := PAG->cCodigoFpg
	       @ 21,20 SAY 'INGRESE EL TIPO DE PAGO';
		       GET cCodigoTfp PICT '@!';
		       VALID lValidaFpg(10,20,@cCodigoTfp)
	       READ
	       RESTSCREEN(21,00,21,79,cSavLin)

	    ENDIF
**********FIN LECTURA Y VALIDACION DEL TIPO DE PAGO

**********LECTURA DEL NUMERO DE LA FORMA DE PAGO
	    cNroFpgTpa := ''
	    IF CAA->lForPagCaA .AND. (nForPag == 1 .OR. nForPag == 2)

	       cNroFpgTpa := PAG->cNroFpgPag
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

**********VALOR DE LA BECA PARA RECIBOS POR ADELANTADO
	    nVlrBec := PAG->nVlrBecPag
	    IF PAG->lHayBecPag .AND.;
	       PAG->nMesIniPag # PAG->nMesFinPag

	       IF !EMPTY(PAG->nPorBecPag)
		  nNroPos := (AT('PE',PAG->cConcepPag)+1)/2
		  nVlrBec := ROUND((PAG->&('nVlrCo'+;
					   STR(nNroPos,1)+'Pag') *;
				    PAG->nPorBecPag)/100,0)
	       ELSE
		  nVlrBec := CLI->nVlrBecCli
	       ENDIF

	    ENDIF
**********FIN VALOR DE LA BECA PARA RECIBOS POR ADELANTADO

**********ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO
	    DO CASE
	    CASE nForPag == 1 .OR. nForPag == 2  // Pago el recibo

*----------------ACTUALIZACION DEL SALDO
		   IF CAA->nMesAmnCaA == nMesIniTpa
		      nSdoAnoTcl := CLI->nSdoAnoCli
		      nMorAnoTcl := CLI->nMorAnoCli

		      nSdoActTcl := PAG->nSdoAntPag
		      nSdoMorTcl := PAG->nMorAntPag

		      nSdAbonTcl := PAG->nSdAbonPag //m
		      nMoAbonTcl := PAG->nMoAbonPag //m
		   ELSE
		      nSdoAnoTcl := 0
		      nMorAnoTcl := 0
		      nSdoActTcl := 0
		      nSdoMorTcl := 0
		      nSdAbonTcl := 0  //m
		      nMoAbonTcl := 0  //m
		   ENDIF
*----------------FIN ACTUALIZACION DEL SALDO

*----------------RECALCULO DE LA BECA PARA RECIBOS POR ADELANTADO
		   IF PAG->lHayBecPag .AND.;
		      PAG->nMesIniPag # PAG->nMesFinPag

		      nVlrBec := nVlrBec*nNroBecas(PAG->nMesIniPag,;
						   PAG->nMesFinPag)
		     *Beca por pago adelantado.

		   ENDIF
*----------------FIN RECALCULO DE LA BECA PARA RECIBOS POR ADELANTADO

	    CASE nForPag == 3                    // No pago el recibo

*----------------CALCULO DE LOS INTERESES
		   IF PAG->nMesIniPag == PAG->nMesFinPag
		      nVlrPag := PAG->nVlrMesPag+PAG->nSdoAntPag+PAG->nMorAntPag

		      IF PAG->nMesAmnPag == nMesIniTpa
			 nPagAbo := nVlrMes  //m
		      ELSE
			 nPagAbo := nVlrMes+PAG->nSdAbonPag+PAG->nMoAbonPag  //m
		      ENDIF

		   ELSE
		      nVlrPag := PAG->nVlrMesPag+PAG->nSdoAntPag+PAG->nMorAntPag

		      IF PAG->nMesAmnPag == nMesIniTpa
			 nPagAbo := nVlrMes  //m
		      ELSE
			 nPagAbo := nVlrMes+PAG->nSdAbonPag+PAG->nMoAbonPag  //m
		      ENDIF
		   ENDIF

		   IF CAA->lIntPenCaA
		      IF CAA->nMesAmnCaA == nMesIniTpa

			 nVlrInt := ROUND((ABS(nVlrPag)*PAG->nIntDeuPag)/100,0)
			 nIntAnt := ROUND((PAG->nSdoAnoPag*PAG->nIntDeuPag)/100,0)
			 nIntAbo := ROUND((nPagAbo*PAG->nIntDeuPag)/100,0) //m

		      ELSE
			 nVlrInt := ROUND(((ABS(nVlrPag)-PAG->nMorAntPag)*;
					    PAG->nIntDeuPag)/100,0)

			 nIntAnt := ROUND((PAG->nSdoAnoPag*PAG->nIntDeuPag)/100,0)

			 nIntAbo := ROUND(((nPagAbo-PAG->nMoAbonPag)*;
					    PAG->nIntDeuPag)/100,0) //m
		      ENDIF
		   ELSE
		      nVlrInt := PAG->nVlrMorPag
		      nIntAnt := 0
		   ENDIF
		  *Calculo de los intereses
*----------------FIN CALCULO DE LOS INTERESES

*----------------ACTUALIZACION DEL SALDO
		   IF CAA->nMesAmnCaA == nMesIniTpa
		      nSdoAnoTcl := PAG->nSdoAnoPag
		      nMorAnoTcl := PAG->nMorAnoPag+nIntAnt

		      nSdoActTcl := PAG->nSdoAntPag+nVlrPag
		      nSdoMorTcl := PAG->nMorAntPag+nVlrInt

		      nSdAbonTcl := PAG->nSdAbonPag+nPagAbo //m
		      nMoAbonTcl := PAG->nMoAbonPag+nIntAbo //m

		   ELSE
		      nSdoAnoTcl := PAG->nSdoAnoPag
		      nMorAnoTcl := PAG->nMorAnoPag+nIntAnt

		      nSdoActTcl := nVlrPag-PAG->nMorAntPag
		      nSdoMorTcl := PAG->nMorAntPag+nVlrInt

		      nSdAbonTcl := nPagAbo-PAG->nMoAbonPag //m
		      nMoAbonTcl := PAG->nMoAbonPag+nIntAbo //m
		   ENDIF
*----------------FIN ACTUALIZACION DEL SALDO

	    ENDCASE
**********FIN ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO

**********ANALISIS DE LA FORMA DE PAGO
	    DO CASE
	    CASE nForPag       == 1
		  cEstadoTpa := 'PAGO OPO'
		  cForPag      := 'P'

	    CASE nForPag       == 2
		  cEstadoTpa := 'PAGO EXT'
		  cForPag      := 'A'

	    CASE nForPag       == 3
		  cEstadoTpa := 'NO PAGO '
		  cForPag      := 'D'

	    OTHERWISE
		  cForPag      := 'E'
		  cEstadoTpa := 'ERROR   '
	    ENDCASE
**********FIN ANALISIS DE LA FORMA DE PAGO

**********GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES
	    IF CLI->(lRegLock(lShared,.F.))

	       DO CASE
	       CASE CAA->nMtdSdoCaA == 98 // No se acumula saldos

		    REPL CLI->nSdoAnoCli WITH 0
		    REPL CLI->nMorAnoCli WITH 0

		    REPL CLI->nSdoActCli WITH 0
		    REPL CLI->nSdoMorCli WITH 0

	       OTHERWISE
		    REPL CLI->nSdoAnoCli WITH nSdoAnoTcl
		    REPL CLI->nMorAnoCli WITH nMorAnoTcl

		    REPL CLI->nSdoActCli WITH nSdoActTcl
		    REPL CLI->nSdoMorCli WITH nSdoMorTcl
	       ENDCASE

	       REPL CLI->nSdAbonCli WITH nSdAbonTcl //m
	       REPL CLI->nMoAbonCli WITH nMoAbonTcl //m

	       IF PAG->nFavDesPag # PAG->nFavAplPag
		  REPL CLI->nSdoFavCli WITH CLI->nSdoFavCli-;
					    PAG->nFavDesPag
	       ENDIF
	     *ÀAplicaci¢n del Descuento del Saldo a Favor

	       DO CASE
	       CASE nForPag == 1 .OR. nForPag == 2

		    FOR i := PAG->nMesIniPag TO PAG->nMesFinPag
			REPL CLI->cMesPagCli;
			     WITH STUFF(CLI->cMesPagCli,i,1,cForPag)
		    NEXT
		   *Graba control de meses pagados

		    IF PAG->nFavPagPag == 0
		       REPL CLI->nSdoFavCli WITH CLI->nSdoFavCli+;
						 PAG->nSdoFavPag
		    ENDIF
		  *ÀGrabaci¢n del Saldo a Favor

		    REPL CLI->cConSdoCli WITH ''
		  *ÀGrabaci¢n de los conceptos que DEBE

	       CASE nForPag == 3

		    REPL CLI->cMesPagCli WITH;
			 STUFF(CLI->cMespagCli,PAG->nMesIniPag,1,cForPag)
		   *Graba el control del meses no pagado

		    FOR i := IF(PAG->nMesIniPag==12,12,PAG->nMesIniPag+1);
			TO nMesFin
			REPL CLI->cMesPagCli;
			     WITH STUFF(CLI->cMesPagCli,i,1,SPACE(01))
		    NEXT
		   *Borra el control de meses adelantados no pagos

		    IF PAG->nFavPagPag # 0
		       REPL CLI->nSdoFavCli WITH CLI->nSdoFavCli-;
						 PAG->nSdoFavPag
		    ENDIF
		  *ÀGrabaci¢n del Saldo a Favor

		    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0
		       REPL CLI->cConSdoCli WITH ''
		    ELSE
		       IF EMPTY(PAG->cConcepPag)
			  REPL CLI->cConSdoCli WITH PAG->cConSdoPag
		       ELSE
			  REPL CLI->cConSdoCli WITH PAG->cConcepPag
		       ENDIF
		    ENDIF
		  *ÀGrabaci¢n de los conceptos del saldo

	       ENDCASE
	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES

**********GRABACION DE LA FORMA DE PAGO
	    IF PAG->(lRegLock(lShared,.F.))
	       IF BAN->(RECCOUNT()) > 1
		  REPL PAG->cCodigoBan WITH BAN->cCodigoBan
	       ENDIF
	       REPL PAG->cEstadoPag WITH cForPag
	       REPL PAG->dFecPagPag WITH dFecPagTpa
	       REPL PAG->nVlrBecPag WITH nVlrBec
	       REPL PAG->cCodigoFpg WITH cCodigoTfp
	       REPL PAG->cNroFpgPag WITH cNroFpgTpa
	       REPL PAG->cNomUsrPag WITH cNomUsr
	       REPL PAG->dFecUsrPag WITH DATE()
	       REPL PAG->cHorUsrPag WITH TIME()

	       DO CASE
	       CASE nForPag == 1 .OR. nForPag == 2
		    REPL PAG->nFavPagPag WITH PAG->nSdoFavPag

	       CASE nForPag == 3
		    REPL PAG->nFavPagPag WITH 0
	       ENDCASE
	     *ÀGrabaci¢n del Control de Grabaci¢n del Saldo a Favor

	       REPL PAG->nFavAplPag WITH PAG->nFavDesPag
	     *ÀAplicaci¢n del Descuento del Saldo a Favor.

	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LA FORMA DE PAGO')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA FORMA DE PAGO

**********GRABACION DEL SALDO EN LA FACTURACION DEL MES DE AMNISTIA
	    IF nMesIniTpa+1 == CAA->nMesAmnCaA
	       IF lLocCodPag(CLI->cCodigoEst,nMesIniTpa+1,.F.)

		  IF PAG->(lRegLock(lShared,.F.))
		     REPL PAG->nSdoAntPag WITH CLI->nSdoActCli
		     REPL PAG->nMorAntPag WITH CLI->nSdoMorCli

		     REPL PAG->nSdAbonPag WITH CLI->nSdAbonCli //m
		     REPL PAG->nMoAbonPag WITH CLI->nMoAbonCli //m
		     PAG->(DBCOMMIT())
		  ELSE
		     cError('NO SE GRABA LA FORMA DE PAGO')
		  ENDIF
		  IF lShared
		     PAG->(DBUNLOCK())
		  ENDIF

	       ENDIF
	    ENDIF
**********FIN GRABACION DEL SALDO EN LA FACTURACION DEL MES DE AMNISTIA

***********GRABACION DE LA FORMA DE PAGO
	     DO CASE
	     CASE nForPag == 1 .OR. nForPag == 2
		  cMesPagCoE(lShared,;
			     CLI->cCodigoEst,;
			     ALLTRIM(PAG->cConSdoPag)+;
			     ALLTRIM(PAG->cConcepPag),;
			     PAG->nMesIniPag,;
			     PAG->cIniFinPag,;
			     cForPag)

	     CASE nForPag == 3  // No Pago

		  cMesPagCoE(lShared,;
			     CLI->cCodigoEst,;
			     ALLTRIM(PAG->cConcepPag)+;
			     ALLTRIM(CLI->cConSdoCli),;
			     PAG->nMesIniPag,;
			     PAG->cIniFinPag,;
			     ' ')
		 *Borra todos los estados. Para eliminar adelantados.

		  cMesPagCoE(lShared,;
			     CLI->cCodigoEst,;
			     ALLTRIM(PAG->cConcepPag)+;
			     ALLTRIM(CLI->cConSdoCli),;
			     PAG->nMesIniPag,;
			     PAG->cIniFinPag,;
			     cForPag)
		 *Graba el estado NO PAGO

	     ENDCASE
***********FIN GRABACION DE LA FORMA DE PAGO

**********GRABACION DEL PAZ Y SALVO
	    IF nCodPaz # 0

	       SELECT &cMaeAct
	       IF lRegLock(lShared,.F.)
		  cCampos := cMaeAct+'->cPazSdoEst'
		  DO CASE
		  CASE nForPag == 1 .OR. nForPag == 2
		       REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,SPACE(01))

		  CASE nForPag == 3
		       REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,'N')
		  ENDCASE
		  DBCOMMIT()
	       ELSE
		  cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	       ENDIF
	       IF lShared
		  DBUNLOCK()
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

**********IMPRESION DE LOS DETALLES DEL PAGO
	    SET COLOR TO I
	    @ nNroFil,aNroCol[3] SAY CLI->nSdoActCli+;
				     CLI->nSdoMorCli+;
				     CLI->nSdoAnoCli+;
				     CLI->nMorAnoCli  PICT "99999,999.99"
	    @ nNroFil,aNroCol[6] SAY cEstadoTpa
	    SET COLOR TO
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

**********VALIDACION DEL ESTADO DE CUENTA
/*
	    IF LEN(aValCtaEst(cCodigoTes,.F.)) # 0
	       cError('ESTADO DE CUENTA CON PROBLEMAS',;
		      'POR FAVOR REVISAR')
	    ENDIF
*/
**********FIN VALIDACION DEL ESTADO DE CUENTA

***********CONTROL DE LA FILA DE VISUALIZACION
	     nNroFil++
	     IF nNroFil > 20

*---------------VISUALIZACION DEL ULTIMO CLIENTE
		  nNroFil := nMarco(nFilInf+1)
		  @ nNroFil-2,01 SAY cCabeza

		  SET COLOR TO I
		  @ nNroFil,aNroCol[1] SAY cCodigoTes
		  SET COLOR TO
		  @ nNroFil,aNroCol[2] SAY cNombreTes
		  SET COLOR TO I
		  @ nNroFil,aNroCol[3] SAY CLI->nSdoActCli+CLI->nSdoMorCli;
				       PICT "9999,999.99"
		  SET COLOR TO
		  @ nNroFil,aNroCol[4] SAY nVlrPag+nVlrInt PICT "$###,###.99"
		  @ nNroFil,aNroCol[5] SAY nVlrPag         PICT "$###,###.99"
		  SET COLOR TO I
		  @ nNroFil,aNroCol[6] SAY cEstadoTpa
		  SET COLOR TO
		  nNroFil++
*---------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	     ENDIF
***********CONTROL DE LA FILA DE VISUALIZACION

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN CANCELACION DE LOS RECIBOS