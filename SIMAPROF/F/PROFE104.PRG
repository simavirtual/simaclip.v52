/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: GRABAR ESTUDIANTES

**************************************************************************
* TITULO..: GRABAR ESTUDIANTES                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 10/1998 MAR A
       Colombia, Bucaramanga        INICIO: 11:30 PM   MAR 10/1998 MAR


OBJETIVOS:

1- Permite permite escoger los estudiantes que optaron por cierta asignatura.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_104(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL cCodAre := ''                  // C¢digo del Area
       LOCAL cSecPro := ''                  // Secuecial de la materia del profesor
       LOCAL cSecMat := ''                  // Secuencial de la materia grabado
       LOCAL lInsSel := .F.                 // .T. Insertar Registro Seleccion
       LOCAL lInsNoP := .T.                 // .T. Insertar Registro en notas del profesor
       LOCAL lRetEst := .F.                 // Borrar el Estudiante
       LOCAL lHayAlu := .F.                 // .T. Estudiante en Lista

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL nNroLisTes := 0                // N£mero de Lista
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
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis)   .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileSel+cMaeAct+ExtFile,'SEL',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       fNtxSel+cMaeAct+cExtNtx,lShared)           .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE JARDIN')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE PRIMARIA')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE BACHILLERATO')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO APARECE LA CARGA DEL PROFESOR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lSelCarga(nFilInf+1,nColInf,@nNroReg,'MATERIA ')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       GO nNroReg
       cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>VALIDACION DE LA CARGA SELECCIONADA
       IF CAP->nTipCarCar == 0
	  cError('A '+ALLTRIM(CAP->cNombreMat)+' NO SE LE PUEDEN AGREGAR '+;
		 'ESTUDIANTES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA CARGA SELECCIONADA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,!lShared)
	  cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+;
		 SUBS(CAP->cCodigoCar,5,4))
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS DE LOS '+;
				   'ESTUDIANTES DE '+;
				   ALLTRIM(CAP->cNombreMat),22,'°')
       nNroCol := 1
       aTamCol := {06,40,06}
       aTitulo := {'CODIGO','NOMBRE','CURSO '}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS REGISTROS
       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAct,@cNalias)
	    IF EMPTY(cCodigoTes) .OR. cNalias == NIL
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    cFilePlan(cAnoUsr,&cNalias->cCodigoGru),;
			    'PLA',NIL,lShared)

	       cError('ABRIENDO ARCHIVOS')
	       CloseDbf('PLA')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE LA ASIGNATURA VARIABLE
	    IF !lMatVarMat(cCodigoTma)
	       cError(ALLTRIM(CAP->cNombreMat)+;
		      ' NO PERTENECE A UNA ASIGNATURA VARIABLE')
	       CloseDbf('PLA')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA ASIGNATURA VARIABLE

**********VALIDACION QUE LA MATERIA PERTENESCA AL PLAN ACADEMICO
	    IF !lLocCodigo('cCodigoMat','PLA',MAT->cCodigoMat)
	       cError(cNombreTes+' NO VE '+ALLTRIM(CAP->cNombreMat,;
		      'CODIGO:'+MAT->cCodigoMat))
	       CloseDbf('PLA')
	       LOOP
	    ENDIF
	    CloseDbf('PLA')
**********FIN VALIDACION QUE LA MATERIA PERTENESCA AL PLAN ACADEMICO

**********VALIDACION DEL ESTUDIANTE
	    lHayErr := .T.
	    lRetEst := .F.
	    lInsNoP := .T.
	    lHayAlu := .F.
	    DO CASE
	    CASE lLocCodigo('cCodigoEst','NOP',cCodigoTes)

		 lInsNoP := .F.
		 lHayAlu := .T.
		 IF !NOP->lRetiroNoP

		    cError('EL ESTUDIANTE YA ESTA SELECCIONADO')

		    IF lPregunta('DESEA SACAR DE LA LISTA A '+;
				  cNombreTes+'? No Si')
		       IF lPregunta('ESTA SEGURO? No Si')
			  lRetEst := .T.
			  lHayErr := .F.
		       ENDIF
		    ENDIF
		 ELSE

		    cError('EL ESTUDIANTE APARECE RETIRADO DE LA LISTA')

		    IF lPregunta('DESEA ACTIVAR EN LA LISTA A '+;
				  cNombreTes+'? No Si')
		       IF lPregunta('ESTA SEGURO? No Si')
			  lRetEst := .F.
			  lHayErr := .F.
		       ENDIF
		    ENDIF
		 ENDIF

	    CASE CAP->nTipCarCar == 1 .AND.;
		 SUBS(CAP->cCodigoCar,5,4) # &cNalias->cCodigoGru

		 cError('DEBE SELECCIONAR ESTUDIANTES DEL GRUPO '+;
			SUBS(CAP->cCodigoCar,5,4))

	    CASE CAP->nTipCarCar == 2 .AND.;
		 SUBS(CAP->cCodigoCar,5,2) # SUBS(&cNalias->cCodigoGru,1,2)

		 cError('DEBE SELECCIONAR ESTUDIANTES DEL NIVEL '+;
			SUBS(CAP->cCodigoCar,5,2))

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL ESTUDIANTE

**********VALIDACION DE LA SELECCION DE LA MATERIA
	    cCodAre := SUBS(CAP->cCodigoCar,1,2)
	    cSecPro := SUBS(CAP->cCodigoCar,3,2)
	    lInsSel := .T.
	    IF lRetEst
	       lInsSel := .F.
	       cSecPro := SPACE(02)
	    ENDIF

	    IF lSekCodigo(cCodigoTes+cCodAre,'SEL')

*--------------VALIDACION DE YA SELECIONADO
		 lInsSel := .F.
		 IF !EMPTY(SEL->cSecProSel) .AND. !lRetEst

		    IF lLocCodigo('cCodigoMat','MAT',+cCodAre+SEL->cSecProSel)
		       IF MAT->nMatVarMat == 0
			  cError(cNombreTes+' FIGURA '+ALLTRIM(MAT->cNombreMat))
			  CloseDbf('PLA')
			  LOOP
		       ELSE
			  lInsSel := .T.
		       ENDIF
		    ELSE
		       cError(cNombreTes+;
			      ' FIGURA EN UNA ASIGNATURA QUE NO EXISTE')
		       CloseDbf('PLA')
		       LOOP
		    ENDIF

		 ENDIF
*--------------FIN VALIDACION DE YA SELECIONADO

	    ENDIF
**********FIN VALIDACION DE LA SELECCION DE LA MATERIA

**********LECTURA DEL GRUPO
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY &cNalias->cCodigoGru+;
				     IF(!lInsNoP .AND. lRetEst,;
					' ELIMINADO','')
**********FIN LECTURA DEL GRUPO

**********GRABACION DEL ESTUDIANTE
	    nNroLisTes := 0
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,lInsNoP))
	       IF lInsNoP
		  REPL NOP->cCodigoEst WITH cCodigoTes
	       ENDIF
	       REPL NOP->lRetiroNoP WITH lRetEst
	       NOP->(DBCOMMIT())
	       nNroLisTes := NOP->(RECNO())
	    ELSE
	       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABAR LAS NOTAS

**********GRABACION DE LA SELECCION
	    IF !lHayAlu .OR. !MAT->lPorNivMat
	       SELECT SEL
	       IF SEL->(lRegLock(lShared,lInsSel))
		  REPL SEL->cCodigoEst WITH cCodigoTes
		  REPL SEL->cCodAreSel WITH cCodAre
		  REPL SEL->cSecProSel WITH cSecPro
		  REPL SEL->cCodigoPro WITH cCodigoTpr
		  IF .NOT. EMPTY(nNroLisTes)
		     REPL SEL->nNroLisEst WITH nNroLisTes
		  ENDIF
		  SEL->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	       ENDIF
	       IF lShared
		  SEL->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DE LA SELECCION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
				   'DE LOS ESTUDIANTES DE '+;
				   ALLTRIM(CAP->cNombreMat),22,'°')
		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY &cNalias->cCodigoGru
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS