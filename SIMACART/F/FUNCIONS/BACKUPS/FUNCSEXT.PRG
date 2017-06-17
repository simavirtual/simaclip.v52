/*               	 SISTEMA CARTERA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DEL EXTRACTO

REQUERIMIENTOS:

- Compilar: clipper FuncsExt /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo del Extracto.

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

   CreaDbfExt(PathExt,FileExt,fNtxExt)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfExt(lShared,nModCry,PathExt,FileExt,fNtxExt,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathExt				    // Path del Archivo
       FileExt				    // Nombre del Archivo
       fNtxExt				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfExt := {{"Registro"  ,"Character",1300,0},;  // Registro
			 {"cCodRefTra","Character",12,0},;   // C¢digo de la Referencia
			 {"cCodFacCar","Character",02,0},;   // C¢digo Servicio Facturado. Ej: 01->PENSION,02->RESTAURANTE,03->TRANSPORTE
			 {"cCodigoEst","Character",06,0},;   // C¢digo del Estudiante
			 {"cCodigoTra","Character",03,0},;   // Codigo de la Transaci¢n
			 {"nCodigoCmv","Numeric"  ,04,0},;   // C¢digo del Concepto del Movimiento
			 {"nValorTra" ,"Numeric"  ,12,2},;   // Valor de la Transaci¢n
			 {"dFechaTra" ,"Date"     ,08,0},;   // Fecha de la Transaci¢n
			 {"nVlrPagPag" ,"Numeric" ,12,2},;   // Valor de la Transaci¢n
			 {"nVlrIntPag" ,"Numeric" ,12,2},;   // Valor de los Intereses
			 {"dFecPagPag" ,"Date"    ,08,0},;   // Fecha de pago
			 {'nVlrDifTra','Numeric'  ,12,2},;   // Valor diferencia
			 {"cNroComTra","Character",12,0},;   // N£mero del Comprobante
			 {"lSumarTra" ,"Logical"  ,01,0},;   // .T. Credito .F. Debito
			 {"lInsUsrTra","Logical"  ,01,0},;   // .T. Insertado por Usuario
			 {"cNroCtaTra","Character",20,0},;   // N£mero de la Cuenta
			 {"cOficinTra","Character",10,0},;   // Oficina de la Trnasacci¢n
			 {"cTerOfiTra","Character",10,0},;   // Terminal de la Oficina
			 {"cTalonTra" ,"Character",10,0},;   // Talon de la Transaci¢n
			 {"cJornadTra","Character",10,0},;   // Jornada de pago
			 {"cObsValTra","Character",150,0}}   // Observaci¢n de Validaci¢n
*>>>>FIN DECLARACION DE VARIABLES


*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfExt
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathExt) == 0
	    DBCREATE(FileExt,aDbfExt,"DBFNTX")
	    Proteger(FileExt,nModCry)

       CASE DIRCHANGE(PathExt) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathExt)

       CASE DIRCHANGE(PathExt) == -5
	    cError('NO TIENE DERECHOS EN: '+PathExt)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 05/99 MAR A
       Colombia, Bucaramanga        INICIO: 04:05 PM   OCT 05/99 MAR

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

FUNCTION nActStrExt(lShared,nModCry,PathExt,FileExt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       FileExt				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathExt+'\'+FileExt,'EXT',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE TRANSACIONES')
	  CloseDbf('EXT',PathExt+'\'+FileExt,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := EXT->(DBSTRUCT())
       CloseDbf('EXT',PathExt+'\'+FileExt,nModCry)
       CreaDbfExt(lShared,nModCry,PathExt,FileExt,,@aStrNew)
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
	  cError('El Archivo del EXTRACTO su Estructura Esta DesActualizada.',;
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
	  FileTem := SUBS(FileExt,1,AT('.',FileExt))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathExt+'\'+FileExt,;
			 PathExt+'\'+FileTem,;
			 {||CreaDbfExt(lShared,nModCry,PathExt,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

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

FUNCTION MantenExt(aParam1,aParam2,aParam3,;
		   cModem)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cModem                               // Banco de la Gerencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL cAnoMtr := ''                  // A¤o de la Matr¡cula
       LOCAL cAnoAlu := ''                  // A¤o del Meaestro de Estudiantes.
       LOCAL nNroMes := 0                   // N£mero del Mes
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL oBrwExt := NIL                 // Browse de Transaciones
       LOCAL aUseDbfs:= {}                  // Bases de Datos
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroMes := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes del Extracto',.T.,{'TOT'})
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
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
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE EMPTY(CAA->cCodigoBan)
	    cError('NO SE HA DEFINIDO EL BANCO EN LA CONFIGURACION DEL A¥O')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE EMPTY(BAN->nCodEstBan) .OR. EMPTY(BAN->nPagIntBan) .OR.;
	    EMPTY(BAN->nMesPagBan) .OR. EMPTY(BAN->nDiaPagBan) .OR.;
	    EMPTY(BAN->nAnoPagBan) .OR. EMPTY(BAN->nTipMovBan)
	    cError('FALTA COMPLETAR LAS POSICIONES DEL ARCHIVO PLANO')

       CASE EMPTY(BAN->nLenAnoBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DEL A¥O')

       CASE EMPTY(BAN->nLenRefBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DE LA REFERENCIA')

       CASE EMPTY(BAN->nLenIntBan)
	    cError('NO SE HA ESPECIFICADO LA LONGITUD DEL VALOR PAGADO')

*       CASE BAN->nLenIntBan > 10
*	    cError('LA LONGITUD DEL VALOR PAGADO NO PUEDE EXCEDER DE 10 CARACTERES')

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

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ANALISIS DEL A¥O DEL MAESTRO DE ESTUDIANTES
       IF EMPTY(CAA->cAnoAluCaA)
	  cAnoAlu := cAnoUsr
	  cIntUno := PathUno+'\'+cPatSis
       ELSE
	  cAnoAlu := CAA->cAnoAluCaA
	  cIntUno := PathUno+'\'+cAnoAlu+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
*>>>>FIN ANALISIS DEL A¥O DEL MAESTRO DE ESTUDIANTES

*>>>>ANALISIS DEL A¥O DE LAS MATRICULAS
       IF EMPTY(CAA->cAnoMtrCaA)
	  cAnoMtr := cAnoUsr
	  cIntDos := PathDos+'\'+cPatSis
       ELSE
	  cAnoMtr := CAA->cAnoMtrCaA
	  cIntDos := PathDos+'\'+cAnoMtr+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
*>>>>FIN ANALISIS DEL A¥O DE LAS MATRICULAS

*>>>>LOCALIZACION DEL BANCO
       IF BAN->(RECCOUNT()) > 1
	  nSelBanco(nFilInf+1,nColInf-1)
       ELSE
	  SELECT BAN
	  GO TOP
       ENDIF
*>>>>FIN LOCALIZACION DEL BANCO

*>>>>LECTURA DEL ARCHIVO DEL EXTRACTO
       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile
       fNtxMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+cExtNtx

       IF !FILE(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB)

**********ANALISIS DE DECISION
	    IF BAN->lLeeExtBan
	       IF nNroMes >0 .AND. nNroMes <= 12 .AND.;
		  !lPregunta('DESEA LEER EL EXTRACTO '+'DE '+cMes(nNroMes,10)+'? Si No')
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DEL ARCHIVO
	    IF nNroMes >0 .AND. nNroMes <= 12
	       IF BAN->lLeeExtBan
		  FOtrExt43(aParam1,aParam2,aParam3,;
			    cNroMes)
	       ELSE
		  LeeExtDia(lShared,nModCry,cNomSis,;
			    cAnoUsr,cPatSis,cNroMes,oBrwExt)
	       ENDIF
	    ELSE
	       LeeExtAcu(lShared,nModCry,cNomSis,;
			 cAnoUsr,cPatSis,cNroMes,oBrwExt)
	    ENDIF
**********FIN LECTURA DEL ARCHIVO

       ENDIF
*>>>>FIN LECTURA DEL ARCHIVO DEL EXTRACTO

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>EXTRACTO ACUMULADO
       IF nNroMes == 13
	  LeeExtAcu(lShared,nModCry,cNomSis,;
		    cAnoUsr,cPatSis,cNroMes,oBrwExt)
       ENDIF
*>>>>FIN EXTRACTO ACUMULADO

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF nActStrExt(lShared,nModCry,cPatSis+'\MODEM\'+BAN->cCodigoBan,;
		     FileMoB) == 1
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

*>>>>AREAS DE TRABAJO
       aUseDbfs := {}
       FileTmv := FileTmv+BAN->cCodigoBan+ExtFile
       AADD(aUseDbfs,{.T.,cPatSis+'\'+FileTmv,'TMV',NIL,lShared,nModCry})
       AADD(aUseDbfs,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lShared,nModCry})
       AADD(aUseDbfs,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			  FileMoB,'TRA',NIL,lShared,nModCry})
       AADD(aUseDbfs,{.T.,cIntDos+'\'+FilePag,'PMT',NIL,lShared,nModCry})
       AADD(aUseDbfs,{.T.,cIntDos+'\'+FileCon,'CMT',NIL,lShared,nModCry})
       AADD(aUseDbfs,{.T.,cIntDos+'\'+FileDes,'DMT',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,SUBS(cAnoAlu,3,2),lAnoAct)  .OR.;
	  !lUseDbfs(aUseDbfs)
	  cError('ABRIENDO LOS ARCHIVOS MAESTROS Y TRANSACIONES')
	  CloseAll(aUseDbf,.F.)
	  CloseAll(aUseDbfs)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

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
	  CloseAll(aUseDbf,.F.)
	  CloseAll(aUseDbfs)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       IF SUBS(CAA->cValConCaA,nNroMes,1) # SPACE(01)

	  cError('LA CONCILIACION DE '+cMes(nNroMes,10)+' '+;
		 'YA SE REPORTO A CONTABILIDAD')

       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT TRA

       oBrwExt := oDefBrwExt(lShared,nFilPal+1,00,22,79,cMaeAlu,nNroMes,;
			     cModem,BAN->cNombreBan,BAN->cNroCtaBan)
       SETKEY(K_F5,{||BuscarExt(lShared,oBrwExt,;
				cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
				fNtxMoB)})
       SETKEY(K_F9,{||MenuExt01(aParam1,aParam2,aParam3,;
				cNroMes,oBrwExt,cModem)})
/*
       SETKEY(K_F10,{||MenuExt02(aParam1,aParam2,aParam3,;
				 cNroMes,oBrwExt,cModem)})
*/
       TRA->(CtrlBrw(lShared,oBrwExt))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf,.F.)
       CloseAll(aUseDbfs)
       SET DECIMALS TO 2
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

 oBrwExt := oDefBrwExt(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwExt(lShared,nFilSup,nColSup,nFilInf,nColInf,;
		    cMaeAlu,nNroMes,cModem,cNomBan,cNroCta)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maestros habilitados
       nNroMes                              // N£mero del Mes
       cModem                               // Banco de la Gerencia
       cNomBan                              // Nombre del Banco
       cNroCta                              // N£mero de la Cuenta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwExt := NIL		    // Browse de Transaciones
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       lModReg := IF(SUBS(CAA->cValConCaA,nNroMes,1) # SPACE(01),.F.,.T.)
       LineaEstado(ALLTRIM(cNomBan)+' CUENTA No. '+ALLTRIM(cNroCta),'')

       oBrwExt := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwExt:ColSep    := '³'
       oBrwExt:HeadSep   := 'Ä'

       IF lModReg

	  oBrwExt:Cargo := {IF(nNroMes==13,;
			       'MOVIMIENTOS ACUMULADOS DE TODOS '+;
			       'LOS EXTRACTOS',;
			       '<< MOVIMIENTOS DEL EXTRACTO. MES '+;
				   cMes(nNroMes,10)+' >>'),;
			       '<INS>Incluir <DEL>Borrar <F5>Buscar '+;
			       '<F9>'+ALLTRIM(cModem),{||IncluirExt(lShared)}}
       ELSE

	  oBrwExt:Cargo := {IF(nNroMes==13,;
			       'MOVIMIENTOS ACUMULADOS DE TODOS '+;
			       'LOS EXTRACTOS',;
			       '<< MOVIMIENTOS DEL EXTRACTO. MES '+;
				   cMes(nNroMes,10)+' >>'),;
			       '<F5>Buscar '+;
			       '<F9>'+ALLTRIM(cModem),{||IncluirExt(lShared)}}

       ENDIF

/*
       oBrwExt:Cargo     := {'<< MOVIMIENTOS DEL EXTRACTO. MES '+cMes(nNroMes,10)+' >>',;
			    '<F1>Ayuda '+;
			    '<F9>'+ALLTRIM(cModem)+' <F10>Conciliaci¢n> '+;
			    '<F11>Contabilidad',;
			    {||IncluirExt(lShared)}}
*/

     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT TRA
       oColumn	     := TBCOLUMNNEW('FECHA;DE PAGO',{||TRA->dFechaTra})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','dFechaTra'},;
			 {'PICTURE','@D'}}
       oColumn:Width := 11
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REFERENCIA', {||TRA->cCodRefTra})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','cCodRefTra'},;
			 {'PICTURE','@!'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||TRA->cCodigoEst})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','cCodigoEst'},;
			 {'PICTURE','@!'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TRAN', {||TRA->cCodigoTra})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','cCodigoTra'},;
			 {'PICTURE','@!'}}
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW(' ', {||TRA->lSumarTra})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','lSumarTra'},;
			 {'PICTURE','@!'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;CREDITO',;
				   {||IF(TRA->lSumarTra,TRA->nValorTra,SPACE(12))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;DEBITO',;
				   {||IF(TRA->lSumarTra,SPACE(12),TRA->nValorTra)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
       oBrwExt:Freeze:= 7
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;CONCEPTO', {||TRA->nCodigoCmv})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','nCodigoCmv'},;
			 {'PICTURE','9999'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('CONCEPTO',;
			{||cConcepCmv(TRA->nCodigoCmv,'TRA')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 40
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DEL;COMPROBANTE', {||TRA->cNroComTra})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','cNroComTra'},;
			 {'PICTURE','@!X'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('REFERENCIA1',;
		  {||SUBS(TRA->Registro,BAN->nCodEstBan,BAN->nLenRefBan)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('REFERENCIA2',;
		  {||SUBS(TRA->Registro,BAN->nCodRf2Ban,BAN->nLenRefBan)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;SERVICIO FACTURADO', {||TRA->cCodFacCar})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},;
			 {'FIELD','cCodFacCar'},{'PICTURE','@!'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES;INICIAL',;
			{||cMes(VAL(SUBS(TRA->cCodRefTra,7,2)))})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 10
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES;FINAL',;
			{||cMes(VAL(SUBS(TRA->cCodRefTra,9,2)))})
       oColumn:Width := 10
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
			{||cSekNomAlu(SUBS(TRA->cCodRefTra,1,6),cMaeAlu,'TRA')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
*       oBrwExt:Freeze:= 3
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INSERTADO POR EL USUARIO',;
				   {||IF(TRA->lInsUsrTra,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION DE LA CONCILIACION DEL EXTRACTO',;
				   {||TRA->cObsValTra})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','TRA'},{'FIELD','cObsValTra'},;
			 {'PICTURE','@S76'}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF BAN->nMotivoBan # 0
	  oColumn := TBCOLUMNNEW('MOTIVO',{||cMotivoTra(46,'TRA')})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrwExt:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF


       IF EMPTY(TRA->cOficinTra)
	  oColumn := TBCOLUMNNEW('OFICINA.',;
		    {||SUBS(TRA->Registro,BAN->nPosOfiBan,BAN->nLenOfiBan)})

       ELSE
	  oColumn := TBCOLUMNNEW('OFICINA',{||TRA->cOficinTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF EMPTY(TRA->cTerOfiTra)
	  oColumn := TBCOLUMNNEW('TERMINAL.',;
		    {||SUBS(TRA->Registro,BAN->nPosTerBan,BAN->nLenTerBan)})
       ELSE
	  oColumn := TBCOLUMNNEW('TERMINAL',{||TRA->cTerOfiTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF EMPTY(TRA->cTalonTra)
	  oColumn := TBCOLUMNNEW('TALON.',;
		    {||SUBS(TRA->Registro,BAN->nPosTalBan,BAN->nLenTalBan)})
       ELSE
	  oColumn := TBCOLUMNNEW('TALON',{||TRA->cTalonTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF EMPTY(TRA->cJornadTra)
	  oColumn := TBCOLUMNNEW('JORNADA.',;
		    {||SUBS(TRA->Registro,BAN->nPosJorBan,BAN->nLenJorBan)})
       ELSE
	  oColumn := TBCOLUMNNEW('JORNADA',{||TRA->cJornadTra})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NRO CUENTA', {||TRA->cNroCtaTra})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;PAGOS',{||TRA->nVlrPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;INTERESES',{||TRA->nVlrIntPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;DE PAGO',{||TRA->dFecPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;DIFERENCIA',{||TRA->nVlrDifTra})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('TRANSACION     1         2        3          4          5         6;123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 ',;
				   {||TRA->Registro})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('Registro No.', {||TRA->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwExt:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
       RETURN oBrwExt
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/99 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAY 20/99 JUE

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirExt(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL dFecha  := CTOD("00/00/00")    // Fecha del Movimiento
       LOCAL cCodTra := ''                  // Tipo de Transaci¢n
       LOCAL nValor  := 0                   // Valor de la Transacci¢n
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL nCodCon := 0                   // C¢digo del Concepto
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR DIGITE LOS DETALLES '+;
			 'DEL MOVIMIENTO',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       dFecha  := CTOD("00/00/00")
	       cCodTra := cSpaces('TRA','cCodigoTra')
	       nValor  := 0
	       cCodRef := cSpaces('TRA','cCodRefTra')
	       nCodCon := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'FECHA DEL MOVIMIENTO :';
				GET dFecha

	    @ nNroFil+1,nNroCol SAY 'TIPO DE TRANSACION   :';
				GET cCodTra PICT '@!';
				VALID lValidaTmv(ROW(),COL()-1,@cCodTra)

	    @ nNroFil+2,nNroCol SAY 'VALOR DEL MOVIMIENTO :';
				GET nValor PICT '9999999999.99'

	    @ nNroFil+3,nNroCol SAY 'REFERENCIA           :';
				GET cCodRef PICT '@!'

	    @ nNroFil+4,nNroCol SAY 'CODIGO DEL CONCEPTO  :';
				GET nCodCon PICT '9999'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(dFecha)  .OR. EMPTY(nValor) .OR.;
		 EMPTY(cCodRef)

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')
	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT TRA
       IF lGrabar
	  IF TRA->(lRegLock(lShared,.T.))
	     REPL TRA->cCodRefTra WITH cCodRef
	     REPL TRA->cCodigoEst WITH SUBS(cCodRef,1,6)
	     REPL TRA->cCodigoTra WITH cCodTra
	     REPL TRA->nCodigoCmv WITH nCodCon
	     REPL TRA->nValorTra  WITH nValor
	     REPL TRA->dFechaTra  WITH dFecha
	     REPL TRA->lSumarTra  WITH TMV->lSumarTra
	     REPL TRA->lInsUsrTra WITH .T.
	     TRA->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  TRA->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

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

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarExt(lShared,oBrowse,FileNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivo Compartido
       oBrowse				    // Browse de Transaciones
       FileNtx                              // Archivo Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nColLin := 0                   // Columna de lectura de linea
       LOCAL nTecPul := 0                   // Tecla pulsada
       LOCAL nLenCam := 12                   // Longitud de campo a leer

       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL nCodCmv := 0                   // C¢digo del Concepto
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo o Referencia del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL METODO DE BUSQUEDA
       aMenus := {'1<POR REFERENCIA>',;
		  '2<POR CODIGO    >',;
		  '3<POR CONCEPTO  >'}

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,NIL,09,30,'BUSQUEDA',NIL,1,.F.)
       IF nNroOpc == 0
	  oBrowse:REFRESHALL()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECCION DEL METODO DE BUSQUEDA

*>>>>ACTIVACION DE LOS INDICES
       DO CASE
       CASE nNroOpc == 1
	    INDEX ON TRA->cCodRefTra TO &(FileNtx)

       CASE nNroOpc == 2
	    INDEX ON TRA->cCodigoEst TO &(FileNtx)

       CASE nNroOpc == 3
	    INDEX ON TRA->nCodigoCmv TO &(FileNtx)
       ENDCASE
*>>>>FIN ACTIVACION DE LOS INDICES

*>>>>IMPRESION DEL TITULO DE BUSQUEDA
       SET CURSOR ON
       DO CASE
       CASE nNroOpc == 1
	    nLenCam := LEN(cSpaces('TRA',"cCodRefTra"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE LA REFERENCIA:')

       CASE nNroOpc == 2
	    nLenCam := LEN(cSpaces('TRA',"cCodigoEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL CODIGO:')

       CASE nNroOpc == 2
	    nLenCam := LEN(cSpaces('TRA',"cCodigoEst"))
	    TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL CONCEPTO:')

       ENDCASE
       nColLin := nNroCol
*>>>>FIN IMPRESION DEL TITULO DE BUSQUEDA

*>>>>BUSQUEDA DEL REGISTRO
       DO WHILE .T.

**********IMPRESION DEL TITULO DE BUSQUEDA
	    DO CASE
	    CASE nNroOpc == 1
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE LA REFERENCIA:')

		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigoTes+;
				      SPACE(nLenCam-LEN(cCodigoTes))
		 SET COLOR TO

	    CASE nNroOpc == 2
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL CODIGO:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigoTes+;
				      SPACE(nLenCam-LEN(cCodigoTes))
		 SET COLOR TO

	    CASE nNroOpc == 3
		 TitBuscar(nLenCam,@nNroFil,@nNroCol,'ENTRE EL CONCEPTO:')
		 SET COLOR TO I
		 @nNroFil,nNroCol SAY cCodigoTes+;
				      SPACE(nLenCam-LEN(cCodigoTes))
		 SET COLOR TO

	    ENDCASE
**********FIN IMPRESION DEL TITULO DE BUSQUEDA

**********LECTURA DEL CARACTER
	    nTecPul := nLeeChr(nNroFil,nColLin)
	    IF nTecPul == 27 .OR. nTecPul == 13 .OR. LEN(cCodigoTes) == nLenCam
	       EXIT
	    ENDIF
	    cCodigoTes += CHR(nTecPul)
	    nColLin++
**********FIN LECTURA DEL CARACTER

**********BUSQUEDA DEL CODIGO
	    SELECT TRA
	    nRegAct := RECNO()
	    DO CASE
	    CASE nNroOpc == 1 .OR. nNroOpc == 2

		 IF lSekCodigo(cCodigoTes,'TRA')
		    nRegAct := RECNO()
		 ENDIF

	    CASE nNroOpc == 3

		 nCodCmv := VAL(cCodigoTes)
		 IF lSekCodigo(nCodCmv,'TRA')
		    nRegAct := RECNO()
		 ENDIF
	    ENDCASE

	    GO TOP
	    oBrowse:GOTOP()
	    GO nRegAct
	    oBrowse:FORCESTABLE()
**********FIN BUSQUEDA DEL CODIGO

       ENDDO
       oBrowse:REFRESHALL()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN BUSQUEDA DEL REGISTRO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO No. 01                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/99 MAR A
       Colombia, Bucaramanga        INICIO: 05:15 PM   MAY 18/99 MAR

OBJETIVOS:

1- Menu de Otros para el archivo contiene las opciones para el control
   de ingresos.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuExt01(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia */
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
       LOCAL nOpcExt := 1                   // Opci¢n para el Extracto
       LOCAL nOpcMvt := 1                   // Opci¢n para los Movimientos
       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL nRegPrn := 0                   // Registro de impresora

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

*>>>>OPCIONES PARA LOS MOVIMIENTOS DEL EXTRACTO
       nRegPrn := PRN->(RECNO())
       DO WHILE .T.

**********OPCIONES PARA EL EXTRACTO
	    aMenus  := {'1<MOVIMIENTOS  >',;
			'2<AUDITORIA    >',;
			'3<POR CONCEPTOS>',;
			'4<OTROS        >'}

	    aAyuda := {'Imprime los diferentes Movimientos del Extracto',;
		       'Permite realizar Auditoria entre el Banco y el Sistema',;
		       'Permite Descriminar el Estracto por Conceptos',;
		       'Permite realizar otro procesos del Estracto'}

	    cSavPan := SAVESCREEN(0,0,24,79)
	    nOpcExt := nMenu(aMenus,aAyuda,09,25,ALLTRIM(cModem),NIL,1,.F.)
	    RESTSCREEN(0,0,24,79,cSavPan)
	    IF nOpcExt == 0
	       EXIT
	    ENDIF
**********FIN OPCIONES PARA EL EXTRACTO

**********OPCIONES PARA LOS MOVIMIENTOS
	    DO WHILE .T.

*--------------MENU DE LOS MOVIMIENTOS
		 DO CASE
		 CASE nOpcExt == 1

		      cTxtTem := 'MOVIMIENTOS'
		      aMenus  := {'1<IMPRIMIR POR TRANSACCION>',;
				  '2<IMPRIMIR POR CONCEPTOS  >',;
				  '3<IMPRIMIR EXTRACTO       >'}

		      aAyuda := {'Imprime los Cr‚ditos y D‚bitos por Tipo de Transacci¢n',;
				 'Imprime los Cr‚ditos y D‚bitos por Conceptos',;
				 'Imprime el Extracto'}

		 CASE nOpcExt == 2

		      cTxtTem := 'AUDITORIA'
		      aMenus  := {'1<VALIDACION DE LOS PAGOS>',;
				  '2<INCONSISTECIAS EN MVTOS>',;
				  '3<IMPRIMIR POR GRUPOS    >',;
				  '4<TOTAL DE LOS PAGOS     >'}

		      aAyuda := {'Compara los pagos del Banco contra los del Sistema',;
				 'Imprime las Inconsistencias en los Movimientos del Banco y del sistema',;
				 'Imprime las consignaciones por grupo',;
				 'Imprime el total de consignaciones por grupos'}

		 CASE nOpcExt == 3

		      cTxtTem := 'CONTABILIDAD'

		      aMenus := {}
		      AADD(aMenus,'1<VALIDACION         >')
		      AADD(aMenus,'2<PAGOS POR CONCEPTOS>')
*		      AADD(aMenus,'3<PAGOS POR GRUPOS   >')
		      AADD(aMenus,'4<PAGOS CONTRATANTES >')

		      aAyuda := {}
		      AADD(aAyuda,'Imprime validar la descriminaci¢n de los conceptos')
		      AADD(aAyuda,'Imprime los pagos descriminados por conceptos')
*		      AADD(aAyuda,'Imprime los pagos descriminado por grupos')
		      AADD(aAyuda,'Imprime los pagos descriminado por Contratantes')

		 CASE nOpcExt == 4  // OTROS

		      cTxtTem := 'OTROS'
		      aMenus  := {'1<ORDENAR POR FECHA >',;
				  '2<ACTUALIZAR CODIGOS>',;
				  '3<LEER EL ARCHIVO   >'}

		      aAyuda := {'Ordena los movimientos por fechas.',;
				 'Actualiza los c¢digos de acuerdo a las modificaciones de las referencias',;
				 'Lee nuevamente el archivo del Extracto'}

		 ENDCASE

		 cSavPan := SAVESCREEN(0,0,24,79)
		 nOpcMvt := nMenu(aMenus,aAyuda,09,25,cTxtTem,NIL,1,.F.)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 IF nOpcMvt == 0
		    EXIT
		 ENDIF
*--------------FIN MENU DE LOS MOVIMIENTOS

*--------------ANALISIS DE LA OPCION SELECIONADA
		 DO CASE

		 CASE nOpcExt == 1 .AND. nOpcMvt == 1
		      FOtrExt11(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Impresi¢n de Movimientos por Tipos de Transacci¢n

		 CASE nOpcExt == 1 .AND. nOpcMvt == 2
		      FOtrExt12(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Impresi¢n de Movimientos por Conceptos

		 CASE nOpcExt == 1 .AND. nOpcMvt == 3
		      FOtrExt13(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Impresi¢n del extracto

		 CASE nOpcExt == 2 .AND. nOpcMvt == 1
		      FOtrExt21(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Validaci¢n de los pagos

		 CASE nOpcExt == 2 .AND. nOpcMvt == 2
		      FOtrExt22(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Validaci¢n de los Movimientos.

		 CASE nOpcExt == 2 .AND. nOpcMvt == 3
		      FOtrExt23(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Pagos por grupos.

		 CASE nOpcExt == 2 .AND. nOpcMvt == 4
		      FOtrExt24(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Total pagos por grupos.

		 CASE nOpcExt == 3 .AND. nOpcMvt == 1
		      FOtrExt31(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Validaci¢n de la descriminaci¢n de los Conceptos

		 CASE nOpcExt == 3 .AND. nOpcMvt == 2
		      FOtrExt32(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Pagos por conceptos.

*		 CASE nOpcExt == 3 .AND. nOpcMvt == 3
*		      FOtrExt33(aParam1,aParam2,aParam3,;
*				cNroMes,oBrowse)
		     *Pagos por grupos.

		 CASE nOpcExt == 3 .AND. nOpcMvt == 3 // Ojo
		      FOtrExt34(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Pagos por Contratantes

		 CASE nOpcExt == 4 .AND. nOpcMvt == 1
		      OrdenaExt(lShared,nModCry,cAnoUsr,cPatSis,cNroMes,oBrowse)
		     *Ordenar el archivo por fechas.

		 CASE nOpcExt == 4 .AND. nOpcMvt == 2
		      FOtrExt42(aParam1,aParam2,aParam3,;
				cNroMes,oBrowse)
		     *Actualizaci¢n de los C¢digos

		 CASE nOpcExt == 4 .AND. nOpcMvt == 3

		      IF VAL(cNroMes) >0 .AND. VAL(cNroMes) <= 12

			 IF SUBS(CAA->cValConCaA,VAL(cNroMes),1) # SPACE(01)

			    cError('LA CONCILIACION DE '+;
				   cMes(VAL(cNroMes),10)+' '+;
				   'YA SE REPORTO A CONTABILIDAD')
			 ELSE

			    IF BAN->lLeeExtBan
			       FOtrExt43(aParam1,aParam2,aParam3,;
					 cNroMes,oBrowse)
			    ELSE
			       IF lPregunta('DESEA LEER NUEVAMENTE EL '+;
					    'EXTRACTO? No Si')
				  LeeExtDia(lShared,nModCry,cNomSis,;
					 cAnoUsr,cPatSis,cNroMes,oBrowse)
			       ENDIF
			    ENDIF
			   *Lectura del Archivo del Extracto

			 ENDIF


		      ELSE
			 LeeExtAcu(lShared,nModCry,cNomSis,;
				   cAnoUsr,cPatSis,cNroMes,oBrowse)
			*Lectura del Extracto acumulado
		      ENDIF

		 ENDCASE
*--------------FIN ANALISIS DE LA OPCION SELECIONADA

	       PRN->(DBGOTO(nRegPrn))

	    ENDDO
**********FIN OPCIONES PARA LOS MOVIMIENTOS

       ENDDO
       RETURN NIL
*>>>>FIN OPCIONES PARA LOS MOVIMIENTOS DEL EXTRACTO



/*
*>>>>ANALISIS DE OPCION ESCOGIDA DEL MOVIMIENTO

       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA DEL MOVIMIENTO

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENAR POR FECHA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 12/99 VIE A
       Colombia, Bucaramanga        INICIO: 10:45 AM   FEB 12/99 VIE

OBJETIVOS:

1- Ordena el archivo por fecha

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaExt(lShared,nModCry,cAnoUsr,cPatSis,cNroMes,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del Sistema
       cNroMes                              // N£mero del Mes
       oBrowse			            // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  RETURN NIL
       ENDIF
       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile
       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,nModCry)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		    FileMoB,'dFechaTra',,nModCry)
	  cError('NO SE ORDENO EL MAESTRO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		       FileMoB,'TRA',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DEL EXTRACTO')
	  RETURN NIL
       ENDIF
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO No. 02                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 12/2000 JUE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 12/2000 JUE

OBJETIVOS:

1- Menu de Otros para el archivo contiene las opciones para el control
   de saldos con la Contabilidad y permitir realizar los movimientos
   contables descriminando los pagos en el Banco.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuExt02(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia */
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'01<IMPRIMIR POR CUENTAS PUC>',;
		   '02<IMPRIMIR POR CONCEPTOS  >',;
		   '03<IMPRIMIR POR GRUPOS     >',;
		   '04<TOTAL PAGOS POR GRUPOS  >'}

       aAyuda := {'Imprime los Movimientos Cr‚ditos y D‚bitos por Cuentas del PUC',;
		  'Imprime los Movimientos Cr‚ditos y D‚bitos por Conceptos',;
		  'Imprime los Movimientos por grupo',;
		  'Imprime el total de Movimientos por grupos'}

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,09,25,'CONTABILIDAD',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU
/*
*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Mn1Ext011(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse)
	   *Impresi¢n de Movimientos por Cuentas del Puc

       CASE nNroOpc == 2
	    Mn1Ext022(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse)
	   *Impresi¢n de Movimientos por Conceptos

       CASE nNroOpc == 3
	    Mn1Ext033(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse)
	   *Movimientos por grupos.

       CASE nNroOpc == 4
	    Mn1Ext044(aParam1,aParam2,aParam3,;
		      cNroMes,oBrowse)
	   *Total Movimientos por Grupos.
       ENDCASE
*/
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA


/*************************************************************************
* TITULO..: LEER EL EXTRACTO ACUMULADO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 15/2000 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   NOV 15/2000 MIE

OBJETIVOS:

1- Appendiza todos los extractos acumulados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeExtAcu(lShared,nModCry,cNomSis,cAnoUsr,cPatSis,cNroMes,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL cMesExt := ''                  // Mes del Extracto
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO DEL ESTRACTO
       cSavPan := SAVESCREEN(0,0,24,79)

       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile

       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,nModCry)
       CreaDbfExt(lShared,0,cPatSis+'\MODEM\'+BAN->cCodigoBan,FileMoB)
      *Creaci¢n de archivo del extracto
*>>>>FIN CREACION DEL ARCHIVO DEL ESTRACTO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			 FileMoB,'TRA',NIL,lShared,0})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO ACUMULADO DEL EXTRACTO')
	  CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,0)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DEL ARCHIVO DEL EXTRACTO
       Termometro(0,'ACUMULADO EXTRACTOS')
       FOR i := 1 TO 12

***********PREPARACION DEL ARCHIVO
	     cMesExt := STR(i,2)
	     lCorrecion(@cMesExt)
	     FileTem := cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			BAN->cCodigoBan+cAnoUsr+cMesExt+ExtFile
***********FIN PREPARACION DEL ARCHIVO

***********VALIDACION Y APPEND DEL ARCHIVO
	     IF FILE(FileTem)

*---------------DESPROTECION DEL ARCHIVO
		  IF nModCry # 0 .AND.;
		     nHayProtec(FileTem) == 1   // SI Protegida
		     Proteger(FileTem,nModCry)  // Desprotege el Archivo
		  ENDIF
*---------------FIN DESPROTECION DEL ARCHIVO

*---------------IMPRESION DE LA LINEA DE ESTADO
		  LineaEstado('ACUMULADO EL EXTRACTO '+;
			      'DEL MES DE: '+cMes(i,10),cNomSis)
*---------------FIN IMPRESION DE LA LINEA DE ESTADO

*---------------COPIA DE LOS REGISTRO DEL ARCHIVO DE EXTRACTO
		  APPEND FROM &FileTem
		  Termometro(i*100/12)
*---------------FIN COPIA DE LOS REGISTRO DEL ARCHIVO DE EXTRACTO

	     ENDIF
***********FIN VALIDACION Y APPEND DEL ARCHIVO

       NEXT
       Termometro(100)
       SELECT TRA
/*
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
*/
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CONVERSION DEL ARCHIVO ASCII

/*************************************************************************
* TITULO..: DISCRIMINACION CONCEPTOS DE LA MATRICULA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2005 MIE A
       Bucaramanga, Colombia        INICIO: 03:00 PM   DIC 06/2005 MIE

OBJETIVOS:

1- Descrimina el valor de los conceptos facturados de la matricula de acuerdo
   al valor especificado.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ConMtrExt(nVlrDiv,aVlrCon,AliaPag,AliaCon,lSumar)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDiv                              // @Valor a Discriminar
       aVlrCon                              // @Valor de los Conceptos
       AliaPag			            // Alias del Pago
       AliaCon                              // Alias del Concepto
       lSumar                               // .T. Sumar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DEL VALOR
       lSumar := IF(lSumar == NIL,.T.,lSumar)
       FOR i := 1 TO LEN(ALLTRIM(&AliaPag->cConcepPag))/2

***********LOCALIZACION DEL CONCEPTO
	     cCodigoTco := SUBS(&AliaPag->cConcepPag,i*2-1,2)
	     lLocCodigo('cCodigoCon',AliaCon,cCodigoTco)

	     nVlrCon := nVlrConPag(cCodigoTco,AliaPag)
	    *Valor del Concepto
***********FIN LOCALIZACION DEL CONCEPTO

***********SUMA DEL CONCEPTO DESCRIMINADO
	     IF nVlrCon # 0

*---------------RESTA DEL VALOR DESCRIMINADO
		  IF nVlrCon <= nVlrDiv
		     nVlrDiv -= nVlrCon
		  ELSE
		     nVlrCon := nVlrDiv
		     nVlrDiv := 0
		  ENDIF
		  VlrCon(cCodigoTco,&AliaCon->cNombreCon,;
			 nVlrCon,aVlrCon,lSumar)
*---------------FIN RESTA DEL VALOR DESCRIMINADO

	     ENDIF
***********FIN SUMA DEL CONCEPTO DESCRIMINADO

***********ANALISIS DE DECISION
	     IF nVlrDiv == 0
		EXIT
	     ENDIF
***********FIN ANALISIS DE DECISION

       ENDFOR
       RETURN NIL
*>>>>FIN DESCRIMINACION DEL VALOR

/*************************************************************************
* TITULO..: DISCRIMINACION CONCEPTOS DEL RECIBO DE PAGO. EXTRACTO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/2008 MIE A
       Bucaramanga, Colombia        INICIO: 09:00 AM   MAY 07/2008 MIE

OBJETIVOS:

1- Descrimina el valor de los conceptos pagados del recibo del extracto.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ConRecExt(nVlrDiv,aVlrCon,AliaPag,AliaCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDiv                              // @Valor a Discriminar
       aVlrCon                              // @Valor de los Conceptos
       AliaPag			            // Alias del Pago
       AliaCon                              // Alias del Concepto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DEL VALOR
       FOR i := 1 TO LEN(ALLTRIM(&AliaPag->cConcepPag))/2

***********LOCALIZACION DEL CONCEPTO
	     cCodigoTco := SUBS(&AliaPag->cConcepPag,i*2-1,2)
	     lLocCodigo('cCodigoCon',AliaCon,cCodigoTco)

	     nVlrCon := nVlrConPag(cCodigoTco,AliaPag)
	    *Valor del Concepto
***********FIN LOCALIZACION DEL CONCEPTO

***********SUMA DEL CONCEPTO DESCRIMINADO
	     IF nVlrCon # 0

*---------------RESTA DEL VALOR DESCRIMINADO
		  IF nVlrCon <= nVlrDiv
		     nVlrDiv -= nVlrCon
		  ELSE
		     nVlrCon := nVlrDiv
		     nVlrDiv := 0
		  ENDIF
		  VlrCon(cCodigoTco,&AliaCon->cNombreCon,nVlrCon,aVlrCon)
*---------------FIN RESTA DEL VALOR DESCRIMINADO

	     ENDIF
***********FIN SUMA DEL CONCEPTO DESCRIMINADO

***********ANALISIS DE DECISION
	     IF nVlrDiv == 0
		EXIT
	     ENDIF
***********FIN ANALISIS DE DECISION

       ENDFOR
       RETURN NIL
*>>>>FIN DESCRIMINACION DEL VALOR

/*************************************************************************
* TITULO..: DESCRIMINACION CONCEPTOS DEL ABONO. EXTRACTO                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/2008 JUE A
       Bucaramanga, Colombia        INICIO: 08:00 AM   MAY 15/2008 JUE

OBJETIVOS:

1- Descrimina el valor de los conceptos pagados del abono del extracto.

2- Debe estar ubicado en el registro del abono en descuentos y en pagos
   en el mes del abono

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ConAboExt(aVlrCon,lSiCert)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL       i := 0                   // Indice de los pagos
       LOCAL nSdoAnt := 0                   // Saldo Anterior
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nIntMes := 0                   // Valor Intereses del Mes
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL aRegPag := {}                  // Registro de Pagos

       LOCAL nDeuAbo := 0                   // Valor de la Deuda Abonada
       LOCAL nMorAnt := 0                   // Valor de la Mora Abonada
       LOCAL nMorMes := 0                   // Mora del Mes
       LOCAL nVlrRec := 0                   // Valor Recargos
       LOCAL nMesRec := 0                   // Mes del Recargo
       LOCAL nRegDes := 0                   // Registro del Descuento
       LOCAL lAboOpo := .T.                 // .T. Abono Oportuno
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL cEstado := ''                  // Estado de Pago
       LOCAL nIntMor := 0                   // Porcentaje de la Mora
       LOCAL nMesInt := 0                   // Mes del Interes

       LOCAL aDetPag := {}                  // Detalles de los pagos
       LOCAL aPagAbo := {}                  // Calculos de los Abonos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REGISTROS DE LOS PAGOS
       nRegAct := PAG->(RECNO())
       aRegPag := aRegPagos(PAG->cCodigoEst)
       PAG->(DBGOTO(nRegAct))
       i := ASCAN(aRegPag,{|aArray| aArray == nRegAct})
*>>>>FIN REGISTROS DE LOS PAGOS

*>>>>INICIALIZACION DE LOS DETALLES DE PAGO
       AADD(aDetPag,{0,0,0,0,'',0})
       AADD(aDetPag,{0,0,0,0,'',0})
      *1- Mes Inicial de Pago,
      *2- Deuda Anterior despu‚s de Abono,
      *3- Mora Anterior despu‚s de Abono
      *4- Valor del Mes
      *5- Por Pagar
      *6- Estado de Pago
      *7- Registro de pagos
*>>>>FIN INICIALIZACION DE LOS DETALLES DE PAGO

*>>>>LOCALIZACION DEL PAGO MES DEL ABONO
       lHayPag := lLocCodPag(DES->cCodigoEst,DES->nNroMesDes,.F.)
       IF lHayPag

	  nRegPag := PAG->(RECNO())
	  nIntMor := PAG->nIntMorPag
	  nMesInt := PAG->nMesIniPag
	  cEstado := PAG->cEstadoPag

	  IF DES->dFechaDes <= PAG->dPagExtPag
	     aDetPag[2,1] := DES->nNroMesDes
	     aDetPag[2,2] := DES->nSdoAntPag
	     aDetPag[2,3] := DES->nMorAntPag
	     aDetPag[2,4] := DES->nVlrMesPag
	     aDetPag[2,5] := cEstado
	     aDetPag[2,6] := nRegPag
		  lAboOpo := .T.
	  ELSE
	     aDetPag[2,1] := DES->nNroMesDes
	     aDetPag[2,2] := DES->nSdoAntPag+DES->nVlrMesPag
	     aDetPag[2,3] := DES->nMorAntPag+;
			     nVlrInt(DES->nSdoAntPag+DES->nVlrMesPag)
		  lAboOpo := .F.
	  ENDIF
       ELSE
	  RETURN !lHayErr
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO MES DEL ABONO

*>>>>LOCALIZACION DEL PAGO MES MODIFICADO
       IF lHayPag .AND. lLocCodPag(DES->cCodigoEst,;
				   IF(DES->nMesModDes==0,;
				      DES->nNroMesDes,;
				      DES->nMesModDes),.F.)

	  IF lAboOpo
	     aDetPag[1,1] := DES->nMesModDes
	     aDetPag[1,2] := DES->nSdoAntDes
	     aDetPag[1,3] := DES->nMorAntDes
	     aDetPag[1,4] := DES->nVlrMesDes
	     aDetPag[1,5] := PAG->cEstadoPag
	     aDetPag[1,6] := PAG->(RECNO())
	  ELSE
	     aDetPag[1,1] := DES->nNroMesDes
	     aDetPag[1,2] := DES->nSdoAntPag
	     aDetPag[1,3] := DES->nMorAntPag
	     aDetPag[1,4] := DES->nVlrMesPag
	     aDetPag[1,5] := cEstado
	     aDetPag[1,6] := nRegPag
	  ENDIF
       ELSE
	  lHayPag := .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO MES MODIFICADO

*>>>>APLICACION DEL ABONO
       IF !lHayPag .OR. !lAbonos(1,DES->dFechaDes,DES->nValorDes,2,;
				 aDetPag,@aPagAbo)
	  RETURN !lHayErr
       ENDIF
*>>>>FIN APLICACION DEL ABONO

*>>>>DESCRIMINACION DE LA DEUDA
       nDeuAbo := aDetPag[2,2] - aPagAbo[3,1]
       nMorAnt := aDetPag[2,3] - aPagAbo[3,2]

       IF lAboOpo
	  i--  // Se ubica en el mes Anterior
       ELSE
	  PAG->(DBGOTO(nRegPag))
	  nMorMes := nVlrInt(nDeuAbo)
	  nMorAnt -= nMorMes
       ENDIF
*>>>>FIN DESCRIMINACION DE LA DEUDA

*>>>>ANALISIS DE DECISION
       IF DES->nValorDes # nDeuAbo+nMorAnt+nMorMes
	  RETURN !lHayErr
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>DESCRIMINACION DE LOS INTESESES ANTERIORES
       lSiCert := IF(lSiCert==NIL,.F.,lSiCert)
       IF nMorAnt # 0
	  IF lSiCert
	     VlrCon('INT',;
		    SUBS('INTERESES'+SPACE(16),1,16),;
		    nMorAnt,;
		    aVlrCon)
	  ELSE
	     VlrCon('ANT',;
		    SUBS('INT PAGO ANT'+SPACE(16),1,16),;
		    nMorAnt,;
		    aVlrCon)
	  ENDIF
       ENDIF
*>>>>FIN DESCRIMINACION DE LOS INTESESES ANTERIORES

*>>>>DESCRIMINACION DE LOS INTESESES DEL MES
       IF nMorMes # 0
	  VlrCon('INT',;
		 SUBS('INT PAGO '+cMes(nMesInt,3)+SPACE(16),1,16),;
		 nMorMes,;
		 aVlrCon)
       ENDIF
*>>>>FIN DESCRIMINACION DE LOS INTESESES DEL MES

*>>>>DESCRIMINACION DEL ABONO
       IF nDeuAbo # 0
	  DO WHILE nDeuAbo > 0

*------------DESCRIMINACION DE LOS CONCEPTOS DEL MES
	       lHayErr := !lDbGoTo('PAG',aRegPag,i)

	       nMesRec := PAG->nMesIniPag
	       nVlrRec := PAG->nVlrRecPag
	       nDeuAbo -= nVlrRec
	       VlrConPag(@nDeuAbo,aVlrCon,lSiCert)
	       i--     // Se ubica en el mes Anterior
*------------FIN DESCRIMINACION DE LOS CONCEPTOS DEL MES

*------------DESCRIMINACION DEL RECARGO
	       IF nVlrRec # 0

		  nRegDes := DES->(RECNO())
		  IF (lSekCodDes(PAG->cCodigoEst,nMesRec,.F.) .AND.;
				  DES->nTipDesDes == 2) .AND.;
				  DES->nValorDes == nVlrRec     // Recargo
		     VlrConDes(nVlrRec,aVlrCon,lSiCert)
		  ELSE
		     VlrCon('REC',;
			    SUBS('ERROR EN RECARGO'+SPACE(16),1,16),;
			    nVlrRec,;
			    aVlrCon)
		  ENDIF
		  DES->(DBGOTO(nRegDes))
	       ENDIF
*------------FIN DESCRIMINACION DEL RECARGO

	  ENDDO
	  PAG->(DBGOTO(nRegAct))
       ENDIF
       RETURN !lHayErr
*>>>>FIN DESCRIMINACION DEL ABONO

/*************************************************************************
* TITULO..: DISMINUCION DEL VALOR DE LOS CONCEPTOS                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2008 MIE A
       Bucaramanga, Colombia        INICIO: 03:00 PM   MAY 21/2008 MIE

OBJETIVOS:

1- Permite restar un valor a los conceptos descriminado

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RestarCon(aVlrCon,nValor,lVlrCre)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos
       nValor                               // Valor a Disminuir
       lVlrCre                              // .T. Valor Credito .F. Valor debito */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nVlrDes := 0                   // Valor a Descontar
       LOCAL cConcep := ''                  // Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RESTAR DE LOS CONCEPTOS
	nValor := ABS(nValor)
       lVlrCre := IF(lVlrCre == NIL,.T.,lVlrCre)
       FOR i := LEN(aVlrCon) TO 1 STEP -1

	   nVlrCon := aVlrCon[i,IF(lVlrCre,3,4)]

	   IF nValor <= nVlrCon
	      nVlrDes := nValor
	       nValor -= nVlrDes
	      nVlrCon -= nVlrDes
	   ELSE
	      nVlrDes := nVlrCon
	       nValor -= nVlrDes
	      nVlrCon := 0
	   ENDIF

	   aVlrCon[i,IF(lVlrCre,3,4)] := nVlrCon

       ENDFOR
       RETURN NIL
*>>>>FIN RESTAR DE LOS CONCEPTOS


/*************************************************************************
* TITULO..: VALIDACION DE LA TRANSACION                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 03/2013 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   DIC 03/2013 MAR

OBJETIVOS:

1- Valida la transacion respecto a al pago que figura en el sistema.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValPagExt(lShared,nVlrPag,nVlrInt,dFecPag)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nVlrPag                              // Valor en pagos
       nVlrInt                              // Valor Intereses
       dFecPag                              // Fecha de pago */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrDif := 0                   // Valor de la diferencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONCILIACION DEL PAGO
       nVlrDif := ABS(EXT->nValorTra - (nVlrPag+nVlrInt))
*>>>>FIN CONCILIACION DEL PAGO

*>>>>GRABACION DEL REGISTRO
       IF EXT->(lRegLock(lShared,.F.))

	  REPL EXT->nVlrPagPag  WITH nVlrPag
	  REPL EXT->nVlrIntPag  WITH nVlrInt
	  REPL EXT->dFecPagPag  WITH dFecPag

	  REPL EXT->nVlrDifTra  WITH nVlrDif


	  EXT->(DBCOMMIT())

       ENDIF

       IF lShared
	  EXT->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: LEER EL EXTRACTO ACUMULADO DIARIO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2016 LUN A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 26/2016 LUN

OBJETIVOS:

1- Appendiza todos los movimientos diarios equivalentes al estracto.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeExtDia(lShared,nModCry,cNomSis,cAnoUsr,cPatSis,cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL cNroDia := ''                  // N£mero del d¡a
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO DEL ESTRACTO
       cSavPan := SAVESCREEN(0,0,24,79)

       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile
       FileTmv := FileTmv+BAN->cCodigoBan+ExtFile
       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile

       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,nModCry)
       CreaDbfExt(lShared,0,cPatSis+'\MODEM\'+BAN->cCodigoBan,FileMoB)
      *Creaci¢n de archivo del extracto
*>>>>FIN CREACION DEL ARCHIVO DEL ESTRACTO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTmv,'TMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			 FileMoB,'TRA',NIL,lShared,0})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO DEL EXTRACTO')
	  CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,0)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DEL ARCHIVO DEL EXTRACTO
       Termometro(0,'ACUMULANDO EL EXTRACTO')
       FOR i := 1 TO 31

***********PREPARACION DEL ARCHIVO
	     cNroDia := STR(i,2)
	     lCorrecion(@cNroDia)
	     FileTem := cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			cAnoUsr+cNroMes+cNroDia+ExtFile
***********FIN PREPARACION DEL ARCHIVO

***********VALIDACION Y APPEND DEL ARCHIVO
	     IF FILE(FileTem)

*---------------DESPROTECION DEL ARCHIVO
		  IF nModCry # 0 .AND.;
		     nHayProtec(FileTem) == 1   // SI Protegida
		     Proteger(FileTem,nModCry)  // Desprotege el Archivo
		  ENDIF
*---------------FIN DESPROTECION DEL ARCHIVO

*---------------IMPRESION DE LA LINEA DE ESTADO
		  LineaEstado('ACUMULANDO EL EXTRACTO '+;
			      'DEL DIA: '+STR(i,2),cNomSis)
*---------------FIN IMPRESION DE LA LINEA DE ESTADO

*---------------LECTURA DEL ARCHIVO DIARIO
		  LeeArcDia(lShared,nModCry,FileTem,cNroMes)

		  Termometro(i*100/31)
*---------------FIN LECTURA DEL ARCHIVO DIARIO

	     ENDIF
***********FIN VALIDACION Y APPEND DEL ARCHIVO

       NEXT
       Termometro(100)
       SELECT TRA

/*
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
*/
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CONVERSION DEL ARCHIVO ASCII