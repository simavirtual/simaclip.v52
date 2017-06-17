/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: INDICADORES POR PROFESOR

**************************************************************************
* TITULO..: INDICADORES POR PROFESOR                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 29/1997 MIE A
       Bucaramanga, Colombia	    INICIO: 05:40 PM   ENE 29/1997 MIE

OBJETIVOS:

1- Permite imprimir las listas de clase de cada profesor.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_3121(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nTotReg := 0                   // Total Registros
       LOCAL FileMaP := ''                  // Archivo Materias Profesor
       LOCAL nTipBol := 0                   // Tipo de Boletin
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTpr := ''               // Nombre del Profesor
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      FileMat,'MAT',NIL,lShared)                  .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileCla,'CLA',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileJui+cMaeAct+cAnoSis+ExtFile,'IND',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxJui+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL

       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADOS')

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LOS PROFESORES
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro .AND.;
		     PRO->lCargasPro .AND. !PRO->lRetiroPro
       GO TOP
       IF EOF()
	  cError('NO EXISTEN PROFESORES PARA '+cMaeAct)
	  SET FILTER TO
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervPro(nFilInf+1,nColInf,@nRegIni,@nRegFin)
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

*>>>>SELECCION DE LA CLASE DE INDICADOR
       SELECT CLA
       IF nSelRegDbf(nFilInf+1,nColInf-1,'CLA','cNombreCla') == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       cCodigoTcl := CLA->cCodigoCla
*>>>>FIN SELECCION DE LA CLASE DE INDICADOR

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>IMPRESION POR PROFESOR
       SELECT PRO
       GO nRegIni
       DO WHILE PRO->(RECNO()) <= nRegFin

**********VALIDACION DE LA CARGA ACADEMICA
	    DO CASE
	    CASE !PRO->lCargasPro
		 cError('NO TIENE CARGA ACADEMICA')

	    CASE !(cMaeAct $ PRO->cMaeAluPro)
		 cError('NO TIENE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
			  ALLTRIM(PRO->cNombrePro)
**********FIN VALIDACION DE LA CARGA ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !EMPTY(PathUno)
	       FileMaP := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  PRO->cCodigoPro+'\'+;
			  'MATPRO'+cAnoSis+ExtFile
	    ELSE
	       FileMaP := cPatSis+'\'+cMaeAct+'\'+;
			  'CARGA'+cMaeAct+ExtFile
	    ENDIF

	    IF !lUseDbf(.T.,FileMaP,'MAP',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE CARGA ACADEMICA')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE MAP->(RECCOUNT()) == 0
		 cError('NO EXISTEN REGISTROS DE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LA MATERIA O AREA A GRABAR
	    cCodigoTni := MAP->cCodigoNiv
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
**********FIN SELECION DE LA MATERIA O AREA A GRABAR

**********FILTRACION DE LA CARGA ACADEMICA
	    SELECT MAP
	    GO TOP
	    IF EMPTY(PathUno)
	       SET FILTER TO MAP->cCodigoPro == PRO->cCodigoPro
	       GO TOP
	       IF EOF()
		  cError('NO EXISTE CARGA PARA EL PROFESOR')
		  SET FILTER TO
		  SELECT PRO
		  PRO->(DBSKIP())
	       ENDIF
	    ENDIF
**********FIN FILTRACION DE LA CARGA ACADEMICA

**********IMPRESION DE N COPIAS
	    nNroCop := 1
	    DO WHILE nNroCop <= nCopias

*--------------RECORRIDO DE LA CARGA ACADEMICA
		 nTipBol := 3
		 SELECT MAP
		 nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
		 DO WHILE .NOT. MAP->(EOF())

*...................LOCALIZACION DE LA MATERIA
		      cCodigoTma := MAP->cCodigoMat
		      cCodigoTni := MAP->cCodigoNiv
		      lLocCodigo('cCodigoMat','MAT',MAP->cCodigoMat)
*...................FIN LOCALIZACION DE LA MATERIA

*...................FILTRACION DE LOS INDICADORES
		      SELECT IND
		      IF TCO->lIndNivTbl
			 SET FILTER TO SUBS(IND->cCodigoJui,1,4) == cCodigoTma .AND.;
				       IND->cCodigoNiv == cCodigoTni
		      ELSE
			 SET FILTER TO SUBS(IND->cCodigoJui,1,4) == SUBS(cCodigoTma,1,2)+'00'
		      ENDIF
		      GO TOP

		      IF EOF()
			 cError('NO HAY INDICADORES DE '+;
				ALLTRIM(MAT->cNombreMat)+;
				IF(TCO->lIndNivTbl,' PARA EL NIVEL '+;
						   cCodigoTni,''))
			 SELECT MAP
			 MAP->(DBSKIP())
			 LOOP
		      ENDIF
*...................FIN FILTRACION DE LOS INDICADORES

*...................TOTAL DE REGISTROS A IMPRIMIR
		      COUNT FOR VAL(SUBS(IND->cCodigoJui,1,4)) == VAL(cCodigoTma);
			    TO nTotReg
*...................FIN TOTAL DE REGISTROS A IMPRIMIR

*...................VISUALIZACION DE LA CARGA
		      @ nNroFil,01 SAY 'NIVEL: '+MAP->cCodigoNiv+' '+;
				       ALLTRIM(MAT->cNombreMat)
		      nNroFil++
		      IF nNroFil == 21
			 nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
		      ENDIF
*...................FIN VISUALIZACION DE LA CARGA

*...................IMPRESION DE LOS INDICADORES
		      PrnIndica2(cNomSis,cNomEmp,cNomUsr,cAnoUsr,cMaeAct,;
				 cJorTxt,ALLTRIM(MAP->cNombreMat),;
				 nTotReg,cCodigoTni,cNombreTpr)
*...................FIN IMPRESION DE LOS INDICADORES

		    SELECT MAP
		    MAP->(DBSKIP())

		 ENDDO
		 nNroCop++
*--------------FIN RECORRIDO DE LA CARGA ACADEMICA

	    ENDDO
	    SELECT IND
	    SET FILTER TO
	    CloseDbf('MAP')
**********FIN IMPRESION DE N COPIAS

	  SELECT PRO
	  PRO->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION POR PROFESOR