/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: LIBRO FINAL

**************************************************************************
* TITULO..: IMPRESION DEL LIBRO FINAL                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 24/97 LUN A
       Colombia, Bucaramanga        INICIO: 11:40 PM   ENE 24/97 LUN


OBJETIVOS:

1- Imprime por grupos y n£mero de lista el libro final

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_541(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas
       #DEFINE  OFICIO CHR(27)+'C'+CHR(78) // P gina de 78 l¡neas
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL       k := 0                   // Contador
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL cNroFol := ''                  // N£mero del folio
       LOCAL cNomRec := ''                  // Nombre del Rector
       LOCAL cDocRec := ''                  // Documento del Rector
       LOCAL cCarRec := ''                  // Cargo del Rector
       LOCAL cDocSec := ''                  // Documento de la Secretaria
       LOCAL cCarSec := ''                  // Cargo de la secretaria
       LOCAL cTxtLib := ''                  // Texto para el Libro
       LOCAL aFirmas := {}                  // Firmas del libro
       LOCAL cNroNiv := ''                  // N£mero del Nivel
       LOCAL nOpcion := 0                   // N£mero de Opci¢n
       LOCAL lInfFin := .F.                 // Informe final.
       LOCAL cMatMod := ''                  // Materia de Modadalidad
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>SELECCION DEL PATH DEL SISTEMA
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatTem := cPatSis+'\JAR'
       CASE 'PRI' $ cMaeAct
	    cPatTem := cPatSis+'\PRI'
       CASE 'BTO' $ cMaeAct
	    cPatTem := cPatSis+'\BTO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fConAno+cAnoUsr+ExtFile,'COA',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileMaT,'MAT',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileJvf,'JVF',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatTem+'\'+fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileApr,'APR',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileEva,'EVA',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatTem+'\'+fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatTem+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACIO PARA EL NIVEL')

       CASE TCO->nTipLibTbl == 0
	    cError('NO SE HA DEFINIDO EL TIPO DE LIBRO A IMPRIMIR')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE APR->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA TABLA DE APROBACIONES')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF TCO->nTipLibTbl == 2
	  IF !lUseDbf(.T.,cPatTem+'\'+;
			  FileJui+cMaeAct+cAnoSis+ExtFile,'JUI',;
			  cPatTem+'\'+;
			  fNtxJui+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	     !lUseDbf(.T.,cPatTem+'\'+FileCla,'CLA',NIL,lShared)
	     cError('ABRIENDO EL ARCHIVO DE JUICIOS EN '+cPatTem)
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF TCO->nTipLibTbl == 2
	  lHayErr := .T.
	  DO CASE
	  CASE JUI->(RECCOUNT()) == 0
	       cError('NO EXISTEN INDICADORES GRABADOS')
	  OTHERWISE
	       lHayErr := .F.
	  ENDCASE

	  IF lHayErr
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL TIPO DE IMPRESION
       nOpcion := nLeeOpcion('ENTRE TIPO DE INFORME: '+;
		 '1<LIBRO FINAL> 2<INFORME FINAL> 3<ABANDONAR>?',3,'1')

       IF nOpcion == 3
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lInfFin := IF(nOpcion==1,.F.,.T.)
*>>>>FIN LECTURA DEL TIPO DE IMPRESION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

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
	  FilePrn := 'librogru'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
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
       nNroBis := TCO->nTotPerTbl
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatTem+'\'+;
		 cFilePlan(cAnoUsr,GRU->cCodigoGru),'PLA',NIL,lShared)

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
	   aNotAre := {}
	   aNotMat := {}
	   DetAreas(@aNotAre,@aNotMat,nNroBis)
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL LIBRO DEL GRUPO: '+;
			GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DEL NOMBRE DEL TITULAR
	    cNombreTpr := 'NO EXISTE TITULAR'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro,;
				  'DEL PROFESOR')
	       cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
			     ALLTRIM(PRO->cNombrePro)
	    ENDIF
**********FIN LOCALIZACION DEL NOMBRE DEL TITULAR

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
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT NOT
		 IF nNroFin <> 0
		    IF NOT->(RECNO()) > nNroFin

		       SET DEVICE TO SCREEN
		       VerPrn(nOpcPrn,FilePrn)

		       CloseAll()
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

*--------------REEMPLAZO DE LAS ASIGNATURAS VARIABLES
		 IF SEL->(RECCOUNT()) # 0
		    lDetAreEst(@aNotAre,@aNotMat,nNroBis,NOT->cCodigoEst)
		 ENDIF
*--------------FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

*--------------LOCALIZACION DE LA MATERIA DE MODALIDAD O ESPECIALIDAD
		 cMatMod := ''
		 IF lLocCodigo('cCodigoMat','MAT',&cMaeAct->cCodigoMat)
		    cMatMod := ALLTRIM(MAT->cNombreMat)
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIA DE MODALIDAD O ESPECIALIDAD

*--------------PREPARACION DE LOS FIRMANTES DEL LIBRO
		 cTxtLib := ALLTRIM(SCO->cTxtLibCon)+' '+;
			    ALLTRIM(SCO->cTxtLi1Con)
		 cNomRec := ALLTRIM(SCO->cGerentCon)
		 cDocRec := ALLTRIM(SCO->cNitGerCon)
		 cCarRec := ALLTRIM(SCO->cCarGerCon)

		 cNomSec := ALLTRIM(SCO->cSecretCon)
		 cDocSec := ALLTRIM(SCO->cNitSecCon)
		 cCarSec := ALLTRIM(SCO->cCarSecCon)

		 IF lInfFin

		    aFirmas := {{cNombreTpr}}   // Marca error

		    aFirmas := {{cNombreTpr,'',''},;
				 {'','',''}}
		 ELSE
		    aFirmas := {{cNomRec,cDocRec,cCarRec},;
				{cNomSec,cDocSec,cCarSec}}
		 ENDIF
*--------------FIN PREPARACION DE LOS FIRMANTES DEL LIBRO

*--------------IMPRESION DEL TIPO DE BOLETIN
		 SET DEVICE TO PRINT
		 cNroFol := IF(lInfFin,'','FOLIO No. ')
		 DO CASE
		 CASE TCO->nTipLibTbl == 1
		      LibroFin01(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 &cMaeAct->lRetiroEst,&cMaeAct->dFecRetEst,;
				 aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
				 cMaeAct,cTxtLib,lInfFin,cMatMod)
		     *Modelo inspirado del Colegio San Bernardo.

		 CASE TCO->nTipLibTbl == 2

		      Boletin07(cNomEmp,cNomSis,cAnoUsr,cNombreTes,'','',;
				nNroBis,TCO->cPorcenTbl,nPorAcu,cJorTxt,;
				cMaeAct,aNotAre,aNotMat,aFirmas,;
				TCO->nColEncTbl,TCO->nColBolTbl)
		    *Solo Indicadores == 3 pero con recuperaciones

/*
		      LibroFin02(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 &cMaeAct->lRetiroEst,&cMaeAct->dFecRetEst,;
				 aFirmas,cJorTxt,cMaeAct,aNotAre,aNotMat,;
				 cNroFol,cTxtLib)
		*Dise¤o original. Igual al £ltimo periodo.
*/

		 CASE TCO->nTipLibTbl == 3
		      LibroFin03(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 &cMaeAct->lRetiroEst,&cMaeAct->dFecRetEst,;
				 aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
				 cMaeAct,cTxtLib,lInfFin,cMatMod)
		     *Modelo inspirado del Colegio De La Salle Bogota.

		 CASE TCO->nTipLibTbl == 4
		      cNombreTes := ALLTRIM(cNombreTes)+;
				    ' IDENTIFICACION:'+;
				    RTRIM(&cMaeAct->cDocNitEst)

		      LibroFin04(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 &cMaeAct->lRetiroEst,&cMaeAct->dFecRetEst,;
				 aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
				 cMaeAct,cTxtLib,lInfFin,cMatMod)
		     *Modelo inspirado del Colegio Presentaci¢n. Centro. Con Notas Numericas.

		 CASE TCO->nTipLibTbl == 5

		      LibroFin05(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
				 &cMaeAct->lRetiroEst,&cMaeAct->dFecRetEst,;
				 aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
				 cMaeAct,cTxtLib,lInfFin,cMatMod)
		     *Libro para areas promediables. Isb

		 ENDCASE
*--------------FIN IMPRESION DEL TIPO DE BOLETIN

	       SELECT NOT
	       SKIP

	    ENDDO
	    CLOSE NOT
	    CLOSE PLA
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  nNroIni := 1
	  SELECT GRU
	  SKIP

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS
