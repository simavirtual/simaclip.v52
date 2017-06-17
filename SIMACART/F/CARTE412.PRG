/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: ESTUDIANTES MOROSOS    MODULO No. 413

**************************************************************************
* TITULO DEL PROGRAMA..: CARTA PARA LOS ESTUDIANTES                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 10/2001 MAR A
       Bucaramanga, Colombia	    INICIO: 11:15 AM   JUL 10/2001 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir las cartas para los Estudiantes seg£n su evaluaci¢n

2- Permite la impresi¢n de acuerdo a dos formatos de cartas.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_412(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroCar := 1                   // N£mero de la Carta
       LOCAL cNroCar := ''                  // N£mero de la Carta
       LOCAL cTipMor := ''                  // Tipo de Moroso
       LOCAL cNotMor := ''                  // Nota del Moroso
       LOCAL lAllCar := .T.                 // .T. Imprime todas las Cartas
       LOCAL lAllEst := .F.                 // .T. Todos los Estudiantes

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nRegPag := 0                   // Registro del pago

       LOCAL cNomFac := ''                  // Nombre de la Factura
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nNroCla := 0                   // N£mero de Clasificaci¢n
       LOCAL lPrnCla := .F.                 // .T. Imprimir Clasificados
       LOCAL lPrnCar := .F.                 // Imprimir la Carta
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda

       LOCAL cNombreTes := ''               // Nombre del Estudiante
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

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>SELECCION DE TIPO DE MOROSO
       TitBuscar(10,@nNroFil,@nNroCol,,'EVALUACION')
       cTipMor := cLeeTipMor(nNroFil,nNroCol,nNroFil+2,nNroCol-2,'EBARID')
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cTipMor)
	  lAllEst := lPregunta('DESEA IMPRIMIR LAS CARTAS '+;
			       'PARA TODOS LOS ESTUDIANTES? Si No')
	  IF .NOT. lAllEst
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE TIPO DE MOROSO

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       SET CURSOR ON
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','CARTA MODELO')
       @ nNroFil,nNroCol GET nNroCar PICT '999'
       READ
       IF EMPTY(nNroCar)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroCar := STR(nNroCar,3)
       lCorrecion(@cNroCar)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>EDICION DE LA CARTA MODELO
       cTxtHlp := 'Inserte el texto: (FECHA) => '+;
		   'para incluir la Fecha del Sistema'+;
		   CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (PADRE) => '+;
		    'para incluir el nombre del padre'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (MADRE) => '+;
		    'para incluir el nombre de la madre'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (ACUDIENTE) => '+;
		    'para incluir el nombre del acudiente'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (NOMFAC) => '+;
		    'para incluir el nombre que se imprime en el Recibo'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (DIRECCION) => '+;
		    'para incluir la Direcci¢n de los Padres'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (ESTUDIANTE) => '+;
		    'para incluir el nombre del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (CODIGO) => '+;
		    'para incluir el c¢digo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (GRUPO) => '+;
		    'para incluir el grupo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: (DEUDA)  => '+;
		    'para incluir la deuda del grupo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)

       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'

       EditFile(cNomSis,"Bases\Carta"+cNroCar+'.Est',;
			 "Edite el Texto de la Carta No. "+cNroCar,;
			 cTxtHlp,cTitHlp)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN EDICION DE LA CARTA MODELO

*>>>>LECTURA DE LA CLASIFICACION DE LOS ESTUDIANTES
       lPrnCla := lPregunta('DESEA IMPRIMIR LAS CARTAS PARA '+;
			    'ESTUDIANTES CLASIFICADOS? No Si')
       IF lPrnCla
	  @nFilInf+7,nColInf SAY 'CLASIFICACION' GET nNroCla PICT '99'
	  READ
       ENDIF
*>>>>FIN LECTURA DE LA CLASIFICACION DE LOS ESTUDIANTES

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA IMPRIMIR LAS CARTAS? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       lAllCar := !lPregunta('DESEA IMPRIMIR UNA CARTA DE MUESTRA? No Si')
       RESTSCREEN(0,0,24,79,cSavPan)

       IF !Printer_On()
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO '+IF(lAllCar,'LAS CARTAS','LA CARTA'))
       Termometro(10)
       SET DEVICE TO PRINT
       SendCodes(INICIALIZA)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS RECIBOS DE PAGO
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT GRU
	       SKIP
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LOS RECIBOS DE PAGO DEL GRUPO
	    SELECT CLI
	    GO nNroIni
	    DO WHILE .NOT. CLI->(EOF())

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT CLI
		 IF nNroFin <> 0
		    IF CLI->(RECNO()) > nNroFin
		       SET DEVICE TO SCREEN
		       CloseDbf('CLI',FileCli,nModCry)
		       CloseAll(aUseDbf)
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodMae(CLI->cCodigoEst,cMaeAct,@cMaeAct,.F.)

		    SET DEVICE TO SCREEN
		    cError('EL CODIGO:' +CLI->cCodigoEst+' NO EXISTE '+;
			   'EN CLIENTES DEL GRUPO '+GRU->cCodigoGru)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF
		 cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			       RTRIM(&cMaeAct->cApelliEst)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF &cMaeAct->lRetiroEst
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------VERIFICACION DEL GRUPO
		 IF &cMaeAct->cCodigoGru # GRU->cCodigoGru .AND.;
		    !(CLI->lRetGruCli)

		    SET DEVICE TO SCREEN
		    cError('CLIENTE DEL GRUPO: '+GRU->cCodigoGru+;
			   ' PERTENECE AL GRUPO: '+&cMaeAct->cCodigoGru,;
			    cNombreTes+' CODIGO: '+&cMaeAct->cCodigoEst,;
			   'POR FAVOR EJECUTE LA OPCION DE ACTUALIZAR')
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VERIFICACION DEL GRUPO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+;
			     'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			     'ºNo. '+STR(CLI->(RECCOUNT()),2)+'/'+;
				     STR(CLI->(RECNO()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DEL TIPO DE MOROSO
		 cNotMor := cNotaCli(&cMaeAct->cCodigoEst,;
				     &cMaeAct->cCodigoGru,;
				     ALLTRIM(CAA->cConPenCaA)+;
				     ALLTRIM(&cMaeAct->cConcepEst),;
				     CLI->nSdoActCli+CLI->nSdoMorCli,;
				     TipoMora(CLI->cMesPagCli),;
				     CLI->cMesPagCli)
*--------------FIN ANALISIS DEL TIPO DE MOROSO

*--------------CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA
		 cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)

		 aMezcla := {{'(FECHA)'     ,cFecha(DATE(),10)},;
			     {'(PADRE)'     ,&cMaeAct->cNomPadEst},;
			     {'(MADRE)'     ,&cMaeAct->cNomMadEst},;
			     {'(ACUDIENTE)' ,&cMaeAct->cNomAcuEst},;
			     {'(NOMFAC)'    ,cNomFac},;
			     {'(DIRECCION)' ,ALLTRIM(&cMaeAct->cDireccEst)+' '+;
					     ALLTRIM(&cMaeAct->cBarrioEst)},;
			     {'(ESTUDIANTE)',cNombreTes},;
			     {'(CODIGO)'    ,CLI->cCodigoEst},;
			     {'(GRUPO)'     ,&cMaeAct->cCodigoGru},;
			     {'(DEUDA)',;
			       ALLTRIM(TRANS(CLI->nSdoActCli+;
					     CLI->nSdoMorCli,;
					     '$#,###,###.##'))}}
*--------------FIN CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA

*--------------IMPRESION DE LA CARTA
		 lPrnCar := .F.
		 DO CASE
		 CASE !lAllEst .AND. lPrnCla .AND.;
		      nNroCla == &cMaeAct->nMorosoEst
		      lPrnCar := .T.

		 CASE !lAllEst .AND. !lPrnCla .AND. cNotMor $ cTipMor
		      lPrnCar := .T.

		 CASE lAllEst
		      lPrnCar := .T.
		 ENDCASE

		 IF lPrnCar
		    PrnFileTxt("Bases\Carta"+cNroCar+'.Est',aMezcla)
		 ENDIF

		 IF .NOT. lAllCar
		    EXIT
		 ENDIF
*--------------FIN IMPRESION DE LA CARTA

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DE LOS RECIBOS DE PAGO DEL GRUPO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    nNroIni := 1

	    SELECT GRU
	    SKIP

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS RECIBOS DE PAGO
