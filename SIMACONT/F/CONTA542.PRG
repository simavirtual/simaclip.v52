/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN A¥O
SUBMODULO...: LIBRO FINAL

**************************************************************************
* TITULO..: IMPRESION DEL LIBRO POR ESTUDIANTE                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 17/1999 MIE A
       Colombia, Bucaramanga        INICIO: 11:52 PM   FEB 17/1999 MIE

OBJETIVOS:

1- Imprime el libro por c¢digo del Estudiante.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_542(aParam1,aParam2,aParam3)

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
       LOCAL cTxtLib := ''                  // Texto para el Libro
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL nOpcion := 0                   // N£mero de Opci¢n
       LOCAL cNroFol := ''                  // N£mero del folio
       LOCAL cNomRec := ''                  // Nombre del Rector
       LOCAL cDocRec := ''                  // Documento del Rector
       LOCAL cCarRec := ''                  // Cargo del Rector
       LOCAL cDocSec := ''                  // Documento de la Secretaria
       LOCAL cCarSec := ''                  // Cargo de la secretaria
       LOCAL aFirmas := {}                  // Firmas del libro
       LOCAL lInfFin := .F.                 // Informe final.
       LOCAL cMatMod := ''                  // Materia de Modadalidad
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       cPatTem := cPatSis+'\'+cMaeAct

       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)       .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fConAno+cAnoUsr+ExtFile,'COA',NIL,lShared) .OR.;
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
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE TCO->nTipBolTbl== 0
	    cError('NO SE HA ESPECIFICADO EL TIPO DE BOLETIN A IMPRIMIR')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF TCO->nTipLibTbl == 2
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
       IF TCO->nTipLibTbl == 2
	  lHayErr := .T.
	  DO CASE
	  CASE JUI->(RECCOUNT()) == 0
	       cError('NO EXISTEN JUICIOS GRABADOS')
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

*>>>>LECTURA DEL TIPO DE IMPRESION
       nOpcion := nLeeOpcion('ENTRE TIPO DE INFORME: '+;
		 '1<LIBRO FINAL> 2<INFORME FINAL> 3<ABANDONAR>?',3,'1')

       IF nOpcion == 3
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lInfFin := IF(nOpcion==1,.F.,.T.)
*>>>>FIN LECTURA DEL TIPO DE IMPRESION

*>>>>PREPARACION DE LOS FIRMANTES DEL LIBRO
       cTxtLib := ALLTRIM(SCO->cTxtLibCon)+' '+;
		  ALLTRIM(SCO->cTxtLi1Con)
       cNomRec := ALLTRIM(SCO->cGerentCon)
       cDocRec := ALLTRIM(SCO->cNitGerCon)
       cCarRec := ALLTRIM(SCO->cCarGerCon)

       cNomSec := ALLTRIM(SCO->cSecretCon)
       cDocSec := ALLTRIM(SCO->cNitSecCon)
       cCarSec := ALLTRIM(SCO->cCarSecCon)
       cNroFol := IF(lInfFin,'','FOLIO No. ')
*>>>>FIN PREPARACION DE LOS FIRMANTES DEL LIBRO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'libroest'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
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

*>>>>IMPRESION DEL LIBRO
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
	    cNombreTpr := 'NO EXISTE TITULAR'
	    IF lLocCodigo('cCodigoPro','PRO',GRU->cCodigoPro,;
			  'DEL PROFESOR TITULAR')

	       cNombreTpr := ALLTRIM(PRO->cApelliPro)+' '+;
			     ALLTRIM(PRO->cNombrePro)
	    ENDIF
	    IF lInfFin

	       aFirmas := {{cNombreTpr}}   // Marca error

	       aFirmas := {{cNombreTpr,'',''},;
			   {cNombreTpr,'',''}}
	    ELSE
	       aFirmas := {{cNomRec,cDocRec,cCarRec},;
			   {cNomSec,cDocSec,cCarSec}}
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
	   nNroBis := TCO->nTotPerTbl
	   aNotAre := {}
	   aNotMat := {}
	   DetAreas(@aNotAre,@aNotMat,nNroBis)
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cNalias->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= &cNalias->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',&cNalias->cCodigoEst)

	       cError(cNombreTes+ 'COD: '+&cNalias->cCodigoEst+;
		      'NO EXISTE EN NOTAS DEL GRUPO '+GRU->cCodigoGru)
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado(ALLTRIM(cNombreTes)+' '+GRU->cCodigoGru+;
			'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

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

**********LOCALIZACION DE LA MATERIA DE MODALIDAD O ESPECIALIDAD
	    cMatMod := ''
	    IF lLocCodigo('cCodigoMat','MAT',&cMaeAct->cCodigoMat)
	       cMatMod := ALLTRIM(MAT->cNombreMat)
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA DE MODALIDAD O ESPECIALIDAD

**********IMPRESION DEL TIPO DE BOLETIN
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE TCO->nTipLibTbl == 1
		 LibroFin01(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    lRetiroTes,&cNalias->dFecRetEst,;
			    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
			    cMaeAct,cTxtLib,lInfFin,cMatMod)
		*Modelo inspirado del Colegio San Bernardo.

	    CASE TCO->nTipLibTbl == 2


		 Boletin07(cNomEmp,cNomSis,cAnoUsr,cNombreTes,'','',;
			   nNroBis,TCO->cPorcenTbl,nPorAcu,cJorTxt,;
			   cNalias,aNotAre,aNotMat,aFirmas,;
			   TCO->nColEncTbl,TCO->nColBolTbl)
	       *Solo Indicadores == 3 pero con recuperaciones


/*
		 LibroFin02(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    lRetiroTes,&cNalias->dFecRetEst,;
			    aFirmas,cJorTxt,cMaeAct,aNotAre,aNotMat,;
			    cNroFol,cTxtLib)
		*Dise¤o original. Igual al £ltimo periodo.
*/

	    CASE TCO->nTipLibTbl == 3
		 LibroFin03(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    lRetiroTes,&cNalias->dFecRetEst,;
			    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
			    cMaeAct,cTxtLib,lInfFin,cMatMod)
		*Modelo inspirado del Colegio De La Salle Bogota.

	    CASE TCO->nTipLibTbl == 4
		 cNombreTes := ALLTRIM(cNombreTes)+;
			       ' IDENTIFICACION:'+;
			       RTRIM(&cMaeAct->cDocNitEst)

		 LibroFin04(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    lRetiroTes,&cNalias->dFecRetEst,;
			    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
			    cMaeAct,cTxtLib,lInfFin,cMatMod)
		*Modelo inspirado del Colegio Presentaci¢n. Centro. Con Notas Numericas.

	    CASE TCO->nTipLibTbl == 5
		 LibroFin05(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNombreTes,;
			    lRetiroTes,&cNalias->dFecRetEst,;
			    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,;
			    cMaeAct,cTxtLib,lInfFin,cMatMod)
		*Libro para areas promediables. Isb

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
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DEL LIBRO