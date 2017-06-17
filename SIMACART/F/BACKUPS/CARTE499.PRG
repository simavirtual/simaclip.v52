/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: TOTAL PAGOS POR ALUMNOS

**************************************************************************
* NOMBRE ..: RELACION DE DETALLADA POR FAMILIAS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2005 MIE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   ABR 20/2005 MIE

OBJETIVOS:

1- Imprime una relaci¢n detallada de facilitar los reportes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_409(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

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
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nOpcRep := 0                   // Opci¢n del Reporte
       LOCAL nNroAlu := 0                   // N£mero de Estudiantes

       LOCAL lHayAlu := .F.                 // .T. Existe el Estudiante
       LOCAL cDocNit := ''                  // N£mero del Documento
       LOCAL cDirecc := ''                  // Direccion
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de campo
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
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
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

*>>>>ANALISIS DE DECISION
       nOpcRep := nLeeOpcion('REPORTAR A: '+;
			     '1<PADRE> '+;
			     '2<MADRE> '+;
			     '3<ABANDONAR>'+;
			     '<?',5,'0')
       IF EMPTY(nOpcRep)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Totpagos'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'TOTAL PAGOS POR ESTUDIANTES',;
		   '',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       IF nOpcPrn == 7 .OR. nOpcPrn == 8

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'No.')

	  AADD(aNroCol,20)
	  AADD(aTitPrn,'IDENTIFICACION')

	  AADD(aNroCol,60)
	  AADD(aTitPrn,'DIRECCION')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'VALOR')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'CODIGO')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'GRUPO')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'ESTUDIANTE')

	  AADD(aNroCol,20)
	  AADD(aTitPrn,'CEDULA PADRE')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE PADRE')

	  AADD(aNroCol,20)
	  AADD(aTitPrn,'CEDULA MADRE')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE DE LA MADRE')

       ELSE

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'No.')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'CODIGO')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'GRUPO')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'NOMBRE')

	  AADD(aNroCol,40)
	  AADD(aTitPrn,'VALOR')

       ENDIF
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

*>>>>RECORRIDO POR NIVELES
       SET DEVICE TO SCREEN
       nNroFil := nMarco(03,'ESTUDIANTES')

       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+'GRU'+;
			 cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry)

		cError('ABRIENDO EL ARCHIVO GRUPOS DE '+cMaeAct)
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********RECORRIDO POR GRUPOS
	     SELECT GRU
	     DO WHILE .NOT. GRU->(EOF())

*===============PREPARACION DE LAS VARIABLES DE ARCHIVOS
		  FileCli := cPatSis+'\CLIENTES\CL'+;
			     &cMaeAct->cCodigoGru+cAnoSis+ExtFile

		  FilePag := cPatSis+'\PAGOS\PA'+;
			     &cMaeAct->cCodigoGru+cAnoSis+ExtFile
*===============FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*===============SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		     cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*===============FIN SELECION DE LAS AREAS DE TRABAJO

*===============RECORRIDO POR CLIENTES
		  DO WHILE .NOT. CLI->(EOF())

*--------------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		       IF CLI->lRetgruCli
			  LOOP
		       ENDIF
*--------------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------------BUSQUEDA DEL ESTUDIANTE
		       cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
		       lHayAlu := lSekCodMae(CLI->cCodigoEst,;
					     cMaeAct,@cMaeAct)
*--------------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		       lRetadoTes := .F.
		       cNombreTes := 'CODIGO:'+CLI->cCodigoEst+;
				     ' NO EXISTE'

		       IF lHayAlu
			  cCodigoTes := &cMaeAct->cCodigoEst
			  IF &cMaeAct->lRetiroEst
			     lRetadoTes := .T.
			  ENDIF
			  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
					&cMaeAct->cNombreEst
			  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		       ENDIF
*--------------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------------ANALISIS DEL REPORTE
		       DO CASE
		       CASE nOpcRep == 1  // Padre

			    cDocNit := &cMaeAct->cPadNitEst
			    IF EMPTY(&cMaeAct->cDirPadEst)
			       cDirecc := ALLTRIM(&cMaeAct->cDireccEst)+' '+;
					  ALLTRIM(&cMaeAct->cBarrioEst)
			    ELSE
			       cDirecc := ALLTRIM(&cMaeAct->cDirPadEst)+' '+;
					  ALLTRIM(&cMaeAct->cBarPadEst)
			    ENDIF

		       CASE nOpcRep == 2  // Madre

			    cDocNit := &cMaeAct->cMadNitEst
			    IF EMPTY(&cMaeAct->cDirMadEst)
			       cDirecc := ALLTRIM(&cMaeAct->cDireccEst)+' '+;
					  ALLTRIM(&cMaeAct->cBarrioEst)
			    ELSE
			       cDirecc := ALLTRIM(&cMaeAct->cDirMadEst)+' '+;
					  ALLTRIM(&cMaeAct->cBarMadEst)
			    ENDIF

		       ENDCASE
		       cDirecc := SUBS(cDirecc+SPACE(40),1,40)
*--------------------FIN ANALISIS DEL REPORTE

*--------------------IMPRESION DEL REGISTRO
		       nNroAlu++
		       aRegPrn := {}

		       IF nOpcPrn == 7 .OR. nOpcPrn == 8

			  AADD(aRegPrn,STR(nNroAlu,6))
			  AADD(aRegPrn,cDocNit)
			  AADD(aRegPrn,cDirecc)
			  AADD(aRegPrn,TRANS(GRU->nVlrTemGru,"####,###,###"))
			  AADD(aRegPrn,CLI->cCodigoEst)
			  AADD(aRegPrn,GRU->cCodigoGru)
			  AADD(aRegPrn,cNombreTes)

			  AADD(aRegPrn,&cMaeAct->cPadNitEst)
			  AADD(aRegPrn,&cMaeAct->cNomPadEst)

			  AADD(aRegPrn,&cMaeAct->cMadNitEst)
			  AADD(aRegPrn,&cMaeAct->cNomMadEst)

		       ELSE

			  AADD(aRegPrn,STR(nNroAlu,6))
			  AADD(aRegPrn,CLI->cCodigoEst)
			  AADD(aRegPrn,GRU->cCodigoGru)
			  AADD(aRegPrn,cNombreTes)
			  AADD(aRegPrn,TRANS(GRU->nVlrTemGru,"####,###,###"))

		       ENDIF

		       SET DEVICE TO PRINT
		       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			       bCabeza)
		       SET DEVICE TO SCREEN
*--------------------FIN IMPRESION DEL REGISTRO

*--------------------VISUALIZACION
		       @ nNroFil,01 SAY 'GRUPO: '+GRU->cCodigoGru+' '+;
					cNombreTes
		       nNroFil++
		       IF nNroFil == 21
			  nNroFil := nMarco(03,'ESTUDIANTES')
		       ENDIF
*--------------------FIN VISUALIZACION


		     CLI->(DBSKIP())

		  ENDDO
*===============FIN RECORRIDO POR CLIENTES

		GRU->(DBSKIP())

	     ENDDO
***********FIN RECORRIDO POR GRUPOS

       ENDFOR
*>>>>FIN RECORRIDO POR NIVELES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
