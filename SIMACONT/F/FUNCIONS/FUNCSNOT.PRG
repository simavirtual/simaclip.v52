/*                     SISTEMA CONTABILIDAD ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO NOTAS

REQUERIMIENTOS:

- Compilar: clipper FuncsNot /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo profesor

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo Notas

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfNot(PathNot,FileNot,lHayJnt,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     PathNot				    // Path del Archivo
       FileNot				    // Nombre del Archivo
       lHayJnt                              // .T. Hay notas en los juicios valortativos
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivo Compartido
       LOCAL PathAct := ''                  // Path Actual
       LOCAL cPorcen := ''                  // Porcentaje para la materia
       LOCAL aDbfNot := {{"cCodigoEst","Character", 06,0},; // C¢digo del Estudiante.
			 {"nNroLisEst","Numeric"  , 03,0},; // N£mero de lista
			 {"lRetGruNot","Logical"  , 01,0},;
			 {"cNroPedNot","Character", 08,0},;
			 {"nAproboNot","Numeric"  , 02,0},;
			 {"cMatHabNot","Character", 08,0},;
			 {"cNotHabNot","Character", 08,0},;
			 {"dFecHa1Not","Date"     , 08,0},;
			 {"dFecHa2Not","Date"     , 08,0},;
			 {"cHorHabNot","Character", 20,0},;
			 {"cActHabNot","Character", 08,0},;
			 {"cPromedNot","Character", 32,0},;
			 {"cPuestoNot","Character", 08,0},;
			 {"cObservNot","Character",100,0},;
			 {"nCamTemNot","Numeric"  , 04,1}}

/* nAproboNot = 0 Por definir
		1 Reprobado
		2 Aprobado
		3 Aprobado por promedio
		4 Habilita
		5 No Termino */

*>>>>FIN DECLARACION DE VARIABLES

*>>>>ADICION DE CAMPOS SEGUN EL PLAN ACADEMICO
       lHayJnt := IF(lHayJnt==NIL,.F.,lHayJnt)
       SELECT PLA
       GO TOP
       DO WHILE .NOT. EOF()

	  IF SUBS(PLA->cCodigoMat,3,2) = '00'

	     AADD(aDbfNot,{"cAre"+;
			    PLA->cTipArePla+;
			    SUBS(PLA->cCodigoMat,1,2)+;
			    "Not",;
			    "Character",20,0})
	   *ÀCampo de Notas para el Area

	     AADD(aDbfNot,{"cAre"+;
			    PLA->cTipArePla+;
			    SUBS(PLA->cCodigoMat,1,2)+;
			    "Rec",;
			    "Character",20,0})
	   *ÀCampo de Notas de Recuperaci¢n para el Area

	     IF PLA->cTipArePla == 'P'
		AADD(aDbfNot,{"cProm"+;
			       SUBS(PLA->cCodigoMat,1,2)+;
			       "Not",;
			       "Character",16,0})

		AADD(aDbfNot,{"cAcum"+;
			       SUBS(PLA->cCodigoMat,1,2)+;
			       "Not",;
			       "Character",20,0})

		cPorcen := IF(PLA->nPorcenPla == 0,;
			      '100','0'+STR(PLA->nPorcenPla,2))

		AADD(aDbfNot,{"cAc"+PLA->cCodigoMat+"Not","Character",26,0})  // Estaba en 22 + 4=26

		AADD(aDbfNot,{"cNt"+PLA->cCodigoMat+cPorcen,"Character",22,0})
		AADD(aDbfNot,{"cNt"+PLA->cCodigoMat+"Rec","Character",20,0}) // Notas de Recuperaci¢n

		AADD(aDbfNot,{"cJ1"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN1"+PLA->cCodigoMat+"Not","Character",160,0}) // 20*8=160   => 1-4=Nota Numerica 5-8=Nota de Recuperaci¢n
		ENDIF
	      *ÀPrimer periodo

		AADD(aDbfNot,{"cJ2"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN2"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀSegundo periodo

		AADD(aDbfNot,{"cJ3"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN3"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀTercer periodo

		AADD(aDbfNot,{"cJ4"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN4"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀCuarto periodo

		AADD(aDbfNot,{"cJ5"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN5"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀQuinto periodo

	     ELSE
		AADD(aDbfNot,{"cJ1"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN1"+PLA->cCodigoMat+"Not","Character",160,0}) // 20*8=160   => 1-4=Nota Numerica 5-8=Nota de Recuperaci¢n
		ENDIF
	      *ÀPrimer periodo

		AADD(aDbfNot,{"cJ2"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN2"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀSegundo periodo

		AADD(aDbfNot,{"cJ3"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN3"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀTercer periodo

		AADD(aDbfNot,{"cJ4"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN4"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀCuarto periodo

		AADD(aDbfNot,{"cJ5"+PLA->cCodigoMat+"Not","Character",125,0})
		IF lHayJnt
		   AADD(aDbfNot,{"cN5"+PLA->cCodigoMat+"Not","Character",160,0})
		ENDIF
	      *ÀQuinto periodo
	     ENDIF

	     AADD(aDbfNot,{"cFa"+PLA->cCodigoMat+"Not","Character",10,0})
	     AADD(aDbfNot,{"cHa"+PLA->cCodigoMat+"Not","Character",20,0})  // 9999 99/99/9999 999999

	  ELSE

	     cPorcen := IF(PLA->nPorcenPla == 0,;
			   '100','0'+STR(PLA->nPorcenPla,2))

	     AADD(aDbfNot,{"cNt"+PLA->cCodigoMat+cPorcen,"Character",22,0})
	     AADD(aDbfNot,{"cNt"+PLA->cCodigoMat+"Rec","Character",20,0}) // Notas de Recuperaci¢n
	     AADD(aDbfNot,{"cAc"+PLA->cCodigoMat+"Not","Character",26,0}) // Estaba en 22 + 4=26

	     AADD(aDbfNot,{"cJ1"+PLA->cCodigoMat+"Not","Character",125,0}) // 20*6=120+5 => 1-4=Indicador 5=Juicio Valorativo 6=Recuperaci¢
	     IF lHayJnt
		AADD(aDbfNot,{"cN1"+PLA->cCodigoMat+"Not","Character",160,0}) // 20*8=160   => 1-4=Nota Numerica 5-8=Nota de Recuperaci¢n
	     ENDIF
	   *ÀPrimer periodo

	     AADD(aDbfNot,{"cJ2"+PLA->cCodigoMat+"Not","Character",125,0}) //   1-4   = Codigo del Indicador. Ej: 1001
	     IF lHayJnt
		AADD(aDbfNot,{"cN2"+PLA->cCodigoMat+"Not","Character",160,0})
	     ENDIF
	   *ÀSegundo periodo

	     AADD(aDbfNot,{"cJ3"+PLA->cCodigoMat+"Not","Character",125,0}) //    5    = C¢digo de Evaluaci¢n  Ej: i
	     IF lHayJnt
		AADD(aDbfNot,{"cN3"+PLA->cCodigoMat+"Not","Character",160,0})
	     ENDIF
	   *ÀTercer periodo

	     AADD(aDbfNot,{"cJ4"+PLA->cCodigoMat+"Not","Character",125,0}) //    6    = Recuperaci¢n de la Evaluaci¢n. Ej: A
	     IF lHayJnt
		AADD(aDbfNot,{"cN4"+PLA->cCodigoMat+"Not","Character",160,0})
	     ENDIF
	   *ÀCuarto periodo

	     AADD(aDbfNot,{"cJ5"+PLA->cCodigoMat+"Not","Character",125,0}) //
	     IF lHayJnt
		AADD(aDbfNot,{"cN5"+PLA->cCodigoMat+"Not","Character",160,0})
	     ENDIF
	   *ÀQuinto periodo

	     AADD(aDbfNot,{"cFa"+PLA->cCodigoMat+"Not","Character",10,0})  //
	     AADD(aDbfNot,{"cHa"+PLA->cCodigoMat+"Not","Character",20,0})
	  ENDIF

	  SKIP

       ENDDO
*>>>>FIN ADICION DE CAMPOS SEGUN EL PLAN ACADEMICO

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfNot
          RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathNot) == 0
	    DBCREATE(FileNot,aDbfNot,"DBFNTX")

       CASE DIRCHANGE(PathNot) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathNot)

       CASE DIRCHANGE(PathNot) == -5
	    cError('NO TIENE DERECHOS EN: '+PathNot)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDA LA EXISTENCIA DE LOS CLIENTES           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 17/95 JUE A
       Colombia, Bucaramanga        INICIO: 11:45 PM   MAY 17/95 JUE

OBJETIVOS:

1)- Debe estar en uso el archivo de Grupos

2)- Valida la existencia de los archivos de notas

3)- Retorna .T. si existen los archivos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFilesNot(cPatSis,cAnoSis)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis                              // Path del sistema
       cAnoSis                              // A¤o del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lExiste := .F.                 // .T. Existen los Clientes
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO NOTAS
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\NOTAS") == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\NOTAS") == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO NOTAS")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\NOTAS") == -3
	    DIRMAKE(cPatSis+"\NOTAS")
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO NOTAS

*>>>>VALIDACION DE EXISTENCIA DE LAS NOTAS
       SELECT GRU
       GO TOP
       DO WHILE .NOT. EOF()

**********VERIFICACION DE EXISTENCIA
	    lExiste := .T.
	    DO CASE
	    CASE FILE (cPatSis+'\NOTAS\NT'+GRU->cCodigoGru+cAnoSis+ExtFile)
		 EXIT
	    OTHERWISE
		 lExiste := .F.
	    ENDCASE
**********FIN VERIFICACION DE EXISTENCIA

	  SKIP

       ENDDO
       RETURN lExiste
*>>>>VALIDACION DE EXISTENCIA DE LAS NOTAS

/*************************************************************************
* TITULO DEL PROGRAMA..: DETERMINACION DE LOS PUESTOS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/95 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 AM   JUL 03/95 LUN

OBJETIVOS:

1- Determina el puesto del estudiante

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Graba el puesto del estudiante

4- Retorna .T. si pudo ordenar

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPuestos(lShared,cPatSis,cNomUsr,cCodGru,nNroBis,cAnoSis,cNomSis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       cPatSis                              // Path del sistema
       cNomUsr                              // Nombre del usuario
       cCodGru                              // C¢digo del grupo
       nNroBis                              // N£mero del bimestre
       cAnoSis                              // A¤o del sistema
       cNomSis                              // Nombre del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL     i,j := 0                   // Contador
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nProBis := 99                  // Promedio del bimestre
       LOCAL nNroPue := 0                   // N£mero del puesto
       LOCAL aPromed := {}                  // Promedio de los Estudiantes
       LOCAL aPuesto := {}                  // Puestos de los Estudiantes
       LOCAL nProAnt := 0                   // Promedio Anterior
       LOCAL nPromed := 0                   // Promedio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
		      'NT'+cCodGru+cAnoSis+ExtFile,;
		      'NOT',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		 cCodGru+' EN '+cPatSis+'\NOTAS')
	 CLOSE NOT
	 RETURN lHayErr
      ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PROMEDIOS DEL PERIODO
       aPromed := {}
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. EOF()

	  IF !NOT->lRetGruNot
	     AADD(aPromed,{NOT->cCodigoEst,;
			   VAL(SUBS(NOT->cPromedNot,nNroBis*4-3,4))})
	  ENDIF
	  NOT->(DBSKIP())

       ENDDO
*>>>>FIN LECTURA DE LOS PROMEDIOS DEL PERIODO

*>>>>ASIGNACION DE LOS PUESTOS
       ASORT(aPromed,,,{|x,y|x[2] > y[2]})

       aPuesto := {}
       j := 1
       nProAnt := aPromed[1,2]
       FOR i := 1 TO LEN(aPromed)
	   nPromed := aPromed[i,2]
	   IF nProAnt # nPromed
	      nProAnt := nPromed
	      j++
	   ENDIF
	   AADD(aPuesto,{aPromed[i,1],j})
       ENDFOR
*>>>>FIN ASIGNACION DE LOS PUESTOS

*>>>>GRABACION DEL PUESTO DE LOS ESTUDIANTES
       SELECT NOT
       GO TOP
       DO WHILE .NOT. EOF()

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('ºPUESTOS PARA EL GRUPO: '+GRU->cCodigoGru+;
			 'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			  NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********AVANCE DEL SIGUIENTE PUESTO
		  i := ASCAN(aPuesto,{|x|x[1] == NOT->cCodigoEst})
	    nNroPue := aPuesto[i,2]
**********FIN AVANCE DEL SIGUIENTE PUESTO

**********GRABACION DEL REGISTRO
	  IF NOT->(lRegLock(lShared,.F.))
	     REPL NOT->cPuestoNot WITH;
		  STUFF(NOT->cPuestoNot,nNroBis*2-1,2,STR(nNroPue,2))
	     NOT->(DBCOMMIT())
	  ELSE
	     cError('NO SE PUEDE GRABA EL PUESTO DEL ESTUDIANTE '+;
		    'CON CODIGO: '+NOT->cCodigoEst)
	     lHayErr := .T.
	  ENDIF
	  IF lShared
	     NOT->(DBUNLOCK())
	  ENDIF
**********FIN GRABACION DEL REGISTRO

	  nProBis := NOT->nCamTemNot
	  SELECT NOT
	  SKIP

       ENDDO

       CloseDbf('NOT')
       RETURN !lHayErr
*>>>>FIN GRABACION DEL PUESTO DE LOS ESTUDIANTES

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE ARCHIVO TEMPORAL DE HABILITACIONES *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUE 12/95 JUE A
       Bucaramanga,Colombia         INICIO: 08:50 AM   JUE 12/95 JUE

OBJETIVOS:

1- Debe estar en uso los archivos de materias, profesores,alumnos y grupos

2- Crea un archivo temporal con las habilitaciones de los grupos
    especificados.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraHabTem(cNomSis,cNomUsr,cPatSis,cAnoUsr,nRegIni,nRegFin,nTotPer)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                             // Nombre del sistema
       cNomUsr                             // Nombre del usuario
       cPatSis                             // Path del sistema
       cAnoUsr                             // A¤o del sistema
       nRegIni                             // Registro inicial del grupo
       nRegFin                             // Registro Final del grupo
       nTotPer                             // Total de Periodos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL PathArc := ''		    // Path del Archivo
       LOCAL cNomArc := ''		    // Nombre del Archivo
       LOCAL FileNtx := ''		    // Archivo de Indices
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema

       LOCAL lShared := .T.                 // .T. Archivo Compartido
       LOCAL PathAct := ''                  // Path Actual

       LOCAL       i := 0                   // Contador
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lAgrega := .F.                 // .T. Agrega registro
       LOCAL cAreUno := ''                  // Area a Habilitar No. 1
       LOCAL cAreDos := ''                  // Area a Habilitar No. 2
       LOCAL cNotHab := ''                  // Notas de las habilitaciones
       LOCAL cCodMat := ''                  // C¢digo de la materia
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTpr := ''               // C¢digo del profesor
       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cCodigoTma := ''               // C¢digo de la materia

       LOCAL aDbfUno := {{"cCodigoGru","Character",04,0},;
			 {"cCodigoEst","Character",06,0},;
			 {"cNombreEst","Character",50,0},;
			 {"cDocNitEst","Character",15,0},;
			 {"cLugNitEst","Character",20,0},;
			 {"cCodUnoUno","Character",04,0},;
			 {"cAreUnoUno","Character",30,0},;
			 {"cTitUnoUno","Character",08,0},;
			 {"cNotUnoUno","Character",04,0},;
			 {"dFecUnoUno","Date"     ,08,0},;
			 {"cActUnoUno","Character",04,0},;
			 {"cCodDosUno","Character",04,0},;
			 {"cAreDosUno","Character",30,0},;
			 {"cTitDosUno","Character",08,0},;
			 {"cNotDosUno","Character",04,0},;
			 {"dFecDosUno","Date"     ,08,0},;
			 {"cActDosUno","Character",04,0}}

       LOCAL aDbfDos := {{"cCodigoGru","Character",04,0},;
			 {"cCodigoEst","Character",06,0},;
			 {"cNombreEst","Character",50,0},;
			 {"cCodigoMat","Character",04,0},;
			 {"cNombreMat","Character",30,0},;
			 {"cTituloMat","Character",08,0},;
			 {"cCodigoPro","Character",06,0},;
			 {"cNombrePro","Character",50,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathArc := DIRNAME()
       FileNtx := NIL

       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(FileTem+SUBS(cNomUsr,1,3)+'.UNO',aDbfUno,"DBFNTX")
	    DBCREATE(FileTem+SUBS(cNomUsr,1,3)+'.DOS',aDbfDos,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.UNO','UNO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.DOS','DOS',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS TEMPORALES')
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS ESTUDIANTES QUE HABILITAN
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'PROCESANDO LOS HABILITANTES')
       Termometro(1)

       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PROCESANDO GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO TERCERO '+;
				     'CUARTO  QUINTO  SEXTO   SEPTIMO '+;
				     'OCTAVO  NOVENO  DECIMO  UNDECIMO',;
				  (VAL(SUBS(GRU->cCodigoGru,1,2))+1)*8-7,8)))
		RETURN NIL
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
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nTotPer)
**********FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT NOT
	    GO TOP
	    DO WHILE .NOT. NOT->(EOF())

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

/*
*--------------ANALISIS SI EL ESTUDIANTE HABILITA
		 IF NOT->nAproboNot # 4
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE HABILITA
*/

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
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------GRABACION DE LAS AREAS
		 IF !EMPTY(NOT->cMatHabNot)

		      cAreUno := SUBS(NOT->cMatHabNot,1,4)
		      cAreDos := SUBS(NOT->cMatHabNot,5,4)
		      cNotHab := NOT->cNotHabNot

		      FOR i := 1 TO LEN(aNotAre)

			 lAgrega := .F.
			 IF aNotAre[i,2] == SUBS(cAreUno,1,2)
			    lAgrega := .T.
			 ENDIF

			 IF aNotAre[i,2] == SUBS(cAreDos,1,2) .OR. lAgrega
			   IF UNO->(lRegLock(lShared,lAgrega))
			      IF lAgrega
				 REPL UNO->cCodigoGru WITH GRU->cCodigoGru
				 REPL UNO->cCodigoEst WITH ALU->cCodigoEst
				 REPL UNO->cNombreEst WITH cNombreTes
				 REPL UNO->cDocNitEst WITH ALU->cDocNitEst
				 REPL UNO->cLugNitEst WITH ALU->cLugNitEst
				 REPL UNO->cCodUnoUno WITH cAreUno
				 REPL UNO->cAreUnoUno WITH aNotAre[i,3]
				 REPL UNO->cTitUnoUno WITH aNotAre[i,7]
				 REPL UNO->cNotUnoUno WITH SUBS(cNotHab,1,4)
				 REPL UNO->dFecUnoUno WITH NOT->dFecHa1Not
				 REPL UNO->cActUnoUno WITH SUBS(NOT->cActHabNot,1,4)
			      ELSE
				 REPL UNO->cCodigoGru WITH GRU->cCodigoGru
				 REPL UNO->cCodigoEst WITH ALU->cCodigoEst
				 REPL UNO->cNombreEst WITH cNombreTes
				 REPL UNO->cCodDosUno WITH cAreUno
				 REPL UNO->cAreDosUno WITH aNotAre[i,3]
				 REPL UNO->cTitDosUno WITH aNotAre[i,7]
				 REPL UNO->cNotDosUno WITH SUBS(cNotHab,5,4)
				 REPL UNO->dFecDosUno WITH NOT->dFecHa2Not
				 REPL UNO->cActDosUno WITH SUBS(NOT->cActHabNot,5,4)
			      ENDIF
			   ELSE
			      cError('NO SE GRABA EL REGISTRO DE HABILITANTES')
			   ENDIF
			   DBUNLOCK()
			ENDIF
		      ENDFOR

		 ENDIF
*--------------FIN GRABACION DE LAS AREAS

*--------------GRABACION DE LAS MATERIAS
		 IF !EMPTY(NOT->cMatHabNot)

		    cAreUno := SUBS(NOT->cMatHabNot,1,4)
		    cAreDos := SUBS(NOT->cMatHabNot,5,4)

		    FOR i:=1 TO LEN(aNotMat)

		       IF aNotMat[i,1] == SUBS(cAreUno,1,2) .OR.;
			  aNotMat[i,1] == SUBS(cAreDos,1,2)

			     cCodMat := SUBS(aNotMat[i,4],9,4)
			  cCodigoTpr := ''
			  cNombreTpr := cNomProMat(cCodMat,GRU->cCodigoGru,;
						   @cCodigoTpr)
			  cCodigoTma := SUBS(aNotMat[i,4],9,4)

			  IF DOS->(lRegLock(lShared,.T.))
			     REPL DOS->cCodigoGru WITH GRU->cCodigoGru
			     REPL DOS->cCodigoEst WITH ALU->cCodigoEst
			     REPL DOS->cNombreEst WITH cNombreTes
			     REPL DOS->cCodigoMat WITH cCodMat
			     REPL DOS->cNombreMat WITH aNotMat[i,2]
			     REPL DOS->cTituloMat WITH aNotMat[i,7]
			     REPL DOS->cCodigoPro WITH cCodigoTpr
			     REPL DOS->cNombrePro WITH cNombreTpr
			  ELSE
			     cError('NO SE GRABA EL REGISTRO DE HABILITANTES')
			  ENDIF
			  DBUNLOCK()
		       ENDIF

		    ENDFOR

		 ENDIF
*--------------FIN GRABACION DE LAS MATERIAS

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 NOT->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********IMPRESION DEL CUERPO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    CLOSE NOT
	    CLOSE PLA
	  *ÀCierre de archivos

	    SELECT GRU
	    nAvance := INT(( GRU->(RECNO()) / nRegFin )*100)
	    Termometro(nAvance)
	    GRU->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CLOSE UNO
       CLOSE DOS
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: NOTA CUALITATIVA A TEXTO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 15/2008 MIE A
       Bucaramanga,Colombia         INICIO: 10:30 AM   MAR 15/2008 MIE

OBJETIVOS:

1- Convierta la nota cualitativa en Texto

2- Retorna el texto de la nota

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTxtNota(cNota,lSpaces)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNota                                // Nota Cualitativa
       lSpaces                              // .T. Hay Espacios */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtNot := ''                  // Texto de la Nota
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lSpaces := IF(EMPTY(lSpaces),.F.,lSpaces)
       IF lLocCodigo('cCodigoJvf','JVF',ALLTRIM(cNota))
	  cTxtNot := JVF->cNombreJvf
       ELSE
	  DO CASE
	  CASE 'NP' $ cNota
	       cTxtNot := '*NO SE PRESENTO'

	  CASE EMPTY(cNota) .AND. .NOT. lSpaces
	       cTxtNot := 'SIN NOTA     '

	  OTHERWISE
	      cTxtNot := cNota
	  ENDCASE
       ENDIF
       RETURN cTxtNot
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO ..: MATERIAS POR HABILITAR CON SELECCION                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2000 LUN A
       Colombia, Bucaramanga        INICIO: 11:05 AM   MAY 29/2000 LUN

OBJETIVOS:

1- Crea un vector con las asignaturas que tienen recuperaciones
   o Habilitaci¢n teniendo en cuenta las asignaturas selectivas.

3- Retorna el Vector

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aMatHabSel(cCodEst,cCodGru,nCodApr,aNotAre,aNotMat,nTotPer,lNotNum)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cCodGru                              // C¢digo del Grupo
       nCodApr                              // C¢digo de Aprobaci¢n
       aNotAre                              // Detalles de las Areas
       aNotMat                              // Detalles de las Materias
       nTotPer                              // Total de Periodos
       lNotNum                              // .T. Nota N£merica .F. Nota Cualitativa */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j := 0                       // Contadores

       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL dFecHab := CTOD('00/00/00')    // Fecha de la Habilitaci¢n
       LOCAL cNroAct := ''                  // N£mero del Acta.
       LOCAL cNotHab := ''                  // Nota de la Habilitaci¢n
       LOCAL cNota   := ''                  // Nota de area o materia
       LOCAL cCamHab := ''                  // Campo de la Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva materia o area
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cCodJvf := ''                  // C¢digo de la Nota
       LOCAL lAprobo := .F.                 // .T. Aprobo

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del Profesor
       LOCAL cApelliTpr := ''               // Apellido del Profesor

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA RECUPERACION
       IF lLocCodigo('nCodigoApr','APR',nCodApr)

	  IF .NOT. APR->lHayHabApr
	     RETURN aMatHab
	  ENDIF

       ELSE
	  RETURN aMatHab
       ENDIF
*>>>>FIN ANALISIS DE LA RECUPERACION

*>>>>MATERIAS POR RECUPERAR
       FOR i := 1 TO LEN(aNotAre)

***********ANALISIS DE LA MATERIA NO RECUPERABLE
	     IF aNotAre[i][15]
		LOOP
	     ENDIF
***********FIN ANALISIS DE LA MATERIA NO RECUPERABLE

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------LECTURA DE LA NOTA DEL AREA
		 cCodigoTma := SUBS(aNotAre[i,6],9,4)
		 cNombreTma := aNotAre[i,3]

		 cCamNotDef := aNotAre[i,4]
		 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		 cNotDef := ALLTRIM(SUBS(&cCamNotDef,nTotPer*4-3,4))
		 cNotRec := ALLTRIM(SUBS(&cCamNotRec,nTotPer*4-3,4))
		 IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		    cNotDef := cNotRec
		 ENDIF

		 cNotDef := cNotDef(cNotDef,lNotNum) //Modificado

		 cCodJvf := ''
		 lAprobo := IF(cAproboJvf(cNotDef,,@cCodJvf) = 'N',.F.,.T.)
		 cCodJvf := UPPER(ALLTRIM(cCodJvf))

*		 IF cNotDef # 'I' .AND. cNotDef # 'D'
		 IF lAprobo
		    LOOP
		 ELSE
		    IF UPPER(ALLTRIM(cNotDef)) # cCodJvf
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------DETALLES DE LA HABILITACION
		 cCamHab := 'NOT->cHa'+cCodigoTma+'Not'
		 cNotHab := ALLTRIM(SUBS(&cCamHab,1,4))
		 dFecHab := CTOD(SUBS(&cCamHab,5,10))
		 cNroAct := SUBS(&cCamHab,15,6)

		 cCodigoTpr := cCodProMat(cCodEst,cCodGru,nTotPer,;
					  @cCodigoTma,@cNombreTma,;
					  @cNombreTpr,@cApelliTpr)
		 AADD(aMatHab,;
		      {cCodigoTma,cNombreTma,;
		       dFecHab,cNroAct,cNotHab,;
		       cCodigoTpr,cNombreTpr,;
		       cApelliTpr,NOT->nAproboNot})
*--------------FIN DETALLES DE LA HABILITACION

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j := 1 TO LEN(aNotMat)

*...............ANALISIS DE LA MATERIA NO RECUPERABLE
		   IF aNotMat[j,15]
		      LOOP
		   ENDIF
*...............ANALISIS DE LA MATERIA NO RECUPERABLE

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    cNombreTma := aNotMat[j,2]

		    cCamNotDef := aNotMat[j,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nTotPer*4-3,4))
		    cNotRec := ALLTRIM(SUBS(&cCamNotRec,nTotPer*4-3,4))

		    IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF


		    cNotDef := cNotDef(cNotDef,lNotNum) //Modificado

		    cCodJvf := ''
		    lAprobo := IF(cAproboJvf(cNotDef,,@cCodJvf) = 'N',.F.,.T.)
		    cCodJvf := UPPER(ALLTRIM(cCodJvf))

*		    IF cNotDef # 'I' .AND. cNotDef # 'D'
		    IF lAprobo
		       LOOP
		    ELSE
		       IF UPPER(ALLTRIM(cNotDef)) # cCodJvf
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------DETALLES DE LA HABILITACION
		    cCamHab := 'NOT->cHa'+cCodigoTma+'Not'
		    cNotHab := ALLTRIM(SUBS(&cCamHab,1,4))
		    dFecHab := CTOD(SUBS(&cCamHab,5,10))
		    cNroAct := SUBS(&cCamHab,15,6)

		    cCodigoTpr := cCodProMat(cCodEst,cCodGru,nTotPer,;
					     @cCodigoTma,@cNombreTma,;
					     @cNombreTpr,@cApelliTpr)

		    AADD(aMatHab,;
			 {cCodigoTma,cNombreTma,;
			  dFecHab,cNroAct,cNotHab,;
			  cCodigoTpr,cNombreTpr,;
			  cApelliTpr,NOT->nAproboNot})
*-----------------FIN DETALLES DE LA HABILITACION

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

       ENDFOR
       RETURN aMatHab
*>>>>FIN MATERIAS POR RECUPERAR

/*************************************************************************
* TITULO ..: MATERIAS POR HABILITAR SIN SELECCION                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2000 LUN A
       Colombia, Bucaramanga        INICIO: 11:05 AM   MAY 29/2000 LUN

OBJETIVOS:

1- Crea un vector con las asignaturas que tienen grabada la recuperaci¢n
   o Habilitaci¢n sin tener en cuenta las asignaturas selectivas

3- Retorna el Vector

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aMatHabPla(nCodApr,aNotAre,aNotMat,nTotPer,lNotNum,lMatVar)

*>>>>DESCRIPCION DE PARAMETROS
/*     nCodApr                              // C¢digo de Aprobaci¢n
       aNotAre                              // Detalles de las Areas
       aNotMat                              // Detalles de las Materias
       nTotPer                              // Total de Periodos
       lNotNum                              // .T. Nota N£merica .F. Nota Cualitativa
       lMatVar                              // .T. Imprimir Materia Variable */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j := 0                       // Contadores

       LOCAL aHayHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL dFecHab := CTOD('00/00/00')    // Fecha de la Habilitaci¢n
       LOCAL cNroAct := ''                  // N£mero del Acta.
       LOCAL cNotHab := ''                  // Nota de la Habilitaci¢n
       LOCAL cCamHab := ''                  // Campo de la Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva materia o area
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lNoPrnM := .F.                 // .T. No Imprimir .F. Imprimir Materia en Boletin

       LOCAL cCodJvf := ''                  // C¢digo de la Nota
       LOCAL lAprobo := .F.                 // .T. Aprobo

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA RECUPERACION
       IF lLocCodigo('nCodigoApr','APR',nCodApr)
	  IF .NOT. APR->lHayHabApr
	     RETURN aHayHab
	  ENDIF
       ELSE
	  RETURN aHayHab
       ENDIF
*>>>>FIN ANALISIS DE LA RECUPERACION

*>>>>MATERIAS POR RECUPERAR
       lMatVar := IF(lMatVar==NIL,.T.,lMatVar)
       FOR i:=1 TO LEN(aNotAre)

***********ANALISIS DE LA MATERIA NO RECUPERABLE
	     IF aNotAre[i][15]
		LOOP
	     ENDIF
***********FIN ANALISIS DE LA MATERIA NO RECUPERABLE

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------LECTURA DE LA NOTA DEL AREA
		 cCodigoTma := SUBS(aNotAre[i,6],9,4)
		 cNombreTma := aNotAre[i,3]

		 cCamNotDef := aNotAre[i,4]
		 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		 cNotDef := ALLTRIM(SUBS(&cCamNotDef,nTotPer*4-3,4))
		 cNotRec := ALLTRIM(SUBS(&cCamNotRec,nTotPer*4-3,4))
		 IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		    cNotDef := cNotRec
		 ENDIF

		 IF VAL(cNotDef) > 0
		    cNotDef := cNotDef(cNotDef,.T.) //Modificado
		 ENDIF

		 cCodJvf := ''
		 lAprobo := IF(cAproboJvf(cNotDef,,@cCodJvf) = 'N',.F.,.T.)
		 cCodJvf := UPPER(ALLTRIM(cCodJvf))

*		 IF UPPER(cNotDef) # 'I' .AND. UPPER(cNotDef) # 'D'
		 IF lAprobo
		    LOOP
		 ELSE
		    IF UPPER(ALLTRIM(cNotDef)) # cCodJvf
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------ANALISIS DE LA IMPRESION DEL AREA  // mod oct 24/2007
		 IF LEN(aNotAre[i][18]) == 6
		    lNoPrnM := IF(SUBS(aNotAre[i][18],6,1)='1',.T.,.F.)
		 ELSE
		    lNoPrnM := .F. // imprime
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION DEL AREA  // mod oct 24/2007

*--------------DETALLES DE LA HABILITACION
		 IF .NOT. lNoPrnM  // MOD Oct 24/2007

		    cCamHab := 'NOT->cHa'+cCodigoTma+'Not'
		    cNotHab := ALLTRIM(SUBS(&cCamHab,1,4))
		    cNotHab := cNotDef(cNotHab,lNotNum) //Modificado

		    dFecHab := SUBS(&cCamHab,5,10)
		    cNroAct := SUBS(&cCamHab,15,6)
		    AADD(aHayHab,{cCodigoTma,dFecHab,;
				  cNroAct,cNotHab,cNombreTma,;
				  ALLTRIM(APR->cObsNivApr)})
		 ENDIF
*--------------FIN DETALLES DE LA HABILITACION

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

*...............ANALISIS DE LA MATERIA NO RECUPERABLE
		   IF aNotMat[j,15]
		      LOOP
		   ENDIF
*...............ANALISIS DE LA MATERIA NO RECUPERABLE

*...............ANALISIS DE LA IMPRESION DE LA MATERIA  // mod oct 24/2007
		  IF LEN(aNotMat[j][18]) == 6
		     lNoPrnM := IF(SUBS(aNotMat[j][18],6,1)='1',.T.,.F.)
		  ELSE
		     lNoPrnM := .F.   // Imprime
		  ENDIF
		  IF lNoPrnM
		     LOOP
		  ENDIF
*...............FIN ANALISIS DE LA IMPRESION DE LA MATERIA

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------NOMBRE DE LA MATERIA
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    IF lMatVar
		       cNombreTma := aNotMat[j,10]
		     *ÀMateria Notas o Certificado
		    ELSE
		       cNombreTma := aNotMat[j,2]
		    ENDIF
*-----------------FIN NOMBRE DE LA MATERIA

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cCamNotDef := aNotMat[j,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nTotPer*4-3,4))
		    cNotRec := ALLTRIM(SUBS(&cCamNotRec,nTotPer*4-3,4))

		    IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF

		    IF VAL(cNotDef) > 0
		       cNotDef := cNotDef(cNotDef,.T.) //Modificado
		    ENDIF

		    cCodJvf := ''
		    lAprobo := IF(cAproboJvf(cNotDef,,@cCodJvf) = 'N',.F.,.T.)
		    cCodJvf := UPPER(ALLTRIM(cCodJvf))

*		    IF UPPER(cNotDef) # 'I' .AND. UPPER(cNotDef) # 'D'
		    IF lAprobo
		       LOOP
		    ELSE
		       IF UPPER(ALLTRIM(cNotDef)) # cCodJvf
			  LOOP
		       ENDIF
		    ENDIF
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------DETALLES DE LA HABILITACION
		    cCamHab := 'NOT->cHa'+cCodigoTma+'Not'
		    cNotHab := ALLTRIM(SUBS(&cCamHab,1,4))
		    cNotHab := cNotDef(cNotHab,lNotNum) //Modificado

		    dFecHab := SUBS(&cCamHab,5,10)
		    cNroAct := SUBS(&cCamHab,15,6)

		    AADD(aHayHab,{cCodigoTma,dFecHab,;
				  cNroAct,cNotHab,cNombreTma,;
				  ALLTRIM(APR->cObsNivApr)})
*-----------------FIN DETALLES DE LA HABILITACION


	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

       ENDFOR
       RETURN aHayHab
*>>>>FIN MATERIAS POR RECUPERAR

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO          	                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 26/2002 MAR A
       Colombia, Bucaramanga        INICIO: 12:15 AM   FEB 26/2002 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo

2- Se debe pasar el directorio completo de archivo

3- Retorn NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenNot(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivo Grupos

       LOCAL       i := 0                   // Contador
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL nNroPar := 0                   // Parte del archivo a Mostrar
       LOCAL oBrowse := NIL                 // Objeto para el Browse
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatSis+'\'+cMaeAct+'\'+fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

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

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL GRUPO
       cCodigoTgr := cSpaces('GRU','cCodigoGru')
       IF !lLeeCodGru(nFilInf+1,nColInf,@cCodigoTgr,cMaeAct)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseDbf('GRU')
*>>>>FIN LECTURA DEL GRUPO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'\NOTAS\'+;
		      'NT'+cCodigoTgr+cAnoSis+ExtFile,;
		      'NOT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,cCodigoTgr),;
			 'PLA',NIL,lShared)

	  cError('ABRIENDO EL ARCHIVO DE NOTAS Y PLAN DEL GRUPO '+cCodigoTgr)
	  CloseAll()
	  RETURN NIL
      ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CONSULTA DEL REGISTRO DEL ESTUDIANTE
       IF lPregunta('DESEA CONSULTAR POR ESTUDIANTE? No Si')
	  RegNotEst(cMaeAct,nFilPal,cCodigoTgr)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DEL REGISTRO DEL ESTUDIANTE

*>>>>ANALISIS DE DECESION
       nNroPar := 1
       cSavLin := SAVESCREEN(20,00,21,79)
       cCodigoTma := SPACE(04)

       IF lPregunta('DESEA REALIZAR LA CONSULTA POR MATERIA? No Si')

	  @ 21,20 SAY 'CODIGO DE LA MATERIA';
		 GET cCodigoTma PICT '9999';
		 VALID LEN(cCodigoTma) == 4
       ELSE
	  @ 21,20 SAY 'PARTE A VISUALIZAR: <DE 1 A 14?';
		 GET nNroPar PICT '99';
		 VALID nNroPar <= 14
       ENDIF
       READ
       RESTSCREEN(20,00,21,79,cSavLin)
*>>>>FIN ANALISIS DE DECESION

*>>>>VALIDACION DE LA MATERIA
       IF !EMPTY(cCodigoTma)

	  IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	     cError('EL CODIGO '+cCodigoTma+' DE LA MATERIA NO EXISTE')
	     CloseAll()
	     RETURN NIL
	  ENDIF

	  aDbfStr := NOT->(DBSTRUCT())
	  lHayErr := .T.
	  FOR i := 1 TO LEN(aDbfStr)
	      IF SUBS(cCodigoTma,1,2) $ aDbfStr[i,1]
		 lHayErr := .F.
	      ENDIF
	  ENDFOR

	  IF lHayErr
	     cError('EL CODIGO '+cCodigoTma+' '+;
		    'DE LA MATERIA NO EXISTE EN NOTAS')
	     CloseAll()
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE LA MATERIA

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oDefBrwNot(lShared,cAnoUsr,nFilPal+1,00,22,79,;
			     cMaeAct,cCodigoTgr,nNroPar,cCodigoTma)

       SETKEY(K_F9,{||MenuOtrNot(aParam1,aParam2,aParam3,;
				 oBrowse,cCodigoTgr,nNroPar)})

       NOT->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE          	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/2002 MAR A
       Colombia, Bucaramanga        INICIO: 12:15 AM   FEB 25/2002 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwNot(lShared,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
		    cMaeAct,cCodGru,nNroPar,cCodMat)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAct                              // Maestro Actual
       cCodGru                              // C¢digo del Grupo
       nNroPar                              // N£mero de la Parte a Mostrar
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL aStrNot := {}                  // Estructura del Archivo Notas
       LOCAL cCampo  := ''                  // Campo
       LOCAL nDiviso := 0                   // Division por 9
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL nPosFin := 0                   // Posici¢n Final

       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       oBrowse:Cargo := {'<< MANTENIMIENTO DE NOTAS. GRUPO: '+cCodGru+' '+;
			 'A¥O: '+cAnoUsr+' >>',;
			 '<F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT NOT
       oColumn := TBCOLUMNNEW('No.',{||STR( NOT->(RECNO()) ,2)+'-'+NOT->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 1
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOMBRE DEL ESTUDIANTE',;
			      {||cSekNomAlu(NOT->cCodigoEst,cMaeAct,'NOT')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF nNroPar == 1
	  oColumn := TBCOLUMNNEW('No.',{||NOT->nNroLisEst})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NOT'},;
			    {'FIELD','nNroLisEst'},{'PICTURE','999'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       aStrNot := {}
       aStrDbf := NOT->(DBSTRUCT())
       IF !EMPTY(cCodMat)
	  FOR i := 1 TO LEN(aStrDbf)
	      IF cCodMat $ aStrDbf[i,1]
		  AADD(aStrNot,aStrDbf[i])
	      ENDIF
	  ENDFOR
       ENDIF

       IF EMPTY(cCodMat)
	  aStrNot := aStrDbf
	  nDiviso := ROUND(LEN(aStrNot)/14,0)
	  DO CASE
	  CASE nNroPar == 1
	       nPosIni := nNroPar
	       nPosFin := nDiviso
	  CASE nNroPar == 2
	       nPosIni := nDiviso+1
	       nPosFin := 2*nDiviso
	  CASE nNroPar == 14
	       nPosIni := ((nNroPar-1)*nDiviso)+1
	       nPosFin := LEN(aStrNot)
	  OTHERWISE
	       nPosIni := ((nNroPar-1)*nDiviso)+1
	       nPosFin := nNroPar*nDiviso
	  ENDCASE
       ELSE
	  nPosIni := 1
	  nPosFin := LEN(aStrNot)
       ENDIF

       FOR i := nPosIni TO nPosFin
	   cCampo  := aStrNot[i,1]
	   oColumn := TBCOLUMNNEW(ALLTRIM(STR(i,3))+':'+cCampo,{||&cCampo})
	   IF SCO->lPruebaCon
	      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NOT'},;
				{'FIELD',cCampo},{'PICTURE','@X'}}
	   ELSE
	      oColumn:Cargo := {{'MODI',.F.}}
	   ENDIF
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna
       ENDFOR

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE


/*************************************************************************
* TITULO..: MENU OTROS DEL ARCHIVO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:20 PM   MAR 04/2002 LUN

OBJETIVOS:

1- Menu de informes para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrNot(aParam1,aParam2,aParam3,;
		    oBrowse,cCodGru,nNroPar)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       cCodGru                              // C¢digo del Grupo
       nNroPar                              // N£mero de Parte a Visualizar */
*>>>>DESCRIPCION DE PARAMETROS

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
       IF nNroPar == 1
	  AADD(aMenus,'1<NUMERO DE LISTA     >')
	  AADD(aMenus,'2<ORDENA POR LISTA    >')
       ENDIF
       AADD(aMenus,'3<VALIDAR NOTAS       >')
       AADD(aMenus,'4<CODIGOS DE PROMOCION>')

       IF nNroPar == 1
	  AADD(aAyuda,'Obtiene el N£mero de lista de los Estudiantes.')
	  AADD(aAyuda,'Ordena el Archivo por N£mero de Lista')
       ENDIF
       AADD(aAyuda,'Valida las Notas con el Profesor')
       AADD(aAyuda,'Confirma los C¢digos de Promoci¢n')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrNot01(aParam1,aParam2,aParam3,oBrowse)
	  *Graba del archivo el n£mero de lista.

       CASE nNroOpc == 2

	    OrdenaNot(lShared,cAnoUsr,cPatSis,oBrowse,cMaeAct,cCodGru)
	  *ÀOrdenar notas

       CASE nNroOpc == 3
	    OtrNot03(aParam1,aParam2,aParam3,oBrowse,cCodGru)
	  *Valida las notas con el Profesor

       CASE nNroOpc == 4
	    OtrNot04(aParam1,aParam2,aParam3,oBrowse,cCodGru)
	  *Confirma los c¢digo se promoci¢n

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: LECTURA DE LOS NUMEROS DE LISTA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   MAR 04/2002 LUN

OBJETIVOS:

1- Graba en el maestro los n£mero de lista.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrNot01(aParam1,aParam2,aParam3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse			            // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL cNombreTes := ''               // Nombre del Estudiante
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

*>>>>LECTURA DE LOS NUMEROS DE LISTA
       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºREGISTRO No. '+NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL NUMERO DE LISTA
	    SELECT NOT
	    IF lRegLock(lShared,.F.)

	       REPL NOT->nNroLisEst WITH NOT->(RECNO())
	      *Grabaci¢n del n£mero de lista.

	       DBCOMMIT()
	    ELSE
	       cError('NO SE PUEDE GRABAR EL NUMERO DE LISTA')
	    ENDIF

	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL NUMERO DE LISTA

	  SELECT NOT
	  NOT->(DBSKIP())

       ENDDO
       SELECT NOT
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN LECTURA DE LOS NUMEROS DE LISTA

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENAR EL ARCHIVO POR NUMERO DE LISTA         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/99 MAR A
       Colombia, Bucaramanga        INICIO: 11:15 AM   ABR 20/99 MAR


OBJETIVOS:

1- Ordena el archivo de alumnos por el n£mero de lista.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaNot(lShared,cAnoUsr,cPatSis,oBrowse,cMaeAct,cCodGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       oBrowse				    // Browse del Profesor
       cMaeAct                              // Maestro Actual
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       SELECT NOT
       IF RECCOUNT() == 0
	  cError('NO EXISTEN REGISTROS EN EL ARCHIVO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DEL NUMERO DE LISTA
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS DE DECISION
	    IF NOT->nNroLisEst == 0
	       cError('NO SE HAN ASIGNADO TODOS LOS NUMEROS DE LISTA')
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

	  NOT->(DBSKIP())

       ENDDO
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL NUMERO DE LISTA

*>>>>ANALISIS DE DECISION
       cError('DEBE HACER COPIA DE SEGURIDAD DEL DIRECTORIO NOTAS')
       IF !lPregunta('ESTA SEGURO QUE DESEA ORDENAR? No Si')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ORDENACION DEL ARCHIVO
       CloseDbf('NOT')
       IF !lOrdFile(lShared,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		    'NT'+cCodGru+cAnoSis+ExtFile,'nNroLisEst')
	  cError('NO SE ORDENO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		       'NT'+cCodGru+cAnoSis+ExtFile,'NOT',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PROFESORES')
	  RETURN NIL
       ENDIF
       SELECT NOT
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO


/*************************************************************************
* TITULO..: CONSULTA DEL REGISTRO DEL ESTUDIANTE                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 02/2002 MAR A
       Colombia, Bucaramanga        INICIO: 01:30 PM   OCT 02/2002 MAR


OBJETIVOS:

1- Visualiza el registro de notas del estudiante

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RegNotEst(cMaeAct,nFilPal,cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     cMaeAct                              // Maestro Actual
       nFilPal                              // Fila Inferior Men£ principal
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea

       LOCAL       i := 0                   // Contador
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nFilTem := 0                   // Fila Temporal
       LOCAL bMarco  := NIL                 // Code Block del Marco

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL aStrNot := {}                  // Estructura de las notas
       LOCAL cCampos := ''                  // Nombre de Campo

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       bMarco := {||nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES DEL GRUPO:'+cCodGru,22,'°')}
       nNroFil := EVAL(bMarco)

       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>CONSULTA DEL REGISTRO
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

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',cCodigoTes)

	       cError(cNombreTes+ 'COD: '+cCodigoTes+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+&cNalias->cCodigoGru)
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********CONSULTA DEL REGISTRO
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
	    cSavPan := SAVESCREEN(0,0,24,79)

	    aStrNot := NOT->(DBSTRUCT())
	    nFilIni := nMarco(nFilPal+1,'REGISTRO DE '+cNombreTes+' '+;
					'CODIGO:'+cCodigoTes+' '+;
					'GRUPO:'+cCodGru,22,'°')
	    nFilTem := nFilIni+1
	    FOR i := 1 TO LEN(aStrNot)

		cCampos := aStrNot[i][1]
		@ nFilTem,01 SAY cCampos
		nFilTem := Fila(nFilTem+1,bMarco)

		cCampos := 'NOT->'+cCampos
		SET COLOR TO I
		IF UPPER(SUBS(cCampos,6,2)) == 'CJ'

		   @ nFilTem,01 SAY SUBS(&cCampos,1,60)
		   SET COLOR TO
		   nFilTem := Fila(nFilTem+1,bMarco)

		   SET COLOR TO I
		   @ nFilTem,01 SAY SUBS(&cCampos,61,125)
		   SET COLOR TO
		ELSE
		   @ nFilTem,01 SAY &cCampos
		ENDIF
		SET COLOR TO
		nFilTem := Fila(nFilTem+1,bMarco)
	    ENDFOR
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN CONSULTA DEL REGISTRO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   'ESTUDIANTES DEL GRUPO:'+cCodGru,22,'°')

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
       RETURN NIL
*>>>>FIN CONSULTA DEL REGISTRO

/*************************************************************************
* TITULO..: VALIDA LAS NOTAS CON EL PROFESOR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 02/2003 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   OCT 02/2003 LUN

OBJETIVOS:

1- Valida las notas con el Profesor

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrNot03(aParam1,aParam2,aParam3,oBrowse,cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse			            // Browse del Archivo
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL     x,i := 0                   // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL aHayErr := {}                  // Descripci¢n de Errores
       LOCAL aDifNot := {}                  // Diferencias en Notas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cJuiNot := ''                  // Campo del Juicio Valorativo
       LOCAL cDefNot := ''                  // Nota Definitiva
       LOCAL cFalNot := ''                  // Ausencias

       LOCAL cJuiPro := ''                  // Campo del Juicio del Profesor
       LOCAL cDefPro := ''                  // Definitiva del Profesor
       LOCAL cFalPro := ''                  // Ausencias del Profesor

       LOCAL cTxtErr := ''                  // Texto de Error
       LOCAL cPatPro := ''                  // Path del Profesor

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia

       LOCAL cCodigoTca := ''               // C¢digo de la Carga

       LOCAL cCamJuiNot := ''               // Campo Juicios de Notas
       LOCAL cCamDefNot := ''               // Campo definitiva de Notas
       LOCAL cCamRecNot := ''               // Campo recuperaciones de Notas
       LOCAL cCamFalNot := ''               // Campo de Ausencias de Notas

       LOCAL cCamJuiNoP := ''               // Campo Juicio del Profesor
       LOCAL cCamDefNoP := ''               // Campo Notas del Profesor
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR ESTUDIANTES
       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********RECORRIDO POR PERIODOS
	    FOR x := 1 TO 5

*---------------IMPRESION DE LA LINEA DE ESTADO
		  nNroPer := x
		  LineaEstado('Periodo No. '+STR(nNroPer,1)+;
			      'ºREGISTRO No. '+NOT->(STR(RECNO(),2))+'/'+;
			       NOT->(STR(RECCOUNT(),2)),cNomSis)
*---------------FIN IMPRESION DE LA LINEA DE ESTADO

*---------------REEMPLAZO DE LAS ASIGNATURAS VARIABLES
		  aNotAre := {}
		  aNotMat := {}
		  DetAreas(@aNotAre,@aNotMat,nNroPer)
		  IF SEL->(RECCOUNT()) # 0
		     lDetAreEst(@aNotAre,@aNotMat,nNroPer,NOT->cCodigoEst)
		  ENDIF
*---------------FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

*---------------RECORRIDO DEL AREA
		  FOR i:=1 TO LEN(aNotAre)

*---------------------ANALISIS DE LOS NOTAS DEL AREA
			cCodigoTca := ''
			cNombreTma := ''

			IF SUBS(aNotAre[i][4],7,4) == 'AREN'
			   cNombreTma := aNotAre[i,3]
			   cCamJuiNot := aNotAre[i,6]
			   cCamDefNot := aNotAre[i,4]
			   cCamRecNot := STUFF(cCamDefNot,13,3,'Rec')
			   cCamFalNot := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
			   cCodigoTma := aNotAre[i,2]+'00'
			   cCodigoTca := cCodigoTma+cCodGru
			ENDIF

			IF EMPTY(cCodigoTca)
			   LOOP
			ENDIF

			cJuiNot := &cCamJuiNot
			cDefNot := &cCamDefNot
			cDefNot := SUBS(cDefNot,nNroPer*4-3,4)
			cFalNot := &cCamFalNot
*---------------------FIN ANALISIS DE LOS NOTAS DEL AREA

*---------------------LOCALIZACION DE LA CARGA
			cPatPro := ''
			IF !lLocCodigo('cCodigoCar','CAR',cCodigoTca)
			   cTxtErr := 'NO EXISTE LA CARGA'
			   AADD(aHayErr,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,cTxtErr})
			   LOOP
			ENDIF
			cPatPro := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				   CAR->cCodigoPro
*---------------------FIN LOCALIZACION DE LA CARGA

*---------------------SELECION DE LAS AREAS DE TRABAJO
			IF !lUseDbf(.T.,cPatPro+'\'+;
				    FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
			   !lUseDbf(.T.,cPatPro+'\'+;
				    FilePro+ExtFile,'PRO',NIL,lShared)

			   cTxtErr :='ABRIENDO ARCHIVOS PROFESOR '+cPatPro
			   AADD(aHayErr,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,cTxtErr})
			   LOOP
			ENDIF
*---------------------FIN SELECION DE LAS AREAS DE TRABAJO

*---------------------VALIDACION DE LA CARGA DEL PROFESOR
			lHayErr := .T.
			DO CASE
			CASE CAP->(RECCOUNT()) == 0
			     cTxtErr := 'NO APARECE DE CARGA ACADEMICA DE '+;
					 cPatPro

			CASE PRO->(RECCOUNT()) == 0
			     cTxtErr := 'NO APARECE INFORMACION DEL PROFESOR '+;
					 cPatPro

			OTHERWISE
			     lHayErr :=.F.
			ENDCASE

			IF lHayErr
			   AADD(aHayErr,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,cTxtErr})
			   LOOP
			ENDIF
*---------------------FIN VALIDACION DE LA CARGA DEL PROFESOR

*---------------------LOCALIZACION DE LA CARGA EN EL PROFESOR
			IF !lLocCodigo('cCodigoCar','CAP',cCodigoTca)
			   cTxtErr := 'NO EXISTE LA CARGA EN PROFESOR'+cPatPro
			   AADD(aHayErr,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,cTxtErr})
			   LOOP
			ENDIF
*---------------------FIN LOCALIZACION DE LA CARGA EN EL PROFESOR

*---------------------SELECION DE LAS AREAS DE TRABAJO
			IF !lUseDbf(.T.,cPatPro+'\'+;
				    CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

			   cTxtErr := 'ABRIENDO NOTAS EN PROFESOR '+;
				       CAP->cCodigoCar
			   AADD(aHayErr,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,cTxtErr})
			   LOOP
			ENDIF
*---------------------FIN SELECION DE LAS AREAS DE TRABAJO

*---------------------LOCALIZACION DEL ESTUDIANTE
			IF !lLocCodigo('cCodigoEst','NOP',NOT->cCodigoEst)
			   cTxtErr := 'NO EXISTE EL ESTUDIANTE EN NOP'
			   AADD(aHayErr,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,cTxtErr})
			   LOOP
			ENDIF
*---------------------FIN LOCALIZACION DEL ESTUDIANTE

*---------------------NOTAS EN EL PROFESOR
			SELECT NOP
			cCamJuiNoP := 'NOP->cIndic'+STR(nNroPer,1)+'NoP'
			cCamDefNoP := 'NOP->cDefin'+STR(nNroPer,1)+'NoP'

			cJuiPro := &cCamJuiNoP
			cDefPro := &cCamDefNoP
			cFalPro := NOP->cFallasNoP
*---------------------FIN NOTAS EN EL PROFESOR

*---------------------ANALISIS DE LA DIFERENCIA
			IF cJuiNot # cJuiPro
			   AADD(aDifNot,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,;
                                         cNombreTma,;
					 STR(nNroPer,1),;
					 cPatPro,;
					 cJuiNot,cJuiPro})
			ENDIF

			IF cDefNot # cDefPro
			   AADD(aDifNot,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,;
					 cNombreTma,;
					 STR(nNroPer,1),;
					 cPatPro,;
					 cDefNot,cDefPro})
			ENDIF

			IF cFalNot # cFalPro
			   AADD(aDifNot,{NOT->cCodigoEst,;
					 cCodGru,cCodigoTma,;
					 cNombreTma,;
					 STR(nNroPer,1),;
					 cPatPro,;
					 cFalNot,cFalPro})
			ENDIF
*---------------------FIN ANALISIS DE LA DIFERENCIA

		  ENDFOR
*---------------FIN RECORRIDO DEL AREA

	    ENDFOR
**********FIN RECORRIDO POR PERIODOS

	  SELECT NOT
	  NOT->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR ESTUDIANTES

*>>>>IMPRESION DE LAS DIFERENCIAS
       SET DEVICE TO PRINT
       @ PROW()+1,01 SAY 'RELACION DE INCONSISTENCIAS'
       FOR i:=1 TO LEN(aDifNot)
	   @ PROW()+2,01 SAY aDifNot[i,1]+','+;
			     aDifNot[i,2]+','+;
			     aDifNot[i,3]+','+;
			     aDifNot[i,4]

	   @ PROW()+1,01 SAY 'PROFESOR:'+aDifNot[i,6]
	   @ PROW()+1,01 SAY 'EN CONTABALIDAD PERIODO No.'+aDifNot[i,5]
	   @ PROW()+1,01 SAY IF(EMPTY(aDifNot[i,7]),;
				      ALLTRIM(aDifNot[i,7])+'vacio',;
				      ALLTRIM(aDifNot[i,7]))
	   @ PROW()+1,01 SAY 'EN EN PROFESOR  PERIODO No.'+aDifNot[i,5]
	   @ PROW()+1,01 SAY IF(EMPTY(aDifNot[i,8]),;
				      ALLTRIM(aDifNot[i,8])+'vacio',;
				      ALLTRIM(aDifNot[i,8]))
       ENDFOR
*>>>>FIN IMPRESION DE LAS DIFERENCIAS

*>>>>IMPRESION DE LOS ERRORES
       SET DEVICE TO PRINT
       @ PROW()+2,01 SAY 'RELACION DE ERRORES'
       FOR i:=1 TO LEN(aHayErr)
	   @ PROW()+1,01 SAY aHayErr[i,1]+','+;
			     aHayErr[i,2]+','+;
			     aHayErr[i,3]+','+;
			     aHayErr[i,4]
       ENDFOR
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       SELECT NOT
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DE LOS ERRORES

/*************************************************************************
* TITULO..: NOTA DEFINITIVA                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2005 VIE A
       Colombia, Bucaramanga        INICIO: 08:45 PM   OCT 14/2005 VIE

OBJETIVOS:

1- Convierte la nota n£merica al Juicio valorativo de acuerdo al
   intervalo.

2- No realiza la conversi¢n si no se cumple la condici¢n de conversi¢n

3- Retorna la nota

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNotDef(cNotDef,lNotNum)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNotDef                              // Nota Definitiva
       lNotNum                              // .T. Nota N£merica */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>ANALISIS DE DECISION
       IF lNotNum .AND. lHayItvTco()
	  IF VAL(cNotDef) == 0
	     cNotDef := ''
	  ELSE
	     cNotDef := cNotDefJvf(VAL(cNotDef))
	  ENDIF
       ENDIF
       RETURN cNotDef
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: CONFIRMACION DE LOS COIDGOS DE PROMOCION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 13/2006 JUE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   JUL 13/2006 JUE

OBJETIVOS:

1- Confirma los c¢digos de promoci¢n que aparecen con en el archivo de notas
   contra los que aparecen en el maestro de estudiantes.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrNot04(aParam1,aParam2,aParam3,oBrowse,cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse			            // Browse del Archivo
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .F.                 // Control de flujo
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

*>>>>RECORRIDO POR NOTAS
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºREGISTRO No. '+NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cError('EL CODIGO:'+NOT->cCodigoEst+' '+;
		      'NO EXISTE EN EL MAESTRO DE ESTUDIANTES')
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********VERIFICACION DEL CODIGO DE APROBACION
	    IF NOT->nAproboNot # &cMaeAct->nAproboNot

	       SELECT &cMaeAct
	       IF lRegLock(lShared,.F.)
		  REPL &cMaeAct->nAproboNot WITH NOT->nAproboNot
		  DBCOMMIT()
		  lSiorNo := .T.
	       ELSE
		  cError('NO SE PUDO GRABAR EL REGISTRO '+;
			 'CON CODIGO: '+NOT->cCodigoEst)
	       ENDIF
	       IF lShared
		  DBUNLOCK()
	       ENDIF

	    ENDIF
**********FIN VERIFICACION DEL CODIGO DE APROBACION

	  NOT->(DBSKIP())

       ENDDO
       SELECT NOT
       NOT->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       IF lSiorNo
	  cError('SE ACTUALIZARON CODIGOS DE PROMOCION '+;
		 'CON EL MAESTRO DE ALUMNOS')
       ELSE
	  cError('LO CODIGOS DE PROMOCION ESTAN SINCRONIZADOS')
       ENDIF
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS

/*************************************************************************
* TITULO..: HAY RECUPERACIONES DEL ESTUDIANTE                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2007 MIE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   MAY 16/2007 MIE

OBJETIVOS:

1- Determina si un estudiante tiene recuperaciones pendientes.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION lHayRecEst(nNroPer,aNotAre,aNotMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroPer                              // N£mero del Periodo
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,y := 0                   // Contadores
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cIndAnt := ''                  // Indicadores Periodos Anteriores
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL lHayRec := .F.                 // .T. Tiene recuperaciones

       LOCAL cCamJuiNot := ''               // Campo de Indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)

       FOR i:=1 TO LEN(aNotAre)

***********RECUPERACIONES DEL AREA
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN' .AND.;
		!aNotAre[i,15]  // Recuperable

		FOR y := 1 TO nNroPer

		   cCamJuiNot := aNotAre[i,6]
		   cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
		      cIndAnt := &cCamJuiNot
		      cSiRecu := ''
		      cNoRecu := ''
		   IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)

		   IF !EMPTY(cNoRecu)
		      lHayRec := .T.
		      EXIT
		   ENDIF

		NEXT

		IF lHayRec
		   EXIT
		ENDIF

	      ENDIF
************FIN RECUPERACIONES DEL AREA

**********ANALISIS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

*===============RECUPERACION DE LA MATERIA
		  IF aNotAre[i,2] == aNotMat[j,1] .AND.;
		     !aNotMat[j,15]  // Recuperable

		    FOR y := 1 TO nNroPer
			cCamJuiNot := aNotMat[j,5]
			cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			   cIndAnt := &cCamJuiNot
			   cSiRecu := ''
			   cNoRecu := ''
			IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
			IF !EMPTY(cNoRecu)
			   lHayRec := .T.
			   EXIT
			ENDIF
		    NEXT

		    IF lHayRec
		       EXIT
		    ENDIF

		  ENDIF
*===============FIN RECUPERACION DE LA MATERIA

	    ENDFOR
	    IF lHayRec
	       EXIT
	    ENDIF
**********ANALISIS DE LA MATERIA

       ENDFOR
       RETURN lHayRec
*>>>>FIN RECORRIDO POR AREAS

/*************************************************************************
* TITULO..: CAMPOS DE LAS NOTAS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 29/2007 LUN A
       Colombia, Bucaramanga        INICIO: 04:30 PM   OCT 29/2007 LUN

OBJETIVOS:

1- Localiza los campos de una materia del archivo de notas

2- Debe estar en uso el archivo de notas

3- Retorna el verctor con los campos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aCamposNot(cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodMat                              // C¢digo de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL cCodAre := ''                  // C¢digo del Area
       LOCAL aStrNot := {}                  // Vector con la estructura
       LOCAL aCampos := {}                  // Campos
       LOCAL cCamNot := ''                  // Campo de notas
       LOCAL cCamRec := ''                  // Campo de Recuperacion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPO DE NOTAS
       SELECT NOT
       aStrNot := DBSTRUCT()

       cCodAre := SUBS(cCodMat,1,2)
       IF SUBS(cCodMat,3,2) == '00'
	  i := ASCAN(aStrNot,{|aStr|UPPER(SUBS(aStr[1],1,7)) == UPPER('cAreN'+cCodAre)})
	  IF i == 0
	     i := ASCAN(aStrNot,{|aStr|UPPER(SUBS(aStr[1],1,7)) == UPPER('cNt'+cCodMat)})
	  ENDIF
       ELSE
	  i := ASCAN(aStrNot,{|aStr|UPPER(SUBS(aStr[1],1,7)) == UPPER('cNt'+cCodMat)})
       ENDIF

       IF i # 1
	  cCamNot := 'NOT->'+aStrNot[i][1]
	  AADD(aCampos,{'NotDef',cCamNot})

	  cCamRec := STUFF(cCamNot,13,3,'Rec')
	  AADD(aCampos,{'NotRec',cCamRec})
       ENDIF
*>>>>FIN CAMPO DE NOTAS

*>>>>CAMPO DE INDICADORES
       FOR i := 1 TO 5

	   j := ASCAN(aStrNot,{|aStr|UPPER(SUBS(aStr[1],1,7)) == UPPER('cJ')+STR(i,1)+cCodMat})
	   IF j # 1
	      AADD(aCampos,{'Ind'+STR(i,1),'NOT->'+aStrNot[j][1]})
	   ENDIF

       ENDFOR
       RETURN aCampos
*>>>>FIN CAMPO DE INDICADORES

/*************************************************************************
* TITULO..: CAMPO DE NOTAS DEFINITIVAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 29/2007 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 29/2007 LUN

OBJETIVOS:

1- Retorna el campo de notas definitivas de una materia o area.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCamNotDef(aCampos,cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     aCampos                              // Campos de la Materia
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCampos := ''                  // Nombre del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CAMPO
       i := ASCAN(aCampos,{|aStr|aStr[1] == 'NotDef'})
       IF i # 0
	  cCampos := aCampos[i][2]
       ENDIF
       RETURN cCampos
*>>>>FIN BUSQUEDA DEL CAMPO

/*************************************************************************
* TITULO..: CAMPO DE NOTAS DE RECUPERACION                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 29/2007 LUN A
       Colombia, Bucaramanga        INICIO: 05:15 PM   OCT 29/2007 LUN

OBJETIVOS:

1- Retorna el campo de notas de recuperacion de una materia o area.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCamNotRec(aCampos,cCodMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     aCampos                              // Campos de la Materia
       cCodMat                              // C¢digo de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCampos := ''                  // Nombre del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CAMPO
       i := ASCAN(aCampos,{|aStr|aStr[1] == 'NotRec'})
       IF i # 0
	  cCampos := aCampos[i][2]
       ENDIF
       RETURN cCampos
*>>>>FIN BUSQUEDA DEL CAMPO

/*************************************************************************
* TITULO..: CAMPO DE INDICADORES                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 29/2007 LUN A
       Colombia, Bucaramanga        INICIO: 05:30 PM   OCT 29/2007 LUN

OBJETIVOS:

1- Retorna el campo de indicadores de una materia o area.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCamIndNot(aCampos,cCodMat,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     aCampos                              // Campos de la Materia
       cCodMat                              // C¢digo de la Materia
       nNroPer                              // N£mero del periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCampos := ''                  // Nombre del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CAMPO
       i := ASCAN(aCampos,{|aStr|aStr[1] == 'Ind'+STR(nNroPer,1)})
       IF i # 0
	  cCampos := aCampos[i][2]
       ENDIF
       RETURN cCampos
*>>>>FIN BUSQUEDA DEL CAMPO

/*************************************************************************
* TITULO DEL PROGRAMA..: ESTADO DE LA APROBACION DEL A¥O                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:20 AM   SEP 05/95 MAR

OBJETIVOS:

1- Define el estado de aprobaci¢n del a¤o del estudiante

2- Retorna el texto del estado

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cAprobo(nNroBis,nAprobo,cNotHab)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroBis                              // N£mero del bimestre
       nAprobo			            // Estado de aprobaci¢n:
						0 => Por definir
						1 => Reprobado
						2 => Aprobado
						3 => Aprobado por promedio
						4 => Habilita
       cNotHab                              // Notas de habilitaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nEstHab := 0                   // Estado final del estudiante
       LOCAL cEstado := ''                  // Estado final del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA APROBACION DEL A¥O
       nEstHab := nEstadoHab(nNroBis,cNotHab)
      *Estado de la habilitaci¢n

       IF nNroBis == 4
	  DO CASE
	  CASE nAprobo == 0
	       cEstado := 'Aprobaci¢n por definir'

	  CASE nAprobo == 2
	       cEstado := 'Aprobado'

	  CASE nAprobo == 3
	       cEstado := 'Aprobo por promedio '

	  CASE nAprobo == 4 .AND. nEstHab == 2
	       cEstado := 'Aprobado. Paso habilitaci¢n '

	  CASE nAprobo == 4 .AND. nEstHab == 0
	       cEstado := 'Habilita'

	  CASE nAprobo == 4 .AND. nEstHab == 1
	       cEstado := 'Reprobado. Perdio habilitaci¢n'

	  CASE nAprobo == 1
	       cEstado := 'Reprobado '

	  OTHERWISE
	       cEstado := 'Aprobacion por definir'
	  ENDCASE
       ENDIF
       RETURN cEstado
*>>>>FIN ANALISIS DE LA APROBACION DEL A¥O

/*************************************************************************
* TITULO DEL PROGRAMA..: ESTADO DE LA HABILITACION                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 AM   SEP 05/95 MAR

OBJETIVOS:

1- Define el estado de la habilitaci¢n del estudiante

2- Retorna el n£mero del estado seg£n documentaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nEstadoHab(nNroBis,cNotHab)

*>>>>DECLARACION DE VARIABLES
       LOCAL nEstHab                        /* Estado de habilitaci¢n
					       0 => Por definir
					       1 => Reprobado
					       2 => Aprobado
					       3 => Aprobado por promedio
					       4 => Habilita */
       LOCAL nNotHab := 0                   // Nota de la habilitaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA HABILITACION
       nEstHab := 0
       IF nNroBis == 4 .AND. !EMPTY(cNotHab)

**********ANALISIS SI APROBO LA HABILITACION
	    nEstHab := 0
	    nNotHab := VAL(SUBS(cNotHab,1,4))

	    IF nNotHab < 6.0
	       nEstHab := 1
	    ELSE
	       nEstHab := 2
	       nNotHab := VAL(SUBS(cNotHab,5,4))
	       IF nNotHab < 6.0
		  nEstHab := 1
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI APROBO LA HABILITACION

       ENDIF
       RETURN nEstHab
*>>>>ANALISIS DE LA HABILITACION