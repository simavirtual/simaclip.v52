/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES

**************************************************************************
* TITULO..: IMPRESION DE BOLETINES POR GRUPOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/1995 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   JUN 05/1995 LUN


OBJETIVOS:

1- Imprime por grupos y n£mero de lista los boletines de los estudiantes


2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_261(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                 // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema
       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas
       #DEFINE  OFICIO CHR(27)+'C'+CHR(78) // P gina de 78 l¡neas
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathMtr := ''                  // Path de SimaMatr
       LOCAL PathCon := ''                  // Path de SimaCont
       LOCAL PathPro := ''                  // Path de SimaProf
       LOCAL PathCar := ''                  // Path de SimaCart
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL       k := 0                   // Contador
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL lPrnBol := .F.                 // Imprimir Boletin por Estudiante
       LOCAL cNroBis := ''                  // N£mero del Periodo
       LOCAL nTipPrn := 0                   // Tipo de Impresi¢n 1=>Por Grupos 2=>Repetir Boletines
       LOCAL cTitDos := ''                  // Titular Dos
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cBoletiTes := ''               // Repetir Boletines
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
       IF  !lParam0102(aParams,;
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

*>>>>LECTURA DE PATHS
       PathPro := PathUno
       PathMtr := PathDos
       PathCar := PathTre
       PathCon := PathCua
*>>>>FIN LECTURA DE PATHS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cPatTem := cPatSis+'\'+cMaeAct
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatTem+'\'+fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileJvf,'JVF',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileApr,'APR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileEva,'EVA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatTem+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE TCO->nTipBolTbl== 0
	    cError('NO SE HA ESPECIFICADO EL TIPO DE BOLETIN A IMPRIMIR')

       CASE TCO->nJuiExtTbl > 1
	    cError('EL TOTAL DE INDICADORES NO PUEDE SER MAYOR A 1')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nPrnBolPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF TCO->nTipBolTbl # 1
	  IF !lUseDbf(.T.,cPatTem+'\'+;
			  FileJui+cMaeAct+cAnoSis+ExtFile,'JUI',;
			  cPatTem+'\'+;
			  fNtxJui+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	     !lUseDbf(.T.,cPatTem+'\'+FileCla,'CLA',NIL,lShared)

	     cError('ABRIENDO EL ARCHIVO DE JUICIOS')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF TCO->nTipBolTbl # 1
	  lHayErr := .T.
	  DO CASE
*	  CASE JUI->(RECCOUNT()) == 0
*	       cError('NO EXISTEN JUICIOS GRABADOS')
	  CASE CLA->(RECCOUNT()) == 0
	       cError('NO EXISTEN CLASES GRABADAS')
	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE

	  IF lHayErr
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL TIPO DE IMPRESION
       nTipPrn := nLeeOpcion('ENTRE EL TIPO DE IMPRESION: '+;
		 '1<POR GRUPOS> 2<REPETIR> 3<ABANDONAR>?',3,'0')

       IF nTipPrn == 3
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE IMPRESION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       cGruIni := GRU->cCodigoGru

       lPrnBol := .F.
       IF SCO->lPrnArcCon
	  lPrnBol := lPregunta('DESEA CREAR EL BOLETIN POR ESTUDIANTE? No Si')
	  IF !lPrnBol
	     SET PRINTER TO &(PathPrn+'\'+cGruIni+cGruFin+'.PRN')
	  ENDIF
       ENDIF
       lPrnBol := .F.
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'bolegru'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","ProporOf","CondenOn"})
       IF TCO->lOficioTbl
	  SendCodes(PCL('Oficio'))
       ELSE
	  SendCodes(PCL('Carta'))
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatTem+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO TERCERO '+;
				     'CUARTO  QUINTO  SEXTO   SEPTIMO '+;
				     'OCTAVO  NOVENO  DECIMO  UNDECIMO',;
				  (VAL(SUBS(GRU->cCodigoGru,1,2))+1)*8-7,8)))
		CLOSE ALL
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatTem+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatTem+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DEL NOMBRE DEL TITULAR
	    cTitDos := 'NO EXISTE TITULAR2'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodProPro)

	       cTitDos := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)

	    ENDIF

	    cNombreTpr := 'NO EXISTE TITULAR'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro,;
			  'DEL PROFESOR TITULAR')

	       cNombreTpr := ALLTRIM(PRO->cNombrePro)+' '+;
			     ALLTRIM(PRO->cApelliPro)
			     
	    ENDIF
**********FIN LOCALIZACION DEL NOMBRE DEL TITULAR

**********CALCULO DEL PORCENTAJE DEL ACUMULADO
	    nPorAcu := 0
	    FOR k := 1 TO nNroBis
		nPorAcu += VAL(SUBS(TCO->cPorcenTbl,k*2-1,2))
	    ENDFOR
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroBis)
**********FIN CALCULO DEL PORCENTAJE DEL ACUMULADO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF TCO->nTipBolTbl == 99 .AND. !EMPTY(PathCar)

	       FileCli := PathCar+'\'+cPatSis+;
			  '\CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared)
		  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT NOT
	    GO nNroIni
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			     'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			      cGruFin+'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT NOT
		 IF nNroFin <> 0
		    IF NOT->(RECNO()) > nNroFin

		       @ PROW()-PROW(),00 SAY ' '
		      *Saca la ultima linea
		       VerPrn(nOpcPrn,FilePrn)

		       CloseAll()
		       SET DEVICE TO SCREEN
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS DEL PERIODO DEL RETIRO
		 lRetiroTes := &cMaeAct->lRetiroEst
		 IF lRetiroTes
		    IF nNroBis <= &cMaeAct->nPerRetEst
		       lRetiroTes := .F.
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DEL PERIODO DEL RETIRO

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF lRetiroTes
		    SELECT NOT
		    NOT->(DBSKIP())  // OJO CON EL BOLETIN
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------ANALISIS DE LA REPETICION DEL BOLETIN
		 cBoletiTes := SUBS(&cMaeAct->cBoletiEst,nNroBis*2-1,2)
		 IF nTipPrn == 2
		    IF SUBS(cBoletiTes,1,1) # '1' .OR.;
		       SUBS(cBoletiTes,2,1) # SPACE(01)

		       SELECT NOT
		       NOT->(DBSKIP())  // OJO CON EL BOLETIN
		       LOOP

		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DE LA REPETICION DEL BOLETIN

*--------------REEMPLAZO DE LAS ASIGNATURAS VARIABLES
		 IF SEL->(RECCOUNT()) # 0
		    lDetAreEst(@aNotAre,@aNotMat,nNroBis,NOT->cCodigoEst)
		 ENDIF
*--------------FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

*--------------ACTIVACION DEL DISPOSITIVO DE IMPRESION
		 IF lPrnBol
		    cNroBis := STR(nNroBis,1)
		    SET PRINTER TO &(PathPrn+'\'+NOT->cCodigoEst+'P'+cNroBis+'.TXT')
		 ENDIF
*--------------ACTIVACION DEL DISPOSITIVO DE IMPRESION

*--------------IMPRESION DEL TIPO DE BOLETIN
		 SET DEVICE TO PRINT
		 DO CASE
		 CASE TCO->nTipBolTbl== 1
		      BoletinNot(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)

		 CASE TCO->nTipBolTbl== 2
		      BoletinNyJ(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)

		 CASE TCO->nTipBolTbl== 3
		      BoletinJui(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin con areas y asignaturas NO anidadas

		 CASE TCO->nTipBolTbl== 4
		      Bol1IndAre(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		     *Boletin con areas y asignatura anidadas

		 CASE TCO->nTipBolTbl== 5
		      Boletin05(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin con areas y asignaturas NO anidadas prof animador

		 CASE TCO->nTipBolTbl== 6
		      Boletin06(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		     *Solo juicios para Belemitas. Barranca.

		 CASE TCO->nTipBolTbl == 7
		      Boletin07(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Solo Indicadores == 3 pero con recuperaciones

		 CASE TCO->nTipBolTbl == 8
		      Boletin08(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin del Virrey

		 CASE TCO->nTipBolTbl == 9
		      Boletin09(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin de la Sabiduria. Nota y Descripci¢n

		 CASE TCO->nTipBolTbl == 10
		      Boletin10(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin de la Sabiduria. Todas las Notas

	    CASE TCO->nTipBolTbl == 11
		      ScoBol_11(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		     *Boletin Abreviado. Virrey

		 CASE TCO->nTipBolTbl == 12
		      Boletin12(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin de la BeleBan. Descripci¢n y nota en porcentaje

		 CASE TCO->nTipBolTbl == 13
		      Boletin13(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin San Jose. Solo Notas

		 CASE TCO->nTipBolTbl == 99
		      BoleXml07(lShared,cCodEmp,cNomEmp,cNomSis,cAnoUsr,;
				cPatSis,PathCar,cNombreTes,cNombreTpr,;
				cTitDos,nNroBis,TCO->cPorcenTbl,nPorAcu,;
				cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin en Xml

		 CASE TCO->nTipBolTbl== 98

		      Boletin98(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin Prueba Isb

		 ENDCASE
		 SET DEVICE TO SCREEN
*--------------FIN IMPRESION DEL TIPO DE BOLETIN

*--------------GRABACION DE LA REPETICION DEL BOLETIN
		 IF nTipPrn == 2
		    SELECT &cMaeAct
		    cBoletiTes := STUFF(cBoletiTes,2,1,'1')
		    cBoletiTes := STUFF(&cMaeAct->cBoletiEst,;
					nNroBis*2-1,2,cBoletiTes)

		    IF lRegLock(lShared,.F.)
		       REPL &cMaeAct->cBoletiEst WITH cBoletiTes
		       DBCOMMIT()
		    ELSE
		       cError('NO SE GRABA EL REGISTRO')
		    ENDIF
		    IF lShared
		       DBUNLOCK()
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DE LA REPETICION DEL BOLETIN

	       SELECT NOT
	       SKIP

	    ENDDO
	    CLOSE NOT
	    CLOSE PLA
	    CloseDbf('CLI')
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  nNroIni := 1
	  SELECT GRU
	  SKIP

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

************

/*************************************************************************
* TITULO DEL PROGRAMA..: BOLETIN DE INDICADORES Y AREAS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 09/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   ABR 09/96 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con las areas descriminadas
   y las materias con sus respectivos indicadores.

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoleIndAre(cNomEmp,cNomSis,cAnoSys,cNomEst,cNomTit,;
		    nNroBis,cPorcen,nPorAcu,cJorTxt,aNotAre,aNotMat)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cNomTit                              // Nombre del titular
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL cPorMat := ''                  // Porcentaje de la materia
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cAcuAre := ''                  // Acumulado del area
       LOCAL cProAre := ''                  // Promedio del area
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cJuicio := SUBS(&(aNotAre[i,6]),nNroBis*16-15,16)
	     nJuiAre += LEN(ALLTRIM(cJuicio))/4
	  ENDIF
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	  cJuicio := SUBS(&(aNotMat[i,5]),nNroBis*16-15,16)
	  nJuiMat += LEN(ALLTRIM(cJuicio))/4
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       nTotImp := IF(nNroBis==4,15,11)
      *L¡neas de los totales de impresi¢n

       nTotCab := IIF(TCO->nLinEspTbl+4 > 10,(TCO->nLinEspTbl+4)-10,0)
      *Total l¡neas del encabezado

       nTotReg := nTotCab+LEN(aNotAre)+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
      *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO DEL BOLETIN
	    IF lPagina
	       CabezaBole(TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
			   cNomEst,;
			   NOT->cCodigoEst,;
			   GRU->cCodigoGru,;
			   NOT->(RECNO()),;
			   nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,2)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

**********IMPRESION DE LAS NOTAS DEL AREA
	    cNroCol := '47637893'
	    @PROW()+1,00 SAY aNotAre[i,3]
	   *Impresi¢n del nombre del area
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LOS JUICIOS
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------VALIDACION Y BUSQUEDA DEL JUICIO
		 cJuicio := SUBS(&(aNotAre[i,6]),nNroBis*16-15,16)
		 FOR j:= 1 TO 4

*                   VALIDACION DEL JUICIO
		      cCodJui := SUBS(cJuicio,j*4-3,4)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*                   FIN VALIDACION DEL JUICIO

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)
		      cCodigoTju := cCodigoTma+cCodJui
		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui

		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
		      @PROW()+1,02 SAY cNombreTju
*   		    FIN BUSQUEDA DEL JUICIO

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > 58
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			 EJECT
			 CabezaBole(TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
				     cNomEst,;
				     NOT->cCodigoEst,;
				     GRU->cCodigoGru,;
				     NOT->(RECNO()),nPorAcu,;
				     cPorcen,nNroBis,cAnoSys,cJorTxt,2)
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN VALIDACION Y BUSQUEDA DEL JUICIO

	    ENDIF
**********FIN IMPRESION DE LOS JUICIOS

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------IMPRESION DE LA MATERIA E INTESIDAD HORARIA
		    @PROW()+1,02 SAY aNotMat[j,2]
		   *Impresi¢n del nombre de la materia

		    @PROW()  ,37 SAY aNotMat[j,3]
		   *Impresi¢n de la intensidad horaria
*-----------------FIN IMPRESION DE LA MATERIA E INTESIDAD HORARIA

*-----------------IMPRESION DE LAS AUSENCIAS
		    cCamFal := aNotMat[j,6]
		    @PROW(),108 SAY SUBS(&cCamFal,nNroBis*2-1,2)
*-----------------FIN IMPRESION DE LAS AUSENCIAS

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := SUBS(&(aNotMat[j,5]),nNroBis*16-15,16)
		    FOR k:= 1 TO 4

*			VALIDACION DEL JUICIO
			  cCodJui := SUBS(cJuicio,k*4-3,4)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*			BUSQUEDA DEL JUICIO
			  cCodigoTma := SUBS(aNotMat[j,5],9,4)
			  cCodigoTju := cCodigoTma+cCodJui
			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui

			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
			  @PROW()+1,04 SAY cNombreTju
*			FIN BUSQUEDA DEL JUICIO

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > 58
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn)
			     EJECT
			     CabezaBole(TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
					 cNomEst,;
					 NOT->cCodigoEst,;
					 GRU->cCodigoGru,;
					 NOT->(RECNO()),nPorAcu,;
					 cPorcen,nNroBis,cAnoSys,cJorTxt,2)
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 58 - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= 58
		DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(TCO->nLinEspTbl,@cTxtPrn,nNroPag++,nTotReg,;
		      cNomEst,;
		      NOT->cCodigoEst,;
		      GRU->cCodigoGru,;
		      NOT->(RECNO()),;
		      nPorAcu,cPorcen,nNroBis,cAnoSys,cJorTxt,2)
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LOS PROMEDIOS GENERALES
       cNroCol := '47637893'
       @PROW()+2,00 SAY 'PROMEDIO PARA CADA PERIODO ...'
       FOR k := 1 TO nNroBis
	   @PROW(),VAL(SUBS(cNroCol,k*2-1,2)) SAY;
					      SUBS(NOT->cPromedNot,k*4-3,4)
	  *Impresi¢n del acumulado del periodo
       ENDFOR
       @PROW(),113 SAY SUBS(NOT->cPromedNot,(nNroBis+4)*4-3,4)
      *Impresi¢n del promedio general del alumno
*>>>>FIN IMPRESION DE LOS PROMEDIOS GENERALES

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == 4 .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHabNot)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA OBSERVACION
       cEstado := cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot)
      *Estado final del estudiante

       @ PROW()+2,00 SAY 'OBSERVACION: '+SUBRAY_ON+cEstado+SUBRAY_OF

       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DEL TITULAR
       cTxtPrn := 'Dir. '+cNomTit
       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL TITULAR



