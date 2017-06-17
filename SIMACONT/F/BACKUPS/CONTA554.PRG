/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FINAL A¥O
SUBMODULO...: POR CODIGO

**************************************************************************
* TITULO..: IMPRESION ESTUDIANTES POR NIVEL                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 05/1996 VIE A
       Colombia, Bucaramanga        INICIO: 11:55 PM   DIC 05/1996 VIE

OBJETIVOS:

1- Imprime por niveles los Estudiantes por c¢digo

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_554(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lPrnCab := .F.                 // .T. Imprimir Encabezado

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀVariables de informe

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cDescriTap := ''               // Descripci¢n de la Aprobaci¢n
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL lRetGruTno := .F.              // .T. Estudiante de Otro Grupo
       LOCAL nAproboTno := 0                // C¢digo de Aprobaci¢n

       LOCAL       i := 1                   // Contador
       LOCAL aNroLin := {}                  // N£mero de l¡neas

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
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
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DEL PATH DEL SISTEMA
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatSis := cPatSis+'\JAR'
       CASE 'PRI' $ cMaeAct
	    cPatSis := cPatSis+'\PRI'
       CASE 'BTO' $ cMaeAct
	    cPatSis := cPatSis+'\BTO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileApr,'APR',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LOS CODIGOS DE APROBACION
       @ nFilInf+1,nColInf SAY 'CODIGO DE APROBACION:';
			   GET nAproboTno PICT '99'
       READ
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LOS CODIGOS DE APROBACION

*>>>>LOCALIZACION DEL CODIGO DE APROBACION
       IF !EMPTY(nAproboTno)
	  IF !lLocCodigo('nCodigoApr','APR',nAproboTno)
	     cError('CODIGO DE APROBACION NO EXISTE')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
       cDescriTap := APR->cDescriApr
*>>>>FIN LOCALIZACION DEL CODIGO DE APROBACION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lPrnCab := lPregunta('IMPRIMIR EL ENCABEZADO? Si No')
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 30
       aCabeza := {IF(lPrnCab,cNomEmp,''),;
		  cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  'RESUMEN DE PROMOCIONES POR CODIGO',;
		  '',;
		  '',;
		  nNroPag,;
		  cTotPagina(nTotReg),;
		  lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*'ALUMNOS CON OBSERVACION: '+ALLTRIM(cDescriTap),;

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,110}
       aTitulo := {'CODIGO',;
		   'GRUPO',;
		   'APELLIDOS Y NOMBRES ',;
		   'DESCRIPCION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON()
	   RETURN NIL
       ENDIF
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL CUERPO DEL INFORME
	    GO TOP
	    DO WHILE .NOT. NOT->(EOF())

*--------------BUSQUEDA DEL ESTUDIANTE
		 cCodigoTes := NOT->cCodigoEst
		 IF !lSekCodigo(cCodigoTes,cMaeAct)
		    cNombreTes := 'Estudiante No Existe'
		 ENDIF
		 cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			      RTRIM(&cMaeAct->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 lRetiroTes := &cMaeAct->lRetiroEst
		 lRetGruTno := NOT->lRetGruNot
*--------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------IMPRESION DE LA PRIMERA LINEA
		 IF NOT->nAproboNot == nAproboTno

		    DO CASE
		    CASE lRetiroTes
			 aTitulo := {&cMaeAct->cCodigoEst,;
				     GRU->cCodigoGru,;
				     cNombreTes,;
				     'RETIRADO'}

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			*Prepara la variable de impresion

			 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

		    CASE lRetGruTno
			 aTitulo := {&cMaeAct->cCodigoEst,;
				     GRU->cCodigoGru,;
				     cNombreTes,;
				     'OTRO GRUPO'}

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			*Prepara la variable de impresion

			 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

		    CASE !lRetiroTes .AND. !lRetGruTno .AND. EMPTY(NOT->nAproboNot)

			 aTitulo := {&cMaeAct->cCodigoEst,;
				     GRU->cCodigoGru,;
				     cNombreTes,;
				     ''}

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			*Prepara la variable de impresion

			 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

		    CASE (!lRetiroTes .AND. !lRetGruTno) .AND. ;
			 (&cMaeAct->nAproboNot # NOT->nAproboNot .OR.;
			  &cMaeAct->lRepiteEst # APR->(!lAproboApr))

			 aTitulo := {&cMaeAct->cCodigoEst,;
				     GRU->cCodigoGru,;
				     cNombreTes,;
				     'ERROR EL CODIGO DEL MAESTRO NO COINCIDO CON EL DE LAS NOTAS'}

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			*Prepara la variable de impresion

			 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

		    CASE !lRetiroTes .AND. !lRetGruTno .AND. ;
			 &cMaeAct->nAproboNot == NOT->nAproboNot .AND.;
			 &cMaeAct->lRepiteEst == APR->(!lAproboApr)

			 aNroLin := aDivLin(ALLTRIM(cDescriTap),110)
			 FOR i := 1 TO LEN(aNroLin)

			    IF i == 1
			       aTitulo := {&cMaeAct->cCodigoEst,;
					   GRU->cCodigoGru,;
					   cNombreTes,;
					   SUBS(aNroLin[i]+SPACE(110),1,110)}
			    ELSE
			       aTitulo := {'','','',;
					   SUBS(aNroLin[i]+SPACE(110),1,110)}
			    ENDIF

			    cTxtPrn := cRegPrint(aTitulo,aNroCol)
			   *Prepara la variable de impresion

			    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
			 ENDFOR

		    ENDCASE


		 ENDIF
*--------------FIN IMPRESION DE LA PRIMERA LINEA

	       NOT->(DBSKIP())

	    ENDDO
	    CloseDbf('NOT')
**********IMPRESION DEL CUERPO DEL INFORME

	  SELECT GRU
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  EVAL(bDerAut)
	 *Impresi¢n de Derechos
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS