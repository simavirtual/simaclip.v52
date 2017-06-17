/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO TRANSACIONES

REQUERIMIENTOS:

- Compilar: clipper FuncsTra /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Transaciones

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 06/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:15 AM   JUN 06/95 MAR

OBJETIVOS:

1)- Crea la estructura del archivo Transaciones

2)- Retorna NIL

SINTAXIS:

   CreaDbfTra(PathTra,FileTra,fNtxTra)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfTra(lShared,nModCry,PathTra,FileTra,fNtxTra,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathTra				    // Path del Archivo
       FileTra				    // Nombre del Archivo
       fNtxTra				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfTra := {{"Registro"  ,"Character",1300,0},;
			 {"cCodigoTra","Character",03,0},;
			 {"cCodRefTra","Character",12,0},;   // C¢digo de la Referencia
			 {"cCodFacCar","Character",02,0},;   // C¢digo Servicio Facturado. Ej: 01->PENSION,02->RESTAURANTE,03->TRANSPORTE
			 {"cCodigoEst","Character",06,0},;
			 {"nMesIniTra","Numeric"  ,02,0},;
			 {"nMesFinTra","Numeric"  ,02,0},;
			 {"nSumarTra" ,"Numeric"  ,01,0},;  // 0 = Indefinido 1 => Credito 2=> Debito
			 {"nValorTra" ,"Numeric"  ,14,2},;
			 {"dFechaTra" ,"Date"     ,08,0},;
			 {"nCodigoCmv","Numeric"  ,04,0},;  // C¢digo del Concepto del Movimiento
			 {"nValidaTra","Numeric"  ,02,0},;
			 {"cObservTra","Character",40,0},;
			 {"cObservTra","Character",40,0},;
			 {"cNroCtaTra","Character",20,0},;  // N£mero de la Cuenta
			 {"cOficinTra","Character",10,0},;  // Oficina de la Trnasacci¢n
			 {"cTerOfiTra","Character",10,0},;  // Terminal de la Oficina
			 {"cTalonTra" ,"Character",10,0},;  // Talon de la Transaci¢n
			 {"cJornadTra","Character",10,0},;  // Jornada de pago
			 {"cMaiPagTra","Character",70,0},;  // MAIL pago de la transacci¢n.
			 {"lRegOkTra" ,"Logical"  ,01,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfTra
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathTra) == 0
	    DBCREATE(FileTra,aDbfTra,"DBFNTX")
	    Proteger(FileTra,nModCry)

       CASE DIRCHANGE(PathTra) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathTra)

       CASE DIRCHANGE(PathTra) == -5
	    cError('NO TIENE DERECHOS EN: '+PathTra)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 10/99 JUE A
       Colombia, Bucaramanga        INICIO: 01:50 PM   MAR 10/99 JUE

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrTra(lShared,nModCry,PathTra,FileTra)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       FileTra				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal

       LOCAL cCodRef := ''                  // C¢digo de la referencia
       LOCAL nSumar  := 0                   // 0 = Indefinido 1 => Credito 2=> Debito
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathTra+'\'+FileTra,'TRA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE TRANSACIONES')
	  CloseDbf('TRA',PathTra+'\'+FileTra,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := TRA->(DBSTRUCT())
       CloseDbf('TRA',PathTra+'\'+FileTra,nModCry)
       CreaDbfTra(lShared,nModCry,PathTra,FileTra,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio
	  cError('El Archivo MODEM su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(FileTra,1,AT('.',FileTra))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathTra+'\'+FileTra,;
			 PathTra+'\'+FileTem,;
			 {||CreaDbfTra(lShared,nModCry,PathTra,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

*>>>>ANALISIS DE DECISION
       IF .NOT. lCambio
	  RETURN nNroErr
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathTra+'\'+FileTra,'TRA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE TRANSACIONES')
	  CloseDbf('TRA',PathTra+'\'+FileTra,nModCry)
	  RETURN nNroErr := 1
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>ACTUALIZACION DE LOS REGISTROS
       SELECT TRA
       TRA->(DBGOTOP())
       DO WHILE .NOT. TRA->(EOF())

**********LINEA DE ESTADO
	   LineaEstado('ACTULIZANDO LOS REGISTROS'+;
		       'ºNo. '+STR(TRA->(RECNO()),2)+'/'+;
			       STR(TRA->(RECCOUNT()),2),'')
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO DE LA TRANSACION
	    nSumar  := 0
	    IF lLocCodigo('ALLTRIM(cCodigoTra)','TMV',;
			   ALLTRIM(TRA->cCodigoTra))
	       IF TMV->lSumarTra
		  nSumar := 1   // Credito
	       ELSE
		  nSumar := 2   // Debito
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO DE LA TRANSACION

**********ACTUALIZACION DE LA REFERENCIA
	    cCodRef := cCodRef(TRA->Registro)

	    IF TRA->(lRegLock(lShared,.F.))

	       IF EMPTY(TRA->cCodRefTra)
		  REPL TRA->cCodRefTra WITH cCodRef
	       ENDIF

	       IF TRA->nCodigoCmv == 0
		  REPL TRA->nCodigoCmv WITH nCodigoCmv(MONTH(TRA->dFechaTra),;
						       cCodRef,;
						       BAN->nLenRefBan)
	       ENDIF

	       IF TRA->nSumarTra == 0 .AND. nSumar # 0
		  REPL TRA->nSumarTra WITH nSumar
	       ENDIF

	       TRA->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       TRA->(DBUNLOCK())
	    ENDIF

	    TRA->(DBSKIP())
**********FIN ACTUALIZACION DE LA REFERENCIA

       ENDDO
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LOS REGISTROS

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE TRANSACIONES		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 06/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUN 06/95 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo Transaciones

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTra(aParam1,aParam2,aParam3,;
		   cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del Dia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del Maestro

       LOCAL cAnoMtr := ''                  // A¤o de la Matr¡cula
       LOCAL cAnoAlu := ''                  // A¤o del Meaestro de Estudiantes.
       LOCAL nNroMes := 0                   // N£mero del Mes
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL oBrwTra := NIL                 // Browse de Transaciones
       LOCAL dFecUsr := CTOD('00/00/00')    // Fecha de Usuario
       LOCAL cEmpCob := ''                  // Empresa de Cobro
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // Codigo del grupo

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
       SET DECIMAL TO

       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       IF EMPTY(cNroDia)
	  nNroMes := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
				'Por Favor Seleccione el Mes',.T.,{'TOT'})
       ELSE
	  nNroMes := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
				'Por Favor Seleccione el Mes',.T.)
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroMes == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cNroMes := STR(nNroMes,2)
       lCorrecion(@cNroMes)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\FILEWWW\FACT'+cMes(nNroMes,3)) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\FILEWWW\FACT'+cMes(nNroMes,3)) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\FILEWWW\FACT'+cMes(nNroMes,3)) == -3
	    DIRMAKE(cPatSis+'\FILEWWW\FACT'+cMes(nNroMes,3))
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION

*>>>>LECTURA DEL DIA
       IF cNroDia # NIL .AND. nNroMes # 13

**********INICIALIZACION DEL DIA
	    cNroDia := DAY(DATE())
	    IF cNroDia # 1
	       cNroDia -= 1
	    ENDIF
	    cNroDia := STR(cNroDia,2)
**********FIN INICIALIZACION DEL DIA

	  @ nFilInf+1,nColInf SAY 'DIA' GET cNroDia PICT '99';
					VALID VAL(cNroDia) >= 0 .AND.;
					      VAL(cNroDia) <= 32
	  READ
	  IF EMPTY(cNroDia)
	     CloseAll()
	     RETURN NIL
	  ENDIF
	  lCorrecion(@cNroDia)
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF EMPTY(cNroDia)
	  cNroDia := ''
	  FileTra := 'PA'+cAnoUsr+cNroMes+ExtFile
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ELSE
	  FileTra := cAnoUsr+cNroMes+cNroDia+ExtFile
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
	  dFecUsr := CTOD(cNroMes+'/'+cNroDia+'/'+cAnoUsr)
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ERROR ABRIENDO ARCHIVOS')
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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)

       IF EMPTY(CAA->cAnoAluCaA)
	  cAnoAlu := cAnoUsr
          cIntUno := PathUno+'\'+cPatSis
       ELSE
	  cAnoAlu := CAA->cAnoAluCaA
	  cIntUno := PathUno+'\'+cAnoAlu+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF

       IF EMPTY(CAA->cAnoMtrCaA)
	  cAnoMtr := cAnoUsr
	  cIntDos := PathDos+'\'+cPatSis
       ELSE
	  cAnoMtr := CAA->cAnoMtrCaA
	  cIntDos := PathDos+'\'+cAnoMtr+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lSiRed,0})

       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 fPazEst+SUBS(cAnoAlu,3,2)+ExtFile,'PAZ',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ERROR ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE EMPTY(CAA->cCodigoBan)
	    cError('NO SE HA DEFINIDO EL BANCO EN LA CONFIGURACION DEL A¥O')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE EMPTY(BAN->nCodEstBan) .OR. EMPTY(BAN->nPagIntBan) .OR.;
	    EMPTY(BAN->nMesPagBan) .OR. EMPTY(BAN->nDiaPagBan) .OR.;
	    EMPTY(BAN->nAnoPagBan) .OR. EMPTY(BAN->nTipMovBan)
	    cError('FALTA COMPLETAR LAS POSICIONES DEL ARCHIVO PLANO')

       CASE EMPTY(BAN->nLenRefBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DE LA REFERENCIA')

       CASE EMPTY(BAN->nLenAnoBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DEL A¥O')

       CASE EMPTY(BAN->nLenIntBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DEL VALOR PAGADO')

*       CASE BAN->nLenIntBan > 10
*            cError('LA LONGITUD DEL VALOR PAGADO NO PUEDE EXCEDER DE 10 CARACTERES')

       CASE !EMPTY(BAN->nPagDecBan) .AND. EMPTY(BAN->nLenDecBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DEL VALOR DECIMAL')

       CASE EMPTY(BAN->nLenTipBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DE TIPO DE MOVIMIENTO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DEL BANCO
       IF BAN->(RECCOUNT()) > 1
	  nSelBanco(nFilInf+1,nColInf-1)
       ELSE
	  SELECT BAN
	  GO TOP
       ENDIF
*>>>>FIN LOCALIZACION DEL BANCO

*>>>>AREAS DE TRABAJO
       FileTmv := FileTmv+BAN->cCodigoBan+ExtFile
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTmv,'TMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lNoRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ERROR ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN TIPOS DE MOVIMIENTOS DE '+;
		   ALLTRIM(BAN->cNombreBan)+' GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF FILE(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTra)

	  IF nActStrTra(lShared,nModCry,;
			cPatSis+'\MODEM\'+BAN->cCodigoBan,FileTra) == 1
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>LECTURA DEL ARCHIVO DEL EXTRACTO
       IF !FILE(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTra) .AND.;
	  (nNroMes < 13 .AND. VAL(cNroDia) < 32)

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA LEER LOS PAGOS DE '+;
			  cMes(nNroMes,10)+;
			  IF(EMPTY(cNroDia),'',' '+cNroDia)+'? Si No')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DEL ARCHIVO
	    IF OtrTra077(aParam1,aParam2,aParam3,;
			 cNroMes,NIL,cModem,cNroDia)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA DEL ARCHIVO

       ENDIF
*>>>>FIN LECTURA DEL ARCHIVO DEL EXTRACTO

*>>>>MOVIMIENTOS ACUMULADOS
       IF nNroMes == 13 .OR. VAL(cNroDia) == 32
	  LeeTraAcu(lShared,nModCry,cNomSis,cAnoUsr,;
		    cPatSis,cNroMes,cNroDia,FileTra)
       ENDIF
*>>>>FIN MOVIMIENTOS ACUMULADOS

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,cIntDos+'\'+;
			 FileAdm+cAnoMtr+ExtFile,'ADM',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			 FileTra,'TRA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,SUBS(cAnoAlu,3,2),lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS MAESTROS Y TRANSACIONES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

/*
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
*/

       CASE TMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS NOMBRES DE LOS CONCEPTOS DEL MOVIMIENTO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT TRA
       oBrwTra := oDefBrwTra(nFilPal+1,00,22,79,cMaeAlu,;
			     cAnoUsr,CAA->cAnoAluCaA,;
			     VAL(cNroMes),cNroDia,;
			     BAN->cNombreBan,BAN->cNroCtaBan)

       SETKEY(K_F5,{||BuscarTra(oBrwTra,cMaeAlu)})
       SETKEY(K_F9,{||MenuOtrTra(aParam1,aParam2,aParam3,;
				 cNroMes,oBrwTra,cModem,cNroDia,;
				 cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
				 FileTra)})

       TRA->(CtrlBrw(lShared,oBrwTra))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       cEmpCob := CAR->cEmpCobCar
       SET DECIMAL TO 2
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE TRANSACIONES		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 06/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 AM   JUN 06/95 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo Transaciones

SINTAXIS:

 oBrwTra := oDefBrwTra(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwTra(nFilSup,nColSup,nFilInf,nColInf,cMaeAlu,;
		    cAnoUsr,cAnoAlu,nNroMes,cNroDia,cNomBan,;
		    cNroCta,cTitSup,cTitInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros habilitados
       cAnoUsr                              // A¤o del Usuario
       nNroMes                              // N£mero del Mes
       cNroDia                              // N£mero del Dia
       cNomBan                              // Nombre del Banco
       cNroCta                              // N£mero de la Cuenta
       cTitSup                              // T¡tulo Superior
       cTitInf                              // T¡tulo Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwTra := NIL		    // Browse de Transaciones
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       LineaEstado(ALLTRIM(cNomBan)+' CUENTA No. '+ALLTRIM(cNroCta),'')

       oBrwTra := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas


       oBrwTra:ColSep    := '³'
       oBrwTra:HeadSep   := 'Ä'

       cTitSup := IF(EMPTY(cTitSup),;
		  '<<RECIBOS PAGADOS EN '+cMes(nNroMes,10)+' '+;
		  IF(EMPTY(cNroDia),'',cNroDia)+' DEL '+cAnoUsr+;
		  '. A¥O DE PROCESO: '+IF(EMPTY(cAnoAlu),cAnoUsr,cAnoAlu)+;
		  ' >>',cTitSup)

       cTitInf := IF(EMPTY(cTitInf),;
		  '<F5>Buscar <F9>Otros <ESC>Abandonar',cTitInf)

       oBrwTra:Cargo     := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TRA
       oColumn	     := TBCOLUMNNEW('REFERENCIA', {||TRA->cCodRefTra})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TRA'},{'FIELD','cCodRefTra'},;
			 {'PICTURE','@!'}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||TRA->cCodigoEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TRA'},{'FIELD','cCodigoEst'},;
			 {'PICTURE','999999'}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
			       {||cNomEstTra(TRA->cCodigoEst,cMaeAlu,20,'TRA')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna



       oColumn	     := TBCOLUMNNEW('TRAN', {||TRA->cCodigoTra})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CREDITOS',;
				    {||TRANS(nValorTra(1,'TRA'),"#######,###.99")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEBITOS',;
				    {||TRANS(nValorTra(2,'TRA'),"#######,###.99")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;TRANSICION',;
				    {||cFecha(TRA->dFechaTra)})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 12
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PROCESADO',;
				   {||IF(TRA->nValidaTra==0,'NO',;
					 TRA->nValidaTra)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION',{||TRA->cObservTra})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;CONCEPTO', {||TRA->nCodigoCmv})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TRA'},{'FIELD','nCodigoCmv'},;
			 {'PICTURE','9999'}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTO',;
			{||cConcepCmv(TRA->nCodigoCmv,'TRA')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 40
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;SERVICIO FACTURADO', {||TRA->cCodFacCar})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TRA'},;
			 {'FIELD','cCodFacCar'},{'PICTURE','@!'}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF BAN->nMotivoBan # 0
	  oColumn := TBCOLUMNNEW('MOTIVO',{||cMotivoTra(46,'TRA')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrwTra:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('CORREGIDO', {||TRA->lRegOkTra})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','TRA'},;
			 {'FIELD','lRegOkTra'}, {'PICTURE','@!'}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('REFERENCIA1',;
		  {||SUBS(TRA->Registro,BAN->nCodEstBan,BAN->nLenRefBan)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('REFERENCIA2',;
		  {||SUBS(TRA->Registro,BAN->nCodRf2Ban,BAN->nLenRefBan)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF EMPTY(TRA->cOficinTra)
	  oColumn := TBCOLUMNNEW('OFICINA.',;
		    {||SUBS(TRA->Registro,BAN->nPosOfiBan,BAN->nLenOfiBan)})

       ELSE
	  oColumn := TBCOLUMNNEW('OFICINA',{||TRA->cOficinTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF EMPTY(TRA->cTerOfiTra)
	  oColumn := TBCOLUMNNEW('TERMINAL.',;
		    {||SUBS(TRA->Registro,BAN->nPosTerBan,BAN->nLenTerBan)})
       ELSE
	  oColumn := TBCOLUMNNEW('TERMINAL',{||TRA->cTerOfiTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF EMPTY(TRA->cTalonTra)
	  oColumn := TBCOLUMNNEW('TALON.',;
		    {||SUBS(TRA->Registro,BAN->nPosTalBan,BAN->nLenTalBan)})
       ELSE
	  oColumn := TBCOLUMNNEW('TALON',{||TRA->cTalonTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF EMPTY(TRA->cJornadTra)
	  oColumn := TBCOLUMNNEW('JORNADA.',;
		    {||SUBS(TRA->Registro,BAN->nPosJorBan,BAN->nLenJorBan)})
       ELSE
	  oColumn := TBCOLUMNNEW('JORNADA',{||TRA->cJornadTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NRO CUENTA', {||TRA->cNroCtaTra})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MAIL DEL PAGO', {||TRA->cMaiPagTra})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TRANSACION     1         2        3          4          5         6;123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 ',;
				   {||TRA->Registro})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('Registro No.', {||TRA->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwTra:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwTra
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CLIENTE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso los archivos de Transaciones

2- Busca el c¢digo del Cliente

3- Retorna NIL

SINTAXIS:

  BuscarTra(oBrwTra,cMaeAlu)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarTra(oBrwTra,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwTra				    // Browse de Transaciones
       cMaeAlu                              // Maestros Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegTra := 0                   // Registro del Trao
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL cNalias := ''                  // Alias del archivo
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL nMesIniTpa := 0                // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTes := cSpaces('TRA','cCodigoEst')
       TitBuscar(LEN(cCodigoTes)+3,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lCorrecion(@cCodigoTes)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE VAL(cCodigoTes) == 0

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
       IF lSekCodMae(cCodigoTes,cMaeAlu,@cNalias)
	  cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			RTRIM(&cNalias->cNombreEst)+SPACE(30)
	  cNombreTes := SUBS(cNombreTes,1,25)
	  cMsgTxt := cNombreTes+'. GRUPO: '+&cNalias->cCodigoGru+;
		     ' NO LE FIGURA PAGO.'
       ELSE
	  cMsgTxt := ' NO LE FIGURA PAGO.'
       ENDIF
*>>>>FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

*>>>>BUSQUEDA DEL CODIGO
       SELECT TRA
       IF lBuscar .AND. lLocCodigo('cCodigoEst','TRA',cCodigoTes)
	  nRegTra := RECNO()
	  GO TOP
	  oBrwTra:GOTOP()
	  GO nRegTra
	  oBrwTra:FORCESTABLE()
       ELSE
	  oBrwTra:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MENU DE OTROS PARA EL ARCHIVO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/99 MAR A
       Colombia, Bucaramanga        INICIO: 05:15 PM   MAY 18/99 MAR

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrTra(aParam1,aParam2,aParam3,;
		    cNroMes,oBrowse,cModem,cNroDia,FileTra)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del D¡a
       FileTra                              // Archivo de Transaciones */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL lDebito := .T.                 // .T. Debito .F. Credito

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       IF EMPTY(cNroDia)

**********MENU PARA EL PROCESO MENSUAL
	    AADD(aMenus,'1<PROCESAR PAGOS          >')
	    AADD(aMenus,'2<PROCESAR NO PAGOS       >')
	    AADD(aMenus,'3<REGISTROS NO PROCESADOS >')
	    AADD(aMenus,'4<IMPRIMIR POR CODIGO     >')
	    AADD(aMenus,'5<IMPRIMIR POR TRANSACCION>')
	    AADD(aMenus,'6<IMPRIMIR POR GRUPO      >')
	    AADD(aMenus,'7<LEER LOS PAGOS          >')
	    AADD(aMenus,'8<ORDENAR POR CONCEPTOS   >')

	    IF !EMPTY(BAN->nPosOfiBan) .AND.;
	       !EMPTY(BAN->nLenOfiBan)
	       AADD(aMenus,'9<REGISTROS POR CLASIFICAR>')
	    ENDIF

	    AADD(aAyuda,'Procesa los recibos que figuran pagados')
	    AADD(aAyuda,'Actualiza los saldos de los que no pagaron')
	    AADD(aAyuda,'Imprime los registros que no se procesaron')
	    AADD(aAyuda,'Imprime la relaci¢n de las consignaciones por c¢digo')
	    AADD(aAyuda,'Imprime los movimientos por transacci¢n')
	    AADD(aAyuda,'Imprime la relaci¢n de las consignaciones por grupo')
	    AADD(aAyuda,'Lee nuevamente el archivo del Modem')
	    AADD(aAyuda,'Ordena los movimientos por conceptos')

	    IF !EMPTY(BAN->nPosOfiBan) .AND.;
	       !EMPTY(BAN->nLenOfiBan)
	       AADD(aAyuda,'Imprime los registros por clasficiar')
	    ENDIF
**********FIN MENU PARA EL PROCESO MENSUAL

       ELSE

**********MENU PARA EL PROCESO DIARIO
	    AADD(aMenus,'1<PROCESAR PAGOS          >')
	    AADD(aMenus,'2<IMPRIMIR POR CODIGO     >')
	    AADD(aMenus,'3<REGISTROS NO PROCESADOS >')
	    AADD(aMenus,'4<IMPRIMIR POR TRANSACCION>')
	    AADD(aMenus,'5<LEER LOS PAGOS          >')
	    AADD(aMenus,'6<ORDENAR POR CONCEPTOS   >')
	    IF !EMPTY(BAN->nPosOfiBan) .AND.;
	       !EMPTY(BAN->nLenOfiBan)
	       AADD(aMenus,'7<REGISTROS POR CLASIFICAR>')
	    ENDIF

	    AADD(aAyuda,'Procesa los recibos que figuran pagados')
	    AADD(aAyuda,'Imprime la relaci¢n de las consignaciones por c¢digo')
	    AADD(aAyuda,'Imprime los registros que no se procesaron')
	    AADD(aAyuda,'Imprime los movimientos por transacci¢n')
	    AADD(aAyuda,'Imprime los registros que no se procesaron')
	    AADD(aAyuda,'Lee nuevamente el archivo del Modem')
	    AADD(aAyuda,'Ordena los movimientos por conceptos')

	    IF !EMPTY(BAN->nPosOfiBan) .AND.;
	       !EMPTY(BAN->nLenOfiBan)
	       AADD(aAyuda,'Imprime los registros por clasficiar')
	    ENDIF
**********FIN MENU PARA EL PROCESO DIARIO

       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE (nNroOpc == 1 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 1 .AND. !EMPTY(cNroDia))
	    OtrTra011(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Cancelaci¢n de los Recibos pagados

       CASE nNroOpc == 2 .AND. EMPTY(cNroDia)
	    OtrTra022(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Procesar NO pagos

       CASE (nNroOpc == 3 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 3 .AND. !EMPTY(cNroDia))

	    OtrTra033(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Impresion de los registros no procesados

       CASE (nNroOpc == 4 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 2 .AND. !EMPTY(cNroDia))

	    OtrTra044(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Relaci¢n por C¢digo

       CASE (nNroOpc == 5 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 4 .AND. !EMPTY(cNroDia))
	    OtrTra055(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Relaci¢n por tipo de transacci¢n

       CASE nNroOpc == 6 .AND. EMPTY(cNroDia)
	    OtrTra066(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Relaci¢n por grupos

       CASE (nNroOpc == 7 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 5 .AND. !EMPTY(cNroDia))
	    OtrTra077(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Lectura del Archivo.

       CASE (nNroOpc == 8 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 6 .AND. !EMPTY(cNroDia))

	    OrdenaTra(lShared,nModCry,FileTra,oBrowse)

       CASE (nNroOpc == 9 .AND. EMPTY(cNroDia)) .OR.;
	    (nNroOpc == 7 .AND. !EMPTY(cNroDia))

	    OtrTra099(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse,cModem,cNroDia)
	   *Relaci¢n por Oficina

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: GRABACION DEL MENSAJE DE OBSERVACION                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 11/99 VIE A
       Colombia, Bucaramanga        INICIO: 08:45 AM   JUN 11/99 VIE

OBJETIVOS:

1- Graba la Observaci¢n de validaci¢n de procesamiento de los pagos

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ObservTra(lShared,cObserv,lAgrega)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cObserv                              // Observaci¢n
       lAgrega                              // .T. Adiciona .F. Reemplaza */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>GRABACION DEL REGISTRO
       lAgrega := IF(lAgrega == NIL,.F.,lAgrega)
       IF TRA->(lRegLock(lShared,lAgrega))
	  REPL TRA->cObservTra WITH cObserv
       ELSE
	  cError('NO SE GRABA LA OBSERVACION')
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: ENCONTRAR EL NOMBRE DEL ESTUDIANTE NUEVO O ANTIGUO           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 30/2000 JUE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   NOV 30/2000 JUE

OBJETIVOS:

1- Deben estar en uso los maestros habilitados

2- Permite encontrar el nombre del estudiante dentro de los archivos
   de Bachillerato,Primari,Jardin, nuevos.

3- Si el nombre del estudiante se incluye en un browse de debe pasar
   el Alias del Archivo del Browse

4- Retorna el nombre del Estudiante

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomEstTra(cCodEst,cMaeAlu,nLenNom,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst                                // C¢digo del Estudiante
       cMaeAlu				      // Maestros habilitados
       nLenNom                                // Longitud del Nombre
       cNalias				      // Alias diferente al maestro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMaeAct := ''                    // Alias del maestro
       LOCAL cCodRef := ''                    // C¢digo de la Referencia

       LOCAL cNombreTes := ''                 // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL ESTUDIANTE
       cCodRef := ALLTRIM(SUBS(TRA->Registro,;
		  BAN->nCodEstBan,BAN->nLenRefBan))

       IF LEN(cCodRef) == BAN->nLenRefBan

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodMae(cCodEst,cMaeAlu,@cMaeAct,.F.)

*--------------LOCALIZACION DEL ESTUDIANTE NUEVO
		 IF lLocCodigo('cCodigoEst','ADM',cCodEst)
		    cNombreTes := 'NUEVO '+ADM->cCodigoGru+' '+;
				  RTRIM(ADM->cApelliEst)+' '+;
				  RTRIM(ADM->cNombreEst)
		    IF ADM->lRetiroAdm
		       cNombreTes := 'RETIRADO '+cNombreTes
		    ENDIF
		 ELSE
		    cNombreTes := SUBS(TRA->cObservTra,1,30)
		 ENDIF
*--------------FIN LOCALIZACION DEL ESTUDIANTE NUEVO

	    ELSE

*--------------NOMBRE DEL ESTUDIANTE ANTIGUO
		 cNombreTes := &cMaeAct->cCodigoGru+' '+;
			       RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)
		 IF &cMaeAct->lRetiroEst
		    cNombreTes := 'RETIRADO '+cNombreTes
		 ENDIF
*--------------FIN NOMBRE DEL ESTUDIANTE ANTIGUO

	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

       ENDIF
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       nLenNom := IF(nLenNom == NIL,20,nLenNom)
       RETURN SUBS(cNombreTes+SPACE(nLenNom),1,nLenNom)
*>>>>FIN VALIDACION DEL CODIGO DEL ESTUDIANTE

/*************************************************************************
* TITULO..: REFERENCIA DE LA TRANSACION                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 12/2007 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   FEB 12/2007 JUE

OBJETIVOS:

1- Permite encontrar la Referencia de la transacci¢n

2- Retorna la Referencia

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodRef(cRegTra,cCodFac)

*>>>>DESCRIPCION DE PARAMETROS
/*     cRegTra                              // Registro de la Transaci¢n
       cCodFac                              //@C¢digo Servicio Facturado. Ej: 01->MATRICULA,02->PENSION 03->RESTAURANTE,04->TRANSPORTE */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodRf1 := ''                  // Referencia No. 1
       LOCAL cCodRf2 := ''                  // Referencia No. 1
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REFERENCIA1
       cCodFac := SPACE(02)
       IF BAN->nCodEstBan # 0
	  cCodRf1 := SUBS(cRegTra,BAN->nCodEstBan,BAN->nLenRefBan)
       ENDIF

       DO CASE
       CASE BAN->nLenRefBan == 10
	    cCodRef := cCodRf1
	    cCodFac := SPACE(02)

       CASE BAN->nLenRefBan == 12  // C¢digo Servicio Facturado

	    cCodFac := SUBS(cCodRf1,1,2)
	    IF VAL(cCodFac) == 0
	       cCodRef := SUBS(cCodRf1,3,10)
	       cCodRef := cCodRef+cCodFac
	    ELSE
	       cCodRef := cCodRf1
	       cCodFac := SUBS(cCodRf1,11,2)
	    ENDIF

       OTHERWISE
	    cCodRef := cCodRf1
	    cCodFac := SPACE(02)
       ENDCASE
*>>>>FIN REFERENCIA1

*>>>>REFERENCIA2
       IF BAN->nCodRf2Ban # 0
	  cCodRf2 := SUBS(cRegTra,BAN->nCodRf2Ban,BAN->nLenRefBan)
       ENDIF

       IF BAN->nCodRf2Ban # 0 .AND. VAL(cCodRf1) == 0
	  cCodRef := cCodRf2

	  DO CASE
	  CASE BAN->nLenRefBan == 10
	       cCodRef := cCodRf2

	  CASE BAN->nLenRefBan == 12  // C¢digo Servicio Facturado

	       cCodFac := SUBS(cCodRf2,1,2)
	       IF VAL(cCodFac) == 0
		  cCodRef := SUBS(cCodRf2,3,10)
		  cCodRef := cCodRef+cCodFac
	       ELSE
		  cCodRef := cCodRf2
	       ENDIF

	  OTHERWISE
	       cCodRef := cCodRf2
	  ENDCASE

       ENDIF
*>>>>FIN REFERENCIA2

*>>>>MOTIVO DE LA TRANSACCION
       IF BAN->nMotivoBan # 0 .AND. VAL(cCodRef) == 0

	  cCodRef := SUBS(cRegTra,BAN->nMotivoBan,BAN->nLenMtvBan)

	  IF BAN->nLenRefBan > BAN->nLenMtvBan
	     cCodRef += SPACE(BAN->nLenRefBan - BAN->nLenMtvBan)
	  ENDIF

       ENDIF

       RETURN cCodRef
*>>>>FIN MOTIVO DE LA TRANSACCION

/*************************************************************************
* TITULO..: LONGITUD DE LA REFERENCIA 2                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 13/2007 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 PM   FEB 13/2007 MAR

OBJETIVOS:

1- Calcula la longitud de la referencia2

2- Retorna la longitud de la Referencia2

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLenRef2()

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenRef := 0                   // Longitud de la Referencia2
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LONGITUD DE LA REFERENCIA2
       IF BAN->nCodRf2Ban == 0
	  nLenRef := BAN->nLenRefBan
       ELSE
	  nLenRef := BAN->nLenRf2Ban
       ENDIF
       RETURN nLenRef
*>>>>FIN LONGITUD DE LA REFERENCIA2

/*************************************************************************
* TITULO..: DESCRIPCION DEL MOTIVO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/2007 VIE A
       Colombia, Bucaramanga        INICIO: 06:30 PM   FEB 16/2007 VIE

OBJETIVOS:

1- Localiza el motivo de la transaci¢n

2- Retorna la descripci¢n del motivo de la transaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cMotivoTra(nLenMtv,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nLenMtv                              // Longitud del Motivo
       cNalias				    // Alias diferente al maestro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodMtv := ''                  // C¢digo de la Referencia
       LOCAL cNomMtv := ''                  // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL MOTIVO
       cCodMtv := ALLTRIM(SUBS(TRA->Registro,;
			       BAN->nMotivoBan,BAN->nLenMtvBan))

       cNomMtv := cCodMtv+' '+SPACE(BAN->nLenMtvBan)

       IF lLocCodigo('ALLTRIM(cCodRefTra)','CMV',cCodMtv)
	  cNomMtv := SUBS(cCodMtv+' '+CMV->cNombreCmv,1,nLenMtv)
       ENDIF

       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF

       RETURN cNomMtv
*>>>>FIN LOCALIZACION DEL MOTIVO

/*************************************************************************
* TITULO..: TIPO DE MOVIMIENTO                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/2007 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   FEB 16/2007 VIE

OBJETIVOS:

1- Localiza el motivo de la transaci¢n

2- Retorna la descripci¢n del motivo de la transaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nValorTra(nSumar,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nSumar			            // 0 = Indefinido 1 => Credito 2=> Debito
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF TRA->nSumarTra == nSumar
	  nVlrTra := TRA->nValorTra
       ELSE
	  IF TRA->nSumarTra # 0
	     nVlrTra := 0
	  ELSE
	     nVlrTra := -1
	  ENDIF
       ENDIF

       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF

       RETURN nVlrTra
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: ORDENAR POR REFERENCIA                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 22/2007 VIE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   FEB 22/2007 VIE

OBJETIVOS:

1- Ordena el archivo por referencias

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaTra(lShared,nModCry,FileTra,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       FileTra                              // Archivo de Transaciones
       oBrowse			            // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN MOVIMIENTOS GRABADOS')
	  RETURN NIL
       ENDIF
       CloseDbf('TRA')
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,FileTra,'nCodigoCmv /D')
	  cError('NO SE ORDENO EL ARCHIVO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTra,'TRA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE TRANSACIONES')
	  RETURN NIL
       ENDIF
       SELECT TRA
       IF !EMPTY(oBrowse)
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: LEER EL MOVIMIENTOS ACUMULADOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 10/2014 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 AM   MAY 10/2014 MIE

OBJETIVOS:

1- Appendiza los movimientos diarios del extracto.

2- Appendiza los movimientos de facturaci¢n del extracto.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeTraAcu(lShared,nModCry,cNomSis,cAnoUsr,;
		   cPatSis,cNroMes,cNroDia,fArchvo)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cNroMes                              // N£mero del Mes
       cNroDia                              // N£mero del Dia
       fArchvo                              // Nombre del Archivo */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL    cMes := ''                  // Mes
       LOCAL    cDia := ''                  // Dia
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO DEL ESTRACTO
       cSavPan := SAVESCREEN(0,0,24,79)

       CloseDbf('TRA')

       CreaDbfTra(lShared,nModCry,cPatSis+'\MODEM\'+BAN->cCodigoBan,fArchvo)
      *Creaci¢n de archivo de trasaciones
*>>>>FIN CREACION DEL ARCHIVO DEL ESTRACTO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			 fArchvo,'TRA',NIL,lShared,0})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO ACUMULADO DEL EXTRACTO')
	  CloseDbf('TRA')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DEL ARCHIVO
       Termometro(0,'ACUMULADO EXTRACTOS')
       FOR i := 1 TO IF(EMPTY(cNroDia),12,31)

***********PREPARACION DEL DE ARCHIVO
	     IF EMPTY(cNroDia)
		cMes := STR(i,2)
		lCorrecion(@cMes)
		FileTem := 'PA'+cAnoUsr+cMes+ExtFile
	     ELSE
		cDia := STR(i,2)
		lCorrecion(@cDia)
		FileTem := cAnoUsr+cNroMes+cDia+ExtFile
	     ENDIF
	     FileTem := cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTem
***********FIN PREPARACION DEL DE ARCHIVO

***********APPEND DEL ARCHIVO
	     IF FILE(FileTem)

*---------------LINEA DE ESTADO
		  LineaEstado('MOVIMIENTO:'+STR(i,2),cNomSis)
*---------------LINEA DE ESTADO

*---------------COPIA DE LOS REGISTRO
		  APPEND FROM &FileTem
		  Termometro(i*100/12)
*---------------FIN COPIA DE LOS REGISTRO

	     ENDIF
***********FIN APPEND DEL ARCHIVO

       ENDFOR
       Termometro(100)
       SELECT TRA

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN LECTURA DEL ARCHIVO
