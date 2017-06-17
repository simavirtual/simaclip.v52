/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : LISTADOS
SUBMODULO...: LISTAS PROVISIONALES

**************************************************************************
* TITULO..: LISTAS DE CLASE POR PROFESOR                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 29/97 MIE A
       Bucaramanga, Colombia	    INICIO: 05:40 PM   ENE 29/97 MIE

OBJETIVOS:

1- Permite imprimir las listas de clase de cada profesor.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_3111(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL PathNot := ''                  // Path de Notas
       LOCAL nNroBis := 0                   // N£mero del peri¢do
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL nTipBol := 0                   // Tipo de Boletin
       LOCAL nNroLin := 0                   // N£mero de l¡neas para las listas
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL lProfes := .F.                 // .T. Si SimaProf
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTpr := ''               // Nombre del Profesor
       FIELD cCodigoGru                     // C¢digo del Grupo
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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>FILTRACION DE LOS PROFESORES
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro .AND.;
		     PRO->lCargasPro .AND. !PRO->lRetiroPro
       GO TOP
       IF EOF()
	  cError('NO EXISTEN PROFESORES PARA '+cMaeAct)
	  SET FILTER TO
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervPro(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE LINEAS
       nNroLin := 1
       @ nFilInf+3,nColInf SAY 'NRO LINEAS' GET nNroLin PICT '99'
       READ
       IF nNroLin == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DEL NUMERO DE COPIA
       @ nFilInf+4,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>IMPRESION POR GRUPOS
       SELECT PRO
       GO nRegIni
       DO WHILE PRO->(RECNO()) <= nRegFin

**********VALIDACION DE LA CARGA ACADEMICA
	    DO CASE
	    CASE !PRO->lCargasPro
		 cError('NO TIENE CARGA ACADEMICA')

	    CASE !(cMaeAct $ PRO->cMaeAluPro)
		 cError('NO TIENE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)
**********FIN VALIDACION DE LA CARGA ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF FILE(PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		    PRO->cCodigoPro+'\'+'CARPRO'+cAnoSis+ExtFile)
	       lProfes := .T.
	       FileCar := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  PRO->cCodigoPro+'\'+'CARPRO'+cAnoSis+ExtFile
	    ELSE
	       lProfes := .F.
	       FileCar := cPatSis+'\'+cMaeAct+'\'+;
			  'CARGA'+cMaeAct+ExtFile
	    ENDIF

	    IF !lUseDbf(.T.,FileCar,'CAR',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE CARGA ACADEMICA')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAR->(RECCOUNT()) == 0
		 cError('NO EXISTEN REGISTROS DE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********FILTRACION DE LA CARGA ACADEMICA
	    SELECT CAR
	    GO TOP
	    IF !lProfes
	       SET FILTER TO CAR->cCodigoPro == PRO->cCodigoPro
	       GO TOP
	       IF EOF()
		  cError('NO EXISTE CARGA PARA EL PROFESOR')
		  SET FILTER TO
		  SELECT PRO
		  PRO->(DBSKIP())
	       ENDIF
	    ENDIF
**********FIN FILTRACION DE LA CARGA ACADEMICA

**********IMPRESION DE N COPIAS
	    nNroCop := 1
	    DO WHILE nNroCop <= nCopias

*--------------RECORRIDO DE LA CARGA ACADEMICA
		 nTipBol := 3
		 SELECT CAR
		 nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
		 DO WHILE .NOT. CAR->(EOF())

*...................INICIALIZACION DEL PATH DE NOTAS
		      cCodGru := SUBS(CAR->cCodigoCar,5,4)
		      IF lProfes
			 PathNot := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				    PRO->cCodigoPro+'\'
			 FileNot := CAR->cCodigoCar+ExtFile
		      ELSE
			 PathNot := cPatSis+'\'+cMaeAct+'\NOTAS\'
			 FileNot := 'NT'+cCodGru+cAnoSis+ExtFile
		      ENDIF
*...................FIN INICIALIZACION DEL PATH DE NOTAS

*...................SELECION DE LAS AREAS DE TRABAJO
		      IF !lUseDbf(.T.,PathNot+FileNot,'NOT',NIL,lShared)
			 cError('ABRIENDO EL ARCHIVO DE NOTAS')
			 IF lPregunta('DESEA CONTINUAR? Si No')
			    EXIT
			 ENDIF
			 CLOSE ALL
			 RETURN NIL
		      ENDIF
		      lLocCodigo('cCodigoMat','MAT',SUBS(CAR->cCodigoCar,1,4))
*...................FIN SELECION DE LAS AREAS DE TRABAJO

*...................VISUALIZACION DE LA CARGA
		      @ nNroFil,01 SAY 'CURSO: '+cCodGru+' '+;
				       ALLTRIM(MAT->cNombreMat)
		      nNroFil++
		      IF nNroFil == 21
			 nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
		      ENDIF
*...................FIN VISUALIZACION DE LA CARGA

*...................IMPRESION DE LA LISTA DE CLASE
		      ListaClase(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
				 cNombreTpr,nNroBis,;
				 nTipBol,nNroLin,;
				 SUBS(CAR->cCodigoCar,5,4),;
				 MAT->cNombreMat,;
				 cMaeAct,cJorTxt,lProfes)
*...................FIN IMPRESION DE LA LISTA DE CLASE

		    CloseDbf('NOT')
		    CAR->(DBSKIP())

		 ENDDO
		 CloseDbf('NOT')
		 nNroCop++
*--------------FIN RECORRIDO DE LA CARGA ACADEMICA

	    ENDDO
	    SELECT CAR
	    IF !lProfes
	       SET FILTER TO
	    ENDIF
	    CloseDbf('CAR')
**********FIN IMPRESION DE N COPIAS

	  SELECT PRO
	  PRO->(DBSKIP())

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION POR GRUPOS