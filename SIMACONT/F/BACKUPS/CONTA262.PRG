/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES

**************************************************************************
* TITULO..: IMPRESION DE BOLETINES POR ESTUDIANTE                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/1998 MIE A
       Colombia, Bucaramanga        INICIO: 10:10 PM   MAR 11/1998 MIE

OBJETIVOS:

1- Imprime los Boletines por c¢digo del Estudiante.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_262(aParam1,aParam2,aParam3)

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
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

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
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nPrnBolPrn)
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
       IF TCO->lOficioTbl
	  SendCodes(PCL('Oficio'))
       ELSE
	  SendCodes(PCL('Carta'))
       ENDIF
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
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE TCO->nTipBolTbl== 1
		 BoletinNot(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)

	    CASE TCO->nTipBolTbl== 2
		 BoletinNyJ(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)


	    CASE TCO->nTipBolTbl== 3
		 BoletinJui(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
	       *Boletin con areas y asignaturas NO anidadas

	    CASE TCO->nTipBolTbl== 4
		 Bol1IndAre(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			    nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
		*Boletin con areas y asignatura anidadas

	    CASE TCO->nTipBolTbl== 5
		 Boletin05(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
	       *Boletin con areas y asignaturas NO anidadas titular animador

	    CASE TCO->nTipBolTbl== 6
		 Boletin06(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
		*Solo juicios para Belemitas. Barranca.

	    CASE TCO->nTipBolTbl == 7
		 Boletin07(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Solo Indicadores == 3 pero con recuperaciones

	    CASE TCO->nTipBolTbl == 8
		 Boletin08(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat)
	       *Solo Indicadores == 3 pero con recuperaciones

	    CASE TCO->nTipBolTbl == 9
		 Boletin09(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Boletin Sabidur¡a. Una nota y descripci¢n

	    CASE TCO->nTipBolTbl == 10
		 Boletin10(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Boletin Sabidur¡a. Todas las Notas

	    CASE TCO->nTipBolTbl == 11
		 ScoBol_11(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Boletin Abreviado. Virrey

	    CASE TCO->nTipBolTbl == 12
		 Boletin12(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
		*Boletin de la BeleBan. Descripci¢n y nota en porcentaje

	    CASE TCO->nTipBolTbl == 13
		 Boletin13(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
		*Boletin San Jose. Solo Notas

	    CASE TCO->nTipBolTbl== 98
		 Boletin98(cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			   cNombreTpr,cTitDos,nNroBis,TCO->cPorcenTbl,;
			   nPorAcu,cJorTxt,cNalias,aNotAre,aNotMat,NIL,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Prueba del Isb


	    CASE TCO->nTipBolTbl == 99
		 BoleXml07(lShared,cCodEmp,cNomEmp,cNomSis,cAnoUsr,;
			   cPatSis,PathCar,cNombreTes,cNombreTpr,;
			   cTitDos,nNroBis,TCO->cPorcenTbl,nPorAcu,;
			   cJorTxt,cNalias,aNotAre,aNotMat)
	       *Boletin en Xml

	    OTHERWISE
		cError('NUMERO DEL BOLETIN INVALIDO '+;
		       STR(TCO->nTipBolTbl,2))
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
