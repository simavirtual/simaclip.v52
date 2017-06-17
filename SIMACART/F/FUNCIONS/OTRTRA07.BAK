/*************************************************************************
* TITULO ..: LECTURA DEL ARCHIVO DE PAGOS MENSUAL.                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/99 MAR A
       Colombia, Bucaramanga        INICIO: 03:20 PM   JUN 15/99 MAR

OBJETIVOS:

1- Lee el archivo ascii generado por el Banco o Coorporaci¢n
   correspondiente al mes de pago.

2- Retorna .F.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra077(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del D¡a */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL lSysErr := .T.                 // .T. Error del Sistema
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cNomArc := ''                  // Nombre del archivo
       LOCAL PathAct := ''                  // Paht Actual
       LOCAL nVlrDec := 0                   // Valor Decimal
       LOCAL FileTxt := ''                  // Archivo Texto
       LOCAL aLinTxt := {}                  // Lineas de Texto
       LOCAL cLinTxt := ''                 // L¡nea de Texto

       LOCAL       i := 0                   // Contador
       LOCAL aStrTra := {}                  // Estructura de la Transacci¢n.
       LOCAL aRegTra := {}                  // Registro de la Transacci¢n
       LOCAL nMesIni := 0                   // Mes del pago
       LOCAL cNroCta := ''                  // N£mero de la Cuenta
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL cCodFac := ''                  //@C¢digo Servicio Facturado. Ej: 01->MATRICULA 02->PENSION,03->RESTAURANTE,04->TRANSPORTE */
       LOCAL cCodTra := ''                  // C¢digo de la transaci¢n
       LOCAL nValor  := 0                   // Valor de la Transaci¢n
       LOCAL dFecha  := CTOD('00/00/00')    // Fecha de Pago
       LOCAL lSumar := .F.                  // .T. Credito .F. Debito
       LOCAL cSigTra := ''                  // Signo de la transaci¢n
       LOCAL nSumar  := 0                   // 0 = Indefinido 1 => Credito 2=> Debito
       LOCAL cCodMtv := ''                  // C¢digo del motivo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTtr := ''               // C¢digo de la Transaci¢n
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL nValorTtr  := 0                // Valor de la Transaci¢n
       LOCAL dFechaTtr  := CTOD('00/00/00') // Fecha de la Transaci¢n
       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
       LOCAL cNroCtaTtr := ''               // N£mero de la Cuenta
       LOCAL cValCtaTba := ''               // N£mero de la Cuenta a validar
       LOCAL cOficinTtr := ''               // Oficina de la Trnasacci¢n
       LOCAL cTerOfiTtr := ''               // Terminal de la Oficina
       LOCAL cTalonTtr  := ''               // Talon de la Transaci¢n
       LOCAL cJornadTtr := ''               // Jornada de pago
       LOCAL cMaiPagTtr := ''               // Mail del Pago
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
	  RETURN lSysErr
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF !EMPTY(cNroDia)
	  FileTra := cAnoUsr+cNroMes+cNroDia+ExtFile
	  FileTxt := cAnoUsr+cNroMes+cNroDia+'.txt'
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ELSE
	  cNroDia := ''
	  FileTra := 'PA'+cAnoUsr+cNroMes+ExtFile
	  FileTxt := 'PA'+cAnoUsr+cNroMes+'.txt'
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>ACTIVACION DEL CURSOR
       IF !EMPTY(oBrowse)
	  SETCURSOR(1)
       ENDIF
*>>>>FIN ACTIVACION DEL CURSOR

*>>>>LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS
       cNomArc := SPACE(99)
*cNomArc := 'C:\MISDOC\DATOS\PENSION\PSE\20160902.TXT'
       cSavLin := SAVESCREEN(nFilInf+1,00,nFilInf+2,79)
       @ nFilInf+1,nColInf SAY "POR FAVOR ENTRE EL NOMBRE DEL ARCHIVO "+;
			       "DE PAGOS DE "+;
			       cMes(VAL(cNroMes),10)+;
			       IF(EMPTY(cNroDia),'',' '+cNroDia)+':'

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
       RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
*>>>>FIN LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS

wait cNroDia

*>>>>VALIDACION DE LA FECHA DEL ARCHIVO
       IF !EMPTY(cNroDia)

	  lHayErr := .F.
	  aLinTxt := aFileTxt(cNomArc)

	  cLinTxt := aLinTxt[1]
	  aStrTra := aStrTra(cLinTxt)
	  aRegTra := aRegTra(cLinTxt,aStrTra)
	  dFechaTtr := xPrm(aRegTra,'dFecTra')


	  FOR i := 1 TO LEN(aLinTxt)

	      cLinTxt := aLinTxt[i]
	      aStrTra := aStrTra(cLinTxt)
	      aRegTra := aRegTra(cLinTxt,aStrTra)

	      IF dFechaTtr # xPrm(aRegTra,'dFecTra')
		 lHayErr := .T.
	      ENDIF

	  ENDFOR

	  IF lHayErr
	     cError('EL ARCHIVO TIENE REGISTROS DE VARIAS FECHAS')
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE LA FECHA DEL ARCHIVO

*>>>>VALIDACION DEL DIA DEL ARCHIVO
       IF !EMPTY(cNroDia)

	  IF !lHayErr
	     IF dFechaTtr # CTOD(cNroMes+'/'+cNroDia+'/'+cAnoUsr)
		cError('EL ARCHIVO DEBE SER DEL MISMO DIA')
		CloseAll()
		RETURN lSysErr
	     ENDIF
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DEL DIA DEL ARCHIVO

*>>>>VALIDACION DEL NUMERO DE CUENTA
       IF !lValArcTra(@cNroCtaTtr,cLinTxt)
	  cError(cNroCtaTtr+' NUMERO DE CUENTA ERRONEA')
	  RETURN lSysErr
       ENDIF
*>>>>FIN VALIDACION DEL NUMERO DE CUENTA

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


*>>>>CREACION DEL ARCHIVO DE TRANSACIONES
       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		FileTra,nModCry)
       cNomArc := ALLTRIM(cNomArc)


       FILECOPY(cNomArc,;
		cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTxt)

       CreaDbfTra(lShared,nModCry,;
		  cPatSis+'\MODEM\'+BAN->cCodigoBan,FileTra)
      *Creaci¢n de archivo de trasaciones
*>>>>FIN CREACION DEL ARCHIVO DE TRANSACIONES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		   FileTra,'TRA',NIL,lShared,nModCry)

	  cError('ERROR ABRIENDO ARCHIVOS')
	  CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		   FileTra,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CONVERSION DEL ARCHIVO ASCII
       Termometro(0,'LEYENDO EL ARCHIVO')
       Termometro(20)
       SELECT TRA
       APPEND FROM &cNomArc SDF
       Termometro(50)
*>>>>FIN CONVERSION DEL ARCHIVO ASCII

*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

**********LECTURA DE LOS RESPECTIVO CAMPOS
	    aStrTra := aStrTra(TRA->Registro)
	    aRegTra := aRegTra(TRA->Registro,aStrTra)

	    cNroCta := xPrm(aRegTra,'cNroCta')
	    cCodFac := xPrm(aRegTra,'cCodFac')
	    cCodRef := xPrm(aRegTra,'cCodRef')
	    cCodigoTes := SUBS(cCodRef,1,06)
	    nMesIniTtr := VAL(SUBS(cCodRef,7,2))
	    nMesFinTtr := VAL(SUBS(cCodRef,9,2))

	    nValorTtr  := xPrm(aRegTra,'nVlrTra')
	    dFechaTtr  := xPrm(aRegTra,'dFecTra')
	    cCodigoTtr := xPrm(aRegTra,'cCodTra')
	    cOficinTtr := xPrm(aRegTra,'cOficin')
	    cTerOfiTtr := xPrm(aRegTra,'cTerOfi')
	    cTalonTtr  := xPrm(aRegTra,'cTalon')
	    cJornadTtr := xPrm(aRegTra,'cJornad')
	    cMaiPagTtr := xPrm(aRegTra,'cMaiPag')
**********FIN LECTURA DE LOS RESPECTIVO CAMPOS

**********MOTIVO DE LA TRANSACION
	    cCodMtv := ''
	    IF !EMPTY(BAN->nPosJorBan)
	       cCodMtv := ALLTRIM(SUBS(TRA->Registro,;
				  BAN->nMotivoBan,BAN->nLenMtvBan))
	    ENDIF
**********FIN MOTIVO DE LA TRANSACION

**********LOCALIZACION DEL CODIGO DE LA TRANSACION
	    nSumar  := 0
	    IF lLocCodigo('ALLTRIM(cCodigoTra)','TMV',;
			   ALLTRIM(cCodigoTtr))

	       IF TMV->lSumarTra
		  nSumar := 1   // Credito
	       ELSE
		  nSumar := 2   // Debito
	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL CODIGO DE LA TRANSACION

**********GRABACION DE LOS CAMPOS
	    IF TRA->(lRegLock(lShared,.F.))
	       REPL TRA->cCodRefTra WITH cCodRef+cCodFac
	       REPL TRA->cCodigoEst WITH cCodigoTes
	       REPL TRA->cCodFacCar WITH cCodFac
	       REPL TRA->nMesIniTra WITH nMesIniTtr
	       REPL TRA->nMesFinTra WITH nMesFinTtr
	       REPL TRA->cCodigoTra WITH cCodigoTtr
	       REPL TRA->nValorTra  WITH nValorTtr
	       REPL TRA->nSumarTra  WITH nSumar
	       REPL TRA->dFechaTra  WITH dFechaTtr
	       REPL TRA->nCodigoCmv WITH nCodigoCmv(MONTH(dFechaTtr),;
						    cCodRef,;
						    BAN->nLenRefBan,;
						    ,,cCodMtv)

	       REPL TRA->cNroCtaTra WITH cNroCtaTtr
	       REPL TRA->cOficinTra WITH cOficinTtr
	       REPL TRA->cTerOfiTra WITH cTerOfiTtr
	       REPL TRA->cTalonTra  WITH cTalonTtr
	       REPL TRA->cJornadTra WITH cJornadTtr
	       REPL TRA->cMaiPagTra WITH cMaiPagTtr
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
       INDEX ON TRA->cCodigoEst;
	     TO &(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxTra)
*>>>>FIN CREACION DE INDICES

*>>>>CIERRE DE ARCHIVOS
       IF EMPTY(oBrowse)
	  OrdenaTra(lShared,nModCry,;
		    cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTra)
       ELSE
	  OrdenaTra(lShared,nModCry,;
		    cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTra,;
		    oBrowse)
       ENDIF
       RETURN !lSysErr
*>>>>FIN CIERRE DE ARCHIVOS

/*************************************************************************
* TITULO..: VALIDACION ARCHIVO DE TRANSACCIONES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/2016 VIE A
       Bucaramanga, Colombia        INICIO: 02:30 PM   JUN 24/2016 VIE

OBJETIVOS:

1- Permite validar el archivo de las transacciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValArcTra(cNroCta,cLinTxt)

*>>>>DECLARACION DE PARAMETROS
/*     cNroCta                        // @N£mero de la cuenta
       cLinTxt                        // Linea de Texto */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay error
       LOCAL aStrTra := {}                  // Estructura de la Transacci¢n.
       LOCAL aRegTra := {}                  // Registro de la Transacci¢n
       LOCAL cCtaBan := ''                  // Cuenta del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA CUENTA
       cNroCta := ''
       IF !EMPTY(BAN->cValCtaBan)

	  aStrTra := aStrTra(cLinTxt)
	  aRegTra := aRegTra(cLinTxt,aStrTra)

	  cNroCta := xPrm(aRegTra,'cNroCta')
	  cCtaBan := ALLTRIM(BAN->cValCtaBan)

	  IF cNroCta # cCtaBan
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LA CUENTA