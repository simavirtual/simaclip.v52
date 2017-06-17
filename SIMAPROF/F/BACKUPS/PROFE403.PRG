/* SIMA - CONTABILIDAD PROFESORES

MODULO      : RECUPERACIONES
SUBMODULO...: LISTAR

**************************************************************************
* TITULO..: IMPRIME LOS LOGROS NO RECUPERADOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 30/2002 JUE A
       Colombia, Bucaramanga        INICIO: 04:00 AM   MAY 30/2002 JUE

OBJETIVOS:

1- Imprime los logros que no han sido recuperados por el Estudiante.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_403(aP1,aP2,aP3)

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

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el Indicador
       LOCAL lHayNot := .F.                 // .T. Hay nota definitiva
       LOCAL lNotNum := .F.                 // .T. Nota N£merica .F. Nota Cualitativa
       LOCAL cValNot := ''                  // Validaci¢n de la nota

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
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL cSecInd := ''                  // Secuencial del Indicador
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nNroInd := 20                   // N£mero de Indicadores
       LOCAL cCamNot := ''                  // Campo de Notas
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cCamDef := ''                  // Campo de Definitivas
       LOCAL cCamObs := ''                  // Campo de Observaciones
       LOCAL nTipPla := 0                   // Tipo del Plan
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Nombre del Indicador

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
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)               .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared)
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
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES DE LA CONTABILIDAD')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE LOGROS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lHayErr := .F.
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
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       cCamNot := 'NOP->cNotas'+STR(nNroPer,1,0)+'NoP'
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cCamObs := 'NOP->cObsev'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervCaP(nFilInf+1,01,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE COPIA
       @ nFilInf+3,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lIndNiv := TCO->lIndNivTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       IF lNotNum
	  cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
       ELSE
	  IF EMPTY(TCO->cValNumTbl)
	     cValNot := ALLTRIM(TCO->cValNotTbl)+SPACE(01)
	  ELSE
	     cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'debe'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE N COPIAS
       SET DEVICE TO SCREEN
       DO WHILE nNroCop <= nCopias

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO'+'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			 STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRISION DE LOS GRUPOS
	    SELECT CAP
	    GO nRegIni
	    DO WHILE CAP->(RECNO()) <= nRegFin

*-------------ANALISIS DEL TIPO DE PLAN ACADEMICO
		cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
		cCodigoTma := SUBS(CAP->cCodigoCar,1,4)

		nTipPla := 0
		IF !('XXXX' $ cCodigoTgr)
		   nTipPla := nTipoPlan(SUBS(cCodigoTgr,1,2))
		   IF nTipPla == 0
		      CAP->(DBSKIP())
		      LOOP
		   ENDIF
		ENDIF
*-------------FIN ANALISIS DEL TIPO DE PLAN ACADEMICO

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
		    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				cFilePlan(cAnoUsr,cCodigoTgr),;
				'PLA',NIL,lShared)
		       cError('ABRIENDO ARCHIVO DEL PLAN DE ESTUDIOS')

		       CAP->(DBSKIP())
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,cPatPro+'\'+;
				 CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
		    cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+;
		    cCodigoTgr)

		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------VALIDACION DE CONTENIDOS DE ARCHIVOS
		 lHayErr := .T.
		 DO CASE
		 CASE !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1 .AND.;
		      PLA->(RECCOUNT()) == 0
		      cError('NO EXISTE REGISTROS DEL PLAN ACADEMICO')

		 CASE NOP->(RECCOUNT()) == 0
		      cError('NO EXISTEN ESTUDIANTES')
		 OTHERWISE
		      lHayErr :=.F.
		 ENDCASE

		 IF lHayErr
		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*--------------LOCALIZACION DE LA MATERIA EN PLAN
		 lMatVarMat(cCodigoTma,.F.)
		 IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
		    IF !lLocCodigo('cCodigoMat','PLA',MAT->cCodigoMat)
		       cError('LA MATERIA: '+cCodigoTma+;
			       'NO EXISTE EN PLAN DE: '+cCodigoTgr)
		       CAP->(DBSKIP())
		       LOOP
		    ENDIF
		 ENDIF
		 IF MAT->lNoRecuMat
		    CAP->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIA EN PLAN

*--------------IMPRESION PLANILLA FINAL
		 lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
		 IF TCO->lNotPlaTbl
		    IF !('XXXX' $ cCodigoTgr)
		       lHayNot := IF(SUBS(PLA->cHayNotPla,nNroPer,1)='1',.T.,.F.)
		    ENDIF
		 ELSE
		    lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
		 ENDIF

		 PrnIndRec(lShared,cNomUsr,cPatPro,;
			   cNomSis,cNomEmp,cMaeAct,nNroPer,;
			   cCodigoTma,nNroInd,cNomPro,cCodigoTgr,;
			   ALLTRIM(CAP->cNombreMat),;
			   lEvaInd,lHayNot,lNotNum)
*--------------FIN IMPRESION PLANILLA FINAL

	       CAP->(DBSKIP())
	       CloseDbf('NOP')
	       CloseDbf('PLA')

	    ENDDO
**********FIN IMPRISION DE LOS GRUPOS

	  nNroCop++

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO..: INDICADORES POR RECUPERAR                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 28/96 MIE A
       Bucaramanga,Colombia         INICIO: 05:00 PM   MAR 28/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de notas del profesor

2- Imprime la relaci¢n de los logros aplicados a cada estudiante

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndRec(lShared,cNomUsr,cPatPro,cNomSis,cNomEmp,cMaeAct,nNroPer,;
		   cCodMat,nNroInd,cNomPro,cCodGru,cNomMat,lEvaInd,lHayNot,;
		   lNotNum)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomMat                              // Nombre de la Materia
       nTotReg                              // Total de Registros
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cMaeAlu                              // Maestros Habilitados
       cCodNiv                              // C¢digo de Nivel
       lEvaInd                              // .T. Evaluar Indicador
       lHayNot                              // .T. Hay Nota
       lNotNum                              // .T. Nota N£merica  */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL lSiorNo := .F.                 // .T. Control de Flujo
       LOCAL nTotPag := 0                   // Total P ginas
       LOCAL nLenCod := 6                   // Longitud del C¢digo

       LOCAL   i,k,y := 0                   // Contador
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nColIni := 0                   // Columna Inicial
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cCampos := ''                  // Definici¢n de Campo
       LOCAL cCamNot := ''                  // Campo de Notas
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cCamDef := ''                  // Campo de Definitivas
       LOCAL cCamObs := ''                  // Campo de Observaciones
       LOCAL cLogros := ''                  // Logros
       LOCAL cRecupe := ''                  // Indicadores por Recuperar
       LOCAL aNroCol := {}                  // N£mero de Columnas
       LOCAL aLenNom := {}                  // Longitud de Nombres
       LOCAL aNoRecu := {}                  // Indicadore no Recuperados
       LOCAL nIndMin := 0                   // Indicadores Minimos
       LOCAL lHayRec := .F.                 // .T. Recuperaciones
       LOCAL lRecAnt := .F.                 // .T. Recuperaciones Anteriores
       LOCAL nNroRec := 0                   // N£mero de Recuperaciones
       LOCAL cChrRec := SPACE(01)           // Character para Recuperaciones
       LOCAL cCodRec := ''                  // C¢digo de Recuperaci¢n

       LOCAL nLenNom := 0                   // Longitud del Nombre
       LOCAL cNomMae := ''                  // Nombre Maestro Habilitado

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETERMINACION DE COLS Y LONGITUD DE NOMBRE
       IF lHayNot
	  aNroCol := {43,37,31,32,63}
	  aLenNom := {31,25,18,18,50}
       ELSE
	  aNroCol := {43,37,31,38,63}
	  aLenNom := {31,25,18,26,50}
       ENDIF

       nIndMin := IF(nNroInd >10,10,nNroInd)
       nNroCol := IF(nIndMin < 7,aNroCol[5],aNroCol[nIndMin-6])
      *Escoge la columna seg£n el n£mero de notas

       nLenNom := IF(nIndMin < 7,aLenNom[5],aLenNom[nIndMin-6])
       nLenNom := 50
      *Escoge la longitud del nombre

       nFilIni := 06
       nNroFil := nFilIni
       nColIni := nNroCol
*>>>>FIN DETERMINACION DE COLS Y LONGITUD DE NOMBRE

*>>>>PREPARACION DE VARIABLES DE CAMPO
       cCamNot := 'NOP->cNotas'+STR(nNroPer,1,0)+'NoP'
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cCamObs := 'NOP->cObsev'+STR(nNroPer,1,0)+'NoP'
       cChrRec := ALLTRIM(SUBS(TCO->cCfgBolTbl,3,1))
*>>>>FIN PREPARACION DE VARIABLES DE CAMPO

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_On(SPR->lPrnArcSpr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       nLenPrn := n17Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOP
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('ºGRUPO:'+cCodGru+'º'+;
			cNomMat+'º'+;
			'REG:'+NOP->(STR(RECNO(),4))+'/'+;
				    NOP->(STR(RECCOUNT(),4)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cCodigoTgr := &cMaeAct->cCodigoGru
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS DEL RETIRO
	    DO CASE
	    CASE lRetiroTes
		 cNombreTes += ' RETIRADO'

	    CASE NOP->lRetiroNoP .AND. CAP->nTipCarCar == 0
		 cNombreTes += ' OTRO GRUPO'

	    ENDCASE
**********FIN ANALISIS DEL RETIRO

**********ANALISIS DE LOS INDICADORES POR RECUPERAR
	    lRecAnt := .F.
	    aNoRecu := {}
	    FOR i := 1 TO nNroPer
		cCampos := 'NOP->cIndic'+STR(i,1,0)+'NoP'
		cLogros := SUBS(&cCampos,1,nNroInd*nLenCod)
		cRecupe := cIndxRecu(cLogros,i)
		AADD(aNoRecu,cRecupe)
		IF !EMPTY(cRecupe)
		   lRecAnt := .T.
		ENDIF
	    ENDFOR
	    cLogros := ''
**********FIN ANALISIS DE LOS INDICADORES POR RECUPERAR

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina .AND. lRecAnt

*--------------ENCABEZADO DEL INFORME
		 lSiorNo := .T.
		 nTotPag++
		 EncabezPrn(cNomEmp,cNomSis,;
			    cNomMat,;
			    'INDICADORES POR RECUPERAR ACUMULADOS No. '+;
			    STR(nNroPer,2),;
			    'GRUPO: '+cCodGru,;
			    nNroPag++,;
			    NIL)
*--------------FIN ENCABEZADO DEL INFORME

*--------------IMPRESION DEL NOMBRE DEL PROFESOR
		 @ PROW()+2,00 SAY 'PROFESOR: '
		 @ PROW()  ,10 SAY SUBRAY_ON+cNomPro+SUBRAY_OF
*--------------FIN IMPRESION DEL NOMBRE DEL PROFESOR

*--------------IMPRESION DE LOS ENCABEZADOS DE COLUMNA
		 IF nNroInd > 10
		    @ PROW(),00 SAY DRAFT_ON+ELITE+CONDEN_ON
		 ELSE
		    @ PROW(),00 SAY DRAFT_ON+PICA+CONDEN_ON
		 ENDIF
		 @ PROW()+1,00 SAY 'No.'
		 @ PROW()  ,04 SAY 'CODIGO'
		 @ PROW()  ,11 SAY 'NOMBRES'
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CODIGO Y NOMBRE DEL ESTUDIANTE
	    IF lRecAnt
	       SELECT NOP
	       @ PROW()+1,00 SAY RECNO()                 PICT '99'
	       @ PROW()  ,04 SAY cCodigoTes		 PICT "999999"
	       @ PROW()  ,11 SAY cNombreTes              PICT "@A"
	    ENDIF
**********FIN IMPRESION DEL CODIGO Y NOMBRE DEL ESTUDIANTE

**********IMPRESION DE INDICADORES POR RECUPERAR
	    IF lRecAnt
	       FOR k := 1 TO LEN(aNoRecu)

		   nNroCol = nColIni
		   cRecupe := aNoRecu[k]

		   IF !EMPTY(cRecupe)
		      nNroRec := ROUND(LEN(ALLTRIM(cRecupe))/nLenCod,0)
		      @ PROW()+1,11 SAY 'POR RECUPERAR P'+STR(k,1)

		      FOR y := 1 TO nNroRec
			  cCodLog := SUBS(cRecupe,y*6-5,6)
			  @ PROW(),nNroCol SAY '*'+cCodLog PICT 'XXXXXX'
			  nNroCol = nNroCol + 6
		      ENDFOR
		   ENDIF
	       ENDFOR
	    ENDIF
	    nNroCol = nNroCol - (I-1)*6
**********FIN IMPRESION DE INDICADORES POR RECUPERAR

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := IF(lSiorNo,.F.,.T.)
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<IMPRIMIR RECUPERACIONES>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})          // Obligatorio
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})          // Obligatorio
	  AADD(aGenLog,{'nNroPerLog',nNroPer})          // Obligatorio
	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)}) // Obligatorio
	  AADD(aGenLog,{'cHorIniLog',cHorIni})          // Obligatorio
	  AADD(aGenLog,{'cHorFinLog',TIME()})           // Obligatorio

	  AADD(aGenLog,{'nPrnPlaLog',nTotPag})

	  cTxtLog :=  ALLTRIM(cNomMat)+' GRUPO: '+cCodGru
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})
	*ÀNovedades de la Opci¢n

	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
       ENDIF

       RETURN NIL
*>>>>FIN GRABACION DEL LOG
