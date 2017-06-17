/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: LISTAS DE CLASE     MODULO No. 608

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE608.PRG                                    *
* TITULO DEL PROGRAMA..: ASIGNACION O CAMBIO DE GRUPO                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 28/96 JUE A
       Bucaramanga, Colombia	    INICIO: 10:30 AM   FEB 28/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite asignar o cambiar de grupo a los estudiantes

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_608(aParam1,aParam2,aParam3,;
		   lModNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lModNiv                              // .T. Cambiar Nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lErrUno := .F.                 // Error Archivos Compartidos Uno
       LOCAL lErrDos := .F.                 // Error Archivos Compartidos Dos
       LOCAL lErrTre := .F.                 // Error Archivos Compartidos Tres
       LOCAL lErrCua := .F.                 // Error Archivos Compartidos Cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cCodGru := ''                  // Grupo del estudiante
       LOCAL lHayGru := .F.                 // .T. Tiene grupo asignado

       LOCAL fNotFue := ''                  // Archivo de notas fuente
       LOCAL fNotDes := ''                  // Archivo de notas destino
       LOCAL fCliFue := ''                  // Archivo de clientes fuente
       LOCAL fCliDes := ''                  // Archivo de clientes destino
       LOCAL fPagFue := ''                  // Archivo de pagos destino
       LOCAL fPagDes := ''                  // Archivo de pagos fuente
       LOCAL nProtec := 0                   // C¢digo de la Protecci¢n
       LOCAL nModCar := 0                   // Modo de Protecci¢n de la Cartera
       LOCAL lFueNot := .F.                 // .T. Estudiante Fuente en Notas
       LOCAL lFueCli := .F.                 // .T. Estudiante Fuente en Notas
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
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
       IF  !lParam0101(aParams,;
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared)

	  cError('ABRIENDO LOS ARCHIVOS MAESTRO Y NIVELES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAct .AND. JAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS DE JARDIN GRABADOS')

       CASE 'PRI' $ cMaeAct .AND. PRI->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS DE PRIMARIA GRABADOS')

       CASE 'BTO' $ cMaeAct .AND. BTO->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS DE BACHILLERATO GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR INGRESE LOS CODIGOS DE LOS '+;
				   'ESTUDIANTES DE '+cMaeAct,22,'°')
       nNroCol := 1
       aTamCol := {06,40,06,06}
       aTitulo := {'CODIGO','NOMBRE','CURSO ','GRUPO '}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS REGISTROS
       nNroFil++
       lModNiv := IF(EMPTY(lModNiv),.F.,lModNiv)
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cMaeAct)
	       cNalias := cMaeAct
	    IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTA RETIRADO
	    IF &cNalias->lRetiroEst
	       cError(cNombreTes+ ' ESTA RETIRADO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI ESTA RETIRADO

**********LECTURA DEL GRUPO
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY &cNalias->cCodigoGru

	    cCodigoTgr := &cNalias->cCodigoGru

	    IF .NOT. lModNiv
	       cCodGru := SUBS(&cNalias->cCodigoGru,3,2)
	       @ nNroFil,aNroCol[4] GET cCodGru PICT '99';
				    VALID lCorrecion(@cCodGru) .AND.;
				    lValGru(SUBS(cCodigoTgr,1,2),VAL(cCodGru))
	       READ
	    ELSE
	       cCodGru := cSpaces('GRU','cCodigoGru')
	       IF !lLeerGru(nNroFil,aNroCol[4]-3,@cCodGru,cMaeAct,.F.)
		  LOOP
	       ENDIF
	    ENDIF
**********FIN LECTURA DEL GRUPO

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********SELECION DE LAS AREAS DE TRABAJO
	    fNotFue := PathUno+'\'+cPatSis+'\'+cNalias+'\NOTAS\'+;
		       'NT'+cCodigoTgr+cAnoSis+ExtFile
	  *ÀArchivo de notas fuente

	    lFueNot := .F.
	    IF FILE(fNotFue)
	       IF !lUseDbf(.T.,fNotFue,'NFU',NIL,lShared)
		  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodigoTgr)
		  LOOP
	       ENDIF
	       lFueNot := lLocCodigo('cCodigoEst','NFU',cCodigoTes)
	    ENDIF
	    CloseDbf('NFU')
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    fCliFue := PathDos+'\'+cPatSis+'\CLIENTES\'+;
		       'CL'+cCodigoTgr+cAnoSis+ExtFile
	  *ÀArchivo de Clientes fuente

	    lFueCli := .F.
	    IF FILE(fCliFue)
	       IF !lUseDbf(.T.,fCliFue,'CFU',NIL,lShared)
		  cError('ABRIENDO EL ARCHIVO DE CLIENTES DEL GRUPO '+cCodigoTgr)
		  LOOP
	       ENDIF
	       lFueCli := lLocCodigo('cCodigoEst','CFU',cCodigoTes)
	    ENDIF
	    CloseDbf('CFU')
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********GRABACION DEL GRUPO
	    SELECT &cNalias
	    IF (lRegLock(lShared,.F.))

	       IF lModNiv
		   REPL &cNalias->cGruAntGru WITH &cNalias->cCodigoGru+'1'
		   REPL &cNalias->cCodigoGru WITH cCodGru
	       ELSE
		   REPL &cNalias->cGruAntGru WITH &cNalias->cCodigoGru+;
						  SUBS(&cNalias->cGruAntGru,4,2)

		   REPL &cNalias->cCodigoGru WITH SUBS(&cNalias->cCodigoGru,1,2)+;
						  cCodGru
	       ENDIF
	       DBCOMMIT()
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       DBUNLOCK()
	    ENDIF
	    @ nNroFil,aNroCol[3] SAY &cNalias->cCodigoGru
**********FIN GRABACION DEL GRUPO

**********VALIDACION SI TIENE GRUPO ASIGNADO
	    SELECT &cNalias
	    lHayGru := .T.
	    IF SUBS(&cNalias->cCodigoGru,3,2) == '00'
	       lHayGru := .F.
	    ENDIF
**********FIN VALIDACION SI TIENE GRUPO ASIGNADO

**********CAMBION DE LAS NOTAS POR CAMBIO DE GRUPO
	    IF !EMPTY(PathUno)

*--------------PREPARACION DE ARCHIVOS
		 fNotFue := PathUno+'\'+cPatSis+'\'+cNalias+'\NOTAS\'+;
			    'NT'+cCodigoTgr+cAnoSis+ExtFile
	       *ÀArchivo de notas fuente

		 fNotDes := PathUno+'\'+cPatSis+'\'+cNalias+'\NOTAS\'+;
			    'NT'+&cNalias->cCodigoGru+cAnoSis+ExtFile
		*Archivo de Notas destino

		 IF SUBS(cCodigoTgr,3,2) == '00' .OR. !lFueNot
		    fNotFue := fNotDes
		 ENDIF
	       *ÀAsignaci¢n de grupo por primera vez
*--------------FIN PREPARACION DE ARCHIVOS

*--------------TRASLADO DE LAS NOTAS
		 IF !(lFueNot .AND. &cNalias->cCodigoGru == cCodigoTgr)
		    CambiarAlu(lShared,PathUno,PathDos,;
			       cCodigoTes,cCodigoTgr,;
			       lHayGru,fNotFue,fNotDes,lModNiv)
		 ENDIF
*--------------FIN TRASLADO DE LAS NOTAS

	    ENDIF
**********FIN CAMBIO DE LAS NOTAS POR CAMBIO DE GRUPO

**********CAMBION EN LA CARTERA POR CAMBIO DE GRUPO
	    IF !EMPTY(PathDos)

*--------------PREPARACION DE ARCHIVOS
		 fCliFue := PathDos+'\'+cPatSis+'\CLIENTES\'+;
			    'CL'+cCodigoTgr+cAnoSis+ExtFile

		 fPagFue := PathDos+'\'+cPatSis+'\PAGOS\'+;
			    'PA'+cCodigoTgr+cAnoSis+ExtFile
	       *ÀArchivo de fuentes

		 fCliDes := PathDos+'\'+cPatSis+'\CLIENTES\'+;
			    'CL'+&cNalias->cCodigoGru+cAnoSis+ExtFile

		 fPagDes := PathDos+'\'+cPatSis+'\PAGOS\'+;
			    'PA'+&cNalias->cCodigoGru+cAnoSis+ExtFile
		*Archivo de destinos

		 IF SUBS(cCodigoTgr,3,2) == '00' .OR. !lFueCli
		    fCliFue := fCliDes
		    fPagFue := fPagDes
		 ENDIF
	       *ÀAsignaci¢n de grupo por primera vez
*--------------FIN PREPARACION DE ARCHIVOS

*--------------TRASLADO DE LOS CLIENTES
		 IF !(lFueCli .AND. &cNalias->cCodigoGru == cCodigoTgr)
		    CambiarCli(lShared,nModCry,PathDos,cCodigoTes,;
			       cCodigoTgr,lHayGru,fCliFue,fCliDes,;
			       fPagFue,fPagDes)
		 ENDIF
*--------------FIN TRASLADO DE LOS CLIENTES

	    ENDIF
**********FIN CAMBION EN LA CARTERA POR CAMBIO DE GRUPO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
				   'DE LOS ESTUDIANTES PARA CAMBIO DE GRUPO',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[4] SAY SUBS(&cNalias->cCodigoGru,3,2)
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO DE LA FUNCION..: TRASLADAR NOTAS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 27/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   AGO 27/96 MAR

OBJETIVOS:

1- Traslada las notas de los estudiantes de un grupo a otro

2- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiarAlu(lShared,PathUno,PathDos,cCodEst,cCodGru,;
		    lHayGru,fNotFue,fNotDes,lModNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       PathUno			            // Path de Integraci¢n Uno
       PathDos			            // Path de Integraci¢n Dos
       cCodEst                              // C¢digo del estudiante
       cCodGru                              // C¢digo del grupo
       lHayGru                              // .T. Hay cambio de grupo
       fNotFue                              // Archivo fuente de notas
       fNotDes                              // Archivo destino de notas
       lModNiv                              // .T. Cambiar Nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lErrUno := .F.                 // Error Archivos Compartidos Uno
       LOCAL lErrDos := .F.                 // Error Archivos Compartidos Dos
       LOCAL lRetGru := .F.                 // .T. Retirado del grupo
       LOCAL lGrabar := .F.                 // .T. Grabar el registro
       LOCAL aStruct := {}                  // Estructura del archivo
       LOCAL xVlrCam := ''                  // Valor del Campo
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cSavPan := SAVESCREEN(0,0,24,79)
       lErrUno := .F.
       IF !EMPTY(PathUno) .AND. lHayGru .AND. FILE(fNotFue)
*	  Termometro(0,'ABRIENDO ARCHIVO FUENTE')
*	  Termometro(25)
	  IF !lUseDbf(.T.,fNotFue,'NFU',NIL,lShared)
	     cError('ABRIENDO EL ARCHIVO DE NOTAS FUENTE DEL GRUPO '+;
		    cCodGru)
	     lErrUno := .T.
	  ELSE
*	     Termometro(100)
	  ENDIF
       ELSE
	  lErrUno := .T.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !EMPTY(PathUno) .AND. lHayGru .AND. !lErrUno .AND.;
	  fNotFue # fNotDes .AND. FILE(fNotDes)

*	  Termometro(0,'ABRIENDO ARCHIVO DESTINO EN NOTAS')
*	  Termometro(25)
	  IF !lUseDbf(.T.,fNotDes,'NDE',NIL,lShared)
	     cError('ABRIENDO EL ARCHIVO DE NOTAS DESTINO DEL GRUPO '+;
		    cCodGru)
	     lErrUno := .T.
	  ELSE
*	     Termometro(100)
	  ENDIF
       ELSE
	   IF fNotFue # fNotDes
	      lErrUno := .T.
	   ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS SI EXISTE CAMBIO DE GRUPO
       lRetGru := .F.
       IF fNotFue # fNotDes
	  lRetGru := .T.
       ENDIF
*>>>>FIN ANALISIS SI EXISTE CAMBIO DE GRUPO

*>>>>GRABACION DEL ESTUDIANTE EN NOTAS FUENTE
       IF !EMPTY(PathUno) .AND. lHayGru .AND. !lErrUno

**********GRABACION DEL REGISTRO
	    SELECT NFU
	    Termometro(0,'AGREGANDO EL ESTUDIANTE EN EL GRUPO DE NOTAS')
	    Termometro(50)
	    lGrabar := !lLocCodigo('cCodigoEst','NFU',cCodEst)

	    IF lRegLock(lShared,lGrabar)
	       REPL NFU->cCodigoEst WITH cCodEst
	       REPL NFU->lRetGruNot WITH lRetGru
	       NFU->(DBCOMMIT())
	    ELSE
	       cError("NO SE GRABA EL ESTUDIANTE EN NOTAS")
	    ENDIF
	    IF lShared
	       NFU->(DBUNLOCK())
	    ENDIF
	    Termometro(100)
**********FIN GRABACION DEL REGISTRO

       ENDIF
*>>>>FIN GRABACION DEL ESTUDIANTE EN NOTAS FUENTE

*>>>>TRASLADO DE LAS NOTAS AL GRUPO DESTINO
       IF !EMPTY(PathUno)  .AND. lHayGru .AND. !lErrUno .AND. lRetGru

**********LECTURA DE LA ESTRUCTURA ACTUAL
	    Termometro(0,'TRASLADANDO LAS NOTAS POR CAMBIO DE GRUPO')
	    Termometro(20)
	    SELECT NDE
	    aStruct := {}
	    aStruct := DBSTRUCT()
**********FIN LECTURA DE LA ESTRUCTURA ACTUAL

**********GRABACION DE LAS NOTAS EN EL DESTINO
	    lGrabar := NDE->(lRegLock(lShared,;
			    !lLocCodigo('cCodigoEst','NDE',cCodEst)))

	    IF lGrabar

	       IF .NOT. lModNiv
		  FOR i := 3 TO LEN(aStruct)
		      REPL &(aStruct[i,1]) WITH NFU->(&(aStruct[i,1]))
		  ENDFOR
	       ENDIF

	       REPL NDE->cCodigoEst WITH cCodEst
	       REPL NDE->lRetGruNot WITH .F.

	       NDE->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN TRASLADAN LAS NOTAS '+;
		      'EN EL GRUPO DESTINO')
	    ENDIF

	    IF lShared
	       NDE->(DBUNLOCK())
	    ENDIF
	    Termometro(50)
**********FIN GRABACION DE LAS NOTAS EN EL DESTINO

       ENDIF
*>>>>FIN TRASLADO DE LAS NOTAS AL GRUPO DESTINO

*>>>>BORRADO DE LAS NOTAS DEL GRUPO FUENTE
       IF !EMPTY(PathUno)  .AND. lHayGru .AND. !lErrUno .AND. lRetGru

**********LECTURA DE LA ESTRUCTURA ACTUAL
	    SELECT NFU
	    aStruct := {}
	    aStruct := DBSTRUCT()
**********FIN LECTURA DE LA ESTRUCTURA ACTUAL

**********BORRADO DE LAS NOTAS
	    IF lLocCodigo('cCodigoEst','NFU',cCodEst)

	       IF NFU->(lRegLock(lShared,.F.))

		  IF .NOT. lModNiv
		     FOR i := 3 TO LEN(aStruct)

			 DO CASE
			 CASE UPPER(aStruct[i,2]) == 'C'
			      xVlrCam := SPACE(aStruct[i,3])

			 CASE UPPER(aStruct[i,2]) == 'N'
			      xVlrCam := 0

			 CASE UPPER(aStruct[i,2]) == 'D'
			      xVlrCam := CTOD('00/00/00')

			 CASE UPPER(aStruct[i,2]) == 'L'
			      xVlrCam := .F.

			 ENDCASE

			 REPL &(aStruct[i,1]) WITH xVlrCam

		     ENDFOR
		  ENDIF

		  REPL NFU->lRetGruNot WITH .T.
		  NFU->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABAN LAS NOTAS EN EL GRUPO DESTINO')
	       ENDIF

	       IF lShared
		  NFU->(DBUNLOCK())
	       ENDIF

	       Termometro(100)

	    ENDIF
**********FIN BORRADO DE LAS NOTAS

       ENDIF
       CloseDbf('NFU')
       CloseDbf('NDE')

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN BORRADO DE LAS NOTAS DEL GRUPO FUENTE


/*************************************************************************
* TITULO DE LA FUNCION..: TRASLADAR DATOS DE LA CARTERA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 27/96 MAR A
       Colombia, Bucaramanga        INICIO: 10:35 AM   AGO 27/96 MAR

OBJETIVOS:

1- Traslada los datos del cliente de los estudiantes de un grupo a otro

2- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiarCli(lShared,nModCry,PathDos,cCodEst,cCodGru,;
		    lHayGru,fCliFue,fCliDes,fPagFue,fPagDes)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       PathDos			            // Path de Integraci¢n Dos
       cCodEst                              // C¢digo del estudiante
       cCodGru                              // C¢digo del grupo
       lHayGru                              // .T. Hay cambio de grupo
       fCliFue			            // Archivo fuente de Clientes
       fCliDes			            // Archivo destino de Clientes
       fPagFue                              // Archivo fuentes de pagos
       fPagDes                              // Archivo destino de pagos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lErrUno := .F.                 // Error Archivos Compartidos Uno
       LOCAL lErrDos := .F.                 // Error Archivos Compartidos Dos
       LOCAL lRetGru := .F.                 // .T. Retirado del grupo
       LOCAL lGrabar := .F.                 // .T. Grabar el registro
       LOCAL aStruct := {}                  // Estructura del archivo
       LOCAL xVlrCam := ''                  // Valor del Campo
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cSavPan := SAVESCREEN(0,0,24,79)
       lErrDos := .F.
       IF !EMPTY(PathDos) .AND. lHayGru .AND. FILE(fCliFue) .AND. FILE(fPagFue)
*	  Termometro(0,'ABRIENDO ARCHIVOS FUENTES EN CARTERA')
*	  Termometro(25)
	  IF !lUseDbf(.T.,fCliFue,'CFU',NIL,lShared,nModCry) .OR.;
	     !lUseDbf(.T.,fPagFue,'PFU',NIL,lShared,nModCry)

	     cError('ABRIENDO LOS ARCHIVOS FUENTE DE LA CARTERA DEL GRUPO '+;
		    cCodGru)
	     lErrDos := .T.
	     CloseDbf('CFU',fCliFue,nModCry)
	     CloseDbf('PFU',fPagFue,nModCry)
	  ELSE
*	     Termometro(100)
	  ENDIF
       ELSE
	  lErrDos := .T.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !EMPTY(PathDos) .AND. lHayGru .AND. !lErrDos  .AND.;
	  fCliFue # fCliDes .AND. FILE(fCliDes) .AND. FILE(fPagDes)

*	  Termometro(0,'ABRIENDO ARCHIVOS DESTINOS EN CARTERA')
*	  Termometro(25)
	  IF !lUseDbf(.T.,fCliDes,'CDE',NIL,lShared,nModCry) .OR.;
	     !lUseDbf(.T.,fPagDes,'PDE',NIL,lShared,nModCry)

	     cError('ABRIENDO LOS ARCHIVOS DESTINOS DE LA CARTERA DEL GRUPO '+;
		    cCodGru)
	     lErrDos := .T.
	     CloseDbf('CDE',fCliDes,nModCry)
	     CloseDbf('PDE',fPagDes,nModCry)
	  ELSE
*	     Termometro(100)
	  ENDIF
       ELSE
	   IF fCliFue # fCliDes
	      lErrDos := .T.
	   ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS SI EXISTE CAMBIO DE GRUPO
       lRetGru := .F.
       IF fCliFue # fCliDes
	  lRetGru := .T.
       ENDIF
*>>>>FIN ANALISIS SI EXISTE CAMBIO DE GRUPO

*>>>>GRABACION DEL ESTUDIANTE EN CLIENTES FUENTE
       IF !EMPTY(PathDos) .AND. lHayGru .AND. !lErrDos

**********GRABACION DEL REGISTRO
	    SELECT CFU
	    Termometro(0,'AGREGANDO EL ESTUDIANTE EN EL GRUPO DE CLIENTES')
	    Termometro(50)
	    lGrabar := !lLocCodigo('cCodigoEst','CFU',cCodEst)

	    IF lRegLock(lShared,lGrabar)
	       REPL CFU->cCodigoEst WITH cCodEst
	       REPL CFU->lRetGruCli WITH lRetGru
	       CFU->(DBCOMMIT())
	    ELSE
	       cError("NO SE GRABA EL ESTUDIANTE EN CLIENTES")
	    ENDIF
	    IF lShared
	       CFU->(DBUNLOCK())
	    ENDIF
	    Termometro(100)
**********FIN GRABACION DEL REGISTRO

       ENDIF
*>>>>FIN GRABACION DEL ESTUDIANTE EN CLIENTES FUENTE

*>>>>TRASLADO DE LOS SALDOS Y PAGOS EN AL GRUPO DESTINO
       IF !EMPTY(PathDos)  .AND. lHayGru .AND. !lErrDos .AND. lRetGru

**********LECTURA DE LA ESTRUCTURA ACTUAL
	    Termometro(0,'TRASLADANDO SALDOS Y PAGOS POR CAMBIO DE GRUPO')
	    Termometro(20)
	    SELECT CDE
	    aStruct := {}
	    aStruct := DBSTRUCT()
**********FIN LECTURA DE LA ESTRUCTURA ACTUAL

**********GRABACION DE LOS SALDOS EN EL DESTINO
	    lGrabar := CDE->(lRegLock(lShared,;
			    !lLocCodigo('cCodigoEst','CDE',cCodEst)))

	    IF lGrabar

	       FOR i := 3 TO LEN(aStruct)
		   REPL &(aStruct[i,1]) WITH CFU->(&(aStruct[i,1]))
		   CDE->(DBCOMMIT())
	       ENDFOR

	       REPL CDE->cCodigoEst WITH cCodEst
	       REPL CDE->lRetGruCli WITH .F.

	    ELSE
	       cError('NO SE GRABAN TRASLADAN LOS SALDOS '+;
		      'EN EL GRUPO DESTINO')
	    ENDIF

	    IF lShared
	       CDE->(DBUNLOCK())
	    ENDIF
	    Termometro(50)
**********FIN GRABACION DE LOS SALDOS EN EL DESTINO

**********GRABACION DE LOS PAGOS EN EL DESTINO
	    SELECT PFU
	    aStruct := {}
	    aStruct := DBSTRUCT()

	    SET FILTER TO PFU->cCodigoEst == cCodEst
	    GO TOP
	    DO WHILE .NOT. PFU->(EOF())

	       SELECT PDE
	       IF PDE->(lRegLock(lShared,.T.))

		  FOR i := 1 TO LEN(aStruct)
		      REPL &(aStruct[i,1]) WITH PFU->(&(aStruct[i,1]))
		      PDE->(DBCOMMIT())
		  ENDFOR
		*ÀGrabaci¢n

*-----------------BORRADO DEL REGISTRO FUENTE
		    IF PFU->(lRegLock(lShared,.F.))

		       PFU->(DBDELETE())
		      *Marca para borrar el registro transferido

		       IF lShared
			  PDE->(DBUNLOCK())
		       ENDIF
		    ELSE
		       cError('NO SE BORRA EL REGISTRO DE PAGOS FUENTE')
		    ENDIF
*-----------------FIN BORRADO DEL REGISTRO FUENTE

	       ELSE
		  cError('NO SE GRABAN LOS PAGOS EN DESTINO')
	       ENDIF
	       IF lShared
		  PDE->(DBUNLOCK())
	       ENDIF
	       SELECT PFU
	       SKIP
	    ENDDO
	    SET FILTER TO
**********FIN GRABACION DE LOS PAGOS EN EL DESTINO

       ENDIF
*>>>>FIN TRASLADO DE LOS SALDOS Y PAGOS EN EL GRUPO DESTINO

*>>>>BORRADO DE LOS SALDOS DEL GRUPO FUENTE
       IF !EMPTY(PathDos)  .AND. lHayGru .AND. !lErrDos .AND. lRetGru

**********LECTURA DE LA ESTRUCTURA ACTUAL
	    SELECT CFU
	    aStruct := {}
	    aStruct := DBSTRUCT()
**********FIN LECTURA DE LA ESTRUCTURA ACTUAL

**********BORRADO DE LOS SALDOS
	    IF lLocCodigo('cCodigoEst','CFU',cCodEst)

	       IF CFU->(lRegLock(lShared,.F.))

		  FOR i := 3 TO LEN(aStruct)

		      DO CASE
		      CASE UPPER(aStruct[i,2]) == 'C'
			   xVlrCam := SPACE(aStruct[i,3])

		      CASE UPPER(aStruct[i,2]) == 'N'
			   xVlrCam := 0

		      CASE UPPER(aStruct[i,2]) == 'D'
			   xVlrCam := CTOD('00/00/00')

		      CASE UPPER(aStruct[i,2]) == 'L'
			   xVlrCam := .F.

		      ENDCASE

		      REPL &(aStruct[i,1]) WITH xVlrCam

		  ENDFOR

		  REPL CFU->lRetGruCli WITH .T.
		  CFU->(DBCOMMIT())
	       ELSE
		  cError('NO SE BORRAN LOS SALDOS EL GRUPO DESTINO')
	       ENDIF

	       IF lShared
		  CFU->(DBUNLOCK())
	       ENDIF

	       Termometro(100)

	    ENDIF
**********FIN BORRADO DE LOS SALDOS

       ENDIF
       CloseDbf('CFU',fCliFue,nModCry)
       CloseDbf('CDE',fCliDes,nModCry)
       CloseDbf('PFU',fPagFue,nModCry)
       CloseDbf('PDE',fPagDes,nModCry)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN BORRADO DE LOS SALDOS DEL GRUPO FUENTE
