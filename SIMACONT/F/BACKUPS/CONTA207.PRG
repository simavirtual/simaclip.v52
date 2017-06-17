/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: RESUMENES

**************************************************************************
* TITULO..: IMPRESION DE LOS RESUMENES                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 11/1995 MAR A
       Colombia, Bucaramanga        INICIO: 12:15 PM   JUL 11/1995 MAR

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los resumenes de los estudiantes


2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_207(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL     i,k := 0                   // Contadores
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL nPorAcu := 0                   // % Acumulado del periodo
       LOCAL nPorAcS := 0                   // % Acumulado sgte periodo
       LOCAL nPorBiS := 0                   // % del bimestre siguiente

       LOCAL lNotNum := .F.                 // .T. Nota N£merica
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cTxtTem := ''                  // Variable temporal

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 0                   // N£mero de la opci¢n
       LOCAL lPrnInd := .F.                 // .T. Imprimir con los Indicadores
       LOCAL lPrnJui := .F.                 // .T. Imprimir los Juicios
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cDescriTap := ''               // Descripci¢n de Promoci¢n
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECCION DEL PATH DEL SISTEMA
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatSis := cPatSis+'\JAR'
       CASE 'PRI' $ cMaeAct
	    cPatSis := cPatSis+'\PRI'
       CASE 'BTO' $ cMaeAct
	    cPatSis := cPatSis+'\BTO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileEmp,'EMP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileMaT,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileJvf,'JVF',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileCla,'CLA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileEva,'EVA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileApr,'APR',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatSis+'\'+fNtxSel+cMaeAct+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE EMP->(RECCOUNT()) == 0
	    cError('NO EXISTEN DATOS DE LA EMPRESA')

       CASE EMP->nTipBolEmp == 0
	    cError('NO SE HA ESPECIFICADO EL TIPO DE BOLETIN A IMPRIMIR')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

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
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='1',.T.,.F.)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>ANALISIS DE LA IMPRESION DE LOS INDICADORES
       lPrnInd := .T.
       IF TCO->nTotPerTbl == nNroBis
	  lPrnInd := lPregunta('DESEA IMPRIMIR EL RESUMEN '+;
			       'CON LOS INDICADORES DE LOGROS? Si No')
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION DE LOS INDICADORES

*>>>>SELECCION DE LA CLASE DE INDICADOR
      IF lPrnInd
	 SELECT CLA
	 DO WHILE .T.
	    IF nSelRegDbf(nFilInf+1,nColInf-1,'CLA','cNombreCla') # 0
	       IF !lPregunta('ESCOGIO '+ALLTRIM(CLA->cNombreCla)+;
		  ' DESEA CONTINUAR? Si No')
		  CLOSE ALL
		  RETURN NIL
	       ENDIF
	       EXIT
	    ELSE
		IF !lPregunta('ESCOGIO TODOS LOS INDICADORES. '+;
			      'DESEA CONTINUAR? No Si')
		   CLOSE ALL
		   RETURN NIL
		ENDIF
		GO CLA->(RECCOUNT())+1
	       *Se Ubica al final del Archivo
		EXIT
	    ENDIF
	 ENDDO
       ENDIF
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnJui := .F.
       IF lPrnInd
	  lPrnJui := lPregunta('DESEA IMPRIMIR LA DESCRIPCION '+;
			       'DE LOS INDICADORES? No Si')
	  IF lPrnJui
	     IF !lUseDbf(.T.,cPatSis+'\'+;
			     FileJui+cMaeAct+cAnoSis+ExtFile,'JUI',;
			     cPatSis+'\'+;
			     fNtxJui+cMaeAct+cAnoSis+cExtNtx,lShared)
		cError('ABRIENDO EL ARCHIVO DE JUICIOS')
		CLOSE ALL
		RETURN NIL
	     ENDIF
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS DE LA IMPRESION DE LA EVALUACION DEL INDICADOR
       IF lEvaInd
	  lEvaInd := lPregunta('DESEA IMPRIMIR EL RESUMEN '+;
			       'CON LA EVALUACION DE LOS INDICADORES? Si No')
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION DE LA EVALUACION DEL INDICADOR

*>>>>SELECCION DE LA EVALUACION DEL INDICADOR
      IF lEvaInd
	 SELECT EVA
	 DO WHILE .T.
	    IF nSelRegDbf(nFilInf+1,nColInf-1,'EVA','cNombreEva') # 0
	       IF !lPregunta('ESCOGIO '+ALLTRIM(EVA->cNombreEva)+;
		  ' DESEA CONTINUAR? Si No')
		  CLOSE ALL
		  RETURN NIL
	       ENDIF
	       EXIT
	    ELSE
		IF !lPregunta('ESCOGIO TODOS LAS EVALUACIONES. '+;
			      'DESEA CONTINUAR? No Si')
		   CLOSE ALL
		   RETURN NIL
		ENDIF
		GO EVA->(RECCOUNT())+1
	       *Se Ubica al final del Archivo
		EXIT
	    ENDIF
	 ENDDO
       ENDIF
*>>>>FIN SELECCION DE LA EVALUACION DEL INDICADOR

*>>>>SELECCION DE LA NOTA FINAL
       IF lHayNot

	  FOR i := 1 TO LEN(ALLTRIM(TCO->cValNotTbl))
	      DO CASE

	      CASE SUBS(ALLTRIM(TCO->cValNotTbl),i,1) == 'E'
		   AADD(aMenus,'<EXCELENTE    >')
		   AADD(aAyuda,'Estudiantes con notas Excelentes')

	      CASE SUBS(ALLTRIM(TCO->cValNotTbl),i,1) == 'S'
		   AADD(aMenus,'<SOBRESALIENTE>')
		   AADD(aAyuda,'Estudiantes con notas Excelentes')

	      CASE SUBS(ALLTRIM(TCO->cValNotTbl),i,1) == 'B'
		   AADD(aMenus,'<BUENO        >')
		   AADD(aAyuda,'Estudiantes con notas Buenas')

	      CASE SUBS(ALLTRIM(TCO->cValNotTbl),i,1) == 'A'
		   AADD(aMenus,'<ACEPTABLE    >')
		   AADD(aAyuda,'Estudiantes con notas Aceptables')

	      CASE SUBS(ALLTRIM(TCO->cValNotTbl),i,1) == 'I'
		   AADD(aMenus,'<INSUFICIENTE >')
		   AADD(aAyuda,'Estudiantes con notas Insuficientes')

	      CASE SUBS(ALLTRIM(TCO->cValNotTbl),i,1) == 'D'
		   AADD(aMenus,'<DEFICIENTE   >')
		   AADD(aAyuda,'Estudiantes con notas Insuficientes')

	      ENDCASE
	  ENDFOR
	  AADD(aMenus,'<NO NOTAS     >')
	  AADD(aAyuda,'Estudiantes Sin Notas')

	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  cNotDef := NIL
	  cTxtTem := 'TODAS LAS NOTAS'
	  IF nNroOpc # 0
	     cNotDef := ALLTRIM(SUBS(aMenus[nNroOpc],2,1))
	     cTxtTem := ALLTRIM(SUBS(aMenus[nNroOpc],2,12))
	  ENDIF

	  IF !lPregunta('ESCOGIO '+cTxtTem+'.'+;
			' DESEA CONTINUAR? Si No')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN SELECCION DE LA NOTA FINAL

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

       IF CON->lPrnArcCon
	  SET PRINTER TO &(PathPrn+'\'+cGruIni+cGruFin+'.PRN')
       ENDIF
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'resumen'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>CALCULO PORCENTAJE ACUMULADO SIGUIENTE PERIODO
       nPorAcS := 0
       FOR k := 1 TO nNroBis + 1
	   nPorAcS += VAL(SUBS(EMP->cPorcenEmp,k*2-1,2))
       ENDFOR
       nPorBiS := VAL(SUBS(EMP->cPorcenEmp,(nNroBis+1)*2-1,2))
*>>>>FIN CALCULO PORCENTAJE ACUMULADO SIGUIENTE PERIODO

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CLOSE ALL
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL RESUMEN
	    IF lHayJvfTco()

	       ResumenLog(cNomEmp,cNomSis,cAnoUsr,nNroBis,;
			  nNroIni,nNroFin,cNotDef,cJorTxt,;
			  lPrnInd,lPrnJui,lEvaInd,cGruFin)

	    ELSE

	       Resumen(cNomEmp,cNomSis,cAnoUsr,nNroBis,nNroIni,;
		       nNroFin,nPorAcS,nPorBiS,cJorTxt,cMaeAct)
	    ENDIF
**********FIN IMPRESION DEL RESUMEN

**********AVANCE AL SIGUIENTE REGISTRO
	    nNroIni := 1
	    CLOSE PLA
	    SELECT GRU
	    SKIP
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO DEL PROGRAMA..: CUADRO DE RESUMEN DE NOTAS DE LOS ESTUDIANTES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 11/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:25 AM   JUL 11/95 MAR

OBJETIVOS:

1- Imprime los resumenes de los estudiantes de acuerdo al bimestre

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Resumen(cNomEmp,cNomSis,cAnoUsr,nNroBis,nNroIni,;
		 nNroFin,nPorAcS,nPorBiS,cJorTxt,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroBis			            // N£mero del bimestre
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       nPorAcS			            // % Acumulado del sgte periodo
       nPorBiS			            // % del bimestre sgte
       cMaeAct			            // Maestro activado
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"              // Impresora EPSON FX

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nLinReg := 0                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nNroReg := 0                   // N£mero de registros

       LOCAL lTamAnc := .T.                 // .T. Tama¤o Ancho
       LOCAL aCabeza := {}                  // Definici¢n del encabezado
       LOCAL cCodIni := ''                  // C¢digos impresora iniciales
       LOCAL cCabCol := ''                  // Encabezados de columnas
       LOCAL cCodFin := ''                  // C¢digos impresora finales
       LOCAL lCentra := .T.                 // Centrar Encabezados Columna
       LOCAL nColCab := 0                   // Columna encabezado columna

       LOCAL     i,j := 0                   // Contadores
       LOCAL aStrNot := {}                  // Estructura del archivo notas
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aCampos := {}                  // Nombres de los campos
       LOCAL aArePed := {}                  // Detalles areas p‚rdidas
       LOCAL aNotMin := {}                  // Detalles notas m¡nimas
       LOCAL cNotDef := ''                  // Nota definitiva
       LOCAL nArePed := 0                   // Areas perdidas
       LOCAL cAcuAct := ''                  // Acumulado actual
       LOCAL cNotMin := ''                  // Nota M¡nima

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(CON->lPrnArcCon)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       aCampos := {}
       DetAreas(@aNotAre,@aNotMat,nNroBis)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .T.

       nNroReg := NOT->(RECCOUNT())
       IF nNroFin # 0
	  nNroReg := nNroFin - nNroIni + 1
	 *N£mero de registro cuando es un intervalo
       ENDIF
       nTotReg := nNroReg * (nNroBis+4)
     *ÀCalculo del total de registros

       aCabeza := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'BIMESTRE No.'+STR(nNroBis,2),;
		   'CUADRO DE RESUMEN',;
		   'GRUPO: '+GRU->cCodigoGru+' '+;
			   'PROMEDIO: '+;
			   SUBS(GRU->cPromedGru,nNroBis*4-3,4)+' '+;
			   'ALUMNOS: '+STR(GRU->nNroAluGru,2,0),;
		   nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := DRAFT_ON+CONDEN_ON
       cCodFin := NEGRA_ON+DOBGOL_OF+CONDEN_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {08}
       aTitulo := {'Periodo '}

       FOR i:=1 TO LEN(aNotAre)

	   AADD(aTitulo, SUBS(aNotAre[i,7],1,6))
	   AADD(aNroCol,06)
	   AADD(aCampos,{aNotAre[i,4],aNotAre[i,8]})

	   FOR j:=1 TO LEN(aNotMat)

	      IF aNotAre[i,2] == aNotMat[j,1]
		 AADD(aTitulo,LOWER(SUBS(aNotMat[j,7],1,6)))
		 AADD(aNroCol,06)
		 AADD(aCampos,{aNotMat[j,4],aNotMat[j,8]})
	      ENDIF

	   ENDFOR

       ENDFOR
       AADD(aTitulo,'PERD')
       AADD(aNroCol,04)
       AADD(aTitulo,"PROM")
       AADD(aNroCol,04)
       AADD(aTitulo,"OBSERVACIONES ")
       AADD(aNroCol,14)
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Wide
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       CabezaPrn(cCodIni,aCabeza,cCabCol,nColCab,cCodFin)
      *Impresi¢n del encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,'ALU')
	       cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			     RTRIM(ALU->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(51),1,51)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := ALU->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= ALU->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF lRetiroTes .OR. NOT->lRetGruNot
	       SELECT NOT
	       SKIP
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    @ PROW(),00 SAY NEGRA_ON+CONDEN_OF

	    nLinReg := nNroBis+4                 
	   *Nro lineas por registro bimestres => 1§->5 2§->6 3§->7 4§->8

	    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    STR(NOT->(RECNO()),2)+SPACE(02)+;
			    SUBS(NOT->cCodigoEst,3,4)+SPACE(02)+;
			    SUBS(cNombreTes,1,51),cNomSis,cNomEmp,;
			    nLinReg,nLenPrn)
	    nLinReg := 0
	   *Por estar imprimiendo el registro

	    @ PROW(),00  SAY NEGRA_OF+DOBGOL_OF+CONDEN_ON
	    lPrintPrn(00,145,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			     'PUESTO: '+SUBS(NOT->cPuestoNot,nNroBis*2-1,2)+;
			     SPACE(02)+;
			     'PROMEDIOS:'+;
			     SUBS(NOT->cPromedNot,(nNroBis+4)*4-3,4),;
			     cNomSis,cNomEmp,nLinReg,nLenPrn)
	    aNroCol[1] := 6
	   *Actualiza la longitud de la primera nota

	    FOR i := 1 TO nNroBis

	      lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			      STR(i,2)+'§'+SPACE(02)+;
			      SUBS(EMP->cPorcenEmp,i*2-1,2)+'%',;
			      cNomSis,cNomEmp,nLinReg,nLenPrn)

	       aRegPrn := {}
	       nArePed := 0
	       FOR j:=1 TO LEN(aCampos)

		   cNotDef := SUBS(&(aCampos[j,1]),i*4-3,4)
		   IF SUBS(aCampos[j,1],7,4) == 'AREP'
		      IF VAL(cNotDef) < 6.0
			 nArePed++
		      ENDIF
		   ENDIF

		   IF SUBS(aCampos[j,1],7,4) # 'AREN'
		      IF VAL(cNotDef) < 6.0
			 cNotDef += '* '
		      ELSE
			 cNotDef += SPACE(02)
		      ENDIF
		   ENDIF
		   AADD(aRegPrn,cNotDef)
	       ENDFOR

	       AADD(aRegPrn,STR(nArePed,2))

	       aNroCol[LEN(aRegPrn)] := 4
	      *Actualiza la longitud del nro de areas p‚rdidas

	       AADD(aRegPrn,SUBS(NOT->cPromedNot,i*4-3,4))

	       cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	       lPrintPrn(00,09,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			       cTxtPrn,cNomSis,cNomEmp,nLinReg,nLenPrn)
	    ENDFOR
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********IMPRESION DE LOS ACUMULADOS
	    lPrintPrn(01,01,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    'Acum--->',cNomSis,cNomEmp,nLinReg,nLenPrn)

	    aNroCol[1] := 6
	   *Actualiza la longitud de la primera nota

	    aRegPrn := {}
	    aNotMin := {}
	    FOR j:=1 TO LEN(aCampos)

*---------------LECTURA DEL ACUMULADO DEL AREA
		  IF SUBS(aCampos[j,1],7,4) == 'AREP'

		     cAcuAct := SUBS(&(aCampos[j,2]),nNroBis*5-4,5)
		    *Acumulado actual

		     cNotMin := cNotMin(nNroBis,nPorAcS,nPorBiS,@cAcuAct)
		     IF nNroBis # 4
			cNotMin += SPACE(02)
		     ENDIF

		     AADD(aRegPrn,cAcuAct)
		    *Preparaci¢n para impresi¢n

		     AADD(aNotMin,cNotMin)
		   *ÀNota M¡nima

		  ENDIF
*---------------FIN LECTURA DEL ACUMULADO DEL AREA

*---------------LECTURA DEL ACUMULADO DE LA MATERIA
		  IF SUBS(aCampos[j,1],7,2) == 'NT'

		     cAcuAct := SUBS(&(aCampos[j,2]),nNroBis*5-4,5)

		     cNotMin := cNotMin(nNroBis,nPorAcS,nPorBiS,@cAcuAct)
		     IF nNroBis == 4
			cNotMin := SPACE(06)
		     ELSE
			cNotMin += SPACE(02)
		     ENDIF

		     AADD(aRegPrn,cAcuAct)
		    *Preparaci¢n para impresi¢n

		     AADD(aNotMin,cNotMin)
		   *ÀNota M¡nima

		  ENDIF
*---------------FIN LECTURA DEL ACUMULADO DE LA MATERIA

	    ENDFOR

	    aNroCol[LEN(aRegPrn)+1] := 22
	   *Actualiza la longitud del estado de aprobaci¢n

	    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	    lPrintPrn(00,09,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    cTxtPrn,cNomSis,cNomEmp,nLinReg,nLenPrn)

	    aNroCol[LEN(aRegPrn)+1] := 06
	   *Actualiza la longitud del estado de aprobaci¢n
**********FIN IMPRESION DE LOS ACUMULADOS

**********IMPRESION DE LAS NOTAS MINIMAS Y ESTADO FINAL
	    lPrintPrn(01,01,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			   'M¡nima->',cNomSis,cNomEmp,nLinReg,nLenPrn)

	    AADD(aNotMin,cAprobo(nNroBis,NOT->nAproboNot,NOT->cNotHabNot))
	    aNroCol[LEN(aNotMin)+1] := 22
	   *Actualiza la longitud del estado de aprobaci¢n

	    cTxtPrn := cRegPrint(aNotMin,aNroCol)
	    cTxtPrn := SUBS(cTxtPrn,1,(LEN(cTxtPrn)-1))
	   *Borra el £ltimo caracter

	    lPrintPrn(00,09,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    cTxtPrn,cNomSis,cNomEmp,nLinReg,nLenPrn)
	    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    REPL('=',LEN(cCabCol)),;
			    cNomSis,cNomEmp,nLinReg,nLenPrn)
**********FIN IMPRESION DE LAS NOTAS MINIMAS Y ESTADO FINAL

**********ACTUALIZACION DE LAS COLUMNAS DE IMPRESION
	    aNroCol[1] := 6
	   *Actualiza la longitud de la primera nota

	    aNroCol[LEN(aRegPrn)] := 06
	   *Actualiza la longitud del nro de areas p‚rdidas

	    aNroCol[LEN(aNotMin)+1] := 06
	   *Actualiza la longitud del estado de aprobaci¢n
**********FIN ACTUALIZACION DE LAS COLUMNAS DE IMPRESION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    SKIP
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CLOSE NOT
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO DEL PROGRAMA..: CALCULO DE LA NOTA MINIMA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 01/95 VIE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   SEP 01/95 VIE

OBJETIVOS:

1- Calcula la nota m¡nima para el siguiente periodo

2- Marca el acumulado con * en caso de p‚rdida

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna la nota m¡nima es caracter

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNotMin(nNroBis,nPorAcS,nPorBiS,cAcuAct)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroBis                             // N£mero del bimestre
       nPorAcS			           // % Acumulado del sgte periodo
       nPorBiS			           // % del Bimestre sgte
       cAcuAct				   // Acumulado actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nAcuSig := 0                   // Acumulado Siguiente
       LOCAL cNotMin := 0                   // Nota M¡mina
       LOCAL nAcuMin := 0                   // Acumulado m¡nimo bimestre
       LOCAL nPorAcB := 0                   // Porcentaje acumulado bimestre
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA PERDIDA DEL ACUMULADO
       nPorAcB := nPorAcS - nPorBiS
      *Porcentaje acumulado para bimestre

       nAcuMin := 6.0 * (nPorAcB/100)
      *Acumulado m¡nimo para el bimestre

       DO CASE
       CASE EMPTY(cAcuAct)
	    cAcuAct := '  ??  '

       CASE VAL(cAcuAct) <  nAcuMin
	    cAcuAct += '*'

       CASE VAL(cAcuAct) >= nAcuMin
	    cAcuAct += SPACE(01)
       ENDCASE
*>>>>FIN ANALISIS DE LA PERDIDA DEL ACUMULADO

*>>>>CALCULO DE LA NOTA MINIMA
       nAcuSig = 6.0 * (nPorAcS/100)
      *Acumulado m¡nimo sgte bimestre

       cNotMin = (nAcuSig - VAL(cAcuAct))*100 / nPorBiS
*>>>>FIN CALCULO DE LA NOTA MINIMA

*>>>>ANALISIS DE LA PERDIDA DE LA AREA O MATERIA
       cNotMin := STR(cNotMin,4,1)
       DO CASE
       CASE '?' $ cAcuAct
	    cNotMin := IF(nNroBis == 4,SPACE(06),SPACE(04))

       CASE VAL(cAcuAct) >=  nAcuMin .AND. nNroBis == 4
	    cNotMin := SPACE(06)

       CASE VAL(cAcuAct) <  nAcuMin .AND. nNroBis == 4
	    cNotMin := 'Perdio'
       ENDCASE
       RETURN cNotMin
*>>>>FIN ANALISIS DE LA PERDIDA DE LA AREA O MATERIA


/*************************************************************************
* TITULO DEL PROGRAMA..: CUADRO DE RESUMEN DE LOGROS DE LOS ESTUDIANTES  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/98 VIE A
       Colombia, Bucaramanga        INICIO: 12:25 AM   MAY 08/98 VIE

OBJETIVOS:

1- Imprime los resumenes de los estudiantes de acuerdo al bimestre

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ResumenLog(cNomEmp,cNomSis,cAnoUsr,nNroBis,;
		    nNroIni,nNroFin,cNotDef,cJorTxt,;
		    lPrnInd,lPrnJui,lEvaInd,cGruFin)


*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroBis			            // N£mero del bimestre
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cNotDef                              // Nota Definitiva de Selecci¢n
       cJorTxt                              // Jornada escogida
       lPrnInd                              // .T. Imprimir los Indicadores
       lPrnJui                              // .T. Imprimir los Juicios
       lEvaInd                              // .T. Evaluar el Indicador
       cGruFin                              // Grupo Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"              // Impresora EPSON FX

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nLinReg := 0                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nNroReg := 0                   // N£mero de registros

       LOCAL lTamAnc := .T.                 // .T. Tama¤o Ancho
       LOCAL aCabeza := {}                  // Definici¢n del encabezado
       LOCAL cCodIni := ''                  // C¢digos impresora iniciales
       LOCAL cCabCol := ''                  // Encabezados de columnas
       LOCAL cCodFin := ''                  // C¢digos impresora finales
       LOCAL lCentra := .T.                 // Centrar Encabezados Columna
       LOCAL nColCab := 0                   // Columna encabezado columna

       LOCAL   i,j,x := 0                   // Contadores
       LOCAL aStrNot := {}                  // Estructura del archivo notas
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aCampos := {}                  // Nombres de los campos
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL aNomJui := {}                  // Nombre de los Juicios
       LOCAL cCampos := ''                  // Nombre del Campo

       LOCAL cJuicio := ''                  // Indicadores de Logro
       LOCAL cLogros := ''                  // Indicadores del Estudiante
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n

       LOCAL lSiPaso := .F.                 // Variable para Contro de Paso
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota N£merica
       LOCAL lNumNot := .F.                 // .T. Nota N£merica
       LOCAL   cNota := ''                  // Notas
       LOCAL   cNotr := ''                  // Nota de Recuperaci¢n
       LOCAL nRegEva := 0                   // Registro Tabla de Evaluaci¢n
       LOCAL nRegCla := 0                   // Registro Clase de Indicadores
       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL cNotTxt := ''                  // Nota en Texto
       LOCAL cCamNot := ''                  // Campo de Nota
       LOCAL cCamRec := ''                  // Campo de Recuperaci¢n
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTju := ''               // C¢digo del Juicio
       LOCAL cNombreTju := ''               // Nombre del Juicio

       LOCAL cDescriTap := ''               // Descripci¢n de Promoci¢n
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(CON->lPrnArcCon)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroBis)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nNroReg := NOT->(RECCOUNT())
       IF nNroFin # 0
	  nNroReg := nNroFin - nNroIni + 1
	 *N£mero de registro cuando es un intervalo
       ENDIF
       nTotReg := nNroReg * (nNroBis+4)
     *ÀCalculo del total de registros

       aCabeza := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   IF(TCO->nTotPerTbl==nNroBis,'',;
			   'PERIODO No.'+STR(nNroBis,2)),;
		   'CUADRO DE RESUMEN'+IF(TCO->nTotPerTbl==nNroBis,;
					       ' FINAL',''),;
		   'GRUPO: '+GRU->cCodigoGru,;
		   nNroPag,NIL,lTamAnc}

       cCodIni := DRAFT_ON+CONDEN_ON
       cCodFin := DRAFT_ON+CONDEN_ON
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ANALISIS DE LA EVALUACION FINAL
       cTxtPrn := ''
       IF lHayNot
	  DO CASE
	  CASE cNotDef == 'E'
	       cTxtPrn := ' CON JUICIO VALORTATIVO EXCELENTE'

	  CASE cNotDef == 'S'
	       cTxtPrn := ' CON JUICIO VALORTATIVO SOBRESALIENTE'

	  CASE cNotDef == 'B'
	       cTxtPrn := ' CON JUICION VALORATIVO BUENO'

	  CASE cNotDef == 'A'
	       cTxtPrn := ' CON JUICIO VALORATIVO ACEPTABLE'

	  CASE cNotDef == 'I'
	       cTxtPrn := ' CON JUICIO VALORATIVO INSUFICIENTE'

	  CASE cNotDef == 'D'
	       cTxtPrn := ' CON JUICIO VALORATIVO DEFICIENTE'

	  CASE cNotDef == 'N'
	       cTxtPrn := ' SIN JUICIO VALORATIVO'
	       cNotDef := SPACE(04)
	  ENDCASE
       ENDIF
*>>>>FIN ANALISIS DE LA EVALUACION FINAL

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {130}
       IF CLA->(EOF())
	  IF lEvaInd
	     IF EVA->(EOF())
		aTitulo := {'RESUMEN DE INDICADORES CON TODAS '+;
			    'LAS EVALUACIONES'+;
			    IF(EMPTY(cTxtPrn),'',' Y')+cTxtPrn}
	     ELSE
		aTitulo := {'RESUMEN DE INDICADORES CON EVALUACION '+;
			    ALLTRIM(EVA->cNombreEva)+;
			    IF(EMPTY(cTxtPrn),'',' Y')+cTxtPrn}
	     ENDIF
	  ELSE
	     aTitulo := {'RESUMEN DE INDICADORES'+cTxtPrn}
	  ENDIF
       ELSE
	  IF lPrnInd
	     IF lEvaInd
		IF EVA->(EOF())
		   aTitulo := {'RESUMEN DE '+ALLTRIM(CLA->cNombreCla)+;
			       ' CON TODAS LAS EVALUACIONES'+;
			       IF(EMPTY(cTxtPrn),'',' Y')+cTxtPrn}
		ELSE
		   aTitulo := {'RESUMEN DE '+ALLTRIM(CLA->cNombreCla)+;
			       ' CON EVALUACION '+;
			       ALLTRIM(EVA->cNombreEva)+;
			       IF(EMPTY(cTxtPrn),'',' Y')+cTxtPrn}
		ENDIF
	     ELSE
		aTitulo := {'RESUMEN DE '+ALLTRIM(CLA->cNombreCla)+cTxtPrn}
	     ENDIF
	  ELSE
	     aTitulo := {'RESUMEN CON JUICIOS VALORATIVOS '+cTxtPrn}
	  ENDIF
       ENDIF
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       CabezaPrn(cCodIni,aCabeza,cCabCol,nColCab,cCodFin)
      *Impresi¢n del encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,'ALU')
	       cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			     RTRIM(ALU->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(51),1,51)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := ALU->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= ALU->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF lRetiroTes
	       SELECT NOT
	       SKIP
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       SKIP
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********REEMPLAZO DE LAS ASIGNATURAS VARIABLES
	    IF SEL->(RECCOUNT()) # 0
	       lDetAreEst(@aNotAre,@aNotMat,nNroBis,NOT->cCodigoEst,.T.)
	    ENDIF
**********FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

**********CARGA DE LAS MATERIAS
	    aCampos := {}
	    FOR i := 1 TO LEN(aNotAre)

		IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		   AADD(aCampos,{IF(lPrnInd .AND. !lPrnJui,;
				    aNotAre[i,7],;        // T¡tulo
				    aNotAre[i,3]),;       // Materia
				    aNotAre[i,6],;        // Logros
				    aNotAre[i,4],;        // Nota
				    aNotAre[i,11],;       // Ausencias
				    aNotAre[i,2]+'00'})   // C¢digo Materia

		ENDIF

		FOR j := 1 TO LEN(aNotMat)

		   IF aNotAre[i,2] == aNotMat[j,1]

		      IF EMPTY(aNotMat[j,14])
			 cCodigoTma := ALLTRIM(aNotMat[j,11])
		      ELSE
			 cCodigoTma := aNotMat[j,14]
		      ENDIF

		      AADD(aCampos,{IF(lPrnInd .AND. !lPrnJui,;
				       aNotMat[j,7],;     // T¡tulo
				       aNotMat[j,2]),;    // Materia
				       aNotMat[j,5],;     // Logros
				       aNotMat[j,4],;     // Nota
				       aNotMat[j,6],;     // Ausencias
				       cCodigoTma})    // C¢digo Materia
		   ENDIF
		ENDFOR
	    ENDFOR
**********FIN CARGA DE LAS MATERIAS

**********IMPRESION DEL REGISTRO
	    lSiPaso := .F.
	    nLinReg := 2
	    FOR i := 1 TO LEN(aCampos)

*--------------ANALISIS POR PERIODOS DE LA MATERIA
		 FOR j := 1 TO nNroBis

*...................INDICADORES DE LA MATERIA
		      cLogros := ''
		      aNomJui := {}
		      IF lPrnInd

			 cCampos := aCampos[i,2]
			 cCampos := STUFF(cCampos,8,1,STR(j,1))
		       *ÀCampo por periodos

			 cJuicio := &cCampos

*			 IF j <= nNroBis .AND. CLA->lRecupeCla
			 IF j <= nNroBis

			    nRegEva := EVA->(RECNO())
			    nRegCla := CLA->(RECNO())

			    IndRecSiNo(&cCampos,lEvaInd,,@cJuicio,.T.)

			    EVA->(DBGOTO(nRegEva))
			    CLA->(DBGOTO(nRegCla))
			    cTxtTem := ' Periodo No.'+STR(j,1)
			 ELSE
			    cTxtTem := ' PERIODO No.'+STR(j,1)
			 ENDIF

			 aJuicio := aJuicio(@cJuicio,TCO->lNoSortTbl)

			 IF LEN(aCampos[i,5]) == 4
			    cCodigoTma := aCampos[i,5]
			 ELSE
			    cCodigoTma := SUBS(aCampos[i,5],j*4-3,4)
			 ENDIF

			 cLogros := cNomIndMat(cCodigoTma,aJuicio,lEvaInd,;
					       lPrnJui,aNomJui)
		      ENDIF
*...................FIN INDICADORES DE LA MATERIA

*...................ANALISIS SI HAY NOTA
		      cNotTxt := ''
		      IF lHayNot

			 lNumNot := IF(SUBS(TCO->cNotNumTbl,j,1)='1',.T.,.F.)
			 cCamNot := aCampos[i,3]
			 cCamRec := SUBS(cCamNot,1,12)+'Rec'
			 cNota := SUBS(&(cCamNot),j*4-3,4)
			 cNota := cNotDef(cNota,lNumNot)
			 cNotr := SUBS(&(cCamRec),j*4-3,4)

			 IF cNotDef # NIL
			    IF .NOT. cNotDef $ cNota
			       LOOP
			    ENDIF
			 ENDIF

			 IF .NOT. EMPTY(cNota)
			    cNotTxt := '=>'+cTxtNota(ALLTRIM(cNota))+;
					    IF(EMPTY(cNotr),'',;
					       'RECUPERACION:'+;
					       cTxtNota(ALLTRIM(cNotr)))
			    cTxtTem += cNotTxt
			 ENDIF
		      ENDIF
*...................FIN ANALISIS SI HAY NOTA

*...................IMPRESION DEL NOMBRE DEL ESTUDIANTE
		      IF !lSiPaso
			  IF (!EMPTY(cLogros) .AND. lPrnInd) .OR. !lPrnInd
			     @ PROW(),00 SAY NEGRA_ON+CONDEN_OF
			     lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,;
					     cCodFin,STR(NOT->(RECNO()),2)+;
					     SPACE(02)+NOT->cCodigoEst+;
					     SPACE(02)+SUBS(cNombreTes,1,51),;
					     cNomSis,cNomEmp,nLinReg,nLenPrn)
			     @ PROW(),00  SAY NEGRA_OF+DOBGOL_OF+CONDEN_ON
			     lSiPaso := .T.
			  ENDIF
		      ENDIF
*...................FIN IMPRESION DEL NOMBRE DEL ESTUDIANTE

*...................IMPRESION DE LOS INDICADORES
		      IF .NOT. EMPTY(cLogros)
			 IF !lPrnJui

			    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,;
					    cCodFin,'P'+STR(j,1)+'=>'+;
					    aCampos[i,1]+SPACE(02)+cLogros+;
					    cNotTxt,cNomSis,cNomEmp,nLinReg,;
					    nLenPrn)
			 ELSE

			    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,;
					    cCodFin,NEGRA_ON+;
					    ALLTRIM(aCampos[i,1])+cTxtTem+;
					    NEGRA_OF,cNomSis,cNomEmp,nLinReg,;
					    nLenPrn)

			    FOR x := 1 TO LEN(aNomJui)

				IF !EMPTY(aNomJui[x])
				   lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,;
						   nColCab,cCodFin,aNomJui[x],;
						   cNomSis,cNomEmp,nLinReg,;
						   nLenPrn)
				ENDIF
			    ENDFOR
			 ENDIF
		      ENDIF
*...................FIN IMPRESION DE LOS INDICADORES

		 ENDFOR
*--------------FIN ANALISIS POR PERIODOS DE LA MATERIA

	    ENDFOR
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DE LA PROMOCION FINAL Y OBSERVACIONES
	    IF TCO->nTotPerTbl == nNroBis .AND. lSiPaso .AND. lHayNot

	       lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			       REPL('-',LEN(cCabCol)),;
			       cNomSis,cNomEmp,nLinReg,nLenPrn)

*--------------PROMOCION FINAL
		 cTxtObsTap := ''
		 IF lRetiroTes
		    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
				    'PROMOCION FINAL: NO TERMINO. '+;
				    'SE RETIRO EN '+cFecha(ALU->dFecRetEst),;
				    cNomSis,cNomEmp,nLinReg,nLenPrn)
		 ELSE
		    cDescriTap := cAproboJui(NOT->nAproboNot,;
					     SUBS(ALU->cCodigoGru,1,2),;
					     @cTxtObsTap)
		    cTxtObsTap := ALLTRIM(cTxtObsTap)

		    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
				    'PROMOCION FINAL: '+ALLTRIM(cDescriTap),;
				    cNomSis,cNomEmp,nLinReg,nLenPrn)
		 ENDIF
*--------------FIN PROMOCION FINAL

*--------------IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
		 aMatHab := {}
		 aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,aNotMat,;
				       TCO->nTotPerTbl,lNotNum,;
				       lMatVar)
		*Materias de las Recuperaciones

		 IF !EMPTY(aMatHab)
		    IF EMPTY(TCO->cTitRecTbl)
		       cTxtPrn := 'ACTIVIDADES DE RECUPERACION DE:'
		    ELSE
		       cTxtPrn := ALLTRIM(TCO->cTitRecTbl)
		    ENDIF

		    FOR i := 1 TO LEN(aMatHab)
			cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
			IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
			   cTxtPrn += 'PENDIENTE. '

			ELSE
			   cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
				      ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
				      ' DE '+aMatHab[i,2]+'. '
			ENDIF
		    NEXT
		    aNroLin := aDivLin(ALLTRIM(cTxtPrn+cTxtObsTap),110)
		    FOR i := 1 TO LEN(aNroLin)
			lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
					aNroLin[i],;
					cNomSis,cNomEmp,nLinReg,nLenPrn)
		    NEXT
		 ENDIF
*--------------IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*--------------IMPRESION DE LA OBSERVACION
		 IF !EMPTY(ALU->cObsLibEst)
		    aNroLin := aDivLin(ALLTRIM(ALU->cObsLibEst),110)
		    FOR i := 1 TO LEN(aNroLin)
			lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
					aNroLin[i],;
					cNomSis,cNomEmp,nLinReg,nLenPrn)
		    NEXT
		 ENDIF
	       *ÀObservaci¢n General.

		 lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
				 'OBSERVACIONES: ',;
				 cNomSis,cNomEmp,nLinReg,nLenPrn)
		 FOR i := 1 TO 5
		     lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
				     '',;
				     cNomSis,cNomEmp,nLinReg,nLenPrn)
		 NEXT
	       *ÀL¡neas en Blanco
*--------------FIN IMPRESION DE LA OBSERVACION

	    ENDIF
**********FIN IMPRESION DE LA PROMOCION FINAL Y OBSERVACIONES

**********IMPRESION DE LA LINEA SEPARADORA
	    IF lSiPaso
	       @ PROW(),00  SAY NEGRA_OF+DOBGOL_OF+CONDEN_ON
	       lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			       REPL('=',LEN(cCabCol)),;
			       cNomSis,cNomEmp,nLinReg,nLenPrn)
	    ENDIF
**********FIN IMPRESION DE LA LINEA SEPARADORA

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    SKIP
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: DESCRIPCION DE LOS INDICADORES DE UNA MATERIA                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 12/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   SEP 12/2002 JUE

OBJETIVOS:

1- Prepara un vector con la descripci¢n de los indicadores de una
   materia espec¡fica

2- Retorna los c¢digos de los Indicadores

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomIndMat(cCodMat,aJuicio,lEvaInd,lPrnJui,aNomJui)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodMat                              // C¢digo de la Materia
       aJuicio                              // Juicios para el periodo
       aCampos                              // Nombres de los campos
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnJui                              // .T. Imprimir los Juicios
       aNomJui                              // @Nombre de los Juicios */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     j,x := 0                   // Contador

       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL cLogros := ''                  // Indicadores del Estudiante
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cCodRec := ''                  // C¢digo de la Recuperaci¢n
       LOCAL lEofCla := .T.                 // Final del Archivo

       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTju := ''               // C¢digo del Juicio
       LOCAL cNombreTju := ''               // Nombre del Juicio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       lEofCla := .F.
       IF CLA->(EOF())
	  lEofCla := .T.
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE LOS INDICADORES
       FOR j := 1 TO LEN(aJuicio)

**********SELECCION DEL INDICADOR
	    cCodLog := aJuicio[j]
	    cCodEva := SUBS(cCodLog,5,1)
	    cCodRec := SUBS(cCodLog,6,1)

	    IF lEofCla

*--------------TODOS LOS INDICADORES
		 IF lEvaInd

*===================REEVALUACION DEL INDICADOR
		      lLocCodigo('cCodigoCla','CLA',SUBS(cCodLog,1,1))
		      IF CLA->cReeEvaCla == '01'
			 IF !EMPTY(cCodRec)
			    cCodEva := cCodRec
			 ENDIF
		      ENDIF
*===================FIN REEVALUACION DEL INDICADOR

		    IF EVA->(EOF())
		       cLogros += cCodLog + SPACE(01)
		      *Todas las Evaluaciones
		    ELSE
		       IF cCodEva == EVA->cCodigoEva
			  cLogros += cCodLog + SPACE(01)
			 *Evaluaci¢n de Acuerdo a la Selecci¢n
		       ELSE
			  cCodLog := ''
		       ENDIF
		    ENDIF
		 ELSE
		    cLogros += cCodLog + SPACE(01)
		 ENDIF
*--------------FIN TODOS LOS INDICADORES

	    ELSE

*--------------INDICADORES DE ACUERDO A LA CLASE ESCOGIDA
		 IF SUBS(cCodLog,1,1) == CLA->cCodigoCla
		    IF lEvaInd
		       IF EVA->(EOF())
			  cLogros += cCodLog + SPACE(01)
			 *Todas las Evaluaciones
		       ELSE
			  IF cCodEva == EVA->cCodigoEva
			     cLogros += cCodLog + SPACE(01)
			    *Acuerdo a la Selecci¢n
			  ELSE
			     cCodLog := ''
			  ENDIF
		       ENDIF
		    ELSE
		      cLogros += cCodLog + SPACE(01)
		    ENDIF
		 ELSE
		    cCodLog := ''
		 ENDIF
*--------------FIN INDICADORES DE ACUERDO A LA CLASE ESCOGIDA

	    ENDIF
**********FIN SELECCION DEL INDICADOR

**********BUSQUEDA DEL JUICIO
	    IF !EMPTY(cCodLog) .AND. lPrnJui

	       cCodLog    := SUBS(cCodLog,1,4)
	       lLocCodigo('cCodigoCla','CLA',SUBS(cCodLog,1,1))

	       IF EMPTY(CLA->cCodigoMat)
		  cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		  cCodigoTma := cCodMat
	       ELSE
		  cCodigoTni := SPACE(02)
		  cCodigoTma := CLA->cCodigoMat
	       ENDIF

	       cCodigoTju := IF(TCO->lIndNivTbl,;
				cCodigoTni+cCodigoTma+cCodLog,;
				cCodigoTma+cCodLog)

	       cNombreTju := 'NO EXISTE EL CODIGO '+cCodLog
	       cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)

	       IF lSekCodigo(cCodigoTju,'JUI')
		  IF .NOT. lEvaInd
		     cNombreTju := aJuicio[j]+' '+JUI->cNombreJui
		  ELSE
		     cNombreTju := aJuicio[j]+' '+;
				   JUI->cNombreJui
		  ENDIF
		  AADD(aNomJui,cNombreTju)
		  FOR x := 1 TO TCO->nJuiExtTbl
		      cNombreTju := &('JUI->cExtra'+;
				      STR(x,1)+'Jui')
		      AADD(aNomJui,SPACE(07)+cNombreTju)
		  ENDFOR
	       ELSE
		  AADD(aNomJui,cNombreTju)
	       ENDIF
	    ENDIF
**********FIN BUSQUEDA DEL JUICIO

**********ANALISIS DE DECISION
	    IF lEofCla
	       CLA->(DBGOTO(CLA->(RECCOUNT())+1))
	      *Se Ubica al final del Archivo
	    ENDIF
**********FIN ANALISIS DE DECISION

	 ENDFOR
	 RETURN cLogros
*>>>>FIN IMPRESION DE LOS INDICADORES