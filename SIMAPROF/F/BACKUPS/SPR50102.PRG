/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : INDICADORES
SUBMODULO...: CREAR - CLASIFICACION

**************************************************************************
* TITULO..: CREACION Y CLASIFICACION DE LOS INDICADORES                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2009 LUN A
       Colombia, Bucaramanga        INICIO:  03:00 AM  ENE 19/2009 LUN

OBJETIVOS:

1- Permite crear los indicadores y a su vez clasificarlos Padre e Hijos

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Spr_501_02(aP1,aP2,aP3)

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
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL cClaInd := ''                  // Clase del Indicador

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nPerAct := 0                   // Periodo Actual
       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nJuiExt := 0                   // Total de Indicadores extra
       LOCAL cSecInd := 0                   // Secuencial del Indicador

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := ''                  // Hora Inicial

       LOCAL nTotInd := 0                   // Total de Indicadores
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cNombreTcl := ''               // Nombre de la Clase
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Nombre del Indicador
       LOCAL cExtra1Tju := ''               // Nombre del Indicador Extra 1

       FIELD cCodigoNiv                     // C¢digo del Nivel
       FIELD cCodigoMat                     // C¢digo de la materia
       FIELD cCodigoCla                     // C¢digo de la clase
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

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
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+cAnoSis+ExtFile,'JUI',;
			 PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nTotPer := TCO->nTotPerTbl
       nPerAct := TCO->nPerActTbl
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

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

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(CLA->cNombreCla)
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>SELECCION DE LA CLASE DE INDICADOR
      SELECT CLA
      DO WHILE .T.
	 IF nSelRegDbf(nFilInf+1,nColInf-1,'CLA','cNombreCla') == 0
	    CLOSE ALL
	    RETURN NIL
	 ENDIF
	 IF lPregunta('ESCOGIO '+ALLTRIM(CLA->cNombreCla)+;
	    ' DESEA CONTINUAR? Si No')
	    EXIT
	 ENDIF
      ENDDO
      cCodigoTcl := CLA->cCodigoCla
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

      lPrueba1(lShared,cCodigoTcl,cCodigoTni)

*>>>>SELECCION DE TEXTO
       IF EMPTY(CLA->cCodigoMat)
	  cNombreTma := IF(TCO->lIndNivTbl,;
			  'NIVEL '+cCodigoTni,'')+' '+;
			  ALLTRIM(MAT->cNombreMat)
	  cNombreTma := SUBS(cNombreTma,1,70)
       ELSE
	  cNombreTma := ''
       ENDIF
       LineaEstado(cNombreTma,cNomSis)
*>>>>SELECCION DE TEXTO

*>>>>LECTURA DEL CODIGO DE LA CLASE DEL PADRE
       cClaPad := ''
       IF CLA->cCodigoCla # '1' .AND. !EMPTY(CLA->cSubCodCla)

	  nRegCla := CLA->(RECNO())
	  cNombreTcl := ALLTRIM(CLA->cNombreCla)
	  IF !lLocCodigo('CLA->cSubCodCla','CLA',CLA->cCodigoCla)
	     cError('NO EXISTE LA SUBCLASE DE:'+cNombreTcl)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  cClaPad := CLA->cCodigoCla
	  cNomPad := ALLTRIM(CLA->cNombreCla)
	  CLA->(DBGOTO(nRegCla))

       ENDIF
*>>>>FIN LECTURA DEL CODIGO DE LA CLASE DEL PADRE

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,;
			 'CLASE DE INDICADOR: '+;
			 ALLTRIM(CLA->cNombreCla),22,'°')

       IF EMPTY(cClaPad)
	  aTamCol := {06,30}
	  aTitulo := {'CODIGO',ALLTRIM(CLA->cNombreCla)}
       ELSE
	  aTamCol := {06,06,30}
	  aTitulo := {'CODIGO','PADRE',ALLTRIM(CLA->cNombreCla)}
       ENDIF

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>CICLO DE GRABACION
       cHorIni := TIME()
       nTotInd := 0

       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       nNroFil++
       DO WHILE .T.

**********VALIDACION DEL LIMITE DEL JUICIO
	    IF NRO->nTotIndNro == 999
	       cError('NO SE PUEDEN GRABAR MAS DE 999 INDICADORES')
	    ENDIF
**********FIN VALIDACION DEL LIMITE DEL JUICIO

**********INICIALIZACION DEL REGISTRO
	    IF !lHayErr
	       cNombreTju := cSpaces('IND','cNombreJui')
	       cExtra1Tju := cSpaces('IND','cExtra1Jui')
	    ENDIF
**********FIN INICIALIZACION DEL REGISTRO

**********LECTURA DEL CODIGO DE LA CLASE PADRE
	    IF !EMPTY(cClaPad)

	       DO WHILE .T.

		  cSecInd := cClaPad+SPACE(03)
		  KEYBOARD CHR(6)
		  @ nNroFil,aNroCol[2] GET cSecInd PICT '9999';
				       VALID lCorrecion(@cSecInd);
				       WHEN {||HelpRead('PARA ABANDONAR DEJAR EL CODIGO EN BLANCO')}
		  READ
		  cCodigoTju := cCodigoTma+cSecInd

		  lHayErr := .T.
		  DO CASE
		  CASE EMPTY(cSecInd)
		       EXIT

		  CASE SUBS(cSecInd,1,1) # cClaPad
		       cError('EL CODIGO DEL ITEM DE '+;
			      'EVALUACION DEBE SER '+cClaPad)
		       LOOP

		  CASE !lSekCodigo(IF(TCO->lIndNivTbl,;
				   cCodigoTni+cCodigoTju,;
				   cCodigoTju),'IND') .AND.;
		       !lSekCodigo(IF(TCO->lIndNivTbl,;
					cCodigoTni+cCodigoTju,;
					cCodigoTju),'JUI')

		       cError('EL CODIGO:'+cSecInd+' '+cNomPad+' '+;
			      'NO EXISTE')
		       LOOP

		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE

		  Centrar(ALLTRIM(IND->cNombreJui))
		  EXIT
	       ENDDO

	       IF EMPTY(cSecInd)
		  EXIT
	       ENDIF

	    ENDIF
**********FIN LECTURA DEL CODIGO DE LA CLASE PADRE

**********CAPTURA DEL TEXTO DEL INDICADOR
	    nJuiExt := IIF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)

	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)

	    IF EMPTY(cClaPad)
	       nNroCol := aNroCol[2]
	       cPictur := 'S68'
	    ELSE
	       nNroCol := aNroCol[3]
	       cPictur := 'S62'
	    ENDIF

	    @ nNroFil,nNroCol GET cNombreTju PICT;
			      IF(CLA->lMinuscCla,'@'+cPictur,'@!'+cPictur)

	    FOR i := 1 TO nJuiExt
		@ nNroFil+i,nNroCol GET cExtra1Tju PICT;
			    IF(CLA->lMinuscCla,'@'+cPictur,'@!'+cPictur)
	    ENDFOR
	    READ
	    IF EMPTY(cNombreTju)
	       EXIT
	    ENDIF
**********FIN CAPTURA DEL TEXTO DEL INDICADOR

**********LECTURA DE GRABACION
	    nNroOpc := nLeeOpcion('1<GRABAR> '+;
				  '2<NO GRABAR> '+;
				  '3<CORREGIR>?',3,'1')
**********FIN LECTURA DE GRABACION

**********ANALISIS PARA LA GRABACION
	    lHayErr := .F.
	    DO CASE
	    CASE nNroOpc == 2
		 RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
		 lHayErr := .F.
		 LOOP
	    CASE nNroOpc == 3
		 lHayErr := .T.
		 LOOP
	    ENDCASE
**********FIN ANALISIS PARA LA GRABACION

**********GRABACION DEL SECUENCIAL DEL JUICIO
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
**********FIN GRABACION DEL SECUENCIAL DEL JUICIO

**********ASIGNACION DEL CODIGO DEL JUICIOS
	    cSecInd := STR(NRO->nTotIndNro,3)
	    lCorrecion(@cSecInd)
	    cCodigoTju := cCodigoTma+cCodigoTcl+cSecInd

	    @ nNroFil,aNroCol[1] SAY SUBS(cCodigoTju,5,4)
**********FIN ASIGNACION DEL CODIGO DEL JUICIOS

**********GRABACION DEL JUICIO
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
	       REPL IND->cNombreJui WITH cNombreTju
	       FOR i := 1 TO nJuiExt
		   REPL IND->cExtra1Jui WITH cExtra1Tju
	       ENDFOR
	       REPL IND->cNomUsrJui WITH cNomUsr
	       REPL IND->dFecUsrJui WITH DATE()
	       REPL IND->cHorUsrJui WITH TIME()
	       IND->(DBCOMMIT())

	       nTotInd++

	    ELSE
	       cError('NO SE GRABA EL INDICADOR')
	    ENDIF
	    IF lShared
	       IND->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL JUICIO


**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    FOR i := 1 TO nJuiExt
	       nNroFil++
	    ENDFOR

	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,;
				   'CLASE DE INDICADOR: '+;
				   ALLTRIM(CLA->cNombreCla),22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY SUBS(cCodigoTju,5,4)
		 @ nNroFil,aNroCol[2] SAY SUBS(cNombreTju,1,68)
		 FOR i := 1 TO nJuiExt
		    @ nNroFil+i,aNroCol[2] SAY SUBS(cExtra1Tju,1,68)
		 ENDFOR
		 SET COLOR TO

		 nNroFil++
		 FOR i := 1 TO nJuiExt
		    nNroFil++
		 ENDFOR
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       RETURN NIL
*>>>>FIN CICLO DE GRABACION

*==========================


FUNCTION lPrueba1(lShared,cCodCla,cCodNiv)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cCodCla                              // C¢digo de la Clase
       cCodNiv                              // C¢digo del Nivel */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la Materia

       FIELD cCodigoNiv                     // C¢digo del Nivel
       FIELD cCodigoMat                     // C¢digo de la materia
       FIELD cCodigoCla                     // C¢digo de la clase
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO DE LA CLASE
       IF !lLocCodigo('cCodigoCla','CLA',cCodCla)
	  cError('NO SE ENCUENTRA EL CODIGO '+cCodCla+' '+;
		 'DE LA CLASE DE INDICADORES')
	  RETURN .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO DE LA CLASE

*>>>>SELECION DE LA MATERIA O AREA A GRABAR
       cCodCla := CLA->cCodigoCla
       IF EMPTY(CLA->cCodigoMat)
	  IF UPPER(CLA->cCodigoCla) == 'A'
	     cCodigoTma := SUBS(MAP->cCodigoMat,1,2)+'00'
	  ELSE
	     cCodigoTma := MAP->cCodigoMat
	  ENDIF
       ELSE
	  cCodigoTma := CLA->cCodigoMat
	  cCodNiv := SPACE(02)
       ENDIF
*>>>>FIN SELECION DE LA MATERIA O AREA A GRABAR

*>>>>LOCALIZACION DE LA MATERIA GENERAL
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	  cError('NO SE ENCUENTRA EL CODIGO '+cCodigoTma+' '+;
		 'PARA GRABACION GENERAL')
	  RETURN .F.
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA GENERAL

*>>>>LOCALIZACION DEL TOTAL DE INDICADORES
       SELECT NRO
       NRO->(DBGOTOP())
       IF TCO->lIndNivTbl
	  LOCATE FOR cCodigoNiv == cCodNiv .AND.;
		     cCodigoMat == cCodigoTma .AND.;
		     cCodigoCla == cCodCla
       ELSE
	  LOCATE FOR cCodigoMat == cCodigoTma .AND.;
		     cCodigoCla == cCodCla
       ENDIF

       IF .NOT. FOUND()
	  IF NRO->(lRegLock(lShared,.T.))
	     IF TCO->lIndNivTbl
		REPL NRO->cCodigoNiv WITH cCodNiv
	     ELSE
		REPL NRO->cCodigoNiv WITH SPACE(02)
	     ENDIF
	     REPL NRO->cCodigoMat WITH cCodigoTma
	     REPL NRO->cCodigoCla WITH cCodCla
	     NRO->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL CONTROL DE LOS INDICADORES')
	  ENDIF
	  IF lShared
	     NRO->(DBUNLOCK())
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN LOCALIZACION DEL CODIGO

