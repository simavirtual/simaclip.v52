/*                       SIMA - CONTABILIDAD ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO HABILITACIONES

REQUERIMIENTOS:

- Compilar: clipper FuncsHab /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Habilitaciones o Recuperaciones

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 05/98 LUN A
       Colombia, Bucaramanga        INICIO: 11:45 AM   ENE 05/98 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfHab(lShared,PathHab,FileHab,lIntUno,fNtxHab,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathHab				    // Path del Archivo
       FileHab				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxHab				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfHab := {{"cCodigoEst","Character",06,0},; // C¢digo del Profesor
			 {"cApelliEst","Character",26,0},; // Apellido del Estudiante
			 {"cNombreEst","Character",26,0},; // Nombre del Estudiante
			 {"cCodigoGru","Character",04,0},; // C¢digo del Grupo
			 {"cCodigoMat","Character",04,0},; // C¢digo de la Materia
			 {"nAproboNot","Numeric"  ,02,0},; // C¢digo de Promoci¢n
			 {"cNombreMat","Character",80,0},; // Nombre de la Materia
			 {"dFecHabHab" ,"Date"    ,08,0},; // Fecha de la Habilitaci¢n
			 {"cNroActHab","Character",06,0},; // N£mero de la acta de Habilitaci¢n
			 {"cNotHabHab","Character",04,0},; // Nota de la Habilitaci¢n
			 {"cCodigoPro","Character",06,0}}  // C¢digo del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfHab
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathHab) == 0
	    DBCREATE(FileHab,aDbfHab,"DBFNTX")

       CASE DIRCHANGE(PathHab) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathHab)

       CASE DIRCHANGE(PathHab) == -5
	    cError('NO TIENE DERECHOS EN: '+PathHab)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: LECTURA DE LOS ESTUDIANTES QUE HABILITAN O RECUPERAN         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2000 VIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   MAY 19/2000 VIE

OBJETIVOS:

1- Lee todas las habilitaciones o recuperaciones y las graba en el archivo
   de Habilitaciones.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeerHab(lShared,cNomSis,nFilInf,nColInf,cAnoUsr,cPatSis,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomSis                              // Nombre del sistema
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cAnoUsr			            // A¤o del sistema
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro habilitado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables Generales

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL lHayHab := .F.                 // .T. Hay Recuperaciones
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       CreaDbfHab(lShared,cPatSis,FileHab)
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileHab,'HAB',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileApr,'APR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuN,'SUN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuG,'SUG',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+FileJvf,'JVF',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN lHayHab
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACIO PARA EL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

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
	  CLOSE ALL
	  RETURN lHayHab
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN lHayHab
       ENDIF
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)

       lHayItv := lHayItvJvf()
       lNotNum := IF(lNotNum,lNotNum,lHayItv)
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO TERCERO '+;
				     'CUARTO  QUINTO  SEXTO   SEPTIMO '+;
				     'OCTAVO  NOVENO  DECIMO  UNDECIMO',;
				  (VAL(SUBS(GRU->cCodigoGru,1,2))+1)*8-7,8)))
		CLOSE ALL
		RETURN lHayHab
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CLOSE ALL
	      RETURN lHayHab
	   ENDIF
	   aNotAre := {}
	   aNotMat := {}
	   DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT NOT
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+;
			      cGruFin+'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------ANALISIS DE LAS HABILITACIONES
		 aMatHab := {}
		 aMatHab := aMatHabSel(NOT->cCodigoEst,GRU->cCodigoGru,;
				       NOT->nAproboNot,aNotAre,aNotMat,;
				       TCO->nTotPerTbl,lNotNum)

		 IF EMPTY(aMatHab)
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
		 lHayHab := .T.
*--------------FIN ANALISIS DE LAS HABILITACIONES

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,'ALU')
		    cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
				  RTRIM(ALU->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF ALU->lRetiroEst
		    cNombreTes += ' RETIRADO'
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------GRABACION DE LA HABILITACION
		 SELECT HAB
		 FOR i := 1 TO LEN(aMatHab)
		     IF HAB->(lRegLock(lShared,.T.))
			REPL HAB->cCodigoEst WITH NOT->cCodigoEst
			REPL HAB->cApelliEst WITH ALU->cApelliEst
			REPL HAB->cNombreEst WITH ALU->cNombreEst
			REPL HAB->cCodigoGru WITH GRU->cCodigoGru
			REPL HAB->cCodigoMat WITH aMatHab[i,1]
			REPL HAB->cNombreMat WITH aMatHab[i,2]
			REPL HAB->dFecHabHab WITH aMatHab[i,3]
			REPL HAB->cNroActHab WITH aMatHab[i,4]
			REPL HAB->cNotHabHab WITH aMatHab[i,5]
			REPL HAB->cCodigoPro WITH aMatHab[i,6]
			REPL HAB->nAproboNot WITH aMatHab[i,9]
			HAB->(DBCOMMIT())
		     ELSE
			cError('NO SE PUEDE GRABAR EL REGISTRO')
		     ENDIF
		     IF lShared
			HAB->(DBUNLOCK())
		     ENDIF
		 NEXT
*--------------GRABACION DE LA HABILITACION

	       SELECT NOT
	       SKIP

	    ENDDO
	    CloseDbf('NOT')
	    CloseDbf('PLA')
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  SELECT GRU
	  SKIP

       ENDDO
       CLOSE ALL
       RETURN lHayHab
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 05/98 LUN A
       Colombia, Bucaramanga        INICIO: 11:51 AM   ENE 05/98 LUN

OBJETIVOS:

1- Permite el mantenimiento del archivo

2- Se debe pasar el directorio completo de archivo

3- Retorn NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenHab(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivo Grupos

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL oBrowse := NIL                 // Objeto para el Browse
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

*>>>>LECTURA DE LAS HABILITACIONES
       IF !lLeerHab(lShared,cNomSis,nFilInf,nColInf,cAnoUsr,cPatSis,cMaeAct)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LAS HABILITACIONES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileHab,'HAB',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileApr,'APR',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileJui+cMaeAct+cAnoSis+ExtFile,'JUI',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxJui+cMaeAct+cAnoSis+cExtNtx,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS DE RECUPERACIONES')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL')

       CASE HAB->(RECCOUNT()) == 0
	    cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')

       CASE APR->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA TABLA DE PROMOCIONES')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASES GRABADAS')

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

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT HAB
       oBrowse := oDefBrwHab(nFilPal+1,00,22,79)
       SETKEY(K_F5,{||BuscarHab(oBrowse)})
       SETKEY(K_F9,{||MenuOtrHab(aParam1,aParam2,aParam3,oBrowse)})
       HAB->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE          	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 05/98 LUN A
       Colombia, Bucaramanga        INICIO: 11:55 AM   ENE 05/98 LUN

OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwHab(nFilUno,nColUno,nFilDos,nColDos)

*>>>>DESCRIPCION DE PARAMETROS
/*     nFilUno                              // Fila Coordenada uno
       nColUno                              // Columna Coordenad uno
       nFilDos                              // Fila Coordenada dos
       nColDos                              // Columna Coordenad dos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilUno+1,nColUno+1,nFilDos-1,nColDos-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       oBrowse:Cargo := {'<< CONSULTA DE RECUPERACIONES. TOTAL: '+;
			  STR(HAB->(RECCOUNT()),4)+' >>',;
			 '<F5>Buscar <F9>Imprimir <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT HAB
       oColumn	     := TBCOLUMNNEW('CODIGO DEL;ESTUDIANTE',;
				    {||HAB->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
				    {||HAB->cNombreEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('APELLIDO DEL;ESTUDIANTE',;
				    {||HAB->cApelliEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRUPO DEL;ESTUDIANTE',;
				    {||HAB->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ASIGNATURA',;
			      {||HAB->cCodigoMat+' '+HAB->cNombreMat})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE LA;RECUPERACION',;
				    {||HAB->dFecHabHab})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ACTA No',{||HAB->cNroActHab})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('EVALUACION',;
				    {||HAB->cNotHabHab})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;PROFESOR', {||HAB->cCodigoPro})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','HAB'},{'FIELD','cCodigoPro'},;
			 {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PROFESOR',;
				   {||cSekNomPro(HAB->cCodigoPro,'HAB')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;PROMOCION',{||HAB->nAproboNot})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
€* TITULO DE LA FUNCION..: BUSCAR EL CODIGO EN EL BROWSE                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/97 MAR A
       Colombia, Bucaramanga        INICIO: 12:25 AM   ABR 02/97 MAR

OBJETIVOS:

1- Localiza el c¢digo dentro del Browse

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarHab(oBrwHab)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwHab			      // Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegHab := 0                   // Registro del Banco
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo de Aprobaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTes := cSpaces('HAB','cCodigoEst')
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lValCodHab(ROW(),COL()-1,@cCodigoTes)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(cCodigoTes)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT HAB
       IF lBuscar .AND. lLocCodigo('cCodigoEst','HAB',cCodigoTes)
	   nRegHab := RECNO()
	   GO TOP
	   oBrwHab:GOTOP()
	   GO nRegHab
	   oBrwHab:FORCESTABLE()
       ELSE
	  oBrwHab:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/97 MAR A
       Colombia, Bucaramanga        INICIO: 12:30 AM   ABR 02/97 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodHab(nNroFil,nNroCol,cCodEst)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodEst				    // C¢digo de la Habse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegHab := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('cCodigoEst','HAB',cCodEst)
	  nRegHab := nSelCodHab(nNroFil,nNroCol)
	  IF nRegHab == 0
	     cCodEst := cSpaces('HAB','cCodigoEst')
	  ELSE
	     GO nRegHab
	     cCodEst := HAB->cCodigoEst
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL CODIGO DE LA CLASE                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/97 MAR A
       Colombia, Bucaramanga        INICIO: 12:30 AM   ABR 02/97 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger el registro del archivo de acuerdo al nombre.

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodHab(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegHab := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN CLASES DE INDICADORES GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT HAB
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL REGISTRO
       HAB->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nRegHab := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||HAB->cNombreEst+' '+HAB->cApelliEst})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nRegHab
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO..: MENU DE INFORMES PARA EL BROWSE DE HABILITACIONES            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 04/98 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   AGO 04/98 MAR

OBJETIVOS:

1- Menu de informes para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrHab(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse				    // Browse del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARACION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<LISTADO DE RECUPERACIONES   >')
       AADD(aMenus,'2<ACTAS DE RECUPERACIONES     >')
       AADD(aMenus,'3<LIBRO DE RECUPERACIONES     >')
       AADD(aMenus,'4<INDICADORES PENDIENTES      >')
       AADD(aMenus,'5<FORMATO LIBRO RECUPERACIONES>')
       IF !EMPTY(TCO->cCalHabTbl)
	  AADD(aMenus,'9<CALCULO NOTA RECUPERACIONES >')
       ENDIF


       aAyuda := {}
       AADD(aAyuda,'Permite imprimir el listado de Recuperaciones')
       AADD(aAyuda,'Permite imprimir las Actas de Recuperaci¢n')
       AADD(aAyuda,'Permite imprimir el libro de Recuperaciones')
       AADD(aAyuda,'Permite imprimir los Indicadores pendientes de los estudiantes')
       AADD(aAyuda,'Crea el archivo del formato del texto de libro de recuperaciones')
       IF !EMPTY(TCO->cCalHabTbl)
	  AADD(aAyuda,'Calcula las notas de las Recuperaciones.')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       IF nNroOpc # 0
	  nNroOpc := VAL(SUBS(aMenus[nNroOpc],1,1))
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    HabMenu01(aParam1,aParam2,aParam3,oBrowse)
	  *ÀListado de Recuperaciones

       CASE nNroOpc == 2
	    HabMenu02(aParam1,aParam2,aParam3,oBrowse)
	  *ÀActas de Recuperaci¢n

       CASE nNroOpc == 3

************IMPRESION LIBRO DE RECUPERACIONES
	      IF lPregunta('DESEA IMPRIMIR DE ACUERDO A UN FORMATO? No Si')
		 LibroRecu(cNomUsr,cAnoUsr,oBrowse)
	      ELSE
		 HabMenu03(aParam1,aParam2,aParam3,oBrowse)
	      ENDIF
************FIN IMPRESION LIBRO DE RECUPERACIONES

       CASE nNroOpc == 4
	    HabMenu04(aParam1,aParam2,aParam3,oBrowse)
	  *ÀIndicadores Pendientes

       CASE nNroOpc == 5
	    FormArch(cNomSis,'bases','libru','.txt',;
		     'Puede insertar los siguientes textos para:'+cEnter(2)+;
		     '(FOLIO)      => N£mero del Folio'+cEnter(1)+;
		     '(ACTA)       => N£mero de Acta'+cEnter(1)+;
		     '(FECHA)      => Fecha del Sistema'+cEnter(1)+;
		     '(YEAR)       => A¤o del Proceso'+cEnter(1)+;
		     '(RECUPERA)   => Recuperaciones del Estudiante'+cEnter(1)+;
		     '(ESTUDIANTE) => Nombre del Estudiante'+cEnter(1)+;
		     '(GRUPO)      => Grupo del Estudiante'+cEnter(1)+;
		     '(GRADO)      => Grado del Estudiante'+;
		     cTxtHlpPrn())

       CASE nNroOpc == 9

	    HabMenu09(aParam1,aParam2,aParam3,oBrowse)
	  *ÀCalculo nota de Recuperaciones.

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: LISTADO DE RECUPERACIONES                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 22/2000 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 22/2000 LUN

OBJETIVOS:

1- Imprime un informe de las recuperaciones por Estudiantes

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HabMenu01(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse				    // Browse del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cCodAct := ''                  // C¢digo Actual
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL lSiorNo := .T.                 // .T. Primer Registro
       LOCAL nNroHab := 0                   // N£mero de Habilitaciones
     *ÀVariables espec¡ficas

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cFecHabTha := ''               // Fecha de la Habilitaci¢n
       LOCAL cNroActTha := ''               // N£mero de la Acta de Habilitaci¢n
       LOCAL cNotHabTHa := ''               // Nota de la Habilitaci¢n
       LOCAL cNombreTpr := ''               // Nombre del Profesor
     *ÀTemporales de Campos
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>VALIDACION DEL CONTENIDO
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LA LECTURA
       SET CURSOR ON
       nNroOpc := nLeeOpcion('1<POR CURSO> 2<POR PROFESOR> '+;
			     '3<POR MATERIA> 4<NO SE PRESENTO> 5<REGRESAR?',4,'0')
       SET CURSOR OFF
       IF nNroOpc == 5
	  RETURN NIL
       ENDIF
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := HAB->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
		   'RELACION DE RECUPERACIONES',;
		   'POR '+IF(nNroOpc==1 .OR. nNroOpc==4 ,'CURSO',;
			     IF(nNroOpc==2,'PROFESOR','MATERIA')),;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,52,06,12,06,40}
       aTitulo := {'No. ',;
		   'GRUPO ',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES',;
		   IF(lNotNum,'NOTA','JUICIO'),;
		   'FECHA ',;
		   'ACTA',;
		   'PROFESOR'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'recuacta'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>INDEXACION DEL ARCHIVO
       SELECT HAB
       fNtxTem := cFileTempo('',SUBS(cNomUsr,1,4),cExtTem)
       DO CASE
       CASE nNroOpc == 2  // Por Profesor
	    INDEX ON HAB->cCodigoPro+HAB->cCodigoGru+;
		     HAB->cCodigoEst+HAB->cCodigoMat TO &fNtxTem
	    DBSETINDEX(fNtxTem)

       CASE nNroOpc == 3  // Por Materia
	    INDEX ON HAB->cCodigoMat+HAB->cCodigoPro TO &fNtxTem
	    DBSETINDEX(fNtxTem)
       ENDCASE
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>FILTRACION DEL ARCHIVO
       IF nNroOpc == 4

	  SELECT HAB
	  SET FILTER TO EMPTY(HAB->cNotHabHab)

	  HAB->(DBGOTOP())
	  IF HAB->(EOF())
	     SET FILTER TO
	     cError('NO EXISTEN ESTUDIANTES SIN RECUPERACIONES')
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT HAB
       GO TOP
       cCodAnt := HAB->cCodigoEst
       DO WHILE .NOT. HAB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( HAB->(RECNO()) / HAB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DE PROFESOR
	    cNombreTpr := ''
	    IF lLocCodigo('cCodigoPro','PRO',HAB->cCodigoPro)
	       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	       cNombreTpr := SUBS(cNombreTpr+SPACE(40),1,40)
	    ENDIF
**********FIN LOCALIZACION DE PROFESOR

**********IMPRESION DEL REGISTRO
	    cCodAct := HAB->cCodigoEst
	    IF cCodAct == cCodAnt .AND. lSiorNo
	       cNombreTes := RTRIM(HAB->cApelliEst)+' '+HAB->cNombreEst
	       cNombreTes := SUBS(cNombreTes+SPACE(52),1,52)
	       aTitulo := {STR(++nNroHab,4),;
			   HAB->cCodigoGru,;
			   HAB->cCodigoEst,;
			   cNombreTes,;
			   SPACE(04),;
			   SPACE(10),;
			   SPACE(06),;
			   SPACE(40)}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)

	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	       cNombreTes := SPACE(02)+SUBS(HAB->cNombreMat+SPACE(50),1,50)
	       aTitulo := {SPACE(04),;
			   SPACE(06),;
			   SPACE(06),;
			   cNombreTes,;
			   cNotDef(HAB->cNotHabHab,lNotNum),; //Modificado
			   cFecha(HAB->dFecHabHab),;
			   HAB->cNroActHab,;
			   cNombreTpr}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)

	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    ELSE
	       cNombreTes := SPACE(02)+SUBS(HAB->cNombreMat+SPACE(50),1,50)
	       aTitulo := {SPACE(04),;
			   SPACE(06),;
			   SPACE(06),;
			   cNombreTes,;
			   cNotDef(HAB->cNotHabHab,lNotNum),; //Modificado
			   cFecha(HAB->dFecHabHab),;
			   HAB->cNroActHab,;
			   cNombreTpr}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)

	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT HAB
	    HAB->(DBSKIP())
	    IF HAB->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DEL CODIGO ANTERIOR
	    IF cCodAnt # HAB->cCodigoEst
	       cCodAnt := HAB->cCodigoEst
	       lSiorNo := .T.
	    ELSE
	       lSiorNo := .F.
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       IF nNroOpc # 1 .AND. nNroOpc # 4
	  HAB->(DBCLEARIND())
	  IF !lFileDelete(fNtxTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
       ENDIF

       IF nNroOpc == 4
	  SELECT HAB
	  SET FILTER TO
       ENDIF

       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: ACTAS DE RECUPERACION                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/2000 MAR A
       Colombia, Bucaramanga        INICIO: 03:40 PM   MAY 23/2000 MAR

OBJETIVOS:

1- Imprime las actas por profesor

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HabMenu02(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse				    // Browse del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cCodAct := ''                  // C¢digo Actual
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL cActMat := ''                  // C¢digo Actual de la Materia
       LOCAL cAntMat := ''                  // C¢digo Anterior de la Materia
       LOCAL lCamPro := .T.                 // .T. Cambio el c¢digo del Estudiante
       LOCAL lCamMat := .T.                 // .T. Cambio el c¢digo de la Materia
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayNpR := .F.                 // .T. No se presento a Recuperacion
       LOCAL aTxtNpr := {}                  // Texto para la no presentaci¢n de la Recuperaci¢n.

       LOCAL nFilSup := 0                   // Fila Superior del marco
       LOCAL nColSup := 0                   // Columna Superior del marco
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroFil := 0                   // N£mero de la Fila
     *ÀVariables espec¡ficas

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cFecHabTha := ''               // Fecha de la Habilitaci¢n
       LOCAL cNroActTha := ''               // N£mero de la Acta de Habilitaci¢n
       LOCAL cNotHabTHa := ''               // Nota de la Habilitaci¢n
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del Profesor
     *ÀTemporales de Campos
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>VALIDACION DEL CONTENIDO
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LA LECTURA
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       nNroOpc := nLeeOpcion('1<TODOS LOS PROFESORES> 2<POR PROFESOR>?',2,'0')
       SET CURSOR OFF
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
       cCodigoTpr := HAB->cCodigoPro
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>LECTURA DEL CODIGO DEL PROFESOR
       IF nNroOpc == 2

	  nFilSup := 07
	  nColSup := 24
	  nFilInf := nFilSup+4
	  nColInf := 60

	  nNroFil := nMarco(nFilSup,'CODIGO DEL PROFESOR :',;
			    nFilInf,'°',,nColSup,nColInf)

	  SETCURSOR(1)
	  cCodigoTpr := SPACE(06)
	  @ nNroFil,nColSup+2 SAY 'CODIGO:' GET cCodigoTpr
	  READ
	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(cCodigoTpr)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA DEL CODIGO DEL PROFESOR

*>>>>LOCALIZACION DEL CODIGO
       IF nNroOpc == 2
	  IF !lLocCodigo('cCodigoPro','HAB',cCodigoTpr)
	     cError('EL CODIGO: '+ALLTRIM(cCodigoTpr)+' NO EXISTE')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'recuacta'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>INDEXACION DEL ARCHIVO
       SELECT HAB
       fNtxTem := cFileTempo('',SUBS(cNomUsr,1,4),cExtTem)
       INDEX ON HAB->cCodigoPro+HAB->cCodigoMat TO &fNtxTem
       DBSETINDEX(fNtxTem)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT HAB
       IF nNroOpc == 1
	  GO TOP
       ELSE
	  lLocCodigo('cCodigoPro','HAB',cCodigoTpr)
       ENDIF
       cCodAnt := HAB->cCodigoPro
       cAntMat := HAB->cCodigoMat
       DO WHILE .NOT. HAB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( HAB->(RECNO()) / HAB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DE PROFESOR
	    cNombreTpr := ''
	    IF lLocCodigo('cCodigoPro','PRO',HAB->cCodigoPro)
	       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	       cNombreTpr := SUBS(cNombreTpr,1,40)
	    ENDIF
**********FIN LOCALIZACION DE PROFESOR

**********DEFINCION DEL ENCABEZADO
	    cCodAct := HAB->cCodigoPro
	    cActMat := HAB->cCodigoMat
	    IF cCodAct == cCodAnt .AND. lCamPro
	       nNroPag := 0
	       lTamAnc := .F.

	       nTotReg := HAB->(RECCOUNT())+nLinTot
	       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
			   'ACTA DE RECUPERACION No. '+HAB->cNroActHab,;
			   'PROFESOR: '+ALLTRIM(cNombreTpr),;
			   'CODIGO:'+HAB->cCodigoPro,;
			   nNroPag++,;
			   NIL,lTamAnc}
	       cCodIni := DRAFT_ON+PICA+CONDEN_ON
	       cCodFin := NEGRA_OF+DOBGOL_OF
	    ENDIF
**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    IF cCodAct == cCodAnt .AND. lCamPro
	       aNroCol := {06,06,82,06,12,06}
	       aTitulo := {'GRUPO ',;
			   'CODIGO',;
			   'APELLIDOS Y NOMBRES ',;
			   IF(lNotNum,'NOTA','JUICIO'),;
			   'FECHA ',;
			   'ACTA'}
	       cCabCol := cRegPrint(aTitulo,@aNroCol)
	    ENDIF
**********FIN ENCABEZADOS DE COLUMNA

**********ANALISIS PARA CENTRAR EL INFORME
	    IF cCodAct == cCodAnt .AND. lCamPro
	       nLenPrn := n17Stan
	       lCentra := .F.
	       nColCab := 0
	       IF lCentra
		  nColCab := (nLenPrn-LEN(cCabCol))/2
	       ENDIF
	       aCabSec := NIL
	       bPagina := {||lPagina(nLinReg)}
	       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
				       nColCab,cCodFin,aCabSec)}
	       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
	    ENDIF
**********FIN ANALISIS PARA CENTRAR EL INFORME

**********IMPRESION DEL ENCABEZADO
	    IF cCodAct == cCodAnt .AND. lCamPro
	       IF lSiPaso
		  EJECT
	       ENDIF
	       EVAL(bCabeza)
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL REGISTRO
	    cNombreTes := RTRIM(HAB->cApelliEst)+' '+HAB->cNombreEst
	    cNombreTes := SUBS(cNombreTes+SPACE(80),1,80)
	    cNombreTma := SUBS(HAB->cNombreMat+SPACE(82),1,82)
	    IF cActMat == cAntMat .AND. lCamMat
	       aTitulo := {SPACE(06),;
			   SPACE(06),;
			   cNombreTma,;
			   SPACE(04),;
			   SPACE(10),;
			   SPACE(06)}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	       aTitulo := {HAB->cCodigoGru,;
			   HAB->cCodigoEst,;
			   SPACE(02)+cNombreTes,;
			   cNotDef(HAB->cNotHabHab,lNotNum),; //Modificado
			   cFecha(HAB->dFecHabHab),;
			   HAB->cNroActHab}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    ELSE
	       aTitulo := {HAB->cCodigoGru,;
			   HAB->cCodigoEst,;
			   SPACE(02)+cNombreTes,;
			   HAB->cNotHabHab,;
			   cFecha(HAB->dFecHabHab),;
			   HAB->cNroActHab}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF

	    IF 'NP' $ HAB->cNotHabHab
	       lHayNpR := .T.
	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT HAB
	    HAB->(DBSKIP())
	    IF HAB->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DEL CODIGO ANTERIOR
	    IF cCodAnt # HAB->cCodigoPro
	       cCodAnt := HAB->cCodigoPro
	       lCamPro := .T.
	       

	       lPrnReg(02,nColCab,'OBSERVACIONES:',bPagina,bDerAut,bCabeza)
	       cTxtPrn := REPL('-',LEN(cTxtPrn))
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       cTxtPrn := REPL('-',LEN(cTxtPrn))
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       cTxtPrn := REPL('-',LEN(cTxtPrn))
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	       IF lHayNpR .AND. !EMPTY(COA->cTxtNpRCoA)
		   aTxtNpr := aDivLin('NP='+ALLTRIM(COA->cTxtNpRCoA),LEN(cTxtPrn))
		   FOR i := 1 TO LEN(aTxtNpR)
		       lPrnReg(01,nColCab,aTxtNpR[i],bPagina,bDerAut,bCabeza)
		   NEXT
	       ENDIF

	       lPrnReg(03,nColCab,'Firma del Profesor',bPagina,bDerAut,bCabeza)

	       lHayNpR := .F.
	       lSiPaso := .T.
	       IF nNroOpc == 2
		  EXIT
	       ENDIF
	    ELSE
	       lCamPro := .F.
	    ENDIF

	    IF cAntMat # HAB->cCodigoMat
	       cAntMat := HAB->cCodigoMat
	       lCamMat := .T.
	    ELSE
	       lCamMat := .F.
	       IF lCamPro
		  lCamMat := .T.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       HAB->(DBCLEARIND())
       IF !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: LIBRO DE HABILITACIONES                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2000 VIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 26/2000 VIE

OBJETIVOS:

1- Imprime el libro de recuperaciones.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HabMenu03(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse				    // Browse del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cCodAct := ''                  // C¢digo Actual
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL lCamEst := .T.                 // .T. Cambio el c¢digo del Estudiante
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cNotHab := ''                  // Nota de la Habilitaci¢n
       LOCAL lHayNpR := .F.                 // .T. No se presento a Recuperacion
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL aTxtNpr := {}                  // Texto para la no presentaci¢n de la Recuperaci¢n.
     *ÀVariables espec¡ficas

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cFecHabTha := ''               // Fecha de la Habilitaci¢n
       LOCAL cNroActTha := ''               // N£mero de la Acta de Habilitaci¢n
       LOCAL cNotHabTHa := ''               // Nota de la Habilitaci¢n
       LOCAL nAproboTno := 0                // C¢digo de la Aprobaci¢n
       LOCAL cNombreTpr := ''               // Nombre del Profesor
     *ÀTemporales de Campos
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>VALIDACION DEL CONTENIDO
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LA LECTURA
       SET CURSOR ON
       nNroOpc := nLeeOpcion('1<TODOS LOS ESTUDIANTES> 2<POR ESTUDIANTE>?',2,'0')
       SET CURSOR OFF
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
       cCodigoTes := HAB->cCodigoEst
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'libracta'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT HAB
       IF nNroOpc == 1
	  GO TOP
       ELSE
	  lLocCodigo('cCodigoEst','HAB',cCodigoTes)
       ENDIF
       cCodAnt := HAB->cCodigoEst
       DO WHILE .NOT. HAB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( HAB->(RECNO()) / HAB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********DEFINCION DEL ENCABEZADO
	    cCodAct := HAB->cCodigoEst
	    IF cCodAct == cCodAnt .AND. lCamEst
	       nNroPag := 0
	       lTamAnc := .F.

	       nTotReg := HAB->(RECCOUNT())+nLinTot
	       aCabeza := {'LIBRO DE '+IF(lNotNum,;
					  'RECUPERACIONES','RECUPERACIONES'),;
			   cTxtMaeAct(cMaeAct),;
			   'JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
			   '',;
			   '',;
			   NIL,;
			   NIL,lTamAnc}

	       cCodIni := DRAFT_ON+PICA+CONDEN_ON
	       cCodFin := NEGRA_OF+DOBGOL_OF
	    ENDIF
**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    IF cCodAct == cCodAnt .AND. lCamEst
	       aNroCol := {80,IF(lNotNum,12,16),12,06}
	       aTitulo := {'MATERIA',;
			   IF(lNotNum,'NOTA','JUICIO'),;
			   'FECHA ',;
			   'ACTA'}
	       cCabCol := cRegPrint(aTitulo,@aNroCol)
	    ENDIF
**********FIN ENCABEZADOS DE COLUMNA

**********ANALISIS PARA CENTRAR EL INFORME
	    IF cCodAct == cCodAnt .AND. lCamEst
	       nLenPrn := n17Stan
	       lCentra := .F.
	       nColCab := 0
	       IF lCentra
		  nColCab := (nLenPrn-LEN(cCabCol))/2
	       ENDIF
	       aCabSec := {'ALUMNO(A): '+;
			   ALLTRIM(HAB->cApelliEst)+' '+HAB->cNombreEst,;
			   'Del Curso: '+HAB->cCodigoGru+' '+;
			   'present¢ las recuperaciones de:'}
	       bPagina := {||lPagina(nLinReg)}
	       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
				       nColCab,cCodFin,aCabSec)}
	       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
	    ENDIF
**********FIN ANALISIS PARA CENTRAR EL INFORME

**********IMPRESION DEL ENCABEZADO
	    IF cCodAct == cCodAnt .AND. lCamEst
	       IF lSiPaso
		  EJECT
	       ENDIF
	       EVAL(bCabeza)
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL REGISTRO
	    aTitulo := {HAB->cNombreMat,;
			cNotDef(HAB->cNotHabHab,lNotNum),; //Modificado
			cFecha(HAB->dFecHabHab),;
			HAB->cNroActHab}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    IF 'NP' $ HAB->cNotHabHab
	       lHayNpR := .T.
	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAproboTno := HAB->nAproboNot
	    SELECT HAB
	    HAB->(DBSKIP())
	    IF HAB->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DEL CODIGO ANTERIOR
	    IF cCodAnt # HAB->cCodigoEst
	       cCodAnt := HAB->cCodigoEst
	       lCamEst := .T.

	       cTxtPrn := REPL('-',LEN(cTxtPrn))
	       aNroLin := aDivLin('OBSERVACION FINAL: '+;
				  cAproboJui(nAproboTno),LEN(cTxtPrn))

	       lPrnReg(01,nColCab,'',bPagina,bDerAut,bCabeza)
	       FOR i := 1 TO LEN(aNroLin)
		   lPrnReg(01,nColCab,aNroLin[i],bPagina,bDerAut,bCabeza)
	       NEXT

		IF lHayNpR .AND. !EMPTY(COA->cTxtNpRCoA)
		   lPrnReg(01,nColCab,'',bPagina,bDerAut,bCabeza)
		   aTxtNpr := aDivLin('*'+ALLTRIM(COA->cTxtNpRCoA),LEN(cTxtPrn))
		   FOR i := 1 TO LEN(aTxtNpR)
		       lPrnReg(01,nColCab,aTxtNpR[i],bPagina,bDerAut,bCabeza)
		   NEXT
		ENDIF

	       lPrnReg(02,nColCab,'OBSERVACIONES:',bPagina,bDerAut,bCabeza)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

*--------------PREPARACION DE LOS FIRMANTES DEL LIBRO
		 Firmas(n17Stan,4,;
			{{ALLTRIM(CON->cGerentCon),;
			  ALLTRIM(CON->cNitGerCon),'RECTOR(A)'},;
			 {ALLTRIM(CON->cSecretCon),;
			 ALLTRIM(CON->cNitSecCon),'SECRETARIO(A)'}},.F.)
		*Impresi¢n firmantes del libro
*--------------FIN PREPARACION DE LOS FIRMANTES DEL LIBRO

	       lSiPaso := .T.
	       IF nNroOpc == 2
		  EXIT
	       ENDIF
	    ELSE
	       lCamEst := .F.
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: INDICADORES PENDIENTES                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 19/2003 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   FEB 19/2003 MIE

OBJETIVOS:

1- Imprime los indicadores pendientes de las recuperaciones por Estudiantes

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HabMenu04(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse				    // Browse del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL   i,j,y := 0                   // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cProAct := ''                  // C¢digo Actual
       LOCAL cProAnt := ''                  // C¢digo Anterior
       LOCAL cEstAct := ''                  // Estudiante Actual
       LOCAL cEstAnt := ''                  // Estudiante Anterior
       LOCAL lCamPro := .T.                 // .T. Cambio el c¢digo del profesor
       LOCAL lCamEst := .T.                 // .T. Cambio el Estudiante
       LOCAL lSiorNo := .T.                 // .T. Primer Registro
       LOCAL nNroHab := 0                   // N£mero de Habilitaciones
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL nNroPer := 5                   // N£mero del Periodo
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL cLogros := ''                  // Indicadores del Periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL aIndTxt := {}                  // Indicadores de Logros

       LOCAL nFilSup := 0                   // Fila Superior del marco
       LOCAL nColSup := 0                   // Columna Superior del marco
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroFil := 0                   // N£mero de la Fila
     *ÀVariables espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cFecHabTha := ''               // Fecha de la Habilitaci¢n
       LOCAL cNroActTha := ''               // N£mero de la Acta de Habilitaci¢n
       LOCAL cNotHabTHa := ''               // Nota de la Habilitaci¢n
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del Profesor

       LOCAL cCamJuiNot := ''               // Campo de Indicadores
     *ÀTemporales de Campos
*>>>>FIN DECLARACION DE VARIABLES

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

*>>>>VALIDACION DEL CONTENIDO
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LA LECTURA
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       nNroOpc := nLeeOpcion('1<TODOS LOS PROFESORES> 2<POR PROFESOR>?',2,'0')
       SET CURSOR OFF
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
       cCodigoTpr := HAB->cCodigoPro
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>LECTURA DEL CODIGO DEL PROFESOR
       IF nNroOpc == 2

	  nFilSup := 07
	  nColSup := 24
	  nFilInf := nFilSup+4
	  nColInf := 60

	  nNroFil := nMarco(nFilSup,'CODIGO DEL PROFESOR :',;
			    nFilInf,'°',,nColSup,nColInf)

	  SETCURSOR(1)
	  cCodigoTpr := SPACE(06)
	  @ nNroFil,nColSup+2 SAY 'CODIGO:' GET cCodigoTpr
	  READ
	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(cCodigoTpr)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA DEL CODIGO DEL PROFESOR

*>>>>LOCALIZACION DEL CODIGO
       IF nNroOpc == 2
	  IF !lLocCodigo('cCodigoPro','HAB',cCodigoTpr)
	     cError('EL CODIGO: '+ALLTRIM(cCodigoTpr)+' NO EXISTE')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'recuindi'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>INDEXACION DEL ARCHIVO
       SELECT HAB
       fNtxTem := cFileTempo('',SUBS(cNomUsr,1,4),cExtTem)
       INDEX ON HAB->cCodigoPro+HAB->cCodigoGru+;
		HAB->cCodigoEst+HAB->cCodigoMat TO &fNtxTem
       DBSETINDEX(fNtxTem)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lIndNiv := TCO->lIndNivTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='1',.T.,.F.)
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT HAB
       IF nNroOpc == 1
	  GO TOP
       ELSE
	  lLocCodigo('cCodigoPro','HAB',cCodigoTpr)
       ENDIF
       cProAnt := HAB->cCodigoPro
       cEstAnt := HAB->cCodigoEst
       DO WHILE .NOT. HAB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( HAB->(RECNO()) / HAB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

***********SELECION DE LAS AREAS DE TRABAJO
	     lHayNot := .T.
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,HAB->cCodigoGru),;
			 'PLA',NIL,lShared) .OR.;
		!lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
					   'NT'+HAB->cCodigoGru+cAnoSis+ExtFile,;
					   'NOT',NIL,lShared)
		lHayNot := .F.
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DE PROFESOR
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroPer)
	    IF .NOT. lLocCodigo('cCodigoEst','NOT',HAB->cCodigoEst)
	       lHayNot := .F.
	    ENDIF
**********FIN LOCALIZACION DE PROFESOR

**********LOCALIZACION DE PROFESOR
	    cNombreTpr := ''
	    IF lLocCodigo('cCodigoPro','PRO',HAB->cCodigoPro)
	       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	       cNombreTpr := SUBS(cNombreTpr,1,40)
	    ENDIF
**********FIN LOCALIZACION DE PROFESOR

**********DEFINCION DEL ENCABEZADO
	    cProAct := HAB->cCodigoPro
	    cEstAct := HAB->cCodigoEst
	    IF cProAct == cProAnt .AND. lCamPro
	       nNroPag := 0
	       lTamAnc := .F.

	       nTotReg := HAB->(RECCOUNT())+nLinTot
	       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+' DE '+cAnoUsr,;
			   'RECUPERACIONES FINALES',;
			   'PROFESOR: '+ALLTRIM(cNombreTpr),;
			   'CODIGO:'+HAB->cCodigoPro,;
			   nNroPag++,;
			   NIL,lTamAnc}
	       cCodIni := DRAFT_ON+PICA+CONDEN_ON
	       cCodFin := NEGRA_OF+DOBGOL_OF
	    ENDIF
**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    IF cProAct == cProAnt .AND. lCamPro

	       aNroCol := {04,06,06,52,06,12,06,40}
	       aTitulo := {'No. ',;
			   'GRUPO ',;
			   'CODIGO',;
			   'APELLIDOS Y NOMBRES',;
			   IF(lNotNum,'NOTA','JUICIO'),;
			   'FECHA ',;
			   'ACTA',;
			   'OBSERVACION'}
	       cCabCol := cRegPrint(aTitulo,@aNroCol)
	    ENDIF
**********FIN ENCABEZADOS DE COLUMNA

**********ANALISIS PARA CENTRAR EL INFORME
	    IF cProAct == cProAnt .AND. lCamPro
	       nLenPrn := n17Stan
	       lCentra := .F.
	       nColCab := 0
	       IF lCentra
		  nColCab := (nLenPrn-LEN(cCabCol))/2
	       ENDIF
	       aCabSec := NIL
	       bPagina := {||lPagina(nLinReg)}
	       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
				       nColCab,cCodFin,aCabSec)}
	       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
	    ENDIF
**********FIN ANALISIS PARA CENTRAR EL INFORME

**********IMPRESION DEL ENCABEZADO
	    IF lCamPro
	       IF lSiPaso
		  EJECT
	       ELSE
		  lSiPaso := .T.
	       ENDIF
	       EVAL(bCabeza)
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL NOMBRE DEL ESTUDIANTE
	    IF lCamEst
	       cNombreTes := RTRIM(HAB->cApelliEst)+' '+HAB->cNombreEst
	       cNombreTes := SUBS(cNombreTes+SPACE(52),1,52)
	       aTitulo := {STR(++nNroHab,4),;
			   HAB->cCodigoGru,;
			   HAB->cCodigoEst,;
			   cNombreTes,;
			   SPACE(04),;
			   SPACE(10),;
			   SPACE(06),;
			   SPACE(40)}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DE LA PRIMERA MATERIA
	    cNombreTes := SPACE(02)+SUBS(HAB->cNombreMat+SPACE(50),1,50)
	    aTitulo := {SPACE(04),;
			SPACE(06),;
			SPACE(06),;
			cNombreTes,;
			HAB->cNotHabHab,;
			cFecha(HAB->dFecHabHab),;
			HAB->cNroActHab,;
			''}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DE LA PRIMERA MATERIA

**********LOCALIZACION DE LA MATERIA VARIABLE
	    lMatVarMat(HAB->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
**********FIN LOCALIZACION DE LA MATERIA VARIABLE

**********LOCALIZACION DEL CAMPO DE INDICADORES
	    IF SUBS(HAB->cCodigoMat,3,2) == '00'
	       y := ASCAN(aNotAre,;
			  {|aNot|SUBS(aNot[6],9,4) == cCodigoTma})
	       cCamJuiNot := aNotAre[y,6]
	    ELSE
	       y := ASCAN(aNotMat,;
			  {|aNot|SUBS(aNot[6],9,4) == cCodigoTma})

	       cCamJuiNot := aNotMat[y,5]
	    ENDIF
**********FIN LOCALIZACION DEL CAMPO DE INDICADORES

**********IMPRESION DE LOS INDICADORES PENDIENTES
	    FOR i := 1 TO 5

		cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(i,1))
		   cLogros := &cCamJuiNot
		   cSiRecu := ''
		   cNoRecu := ''

		IndRecSiNo(cLogros,lEvaInd,@cSiRecu,@cNoRecu,.T.)
		IF EMPTY(cNoRecu)
		   LOOP
		ENDIF
		aIndTxt := aIndLogTxt(HAB->cCodigoGru,;
				      HAB->cCodigoMat,cNoRecu,lIndNiv)

		FOR j := 1 TO LEN(aIndTxt)

		    aTitulo := {SPACE(04),;
				'Perio'+STR(i,1),;
				aIndTxt[j,1],;
				SUBS(aIndTxt[j,2,1]+SPACE(120),1,120)}
		    cTxtPrn := cRegPrint(aTitulo,{04,06,06,52,120})
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		  *ÀIndicador

		    IF !EMPTY(aIndTxt[j,2,2])
		       aTitulo := {SPACE(01),;
				   SPACE(01),;
				   SPACE(01),;
				   SPACE(01)+;
				   SUBS(aIndTxt[j,2,2]+SPACE(120),1,120)}
		       cTxtPrn := cRegPrint(aTitulo,{04,06,06,52,120})
		       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		    ENDIF
		  *ÀIndicador Extra


		ENDFOR
	    ENDFOR
**********FIN IMPRESION DE LOS INDICADORES PENDIENTES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT HAB
	    HAB->(DBSKIP())
	    IF HAB->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DEL CODIGO ANTERIOR PROFESOR
	    IF cProAnt # HAB->cCodigoPro

	       lCamPro := .T.
	       lCamEst := .T.
	       cProAnt := HAB->cCodigoPro

	       IF nNroOpc == 2
		  EXIT
	       ENDIF

	    ELSE
	       lCamPro := .F.
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR PROFESOR

**********ANALISIS DEL CODIGO ANTERIOR ESTUDIANTE
	    IF cEstAnt # HAB->cCodigoEst
	       lCamEst := .T.
	       cEstAnt := HAB->cCodigoEst
	    ELSE
	       lCamEst := .F.
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR ESTUDIANTE

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       HAB->(DBCLEARIND())
       IF !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: INDICADORES DE LOGROS EN TEXTO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 19/2003 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   FEB 19/2003 MIE

OBJETIVOS:

1- Busca el texto de los indicadores de logros

2- Retorna un vector con el texto de los indicadores

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aIndLogTxt(cCodGru,cCodMat,cLogros,lIndNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       cCodMat                              // C¢digo de la Materia
       cLogros                              // Indicadores a Imprimir
       lIndNiv                              // .T. Indicadores por nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL aIndLog := {}                  // Indicadores de Logros
       LOCAL aIndica := {}                  // Indicadores de Logros

       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Descripci¢n del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS INDICADORES
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR i:= 1 TO nNroInd

***********SEPARACION DEL CODIGO DEL LOGRO
	     cCodInd    := SUBS(cLogros,i*6-5,6)
	     cCodLog    := SUBS(cCodInd,1,4)
	     IF EMPTY(cCodInd)
		LOOP
	     ENDIF
***********FIN SEPARACION DEL CODIGO DEL LOGRO

***********LOCALIZACION DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(cCodGru,1,2)

	     IF cCodLog # SPACE(04)

		IF lLocCodigo('cCodigoCla','CLA',UPPER(SUBS(cCodLog,1,1)),;
			      'DE LA CLASE')

*------------------ANALISIS DEL NIVEL PARA EL INDICADOR
		     IF EMPTY(CLA->cCodigoMat)
			cCodigoTni := SUBS(cCodGru,1,2)
		     ELSE
			cCodMat := CLA->cCodigoMat
			cCodigoTni := SPACE(02)
		     ENDIF
		   *ÀAsignaci¢n del nivel para usar indicador nivel o materia
*------------------FIN ANALISIS DEL NIVEL PARA EL INDICADOR

		ENDIF

	    ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodMat+cCodLog,;
			      cCodMat+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodInd
	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := JUI->cNombreJui
	     ENDIF
	     aIndLog := {}
	     AADD(aIndLog,cNombreTju)
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION DE LOS INDICADORES EXTRAS
	     FOR j := 1 TO TCO->nJuiExtTbl

		 cNombreTju := &('JUI->cExtra'+STR(j,1)+'Jui')
		 IF EMPTY(cNombreTju)
		    AADD(aIndLog,'')
		 ELSE
		    AADD(aIndLog,cNombreTju)
		 ENDIF

	     ENDFOR
	     AADD(aIndica,{cCodInd,aIndLog})
***********FIN IMPRESION DE LOS INDICADORES EXTRAS

       ENDFOR
       RETURN aIndica
*>>>>FIN IMPRESION DE LOS INDICADORES

/*************************************************************************
* TITULO..: LIBRO DE HABILITACIONES                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 17/2005 JUE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAR 17/2005 JUE

OBJETIVOS:

1- Imprime el libro de recuperaciones.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecupeEst(cCodEst,nMarIzq)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL       i := {}                  // Contador
       LOCAL lHayNpR := .F.                 // .T. No se presento a Recuperacion
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nColPrn := 0                   // Columna de Impresi¢n
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
     *ÀVariables espec¡ficas

       LOCAL cNombreTpr := ''               // Nombre del Profesor
       LOCAL nAproboTno := 0                // C¢digo de la Aprobaci¢n
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL ESTUDIANTE
       IF !lLocCodigo('cCodigoEst','HAB',cCodEst)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL ESTUDIANTE

*>>>>ENCABEZADOS DE COLUMNA
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
       aNroCol := {50,IF(lNotNum,12,16),12,40}
       aTitPrn := {'MATERIA',;
		   IF(lNotNum,'NOTA','JUICIO'),;
		   'FECHA ',;
		   'EXAMINADOR'}

       SendCodes(PCL('CondenOn'))
       cCabCol := cRegPrint(aTitPrn,@aNroCol)

       nMarIzq := IF(EMPTY(nMarIzq),0,nMarIzq)
       nColPrn := nMarIzq
       @PROW()+1,nColPrn SAY REPL('-',LEN(cCabCol))
       @PROW()+1,nColPrn SAY cCabCol
       @PROW()+1,nColPrn SAY REPL('-',LEN(cCabCol))
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS RECUPERACIONES
       DO WHILE HAB->cCodigoEst == cCodEst .AND. !HAB->(EOF())

**********LOCALIZACION DE PROFESOR
	    cNombreTpr := ''
	    IF lLocCodigo('cCodigoPro','PRO',HAB->cCodigoPro)
	       cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	       cNombreTpr := SUBS(cNombreTpr,1,40)
	    ENDIF
**********FIN LOCALIZACION DE PROFESOR

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    AADD(aRegPrn,SUBS(HAB->cNombreMat,1,50))
	    AADD(aRegPrn,IF(lNotNum,HAB->cNotHabHab,;
				    cTxtNota(HAB->cNotHabHab)))
	    AADD(aRegPrn,cFecha(HAB->dFecHabHab))
	    AADD(aRegPrn,cNombreTpr)

	    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	    @PROW()+1,nColPrn SAY cTxtPrn

	    IF 'NP' $ HAB->cNotHabHab
	       lHayNpR := .T.
	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAproboTno := HAB->nAproboNot
	    SELECT HAB
	    HAB->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DE LA OBSERVACION FINAL
       aNroLin := aDivLin('OBSERVACION FINAL: '+;
			  cAproboJui(nAproboTno),LEN(cTxtPrn))

       @PROW()+1,nColPrn SAY ''
       FOR i := 1 TO LEN(aNroLin)
	   @PROW()+1,nColPrn SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA OBSERVACION FINAL

*>>>>IMPRESION OBSERVACION NP
       IF lHayNpR .AND. !EMPTY(COA->cTxtNpRCoA)
	  @PROW()+1,nColPrn SAY ''
	  aNroLin := aDivLin('*'+ALLTRIM(COA->cTxtNpRCoA),LEN(cTxtPrn))
	  FOR i := 1 TO LEN(aNroLin)
	      @PROW()+1,nColPrn SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION OBSERVACION NP

*>>>>OBSERVACIONES
       @PROW()+2,nColPrn SAY 'OBSERVACIONES:'
       FOR i := 1 TO 3
	   @PROW()+1,nColPrn SAY REPL('-',LEN(cCabCol))
       NEXT
       RETURN NIL
*>>>>FIN OBSERVACIONES

/*************************************************************************
* TITULO..: LIBRO DE RECUPERACIONES CON FORMATO DE TEXTO                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2000 VIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 26/2000 VIE

OBJETIVOS:

1- Imprime el libro de recuperaciones de acuerdo al archivo con el modelo
   del libro de recuperciones.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibRecu01(cAnoUsr,cCodEst,cNroFrm,nFolio,nLenLin,nMarIzq)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoUsr                              // A¤o del Usuario
       cCodEst                              // C¢digo del Estudiante
       cNroFrm                              // N£mero del Documento
       lNotNum                              // .T. Nota Numerica
       nFolio                               // Folio del Libro
       nLenLin                              // Longitud de la l¡nea
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aMezIni := {}                  // Campos a Mesclar iniciales
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL bCodBlo := NIL                 // Code Block de C¢digo.
       LOCAL cNomEst := ''                  // Nombre del Estudiante

       LOCAL cCodigoTgr := ''               // Nombre del Grupo
       LOCAL cNombreTni := ''               // Nombre del Nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL ESTUDIANTE
       cNomEst := RTRIM(HAB->cApelliEst)+' '+;
		  RTRIM(HAB->cNombreEst)
       cNombreTni := cNomNiv(VAL(SUBS(HAB->cCodigoGru,1,2)))
*>>>>FIN BUSQUEDA DEL ESTUDIANTE

*>>>>SUSTITUCION DE CAMPOS
       bCodBlo := {||RecupeEst(HAB->cCodigoEst,nMarIzq)}
       CamSusPrn(@aMezIni)

       aMezcla := {}
       AADD(aMezcla,{'(FOLIO)',STR(nFolio++,3,0)})
       AADD(aMezcla,{'(ACTA)',HAB->cNroActHab})
       AADD(aMezcla,{'(FECHA)',cFecha(DATE(),10)})
       AADD(aMezcla,{'(YEAR)',cAnoUsr})
       AADD(aMezcla,{'(RECUPERA)',bCodBlo})
       AADD(aMezcla,{'(ESTUDIANTE)',cNomEst})
       AADD(aMezcla,{'(CODIGO)',cCodEst})
       AADD(aMezcla,{'(GRUPO)',HAB->cCodigoGru})
       AADD(aMezcla,{'(GRADO)',cNombreTni})

       FOR i := 1 TO LEN(aMezIni)
	   AADD(aMezcla,{aMezIni[i,1],aMezIni[i,2]})
       NEXT
*>>>>FIN SUSTITUCION DE CAMPOS

*>>>>ESPECIFICACION DEL TAMA¥O DEL PAPEL
       nLenLin := IF(EMPTY(nLenLin),70,nLenLin)
       nMarIzq := IF(EMPTY(nMarIzq),NIL,nMarIzq)

       @PROW()+1,00 SAY ''
       PrnFileDoc('Bases\libru'+cNroFrm+'.txt',aMezcla,nLenLin,nMarIzq)
       RETURN NIL
*>>>>FIN ESPECIFICACION DEL TAMA¥O DEL PAPEL

/*************************************************************************
* TITULO ..: EDICION DEL FORMATO PARA EL LIBRO DE RECUPERACIONES         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 18/2004 VIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   MAR 18/2004 VIE

OBJETIVOS:

1- Permite Crear,modicar el modelo del formato para el libro de
   recuperaciones

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FormArch(cNomSis,PathArc,farchvo,ExtFile,cTxtHlp)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       PathArc                              // Path del Archivo
       farchvo                              // Iniciales del nombre del archivo
       ExtFile                              // Extension del Archivo
       cTxtHlp                              // Texto de ayuda del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroFrm := 1                   // N£mero del Formato
       LOCAL cNroFrm := ''                  // N£mero del Formato
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','FORMATO MODELO')
       @ nNroFil,nNroCol GET nNroFrm PICT '999'
       READ
       IF EMPTY(nNroFrm)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroFrm := STR(nNroFrm,3)
       lCorrecion(@cNroFrm)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>EDICION DE LA CARTA MODELO
       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'
       cTxtHlp := IF(EMPTY(cTxtHlp),'AYUDA NO DISPONIBLE',cTxtHlp)
       EditFile(cNomSis,PathArc+'\'+farchvo+cNroFrm+ExtFile,;
			 "Edite el Texto del Formato No. "+cNroFrm,;
			 cTxtHlp,cTitHlp)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN EDICION DE LA CARTA MODELO

/*************************************************************************
* TITULO..: LIBRO DE HABILITACIONES                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2000 VIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 26/2000 VIE

OBJETIVOS:

1- Imprime el libro de recuperaciones.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibroRecu(cNomUsr,cAnoUsr,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL lCamEst := .T.                 // .T. Cambio el c¢digo del Estudiante
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nFilSup := 0                   // Fila Superior del marco
       LOCAL nColSup := 0                   // Columna Superior del marco
       LOCAL nFilInf := 0                   // Fila Inferior del marco
       LOCAL nColInf := 0                   // Columna Inferior del marco
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroFrm := 1                   // N£mero del Formato
       LOCAL cNroFrm := ''                  // N£mero del Formato

       LOCAL nFolio  := 1                   // Folio del Libro
       LOCAL nLenLin := 70                  // Longitud de l¡nea
       LOCAL nMarIzq := 1                   // Margen Izquierdo
       LOCAL GetList := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       SET CURSOR ON
       cSavPan := SAVESCREEN(0,0,24,79)
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','FORMATO MODELO')
       @ nNroFil,nNroCol GET nNroFrm PICT '999'
       READ
       IF EMPTY(nNroFrm)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SET CURSOR OFF
	  RETURN NIL
       ENDIF
       cNroFrm := STR(nNroFrm,3)
       lCorrecion(@cNroFrm)

       IF !FILE('Bases\libru'+cNroFrm+'.txt')
	  cError('EL FORMATO MODELO No. '+cNroFrm+' NO EXISTE')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SET CURSOR OFF
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>VALIDACION DE LA LECTURA
       nNroOpc := nLeeOpcion('1<TODOS LOS ESTUDIANTES> 2<POR ESTUDIANTE>?',2,'0')
       SET CURSOR OFF
       cCodigoTes := HAB->cCodigoEst
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>DETALLES DE IMPRESION
       nFilSup := 07
       nColSup := 24
       nFilInf := nFilSup+7
       nColInf := 60

       nNroFil := nMarco(nFilSup,'DETALLES PARA IMPRIMIR:',;
			 nFilInf,'°',,nColSup,nColInf)

       SETCURSOR(1)
       @ nNroFil,nColSup+2   SAY 'FOLIO             :' GET nFolio
       @ nNroFil+1,nColSup+2 SAY 'LONGITUD DE LINEAS:' GET nLenLin
       @ nNroFil+2,nColSup+2 SAY 'MARGEN IZQUIERDO  :' GET nMarIzq
       IF nNroOpc == 2
	  cCodigoTes := SPACE(06)
	  @ nNroFil+3,nColSup+2 SAY 'CODIGO ESTUDIANTE :' GET cCodigoTes
       ENDIF
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN DETALLES DE IMPRESION

*>>>>LOCALIZACION DEL CODIGO
       IF nNroOpc == 2
	  IF !lLocCodigo('cCodigoEst','HAB',cCodigoTes)
	     cError('EL CODIGO: '+ALLTRIM(cCodigoTes)+' NO EXISTE')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'librecu'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT HAB
       IF nNroOpc == 1
	  HAB->(DBGOTOP())
       ENDIF
       cCodAnt := HAB->cCodigoEst
       DO WHILE .NOT. HAB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( HAB->(RECNO()) / HAB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL LIBRO DE RECUPERACION
	    nNroReg := HAB->(RECNO())
	    IF lCamEst
	       LibRecu01(cAnoUsr,HAB->cCodigoEst,cNroFrm,;
			 nFolio++,nLenLin,nMarIzq)
	    ENDIF
	    HAB->(DBGOTO(nNroReg))
**********FIN IMPRESION DEL LIBRO DE RECUPERACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT HAB
	    HAB->(DBSKIP())
	    IF HAB->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DEL CODIGO ANTERIOR
	    IF cCodAnt # HAB->cCodigoEst
	       cCodAnt := HAB->cCodigoEst
	       lCamEst := .T.

	       IF nNroOpc == 2
		  EXIT
	       ENDIF
	    ELSE
	       lCamEst := .F.
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DE LAS RECUPERACIONES

*>>>>IMPRESION DERECHOS
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: CALCULO DE LAS NOTAS DE LAS RECUPERACIONES                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 19/2003 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   FEB 19/2003 MIE

OBJETIVOS:

1- Imprime los indicadores pendientes de las recuperaciones por Estudiantes

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HabMenu09(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse				    // Browse del Profesor */
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

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nFilSup := 0                   // Fila Superior del marco
       LOCAL nColSup := 0                   // Columna Superior del marco
       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL nTotPer := 0                   // Total Periodos
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nIndice := 0                   // Indice de Cumplimiento

       LOCAL dFecHab := CTOD('00/00/00')    // Fecha de la Habilitaci¢n
       LOCAL cNroAct := ''                  // Acta de Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL cIndic1 := ''                  // Indicadores del Periodo No.1
       LOCAL cIndic2 := ''                  // Indicadores del Periodo No.2
       LOCAL cIndic3 := ''                  // Indicadores del Periodo No.3
       LOCAL cIndic4 := ''                  // Indicadores del Periodo No.4
       LOCAL cIndic5 := ''                  // Indicadores del Periodo No.5

       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF HAB->(RECCOUNT()) == 0
	  cError('NO EXISTEN RECUPERACIONES PARA NINGUN ESTUDIANTE')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DETALLES DE LAS RECUPERACIONES
       cSavPan := SAVESCREEN(0,0,24,79)
       nFilSup := 07
       nColSup := 24
       nFilInf := nFilSup+7
       nColInf := 60

       nNroFil := nMarco(nFilSup,'DETALLES PARA EL ACTA :',;
			 nFilInf,'°',,nColSup,nColInf)

       SETCURSOR(1)
       dFecHab := CTOD('00/00/00')
       cNroAct := SPACE(06)
       @ nNroFil,nColSup+2   SAY 'FECHA PARA EL ACTA:' GET dFecHab;
						       WHEN  {||HelpRead('FECHA')}
       @ nNroFil+1,nColSup+2 SAY 'NUMERO DEL ACTA   :' GET cNroAct
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN DETALLES DE LAS RECUPERACIONES

*>>>>ANALISIS DE DECISION
       IF !lPregunta('SE VAN A HACER CALCULOS CON EL METODO No. '+;
		     TCO->cCalHabTbl+'.DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       nNroPer := nTotPer
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DE LAS NOTAS DE LAS MATERIAS
       SELECT HAB
       HAB->(DBGOTOP())
       DO WHILE .NOT. HAB->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('GRUPO:'+HAB->cCodigoGru+;
			'ºNo. '+HAB->(STR(RECNO(),4))+'/'+;
				HAB->(STR(RECCOUNT(),4))+;
			'ºCALCULO DE MATERIAS',cNomSis)
**********FIN LINEA DE ESTADO

**********ANALISIS DE DECISION
	    IF SUBS(HAB->cCodigoMat,3,2) == '00' .AND.;
	       TCO->cCalHabTbl == '102'
	       HAB->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,HAB->cCodigoGru),;
			 'PLA',NIL,lShared) .OR.;
		!lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
					   'NT'+HAB->cCodigoGru+cAnoSis+ExtFile,;
					   'NOT',NIL,lShared)
		HAB->(DBSKIP())
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroPer)
	    IF !lLocCodigo('cCodigoEst','NOT',HAB->cCodigoEst)
		HAB->(DBSKIP())
		LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE

**********ANALISIS DE LA MATERIA VARIABLE
	    cCodigoTma := HAB->cCodigoMat
	    IF lMatVarMat(cCodigoTma)
	       cCodigoTma := MAT->cCodigoMat
	    ENDIF
**********FIN ANALISIS DE LA MATERIA VARIABLE

**********CALCULO DE LA NOTA DE RECUPERACION. MATERIA
	    DO CASE
	    CASE TCO->cCalHabTbl == '102'  // Indice de Cumplimiento

*================CAMPO DE INDICADORES
		   cIndic1 := &('NOT->cJ1'+cCodigoTma+'Not')
		   cIndic2 := &('NOT->cJ2'+cCodigoTma+'Not')
		   cIndic3 := &('NOT->cJ3'+cCodigoTma+'Not')
		   cIndic4 := &('NOT->cJ4'+cCodigoTma+'Not')
		   cIndic5 := &('NOT->cJ5'+cCodigoTma+'Not')
*================FIN CAMPO DE INDICADORES

*================INDICE DE CUMPLIMIENTO. MATERIA
		   nIndice := 0
		   cNotDef := cJvfCal102(cIndic1,;
					 cIndic2,;
					 cIndic3,;
					 cIndic4,;
					 cIndic5,;
					 nNroPer,nTotPer,;
					 @nIndice,HAB->cCodigoMat)+SPACE(03)
*================FIN INDICE DE CUMPLIMIENTO. MATERIA

*================GRABACION DE LA HABILITACION
		   SELECT NOT
		   IF NOT->(lRegLock(lShared,.F.))
		      REPL &('cHa'+cCodigoTma+'Not') WITH cNotDef+DTOC(dFecHab)+cNroAct
		      NOT->(DBCOMMIT())
		   ELSE
		      cError('NO SE PUEDE GRABAR LAS NOTAS')
		   ENDIF
		   IF lShared
		      NOT->(DBUNLOCK())
		   ENDIF
*================FIN GRABACION DE LA HABILITACION

	    CASE TCO->cCalHabTbl == '103'  // Indice de Cumplimiento. Variable

*================CAMPO DE INDICADORES
		   cIndic1 := &('NOT->cJ1'+cCodigoTma+'Not')
		   cIndic2 := &('NOT->cJ2'+cCodigoTma+'Not')
		   cIndic3 := &('NOT->cJ3'+cCodigoTma+'Not')
		   cIndic4 := &('NOT->cJ4'+cCodigoTma+'Not')
		   cIndic5 := &('NOT->cJ5'+cCodigoTma+'Not')
*================FIN CAMPO DE INDICADORES

*================INDICE DE CUMPLIMIENTO VARIABLE
		   nIndice := 0
		   IF SUBS(cCodigoTma,3,2) == '00'

		      cNotDef := cJvfAre103(HAB->cCodigoGru,;
					    aNotAre,aNotMat,;
					    nNroPer,;
					    nNroPer,;
					    cCodigoTma,@aTotErr)
		      cNotDef := ALLTRIM(cNotDef)+SPACE(03)

		   ELSE
		      cNotDef := cJvfCal103(cIndic1,;
					    cIndic2,;
					    cIndic3,;
					    cIndic4,;
					    cIndic5,;
					    nNroPer,nNroPer,;
					    @nIndice,HAB->cCodigoMat)+SPACE(03)
		   ENDIF
*================FIN INDICE DE CUMPLIMIENTO VARIABLE

*================GRABACION DE LA HABILITACION
		   SELECT NOT
		   IF NOT->(lRegLock(lShared,.F.))
		      REPL &('cHa'+cCodigoTma+'Not') WITH cNotDef+DTOC(dFecHab)+cNroAct
		      NOT->(DBCOMMIT())
		   ELSE
		      cError('NO SE PUEDE GRABAR LAS NOTAS')
		   ENDIF
		   IF lShared
		      NOT->(DBUNLOCK())
		   ENDIF
*================FIN GRABACION DE LA HABILITACION

	    OTHERWISE
		 cError('NO SE CALCULA LA NOTA RECUPERACION No.'+TCO->cCalHabTbl)

	    ENDCASE
**********FIN CALCULO DE LA NOTA DE RECUPERACION. MATERIA

	  SELECT HAB
	  HAB->(DBSKIP())

       ENDDO
       CloseDbf('PLA')
       CloseDbf('NOT')
*>>>>FIN CALCULO DE LAS NOTAS DE LAS MATERIAS

*>>>>CALCULO DE LAS NOTAS DE LAS AREAS
       SELECT HAB
       HAB->(DBGOTOP())
       DO WHILE .NOT. HAB->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('GRUPO:'+HAB->cCodigoGru+;
			'ºNo. '+HAB->(STR(RECNO(),4))+'/'+;
				HAB->(STR(RECCOUNT(),4))+;
			'ºCALCULO DE AREAS',cNomSis)
**********FIN LINEA DE ESTADO

**********ANALISIS DE DECISION
	    IF SUBS(HAB->cCodigoMat,3,2) # '00'
	       HAB->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,HAB->cCodigoGru),;
			 'PLA',NIL,lShared) .OR.;
		!lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
					   'NT'+HAB->cCodigoGru+cAnoSis+ExtFile,;
					   'NOT',NIL,lShared)
		HAB->(DBSKIP())
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroPer)
	    IF !lLocCodigo('cCodigoEst','NOT',HAB->cCodigoEst)
		HAB->(DBSKIP())
		LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE

**********ANALISIS DE LA MATERIA VARIABLE
	    cCodigoTma := HAB->cCodigoMat
**********FIN ANALISIS DE LA MATERIA VARIABLE

**********CALCULO DE LA NOTA DE RECUPERACION. MATERIA
	    DO CASE
	    CASE TCO->cCalHabTbl == '102'  // Indice de Cumplimiento

*================INDICE DE CUMPLIMIENTO. MATERIA
		   cNotDef := cJvfAre102(HAB->cCodigoGru,aNotAre,aNotMat,;
					 nNroPer,;
					 nTotPer,;
					 cCodigoTma)

		   cNotDef := ALLTRIM(cNotDef)+SPACE(03)
*================FIN INDICE DE CUMPLIMIENTO. MATERIA

*================GRABACION DE LA HABILITACION
		   SELECT NOT
		   IF NOT->(lRegLock(lShared,.F.))
		      REPL &('cHa'+cCodigoTma+'Not') WITH cNotDef+DTOC(dFecHab)+cNroAct
		      NOT->(DBCOMMIT())
		   ELSE
		      cError('NO SE PUEDE GRABAR LAS NOTAS')
		   ENDIF
		   IF lShared
		      NOT->(DBUNLOCK())
		   ENDIF
*================FIN GRABACION DE LA HABILITACION

	    ENDCASE
**********FIN CALCULO DE LA NOTA DE RECUPERACION. MATERIA

	  SELECT HAB
	  HAB->(DBSKIP())

       ENDDO
       CloseDbf('PLA')
       CloseDbf('NOT')
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CALCULO DE LAS NOTAS DE LAS MATERIAS
