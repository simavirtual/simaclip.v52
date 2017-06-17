/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INCONSISTENCIAS.
SUBMODULO...: ESTADOS DE CUENTA

**************************************************************************
* TITULO..: ESTUDIANTES DEUDORES                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 16/2007 VIE A
       Bucaramanga, Colombia	    INICIO: 02:45 PM   MAR 16/2007 VIE

OBJETIVOS:

1- Permite imprimir los estudiantes con estado deudor.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_264(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀVariables Gestion Documental

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
       LOCAL lPrnCab := .F.                 // .T. Imprimir el Encabezado
     *ÀVariables de informe

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nGruIni := 0                   // Registro inicial del grupo
       LOCAL nGruFin := 0                   // Registro Final del grupo
       LOCAL aErrCta := {}                  // Errores del Estado de Cuenta
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL cCodAct := 0                   // C¢digo Actual
       LOCAL lRegIni := .T.                 // .T. Control de flujo

       LOCAL GetList := {}                  // Variable del sistema
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
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
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

       CASE SCA->(RECCOUNT()) == 0
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
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 264
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<PAGOS><INCONSISTENCIAS><DEUDORES>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')   // T¡tulo Uno
       AADD(aTitIso,'ESTUDIANTES CON ESTADO DEUDORES')     // T¡tulo Dos
       AADD(aTitIso,'')                                    // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCA->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Seleccione el Mes',.T.)
       RESTORE SCREEN
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nGruIni,@nGruFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Deudores'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.,bInsIso)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,60}
       aTitPrn := {'CODIGO','GRUPO','NOMBRE','OBSERVACION'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
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
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>VALIDACION DE LOS ESTADOS DE CUENTA
       SET DEVICE TO SCREEN
       aErrCta := aValDeudor(lShared,nModCry,cNomSis,cAnoUsr,cMaeAct,;
			     nGruIni,nGruFin,cPatSis,nMesIni)
       SET DEVICE TO PRINT
*>>>>FIN VALIDACION DE LOS ESTADOS DE CUENTA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       FOR i := 1 TO LEN(aErrCta)

***********IMPRESION DEL ENCABEZADO
	     IF .NOT. lPrnCab

		SendCodes(PCL('Reset'))

		EVAL(bCabeza)
	       *Impresi¢n del Encabezado

		AADD(aCabPrn,cFecPrn)
		AADD(aCabPrn,cHorPrn)
		AADD(aCabPrn,cDiaPrn)

		nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,;
				      aCabPrn,aTitPrn)
		lPrnCab := .T.
	     ENDIF
***********FIN IMPRESION DEL ENCABEZADO

***********LINEA DE ESTADO
	     SET DEVICE TO SCREEN
	     LineaEstado('IMPRIMIENDO:'+;
			 'ºRegistro. '+STR(i,4)+'/'+;
			 STR(LEN(aErrCta),4),cNomSis)
	     SET DEVICE TO PRINT
***********FIN LINEA DE ESTADO

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    FOR j := 1 TO LEN(aErrCta[i])

*===============PREPARACION DEL REGISTRO
		  cCodAct := aErrCta[i,1]
		  IF lRegIni

*--------------------REGISTRO INICIAL
		       AADD(aRegPrn,;
			    SUBS(aErrCta[i,j]+;
				 SPACE(aNroCol[j]),1,aNroCol[j]))
		       cCodAnt := cCodAct
*--------------------FIN REGISTRO INICIAL

		  ELSE

*--------------------REGISTRO REPETIDO
		       IF j == LEN(aErrCta[i])
			  AADD(aRegPrn,;
			       SUBS(aErrCta[i,j]+;
				    SPACE(aNroCol[j]),1,aNroCol[j]))
		       ELSE
			  AADD(aRegPrn,'')
		       ENDIF
*--------------------FIN REGISTRO REPETIDO

		  ENDIF
*===============FIN PREPARACION DEL REGISTRO

	    ENDFOR
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

       ENDFOR
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF lPrnCab
	  EVAL(bDerAut)
	 *Derechos de Autor
	  EJECT

	  VerPrn(nOpcPrn,FilePrn,nHanXml)
	  SET DEVICE TO SCREEN
       ELSE
	  SET DEVICE TO SCREEN
	  cError('ESTADOS DE CUENTA SIN PROBLEMAS')
       ENDIF
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALIDAR LOS ESTUDIANTES DEUDORES                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 14/2007 JUE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   JUN 14/2007 JUE

OBJETIVOS:

1- Valida el £ltimo recibo para verificar si el estudiante se encuentra
   en estado deudor.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aValDeudor(lShared,nModCry,cNomSis,cAnoUsr,cMaeAlu,nGruIni,nGruFin,;
		    cPatCar,nMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros habilitados
       nGruIni                              // Registo inicial del Grupo
       nGruFin                              // Grupo Final del Grupo
       cPatCar                              // Path de la Cartera
       nMesIni                              // Mes Inicial */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL aErrCta := {}                  // Errores del Estado de Cuenta
       LOCAL aMsgErr := {}                  // Estudiantes con errores
       LOCAL aRegPag := {}                  // Registro de Pagos

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nGruIni))
       DO WHILE GRU->(RECNO()) <= nGruFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatCar+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatCar+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       cMsgErr := 'ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS.'+;
			  'GRUPO:'+GRU->cCodigoGru

	       AADD(aMsgErr,{'','','',cMsgErr})

	       CloseDbf('CLI')
	       CloseDbf('PAG')

	       SELECT GRU
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR GRUPOS
	    SELECT CLI
	    CLI->(DBGOTOP())
	    DO WHILE .NOT. CLI->(EOF())

*--------------LINEA DE ESTADO
		 LineaEstado('ºCODIGO: '+GRU->cCodigoGru+;
			     'ºGRUPO : '+CLI->cCodigoEst+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
*--------------FIN LINEA DE ESTADO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)

		    cMsgErr := 'NO EXISTE EN EL ARCHIVO DE ALUMNOS'
		    AADD(aMsgErr,{CLI->cCodigoEst,GRU->cCodigoGru,;
				  '',cMsgErr})

		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF

		 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------VERIFICACION DEL GRUPO
		 IF &cMaeAct->cCodigoGru # GRU->cCodigoGru .AND.;
		    !(CLI->lRetGruCli)

		    cMsgErr := 'PERTENECE AL GRUPO: '+&cMaeAct->cCodigoGru
		    AADD(aMsgErr,{CLI->cCodigoEst,GRU->cCodigoGru,;
				  cNombreTes,cMsgErr})

		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VERIFICACION DEL GRUPO

*--------------VALIDACION DE LOS DEUDORES
		 aRegPag := aRegPagos(CLI->cCodigoEst)
		 SELECT PAG
		 SET FILTER TO
		 FOR i := 1 TO LEN(aRegPag)

		     PAG->(DBGOTO(aRegPag[i]))

*::::::::::::::::::::VALIDACION DEL MES
		       IF nMesIni # 0 .AND. PAG->nMesIniPag # nMesIni
			  LOOP
		       ENDIF
*::::::::::::::::::::FIN VALIDACION DEL MES

*::::::::::::::::::::VALIDACION DE LA FORMA DE PAGO
		       IF PAG->cEstadoPag == '*'
			  AADD(aMsgErr,{CLI->cCodigoEst,GRU->cCodigoGru,;
					cNombreTes,;
					'MES DE '+cMes(PAG->nMesIniPag)})
		       ENDIF
*::::::::::::::::::::FIN VALIDACION DE LA FORMA DE PAGO

		 ENDFOR
*--------------FIN VALIDACION DE LOS DEUDORES

	       SELECT CLI
	       CLI->(DBSKIP())

	    ENDDO
**********RECORRIDO POR GRUPOS

	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
       RETURN aMsgErr
*>>>>FIN RECORRIDO POR GRUPOS