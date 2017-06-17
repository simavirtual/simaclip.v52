/* SIMA - CONTABILIDAD PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR NOTAS DEL PROFESOR

**************************************************************************
* TITULO..: ACTUALIZAR NOTAS DEL PROFESOR                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2009 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   JUN 03/2009 MIE

OBJETIVOS:

1- Permite actualizar los registro de los notas de los estudiantes

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_748(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // C¢digo del Profesor
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cTxtTem := ''                  // Texto temporal

       LOCAL nTotPer := 0                   // Total de Periodos
       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL lTodos  := .F.                 // .T. Procesar todos
       LOCAL nNroOpc := 0                   // N£mero de la opci¢n

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor

       LOCAL GetList := {}                  // Variable del sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
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
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE LOGOS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL PERIODO
       nTotPer := TCO->nTotPerTbl
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,5)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL PERIODO

*>>>>LECTURA DEL USUARIO PROFESOR
       cSavPan := SAVESCREEN(0,0,24,79)
       cPatPro := cUsrPro(lShared,cNomSis,cPatSis,cNomUsr,cAnoUsr,cMaeAct,;
			  lMemUsb,@cCodigoTpr,@cNomPro,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       lTodos := .F.
       IF EMPTY(cPatPro)
	  lTodos := lPregunta('DESEA ACTUALIZAR TODOS LOS PROFESORES? No Si')
	  IF !lTodos
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       CloseDbf('TCO')
*>>>>FIN LECTURA DEL USUARIO PROFESOR

*>>>>ANALISIS DE DECISION
       SELECT PRO
       IF lTodos
	  PRO->(DBGOTOP())
       ENDIF

       nNroOpc := 2
       DO CASE
       CASE nNroOpc == 1 // Actualizar ¡ndice de cumplimiento
	    cTxtTem := 'COMPARACION DE REGISTROS.'

       CASE nNroOpc == 2 // Actualizar ¡ndice de cumplimiento
	    cTxtTem := 'ACTUALIZAR EL INDICE DE CUMPLIMIENTO.'
       ENDCASE
       IF !lPregunta(cTxtTem+cMaeAct+'.Periodo No.?'+;
		     STR(nNroPer,2)+'.DESEA CONTINUAR?No Si')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>PARAMETROS ESPECIFICOS
       AADD(aP3,{'cCodPro',PRO->cCodigoPro})
       AADD(aP3,{'cPatPro',cPatPro})
       AADD(aP3,{'cNomPro',cNomPro})

       AADD(aP3,{'nNroPer',nNroPer})
       AADD(aP3,{'nTotPer',nTotPer})

       AADD(aP3,{'nNroOpc',nNroOpc})

       AADD(aP3,{'nNroFil',''})
       AADD(aP3,{'aNroCol',''})

       AADD(aP3,{'cCamInd',''})
       AADD(aP3,{'cCamNtI',''})
       AADD(aP3,{'cCamNot',''})
       AADD(aP3,{'cCamRec',''})
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>RECORRIDO DE LOS PROFESORES
       SET PRINTER  TO &cMaeAct             // Archivo salida impresora

       DO WHILE .T.

**********LINEA DE ESTADO
	    LineaEstado('PROF:'+ALLTRIM(PRO->cApelliPro)+;
			'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				STR(PRO->(RECCOUNT()),4),cNomSis)
**********FINLINEA DE ESTADO

**********LECTURA DEL PATH DEL PROFESOR
	    IF lTodos
	       cPatPro := cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
	       nParameSet(aP3,'cCodPro',cCodPro)
	       nParameSet(aP3,'cPatPro',cPatPro)
	       nParameSet(aP3,'cNomPro',ALLTRIM(PRO->cApelliPro)+' '+;
					ALLTRIM(PRO->cNombrePro)+':'+;
					cCodigoTpr)
	    ENDIF
**********FIN LECTURA DEL PATH DEL PROFESOR

**********VALIDACION DE EXISTENCIA
	    IF !FILE(cPatPro+'\'+FCarPro+cAnoSis+ExtFile)
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE EXISTENCIA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO CARGAS DEL PROFESOR')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAP->(RECCOUNT()) == 0
		 cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR '+;
			'CODIGO: '+PRO->cCodigoPro)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CAP')
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECCION DE LA CARGA ACADEMICA
	    IF !lTodos
	       IF !lIntervCaP(nFilInf+1,1,@nRegIni,@nRegFin)
		  EXIT
	       ENDIF
	    ELSE
	       SELECT CAP
	       CAP->(DBGOBOTTOM())
	       nRegIni := 1
	       nRegFin := CAP->(RECNO())
	    ENDIF
**********FIN SELECCION DE LA CARGA ACADEMICA

**********RECORRIDO CARGA ACADEMICA DEL PROFESOR
	    SELECT CAP
	    CAP->(DBGOTO(nRegIni))
	    DO WHILE CAP->(RECNO()) <= nRegFin

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('PROF:'+PRO->cApelliPro+;
			     'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				     STR(PRO->(RECCOUNT()),4)+;
			     'ºGRUPO:'+SUBS(CAP->cCodigoCar,5,4)+;
			     'ºNo. '+STR(CAP->(RECNO()),4)+'/'+;
				     STR(CAP->(RECCOUNT()),4),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------NOTAS PROFESOR VS NOTAS CONTABILIDAD
		 NoPvsNot(aP1,aP2,aP3)
*--------------FIN NOTAS PROFESOR VS NOTAS CONTABILIDAD

	       SELECT CAP
	       CAP->(DBSKIP())

	    ENDDO
	    CloseDbf('CAP')
**********FIN RECORRIDO CARGA ACADEMICA DEL PROFESOR

**********ANALISIS DE DECISION
	    IF !lTodos
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

**********AVANCE DEL REGISTRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       EXIT
	    ENDIF
**********AVANCE DEL REGISTRO

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS PROFESORES

/*************************************************************************
* TITULO..: REGISTROS NOP vs NOT                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2009 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   JUN 03/2009 MIE

OBJETIVOS:

1- Recorre los registros de notas del profesor simultaneamente con
   los registros de notas de contabilidad.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NoPvsNot(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // C¢digo del Profesor
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"        // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := xPrm(aP3,'nNroOpc') // N£mero de la opci¢n
       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL nTotPer := xPrm(aP3,'nTotPer') // Total Periodos

       LOCAL nTipPla := 0                   // Tipo del Plan
       LOCAL lMatVar := .F.                 // .T. Materia Variable

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la Materia

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo

       LOCAL cCamIndNot := ''               // Campo Indicadores en Notas
       LOCAL cCamNtINot := ''               // Campo de Nota de Indicadores
       LOCAL cCamNotDef := ''               // Campo Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo Notas de Recuperaci¢n
     *ÀVariables de Campos de Notas en Contabilidad
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PARAMETROS ESPECIFICOS
       cCodPro := xPrm(aP3,'cCodPro') // C¢digo del Profesor
       cPatPro := xPrm(aP3,'cPatPro') // Path del Profesor
       cNomPro := xPrm(aP3,'cNomPro') // Nombre del Profesor
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>ANALISIS DEL TIPO DE PLAN ACADEMICO
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTma := MAT->cCodigoMat
       nTipPla := 0
       IF !('XXXX' $ cCodigoTgr)
	  nTipPla := nTipoPlan(SUBS(cCodigoTgr,1,2))
	  IF nTipPla == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
	  IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)
	     cError('ABRIENDO ARCHIVO DEL PLAN DE ESTUDIOS')
	     CloseDbf('PLA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA MATERIA
       lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))

       cCodigoTma := MAT->cCodigoMat
       lMatVar := lMatVarMat(cCodigoTma,.F.)
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO '+cPatPro)
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NOP->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('NOP')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ENCABEZADOS DE COLUMNA
       nNroFil := nMarco(nFilPal+1,'GRUPO.:'+;
				   SUBS(CAP->cCodigoCar,5,4)+' '+;
				   ALLTRIM(CAP->cNombreMat),22,'°')
       nNroCol := 1
       aTamCol := {10,06,20}
       aTitulo := {'CODIGO','ESTADO','OBSERVACION'}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
       nNroFil++

       nParameSet(aP3,'aNroCol',aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>RECORRIDO NOTAS DEL PROFESOR
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********CONSULTA DETALLES DEL ESTUDIANTE
	    @ nNroFil,aNroCol[1] SAY NOP->cCodigoEst+'-'+;
				 STR(NOP->(RECNO()),2,0)
**********FIN CONSULTA DETALLES DEL ESTUDIANTE

*>>>>ANALISIS DE DECISION
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cDefNoP := &cCamDef

       IF EMPTY(ALLTRIM(cDefNoP))
	  NOP->(DBSKIP())
	  LOOP
       ENDIF
*>>>>FIN ANALISIS DE DECISION


**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)

	       SET DEVICE TO PRINT
	       @ PROW()+1,00 SAY PRO->cCodigoPro+' '+CAP->cCodigoCar+' '+;
				 NOP->cCodigoEst+'-'+;
				 ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
				 'NO EXISTE EL CODIGO EN EL MAE'
	       SET DEVICE TO SCREEN

	       @ nNroFil,aNroCol[2] SAY 'ERROR'
	       @ nNroFil,aNroCol[3] SAY 'NO EXISTE EL CODIGO EN EL MAE'

	    ENDIF
	    lRetiroTno := NOP->lRetiroNoP
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
	    IF lRetiroTes
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS DE FUERA DE LISTA
	    IF lRetiroTno
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********LOCALIZACION DEL GRUPO
	    IF !lLocCodigo('cCodigoGru','GRU',&cMaeAct->cCodigoGru)
	       cError('EL GRUPO '+&cMaeAct->cCodigoGru+' NO EXISTE')
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL GRUPO

**********CAMPOS NOTAS DE CONTABILIDAD
	    cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
				     PathUno+'\'+cPatSis,nNroPer,;
				     &cMaeAct->cCodigoGru,;
				     cCodigoTma,lMatVar,;
				     @cCamNotDef,@cCamNotRec,;
				     @cCamNtINot)

	    nParameSet(aP3,'cCamInd',cCamIndNot)
	    nParameSet(aP3,'cCamNtI',cCamNtINot)
	    nParameSet(aP3,'cCamNot',cCamNotDef)
	    nParameSet(aP3,'cCamRec',cCamNotRec)
**********FIN CAMPOS NOTAS DE CONTABILIDAD

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',cCodigoTes)

	       SET DEVICE TO PRINT
	       @ PROW()+1,00 SAY PRO->cCodigoPro+' '+CAP->cCodigoCar+' '+;
				 NOP->cCodigoEst+'-'+;
				 ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
				 'NO EXISTE EN NOTAS DEL GRUPO:'+;
				 &cMaeAct->cCodigoGru
	       SET DEVICE TO SCREEN

	       @ nNroFil,aNroCol[2] SAY 'ERROR'
	       @ nNroFil,aNroCol[3] SAY 'NO EXISTE EN NOTAS DEL GRUPO'

	       NOP->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********VALIDACION CODIGOS ESTUDIANTES
	    IF NOP->cCodigoEst # NOT->cCodigoEst
	       SET DEVICE TO PRINT
	       @ PROW()+1,00 SAY PRO->cCodigoPro+' '+CAP->cCodigoCar+' '+;
				 NOP->cCodigoEst+'-'+;
				 ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
				 NOP->cCodigoEst+;
				 'NO COICIDE LOS CODIGOS DE ESTUDIANTES'
	       SET DEVICE TO SCREEN

	       @ nNroFil,aNroCol[2] SAY 'ERROR'
	       @ nNroFil,aNroCol[3] SAY 'NO COICIDE LOS CODIGOS DE ESTUDIANTES'

	       NOP->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN VALIDACION CODIGOS ESTUDIANTES

**********ANALISIS DE DECISION
	    nParameSet(aP3,'nNroFil',nNroFil)
	    DO CASE
	    CASE nNroOpc == 1 // Comparaci¢n de registros

		 IF FILE(cPatPro+'\'+CAP->cCodigoCar+ExtFile) .AND.;
		    SUBS(CAP->cCodigoCar,1,4) # '4000'

		    Prof748_01(aP1,aP2,aP3)

		 ENDIF

	    CASE nNroOpc == 2 // Actualizaci¢n ¡ndice de cumplimiento

		 IF FILE(cPatPro+'\'+CAP->cCodigoCar+ExtFile) .AND.;
		    SUBS(CAP->cCodigoCar,1,4) # '4000'

		    Prof748_02(aP1,aP2,aP3)

		 ENDIF

	    ENDCASE
**********FIN ANALISIS DE DECISION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'GRUPO.:'+;
					     SUBS(CAP->cCodigoCar,5,4)+' '+;
					     ALLTRIM(CAP->cNombreMat),22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt
		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

	  NOP->(DBSKIP())

       ENDDO
       CloseDbf('PLA')
       CloseDbf('NOP')
       RETURN NIL
*>>>>FIN RECORRIDO NOTAS DEL PROFESOR

/*************************************************************************
* TITULO..: COMPRACION DE REGISTROS                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2009 MIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   JUN 03/2009 MIE

OBJETIVOS:

1- Compara los registros de las notas del profesor con las notas de
   contabilidad.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION Prof748_01(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // C¢digo del Profesor
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"        // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := xPrm(aP3,'nNroOpc') // N£mero de la opci¢n
       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL nTotPer := xPrm(aP3,'nTotPer') // Total Periodos

       LOCAL nNroFil := xPrm(aP3,'nNroFil') // N£mero de Fila
       LOCAL aNroCol := xPrm(aP3,'aNroCol') // N£meros de Columnas

       LOCAL cCamDef := ''                  // Campo de definitivas
       LOCAL cCamInd := ''                  // Campo de Indicadores

       LOCAL cIndic1 := ''                  // Indicadores del Periodo No.1
       LOCAL cIndic2 := ''                  // Indicadores del Periodo No.2
       LOCAL cIndic3 := ''                  // Indicadores del Periodo No.3
       LOCAL cIndic4 := ''                  // Indicadores del Periodo No.4
       LOCAL cIndic5 := ''                  // Indicadores del Periodo No.5

*       LOCAL cCodigoTma := xPrm(aP3,'cCodMat') // C¢digo de la Materia

       LOCAL cCamIndNot := xPrm(aP3,'cCamInd')	// Campo Indicadores en Notas
       LOCAL cCamNtINot := xPrm(aP3,'cCamNtI')	// Campo de Nota de Indicadores
       LOCAL cCamNotDef := xPrm(aP3,'cCamNot')	// Campo Notas Definitivas
       LOCAL cCamNotRec := xPrm(aP3,'cCamRec')	// Campo Notas de Recuperaci¢n
     *ÀVariables de Campos de Notas en Contabilidad
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS NOTAS DEL PROFESOR
       cIndic1 := NOP->cIndic1NoP
       cIndic2 := NOP->cIndic2NoP
       cIndic3 := NOP->cIndic3NoP
       cIndic4 := NOP->cIndic4NoP
       cIndic5 := NOP->cIndic5NoP

       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'

       RETURN NIL
*>>>>FIN CAMPOS NOTAS DEL PROFESOR

/*************************************************************************
* TITULO..: ACTUALIZACION DEL INDICE DE CUMPLIMIENTO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2009 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   JUN 03/2009 MIE

OBJETIVOS:

1- Permite actualizar el ¡ndice de cumpliento en las notas del profesor

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION Prof748_02(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // C¢digo del Profesor
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"        // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador

       LOCAL nNroOpc := xPrm(aP3,'nNroOpc') // N£mero de la opci¢n
       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL nTotPer := xPrm(aP3,'nTotPer') // Total Periodos

       LOCAL nNroFil := xPrm(aP3,'nNroFil') // N£mero de Fila
       LOCAL aNroCol := xPrm(aP3,'aNroCol') // N£meros de Columnas

       LOCAL cCamDef := ''                  // Campo de definitivas
       LOCAL cCamInd := ''                  // Campo de Indicadores

       LOCAL cIndic1 := ''                  // Indicadores del Periodo No.1
       LOCAL cIndic2 := ''                  // Indicadores del Periodo No.2
       LOCAL cIndic3 := ''                  // Indicadores del Periodo No.3
       LOCAL cIndic4 := ''                  // Indicadores del Periodo No.4
       LOCAL cIndic5 := ''                  // Indicadores del Periodo No.5

       LOCAL cDefNoP := ''                  // Nota definita profesor
       LOCAL cNotDef := ''                  // Nota Definitiva calculada

       LOCAL cCamIndNot := xPrm(aP3,'cCamInd')	// Campo Indicadores en Notas
       LOCAL cCamNtINot := xPrm(aP3,'cCamNtI')	// Campo de Nota de Indicadores
       LOCAL cCamNotDef := xPrm(aP3,'cCamNot')	// Campo Notas Definitivas
       LOCAL cCamNotRec := xPrm(aP3,'cCamRec')	// Campo Notas de Recuperaci¢n
     *ÀVariables de Campos de Notas en Contabilidad
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cDefNoP := &cCamDef

       IF EMPTY(ALLTRIM(cDefNoP))
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>INDICADORES DE LOS PERIODOS
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'

       FOR i := 1 TO 5

	   cCamIndNot := STUFF(cCamIndNot,8,1,STR(i,1))
	  *Campo para cade periodo

	   DO CASE
	   CASE i == 1

		IF nNroPer == 1
		   cIndic1 := &cCamInd
		ELSE
		   cIndic1 := &cCamIndNot
		ENDIF

	   CASE i == 2

		IF nNroPer == 2
		   cIndic2 := &cCamInd
		ELSE
		   cIndic2 := &cCamIndNot
		ENDIF

	   CASE i == 3

		IF nNroPer == 3
		   cIndic3 := &cCamInd
		ELSE
		   cIndic3 := &cCamIndNot
		ENDIF

	   CASE i == 4

		IF nNroPer == 4
		   cIndic4 := &cCamInd
		ELSE
		   cIndic4 := &cCamIndNot
		ENDIF

	   CASE i == 5

		IF nNroPer == 5
		   cIndic5 := &cCamInd
		ELSE
		   cIndic5 := &cCamIndNot
		ENDIF

	   ENDCASE

       ENDFOR
*>>>>FIN INDICADORES DE LOS PERIODOS

*>>>>CALCULO DEL INDICE DE CUMPLIMIENTO
       cNotDef := cJvfCal103(cIndic1,;
			     cIndic2,;
			     cIndic3,;
			     cIndic4,;
			     cIndic5,;
			     nNroPer,nTotPer)+SPACE(03)
     *ÀIndice de Cumplimiento. La Salle Bucaramaga.Variable
*>>>>FIN CALCULO DEL INDICE DE CUMPLIMIENTO

*>>>>ANALISIS DE DECISION
       IF ALLTRIM(cDefNoP) # ALLTRIM(cNotDef)

	  lHayErr := .T.

	  @ nNroFil,aNroCol[2] SAY 'ERROR'
	  @ nNroFil,aNroCol[3] SAY 'NOTA PROFESOR='+ALLTRIM(cDefNoP)+' '+;
				   'NOTA CALCULADA='+ALLTRIM(cNotDef)
       ELSE

	  @ nNroFil,aNroCol[2] SAY 'OK'

       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>GRABACION DE LA NOTA DEFINITIVA
       IF lHayErr

	  SELECT NOP
	  IF NOP->(lRegLock(lShared,.F.))

	     REPL &cCamDef WITH cNotDef

	     NOP->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	  ENDIF
	  IF lShared
	     NOP->(DBUNLOCK())
	  ENDIF

	  SET DEVICE TO PRINT
	  @ PROW()+1,00 SAY PRO->cCodigoPro+' '+CAP->cCodigoCar+' '+;
			    ALLTRIM(cDefNoP)+' '+;
			    ALLTRIM(cNotDef)+' OK'+;
			    NOP->cCodigoEst+'-'+ALLTRIM(STR(NOP->(RECNO()),2))+' '+;
			    CAP->cNombreMat
	  SET DEVICE TO SCREEN

       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LA NOTA DEFINITIVA





