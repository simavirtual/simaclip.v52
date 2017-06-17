/* SIMA - CONTABILIDAD PROFESORES

MODULO      : RECUPERACIONES
SUBMODULO...: RECUPERAR

**************************************************************************
* TITULO..: DEFINIR RECUPERACIONES                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/2010 LUN A
       Colombia, Bucaramanga        INICIO: 08:30 AM   JUL 15/2010 LUN


OBJETIVOS:

1- Permite la grabar las recuperaciones del estudiante

2- Permite recuperar la nota del promedio acumulado de la materia en el
   periodo.

3- Permite recuperar la nota del promedio sin ninguna restricci¢n

4- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Spr_401_99(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL cSavCab := ''                  // Salvar Encabezado
       LOCAL       i := 0                   // Contador

       LOCAL nPerAct := 0                   // Periodo Actual

       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior

       LOCAL lOtrFil := .F.                 // .T. Otra Fila
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL nFilCab := 0                   // File de Encabezado

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas

       LOCAL nColIni := 0                   // Columna Inicial
       LOCAL nFilFin := 19                   // Fila Final de Control

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL cEvaInd := ''                  // Evaluar el Indicador
       LOCAL lNotNum := .F.                 // .T. Nota N£merica .F. Nota Cualitativa
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL nValNot := ''                  // Validaci¢n de la nota
       LOCAL lHayRec := .F.                 // .T. Hay Recuperaciones
       LOCAL  cJvfSi := ""                  // Juicios Valorativos Si Aprobados
       LOCAL  cJvfNo := ""                  // Juicios Valorativos No Aprobados

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nNroPer := 0                   // N£mero del periodo

       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL aLenNom := {}                  // Longitud de nombres
       LOCAL nLenNom := 0                   // Longitud del nombre
       LOCAL nNroInd := 20                   // N£mero de indicadores
       LOCAL nNroRec := 0                   // N£mero de Recuperaciones
       LOCAL nIndMin := 0                   // Indicador M¡nimo para control
       LOCAL nNroLog := 0                   // N£mero de logro escogido
       LOCAL lOtrEst := .F.                 // .T. Otro Estudiante

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL nLenCod := 6                   // Longitud del C¢digo
       LOCAL nLenNtI := 8                   // Longitud del C¢digo de la Nota de la Recuperaci¢n del Indicador
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL lHayNot := .F.                 // .T. Hay Nota

       LOCAL cLogros := ''                  // Logros aplicados
       LOCAL cCodLog := ''                  // C¢digo del logro

       LOCAL cLogNot := ''                  // Logros de Notas
       LOCAL cNotInd := ''                  // Nota de los Indicadores en Notas
       LOCAL cNotDef := ''                  // Nota Definitiva en Notas
       LOCAL cNotRec := ''                  // Nota Recuperaci¢n
       LOCAL nNotRec := 0                   // Nota Recuperaci¢n
       LOCAL cPromed := ''                  // Nota del Promedio

       LOCAL cLogNoP := ''                  // Logros de Notas del Profesor
       LOCAL cNtINoP := ''                  // Nota de los Indicadores en Profesor
       LOCAL cNoPDef := ''                  // Nota Definitiva en Profesor
       LOCAL cNoPRec := ''                  // Nota Recuperaci¢n en Notas

       LOCAL cRecupe := ''                  // Indicadores por Recuperar
       LOCAL nPosInd := ''                  // Posici¢n del Indicador
       LOCAL lRecNot := .F.                 // .T. Recuperar Nota

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := ''                  // Hora de Inicio
       LOCAL lHayLog := .F.                 // .T. Hay Log
       LOCAL lLeeRec := .T.                 // .T. Leer Recuperaci¢n
     *ÀVariables del Log

       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas 

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL nTipCarTca := 0                // Tipo de carga

       LOCAL cCamIndNot := ''               // Campo Indicadores en Notas
       LOCAL cCamNtINot := ''               // Campo de Nota de Indicadores
       LOCAL cCamNotDef := ''               // Campo Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo Notas de Recuperaci¢n
       LOCAL cCamProNot := ''               // Campo Promedio Acumulado

       LOCAL cCamIndNoP := ''               // Campo Indicadores en Notas Profesor
       LOCAL cCamNtINop := ''               // Campo de Nota de Indicadores
       LOCAL cCamNoPDef := ''               // Campo Nota Definitvia en Notas Profesor
       LOCAL cCamNoPRec := ''               // Campo Nota Recuperaci¢n en Notas Profesor

       LOCAL lMatSelTma := .F.              // .T. Materia Selectiva

       LOCAL cIndic1Tlo := ''               // Indicadores Antes
       LOCAL cDefRe1Tlo := ''               // Recuperaci¢n Antes
     *ÀVariables de Campo

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES


*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)  .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeACt+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FProTbl+cMaeAct+ExtFile,'TPR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
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

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES DE LA CONTABILIDAD')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE LOGROS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>PERIODO ACTUAL
       nNroPer := IF(EMPTY(PRO->nNroPerPro),TCO->nPerActTbl-1,PRO->nNroPerPro)
       @ nFilPal,65 SAY 'Peri¢do No: '+STR(nNroPer,1)
*>>>>FIN PERIODO ACTUAL

*>>>>LOCALIZACION DEL PROFESOR
       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       IF !lLocCodigo('cCodigoPro','PRO',cCodigoTpr,'DEL PROFESOR')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PROFESOR

*>>>>SELECCION DE LA MATERIA DEL GRUPO
       SELECT CAP
       IF CAP->(RECCOUNT()) # 0

**********INICIALIZACION DE LAS COORDENADAS
	    nFilSup := nFilInf+2
	    nColSup := nColInf
	    IF nFilSup+RECCOUNT() > 22
	       nInfFil := 21
	    ELSE
	       nInfFil := nFilSup + RECCOUNT()-1
	    ENDIF
	    nInfCol := nColSup+LEN(CAP->cNombreMat)+2
**********FIN INICIALIZACION DE LAS COORDENADAS

**********BROWSE DE SELECCION
	    DO WHILE .T.

*--------------SELECCION DEL REGISTRO
		 SELECT CAP
		 IF nBrowseDbf(nFilSup,02,nInfFil,78,;
			      {||SUBS(CAP->cCodigoCar,5,4)+' '+;
			       Materia()}) == 0
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
		 lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))
		 lMatSelTma := MAT->lMatSelMat
		 IF MAT->lNoRecuMat
		    cError('LA MATERIA ES NO RECUPERABLE')
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
*--------------FIN SELECCION DEL REGISTRO

*--------------PREGUNTA DE DECISION
		 cMsgTxt := 'ESCOGIO '+ALLTRIM(CAP->cNombreMat)+' '+;
			    'DEL GRUPO: '+SUBS(CAP->cCodigoCar,5,4)
		 cMsgTxt := SUBS(cMsgTxt,1,50)

		 IF lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
		    EXIT
		 ENDIF
*--------------FIN PREGUNTA DE DECISION

	    ENDDO
**********FIN BROWSE DE SELECCION

       ENDIF
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTni := SUBS(cCodigoTgr,1,2)
       cCodigoTma := SUBS(CAP->cCodigoCar,1,4)
       nTipCarTca := CAP->nTipCarCar
*>>>>FIN SELECCION DE LA MATERIA DEL GRUPO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)

	  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL DEL PROFESOR '+;
		 CAP->cCodigoCar)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS DE LOS '+;
				   'ESTUDIANTES DE '+;
				   ALLTRIM(CAP->cNombreMat),22,'°')

       nLenNom := 40
       nNroCol := 1
       aTamCol := {06,nLenNom,08,10}
       aTitulo := {'CODIGO','NOMBRE','PROMEDIO','RECUPERACION'}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt

       cSavCab := SAVESCREEN(nFilCab,0,nFilCab,79)
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nValNot := VAL(ALLTRIM(TCO->cValNumTbl))
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD


*>>>>GRABACION DE LAS NOTAS DE LOS ESTUDIANTES
       cSavLin := SAVESCREEN(21,0,22,79)
       lOtrEst := .T.
       DO WHILE lOtrEst

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cHorIni := TIME()
	    RESTSCREEN(nFilCab,0,nFilCab,79,cSavCab)
	    cCodigoTes := cLeeCodEst(nNroFil,01,cMaeAct,@cNalias)
	    RESTSCREEN(21,0,22,79,cSavLin)
	    IF EMPTY(cCodigoTes) .OR. cNalias == NIL
	       lOtrEst := .F.
	       LOOP
	    ENDIF
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********CALCULO DEL CAMPO DE INDICADORES DE NOTAS
	    IF !lMatSelTma
	       cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
					PathUno+'\'+cPatSis,nNroPer,;
					cCodigoTgr,cCodigoTma,NIL,;
					@cCamNotDef,@cCamNotRec,;
					@cCamNtINot)

	       IF EMPTY(cCamIndNot) .OR.;
		  EMPTY(cCamNotDef) .OR. EMPTY(cCamNotRec)
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ENDIF
	    cCamIndNoP := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
	    cCamNtINoP := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
	    cCamNoPDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
	    cCamNoPRec := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
**********FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

**********CALCULO DEL CAMPO DE INDICADORES DE NOTAS
	    IF lMatSelTma
	       CloseDbf('PLA')
	       CloseDbf('NOT')
	       cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
					PathUno+'\'+cPatSis,;
					nNroPer,&cNalias->cCodigoGru,;
					cCodigoTma,.T.,@cCamNotDef,;
					@cCamNotRec,@cCamNtINot)
	       IF EMPTY(cCamIndNot)
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    cNotDef := ''
	    cNotRec := ''
	    IF lLocCodigo('cCodigoEst','NOT',cCodigoTes)

	       cCamProNot := 'NOT->cAc'+SUBS(cCamNotDef,9,4)+'Not'
		  cPromed := SUBS(&cCamProNot,nNroPer*5-4,5)
		  cPromed := VAL(cPromed)
		  cPromed := STR(cPromed,4,1)

	       cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
	       cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
	       IF !EMPTY(cNotRec)
		  cNotDef := cNotRec
	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR
	    cNoPDef := ''
	    cNoPRec := ''
	    IF lLocCodigo('cCodigoEst','NOP',cCodigoTes)

	       cNoPDef := &cCamNoPDef
	       cNoPRec := &cCamNoPRec
	       IF !EMPTY(cNoPRec)
		  cNoPDef := cNoPRec
	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR

**********VALIDACION DE LOS REGISTROS
	    IF NOT->cCodigoEst # NOP->cCodigoEst
	       cError('LOS CODIGOS:'+NOT->cCodigoEst+':'+NOP->cCodigoEst+' '+;
		      'DEL ESTUDIANTE NO SON IGUALES')
	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE LOS REGISTROS

**********CONSULTA DEL REGISTRO
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)

	    cNombreTes := SUBS(cNombreTes+SPACE(nLenNom),1,nLenNom)

	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY cPromed
**********FIN CONSULTA DEL REGISTRO

**********LECTURA DE LA NOTA
	     nNotRec := VAL(cNotRec)
	     @ nNroFil,aNroCol[4];
		       GET nNotRec PICT '99.9';
		       VALID {|oLeeGet|lValNota(oLeeGet,nValNot,VAL(cPromed))}
	     READ
	     cNotRec := IF(nNotRec==0,SPACE(04),STR(nNotRec,4,1))
**********FIN LECTURA DE LA NOTA

**********GRABACION DE LAS RECUPERACIONES EN NOTAS
	    SELECT NOT
	    IF NOT->(lRegLock(lShared,.F.))

	       REPL &cCamNotRec WITH STUFF(&cCamNotRec,nNroPer*4-3,4,cNotRec)
	      *Grabaci¢n de la nota de Recuperaci¢n.

	       NOT->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LA RECUPERACION DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOT->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LAS RECUPERACIONES EN NOTAS

**********GRABACION DE LAS RECUPERACIONES EN NOTAS DEL PROFESOR
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,.F.))

	       REPLACE &cCamNoPRec WITH cNotRec
	      *Grabaci¢n de la nota de Recuperaci¢n

	       REPL NOP->cNomUsrNop WITH cNomUsr
	       REPL NOP->dFecUsrNop WITH DATE()
	       REPL NOP->cHorUsrNop WITH TIME()

	       NOP->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LA RECUPERACION DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LAS RECUPERACIONES EN NOTAS DEL PROFESOR

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
				   'DE LOS ESTUDIANTES DE '+;
				   ALLTRIM(CAP->cNombreMat),22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY cPromed
		 @ nNroFil,aNroCol[4] SAY cNotRec

		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LAS NOTAS DE LOS ESTUDIANTES

/*************************************************************************
* TITULO..: VALIDACION DE LA NOTA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/2011 VIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   JUL 15/2011 VIE

OBJETIVOS:

1- Valida el rango de la nota n£merica


4- Retorna .T. si no se presentaron problemas


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/
                              
FUNCTION lValNota(oLeeGet,nValNot,nNotDef)

*>>>>DESCRIPCION DE PARAMETROS
/*     oLeeGet                              // Objeto de Lectura
       nValNot                              // Validaci¢n de la Nota
       nNotDef                              // Nota definitiva */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNota   := 0                   // Nota a validar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION
       nNota := oLeeGet:VarGet()
*>>>>FIN INICIALIZACION

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE nNota > nValNot
	    cError('NOTA POR FUERA DE RANGO:'+STR(nNota,4,1))

       CASE nNotDef # NIL .AND. nNota > 0 .AND. nNota <= nNotDef
	    cError('NOTA DEBE SER MAYOR A:'+ALLTRIM(STR(nNotDef,4,1)))

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       RETURN !lHayErr
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS