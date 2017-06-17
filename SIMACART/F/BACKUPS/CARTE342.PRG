/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : CONSULTAS
SUBMODULO...: PAGOS ESTUDIANTES

**************************************************************************
* TITULO..: ESTADO DE CUENTA POR GRUPOS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 11:30 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Imprime el Estado de Cuenta del Estudiante por grupos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_342(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial

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
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
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

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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

*>>>>PREGUNTA DE DECISION
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  cError('NO SE IMPRIME. DECIDIO NO CONTINUAR')
	  RETURN NIL
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0
       aCabeza := {cNomEmp,cNomSis,;
		   'ESTADO DE CUENTA. A¥O: '+cAnoUsr+'.JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {08,12,12,12,12,06,12,12,12,12,12}
       aTitulo := {'MES',;
		   'DEUDA ANT',;
		   'MORA ANT',;
		   'VALOR MES',;
		   'VLR A PAGAR',;
		   'ESTADO',;
		   'F.DE PAGO',;
		   'VLR PAGADO',;
		   'SDO ACTUAL',;
		   'FECHA OPO',;
		   'FECHA EXT'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ESTADOS DE CUENTA
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

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
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
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
		       CloseDbf('PAG',FilePag,nModCry)
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
		 IF !lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias,.F.)

		    SET DEVICE TO SCREEN
		    cError('EL CODIGO:' +CLI->cCodigoEst+' NO EXISTE '+;
			   'EN CLIENTES DEL GRUPO '+GRU->cCodigoGru)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF
		 cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			       RTRIM(&cNalias->cNombreEst)
		 IF &cNalias->lRetiroEst
		    cNombreTes += '. SE RETIRO EN '+;
				  cFecha(&cNalias->dFecRetEst)+' '+;
				  'ULTIMO MES A FACTURAR .'+;
				  cMes(&cNalias->nUltRecEst,3)
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------VERIFICACION DEL GRUPO
		 IF &cNalias->cCodigoGru # GRU->cCodigoGru .AND.;
		    !(CLI->lRetGruCli)

		    SET DEVICE TO SCREEN
		    cError('CLIENTE DEL GRUPO: '+GRU->cCodigoGru+;
			   ' PERTENECE AL GRUPO: '+&cNalias->cCodigoGru,;
			    cNombreTes+' CODIGO: '+&cNalias->cCodigoEst,;
			   'POR FAVOR EJECUTE LA OPCION DE ACTUALIZAR')
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VERIFICACION DEL GRUPO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('ºGRUPO: '+GRU->cCodigoGru+;
			     'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------FILTRACION DE LOS PAGOS
		 SELECT PAG
		 SET FILTER TO PAG->cCodigoEst == CLI->cCodigoEst
		 PAG->(DBGOTOP())
		 IF PAG->(EOF())
		    SET FILTER TO
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN FILTRACION DE LOS PAGOS

*--------------IMPRESION DE LOS DATOS DEL ESTUDIANTE
		 cTxtPrn := 'CODIGO:'+CLI->cCodigoEst+' '+;
			     cNombreTes+' '+;
			     'GRUPO: '+&cNalias->cCodigoGru+'-'+;
			     STR(CLI->(RECNO()),2)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------IMPRESION DE LOS DATOS DEL ESTUDIANTE

*--------------IMPRESION DEL ESTADO DE CUENTA
		 IF !lPrnBodCta(CLI->cCodigoEst,aNroCol,nColCab,bPagina,;
			      bDerAut,bCabeza)

		    lPrnReg(01,nColCab,'ERROR FAVOR REVISAR',;
			    bPagina,bDerAut,bCabeza)
		 ENDIF
		 SELECT PAG
		 SET FILTER TO
*--------------FIN IMPRESION DEL ESTADO DE CUENTA

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
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
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LOS ESTADOS DE CUENTA
