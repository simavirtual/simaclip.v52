/*************************************************************************
* TITULO ..: CANCELACION DE LOS RECIBOS DE PAGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2000 MAR A
       Colombia, Bucaramanga        INICIO: 10:20 AM   NOV 28/2000 MAR

OBJETIVOS:

1- Cancela los recibos de pago por los servicios educativos

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CodPag02(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cNroMes,oBrowse,cModem,cSavPan,nNroFil,aNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cSavPan                              // Salvar Pantalla
       nNroFil                              // N£mero de la Fila
       aNroCol                              // Numeros de Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL       i := 0                   // Contador
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL aRegAct := {}                  // Registro Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL nSdoActTcl := 0                // Saldo del cliente
       LOCAL nSdoMorTcl := 0                // Saldo de la mora
       LOCAL cEstadoTpa := ''               // Forma de pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
       IF !lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,NIL,.F.)
	  RETURN NIL
       ENDIF
       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
		     RTRIM(&cMaeAct->cNombreEst)
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
       cCodigoTgr := &cMaeAct->cCodigoGru
*>>>>FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

*>>>>CIERRE DE ARCHIVOS
       IF SELECT('CLI') # 0
	  CloseDbf('CLI',FileCli,nModCry)
       ENDIF

       IF SELECT('PAG') # 0
	  CloseDbf('PAG',FilePag,nModCry)
       ENDIF
*>>>>FIN CIERRE DE ARCHIVOS

*>>>>PREPARACION DE LAS VARIABLES DE ARCHIVO
       FileCli := cPatSis+'\CLIENTES\CL'+;
		  cCodigoTgr+cAnoSis+ExtFile
       FilePag := cPatSis+'\PAGOS\PA'+;
		  cCodigoTgr+cAnoSis+ExtFile
*>>>>FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
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
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION EN CLIENTES
       IF !lLocCodigo('cCodigoEst','CLI',TRA->cCodigoEst)

	  ObservTra(lShared,' NO EXISTE EN LOS CLIENTES DEL GRUPO: '+;
		   cCodigoTgr)

	  cError(cNombreTes+' NO EXISTE EN LOS '+;
		 'CLIENTES DEL GRUPO: '+cCodigoTgr)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION EN CLIENTES

*>>>>VALIDACION DEL MES ACTUAL
       IF TRA->nMesIniTra # LEN(RTRIM(CLI->cMesPagCli))

	  ObservTra(lShared,'PAGO '+cMes(TRA->nMesIniTra)+' '+;
		    'EN EL MES DE '+cMes(VAL(cNroMes)))

	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES ACTUAL

*>>>>LOCALIZACION DEL PAGO
       IF !lLocCodPag(TRA->cCodigoEst,TRA->nMesIniTra,.F.)

	  ObservTra(lShared,'NO SE LE GENERO RECIBO DE PAGO')

	  cError('NO SE LE GENERO RECIBO DE PAGO A '+cNombreTes+;
		 'CODIGO: '+TRA->cCodigoEst)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO

*>>>>CALCULO DE LOS INTERESES
       nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
			     PAG->nMesIniPag,;
			     CAA->nMesAmnCaA)
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DEL PAGO
       nVlrTra := 0
       aRegAct := {}
       DO WHILE CLI->cCodigoEst == TRA->cCodigoEst .AND.;
		!(TRA->nMesIniTra < 1 .OR. TRA->nMesIniTra > 12  .OR.;
		  TRA->nMesFinTra < 1 .OR. TRA->nMesFinTra > 12)

	  nVlrTra += TRA->nValorTra
	  AADD(aRegAct,TRA->(RECNO()))
	  TRA->(DBSKIP())

       ENDDO
       IF EMPTY(aRegAct)
	  cError('EN EL VECTOR DE LOS PAGOS')
	  IF !lPregunta('DESEA CONTINUAR? No Si')
	     CloseDbf('CLI',FileCli,nModCry)
	     CloseDbf('PAG',FilePag,nModCry)
	     RESTSCREEN(0,0,24,79,cSavPan)
	     SELECT TRA
	     oBrowse:GOTOP()
	     oBrowse:FORCESTABLE()
	     RETURN NIL
	  ENDIF
       ENDIF
       SELECT TRA
       GO aRegAct[1]
*>>>>FIN ANALISIS DEL PAGO

*>>>>ANALISIS DEL PAGO DEL RECIBO
       nForPag := 3
       IF TRA->dFechaTra > PAG->dPagOpoPag
	  IF nVlrTra == PAG->nVlrPagPag+nVlrInt
	     nForPag := 2
	  ENDIF
       ELSE
	  IF nVlrTra == PAG->nVlrPagPag
	     nForPag := 1
	  ENDIF
       ENDIF
      *1<PAGO OPO> 2<PAG EXT> 3<NO PAGO>
*>>>>FIN ANALISIS DEL PAGO DEL RECIBO

*>>>>LOCALIZACION DEL TIPO DE MOVIMIENTO
       IF !lLocCodigo('cCodigoTra','TMV',TRA->cCodigoTra)

	  ObservTra(lShared,'NO EXISTE LA TRANSACION '+TMV->cCodigoTra)
	  cError('NO EXISTE LA TRANSACION '+TMV->cCodigoTra)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL TIPO DE MOVIMIENTO

*>>>>VALIDACION FINAL
       lHayErr := .T.
       DO CASE
       CASE nForPag # 3 .AND. !TMV->lSumarTra

	    ObservTra(lShared,ALLTRIM(TMV->cNombreTmv))
	    cError(ALLTRIM(TMV->cNombreTmv))

       CASE CLI->nSdoactCli == 0 .AND. '*' $ CLI->cMespagCli
	    ObservTra(lShared,'NO SE FACTURO DESPUES DE LA CORRECION')

       CASE PAG->nVlrpagPag == 0
	    ObservTra(lShared,'NO TUVO QUE CANCELAR NINGUN VALOR')

       CASE nForPag == 3
	    IF EMPTY(TRA->nValidaTra)
	       ObservTra(lShared,'NO LE COINCIDE EL VALOR PAGADO')
	       cError('NO LE COINCIDE EL VALOR PAGADO')
	    ENDIF
       OTHERWISE
	   lHayErr := .F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION FINAL

*>>>>ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO
       IF nForPag == 1 .OR. nForPag == 2  // Pago el recibo
	  nSdoActTcl := 0
	  nSdoMorTcl := 0
       ENDIF
*>>>>FIN ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE nForPag       == 1
	     cEstadoTpa := 'PAGO OPO'
	     cForPag      := 'P'

       CASE nForPag       == 2
	     cEstadoTpa := 'PAGO EXT'
	     cForPag      := 'A'
       ENDCASE
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

*>>>>GRABACION DE LA FORMA DE PAGO
       IF PAG->(lRegLock(lShared,.F.))
	  REPL PAG->dFecPagPag WITH TRA->dFechaTra
	  REPL PAG->cEstadoPag WITH cForPag
	  REPL PAG->cNomUsrPag WITH cModem
       ELSE
	  cError('NO SE GRABA LA FORMA DE PAGO')
       ENDIF
*>>>>FIN GRABACION DE LA FORMA DE PAGO

*>>>>GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES
       IF CLI->(lRegLock(lShared,.F.))

	  REPL CLI->nSdoActCli WITH nSdoActTcl
	  REPL CLI->nSdoMorCli WITH nSdoMorTcl

	  IF nForPag == 1 .OR. nForPag == 2

	       FOR i := PAG->nMesIniPag TO PAG->nMesFinPag
		   REPL CLI->cMesPagCli;
			WITH STUFF(CLI->cMesPagCli,i,1,cForPag)
	       NEXT
	      *Graba control de meses pagados
	  ENDIF
       ELSE
	  cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
       ENDIF
*>>>>FIN GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES

*>>>>GRABACION DE LA VALIDACION DEL REGISTRO
       SELECT TRA
       FOR i := 1 TO LEN(aRegAct)
	   GO aRegAct[i]
	   IF TRA->(lRegLock(lShared,.F.))
	      IF TRA->nValidaTra < 100
		 REPL TRA->nValidaTra WITH ++TRA->nValidaTra
*		 REPL TRA->cObservTra WITH ''
	      ENDIF
	   ELSE
	      cError('NO SE GRABA LA FORMA DE PAGO')
	   ENDIF
       ENDFOR
       GO aRegAct[1]
      *Registro Actual
*>>>>FIN GRABACION DE LA VALIDACION DEL REGISTRO

*>>>>IMPRESION DE LOS DETALLES DEL PAGO
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
       @ nNroFil,aNroCol[1] SAY CLI->cCodigoEst
       @ nNroFil,aNroCol[2] SAY cNombreTes
       @ nNroFil,aNroCol[3] SAY CLI->nSdoactCli         PICT "9999,999.99"
       @ nNroFil,aNroCol[4] SAY PAG->nVlrMesPag+nVlrInt PICT "$###,###.99"
       @ nNroFil,aNroCol[5] SAY PAG->nVlrpagPag         PICT "$###,###.99"
       SET COLOR TO I
       @ nNroFil,aNroCol[6] SAY cEstadoTpa
       SET COLOR TO

       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)

       RETURN NIL
*>>>>FIN IMPRESION DE LOS DETALLES DEL PAGO