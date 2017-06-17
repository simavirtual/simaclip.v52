/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : ACTUALIZAR
SUBMODULO...: ACTUALIZAR ALUMNOS     MODULO No. 507

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE507.PRG                                    *
* TITULO DEL PROGRAMA..: ACTUALIZA LOS ESTUDIANTES DE LOS MAESTROS       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/94 JUE A
						       MAY 12/94 JUE

REQUERIMIENTOS:

1- Ejucutar la funci¢n de acuerdo a su sintaxis

OBJETIVOS:

1- Actualiza los clientes si esta autorizado por el campo de revisar
   del archivo empresa

2- Cambia de grupo a los clientes

3- Traslada los detalles del pago entre los archivos de clientes y pagos

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_507(aParam1,aParam2,aParam3,;
		   lCondic)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lCondic                              // .T. Revisar por Condicion */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL lReviso := .T.                 // .T. Hizo Revisi¢n
       LOCAL Getlist := {}                  // Variable del sistema
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

       lCondic := IF(lCondic==NIL,.F.,lCondic)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF lCondic
	  IF !lUseDbf(.T.,cPatSis+'\'+;
		      fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry)
	     cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL A¥O')
	     CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS PARA ACTUALIZAR LOS CLIENTES
       IF lCondic
	  IF !(CAA->lRevisaCaA)
	     CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS PARA ACTUALIZAR LOS CLIENTES

*>>>>CRACION DE LOS CLIENTES
       IF 'JAR' $ cMaeAlu
	  IF lReviso
	     lReviso := RevisarCli(lShared,nModCry,nFilPal+1,cNomSis,;
				   cNomUsr,cAnoUsr,cPatSis,cIntUno,'JAR',;
				   lAnoAct)
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu
	  IF lReviso
	     lReviso := RevisarCli(lShared,nModCry,nFilPal+1,cNomSis,;
				   cNomUsr,cAnoUsr,cPatSis,cIntUno,'PRI',;
				   lAnoAct)

	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu
	  IF lReviso
	     lReviso := RevisarCli(lShared,nModCry,nFilPal+1,cNomSis,;
				   cNomUsr,cAnoUsr,cPatSis,cIntUno,'BTO',;
				   lAnoAct)
	  ENDIF
       ENDIF
*>>>>FIN CREACION DE LOS CLIENTES

*>>>>GRABACION DE LA REVISION
       IF lCondic
	  IF lReviso
	     IF CAA->(lRegLock(lShared,.F.))
		REPL CAA->lRevisaCaA WITH .F.
		CAA->(DBCOMMIT())
	     ELSE
		cError('NO SE GRABA EL SWICTH DE LA REVISION')
	     ENDIF
	     IF lShared
		CAA->(DBUNLOCK())
	     ENDIF
	  ELSE
	     cError('NO SE HIZO LA REVISION DE LOS ALUMNOS')
	  ENDIF
       ENDIF
       CloseDbf('CAA',fCarAno+cAnoUsr+ExtFile,nModCry)
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LA REVISION


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************


/*************************************************************************
* TITULO DEL PROGRAMA..: REVISION DE LOS CLIENTES                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/94 JUE A
						       MAY 12/94 JUE
OBJETIVOS:

1- Actualiza los clientes para los maestros habilitados

2- Cambia de grupo a los clientes

3- Traslada los detalles del pago entre los archivos de clientes y pagos

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarCli(lShared,nModCry,nFilPal,cNomSis,cNomUsr,;
		    cAnoUsr,cPatSis,cIntUno,cMaeAct,lAnoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       nFilPal                              // Fila principal de impresi¢n
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre de usuario
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del Sistema
       cIntUno                              // Path de integraci¢n uno
       cMaeAct                              // Maestro Actual
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna

       LOCAL lEofAlu := .F.                 // .T. Fin Archivo Alumnos
       LOCAL lEofCli := .F.                 // .T. Fin Archivo Clientes
       LOCAL lCambio := .F.                 // .T. Existe cambio de grupo
       LOCAL cMsgTxt := ''		    // Variable texto variable

       LOCAL nRegCli := 0                   // Registro del Cliente
       LOCAL nRegAlu := 0                   // Registro del Alumno

       LOCAL fPagFue := ''                  // Archivo de pagos Fuente
       LOCAL fPagDes := ''                  // Archivo de pagos Destino
       LOCAL fCliDes := ''                  // Archivo de clientes Destino
       LOCAL fNtxCli := ''                  // Archivo Indice de Clientes

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE (RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS EN '+cNomNiv(cMaeAct))

       CASE GRU->(RECCOUNT()) == 0
	    cError('LOS GRUPOS NO ESTAN GRABADOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
       nNroFil := nMarco(nFilPal,'POR FAVOR ESPERE MIENTRAS '+;
			'SE REVISAN LOS CLIENTES DE '+cNomNiv(cMaeAct))
       nNroCol := 1
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>ACTUALIZACION DE LOS GRUPOS
       SELECT GRU
       GO TOP
       DO WHILE .NOT. EOF()

**********PREPARACION DE VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll()
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS EN '+FileCli)
		 CloseDbf('CLI',FileCli,nModCry)
		 CloseAll()
		 RETURN .F.
	    ENDCASE
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********FILTRACION DEL MAESTRO DE ACUERDO AL GRUPO
	    DO CASE
	    CASE cMaeAct == 'JAR'
	       SELECT JAR
	       SET FILTER TO JAR->cCodigoGru == GRU->cCodigoGru

	    CASE cMaeAct == 'PRI'
	       SELECT PRI
	       SET FILTER TO PRI->cCodigoGru == GRU->cCodigoGru

	    CASE cMaeAct == 'BTO'
	       SELECT BTO
	       SET FILTER TO BTO->cCodigoGru == GRU->cCodigoGru
	    ENDCASE
	    GO TOP
**********FIN FILTRACION DEL MAESTRO DE ACUERDO AL GRUPO

**********INDEXADO DEL ARCHIVO CLIENTES TEMPORAL
	    fNtxCli := SUBS(cNomUsr,1,3)+'CLI'+cExtNtx
	    SELECT CLI
	    INDEX ON CLI->cCodigoEst TO &fNtxCli
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN INDEXADO DEL ARCHIVO CLIENTES TEMPORAL

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',fNtxCli,lShared,nModCry)
	       cError('ABRIENDO CLIENTES INDEXADO EN ACTUALIZAR CLIENTES')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********ACTUALIZACION DE LOS CLIENTES
	    SELECT CLI
	    GO TOP
	    SELECT &cMaeAct
	    GO TOP
	    lCambio := .F.
	    lEofCli := .F.
	    lEofAlu := .F.
	    DO WHILE !lEofAlu .OR. !lEofCli

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstados('REVISANDO EL GRUPO: '+GRU->cCodigoGru+;
			      'ºNo. '+CLI->(STR(RECNO(),2))+'/'+;
			       CLI->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DE CAMBIO DE GRUPO
		  SELECT &cMaeAct
		  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+&cMaeAct->cNombreEst
		  cNombreTes := SUBS(cNombreTes,1,30)+SPACE(14)+'...'
		 *Estudiante del maestro

		  cMsgTxt = GRU->cCodigoGru + ' û'
		  IF .NOT. lCambio
		     IF &cMaeAct->cCodigoEst # CLI->cCodigoEst
			lCambio := .T.
		     ENDIF
		  ENDIF
*--------------FIN ANALISIS DE CAMBIO DE GRUPO

*--------------CONFIRMACION DEL GRUPO DEL ESTUDIANTE
		 IF .NOT. lCambio
		    SELECT CLI
		    IF CLI->(lRegLock(lShared,.F.))
		       REPL CLI->lRetgruCli WITH .F.
		       CLI->(DBCOMMIT())
		    ELSE
		       cError('AL CONFIRMAR EL GRUPO')
		    ENDIF
		    IF lShared
		       CLI->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN CONFIRMACION DEL GRUPO DEL ESTUDIANTE

*--------------BUSQUEDA DEL ALUMNO COMO CLIENTE
		 IF lCambio .AND. !lEofAlu

		    SELECT CLI
		    nRegCli = CLI->(RECNO())

		    IF !CLI->(DBSEEK(&cMaeAct->cCodigoEst)) .AND.;
		       &cMaeAct->cCodigoEst # SPACE(04)

*                      INCLUSION DEL ESTUDIANTE EN CLIENTES
			 IF &cMaeAct->cCodigoGru == GRU->cCodigoGru
			    IF CLI->(lRegLock(lShared,.T.))

cError('CODIGO '+&cMaeAct->cCodigoEst+' '+;
       'GRUPO: '+GRU->cCodigoGru+' SE VA A INCLUIR '+;
       'RETIRADO:'+IF(&cMaeAct->lRetiroEst,'SI','NO'))

			       REPL CLI->cCodigoEst WITH &cMaeAct->cCodigoEst
			       REPL CLI->lRetGruCli WITH .F.
			       CLI->(DBCOMMIT())

			       cMsgTxt = 'Incluido en '+GRU->cCodigoGru
			       @ nNroFil,nNroCol SAY CLI->cCodigoEst+' '+;
					      cNombreTes+cMsgTxt   PICT '@A'
			       nNroFil = nNroFil+1
			       IF nNroFil == 21
				  nNroFil := nMarco(nFilPal,'POR FAVOR ESPERE MIENTRAS '+;
						   'SE REVISAN LOS CLIENTES DE '+;
						   cNomNiv(cMaeAct))

			       ENDIF
			    ELSE
			       cError('AL INCLUIR EL CLIENTE')
			    ENDIF
			    IF lShared
			       CLI->(DBUNLOCK())
			    ENDIF
			 ELSE
			    cMsgTxt = 'EQUIVOCADO DE GRUPO'
			 ENDIF
*                      FIN INCLUSION DEL ESTUDIANTE EN CLIENTES

		    ENDIF

		    SELECT CLI
		    GO nRegCli
		   *Reestablece el puntero del cliente
		 ENDIF
*--------------FIN BUSQUEDA DEL ALUMNO COMO CLIENTE

*--------------BUSQUEDA EN EL MAESTRO DE LA CONTABILIDAD
		 IF lCambio .AND. !lEofCli

		    SELECT &cMaeAct
		    nRegAlu = RECNO()
		   *Guarda el puntero del maestro

		    SET FILTER TO
		   *Desactiva para buscar en todo el maestro

		    SEEK CLI->cCodigoEst
		    IF FOUND()

*                      CONFIRMAR EL GRUPO DEL ESTUDIANTE
			 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+&cMaeAct->cNombreEst
			 cNombreTes := SUBS(cNombreTes,1,30)+SPACE(14)+'...'
			*Estudiante del archivo clientes

			 SELECT CLI
			 IF &cMaeAct->cCodigoGru == GRU->cCodigoGru
			    IF CLI->(lRegLock(lShared,.F.))
			       REPL CLI->lRetGruCli WITH .F.
			       CLI->(DBCOMMIT())
			      *Existe en el grupo

			       cMsgTxt = GRU->cCodigoGru + ' û'
			    ELSE
			       cError('AL CONFIRMAR EL GRUPO')
			    ENDIF
			    IF lShared
			       CLI->(DBUNLOCK())
			    ENDIF
			 ELSE
			    fPagDes := cPatSis+'\PAGOS\PA'+;
				       &cMaeAct->cCodigoGru+cAnoSis+ExtFile

			    fCliDes := cPatSis+'\CLIENTES\CL'+;
				       &cMaeAct->cCodigoGru+cAnoSis+ExtFile

cError('CODIGO '+&cMaeAct->cCodigoEst+' '+;
       'GRUPO: '+GRU->cCodigoGru+' TRASLADO DEL GRUPO '+;
       'RETIRADO:'+IF(&cMaeAct->lRetiroEst,'SI','NO'))

			    IF !lMoverPag(lShared,CLI->cCodigoEst,;
					  FilePag,fPagDes,cMaeAct,nModCry)
			       cError('NO SE TRASLADO LOS PAGOS DEL CLIENTE')
			    ELSE
			       IF !lMoverCli(CLI->cCodigoEst,fCliDes,nModCry)
				  cError('NO SE TRASLADO LOS SALDOS')
			       ELSE
				  IF CLI->(lRegLock(lShared,.F.))
				     REPL CLI->lRetGruCli WITH .T.
				     CLI->(DBCOMMIT())
				    *No existe en el grupo
				    cMsgTxt = GRU->cCodigoGru +' Pertenece a otro Grupo'
				  ELSE
				     cError('AL CONFIRMAR EL GRUPO')
				  ENDIF
				  IF lShared
				     CLI->(DBUNLOCK())
				  ENDIF
			       ENDIF
			    ENDIF
			  *ÀTraslado de los pagos del cliente
			 ENDIF
*                      CONFIRMAR EL GRUPO DEL ESTUDIANTE

		    ELSE
			cNombreTes = 'EL CODIGO: '+CLI->cCodigoEst+;
				     ' NO EXISTE EN EL MAESTRO '
			cMsgTxt = 'ERROR'
		    ENDIF

*                   FILTRACION DEL MAESTRO DE ACUERDO AL GRUPO
		      SELECT &cMaeAct
		      DO CASE
		      CASE cMaeAct == 'JAR'
			 SELECT JAR
			 SET FILTER TO JAR->cCodigoGru == GRU->cCodigoGru

		      CASE cMaeAct == 'PRI'
			 SELECT PRI
			 SET FILTER TO PRI->cCodigoGru == GRU->cCodigoGru

		      CASE cMaeAct == 'BTO'
			 SELECT BTO
			 SET FILTER TO BTO->cCodigoGru == GRU->cCodigoGru

		      ENDCASE
		      GO nRegAlu
		     *Reestablece el puntero del maestro
*                   FIN FILTRACION DEL MAESTRO DE ACUERDO AL GRUPO
		 ENDIF
*--------------FIN BUSQUEDA EN EL MAESTRO DE LA CONTABILIDAD

*--------------VISUALIZACION DATOS DEL ESTUDIANTE
		 @ nNroFil,nNroCol SAY IF(!lEofCli,CLI->cCodigoEst,;
					      &cMaeAct->cCodigoEst)+' '+;
				       cNombreTes+cMsgTxt   PICT '@A'
		 IF !('û' $ cMsgTxt)
		    INKEY(3)
		 ENDIF

		 nNroFil = nNroFil+1
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal,'POR FAVOR ESPERE MIENTRAS '+;
				     'SE REVISAN LOS CLIENTES DE '+;
				     cNomNiv(cMaeAct))

		 ENDIF
*--------------FIN VISUALIZACION DATOS DEL ESTUDIANTE

*--------------ANALISIS DEL EOF DE CLIENTES
		 SELECT CLI
		 SKIP
		 IF EOF()
		    lEofCli := .T.
		 ENDIF
*--------------FIN ANALISIS DEL EOF DE CLIENTES

*--------------ANALISIS DEL EOF DE ALUMNOS
		 SELECT &cMaeAct
		 SKIP
		 IF EOF()
		    lEofAlu := .T.
		 ENDIF
*--------------FIN ANALISIS DEL EOF DE ALUMNOS

	    ENDDO
	   *Del archivo de notas de la contabilidad
**********FIN ACTUALIZACION DE LOS CLIENTES

	  CloseDbf('CLI',FileCli,nModCry)
	  SELECT GRU
	  SKIP

       ENDDO
       CloseDbf('GRU')
       CloseDbf(cMaeAct)
       lFileDelete(fNtxCli)
       RETURN .T.
*>>>>FIN ACTUALIZACION DE LOS GRUPOS

/*************************************************************************
* TITULO DE LA FUNCION......: TRASLADO SALDOS DEL CLIENTE A OTRO GRUPO   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1- El archivo de clientes destino debe estar en uso en el registro del
   cliente correspondiente

1- Traslada los datos del cliente saldos, becados, etc a otro grupo

2- Retorna .T. si hubo problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lMoverCli(cCodCli,fCliDes,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodCli		                    // C¢digo del cliente
       fCliDes		                    // Archivo Clientes Destino */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Compartir Archivos
       LOCAL lExiste := .T.                 // Existe el Cliente
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI EL CLIENTE ESTA ACTIVO
       IF CLI->lRetGruCli
	  RETURN .T.
       ENDIF
*>>>>FIN ANALISIS SI EL CLIENTE ESTA ACTIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,fCliDes,'DES',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS EN MOVER CLIENTES')
	  CloseDbf('DES',fCliDes,nModCry)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>TRASLADO AL ARCHIVO DESTINO
       SELECT DES
       GO TOP
       LOCATE FOR DES->cCodigoEst == cCodCli
       IF .NOT. FOUND()
	  lExiste := .F.
	  IF DES->(lRegLock(lShared,.T.))
	     REPL DES->cCodigoEst     WITH CLI->cCodigoEst
	     REPL DES->lRetGruCli WITH .F.
	  ELSE
	     cError('TRASLADANDO SALDOS EN CLIENTES')
	  ENDIF
       ENDIF
       IF lExiste
	  DES->(lRegLock(lShared,.F.))
       ENDIF
       REPL DES->nSdoActCli WITH CLI->nSdoActCli
       REPL DES->cMesPagCli WITH CLI->cMesPagCli
       REPL DES->cNroCopCli WITH CLI->cNroCopCli
       REPL DES->nPorBecCli WITH CLI->nPorBecCli
       REPL DES->nBecIniCli WITH CLI->nBecIniCli
       REPL DES->nBecFinCli WITH CLI->nBecFinCli
       REPL DES->lFondosCli WITH CLI->lFondosCli
       CloseDbf('DES',fCliDes,nModCry)
*>>>>FIN TRASLADO AL ARCHIVO DESTINO

*>>>>BORRADO DE LOS DATOS DEL ARCHIVO DESTINO
       IF CLI->(lRegLock(lShared,.F.))
	  REPL CLI->nSdoActCli WITH 0
	  REPL CLI->cMesPagCli WITH SPACE(12)
	  REPL CLI->cNroCopCli WITH SPACE(24)
	  REPL CLI->nPorBecCli WITH 0
	  REPL CLI->nBecIniCli WITH 0
	  REPL CLI->nBecFinCli WITH 0
	  REPL CLI->lFondosCli WITH .F.
       ELSE
	  cError('AL BORRAR REGISTRO EN CLIENTES')
       ENDIF
       RETURN .T.
*>>>>FIN BORRADO DE LOS DATOS DEL ARCHIVO DESTINO

/*************************************************************************
* TITULO DE LA FUNCION......: TRASLADO DE PAGOS DE UN GRUPO A OTRO       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1- Debe estar en uso el archivo de clientes en el estudiante correspondiente

2- Traslada los pagos de un estudiante de un grupo a otro de los archivos
   Clientes y Pagos.

3- Retorna .T. si hubo problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lMoverPag(lShared,cCodEst,fPagFue,fPagDes,cMaeAct,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cCodEst                              // C¢digo del estudiante
       fPagFue		                    // Archivo Pago Fuente
       fPagDes		                    // Archivo Pago Destino
       cMaeAct			            // Maestro Actual
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>ANALISIS SI EL CLIENTE ESTA ACTIVO
       IF CLI->lRetGruCli
	  RETURN .T.
       ENDIF
*>>>>FIN ANALISIS SI EL CLIENTE ESTA ACTIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       lShared := .f.
       IF !lUseDbf(.T.,fPagFue,'FUE',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,fPagDes,'DES',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS EN MOVER PAGOS')
	  CloseDbf('DES',fPagDes,nModCry)
	  CloseDbf('FUE',fPagFue,nModCry)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>TRASLADO DE LOS PAGOS AL ARCHIVO DESTINO
       SELECT FUE
       SET FILTER TO FUE->cCodigoEst == cCodEst
       GO TOP
       DO WHILE .NOT. FUE->(EOF())

	  IF DES->(lRegLock(lShared,.T.))
	     REPL DES->cCodigoEst     WITH FUE->cCodigoEst
	     REPL DES->cCodigoBan WITH FUE->cCodigoBan
	     REPL DES->nIntMorPag WITH FUE->nIntMorPag
	     REPL DES->nMesIniPag WITH FUE->nMesIniPag
	     REPL DES->nMesFinPag WITH FUE->nMesFinPag
	     REPL DES->cAtrasoPag WITH FUE->cAtrasoPag
	     REPL DES->nSdoAntPag WITH FUE->nSdoAntPag
	     REPL DES->nVlrMesPag WITH FUE->nVlrMesPag
	     REPL DES->nVlrPagPag WITH FUE->nVlrPagPag
	     REPL DES->cConcepPag WITH FUE->cConcepPag
	     REPL DES->dPagOpoPag WITH FUE->dPagOpoPag
	     REPL DES->dPagExtPag WITH FUE->dPagExtPag
	     REPL DES->cEstadoPag WITH FUE->cEstadoPag
	     DES->(DBCOMMIT())
	  ELSE
	     cError('TRASLADANDO PAGOS')
	  ENDIF
	  IF lShared
	     CLI->(DBUNLOCK())
	  ENDIF
	  SELECT FUE
	  SKIP
       ENDDO
       SET FILTER TO
*>>>>FIN TRASLADO DE LOS PAGOS AL ARCHIVO DESTINO

*>>>>BORRADO DE LOS PAGOS DEL ARCHIVO FUENTE
       SELECT FUE
       IF !lFileLock()
	  DELETE ALL FOR FUE->cCodigoEst == cCodEst
	  PACK
       ENDIF
       DBUNLOCKALL()
       CloseDbf('DES',fPagDes,nModCry)
       CloseDbf('FUE',fPagFue,nModCry)
       RETURN .T.
*>>>>FIN BORRADO DE LOS PAGOS DEL ARCHIVO FUENTE