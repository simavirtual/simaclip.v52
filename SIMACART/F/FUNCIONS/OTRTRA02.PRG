/*************************************************************************
* TITULO ..: PROCESAR NO PAGOS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/99 VIE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   JUN 11/99 VIE

OBJETIVOS:

1- Lee el archivo transferido del modem y actualiza el saldo de los
   recibos que no fueron cancelados.

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra022(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del Dia */
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

       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL nForPag := 0                   // Forma de pago
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL nIntNoP := 0                   // Valor de los intereses no pago
       LOCAL nIntAnt := 0                   // Valor Intereres A¤o Anterior
       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo

       LOCAL nNroPos := 0                   // N£mero de posici¢n del concepto
       LOCAL nMesFin := 0                   // Mes Final del Pago
       LOCAL nMesUlt := 0                   // Mes Ultimo de Facturaci¢n
       LOCAL aErrCta := {}                  // Errores del Estado de Cuenta

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo

       LOCAL nSdoAnoTcl := 0                // Saldo A¤o Anterior
       LOCAL nMorAnoTcl := 0                // Mora A¤o Anterior
       LOCAL nSdoActTcl := 0                // Saldo del cliente
       LOCAL nSdoMorTcl := 0                // Saldo de la mora

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables de Campos
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>VALIDACION DEL PROCESO MENSUAL
       IF !EMPTY(cNroDia)
	  cError('ESTA OPCION NO ESTA HABILITADA PARA LOS PAGOS DIARIOS')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL PROCESO MENSUAL

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF EMPTY(cNroDia)
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ELSE
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

/*
*>>>>INDEXACION DEL ARCHIVO
       IF !FILE(cPatSis+'\MODEM\'+fNtxTra)

	  SELECT TRA
	  INDEX ON TRA->cCodigoEst;
		TO &(cPatSis+'\MODEM\'+fNtxTra)

       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO
*/

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('FUE')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
	      cError('ABRIENDO ARCHIVOS')
	      CloseDbf('GRU')
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN NIL
	   ENDIF

	   SELECT GRU
	   GO TOP
	   DO WHILE .NOT. (GRU->(EOF()))

	      IF FUE->(lRegLock(lShared,.T.))
		 REPL FUE->cCodigoGru WITH GRU->cCodigoGru
		 FUE->(DBCOMMIT())
	      ELSE
		 cError('NO SE GRABA LA FORMA DE PAGO')
	      ENDIF
	      IF lShared
		 FUE->(DBUNLOCK())
	      ENDIF

	      SELECT GRU
	      SKIP

	   ENDDO

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL

       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS GRUPOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DEL MES DE AMNISTIA
       IF CAA->nMesAmnCaA == VAL(cNroMes)
	  cError('EL MES DE AMNISTIA SE DEBE PROCESAR MANUALMENTE',;
		 'PARA EVITAR ERRORES')
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES DE AMNISTIA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',22,NIL,NIL,20,60)
       IF !lIntervGru(nNroFil,21,@nRegIni,@nRegFin)
	  CloseDbf('GRU')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DECISION
       DO CASE
       CASE CAA->nMtdSdoCaA == 98
	    cError('ESTA HABILITADO NO ACUMULAR SALDOS POR NO PAGO')
       ENDCASE

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseDbf('GRU')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

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
       nNroFil := nMarco(nFilPal+1)
       cCabeza := cRegPrint({'CODIGO',;
			     'NOMBRE',;
			     'SALDO ACTUAL',;
			     'VALOR MES % ',;
			     'TOTAL PAGADO  ',;
			     'FORMA '},;
			    {06,18,12,12,14,06},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>CANCELACION DE LOS RECIBOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********CIERRE DE ARCHIVOS
	    IF SELECT('CLI') # 0
	       CloseDbf('CLI',FileCli,nModCry)
	    ENDIF

	    IF SELECT('PAG') # 0
	       CloseDbf('PAG',FilePag,nModCry)
	    ENDIF
**********FIN CIERRE DE ARCHIVOS

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       GRU->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       SELECT TRA
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

/*
**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS '+FileCli)

	    CASE PAG->(RECCOUNT()) == 0
		 cError('NO EXISTEN PAGOS REGISTRADOS '+FilePag)

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       SELECT TRA
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS
*/

**********CANCELACION DEL RECIBO POR GRUPO
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			     'ºNo. '+STR(CLI->(RECCOUNT()),2)+'/'+;
				     STR(CLI->(RECNO()),2),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI ES DE OTRO GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI ES DE OTRO GRUPO

*--------------ANALISIS DEL PAGO DEL RECIBO
		 nForPag := 3
		 IF lLocCodigo('cCodigoEst','TRA',CLI->cCodigoEst)

		    nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))

		    IF nMesIniTtr == VAL(cNroMes)
		       nForPag := 1
		       SELECT CLI
		       CLI->(DBSKIP())
		       LOOP
		    ENDIF

		 ENDIF
		*1<PAGO OPO> 2<PAG EXT> 3<NO PAGO>
*--------------FIN ANALISIS DEL PAGO DEL RECIBO

*--------------BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
		 cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
		 IF !lSekCodigo(CLI->cCodigoEst,cMaeAct)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)
		 cCodigoTgr := &cMaeAct->cCodigoGru
*--------------FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

*--------------LOCALIZACION DEL CODIGO DEL PAGO
		 nMesUlt := nMesUltPag(CLI->cCodigoEst)
	       *ÀUltimo recibo facturados

		 IF !lLocCodPag(CLI->cCodigoEst,VAL(cNroMes),.F.)
*		    cError('NO SE LE GENERO RECIBO DE PAGO A '+cNombreTes)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DEL CODIGO DEL PAGO

*--------------VALIDACION FINAL
		 lHayErr := .T.
		 DO CASE
		 CASE CLI->nSdoactCli == 0 .AND. '*' $ CLI->cMespagCli
		      cError('A '+CLI->cCodigoEst+':'+cNombreTes,;
			     'NO SE FACTURO DESPUES DE LA '+;
			     'CORRECION DE LA FORMA DE PAGO')

		 CASE PAG->nVlrpagPag == 0
		      cError('A '+CLI->cCodigoEst+':'+cNombreTes,;
			     'NO TUVO QUE CANCELAR NINGUN VALOR')

		 CASE nMesUlt > VAL(cNroMes)
/*
		      cError('A '+CLI->cCodigoEst+':'+cNombreTes,;
			     'YA SE FACTURO UN MES '+;
			     'POSTERIOR A '+cMes(VAL(cNroMes)))
*/

		 OTHERWISE
		     lHayErr := .F.
		 ENDCASE
		 IF lHayErr
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VALIDACION FINAL

*--------------ANALISIS DE LA FORMA DE PAGO
		 IF !EMPTY(PAG->dFecPagPag) .OR. PAG->cEstadoPag == 'A'
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA FORMA DE PAGO

*--------------CALCULO DE LOS INTERESES
		 nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				       PAG->nMesIniPag,;
				       CAA->nMesAmnCaA,;
				       @nIntAnt)

		 nIntNoP := nVlrIntNoP(CAA->lIntPenCaA,;
				       PAG->nMesIniPag,;
				       CAA->nMesAmnCaA)
*--------------FIN CALCULO DE LOS INTERESES

*--------------ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO
		 nSdoAnoTcl := PAG->nSdoAnoPag
		 nMorAnoTcl := PAG->nMorAnoPag+nIntAnt

		 nSdoActTcl := PAG->nSdoAntPag+PAG->nVlrMesPag
		 nSdoMorTcl := PAG->nMorAntPag+nIntNoP
*--------------FIN ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO

*--------------GRABACION DE LA FORMA DE PAGO
		 IF PAG->(lRegLock(lShared,.F.))
		    REPL PAG->cEstadoPag WITH 'D'
		    REPL PAG->cNomUsrPag WITH cModem
		    REPL PAG->dFecUsrPag WITH DATE()
		    REPL PAG->cHorUsrPag WITH TIME()
		 ELSE
		    cError('NO SE GRABA LA FORMA DE PAGO')
		 ENDIF
*--------------FIN GRABACION DE LA FORMA DE PAGO

*--------------GRABACION DE LA FORMA DE PAGO
		 cMesPagCoE(lShared,;
			    CLI->cCodigoEst,;
			    ALLTRIM(PAG->cConSdoPag)+;
			    ALLTRIM(PAG->cConcepPag),;
			    PAG->nMesIniPag,;
			    PAG->cIniFinPag,;
			    ' ')
		*Borra todos los estados. Para eliminar adelantados.

		 cMesPagCoE(lShared,;
			    CLI->cCodigoEst,;
			    PAG->cConcepPag,;
			    PAG->nMesIniPag,;
			    PAG->cIniFinPag,;
			    'D')
		*Graba el estado NO PAGO
*--------------FIN GRABACION DE LA FORMA DE PAGO

*--------------MES FINAL FACTURACION POR CONCEPTOS
		 nMesFin := PAG->nMesFinPag
		 nNroPos := AT('PE',PAG->cConcepPag)
		 IF nNroPos # 0 .AND. !EMPTY(PAG->cIniFinPag)

		    nNroPos := ((nNroPos+1)/2)+1
		   *Posici¢n mes final
		    nMesFin := VAL(SUBS(PAG->cIniFinPag,nNroPos*2-1,2))

		 ENDIF
*--------------FIN MES FINAL FACTURACION POR CONCEPTOS

*--------------GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES
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


		    REPL CLI->cMesPagCli WITH;
			 STUFF(CLI->cMespagCli,PAG->nMesIniPag,1,'D')
		   *Graba el control del meses no pagado

		    FOR i := IF(PAG->nMesIniPag==12,12,PAG->nMesIniPag+1);
			TO nMesFin
			REPL CLI->cMesPagCli;
			     WITH STUFF(CLI->cMesPagCli,i,1,' ')
		    NEXT
		   *Borra el control de meses adelantados no pagos

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

		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
*--------------FIN GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES

*--------------GRABACION DEL PAZ Y SALVO
		 IF nCodPaz # 0
		    SELECT &cMaeAct
		    IF lRegLock(lShared,.F.)
		       cCampos := cMaeAct+'->cPazSdoEst'
		       REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,'N')
		       DBCOMMIT()
		    ELSE
		       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
		    ENDIF
		    IF lShared
		       DBUNLOCK()
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL PAZ Y SALVO

*--------------IMPRESION DE LOS DETALLES DEL PAGO
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
		 @ nNroFil,aNroCol[1] SAY CLI->cCodigoEst
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY CLI->nSdoAnoCli+CLI->nMorAnoCli+;
					  CLI->nSdoActCli+CLI->nSdoMorCli;
					  PICT "9999,999.99"
		 @ nNroFil,aNroCol[4] SAY PAG->nVlrMesPag PICT "$###,###.99"
		 @ nNroFil,aNroCol[5] SAY 0
		 SET COLOR TO I
		 @ nNroFil,aNroCol[6] SAY 'NO PAGO'
		 SET COLOR TO
*--------------FIN IMPRESION DE LOS DETALLES DEL PAGO

*--------------CONTROL DE LA FILA DE VISUALIZACION
		 nNroFil++
		 IF nNroFil > 20

		    nNroFil := nMarco(nFilPal+1)
		    @ nNroFil-2,01 SAY cCabeza
		    nNroFil++

		 ENDIF
*--------------FIN CONTROL DE LA FILA DE VISUALIZACION

	       SELECT CLI
	       SKIP

	    ENDDO
**********FIN CANCELACION DEL RECIBO POR GRUPO

	  SELECT GRU
	  SKIP

       ENDDO
*>>>>FIN CANCELACION DE LOS RECIBOS

*>>>>VALIDACION DE DEUDORES
       aErrCta := aValDeudor(lShared,nModCry,cNomSis,cAnoUsr,cMaeAlu,;
			     nRegIni,nRegFin,cPatSis,VAL(cNroMes))
       IF LEN(aErrCta) # 0
	  cError('EXISTEN ESTUDIANTES QUE FIGURAN DEUDORES',;
		 'IMPRIMA REGISTROS NO PROCESADOS')
       ENDIF

       CloseDbf('GRU')
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN VALIDACION DE DEUDORES
