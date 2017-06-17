/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: CALCULOS - INCONSISTENCIAS

**************************************************************************
* TITULO..: CALCULOS                                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2008 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   OCT 14/2008 MAR

OBJETIVOS:

1- Permite imprimir los estudiantes con inconsistencias.

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_255(aP1,aP2,aP3)

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
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOI'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
     *ÀVariables del Log
*>>>>FIN DECLARACION DE VARIABLES

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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathLog+'\',;
			     'LOI'+STR(nNroPer,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   'PLAN'+SUBS(GRU->cCodigoGru,1,2)+cAnoSis+ExtFile,;
			   'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    IF PLA->(RECCOUNT()) == 0
	       cError('NO EXISTEN PLAN ACADEMICO PARA GRUPO'+GRU->cCodigoGru)
	       CloseDbf('PLA')
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CloseAll()
	      RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********FUNCION DEL PROGRAMA
	    aP2 := {}
	    AADD(aP2,{'nNroPer',nNroPer})
	    AADD(aP2,{'cCodGru',GRU->cCodigoGru})
	    AADD(aP2,{'cGruFin',cGruFin})


	    Func1_255(aP1,aP2,aP3)
**********FIN FUNCION DEL PROGRAMA

	  CloseDbf('NOT')
	  GRU->(DBSKIP())

       ENDDO
       SELECT &cAliasL
       BROWSE()
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: FUNCION DEL PROGRAMA. No.1                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2008 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   OCT 14/2008 MAR

OBJETIVOS:

1- Recorre el archivo de Notas para realizar los diferentes procesos.

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Func1_255(aP1,aP2,aP3)

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del periodo
       LOCAL cCodGru := xPrm(aP2,'cCodGru') // C¢digo del Grupo
       LOCAL cGruFin := xPrm(aP2,'cGruFin') // C¢digo del grupo final
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
     *ÀVariables de Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR NOTAS
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF lRetiroTes
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********FUNCION DEL PROGRAMA
	    Func3_255(aP1,aP2,aP3)
**********FIN FUNCION DEL PROGRAMA

	  NOT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS

/*************************************************************************
* TITULO..: FUNCION DEL PROGRAMA. No.2                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2008 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   OCT 14/2008 MAR

OBJETIVOS:

1- Recorre las areas y las materias para encontrar las inconsistencias

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Func2_255(aP1,aP2,aP3)

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del periodo
       LOCAL cCodGru := xPrm(aP2,'cCodGru') // C¢digo del Grupo
       LOCAL cGruFin := xPrm(aP2,'cGruFin') // C¢digo del grupo final
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL aAreas  := {}		    // Areas
       LOCAL aMaters := {}		    // Materias

       LOCAL aDetAre := {}                  // Detalles del Area
       LOCAL aDetMat := {}                  // Detalles de la Materia

       LOCAL aDbfMat := {}                  // Campos de Materias
       LOCAL aDbfPla := {}                  // Campos del Plan Academico
       LOCAL aDbfNot := {}                  // Campos de Notas

       LOCAL cMatVar := {}                  // Materia Variable
       LOCAL aMatSel := {}                  // Materias Selectivas
       LOCAL aDbfSel := {}                  // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                  // Materias Variables
       LOCAL aMatVar := {}                  // Campos de Materias
     *ÀMaterias Selectivas

       LOCAL nNroOrd := 0                   // Orden en el Boletin
       LOCAL cCodAre := ''                  // C¢digo del Area
       LOCAL cAreMat := ''                  // C¢digo del Area de la Materia

       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCamIndNot := ''               // Campo de Indicadores
       LOCAL cCamJntNot := ''               // Campo notas de los Indicadores
     *ÀVariables de Campo

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOI'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
     *ÀVariables del Log

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL AREA
       aAreas  := {}			// Areas
       aMaters := {}			// Materias
       AreMatEst(@aAreas,@aMaters,nNroPer)
*>>>>FIN DETALLES DEL AREA

*>>>>RECORRIDO POR AREAS
       FOR i := 1 TO LEN(aAreas)

**********DETALLES DEL AREA
	    nNroOrd := aAreas[i,1]
	    cCodAre := aAreas[i,2]
	    aDetAre := aAreas[i,3]

	    aDbfMat := xPrm(aDetAre,'aDbfMat')
	    aDbfPla := xPrm(aDetAre,'aDbfPla')
	    aDbfNot := xPrm(aDetAre,'aDbfNot')
**********DETALLES DEL AREA

**********AREAS NO PROMEDIABLES
	    cCamNotDef := xPrm(aDbfNot,'cNotas')
	    IF 'AREN' $ cCamNotDef

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF !xPrm(aDetAre,'lNoPrnM')  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------ANALISIS DE LA NOTA DEL AREA
		 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		 IF EMPTY(cNotDef)

		    cCodigoTma := xPrm(aDbfMat,'cCodMat')

		    aCamLog := {}
		    AADD(aCamLog,{'cCodigoEst',NOT->cCodigoEst})
		    AADD(aCamLog,{'cCodigoGru',cCodGru})
		    AADD(aCamLog,{'nNroRegEst',NOT->(RECNO())})
		    AADD(aCamLog,{'cMatNotLog',cCodigoTma})
		    AADD(aCamLog,{'cObservLog','SIN NOTA'})
		  *ÀCampos del Log

		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		 ENDIF
*--------------FIN ANALISIS DE LA NOTA DEL AREA

	    ENDIF
**********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS DEL AREA
	    FOR j := 1 TO LEN(aMaters)

		cAreMat := aMaters[j,1]

		IF cCodAre == cAreMat

*==================DETALLES DE LA MATERIA
		     cAreMat := aMaters[j,1]
		     aDetMat := aMaters[j,2]

		     aDbfMat := xPrm(aDetMat,'aDbfMat')
		     aDbfPla := xPrm(aDetMat,'aDbfPla')
		     aDbfNot := xPrm(aDetMat,'aDbfNot')

		     aMatSel := xPrm(aDetMat,'aMatSel')
*==================FIN DETALLES DE LA MATERIA

*==================ANALISIS DE LA IMPRESION DE LA MATERIA
		     IF !xPrm(aDetMat,'lNoPrnM')   // .T. No Imprimir
			LOOP
		     ENDIF
*==================FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*==================ANALISIS DE LA NOTA DE LA MATERIA
		     cCamNotDef := xPrm(aDbfNot,'cNotas')
		     cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		     IF EMPTY(cNotDef)

		       cCodigoTma := xPrm(aDbfMat,'cCodMat')

		       aCamLog := {}
		       AADD(aCamLog,{'cCodigoEst',NOT->cCodigoEst})
		       AADD(aCamLog,{'cCodigoGru',cCodGru})
		       AADD(aCamLog,{'nNroRegEst',NOT->(RECNO())})
		       AADD(aCamLog,{'cMatNotLog',cCodigoTma})
		       AADD(aCamLog,{'cObservLog','SIN NOTA'})
		     *ÀCampos del Log

		       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		     ENDIF
*==================FIN ANALISIS DE LA NOTA DE LA MATERIA

		ENDIF

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS DEL AREA

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS

/*************************************************************************
* TITULO..: FUNCION DEL PROGRAMA. No.3                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2008 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   OCT 14/2008 MAR

OBJETIVOS:

1- Recorre las areas y las materias para encontrar las inconsistencias

2- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Func3_255(aP1,aP2,aP3)

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del periodo
       LOCAL cCodGru := xPrm(aP2,'cCodGru') // C¢digo del Grupo
       LOCAL cGruFin := xPrm(aP2,'cGruFin') // C¢digo del grupo final
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOI'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
     *ÀVariables del Log

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL AREA
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DETALLES DEL AREA

*>>>>RECORRIDO POR AREAS
       FOR i := 1 TO LEN(aNotAre)

**********AREAS NO PROMEDIABLES
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

	       cCodigoTma := SUBS(aNotAre[i,6],9,4)

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 cNotDef := SUBS(&(aNotAre[i,4]),nNroPer*4-3,4)
		 IF EMPTY(cNotDef)

		    aCamLog := {}
		    AADD(aCamLog,{'cCodigoEst',NOT->cCodigoEst})
		    AADD(aCamLog,{'cCodigoGru',cCodGru})
		    AADD(aCamLog,{'nNroRegEst',NOT->(RECNO())})
		    AADD(aCamLog,{'cMatNotLog',cCodigoTma})
		    AADD(aCamLog,{'cObservLog','SIN NOTA'})
		  *ÀCampos del Log

		    aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

	    ENDIF
**********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

		  cCodigoTma := SUBS(aNotMat[j,11],3,4)

*=================ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*=================FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*=================LECTURA DE LA NOTAS DE LA MATERIA
		    cNotDef := SUBS(&(aNotMat[j,4]),nNroPer*4-3,4)
		    IF EMPTY(cNotDef)

		       aCamLog := {}
		       AADD(aCamLog,{'cCodigoEst',NOT->cCodigoEst})
		       AADD(aCamLog,{'cCodigoGru',cCodGru})
		       AADD(aCamLog,{'nNroRegEst',NOT->(RECNO())})
		       AADD(aCamLog,{'cMatNotLog',cCodigoTma})
		       AADD(aCamLog,{'cObservLog','SIN NOTA'})
		     *ÀCampos del Log

		       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

		    ENDIF
*=================FIN LECTURA DE LA NOTAS DE LA MATERIA

	       ENDIF

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS

