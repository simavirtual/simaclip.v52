/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INICIO DE A¥O
SUBMODULO...: CREACION DE GRUPOS

**************************************************************************
* TITULO..: CREACION DE GRUPOS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 17/1995 MIE A
       Colombia, Bucaramanga        INICIO: 12:10 PM   MAY 17/1995 MIE


OBJETIVOS:

1- Permite crear los grupos con los respectivos alumnos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_108(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar pantalla
       LOCAL cPatTem := ''                  // Path Temporal
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL cNroNiv := ''                  // N£mero del nivel
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL nNroPun := 0                   // N£mero del puntero
       LOCAL lOrdMae := .T.                 // .T. Ordeno el maestro
       LOCAL lHayJnt := .F.                 // .T. Hay notas en los juicios valortativos

       LOCAL Getlist := {}                  // Variable del sistema
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cNombreTes := ''               // Nombre del estudiante
       FIELD cCodigoGru                     // C¢digo del grupo
       FIELD cApelliEst                     // Apellido del estudiante
       FIELD cNombreEst                     // Nombre del estudiante
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

*>>>>ANALISIS DE DECISION
       cError('DEBE GARANTIZAR QUE NINGUN USUARIO ESTE '+;
	      'UTILIZANDO EL SIMA')

       IF !lPregunta('ESTA SEGURO QUE NINGUN USUARIO '+;
		     'ESTA UTILIZANDO EL SIMA?No Si')
	  CloseAll()
	  RETURN NIL
       ENDIF

       IF !lPregunta('REALIZO COPIA DE SEGURIDAD? No Si')
	  cError('DEBE SACAR COPIA DE TODOS LOS A¥OS A ACTUALIZAR')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECCION DEL PATH DEL SISTEMA
       cPatTem := cPatSis
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatSis := cPatSis+'\'+cMaeAct
	    cNomNiv := 'JARDIN'

       CASE 'PRI' $ cMaeAct
	    cPatSis := cPatSis+'\'+cMaeAct
	    cNomNiv := 'PRIMARIA'

       CASE 'BTO' $ cMaeAct
	    cPatSis := cPatSis+'\'+cMaeAct
	    cNomNiv := 'BACHILLERATO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
      IF !lUseDbf(.T.,cPatSis+'\'+;
		     FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	 !lUseDbf(.T.,cPatSis+'\'+;
		     FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE GRUPOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE EXISTENCIA DE ARCHIVO DE NOTAS
       IF lFilesNot(cPatSis,cAnoSis)
	  cError('LOS GRUPOS DE '+cNomNiv+' YA ESTAN CREADOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE EXISTENCIA DE ARCHIVO DE NOTAS

*>>>>VALIDACION DE CONTENIDO DEL PLAN DE ESTUDIOS
      IF lVaciosPla(cPatSis,cAnoSis,@cNroNiv)
	 cError('NO EXISTE PLAN ACADEMICO DE '+cNomNiv(cNroNiv))
	 CLOSE ALL
	 RETURN NIL
      ENDIF
*>>>>VALIDACION DE CONTENIDO DEL PLAN DE ESTUDIOS

*>>>>ORDENAMIENTO DEL MAESTRO
       lOrdMae := .F.
       IF lPregunta('DESEA ORDENAR EL MAESTRO POR APELLIDOS? Si No')

**********PREGUNTA DE DECISION
	    IF !lPregunta('SE VA A ORDENAR EL MAESTRO. DESEA CONTINUAR? No Si')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
	    lOrdMae := .T.
**********FIN PREGUNTA DE DECISION

**********COPIA DEL MAESTRO PARA EL ORDENAMIENTO
	    cSavPan := SAVESCREEN(0,0,24,79)
	    Termometro(0,'ORDENANDO EL MAESTRO')
	    Termometro(10)
	    FILECOPY(cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+ExtFile,;
				  cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+'.TEM')
	    Termometro(40)
**********FIN COPIA DEL MAESTRO PARA EL ORDENAMIENTO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+;
			   FileAlu+cMaeAct+cAnoSis+'.TEM','ALU',NIL,lShared)
	       cError('ABRIENDO ARCHIVO MAESTRO TEMPORAL EN '+cPatSis)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE ALU->(RECCOUNT()) == 0
		 cError('NO EXISTEN ALUMNOS GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********ORDENAMIENTO
	    SORT TO &(cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+ExtFile) ;
		 ON cCodigoGru,cApelliEst,cNombreEst

	    CloseDbf('ALU')
	    IF !lFileDelete(cPatSis+'\'+FileAlu+cMaeAct+cAnoSis+'.TEM')
	       cError('NO SE BORRO EL MAESTRO TEMPORAL')
	    ENDIF

	    Termometro(100)
	    SAVESCREEN(0,0,24,79,cSavPan)

	    Indexar(cPatTem,cAnoUsr,cMaeAct)
**********FIN ORDENAMIENTO

       ENDIF
       CloseDbf('GRU')
*>>>>FIN ORDENAMIENTO DEL MAESTRO

*>>>>PREGUNTA DE DECISION
       IF !lOrdMae
	  IF !lPregunta('NO SE ORDENA EL MAESTRO. DESEA CONTINUAR? No Si')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		      FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		     FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS MAESTRO Y GRUPOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE NIVEL PARA '+cMaeAct)

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>BLOQUE DEL ARCHIVO MAESTRO
       SELECT ALU
       IF lShared
	  IF lFileLock()
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN BLOQUE DEL ARCHIVO MAESTRO

*>>>>CREACION DE LOS GRUPOS Y GRABACION DE LOS ESTUDIANTES
       lHayJnt := lHayJnt(TCO->cEvaIndTbl)

       nNroFil := nMarco(nFilPal+1,'POR FAVOR ESPERE MIENTRAS SE AGRUPAN '+;
				   'LOS ESTUDIANTES DE '+cNomNiv)
       SELECT GRU
       GO TOP
       DO WHILE .NOT. EOF()

**********ASIGNACION DEL NIVEL
	    nNroPun := VAL(SUBS(GRU->cCodigoGru,1,2))
	    DO CASE
	    CASE 'JAR' $ cMaeAct
		 nNroPun := VAL(SUBS(GRU->cCodigoGru,1,2)) - 11
		 cNroNiv := SUBS('1213141516',nNroPun*2-1,2)

	    CASE 'PRI' $ cMaeAct
		 nNroPun := VAL(SUBS(GRU->cCodigoGru,1,2)) + 1
		 cNroNiv := SUBS('000102030405',nNroPun*2-1,2)

	    CASE 'BTO' $ cMaeAct
		 nNroPun := VAL(SUBS(GRU->cCodigoGru,1,2)) - 5
		 cNroNiv := SUBS('060708091011',nNroPun*2-1,2)
	    ENDCASE
**********FIN ASIGNACION DEL NIVEL

***********SELECION DE LAS AREAS DE TRABAJO
	    FilePla := cFilePlan(cAnoUsr,GRU->cCodigoGru)
	    IF !lUseDbf(.T.,cPatSis+'\'+FilePla,'PLA',NIL,lShared)
		cError('ABRIENDO EL ARCHIVO DEL PLAN DE '+cNomNiv(cNroNiv))
	       EXIT
	    ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     IF PLA->(RECCOUNT()) == 0
		cError('NO EXISTE PLAN ACADEMICO '+cNomNiv(cNroNiv))
		CloseDbf('PLA')
		EXIT
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********CREACION DE LAS ESTRUCTURAS DE NOTAS
	    FileNot := 'NT'+GRU->cCodigoGru+cAnoSis+ExtFile
	    CreaDbfNot(cPatSis+'\NOTAS',FileNot,lHayJnt)
	    CLOSE PLA
**********FIN CREACION DE LAS ESTRUCTURAS DE NOTAS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+FileNot,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ASIGNANDO LOS ESTUDIANTES DEL GRUPO: '+;
			GRU->cCodigoGru+' ...copiando en el disco',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********FILTRACION DEL ARCHIVO DE ALUMNOS
	    SELECT ALU
	    SET FILTER TO ALU->cCodigoGru == GRU->cCodigoGru
	    GO TOP
**********FIN FILTRACION DEL ARCHIVO DE ALUMNOS

**********GRABACION DE LOS ALUMNOS DEL RESPECTIVO GRUPO
	    DO WHILE .NOT. EOF()

*--------------GRABACION DEL ESTUDIANTE EN EL DISCO
		 SELECT NOT
		 IF NOT->(lRegLock(lShared,.T.))
		    REPL NOT->cCodigoEst WITH ALU->cCodigoEst
		    REPL NOT->lRetGruNot WITH .F.
		    NOT->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EN NOTAS EL ESTUDIANTE CON CODIGO: '+;
			   ALU->cCodigoEst+' AL GRUPO: '+GRU->cCodigoGru)
		 ENDIF
		 IF lShared
		    NOT->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DEL ESTUDIANTE EN EL DISCO

*--------------VISUALIZACION DEL ESTUDIANTE GRABADO
		 nNroFil++
		 cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			       RTRIM(ALU->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)

		 @ nNroFil,01 SAY cNombreTes+' ... PARA EL GRUPO '+;
				  GRU->cCodigoGru

		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,'POR FAVOR ESPERE MIENTRAS '+;
				     'SE AGRUPAN LOS ESTUDIANTES DE '+cNomNiv)
		 ENDIF
*--------------FIN VISUALIZACION DEL ESTUDIANTE GRABADO

	       SELECT ALU
	       SKIP
	    ENDDO

	    SELECT ALU
	    SET FILTER TO
	    CLOSE NOT
**********FIN GRABACION DE LOS ALUMNOS DEL RESPECTIVO GRUPO

	  SELECT GRU
	  SKIP

       ENDDO
       SELECT ALU
       DBUNLOCKALL()
       SET FILTER TO
       CloseAll()
       RETURN NIL
*>>>>FIN CREACION DE LOS GRUPOS Y GRABACION DE LOS ALUMNOS Y PAGOS