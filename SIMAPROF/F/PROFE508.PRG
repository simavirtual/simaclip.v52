/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : INDICADORES
SUBMODULO...: CLASIFICAR

**************************************************************************
* TITULO..: CLASIFICACION DE LOS INDICADORES                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 22/2008 VIE A
       Colombia, Bucaramanga        INICIO:  04:00 PM  FEB 22/2008 VIE

OBJETIVOS:

1- Permite modificar los c¢digos de la clasificaci¢n de los indicadores.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_508(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cSavCab := ''                  // Salvar Encabezado
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nColIni := 0                   // Columna Inicial
       LOCAL nFilFin := 19                  // Fila Final de Control

       LOCAL nRegCla := 0                   // Registro de la Clase
       LOCAL nLenCod := 6                   // Longitud del C¢digo
       LOCAL nNroPer := 0                   // N£mero del periodo

       LOCAL nNroLog := 1                   // N£mero de logro escogido

       LOCAL nNroInd := 0                   // N£mero de indicadores
       LOCAL cLogros := ''                  // Logros aplicados
       LOCAL cNotInd := ''                  // Nota de los Indicadores
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodigo := ''                  // C¢digo de Logro

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL cEvaInd := ''                  // Evaluar el Indicador
       LOCAL lHayNot := .F.                 // .T. Hay nota definitiva
       LOCAL lNotNum := .F.                 // .T. Nota N£merica .F. Nota Cualitativa
       LOCAL cValNot := ''                  // Validaci¢n de la nota

       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cCodIndTsi := ''               // C¢digo de Subindicadores
     *ÀVariables de Campo

       LOCAL GetList := {}                  // Variable del Sistema
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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 fNroInd+cMaeAct+cAnoSis+ExtFile,'NRO',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileSin+cMaeAct+cAnoSis+ExtFile,'SIN',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FProTbl+cMaeAct+ExtFile,'TPR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+ExtFile,'IND',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxInd+cMaeAct+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+;
			 fMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared,nModCry})
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
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS CLASES DE INDICADORES')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE MAP->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS DEL PROFESOR GRABADAS')

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRA->nModRegAno # 0
	    cError('NO ESTA PERMITIDO ASOCIAR INDICADORES PARA EL '+cAnoUsr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lHayErr := .F.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DE LA MATERIA
       SELECT MAP
       IF MAP->(RECCOUNT()) # 1

**********INICIALIZACION DE LAS COORDENADAS
	    nFilSup := nFilInf+2
	    nColSup := nColInf
	    IF nFilSup+RECCOUNT() > 22
	       nInfFil := 21
	    ELSE
	       nInfFil := nFilSup + RECCOUNT()-1
	    ENDIF
	    nInfCol := nColSup+LEN(MAP->cNombreMat)+2
**********FIN INICIALIZACION DE LAS COORDENADAS

**********BROWSE DE SELECCION
	    DO WHILE .T.
	       IF nBrowseDbf(nFilSup,02,nInfFil,78,;
			     {||MAP->cCodigoNiv+' '+MAP->cNombreMat}) == 0
		  CLOSE ALL
		  RETURN NIL
	       ENDIF
	       cMsgTxt := 'ESCOGIO '+ALLTRIM(MAP->cNombreMat)+;
			  IF(TCO->lIndNivTbl,' DEL NIVEL '+MAP->cCodigoNiv,'')
	       cMsgTxt := SUBS(cMsgTxt,1,50)

	       IF lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
		  EXIT
	       ENDIF
	    ENDDO
**********FIN BROWSE DE SELECCION

       ENDIF
       cCodigoTni := MAP->cCodigoNiv
       cCodigoTma := MAP->cCodigoMat
       cNombreTma := ALLTRIM(MAP->cNombreMat)
*>>>>FIN SELECCION DE LA MATERIA

*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,'DE LA MATERIA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,;
			 ALLTRIM(cNombreTma),22,'°')
       @ nNroFil,01 SAY 'CODIGO'
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>DETERMINACION DE COLS Y LONGITUD DE NOMBRE
       nNroCol := 10
      *Escoge la columna seg£n el n£mero de notas

       nFilIni := 06
       nColIni := nNroCol
       nNroFil := nFilIni
*>>>>FIN DETERMINACION DE COLS Y LONGITUD DE NOMBRE

*>>>>IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS
       i := 1
       DO WHILE i <= 10
	  @ nNroFil,nNroCol SAY 'IND'+LTRIM(STR(i))
	  i++
	  nNroCol := nNroCol + 6
       ENDDO

       nNroCol = nNroCol - (i-1)*6
       nNroFil = nNroFil + 1
      *Ubica la fila primera de grabacion

       cSavCab := SAVESCREEN(nNroFil-1,0,nNroFil-1,79)
       cSavLin := SAVESCREEN(21,0,22,79)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS

*>>>>GRABACION DE LAS NOTAS DE LOS ESTUDIANTES
       nNroPer := 1
       lIndNiv := .T.
       cEvaInd := '0'
       nNroLog := 0
       cLogros := SUBS(SPACE(200),1,nNroInd*nLenCod)
       cNotInd := SUBS(SPACE(200),1,nNroInd*nLenCod)
       lHayNot := .F.
       lNotNum := .F.
       cNotDef := SPACE(04)
       cValNot := SPACE(04)

       cCodigoTgr := cCodigoTni+'00'

       DO WHILE .T.

**********CAPTURA DEL CODIGO A CLASIFICAR
	    nColIni = 1
	    nNroInd = 1
	    cLogros := SUBS(SPACE(200),1,nNroInd*nLenCod)

	    IF !lLeeLogro(cNomSis,@nNroFil,nColIni,nNroPer,lIndNiv,;
			  cEvaInd,cCodigoTgr,cCodigoTni,nNroInd,;
			  nNroLog,@cLogros,cNotInd,;
			  lHayNot,lNotNum,@cNotDef,cValNot,cSavLin)
	       LOOP
	    ENDIF
	    IF EMPTY(cLogros)
	       EXIT
	    ENDIF
	    cCodLog := SUBS(cLogros,1,4)
**********FIN CAPTURA DEL CODIGO A CLASIFICAR

**********LOCALIZACION DE LA CLASE
	    IF !lLocCodigo('cCodigoCla','CLA',SUBS(cCodLog,1,1),'DE LA CLASE')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DE LA CLASE

**********VALIACION DEL CODIGO A CLASIFICAR
	     IF !lSekCodigo(IF(lIndNiv,;
			       cCodigoTni+cCodigoTma+cCodLog,;
			       cCodigoTma+cCodLog),'IND')
		cError('EL CODIGO: '+cCodLog+' DE '+;
		       ALLTRIM(CLA->cNombreCla)+' NO EXISTE')
		LOOP
	     ENDIF
**********FIN VALIACION DEL CODIGO A CLASIFICAR

**********VALIDACION DE LA CLASE
	    lHayErr := .T.
	    DO CASE
	    CASE CLA->cSubCodCla == '0' .OR.;
		 CLA->cSubCodCla == SPACE(01)

		 cError(ALLTRIM(CLA->cNombreCla)+'.'+;
			'NO ESTAN HABILITADOS PARA SER CLASIFICADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       LOOP
	    ENDIF
**********VALIDACION DE LA CLASE

**********LOCALIZACION DE LA CLASIFICACION
	    SELECT SIN
	    SIN->(DBGOTOP())

	    LOCATE FOR SIN->cCodGruSin == cCodigoTni+'00' .AND.;
		       SIN->cCodMatSin == cCodigoTma      .AND.;
		       SIN->cCodLogSin == cCodLog

	    IF FOUND()
	       cCodInd := SIN->cCodIndSin
	    ELSE
	       cCodInd := cSpaces('SIN','cCodIndSin')
	    ENDIF
**********FIN LOCALIZACION DE LA CLASIFICACION

**********VALIDACION DE INSERTAR REGISTROS
	    IF EMPTY(TPR->cInsSubTbl) .AND. EMPTY(cCodInd)
	       cError('EL CODIGO:'+cCodLog+' NO ESTA CLASIFICADO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE INSERTAR REGISTROS

**********LOCALIZACION DE LA CLASE
	    IF !lLocCodigo('cCodigoCla','CLA',CLA->cSubCodCla,'DE LA CLASE')
	       LOOP
	    ENDIF
	    nRegCla := CLA->(RECNO())
**********FIN LOCALIZACION DE LA CLASE

**********LECTURA DE SUBINDICADORES
	    cLogros := ''
	    FOR i := 1 TO IF(EMPTY(TPR->cInsSubTbl),CLA->nSubCodCla,10)
		cLogros += SUBS(cCodInd,4*i-3,4)+SPACE(02)
	    ENDFOR
**********FIN LECTURA DE SUBINDICADORES

**********CAPTURA Y VALIDACION DE LOS LOGROS
	    nColIni = nNroCol
	    nNroInd = IF(EMPTY(TPR->cInsSubTbl),CLA->nSubCodCla,10)

	    IF !lLeeLogro(cNomSis,@nNroFil,nColIni,nNroPer,lIndNiv,;
			  cEvaInd,cCodigoTgr,cCodigoTni,nNroInd,;
			  nNroLog,@cLogros,cNotInd,;
			  lHayNot,lNotNum,@cNotDef,cValNot,cSavLin)
	       LOOP
	    ENDIF
**********FIN CAPTURA Y VALIDACION DE LOS LOGROS

**********CORREGIR LAS NOTAS
	    IF !lPregunta('Desea Grabar? Si No')
	       IF nNroInd > 10
		  nNroFil--
		  nNroCol := nColIni
	       ENDIF
	       LOOP
	    ELSE
	       RESTSCREEN(21,0,22,79,cSavLin)
	    ENDIF
**********FIN CORREGIR LAS NOTAS

**********VALIDACION DE LOS SUBINDICADORES
	    IF EMPTY(cLogros)
	       cError('NO DIGITO CODIGOS PARA CLASIFICAR')
	       LOOP
	    ENDIF

	    CLA->(DBGOTO(nRegCla))
	    lHayErr := .T.
	    cCodIndTsi := ''
	    FOR i := 1 TO IF(EMPTY(TPR->cInsSubTbl),CLA->nSubCodCla,10)

		cCodInd := SUBS(cLogros,i*6-5,6)
		cCodigo := cCodLog

		lHayErr := .T.
		DO CASE
		CASE !EMPTY(SUBS(cCodInd,1,4)) .AND.;
		     SUBS(cLogros,1,1) # SUBS(cCodInd,1,1)

		     cError('EL CODIGO:'+SUBS(cCodInd,1,4)+' '+;
			    'DEBE SER DE LA MISMA CLASE')

		CASE cCodLog == SUBS(cCodInd,1,4)

		     cError('NO SE PUEDE CLASIFICAR EL MISMO CODIGO:'+;
			    SUBS(cCodInd,1,4))

		CASE lHayCodSin(cCodigoTni+'00',cCodigoTma,;
				SUBS(cCodInd,1,4),@cCodigo)

		     cError('EL CODIGO:'+SUBS(cCodInd,1,4)+' '+;
			    'YA ESTA CLASIFICADO EN EL CODIGO:'+cCodigo)

		OTHERWISE
		     lHayErr :=.F.
		ENDCASE

		IF lHayErr
		   EXIT
		ENDIF
		cCodIndTsi += SUBS(cCodInd,1,4)
	    ENDFOR
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS SUBINDICADORES

**********LOCALIZACION DE LA CLASIFICACION
	    SELECT SIN
	    SIN->(DBGOTOP())

	    LOCATE FOR SIN->cCodGruSin == cCodigoTni+'00' .AND.;
		       SIN->cCodMatSin == cCodigoTma      .AND.;
		       SIN->cCodLogSin == cCodLog

	    IF .NOT. FOUND()
	       IF SIN->(lRegLock(lShared,.T.))

		  REPL SIN->cCodGruSin WITH cCodigoTni+'00'
		  REPL SIN->cCodMatSin WITH cCodigoTma
		  REPL SIN->cCodLogSin WITH cCodLog
		  SIN->(DBCOMMIT())

	       ELSE
		  cError('NO SE GRABA EL CONTROL DE LOS INDICADORES')
	       ENDIF
	       IF lShared
		  SIN->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DE LA CLASIFICACION

**********GRABACION DE LOS SUBINDICADORES
	    IF !EMPTY(cCodIndTsi)

	       IF SIN->(lRegLock(lShared,.F.))
		  REPL SIN->cCodIndSin WITH cCodIndTsi

		  SIN->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL CONTROL DE LOS INDICADORES')
	       ENDIF
	       IF lShared
		  SIN->(DBUNLOCK())
	       ENDIF

	    ENDIF
**********FIN GRABACION DE LOS SUBINDICADORES

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > nFilFin

*--------------IMPRESION DE LOS ENCABEZADOS
		 nNroFil := nMarco(nFilPal+1,;
				   ALLTRIM(cNombreTma),22,'°')
*--------------IMPRESION DE LOS ENCABEZADOS

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LAS NOTAS DE LOS ESTUDIANTES

/*************************************************************************
* TITULO..: BUSQUEDA DE CODIGO CLASIFICADO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/2008 MIE A
       Colombia, Bucaramanga        INICIO:  04:00 PM  MAR 12/2008 MIE

OBJETIVOS:

1- Permite buscar si el c¢digo ya ha sido clasificado.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHayCodSin(cCodGru,cCodMat,cCodInd,cCodLog)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       cCodMat                              // C¢digo de la Materia
       cCodInd				    // C¢digo del Indicador
       cCodLog			            // @C¢digo del Logro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 1                   // Contador
       LOCAL cCodigo := ''                  // C¢digo del Indicador
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lHayCod := .F.                 // .T. Hay C¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DE LA CLASIFICACION
       SELECT SIN
       nNroReg := SIN->(RECNO())
       SET FILTER TO SIN->cCodGruSin == cCodGru .AND.;
		     SIN->cCodMatSin == cCodMat

       SIN->(DBGOTOP())
       IF SIN->(EOF())
	  SET FILTER TO
	  RETURN lHayCod
       ENDIF
*>>>>FIN FILTRACION DE LA CLASIFICACION

*>>>>RECORRIDO DEL ARCHIVO
       SELECT SIN
       SIN->(DBGOTOP())
       DO WHILE .NOT. SIN->(EOF())

	  FOR i := 1 TO 10

	      cCodigo := SUBS(SIN->cCodIndSin,i*4-3,4)

	      IF !EMPTY(cCodigo) .AND. cCodInd == cCodigo

		 IF EMPTY(cCodLog)
		    cCodLog := SIN->cCodLogSin
		    lHayCod := .T.
		    EXIT
		 ELSE
		    IF cCodLog # SIN->cCodLogSin
		       cCodLog := SIN->cCodLogSin
		       lHayCod := .T.
		       EXIT
		    ENDIF
		 ENDIF

	      ENDIF

	  ENDFOR

	  SIN->(DBSKIP())

       ENDDO
       SET FILTER TO
       SIN->(DBGOTO(nNroReg))
       RETURN lHayCod
*>>>>FIN RECORRIDO DEL ARCHIVO