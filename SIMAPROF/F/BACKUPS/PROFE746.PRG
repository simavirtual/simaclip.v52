/* SIMA - CONTABILIDAD PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: ASINGACION

**************************************************************************
* TITULO..: ACTUALIZACION DE LA CARGA ACADEMICA                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 12/2002 LUN A
       Colombia, Bucaramanga        INICIO: 01:00 PM   AGO 12/2002 LUN

OBJETIVOS:

1- Actualiza la asignaci¢n acad‚mica del profesor incluyendo las materias
   nuevas que dicta.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_746(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroAlu := 1                   // N£mero de Alumnos
       LOCAL lUseNtx := .F.                 // .T. Abrir Indices
       LOCAL lHayMat := .T.                 // .T. Hay Materia
       LOCAL lTodos  := .F.                 // .T. Procesar todos
       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la fila

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor

       FIELD cCodigoGru                     // C¢digo del Grupo

       LOCAL GetList := {}                  // Variable del sistema
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

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL lMemUsb := xPrm(aP1,'lMemUsb') // .T. SimaProf en Usb. .F. SimaProf en la Red
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared) .OR.;
	  !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis,lUseNtx)

	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO ESTUDIANTES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION DEL DE LA CONTABILIDAD')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO APARECEN MATERIAS GRABADAS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO SE HA CREADO LAS CARGAS ACADEMICAS DEL PROFESOR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
       lHayErr := .F.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

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
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL USUARIO PROFESOR

*>>>>ACTUALIZACION DEL REGISTRO
       SELECT PRO
       IF lTodos
	  PRO->(DBGOTOP())
       ENDIF
*>>>>FIN ACTUALIZACION DEL REGISTRO

*>>>>ACTUALIZACION DE LAS ESTRUCTURAS
       DO WHILE .T.

**********LECTURA DEL PATH DEL PROFESOR
	    IF lTodos
	       cPatPro := cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
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

**********FILTRACION DE LA CARGA ACADEMICA DE LA CONTABILIDAD
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == PRO->cCodigoPro
	    CAR->(DBGOTOP())
	    IF CAR->(EOF())

	       SET FILTER TO
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP

	    ENDIF
**********FIN FILTRACION DE LA CARGA ACADEMICA DE LA CONTABILIDAD

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
	       !lUseDbf(.T.,cPatPro+'\'+;
			    FMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO CARGAS DEL PROFESOR')
	       CloseAll()
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAP->(RECCOUNT()) == 0
		 cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR '+;
			'CODIGO: '+PRO->cCodigoPro)

	    CASE MAP->(RECCOUNT()) == 0
		 cError('NO EXISTE MATERIAS DEL PROFESOR '+;
			'CODIGO: '+PRO->cCodigoPro)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       PRO->(DBSKIP())
	       IF PRO->(EOF())
		  EXIT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********ACTUALIZACION DE LOS ARCHIVOS DE LA CARGA ACADEMICA
	    i := 0
	    SELECT CAR
	    GO TOP
	    DO WHILE .NOT. CAR->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 i++
		 LineaEstado('PROF:'+PRO->cApelliPro+;
			     'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				     STR(PRO->(RECCOUNT()),4)+;
			     'ºGRUPO:'+SUBS(CAR->cCodigoCar,5,4)+;
			     'ºNo. '+STR(i,4)+'/'+;
				     STR(CAP->(RECCOUNT()),4),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------LOCALIZACION DEL CODIGO DE LA MATERIA
		 cCodigoTgr := SUBS(CAR->cCodigoCar,5,4)
		 cCodigoTni := SUBS(CAR->cCodigoCar,5,2)
		 cCodigoTma := SUBS(CAR->cCodigoCar,1,4)

		 cNombreTma := 'MATERIA CON CODIGO: '+cCodigoTma+;
			       ' NO EXISTE'

		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma)
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DEL CODIGO DE LA MATERIA

*--------------LOCALIZACION DE LA CARGA DEL PROFESOR
		 IF lLocCodigo('cCodigoCar','CAP',CAR->cCodigoCar)
		    SELECT CAR
		    CAR->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DE LA CARGA DEL PROFESOR

*--------------GRABACION DE LA CARGA ACADEMICA
		 IF CAP->(lRegLock(lShared,.T.))
		    REPL CAP->cCodigoCar WITH CAR->cCodigoCar
		    REPL CAP->nTipCarCar WITH CAR->nTipCarCar
		    REPL CAP->cNombreMat WITH cNombreTma
		    CAP->(DBCOMMIT())
		 ENDIF
		 IF lShared
		    CAP->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DE LA CARGA ACADEMICA

*--------------GRABACION DE LAS MATERIAS DEL PROFESOR
		 SELECT MAP
		 IF TCO->lIndNivTbl
		    LOCATE FOR MAP->cCodigoNiv == cCodigoTni .AND.;
			       MAP->cCodigoMat == cCodigoTma
		    lHayMat := .F.
		    IF FOUND()
		       lHayMat := .T.
		    ENDIF
		 ELSE
		     lHayMat := lLocCodigo('cCodigoMat','MAP',cCodigoTma)
		 ENDIF

		 IF !lHayMat
		    IF MAP->(lRegLock(lShared,.T.))
		       IF TCO->lIndNivTbl
			  REPL MAP->cCodigoNiv WITH cCodigoTni
		       ELSE
			  REPL MAP->cCodigoNiv WITH SPACE(02)
		       ENDIF
		       REPL MAP->cCodigoMat WITH cCodigoTma
		       REPL MAP->cNombreMat WITH cNombreTma
		       MAP->(DBCOMMIT())
		    ENDIF
		    IF lShared
		       MAP->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DE LAS MATERIAS DEL PROFESOR

*--------------CREACION DE LA ESTRUCTURA DEL GRUPO
		 FNotPro := CAR->cCodigoCar+ExtFile
		 CreaDbfNoP(lShared,cPatPro,FNotPro)
*--------------FIN CREACION DE LA ESTRUCTURA DEL GRUPO

*--------------VALIDACION DE LA CARGA NORMAL
		 IF CAR->nTipCarCar # 0
		    @ 10,20 SAY 'PARA '+SUBS(cCodigoTgr,1,2)+;
				' CREANDO '+ALLTRIM(CAP->cNombreMat)
		    SELECT CAR
		    CAR->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VALIDACION DE LA CARGA NORMAL

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,cPatPro+'\'+FNotPro,'NOP',NIL,lShared)
		    cError('ABRIENDO EL ARCHIVO DE NOTAS '+FNotPro)
		    CAR->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------FILTRACION DEL MAESTRO DE ALUMNOS
		 SELECT &cMaeAct
		 cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
		 SET FILTER TO cCodigoGru == cCodigoTgr
		 GO TOP
		 IF EOF()
		    cError('NO EXISTEN ALUMNOS PARA EL GRUPO '+cCodigoTgr)
		    SET FILTER TO
		    CAR->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN FILTRACION DEL MAESTRO DE ALUMNOS

*--------------GRABACION DE LOS ALUMNOS DEL RESPECTIVO GRUPO
		 nNroFil := nMarco(01,'PROFESOR: '+ALLTRIM(PRO->cNombrePro)+' '+;
				      'MATERIA: '+ALLTRIM(cNombreTma)+' '+;
				      'ESTUDIANTE DEL GRUPO: '+cCodigoTgr)
		 SELECT &cMaeAct
		 GO TOP
		 DO WHILE .NOT. EOF()

*...................GRABACION DEL ALUMNO EN EL DISCO
		      IF NOP->(lRegLock(lShared,.T.))
			 REPL NOP->cCodigoEst WITH &cMaeAct->cCodigoEst
			 REPL NOP->cApelliEst WITH &cMaeAct->cApelliEst
			 REPL NOP->cNombreEst WITH &cMaeAct->cNombreEst
			 REPL NOP->lRetiroNoP WITH .F.
			 NOP->(DBCOMMIT())
		      ENDIF
		      IF lShared
			 NOP->(DBUNLOCK())
		      ENDIF
*...................FIN GRABACION DEL ALUMNO EN EL DISCO

*...................VISUALIZACION DEL ESTUDIANTE GRABADO
		      SELECT &cMaeAct
		      cNombreTes := ALLTRIM(&cMaeAct->cApelliEst)+' '+;
				    ALLTRIM(&cMaeAct->cNombreEst)
		      nNroFil++
		      @ nNroFil,01 SAY 'No. '+STR(nNroAlu++,2)+;
				       ' CODIGO: '+&cMaeAct->cCodigoEst+' '+;
				       cNombreTes+' ...'

		      IF nNroFil == 21
			 nNroFil := nMarco(01,'PROFESOR: '+;
					      ALLTRIM(PRO->cNombrePro)+' '+;
					      'MATERIA: '+;
					      ALLTRIM(cNombreTma)+' '+;
					      'ESTUDIANTE DEL GRUPO: '+;
					      cCodigoTgr)
		      ENDIF
*...................FIN VISUALIZACION DEL ESTUDIANTE GRABADO

		    SKIP

		 ENDDO

		 SELECT &cMaeAct
		 SET FILTER TO
		 CloseDbf('NOP')
		 nNroAlu := 1
*--------------GRABACION DE LOS ALUMNOS DEL RESPECTIVO GRUPO

	       SELECT CAR
	       CAR->(DBSKIP())

	    ENDDO
	    SELECT CAR
	    SET FILTER TO
**********FIN ACTUALIZACION DE LOS ARCHIVOS DE LA CARGA ACADEMICA

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
*>>>>FIN ACTUALIZACION DE LAS ESTRUCTURAS