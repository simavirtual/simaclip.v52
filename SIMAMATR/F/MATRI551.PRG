/* SIMA - MATRICULA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: FACTURACION DEL MES           MODULO No. 506

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI506.PRG                                    *
* TITULO DEL PROGRAMA..: FACTURACION DEL MES                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 12/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   DIC 12/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- ?

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_551(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "CAMPOS\ARC-MATRR.PRG"      // Archivos del Sistema

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

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL cNivFin := ''                  // Nivel Final
       LOCAL cNivAct := ''                  // Nivel Actual
       LOCAL cNivAnt := ''                  // Nivel Anterior

       LOCAL nNroEst := 0                   // N£mero de Estudiantes
       LOCAL nTotEst := 0                   // Total Estudiantes
       LOCAL nAluGru := 0                   // Alumnos del Grupo
       LOCAL nNroDeu := 0                   // N£mero de Deudores
       LOCAL nNroExt := 0                   // N£mero de Extemporaneos

       LOCAL cConcep := ''                  // Conceptos
       LOCAL nTotal  := 0                   // Total Conceptos
       LOCAL aTotCon := {}                  // Total Conceptos
       LOCAL aVlrCon := {}                  // Valor Conceptos
       LOCAL aTotNiv := {}                  // Total Niveles
       LOCAL nVlrTar := 0                   // Valor Tarifas
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotBec := 0                   // Total Becas
       LOCAL nTotRec := 0                   // Total Recargos
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nIntMes := 0                   // Intereses del mes
       LOCAL nPago   := 0                   // Pagos
       LOCAL nTotPag := 0                   // Total de pagos
       LOCAL nNotPag := 0                   // Pagos por fuera del intervalo
       LOCAL nNotInt := 0                   // Intereses Extemporaneos por fuera del intervalo
       LOCAL nAboMes := 0                   // Abonos del Mes
       LOCAL nAboOtr := 0                   // Abonos Otros Meses
       LOCAL lFechOk := .T.                 // Fecha de Acuedo al intervalo
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
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
		       FileCon,'CON',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileTar,'TAR',NIL,lShared) .OR.;
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

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CONCEPTOS GRABADOS')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN PAGOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO')

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
       cConcep := ANO->cConPenAno+SPACE(08)
       IF nLeeOpcion('ESCOJA EL CONCEPTO: '+;
		     '1<MATRICULA> 2<PENSION>?',2,'1') == 1
	  cMatricTpa := '1'
	  cConcep := ANO->cConMatAno+SPACE(08)
       ENDIF
*>>>>FIN TIPO DE CONCEPTO PENSION O MATRICULA

*>>>>LECTURA DE LOS CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)

       @ nFilInf+1,nColInf SAY 'CONCEPTOS' GET cConcep PICT "@!";
			   VALID lValLeeCon(nFilInf+1,nColInf+0,;
					    nFilInf+1,nColInf+12,;
					    @cConcep)
       READ
       IF EMPTY(cConcep) .OR. !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       cConcep := ALLTRIM(cConcep)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LOS CONCEPTOS

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
		   'FACTURACION DEL MES'+cTxtPrn,;
		   'POR CONCEPTO DE '+;
		     IF(cMatricTpa == '1','MATRICULA','PENSION'),;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aTotCon := {0,0,0,0,0}   // Saldo Actual
       aTotNiv := {0,0,0,0,0}   // Saldo Actual

       aNroCol := {08,16,12,12,12,12}
       aTitulo := {'NIVEL ',;
		   'SALDO ACTUAL',;
		   'TOTAL DEUDA',;
		   'INTxCOBRAR',;
		   'INTxCOBMes',;
		   'INTxCOBAnt'}

       FOR i := 1 TO LEN(cConcep)/2

	   AADD(aTotCon,0)  // Conceptos Mes
	   AADD(aTotNiv,0)  // Totales Conceptos Mes

	   IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(CON->cNombreCon,1,12))  // Conceptos Mes
	   ELSE
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(cConcep,i*2-1,2))       // Conceptos Mes
	   ENDIF

       ENDFOR

       AADD(aNroCol,16)
       AADD(aTitulo,'INT PAGO MES')

       AADD(aNroCol,12)
       AADD(aTitulo,'ANTICIPOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')

       AADD(aTotCon,0)  // Intereses Pagados
       AADD(aTotCon,0)  // Anticipos
       AADD(aTotCon,0)  // Total Nivel

       AADD(aTotNiv,0)  // Intereses Pagados
       AADD(aTotNiv,0)  // Anticipos
       AADD(aTotNiv,0)  // Total Nivel

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
	  FilePrn = SUBS(MTR->cSerFacMtr,1,1)+'fac'+cAnoUsr
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
       SELECT NIV
       GO nRegFin
       cNivFin = NIV->cCodigoNiv

       GO nRegIni
       DO WHILE NIV->(RECNO()) <= nRegFin

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('CONCEPTO: '+IF(cMatricTpa == '1','MATRICULA',;
							  'PENSION')+;
			'ºIMPRIMIENDO EL NIVEL: '+NIV->cCodigoNiv+'º'+;
			'HASTA EL NIVEL: '+cNivFin,cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DE LOS GRUPOS
	    nGruIni := 0
	    DO WHILE nGruIni <= NIV->nNroGruNiv+5

*---------------FILTRACION POR GRUPO
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
*---------------FIN FILTRACION POR GRUPO

*---------------INICIALIZACION DE ACUMULADORES
		  aVlrCon := {0,0,0,0,0}        // Saldo
		  FOR i := 1 TO LEN(cConcep)/2
		      AADD(aVlrCon,0)           // Conceptos Mes
		  ENDFOR
		  AADD(aVlrCon,0)               // Recargos
		  AADD(aVlrCon,0)               // Anticipos
		  AADD(aVlrCon,0)               // Total Nivel
*---------------FIN INICIALIZACION DE ACUMULADORES

*--------------IMPRESION DE LOS GRUPOS
		 SET DEVICE TO SCREEN
		 Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
		 Termometro(50)

		 SELECT &cMaeAct
		 GO TOP
		 nAluGru := 0
		 cNivAnt := SUBS(cCodGru,1,2)
		 DO WHILE .NOT. EOF()

*...................BUSQUEDA DEL PAGO
		      IF !lSekCodigo(&cMaeAct->cCodigoEst+cMatricTpa,'PAG')
			 SELECT &cMaeAct
			 DBSKIP()
			 LOOP
		      ENDIF
		      nNroEst++
*...................FIN BUSQUEDA DEL PAGO

*...................ANALISIS DE LA FECHA DE FACTURACION
		      IF ANO->lLeeFecAno
			 IF !EMPTY(PAG->dFecpagPag) .AND.;
			    !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)

			    IF PAG->dFecFacPag < dFecIni .OR.;
			       PAG->dFecFacPag > dFecFin

			       SELECT &cMaeAct
			       DBSKIP()
			       LOOP

			    ENDIF

			 ENDIF
		      ENDIF
*...................FIN ANALISIS DE LA FECHA DE FACTURACION

*...................ANALISIS DE LA FECHA DE PAGO
		      lFechOk := .T.
/*
		      IF ANO->lLeeFecAno
			 IF !EMPTY(PAG->dFecpagPag) .AND.;
			    !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)

			    IF PAG->dFecpagPag < dFecIni .OR.;
			       PAG->dFecpagPag > dFecFin
			       lFechOk := .F.
			    ENDIF

			 ENDIF
		      ENDIF
*/
*...................FIN ANALISIS DE LA FECHA DE PAGO

*...................CALCULO DE LOS INTERESES
		      IF PAG->lIntPenPag
			 nVlrInt  := ROUND((PAG->nVlrMesPag*;
					    PAG->nIntmorPag)/100,0)
		      ELSE
			 nVlrInt := PAG->nVlrMorPag
		      ENDIF
*...................FIN CALCULO DE LOS INTERESES

*...................VALOR DE CADA CONCEPTO
		      FOR i := 1 TO LEN(cConcep)/2

*                         VALOR DEL CONCEPTO FACTURADO
			    cCodigoTco := SUBS(cConcep,i*2-1,2)
			    IF cCodigoTco $ PAG->cConcepPag
			       nVlrTar := nValorTar(NIV->cCodigoNiv+'00',;
						    cCodigoTco)
			    ELSE
			       nVlrTar := 0
			       LOOP
			    ENDIF
*                         FIN VALOR DEL CONCEPTO FACTURADO

*                         FACTURACION DEL MES PARA CADA CONCEPTO
			    aVlrCon[i+5] += nVlrTar
			    aTotCon[i+5] += nVlrTar
			    aTotNiv[i+5] += nVlrTar
*                         FIN FACTURACION DEL MES PARA CADA CONCEPTO

*                         TOTALES DEL GRUPO
			    aVlrCon[LEN(aVlrCon)] += nVlrTar
			    aTotNiv[LEN(aTotNiv)] += nVlrTar
			    aTotCon[LEN(aTotCon)] += nVlrTar
*                         FIN TOTALES DEL GRUPO

*                         TOTALIZACION DEL VALOR PAGADO
			    IF (PAG->cEstadoPag == 'P' .OR.;
				PAG->cEstadoPag == 'A') .AND. lFechOk

			       nVlrPag += nVlrTar

			    ENDIF
*                         FIN TOTALIZACION DEL VALOR PAGADO

		      ENDFOR
*...................FIN VALOR DE CADA CONCEPTO

*...................ANALISIS DE LA FORMA DE PAGO
		      DO CASE
		      CASE (PAG->cEstadoPag == 'P' .OR.;
			    PAG->cEstadoPag == 'A')

			    IF lFechOk
			       nTotPag += PAG->nVlrPagPag
			    ELSE
			       nNotPag += PAG->nVlrPagPag
			    ENDIF

*                          VALOR DE LOS INTERESES PAGADOS
			     IF PAG->cEstadoPag == 'A'

				nNroExt++
				IF lFechOk
				   nVlrPag += nVlrInt
				ELSE
				   nNotInt += nVlrInt
				ENDIF

				aVlrCon[LEN(aVlrCon)-2] += nVlrInt
				aTotNiv[LEN(aTotNiv)-2] += nVlrInt
				aTotCon[LEN(aTotCon)-2] += nVlrInt
			      *ÀValor de los intereses

				aVlrCon[LEN(aVlrCon)] += nVlrInt
				aTotNiv[LEN(aTotNiv)] += nVlrInt
				aTotCon[LEN(aTotCon)] += nVlrInt
			      *ÀTotal del grupo

			     ENDIF
*                          FIN VALOR DE LOS INTERESES PAGADOS

*                          VALOR DE LOS ANTICIPOS
			     IF PAG->nMesIniPag # PAG->nMesFinPag .AND. lFechOk

				aVlrCon[LEN(aVlrCon)-1] += PAG->nVlrPagPag-;
							   nVlrPag
				aTotNiv[LEN(aTotNiv)-1] += PAG->nVlrPagPag-;
							   nVlrPag
				aTotCon[LEN(aTotCon)-1] += PAG->nVlrPagPag-;
							   nVlrPag
			      *ÀAnticipos

				aVlrCon[LEN(aVlrCon)] += PAG->nVlrPagPag-;
							 nVlrPag
				aTotNiv[LEN(aTotNiv)] += PAG->nVlrPagPag-;
							 nVlrPag
				aTotCon[LEN(aTotCon)] += PAG->nVlrPagPag-;
							 nVlrPag
			      *ÀTotal del grupo

			     ENDIF
*                          FIN VALOR DE LOS ANTICIPOS

		      CASE PAG->cEstadoPag == 'D'

*                          SALDO ACTUAL
			     nNroDeu++
			     nPago := PAG->nVlrMesPag

			     aVlrCon[1] += nPago+nVlrInt
			     aTotNiv[1] += nPago+nVlrInt
			     aTotCon[1] += nPago+nVlrInt
*                          FIN SALDO ACTUAL

*                          DEUDA SIN INTERESES
			     aVlrCon[2] += nPago
			     aTotNiv[2] += nPago
			     aTotCon[2] += nPago
*                          FIN DEUDA SIN INTERESES

*                          INTERESES POR COBRAR
			     aVlrCon[3] += nVlrInt
			     aTotNiv[3] += nVlrInt
			     aTotCon[3] += nVlrInt
*                          FIN INTERESES POR COBRAR

*                          INTERESES POR COBRAR DEL MES
			     nIntMes := nVlrInt

			     aVlrCon[4] += nIntMes
			     aTotNiv[4] += nIntMes
			     aTotCon[4] += nIntMes

			     aVlrCon[LEN(aVlrCon)] += nIntMes
			     aTotNiv[LEN(aTotNiv)] += nIntMes
			     aTotCon[LEN(aTotCon)] += nIntMes
			    *Total del grupo
*                          FIN INTERESES POR COBRAR DEL MES

*                          INTERESES POR COBRAR ANTERIORES
			     aVlrCon[5] += 0
			     aTotNiv[5] += 0
			     aTotCon[5] += 0
*                          FIN INTERESES POR COBRAR ANTERIORES

		      ENDCASE
*...................FIN ANALISIS DE LA FORMA DE PAGO

		    SELECT &cMaeAct
		    DBSKIP()

		 ENDDO
		 Termometro(100)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LOS GRUPOS

*--------------IMPRESION DEL CONTENIDO DEL INFORME
		 aTitulo := {}
		 AADD(aTitulo,cCodGru+'->'+STR(nNroEst,2))
		 AADD(aTitulo,' '+STR(nNroDeu,2)+':'+;
			      TRANS(aVlrCon[1],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrCon[2],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrCon[3],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrCon[4],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrCon[5],"####,###,###"))
		 FOR i := 1 TO LEN(cConcep)/2
		     AADD(aTitulo,TRANS(aVlrCon[i+5],"####,###,###"))
		 ENDFOR
		 AADD(aTitulo,' '+STR(nNroExt,2)+':'+;
			      TRANS(aVlrCon[LEN(aVlrCon)-2],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrCon[LEN(aVlrCon)-1],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrCon[LEN(aVlrCon)],"####,###,###"))

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DEL CONTENIDO DEL INFORME

	       nGruIni++
	       nTotEst += nNroEst
	       nNroEst := 0
	       nNroExt := 0
	       nNroDeu := 0

	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(cCodGru,1,2)
	    IF cNivAnt # cNivAct

	       @ PROW()+1,00 SAY ''
	       FOR i := 1 TO LEN(aTotNiv)
		   @ PROW(),nColTxt(aNroCol,i+1) SAY REPL('-',aNroCol[i+1])
	       ENDFOR

	       aTitulo := {}
	       AADD(aTitulo,cNivAnt)
	       AADD(aTitulo,SPACE(04)+TRANS(aTotNiv[1],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[2],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[3],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[4],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[5],"####,###,###"))
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aTitulo,TRANS(aTotNiv[i+5],"####,###,###"))
	       ENDFOR
	       AADD(aTitulo,SPACE(04)+;
			    TRANS(aTotNiv[LEN(aTotNiv)-2],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-1],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)],"####,###,###"))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	       @ PROW()+1,00 SAY ''

	       aTotNiv := {0,0,0,0,0}   // Saldo Actual
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aTotNiv,0)  // Concepto Mes
	       ENDFOR
	       AADD(aTotNiv,0)  // Recargo
	       AADD(aTotNiv,0)  // Anticipos
	       AADD(aTotNiv,0)  // Total Nivel
	       cNivAnt := cNivAct
	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

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
       @ PROW()+1,00 SAY ''
       FOR i := 1 TO LEN(aTotCon)
	   @ PROW(),nColTxt(aNroCol,i+1) SAY REPL('=',aNroCol[i+1])
       ENDFOR

       aTitulo := {}
       AADD(aTitulo,'TOTAL')
       AADD(aTitulo,SPACE(04)+TRANS(aTotCon[1],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[2],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[3],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[4],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[5],"####,###,###"))
       FOR i := 1 TO LEN(cConcep)/2
	   AADD(aTitulo,TRANS(aTotCon[i+5],"####,###,###"))
       ENDFOR
       AADD(aTitulo,SPACE(04)+TRANS(aTotCon[LEN(aTotCon)-2],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-1],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)],"####,###,###"))

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>CAMBIO DE PAGINA
       IF PROW() > 52
	  EJECT
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN CAMBIO DE PAGINA

*>>>>IMPRESION TOTALES DE LOS CONCEPTOS
       lPrnReg(02,00,DOBANC_ON+'RESUMEN'+DOBANC_OF,bPagina,bDerAut,bCabeza)
       nTotal := 0
       FOR i := 1 TO LEN(cConcep)/2

	 IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	    lPrnReg(01,00,CON->cNombreCon+SPACE(03)+;
			  TRANS(aTotCon[i+5],"####,###,###"),;
			  bPagina,bDerAut,bCabeza)
	    nTotal += aTotCon[i+5]
	 ELSE
	    lPrnReg(01,00,SUBS(cConcep,i*2-1,2)+SPACE(03)+;
			  TRANS(aTotCon[i+5],"####,###,###"),;
			  bPagina,bDerAut,bCabeza)
	    nTotal += aTotCon[i+5]
	 ENDIF

       ENDFOR
*>>>>FIN IMPRESION TOTALES DE LOS CONCEPTOS

*>>>>OTROS TOTALES
       nTotRec := 0
       nTotal += nTotRec
       lPrnReg(01,00,'+RECARGOS          '+TRANS(nTotRec,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       nTotal += aTotCon[LEN(aTotCon)-1]
       lPrnReg(01,00,'+ANTICIPOS         '+;
		     TRANS(aTotCon[LEN(aTotCon)-1],"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       nTotBec := 0
       nTotal -= nTotBec
       lPrnReg(01,00,'-BECAS             '+TRANS(nTotBec,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       nTotDes := 0
       nTotal -= nTotDes
       lPrnReg(01,00,'-DESCUENTOS        '+TRANS(nTotDes,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       lPrnReg(01,00,SPACE(19)+REPL('=',12),bPagina,bDerAut,bCabeza)

       lPrnReg(01,00,'FACTURACION        '+;
		     TRANS(nTotal ,"####,###,###")+' ALUMNOS = '+;
		     TRANS(nTotEst,"####"),;
		     bPagina,bDerAut,bCabeza)

       nTotal += aTotCon[LEN(aTotCon)-2]
       lPrnReg(01,00,'+INT PAGO MES      '+;
		     TRANS(aTotCon[LEN(aTotCon)-2],"####,###,###"),;
		     bPagina,bDerAut,bCabeza)


       nTotal += aTotCon[4]
       lPrnReg(01,00,'+INTxCobMes        '+;
		     TRANS(aTotCon[4],"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       lPrnReg(01,00,SPACE(19)+REPL('=',12),bPagina,bDerAut,bCabeza)
       lPrnReg(01,00,'GRAN TOTAL         '+;
		     TRANS(nTotal,"####,###,###"),bPagina,bDerAut,bCabeza)

       nDeuAnt := 0
       nTotal += nDeuAnt
       lPrnReg(01,00,'+DEUDA ANTERIOR    '+;
		     TRANS(nDeuAnt,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       nMorAnt := 0
       nTotal += nMorAnt
       lPrnReg(01,00,'+MORA ANTERIOR     '+;
		     TRANS(nMorAnt,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)


       nTotPag += aTotCon[LEN(aTotCon)-2] - nNotInt
      *Mas Intereses Extemporaneos

       nTotal -= nTotPag
       lPrnReg(01,00,'-PAGOS             '+;
		     TRANS(nTotPag,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       IF !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)
	  nTotal -= nNotPag+nNotInt
	  lPrnReg(01,00,'-PAGOS OTRA FECHAS '+;
			TRANS(nNotPag+nNotInt,"####,###,###"),;
			bPagina,bDerAut,bCabeza)
       ENDIF

       nAboMes := 0
       nTotal -= nAboMes
       lPrnReg(01,00,'-ABONOS PARA EL MES'+;
		     TRANS(nAboMes,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       nAboOtr := 0
       nTotal -= nAboOtr
       lPrnReg(01,00,'-ABONOS OTROS MESES'+;
		     TRANS(nAboOtr,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

       lPrnReg(01,00,SPACE(19)+REPL('=',12),bPagina,bDerAut,bCabeza)
       lPrnReg(01,00,'SALDO ACTUAL       '+;
		     TRANS(nTotal,"####,###,###"),bPagina,bDerAut,bCabeza)
*>>>>FIN OTROS TOTALES

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