/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: CALCULOS - VALIDAR

**************************************************************************
* TITULO..: VALIDAR CALCULOS DE AREAS POR ESTUDIANTE                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/2008 LUN A
       Bucaramanga, Colombia	    INICIO: 10:45 AM   SEP 08/2008 LUN

OBJETIVOS:

1- Permite validar los c lculos de las areas por estudiante.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_254(aP1,aP2,aP3)

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

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL nNroPer := 0                   // N£mero del bimestre
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀVariables archivos

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat+ExtFile,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSel+cMaeAct+ExtFile,'SEL',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxSel+cMaeAct+cExtNtx,lShared,nModCry})
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

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>VALIDACION DE LOS CALCULOS
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
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********LOCALIZACION DEL GRUPO
	    IF !lLocCodigo('cCodigoGru','GRU',&cNalias->cCodigoGru)
		cError('EL GRUPO '+&cNalias->cCodigoGru+ ' NO EXISTE')
		LOOP
	    ENDIF
**********FIN LOCALIZACION DEL GRUPO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	       LOOP
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',&cNalias->cCodigoEst)

	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+GRU->cCodigoGru)
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			cNombreTes+' '+GRU->cCodigoGru+;
			'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO PERTENECE AL GRUPO '+GRU->cCodigoGru)

	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********CALCULO DEL PORCENTAJE DEL ACUMULADO
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroPer)
**********FIN CALCULO DEL PORCENTAJE DEL ACUMULADO

**********IMPRESION DEL INFORME
	    aArchvo := {}
	    oBrowse := NIL

	    AADD(aP3,{'aArchvo',aArchvo})
	    AADD(aP3,{'PathDoc',PathDoc})
	    AADD(aP3,{'cOpcPrn',SCO->cOpcPrnCon})
	    AADD(aP3,{'nCodPrn',SCO->nCodigoPrn})
	    AADD(aP3,{'oBrowse',oBrowse})

	    AADD(aP3,{'nNroPer',nNroPer})
	    AADD(aP3,{'cCodEst',NOT->cCodigoEst})
	    AADD(aP3,{'cNomEst',cNombreTes})
	    AADD(aP3,{'cCodGru',GRU->cCodigoGru})
	    AADD(aP3,{'nNroLis',NOT->(RECNO())})

	    AADD(aP3,{'aNotAre',aNotAre})
	    AADD(aP3,{'aNotMat',aNotMat})
	    AADD(aP3,{'cJvfCal',SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)})
	    AADD(aP3,{'nMetodo',TCO->nMetodoTbl})

	    SCO_25400(aP1,aP2,aP3)
**********FIN IMPRESION DEL INFORME

**********INCREMENTO DE LAS FILAS
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
*>>>>FIN VALIDACION DE LOS CALCULOS