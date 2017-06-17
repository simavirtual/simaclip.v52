/*************************************************************************
* TITULO ..: LECTURA DEL ARCHIVO DEL EXTRACTO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/99 JUE A
       Bucaramanga, Colombia        INICIO: 09:55 PM   MAY 06/99 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Lee el archivo ascii generado por el Banco o Coorporaci¢n
   correspondiente al mes del estracto.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt43(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cNomArc := ''                  // Nombre del archivo
       LOCAL PathAct := ''                  // Paht Actual
       LOCAL nVlrDec := 0                   // Valor Decimal
       LOCAL FileTxt := ''                  // Archivo Texto

       LOCAL nMesIni := 0                   // Mes del pago
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL cCodFac := ''                  //@C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION,03->RESTAURANTE,04->TRANSPORTE */
       LOCAL cCodTra := ''                  // C¢digo de la transaci¢n
       LOCAL cSigTra := ''                  // Signo de la transaci¢n
       LOCAL nValor  := 0                   // Valor de la Transaci¢n
       LOCAL dFecha  := CTOD('00/00/00')    // Fecha de Pago
       LOCAL lSumar  := .F.                 // .T. Credito .F. Debito
       LOCAL cCodMtv := ''                  // C¢digo del motivo

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNroCtaTtr := ''               // N£mero de la Cuenta
       LOCAL cValCtaTba := ''               // N£mero de la Cuenta a validar
       LOCAL cOficinTtr := ''               // Oficina de la Trnasacci¢n
       LOCAL cTerOfiTtr := ''               // Terminal de la Oficina
       LOCAL cTalonTtr  := ''               // Talon de la Transaci¢n
       LOCAL cJornadTtr := ''               // Jornada de pago
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

*>>>>ACTIVACION DEL CURSOR
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !EMPTY(oBrowse)
	  SETCURSOR(1)
       ENDIF
*>>>>FIN ACTIVACION DEL CURSOR

*>>>>LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS
       cNomArc := SPACE(99)
       cSavLin := SAVESCREEN(nFilInf+1,00,nFilInf+2,79)
       @ nFilInf+1,nColInf SAY "POR FAVOR ENTRE EL NOMBRE DEL ARCHIVO "+;
			       "DEL EXTRACTO DE "+cMes(VAL(cNroMes),10)+':'
       DO WHILE .T.

**********LECTURA DEL ARCHIVO
	    @ nFilInf+2,nColInf GET cNomArc PICT "@!S50"
	    READ
**********FIN LECTURA DEL ARCHIVO

**********VALIDACION DEL ARCHIVO
	    DO CASE
	    CASE EMPTY(cNomArc)
		 RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
		 RETURN NIL

	    CASE !FILE(ALLTRIM(cNomArc))
		 cError('NO EXISTE EL ARCHIVO '+ALLTRIM(cNomArc))
		 LOOP

	    OTHERWISE
		 IF !lPregunta('DESEA CORREGIR? No Si')
		    EXIT
		 ENDIF
	    ENDCASE
**********FIN VALIDACION DEL ARCHIVO

       ENDDO
*>>>>FIN LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO MODEM
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\MODEM\"+BAN->cCodigoBan) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\MODEM\"+BAN->cCodigoBan) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO MODEM")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\MODEM\"+BAN->cCodigoBan) == -3
	    DIRMAKE(cPatSis+"\MODEM\"+BAN->cCodigoBan)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO MODEM

*>>>>CIERRE DE AREAS DE TRABAJO
       FileTmv := FileTmv+BAN->cCodigoBan+ExtFile
       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile
       FileTxt := BAN->cCodigoBan+cAnoUsr+cNroMes+'.txt'
       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,nModCry)
       CloseDbf('TMV',cPatSis+'\'+FileTmv,nModCry)
       CloseDbf('CMV',cPatSis+'\'+FileCmv,nModCry)
*>>>>FIN CIERRE DE AREAS DE TRABAJO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTmv,'TMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			 FileMoB,'TRA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>CREACION DEL ARCHIVO DEL ESTRACTO
       RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
       cNomArc := ALLTRIM(cNomArc)

       FILECOPY(cNomArc,;
		cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTxt)

       CreaDbfExt(lShared,nModCry,;
		  cPatSis+'\MODEM\'+BAN->cCodigoBan,FileMoB)
      *Creaci¢n de archivo del extracto
*>>>>FIN CREACION DEL ARCHIVO DEL ESTRACTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ERROR ABRIENDO ARCHIVOS')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS NOMBRES DE LOS CONCEPTOS DEL MOVIMIENTO')

       CASE TMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS NOMBRES DE LOS CONCEPTOS DEL MOVIMIENTO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CONVERSION DEL ARCHIVO ASCII
       Termometro(0,'LEYENDO EL ARCHIVO')
       Termometro(20)
       SELECT TRA
       APPEND FROM &cNomArc SDF
       Termometro(50)
*>>>>FIN CONVERSION DEL ARCHIVO ASCII

*>>>>VALIDACION DEL ARCHIVO
       IF !lValArcTra(@cNroCtaTtr)
	  cError(cNroCtaTtr+' NUMERO DE CUENTA ERRONEA')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

/*

*>>>>VALIDACION DE LA CUENTA
       cNroCtaTtr := ''
       IF !EMPTY(BAN->cValCtaBan)

	  TRA->(DBGOTOP())
	  TRA->(DBGOTO(2)) // Salta el Registro de Control si existe

	  cNroCtaTtr := SUBS(TRA->Registro,BAN->nNroCtaBan,BAN->nLenCtaBan)

	  cValCtaTba := SUBS(BAN->cValCtaBan,1,BAN->nLenCtaBan)

	  IF cNroCtaTtr # cValCtaTba
	     cError(cNroCtaTtr+' NUMERO DE CUENTA ERRONEA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA CUENTA

*/

*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

**********LECTURA DE LOS RESPECTIVO CAMPOS
	    cCodRef := cCodRef(TRA->Registro,@cCodFac)

	    cCodTra := SUBS(TRA->Registro,BAN->nTipMovBan,BAN->nLenTipBan)

	    IF BAN->nSigMovBan # 0 .AND.;
	       BAN->nLenSigBan # 0 .AND.;
	       BAN->nLugSigBan # 0

	       cSigTra := SUBS(TRA->Registro,BAN->nSigMovBan,BAN->nLenSigBan)
	       IF BAN->nLugSigBan == 1
		  cCodTra := cSigTra+cCodTra
	       ELSE
		  cCodTra := cCodTra+cSigTra
	       ENDIF
	    ENDIF

	    nVlrDec := 0
	    IF !EMPTY(BAN->nPagDecBan)
	       nVlrDec := VAL(SUBS(TRA->Registro,BAN->nPagDecBan,;
						 BAN->nLenDecBan))/100
	    ENDIF
	    nValor  := VAL(SUBS(TRA->Registro,BAN->nPagIntBan,;
				BAN->nLenIntBan))+nVlrDec

	    dFecha  := CTOD(SUBS(TRA->Registro,BAN->nMesPagBan,02)+'/'+;
			       SUBS(TRA->Registro,BAN->nDiaPagBan,02)+'/'+;
			       SUBS(TRA->Registro,;
				    BAN->nAnoPagBan,BAN->nLenAnoBan))

	    cOficinTtr := ''
	    IF !EMPTY(BAN->nPosOfiBan)
	       cOficinTtr := SUBS(TRA->Registro,BAN->nPosOfiBan,BAN->nLenOfiBan)
	    ENDIF

	    cTerOfiTtr := ''
	    IF !EMPTY(BAN->nPosTerBan)
	       cTerOfiTtr := SUBS(TRA->Registro,BAN->nPosTerBan,BAN->nLenTerBan)
	    ENDIF

	    cTalonTtr  := ''
	    IF !EMPTY(BAN->nPosTalBan)
	       cTalonTtr := SUBS(TRA->Registro,BAN->nPosTalBan,BAN->nLenTalBan)
	    ENDIF

	    cJornadTtr := ''
	    IF !EMPTY(BAN->nPosJorBan)
	       cJornadTtr := SUBS(TRA->Registro,BAN->nPosJorBan,BAN->nLenJorBan)
	    ENDIF

	    cCodMtv := ''
	    IF !EMPTY(BAN->nPosJorBan)
	       cCodMtv := ALLTRIM(SUBS(TRA->Registro,;
				  BAN->nMotivoBan,BAN->nLenMtvBan))
	    ENDIF
**********FIN LECTURA DE LOS RESPECTIVO CAMPOS

**********LOCALIZACION DE LA TRANSACION
	    IF lLocCodigo('cCodigoTra','TMV',cCodTra)
	       lSumar := TMV->lSumarTra
	    ELSE
	       cError('EL CODIGO: '+cCodTra+;
		      ' NO EXISTE SE ASUME COMO UN DEBITO')
	       lSumar := .F.
	    ENDIF
**********FIN LOCALIZACION DE LA TRANSACION

**********GRABACION DE LOS CAMPOS
	    SELECT TRA
	    IF TRA->(lRegLock(lShared,.F.))
	       REPL TRA->cCodRefTra WITH cCodRef
	       REPL TRA->cCodigoEst WITH SUBS(cCodRef,1,6)
	       REPL TRA->cCodFacCar WITH cCodFac
	       REPL TRA->cCodigoTra WITH cCodTra
	       REPL TRA->nCodigoCmv WITH nCodigoCmv(VAL(cNroMes),;
						    cCodRef,BAN->nLenRefBan,;
						    ,,cCodMtv)
	       REPL TRA->nValorTra  WITH nValor
	       REPL TRA->dFechaTra  WITH dFecha
	       REPL TRA->lSumarTra  WITH lSumar
	       REPL TRA->lInsUsrTra WITH .F.
	       REPL TRA->cNroCtaTra WITH cNroCtaTtr

	       REPL TRA->cTerOfiTra WITH cTerOfiTtr
	       REPL TRA->cTalonTra  WITH cTalonTtr
	       REPL TRA->cJornadTra WITH cJornadTtr

	       TRA->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       TRA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS CAMPOS

	  TRA->(DBSKIP())

       ENDDO
       Termometro(100)
*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS

*>>>>CREACION DE INDICES
       SELECT TRA
       fNtxMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+cExtNtx
       INDEX ON TRA->cCodRefTra TO &(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxMoB)
*>>>>FIN CREACION DE INDICES

*>>>>CIERRE DE ARCHIVOS
       IF EMPTY(oBrowse)
	  CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		   FileMoB,nModCry)
	  CloseDbf('TMV',cPatSis+'\'+FileTmv,nModCry)
	  CloseDbf('CMV',cPatSis+'\'+FileCmv,nModCry)
       ELSE
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavPan)
       RETURN NIL
*>>>>FIN CIERRE DE ARCHIVOS

/*************************************************************************
* TITULO..: LECTURA DE LOS ARCHIVOS CON MOVIMIENTOS DIARIOS              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2016 LUN A
       Colombia, Bucaramanga        INICIO: 09:00 AM   SEP 26/2016 LUN

OBJETIVOS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeArcDia(lShared,nModCry,FileTra,cNroMes,lInsReg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       FileTra                              // Archivo de Transaciones
       cNroMes                              // N£mero del Mes
       lInsReg                              // .T. Insertar registros */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aStrTra := {}                  // Estructura de la Transacci¢n.
       LOCAL aRegTra := {}                  // Registro de la Transacci¢n

       LOCAL cNroCta := ''                  // N£mero de la Cuenta
       LOCAL cCodFac := ''                  //@C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION,03->RESTAURANTE,04->TRANSPORTE */
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL cCodTra := ''                  // C¢digo de la transaci¢n
       LOCAL cSigTra := ''                  // Signo de la transaci¢n
       LOCAL nVlrDec := 0                   // Valor Decimal
       LOCAL nValor  := 0                   // Valor de la Transaci¢n
       LOCAL dFecha  := CTOD('00/00/00')    // Fecha de Pago
       LOCAL lSumar := .F.                 // .T. Credito .F. Debito

       LOCAL cNroCtaTtr := ''               // N£mero de la Cuenta
       LOCAL cOficinTtr := ''               // Oficina de la Trnasacci¢n
       LOCAL cTerOfiTtr := ''               // Terminal de la Oficina
       LOCAL cTalonTtr  := ''               // Talon de la Transaci¢n
       LOCAL cJornadTtr := ''               // Jornada de pago
       LOCAL cMaiPagTtr := ''               // Mail del Pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTra,'DIA',NIL,lShared,nModCry)
	  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	  CloseDbf('DIA',fileTra,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>RECORRIDO DE LOS MOVIMIENTOS DIARIOS
       SELECT DIA
       DIA->(DBGOTOP())
       DO WHILE .NOT. DIA->(EOF())

**********LECTURA DEL REGISTRO
	    aStrTra := aStrTra(DIA->Registro)
	    aRegTra := aRegTra(DIA->Registro,aStrTra)
	    cNroCta := xPrm(aRegTra,'cNroCta')
	    cCodFac := xPrm(aRegTra,'cCodFac')
	    cCodRef := xPrm(aRegTra,'cCodRef')
	    cCodRef := cCodRef+cCodFac
	    cCodTra := xPrm(aRegTra,'cCodTra')
	    nValor := xPrm(aRegTra,'nVlrTra')
	    dFecha := xPrm(aRegTra,'dFecTra')

	    cOficinTtr := xPrm(aRegTra,'cOficin')
	    cTerOfiTtr := xPrm(aRegTra,'cTerOfi')
	    cTalonTtr  := xPrm(aRegTra,'cTalon')
	    cJornadTtr := xPrm(aRegTra,'cJornad')
	    cMaiPagTtr := xPrm(aRegTra,'cMaiPag')
**********FIN LECTURA DEL REGISTRO

**********LOCALIZACION DE LA TRANSACION
	    IF lLocCodigo('cCodigoTra','TMV',cCodTra)
	       lSumar := TMV->lSumarTra
	    ELSE
	       cError('EL CODIGO: '+cCodTra+;
		      ' NO EXISTE SE ASUME COMO UN DEBITO')
	       lSumar := .F.
	    ENDIF
**********FIN LOCALIZACION DE LA TRANSACION

**********GRABACION DEL REGISTRO
	    SELECT TRA
	    IF TRA->(lRegLock(lShared,.T.))
	       REPL TRA->cCodRefTra WITH cCodRef
	       REPL TRA->cCodigoEst WITH SUBS(cCodRef,1,6)
	       REPL TRA->cCodFacCar WITH cCodFac
	       REPL TRA->cCodigoTra WITH cCodTra
	       REPL TRA->nCodigoCmv WITH nCodigoCmv(VAL(cNroMes),;
						    cCodRef,BAN->nLenRefBan,;
						    cCodFac,CAR->cCodFacCar)
	       REPL TRA->nValorTra  WITH nValor
	       REPL TRA->dFechaTra  WITH dFecha
	       REPL TRA->lSumarTra  WITH lSumar
	       REPL TRA->lInsUsrTra WITH .F.
	       REPL TRA->cNroCtaTra WITH cNroCtaTtr

	       REPL TRA->cTerOfiTra WITH cTerOfiTtr
	       REPL TRA->cTalonTra  WITH cTalonTtr
	       REPL TRA->cJornadTra WITH cJornadTtr

	       TRA->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       TRA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  DIA->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS MOVIMIENTOS DIARIOS

