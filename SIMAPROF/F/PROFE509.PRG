/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : INDICADORES
SUBMODULO...: ASOCIAR

**************************************************************************
* TITULO..: ASOCAR LOS INDICADORES A LOS LOGROS.                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2008 MAR A
       Colombia, Bucaramanga        INICIO:  04:00 PM  ENE 20/2008 MAR

OBJETIVOS:

1- Permite asociar los indicadores a los logros.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_509(aP1,aP2,aP3)

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

       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas

       LOCAL cIdePad := ''                  // Id del Indicador Padre
       LOCAL cClaPad := ''                  // C¢digo de la Clase del Indicador del Padre
       LOCAL cNomPad := ''                  // Nombre de la Clase del Indicador del Padre

       LOCAL nRegCla := 0                   // Registro de la Clase
       LOCAL nRegInd := 0                   // Registro del Indicador

       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cNombreTcl := ''               // Nombre de la Clase
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

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS CLASES DE INDICADORES')

       CASE MAP->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS DEL PROFESOR GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRA->nModRegAno # 0
	    cError('NO ESTA PERMITIDO ASOCIAR INDICADORES PARA EL '+cAnoUsr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
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
	    CloseAll()
	    RETURN NIL
	 ENDIF
	 IF lPregunta('ESCOGIO '+ALLTRIM(CLA->cNombreCla)+;
	    ' DESEA CONTINUAR? Si No')
	    EXIT
	 ENDIF
      ENDDO
      cCodigoTcl := CLA->cCodigoCla
      cNombreTcl := ALLTRIM(CLA->cNombreCla)
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

*>>>>VALIDACION DEL CODIGO DE LA CLASE
       lHayErr := .T.
       DO CASE
       CASE CLA->nNivClaCla == 0 .OR. CLA->nNivClaCla == 1

	    cError('NO PERMITE ASOCIAR '+cNombreTcl)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DE LA CLASE

*>>>>SELECION DE LA MATERIA O AREA A GRABAR
       IF EMPTY(CLA->cCodigoMat)
	  IF UPPER(CLA->cCodigoCla) == 'A'
	     cCodigoTma := SUBS(MAP->cCodigoMat,1,2)+'00'
	  ELSE
	     cCodigoTma := MAP->cCodigoMat
	  ENDIF
       ELSE
	  cCodigoTma := CLA->cCodigoMat
	  cCodigoTni := SPACE(02)
       ENDIF
*>>>>FIN SELECION DE LA MATERIA O AREA A GRABAR

*>>>>LOCALIZACION DE LA MATERIA GENERAL
       IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	  cError('NO SE ENCUENTRA EL CODIGO '+cCodigoTma+' '+;
		 'PARA GRABACION GENERAL')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA GENERAL

*>>>>LECTURA DEL CODIGO DE LA CLASE DEL PADRE
       nRegCla := CLA->(RECNO())             
       IF !lLocCodigo('CLA->cCodigoCla','CLA',CLA->cSubCodCla)
	  cError('NO EXISTE LA SUBCLASE DE:'+cNombreTcl)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       cClaPad := CLA->cCodigoCla
       cNomPad := ALLTRIM(CLA->cNombreCla)
       CLA->(DBGOTO(nRegCla))
*>>>>FIN LECTURA DEL CODIGO DE LA CLASE DEL PADRE

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,;
			 'ASOCIAR:'+;
			 ALLTRIM(CLA->cNombreCla),22,'°')

       aTamCol := {LEN(ALLTRIM(CLA->cNombreCla)),LEN(cNomPad)}
       aTitulo := {ALLTRIM(CLA->cNombreCla),cNomPad}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>CICLO DE GRABACION
       nNroFil++
       DO WHILE .T.

**********CAPTURA Y VALIDACION DEL CODIGO DEL HIJO
	    DO WHILE .T.

	       cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)

*==============CODIGO HIJO
		 cSavTxt := SAVESCREEN(22,00,22,79)

		 Centrar('DIGITE CODIGO:'+cNombreTcl+' '+;
			 '.ABANDONAR = BLANCOS',22)

		 cSecInd := SPACE(04)
		 @ nNroFil,aNroCol[1] GET cSecInd PICT '9999'
		 READ
		 IF EMPTY(cSecInd)
		    EXIT
		 ENDIF
		 cCodigoTju := cCodigoTma+cSecInd
*==============FIN CODIGO HIJO

*==============VALIDACION CODIGO HIJO
		 DO CASE
		 CASE EMPTY(cSecInd)
		      EXIT

		 CASE SUBS(cSecInd,1,1) # cCodigoTcl
		      cError('EL CODIGO DEL ITEM DE '+;
			     'EVALUACION DEBE SER '+cCodigoTcl)
		      LOOP

		 CASE LEN(ALLTRIM(cSecInd)) # 4
		      cError('EL CODIGO DEBE SER DE 4 DIGITOS')
		      LOOP
		 ENDCASE

		 IF !lSekCodigo(IF(TCO->lIndNivTbl,;
				  cCodigoTni+cCodigoTju,;
				  cCodigoTju),'IND')

		    cError('EL CODIGO:'+cSecInd+' '+cNombreTcl+' '+;
			   'NO EXISTE')
		    LOOP
		 ENDIF

		 nRegInd := IND->(RECNO())
		 Centrar(ALLTRIM(IND->cNombreJui),22)
		 EXIT
*==============FIN VALIDACION CODIGO HIJO

	    ENDDO
	    IF EMPTY(cSecInd)
	       EXIT
	    ENDIF
**********FIN CAPTURA Y VALIDACION DEL CODIGO DEL HIJO

**********CAPTURA Y VALIDACION DEL CODIGO DEL PADRE
	    DO WHILE .T.

*==============CODIGO PADRE
		 RESTSCREEN(22,00,22,79,cSavTxt)
		 Centrar('CODIGO:'+cNomPad+' '+;
			 'AL QUE PERTENCE EL '+cNombreTcl+'. '+;
			 'ABANDONAR = BLANCOS',22)

		 cSecPad := SUBS(IND->cCodLogJui,5,4)
		 @ nNroFil,aNroCol[2] GET cSecPad PICT '9999'
		 READ
		 RESTSCREEN(22,00,22,79,cSavTxt)

		 cCodPadTju := cCodigoTma+cSecPad
*==============FIN CODIGO PADRE

*==============VALIDACION CODIGO PADRE
		 cNalias := 'IND'
		 DO CASE
		 CASE EMPTY(cSecPad)
		      cError('SE DEBE DIGITAR EL CODIGO '+cNomPad+' '+;
			     'AL QUE PERTENECE '+cNombreTcl)
		      lHayErr := .T.
		      EXIT

		 CASE SUBS(cSecPad,1,1) # cClaPad
		      cError('EL CODIGO DEL ITEM DE '+;
			     'EVALUACION DEBE SER '+cClaPad)
		      LOOP

		 CASE LEN(ALLTRIM(cSecPad)) # 4
		      cError('EL CODIGO DEBE SER DE 4 DIGITOS')
		      LOOP
		 ENDCASE

		 IF lSekCodigo(IF(TCO->lIndNivTbl,;
			       cCodigoTni+cCodPadTju,;
			       cCodPadTju),'IND')

		    cIdePad := ALLTRIM(IND->cIdeCodJui)

		 ELSE
		    IF lSekCodigo(IF(TCO->lIndNivTbl,;
				   cCodigoTni+cCodPadTju,;
				   cCodPadTju),'JUI')

			cIdePad := ALLTRIM(JUI->cIdeCodJui)

		    ELSE
			 cError('EL CODIGO:'+cSecInd+' '+cNomPad+' '+;
				'NO EXISTE')
			 LOOP
		    ENDIF
		 ENDIF

		 EXIT
*==============FIN VALIDACION CODIGO PADRE

	    ENDDO
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN CAPTURA Y VALIDACION DEL CODIGO DEL PADRE

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



**********GRABACION DE LA CLASIFICACION
	    SELECT IND
	    IND->(DBGOTO(nRegInd))

	    IF IND->(lRegLock(lShared,.F.))

	       REPL IND->cCodLogJui WITH cCodPadTju
	       REPL IND->cIdeCodJui WITH cIdePad+cSecInd
	       REPL IND->cCodigoPro WITH cCodPro

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
**********FIN GRABACION DE LA CLASIFICACION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,;
				   'CLASIFICACION:'+;
				   ALLTRIM(CLA->cNombreCla),22,'°')
		 @ nNroFil,1 SAY cMsgTxt

		 nNroFil++
		 cClrSrc := SETCOLOR()
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY SUBS(cCodigoTju,5,4)
		 @ nNroFil,aNroCol[2] SAY SUBS(cCodPadTju,5,4)
		 SET COLOR TO
		 SETCOLOR(cClrSrc)

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN CICLO DE GRABACION
