/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES RECUPERACIONES

**************************************************************************
* TITULO..: IMPRESION DE BOLETINES RECUPERACIONES POR GRUPOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2007 MIE A
       Bucaramanga, Colombia	    INICIO: 10:50 AM   MAY 16/2007 MIE

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los boletines de los estudiantes

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_291(aParam1,aParam2,aParam3)

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
       LOCAL lHayRec := .F.                 // .T. Hay Recuperacion
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte

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

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>LECTURA DE LA FECHA DE CORTE

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
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nPrnCerPrn)
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
	  SendCodes(OFICIO)
       ELSE
	  SendCodes(CARTA)
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
		    SET PRINTER TO &(PathPrn+'\'+NOT->cCodigoEst+'P'+cNroBis+'.rec')
		 ENDIF
*--------------ACTIVACION DEL DISPOSITIVO DE IMPRESION

*--------------IMPRESION DEL TIPO DE BOLETIN
		 lHayRec := lHayRecEst(nNroBis,aNotAre,aNotMat)
		 SET DEVICE TO PRINT
		 DO CASE
		 CASE TCO->nTipBolTbl== 1 .AND. lHayRec
		      BoletinNot(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)

		 CASE TCO->nTipBolTbl== 2 .AND. lHayRec
		      BoletinNyJ(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)

		 CASE TCO->nTipBolTbl== 3 .AND. lHayRec
		      BoletinJui(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin con areas y asignaturas NO anidadas

		 CASE TCO->nTipBolTbl== 4 .AND. lHayRec
		      Bol1IndAre(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				 nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		     *Boletin con areas y asignatura anidadas

		 CASE TCO->nTipBolTbl== 5 .AND. lHayRec
		      Boletin05(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin con areas y asignaturas NO anidadas prof animador

		 CASE TCO->nTipBolTbl== 6 .AND. lHayRec
		      Boletin06(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		     *Solo juicios para Belemitas. Barranca.

		 CASE TCO->nTipBolTbl == 7 .AND. lHayRec
		      BoleRecu07(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl,dFecPrn)
		    *Solo Indicadores == 3 pero con recuperaciones

		 CASE TCO->nTipBolTbl == 8 .AND. lHayRec
		      Boletin08(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin del Virrey

		 CASE TCO->nTipBolTbl == 9 .AND. lHayRec
		      Boletin09(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin de la Sabiduria. Nota y Descripci¢n

		 CASE TCO->nTipBolTbl == 10 .AND. lHayRec
		      Boletin10(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
				nPorAcu,cJorTxt,cMaeAct,aNotAre,aNotMat,NIL,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Boletin de la Sabiduria. Todas las Notas

		 CASE TCO->nTipBolTbl == 99 .AND. lHayRec
		      BoleXml07(lShared,cCodEmp,cNomEmp,cNomSis,cAnoUsr,;
				cPatSis,PathCar,cNombreTes,cNombreTpr,;
				cTitDos,nNroBis,TCO->cPorcenTbl,nPorAcu,;
				cJorTxt,cMaeAct,aNotAre,aNotMat)
		    *Boletin en Xml

		 CASE TCO->nTipBolTbl== 98 .AND. lHayRec

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



