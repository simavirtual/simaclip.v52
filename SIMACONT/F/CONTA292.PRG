/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES RECUPERACIONES

**************************************************************************
* TITULO..: IMPRESION DE BOLETINES RECUPERACIONES POR ESTUDIANTE         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2007 MIE A
       Bucaramanga, Colombia	    INICIO: 10:55 AM   MAY 16/2007 MIE

OBJETIVOS:

1- Imprime los Boletines de recuperaciones por c¢digo del Estudiante.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_292(aParam1,aParam2,aParam3)

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
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathMtr := ''                  // Path de SimaMatr
       LOCAL PathCon := ''                  // Path de SimaCont
       LOCAL PathPro := ''                  // Path de SimaProf
       LOCAL PathCar := ''                  // Path de SimaCart

       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cPatTem := ''                  // Path Temporal

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

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
       LOCAL cNroBis := ''                  // N£mero del Periodo
       LOCAL cTitDos := ''                  // Titular Dos
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL lHayRec := .F.                 // .T. Hay Recuperacion
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
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

*>>>>LECTURA DE PATHS
       PathPro := PathUno
       PathMtr := PathDos
       PathCar := PathTre
       PathCon := PathCua
*>>>>FIN LECTURA DE PATHS

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cPatTem := cPatSis+'\'+cMaeAct
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatTem+'\'+fNtxSel+cMaeAct+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared)   .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileMat,'MAT',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileJvf,'JVF',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileEva,'EVA',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+FileApr,'APR',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatTem+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseXYZ(lShared,cPatSis,cMaeAlu,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE TCO->nTipBolTbl== 0
	    cError('NO SE HA ESPECIFICADO EL TIPO DE BOLETIN A IMPRIMIR')

       CASE TCO->nJuiExtTbl > 1
	    cError('EL TOTAL DE INDICADORES NO PUEDE SER MAYOR A 1')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nPrnCerPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF TCO->nTipBolTbl # 1
	  IF !lUseDbf(.T.,cPatTem+'\'+;
			  FileJui+cMaeAct+cAnoSis+ExtFile,'JUI',;
			  cPatTem+'\'+;
			  fNtxJui+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	     !lUseDbf(.T.,cPatTem+'\'+FileCla,'CLA',NIL,lShared)

	     cError('ABRIENDO EL ARCHIVO DE JUICIOS')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF TCO->nTipBolTbl # 1
	  lHayErr := .T.
	  DO CASE
*	  CASE JUI->(RECCOUNT()) == 0
*	       cError('NO EXISTEN JUICIOS GRABADOS')
	  CASE CLA->(RECCOUNT()) == 0
	       cError('NO EXISTEN CLASES GRABADAS')
	  OTHERWISE
	       lHayErr :=.F.
	  ENDCASE

	  IF lHayErr
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'boleest'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","ProporOf","CondenOn"})
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS BOLETINES
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    CloseDbf('PLA')
	    CloseDbf('NOT')
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********LOCALIZACION DEL GRUPO
	    IF !lLocCodigo('cCodigoGru','GRU',&cNalias->cCodigoGru)
		cError('EL GRUPO '+&cNalias->cCodigoGru+ ' NO EXISTE')
		LOOP
	    ENDIF
**********FIN LOCALIZACION DEL GRUPO

**********LOCALIZACION DEL NOMBRE DEL TITULAR
	    cTitDos := 'NO EXISTE TITULAR2'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodProPro)

	       cTitDos := ALLTRIM(PRO->cNombrePro)+' '+;
			  ALLTRIM(PRO->cApelliPro)

	    ENDIF

	    cNombreTpr := 'NO EXISTE TITULAR'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro,;
			  'DEL PROFESOR TITULAR')

	       cNombreTpr := ALLTRIM(PRO->cNombrePro)+' '+;
			     ALLTRIM(PRO->cApelliPro)
			     
	    ENDIF
**********FIN LOCALIZACION DEL NOMBRE DEL TITULAR

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatTem+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatTem+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	       LOOP
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',&cNalias->cCodigoEst)

	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+GRU->cCodigoGru)
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			cNombreTes+' '+GRU->cCodigoGru+;
			'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********CALCULO DEL PORCENTAJE DEL ACUMULADO
	    nPorAcu := 0
	    FOR k := 1 TO nNroBis
		nPorAcu += VAL(SUBS(TCO->cPorcenTbl,k*2-1,2))
	    ENDFOR
	    aNotAre := {}
	    aNotMat := {}
	    DetAreas(@aNotAre,@aNotMat,nNroBis)
**********FIN CALCULO DEL PORCENTAJE DEL ACUMULADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO PERTENECE AL GRUPO '+GRU->cCodigoGru)

	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********REEMPLAZO DE LAS ASIGNATURAS VARIABLES
	    IF SEL->(RECCOUNT()) # 0
	       lDetAreEst(@aNotAre,@aNotMat,nNroBis,cCodigoTes)
	    ENDIF
**********FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

/*
**********ACTIVACION DEL DISPOSITIVO DE IMPRESION
	    IF SCO->lPrnArcCon
	       cNroBis := STR(nNroBis,1)
	       SET PRINTER TO &(PathPrn+'\'+NOT->cCodigoEst+'P'+cNroBis+'.TXT')
	    ENDIF
**********FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION
*/

**********SELECION DE LAS AREAS DE TRABAJO
	    IF TCO->nTipBolTbl == 99 .AND. !EMPTY(PathCar)

	       FileCli := PathCar+'\'+cPatSis+;
			  '\CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile

	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared)
		  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
		  CloseAll()
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL TIPO DE BOLETIN
	    lHayRec := lHayRecEst(nNroBis,aNotAre,aNotMat)
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE TCO->nTipBolTbl== 1 .AND. lHayRec
		 BoletinNot(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)

	    CASE TCO->nTipBolTbl== 2 .AND. lHayRec
		 BoletinNyJ(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)


	    CASE TCO->nTipBolTbl== 3 .AND. lHayRec
		 BoletinJui(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
	       *Boletin con areas y asignaturas NO anidadas

	    CASE TCO->nTipBolTbl== 4 .AND. lHayRec
		 Bol1IndAre(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
		*Boletin con areas y asignatura anidadas

	    CASE TCO->nTipBolTbl== 5 .AND. lHayRec
		 Boletin05(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
	       *Boletin con areas y asignaturas NO anidadas titular animador

	    CASE TCO->nTipBolTbl== 6 .AND. lHayRec
		 Boletin06(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
		*Solo juicios para Belemitas. Barranca.

	    CASE TCO->nTipBolTbl == 7 .AND. lHayRec
		 BoleRecu07(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			    TCO->nColEncTbl,TCO->nColBolTbl,dFecPrn)
	       *Solo Indicadores == 3 pero con recuperaciones

	    CASE TCO->nTipBolTbl == 8 .AND. lHayRec
		 Boletin08(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
	       *Solo Indicadores == 3 pero con recuperaciones

	    CASE TCO->nTipBolTbl == 9 .AND. lHayRec
		 Boletin09(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Boletin Sabidur¡a. Una nota y descripci¢n

	    CASE TCO->nTipBolTbl == 10 .AND. lHayRec
		 Boletin10(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,cNalias,TCO->nColBolTbl)
	       *Boletin Sabidur¡a. Todas las Notas

	    CASE TCO->nTipBolTbl== 98  .AND. lHayRec
		 Boletin98(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,cNalias,TCO->nColBolTbl)
	       *Prueba del Isb


	    CASE TCO->nTipBolTbl == 99 .AND. lHayRec
		 BoleXml07(lShared,cCodEmp,cNomEmp,cNomSis,cAnoUsr,;
			   cPatSis,PathCar,cNombreTes,cNombreTpr,;
			   cTitDos,nNroBis,TCO->cPorcenTbl,nPorAcu,;
			   cJorTxt,cNalias,aNotAre,aNotMat)
	       *Boletin en Xml

	    OTHERWISE
		 SET DEVICE TO SCREEN
		 IF !lHayRec
		    cError('NO TIENE RECUPERACIONES PENDIENTES')
		 ELSE
		    cError('NUMERO DEL BOLETIN INVALIDO '+;
			   STR(TCO->nTipBolTbl,2))
		 ENDIF
	    ENDCASE
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DEL TIPO DE BOLETIN

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,;
				   'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				   ' ESTUDIANTES',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO

       @ PROW()-PROW(),00 SAY ' '
       VerPrn(nOpcPrn,FilePrn)
      *Saca la ultima linea

       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LOS BOLETINES


/*************************************************************************
* TITULO..: IMPRESION DE UN BOLETIN CON INDICADORES CON RECUPERACIONES   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 MIE

OBJETIVOS:

1- Imprime el boletin para un estudiante con solo indicadores con el
   control de las recuperaciones en cada asignatura.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoleRecu07(cNomEmp,cNomSis,cAnoSys,cNomEst,cTitUno,cTitDos,;
		   nNroBis,cPorcen,nPorAcu,cJorTxt,cMaeAct,aNotAre,;
		   aNotMat,aFirmas,nColEnc,nNroCol,dFecPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del sistema
       cNomEst                              // Nombre del estudiante
       cTitUno			            // Nombre del titular Uno
       cTitDos                              // Nombre del titular Dos
       nNroBis                              // N£mero del bimestre
       cPorcen                              // Porcentajes aplicados
       nPorAcu                              // Porcentaje acumulado
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       aFirmas                              // Firmas para el libro final
       nNroCol                              // N£mero de la Columna
       nColEnc                              // Columna del Encabezado
       dFecPrn                              // Fecha de Corte */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,x,y,p := 0                 // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL cTx1Top := ''                  // Texto para el Encabezado
       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nLenPrn := n17Stan             // Longitud de impresi¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroFol := NIL                 // N£mero de Folio
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL   cNota := ''                  // Nota de area o materia

       LOCAL cCamAcu := ''                  // Campo del acumulado
       LOCAL cCamPro := ''                  // Campo del promedio
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotLin := 0                   // Total lineas impresas
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lRecNot := .F.                 // .T. Recuperar el Juicio Valorativo
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lPrnEva := .F.                 // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       LOCAL nLenEva := 0                   // Longitud del Nombre de la Evaluaci¢n del Indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lPrnCod := .F.                 // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL nLinObs := 0                   // L¡neas de Observaci¢n
       LOCAL bDerPrn := NIL                 // Derechos de Impresi¢n
       LOCAL bCabBol := NIL                 // Encabezados del Boletin
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cAcuAre := ''                  // Acumulado del area
       LOCAL cProAre := ''                  // Promedio del area
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cClaInd := ''                  // Clase de Indicador de Configuraci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL cNomCla := ''                  // Nombre de la Clase
       LOCAL lSiPaso := .F.                 // .T. Control de Flujo
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL cMatRec := ''                  // Materia de las Recuperaciones
       LOCAL cTitReN := ''                  // T¡tulo Indicadores NO Recuperados
       LOCAL cTitReS := ''                  // T¡tulo Indicadores SI Recuperados
       LOCAL cIndAnt := ''                  // Indicadores Periodos Anteriores
       LOCAL cChrIni := ''                  // C¢digo Inicial de Impresi¢n
       LOCAL cChrFin := ''                  // C¢digo Final de Impresi¢n
       LOCAL cChrLin := ''                  // Caracter separador de l¡nea
       LOCAL nNroPos := 0                   // N£mero de la Posici¢n
       LOCAL lPiePag := .T.                 // .T. Imprimir el Pie de P gina
       LOCAL lHayRec := .F.                 // .T. Hay Recuperaci¢n

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCamJuiNot := ''               // Campo de Indicadores
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL LIBRO FINAL
       IF aFirmas == NIL
	  cNroFol := NIL
       ELSE
	  cNroFol := 'Folio No.'
       ENDIF
*>>>>FIN ANALISIS DEL LIBRO FINAL

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nColEnc := IF(EMPTY(nColEnc),0,nColEnc)
       nNroCol := IF(EMPTY(nNroCol),0,nNroCol)

       cTx1Top := ALLTRIM(SCO->cTxtLibCon)+;
		  ALLTRIM(SCO->cTxtLi1Con)
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       IF EMPTY(TCO->nTotLinTbl)
	  nTotLin := IIF(lOficio,70,58)
       ELSE
	  nTotLin := TCO->nTotLinTbl
       ENDIF
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroBis,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl
       lRecNot := TCO->lRecNotTbl
       lIndNiv := TCO->lIndNivTbl
       cClaInd := TCO->cClaIndTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroBis,1)='0',.F.,.T.)
       lPrnEva := IF(SUBS(TCO->cEvaIndTbl,6,2)='00',.F.,.T.)
       nLenEva := VAL(SUBS(TCO->cEvaIndTbl,6,2))
       nLenEva := IF(nLenEva > 16,16,nLenEva)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroBis,1)='1',.T.,.F.)
       lPrnCod := TCO->lPrnCodTbl
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroBis,1)='1',.T.,.F.)
       lMatVar := IF(SUBS(TCO->cPrnVarTbl,nNroBis,1)='1',.T.,.F.)

       IF nNroBis == TCO->nTotPerTbl
	  IF EMPTY(ALLTRIM(TCO->cBolFinTbl))
	     cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
	  ELSE
	     cMsgBol := ALLTRIM(TCO->cBolFinTbl)
	  ENDIF
       ELSE
	  cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
       ENDIF

       IF !lHayNot .AND. lEvaInd
	  lNotNum := .F.
       ENDIF
       lHayItv := lHayItvJvf()
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroBis==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroBis==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

	nMarSup := TCO->nLinEspTbl
	nLinCab := 9
	nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
      *Encabezado de columna
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>ENCABEZADOS DE COLUMNA
       CabColBol(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		 cMsgBol,@aNroCol,@aTitulo,nNroBis,cNotAcu)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

*--------------IMPRESION DEL ENCABEZADO DEL BOLETIN
		 CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
			    nTotReg,;
			    cNomEst,;
			    NOT->cCodigoEst,;
			    GRU->cCodigoGru,;
			    NOT->(RECNO()),;
			    nPorAcu,cPorcen,nNroBis,cAnoSys,;
			    cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,cTx1Top,,;
			    TCO->cTi2BolTbl,,nColEnc)
			    
*--------------FIN IMPRESION DEL ENCABEZADO DEL BOLETIN

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := PCL('n17Stan')
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nNroCol SAY cTxtPrn
		 @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
		 nLenLin := LEN(cTxtPrn)
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN' .AND.;
	       !aNotAre[i,15]  // Recuperable

*==============DEFINICION DE BLOQUES DE FUNCION AREA
		 bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
					   nLenPrn,lOficio,lPiePag)}
		*Impresi¢n de los Derechos de Autor

		 bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					  cTxtPrn,;
					  nNroPag++,nTotReg,;
					  cNomEst,NOT->cCodigoEst,;
					  GRU->cCodigoGru,;
					  NOT->(RECNO()),nPorAcu,;
					  cPorcen,nNroBis,cAnoSys,;
					  cJorTxt,3,cNomEmp,lPrnEmp,;
					  cNroFol,,,;
					  TCO->cTi2BolTbl,,nColEnc)}
		*Impresi¢n del Encabezado del Boletin
*==============FIN DEFINICION DE BLOQUES DE FUNCION AREA

*==============RECUPERACIONES PENDIENTES
		 lHayRec := .F.
		 lSiPaso := .F.
		 FOR y := 1 TO nNroBis

*-------------------INDICADORES POR SI/NO RECUPERAR AREA
		      cCamJuiNot := aNotAre[i,6]
		      cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			 cIndAnt := &cCamJuiNot
			 cSiRecu := ''
			 cNoRecu := ''
		      IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*-------------------FIN INDICADORES POR SI/NO RECUPERAR AREA

*-------------------IMPRESION DEL NOMBRE DEL AREA
		      IF !EMPTY(cNoRecu) .AND. !lSiPaso

			 cNomAre := aNotAre[i,3]
			 IF lNegAre
			    cNomAre := PCL("NegraOn")+cNomAre+PCL("NegraOf")
			 ENDIF

			 IF lHayNot .OR. lEvaInd
			    aRegPrn := aRegPrnRec(lHayNot,lNotNum,lEvaInd,lPrnEva,;
						  nLenEva,lPrnCod,nNroBis,cNotAcu,;
						  SPACE(01),;
						  cNomAre+SPACE(108-LEN(aNotAre[i,3])),;
						  SPACE(01),;
						  SPACE(01))
			 ELSE
			    aRegPrn := {}
			    AADD(aRegPrn,SPACE(01))
			    AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,3])))
			    AADD(aRegPrn,SPACE(01))
			 ENDIF
			 @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			 lSiPaso := .T.

		      ENDIF
*-------------------FIN IMPRESION DEL NOMBRE DEL AREA

*-------------------IMPRESION DE LOS INDICADORES POR RECUPERAR AREA
		      IF !EMPTY(cNoRecu)
			 cTitReN := ALLTRIM(TCO->cTitReNTbl)
			 IF EMPTY(cTitReN)
			    cTitReN := '** INDICADORES POR RECUPERAR '+;
				       'PERIODO NO.# **'
			 ENDIF
			 cTitReN := PCL("NegraOn")+;
				    cTitReN+SPACE(108-LEN(cTitReN))+;
				    PCL("NegraOf")

			 nNroPos := AT('NO.#',cTitReN)
			 IF nNroPos # 0
			    cTitReN := STUFF(cTitReN,;
					     nNroPos,4,'No.'+STR(y,1))
			 ENDIF

			 IF lHayNot .OR. lEvaInd

			    aRegPrn := {}
			    AADD(aRegPrn,SPACE(02))
			    AADD(aRegPrn,cTitReN)

			    IF EMPTY(cNotAcu)
			       AADD(aRegPrn,SPACE(04))
			    ELSE
			       FOR p := 1 TO nNroBis
				   AADD(aRegPrn,SPACE(02))
			       ENDFOR
			    ENDIF
			    AADD(aRegPrn,SPACE(04))

			 ELSE
			    aRegPrn := {SPACE(02),;
					cTitReN,;
					SPACE(02)}
			 ENDIF
			 @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			 PrnIndRec(aNroCol,aTitulo,;
				   SUBS(aNotAre[i,6],9,4),;
				   cNoRecu,lIndNiv,lOficio,;
				   lHayNot,lNotNum,lPrnCod,;
				   cClaInd,lEvaInd,;
				   lPrnEva,nLenEva,;
				   cCodigoTni,bDerPrn,;
				   bCabBol,cNotAcu,nNroBis,;
				   nNroCol)
			 lHayRec := .T.
		      ENDIF
*-------------------FIN IMPRESION DE LOS INDICADORES POR RECUPERAR AREA

		 NEXT
*==============FIN RECUPERACIONES PENDIENTES

*==============IMPRESION DE LA LINEA SEPARADORA DEL AREA
		 cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		 IF !EMPTY(cChrLin) .AND. lHayRec
		    IF lHayNot .OR. lEvaInd
		       aRegPrn := aRegPrnRec(lHayNot,lNotNum,lEvaInd,lPrnEva,;
					     nLenEva,lPrnCod,nNroBis,cNotAcu,;
					     REPL(cChrLin,aNroCol[1]),;
					     REPL(cChrLin,aNroCol[2]),;
					     REPL(cChrLin,aNroCol[3]),;
					     REPL(cChrLin,aNroCol[4]))
		    ELSE
		       aRegPrn := {}
		       AADD(aRegPrn,cChrLin+cChrLin)
		       AADD(aRegPrn,REPL(cChrLin,108))
		       AADD(aRegPrn,SPACE(04))
		    ENDIF
		    @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF
*==============FIN IMPRESION DE LA LINEA SEPARADORA DEL AREA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1] .AND.;
		  !aNotMat[j,15]  // Recuperable

*=================DEFINICION DE BLOQUES DE FUNCION
		    bDerPrn := {||DerechosPrn(cNomSis,cNomEmp,;
					      nLenPrn,lOficio,lPiePag)}
		   *Impresi¢n de los Derechos de Autor

		    bCabBol := {||CabezaBole(lOficio,TCO->nLinEspTbl,;
					     cTxtPrn,;
					     nNroPag++,nTotReg,;
					     cNomEst,NOT->cCodigoEst,;
					     GRU->cCodigoGru,;
					     NOT->(RECNO()),nPorAcu,;
					     cPorcen,nNroBis,cAnoSys,;
					     cJorTxt,3,cNomEmp,lPrnEmp,;
					     cNroFol,,,;
					     TCO->cTi2BolTbl,,nColEnc)}
		   *Impresi¢n del Encabezado del Boletin
*=================FIN DEFINICION DE BLOQUES DE FUNCION

*=================RECUPERACIONES PENDIENTES. MATERIA
		    lHayRec := .F.
		    lSiPaso := .F.
		    FOR y := 1 TO nNroBis

*-----------------------INDICADORES POR SI/NO RECUPERAR. MATERIA
			  cCamJuiNot := aNotMat[j,5]
			  cCamJuiNot := STUFF(cCamJuiNot,8,1,STR(y,1))
			     cIndAnt := &cCamJuiNot
			     cSiRecu := ''
			     cNoRecu := ''
			  IndRecSiNo(cIndAnt,lEvaInd,@cSiRecu,@cNoRecu,.T.)
*-----------------------FIN INDICADORES POR SI/NO RECUPERAR. MATERIA

*-----------------------IMPRESION DEL NOMBRE DE LA MATERIA
			  IF !EMPTY(cNoRecu) .AND. !lSiPaso

			     IF lPrnAre
				IF lMatVar
				   cNomMat := ALLTRIM(aNotAre[i,3])+' : '+;
					      ALLTRIM(aNotMat[j,10])
				 *ÀMateria Notas o Certificado
				ELSE
				   cNomMat := ALLTRIM(aNotAre[i,3])+' : '+;
					      ALLTRIM(aNotMat[j,2])
				ENDIF

				nLenTxt := LEN(cNomMat)
				cNomMat := cNomMat+SPACE(108-nLenTxt)
				cNomMat := SUBS(cNomMat,1,108)
			     ELSE
				IF lMatVar
				   cNomMat := aNotMat[j,10]+SPACE(108-LEN(aNotMat[j,10]))
				 *ÀMateria Notas o Certificado
				ELSE
				   cNomMat := aNotMat[j,2]+SPACE(108-LEN(aNotMat[j,2]))
				ENDIF
			     ENDIF

			     IF lNegAre
				cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
			     ENDIF

			     IF lHayNot .OR. lEvaInd
				aRegPrn := aRegPrnRec(lHayNot,lNotNum,lEvaInd,lPrnEva,;
						      nLenEva,lPrnCod,nNroBis,cNotAcu,;
						      SPACE(01),;
						      cNomMat,;
						      SPACE(01),;
						      SPACE(01))
			     ELSE
				aRegPrn := {}
				AADD(aRegPrn,SPACE(01))
				AADD(aRegPrn,cNomAre+SPACE(108-LEN(aNotAre[i,3])))
				AADD(aRegPrn,SPACE(01))
			     ENDIF
			     @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			     lSiPaso := .T.

			  ENDIF
*-----------------------FIN IMPRESION DEL NOMBRE DE LA MATERIA

*-----------------------INDICADORES POR RECUPERAR. MATERIA
			  IF !EMPTY(cNoRecu)

			     cTitReN := ALLTRIM(TCO->cTitReNTbl)
			     IF EMPTY(cTitReN)
				cTitReN := '** INDICADORES POR RECUPERAR '+;
					   'PERIODO NO.# **'
			     ENDIF
			     cTitReN := PCL("NegraOn")+;
					cTitReN+SPACE(108-LEN(cTitReN))+;
					PCL("NegraOf")

			     nNroPos := AT('NO.#',cTitReN)
			     IF nNroPos # 0
				cTitReN := STUFF(cTitReN,;
						 nNroPos,4,'No.'+STR(y,1))
			     ENDIF

			     IF lHayNot .OR. lEvaInd

				aRegPrn := {}
				AADD(aRegPrn,SPACE(02))
				AADD(aRegPrn,cTitReN)

				IF EMPTY(cNotAcu)
				   AADD(aRegPrn,SPACE(04))
				ELSE
				   FOR p := 1 TO nNroBis
				       AADD(aRegPrn,SPACE(02))
				   ENDFOR
				ENDIF
				AADD(aRegPrn,SPACE(04))

			     ELSE
				aRegPrn := {SPACE(02),;
					    cTitReN,;
					    SPACE(02)}
			     ENDIF
			     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)

			     IF EMPTY(aNotMat[j,14]) // Materias Selectivas
				cMatRec := SUBS(aNotMat[j,11],3,4)
			     ELSE
				cMatRec := SUBS(aNotMat[j,14],y*4-3,4)
			     ENDIF

			     PrnIndRec(aNroCol,aTitulo,cMatRec,;
				       cNoRecu,lIndNiv,lOficio,;
				       lHayNot,lNotNum,lPrnCod,;
				       cClaInd,lEvaInd,;
				       lPrnEva,nLenEva,;
				       SUBS(aNotMat[j,11],1,2),;
				       bDerPrn,bCabBol,cNotAcu,nNroBis,;
				       nNroCol)

			     lHayRec := .T.

			  ENDIF
*-----------------------FIN INDICADORES POR RECUPERAR. MATERIA

		    NEXT
*=================FIN RECUPERACIONES PENDIENTES. MATERIA

*=================IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA
		    cChrLin := SUBS(TCO->cCfgBolTbl,2,1)
		    IF !EMPTY(cChrLin) .AND. lHayRec
		       IF lHayNot .OR. lEvaInd
			  aRegPrn := aRegPrnRec(lHayNot,lNotNum,lEvaInd,;
						lPrnEva,nLenEva,lPrnCod,;
						nNroBis,cNotAcu,;
						REPL(cChrLin,aNroCol[1]),;
						REPL(cChrLin,aNroCol[2]),;
						REPL(cChrLin,aNroCol[3]),;
						REPL(cChrLin,aNroCol[4]))
		       ELSE
			  aRegPrn := {}
			  AADD(aRegPrn,cChrLin+cChrLin)
			  AADD(aRegPrn,REPL(cChrLin,108))
			  AADD(aRegPrn,SPACE(04))
		       ENDIF
		       @ PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		    ENDIF
*=================FIN IMPRESION DE LA LINEA SEPARADORA DE LA MATERIA

	       ENDIF

	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > nTotLin
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > nTotLin - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= nTotLin
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
	     ENDIF
	     EJECT
	  ENDIF
	  CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,nTotReg,;
		     cNomEst,;
		     NOT->cCodigoEst,;
		     GRU->cCodigoGru,;
		     NOT->(RECNO()),;
		     nPorAcu,cPorcen,nNroBis,cAnoSys,;
		     cJorTxt,3,cNomEmp,lPrnEmp,cNroFol,,,;
		     TCO->cTi2BolTbl,,;
		     nColEnc)

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

	  @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
	  @ PROW()+1,nNroCol SAY cTxtPrn
	  @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

	  @ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	 *Imprime el encabezado del boletin
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroBis == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nNroCol SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nNroCol SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroBis == nTotPer
	  cEstado := cAproboJui(NOT->nAproboNot,;
				SUBS(GRU->cCodigoGru,1,2),;
				     @cTxtObsTap)
	  cEstado := ALLTRIM(cEstado)
       ENDIF

       aNroLin := aDivLin(ALLTRIM('OBSERVACION: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,nNroCol SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       aMatHab := {}
       IF nNroBis == nTotPer .AND. EMPTY(SUBS(TCO->cCfgBolTbl,6,1))
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroBis == nTotPer .AND. !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''

	  cTxtPrn := IF(EMPTY(TCO->cTitRecTbl),;
		       'ACTIVIDADES DE RECUPERACION DE',;
			ALLTRIM(TCO->cTitRecTbl))

	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			    ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			    ' DE '+aMatHab[i,2]+'. '
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nNroCol SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA FECHA DE CORTE
       IF dFecPrn # CTOD('00/00/00')
	  @ PROW()+1,nNroCol SAY 'FECHA DE CORTE:'+cFecha(dFecPrn)
       ENDIF
*>>>>FIN IMPRESION DE LA FECHA DE CORTE

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(ALLTRIM(TCO->cOb2BolTbl))
	  aNroLin := aDivLin(ALLTRIM(TCO->cOb2BolTbl),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nNroCol SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n de General

       nLinObs := IF(EMPTY(VAL(SUBS(TCO->cCfgBolTbl,1,1))),2,;
		     VAL(SUBS(TCO->cCfgBolTbl,1,1)))
       FOR p := 1 TO nLinObs
	   @ PROW()+2,nNroCol SAY REPL('-',nLenLin)
       ENDFOR
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>FIRMANTES DEL BOLETIN
       IF aFirmas == NIL
	  aFirmas := {}
	  DO CASE
	  CASE EMPTY(SUBS(TCO->cCfgBolTbl,7,1)) .OR.;
	       SUBS(TCO->cCfgBolTbl,7,1) == '1'

	       cTxtPrn := 'Dir. '+cTitUno
	       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn

	  CASE SUBS(TCO->cCfgBolTbl,7,1) == '2'
	       aFirmas := {{ALLTRIM(SCO->cGerentCon),NIL,ALLTRIM(SCO->cCarGerCon)},;
			   {cTitUno,NIL,'Dir.'}}
	       Firmas(PCL('n17Stan'),4,aFirmas)

	  CASE SUBS(TCO->cCfgBolTbl,7,1) == '3'

	       aFirmas := {{cTitUno,NIL,'Dir.'},;
			   {cTitDos,NIL,'Dir.'}}
	       Firmas(PCL('n17Stan'),4,aFirmas)

	  OTHERWISE
	       cTxtPrn := 'Dir. '+cTitUno
	       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	       @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
	  ENDCASE

       ELSE
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.,nNroCol)
       ENDIF

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag)
       EJECT
       RETURN NIL
*>>>>FIN FIRMANTES DEL BOLETIN

/*************************************************************************
* TITULO..: IMPRESION DE LOS INDICADORES POR RECUPERAR                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2001 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 14/2001 VIE

OBJETIVOS:

1- Imprime los indicadores de cualquier asignatura

2- Los indicadores pueden ser de las recuperaciones.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnIndRec(aNroCol,aTitulo,cCodMat,cLogros,lIndNiv,lOficio,;
		   lHayNot,lNotNum,lPrnCod,cClaInd,lEvaInd,lPrnEva,;
		   nLenEva,cNivInd,bDerPrn,bCabBol,cNotAcu,nNroPer,;
		   nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNroCol                              // Columnas de los titulos
       aTitulo                              // T¡tulos para el informe
       cCodMat                              // C¢digo de la Materia
       cLogros                              // Indicadores a Imprimir
       lIndNiv                              // .T. Indicadores por nivel
       lOficio                              // .F. Tama¤o carta
       lHayNot                              // .T. Hay Nota final
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       cClaInd                              // Clase de Indicador de Configuraci¢n
       lEvaInd                              // .T. Evaluar el Indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       cNivInd                              // Nivel del Indicador
       bDerPrn                              // Derechos de Impresi¢n
       bCabBol                              // Encabezados del Boletin
       cNotAcu                              // Notas Acumuladas
       nNroPer                              // N£mero del Periodo
       nNroCol                              // N£mero de Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   k,j,p := 0                   // Contador
       LOCAL nTotLin := 0                   // Total lineas impresas
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL cRecEva := ''                  // Recuperaci¢n de la Evaluaci¢n
       LOCAL cCodEva := ''                  // C¢digo de Evaluaci¢n

       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTju := ''               // C¢digo del Indicador
       LOCAL cNombreTju := ''               // Descripci¢n del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS INDICADORES
       nNroCol := IF(EMPTY(nNroCol),0,nNroCol)
       IF EMPTY(TCO->nTotLinTbl)
	  nTotLin := IIF(lOficio,70,58)
       ELSE
	  nTotLin := TCO->nTotLinTbl
       ENDIF
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR k:= 1 TO nNroInd

***********SEPARACION DEL CODIGO DEL LOGRO
	     cCodInd    := SUBS(cLogros,k*6-5,6)
	     cCodLog    := SUBS(cCodInd,1,4)
	     cCodigoTev := SUBS(cCodInd,5,1)
	     cRecEva    := SUBS(cCodInd,6,1)
	     IF EMPTY(cCodInd)
		LOOP
	     ENDIF
	     cCodEva := IF(EMPTY(cRecEva),cCodigoTev,cRecEva)
***********FIN SEPARACION DEL CODIGO DEL LOGRO

***********LOCALIZACION DEL CODIGO DE EVALUACION
	     IF lEvaInd .AND. lPrnEva
		IF lLocCodigo('cCodigoEva','EVA',;
			      SUBS(cCodEva,1,1),;
			      'DE LA EVALUACION '+cCodInd)
		   cCodigoTev := SUBS(EVA->cNombreEva,1,nLenEva)
		ELSE
		   cCodigoTev := 'NO EXISTE'
		ENDIF
	     ELSE
		cCodigoTev += SPACE(03)
	     ENDIF
***********FIN LOCALIZACION DEL CODIGO DE EVALUACION

***********LOCALIZACION DE LA CLASE DE INDICADOR
	     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
	     IF cCodLog # SPACE(04)
		cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
		IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
			      'DE LA CLASE')

*------------------ANALISIS DEL NIVEL PARA EL INDICADOR
		     IF EMPTY(CLA->cCodigoMat)
			IF EMPTY(cNivInd)
			   cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			  *Por nivel
			ELSE
			   cCodigoTni := cNivInd
			  *Por Niveles
			ENDIF
		     ELSE
			cCodMat := CLA->cCodigoMat
			cCodigoTni := SPACE(02)
		     ENDIF
		   *ÀAsignaci¢n del nivel para usar indicador nivel o materia
*------------------FIN ANALISIS DEL NIVEL PARA EL INDICADOR

		ENDIF
	    ENDIF
***********FIN LOCALIZACION DE LA CLASE DE INDICADOR

***********BUSQUEDA DEL INDICADOR
	     cCodigoTju := IF(lIndNiv,;
			      cCodigoTni+cCodMat+cCodLog,;
			      cCodMat+cCodLog)

	     cNombreTju := 'NO EXISTE EL CODIGO '+cCodInd
	     cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
	     IF lSekCodigo(cCodigoTju,'JUI')
		cNombreTju := JUI->cNombreJui
	     ENDIF
***********FIN BUSQUEDA DEL INDICADOR

***********IMPRESION DEL INDICADOR
	     aRegPrn := aRegPrnRec(lHayNot,lNotNum,;
				   lEvaInd,lPrnEva,;
				   nLenEva,lPrnCod,;
				   nNroPer,cNotAcu,;
				   cClaInd(cClaInd,cCodigoTcl),;
				   '- '+cNombreTju,;
				   cCodigoTev,; // Modificado
				   SPACE(02))

	     @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
***********FIN IMPRESION DEL INDICADOR

***********IMPRESION DE LOS INDICADORES EXTRAS
	     FOR j := 1 TO TCO->nJuiExtTbl

		 cNombreTju := &('JUI->cExtra'+STR(j,1)+'Jui')
		 cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)

		 aRegPrn := aRegPrnRec(lHayNot,lNotNum,;
				       lEvaInd,lPrnEva,;
				       nLenEva,lPrnCod,;
				       nNroPer,cNotAcu,;
				       SPACE(02),;
				       '  '+cNombreTju,;
				       SPACE(02),;
				       SPACE(02))

		 IF !EMPTY(ALLTRIM(cNombreTju))
		    @PROW()+1,nNroCol SAY cRegPrint(aRegPrn,aNroCol)
		 ENDIF

	     ENDFOR
***********FIN IMPRESION DE LOS INDICADORES EXTRAS

***********ANALISIS PARA EL CAMBIO DE PAGINA
	     IF PROW() > nTotLin
		EVAL(bDerPrn)
*		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		EJECT
		EVAL(bCabBol)

		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		@ PROW(),00 SAY PCL({"DraftOn","CondenOn"})

		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
		@ PROW()+1,nNroCol SAY cTxtPrn
		@ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

		@ PROW()  ,00 SAY PCL({"NegraOf","DobGolOf"})
	     ENDIF
***********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION DE LOS INDICADORES

/*************************************************************************
* TITULO..: REGISTRO DE IMPRESION DEL BOLETIN                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 14/2002 DOM A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ABR 14/2002 DOM

OBJETIVOS:

1- Prepara el registro de impresi¢n del Boletin en un vector.

2- Retorna el vector de impresion

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aRegPrnRec(lHayNot,lNotNum,lEvaInd,lPrnEva,nLenEva,lPrnCod,;
		    nNroPer,cNotAcu,cColNo1,cColNo2,cColNo3,cColNo4)

*>>>>DESCRIPCION DE PARAMETROS
/*     lHayNot                              // .T. Hay Notas
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       lEvaInd                              // .T. Evaluar el indicador
       lPrnEva                              // .T. Imprimir el Nombre de la Evaluaci¢n del Nombre del Indicador. .F. Imprime el c¢digo de Evaluaci¢n.
       nLenEva                              // Longitud del Nombre de la Evaluaci¢n del Indicador
       lPrnCod                              // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       nNroPer			            // N£mero del Periodo
       cNotAcu                              // Notas Acumuladas
       cColNo1                              // Columna No. 1  Intensidad
       cColNo2                              // Columna No. 2  Materia
       cColNo3                              // Columna No. 3  Nota o Notas
       cColNo4                              // Columna No. 4  Fallas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aRegPrn := {}                  // Registro de Impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>REGISTRO DE IMPRESION DEL BOLETIN
       AADD(aRegPrn,cColNo1)  // Intensidad
       AADD(aRegPrn,cColNo2)  // Materia

       IF lHayNot .OR. lEvaInd

	  IF lHayNot

	     IF EMPTY(cNotAcu)

		IF lPrnCod
		   AADD(aRegPrn,cColNo3)   // Notas
		ELSE
		   IF EMPTY(cColNo3)
		      AADD(aRegPrn,'')
		   ELSE
		      IF SUBS(TCO->cCfgBolTbl,2,1) $ cColNo3  // Separador de linea
			 AADD(aRegPrn,cColNo3)
		      ELSE
			 AADD(aRegPrn,cColNo3) // Modificado
*			 AADD(aRegPrn,ALLTRIM(cTxtNota(cColNo3)))
		      ENDIF
		   ENDIF
		ENDIF

	     ELSE

		IF lNotNum

		   IF !EMPTY(cColNo3)
		      aRegPrn[2] := ALLTRIM(aRegPrn[2])
		      aRegPrn[2] := SUBS(aRegPrn[2]+SPACE(60),1,60)
		   ENDIF

		   FOR i := 1 TO nNroPer

		       IF !EMPTY(cColNo3)

			  aRegPrn[2] += ' P'+STR(i,1)+'='+;
				cNotDefJvf(VAL(SUBS(cColNo3,i*4-3,4)))+':'+;
					 ALLTRIM(SUBS(cColNo3,i*4-3,4))
		       ENDIF
		   ENDFOR
		   aRegPrn[2] := SUBS(aRegPrn[2]+SPACE(106),1,106)

		ELSE

		   FOR i := 1 TO nNroPer
		       AADD(aRegPrn,ALLTRIM(SUBS(cColNo3,i*4-3,4)))
		   ENDFOR
		ENDIF

	     ENDIF

	  ELSE

	     IF lPrnEva

		IF nLenEva > 4
		   AADD(aRegPrn,SPACE(nLenEva))
		ELSE
		   AADD(aRegPrn,SPACE(06))
		ENDIF

	     ELSE
		AADD(aRegPrn,SPACE(04))
	     ENDIF
	  ENDIF
	  AADD(aRegPrn,cColNo4)  // Intensidad

       ELSE
	  AADD(aRegPrn,cColNo3)
       ENDIF
       RETURN aRegPrn
*>>>>FIN REGISTRO DE IMPRESION DEL BOLETIN