/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : CERTIFICADOS
SUBMODULO...: PAZ Y SALVOS. RESUMEN

**************************************************************************
* TITULO..: RESUMEN DE PAZ Y SALVOS EN DEUDA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2003 MAR A
       Colombia, Bucaramanga        INICIO: 11:20 PM   OCT 21/2003 MAR

OBJETIVOS:

1- Imprime Todos los Estudiantes con Paz y Salvo en Deuda

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_624(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
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
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL       i := 1                   // Contador
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fDpzEst+cAnoSis+ExtFile,'DPZ',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)

	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CloseAll()
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
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0
       aCabeza := {cNomEmp,cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		  'RESUMEN DE PAZ Y SALVOS',;
		  'ESTUDIANTES EN DEUDA',;
		  '',;
		  nNroPag,;
		  NIL,;
		  lTamAnc}
       cCodIni := PCL({"DraftOn","CondenOn"})
       cCodFin := PCL({"DraftOn","CondenOn"})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,04}
       aTitulo := {'CODIGO','GRUPO',;
		   'APELLIDOS Y NOMBRES ','No.'}

       PAZ->(DBGOTOP())
       DO WHILE .NOT. PAZ->(EOF())
	  IF PAZ->(RECCOUNT()) <= 12
	     AADD(aTitulo,PAZ->cTituloPaz)
	     AADD(aNroCol,04)
	  ELSE
	     AADD(aTitulo,STR(PAZ->nCodigoPaz,2,0))
	     AADD(aNroCol,02)
	  ENDIF
	  PAZ->(DBSKIP())
       ENDDO
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := 137
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := {'Nota: En Blanco est  a Paz y Salvo'}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","ProporOf","CondenOn"})
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT NOT
	    NOT->(DBGOTOP())
	    DO WHILE .NOT. NOT->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			     cGruFin+' No.'+STR(NOT->(RECNO()),2)+;
			     'ºFAVOR ESPERAR ...',cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------BUSQUEDA DEL ESTUDIANTE
		 cCodigoTes := NOT->cCodigoEst
		 IF !lSekCodigo(cCodigoTes,cMaeAct)
		    cNombreTes := 'Estudiante No Existe'
		 ENDIF
		 cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			      RTRIM(&cMaeAct->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,30)
*--------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------IMPRESION DE LOS ESTADOS DE PAZ Y SALVO
		 IF !EMPTY(ALLTRIM(&cMaeAct->cPazSdoEst))

		    aTitulo := {}
		    AADD(aTitulo,cCodigoTes)
		    AADD(aTitulo,&cMaeAct->cCodigoGru)
		    AADD(aTitulo,cNombreTes)
		    AADD(aTitulo,STR(NOT->(RECNO()),2,0))

		    PAZ->(DBGOTOP())
		    DO WHILE .NOT. PAZ->(EOF())
		       IF SUBS(&cMaeAct->cPazSdoEst,PAZ->nCodigoPaz,1) == SPACE(01)
			  IF PAZ->(RECCOUNT()) <= 12
			     AADD(aTitulo,SPACE(06))
			  ELSE
			     AADD(aTitulo,SPACE(02))
			  ENDIF
		       ELSE
			  IF PAZ->(RECCOUNT()) <= 12
			     AADD(aTitulo,'  No  ')
			  ELSE
			     AADD(aTitulo,'No')
			  ENDIF
		       ENDIF

		       PAZ->(DBSKIP())
		    ENDDO
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		   *Prepara la variable de impresion

		    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DE LOS ESTADOS DE PAZ Y SALVO

*--------------IMPRESION DE LA DESCRIPCION DE LA DEUDA
		 SELECT DPZ
		 SET FILTER TO DPZ->cCodigoEst == NOT->cCodigoEst .AND.;
			       !DPZ->lPazSdoDpz
		 DPZ->(DBGOTOP())

		 IF .NOT. EOF()

		    DO WHILE .NOT. DPZ->(EOF())
		       aTitulo := {}
		       AADD(aTitulo,'')
		       AADD(aTitulo,DPZ->cDescriDpz)

		       cTxtPrn := cRegPrint(aTitulo,{06,70})
		      *Prepara la variable de impresion

		       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
		       DPZ->(DBSKIP())
		    ENDDO

		 ENDIF
		 SET FILTER TO
*--------------FIN IMPRESION DE LA DESCRIPCION DE LA DEUDA

	       SELECT NOT
	       NOT->(DBSKIP())

	    ENDDO
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  SELECT GRU
	  SKIP

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       CloseAll()

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION POR GRUPOS