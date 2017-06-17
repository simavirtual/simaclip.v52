/* SIMA - CONTABILIDAD ACADEMICA PROFESORES

MODULO      : INDICADORES
SUBMODULO...: CREAR - CLASIFICACION

**************************************************************************
* TITULO..: CREACION Y CLASIFICACION DE LOS INDICADORES                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/2008 SAB A
       Colombia, Bucaramanga        INICIO:  03:00 AM  FEB 16/2008 SAB

OBJETIVOS:

1- Permite crear los indicadores y a su vez clasificarlos

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Spr_501_01(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL   i,j,k := 0                   // Contadores
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

       LOCAL nSubAnt := 0                   // Sub indicador anterior

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := ''                  // Hora Inicial

       LOCAL cCodAct := ''                  // C¢digo Actual
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL aSubCod := {}                  // Clasificaci¢n de Indicadores
       LOCAL aSubInd := {}                  // Sub Indicadores
       LOCAL nSubCod := 0                   // N£mero total de Sub C¢digos de Clase de indicadores
       LOCAL lSiorNo := .F.                 // Control de flujo
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Nombre del Indicador
       LOCAL cExtra1Tju := ''               // Nombre del Indicador Extra 1

       FIELD cCodigoNiv                     // C¢digo del Nivel
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
	    cError('NO ESTA PERMITIDO CREAR INDICADORES PARA EL '+cAnoUsr)

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

*>>>>VALIDACION CLASE DE INDICADORES
       lSiorNo := .F.
       aSubCod := {}
       SELECT CLA
       CLA->(DBGOTOP())
       DO WHILE .NOT. CLA->(EOF())

**********ANALISIS DE DECISION
	    IF CLA->cSubCodCla == SPACE(01)
	       CLA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********LECTURA DEL TOTAL DE SUBINDICADORES
	    DO CASE
	    CASE CLA->nSubCodCla # 1 .AND. !lSiorNo
		 nSubCod := 1

	    OTHERWISE
		 nSubCod := CLA->nSubCodCla
	    ENDCASE

	    AADD(aSubCod,{CLA->cCodigoCla,;
			  CLA->cSubCodCla,;
			  nSubCod,;
			  ALLTRIM(CLA->cNombreCla),;
			  0,''})
	   /*Posiciones:
	    1. C¢digo de la clase
	    2. C¢digo de la Clase en el cual esta subdividido
	    3. N£mero total de Sub C¢digos de Clase de indicadores
	    4. Nombre de la Clase
	    5. Contador de los indicadores digitados
	    6. C¢digo del Indicador para subdividir */

	    lSiorNo := .T.
**********FIN LECTURA DEL TOTAL DE SUBINDICADORES

	  CLA->(DBSKIP())

       ENDDO
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(aSubCod)

	   lHayErr := .T.
	   DO CASE
	   CASE !lLocCodigo('CLA->cCodigoCla','CLA',aSubCod[i,2])

		IF aSubCod[i,2] == '0'
		   lHayErr := .F.
		ELSE
		   cError('EL CODIGO DE LA CLASIFICACION '+aSubCod[i,2]+' '+;
			  'DE LA CLASE '+aSubCod[i,1]+' NO EXISTE')
		ENDIF

	   OTHERWISE
		lHayErr :=.F.
	   ENDCASE

	   IF lHayErr
	      EXIT
	   ENDIF
       ENDFOR

       IF aSubCod[LEN(aSubCod),2] # '0'
	  cError('EL CODIGO DE LA CLASIFICACION '+;
		 aSubCod[LEN(aSubCod),2]+' '+;
		 'DE LA ULTIMA CLASE '+aSubCod[LEN(aSubCod),1]+' '+;
		 'DEBE SER CERO')
	  lHayErr := .T.
       ENDIF

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION CLASE DE INDICADORES

*>>>>VALIDACION DEL NIVEL DE CLASIFICACION
       lHayErr := .T.
       DO CASE
       CASE LEN(aSubCod) == 0
	    cError('NO EXISTEN CLASIFICACION DE LOS INDICADORES')

       CASE LEN(aSubCod) # 3
	    cError('EL NIVEL DE CLASIFICACION No.'+;
		   ALLTRIM(STR(LEN(aSubCod),2))+' '+;
		   'NO ESTA PERMITIDO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL NIVEL DE CLASIFICACION

*>>>>LECTURA Y VALIDACION TOTAL DE INDICADORES
       DO WHILE .T.

**********ENCABEZADOS DE COLUMNA
	    nNroFil := nMarco(nFilPal+1,cNombreTma,22,'°')
	    aTamCol := {30,04}
	    aTitulo := {'CLASE','TOTAL'}

	    cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
	    @ nNroFil,nNroCol SAY cMsgTxt

	    nNroFil++
**********FIN ENCABEZADOS DE COLUMNA

**********LECTURA TOTAL INDICADORES
	    FOR i := 2 TO LEN(aSubCod)
		cMsgTxt := 'FAVOR INGRESE EL TOTAL DE '+aSubCod[i,4]+' A '+;
			   'DIGITAR'
		@ nNroFil,aNroCol[1] SAY aSubCod[i,4]
		@ nNroFil,aNroCol[2] GET aSubCod[i,3] PICT '99';
				     WHEN {||HelpRead(cMsgTxt)}
		READ
		nNroFil++
	    ENDFOR
**********FIN LECTURA TOTAL INDICADORES

**********VALIDACION TOTAL INDICADORES
	    lHayErr := .T.
	    FOR i := 2 TO LEN(aSubCod)

		DO CASE
		CASE aSubCod[i,3] == 0
		     cError('EL TOTAL DE '+aSubCod[i,4]+' '+;
			    'NO DEBE SER CERO')

		CASE aSubCod[i,3] > 20
		     cError('EL TOTAL DE '+aSubCod[i,4]+' '+;
			    'NO DEBE SER MAYOR A 20')

		OTHERWISE
		     lHayErr :=.F.
		ENDCASE

	    ENDFOR
	    IF lHayErr
	       LOOP
	    ENDIF
	    EXIT
**********FIN VALIDACION TOTAL INDICADORES

       ENDDO
       IF !lPregunta('DESEA CONTINUAR?No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA Y VALIDACION TOTAL DE INDICADORES

*>>>>CALCULO DEL TOTAL DE INDICADORES
       nSubAnt := aSubCod[1,3]
       FOR i := 1 TO LEN(aSubCod)
	   j := 1
	   DO WHILE .T.

	      AADD(aSubInd,{aSubCod[i,1],aSubCod[i,3],0})
	     /*Posiciones:
	      1. C¢digo de la clase
	      2. N£mero total de Sub C¢digos de Clase de indicadores
	      3. Numero para ordenar la secuencia de digitaci¢n */

	      j++
	      IF j > aSubCod[i,3]*nSubAnt
		 nSubAnt := aSubCod[i,3]
		 EXIT
	      ENDIF
	   ENDDO
       ENDFOR
*>>>>FIN CALCULO DEL TOTAL DE INDICADORES

*>>>>ORDENAMIENTO NIVEL DE CLASIFICACION
       DO CASE
       CASE LEN(aSubCod) == 3
	    OrdInd03(aSubCod,aSubInd)
       ENDCASE
*>>>>FIN ORDENAMIENTO NIVEL DE CLASIFICACION

*>>>>ENCABEZADO DE LECTURA
       nNroFil := nMarco(nFilPal+1,cNombreTma,22,'°')
       aTamCol := {06,30}
       aTitulo := {'CODIGO','DESCRIPCION'}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN ENCABEZADO DE LECTURA

*>>>>CREACION DE LOS INDICADORES
       cHorIni := TIME()

       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       nNroFil++
       DO WHILE .T.

**********GRABACION DE LA CLASIFICACION
	    i := 0
	    lHayErr := .F.
	    DO WHILE .T.

	       IF !lHayErr
		  i++
	       ENDIF

*==============LOCALIZACION DE LA CLASE
		 k := ASCAN(aSubCod,{|aArray|aArray[1] == aSubInd[i,1]})
		 lLocCodigo('cCodigoCla','CLA',aSubCod[k,1])
*==============FIN LOCALIZACION DE LA CLASE

*==============IMPRESION DE LA LINEA DE ESTADO
		 IF aSubCod[k,5] == aSubCod[k,3]
		    aSubCod[k,5] := 0
		 ENDIF

		 IF !lHayErr
		    aSubCod[k,5]++
		 ENDIF

		 IF i == 1

		    cError('POR FAVOR DIGITE <ENTER> SI DESEA TERMINAR')

		    LineaEstado(aSubCod[k,4]+' No.'+;
				ALLTRIM(STR(aSubCod[k,5],2))+;
				'º'+'DIGITE <ENTER> PARA TERMINAR',;
				cNomSis)
		 ELSE
		    LineaEstado(aSubCod[k-1,4]+' No.'+;
				ALLTRIM(STR(aSubCod[k-1,5],2))+'º'+;
				'DIGITE:'+aSubCod[k,4]+' No.'+;
				ALLTRIM(STR(aSubCod[k,5],2))+'º'+;
				ALLTRIM(STR(i,2))+'/'+;
				ALLTRIM(STR(LEN(aSubInd),2)),cNomSis)
		 ENDIF
*==============FIN IMPRESION DE LA LINEA DE ESTADO

*==============LOCALIZACION DEL TOTAL DE INDICADORES
		 cCodigoTcl := aSubInd[i,1]
		 SELECT NRO
		 NRO->(DBGOTOP())
		 IF TCO->lIndNivTbl
		    LOCATE FOR cCodigoNiv == cCodigoTni .AND.;
			       cCodigoMat == cCodigoTma .AND.;
			       cCodigoCla == cCodigoTcl
		 ELSE
		    LOCATE FOR cCodigoMat == cCodigoTma .AND.;
			       cCodigoCla == cCodigoTcl
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
*==============FIN LOCALIZACION DEL TOTAL DE INDICADORES

*==============VALIDACION DEL LIMITE DEL JUICIO
		 IF NRO->nTotIndNro == 999
		    cError('NO SE PUEDEN GRABAR MAS DE 999 INDICADORES')
		    EXIT
		 ENDIF
*==============FIN VALIDACION DEL LIMITE DEL JUICIO

*==============INICIALIZACION DEL REGISTRO
		 IF !lHayErr
		    cNombreTju := cSpaces('IND','cNombreJui')
		    cExtra1Tju := cSpaces('IND','cExtra1Jui')
		 ENDIF
*==============FIN INICIALIZACION DEL REGISTRO

*==============CAPTURA DEL INDICADOR
		 nJuiExt := IIF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)

		 cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)

		 IF i # 1 .AND. CLA->cSubCodCla # '0'
		    @ nNroFil,aNroCol[2] GET cNombreTju PICT;
					 IF(CLA->lMinuscCla,"@S68","@!S68");
					 VALID !EMPTY(cNombreTju)
		 ELSE
		    @ nNroFil,aNroCol[2] GET cNombreTju PICT;
					 IF(CLA->lMinuscCla,"@S68","@!S68")
		 ENDIF
		 FOR j := 1 TO nJuiExt
		     @ nNroFil+j,aNroCol[2] GET cExtra1Tju PICT;
					    IF(CLA->lMinuscCla,"@S68","@!S68")
		 ENDFOR
		 READ

		 DO CASE
		 CASE i == 1 .AND. EMPTY(cNombreTju)
		      EXIT

		 CASE EMPTY(cNombreTju)

		      cError('SE VA ABANDONAR LA CREACION DE '+;
			     ALLTRIM(CLA->cNombreCla))

		      IF lPregunta('DESEA ABANDONAR LA CREACION DE '+;
				   ALLTRIM(CLA->cNombreCla)+'? Si No')

			 lHayErr := .F.
			 FOR j := aSubCod[k,5] TO aSubCod[k,3]-1
			     i++
			     aSubCod[k,5]++
			 ENDFOR
		      ELSE
			 lHayErr := .T.
		      ENDIF

		      IF i == LEN(aSubInd)
			 EXIT
		      ELSE
			 LOOP
		      ENDIF

		 ENDCASE
*==============FIN CAPTURA DEL INDICADOR

*==============LECTURA DE GRABACION
		 nNroOpc := nLeeOpcion('1<GRABAR> '+;
				       '2<NO GRABAR> '+;
				       '3<CORREGIR>?',3,'1')
*==============FIN LECTURA DE GRABACION

*==============ANALISIS PARA LA GRABACION
		 lHayErr := .F.
		 DO CASE
		 CASE nNroOpc == 2
		      RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
		      lHayErr := .T.
		      LOOP

		 CASE nNroOpc == 3
		      lHayErr := .T.
		      LOOP
		 ENDCASE
*==============FIN ANALISIS PARA LA GRABACION

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

*==============ASIGNACION DEL CODIGO DEL JUICIOS
		 cSecInd := STR(NRO->nTotIndNro,3)
		 lCorrecion(@cSecInd)
		 cCodigoTju := cCodigoTma+cCodigoTcl+cSecInd

		 aSubCod[k,6] := cCodigoTcl+cSecInd

		 @ nNroFil,aNroCol[1] SAY SUBS(cCodigoTju,5,4)
*==============FIN ASIGNACION DEL CODIGO DEL JUICIOS

*==============GRABACION DEL JUICIO
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
		    FOR j := 1 TO nJuiExt
			REPL IND->cExtra1Jui WITH cExtra1Tju
		    ENDFOR
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
*==============GRABACION DEL JUICIO

*==============LOCALIZACION DE LA CLASIFICACION
		 SELECT SIN
		 SIN->(DBGOTOP())

		 IF i == 1
		    cCodLog := aSubCod[k,6]
		 ELSE
		    cCodLog := aSubCod[k-1,6]
		 ENDIF

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
*==============FIN LOCALIZACION DE LA CLASIFICACION

*==============GRABACION DE LOS SUBCODIGOS
		 IF i # 1

		    IF SIN->(lRegLock(lShared,.F.))
		       REPL SIN->cCodIndSin WITH ALLTRIM(SIN->cCodIndSin)+;
						 aSubCod[k,6]
		       SIN->(DBCOMMIT())
		    ELSE
		       cError('NO SE GRABA EL CONTROL DE LOS INDICADORES')
		    ENDIF
		    IF lShared
		       SIN->(DBUNLOCK())
		    ENDIF

		 ENDIF
*==============FIN GRABACION DE LOS SUBCODIGOS

*==============INCREMENTO DE LAS FILAS
		 nNroFil++
		 FOR j := 1 TO nJuiExt
		    nNroFil++
		 ENDFOR

		 IF nNroFil > 19

*:::::::::::::::::::IMPRESION DEL ULTIMO REGISTRO
		      nNroFil := nMarco(nFilPal+1,;
					'CLASE DE INDICADOR: '+;
					ALLTRIM(CLA->cNombreCla),22,'°')
		      @ nNroFil,nNroCol SAY cMsgTxt

		      nNroFil++
		      SET COLOR TO I
		      @ nNroFil,aNroCol[1] SAY SUBS(cCodigoTju,5,4)
		      @ nNroFil,aNroCol[2] SAY SUBS(cNombreTju,1,68)
		      FOR j := 1 TO nJuiExt
			 @ nNroFil+j,aNroCol[2] SAY SUBS(cExtra1Tju,1,68)
		      ENDFOR
		      SET COLOR TO

		      nNroFil++
		      FOR j := 1 TO nJuiExt
			 nNroFil++
		      ENDFOR
*:::::::::::::::::::FIN IMPRESION DEL ULTIMO REGISTRO

		 ENDIF
*==============FIN INCREMENTO DE LAS FILAS

*==============ANALISIS DE DECISION
		 IF i == LEN(aSubInd)
		    EXIT
		 ENDIF
*==============FIN ANALISIS DE DECISION

	   ENDDO
	   IF i == 1 .AND. EMPTY(cNombreTju)
	      EXIT
	   ENDIF
**********FIN GRABACION DE LA CLASIFICACION


       ENDDO
*>>>>FIN CREACION DE LOS INDICADORES

RETURN NIL

/*************************************************************************
* TITULO..: ORDENAMIENTO DE LA CLASIFICACION NIVEL No.3                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 19/2008 MAR A
       Colombia, Bucaramanga        INICIO:  09:30 AM  FEB 19/2008 MAR

OBJETIVOS:

1- Permite ordenar la secuencia de digitaci¢n de los indicadores de la
   clasificaci¢n del nivel No.3

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdInd03(aSubCod,aSubInd)

*>>>>DESCRIPCION DE PARAMETROS
/*     aSubCod                              // Clasificaci¢n de Indicadores
       aSubInd                              // Sub Indicadores */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                  // Contadores
       LOCAL       m := 0                  // Control de secuencia
       LOCAL       k := 0                  // Secuencial
       LOCAL aOrdInd := {}                 // Orden de los Indicadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PRIMER NIVEL
       FOR i := 1 TO aSubCod[1,3]
	   m := i
	   k := i
	   AADD(aOrdInd,k)
       ENDFOR
*>>>>FIN PRIMER NIVEL

*>>>>SEGUNDO NIVEL
       FOR i := 1 TO aSubCod[2,3]

	 IF i == 1
	    m++
	    k=m
	    AADD(aOrdInd,k)
	 ELSE
	    k += aSubCod[3,3]+1
	    AADD(aOrdInd,k)
	 ENDIF

       ENDFOR
*>>>>FIN SEGUNDO NIVEL

*>>>>TERCER NIVEL
       FOR i := 1 TO aSubCod[2,3]

	 FOR j := 1 TO aSubCod[3,3]

	     IF j == 1
		IF i == 1
		   m++
		   AADD(aOrdInd,m)
		ELSE
		   m += aSubCod[3,3]+1
		   AADD(aOrdInd,m)
		ENDIF
		k := m
	     ENDIF

	     IF j # 1
		k++
		AADD(aOrdInd,k)
	     ENDIF

	 ENDFOR

       ENDFOR
*>>>>FIN TERCER NIVEL

*>>>>ASINACION DEL ORDEN
       FOR i := 1 TO LEN(aOrdInd)
	   aSubInd[i,3] := aOrdInd[i]
       ENDFOR
       aSubInd := ASORT(aSubInd,,,{|x,y| y[3] > x[3]})
       RETURN NIL
*>>>>FIN ASINACION DEL ORDEN

*============ ALGORITMOS VARIOS DE CLASIFICACION DE INDICADORES ========

/*

aa(aOrden)

wait 'suerte'
bbb(aSubInd)


wait 'ordenado'
aSubInd := ASORT(aSubInd,,,{|x,y| y[3] > x[3]})
bbb(aSubInd)

FUNCTION aa(aNivel)

FOR i := 1 TO LEN(aNivel)
    wait ALLTRIM(str(aNivel[i],2))
ENDFOR
RETURN NIL

FUNCTION aaa(aNivel)

FOR i := 1 TO LEN(aNivel)
    wait ALLTRIM(str(aNivel[i,1],2))+'=>'+;
	 ALLTRIM(str(aNivel[i,2],2))
ENDFOR
RETURN NIL


FUNCTION bbb(aSubInd)

FOR i := 1 TO LEN(aSubInd)

    wait aSubInd[i,1]

/*
    wait aSubInd[i,1]+'=>'+;
	 ALLTRIM(str(aSubInd[i,3],2))
*/

/*
    wait aSubInd[i,1]+'=>'+;
	 ALLTRIM(str(aSubInd[i,2],2))+'=>'+;
	 ALLTRIM(str(aSubInd[i,3],2))
*/

/*
ENDFOR
RETURN NIL
*/



/*
k := 1
aSubInd[1,3] := k
cCodAnt := aSubInd[2,1]
FOR i := 2 TO LEN(aSubInd)

    cCodAct := aSubInd[i,1]
    IF i == 2
       k := i
       n := k
       aSubInd[i,3] := k
       LOOP
    ENDIF

    IF cCodAnt # cCodAct
       cCodAnt := cCodAct
       k++
       aSubInd[i,3] := k
       n := k
    ELSE
       IF k # LEN(aSubCod)
	  n := n+aSubInd[i,2]
	  aSubInd[i,3] := n
	  j := 0
       ELSE
	  j++
	  IF j <= (aSubInd[i,2]-1)
	     n := n+j
	     aSubInd[i,3] := n
	  ELSE
	     n := n+aSubInd[i,2]
	     aSubInd[i,3] := n
	     j := 0
	  ENDIF
       ENDIF
    ENDIF

ENDFOR


FOR i := 1 TO LEN(aSubInd)
wait aSubInd[i,1]+'=>'+ALLTRIM(str(aSubInd[i,2],2))+'=>'+;
		       ALLTRIM(str(aSubInd[i,3],2))
ENDFOR

aSubInd := ASORT(aSubInd,,,{|x,y| y[3] > x[3]})

FOR i := 1 TO LEN(aSubInd)
wait aSubInd[i,1]+'=>'+ALLTRIM(str(aSubInd[i,2],2))+'=>'+;
		       ALLTRIM(str(aSubInd[i,3],2))
ENDFOR

*/

/*

aNivel := {}
FOR i := 1 TO LEN(aSubCod)
    AADD(aNivel,{aSubCod[i,3],aSubCod[i,3]})
ENDFOR


aaa(aNivel)
k := 0
j := 0
DO WHILE .T.

   FOR i := 2 TO LEN(aNivel)

       IF aNivel[i,2] # 0

	  k++

	  wait 'k='+ALLTRIM(str(k,2))

	  aNivel[i,2]--
	  aSubInd[k,3] := k

	  IF i < LEN(aNivel) .AND. aNivel[i+1,2] == 0
	     aNivel[i+1,2] := aNivel[i+1,1]
	  ENDIF

       ENDIF

   ENDFOR
   aaa(aNivel)

   IF aNivel[LEN(aNivel),2] == 0
      EXIT
   ENDIF

   FOR i := 1 TO aNivel[LEN(aNivel),2]
       k++
       wait 'k='+ALLTRIM(str(k,2))
       aNivel[LEN(aNivel),2]--
       aSubInd[k,3] := k
   ENDFOR

ENDDO
aaa(aNivel)
wait 'suerte'
bbb(aSubInd)
*/

