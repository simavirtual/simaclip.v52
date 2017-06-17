/* SIMA - CENTRAL DE RIESGOS

MODULO      : DATACREDITO
SUBMODULO...: REPORTAR

**************************************************************************
* TITULO..: GENERACION DEL REPORTE                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 17/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAR 17/2004 MIE

OBJETIVOS:

1- Permite crear el archivo para realizar el reporte mensual a DataCredito

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt,cVerSis)

*>>>>PARAMETROS DE LA FUNCION
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
       cJorTxt                              // Jornada escogida
       cVerSis	                            // Versi¢n del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

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

       LOCAL   i,j,k := 0                   // Contadores
       LOCAL lErrRep := .F.                 // .T. Hay Errores en el reporte
       LOCAL lSiPaso := .F.                 // Control de Flujo
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cDocNit := ''                  // Documento del Contratante
       LOCAL cTipDoc := ''                  // Tipo del Documento del Contrante
       LOCAL nRepIni := 0                   // A¤o Inicial del Reporte
       LOCAL nRepFin := 0                   // A¤o Final del Reporte
       LOCAL nIniAbo := 0                   // Mes Inicial del abono
       LOCAL nFinAbo := 0                   // Mes Final del abono

       LOCAL nCodPrn := 0                   // C¢digo de impresi¢n
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n
       LOCAL aErrRep := {}                  // Errores en el reporte
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes del Reporte',.T.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,.T.)
*>>>>FIN CAPTURA DEL MES

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecPrn)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+PathSis+'\'+;
			 fSimCar,'CAR',NIL,lShared,nModCry})

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
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE !lValRep(ANO->cValRepDaA,nMesIni)

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

       CASE SDA->nClaRepDat == 0
	    cError('SE DEBE DEFINIR LA CLASE DE REPORTE')

       CASE SDA->nClaRepDat > 2
	    cError('LA CLASE DE REPORTE '+STR(SDA->nClaRepDat,2)+' '+;
		   'NO ESTA PERMITIDA')

       CASE EMPTY(SDA->cTipMonDat)
	    cError('DEBE DEFINIR EL TIPO DE MONEDA')

       CASE EMPTY(SDA->cTipOblDat)
	    cError('DEBE DEFINIR EL TIPO DE OBLIGACION')

       CASE EMPTY(SDA->cTipGarDat)
	    cError('DEBE DEFINIR EL TIPO DE GARANTIA')

       CASE EMPTY(SDA->cPerPagDat)
	    cError('DEBE DEFINIR LA PERIODICIDAD DE PAGO')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE CAR->nRepIniCar == 0 .OR. CAR->nRepFinCar == 0
	    cError('NO SE HA DEFINIDO EL A¥O INICIAL O FINAL DE LA CARTERA')

       CASE VAL(cAnoUsr) < CAR->nRepFinCar
	    cError('SE DEBE REALIZAR EL REPORTE EN EL A¥O ACTUAL')

       CASE CAR->nRepIniCar > CAR->nRepFinCar
	    cError('EL A¥O INICIAL ES MAYOR AL A¥O FINAL DE LA CARTERA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE LA FECHA DE REPORTE
       lHayErr := .T.
       DO CASE
       CASE dFecPrn < SDA->dFecRepDat

	    cError('LA FECHA '+cFecha(dFecPrn)+' A REPORTAR ES '+;
		   'INFERIOR A '+cFecha(SDA->dFecRepDat)+' '+;
		   'DEL ULTIMO REPORTE')

       CASE YEAR(SDA->dFecRepDat) == YEAR(dFecPrn) .AND.;
	    nMesIni < SDA->nMesRepDat

	    cError(cMes(nMesIni)+' MES A REPORTAR ES INFERIOR A '+;
		   cMes(SDA->nMesRepDat)+' ULTIMO MES REPORTADO')

       CASE YEAR(SDA->dFecRepDat) == YEAR(dFecPrn) .AND.;
	    nMesIni > SDA->nMesRepDat+1

	    cError(cMes(nMesIni)+' MES A REPORTAR NO PUEDE SER '+;
		   'POSTERIOR A '+cMes(SDA->nMesRepDat)+' '+;
		   'ULTIMO MES REPORTADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA FECHA DE REPORTE

*>>>>ANALISIS DE LA VALIDACION DEL REPORTE
       lHayErr := .T.
       DO CASE
       CASE VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) == 9
	    cError('EL REPORTE DE '+cMes(VAL(cMesIni))+' '+;
		   'FIGURA PENDIENTE POR RESTAURAR')

       CASE VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) == 2
	    cError('EL ARCHIVO DEL REPORTE DE '+cMes(nMesIni)+' '+;
		   'YA FUE CONFIRMADO')

       CASE nMesIni > LEN(RTRIM(ANO->cValRepDaA))+1 .AND.;
	    LEN(RTRIM(ANO->cValRepDaA)) # 0

	    cError(cMes(nMesIni)+' NO SE PUEDE REPORTAR'+' '+;
		   'SIN HABER REPORTADO LOS MESES ANTERIORES')

       CASE nMesIni < LEN(RTRIM(ANO->cValRepDaA))

	    cError(cMes(nMesIni)+' ES UN MES ANTERIOR'+' '+;
		   'AL ULTIMO MES REPORTADO')

       OTHERWISE
	  lHayErr := .F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE LA VALIDACION DEL REPORTE

*>>>>VALIDACION DE LA EXISTENCIA DEL ARCHIVO
       IF FILE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)+'\'+;
		       FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile)

	  IF VAL(SUBS(ANO->cValRepDaA,nMesIni,1)) == 1

	     cError('EL ARCHIVO DEL REPORTE DE '+cMes(VAL(cMesIni))+' '+;
		    'YA SE CREO SATISFACTORIAMENTE')

	     IF !lPregunta('DESEA VOLVER A GENERAR EL ARCHIVO DE'+' '+;
			   cMes(VAL(cMesIni))+'?No Si')
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF

	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE LA EXISTENCIA DEL ARCHIVO

*>>>>VALIDACION DEL REPORTE
       cSavPan := SAVESCREEN(0,0,24,79)

       nRepIni := CAR->nRepIniCar
       nRepFin := CAR->nRepFinCar

       nCodPrn := SDA->nCodigoPrn
       lPrnArc := SDA->lPrnArcDat
       cOpcPrn := SDA->cOpcPrnDat
//* ojo
       FOR j := nRepIni TO nRepFin
	   FOR i := 1 TO LEN(cMaeAlu)/3
	       cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	       lValiRepo(lShared,nModCry,cNomSis,cPatSis,;
			 cMaeAct,cAnoUsr,STR(j,4),STR(nRepFin,4),;
			 nMesIni,PathUno,PathDos,@aErrRep)
	   ENDFOR
       ENDFOR
**/
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseAll(aUseDbf)
*>>>>FIN VALIDACION DEL REPORTE

*>>>>IMPRESION DE ERRORES
       IF LEN(aErrRep) # 0

	  PrnErrRep(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr,;
		    PathSis+'\'+FilePrn,nCodPrn,lPrnArc,cOpcPrn,;
		    nMesIni,dFecPrn,aErrRep)
	*ÀImpresi¢n de la inconsistencias

	  CloseAll(aUseDbf)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN IMPRESION DE ERRORES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+PathSis+'\'+;
			 fSimCar,'CAR',NIL,lShared,nModCry})

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

*>>>>VALIDACION DEL VALOR TOTAL DE LOS SERVICIOS
       IF !lValTotSer(lShared,nModCry,PathUno,cPatSis,FileNiv,ExtFile,;
		      CAR->nRepIniCar,CAR->nRepFinCar,cMaeAlu)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL VALOR TOTAL DE LOS SERVICIOS

*>>>>VALIDACION DEL TOTAL DE COUTAS
       IF !lValTotCou(lShared,nModCry,cPatSis,fDatAno,ExtFile,;
		      CAR->nRepIniCar,CAR->nRepFinCar)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL TOTAL DE COUTAS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO REPORT DEL MES
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)) == -3
	    DIRMAKE(cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3))
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO REPORT DEL MES

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA GENERAR EL REPORTE DE '+;
		     cMes(nMesIni)+' A FECHA DE CORTE '+cFecha(dFecPrn)+;
		     '? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CREACION DEL ARCHIVO DEL REPORTE
       CreaDbfRep(lShared,nModCry,cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3),;
		  FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile)
*>>>>FIN CREACION DEL ARCHIVO DEL REPORTE

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\REPORT\'+cMes(VAL(cMesIni),3)+'\'+;
		       FileRep+ALLTRIM(SCO->cCodEmpCon)+cMesIni+ExtFile,;
		       'REP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE REPORTES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO


*>>>>ANALISIS PARA CADA A¥O
       FOR j := CAR->nRepIniCar TO CAR->nRepFinCar

***********SELECCION DE LAS AREAS DE TRABAJO
	     cAnoSis := SUBS(STR(j,4),3,2)
	     cPatSis := STR(j,4)+SUBS(cPatSis,5,4)

	     IF !lUseDbf(.T.,PathDos+'\'+cPatSis+'\'+;
			     fCarAno+STR(j,4)+ExtFile,'CAA',;
			     NIL,lShared,nModCry)               .OR.;
		!lUseDbf(.T.,PathDos+'\'+cPatSis+'\'+;
			     FileTar,'TAR',NIL,lShared,nModCry) .OR.;
		!lUseDbf(.T.,PathDos+'\'+cPatSis+'\'+;
			     FileDes,'DES',;
			     PathDos+'\'+cPatSis+'\'+;
			     fNtxDes,lShared,nModCry)           .OR.;
		!lUseDbf(.T.,cPatSis+'\'+;
			     FDatAno+STR(j,4)+ExtFile,'DAA',;
			     NIL,lShared,nModCry)
		cError('ABRIENDO ARCHIVOS. A¥O:'+STR(j,4))
	     ENDIF
***********FIN SELECCION DE LAS AREAS DE TRABAJO

***********ANALISIS PARA CADA NIVEL
	     FOR i := 1 TO LEN(cMaeAlu)/3

*---------------SELECION DE LAS AREAS DE TRABAJO
		  cMaeAct := SUBS(cMaeAlu,i*3-2,3)

		  IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
		     !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
		     !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				  FileNiv+cAnoSis+ExtFile,'NIV',NIL,;
				  lShared,nModCry)
		     cError('ABRIENDO ARCHIVOS. A¥O:'+STR(j,4))
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*---------------FIN SELECION DE LAS AREAS DE TRABAJO

*---------------VALIDACION DE CONTENIDOS DE ARCHIVOS
		  lHayErr := .T.
		  SELECT &cMaeAct
		  DO CASE
		  CASE RECCOUNT() == 0
		       cError('NO EXISTE ESTUDIANTES GRABADOS')

		  CASE GRU->(RECCOUNT()) == 0
		       cError('NO EXISTE GRUPOS GRABADOS')

		  CASE NIV->(RECCOUNT()) == 0
		       cError('NO EXISTEN NIVELES CREADOS')

		  CASE DAA->(RECCOUNT()) == 0
		       cError('NO EXISTE CONFIGURACION DEL A¥O '+cAnoUsr)

		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE
		  IF lHayErr
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*---------------FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*---------------IMPRESION DEL INFORME PARA CADA GRUPO
		  SELECT GRU
		  GRU->(DBGOTOP())
* lLocCodigo('cCodigoGru','GRU','1103')  // ojo
		  DO WHILE .NOT. GRU->(EOF())

*....................PREPARACION DE LAS VARIABLES DE ARCHIVO
		       FileCli := PathDos+'\'+cPatSis+'\'+;
				  'CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

		       FilePag := PathDos+'\'+cPatSis+'\'+;
				  'PAGOS\PA'+GRU->cCodigoGru+cAnoSis+ExtFile
*....................FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*....................SELECION DE LAS AREAS DE TRABAJO
		       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
			  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

			  cError('ABRIENDO DE CLIENTES Y PAGOS')
			  CloseDbf('CLI',FileCli,nModCry)
			  CloseDbf('PAG',FilePag,nModCry)
			  CloseAll(aUseDbf)
			  RETURN NIL
		       ENDIF
*....................FIN SELECION DE LAS AREAS DE TRABAJO

*....................VALIDACION DE CONTENIDOS DE ARCHIVOS
		       lHayErr := .T.
		       DO CASE
		       CASE CLI->(RECCOUNT()) == 0
			    cError('NO EXISTEN CLIENTES GRABADOS PARA '+;
				   GRU->cCodigoGru)
		       OTHERWISE
			    lHayErr :=.F.
		       ENDCASE
		       IF lHayErr
			  CloseDbf('CLI',FileCli,nModCry)
			  CloseDbf('PAG',FilePag,nModCry)
			  SELECT GRU
			  GRU->(DBSKIP())
			  LOOP
		       ENDIF
*....................FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*....................GRABACION DEL REPORTE
		       IF !lSaveRep(lShared,nModCry,cNomSis,cNomUsr,;
				    cAnoUsr,cMaeAlu,GRU->cCodigoGru,;
				    nMesIni,j,CAR->nRepFinCar,dFecPrn,;
				    @aErrRep,SDA->nClaRepDat,cVerSis)
			  lErrRep := .T.
		       ENDIF
*....................FIN GRABACION DEL REPORTE

*....................AVANCE DEL SIGUIENTE GRUPO
		       CloseDbf('CLI',FileCli,nModCry)
		       CloseDbf('PAG',FilePag,nModCry)
		       SELECT GRU
		       GRU->(DBSKIP())
*....................FIN AVANCE DEL SIGUIENTE GRUPO

		  ENDDO
*---------------FIN IMPRESION DEL INFORME PARA CADA GRUPO

		CloseDbf('GRU')

	     ENDFOR
***********ANALISIS PARA CADA NIVEL

       ENDFOR
*>>>>FIN ANALISIS PARA CADA A¥O

*>>>>GRABACION DE LA VALIDACION DEL REPORTE
       IF LEN(aErrRep) == 0

	  IF ANO->(lRegLock(lShared,.F.))
	     REPL ANO->cValRepDaA WITH STUFF(ANO->cValRepDaA,nMesIni,1,'1')
	     ANO->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF

	  IF lShared
	     ANO->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION DE LA VALIDACION DEL REPORTE

*>>>>IMPRESION DE LAS INCONSISTENCIAS
       PrnErrRep(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr,;
		 PathSis+'\'+FilePrn,nCodPrn,lPrnArc,cOpcPrn,;
		 nMesIni,dFecPrn,aErrRep)
     *ÀImpresi¢n de la inconsistencias

       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)

       IF LEN(aErrRep) == 0
	  cError('REPORTE DE '+cMes(nMesIni)+' SE CREO SATIFACTORIAMENTE')
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LAS INCONSISTENCIAS

/*************************************************************************
* TITULO..: GRABACION DEL REPORTE                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 17/2004 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   MAR 17/2004 MIE

OBJETIVOS:

1- Permite grabar los datos del reporte

2- Retorna .T. si no existieron problemas en el reporte

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSaveRep(lShared,nModCry,cNomSis,cNomUsr,cAnoUsr,cMaeAlu,;
		  cCodGru,nMesIni,nAnoIni,nAnoFin,dFecPrn,aErrRep,;
		  nClaRep,cVerSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros habilitados
       cCodGru                              // C¢digo del Grupo
       nMesIni                              // Mes Inicial
       nAnoIni                              // A¤o Inicial
       nAnoFin                              // A¤o Final
       dFecPrn                              // Fecha de Impresi¢n de Corte
       aErrRep                              // @Errores del Reporte
       nClaRep                              // Clase de Reporte
       cVerSis	                            // Versi¢n del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lErrRep := .F.                 // .T. Hay Errores en el reporte

       LOCAL       i := 0                   // Contador
       LOCAL cFecPrn := ''                  // Fecha de Corte
       LOCAL aFecPrn := {}                  // Fecha de Corte
       LOCAL cDebugs := ''                  // Variable de Depuracion
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL lHayAlu := .F.                 // .T. Existe alumno
       LOCAL nMesFin := 0                   // Mes Final de Facturaci¢n
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cCalifi := ''                  // Calificaci¢n
       LOCAL cEdadNo := ''                  // Edad de la Novedad
       LOCAL nNroMes := 0                   // Meses de Mora
       LOCAL aFecPag := {}                  // Fecha de Pago
       LOCAL aFecAct := {}                  // Fecha de Actualizaci¢n
       LOCAL aFecNac := {}                  // Fecha de Nacimiento
       LOCAL dFecNac := CTOD('00/00/00')    // Fecha de Nacimiento
       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nDeuAct := 0                   // Deuda Actual
       LOCAL nMorAct := 0                   // Mora Actual
       LOCAL nRegPag := 0                   // Registro de Pago
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL aDetPag := {}                  // Detalles de los Pagos
       LOCAL nVlrPag := 0                   // Valor pagado
       LOCAL nVlrAbo := 0                   // Valor Abonos
       LOCAL nRecIni := 0                   // Mes Inicial del Primer Recibo
       LOCAL nTotCou := 0                   // Total Coutas

       LOCAL nIniAbo := 0                   // Mes Inicial del Abono
       LOCAL nFinAbo := 0                   // Mes Final del Abono

       LOCAL nRegPlz := 0                   // Registro Mes de Plazo

       LOCAL cDocNit := ''                  // Documento del Contratante
       LOCAL cTipDoc := ''                  // Tipo del Documento del Contrante
       LOCAL nNroCnt := 0                   // N£mero de Contratantes
       LOCAL lHayRep := .F.                 // .T. Hay Reporte
       LOCAL lNoRepo := .T.                 // .F. Reportar al contrante
       LOCAL nIniPen := 0                   // Mes Inicial de la Pension
       LOCAL nFinPen := 0                   // Mes Final de la Pension
       LOCAL cMsgErr := ''                  // Mensaje de Error

       LOCAL nMesIniTpa := 0                // Mes Inicial del Pago
       LOCAL nMesFinTpa := 0                // Mes Final del Pago
       LOCAL cNovRepTcl := ''               // Tipo de Novedad Reportada
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante

       LOCAL cCodigoTre := ''               // N£mero de la Cuenta o Obligaci¢n
       LOCAL cDocNitTre := ''	            // N£mero de Identificaci¢n
       LOCAL cNombreTre := ''		    // Nombre Completo del Reportado
       LOCAL cFecNacTre := ''		    // Fecha de Nacimiento
       LOCAL cFecApeTre := ''		    // Fecha de Apertura
       LOCAL cFecVtoTre := ''		    // Fecha de Vencimiento
       LOCAL cVlrMenTre := ''		    // Valor Couta Mensual
       LOCAL cNovedaTre := ''		    // Novedad
       LOCAL cAdjetiTre := ''		    // Adjetivo
       LOCAL cTipNitTre := ''		    // Tipo de Identificaci¢n
       LOCAL cVlrIniTre := ''		    // Valor Inicial
       LOCAL cSdoActTre := ''		    // Valor Saldo Deuda
       LOCAL cSdoMorTre := ''		    // Valor Saldo Mora
       LOCAL cVlrDisTre := ''		    // Valor Disponible
       LOCAL cTipMonTre := ''		    // Tipo de Moneda
       LOCAL cTipOblTre := ''		    // Tipo de Obligaci¢n
       LOCAL cTipGarTre := ''		    // Tipo de Garantia
       LOCAL cCalifiTre := ''		    // Calificaci¢n
       LOCAL cCiuResTre := ''		    // Ciudad de Residencia
       LOCAL cDirResTre := ''		    // Direcci¢n de Residencia
       LOCAL cTelResTre := ''		    // Telefono de Residencia
       LOCAL cCiuTraTre := ''               // Ciudad del Trabajo
       LOCAL cTelTraTre := ''		    // Telefono del Trabajo
       LOCAL cCiuEnvTre := ''		    // Ciudad de Correspondencia
       LOCAL cDirEnvTre := ''		    // Direccion de Correspondencia
       LOCAL cCoCiiuTre := ''		    // C¢digo Internacional Industrial Uniforme
       LOCAL cTotCouTre := ''		    // Total Coutas
       LOCAL cCouPagTre := ''		    // Coutas Canceladas
       LOCAL cCouMorTre := ''		    // Coutas Reportadas
       LOCAL cFecPagTre := ''		    // Fecha de Pago
       LOCAL cNomEmpTre := ''		    // Oficina de Radicaci¢n
       LOCAL cCiuEmpTre := ''		    // Ciudad de Radicaci¢n
       LOCAL cForPagTre := ''		    // Forma de Pago
       LOCAL cPerPagTre := ''		    // Periocidad de Pago
       LOCAL cEdaMorTre := ''		    // Edad de Mora o Pago Total
       LOCAL cFecActTre := ''		    // Fecha de Actualizaci¢n = Fecha l¡mite de pago en la v.2.5
       LOCAL cReclamTre := ''		    // Reclamo
       LOCAL cResponTre := ''		    // Responsable
       LOCAL cEstratTre := ''		    // Estrato
       LOCAL cFillerTre := ''		    // Filler
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FECHA DE CORTE
       aFecPrn := aFecha(dFecPrn)
       cFecPrn := aFecPrn[3]+aFecPrn[1]+aFecPrn[2]
*>>>>FIN FECHA DE CORTE


*>>>>RECORRIDO POR GRUPO
       nNroFil := nMarco(03,'RELACION DE FIADORES REPORTADOS. MES '+;
			    cMes(nMesIni)+' A '+cFecha(dFecPrn))
       SELECT CLI
       CLI->(DBGOTOP())
*GO 28  // ojo
       DO WHILE .NOT. CLI->(EOF())

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********LOCALIZACION DEL PAGO
	    nRegPlz := 0
	    nRecIni := nMesIniPag(CLI->cCodigoEst)
	  *ÀPrimer recibo

	    nIniPen := 0
	    nFinPen := 0

	    nIniAbo := 0
	    nFinAbo := 0

	    nMesIniTpa := 0
	    nMesFinTpa := 0
	    IF nAnoIni < VAL(cAnoUsr)

	       nIniFinPen(CLI->cCodigoEst,@nIniPen,@nFinPen)

	       nMesIniTpa := nMesUltPag(CLI->cCodigoEst)
	       IF lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)

		  nMesIniTpa := nMesIniTpa
		  nMesFinTpa := PAG->nMesFinPag

		  IF nMesFinTpa > nMesIniTpa .AND.;
		     PAG->cEstadoPag == 'D'
		     nMesFinTpa := nMesIniTpa
		  ENDIF

	       ENDIF

	    ELSE

	       nRegPag := nMesFacPag(CLI->cCodigoEst,nMesIni)

	       IF nRegPag # 0

		  PAG->(DBGOTO(nRegPag))

*=================PLAZO DEL SIGUIENTE MES
		    IF ANO->nMesPlzDaA # 0 .AND.;
		       PAG->nMesIniPag < CAA->nMesFinCaA

		       DO CASE
		       CASE PAG->cEstadoPag == 'P' .OR.;
			    PAG->cEstadoPag == 'A'

			    nIniPen := PAG->nMesIniPag
			    nFinPen := PAG->nMesFinPag
			  *ÀSe adiciono

		       CASE PAG->cEstadoPag == 'D'

			  nRegPlz := nMesFacPag(CLI->cCodigoEst,;
						nMesPlz(nMesIni,;
							CAA->nMesFinCaA,;
							ANO->nMesPlzDaA))

			  PAG->(DBGOTO(nRegPlz))

			  IF PAG->nSdoAntPag+PAG->nMorAntPag == 0
			     nIniAbo := PAG->nMesIniPag
			     nFinAbo := PAG->nMesFinPag
			     PAG->(DBGOTO(nRegPag))
			  ELSE
			     IF PAG->cEstadoPag == 'D'
				PAG->(DBGOTO(nRegPag))
			     ENDIF
			  ENDIF
			*ÀPaz y Salvo por Abono en el siguiente mes

		       ENDCASE

		    ENDIF
*=================FIN PLAZO DEL SIGUIENTE MES

		  nMesIniTpa := PAG->nMesIniPag
		  nMesFinTpa := PAG->nMesFinPag

		  IF nMesFinTpa > nMesIniTpa .AND.;
		     PAG->cEstadoPag == 'D'
		     nMesFinTpa := nMesIniTpa
		  ENDIF

	       ELSE

		  nMesIniTpa := nRecMesFac(CLI->cCodigoEst,nMesIni)
		  IF nMesIniTpa == 0
		     nMesIniTpa := nMesUltPag(CLI->cCodigoEst)
		    *Recibos anteriores al reporte retirados.
		  ELSE

		     nNroReg := nMesFacPag(CLI->cCodigoEst,nMesIniTpa)
		     PAG->(DBGOTO(nNroReg))
		   *ÀAdicionado

		  ENDIF

		  nRegPag := nIniFinPen(CLI->cCodigoEst,@nIniPen,@nFinPen)

		  IF nRegPag # 0 .AND. nMesIniTpa == PAG->nMesIniPag

		     nMesIniTpa := PAG->nMesIniPag
		     nMesFinTpa := PAG->nMesFinPag

		     IF nMesFinTpa > nMesIniTpa .AND.;
			PAG->cEstadoPag == 'D'
			nMesFinTpa := nMesIniTpa
		     ENDIF

		  ELSE

		     nRegPag := nNroReg
		     PAG->(DBGOTO(nRegPag))
		   *ÀSe adiciono

		     nIniPen := PAG->nMesIniPag
		     nFinPen := PAG->nMesFinPag
		   *ÀSe adiciono

		  ENDIF

		  IF lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)

		     nMesIniTpa := nMesIniTpa
		     nMesFinTpa := PAG->nMesFinPag

		     IF nMesFinTpa > nMesIniTpa .AND.;
			PAG->cEstadoPag == 'D'
			nMesFinTpa := nMesIniTpa
		     ENDIF

		  ENDIF

	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('A¥O : '+STR(nAnoIni,4)+' HASTA :'+STR(nAnoFin,4)+;
			'ºMES : '+cMes(nMesIniTpa)+;
			'ºGRUPO: '+cCodGru+;
			'ºCODIGO: '+CLI->cCodigoEst+;
			'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				STR(CLI->(RECCOUNT()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DEL MES A REPORTAR
	    lHayErr := .T.
	    DO CASE
	    CASE EMPTY(nMesIniTpa) .OR. EMPTY(nMesFinTpa)

		 // No se factura el recibo para nMesIni
		 cDebugs := ''

	    CASE &cMaeAct->lRetiroEst .AND.;
		 nMesIniTpa > &cMaeAct->nUltRecEst

		 cMsgErr := 'RETIRADO. SE FACTURO '+cMes(nMesIniTpa)+;
			    ' Y EL ULTIMO MES AUTORIZADO ES '+;
			    cMes(&cMaeAct->nUltRecEst)

		 AADD(aErrRep,{CLI->cCodigoEst,;
			       &cMaeAct->cCodigoGru+'-'+;
			       STR(CLI->(RECNO()),2),;
			       STR(nAnoIni,4),;
			       cNombreTes,SUBS(cMsgErr+SPACE(80),1,80)})
		 *1- C¢digo del Estudiante
		 *2- C¢digo del Grupo
		 *3- A¤o de la noveadad
		 *3- Nombre del Estudiante
		 *4- Observaci¢n

		 lErrRep := .T.
		 // Mes facturado mayor al ultimo mes autorizado

	    CASE nMesIniTpa > nMesFinTpa

		 lErrRep := .T.

		 cMsgErr := 'EL MES INICIAL '+cMes(nMesIniTpa)+' '+;
			    'ES MAYOR AL MES FINAL '+cMes(nMesFinTpa)

		 AADD(aErrRep,{CLI->cCodigoEst,;
			       &cMaeAct->cCodigoGru+'-'+;
			       STR(CLI->(RECNO()),2),;
			       STR(nAnoIni,4),;
			       cNombreTes,SUBS(cMsgErr+SPACE(80),1,80)})

	    CASE !&cMaeAct->lRetiroEst .AND. &cMaeAct->nUltRecEst # 0

		 lErrRep := .T.

		 cMsgErr := 'NO ESTA RETIRADO Y TIENE DEFINIDO EL ULTIMO '+;
			    'MES AUTORIZADO '+cMes(&cMaeAct->nUltRecEst)

		 AADD(aErrRep,{CLI->cCodigoEst,;
			       &cMaeAct->cCodigoGru+'-'+;
			       STR(CLI->(RECNO()),2),;
			       STR(nAnoIni,4),;
			       cNombreTes,SUBS(cMsgErr+SPACE(80),1,80)})

	    CASE EMPTY(PAG->dFecPagPag) .AND. PAG->cEstadoPag # 'D'

		 // Registro no punteado
		 cDebugs := ''

	    CASE nRegPlz == 0 .AND.;
		 nMesIniTpa > nMesIni .AND. VAL(cAnoUsr) == nAnoIni

		 // El primer recibo es posterior al mes del reporte
		 cDebugs := ''

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE
	    IF lHayErr
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
	    nRegPag := PAG->(RECNO())
**********FIN VALIDACION DEL MES A REPORTAR

**********CALCULO DE SALDO
	    nDeuAct := 0
	    nMorAct := 0
	    aDetPag := {}
	    nVlrPag := 0
	    nVlrAbo := 0
	    nSdoAct := aSdoAct(CLI->cCodigoEst,nMesIniTpa,dFecPrn,;
			       @nDeuAct,@nMorAct,@aDetPag,@nVlrPag,;
			       @nVlrAbo)
	    nVlrPag += nVlrAbo

	    SELECT PAG
	    PAG->(DBGOTO(nRegPag))
**********FIN CALCULO DE SALDO

**********LOCALLIZACION DEL NIVEL
	    IF !lLocCodigo('cCodigoNiv','NIV',SUBS(cCodGru,1,2))
	       cError('NO EXISTE EL NIVEL '+cCodGru+' DE '+cNombreTes)
	       CloseAll()
	       QUIT
	    ENDIF
**********FIN LOCALLIZACION DEL NIVEL

**********LECTURA DE LOS CONTRATANTES
	    aDocNit := {}
	    IF lHayAlu

	       FOR i := 1 TO DAA->nNroCntDaA

		   cDocNit := &(cMaeAct+'->cNitCo'+STR(i,1)+'Est')
		   cTipDoc := &(cMaeAct+'->cTipCo'+STR(i,1)+'Est')
		   lNoRepo := &(cMaeAct+'->lNoRCo'+STR(i,1)+'Est')

		   DO CASE
		   CASE DAA->nTipRepDaA == 1 .AND. !lNoRepo
			AADD(aDocNit,{cDocNit,cTipDoc})

		   CASE DAA->nTipRepDaA == 2 .AND. !lNoRepo
			IF !EMPTY(cDocNit)
			   AADD(aDocNit,{cDocNit,cTipDoc})
			ENDIF
		   ENDCASE

	       ENDFOR
	    ENDIF
**********FIN LECTURA DE LOS CONTRATANTES

**********RECORRIDO DE LOS REGISTROS
	    lHayRep := .F.
	    FOR i := 1 TO LEN(aDocNit)

*===============ANALISIS DE DECISION
		  IF EMPTY(aDocNit[i,1])  // Descartar los no definidos
		     LOOP
		  ENDIF
*===============FIN ANALISIS DE DECISION

*===============LECTURA DE LOS DATAS DE LAS PERSONAS
		  cDocNitTre := aDocNit[i,1]
		  cTipNitTre := aDocNit[i,2]

		  IF !lLeerDatos(cMaeAct,cDocNitTre,cTipNitTre,;
				 @cNombreTre,dFecNac,;
				 @cCiuResTre,@cDirResTre,@cTelResTre,;
				 @cCiuEnvTre,@cDirEnvTre,;
				 @cCiuTraTre,@cTelTraTre,;
				 @cEstratTre)



		     lErrRep := .T.

		     cMsgErr := 'LA CEDULA '+ALLTRIM(cDocNitTre)+' '+;
				'NO EXISTE EN PERSONAS'

		     AADD(aErrRep,{CLI->cCodigoEst,;
				   &cMaeAct->cCodigoGru+'-'+;
				   STR(CLI->(RECNO()),2),;
				   STR(nAnoIni,4),;
				   cNombreTes,SUBS(cMsgErr+SPACE(80),1,80)})

		     LOOP
		  ENDIF

		    aFecNac := aFecha(dFecNac)
		 cFecNacTre := aFecNac[3]+aFecNac[1]

		 cDocNitTre := SUBS(cDocNitTre+SPACE(11),1,11)
		 lCorrecion(@cDocNitTre,.T.)
*===============FIN LECTURA DE LOS DATAS DE LAS PERSONAS

*================NUMERO DE LA CUENTA U OBLIGACION. 2.3
		   IF i == 1
		      cCodigoTre := REPL('0',5)+;
				    STR(nAnoIni,4)+;
				    SCO->cCodEmpCon+CLI->cCodigoEst
		   ELSE
		      cCodigoTre := REPL('0',3)+;
				    STR(nAnoIni,4)+;
				    SCO->cCodEmpCon+CLI->cCodigoEst+;
				    'C'+STR(i-1,1)
		   ENDIF
*================FIN NUMERO DE LA CUENTA U OBLIGACION. 2.3

*================FECHA DE APERTURA. 2.6
		   cFecApeTre := STR(nRecIni,2)
		   lCorrecion(@cFecApeTre,.T.)
		   cFecApeTre := STR(nAnoIni,4)+cFecApeTre
*================FIN FECHA DE APERTURA. 2.6

*================FECHA DE VENCIMIENTO. 2.7
		   cFecVtoTre := STR(CAA->nMesFinCaA,2)
		   lCorrecion(@cFecVtoTre,.T.)
		   cFecVtoTre := STR(nAnoIni,4)+cFecVtoTre
*================FIN FECHA DE VENCIMIENTO. 2.7

*================VALOR COUTA MENSUAL. 2.35
		   cVlrMenTre := STR(nVlrMes(),10,0)
		   lCorrecion(@cVlrMenTre,.T.)
*================FIN VALOR COUTA MENSUAL. 2.35

*================NOVEDAD. 2.15
		   nMesFin := IF(EMPTY(&cMaeAct->nUltRecEst),;
				 CAA->nMesFinCaA,&cMaeAct->nUltRecEst)

		   cNovedaTre := ''
		   cNovedaTre := cNovedad(&cMaeAct->cCodigoEst,;
					  nDeuAct,;
					  PAG->cNovRepPag,;
					  cAnoUsr,nAnoIni,;
					  aDetPag,nMesIniTpa,;
					  @cCalifi,@cEdadNo,@nNroMes)

		   cDebugs := ''

		   IF (nMesFinTpa == nMesFin .OR. nFinPen == nMesFin) .AND.;
		      cNovedaTre == '01'

		      IF nAnoIni < VAL(cAnoUsr)
			 cNovedaTre := '05'
		      ELSE
			 DO CASE
			 CASE nMesFin <= nMesIni
			      cNovedaTre := '05'

			 CASE nFinPen == nMesFin
			      cNovedaTre := '05'

			 OTHERWISE
			 ENDCASE
		      ENDIF
		    *ÀModificado

		   ENDIF
*================FIN NOVEDAD. 2.15

/*
*================ANALISIS DE DECISION
		   DO CASE
		   CASE nAnoIni < VAL(cAnoUsr) .AND.;
			(cNovedaTre # '12' .AND. cNovedaTre # '14')

			LOOP

		   CASE nAnoIni == VAL(cAnoUsr)       .AND.;
			nMesIni #  PAG->nMesIniPag    .AND.;
			PAG->cNovRepPag == cNovedaTre .AND.;
			cNovedaTre == '05'

			LOOP // Descarta los meses diferentes

		   ENDCASE
*================FIN ANALISIS DE DECISION
*/

*================ANALISIS DE DECISION
		   DO CASE
		   CASE PAG->cNovRepPag == cNovedaTre .AND.;
			cNovedaTre == '05'

			LOOP // Descarta los meses diferentes

		   ENDCASE
*================FIN ANALISIS DE DECISION

*================ANALISIS DE LA NOVEDAD PARA A¥OS ANTERIORES
		   IF cNovedaTre == '01' .AND. nAnoIni < VAL(cAnoUsr)

		      cMsgErr := 'LA NOVEDAD:'+cNovedaTre+' '+;
				 'NO SE DEBE REPORTAR PARA A¥OS ANTERIORES'

		      AADD(aErrRep,{CLI->cCodigoEst,;
				    &cMaeAct->cCodigoGru+'-'+;
				    STR(CLI->(RECNO()),2),;
				    STR(nAnoIni,4),;
				    cNombreTes,SUBS(cMsgErr+SPACE(80),1,80)})
		   ENDIF
*================FIN ANALISIS DE LA NOVEDAD PARA A¥OS ANTERIORES

*================ANALISIS DE LOS RECIBOS POR ADELANTADO YA REPORTADOS
		   IF VAL(cAnoUsr) == nAnoIni       .AND.;
		      cNovedaTre == '01'            .AND.;
		      PAG->cNovRepPag == cNovedaTre .AND.;
		      nMesIni >= PAG->nMesIniPag    .AND.;
		      nMesIni <= PAG->nMesFinPag    .AND.;
		      PAG->nMesIniPag # PAG->nMesFinPag

		      LOOP // Descarta ya reportado

		   ENDIF
*================FIN ANALISIS DE LOS RECIBOS POR ADELANTADO YA REPORTADOS

*================ADJETIVO. 2.22
		   cAdjetiTre := '00'
*================FIN ADJETIVO. 2.22

*================VALOR INICIAL. 2.32
		   cVlrIniTre := STR(NIV->nVlrTotNiv,10,0)
		   lCorrecion(@cVlrIniTre,.T.)
*================FIN VALOR INICIAL. 2.32

*================SALDO DEUDA. 2.33
		   IF cNovedaTre == '05'
		      cSdoActTre := STR(0,10,0)
		   ELSE
		      IF NIV->nVlrTotNiv-nVlrPag > 0
			 cSdoActTre := STR(NIV->nVlrTotNiv-nVlrPag,10,0)
		      ELSE
			 cSdoActTre := STR(NIV->nVlrTotNiv,10,0)
		      ENDIF
		   ENDIF
		   lCorrecion(@cSdoActTre,.T.)
*================FIN SALDO DEUDA. 2.33

*================VALOR SALDO EN MORA. 2.36
		   cSdoMorTre := STR(nDeuAct+nMorAct,10,0)
		   lCorrecion(@cSdoMorTre,.T.)
*================FIN VALOR SALDO EN MORA. 2.36

*================VALOR DISPONIBLE. 2.34
		   cVlrDisTre := REPL('0',10)
*================FIN VALOR DISPONIBLE. 2.34

*================TIPO MONEDA. 2.27
		   cTipMonTre := SDA->cTipMonDat
*================FIN TIPO MONEDA. 2.27

*================TIPO DE OBLIGACION. 2.9
		   cTipOblTre := SDA->cTipOblDat
*================FIN TIPO DE OBLIGACION. 2.9

*================TIPO DE GARANTIA. 2.28
		   cTipGarTre := SDA->cTipGarDat
*================FIN TIPO DE GARANTIA. 2.28

*================CALIFICACION. 2.29
		   cCalifiTre := cCalifi
*================FIN CALIFICACION. 2.29

*================CODIGO INTERNACIONAL INDUSTRIAL UNIFORME. CIIU. 2.26
		   cCoCiiuTre := REPL('0',6)
*================FIN CODIGO INTERNACIONAL INDUSTRIAL UNIFORME. CIIU. 2.26

*================TOTAL COUTAS. 2.37
		      nTotCou := nMesFin-nRecIni+1
		   cTotCouTre := STR(nTotCou,3,0)
		   lCorrecion(@cTotCouTre,.T.)
*================FIN TOTAL COUTAS. 2.37

*================COUTAS CANCELADAS. 2.38
		   cCouPagTre := STR(nCoutasPag(aDetPag,nMesIniTpa),3,0)
		   lCorrecion(@cCouPagTre,.T.)
*================FIN COUTAS CANCELADAS. 2.38

*================COUTAS EN MORA. 2.39
		   cCouMorTre := STR(nNroMes,3,0)
		   lCorrecion(@cCouMorTre,.T.)
*================FIN COUTAS EN MORA. 2.39

*================FECHA DE PAGO. 2.43
		   IF nSdoAct == 0
		      nNroMesPag(@aFecPag)
		      cFecPagTre := IF(EMPTY(PAG->dFecPagPag),REPL('0',8),;
				       aFecPag[3]+aFecPag[1]+aFecPag[2])
		   ELSE
		      cFecPagTre := REPL('0',8)
		   ENDIF
*================FIN FECHA DE PAGO. 2.43

*================OFICINA DE RADICACION. 2.44
		   cNomEmpTre := SUBS(SCO->cNomEmpCon,1,15)
*================FIN OFICINA DE RADICACION. 2.44

*================CIUDAD DE RADICACION. 2.32
		   cCiuEmpTre := SUBS(SCO->cCiuEmpCon,1,15)
*================FIN CIUDAD DE RADICACION. 2.32

*================FORMA DE PAGO. 2.13
		   IF cNovedaTre == '05' .OR. cNovedaTre == '14'
		      cForPagTre := '1'       // Voluntario
		   ELSE
		      cForPagTre := '0'       // Vigente
		   ENDIF
*================FIN FORMA DE PAGO. 2.13

*================PERIODICIDAD DE PAGO. 2.14
		   cPerPagTre := SDA->cPerPagDat
*================FIN PERIODICIDAD DE PAGO. 2.14

*================EDAD DE LA MORA O PAGO TOTAL. 2.31
		   cEdaMorTre := cEdadNo
*================FIN EDAD DE LA MORA O PAGO TOTAL. 2.31

*================FECHA LIMITE DE PAGO. 2.42
		   cFecActTre := STR(PAG->nMesIniPag,2)
		   lCorrecion(@cFecActTre,.T.)
		   IF VAL(cFecActTre) == 2
		      cFecActTre := STR(nAnoIni,4)+cFecActTre+'28'
		   ELSE
		      cFecActTre := STR(nAnoIni,4)+cFecActTre+'28'
		   ENDIF
*================FIN FECHA LIMITE DE PAGO. 2.42

*================RECLAMO. 2.37  no se encuentra en la version:2.15
		   cReclamTre := '0'
*================FIN RECLAMO. 2.37

*================RESPONSABLE. 2.8
		   cResponTre := IF(i==1,'00','01')
*================FIN RESPONSABLE. 2.8

*================FILLER. 2.64
		   cFillerTre := REPL('0',14)
*================FIN FILLER. 2.64

*==============VISUALIZACION DE CONTROL
		 nNroFil++

		 @ nNroFil,01 SAY cDocNitTre+' '+;
				  &cMaeAct->cCodigoEst+' '+;
				  cNombreTes+' '+;
				  &cMaeAct->cCodigoGru+':'+;
				  'NOVEDAD:'+cNovedaTre

		 IF EMPTY(cNovedaTre)

		    lErrRep := .T.

		    cMsgErr := 'NO TIENE NOVEDAD PARA DATACREDITO'

		    AADD(aErrRep,{CLI->cCodigoEst,;
				  &cMaeAct->cCodigoGru+'-'+;
				  STR(CLI->(RECNO()),2),;
				  STR(nAnoIni,4),;
				  cNombreTes,SUBS(cMsgErr+SPACE(80),1,80)})

		    cError(&cMaeAct->cCodigoEst,cMsgErr)

		 ENDIF

		 IF nNroFil == 21
		    nNroFil := nMarco(03,'RELACION DE FIADORES REPORTADOS. '+;
					 'MES '+cMes(nMesIni)+' A '+;
					 cFecha(dFecPrn))
		 ENDIF
*==============FIN VISUALIZACION DE CONTROL

*==============GRABACION DEL REPORTE
		 IF REP->(lRegLock(lShared,.T.))

		    lHayRep := .T.
		    REPL REP->cCodigoEst WITH CLI->cCodigoEst
		    REPL REP->cCodigoGru WITH &cMaeAct->cCodigoGru
		    REPL REP->cAnoSisRep WITH STR(nAnoIni,4)
		    REPL REP->cVerSisRep WITH cVerSis
		    REPL REP->nMesRepRep WITH nMesIni
		    REPL REP->cFecPrnRep WITH cFecPrn
		    IF nIniAbo # 0 .AND. nFinAbo # 0
		       REPL REP->nMesIniPag WITH nIniAbo
		       REPL REP->nMesFinPag WITH nFinAbo
		    ELSE
		       REPL REP->nMesIniPag WITH nMesIniTpa
		       REPL REP->nMesFinPag WITH nMesFinTpa
		    ENDIF
		    REPL REP->nSdoActRep WITH nDeuAct
		    REPL REP->nSdoMorRep WITH nMorAct
		    REPL REP->nVlrPagRep WITH nVlrPag - nVlrAbo
		    REPL REP->nVlrAboRep WITH nVlrAbo
		    REPL REP->cCodigoRep WITH cCodigoTre
		    REPL REP->cDocNitRep WITH cDocNitTre
		    REPL REP->cNombreRep WITH cNombreTre
		    REPL REP->cFecNacRep WITH cFecNacTre
		    REPL REP->cFecApeRep WITH cFecApeTre
		    REPL REP->cFecVtoRep WITH cFecVtoTre
		    REPL REP->cVlrMenRep WITH cVlrMenTre
		    REPL REP->cNovedaRep WITH cNovedaTre
		    REPL REP->cAdjetiRep WITH cAdjetiTre
		    REPL REP->cTipNitRep WITH cTipNitTre
		    REPL REP->cVlrIniRep WITH cVlrIniTre
		    REPL REP->cSdoActRep WITH cSdoActTre
		    REPL REP->cSdoMorRep WITH cSdoMorTre
		    REPL REP->cVlrDisRep WITH cVlrDisTre
		    REPL REP->cTipMonRep WITH cTipMonTre
		    REPL REP->cTipCtaRep WITH cTipOblTre
		    REPL REP->cTipGarRep WITH cTipGarTre
		    REPL REP->cCalifiRep WITH cCalifiTre
		    REPL REP->cCiuResRep WITH cCiuResTre
		    REPL REP->cDirResRep WITH cDirResTre
		    REPL REP->cTelResRep WITH cTelResTre
		    REPL REP->cCiuTraRep WITH cCiuTraTre
		    REPL REP->cTelTraRep WITH cTelTraTre
		    REPL REP->cCiuEnvRep WITH cCiuEnvTre
		    REPL REP->cDirEnvRep WITH cDirEnvTre
		    REPL REP->cCoCiiuRep WITH cCoCiiuTre
		    REPL REP->cTotCouRep WITH cTotCouTre
		    REPL REP->cCouPagRep WITH cCouPagTre
		    REPL REP->cCouMorRep WITH cCouMorTre
		    REPL REP->cFecPagRep WITH cFecPagTre
		    REPL REP->cNomEmpRep WITH cNomEmpTre
		    REPL REP->cCiuEmpRep WITH cCiuEmpTre
		    REPL REP->cForPagRep WITH cForPagTre
		    REPL REP->cPerPagRep WITH cPerPagTre
		    REPL REP->cEdaMorRep WITH cEdaMorTre
		    REPL REP->cFecActRep WITH cFecActTre
		    REPL REP->cReclamRep WITH cReclamTre
		    REPL REP->cResponRep WITH cResponTre
		    REPL REP->cEstratRep WITH cEstratTre
		    REPL REP->cFillerRep WITH cFillerTre

		    REPL REP->nRegPagRep WITH nRegPag
		    REPL REP->cNomUsrPag WITH cNomUsr
		    REPL REP->dFecUsrPag WITH DATE()
		    REPL REP->cHorUsrPag WITH TIME()

		    REPL REP->nNroCntDaA WITH DAA->nNroCntDaA
		    REPL REP->nTipRepDaA WITH DAA->nTipRepDaA
		    REPL REP->nValCntDaA WITH DAA->nValCntDaA

		    REP->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
		 ENDIF
		 IF lShared
		    REP->(DBUNLOCK())
		 ENDIF
*==============FIN GRABACION DEL REPORTE

	    NEXT
**********FIN RECORRIDO DE LOS REGISTROS

/*
**********GRABACION DE LA NOVEDAD REPORTADA EN PAGOS
	    IF lHayRep

	       IF PAG->(lRegLock(lShared,.F.))

		  DO CASE
		  CASE VAL(cAnoUsr) == nAnoIni
		       REPL PAG->cNovRepPag WITH cNovedaTre

		  CASE nAnoIni < VAL(cAnoUsr) .AND.;
		       (cNovedaTre == '12' .OR. cNovedaTre == '14')

		       REPL PAG->cNovRepPag WITH cNovedaTre
		  ENDCASE

		  PAG->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO NO FIADOR')
	       ENDIF
	       IF lShared
		  PAG->(DBUNLOCK())
	       ENDIF

	    ENDIF
**********FIN GRABACION DE LA NOVEDAD REPORTADA EN PAGOS
*/

**********GRABACION DE LA FECHA DEL REPORTE
	    IF lHayRep .AND. !lErrRep
	       IF SDA->(lRegLock(lShared,.F.))
		  REPL SDA->nMesRepDat WITH nMesIni
		  REPL SDA->dFecRepDat WITH dFecPrn
		  SDA->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	       ENDIF
	       IF lShared
		  SDA->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DE LA FECHA DEL REPORTE


	  CLI->(DBSKIP())

       ENDDO
       RETURN lErrRep
*>>>>FIN RECORRIDO POR GRUPO

/*************************************************************************
* TITULO..: DATOS DEL CONTRATANTE                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 28/2004 MIE A
       Colombia, Bucaramanga        INICIO: 02:20 PM   JUL 28/2004 MIE

OBJETIVOS:

1- Permite leer los datos de las personas del maestro

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeerDatos(cMaeAct,cDocNit,cTipNit,cNombre,cFecNac,;
		    cCiuRes,cDirRes,cTelRes,cCiuEnv,cDirEnv,;
		    cCiuTra,cTelTra,cEstrat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cMaeAct                              // Maestro Actual
       cDocNit                              // Documento de Identidad
       cTipNit                              // Tipo de Documento
       cNombre                              // @Nombre de la Persona
       cFecNac                              // @Fecha de Nacimiento
       cCiuRes                              // @Ciudad de Residencia
       cDirRes                              // @Direccion de la Residencia
       cTelRes                              // @Telefono de Residencia
       cCiuEnv                              // @Ciudad de Correspondencia
       cDirEnv                              // @Direccion de Correspondencia
       cCiuTra                              // @Ciudad del Trabajo
       cTelTra                              // @Telefono del Trabajo
       cEstrat                              // @Estrato de la Persona */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nTipPer := 0                   // Tipo de Persona
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TIPO DE PERSONA
       nTipPer := nTipPerMae(cDocNit,;
			     &cMaeAct->cPadNitEst,;
			     &cMaeAct->cMadNitEst)
*>>>>FIN TIPO DE PERSONA

*>>>>LECTURA DE LOS DATOS
       DO CASE
       CASE nTipPer == 1                    // Padre

	    cNombre := ALLTRIM(&cMaeAct->cApePadEst)+' '+;
		       ALLTRIM(&cMaeAct->cNomPadEst)

	    cFecNac := &cMaeAct->dNacPadEst

	    cDirRes := &cMaeAct->cDirPadEst
	    cCiuRes := &cMaeAct->cCiuPadEst
	    cTelRes := &cMaeAct->cTelPadEst

	    cCiuTra := &cMaeAct->cCiuPadEst
	    cTelTra := &cMaeAct->cTelPadEst

	    cDirEnv := cDirRes
	    cCiuEnv := cCiuRes

	    cEstrat := STR(&cMaeAct->nEstratEst,1)

       CASE nTipPer == 2                    // Madre

	    cNombre := ALLTRIM(&cMaeAct->cApeMadEst)+' '+;
		       ALLTRIM(&cMaeAct->cNomMadEst)

	    cFecNac := &cMaeAct->dNacMadEst

	    cDirRes := &cMaeAct->cDirMadEst
	    cCiuRes := &cMaeAct->cCiuMadEst
	    cTelRes := &cMaeAct->cTelMadEst

	    cCiuTra := &cMaeAct->cCiuMadEst
	    cTelTra := &cMaeAct->cTelMadEst

	    cDirEnv := cDirRes
	    cCiuEnv := cCiuRes

	    cEstrat := STR(&cMaeAct->nEstratEst,1)

       CASE nTipPer == 3                    // Otra Persona

	    lHayErr := .T.
	    IF lLocNitPer(cDocNit,cTipNit)

	       cNombre := cNomPer(PER->cApeUnoPer,;
				  PER->cApeDosPer,;
				  PER->cNomUnoPer,;
				  PER->cNomDosPer)

	       cFecNac := PER->dFecNacPer

	       cDirRes := PER->cDireccPer
	       cCiuRes := PER->cCiudadPer
	       cTelRes := PER->cTelefnPer

	       cCiuTra := PER->cCiuTraPer
	       cTelTra := PER->cTelTraPer

	       cDirEnv := PER->cDirEnvPer
	       cCiuEnv := PER->cCiuEnvPer

	       lHayErr := .F.
	    ENDIF
       ENDCASE
*>>>>FIN LECTURA DE LOS DATOS

*>>>>VALIDACION DE LOS DATOS
       cNombre := SUBS(cNombre+SPACE(45),1,45)

       cDirRes := SUBS(cDirRes+SPACE(30),1,30)
       cCiuRes := SUBS(cCiuRes+SPACE(15),1,15)
       cTelRes := SUBS(cTelRes+SPACE(10),1,10)

       cCiuTra := SUBS(cCiuTra+SPACE(15),1,15)
       cTelTra := SUBS(cTelTra+SPACE(10),1,10)

       cDirEnv := SUBS(cDirEnv+SPACE(30),1,30)
       cCiuEnv := SUBS(cCiuEnv+SPACE(15),1,15)

       RETURN !lHayErr
*>>>>FIN VALIDACION DE LOS DATOS

/*************************************************************************
* TITULO..: VALIDACION DEL REPORTE                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 18/2005 LUN A
       Bucaramanga, Colombia	    INICIO: 05:00 PM   JUL 18/2005 LUN

OBJETIVOS:

1- Validaci¢n de la forma de pago

2- Retorna .T. si no hay problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValiRepo(lShared,nModCry,cNomSis,cPatSis,cMaeAct,cAnoUsr,;
		   cAnoIni,cAnoFin,nMesIni,PathUno,PathDos,aHayErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cPatSis                              // Path del Sistema
       cMaeAct                              // Maestro Actual
       cAnoUsr                              // A¤o Actual
       cAnoIni				    // A¤o Inicial
       cAnoFin                              // A¤o Final
       nMesIni                              // Mes Inicial
       PathUno                              // Path de Integraci¢n Uno
       PathDos                              // Path de Integraci¢n Dos
       aHayErr                              // Hay Errores */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := ''                  // A¤o del Sistema
       LOCAL lHayAlu := .F.                 // .T. Existe alumno
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lError  := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL cDocNit := ''                  // Documento del Contratante
       LOCAL cTipDoc := ''                  // Tipo del Documento del Contrante
       LOCAL lNoRCon := .F.                 // .T. No Reportar .F. Si Reportar

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       cAnoSis := SUBS(cAnoIni,3,2)
       cPatSis := cAnoIni+SUBS(cPatSis,5,4)

       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+cPatSis+'\'+;
			 fCarAno+cAnoIni+ExtFile,'CAA',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FDatAno+cAnoIni+ExtFile,'DAA',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
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

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O:'+cAnoIni)

       CASE EMPTY(CAA->nMesFinCaA)
	    cError('NO SE HA DEFINIDO EL ULTIMO MES DE FACTURACION.'+;
		   'A¥O:'+cAnoIni)

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO.'+;
		   'A¥O:'+cAnoIni)

       CASE DAA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O:'+cAnoIni)

       CASE DAA->nTotCouDaA == 0
	    cError('FALTA DEFINIR EL TOTAL DE CUOTAS. A¥O:'+cAnoIni)

       CASE DAA->nNroCntDaA == 0
	    cError('NO SE HA DEFINIDO EL NUMERO DE CONTRATANTES A REPORTAR. A¥O:'+cAnoIni)

       CASE DAA->nNroCntDaA > 4
	    cError('NO SE PUEDE REPORTAR MAS 4 CONTRATANTES. A¥O:'+cAnoIni)

       CASE DAA->nTipRepDaA == 0
	    cError('NO SE HA DEFINIDO EL TIPO DE REPORTE. A¥O:'+cAnoIni)

       CASE DAA->nTipRepDaA > 2
	    cError('EL TIPO DE REPORTE NO PUEDE SER > 2. A¥O:'+cAnoIni)

       CASE DAA->nValCntDaA == 0
	    cError('DEBE DEFINIR EL TIPO DE VALIDACION DE CONTRATANTES. A¥O:'+cAnoIni)

       CASE DAA->nValCntDaA > 4 .AND. DAA->nValCntDaA < 9
	    cError('NUMERO DE VALIDACION NO PERMITIDA:'+;
		   STR(DAA->nValCntDaA,1))

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN !lHayErr
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := PathDos+'\'+cPatSis+'\'+;
		       'CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := PathDos+'\'+cPatSis+'\'+;
		       'PAGOS\PA'+GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       cError('ABRIENDO DE CLIENTES Y PAGOS')
	       CloseAll(aUseDbf)
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS PARA '+;
			GRU->cCodigoGru)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseAll(aUseDbf)
	       RETURN !lHayErr
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********VALIDACION POR CLIENTES
	    nNroFil := nMarco(03,'VALIDANDO LA INFORMACION A REPORTAR.'+;
			      IF(DAA->nValCntDaA==9,;
			      'NO ESTA VALIDANDO CONTRATANTES',;
			      'ESTA VALIDANDO '+STR(DAA->nValCntDaA,1)+' '+;
			      'CONTRATANTE(S)'))
	    SELECT CLI
	    CLI->(DBGOTOP())
	    DO WHILE .NOT. CLI->(EOF())

*==============IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('A¥O:'+cAnoIni+' HASTA:'+cAnoFin+;
			     'ºGRUPO: '+GRU->cCodigoGru+;
			     'ºCODIGO: '+CLI->cCodigoEst+;
			     'ºMES: '+cMes(nMesIni)+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
*==============FIN IMPRESION DE LA LINEA DE ESTADO

*==============ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetgruCli
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*==============LOCALIZACION DEL PAGO
		 nMesIniTpa := 0
		 IF VAL(cAnoIni) < VAL(cAnoUsr)
		    nMesIniTpa := nMesUltPag(CLI->cCodigoEst)
		 ELSE
		    IF lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
		       nMesIniTpa := nMesIni
		    ENDIF
		 ENDIF

		 IF EMPTY(nMesIniTpa)
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN LOCALIZACION DEL PAGO

*==============VALIDACION DE LA FORMA DE PAGO
		 lHayErr := .F.
		 DO CASE
		 CASE PAG->cEstadoPag == 'P' .AND. !EMPTY(PAG->dFecPagPag)
		 CASE PAG->cEstadoPag == 'A' .AND. !EMPTY(PAG->dFecPagPag)
		 CASE PAG->cEstadoPag == 'D'
		 OTHERWISE
		      lHayErr := .T.
		 ENDCASE
		 IF lHayErr
		    cError('CODIGO:'+CLI->cCodigoEst+' '+;
			   'GRUPO:'+GRU->cCodigoGru+' '+;
			   'NO SE LE HA DEFINIDO LA FORMA DE PAGO')
		    CloseAll(aUseDbf)
		    RETURN !lHayErr
		 ENDIF
*==============VALIDACION DE LA FORMA DE PAGO

*==============BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 cNombreTes := 'EL ALUMNO NO EXISTE'
		 IF DAA->nValCntDaA # 9
		    IF !lSekCodMae(CLI->cCodigoEst,cMaeAct,@cMaeAct)
		       cError('CODIGO:'+CLI->cCodigoEst+' '+;
			      'NO EXISTE EN EL ARCHIVO DE ALUMNOS')

		       CloseAll(aUseDbf)
		       RETURN .F.
		    ENDIF
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ENDIF
                 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
*==============FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*==============CONSULTA DE LA VALIDACION
		 nNroFil++
		 IF DAA->nValCntDaA # 9
		    @ nNroFil,01 SAY cAnoIni+' '+;
				     &cMaeAct->cCodigoEst+' '+;
				     &cMaeAct->cCodigoGru+' '+;
				     &cMaeAct->cNitCo1Est+' '+;
				     &cMaeAct->cNitCo2Est+' '+;
				     &cMaeAct->cNitCo3Est+' '+;
				     ALLTRIM(&cMaeAct->cNitCo3Est)
		 ELSE
		    @ nNroFil,01 SAY cAnoIni+' '+;
				     CLI->cCodigoEst+' '+;
				     GRU->cCodigoGru
		 ENDIF

		 IF nNroFil == 21
		    nNroFil := nMarco(03,'VALIDANDO LA INFORMACION A '+;
					 'REPORTAR.'+;
				      IF(DAA->nValCntDaA==9,;
					 'NO ESTA VALIDANDO CONTRATANTES',;
					 'ESTA VALIDANDO '+;
					 STR(DAA->nValCntDaA,1)+' '+;
					 'CONTRATANTE(S)'))
		 ENDIF
*==============FIN CONSULTA DE LA VALIDACION

*==============VALIDACION DE LOS CONTRATANTES
		 IF DAA->nValCntDaA # 9

*-------------------VALIDACION DEL CONTRATANTE
		      lHayErr := .F.
		      FOR i := 1 TO DAA->nValCntDaA

*:::::::::::::::::::::::VALIDACION DE LA CEDULA
			  cDocNit := &(cMaeAct+'->cNitCo'+STR(i,1)+'Est')
			  cTipDoc := &(cMaeAct+'->cTipCo'+STR(i,1)+'Est')
			  lNoRCon := &(cMaeAct+'->lNoRCo'+STR(i,1)+'Est')

			  IF i == 1 .AND. EMPTY(cDocNit) .AND.  !lNoRCon

			     IF (EMPTY(&cMaeAct->cNitCo1Est) .AND.;
				 !&cMaeAct->lNoRCo1Est) .AND.;
				(EMPTY(&cMaeAct->cNitCo2Est) .AND.;
				 !&cMaeAct->lNoRCo2Est) .AND.;
				(EMPTY(&cMaeAct->cNitCo3Est) .AND.;
				 !&cMaeAct->lNoRCo3Est) .AND.;
				(EMPTY(&cMaeAct->cNitCo4Est) .AND.;
				 !&cMaeAct->lNoRCo4Est)

				 cHayErr := 'CODIGO:'+CLI->cCodigoEst+' '+;
					    'GRUPO:'+GRU->cCodigoGru+' '+;
					    'NO SE LE HAN DEFINIDO LOS '+;
					    'CONTRATANTES'

				 AADD(aHayErr,{CLI->cCodigoEst,;
					       GRU->cCodigoGru+'-'+;
					       STR(CLI->(RECNO()),2),;
					       cAnoIni,cNombreTes,;
					       SUBS(cHayErr+SPACE(80),1,80)})

				lError := .T.

			     ENDIF

			  ENDIF

			  IF EMPTY(cDocNit) .AND. DAA->nTipRepDaA == 2
			     cHayErr := 'CODIGO:'+CLI->cCodigoEst+' '+;
					'GRUPO:'+GRU->cCodigoGru+' '+;
					'NO SE LE HA DEFINIDO EL '+;
					'CONTRATANTE No.'+STR(i,1)

			     AADD(aHayErr,{CLI->cCodigoEst,;
					   GRU->cCodigoGru+'-'+;
					   STR(CLI->(RECNO()),2),;
					   cAnoIni,cNombreTes,;
					   SUBS(cHayErr+SPACE(80),1,80)})
			    lError := .T.

			  ENDIF
*:::::::::::::::::::::::FIN VALIDACION DE LA CEDULA

*:::::::::::::::::::::::VALIDACION DE LA CEDULA EN PERSONAS
			  IF nTipPerMae(cDocNit,;
					&cMaeAct->cPadNitEst,;
					&cMaeAct->cMadNitEst) == 3 .AND.;
			     !lLocNitPer(cDocNit,cTipDoc)

			      cHayErr := 'CODIGO:'+CLI->cCodigoEst+' '+;
					 'GRUPO:'+GRU->cCodigoGru+' '+;
					 'LA CEDULA '+ALLTRIM(cDocNit)+;
					 ' NO EXISTE EN PERSONAS'

			      AADD(aHayErr,{CLI->cCodigoEst,;
					    GRU->cCodigoGru+'-'+;
					    STR(CLI->(RECNO()),2),;
					    cAnoIni,cNombreTes,;
					    SUBS(cHayErr+SPACE(80),1,80)})
			     lError := .T.

			  ENDIF
*:::::::::::::::::::::::FIN VALIDACION DE LA CEDULA EN PERSONAS

		      ENDFOR
*-------------------FIN VALIDACION DEL CONTRATANTE

		 ENDIF
*==============FIN VALIDACION DE LOS CONTRATANTES

	       CLI->(DBSKIP())

	    ENDDO
**********FIN VALIDACION POR CLIENTES

**********AVANCE DEL SIGUIENTE GRUPO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       lHayErr := IF(lError,lError,lHayErr)
       CloseAll()
       RETURN !lHayErr
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

/*************************************************************************
* TITULO..: LOCALIZAR DEL MES FACTURADO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2005 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   AGO 09/2005 MAR

OBJETIVOS:

1- Localiza el recibo en que se facturo el mes.

2- Retorna el registro del recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMesFacPag(cCodEst,nMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nMesIni			            // @Mes Inicial del Recibo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegPag := 0                   // Registro de pagos
       LOCAL nRegMes := 0                   // Registro del Mes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       nRegPag := PAG->(RECNO())
       SELECT PAG
       SET FILTER TO PAG->cCodigoEst == cCodEst

       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

/*
**********RECIBO POR ADELANTADO
	    IF PAG->nMesFinPag > PAG->nMesIniPag  .AND.;
	      (PAG->cEstadoPag == 'P' .OR.  PAG->cEstadoPag == 'A') .AND.;
	       nMesIni >= PAG->nMesIniPag .AND. nMesIni <= PAG->nMesFinPag .AND.;
	       !EMPTY(PAG->dFecPagPag)

	       nRegMes := PAG->(RECNO())
	       EXIT

	    ENDIF
**********FIN RECIBO POR ADELANTADO

**********RECIBO DEL MES
	    IF PAG->nMesIniPag == PAG->nMesFinPag .AND.;
	       PAG->nMesIniPag == nMesIni

	       nRegMes := PAG->(RECNO())
	       EXIT

	    ENDIF
**********FIN RECIBO DEL MES
*/

**********RECIBO DEL MES
	    IF PAG->nMesIniPag == nMesIni

	       nRegMes := PAG->(RECNO())
	       EXIT

	    ENDIF
**********FIN RECIBO DEL MES

	  PAG->(DBSKIP())

       ENDDO
       SET FILTER TO
       PAG->(DBGOTO(nRegPag))
       RETURN nRegMes
*>>>>FIN FILTRACION DEL ARCHIVO

/*************************************************************************
* TITULO..: LOCALIZAR DEL MES FACTURADO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2005 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   AGO 09/2005 MAR

OBJETIVOS:

1- Localiza el recibo en que se facturo el mes.

2- Retorna el registro del recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnInforme(lShared,cNomSis,cNomEmp,cNomUsr,lPrnArc,cOpcPrn,;
		    FilePrn,aCabPrn,aNroCol,aTitPrn,aTotReg,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       FilePrn                              // Archivo de impresion
       aCabPrn                              // Encabezado del informe General
       aNroCol                              // Columnas de impresi¢n
       aTitPrn                              // T¡tulos para impresi¢n
       aTotReg                              // Total de Registros a imprimir
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales


       LOCAL     i,j := 0                   // Contadores
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros

       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
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
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF lPrnArc
          SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)
          IF EMPTY(nOpcPrn)
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       FOR i := 1 TO LEN(aTotReg)

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( i / LEN(aRegPrn) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    FOR j := 1 TO LEN(aTotReg[i])
		AADD(aRegPrn,aTotReg[i,j])
	    ENDFOR

            lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
                    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

       ENDFOR
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION DE INCONSISTENCIAS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 07/2006 MAR A
       Colombia, Bucaramanga        INICIO: 02:10 PM   ENE 07/2006 MAR

OBJETIVOS:

1- Localiza el recibo en que se facturo el mes.

2- Retorna el registro del recibo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnErrRep(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr,;
		   FilePrn,nCodPrn,lPrnArc,cOpcPrn,nMesRep,dFecPrn,;
		   aErrRep)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       FilePrn                              // Archivo de Impresi¢n
       nCodPrn                              // C¢digo de impresi¢n
       lPrnArc                              // .T. Imprimir a Archivo
       cOpcPrn                              // Opciones de Impresi¢n
       nMesRep                              // Mes del Reporte
       dFecPrn                              // Fecha de Corte
       aErrRep                              // Errores del reporte */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n

       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
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
       IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS INCONSISTENCIAS
       IF LEN(aErrRep) # 0

**********DEFINICION DEL ENCABEZADO
	    FilePrn := 'ErRep'+cMes(nMesRep,3)
	    aCabPrn := {cNomEmp,cNomSis,;
			'INCONSISTENCIAS DATACREDITO',;
			'REPORTE DE '+cMes(nMesRep)+' DE '+cAnoUsr,;
			'FECHA DE CORTE '+cFecha(dFecPrn)}
**********FIN DEFINICION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    aNroCol := {}
	    aTitPrn := {}

	    AADD(aNroCol,6)
	    AADD(aTitPrn,'CODIGO')

	    AADD(aNroCol,8)
	    AADD(aTitPrn,'GRUPO')

	    AADD(aNroCol,4)
	    AADD(aTitPrn,'A¥O')

	    AADD(aNroCol,40)
	    AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')

	    AADD(aNroCol,80)
	    AADD(aTitPrn,'OBSERVACION')
**********FIN ENCABEZADOS DE COLUMNA

**********IMPRESION DEL INFORME
	    cError('EXISTEN INCONSISTENCIAS',;
		   'ATENCION','PREPARE LA IMPRESORA')

	    PrnInforme(lShared,cNomSis,cNomEmp,cNomUsr,lPrnArc,cOpcPrn,;
		       FilePrn,aCabPrn,aNroCol,aTitPrn,aErrRep)
**********FIN IMPRESION DEL INFORME

       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LAS INCONSISTENCIAS

/*************************************************************************
* TITULO..: MES DE PLAZO                                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 09/2009 MIE A
       Colombia, Bucaramanga        INICIO: 02:10 PM   JUL 09/2009 MIE

OBJETIVOS:

1- Calcula el mes de plazo

2- Retorna el mes de plazo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMesPlz(nMesIni,nFinFac,nMesPlz)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMesIni                              // Mes Inicial
       nFinFac                              // Mes Final de la facturaci¢n
       nMesPlz                              // Meses de Plazo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>DECLARACION DE VARIABLES
      LOCAL nNroMes := 0                    // Mes inicial
*>>>FIN DECLARACION DE VARIABLES

*>>>MES DE PLAZO
      IF nMesIni < nFinFac
	 nNroMes := nMesIni+nMesPlz
      ELSE
	 nNroMes := nMesIni
      ENDIF
      RETURN nNroMes
*>>>FIN MES DE PLAZO
