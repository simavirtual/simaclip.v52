/*************************************************************************
* TITULO..: VERIFICACION DE LOS PAZ Y SALVOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2005 LUN A
       Colombia, Bucaramanga        INICIO: 08:30 PM   NOV 28/2005 LUN

OBJETIVOS:

1- Valida y actualiza el Swich de los Paz y Salvos Acad‚micos

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor055(aParam1,aParam2,aParam3,;
		   cEmpCob,oBrowse,cMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro
       oBrowse                              // Browse del Archivo
       cMesIni                              // Mes Inical del pago */
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

       LOCAL       i := 0                   // Contador
       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL lGrabar := .F.                 // .T. Grabar Registro
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
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>LOCALIZACION ITEM DEL PAZ Y SALVOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nCodPaz := 0
       IF lLocCodigo('nNroTipPaz','PAZ',1)
	  nCodPaz := PAZ->nCodigoPaz
       ENDIF
       IF EMPTY(nCodPaz)
	  cError('NO ESTA HABILITADO EL ITEM DE LOS PAZ Y SALVOS')
	  RETURN NIL
       ENDIF
       lGrabar := lPregunta('DESEA GRABAR LA ACTUALIZACION '+;
			    'DE LOS PAZ Y SALVOS? No Si')
*>>>>FIN LOCALIZACION ITEM DEL PAZ Y SALVOS

*>>>>RECORRIDO POR MAESTRO DE ALUMNOS
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     'GRU'+cMaeAct+cAnoSis+ExtFile,'GRU',;
			     NIL,lShared,nModCry)

		cError('ABRIENDO EL ARCHIVO GRUPOS DE '+cMaeAct)
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     GRU->(DBGOTOP())
	     DO WHILE .NOT. GRU->(EOF())

*===============PREPARACION DE LAS VARIABLES DE ARCHIVO
		  FileCli := cPatSis+'\CLIENTES\CL'+;
				      GRU->cCodigoGru+cAnoSis+ExtFile

		  FilePag := cPatSis+'\PAGOS\PA'+;
				      GRU->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		     cError('ABRIENDO DE CLIENTES Y PAGOS')
		     CloseDbf('CLI')
		     CloseDbf('GRU')
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============VALIDACION DE CONTENIDOS DE ARCHIVOS
		  lHayErr := .T.
		  DO CASE
		  CASE CLI->(RECCOUNT()) == 0
		       cError('NO EXISTEN CLIENTES GRABADOS PARA '+;
			      GRU->cCodigoGru)
		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE
		  IF lHayErr
		     CloseDbf('CLI')
		     CloseDbf('GRU')
		     RETURN NIL
		  ENDIF
*===============FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*===============VERIFICACION DE PAZ Y SALVOS
		  PazEstOk(lShared,cNomSis,cMaeAct,lGrabar,nCodPaz)
*===============FIN VERIFICACION DE PAZ Y SALVOS

*===============AVANCE DEL REGISTRO
		  SELECT GRU
		  GRU->(DBSKIP())
*===============FIN AVANCE DEL REGISTRO

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

	   CloseDbf('GRU')

       ENDFOR
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT MOR
       MOR->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO POR MAESTRO DE ALUMNOS

/*************************************************************************
* TITULO..: VERIFICAR LOS PAZ Y SALVOS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 29/2005 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   NOV 29/2005 MAR

OBJETIVOS:

1- Visualiza los c¢digos de los estudiantes con inconsistencia en los
   paz y salvos.

2- Facilita la opci¢n de actualizar o solo consultar las inconsistencias.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PazEstOk(lShared,cNomSis,cMaeAct,lGrabar,nCodPaz)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cMaeAct                              // Maestro Actual
       lGrabar                              // .T. Grabar Registro
       nCodPaz                              // C¢digo del Paz y Salvo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cPazEst := ''                  // Paz y Salvo en Contabilidad
       LOCAL cPazCar := ''                  // Paz y Salvo en Cartera

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cCampos := ''                  // Campo
       LOCAL cNalias := ''                  // Alias del Archivo

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR ESTUDIANTES
       nNroFil := nMarco(03,'VERIFICANDO EL ESTADO DE LOS PAZ Y SALVOS')
       SELECT CLI
       CLI->(DBGOTOP())
       DO WHILE .NOT. CLI->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('GRUPO: '+GRU->cCodigoGru+;
			'ºCODIGO: '+CLI->cCodigoEst+;
			'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				STR(CLI->(RECCOUNT()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias,.F.)

	       cError('EL CODIGO:' +CLI->cCodigoEst+' NO EXISTE '+;
		      'EN LOS ALUMNOS DEL GRUPO '+GRU->cCodigoGru)
	       SELECT CLI
	       CLI->(DBSKIP())
	       LOOP

	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********VALIDACION DEL PAZ Y SALVO
	    cCampos := cMaeAct+'->cPazSdoEst'
	    cPazEst := SUBS(&cCampos,nCodPaz,1)

	    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0

*==============VALIDACION PAGO ULTIMO RECIBO
		 IF nUltRecPag(CLI->cCodigoEst) # 0 .AND.;
		    CLI->cCodigoEst == PAG->cCodigoEst

		    IF !EMPTY(PAG->dFecPagPag) .AND.;
		       (PAG->cEstadoPag == 'P' .OR.;
			PAG->cEstadoPag == 'A')
		       cPazCar := SPACE(01)
		    ELSE
		       IF PAG->nAbonosPag == 0
			  cPazCar := '*'
		       ELSE
			  cPazCar := SPACE(01)  // Abono y no debe
		       ENDIF
		    ENDIF

		 ELSE
		    cPazCar := SPACE(01)
		 ENDIF
*==============FIN VALIDACION PAGO ULTIMO RECIBO

	    ELSE
	       cPazCar := 'N'
	    ENDIF
**********FIN VALIDACION DEL PAZ Y SALVO

**********VISUALIZACION
	    cMsgTxt := 'CODIGO:'+CLI->cCodigoEst+' '+;
		       'GRUPO: '+GRU->cCodigoGru+' '+cNombreTes
	    IF cPazEst == cPazCar
	       @ nNroFil,01 SAY cMsgTxt+' OK'
	    ELSE
	       @ nNroFil,01 SAY cMsgTxt+' INCONSISTENCIA'
*	       cPausa()
	    ENDIF
	    nNroFil++
	    IF nNroFil == 21
	       nNroFil := nMarco(03,'VERIFICANDO EL ESTADO DE LOS PAZ Y '+;
				    'SALVOS')
	    ENDIF
**********FIN VISUALIZACION

**********AUTUALIZACION DEL PAZ Y SALVO
	    IF lGrabar .AND. cPazEst # cPazCar

	       SELECT &cMaeAct
	       IF lRegLock(lShared,.F.)
		  REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,cPazCar)
		  DBCOMMIT()
	       ELSE
		  cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	       ENDIF
	       IF lShared
		  DBUNLOCK()
	       ENDIF
	    ENDIF
**********FIN AUTUALIZACION DEL PAZ Y SALVO

	  SELECT CLI
	  CLI->(DBSKIP())
	  LOOP

       ENDDO
       CloseDbf('CLI')
       RETURN NIL
*>>>>FIN RECORRIDO POR ESTUDIANTES
