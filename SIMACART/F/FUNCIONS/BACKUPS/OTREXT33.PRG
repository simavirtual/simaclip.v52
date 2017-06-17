/*************************************************************************
* TITULO ..: PAGOS DESCRIMINADOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2003 JUE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   MAY 28/2003 JUE

OBJETIVOS:

1- Permite descriminar los pagos por conceptos

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt33(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

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

       LOCAL       i := 0                   // Contador
       LOCAL aGruCre[4]                     // Cr‚ditos por grupos
       LOCAL aGruDeb[4]                     // D‚bitos por grupos
       LOCAL aNivCre[4]                     // Cr‚ditos por niveles
       LOCAL aNivDeb[4]                     // D‚bitos por niveles
       LOCAL aTotCre[4]                     // Cr‚ditos por totales
       LOCAL aTotDeb[4]                     // D‚bitos por totales
       LOCAL aOtrCre[4]                     // Cr‚ditos Varios
       LOCAL aOtrDeb[4]                     // D‚bitos Varios

       LOCAL lPagoOk := .T.
       LOCAL lValida := .F.                 // .T. Imprimir por detalle
       LOCAL nVlrOtr := 0                   // Valor de otros
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
     *ÀVariables espec¡ficas

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura

       LOCAL cAnoMtr := ''                  // A¤o de la Matricula
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL cConcep := ''                  // Conceptos a descriminar
       LOCAL aVlrTot := {}                  // Valor Total
       LOCAL aTotNiv := {}                  // Valor Total nivel
       LOCAL aVlrNiv := {}                  // Valor por niveles
       LOCAL aVlrGru := {}                  // Valor por grupos
       LOCAL aVlrAlu := {}                  // Valor por alumnos
       LOCAL aTotCon := {}                  // Total Conceptos
       LOCAL nVlrPag := 0                   // Valor pagado
       LOCAL nVlrInt := 0                   // Valor de los Interese
       LOCAL nVlrTar := 0                   // Valor de la Tarifa
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n

       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL nCodigoTcm := 0                // Codigo del Concepto del Movimiento

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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)

       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>A¥O DE LA MATRICULA
       IF EMPTY(CAA->cAnoMtrCaA)
	  cAnoMtr := cAnoUsr
	  cIntDos := PathDos+'\'+cPatSis
       ELSE
	  cAnoMtr := CAA->cAnoMtrCaA
	  cIntDos := PathDos+'\'+cAnoMtr+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
*>>>>FIN A¥O DE LA MATRICULA

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoMtr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
       cPatAnt := PathUno+'\'+cPatAnt
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('FUE')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CREACION DE TODOS LOS GRUPOS
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
		cError('ABRIENDO ARCHIVOS')
		CloseDbf('GRU')
		IF !lFileDelete(FileTem)
		   cError('NO SE BORRO EL ARCHIVO TEMPORAL')
		ENDIF
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********GRAGACION DEL GRUPO DE LOS NUEVOS
	     SELECT GRU
	     GO TOP
	     cNivAnt := SUBS(GRU->cCodigoGru,1,2)

	     IF FUE->(lRegLock(lShared,.T.))
		REPL FUE->cCodigoGru WITH cNivAnt+'00'
		FUE->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABA LA FORMA DE PAGO')
	     ENDIF
	     IF lShared
		FUE->(DBUNLOCK())
	     ENDIF
***********FIN GRAGACION DEL GRUPO DE LOS NUEVOS

***********RECORRIDO DE LOS GRUPOS
	     DO WHILE .NOT. (GRU->(EOF()))

*---------------GRABACION DEL GRUPO
		  IF FUE->(lRegLock(lShared,.T.))
		     REPL FUE->cCodigoGru WITH GRU->cCodigoGru
		     FUE->(DBCOMMIT())
		  ELSE
		     cError('NO SE GRABA LA FORMA DE PAGO')
		  ENDIF
		  IF lShared
		     FUE->(DBUNLOCK())
		  ENDIF
*---------------FIN GRABACION DEL GRUPO

		SELECT GRU
		GRU->(DBSKIP())

*---------------ANALISIS DEL CAMBIO DEL GRUPO
		  cNivAct := SUBS(GRU->cCodigoGru,1,2)
		  IF cNivAnt # cNivAct .AND. !GRU->(EOF())

*....................GRAGACION DEL GRUPO DE LOS NUEVOS
		       IF FUE->(lRegLock(lShared,.T.))
			  REPL FUE->cCodigoGru WITH SUBS(GRU->cCodigoGru,1,2)+'00'
			  FUE->(DBCOMMIT())
		       ELSE
			  cError('NO SE GRABA LA FORMA DE PAGO')
		       ENDIF
		       IF lShared
			  FUE->(DBUNLOCK())
		       ENDIF
*....................FIN GRAGACION DEL GRUPO DE LOS NUEVOS

		     cNivAnt := cNivAct
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO DEL GRUPO

	     ENDDO
***********FIN RECORRIDO DE LOS GRUPOS

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    IF !lFileDelete(FileTem)
	       cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	    ENDIF
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INDEXACION DEL ARCHIVO
       SELECT TRA
       fNtxMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+cExtNtx
       INDEX ON TRA->cCodigoEst TO &(cPatSis+'\MODEM\'+fNtxMoB)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>LECTURA DEL CONCEPTO DEL MOVIMIENTO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       nCodigoTcm := 9999
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET nCodigoTcm PICT '9999';
			 VALID lValidaCmv(ROW(),COL()-1,@nCodigoTcm)
       READ
       IF !lPregunta('ESCOGIO '+ALLTRIM(CMV->cNombreCmv)+;
		     '. DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF

       IF !(nCodigoTcm == 1 .OR. nCodigoTcm == 2 .OR.;
	    nCodigoTcm == 3 .OR. nCodigoTcm == 4)

	  cError('NO SE PERMITE DESCRIMINAR ESTE CONCEPTO')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL CONCEPTO DEL MOVIMIENTO

*>>>>LECTURA DE LOS CONCEPTOS
       nNroFil := nMarco(6,'POR FAVOR SELECCIONE LOS CONCEPTOS A '+;
			   'DESCRIMINAR',15,'°',,15,65)

       cConcep := cLeeConcep(10,30,09,16)
       IF EMPTY(cConcep) .OR. !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cConcep := ALLTRIM(cConcep)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LOS CONCEPTOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2)) .OR.;
	  !lUseDbf(.T.,cIntDos+'\'+;
		       FileAdm+cAnoMtr+ExtFile,'ADM',NIL,lShared) .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cIntDos+'\'+FilePag,'PAG',;
		       cIntDos+'\'+fNtxPag,lShared) .OR.;
	  !lUseDbf(.T.,cIntDos+'\'+FileTar,'TAR',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('GRU')
	  CloseDbf('PAG')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS GRUPOS')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN PAGOS DE MATRICULAS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN TARIFAS DE MATRICULAS CREADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('GRU')
	  CloseDbf('PAG')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',22,NIL,NIL,20,60)
       IF !lIntervGru(nNroFil,21,@nRegIni,@nRegFin)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       lValida := .F.
       IF nRegIni == nRegFin
	  lValida := lPregunta('DESEA IMPRIMIR EL INFORME CON DETALLE '+;
			       'POR CADA ESTUDIANTE? No Si')
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		   '. A¥O: '+cAnoUsr,;
		   'PAGOS DESCRIMINADOS DE '+ALLTRIM(CMV->cNombreCmv),;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aTotCon := {}
       aTotNiv := {}

       aNroCol := {04}
       aTitulo := {'NIV.'}

       FOR i := 1 TO LEN(cConcep)/2

	   AADD(aTotCon,0)  // Conceptos Mes
	   AADD(aTotNiv,0)  // Totales Conceptos Mes

	   IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(CON->cNombreCon,1,12))     // Conceptos Mes
	   ELSE
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(cConcep,i*2-1,2))       // Conceptos Mes
	   ENDIF

       ENDFOR

       AADD(aNroCol,12)
       AADD(aTitulo,'INT PAGO MES')

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')

       AADD(aTotCon,0)  // Int Pago Mes
       AADD(aTotCon,0)  // Total Nivel

       AADD(aTotNiv,0)  // Int Pago Mes
       AADD(aTotNiv,0)  // Total Nivel

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
	     CloseDbf('GRU')
	     SELECT TRA
	     SET INDEX TO
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>INICIALIZACION DE ACUMULADORES
       aVlrTot := {}
       aVlrNiv := {}
       FOR i := 1 TO LEN(cConcep)/2
	   AADD(aVlrNiv,0)           // Conceptos Mes
	   AADD(aVlrTot,0)           // Conceptos Mes
       ENDFOR
       AADD(aVlrNiv,0)               // Recargos
       AADD(aVlrNiv,0)               // Total Nivel
       AADD(aVlrTot,0)               // Recargos
       AADD(aVlrTot,0)               // Total Nivel
*>>>>FIN INICIALIZACION DE ACUMULADORES

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       cNivAnt := SUBS(GRU->cCodigoGru,1,2)
       DO WHILE RECNO() <= nRegFin

**********INICIALIZACION DEL GRUPO
	    FOR i := 1 TO 4
		aGruCre[i] := 0
		aGruDeb[i] := 0
	    ENDFOR
**********FIN INICIALIZACION DEL GRUPO

**********INICIALIZACION DE ACUMULADORES DEL GRUPO
	     aVlrGru := {}
	     FOR i := 1 TO LEN(cConcep)/2
		 AADD(aVlrGru,0)           // Conceptos Mes
	     ENDFOR
	     AADD(aVlrGru,0)               // Recargos
	     AADD(aVlrGru,0)               // Total Nivel
**********FIN INICIALIZACION DE ACUMULADORES DEL GRUPO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT TRA
	    GO TOP
	    lPagoOk := .T.
	    DO WHILE .NOT. TRA->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+'º'+;
			     'REFERENCIA: '+TRA->cCodRefTra,cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DEL CODIGO DEL CONCEPTO
		 IF TRA->nCodigoCmv # nCodigoTcm
		    SELECT TRA
		    DBSKIP()
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DEL CODIGO DEL CONCEPTO

*--------------BUSQUEDA DEL ESTUDIANTE
		 cCodigoTgr := ''
		 IF lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		    IF &cMaeAct->cCodigoGru == GRU->cCodigoGru
		       cCodigoTgr := &cMaeAct->cCodigoGru
		    ELSE
		       SELECT TRA
		       DBSKIP()
		       LOOP
		    ENDIF
		 ELSE
		    IF lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		       IF &cMaeAct->cCodigoGru == GRU->cCodigoGru
			  cCodigoTgr := &cMaeAct->cCodigoGru
		       ELSE
			  SELECT TRA
			  DBSKIP()
			  LOOP
		       ENDIF
		    ELSE
		       IF lLocCodigo('cCodigoEst','ADM',TRA->cCodigoEst)
			  IF ADM->cCodigoGru == GRU->cCodigoGru
			     cCodigoTgr := ADM->cCodigoGru
			  ELSE
			     SELECT TRA
			     DBSKIP()
			     LOOP
			  ENDIF
		       ELSE
			  SET DEVICE TO SCREEN
			  cError('EL CODIGO '+TRA->cCodigoEst+' NO EXISTE')
			  SET DEVICE TO PRINT
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------VALIDACION DEL GRUPO
		 IF EMPTY(cCodigoTgr)
		    SET DEVICE TO SCREEN
		    cError('EL CODIGO '+TRA->cCodigoEst+' NO TIENE GRUPO')
		    SET DEVICE TO PRINT
		 ENDIF
*--------------FIN VALIDACION DEL GRUPO

*--------------BUSQUEDA DEL PAGO DE LA MATRICULA
		 IF !lSekCodigo(TRA->cCodigoEst+'1','PAG')
		    SET DEVICE TO SCREEN
		    cError('NO EXISTE EL RECIBO DE MATRICULA DE '+;
			   TRA->cCodigoEst)
		    SET DEVICE TO PRINT
		    SELECT TRA
		    DBSKIP()
		    LOOP
		 ENDIF
*--------------FIN BUSQUEDA DEL PAGO DE LA MATRICULA

* OJO TRA->lSumarTra

*---------------INICIALIZACION DE ACUMULADORES DEL ALUMNO
		  aVlrAlu := {}
		  FOR i := 1 TO LEN(cConcep)/2
		      AADD(aVlrAlu,0)           // Conceptos Mes
		  ENDFOR
		  AADD(aVlrAlu,0)               // Interes
		  AADD(aVlrAlu,0)               // Total Nivel
*---------------FIN INICIALIZACION DE ACUMULADORES DEL ALUMNO

*--------------CALCULO DE LOS INTERESES
		 IF PAG->lIntPenPag
		    nVlrInt  := ROUND((ABS(PAG->nVlrMesPag)*;
				       PAG->nIntmorPag)/100,0)
		 ELSE
		    nVlrInt := PAG->nVlrMorPag
		 ENDIF
*--------------FIN CALCULO DE LOS INTERESES

*--------------VALOR DE CADA CONCEPTO
		 nVlrTra := TRA->nValorTra
		 nVlrPag := 0
		 FOR i := 1 TO LEN(cConcep)/2

*....................VALOR DEL CONCEPTO FACTURADO
		       cCodigoTni := SUBS(cCodigoTgr,1,2)
		       cCodigoTco := SUBS(cConcep,i*2-1,2)
		       IF cCodigoTco $ PAG->cConcepPag
			  nVlrTar := nValorTar(cCodigoTni+'00',cCodigoTco)
		       ELSE
			  nVlrTar := 0
			  LOOP
		       ENDIF

		       nVlrPag += nVlrTar
		       IF nVlrTar > nVlrTra
			  nVlrTar := nVlrTra
		       ENDIF
		       nVlrTra -= nVlrTar
*....................FIN VALOR DEL CONCEPTO FACTURADO

*....................TOTALIZACION DEL VALOR PAGADO
		       aVlrAlu[i] += nVlrTar
		       aVlrGru[i] += nVlrTar
		       aVlrNiv[i] += nVlrTar
		       aVlrTot[i] += nVlrTar
		     *ÀValor pagado del concepto

		       aVlrAlu[LEN(aVlrAlu)] += nVlrTar
		       aVlrGru[LEN(aVlrGru)] += nVlrTar
		       aVlrNiv[LEN(aVlrNiv)] += nVlrTar
		       aVlrTot[LEN(aVlrTot)] += nVlrTar
		     *ÀTotales del Grupo
*....................FIN TOTALIZACION DEL VALOR PAGADO

*....................VALOR DE LOS INTERESES PAGADOS
		       IF PAG->cEstadoPag == 'A'

			  nVlrPag += nVlrInt

			  aVlrAlu[LEN(aVlrAlu)-1] += nVlrInt
			  aVlrGru[LEN(aVlrGru)-1] += nVlrInt
			  aVlrNiv[LEN(aVlrNiv)-1] += nVlrInt
			  aVlrTot[LEN(aVlrTot)-1] += nVlrInt
			*ÀValor Recargo

			  aVlrAlu[LEN(aVlrAlu)] += nVlrInt
			  aVlrGru[LEN(aVlrGru)] += nVlrInt
			  aVlrNiv[LEN(aVlrNiv)] += nVlrInt
			  aVlrTot[LEN(aVlrTot)] += nVlrInt
			 *Total del grupo
		       ENDIF
*....................FIN VALOR DE LOS INTERESES PAGADOS

		 ENDFOR
*--------------FIN VALOR DE CADA CONCEPTO

*--------------VALIDACION DEL PAGO
		 IF nVlrPag # TRA->nValorTra
		    lPagoOk := .F.
		    SET DEVICE TO SCREEN
*		    cError('EL CODIGO '+TRA->cCodigoEst+' EL VALOR NO COINCIDE')
		    SET DEVICE TO PRINT
		 ENDIF
*--------------FIN VALIDACION DEL PAGO

*--------------IMPRESION DEL REGISTRO DEL ESTUDIANTE
		 IF lValida

		    aTitulo := {}
		    AADD(aTitulo,cCodigoTgr)
		    FOR i := 1 TO LEN(cConcep)/2
			AADD(aTitulo,TRANS(aVlrAlu[i],"####,###,###"))
		    ENDFOR
		    AADD(aTitulo,TRANS(aVlrAlu[LEN(aVlrAlu)-1],"####,###,###"))
		    AADD(aTitulo,TRANS(aVlrAlu[LEN(aVlrAlu)],"####,###,###"))

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)+'->'+;
			       TRA->cCodRefTra+':'+;
			       IF(nVlrPag # TRA->nValorTra,;
				  TRANS(TRA->nValorTra,"####,###,###")+':'+;
				  TRANS(PAG->nVlrPagPag,"####,###,###"),'')
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO DEL ESTUDIANTE

	       SELECT TRA
	       SKIP

	    ENDDO
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********IMPRESION DEL REGISTRO DEL ESTUDIANTE
	    aTitulo := {}
	    AADD(aTitulo,GRU->cCodigoGru)
	    FOR i := 1 TO LEN(cConcep)/2
		AADD(aTitulo,TRANS(aVlrGru[i],"####,###,###"))
	    ENDFOR
	    AADD(aTitulo,TRANS(aVlrGru[LEN(aVlrGru)-1],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[LEN(aVlrGru)],"####,###,###"))

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)+IF(lPagoOk,'','.')
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO DEL ESTUDIANTE

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct

*--------------IMPRESION DE LOS TOTALES POR NIVEL
		 aTitulo := {}
		 AADD(aTitulo,SPACE(04))
		 FOR i := 1 TO LEN(cConcep)/2
		     AADD(aTitulo,REPL('-',aNroCol[i+1]))
		 ENDFOR
		 AADD(aTitulo,REPL('-',aNroCol[LEN(aVlrNiv)-1]))
		 AADD(aTitulo,REPL('-',aNroCol[LEN(aVlrNiv)]))
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		 aTitulo := {}
		 AADD(aTitulo,cNivAct)
		 FOR i := 1 TO LEN(cConcep)/2
		     AADD(aTitulo,TRANS(aVlrNiv[i],"####,###,###"))
		 ENDFOR
		 AADD(aTitulo,TRANS(aVlrNiv[LEN(aVlrNiv)-1],"####,###,###"))
		 AADD(aTitulo,TRANS(aVlrNiv[LEN(aVlrNiv)],"####,###,###"))

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 @ PROW()+1,00 SAY ''
*--------------FIN IMPRESION DE LOS TOTALES POR NIVEL

*--------------INICIALIZACION DE ACUMULADORES
		 aVlrNiv := {}
		 FOR i := 1 TO LEN(cConcep)/2
		     AADD(aVlrNiv,0)           // Conceptos Mes
		 ENDFOR
		 AADD(aVlrNiv,0)               // Interes
		 AADD(aVlrNiv,0)               // Total Nivel
*--------------FIN INICIALIZACION DE ACUMULADORES

	       cNivAnt := cNivAct

	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION DE LOS TOTALES
       aTitulo := {}
       AADD(aTitulo,SPACE(04))
       FOR i := 1 TO LEN(cConcep)/2
	   AADD(aTitulo,REPL('-',aNroCol[i+1]))
       ENDFOR
       AADD(aTitulo,REPL('-',aNroCol[LEN(aVlrNiv)-1]))
       AADD(aTitulo,REPL('-',aNroCol[LEN(aVlrNiv)]))
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       aTitulo := {}
       AADD(aTitulo,'TOT=')
       FOR i := 1 TO LEN(cConcep)/2
	   AADD(aTitulo,TRANS(aVlrTot[i],"####,###,###"))
       ENDFOR
       AADD(aTitulo,TRANS(aVlrTot[LEN(aVlrTot)-1],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[LEN(aVlrTot)],"####,###,###"))

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       @ PROW()+1,00 SAY ''
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>CIERRE DE ARCHIVOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseDbf('GRU')
       SELECT TRA
       SET INDEX TO
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN CIERRE DE ARCHIVOS