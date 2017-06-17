/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: LISTAS DE CLASE

**************************************************************************
* TITULO..: IMPRIME LAS LISTAS DE CLASE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2007 LUN A
       Colombia, Bucaramanga        INICIO: 10:15 AM   ABR 23/2007 LUN

OBJETIVOS:

1- Permite imprimir las listas de clase del profesor con solo los nombres
   de los estudiantes.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_105(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual

       LOCAL nNroPer := 0                   // N£mero de Periodos
       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nIndTot := 20                  // Total de Indicadores
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL cSecInd := ''                  // Secuencial del Indicador
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Nombre del Indicador

STATIC nNroArc

       FIELD cCodigoMat                     // C¢digo de la materia
       FIELD cCodigoCla                     // C¢digo de la clase
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
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)   .OR.;
	  !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)               .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
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
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervCaP(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'listaNom'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.F.,2)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR ASIGNACION ACADEMICA
       SET DEVICE TO SCREEN
       SELECT CAP
       GO nRegIni
       DO WHILE CAP->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			    CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	       cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+;
		      SUBS(CAP->cCodigoCar,5,4))

	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
	    DO CASE
	    CASE NOP->(RECCOUNT()) == 0
		 cError('NO EXISTEN ESTUDIANTES DEL GRUPO: '+cCodigoTgr)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LISTA
	    Lista_2(lShared,cNomEmp,cNomSis,cAnoUsr,cNomPro,nNroPer,;
		    cCodigoTgr,CAP->cNombreMat,cMaeAct,cJorTxt,;
		    FilePrn,nOpcPrn,@nNroArc)
**********FIN IMPRESION DE LA LISTA

	  CAP->(DBSKIP())
	  CloseDbf('NOP')

       ENDDO
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nNroArc)
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR ASIGNACION ACADEMICA

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO..: IMPRESION DE LA LISTA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2007 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   ABR 23/2007 LUN

OBJETIVOS:

1- Imprime una lista de clase para el grupo determinado

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Lista_2(lShared,cNomEmp,cNomSis,cAnoUsr,cNomPro,nNroPer,;
		 cCodGru,cNomMat,cMaeAct,cJorTxt,FilePrn,nOpcPrn,;
		 nHanXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario
       cNomPro                              // Nombre del Profesor
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del grupo
       cNomMat                              // Nombre de la Materia
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n
       nHanXml                              // Manejador del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales


       LOCAL nRegPrn := 0                   // Registro de Impresi¢n

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

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetiroTno := .F.              // .T. Estudiante de Otro Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   ALLTRIM(cNomMat),;
		   'Prof: '+cNomPro,;
		   'GRUPO: '+cCodGru+' '+;
		   'PERIODO No. '+STR(nNroPer,1)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,4)
       AADD(aTitPrn,'No.')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,60)
       AADD(aTitPrn,'APELLIDOS Y NOMBRES')

       AADD(aNroCol,22)
       AADD(aTitPrn,'OBSERVACION')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
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
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(60),1,60)
	    lRetiroTno := NOP->lRetiroNoP
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS DE FUERA DE LISTA
	    IF lRetiroTno .AND. CAP->nTipCarCar # 0
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE FUERA DE LISTA

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    AADD(aRegPrn,STR(NOP->(RECNO()),2))
	    AADD(aRegPrn,NOP->cCodigoEst)
	    AADD(aRegPrn,cNombreTes)

	    DO CASE
	    CASE lRetiroTes
		 AADD(aRegPrn,'RETIRADO')

	    CASE lRetiroTno
		 IF CAP->nTipCarCar # 0
		    AADD(aRegPrn,'FUERA DE LISTA')
		 ELSE
		    AADD(aRegPrn,'PERTENECE A OTRO GRUPO')
		 ENDIF

	    CASE !lRetiroTes .AND. !lRetiroTno
		 AADD(aRegPrn,'')
	    ENDCASE
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

	  NOP->(DBSKIP())

       ENDDO

       EVAL(bDerAut)
      *Impresi¢n de Derechos

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       EJECT

       SET DEVICE TO SCREEN
*       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

