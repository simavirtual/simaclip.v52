/* SIMA - CENTRAL DE RIESGOS

MODULO      : DATACREDITO
SUBMODULO...: REPORTAR

**************************************************************************
* TITULO..: RESTAURAR NOVEDADES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2006 MAR A
       Colombia, Bucaramanga        INICIO: 07:00 AM   MAR 01/2006 MAR

OBJETIVOS:

1- Permite restaurar el reporte actual y cual consiste en dejar en blanco
   el campo de la novedad en el archivo de clientes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_105(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL cHayErr := ''                  // Descripci¢n del Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nHayErr := 0                   // 0 No hay Error
       LOCAL lErrRep := .T.                 // .T. Hay Errores en el reporte

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL nLenObs := 120                 // Longitud de la Observaci¢n
     *ÀInforme autom ticos

       LOCAL PathTem := ''                  // Path temporal
       LOCAL nMesRep := 0                   // Mes del Reporte
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte.
       LOCAL nNroFil := 0                   // N£mero de la Fila
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FDatAno+cAnoUsr+ExtFile,'ANO',;
			 NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SDA->nMesRepDat)
	    cError('NO FIGURA EL MES DEL ULTIMO REPORTE')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DEL ARCHIVO
       nMesIni := SDA->nMesRepDat
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)

       IF !FILE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)+'\'+;
		FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile)

	  cError('NO EXISTE EL ARCHIVO DE '+cMes(nMesIni)+;
		 ' DEL REPORTE')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>VALIDACION DEL MES DEL REPORTE
       lHayErr := .T.
       DO CASE
       CASE SUBS(ANO->cValRepDaA,nMesIni,1) # '2'
	    cError('EL REPORTE DE '+cMes(VAL(cMesIni))+' '+;
		   'NO FIGURA COMO CONFIRMADO')

       CASE LEN(RTRIM(ANO->cValRepDaA)) # nMesIni
	    cError('NO SE PUEDE RESTUARAR UN MES'+' '+;
		   'ANTERIOR AL ULTIMO REPORTADO')

       CASE VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) # 2
	    cError('EL ARCHIVO DEL REPORTE DE '+cMes(nMesIni)+' '+;
		   'NO HA SIDO CONFIRMADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA RESTAURAR EL MES DE '+cMes(nMesIni)+'? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES DEL REPORTE

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)+'\'+;
			 FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile,;
			 'REP',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE LEN(ALLTRIM(SCO->cCodEmpCon)) < 3
	    cError('EL CODIGO DE LA EMPRESA DEBE SER DE 3 CARACTERES')

       CASE EMPTY(SCO->cNomEmpCon)
	    cError('SE DEBE ESPECIFICAR EL NOMBRE DE LA EMPRESA')

       CASE EMPTY(SCO->cCiuEmpCon)
	    cError('SE DEBE ESPECIFICAR LA CIUDAD DE LA EMPRESA')

       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

       CASE REP->(RECCOUNT()) == 0
	    cError('NO SE EXISTEN REGISTROS DE REPORTE')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SDA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := SDA->lPrnArcDat
       cOpcPrn := SDA->cOpcPrnDat
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>RESTAURAR LAS NOVEDADES
       nNroFil := nMarco(03,'RESTAURANDO LAS NOVEDADES DEL MES DE '+;
			    cMes(nMesIni))
       SELECT REP
       REP->(DBGOTOP())
       DO WHILE .NOT. REP->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REGISTRO:'+REP->(STR(RECNO(),4))+'/'+;
				    REP->(STR(RECCOUNT(),4)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    PathTem := REP->cAnoSisRep+SUBS(cPatSis,5,4)

	    FilePag := PathDos+'\'+PathTem+'\'+;
		       'PAGOS\PA'+REP->cCodigoGru+;
		       SUBS(REP->cAnoSisRep,3,2)+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       cError('ABRIENDO DE PAGOS')
	       CloseDbf('PAG',FilePag,nModCry)

	       cHayErr := 'ABRIENDO EL ARCHIVO DE PAGOS '+FilePag
	       AADD(aHayErr,{REP->cCodigoEst,;
			     REP->cCodigoGru,;
			     REP->cAnoSisRep,;
			     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})

	       REP->(DBSKIP())
               nHayErr++
	       LOOP
	       
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE PAG->(RECCOUNT()) == 0

	       cHayErr := 'NO EXISTEN PAGOS GRABADOS PARA '+REP->cCodigoGru

	       AADD(aHayErr,{REP->cCodigoEst,;
			     REP->cCodigoGru,;
			     REP->cAnoSisRep,;
			     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})
	       cError(cHayErr)

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CloseDbf('PAG',FilePag,nModCry)
	       REP->(DBSKIP())
	       nHayErr++
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LOCALIZACION DEL PAGO
	    IF cAnoUsr == REP->cAnoSisRep

	       nMesRep := REP->nMesRepRep

/*
	       IF REP->nMesIniPag == REP->nMesFinPag

		  IF REP->nMesRepRep # REP->nMesIniPag
		     nMesRep := REP->nMesRepRep
		  ELSE
		     nMesRep := REP->nMesIniPag
		  ENDIF
		*ÀRecibo de solo mes

	       ELSE
		  nMesRep := REP->nMesIniPag  // Por Adelantado
	       ENDIF
Pendiente la confirmaci¢n para el a¤o debe ser el mes del reporte
*/

	    ELSE
	       nMesRep := REP->nMesIniPag
	    ENDIF


	    IF !lLocCodPag(REP->cCodigoEst,nMesRep,.F.)

	       CloseDbf('PAG',FilePag,nModCry)

	       cHayErr := 'NO EXISTE EL RECIBO DE '+;
			  cMes(REP->nMesIniPag)+' EN PAGOS'

	       AADD(aHayErr,{REP->cCodigoEst,;
			     REP->cCodigoGru,;
			     REP->cAnoSisRep,;
			     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})
	       cError(cHayErr)

	       REP->(DBSKIP())
               nHayErr++
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********RESTAURAR NOVEDAD
	    dFecPrn := CTOD(SUBS(REP->cFecActRep,5,2)+'/'+;
			    SUBS(REP->cFecActRep,7,2)+'/'+;
			    SUBS(REP->cFecActRep,1,4))

	    IF PAG->(lRegLock(lShared,.F.))

	       IF REP->cCodigoEst == PAG->cCodigoEst

		  IF !EMPTY(PAG->cNovRepPag)
		     REPL PAG->cNovAntPag WITH PAG->cNovRepPag
		  ENDIF

		  IF !EMPTY(PAG->dFecRepPag)
		     REPL PAG->dRepAntPag WITH PAG->dFecRepPag
		  ENDIF

		  REPL PAG->cNovRepPag WITH ''
		  REPL PAG->dFecRepPag WITH CTOD('00/00/00')

		  PAG->(DBCOMMIT())

	       ELSE
		  DO CASE
		  CASE REP->cCodigoEst # PAG->cCodigoEst

		       cHayErr := 'CODIGO DEL REPORTE:'+REP->cCodigoEst+;
				  ' DIFERETES '+;
				  'CODIGO EN PAGOS:'+PAG->cCodigoEst

		       AADD(aHayErr,{REP->cCodigoEst,;
				     REP->cCodigoGru,;
				     REP->cAnoSisRep,;
				     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})

		  CASE REP->nMesIniPag == PAG->nMesIniPag

		       cHayErr := 'MES DEL REPORTE:'+cMes(REP->nMesIniPag)+;
				  ' DIFERENTES '+;
				  'MES EN PAGOS:'+cMes(PAG->nMesIniPag)

		       AADD(aHayErr,{REP->cCodigoEst,;
				     REP->cCodigoGru,;
				     REP->cAnoSisRep,;
				     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})

		  ENDCASE
	       ENDIF

	    ELSE

	       cHayErr := 'NO SE GRABO EL REGISTRO EN PAGOS'
	       AADD(aHayErr,{REP->cCodigoEst,;
			     REP->cCodigoGru,;
			     REP->cAnoSisRep,;
			     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})
	       nHayErr++
	    ENDIF

	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN RESTAURAR NOVEDAD

**********GRABACION DEL REPORTE
	    IF REP->(lRegLock(lShared,.F.))

	       REPL REP->nValidoRep WITH REP->nValidoRep-1
	       REP->(DBCOMMIT())

	    ELSE
	       cHayErr := 'NO SE GRABO EL REGISTRO EN REPORTE'
	       AADD(aHayErr,{REP->cCodigoEst,;
			     REP->cCodigoGru,;
			     REP->cAnoSisRep,;
			     SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})
	    ENDIF
	    IF lShared
	       REP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REPORTE

**********VISUALIZACION DE CONTROL
	    nNroFil++

	    @ nNroFil,01 SAY STR(REP->nValidoRep,2)+':'+;
			     REP->cCodigoEst+' '+PAG->cCodigoEst+' '+;
			     REP->cNovedaRep+' '+cFecha(dFecPrn)

	    IF nNroFil == 21
	       nNroFil := nMarco(03,'RESTAURANDO LAS NOVEDADES DEL MES DE '+;
				    cMes(nMesIni))
	    ENDIF
**********FIN VISUALIZACION DE CONTROL

	  REP->(DBSKIP())

       ENDDO
*>>>>FIN RESTAURAR LAS NOVEDADES

*>>>>GRABACION DE LA VALIDACION DEL REPORTE
       IF ANO->(lRegLock(lShared,.F.))

	  IF LEN(aHayErr) == 0
	     REPL ANO->cValRepDaA WITH STUFF(ANO->cValRepDaA,nMesIni,1,'1')
	  ELSE
	     REPL ANO->cValRepDaA WITH STUFF(ANO->cValRepDaA,nMesIni,1,'9')
	  ENDIF

	  ANO->(DBCOMMIT())
       ELSE
	  cHayErr := 'NO SE GRABO EL REGISTRO:DAA'
	  AADD(aHayErr,{REP->cCodigoEst,;
			REP->cCodigoGru,;
			REP->cAnoSisRep,;
			SUBS(cHayErr+SPACE(nLenObs),1,nLenObs)})
       ENDIF

       IF lShared
	  ANO->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DE LA VALIDACION DEL REPORTE

*>>>>IMPRESION DE LAS INCONSISTENCIAS
       IF LEN(aHayErr) # 0

**********DEFINICION DEL ENCABEZADO
	    FilePrn := 'ErrReu'+cMes(nMesIni,3)
	    aCabPrn := {cNomEmp,cNomSis,;
			'INCONSISTENCIAS DATACREDITO',;
			'REPORTE DE '+cMes(nMesIni)+' DE '+cAnoUsr,;
			'FECHA DE CORTE '+cFecha(dFecPrn)}
**********FIN DEFINICION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    aNroCol := {}
	    aTitPrn := {}

	    AADD(aNroCol,6)
	    AADD(aTitPrn,'CODIGO')

	    AADD(aNroCol,6)
	    AADD(aTitPrn,'GRUPO')

	    AADD(aNroCol,4)
	    AADD(aTitPrn,'A¥O')

	    AADD(aNroCol,nLenObs)
	    AADD(aTitPrn,'OBSERVACION')
**********FIN ENCABEZADOS DE COLUMNA

**********IMPRESION DEL INFORME
	    cError('EXISTEN INCONSISTENCIAS',;
		   'ATENCION','PREPARE LA IMPRESORA')

	    PrnInforme(lShared,cNomSis,cNomEmp,cNomUsr,lPrnArc,cOpcPrn,;
		       FilePrn,aCabPrn,aNroCol,aTitPrn,aHayErr)
**********FIN IMPRESION DEL INFORME

       ENDIF
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>IMPRESION DE LAS INCONSISTENCIAS
