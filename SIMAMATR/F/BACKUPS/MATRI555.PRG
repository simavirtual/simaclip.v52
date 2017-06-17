/* SIMA - MATRICULA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS POR GRUPO

**************************************************************************
* TITULO..: PAGOS POR GRUPO                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 12/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   DIC 12/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir el informe de la relaci¢n total
   de los ingresos y egresos que se efectuaron por los grupos.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_555(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"              // Impresora EPSON FX
       #INCLUDE "CAMPOS\ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL nVlrSdo := 0                   // Valor del saldo
       LOCAL nIntMor := 0                   // Intereses por mora
       LOCAL nVlrDeu := 0                   // Valor de la deuda
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrIng := 0                   // Valor de los ingresos
       LOCAL nVlrMes := 0                   // Valor de lo facturado

       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nTotMor := 0                   // Total intereses por mora
       LOCAL nTotDeu := 0                   // Total de la deuda
       LOCAL nTotPag := 0                   // Total de pagos
       LOCAL nTotInt := 0                   // Total de intereses
       LOCAL nTotIng := 0                   // Total de ingresos
       LOCAL nTotMes := 0                   // Total del Mes

       LOCAL nAluGru := 0                   // Alumnos del grupo
       LOCAL nSiPago := 0                   // Alumnos que pagaron
       LOCAL nNoPago := 0                   // Alumnos que no pagaron
       LOCAL nTotAlu := 0                   // Total de alumnos
       LOCAL nTotSiP := 0                   // Total alumnos que pagaron
       LOCAL nTotNoP := 0                   // Total alumnos que no pagaron

       LOCAL       i := 0                   // Contador
       LOCAL nMinNiv := 0                   // M¡nimo nivel
       LOCAL nMaxNiv := 0                   // M ximo nivel
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL cNivFin := ''                  // Nivel Final
       LOCAL lFechOk := .T.                 // Fecha de Acuedo al intervalo
       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas

       LOCAL cMatricTpa := ''               // '1'->Matr¡cula '0'->Pensi¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
     *ÀVariables temporales de campos

       FIELD cMatricPag                     // '1'->Matr¡cula '0'->Pensi¢n
       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀCampos de Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
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

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0101(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>CREACION TEMPORAL DE TODOS LOS NIVELES
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfNiv(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'NIV',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>GRABACION DE LOS NIVELES DE PRIMARIA
       IF 'PRI' $ cMaeAlu

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\PRI\'+;
			    FileNiv+cAnoSis+ExtFile,'FUE',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVOS')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE FUE->(RECCOUNT()) == 0
		 cError('NO ESTAN GRABADOS LOS NIVELES')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********GRABACION DE LOS NIVELES
	    DO WHILE .NOT. FUE->(EOF())

	       IF NIV->(lRegLock(lShared,.T.))
		  REPL NIV->cCodigoNiv WITH FUE->cCodigoNiv
		  REPL NIV->nNroGruNiv WITH FUE->nNroGruNiv
		  NIV->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA NIVEL')
	       ENDIF

	       IF lShared
		  NIV->(DBUNLOCK())
	       ENDIF

	       FUE->(DBSKIP())

	    ENDDO
	    CloseDbf('FUE')
**********FIN GRABACION DE LOS NIVELES

       ENDIF
*>>>>FIN GRABACION DE LOS NIVELES DE PRIMARIA

*>>>>GRABACION DE LOS NIVELES DE BACHILLERATO
       IF 'BTO' $ cMaeAlu

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\BTO\'+;
			FileNiv+cAnoSis+ExtFile,'FUE',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVOS')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE FUE->(RECCOUNT()) == 0
		 cError('NO ESTAN GRABADOS LOS NIVELES')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********GRABACION DE LOS NIVELES
	    DO WHILE .NOT. FUE->(EOF())

	       IF NIV->(lRegLock(lShared,.T.))
		  REPL NIV->cCodigoNiv WITH FUE->cCodigoNiv
		  REPL NIV->nNroGruNiv WITH FUE->nNroGruNiv
		  NIV->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA NIVEL')
	       ENDIF

	       IF lShared
		  NIV->(DBUNLOCK())
	       ENDIF

	       FUE->(DBSKIP())

	    ENDDO
	    CloseDbf('FUE')
**********FIN GRABACION DE LOS NIVELES

       ENDIF
*>>>>FIN GRABACION DE LOS NIVELES DE BACHILLERATO

*>>>>GRABACION DE LOS NIVELES DE JARDIN
       IF 'JAR' $ cMaeAlu

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\JAR\'+;
			FileNiv+cAnoSis+ExtFile,'FUE',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVOS')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE FUE->(RECCOUNT()) == 0
		 cError('NO ESTAN GRABADOS LOS NIVELES')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********GRABACION DE LOS NIVELES
	    DO WHILE .NOT. FUE->(EOF())

	       IF NIV->(lRegLock(lShared,.T.))
		  REPL NIV->cCodigoNiv WITH FUE->cCodigoNiv
		  REPL NIV->nNroGruNiv WITH FUE->nNroGruNiv
		  NIV->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA NIVEL')
	       ENDIF

	       IF lShared
		  NIV->(DBUNLOCK())
	       ENDIF

	       FUE->(DBSKIP())

	    ENDDO
	    CloseDbf('FUE')
**********FIN GRABACION DE LOS NIVELES

       ENDIF
*>>>>FIN GRABACION DE LOS NIVELES DE JARDIN

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePag,'PAG',cPatSis+'\'+fNtxPag,lShared)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoSis)

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoSis)

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoSis)

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN PAGOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>TIPO DE CONCEPTO PENSION O MATRICULA
       cMatricTpa := '0'
       IF nLeeOpcion('ESCOJA EL CONCEPTO: '+;
		     '1<MATRICULA> 2<PENSION>?',2,'1') == 1
	  cMatricTpa := '1'
       ENDIF
*>>>>FIN TIPO DE CONCEPTO PENSION O MATRICULA

*>>>>FILTRACION DE LOS PAGOS
       SELECT PAG
       IF cMatricTpa == '1'
	  SET FILTER TO PAG->cMatricPag == '1'
       ELSE
	  SET FILTER TO PAG->cMatricPag == '0'
       ENDIF
       GO TOP
       IF PAG->(EOF())
	  cError('NO EXISTEN PAGOS PARA '+;
		 IF(cMatricPag == '1','MATRICULA','PENSION'))
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')
       IF ANO->lLeeFecAno
	  IF lPregunta('DESEA EL INFORME POR INTERVALO DE FECHAS? No Si')

	     cSavPan := SAVESCREEN(0,0,24,79)
	     @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	     @ nFilInf+1,nColInf SAY 'FECHA INICIAL:' GET dFecIni PICT '@D'
	     @ nFilInf+2,nColInf SAY 'FECHA FINAL  :' GET dFecFin PICT '@D'
	     READ
	     RESTSCREEN(0,0,24,79,cSavPan)

	     IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
		CloseDbf('NIV')
		RETURN NIL
	     ENDIF

	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>CAPTURA DE LOS NIVELES POR INTERVALO
       IF !lInterNiv(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NIVELES POR INTERVALO

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       SELECT NIV
       GO nRegIni
       DO WHILE RECNO() <= nRegFin
	  nTotReg += NIV->nNroGruNiv+1
	  SKIP
       ENDDO
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>LECTURA DEL INTERVALO DE FECHAS
       IF ANO->lLeeFecAno .AND. !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)
	  cTxtPrn := ' DE '+cFecha(dFecIni,03)+ ' A '+cFecha(dFecFin,03)
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       aCabeza := {cNomEmp,cNomSis,;
		   'RELACION DE PAGOS POR GRUPOS'+cTxtPrn,;
		   'POR CONCEPTO DE '+;
		     IF(cMatricTpa == '1','MATRICULA','PENSION'),;
		   'JORNADA: '+cJorTxt,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,12,12,12,12,12,12,12,38}
       aTitulo := {'GRU.',;
		   'SALDO ACTUAL',;
		   'TOTAL MES ',;
		   'INTxCOBMes',;
		   'TOTAL DEUDA ',;
		   'VALOR PAGOS ',;
		   'INT PAGMes',;
		   'TOTAL PAGADO',;
		   'ESTADISTICAS DEL PAGO'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn = SUBS(MTR->cSerFacMtr,1,1)+'pgr'+cAnoUsr
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF

       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA


*>>>>IMPRESION POR NIVELES
       SET DEVICE TO SCREEN
       SELECT NIV
       GO nRegFin
       cNivFin = NIV->cCodigoNiv

       GO nRegIni
       DO WHILE NIV->(RECNO()) <= nRegFin

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('CONCEPTO: '+IF(cMatricTpa == '1','MATRICULA',;
							  'PENSION')+;
			'ºIMPRIMIENDO EL NIVEL: '+NIV->cCodigoNiv+'º'+;
			'HASTA EL NIVEL: '+cNivFin,cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DE LOS GRUPOS
	    nGruIni := 0
	    DO WHILE nGruIni <= NIV->nNroGruNiv

*---------------FILTRACION DE PRIMARIA
		  cMaeAct := cMaeActNiv(NIV->cCodigoNiv)
		  cCodGru := NIV->cCodigoNiv+STR(nGruIni,2)
		  lCorrecion(@cCodGru)
		  SELECT &cMaeAct
		  SET FILTER TO cCodigoGru == cCodGru
		  GO TOP
		  IF EOF() .AND. &cMaeAct->cCodigoGru # cCodGru
		     nGruIni++
		     SKIP
		     LOOP
		  ENDIF
*---------------FIN FILTRACION DE PRIMARIA

*--------------INICIALIZACION DE ACUMULADORES
		 nVlrSdo := 0
		 nIntMor := 0
		 nVlrDeu := 0
		 nVlrPag := 0
		 nIntPag := 0
		 nVlrIng := 0
		 nVlrMes := 0

		 nAluGru := 0
		 nSiPago := 0
		 nNoPago := 0
*--------------FIN INICIALIZACION DE ACUMULADORES

*--------------IMPRESION DE LOS GRUPOS
		 Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
		 Termometro(50)
		 SELECT &cMaeAct
		 GO TOP
		 nAluGru := 0
		 DO WHILE .NOT. EOF()

*...................CALCULO DE LOS INTERESES ACUMULACION DE PAGOS
		      nAluGru++

		      IF lSekCodigo(&cMaeAct->cCodigoEst+;
				    cMatricTpa,'PAG')

*		         ANALISIS DE LA FECHA DE PAGO
			   lFechOk := .T.
			   IF ANO->lLeeFecAno
			      IF !EMPTY(PAG->dFecpagPag) .AND.;
				 !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)

				 IF PAG->dFecpagPag < dFecIni .OR.;
				    PAG->dFecpagPag > dFecFin
				    lFechOk := .F.
				 ENDIF

			      ENDIF
			   ENDIF
			   nVlrMes += PAG->nVlrMesPag
*			ANALISIS DE LA FECHA DE PAGO

*                       CALCULO DE LOS INTERESES
			  IF PAG->lIntPenPag
			     nVlrInt  := ROUND((PAG->nVlrMesPag*;
						PAG->nIntmorPag)/100,0)
			  ELSE
			     nVlrInt := PAG->nVlrMorPag
			  ENDIF
*                       FIN CALCULO DE LOS INTERESES

*			ANALISIS DE LA FORMA DE PAGO
			  DO CASE
			  CASE (PAG->cEstadoPag == 'P'  .OR.;
				PAG->cEstadoPag == 'A') .AND. lFechOk

			       nSiPago++
			       nVlrPag += PAG->nVlrPagPag
			       nVlrIng += PAG->nVlrPagPag
			       IF PAG->cEstadoPag == 'A'
				  nIntPag += nVlrInt
				  nVlrIng += nVlrInt
			       ENDIF

			  CASE PAG->cEstadoPag == 'D' .OR.;
			       PAG->cEstadoPag = '*'

			       nNoPago++
			       IF PAG->cEstadoPag = 'D'
				  nIntMor += nVlrInt
				  nVlrDeu += PAG->nVlrPagPag
				  nVlrSdo += PAG->nVlrPagPag+nVlrInt
			       ELSE
				  nVlrSdo += CLI->nSdoActCli
			       ENDIF

			  ENDCASE
*			FIN ANALISIS DE LA FORMA DE PAGO

		      ENDIF
*...................FIN CALCULO DE LOS INTERESES ACUMULACION DE PAGOS

		    SELECT &cMaeAct
		    DBSKIP()

		 ENDDO
		 Termometro(100)
*--------------FIN IMPRESION DE LOS GRUPOS

*--------------IMPRESION DEL CONTENIDO DEL INFORME
		 SET DEVICE TO PRINT
		 aTitulo := {cCodGru,;
			     TRANS(nVlrSdo,"####,###,###"),;
			     TRANS(nVlrMes,"####,###,###"),;
			     TRANS(nIntMor,"####,###,###"),;
			     TRANS(nVlrDeu,"####,###,###"),;
			     TRANS(nVlrPag,"####,###,###"),;
			     TRANS(nIntPag,"####,###,###"),;
			     TRANS(nVlrIng,"####,###,###"),;
			     '('+TRANS(nAluGru,"9999")+')=>'+;
			     SPACE(01)+;
			     'SI('+TRANS(nSiPago,"999")+')'+;
			     TRANS(nSiPago*100/nAluGru,"999.99")+'%'+;
			     SPACE(01)+;
			     'NO('+TRANS(nNoPago,"999")+')'+;
			     TRANS(nNoPago*100/nAluGru,"999.99")+'%'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
		 SET DEVICE TO SCREEN
*--------------FIN IMPRESION DEL CONTENIDO DEL INFORME

*--------------ACUMULACION DE TOTALES
		 nTotSdo += nVlrSdo
		 nTotMor += nIntMor
		 nTotDeu += nVlrDeu
		 nTotPag += nVlrPag
		 nTotInt += nIntPag
		 nTotIng += nVlrIng
		 nTotMes += nVlrMes

		 nTotAlu += nAluGru
		 nTotSiP += nSiPago
		 nTotNoP += nNoPago
*--------------FIN ACUMULACION DE TOTALES

	       nGruIni++

	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

**********AVANCE DEL SIGUIENTE NIVEL
	    SELECT NIV
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE NIVEL

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       SET DEVICE TO PRINT
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,02) SAY REPL('-',aNroCol[02])
       @ PROW()  ,nColTxt(aNroCol,03) SAY REPL('-',aNroCol[03])
       @ PROW()  ,nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       @ PROW()  ,nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       @ PROW()  ,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])

       @ PROW()+1,00 SAY 'TOTAL'
       @ PROW()  ,nColTxt(aNroCol,02) SAY TRANS(nTotSdo,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,03) SAY TRANS(nTotMes,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,04) SAY TRANS(nTotMor,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotDeu,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotPag,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotInt,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotIng,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,09) SAY '('+TRANS(nTotAlu,"9999")+')=>'+;
					  SPACE(01)+;
					  'SI('+TRANS(nTotSiP,"999")+')'+;
					  TRANS(nTotSiP*100/nTotAlu,"999.99")+'%'+;
					  SPACE(01)+;
					  'NO('+TRANS(nTotNoP,"999")+')'+;
					  TRANS(nTotNoP*100/nTotAlu,"999.99")+'%'
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)

       CLOSE ALL
       SET DEVICE TO SCREEN
       ERASE &FileTem
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

