/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: INDICADORES

**************************************************************************
* TITULO..: LISTA LOS INDICADORES DE LA CONTABILIDAD                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 28/1996 JUE A
       Colombia, Bucaramanga        INICIO: 03:55 PM   MAR 28/1996 JUE


OBJETIVOS:

1- Permite imprimir los indicadores de la contabilidad

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_102(aP1,aP2,aP3)

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
       LOCAL cMsgTxt := ''                  // Texto Variable
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			FileMat,'MAT',NIL,lShared)                .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
		       PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS CLASES DE INDICADORES')

       CASE MAP->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS DEL PROFESOR GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES GRABADOS')
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
	 IF nSelRegDbf(nFilInf+1,nNroCol,'CLA','cNombreCla') == 0
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

*>>>>SELECION DE LA MATERIA O AREA A GRABAR
       IF EMPTY(CLA->cCodigoMat)
	  IF UPPER(CLA->cCodigoCla) == 'A'
	     cCodigoTma := SUBS(MAP->cCodigoMat,1,2)+'00'
	    *Indicadores por area
	  ELSE
	     cCodigoTma := MAP->cCodigoMat
	    *Indicadores por materia
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
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA GENERAL

*>>>>FILTRACION DE LOS INDICADORES
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'CARGANDO LOS INDICADORES. POR FAVOR ESPERE')
       Termometro(50)
       SELECT IND
       IF TCO->lIndNivTbl
	  SET FILTER TO SUBS(IND->cCodigoJui,1,4) == cCodigoTma .AND.;
			IND->cCodigoNiv == cCodigoTni
       ELSE
	  SET FILTER TO SUBS(IND->cCodigoJui,1,4) == cCodigoTma
       ENDIF
       GO TOP
       IF EOF()
	  cError('NO HAY INDICADORES '+;
		 IF(TCO->lIndNivTbl,'DE NIVEL','DE MATERIA')+' '+;
		 'DE CONTABILIDAD PARA '+ALLTRIM(MAT->cNombreMat)+' '+;
		 'DE '+ALLTRIM(CLA->cNombreCla))
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS INDICADORES

*>>>>TOTAL DE REGISTROS A IMPRIMIR
       Termometro(70)
       COUNT FOR VAL(SUBS(IND->cCodigoJui,1,4)) == VAL(cCodigoTma);
	     TO nTotReg
*>>>>FIN TOTAL DE REGISTROS A IMPRIMIR

*>>>>LECTURA DEL NUMERO DE COPIA
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       @ nFilInf+1,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ind'
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

	  PrnIndica2(lShared,cNomUsr,cPatPro,ALLTRIM(MAT->cNombreMat),;
		     nTotReg,cNomEmp,cNomSis,cMaeAct,cCodigoTni,cAnoUsr,;
		     cJorTxt)
	 *Impresion de los juicios

	  nNroCop++

       ENDDO
       SELECT IND
       SET FILTER TO
       VerPrn(nOpcPrn,FilePrn)
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS CANDITOS INSCRITOS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MIE A
       Bucaramanga,Colombia         INICIO: 04:02 PM   MAR 20/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de indicadores

2- Imprime la relaci¢n de Indicadores

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndica2(lShared,cNomUsr,cPatPro,cNomMat,nTotReg,cNomEmp,;
		    cNomSis,cMaeAct,cCodNiv,cAnoUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cPatPro                              // Path del Profesor
       cNomMat                              // Nombre de la Materia
       nTotReg                              // Total de Registros
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cMaeAct                              // Maestro Actual
       cCodNiv                              // C¢digo de Nivel
       cAnoUsr                              // A¤o del Usuario
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL       i := 0                  // Contador
       LOCAL cTxtPrn := ''                 // Texto de impresi¢n
       LOCAL nLenPrn := 0                  // Longitud de impresi¢n
       LOCAL nNroPag := 1                  // N£mero de p gina
       LOCAL cTotPag := 0                  // Total p ginas a imprimir
       LOCAL lPagina := .T.                // .T. Cambio de p gina
       LOCAL nTotPag := 0                   // Total P ginas
       LOCAL aTitulo[15]                   // Titulos de las Columnas
       LOCAL aTamCol[15]                   // Tama¤o de las Columnas
       LOCAL aNroCol[15]                   // N£meros de Columnas

       LOCAL cNomMae := ''                 // Nombre Maestro Habilitado
       LOCAL nJuiExt := 0                   // Total de Indicadores extra

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE VARIABLES
       DO CASE
       CASE 'BTO' == cMaeAct
	    cNomMae := 'BACHILLERATO'
       CASE 'PRI' == cMaeAct
	    cNomMae := 'PRIMARIA'
       CASE 'JAR' == cMaeAct
	    cNomMae := 'JARDIN'
       ENDCASE
       nJuiExt := IIF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)
       cNomMat := SUBS(cNomMat,1,40)
*>>>>FIN INICIALIZACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_On()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT IND
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 nTotPag++
		 EncabezPrn(cNomEmp,;
			    cNomSis+' JORNADA '+cJorTxt+' A¥O:'+cAnoUsr,;
			    cNomMat+' '+cNomMae,;
			    IF(EMPTY(cCodNiv),' ','NIVEL: '+cCodNiv),;
			    'LOGROS E INDICADORES DEFINITIVOS',;
			    nNroPag++,;
			    cTotPagina(nTotReg))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {06,106}
		 aTitulo := {'CODIGO','INDICADORES '}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 @ PROW(),00 SAY DRAFT_ON+PICA+CONDEN_ON
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aNroCol := {06,106}
	    aTitulo := {SUBS(IND->cCodigoJui,5,4),;
			IND->cNombreJui}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	   *Prepara la variable de impresion

	    @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

	    FOR i := 1 TO nJuiExt
		IF !EMPTY(IND->cExtra1Jui)

		   aTitulo := {SPACE(06),IND->cExtra1Jui}
		   cTxtPrn := cRegPrint(aTitulo,aNroCol)
		  *Prepara la variable de impresion

		   @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		ENDIF
	    ENDFOR
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DERECHOS

*>>>>GRABACION DEL LOG
       IF !EMPTY(nTotPag)
	  AADD(aGenLog,{'nCodigoLog',5})
	  AADD(aGenLog,{'cOpcionLog','<INDICADORES FINALES>'})
	  AADD(aGenLog,{'cMaeActLog',cMaeAct})          // Obligatorio
	  AADD(aGenLog,{'cNomUsrLog',cNomUsr})          // Obligatorio
	  AADD(aGenLog,{'nNroPerLog',TCO->nPerActTbl})  // Obligatorio
	  AADD(aGenLog,{'cCodigoPro',SUBS(cPatPro,LEN(cPatPro)-5,6)}) // Obligatorio
	  AADD(aGenLog,{'cHorIniLog',cHorIni})          // Obligatorio
	  AADD(aGenLog,{'cHorFinLog',TIME()})           // Obligatorio

	  AADD(aGenLog,{'nPrnIndLog',nTotPag})
	*ÀNovedades de la Opci¢n

	  cTxtLog :=  ALLTRIM(cNomMat)+' NIVEL: '+cCodNiv
	  AADD(aCamLog,{'cObsMatLog',cTxtLog})

	  cTxtLog := ''
	  AADD(aCamLog,{'cObservLog',cTxtLog})
/*
	  aCamLog := aGraProLog(lShared,'LOG',aCamLog,aGenLog)
Caso:
COLEGIO PRESENTACION
PROF:203011 A¥O:2008
<LISTAS><INDICADORES ACUMULADOS>
Error en Ciencas
Prescritura no marca error
*/
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL LOG