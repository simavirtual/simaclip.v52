/* SIMA - CENTRAL DE RIESGOS

MODULO      : DATACREDITO
SUBMODULO...: REPORTAR

**************************************************************************
* TITULO..: CONFIRMAR LAS NOVEDADES                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 24/2006 MAR A
       Colombia, Bucaramanga        INICIO: 07:00 AM   ENE 24/2006 MAR

OBJETIVOS:

1- Permite confirmar a traves de la grabaci¢n de las novedades en los
   pagos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_103(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nHayErr := 0                   // 0 No hay Error
       LOCAL lErrRep := .T.                 // .T. Hay Errores en el reporte

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

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DEL MES DEL REPORTE
       lHayErr := .T.
       DO CASE
       CASE EMPTY(SDA->nMesRepDat)
	    cError('NO EXISTE MES DEL ULTIMO REPORTE')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA FECHA DEL REPORTE

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
       CASE VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) == 0
	    cError('EL REPORTE DE '+cMes(VAL(cMesIni))+' '+;
		   'NO HA SIDO CREADO')

       CASE VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) == 2
	    cError('EL ARCHIVO DEL REPORTE DE '+cMes(nMesIni)+' '+;
		   'YA FUE CONFIRMADO')

       CASE nMesIni < LEN(RTRIM(ANO->cValRepDaA))
	    cError('NO SE PUEDE CONFIRMAR UN MES'+' '+;
		   'ANTERIOR AL ULTIMO REPORTADO')

       CASE nMesIni > LEN(RTRIM(ANO->cValRepDaA))
	    cError('NO SE PUEDE CONFIRMAR UN MES'+' '+;
		   'POSTERIOR AL ULTIMO REPORTADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA CONFIRMAR LAS NOVEDADES DEL MES DE '+;
		     cMes(nMesIni)+'? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL MES DEL REPORTE

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})

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

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RESTAURAR LAS NOVEDADES
       nNroFil := nMarco(03,'CONFIRMANDO LAS NOVEDADES DEL MES DE '+;
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

	       REP->(DBSKIP())

	       nHayErr++
	       LOOP
	       
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE PAG->(RECCOUNT()) == 0
		 cError('NO EXISTEN PAGOS GRABADOS PARA '+;
			REP->cCodigoGru)
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
	    nMesRep := REP->nMesIniPag
	    IF !lLocCodPag(REP->cCodigoEst,nMesRep,.F.)
	       CloseDbf('PAG',FilePag,nModCry)

	       nHayErr++
	       cError('ESTUDIANTE:'+REP->cCodigoEst+' '+;
		      'MES:'+STR(REP->nMesRepRep,2,0)+' '+;
		      'DEL REPORTE NO EXISTE EN PAGOS')

	       REP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********REGISTRAR NOVEDAD
	    dFecPrn := CTOD(SUBS(REP->cFecActRep,5,2)+'/'+;
			    SUBS(REP->cFecActRep,7,2)+'/'+;
			    SUBS(REP->cFecActRep,1,4))

	    IF PAG->(lRegLock(lShared,.F.))

	       IF REP->cCodigoEst == PAG->cCodigoEst

		  IF !EMPTY(PAG->cNovAntPag)
		     REPL PAG->cNovAntPag WITH PAG->cNovRepPag
		  ENDIF

		  IF !EMPTY(PAG->dRepAntPag)
		     REPL PAG->dRepAntPag WITH PAG->dFecRepPag
		  ENDIF

		  REPL PAG->cNovRepPag WITH REP->cNovedaRep
		  REPL PAG->dFecRepPag WITH dFecPrn

		  PAG->(DBCOMMIT())
	       ELSE
		  nHayErr++
		  cError('EL ESTUDIANTE:'+REP->cCodigoEst+' '+;
			 'ESTUDIANTE EN PAGOS:'+PAG->cCodigoEst+' '+;
			 'NO COINCIDE')
	       ENDIF

	    ELSE
	       cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	       nHayErr++
	    ENDIF

	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN REGISTRAR NOVEDAD

**********GRABACION DEL REPORTE
	    IF REP->(lRegLock(lShared,.F.))

	       REPL REP->nValidoRep WITH 1
	       REP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
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
	       nNroFil := nMarco(03,'CONFIRMANDO LAS NOVEDADES DEL MES DE '+;
				    cMes(nMesIni))
	    ENDIF
**********FIN VISUALIZACION DE CONTROL

	  REP->(DBSKIP())

       ENDDO
*>>>>FIN RESTAURAR LAS NOVEDADES

*>>>>GRABACION DE LA FECHA DEL REPORTE
       IF nHayErr == 0

	  IF SDA->(lRegLock(lShared,.F.))
	     REPL SDA->nMesRepDat WITH nMesIni
	     REPL SDA->dFecRepDat WITH dFecPrn
	     SDA->(DBCOMMIT())
	     lErrRep := .F.
	     cError('TODOS LOS REGISTROS SE REGISTRARON','ATENCION')
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF

	  IF lShared
	     SDA->(DBUNLOCK())
	  ENDIF

       ELSE
	  cError('SE PRESENTARON ERRORES EN LA CONFIRMACION DE LAS NOVEDADES')
       ENDIF
*>>>>FIN GRABACION DE LA FECHA DEL REPORTE

*>>>>GRABACION DE LA VALIDACION DEL REPORTE
       IF !lErrRep

	  IF ANO->(lRegLock(lShared,.F.))
	     REPL ANO->cValRepDaA WITH STUFF(ANO->cValRepDaA,nMesIni,1,'2')
	     ANO->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF

	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF

       ENDIF

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LA VALIDACION DEL REPORTE
