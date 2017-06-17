/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: CALCULOS - POR ESTUDIANTE

**************************************************************************
* TITULO..: CALCULOS                                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP XX/XXXX LUN A
       Bucaramanga, Colombia	    INICIO: XX:XX AM   SEP XX/XXXX LUN

OBJETIVOS:

1- Realiza los calculos de acuerdo el n£mero del m‚todo especificado

2- El c lculo por estudiante afecta los c lculos relacionados con el
   grupo en lo referente a promedios, puestos etc. Tener presente esta
   situaci¢n para resolverla

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_252(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores

       LOCAL       i := 0                   // Contador
       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL lNotFin := .F.                 // .T. Calcular la nota de fin de a¤o.

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat+ExtFile,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSin+cMaeAct+cAnoSis+ExtFile,'SIN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE TCO->nTotPerTbl == 0
	    cError('NO SE HAN DEFINIDO EL TOTAL DE PERIODOS'+cMaeAct)

/*
       CASE TCO->nMetodoTbl == 0  .AND.;
	    nNroPer >= TCO->nTotPerTbl .AND.;
	    SUBS(TCO->cJvfCalTbl,TCO->nTotPerTbl*3-2,3) == SPACE(03)

	    cError('EL NUMERO DEL PERIODO DEBE SER MENOR AL TOTAL DE PERIODOS')
*/

       CASE TCO->nMetodoTbl == 1 .AND. nNroPer # TCO->nTotPerTbl

	    cError('DEBE DIGITAR EL ULTIMO PERIODO:'+;
		   STR(TCO->nTotPerTbl,2,0))

       CASE TCO->nMetodoTbl == 1 .AND. LEN(aFactorJvf()) == 0

	    cError('SE DEBE DEFINIR BIEN EL VALOR NUMERICO '+;
		   'DE LOS JUICIOS VALORATIVOS')

       CASE TCO->nMetodoTbl == 1 .AND. !lHayItvJvf()

	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')


       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DEL CALCULO DE LA NOTA DE FIN DE A¥O
       DO CASE
       CASE TCO->nMetodoTbl == 0

	    lNotFin := .F.
	    IF nNroPer+1 == TCO->nTotPerTbl .AND.;
	       SUBS(TCO->cJvfCalTbl,TCO->nTotPerTbl*3-2,3) == SPACE(03)

	       IF SUBS(TCO->cHayNotTbl,TCO->nTotPerTbl,1) == '0'
		  lNotFin := .T.
	       ENDIF

	       cError('La nota para el '+;
		      ALLTRIM(STR(TCO->nTotPerTbl,2))+' '+;
		      'per¡odo '+IF(lNotFin,'SI','NO')+' se calcula')

	       IF !lPregunta('DESEA CONTINUAR? No Si')
		  CloseAll()
		  RETURN NIL
	       ENDIF

	    ENDIF

       ENDCASE
*>>>>FIN VALIDACION DEL CALCULO DE LA NOTA DE FIN DE A¥O

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>REALIZACION DE LOS CALCULOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********LOCALIZACION DEL GRUPO
	    IF !lLocCodigo('cCodigoGru','GRU',&cNalias->cCodigoGru)
		cError('EL GRUPO '+&cNalias->cCodigoGru+ ' NO EXISTE')
		LOOP
	    ENDIF
**********FIN LOCALIZACION DEL GRUPO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,&cNalias->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(&cNalias->cCodigoGru,1,2)))

		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     IF PLA->(RECCOUNT()) == 0
		cError('NO EXISTEN PLAN ACADEMICO PARA ESTE GRUPO')
		CLOSE PLA
		LOOP
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+&cNalias->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      &cNalias->cCodigoGru)
	       LOOP
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',&cNalias->cCodigoEst)

	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+&cNalias->cCodigoGru)
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO PERTENECE AL GRUPO '+&cNalias->cCodigoGru)

	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			cNombreTes+' '+&cNalias->cCodigoGru+;
			'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

***********DETALLES DEL AREA
	     aNotAre := {}
	     aNotMat := {}
	     DetAreas(@aNotAre,@aNotMat,nNroPer)
***********FIN DETALLES DEL AREA

**********CALCULO DE LAS NOTAS DE LOS GRUPOS
	    cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)

	    DO CASE
	    CASE cJvfCal == '102'  // Indice de Cumplimiento

		 AreMat102(lShared,&cNalias->cCodigoGru,aNotAre,aNotMat,;
			   nNroPer,TCO->nTotPerTbl,aHayErr)
	       *ÀIndice de Cumpliento de las Areas

	    CASE cJvfCal == '103'  // Indice de Cumplimiento

		 AreMat103(lShared,&cNalias->cCodigoGru,aNotAre,aNotMat,;
			   nNroPer,TCO->nTotPerTbl,aHayErr)
	       *ÀIndice de Cumpliento de las Areas


	    CASE cJvfCal == '301'  // Indicadores promocionales. Virrey

		 AreMat301(lShared,&cNalias->cCodigoGru,;
			   aNotAre,aNotMat,nNroPer,;
			   TCO->nTotPerTbl,aHayErr)
	       *ÀCalculo de las notas de las Areas. Virrey

	    CASE TCO->nMetodoTbl == 0  // Calculo de Areas. Notas Numericas

		 AreMat000(lShared,&cNalias->cCodigoGru,;
			   aNotAre,aNotMat,nNroPer,TCO->nTotPerTbl,;
			   lNotFin,aHayErr)
	       *ÀIndicadores con notas numericas

	    CASE TCO->nMetodoTbl == 1  // Juicio valorativo calculodo. Factor N£merico

		 AreMat001(lShared,aNotAre,aNotMat,nNroPer,;
			   TCO->nTotPerTbl,TCO->lRecNotTbl,;
			   aHayErr)
	       *ÀJuicio valorativo calculodo. Factor Numerico

	    CASE TCO->nMetodoTbl == 99  // Colsalle

		 AreMat099(lShared,&cNalias->cCodigoGru,;
			   aNotAre,aNotMat,nNroPer,TCO->nTotPerTbl,aHayErr)
	       *ÀIndicadores con notas numericas

	    ENDCASE
**********FIN CALCULO DE LAS NOTAS DE LOS GRUPOS

**********INCREMENTO DE LAS FILAS
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes

	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN REALIZACION DE LOS CALCULOS
