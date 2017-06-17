/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LOGROS
SUBMODULO...: LISTAR

**************************************************************************
* TITULO..: IMPRIME LOS LOGROS DE CADA ESTUDIANTE                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MIE 28/1996 MIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   MIE 28/1996 MIE


OBJETIVOS:

1- Permite imprimir los logros aplicados para cada estudiante

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_204(aP1,aP2,aP3)

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
       LOCAL cEvaInd := ''                  // Evaluar el Indicador

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
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)       .OR.;
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
	  !lUseDbf(.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fSprAno+cAnoUsr+ExtFile,'PRA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FileEva,'EVA',NIL,lShared)
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

       CASE PRA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
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
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>LECTURA DEL NUMERO DE COPIA
       @ nFilInf+1,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>IMPRESION DEL INFORME
       PrnIndNot(aP1,aP2,aP3,nNroPer,nCopias)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: IMPRIME LOS LOGROS DE CADA ESTUDIANTE                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MIE 28/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   MIE 28/96 MIE


OBJETIVOS:

1- Permite imprimir los logros aplicados para cada estudiante

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndNot(aP1,aP2,aP3,nNroPer,nCopias)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nNroPer                              // N£mero del Periodo
       nCopias                              // Copias a imprimir  */
*>>>>DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el Indicador
       LOCAL cEvaInd := ''                  // Evaluar el Indicador

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
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones
       LOCAL cSecInd := ''                  // Secuencial del Indicador
       LOCAL nNroCol := 0                   // N£mero de Columna
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
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervCaP(nFilInf+1,01,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>INICIALIZACION DE CAMPOS
       cCamNot := 'NOP->cNotas'+STR(nNroPer,1,0)+'NoP'
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cCamObs := 'NOP->cObsev'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN INICIALIZACION DE CAMPOS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lIndNiv := TCO->lIndNivTbl
       cEvaInd := SUBS(TCO->cEvaIndTbl,nNroPer,1)

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

*>>>>GESTION DOCUMENTAL DEL INFORME
       nNroIso := 204
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<LOGROS><IMPRIMIR>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aMezIso,{'<nNroPer>',STR(nNroPer,2)})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'REGISTRO DEL PROCESO EVALUATIVO PERIODO No. <nNroPer>')  // T¡tulo Uno
       AADD(aTitIso,'')  // T¡tulo Dos
       AADD(aTitIso,'')  // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       aPieIso := {}
       AADD(aPieIso,'')  // Pie de p gina Uno
       AADD(aPieIso,'')  // Pie de p gina Dos
       AADD(aPieIso,'')  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'final'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.,.F.,bInsIso)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

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

		 DO CASE
		 CASE cEvaInd == '0' .OR. cEvaInd == '1'


		      PrnIndFin(lShared,cNomUsr,cAnoUsr,cPatPro,;
				cNomSis,cNomEmp,cMaeAct,nNroPer,;
				cCodigoTma,nNroInd,cNomPro,cCodigoTgr,;
				cCodigoTma+':'+ALLTRIM(CAP->cNombreMat),;
				cEvaInd,lHayNot,lNotNum,;
				cCodIso,aTitIso,aPieIso)

		 CASE cEvaInd == '2'


		      IF VAL(SUBS(CAP->cNroIndCaP,nNroPer*2-1,2)) <= 10
			 nNroInd := 10
		      ENDIF

		      PrnNotFin(lShared,cNomUsr,cAnoUsr,cPatPro,;
				cNomSis,cNomEmp,cMaeAct,nNroPer,;
				cCodigoTma,nNroInd,cNomPro,cCodigoTgr,;
				cCodigoTma+':'+ALLTRIM(CAP->cNombreMat),;
				cEvaInd,lHayNot,lNotNum,;
				cCodIso,aTitIso,aPieIso)

		 ENDCASE
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

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS CANDITOS INSCRITOS            *
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

FUNCTION PrnIndFin(lShared,cNomUsr,cAnoUsr,cPatPro,cNomSis,cNomEmp,cMaeAct,;
		   nNroPer,cCodMat,nNroInd,cNomPro,cCodGru,cNomMat,cEvaInd,;
		   lHayNot,lNotNum,cCodIso,aTitIso,aPieIso)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomMat                              // Nombre de la Materia
       nTotReg                              // Total de Registros
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cMaeAlu                              // Maestros Habilitados
       cCodNiv                              // C¢digo de Nivel
       cEvaInd                              // .T. Evaluar Indicador
       lHayNot                              // .T. Hay Nota
       lNotNum                              // .T. Nota N£merica
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso      		            // Textos del pie de p gina */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
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
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cCodRec := ''                  // C¢digo de Recuperaci¢n

       LOCAL nLenNom := 0                   // Longitud del Nombre
       LOCAL cNomMae := ''                  // Nombre Maestro Habilitado

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cHorIni := TIME()              // Hora de Inicio
       LOCAL cTitul1 := ''                  // T¡tulo1 para encabezado de captura

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL lRetiroTno := .F.              // .T. Retiro del Estudiante
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
       cTitul1 := IF(EMPTY(PRA->cTitul1Ano),'INDI',PRA->cTitul1Ano)
       cTitul1 := ALLTRIM(cTitul1)

       SELECT NOP
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

/*
*--------------CODIGO ISO PARA EL INFORME
		 DO CASE
		 CASE 'DE LA SALLE BOGOTA' $ cNomEmp
		      cCodIso := 'ISO:F-SED-001'
		 ENDCASE
*--------------FIN CODIGO ISO PARA EL INFORME
*/



*--------------ENCABEZADO DEL INFORME
		 nTotPag++
		 EncabezPrn(cNomEmp,cNomSis+cCodIso,;
			    cNomMat,;
			    aTitIso[1],;
			    'GRUPO: '+cCodGru+' A¥O:'+cAnoUsr,;
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

		 I = 1
		 nNroCol = nColIni
		 DO WHILE I <= nNroInd

		    @ PROW(),nNroCol SAY IF(i<10,cTitul1,SUBS(cTitul1,1,3))+LTRIM(STR(i));
				     PICT '@A'
		    I = I + 1
		    nNroCol = nNroCol + 6
		 ENDDO
		 IF lHayNot
		    @ PROW(),nNroCol SAY IF(lNotNum,'NOTA','JUIC')
		    @ PROW(),nNroCol+5 SAY 'AU'
		 ELSE
		    @ PROW(),nNroCol SAY 'AU'
		 ENDIF

		 nNroCol = nNroCol - (I-1)*6
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
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

**********ANALISIS DE LOS INDICADORES POR RECUPERAR
	    lRecAnt := .F.
	    aNoRecu := {}
	    IF !MAT->lNoRecuMat
	       FOR i := 1 TO nNroPer-1
		   cCampos := 'NOP->cIndic'+STR(i,1,0)+'NoP'
		   cLogros := SUBS(&cCampos,1,nNroInd*nLenCod)
		   cRecupe := cIndxRecu(cLogros,i)

		   AADD(aNoRecu,cRecupe)
		   IF !EMPTY(cRecupe)
		      lRecAnt := .T.
		   ENDIF
	       ENDFOR
	    ENDIF
	    cLogros := ''
**********FIN ANALISIS DE LOS INDICADORES POR RECUPERAR

**********IMPRESION DEL CODIGO Y NOMBRE DEL ESTUDIANTE
	    lRetiroTno := NOP->lRetiroNoP
	    cLogros := SUBS(&cCamInd,1,nNroInd*nLenCod)

	    IF !(lRetiroTno .AND. CAP->nTipCarCar # 0 .AND.;
	       EMPTY(cLogros)) .OR. lRecAnt
	       SELECT NOP
	       @ PROW()+1,00 SAY RECNO()                    PICT '99'
	       @ PROW()  ,04 SAY cCodigoTes		 PICT "999999"
	       IF lRetiroTno
		  @ PROW()  ,10 SAY '.'+SUBS(cNombreTes,1,nLenNom) PICT "@A"
	       ELSE
		  @ PROW()  ,11 SAY SUBS(cNombreTes,1,nLenNom) PICT "@A"
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL CODIGO Y NOMBRE DEL ESTUDIANTE

**********IMPRESION DE LAS NOTAS DEL ESTUDIANTE
	    nNroCol = nColIni

	    IF !(lRetiroTno .AND. CAP->nTipCarCar # 0 .AND.;
	       EMPTY(cLogros)) .OR. lRecAnt

	       DO CASE
	       CASE lRetiroTes
		    @ PROW(),nNroCol SAY 'RETIRADO'   PICT '@A'

	       CASE lRetiroTno .AND. CAP->nTipCarCar == 0
		    @ PROW(),nNroCol SAY 'PERTENECE A OTRO GRUPO'   PICT '@A'

	       CASE (!lRetiroTes .AND. !lRetiroTno) .OR.;
		    !EMPTY(cLogros) .OR. lRecAnt

*-------------------IMPRESION DE LOS LOGROS
		      i = 1
		      lHayRec := .F.
		      nNroCol = nColIni
		      DO WHILE i <= nNroInd
			 cCodLog := cCodLogN(cLogros,i,nLenCod,cEvaInd,;
					     @cCodEva,@cCodRec)
			*Lectura del C¢digo

			 DO CASE
			 CASE cEvaInd == '0'
			      cCodLog := cCodLog+SPACE(01)

			 CASE cEvaInd == '1'
			      cCodLog := cCodLog+cCodEva


			 CASE cEvaInd == '2'
			      cCodLog := cCodLog+SPACE(01)
			 ENDCASE

			 IF EMPTY(cCodLog)
			    @ PROW(),nNroCol SAY ''  PICT 'AA'
			 ELSE
			    IF lCodLogRec(cCodLog,nNroPer) .AND.;
			       !MAT->lNoRecuMat

			       @ PROW(),nNroCol SAY IF(EMPTY(cCodRec),;
						       cChrRec,cCodRec)+;
						       cCodLog;
						PICT 'XXXXXX'
			       lHayRec := .T.
			    ELSE
			       @ PROW(),nNroCol SAY cCodLog PICT 'XXXXX'
			    ENDIF
			 ENDIF
			 i = i + 1
			 nNroCol = nNroCol + 6
		      ENDDO
		      cNroFal := SUBS(NOP->cFallasNoP,nNroPer*2-1,2)
		      IF lHayNot
			 @ PROW(),nNroCol SAY &cCamDef
			 IF lHayRec
			    @ PROW(),nNroCol+5 SAY cNroFal+;
				     IF('XX' $ cCodGru,;
					cChrRec+cCodigoTgr,cChrRec)
			 ELSE
			    @ PROW(),nNroCol+5 SAY cNroFal+;
				     IF('XX' $ cCodGru,':'+cCodigoTgr,'')
			 ENDIF
		      ELSE
			 IF lHayRec
			    @ PROW(),nNroCol SAY cNroFal+;
				     IF('XX' $ cCodGru,;
					cChrRec+cCodigoTgr,cChrRec)
			 ELSE
			    @ PROW(),nNroCol SAY cNroFal+;
				     IF('XX' $ cCodGru,':'+cCodigoTgr,'')
			 ENDIF
		      ENDIF
		      nNroCol = nNroCol - (I-1)*6
*-------------------FIN IMPRESION DE LOS LOGROS

*** OJO INSERTADO
**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       EJECT

**********IMPRESION DE LOS ENCABEZADOS
lPagina := .T.
	    IF lPagina

/*
*--------------CODIGO ISO PARA EL INFORME
		 DO CASE
		 CASE 'DE LA SALLE BOGOTA' $ cNomEmp
		      cCodIso := 'ISO:F-SED-001'
		 ENDCASE
*--------------FIN CODIGO ISO PARA EL INFORME
*/



*--------------ENCABEZADO DEL INFORME
		 nTotPag++
		 EncabezPrn(cNomEmp,cNomSis+cCodIso,;
			    cNomMat,;
			    aTitIso[1],;
			    'GRUPO: '+cCodGru+' A¥O:'+cAnoUsr,;
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

		 I = 1
		 nNroCol = nColIni
		 DO WHILE I <= nNroInd

		    @ PROW(),nNroCol SAY IF(i<10,cTitul1,SUBS(cTitul1,1,3))+LTRIM(STR(i));
				     PICT '@A'
		    I = I + 1
		    nNroCol = nNroCol + 6
		 ENDDO
		 IF lHayNot
		    @ PROW(),nNroCol SAY IF(lNotNum,'NOTA','JUIC')
		    @ PROW(),nNroCol+5 SAY 'AU'
		 ELSE
		    @ PROW(),nNroCol SAY 'AU'
		 ENDIF

		 nNroCol = nNroCol - (I-1)*6
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS


	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA
*** FIN OJO INSERTADO

*-------------------IMPRESION DE LOS INDICADORES POR RECUPERAR
		      IF lRecAnt
			 FOR k := 1 TO LEN(aNoRecu)

			     nNroCol = nColIni
			     cRecupe := aNoRecu[k]

			     IF !EMPTY(cRecupe)
				nNroRec := ROUND(LEN(ALLTRIM(cRecupe))/nLenCod,0)
				@ PROW()+1,11 SAY 'POR RECUPERAR P'+STR(k,1)

				FOR y := 1 TO nNroRec
				    cCodLog := SUBS(cRecupe,y*6-5,6)
				    @ PROW(),nNroCol SAY '*'+cCodLog PICT 'XXXXXXX'
				    nNroCol = nNroCol + 7
				ENDFOR

*** OJO INSERTADO
**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       EJECT

**********IMPRESION DE LOS ENCABEZADOS
lPagina := .T.
	    IF lPagina

/*
*--------------CODIGO ISO PARA EL INFORME
		 DO CASE
		 CASE 'DE LA SALLE BOGOTA' $ cNomEmp
		      cCodIso := 'ISO:F-SED-001'
		 ENDCASE
*--------------FIN CODIGO ISO PARA EL INFORME
*/



*--------------ENCABEZADO DEL INFORME
		 nTotPag++
		 EncabezPrn(cNomEmp,cNomSis+cCodIso,;
			    cNomMat,;
			    aTitIso[1],;
			    'GRUPO: '+cCodGru+' A¥O:'+cAnoUsr,;
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

		 I = 1
		 nNroCol = nColIni
		 DO WHILE I <= nNroInd
					 
		    @ PROW(),nNroCol SAY IF(i<10,'INDI','IND')+LTRIM(STR(i));
				     PICT '@A'
		    I = I + 1
		    nNroCol = nNroCol + 6
		 ENDDO
		 IF lHayNot
		    @ PROW(),nNroCol SAY IF(lNotNum,'NOTA','JUIC')
		    @ PROW(),nNroCol+5 SAY 'AU'
		 ELSE
		    @ PROW(),nNroCol SAY 'AU'
		 ENDIF

		 nNroCol = nNroCol - (I-1)*6
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS


	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA
*** FIN OJO INSERTADO

			     ENDIF
			 ENDFOR
		      ENDIF
		      nNroCol = nNroCol - (I-1)*6
*-------------------FIN IMPRESION DE LOS INDICADORES POR RECUPERAR


	       ENDCASE
	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL ESTUDIANTE

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
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
	  AADD(aGenLog,{'cOpcionLog','<PLANILLA DE LOGROS>'})
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

/*************************************************************************
* TITULO..: INDICADOR POR RECUPEAR                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 14/2002 VIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   JUN 14/2002 VIE

OBJETIVOS:

1- Analiza si el indicador es por Recuperar

2- Retorna .T. si es de Recuperaci¢n

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lCodLogRec(cCodLog,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodLog                             // C¢digo por Recuperar
       nNroPer                             // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayRec := .F.                // .T. Hay Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL INDICADOR POR CLASE
       IF SUBS(TCO->cEvaIndTbl,nNroPer,1) == '0'
	  IF lLocCodigo('cCodigoCla','CLA',SUBS(cCodLog,1,1)) .AND.;
	     CLA->lRecupeCla
	     lHayRec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL INDICADOR POR CLASE

*>>>>ANALSIS DEL INDICADOR POR TIPO DE EVALUACION
       IF SUBS(TCO->cEvaIndTbl,nNroPer,1) # '0'
	  IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,5,1)).AND.;
	     EVA->lRecupeEva
	     lHayRec := .T.
	  ENDIF
       ENDIF
       RETURN lHayRec
*>>>>FIN ANALSIS DEL INDICADOR POR TIPO DE EVALUACION

/*************************************************************************
* TITULO..: IMPRESION DE LOS INDICADORES CON PORCENTAJE DE APROBACION    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/2006 LUN A
       Bucaramanga,Colombia         INICIO: 06:30 PM   MAR 20/2006 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de notas del profesor

2- Imprime la relaci¢n de los logros aplicados a cada estudiante

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnNotFin(lShared,cNomUsr,cAnoUsr,cPatPro,cNomSis,cNomEmp,cMaeAct,;
		   nNroPer,cCodMat,nNroInd,cNomPro,cCodGru,cNomMat,cEvaInd,;
		   lHayNot,lNotNum,cCodIso,aTitIso,aPieIso)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomMat                              // Nombre de la Materia
       nTotReg                              // Total de Registros
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cMaeAlu                              // Maestros Habilitados
       cCodNiv                              // C¢digo de Nivel
       cEvaInd                              // .T. Evaluar Indicador
       lHayNot                              // .T. Hay Nota
       lNotNum                              // .T. Nota N£merica
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso      		            // Textos del pie de p gina */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nTotPag := 0                   // Total P ginas
       LOCAL nLenInd := 6                   // Longitud del C¢digo del Indicador
       LOCAL nLenNtI := 8                   // Longitud del C¢digo de la Nota de la Recuperaci¢n del Indicador

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
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cCamDef := ''                  // Campo de Definitivas
       LOCAL cCamObs := ''                  // Campo de Observaciones
       LOCAL cLogros := ''                  // Logros
       LOCAL cNotInd := ''                  // Nota de los Indicadores
       LOCAL cRecupe := ''                  // Indicadores por Recuperar
       LOCAL aNroCol := {}                  // N£mero de Columnas
       LOCAL aLenNom := {}                  // Longitud de Nombres
       LOCAL aNoRecu := {}                  // Indicadore no Recuperados
       LOCAL nIndMin := 0                   // Indicadores Minimos
       LOCAL lHayRec := .F.                 // .T. Recuperaciones
       LOCAL lRecAnt := .F.                 // .T. Recuperaciones Anteriores
       LOCAL nNroRec := 0                   // N£mero de Recuperaciones
       LOCAL cChrRec := SPACE(01)           // Character para Recuperaciones
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cCodRec := ''                  // C¢digo de Recuperaci¢n

       LOCAL nLenNom := 0                   // Longitud del Nombre
       LOCAL cNomMae := ''                  // Nombre Maestro Habilitado
       LOCAL nSiPaso := 0                   // Control de flujo

       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cTitul1 := ''                  // T¡tulo1 para encabezado de captura
       LOCAL cHorIni := TIME()              // Hora de Inicio

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL lRetiroTno := .F.              // .T. Retiro del Estudiante
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
      *Escoge la longitud del nombre

       nFilIni := 06
       nNroFil := nFilIni
       nColIni := nNroCol
*>>>>FIN DETERMINACION DE COLS Y LONGITUD DE NOMBRE

*>>>>PREPARACION DE VARIABLES DE CAMPO
       cCamNot := 'NOP->cNotas'+STR(nNroPer,1,0)+'NoP'
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamNtI := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
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
       cTitul1 := IF(EMPTY(PRA->cTitul1Ano),'INDI',PRA->cTitul1Ano)
       cTitul1 := ALLTRIM(cTitul1)

       SELECT NOP
       GO TOP
       DO WHILE .NOT. NOP->(EOF())

**********IMPRESION DE LOS ENCABEZADOS
	    nSiPaso := 0
	    IF lPagina

*--------------CODIGO ISO PARA EL INFORME
/*
		 DO CASE
		 CASE 'DE LA SALLE BOGOTA' $ cNomEmp
		      cCodIso := 'ISO:F-SED-001'
		 ENDCASE
*/
*--------------FIN CODIGO ISO PARA EL INFORME

*--------------ENCABEZADO DEL INFORME
		 nTotPag++
		 EncabezPrn(cNomEmp,cNomSis+cCodIso,;
			    cNomMat,;
			    aTitIso[1],;
			    'GRUPO: '+cCodGru+' A¥O:'+cAnoUsr,;
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

		 i := 1
		 nNroCol = nColIni
		 DO WHILE i <= 10
					 
		    @ PROW(),nNroCol SAY IF(i<10,cTitul1,SUBS(cTitul1,1,3))+LTRIM(STR(i));
				     PICT '@A'
		    i++
		    DO CASE
		    CASE cEvaInd == '0'
			 nNroCol += 6  // 4:Indicador+1:Nota+1:Espacio

		    CASE cEvaInd == '1'
			 nNroCol += 6  // 4:Indicador+1:Nota+1:Espacio

		    CASE cEvaInd == '2'
			 nNroCol += 11  // 4:Indicador+4:Nota+1:Espacio

		    ENDCASE

		 ENDDO
		 IF lHayNot
		    DO CASE
		    CASE cEvaInd == '0' .OR. cEvaInd == '1'
			 @ PROW(),nNroCol SAY IF(lNotNum,'NOTA','JUIC')

		    CASE cEvaInd == '2'
			 @ PROW(),nNroCol SAY 'NOTA'

		    ENDCASE
		    @ PROW(),nNroCol+5 SAY 'AU'
		 ELSE
		    @ PROW(),nNroCol SAY 'AU'
		 ENDIF

		 nNroCol = nNroCol - (i-1)*6
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
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

**********ANALISIS DE LOS INDICADORES POR RECUPERAR
	    lRecAnt := .F.
	    aNoRecu := {}
	    IF !MAT->lNoRecuMat
	       FOR i := 1 TO nNroPer-1
		   cCampos := 'NOP->cIndic'+STR(i,1,0)+'NoP'
		   cLogros := SUBS(&cCampos,1,nNroInd*nLenInd)
		   cRecupe := cIndxRecu(cLogros,i)
		   AADD(aNoRecu,cRecupe)
		   IF !EMPTY(cRecupe)
		      lRecAnt := .T.
		   ENDIF
	       ENDFOR
	    ENDIF
	    cLogros := ''
**********FIN ANALISIS DE LOS INDICADORES POR RECUPERAR

**********IMPRESION DEL CODIGO Y NOMBRE DEL ESTUDIANTE
	    lRetiroTno := NOP->lRetiroNoP
	    cLogros := SUBS(&cCamInd,1,nNroInd*nLenInd)
	    cNotInd := SUBS(&cCamNtI,1,nNroInd*nLenNtI)

	    IF !(lRetiroTno .AND. CAP->nTipCarCar # 0 .AND.;
	       EMPTY(cLogros)) .OR. lRecAnt
	       SELECT NOP
	       @ PROW()+1,00 SAY RECNO()                    PICT '99'
	       @ PROW()  ,04 SAY cCodigoTes		 PICT "999999"
	       IF lRetiroTno
		  @ PROW()  ,10 SAY '.'+SUBS(cNombreTes,1,nLenNom) PICT "@A"
	       ELSE
		  @ PROW()  ,11 SAY SUBS(cNombreTes,1,nLenNom) PICT "@A"
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL CODIGO Y NOMBRE DEL ESTUDIANTE

**********IMPRESION DE LAS NOTAS DEL ESTUDIANTE
	    nNroCol = nColIni

	    IF !(lRetiroTno .AND. CAP->nTipCarCar # 0 .AND.;
	       EMPTY(cLogros)) .OR. lRecAnt

	       DO CASE
	       CASE lRetiroTes
		    @ PROW(),nNroCol SAY 'RETIRADO'   PICT '@A'

	       CASE lRetiroTno .AND. CAP->nTipCarCar == 0
		    @ PROW(),nNroCol SAY 'PERTENECE A OTRO GRUPO'   PICT '@A'

	       CASE (!lRetiroTes .AND. !lRetiroTno) .OR.;
		    !EMPTY(cLogros) .OR. lRecAnt

*-------------------IMPRESION DE LOS LOGROS
		      i = 1
		      lHayRec := .F.
		      nNroCol = nColIni
		      DO WHILE i <= nNroInd
			 cCodLog := cCodLogN(cLogros,i,nLenInd,cEvaInd,;
					     @cCodEva,@cCodRec)
			*Lectura del C¢digo

			 DO CASE
			 CASE cEvaInd == '0'
			      cCodLog := cCodLog+SPACE(01)

			 CASE cEvaInd == '1'
			      cCodLog := cCodLog+cCodEva

			 CASE cEvaInd == '2'

			      cCodLog := cCodLog+cCodEva
			      cCodEva := SUBS(cNotInd,i*nLenNtI-(nLenNtI-1),nLenNtI)
			      cCodEva := SUBS(cCodEva,1,4)

			      cCodLog := cCodLog+':'+cCodEva

			      IF nSiPaso == 0
				 IF i > 10
				    nSiPaso++
				    nNroCol := nColIni
				    @ PROW()+1,nNroCol SAY ''
				 ENDIF
			      ENDIF

			 ENDCASE

			 IF EMPTY(cCodLog)
			    @ PROW(),nNroCol SAY ''  PICT 'AA'
			 ELSE
			    IF lCodLogRec(cCodLog,nNroPer) .AND.;
			       !MAT->lNoRecuMat

/*
			       @ PROW(),nNroCol SAY IF(EMPTY(cCodRec),;
						       cChrRec,cCodRec)+;
						       cCodLog;
						PICT 'XXXXXXXXXXX'
*/

			       @ PROW(),nNroCol SAY cCodLog;
						PICT 'XXXXXXXXXX'

			       lHayRec := .T.
			    ELSE

			       DO CASE
			       CASE cEvaInd == '0'
				    @ PROW(),nNroCol SAY cCodLog PICT 'XXXXX'

			       CASE cEvaInd == '1'
				    @ PROW(),nNroCol SAY cCodLog PICT 'XXXXX'

			       CASE cEvaInd == '2'
				    @ PROW(),nNroCol SAY cCodLog;
							 PICT 'XXXXXXXXXX'
			       ENDCASE

			    ENDIF
			 ENDIF
			 i = i + 1

			 DO CASE
			 CASE cEvaInd == '0'
			      nNroCol += 6  // 4:Indicador+1:Nota+1:Espacio

			 CASE cEvaInd == '1'
			      nNroCol += 6  // 4:Indicador+1:Nota+1:Espacio

			 CASE cEvaInd == '2'
			      nNroCol += 11  // 4=Indicador++1=Espacio+4=Nota+1=Espacio

			 ENDCASE

		      ENDDO
		      cNroFal := SUBS(NOP->cFallasNoP,nNroPer*2-1,2)
		      IF lHayNot
			 @ PROW(),nNroCol SAY &cCamDef
			 IF lHayRec
			    @ PROW(),nNroCol+5 SAY cNroFal+;
				     IF('XX' $ cCodGru,;
					cChrRec+cCodigoTgr,cChrRec)
			 ELSE
			    @ PROW(),nNroCol+5 SAY cNroFal+;
				     IF('XX' $ cCodGru,':'+cCodigoTgr,'')
			 ENDIF
		      ELSE
			 IF lHayRec
			    @ PROW(),nNroCol SAY cNroFal+;
				     IF('XX' $ cCodGru,;
					cChrRec+cCodigoTgr,cChrRec)
			 ELSE
			    @ PROW(),nNroCol SAY cNroFal+;
				     IF('XX' $ cCodGru,':'+cCodigoTgr,'')
			 ENDIF
		      ENDIF
		      nNroCol = nNroCol - (I-1)*6
*-------------------FIN IMPRESION DE LOS LOGROS

*-------------------IMPRESION DE LOS INDICADORES POR RECUPERAR
		      IF lRecAnt
			 FOR k := 1 TO LEN(aNoRecu)

			     nNroCol = nColIni
			     cRecupe := aNoRecu[k]

			     IF !EMPTY(cRecupe)
				nNroRec := ROUND(LEN(ALLTRIM(cRecupe))/nLenInd,0)
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
*-------------------FIN IMPRESION DE LOS INDICADORES POR RECUPERAR


	       ENDCASE
	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL ESTUDIANTE

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
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
	  AADD(aGenLog,{'cOpcionLog','<PLANILLA DE LOGROS>'})
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