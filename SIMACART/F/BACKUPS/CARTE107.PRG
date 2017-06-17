/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: ELIMINAR NOVEDADES                       MODULO No. 105

**************************************************************************
* NOMBRE ..: ELIMINACION DE NOVEDADES                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 28/99 MAR A
       Bucaramanga, Colombia        INICIO: 12:40 AM   SEP 28/99 MAR

OBJETIVOS:

1- Permite eliminar todas las novedades como abonos,descuentos,recargos,
   pagos parciales.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_107(aParam1,aParam2,aParam3)

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

       LOCAL     i,x := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nTipDes := 0                   // Tipo de Descuento
       LOCAL cNomDes := ''                  // Nombre del Descuento
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL aMsgErr := {}                  // Mensajes de Error
       LOCAL nIntNoP := 0                   // Valor de los intereses no pago
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Mora Actual
       LOCAL nSdoAnoTcl := 0                // Saldo del A¤o Anterior
       LOCAL nMorAnoTcl := 0                // Saldo Mora A¤o Anterior
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<DESCUENTOS     >',;
		  '2<RECARGOS       >',;
		  '3<ABONOS         >',;
		  '4<PAGOS PARCIALES>'}

       aAyuda := {'Permite Eliminar los Descuentos',;
		  'Permite Eliminar los Recargos',;
		  'Permite Eliminar los Abonos',;
		  'Permite Eliminar los pagos parciales'}
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>LECTURA DEL TIPO DE DESCUENTO
       nTipDes := 1
       nTipDes := nMenu(aMenus,aAyuda,nFilInf,nColInf,NIL,NIL,nTipDes,.F.)
       IF nTipDes == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)

       DO CASE
       CASE nTipDes == 1
	    cNomDes := 'DESCUENTO'
       CASE nTipDes == 2
	    cNomDes := 'RECARGO'
       CASE nTipDes == 3
	    cNomDes := 'ABONO'
       CASE nTipDes == 4
	    cNomDes := 'PAG PARCIAL'
       ENDCASE
*>>>>FIN LECTURA DEL TIPO DE DESCUENTO

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
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
	    RESTSCREEN(0,0,24,79,cSavPan)
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(RTRIM(cNombreTes)+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cMaeAct->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       cError(cNombreTes+' NO PERTENCE AL GRUPO: '+&cMaeAct->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('GRUPO: '+&cMaeAct->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			'ºNo. '+STR(CLI->(RECNO()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DEL ULTIMO RECIBO
	    IF nUltRecPag(cCodigoTes) == 0
	       nMesIni := 0
	    ELSE
	       nMesIni := PAG->nMesIniPag
	    ENDIF
**********FIN LOCALIZACION DEL ULTIMO RECIBO

**********VALIDACION DE LA CONCILIACION
	    IF nTipDes # 3 // DIFERENTE A ABONO

	       IF SUBS(CAA->cValConCaA,nMesIni,1) # SPACE(01)

		  cError('LA CONCILIACION DE '+cMes(nMesIni,10)+' '+;
			 'YA SE REPORTO A CONTABILIDAD')

		  CloseDbf('CLI',FileCli,nModCry)
		  CloseDbf('PAG',FilePag,nModCry)
		  LOOP

	       ENDIF

	    ENDIF
**********FIN VALIDACION DE LA CONCILIACION

**********FILTRACION DEL ARCHIVO DE DESCUENTOS
	    SELECT DES
	    IF nTipDes == 3  // Abono
	       SET FILTER TO DES->cCodigoEst == cCodigoTes .AND.;
			     DES->nTipDesDes == nTipDes
	    ELSE
	       SET FILTER TO DES->cCodigoEst == cCodigoTes .AND.;
			     DES->nNroMesDes == nMesIni    .AND.;
			     DES->nTipDesDes == nTipDes
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO DE DESCUENTOS

**********VALIDACION DEL FILTRO DE DESCUENTOS
	    GO TOP
	    IF nTipDes == 3  // Abono

	       lHayErr := .T.
	       DO CASE
	       CASE DES->(EOF())
		    cError('NO EXISTEN ABONOS')

	       CASE .NOT. DES->(EOF())

		    DES->(DBGOBOTTOM())
		    IF !(nMesIni   == DES->nNroMesDes .OR.;
			 nMesIni-1 == DES->nNroMesDes)
		       cError('NO SE PUEDE ELIMINAR ABONOS')
		    ELSE
		       lHayErr := .F.
		    ENDIF

	       OTHERWISE
		    lHayErr := .F.
	       ENDCASE
	       IF lHayErr
		  SET FILTER TO
		  LOOP
	       ENDIF

	    ELSE
	       IF DES->(EOF())
		  SET FILTER TO
		  cError('NO EXISTEN '+cNomDes+'S PARA '+cMes(nMesIni))
		  LOOP
	       ENDIF
	    ENDIF
	    DES->(DBGOBOTTOM())
**********FIN VALIDACION DEL FILTRO DE DESCUENTOS

**********LOCALIZACION DEL CODIGO DEL PAGO
	    IF !lLocCodPag(cCodigoTes,nMesIni,.F.)
	       cError('NO EXISTE EL RECIBO DEL MES DE '+cMes(nMesIni))
	       LOOP
	    ENDIF
	    SELECT PAG
	    nRegPag := PAG->(RECNO())
**********FIN LECTURA DE LOS DETALLES DEL PAGO

**********CONSULTA DEL ULTIMO RECIBO
	    nMesIni := DES->nNroMesDes
	    nNroFil := nMarco(nFilInf+1,'ULTIMO '+cNomDes+;
					' PARA '+cMes(nMesIni),22,'°')

	    @  nNroFil ,01 SAY 'CODIGO: '+&cMaeAct->cCodigoEst
	    @  nNroFil ,16 SAY 'NOMBRE: '+RTRIM(&cMaeAct->cApelliEst)+' '+;
						&cMaeAct->cNombreEst
	    @ nNroFil++,65 SAY 'CURSO : '+&cMaeAct->cCodigoGru

	    @ ++nNroFil,01 SAY 'VLR '+cNomDes
	    @  nNroFil ,20 SAY 'FECHA' +SPACE(08)
	    @  nNroFil ,35 SAY 'DESCRIPCION'

	    @ ++nNroFil,01 SAY TRANS(DES->nValorDes,"####,###,###")
	    @ nNroFil,20   SAY cFecha(DES->dFechaDes)
	    @ nNroFil,35   SAY DES->cDescriDes

	    IF !lPregunta('DESEA ELIMANAR ESTA NOVEDAD? No Si')
	       LOOP
	    ENDIF
**********FIN CONSULTA DEL ULTIMO RECIBO

**********ELIMINACION DEL DESCUENTO O RECARGO
	    IF nTipDes == 1 .OR. nTipDes == 2 .OR. nTipDes == 4

*--------------ACTUALIZACION EN PAGOS
		 IF PAG->(lRegLock(lShared,.F.))
		    IF nTipDes == 1 .OR. nTipDes == 4  // Descuento

		       IF PAG->nVlrDesPag # 0
			  REPL PAG->nVlrMesPag WITH PAG->nVlrMesPag+;
						    DES->nValorDes

			  REPL PAG->nVlrDesPag WITH PAG->nVlrDesPag-;
						    DES->nValorDes
		       ENDIF

		    ELSE                               // Recargo
		       IF PAG->nVlrRecPag # 0
			  REPL PAG->nVlrMesPag WITH PAG->nVlrMesPag-;
						    DES->nValorDes

			  REPL PAG->nVlrRecPag WITH PAG->nVlrRecPag-;
						    DES->nValorDes
		       ENDIF
		    ENDIF
		    REPL PAG->nVlrPagPag WITH PAG->nSdoAntPag+;
					      PAG->nMorAntPag+;
					      PAG->nVlrMesPag
		    PAG->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
		 IF lShared
		    PAG->(DBUNLOCK())
		 ENDIF
*--------------FIN ACTUALIZACION EN PAGOS

	    ENDIF
**********FIN ELIMINACION DEL DESCUENTO O RECARGO

**********ELIMINACION DEL ABONO
	    IF nTipDes == 3

*--------------ACTUALIZACION EN PAGOS
		 FOR i := 1 TO 2

*....................ACTUALIZACION DEL REGISTRO
		       nMesIni := IF(i==1,DES->nNroMesDes,DES->nMesModDes)
		       IF lLocCodPag(cCodigoTes,nMesIni,.F.)

			  IF PAG->(lRegLock(lShared,.F.))
			     REPL PAG->nSdoAnoPag;
			       WITH IF(i==1,DES->nSdoAnoPag,;
					    DES->nAnoSdoPag)

			     REPL PAG->nMorAnoPag;
			       WITH IF(i==1,DES->nMorAnoPag,;
					    DES->nAnoMorPag)

			     REPL PAG->nSdoAntPag;
			       WITH IF(i==1,DES->nSdoAntPag,;
					    DES->nSdoAntDes)

			     REPL PAG->nMorAntPag;
			       WITH IF(i==1,DES->nMorAntPag,;
					    DES->nMorAntDes)

			     REPL PAG->nVlrMesPag;
			       WITH IF(i==1,DES->nVlrMesPag,;
					    DES->nVlrMesDes)

			     REPL PAG->nVlrMorPag;
			       WITH IF(i==1,DES->nVlrMorPag,;
					    DES->nVlrMorDes)

			     REPL PAG->nVlrPagPag WITH PAG->nSdoAntPag+;
						       PAG->nMorAntPag+;
						       PAG->nVlrMesPag

			     IF PAG->nMesIniPag == DES->nNroMesDes

				REPL PAG->nAbonosPag WITH PAG->nAbonosPag-;
							  DES->nValorDes
			     ENDIF
			     IF PAG->nMesIniPag == DES->nNroMesDes
				REPL PAG->nSdAanoPag WITH PAG->nSdAanoPag-;
							  DES->nSdoAnoDes
				REPL PAG->nMoAanoPag WITH PAG->nMoAanoPag-;
							  DES->nMorAnoDes
			     ENDIF
			     PAG->(DBCOMMIT())
			  ELSE
			     cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
			  ENDIF

			  IF lShared
			     PAG->(DBUNLOCK())
			  ENDIF
		       ELSE
			  cError('NO SE ENCUENTRA EL RECIBO DEL MES DE '+cMes(nMesIni))
		       ENDIF
*....................FIN ACTUALIZACION DEL REGISTRO

		 ENDFOR
*--------------FIN ACTUALIZACION EN PAGOS

	    ENDIF
**********FIN ELIMINACION DEL ABONO

**********ELIMINACION DE LA NOVEDAD
	    SELECT DES
	    IF DES->(lRegLock(lShared,.F.))

*--------------ELIMINACION DEL REGISTRO
		 IF !DELETED()
		    DELETE
		 ENDIF
*--------------FIN ELIMINACION DEL REGISTRO

*--------------VALIDACION DE LA ELIMINACION
		 IF !DELETED()
		    cError('NO SE BORRO EL '+cNomDes)
		 ENDIF
*--------------FIN VALIDACION DE LA ELIMINACION

	    ELSE
	       cError('NO SE BORRO EL '+cNomDes)
	    ENDIF
**********FIN ELIMINACION DE LA NOVEDAD

**********ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO
	    SELECT PAG
	    GO nRegPag
	    DO CASE
	    CASE PAG->cEstadoPag == 'P' .OR. ;
		 PAG->cEstadoPag == 'A'

*----------------ACTUALIZACION DEL SALDO
		   IF CAA->nMesAmnCaA == PAG->nMesIniPag
		      nSdoActTcl := PAG->nSdoAntPag
		      nSdoMorTcl := PAG->nMorAntPag
		      nSdoAnoTcl := PAG->nSdoAnoPag
		      nMorAnoTcl := PAG->nMorAnoPag
		   ELSE
		      nSdoActTcl := 0
		      nSdoMorTcl := 0
		      nSdoAnoTcl := 0
		      nMorAnoTcl := 0
		   ENDIF
*----------------FIN ACTUALIZACION DEL SALDO

	    CASE PAG->cEstadoPag == 'D'

*----------------ACTUALIZACION DEL SALDO
		   nIntNoP := nIntMesNoP(CAA->lIntPenCaA,;
					 PAG->nSdoAntPag,;
					 PAG->nVlrMesPag,;
					 PAG->nMesIniPag,;
					 CAA->nMesAmnCaA)

		   nSdoActTcl := PAG->nSdoAntPag+PAG->nVlrMesPag
		   nSdoMorTcl := PAG->nMorAntPag+nIntNoP


		   nSdoAnoTcl := PAG->nSdoAnoPag
		   nMorAnoTcl := PAG->nMorAnoPag+nVlrInt(PAG->nSdoAnoPag)
*----------------FIN ACTUALIZACION DEL SALDO

	    CASE PAG->cEstadoPag == '*'

*----------------ACTUALIZACION DEL SALDO
		   nSdoActTcl := PAG->nSdoAntPag
		   nSdoMorTcl := PAG->nMorAntPag
		   nSdoAnoTcl := PAG->nSdoAnoPag
		   nMorAnoTcl := PAG->nMorAnoPag
*----------------FIN ACTUALIZACION DEL SALDO

	    ENDCASE
**********FIN ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO

**********GRABACION DEL SALDO EN CLIENTES
	    IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A' .OR.;
	       PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag == '*'

	       IF CLI->(lRegLock(lShared,.F.))
		  REPL CLI->nSdoActCli WITH nSdoActTcl
		  REPL CLI->nSdoMorCli WITH nSdoMorTcl
		  REPL CLI->nSdoAnoCli WITH nSdoAnoTcl
		  REPL CLI->nMorAnoCli WITH nMorAnoTcl
		  CLI->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	       ENDIF
	       IF lShared
		  CLI->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL SALDO EN CLIENTES

**********VALIDACION DEL ESTADO DE CUENTA DESPUES DEL ABONO
	    aMsgErr := aValCtaEst(cCodigoTes,.F.)

	    IF LEN(aMsgErr) > 0

	       cError('FAVOR REVISAR EXISTEN INCONSISTENCIAS EN EL ESTADO DE CUENTA')

	       FOR x := 1 TO LEN(aMsgErr)
		   cError(aMsgErr[x])
	       ENDFOR
	    ENDIF
**********FIN VALIDACION DEL ESTADO DE CUENTA

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)


       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION