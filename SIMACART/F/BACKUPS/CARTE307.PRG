/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: SOPORTE DE FIADORES

**************************************************************************
* TITULO..: SOPORTE DE FIADORES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 04/99 LUN A
       Bucaramanga, Colombia	    INICIO: 04:30 PM   OCT 04/99 LUN

OBJETIVOS:

1- Permite imprimir el Directorio de Alunmos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_307(aParam1,aParam2,aParam3)

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

       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
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

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileFia,'FIA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis) .OR.;
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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DECISION
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    Padres(lShared,cPatSis,GRU->cCodigoGru,;
		   cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt)
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF (nRegIni = nRegFin) .OR. GRU->(EOF())
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

/*************************************************************************
* TITULO..: PADRES CON CEDULA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 04/97 VIE A
       Bucaramanga, Colombia	    INICIO: 05:55 PM   ABR 04/97 VIE


OBJETIVOS:

1- Imprime el directorio con la informaci¢n del alumno.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Padres(lShared,cPatSis,cCodGru,cNomEmp,;
		cNomSis,cAnoUsr,cMaeAct,cJorTxt)

*>>>>PARAMATROS DE LA FUNCION
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
     *ÀVariables generales

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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroAlu := 1                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL aCedFia := {}                  // C‚dulas de Fiadores
       LOCAL cFiaUno := ''                  // Cedula Primer Fiador.
       LOCAL cFiaDos := ''                  // Cedula Segundo Fiador.
       LOCAL cFiaTre := ''                  // Cedula Tercer Fiador
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomPadTes := ''               // Nombre del Padre
       LOCAL cNomMadTes := ''               // Nombre de la Madre
       LOCAL cNomAcuTes := ''               // Nombre del Acudiente
       LOCAL cPadNitTes := ''               // C‚dula del Padre
       LOCAL cMadNitTes := ''               // C‚dula de la Madre
       LOCAL cAcuNitTes := ''               // C‚dula del Acudiente
       FIELD cCodigoGru                     // C¢digo del Grupo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := CLI->(RECCOUNT())
       aCabeza := {cNomEmp,cNomSis,;
		   'SOPORTE DE FIADORES A¥O:'+;
		   cAnoUsr+' JORNADA: '+cJorTxt,;
		   'GRUPO: '+cCodGru,;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,40,40,10,16,20}
       aTitulo := {'No',;
		   'CODIGO',;
		   'ESTUDIANTE',;
		   'FAMILIAR',;
		   'PARENTESCO',;
		   'CEDULA',;
		   'FIADORES C.C'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Wide
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
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TERMOMETRO DE IMPRESION
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT
*>>>>FIN TERMOMETRO DE IMPRESION

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. CLI->(EOF()) .AND. nTotReg # 0

**********VISUALIZACION DE AVANCE
	    nAvance := INT((nNroAlu / nTotReg )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(CLI->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)

	    cNomPadTes := RTRIM(&cMaeAct->cApePadEst)+' '+;
			  RTRIM(&cMaeAct->cNomPadEst)
	    cNomPadTes := SUBS(cNomPadTes+SPACE(40),1,40)

	    cNomMadTes := RTRIM(&cMaeAct->cApeMadEst)+' '+;
			  RTRIM(&cMaeAct->cNomMadEst)
	    cNomMadTes := SUBS(cNomMadTes+SPACE(40),1,40)

	    cNomAcuTes := RTRIM(&cMaeAct->cApeAcuEst)+' '+;
			  RTRIM(&cMaeAct->cNomAcuEst)
	    cNomAcuTes := SUBS(cNomAcuTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DE LAS CEDULAS DE LOS FIADORES
	    cFiaUno := ''
	    cFiaDos := ''
	    cFiaTre := ''
	    aCedFia := aCedulafia(CLI->cCodigoEst)

	    IF LEN(aCedFia) # 0

*--------------BUSQUEDA DE LAS CEDULAS DE LOS PADRES Y ACUDIENTE
		 cPadNitTes := ALLTRIM(&cMaeAct->cPadNitEst)
		 IF ASCAN(aCedFia,{|x|ALLTRIM(x) == cPadNitTes}) # 0
		    cFiaUno := cPadNitTes
		 ENDIF

		 cMadNitTes := ALLTRIM(&cMaeAct->cMadNitEst)
		 IF ASCAN(aCedFia,{|x|ALLTRIM(x) == cMadNitTes}) # 0
		    cFiaDos := cMadNitTes
		 ENDIF

		 cAcuNitTes := ALLTRIM(&cMaeAct->cAcuNitEst)
		 IF ASCAN(aCedFia,{|x|ALLTRIM(x) == cAcuNitTes}) # 0
		    IF cAcuNitTes # cPadNitTes .AND.;
		       cAcuNitTes # cMadNitTes
		       cFiaTre := cAcuNitTes
		    ENDIF
		 ENDIF
*--------------FIN BUSQUEDA DE LAS CEDULAS DE LOS PADRES Y ACUDIENTE

*--------------ANALISIS DE CEDULAS DE TECEROS
		 FOR i := 1 TO LEN(aCedFia)

*....................ANALISIS DE ASIGNACION
		       IF ALLTRIM(aCedFia[i]) == cFiaUno .OR.;
			  ALLTRIM(aCedFia[i]) == cFiaDos .OR.;
			  ALLTRIM(aCedFia[i]) == cFiaTre
			  LOOP
		       ENDIF
*....................FIN ANALISIS DE ASIGNACION

*....................ASIGNACION DE LA CEDULA
		       DO CASE
		       CASE EMPTY(cFiaUno)
			    cFiaUno := ALLTRIM(aCedFia[i])

		       CASE EMPTY(cFiaDos)
			    cFiaDos := ALLTRIM(aCedFia[i])

		       CASE EMPTY(cFiaTre)
			    cFiaTre := ALLTRIM(aCedFia[i])
		       OTHERWISE
			    cFiaUno := 'ERROR'
		       ENDCASE
*....................FIN ASIGNACION DE LA CEDULA

		 NEXT
*--------------FIN ANALISIS DE CEDULAS DE TECEROS

	    ENDIF
**********FIN ANALISIS DE LAS CEDULAS DE LOS FIADORES

**********IMPRESION DEL ESTUDIANTE Y PADRE
	    aTitulo := {}
	    AADD(aTitulo,STR(CLI->(RECNO()),2))
	    AADD(aTitulo,&cMaeAct->cCodigoEst)
	    AADD(aTitulo,cNombreTes)
	    AADD(aTitulo,cNomPadTes)
	    AADD(aTitulo,'PADRE')
	    AADD(aTitulo,&cMaeAct->cPadNitEst)

	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 AADD(aTitulo,'RETIRADO.'+cFiaUno)

	    CASE CLI->lRetGruCli
		 AADD(aTitulo,'OTRO GRUPO')
	    OTHERWISE
		 AADD(aTitulo,cFiaUno)
	    ENDCASE
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL ESTUDIANTE Y PADRE

**********IMPRESION DE LA MADRE
	    IF .NOT. CLI->lRetGruCli
	       aTitulo := {}
	       AADD(aTitulo,SPACE(02))
	       AADD(aTitulo,SPACE(06))
	       AADD(aTitulo,SPACE(40))
	       AADD(aTitulo,cNomMadTes)
	       AADD(aTitulo,'MADRE')
	       AADD(aTitulo,&cMaeAct->cMadNitEst)
	       AADD(aTitulo,cFiaDos)

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DE LA MADRE

**********IMPRESION DEL ACUDIENTE
	    IF .NOT. CLI->lRetGruCli

	       aTitulo := {}
	       AADD(aTitulo,SPACE(02))
	       AADD(aTitulo,SPACE(06))
	       AADD(aTitulo,SPACE(40))
	       AADD(aTitulo,cNomAcuTes)
	       AADD(aTitulo,'ACUDIENTE')
	       AADD(aTitulo,&cMaeAct->cAcuNitEst)
	       AADD(aTitulo,cFiaTre)

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL ACUDIENTE

**********AVANCE DEL SIGUIENTE REGISTRO
	    CLI->(DBSKIP())
	    IF CLI->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
