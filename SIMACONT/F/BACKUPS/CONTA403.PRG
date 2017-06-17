/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR INDICADORES

**************************************************************************
* TITULO..: ESTADISTICAS DE RENDIMIENTO POR INDICADORES                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 11/2006 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   AGO 16/2006 JUE

OBJETIVOS:

1- Calcula las estad¡sticas por indicadores

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_403(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

       LOCAL nTotPer := 0                   // Total Periodos
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nPerIni := 0                   // Perido inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aStdMat := {}                  // Estadisticas de las Materias

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>CREACION DE LAS ESTADISTICAS
       IF lPregunta('DESEA ACTUALIZAR LOS DATOS DE LAS ESTADISTICA? No Si')
	  CreaStdInd(lShared,cNomSis,nFilPal,nFilInf,nColInf,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct)
       ENDIF
       CloseAll()
*>>>>FIN CREACION DE LAS ESTADISTICAS

*>>>>AREAS DE TRABAJO
       aArchvo := {}
       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})

       AADD(aArchvo,{cPatSis+'\'+FileStI,NIL,'STI'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FConTbl+cMaeAct+ExtFile,NIL,'TCO'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+FileMat,NIL,'MAT'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+FileCla,NIL,'CLA'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileJvf+ExtFile,NIL,'JVF'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileNiv+cAnoSis+ExtFile,NIL,'NIV'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileGru+cMaeAct+cAnoSis+ExtFile,NIL,'GRU'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileSuN,NIL,'SUN'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileSuG,NIL,'SUG'})

       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileJui+cMaeAct+cAnoSis+ExtFile,;
		     cPatSis+'\'+cMaeAct+'\'+;
		     fNtxJui+cMaeAct+cAnoSis+cExtNtx,'IND'})

       AADD(aArchvo,{cPatSis+'\'+;
		     FilePro+cAnoSis+ExtFile,NIL,'PRO'})
*>>>>FIN AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       lDelReg := .F.
       lInsReg := .F.
       lHaySql := .F.

       MantenStI(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
		 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
		 aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
		 lModReg,lDelReg,lInsReg,lHaySql)

       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: ESTADISTICA DE INDICADORES POR GRUPO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 16/2007 JUE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   AGO 16/2007 JUE

OBJETIVOS:

1- Totaliza el juicio valorativo de cada grupo

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION TotStdInd(cNomSis,nNroPer,cCodGru,aStdMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del Grupo
       aStdMat                              // @Estadistica de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,x := 0                   // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n

       LOCAL lMatVar := .F.                 // Materia variable
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del indicador
       LOCAL cSiIndi := ''                  // Indicadores aprobados
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados

       LOCAL nEstuSi := 0                   // Estudiantes indicador aprobado
       LOCAL nEstuNo := 0                   // Estudiantes indicador no aprobado
       LOCAL nEstNoR := 0                   // Estudiantes indicador recuperado
       LOCAL nNroEst := 0                   // N£mero de Estudiantes
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       lHayItv := lHayItvJvf()
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>IMPRESION DEL CUERPO DEL INFORME
       aStdMat := {}
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
	    nNroEst++
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********RECORRIDO POR AREAS
	    FOR i:=1 TO LEN(aNotAre)

*==============DETALLES DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*-------------------ANALISIS DE LA AREA NO IMPRIMIR
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)
		      IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
			 SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
			 LOOP
		      ENDIF
		      cCodigoTpr := &('PLA->cPr'+cCodGru+'Pla')
*-------------------FIN ANALISIS DE LA AREA NO IMPRIMIR

*-------------------NOTAS DEL AREA
		      cCamNotDef := aNotAre[i,4]
			 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			 cNotDef := cNotDef(cNotDef,lNotNum)
		     *ÀNota del Periodo

		      IF TCO->nTotPerTbl == nNroPer .AND.;
			 SUBS(cCodigoTma,3,2) # '00'

			 cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
			    cNotRec := SUBS(&cCamNotRec,1,4)

		      ELSE
			 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
			    cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
		      ENDIF
		    *ÀNota de Recuperaci¢n del Periodo
*-------------------FIN NOTAS DEL AREA

*-------------------ANALISIS DE LA NOTA DEL AREA
		      cNotDef := UPPER(ALLTRIM(cNotDef))
		      cCodLog := ''
		      nEstuSi := 0
		      nEstuNo := 0
		      nEstNoR := 0
		      IF lLocCodigo('cCodigoJvf','JVF',cNotDef)
			 IF JVF->lAproboJvf
			    nEstuSi := 1
			 ELSE
			    nEstuNo := 1
			    cNotRec := UPPER(ALLTRIM(cNotRec))
			    IF lLocCodigo('cCodigoJvf','JVF',cNotRec)
			       IF JVF->lAproboJvf
				  nEstNoR := 1
			       ENDIF
			    ENDIF
			 ENDIF
		      ENDIF
		      EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
				nEstuSI,nEstuNo,nEstNoR,@aStdMat)
*-------------------FIN ANALISIS DE LA NOTA DEL AREA

*-------------------INDICADORES DEL AREA
		      lMatVar := lLocMatVar(cCodigoTma)
		      IF !lMatVar
			 cCamInd := aNotAre[i,6]

			 cCamInd := STUFF(cCamInd,8,1,STR(nNroPer,1))
			 cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
		       *ÀIndicadores del Periodo

			 cSiIndi := ''
			 cSiRecu := ''
			 cNoRecu := ''
			 IF !aNotAre[i,15]   // Recuperable
			    IndRecSiNo(cJuicio,lEvaInd,;
				       @cSiRecu,@cNoRecu,.F.,;
				       @cSiIndi)
			 ENDIF
		       *ÀIndicadores recuperados y por recuperar
		      ENDIF
*-------------------FIN INDICADORES DEL AREA

*-------------------INDICADORES APROBADOS
		      IF !lMatVar
			 aJuicio := aJuicio(@cSiIndi,TCO->lNoSortTbl)
			 FOR x := 1 TO LEN(aJuicio)

			     cNotDef := ''
			     cCodLog := aJuicio[x]
			     nEstuSi := 1
			     nEstuNo := 0
			     nEstNoR := 0

			     EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
				       nEstuSI,nEstuNo,nEstNoR,@aStdMat)
			 ENDFOR
		      ENDIF
*-------------------FIN INDICADORES APROBADOS

*-------------------INDICADORES NO APROBADOS
		      IF !lMatVar
			 aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
			 FOR x := 1 TO LEN(aJuicio)

			     cNotDef := ''
			     cCodLog := aJuicio[x]
			     nEstuSi := 0
			     nEstuNo := 1
			     nEstNoR := 0

			     EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
				       nEstuSI,nEstuNo,nEstNoR,@aStdMat)

			 ENDFOR
		      ENDIF
*-------------------FIN INDICADORES NO APROBADOS

*-------------------INDICADORES RECUPERADOS
		      IF !lMatVar
			 aJuicio := aJuicio(@cSiRecu,TCO->lNoSortTbl)
			 FOR x := 1 TO LEN(aJuicio)

			     cNotDef := ''
			     cCodLog := aJuicio[x]
			     nEstuSi := 0
			     nEstuNo := 1
			     nEstNoR := 1

			     EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
				       nEstuSI,nEstuNo,nEstNoR,@aStdMat)
			 ENDFOR
		      ENDIF
*-------------------FIN INDICADORES RECUPERADOS

		 ENDIF
*==============FIN DETALLES DEL AREA

*==============RECORRIDO POR MATERIAS
		 FOR j := 1 TO LEN(aNotMat)

*-------------------DETALLES DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]

*::::::::::::::::::::::::ANALISIS DE LA MATERIA NO IMPRIMIR
			   cCodigoTma := SUBS(aNotMat[j,5],9,4)
			   IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
			      SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
			      LOOP
			   ENDIF
			   cCodigoTpr := &('PLA->cPr'+cCodGru+'Pla')
*::::::::::::::::::::::::FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*::::::::::::::::::::::::NOTAS DE LA MATERIA
			   cCamNotDef := aNotMat[j,4]
			      cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			      cNotDef := cNotDef(cNotDef,lNotNum)
			  *ÀNota del Periodo

			   IF TCO->nTotPerTbl == nNroPer .AND.;
			      SUBS(cCodigoTma,3,2) # '00'

			      cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
				 cNotRec := SUBS(&cCamNotRec,1,4)

			   ELSE
			      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
				 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			   ENDIF
			 *ÀNota de Recuperaci¢n del Periodo
*::::::::::::::::::::::::FIN NOTAS DE LA MATERIA

*::::::::::::::::::::::::ANALISIS DE LA NOTA DE LA MATERIA
			   cNotDef := UPPER(ALLTRIM(cNotDef))
			   cCodLog := ''
			   nEstuSi := 0
			   nEstuNo := 0
			   nEstNoR := 0
			   IF lLocCodigo('cCodigoJvf','JVF',cNotDef)
			      IF JVF->lAproboJvf
				 nEstuSi := 1
			      ELSE
				 nEstuNo := 1
				 cNotRec := UPPER(ALLTRIM(cNotRec))
				 IF lLocCodigo('cCodigoJvf','JVF',cNotRec)
				    IF JVF->lAproboJvf
				       nEstNoR := 1
				    ENDIF
				 ENDIF
			      ENDIF
			   ENDIF
			   EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
				     nEstuSI,nEstuNo,nEstNoR,@aStdMat)
*::::::::::::::::::::::::FIN ANALISIS DE LA NOTA DE LA MATERIA

*::::::::::::::::::::::::INDICADORES DE LA MATERIA
			   lMatVar := lLocMatVar(cCodigoTma)
			   IF !lMatVar
			      cCamInd := aNotMat[j,5]

			      cCamInd := STUFF(cCamInd,8,1,STR(nNroPer,1))
			      cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
			    *ÀIndicadores del Periodo

			      cSiIndi := ''
			      cSiRecu := ''
			      cNoRecu := ''
			      IF !aNotMat[j,15]  // No Recuperable
				 IndRecSiNo(cJuicio,lEvaInd,;
					    @cSiRecu,@cNoRecu,.F.,;
					    @cSiIndi)
			      ENDIF
			    *ÀIndicadores recuperados y por recuperar
			   ENDIF
*::::::::::::::::::::::::FIN INDICADORES DE LA MATERIA

*::::::::::::::::::::::::INDICADORES APROBADOS
			   IF !lMatVar
			      aJuicio := aJuicio(@cSiIndi,TCO->lNoSortTbl)
			      FOR x := 1 TO LEN(aJuicio)

				  cCodLog := aJuicio[x]
				  cNotDef := SUBS(cCodLog,5,1)

				  nEstuSi := 1
				  nEstuNo := 0
				  nEstNoR := 0

				  EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
					    nEstuSI,nEstuNo,nEstNoR,@aStdMat)
			      ENDFOR
			   ENDIF
*::::::::::::::::::::::::FIN INDICADORES APROBADOS

*::::::::::::::::::::::::INDICADORES NO APROBADOS
			   IF !lMatVar
			      aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
			      FOR x := 1 TO LEN(aJuicio)

				  cCodLog := aJuicio[x]
				  cNotDef := SUBS(cCodLog,5,1)

				  nEstuSi := 0
				  nEstuNo := 1
				  nEstNoR := 0

				  EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
					    nEstuSI,nEstuNo,nEstNoR,@aStdMat)
			      ENDFOR
			   ENDIF
*::::::::::::::::::::::::FIN INDICADORES NO APROBADOS

*::::::::::::::::::::::::INDICADORES RECUPERADOS
			   IF !lMatVar
			      aJuicio := aJuicio(@cSiRecu,TCO->lNoSortTbl)
			      FOR x := 1 TO LEN(aJuicio)

				  cNotDef := ''
				  cCodLog := aJuicio[x]
				  nEstuSi := 0
				  nEstuNo := 1
				  nEstNoR := 1

				  EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
					    nEstuSI,nEstuNo,nEstNoR,@aStdMat)
			      ENDFOR
			   ENDIF
*::::::::::::::::::::::::FIN INDICADORES RECUPERADOS

		      ENDIF
*-------------------FIN DETALLES DE LA MATERIA

		 ENDFOR
*==============FIN RECORRIDO POR MATERIAS

	    ENDFOR
**********FIN RECORRIDO POR AREAS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>NUMERO DE ESTUDIANTES
       FOR i := 1 TO LEN(aStdMat)
	   aStdMat[i,8] := nNroEst
       ENDFOR
       RETURN NIL
*>>>>FIN NUMERO DE ESTUDIANTES

/*************************************************************************
* TITULO..: TOTAL DE JUICIOS VALORATIVOS MATERIAS VARIABLES              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 23/2007 JUE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   AGO 23/2007 JUE

OBJETIVOS:

1- Estadistica de las materias variables

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IndMatVar(lShared,cNomSis,cAnoUsr,cPatSis,;
		   cMaeAct,nNroPer,cCodGru,aStdMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del Grupo
       aStdMat                              // @Estadistica de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL   i,j,x := 0                   // Contadores
       LOCAL aCodMat := {}                  // C¢digo de Materias
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiIndi := ''                  // Indicadores aprobados
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cCodLog := ''                  // C¢digo del indicador
       LOCAL nEstuSi := 0                   // Estudiantes indicador aprobado
       LOCAL nEstuNo := 0                   // Estudiantes indicador no aprobado
       LOCAL nEstNoR := 0                   // Estudiantes indicador recuperado
       LOCAL nNroEst := 0                   // N£mero de Estudiantes

       LOCAL PathNot := ''                  // Path de Notas
       LOCAL aStrNot := {}                  // Vector con la estructura
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR SUBGRUPOS
       aCodMat := {}
       SUG->(DBGOTOP())
       DO WHILE .NOT. SUG->(EOF())

**********ANALISIS DE LA MATERIA NO IMPRIMIR
	    lMatVarMat(SUG->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
	    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
	       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'

	       SUG->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE LA MATERIA NO IMPRIMIR

**********INICIALIZACION DE LA MATERIA
	    IF SUG->cCodigoGru == cCodGru

	       cCodigoTpr := SUG->cCodigoPro
	       AADD(aCodMat,{SUG->cCodigoMat,cCodigoTpr})

	    ENDIF
**********FIN INICIALIZACION DE LA MATERIA

	 SUG->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR SUBGRUPOS

*>>>>RECORRIDO POR SUBNIVELES
       SUN->(DBGOTOP())
       DO WHILE .NOT. SUN->(EOF())

**********ANALISIS DE LA MATERIA NO IMPRIMIR
	    lMatVarMat(SUN->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
	    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
	       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'

	       SUN->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE LA MATERIA NO IMPRIMIR

**********INICIALIZACION DE LA MATERIA
	    IF SUN->cCodigoNiv == SUBS(cCodGru,1,2)

	       IF SUN->lPorNivSuN
		  cCodigoTpr := SUN->cCodigoPro
	       ELSE
		  cCodigoTpr := MAT->cCodigoPro
	       ENDIF
	       AADD(aCodMat,{SUN->cCodigoMat,cCodigoTpr})

	    ENDIF
**********FIN INICIALIZACION DE LA MATERIA

	 SUN->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR SUBNIVELES

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       lHayItv := lHayItvJvf()
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>RECORRIDO POR MATERIAS VARIABLES
       FOR i := 1 TO LEN(aCodMat)

	   cCodigoTma := aCodMat[i,1]
	   cCodigoTpr := aCodMat[i,2]

***********FILTRACION DEL ARCHIVO
	     SELECT SEL
	     SET FILTER TO SEL->cCodigoPro == cCodigoTpr .AND.;
			   SEL->cCodAreSel == SUBS(cCodigoTma,1,2) .AND.;
			   SUBS(SEL->cSecMatSel,nNroPer*2-1,2) == SUBS(cCodigoTma,3,2)

	     SEL->(DBGOTOP())
	     IF SEL->(EOF())
		SET FILTER TO
		RETURN NIL
	     ENDIF
***********FIN FILTRACION DEL ARCHIVO

***********RECORRIDO POR ESTUDIANTES SELECTIVOS
	     nNroEst := 0
	     SEL->(DBGOTOP())
	     DO WHILE .NOT. SEL->(EOF())

*===============BUSQUEDA DEL ESTUDIANTE
		  IF lSekCodigo(SEL->cCodigoEst,cMaeAct) .AND.;
		     &cMaeAct->cCodigoGru # cCodGru

		     SEL->(DBSKIP())
		     LOOP

		  ENDIF
*===============FIN BUSQUEDA DEL ESTUDIANTE

*===============IMPRESION DE LA LINEA DE ESTADO
		  LineaEstado('ºPERIODO: '+STR(nNroPer,2)+'º'+;
			      'ºCODIGO: '+&cMaeAct->cCodigoEst+;
			      'ºGRUPO: '+&cMaeAct->cCodigoGru+;
			      'ºMATERIA: '+cCodigoTma+;
			      'º No. '+ALLTRIM(STR(i,4))+'/'+;
				       ALLTRIM(STR(LEN(aCodMat),4)),cNomSis)
*===============FIN IMPRESION DE LA LINEA DE ESTADO

*==============INICIALIZACION DEL PATH DE NOTAS
		 PathNot := cPatSis+'\'+cMaeAct+'\NOTAS\'
		 FileNot := 'NT'+cCodGru+cAnoSis+ExtFile
*==============FIN INICIALIZACION DEL PATH DE NOTAS

*==============SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,PathNot+'\'+FileNot,'NOT',NIL,lShared)
		    cError('ABRIENDO EL ARCHIVO DE NOTAS DE '+cCodGru)
		    SEL->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN SELECION DE LAS AREAS DE TRABAJO

*==============LOCALIZACION DEL ESTUDIANTE
		 IF !lLocCodigo('cCodigoEst','NOT',&cMaeAct->cCodigoEst,.T.)
		    SEL->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN LOCALIZACION DEL ESTUDIANTE

*==============DETALLES DE LAS AREAS Y MATERIAS
		 aNotAre := {}
		 aNotMat := {}
		 DetAreas(@aNotAre,@aNotMat,nNroPer)
*==============FIN DETALLES DE LAS AREAS Y MATERIAS

*==============LOCALIZACION DE LA MATERIA VARIABLE
		 lMatVarMat(cCodigoTma,.F.)
		 FOR j := 1 TO LEN(aNotMat)
		     IF SUBS(aNotMat[j,4],9,4) == MAT->cCodigoMat
			EXIT
		     ENDIF
		 ENDFOR
*==============FIN LOCALIZACION DE LA MATERIA VARIABLE

*==============NOTAS DE LA MATERIA
		 cCamNotDef := aNotMat[j,4]
		    cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		    cNotDef := cNotDef(cNotDef,lNotNum)
		*ÀNota del Periodo

		 IF TCO->nTotPerTbl == nNroPer .AND.;
		    SUBS(cCodigoTma,3,2) # '00'

		    cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
		       cNotRec := SUBS(&cCamNotRec,1,4)

		 ELSE
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
		       cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
		 ENDIF
	       *ÀNota de Recuperaci¢n del Periodo
*==============FIN NOTAS DE LA MATERIA

*==============ANALISIS DE LA NOTA DE LA MATERIA
		 cNotDef := UPPER(ALLTRIM(cNotDef))
		 cCodLog := ''
		 nEstuSi := 0
		 nEstuNo := 0
		 nEstNoR := 0
		 IF lLocCodigo('cCodigoJvf','JVF',cNotDef)
		    IF JVF->lAproboJvf
		       nEstuSi := 1
		    ELSE
		       nEstuNo := 1
		       cNotRec := UPPER(ALLTRIM(cNotRec))
		       IF lLocCodigo('cCodigoJvf','JVF',cNotRec)
			  IF JVF->lAproboJvf
			     nEstNoR := 1
			  ENDIF
		       ENDIF
		    ENDIF
		 ENDIF
		 EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
			   nEstuSI,nEstuNo,nEstNoR,@aStdMat)
*==============FIN ANALISIS DE LA NOTA DE LA MATERIA

*==============INDICADORES DE LA MATERIA
		 cCamInd := aNotMat[j,5]

		 cCamInd := STUFF(cCamInd,8,1,STR(nNroPer,1))
		 cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
	       *ÀIndicadores del Periodo

		 cSiIndi := ''
		 cSiRecu := ''
		 cNoRecu := ''
		 IF !aNotMat[j,15]  // No Recuperable
		    IndRecSiNo(cJuicio,lEvaInd,;
			       @cSiRecu,@cNoRecu,.F.,;
			       @cSiIndi)
		 ENDIF
	       *ÀIndicadores recuperados y por recuperar
*==============FIN INDICADORES DE LA MATERIA

*==============INDICADORES APROBADOS
		 aJuicio := aJuicio(@cSiIndi,TCO->lNoSortTbl)
		 FOR x := 1 TO LEN(aJuicio)

		     cNotDef := ''
		     cCodLog := aJuicio[x]
		     nEstuSi := 1
		     nEstuNo := 0
		     nEstNoR := 0

		     EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
			       nEstuSI,nEstuNo,nEstNoR,@aStdMat)
		 ENDFOR
*==============FIN INDICADORES APROBADOS

*==============INDICADORES NO APROBADOS
		 aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)
		 FOR x := 1 TO LEN(aJuicio)

		     cNotDef := ''
		     cCodLog := aJuicio[x]
		     nEstuSi := 0
		     nEstuNo := 1
		     nEstNoR := 0

		     EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
			       nEstuSI,nEstuNo,nEstNoR,@aStdMat)
		 ENDFOR
*==============FIN INDICADORES NO APROBADOS

*==============INDICADORES RECUPERADOS
		 aJuicio := aJuicio(@cSiRecu,TCO->lNoSortTbl)
		 FOR x := 1 TO LEN(aJuicio)

		     cNotDef := ''
		     cCodLog := aJuicio[x]
		     nEstuSi := 0
		     nEstuNo := 1
		     nEstNoR := 1

		     EstadiStI(cCodigoTma,cCodigoTpr,cNotDef,cCodLog,;
			       nEstuSI,nEstuNo,nEstNoR,@aStdMat)
		 ENDFOR
*==============FIN INDICADORES RECUPERADOS

	       nNroEst++
	       SEL->(DBSKIP())

	     ENDDO
***********FIN RECORRIDO POR ESTUDIANTES SELECTIVOS

***********NUMERO DE ESTUDIANTES
	     FOR x := 1 TO LEN(aStdMat)

		 IF aStdMat[x,1] == cCodigoTma .AND.;
		    aStdMat[x,7] == cCodigoTpr

		    aStdMat[x,8] := nNroEst
		 ENDIF

	     ENDFOR
***********FIN NUMERO DE ESTUDIANTES

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR MATERIAS VARIABLES

/*************************************************************************
* TITULO..: SUMA DE ESTADISTICAS DE LOS INDICADORES                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2007 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   AGO 22/2007 MIE

OBJETIVOS:

1- Suma las estadisticas de los indicadores

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstadiStI(cCodMat,cCodPro,cNotDef,cCodLog,;
		   nEstuSI,nEstuNo,nEstNoR,aEstadi)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodMat                              // C¢digo de la materia
       cCodPro                              // C¢digo del Profesor
       cNotDef                              // Nota definitiva
       cCodLog                              // C¢digo del indicador
       nEstuSi                              // Estudiantes indicador aprobado
       nEstuNo                              // Estudiantes indicador no aprobado
       nEstNoR                              // Estudiantes indicador recuperado
       aEstadi                              // @Estadistica  */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL      k := 0                         // Contador
*>>>>DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL INDICADOR
       cNotDef := UPPER(ALLTRIM(cNotDef))
       IF EMPTY(aEstadi)

	  AADD(aEstadi,{cCodMat,;           // 1. cCodMat
			cNotDef,;           // 2. Nota Definitiva
			SUBS(cCodLog,1,4),; // 3. cCodLog
			0,;                 // 4. nEstuSi
			0,;                 // 5. nEstuNo
			0,;                 // 6. nEstNoR
			cCodPro,;           // 7. cCodPro
			0})                 // 8. N£mero de Estudiantes

	  k := LEN(aEstadi)

       ELSE

/*
	  DO CASE
	  CASE !EMPTY(cNotDef)
	       k := ASCAN(aEstadi,{|aArr|aArr[1] == cCodMat .AND.;
					 aArr[7] == cCodPro .AND.;
					 aArr[2] == cNotDef})
	  CASE !EMPTY(cCodLog)
	       k := ASCAN(aEstadi,{|aArr|aArr[1] == cCodMat .AND.;
					 aArr[7] == cCodPro .AND.;
					 aArr[3] == SUBS(cCodLog,1,4)})
	  OTHERWISE
	       k := -1
	  ENDCASE
*/

	  k := ASCAN(aEstadi,{|aArr|aArr[1] == cCodMat .AND.;
				    aArr[7] == cCodPro .AND.;
				    aArr[2] == cNotDef .AND.;
				    aArr[3] == SUBS(cCodLog,1,4)})

	  IF k == 0

	     AADD(aEstadi,{cCodMat,;           // 1. cCodMat
			   cNotDef,;           // 2. Nota Definitiva
			   SUBS(cCodLog,1,4),; // 3. cCodLog
			   0,;                 // 4. nEstuSi
			   0,;                 // 5. nEstuNo
			   0,;                 // 6. nEstNoR
			   cCodPro,;           // 7. cCodPro
			   0})                 // 8. N£mero de Estudiantes

	     k := LEN(aEstadi)

	  ENDIF

       ENDIF
*>>>>FIN LOCALIZACION DEL INDICADOR

*>>>>CONTEO DE LOS INDICADORES
       IF k > 0
	  aEstadi[k,4] += nEstuSi
	  aEstadi[k,5] += nEstuNo
	  aEstadi[k,6] += nEstNoR
       ENDIF
       RETURN NIL
*>>>>FIN CONTEO DE LOS INDICADORES

/*************************************************************************
* TITULO..: CREACION DE ESTADISTICAS DE RENDIMIENTO POR INDICADORES      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2007 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   SEP 26/2007 MIE

OBJETIVOS:

1- Crea las estad¡sticas de rendimiento de los indicadores

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaStdInd(lShared,cNomSis,nFilPal,nFilInf,nColInf,;
		    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       nFilPal                              // Fila Inferior Men£ principal
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomUsr                              // Nombre del Usuario
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSec := ''                  // Nombre Secundario

       LOCAL     i,j := 0                   // Contador

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

       LOCAL nTotPer := 0                   // Total Periodos
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nPerIni := 0                   // Perido inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aStdMat := {}                  // Estadisticas de las Materias

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LAS ESTRUCTURAS
       CreaDbfStI(lShared,nModCry,cPatSis,FileStI)
       CloseAll()
*>>>>FIN CREACION DE LAS ESTRUCTURAS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileStI,'STI',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuN,'SUN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuG,'SUG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSel+cMaeAct+ExtFile,'SEL',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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
       lPrnArc := CON->lPrnArcCon
       nCodPrn := CON->nCodigoPrn
       cOpcPrn := CON->cOpcPrnCon
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL PERIODO
       nTotPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,;
			     TCO->nTotPerTbl)
       IF nTotPer == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       IF lPregunta('DESEA PROCESAR SOLO EL PERIODO No.'+;
		    STR(nTotPer,1)+'? Si No')
	  nPerIni := nTotPer
       ELSE
	  nPerIni := 1
       ENDIF
*>>>>FIN LECTURA DEL PERIODO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR GRUPOS
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

**********RECORRIDO POR PERIODOS
	    FOR nNroPer := nPerIni TO nTotPer

*===============ESTADISTICA DEL GRUPO
		  aStdMat := {}

		  TotStdInd(cNomSis,nNroPer,GRU->cCodigoGru,@aStdMat)

		  IndMatVar(lShared,cNomSis,cAnoUsr,cPatSis,;
			    cMaeAct,nNroPer,GRU->cCodigoGru,;
			    @aStdMat)
*===============FIN ESTADISTICA DEL GRUPO

*===============GRABACION DE LAS ESTADISTICAS
		  FOR i := 1 TO LEN(aStdMat)

*--------------------IMPRESION DE LA LINEA DE ESTADO
		       LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
				   'GRUPO: '+GRU->cCodigoGru+'º'+;
				   'INDICADORES.'+;
				    STR(i,4)+'/'+;
				    STR(LEN(aStdMat),4),cNomSis)
*--------------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------------GRABACION DEL REGISTRO
		       SELECT STI
		       IF STI->(lRegLock(lShared,.T.))

			  REPL STI->cCodigoGru WITH GRU->cCodigoGru
			  REPL STI->cCodigoMat WITH aStdMat[i,1]
			  REPL STI->nNroPerStI WITH nNroPer

			  REPL STI->cNotDefStI WITH IF(EMPTY(aStdMat[i,2]),'',;
						       aStdMat[i,2])
			  REPL STI->cCodIndStI WITH aStdMat[i,3]
			  REPL STI->nEstuSiStI WITH aStdMat[i,4]
			  REPL STI->nEstuNoStI WITH aStdMat[i,5]
			  REPL STI->nEstNoRStI WITH aStdMat[i,6]
			  REPL STI->cCodigoPro WITH aStdMat[i,7]
			  REPL STI->nTotEstStI WITH aStdMat[i,8]

			  REPL STI->nIdeCodSTI WITH STI->(RECNO())
			  REPL STI->cNomUsrSTI WITH cNomUsr
			  REPL STI->dFecUsrSTI WITH DATE()
			  REPL STI->cHorUsrSTI WITH TIME()

			  STI->(DBCOMMIT())
		       ELSE
			  cError('NO SE GRABA EL REGISTRO')
		       ENDIF

		       IF lShared
			  STI->(DBUNLOCK())
		       ENDIF
*--------------------FIN GRABACION DEL REGISTRO


		  ENDFOR
*===============FIN GRABACION DE LAS ESTADISTICAS

	    ENDFOR
**********FIN RECORRIDO POR PERIODOS

**********AVANCE AL SIGUIENTE REGISTRO
	    CloseDbf('NOT')
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       lModReg := CON->lPruebaCon

       CloseAll(aUseDbf)
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,cPatSis+'\'+FileStI,;
		    'cCodigoMat','cCodIndStI','cCodigoPro')
	  cError('NO SE ORDENO EL ARCHIVO')
       ENDIF
       RETURN NIL
*>>>>FIN ORDENACION DEL ARCHIVO