/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: CANCELAR RECIBOS       MODULO No. 106

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE106.PRG                                    *
* TITULO DEL PROGRAMA..: ELIMINAR UN RECIBO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 12/97 MAR A
       Bucaramanga, Colombia        INICIO: 10:50 AM   AGO 12/97 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite cancelar el £ltimo recibo de facturaci¢n.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_106(aParam1,aParam2,aParam3)

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
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL       i := 0                   // Contador
       LOCAL cCampos := ''                  // Variable de Campo
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cPazCar := ''                  // Paz y Salvo en Cartera
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL nNroFil := 0                   // N£mero de fila
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cConSdoTpa := ''               // Concepto en mora
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL nFavPagTpa := 0                // Saldo a Favor Pagado.
       LOCAL nFavAplTpa := 0                // Saldo a Favor aplicado.
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Saldo de la Mora
       LOCAL nSdAbonTcl := 0                // Saldo Actual sin abonos
       LOCAL nMoAbonTcl := 0                // Saldo de la Mora sin abonos
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbf(.T.,cIntUno+'\'+;
		       fPazEst+cAnoSis+ExtFile,'PAZ',;
		       NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		   fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileDes,'DES',;
		       cPatSis+'\'+fNtxDes,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION ITEM DEL PAZ Y SALVO
       nCodPaz := 0
       IF lLocCodigo('nNroTipPaz','PAZ',1)
	  nCodPaz := PAZ->nCodigoPaz
       ENDIF
       IF EMPTY(nCodPaz)
	  cError('NO ESTA HABILITADO EL ITEM DE LOS PAZ Y SALVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION ITEM DEL PAZ Y SALVO

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       FileCli := ''
       FilePag := ''
       cSavPan := SAVESCREEN(0,0,24,79)
       DO WHILE .T.

**********CIERRE DE ARCHIVOS
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN CIERRE DE ARCHIVOS

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    RESTSCREEN(0,0,24,79,cSavPan)
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			   RTRIM(&cNalias->cNombreEst)
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
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION EN CLIENTES
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(RTRIM(cNombreTes)+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION EN CLIENTES

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       cError(cNombreTes+' NO PERTENCE AL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********LOCALIZACION DEL ULTIMO RECIBO
	    nRegPag := nUltRecPag(cCodigoTes)
	    IF nRegPag == 0
	       cError('NO EXISTEN RECIBOS PARA EL CODIGO '+cCodigoTes)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ULTIMO RECIBO

**********VALIDACION DE LA CONCILIACION
	    nMesIniTpa := PAG->nMesIniPag
	    IF SUBS(CAA->cValConCaA,nMesIniTpa,1) # SPACE(01)

	       cError('LA CONCILIACION DE '+cMes(nMesIniTpa,10)+' '+;
		      'YA SE REPORTO A CONTABILIDAD')

	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LA CONCILIACION

**********VALIDACION DEL ULTIMO RECIBO
	    IF !EMPTY(PAG->dFecPagPag) .AND. PAG->cEstadoPag # 'D'

	       cError('EL ULTIMO RECIBO FIGURA PAGADO. '+;
		      'NO SE PUEDA ELIMINAR')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP

	    ENDIF
**********FIN VALIDACION DEL ULTIMO RECIBO

**********VALIDACION DEL ABONO
	    SELECT DES
	    LOCATE FOR DES->cCodigoEst == cCodigoTes     .AND.;
		       DES->nTipDesDes == 3              .AND.;
		      (DES->nNroMesDes == PAG->nMesIniPag .OR.;
		       DES->nMesModDes == PAG->nMesIniPag)

	    IF DES->(FOUND())
	       cError('EL ULTIMO RECIBO ESTA AFECTADO POR UN ABONO. '+;
		      'NO SE PUEDA ELIMINAR')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP
	    ENDIF
	    SELECT PAG
**********FIN VALIDACION DEL ABONO

**********CONSULTA DEL ULTIMO RECIBO
	    nNroFil := nMarco(nFilInf,;
			      'ULTIMO RECIBO. MES: '+;
			      cMes(PAG->nMesIniPag,10)+' A '+;
			      cMes(PAG->nMesFinPag,10),;
			      22,'°')

	    @  nNroFil ,01 SAY 'CODIGO: '+&cNalias->cCodigoEst
	    @  nNroFil ,16 SAY 'NOMBRE: '+RTRIM(&cNalias->cApelliEst)+' '+;
						&cNalias->cNombreEst
	    @ nNroFil++,65 SAY 'CURSO : '+&cNalias->cCodigoGru

	    @ ++nNroFil,01 SAY 'CONCEPTOS'
	    @  nNroFil ,20 SAY 'MORA' +SPACE(08)
	    @  nNroFil ,35 SAY 'MES'  +SPACE(09)
	    @ nNroFil++,55 SAY 'TOTAL'+SPACE(07)

	    @ nNroFil,01 SAY PAG->cConcepPag
	    @ nNroFil,20 SAY TRANS(PAG->nSdoAntPag,"####,###,###")
	    @ nNroFil,35 SAY TRANS(PAG->nVlrMesPag,"####,###,###")
	    @ nNroFil,55 SAY TRANS(PAG->nVlrPagPag,"####,###,###")

	    nNroFil += 1
	    IF PAG->nSdoFavPag # 0
	       @ nNroFil ,35 SAY 'SALDO A FAVOR '
	       SET COLOR TO G*
	       @ nNroFil,50 SAY TRANS(PAG->nSdoFavPag,"####,###,###")
	       SET COLOR TO
	    ENDIF

	    @  nNroFil ,01 SAY 'ORDINARIO------->'
	    @ nNroFil++,18 SAY TRANS(PAG->nVlrPagPag+;
				     PAG->nSdoFavPag,"####,###,###")
	    @  nNroFil ,01 SAY 'EXTRAORDINARIO-->'
	    @  nNroFil ,18 SAY TRANS(PAG->nVlrPagPag+PAG->nSdoFavPag+;
			       ROUND(((PAG->nSdoAntPag+;
				       ABS(PAG->nVlrMesPag))*;
				       PAG->nIntMorPag)/100,0),;
			       "####,###,###")

	    IF !lPregunta('DESEA ELIMANAR ESTE RECIBO? No Si')
	       LOOP
	    ENDIF
**********FIN CONSULTA DEL ULTIMO RECIBO

***********GRABACION DE LA FORMA DE PAGO
	     cMesPagCoE(lShared,;
			 CLI->cCodigoEst,;
			 ALLTRIM(PAG->cConSdoPag)+;
			 ALLTRIM(PAG->cConcepPag),;
			 PAG->nMesIniPag,;
			 PAG->cIniFinPag,;
			 ' ')
***********FIN GRABACION DE LA FORMA DE PAGO

**********ELIMINACION DEL ULTIMO RECIBO
	    SELECT PAG
	    nSdoActTcl := PAG->nSdoAntPag
	    nSdoMorTcl := PAG->nMorAntPag

	    IF EMPTY(PAG->cConcepPag)
	       cConSdoTpa := PAG->cConSdoPag
	    ELSE
	       cConSdoTpa := PAG->cConcepPag
	    ENDIF

	    nSdAbonTcl := PAG->nSdAbonPag //m
	    nMoAbonTcl := PAG->nMoAbonPag //m

	    nFavPagTpa := PAG->nFavPagPag
	    nFavAplTpa := PAG->nFavAplPag
	    IF lRegLock(lShared,.F.)

	       IF !DELETED()
		 DELETE
	       ENDIF

	       IF !DELETED()
		  cError('NO SE BORRO EL RECIBO DE '+cMes(nMesIniTpa,10),;
			 'POR FAVOR TOME NOTA Y AVISE AL SUPERVISOR EL SISTEMA')
		  LOOP
	       ENDIF

	    ELSE
	       cError('NO SE BORRO EL RECIBO DE '+cMes(nMesIniTpa,10),;
		      'POR FAVOR TOME NOTA Y AVISE AL SUPERVISOR EL SISTEMA')
	       LOOP
	    ENDIF
**********FIN ELIMINACION DEL ULTIMO RECIBO

**********ELIMINACION DE LA MARCA DEL ULTIMO RECIBO
	    IF CLI->(lRegLock(lShared,.F.))

	       REPL CLI->nSdoActCli WITH nSdoActTcl
	       REPL CLI->nSdoMorCli WITH nSdoMorTcl
	      *Actualizaci¢n del saldo

	       IF CLI->nSdoActCli+CLI->nSdoMorCli == 0
		  REPL CLI->cConSdoCli WITH ''
	       ELSE
		  REPL CLI->cConSdoCli WITH cConSdoTpa
	       ENDIF
	     *ÀGrabaci¢n de los conceptos del saldo

	       REPL CLI->nSdAbonCli WITH nSdAbonTcl //m
	       REPL CLI->nMoAbonCli WITH nMoAbonTcl //m
	      *Actualizaci¢n del saldo sin abonos

	       REPL CLI->nSdoFavCli WITH CLI->nSdoFavCli-;
					      nFavPagTpa+nFavAplTpa

	       REPL CLI->cMesPagCli WITH;
			 STUFF(CLI->cMespagCli,nMesIniTpa,1,SPACE(01))
	      *Borra el control del £ltimo recibos

	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN ELIMINACION DE LA MARCA DEL ULTIMO RECIBO

**********VALIDACION DEL PAZ Y SALVO
	    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0

*==============VALIDACION PAGO ULTIMO RECIBO
		 IF nUltRecPag(CLI->cCodigoEst) # 0 .AND.;
		    CLI->cCodigoEst == PAG->cCodigoEst

		    IF !EMPTY(PAG->dFecPagPag) .AND.;
		       (PAG->cEstadoPag == 'P' .OR.;
			PAG->cEstadoPag == 'A')
		       cPazCar := SPACE(01)
		    ELSE
		       cPazCar := '*'
		    ENDIF

		 ELSE
		    cPazCar := SPACE(01)
		 ENDIF
*==============FIN VALIDACION PAGO ULTIMO RECIBO

	    ELSE
	       cPazCar := 'N'
	    ENDIF
**********FIN VALIDACION DEL PAZ Y SALVO

**********GRABACION DEL PAZ Y SALVO
	    SELECT &cNalias
	    IF lRegLock(lShared,.F.)
	       cCampos := cNalias+'->cPazSdoEst'
	       REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,cPazCar)
	       DBCOMMIT()
	    ELSE
	       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	    ENDIF
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

**********VALIDACION DEL ESTADO DE CUENTA
/*
	    IF LEN(aValCtaEst(cCodigoTes,.F.)) # 0
	       cError('ESTADO DE CUENTA CON PROBLEMAS',;
		      'POR FAVOR REVISAR')
	    ENDIF
*/
**********FIN VALIDACION DEL ESTADO DE CUENTA

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION