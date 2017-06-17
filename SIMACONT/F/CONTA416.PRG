/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR ESTUDIANTE - POR AREAS

**************************************************************************
* TITULO..: ESTADISTICAS POR AREAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 14/2008 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 PM   JUL 14/2008 MAR

OBJETIVOS:

1- Imprime las estad¡sticas por estudiante por  reas.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_416(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores
       LOCAL cSavPan := ''                  // Salvar Pantalla


       LOCAL       i := 0                   // Contador
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lPorcen := .F.                 // .T. Imprimir Porcentajes
       LOCAL lOrdena := .F.                 // .T. Ordenar el informe

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOE'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
     *ÀVariables del Log
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       CloseAll()
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
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
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
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
	  SET PRINTER TO &(PathPrn+'\'+cGruIni+cGruFin+'.401')
       ENDIF
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPorcen := lPregunta('DESEA IMPRIMIR LOS TOTALES COMO PORCENTAJES? No Si')
       lOrdena := lPregunta('DESEA ORDENAR EL INFORME? Si No')
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  IF nRegIni == nRegFin
	     FilePrn := STR(nNroPer,1)+'stA'+GRU->cCodigoGru
	  ELSE
	     FilePrn := STR(nNroPer,1)+'stA'+cMaeAct
	  ENDIF
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.,2)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","ProporOf","CondenOn"})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathLog+'\',;
			     'LOE'+STR(nNroPer,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LAS ESTADISTICAS
	    aTotErr := {}
	    EstaEstAre(lShared,cNomEmp,cNomSis,cAnoUsr,cNomUsr,nNroPer,;
		       cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,lPorcen,;
		       lOrdena,FilePrn,nOpcPrn,@nHanXml,@aTotErr)
**********FIN IMPRESION DEL RESUMEN

**********REGISTRO DEL LOG
	    FOR i := 1 TO LEN(aTotErr)

		LineaEstado('GRUPO: '+GRU->cCodigoGru+;
			    'º'+STR(i,2)+'/'+;
			     STR(LEN(aTotErr),2),cNomSis)

		aHayErr := aTotErr[i]

		AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		AADD(aCamLog,{'cMatNotLog',xPrm(aHayErr,'cCodMat')})
		AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
	      *ÀCampos del Log

		aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	    ENDFOR
**********FIN REGISTRO DEL LOG

**********AVANCE AL SIGUIENTE REGISTRO
	    nNroIni := 1
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN

       VerPrn(nOpcPrn,FilePrn,nHanXml)

       SELECT &cAliasL
       BROWSE()

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: CUADRO DE RESUMEN DE LOGROS DE LOS ESTUDIANTES               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 23/2002 MAR A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUL 23/2002 MAR

OBJETIVOS:

1- Imprime las Estadisticas por Estudiante

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstaEstAre(lShared,cNomEmp,cNomSis,cAnoUsr,cNomUsr,nNroPer,;
		    cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,lPorcen,;
		    lOrdena,FilePrn,nOpcPrn,nHanXml,aTotErr)


*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroPer				    // N£mero del bimestre
       cMaeAct                              // Maestro Actual
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cNotDef                              // Nota Definitiva de Selecci¢n
       cJorTxt                              // Jornada escogida
       cGruFin                              // Grupo Final
       lPorcen                              // .T. Imprimir Porcentajes
       lOrdena                              // .T. Ordenar el informe
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n
       nHanXml                              // Manejador del Archivo
       aTotErr                              // @Registros con errores */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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
       LOCAL aTitReg := {}                  // Registros para los T¡tulos
     *ÀVariables de informe

       LOCAL i,j,k,y,x := 0                 // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL aStdJui := {}                  // Estadisticas de Juicios Valorativos
       LOCAL aStdMat := {}                  // Estadisticas de las Materias
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos
       LOCAL nNroLen := 0                   // N£mero de longitud
       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
       LOCAL cNotAre := ''                  // Nota del Area
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL lJvfCalTma := .F.              // .F. Calcula el Juicio Valorativo .T. No Calcula el Juicio Valorativo
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   IF(TCO->nTotPerTbl==nNroPer,'',;
			   'PERIODO No.'+STR(nNroPer,2)),;
		   'ESTADISTICAS DE AREAS POR ESTUDIANTES'+;
		   IF(TCO->nTotPerTbl==nNroPer,' FINAL',''),;
		   'GRUPO: '+GRU->cCodigoGru}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,NIL,lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}
       aStdJui := {}

       AADD(aNroCol,4)
       AADD(aTitPrn,'No.')
       AADD(aStdJui,'')

       AADD(aNroCol,30)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')
       AADD(aStdJui,'')

       FOR i := 1 TO LEN(aNotAre)

**********ANALISIS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	       AADD(aNroCol,4)
	       AADD(aTitPrn,SUBS(aNotAre[i,7],1,4))
	       AADD(aStdJui,0)
	    ENDIF
**********FIN ANALISIS DEL AREA

**********ANALISIS DE LA MATERIA
	    FOR j := 1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*=================ANALISIS DE LA MATERIA NO IMPRIMIR
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    IF SUBS(cCodigoTma,3,2) # '00'
		       LOOP
		    ENDIF
*=================FIN ANALISIS DE LA MATERIA NO IMPRIMIR

		  AADD(aNroCol,4)
		  AADD(aTitPrn,SUBS(aNotMat[j,7],1,4))
		  AADD(aStdJui,0)

	       ENDIF
	    ENDFOR
**********FIN ANALISIS DE LA MATERIA

       ENDFOR

       AADD(aNroCol,04)
       AADD(aTitPrn,'TDIF')

       IF TCO->nTotPerTbl == nNroPer
	  AADD(aNroCol,04)
	  AADD(aTitPrn,'APR.')
       ENDIF
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)

       cCabCol := cRegPrint(aTitPrn,@aNroCol)
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
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       lHayItv := lHayItvJvf()
       lNotNum := IF(lNotNum,lNotNum,lHayItv)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LECTURA DE LOS JUICIOS VALORATIVOS
       aStdMat := {}

       SELECT JVF
       JVF->(DBGOTOP())
       DO WHILE .NOT. JVF->(EOF())
	  aStdJui[1] := JVF->cCodigoJvf
	  aStdJui[2] := JVF->cNombreJvf
	  AADD(aStdMat,ACLONE(aStdJui))
	  JVF->(DBSKIP())
       ENDDO
       aStdJui[1] := ''
       aStdJui[2] := 'SIN JUICIO'
       aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
       AADD(aStdMat,ACLONE(aStdJui))

       aStdJui[1] := '?'
       aStdJui[2] := 'OTRO'
       aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
       AADD(aStdMat,ACLONE(aStdJui))
*>>>>FIN LECTURA DE LOS JUICIOS VALORATIVOS

*>>>>IMPRESION DEL CUERPO DEL INFORME
       cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)

       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroPer,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
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
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DEL REGISTRO
	    y := 0
	    nTotDif := 0
	    aTitReg := {}
	    AADD(aTitReg,STR(NOT->(RECNO()),2)+IF(lRetiroTes,' R',''))
	    AADD(aTitReg,cNombreTes)

	    FOR i := 1 TO LEN(aNotAre)

*--------------ESTADISTICA DE LOS INDICADORES DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*...................NOTA DEFINITIVA DEL AREA
		      cCamNotDef := aNotAre[i,4]
			 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			 cNotDef := cNotDef(cNotDef,lNotNum)
*...................FIN NOTA DEFINITIVA DEL AREA

*...................CALCULO DEL JVF
		      lJvfCalTma := !aNotAre[i,19]
		      IF lJvfCalTma

			 cCodigoTma := aNotAre[i,2]+'00'
			 DO CASE
			 CASE cJvfCal == '102'  // Indice de Cumplimiento

			      cNotAre := cJvfAre102(&cMaeAct->cCodigoGru,;
						    aNotAre,aNotMat,;
						    nNroPer,;
						    nNroPer,;
						    cCodigoTma,@aTotErr)

			      cNotDef := ALLTRIM(cNotAre)+SPACE(03)

			 CASE cJvfCal == '103'  // Indice de Cumplimiento. Variable

			      cNotAre := cJvfAre103(&cMaeAct->cCodigoGru,;
						    aNotAre,aNotMat,;
						    nNroPer,;
						    nNroPer,;
						    cCodigoTma,@aTotErr)

			      cNotDef := ALLTRIM(cNotAre)+SPACE(03)

			 ENDCASE

		      ENDIF
*...................FIN CALCULO DEL JVF

*...................ANALISIS DE DECISION
		       IF cAproboJvf(ALLTRIM(cNotDef)) == 'N'
			  nTotDif++
		       ENDIF
*...................FIN ANALISIS DE DECISION

*...................CAMPOS DEL REGISTRO DE IMPRESION
		      cTxtPrn := ALLTRIM(cNotDef)+LOWER(ALLTRIM(cNotRec))
		      IF !EMPTY(nNroDif)
			 cTxtPrn := cTxtPrn+STR(nNroDif,2)
		      ENDIF
		      AADD(aNroCol,4)
		      AADD(aTitReg,cTxtPrn)
*...................FIN CAMPOS DEL REGISTRO DE IMPRESION

		 ENDIF
*--------------FIN ESTADISTICA DE LOS INDICADORES DEL AREA

*--------------ESTADISTICA DE LOS JUICIOS VALORATIVOS DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		    y++
		    IF !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF
		    k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
		    IF k # 0
		       aStdMat[k,y+2]++
		    ELSE
		       aStdMat[LEN(aStdMat),y+2]++
		    ENDIF
		 ENDIF
*--------------FIN ESTADISTICA DE LOS JUICIOS VALORATIVOS DEL AREA

*==============RECORRIDO AREAS PROMEDIABLES
		 FOR j := 1 TO LEN(aNotMat)

*-------------------ESTADISTICA DE LOS INDICADORES DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

*........................ANALISIS DE LA MATERIA
			    lJvfCalTma := !aNotMat[j,19]

			    cCodigoTma := SUBS(aNotMat[j,5],9,4)
			    IF SUBS(cCodigoTma,3,2) # '00'
			       LOOP  // Descarta la materia
			    ENDIF
*........................FIN ANALISIS DE LA MATERIA

*........................NOTA DEFINITIVA DE LA MATERIA
			   cCamNotDef := aNotMat[j,4]
			      cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			      cNotDef := cNotDef(cNotDef,lNotNum)
*........................FIN NOTA DEFINITIVA DE LA MATERIA

*........................CALCULO DEL JVF
			   IF lJvfCalTma

			      DO CASE
			      CASE cJvfCal == '102'  // Indice de Cumplimiento
				   cNotAre := cJvfAre102(&cMaeAct->cCodigoGru,;
							 aNotAre,aNotMat,;
							 nNroPer,;
							 nNroPer,;
							 cCodigoTma,@aTotErr)

				   cNotDef := ALLTRIM(cNotAre)+SPACE(03)

			      CASE cJvfCal == '103'  // Indice de Cumplimiento. Variable

				   cNotAre := cJvfAre103(&cMaeAct->cCodigoGru,;
							 aNotAre,aNotMat,;
							 nNroPer,;
							 nNroPer,;
							 cCodigoTma,@aTotErr)

				   cNotDef := ALLTRIM(cNotAre)+SPACE(03)

			      ENDCASE

			   ENDIF
*........................FIN CALCULO DEL JVF

*........................ANALISIS DE DECISION
			   IF cAproboJvf(ALLTRIM(cNotDef)) == 'N'
			      nTotDif++
			   ENDIF
*........................FIN ANALISIS DE DECISION

*........................CAMPOS DEL REGISTRO DE IMPRESION
			   cTxtPrn := ALLTRIM(cNotDef)+;
				      LOWER(ALLTRIM(cNotRec))
			   IF !EMPTY(nNroDif)
			      cTxtPrn := cTxtPrn+STR(nNroDif,2)
			   ENDIF

			   AADD(aNroCol,4)
			   AADD(aTitReg,cTxtPrn)
*........................FIN CAMPOS DEL REGISTRO DE IMPRESION

		      ENDIF
*-------------------FIN ESTADISTICA DE LOS INDICADORES DE LA MATERIA

*-------------------ESTADISISTICA DE LOS JUICIOS VALORATIVOS DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

			 y++
			 IF !EMPTY(cNotRec)
			    cNotDef := cNotRec
			 ENDIF
			 k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
			 IF k # 0
			    aStdMat[k,y+2]++
			 ELSE
			    aStdMat[LEN(aStdMat),y+2]++
			 ENDIF
		      ENDIF
*-------------------FIN ESTADISISTICA DE LOS JUICIOS VALORATIVOS DE LA MATERIA

		 ENDFOR
*==============FIN RECORRIDO AREAS PROMEDIABLES

	    ENDFOR

	    AADD(aTitReg,STR(nTotDif,4))

	    IF TCO->nTotPerTbl == nNroPer
	       AADD(aTitReg,STR(NOT->nAproboNot,2))
	    ENDIF
**********IMPRESION DEL REGISTRO

	   AADD(aRegPrn,aTitReg)

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DEL INFORME ORDENADO
       nNroLen := LEN(aRegPrn[1])
       IF lOrdena
	  aRegPrn := ASORT(aRegPrn,,,{|x,y|x[nNroLen] < y[nNroLen]})
       ENDIF

       FOR i := 1 TO LEN(aRegPrn)
	   aTitReg := {}
	   FOR j := 1 TO LEN(aRegPrn[i])
	       AADD(aTitReg,aRegPrn[i,j])
	   ENDFOR

	   cTxtPrn := cRegPrint(aTitReg,aNroCol)

	   SET DEVICE TO PRINT
	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aTitReg,aNroCol,bPagina,bDerAut,;
		   bCabeza)
	   SET DEVICE TO SCREEN

       ENDFOR
*>>>>FIN IMPRESION DEL INFORME ORDENADO

*>>>>IMPRESION DE LAS ESTADISTICAS TOTALES
       aTitPrn[1] := 'JUI'
       aTitPrn[2] := 'JUICIOS VALORATIVOS'
       cTxtPrn := cRegPrint(aTitPrn,aNroCol)

       SET DEVICE TO PRINT
       lPrnReg(02,00,cTxtPrn,bPagina,bDerAut,bCabeza)
       SET DEVICE TO SCREEN

       FOR k := 1 TO LEN(aStdMat)
	   aStdJui := ACLONE(aStdMat[k])
	   FOR y := 3 TO LEN(aStdJui)
	       NOT->(RECCOUNT())
	       IF lPorcen
		  aStdJui[y] := STR((aStdJui[y]*100)/NOT->(RECCOUNT()),3)+'%'
	       ELSE
		  aStdJui[y] := STR(aStdJui[y],4)
	       ENDIF
	   ENDFOR
	   cTxtPrn := cRegPrint(aStdJui,aNroCol)

	   SET DEVICE TO PRINT
	   lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	   SET DEVICE TO SCREEN

       ENDFOR
       CloseDbf('NOT')
*>>>>FIN IMPRESION DE LAS ESTADISTICAS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

