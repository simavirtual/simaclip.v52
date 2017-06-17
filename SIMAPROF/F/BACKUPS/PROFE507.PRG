/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : MANTENIMIENTO
SUBMODULO...: TRASLADAR2

**************************************************************************
* TITULO..: TRASLADO DE TODOS LOS INDICADORES DEL A¥O ANTERIOR           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 26/2008 LUN A
       Colombia, Bucaramanga        INICIO:  04:00 PM  ENE 26/2008 LUN

OBJETIVOS:

1- Permite trasladar todas los indicadores por materia y por nivel

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_507(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"        // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nPerAct := 0                   // Periodo Actual
       LOCAL nNroPer := 0                   // N£mero del periodo

       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas

       LOCAL cIdePad := ''                  // Id del Indicador Padre
       LOCAL cSecPad := ''                  // Secuencial del Indicador del padre
       LOCAL cClaPad := ''                  // C¢digo de la Clase del Indicador del Padre
       LOCAL cNomPad := ''                  // Nombre de la Clase del Indicador del Padre

       LOCAL nRegCla := 0                   // Registro de la Clase

       LOCAL cSecInd := ''                  // Secuencial del Indicador

       LOCAL cMatAnt := ''                  // Materia traslado de Indicadores
       LOCAL cNivAnt := ''                  // Grado traslado de Indicadores
       LOCAL cClaAnt := ''                  // Clase de Indicador traslado de indicadores
       LOCAL cIndAnt := ''                  // C¢digo del Indicador a trasladar
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cNombreTcl := ''               // Nombre de la Clase

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia

       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cCodPadTju := ''               // C¢digo del Indicador del Padre
       LOCAL cIdeCodTju := ''               // C¢digo de Identificaci¢n del Indicador
       LOCAL cNombreTju := ''               // Nombre del Indicador
       LOCAL cExtra1Tju := ''               // Nombre del Indicador Extra 1

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PATH DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
*>>>>FIN PATH DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatAnt+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+SUBS(cAnoAnt,3,2)+ExtFile,'JUI',;
			 PathUno+'\'+cPatAnt+'\'+cMaeAct+'\'+;
			 FNtxInd+cMaeAct+SUBS(cAnoAnt,3,2)+cExtNtx,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FNroInd+cMaeAct+cAnoSis+ExtFile,'NRO',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+ExtFile,'IND',;
			 cPatSis+'\'+cMaeAct+'\'+;
			 FNtxInd+cMaeAct+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+;
			 FMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+;
			 FileLog,'LOG',NIL,lShared,nModCry})
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
       CASE JUI->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES A TRASLADAR')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORE GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS CLASES DE INDICADORES')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LOS GRADOS DE ESTUDIO')

       CASE MAP->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS DEL PROFESOR GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRA->nModRegAno # 0
	    cError('NO ESTA PERMITIDO TRASLADAR TODOS LOS INDICADORES PARA EL '+cAnoUsr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nTotPer := TCO->nTotPerTbl
       nPerAct := TCO->nPerActTbl
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer)
       IF nNroPer == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>SELECCION DE LA MATERIA
       IF nSelMap(nFilInf+1,00) == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       cMsgTxt := 'ESCOGIO '+ALLTRIM(MAP->cNombreMat)+;
		  IF(TCO->lIndNivTbl,' DEL NIVEL '+MAP->cCodigoNiv,'')
       cMsgTxt := SUBS(cMsgTxt,1,50)

       IF !lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cCodigoTni := MAP->cCodigoNiv
       cCodigoTma := MAP->cCodigoMat
	  cNivAnt := cCodigoTni
*>>>>FIN SELECCION DE LA MATERIA

*>>>>LOCALIZACION DEL NIVEL
       IF !lLocCodigo('cCodigoNiv','NIV',cCodigoTni)
	  cError('EL GRADO '+cCodigoTni+' '+;
		 'PARA GRABACION GENERAL')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	  cError('CODIGO '+cCodigoTma+' DE LA MATERIA NO EXISTE')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>VALIDACION DE LOS INDICADORES A TRASLADAR
       IF EMPTY(MAT->cMatIndMat)
	  cError('NO ESTA HABILITADA PARA TRASLADAR INDICADORES',;
		 cCodigoTma+':'+ALLTRIM(MAT->cNombreMat))
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cMatAnt := MAT->cMatIndMat
*>>>>FIN VALIDACION DE LOS INDICADORES A TRASLADAR

*>>>>FILTRACION DE LOS INDICADORES
       SELECT JUI
       IF TCO->lIndNivTbl
	  SET FILTER TO SUBS(JUI->cCodigoJui,1,4) == cCodigoTma .AND.;
			JUI->cCodigoNiv == cCodigoTni
       ELSE
	  SET FILTER TO SUBS(JUI->cCodigoJui,1,4) == cCodigoTma
       ENDIF
       JUI->(DBGOTOP())
       IF JUI->(EOF())
	  cError('NO HAY INDICADORES '+;
		 IF(TCO->lIndNivTbl,'DE NIVEL','DE MATERIA')+' '+;
		 'DE CONTABILIDAD PARA '+ALLTRIM(MAT->cNombreMat)+' '+;
		 'DE '+ALLTRIM(CLA->cNombreCla))
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS INDICADORES

*>>>>RECORRIDO POR CLASE DE INDICADORES
       CLA->(DBGOTOP())
       DO WHILE .NOT. CLA->(EOF())

**********VALIDACION DE LA CLASE DE INDICADOR A TRASLADAR
	    IF EMPTY(CLA->cCodAllCla)
	       CLA->(DBSKIP())
	       LOOP
	    ENDIF
	       cClaAnt := CLA->cCodAllCla
	    cCodigoTcl := CLA->cCodigoCla
**********FIN VALIDACION DE LA CLASE DE INDICADOR A TRASLADAR

**********LECTURA DEL CODIGO DE LA CLASE DEL PADRE
	    cClaPad := ''
	    cCodPadTju := ''

	    DO CASE
	    CASE CLA->nNivClaCla == 1
		 cCodPadTju := REPL('0',8)

	    CASE CLA->nNivClaCla > 0

	       nRegCla := CLA->(RECNO())
	       cNombreTcl := ALLTRIM(CLA->cNombreCla)

	       IF !lLocCodigo('CLA->cCodigoCla','CLA',CLA->cSubCodCla)
		  cError('NO EXISTE LA SUBCLASE DE:'+cNombreTcl)
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF

	       cClaPad := CLA->cCodigoCla
	       cNomPad := ALLTRIM(CLA->cNombreCla)
	       CLA->(DBGOTO(nRegCla))

	    ENDCASE
**********FIN LECTURA DEL CODIGO DE LA CLASE DEL PADRE

**********IMPRESION DE LOS ENCABEZADOS
	    nNroFil := nMarco(nFilPal+1,;
			      'CLASE DE INDICADOR: '+;
			      ALLTRIM(CLA->cNombreCla),22,'°')
	    aTamCol := {06,30}
	    aTitulo := {'CODIGO',ALLTRIM(CLA->cNombreCla)}

	    cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
	    @ nNroFil,nNroCol SAY cMsgTxt
	    nNroFil++
**********FIN IMPRESION DE LOS ENCABEZADOS

**********SELECION DE LA MATERIA O AREA A GRABAR
	    IF EMPTY(CLA->cCodigoMat)

	       IF UPPER(CLA->cCodigoCla) == 'A'
		  cCodigoTma := SUBS(MAP->cCodigoMat,1,2)+'00'
	       ELSE
		  cCodigoTma := MAP->cCodigoMat
	       ENDIF

	    ELSE
		  cMatAnt := CLA->cMatAntCla
		  cNivAnt := SPACE(02)

	       cCodigoTma := CLA->cCodigoMat
	       cCodigoTni := SPACE(02)
	    ENDIF
**********FIN SELECION DE LA MATERIA O AREA A GRABAR

**********LOCALIZACION DE LA MATERIA
	    SELECT NRO
	    NRO->(DBGOTOP())

	    IF TCO->lIndNivTbl
	       LOCATE FOR NRO->cCodigoNiv == cCodigoTni .AND.;
			  NRO->cCodigoMat == cCodigoTma .AND.;
			  NRO->cCodigoCla == cCodigoTcl
	    ELSE
	       LOCATE FOR NRO->cCodigoMat == cCodigoTma .AND.;
			  NRO->cCodigoCla == cCodigoTcl
	    ENDIF

	    IF .NOT. FOUND()
	       IF NRO->(lRegLock(lShared,.T.))
		  IF TCO->lIndNivTbl
		     REPL NRO->cCodigoNiv WITH cCodigoTni
		  ELSE
		     REPL NRO->cCodigoNiv WITH SPACE(02)
		  ENDIF
		  REPL NRO->cCodigoMat WITH cCodigoTma
		  REPL NRO->cCodigoCla WITH cCodigoTcl
		  NRO->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL CONTROL DE LOS INDICADORES')
	       ENDIF
	       IF lShared
		  NRO->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA

**********VALIDACION DEL LIMITE DEL JUICIO
	    IF NRO->nTotIndNro == 999
	       cError('NO SE PUEDEN GRABAR MAS DE 999'+;
		      ALLTRIM(CLA->cNombreCla),ALLTRIM(MAT->cNombreMat))
	       CLA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL LIMITE DEL JUICIO

**********SELECCION DE TEXTO
	    IF EMPTY(CLA->cCodigoMat)
	       cNombreTma := IF(TCO->lIndNivTbl,;
			       'NIVEL '+cCodigoTni,'')+' '+;
			       ALLTRIM(MAT->cNombreMat)
	       cNombreTma := SUBS(cNombreTma,1,70)
	    ELSE
	       cNombreTma := ''
	    ENDIF
	    LineaEstado(cNombreTma,cNomSis)
**********FIN SELECCION DE TEXTO

**********RECORRIDO INDICADORES
	    SELECT JUI
	    JUI->(DBGOTOP())
	    DO WHILE .NOT. JUI->(EOF())

*==============VALIDACION CLASE DEL INDICADOR
		 IF SUBS(JUI->cCodigoJui,5,1) # cClaAnt
		    JUI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN VALIDACION CLASE DEL INDICADOR


/*
  lHayErr := .T.
  DO CASE
  CASE cCodigoTcl == '1' .AND. JUI->cCodLogJui # '00000000'
  CASE cCodigoTcl == '2' .AND. JUI->cCodLogJui # SPACE(8)
  OTHERWISE
       lHayErr := .F.
  ENDCASE
  IF lHayErr
     JUI->(DBSKIP())
     LOOP
  ENDIF
*ÀCodigo parcial para poder asociar los logros e indicadores caso Bga 2008
*/

*==============BUSQUEDA DEL INDICADOR
		 cSecInd := SUBS(JUI->cCodigoJui,6,3)
		 cIndAnt := cMatAnt+cClaAnt+cSecInd
		 IF !lSekCodigo(IF(TCO->lIndNivTbl,cNivAnt+cIndAnt,cIndAnt),;
				'JUI','INDICADOR')
		    JUI->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTju := JUI->cNombreJui
		 IF TCO->nJuiExtTbl # 0
		     cExtra1Tju := JUI->cExtra1Jui
		 ENDIF
*==============FIN BUSQUEDA DEL INDICADOR

*==============ANALISIS DE DECISION
		 IF JUI->lSiSendJui

		    @ nNroFil,aNroCol[1] SAY SUBS(JUI->cCodigoJui,5,4)
		    @ nNroFil,aNroCol[2] SAY 'YA FUE TRASLADADO'

		    nNroFil++
		    IF nNroFil > 19
		       nNroFil := nMarco(nFilPal+1,;
					 'CLASE DE INDICADOR: '+;
					 ALLTRIM(CLA->cNombreCla),22,'°')
		       @ nNroFil,nNroCol SAY cMsgTxt
		       nNroFil++
		    ENDIF

		    JUI->(DBSKIP())
		    LOOP

		 ENDIF
*==============FIN ANALISIS DE DECISION

*==============GRABACION DEL SECUENCIAL DEL JUICIO
		 SELECT NRO
		 IF NRO->(lRegLock(lShared,.F.))
		    REPL NRO->nTotIndNro WITH NRO->nTotIndNro+1
		    NRO->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL SECUENCIAL DEL INDICADOR')
		 ENDIF
		 IF lShared
		    NRO->(DBUNLOCK())
		 ENDIF
*==============FIN GRABACION DEL SECUENCIAL DEL JUICIO

*==============ASIGNACION DEL NUEVO CODIGO DEL INDICADOR
		 cSecInd := STR(NRO->nTotIndNro,3)
		 lCorrecion(@cSecInd)
		 cCodigoTju := cCodigoTma+cCodigoTcl+cSecInd

		 @ nNroFil,aNroCol[1] SAY SUBS(cCodigoTju,5,4)
		 @ nNroFil,aNroCol[2] SAY SUBS(cNombreTju,1,65)+' ...'

		 IF EMPTY(cClaPad)
		    cIdeCodTju := cCodigoTcl+cSecInd
		 ELSE
		    cIdeCodTju := JUI->cIdeCodJui
		 ENDIF
*==============FIN ASIGNACION DEL NUEVO CODIGO DEL INDICADOR

*==============CONVERSION DE LOS LOGROS E INDICADORES
		 IF CLA->lMinuscCla
		    cExtra1Tju := LOWER(cExtra1Tju)

		    cNombreTju := UPPER(SUBS(cNombreTju,1,1))+;
				  LOWER(SUBS(cNombreTju,2,LEN(cNombreTju)))
		 ELSE
		    cNombreTju := UPPER(cNombreTju)
		    cExtra1Tju := UPPER(cExtra1Tju)
		 ENDIF
*==============FIN CONVERSION DE LOS LOGROS E INDICADORES

*==============GRABACION DEL INDICADOR
		 SELECT IND
		 IF IND->(lRegLock(lShared,.T.))
		    IF TCO->lIndNivTbl
		       REPL IND->cCodigoNiv WITH cCodigoTni
		    ELSE
		       REPL IND->cCodigoNiv WITH SPACE(02)
		    ENDIF
		    REPL IND->cCodigoPro WITH cCodigoTpr
		    REPL IND->nNroPerJui WITH nNroPer
		    REPL IND->cCodigoJui WITH cCodigoTju
		    REPL IND->cCodLogJui WITH cCodPadTju
		    REPL IND->cIdeCodJui WITH cIdeCodTju
		    REPL IND->cNombreJui WITH cNombreTju
		    IF TCO->nJuiExtTbl # 0
			REPL IND->cExtra1Jui WITH cExtra1Tju
		    ENDIF
		    REPL IND->cNomUsrJui WITH cNomUsr
		    REPL IND->dFecUsrJui WITH DATE()
		    REPL IND->cHorUsrJui WITH TIME()
		    IND->(DBCOMMIT())

		 ELSE
		    cError('NO SE GRABA EL INDICADOR')
		 ENDIF
		 IF lShared
		    IND->(DBUNLOCK())
		 ENDIF
*==============FIN GRABACION DEL INDICADOR

*==============GRABACION DEL INDICADOR TRASLADADO
		 SELECT JUI
		 IF JUI->(lRegLock(lShared,.F.))

		    REPL JUI->lSiSendJui WITH .T.
		    JUI->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL INDICADOR')
		 ENDIF
		 IF lShared
		    JUI->(DBUNLOCK())
		 ENDIF
*==============FIN GRABACION DEL INDICADOR TRASLADADO

*==============INCREMENTO DE LAS FILAS
		 nNroFil++
		 IF nNroFil > 19

*-------------------IMPRESION DEL ULTIMO REGISTRO
		      nNroFil := nMarco(nFilPal+1,;
					'CLASE DE INDICADOR: '+;
					ALLTRIM(CLA->cNombreCla),22,'°')
		      @ nNroFil,nNroCol SAY cMsgTxt
		      nNroFil++
*-------------------FIN IMPRESION DEL ULTIMO REGISTRO

		 ENDIF
*==============FIN INCREMENTO DE LAS FILAS


	       JUI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO INDICADORES

	  CLA->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR CLASE DE INDICADORES