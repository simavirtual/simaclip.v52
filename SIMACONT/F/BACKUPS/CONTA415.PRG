/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR ESTUDIANTE                            MODULO No. 401

**************************************************************************
* TITULO..: ASIGNATURAS I O D                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2002 MAR A
       Colombia, Bucaramanga        INICIO: 12:45 PM   NOV 19/2002 MAR


OBJETIVOS:

1- Imprime los estudiantes con asignaturas Insuficiente o Deficiente.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_415(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                 // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"      // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileApr,'APR',NIL,lShared,nModCry})
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
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       cGruIni := GRU->cCodigoGru

       IF CON->lPrnArcCon
	  SET PRINTER TO &(PathPrn+'\'+cGruIni+cGruFin+'.401')
       ENDIF
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF CON->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'stdid'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CON->cOpcPrnCon,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","ProporOf","CondenOn"})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LAS ESTADISTICAS
	    MateriasID(lShared,cNomEmp,cNomSis,cAnoUsr,nNroPer,;
		       cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,;
		       FilePrn,nOpcPrn)
**********FIN IMPRESION DEL RESUMEN

**********AVANCE AL SIGUIENTE REGISTRO
	    nNroIni := 1
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

/*************************************************************************
* TITULO..: CUADRO DE RESUMEN DE LOGROS DE LOS ESTUDIANTES               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 23/2002 MAR A
       Colombia, Bucaramanga        INICIO: 03:00 PM   JUL 23/2002 MAR

OBJETIVOS:

1- Imprime las Estadisticas por Estudiante

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MateriasID(lShared,cNomEmp,cNomSis,cAnoUsr,nNroPer,;
		    cMaeAct,cJorTxt,nNroIni,nNroFin,cGruFin,;
		    FilePrn,nOpcPrn)


*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroPer				    // N£mero del bimestre
       cMaeAct                              // Maestro Actual
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cNotDef                              // Nota Definitiva de Selecci¢n
       cJorTxt                              // Jornada escogida
       cGruFin                              // Grupo Final
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
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
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aMateID := {}                  // Materia Insuficiente o Deficiente
       LOCAL aNroLin := {}                  // N£mero de l¡neas
     *ÀVariables Espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cDescriTap := ''               // Descripci¢n de Promoci¢n
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'PERIODO No.'+STR(nNroPer,2),;
		   'ESTUDIANTES CON INSUFICIENTE O DEFICIENTE',;
		   'GRUPO: '+GRU->cCodigoGru}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,NIL,lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,2)
       AADD(aTitPrn,'No')

       AADD(aNroCol,30)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')

       AADD(aNroCol,80)
       AADD(aTitPrn,'ASIGNATURAS CON INSUFICIENTE O DEFICIENTE')

       AADD(aNroCol,12)
       AADD(aTitPrn,'JUICIO')
       cCabCol := cRegPrint(aTitPrn,@aNroCol)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroPer,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********ANALISIS DE MATERIAS INSUFICIENTES O DEFICIENTES
	     aMateID := {}
	     aRegPrn := {}
	     EstMatID(aNotAre,aNotMat,nNroPer,TCO->lRecNotTbl,@aMateID)

	     IF LEN(aMateID) # 0
		FOR i := 1 TO LEN(aMateID)
		    aRegPrn := {}
		    IF i == 1
		       AADD(aRegPrn,NOT->cCodigoEst)
		       AADD(aRegPrn,&cMaeAct->cCodigoGru)
		       AADD(aRegPrn,STR(NOT->(RECNO()),2))
		       AADD(aRegPrn,cNombreTes)
		    ELSE
		       AADD(aRegPrn,SPACE(06))
		       AADD(aRegPrn,SPACE(06))
		       AADD(aRegPrn,SPACE(02))
		       AADD(aRegPrn,SPACE(30))
		    ENDIF
		    AADD(aRegPrn,aMateID[i,1])
		    AADD(aRegPrn,aMateID[i,3])

		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

		ENDFOR
	     ENDIF
**********FIN ANALISIS DE MATERIAS INSUFICIENTES O DEFICIENTES

**********IMPRESION DE ESTADO DE APROBACION
	    IF LEN(aMateID) # 0 .AND. TCO->nTotPerTbl==nNroPer

	       IF lRetiroTes
		  cDescriTap := 'NO TERMINO. SE RETIRO EN '+;
				 cFecha(&cMaeAct->dFecRetEst)
		  cTxtObsTap := ''

	       ELSE
		  cDescriTap := cAproboJui(NOT->nAproboNot,;
					   SUBS(&cMaeAct->cCodigoGru,1,2),;
					   @cTxtObsTap)
	       ENDIF

	       aNroLin := aDivLin(ALLTRIM(cDescriTap),80)
	       FOR i := 1 TO LEN(aNroLin)

		  cDescriTap := SUBS(aNroLin[i]+SPACE(80),1,80)
		  aRegPrn := {}
		  AADD(aRegPrn,STR(NOT->nAproboNot,2))
		  AADD(aRegPrn,'')
		  AADD(aRegPrn,'')
		  AADD(aRegPrn,'')
		  AADD(aRegPrn,cDescriTap)
		  AADD(aRegPrn,'')

		  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	       NEXT

	       IF !EMPTY(cTxtObsTap)

		  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),80)
		  FOR i := 1 TO LEN(aNroLin)
		     cTxtObsTap := SUBS(aNroLin[i]+SPACE(80),1,80)
		     aRegPrn := {}
		     AADD(aRegPrn,'')
		     AADD(aRegPrn,'')
		     AADD(aRegPrn,'')
		     AADD(aRegPrn,'OBSERVACION')
		     AADD(aRegPrn,cTxtObsTap)
		     AADD(aRegPrn,'')

		     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		  ENDFOR
	       ENDIF

	    ENDIF
**********FIN IMPRESION DE ESTADO DE APROBACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('NOT')
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EJECT
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: MATERIAS DEL ESTUDIANTE CON INSUFICIENTE O DEFICIENTE        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2002 MAR A
       Colombia, Bucaramanga        INICIO: 03:15 PM   NOV 19/2002 MAR

OBJETIVOS:

1- Determina el n£mero de materias con juicio valorativo Insuficiente o
   Deficiente.

3- Retorna un vector con las materias.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstMatID(aNotAre,aNotMat,nNroPer,lRecNot,aMateID)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       lRecNot                              // .T. Recuperar el Juicio Valorativo
       aMateID                              // Materia Insuficiente o Deficiente */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j := 0                       // Contadores
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>MATERIAS CON INSUFICIENTE O DEFICIENTE
       aMateID := {}
       lHayItv := lHayItvJvf()
       FOR i := 1 TO LEN(aNotAre)

***********ANALISIS DE LA MATERIA NO RECUPERABLE
	     IF aNotAre[i][15]
		LOOP
	     ENDIF
***********FIN ANALISIS DE LA MATERIA NO RECUPERABLE

***********ANALISIS JUICIO VALORATIVO DEL AREA
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		cCamNotDef := aNotAre[i,4]
		cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		IF lHayItv
		   cNotDef := cNotDefJvf(VAL(cNotDef))
		   cNotRec := cNotDefJvf(VAL(cNotRec))
		ENDIF

		IF lRecNot .AND. !EMPTY(cNotRec)
		   cNotDef := cNotRec
		ENDIF

		IF UPPER(cNotDef) == 'I' .OR. UPPER(cNotDef) == 'D'

		   AADD(aMateID,{aNotAre[i,10],;
				 cNotDef,;
				 IF (UPPER(cNotDef) == 'I',;
				     'INSUFICIENTE','DEFICIENTE'),;
				 aNotAre[i,7]})
		ENDIF
	     ENDIF
***********FIN ANALISIS JUICIO VALORATIVO DEL AREA

***********ANALISIS DE LA MATERIA
	     FOR j:=1 TO LEN(aNotMat)

*................ANALISIS DE LA MATERIA NO RECUPERABLE
		   IF aNotMat[j,15]
		      LOOP
		   ENDIF
*................ANALISIS DE LA MATERIA NO RECUPERABLE

*................ANALISIS DEL JUICIO VALORATIVO
		   IF aNotAre[i,2] == aNotMat[j,1]

		      cCamNotDef := aNotMat[j,4]
		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		      cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		      cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		      IF lHayItv
			 cNotDef := cNotDefJvf(VAL(cNotDef))
			 cNotRec := cNotDefJvf(VAL(cNotRec))
		      ENDIF

		      IF lRecNot .AND. !EMPTY(cNotRec)
			 cNotDef := cNotRec
		      ENDIF

		      IF UPPER(cNotDef) == 'I' .OR. UPPER(cNotDef) == 'D'
			 AADD(aMateID,{aNotMat[j,10],;
				       cNotDef,;
				       IF (UPPER(cNotDef) == 'I',;
					   'INSUFICIENTE','DEFICIENTE'),;
				       aNotMat[j,7]})


		      ENDIF
		   ENDIF
*................FIN ANALISIS DEL JUICIO VALORATIVO

	     ENDFOR
***********FIN ANALISIS DE LA MATERIA

       ENDFOR
       RETURN NIL
*>>>>FIN MATERIAS CON INSUFICIENTE O DEFICIENTE
