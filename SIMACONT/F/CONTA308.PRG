/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: ESTUDIANTES POR GRABAR

**************************************************************************
* TITULO..: ESTUDIANTES POR GRABAR                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/98 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   MAY 06/98 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Imprime por grupos los estudiantes que faltan por selecionarlos en las
   materias optativas

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_308(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL       k := 0                   // Contador
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nNroReg := 0                   // N£mero de Registro

       LOCAL cNombreTpr := ''               // Nombre del profesor
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
       cPatTem := cPatSis+'\'+cMaeAct
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		   FileSel+cMaeAct+ExtFile,'SEL',;
		   cPatTem+'\'+fNtxSel+cMaeAct+cExtNtx,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileMat,'MAT',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatTem+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
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

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatTem+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

		CLOSE ALL
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********RECORRIDOS DE LAS MATERIAS VARIABLES
	     SELECT PLA
	     GO TOP

	     DO WHILE .NOT. PLA->(EOF())

*---------------OMISION DE LAS AREAS O MATERIAS FIJAS
		  IF SUBS(PLA->cCodigoMat,3,2) == '00' .OR.;
		     !lMatVarMat(PLA->cCodigoMat,.F.)

		     SET DEVICE TO SCREEN
		     LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
				 'º'+ALLTRIM(MAT->cNombreMat),cNomSis)
		     SET DEVICE TO PRINT

		     PLA->(DBSKIP())
		     LOOP
		  ENDIF
*---------------FIN OMISION DE LAS AREAS O MATERIAS FIJAS

*---------------VERIFICACION DE LA MATERIA VARIABLE
		  nNroReg := PLA->(RECNO())
		  IF !lLocCodigo('cCodigoMat','PLA',MAT->cCodigoMat)

		     SET DEVICE TO SCREEN
		     LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
				 'º'+ALLTRIM(MAT->cNombreMat),cNomSis)
		     SET DEVICE TO PRINT

		     PLA->(DBSKIP())
		     LOOP

		  ENDIF
*---------------FIN VERIFICACION DE LA MATERIA VARIABLE

*---------------LISTADO DE ESTUDIANTES NO SELECIONADOS
		  AluNoSele(cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt,;
			    GRU->cCodigoGru,SUBS(GRU->cCodigoGru,1,2),;
			    SUBS(PLA->cCodigoMat,1,2),;
			    ALLTRIM(MAT->cNombreMat))

/*
		  AluSiSele(cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt,;
			    GRU->cCodigoGru,SUBS(GRU->cCodigoGru,1,2),;
			    SUBS(PLA->cCodigoMat,1,2),;
			    ALLTRIM(MAT->cNombreMat))
*/
*---------------FIN LISTADO DE ESTUDIANTES NO SELECIONADOS

		PLA->(DBGOTO(nNroReg))
		SELECT PLA
		PLA->(DBSKIP())

	     ENDDO
	     CloseDbf('PLA')
***********FIN RECORRIDOS DE LAS MATERIAS VARIABLES

	  SELECT GRU
	  SKIP

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS GRUPOS

/*************************************************************************
* TITULO DE LA FUNCION..: ESTUDIANTES NO SELECIONADOS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/95 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 19/95 MIE

OBJETIVOS:

1- Imprime para cada alumno del grupo su juicio valorativo de cada
   asignatura.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AluNoSele(cNomEmp,cNomSis,cAnoUsr,cMaeAct,;
		   cJorTxt,cCodGru,cCodNiv,cCodAre,cNomMat)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistemas
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL     j,i,k  := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO DE ALUMNOS
       SET DEVICE TO PRINT
       SELECT &cMaeAct
       SET FILTER TO cCodigoGru == GRU->cCodigoGru
       DBGOTOP()
*>>>>FIN FILTRACION DEL ARCHIVO DE ALUMNOS

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT &cMaeAct
       DBGOTOP()

       DO WHILE .NOT. EOF()

**********LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('ºGRUPO: '+GRU->cCodigoGru+':'+;
				   STR(GRU->(RECNO()),4)+'/'+;
				   STR(GRU->(RECCOUNT()),4)+;
			'ºCODIGO: '+&cMaeAct->cCodigoEst+' '+;
			'ºPLAN:'+PLA->cCodigoMat+':'+;
				 STR(PLA->(RECNO()),4)+'/'+;
				 STR(PLA->(RECCOUNT()),4),cNomSis)
	    SET DEVICE TO PRINT
**********FIN LINEA DE ESTADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF &cMaeAct->lRetiroEst .OR.;
	       (lSekCodigo(&cMaeAct->cCodigoEst+cCodAre,'SEL') .AND.;
		!EMPTY(SEL->cSecProSel))

	       SELECT &cMaeAct
	       SKIP
	       LOOP
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,26)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'ESTUDIANTES NO SELECCIONADOS. JORNADA: '+cJorTxt,;
			    'A¥O: '+cAnoUsr,;
			    'GRUPO: '+cCodGru+' MATERIA: '+cNomMat,;
			    nNroPag++,;
			    cTotPagina(nTotReg))
		 @ PROW(),00 SAY CONDEN_ON
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {06,26}
		 aTitulo := {'CODIGO',;
			     'APELLIDOS Y NOMBRES '}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := 144
		 @ PROW(),00 SAY DRAFT_ON+PICA
		 @ PROW()+1,01 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,01 SAY cTxtPrn
		 @ PROW()+1,01 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL REGISTRO
	    aTitulo := {&cMaeAct->cCodigoEst,;
			cNombreTes}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,01 SAY cTxtPrn
**********FIN IMPRESION DEL REGISTRO

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
*	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SELECT &cMaeAct
	  DBSKIP()

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
*	  DerechosPrn(cNomSis,cNomEmp,n17Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: ESTUDIANTES SI SELECIONADOS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2002 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   JUN 05/2002 MIE

OBJETIVOS:

1- Imprime para cada alumno del grupo su juicio valorativo de cada
   asignatura.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AluSiSele(cNomEmp,cNomSis,cAnoUsr,cMaeAct,;
		   cJorTxt,cCodGru,cCodNiv,cCodAre,cNomMat)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistemas
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL     j,i,k  := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO DE ALUMNOS
       SET DEVICE TO PRINT
       SELECT &cMaeAct
       SET FILTER TO cCodigoGru == GRU->cCodigoGru
       GO TOP
*>>>>FIN FILTRACION DEL ARCHIVO DE ALUMNOS

*>>>>IMPRESION DEL CUERPO DEL INFORME
       GO TOP
       DO WHILE .NOT. EOF()

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !(&cMaeAct->lRetiroEst .OR.;
		(lSekCodigo(&cMaeAct->cCodigoEst+cCodAre,'SEL') .AND.;
		 !EMPTY(SEL->cSecProSel)))

	       SELECT &cMaeAct
	       SKIP
	       LOOP
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)+SPACE(30)
	    cNombreTes := SUBS(cNombreTes,1,26)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'ESTUDIANTES SELECCIONADOS. JORNADA: '+cJorTxt,;
			    'A¥O: '+cAnoUsr,;
			    'GRUPO: '+cCodGru+' MATERIA: '+cNomMat,;
			    nNroPag++,;
			    cTotPagina(nTotReg))
		 @ PROW(),00 SAY CONDEN_ON
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {06,26,14}
		 aTitulo := {'CODIGO',;
			     'APELLIDOS Y NOMBRES ','MATERIA'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := 144
		 @ PROW(),00 SAY DRAFT_ON+PICA
		 @ PROW()+1,01 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,01 SAY cTxtPrn
		 @ PROW()+1,01 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL REGISTRO
	    aTitulo := {&cMaeAct->cCodigoEst,;
			cNombreTes,;
			cCodAre+':'+SEL->cSecMatSel}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,01 SAY cTxtPrn
**********FIN IMPRESION DEL REGISTRO

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
*	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  SELECT &cMaeAct
	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
*	  DerechosPrn(cNomSis,cNomEmp,n17Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS