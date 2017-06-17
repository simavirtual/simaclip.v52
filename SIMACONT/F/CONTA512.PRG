/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: HABILITACIONES         MODULO No. 512

**************************************************************************
* TITULO..: RELACION DE HABILITANTES                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 01:10 PM   OCT 06/95 VIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Imprime la relaci¢n total de los habilitantes

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_512(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa

       LOCAL GetList := {}                  // Variable del Sistema
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
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lHayNot := IF(SUBS(TCO->cHayNotTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,TCO->nTotPerTbl,1)='1',.T.,.F.)
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACIO PARA EL NIVEL')

       CASE .NOT. lHayNot
	    cError('NO ESTA HABILITADA LA OPCION DE HAY '+;
		   IF(lNotNum,'NOTAS','JUICIOS VALORATIVOS'))

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       CloseDbf('TCO')
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<POR ESTUDIANTE>',;
		  '2<POR MATERIAS  >'}

       aAyuda := {'Imprime los habilitantes por Estudiante',;
		  'Imprime los habilitantes por Materias'}
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroFil := nFilInf-LEN(aMenus) - 3
	  nNroCol := nColInf+6
	*ÀCoordenadas para cascada

	  nNroOpc := nMenu(aMenus,aAyuda,nNroFil,nNroCol,NIL,NIL,nNroOpc)
	  nNroFil := nNroFil + LEN(aMenus) + 1

	  cSavPan := SAVESCREEN(0,0,24,79)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1 .AND. lNotNum  // Nota N£merica
	       PrnNHabEst(lShared,nFilInf,nColInf,cNomEmp,cNomSis,;
			 cAnoUsr,cMaeAct,cPatSis,cNomUsr,cJorTxt)
	      *Por Estudiante.

	  CASE nNroOpc == 1 .AND. !lNotNum  // Nota Cualitativa.
*	       PrnJHabEst(lShared,nFilInf,nColInf,cNomEmp,cNomSis,;
*			 cAnoUsr,cMaeAct,cPatSis,cNomUsr,cJorTxt)
	      *Por Estudiante.

	  CASE nNroOpc == 2 .AND. lNotNum  // Nota N£merica
	       PrnNHabMat(lShared,nFilInf,nColInf,cNomEmp,cNomSis,;
			 cAnoUsr,cMaeAct,cPatSis,cNomUsr,cJorTxt)
	      *Por Materias.
	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION HABILITANTES POR ARAES Y MATERIAS     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/95 VIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   OCT 06/95 VIE

OBJETIVOS:

1- Imprime la relaci¢n de los habilitantes por  reas y materias y el
   usuario lo autoriza.

2- Debe estar en uso los archivos de materias,

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnNHabEst(lShared,nFilInf,nColInf,cNomEmp,cNomSis,;
		    cAnoUsr,cMaeAct,cPatSis,cNomUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del sistema
       cMaeAct                              // Maestro habilitado
       cPatSis                              // Path del sistema
       cNomUsr                              // Nombre del usuario
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // Path del sistemas
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nLinReg := 0                   // L¡neas del registro
       LOCAL cRegPrn := ''                  // Registro de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nNroReg := 0                   // N£mero de registros

       LOCAL lTamAnc := .T.                 // .T. Tama¤o Ancho
       LOCAL aCabeza := {}                  // Definici¢n del encabezado
       LOCAL cCodIni := ''                  // C¢digos impresora iniciales
       LOCAL cCabCol := ''                  // Encabezados de columnas
       LOCAL cCodFin := ''                  // C¢digos impresora finales
       LOCAL lCentra := .T.                 // Centrar Encabezados Columna
       LOCAL nColCab := 0                   // Columna encabezado columna

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lPrnMat := ''                  // Imprimir materias
       LOCAL cCodGru := ''                  // C¢digo del grupo
       LOCAL lMisGru := .T.                 // .T. Mismo Grupo
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL nNroHab := 1                   // Habilitantes por curso
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACIO PARA EL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE COPIA
       nCopias := 1
       @ nFilInf+3,nColInf SAY 'NRO COPIAS:' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF

       lPrnMat := !lPregunta('DESEA IMPRIMIR SOLO LAS AREAS '+;
			    'SIN LAS MATERIAS? Si No')
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>CREACION DE ARCHIVO TEMPORAL DE HABILITANTES
       GraHabTem(cNomSis,cNomUsr,cPatSis+'\'+cMaeAct,;
		 cAnoUsr,nRegIni,nRegFin,TCO->nTotPerTbl)
*>>>>FIN CREACION DE ARCHIVO TEMPORAL DE HABILITANTES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.UNO','UNO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.DOS','DOS',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS TEMPORALES')
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE UNO->(RECCOUNT()) == 0
	    cError('NO HAY HABILITANTES')

       CASE DOS->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS A HABILITAR. POR FAVOR REVISAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := IF(lPrnMat,UNO->(RECCOUNT())+DOS->(RECCOUNT()),;
			     UNO->(RECCOUNT()))

       aCabeza := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'RELACION DE '+IF ('0000' $ TCO->cNotNumTbl,;
				 'RECUPERACIONES','HABILITANTES'),;
		   'FECHA DE PUBLICACION: ________________',;
		   '',;
		   nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := DRAFT_ON+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,02,06,40,08,04,10,04,08,04,10,04}
       aTitulo := {'NRO.',;
		   'GRUPO ',;
		   'No',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES ',;
		   'HABILITA',;
		   'NOTA',;
		   'FECHA ',;
		   'ACTA',;
		   'HABILITA',;
		   'NOTA',;
		   'FECHA ',;
		   'ACTA'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

***********IMPRESION DEL TERMOMETRO
	     SET DEVICE TO SCREEN
	     Termometro(0,'IMPRIMIENDO LOS HABILITANTES COPIA No.'+;
			  STR(nNroCop,2)+'\'+STR(nCopias,2))
	     Termometro(10)
	     SET DEVICE TO PRINT
***********FIN IMPRESION DEL TERMOMETRO

***********IMPRESION DEL ENCABEZADO
	     CabezaPrn(cCodIni,aCabeza,cCabCol,nColCab,cCodFin)
***********FIN IMPRESION DEL ENCABEZADO

***********IMPRESION DEL INFORME
	     SELECT UNO
	     GO TOP
	     cCodGru := UNO->cCodigoGru
	     lMisGru := .F.

	     DO WHILE .NOT. UNO->(EOF())

*---------------ANALISIS DEL CAMBIO DE PAGINA
		  IF lPagina(4)
		     lMisGru := .F.
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO DE PAGINA

*---------------IMPRESION DEL CONTENIDO DEL INFORME
		  cRegPrn := cRegPrint({STR(UNO->(RECNO()),4),;
					IF(lMisGru,SPACE(06),UNO->cCodigoGru),;
					STR(nNroHab++,2),;
					SUBS(UNO->cCodigoEst,3,4),;
					SUBS(UNO->cNombreEst,1,40),;
					UNO->cTitUnoUno,;
					UNO->cNotUnoUno,;
					cFecha(UNO->dFecUnoUno)+' ',;
					UNO->cActUnoUno,;
					UNO->cTitDosUno,;
					UNO->cNotDosUno,;
					cFecha(UNO->dFecDosUno)+' ',;
					UNO->cActDosUno},;
					aNroCol)

		  lPrintPrn(01,nColCab,cCodIni,aCabeza,cCabCol,;
				  nColCab,cCodFin,cRegPrn,cNomSis,;
				  cNomEmp,IF(lPrnMat,4,0),nLenPrn)
*---------------FIN IMPRESION DEL CONTENIDO DEL INFORME

*---------------IMPRESION DE LAS MATERIAS A HABILITAR
		  IF lPrnMat
		     SELECT DOS
		     SET FILTER TO DOS->cCodigoEst == UNO->cCodigoEst
		     GO TOP
		     DO WHILE .NOT. DOS->(EOF())

			cRegPrn := cRegPrint({SPACE(04),;
					      SPACE(06),;
					      SPACE(02),;
					      SPACE(04),;
					      SPACE(02)+;
					       SUBS(DOS->cNombreMat+;
						    SPACE(30),1,38),;
					      SPACE(08),;
					      SPACE(04),;
					      SPACE(10),;
					      SPACE(04),;
					      SPACE(08),;
					      SPACE(04),;
					      SPACE(10),;
					      SPACE(04)},;
					      aNroCol)


			lPrintPrn(01,nColCab,cCodIni,aCabeza,cCabCol,;
					nColCab,cCodFin,cRegPrn,cNomSis,;
					cNomEmp,0,nLenPrn)
			DOS->(DBSKIP())
		     ENDDO
		  ENDIF
*---------------FIN IMPRESION DE LAS MATERIAS A HABILITAR

*---------------AVANCE DEL SIGUIENTE REGISTRO
		  nAvance := INT(( UNO->(RECNO()) / UNO->(RECCOUNT()) )*100)

		  IF STR(nAvance,3) $ '25 50 75100'
		     SET DEVICE TO SCREEN
		     Termometro(nAvance)
		     SET DEVICE TO PRINT
		  ENDIF

		  UNO->(DBSKIP())
*---------------FIN AVANCE DEL SIGUIENTE REGISTRO

*---------------ANALISIS DEL CAMBIO DE GRUPO
		  lMisGru := .T.
		  IF UNO->cCodigoGru # cCodGru
		     lMisGru := .F.
		     cCodGru := UNO->cCodigoGru
		     nNroHab := 1
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO DE GRUPO

	     ENDDO
	     SET FILTER TO
***********IMPRESION DEL INFORME

***********IMPRESION DE DERECHOS
	     DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     @ PROW()-PROW(),00 SAY ' '
	    *Saca la ultima linea
	     SET DEVICE TO SCREEN
***********FIN IMPRESION DE DERECHOS

	  nNroCop++

       ENDDO
       CLOSE ALL
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.UNO')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.DOS')
       RETURN NIL
*>>>>IMPRESION DE N COPIAS


/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION HABILITANTES POR MATERIAS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/95 MIE A
       Colombia, Bucaramanga        INICIO: 10:40 AM   OCT 18/95 MIE

OBJETIVOS:

1- Imprime la relaci¢n de los habilitantes por materias.

2- Debe estar en uso los archivos de temporales de habilitaci¢n

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnNHabMat(lShared,nFilInf,nColInf,cNomEmp,cNomSis,;
		    cAnoUsr,cMaeAct,cPatSis,cNomUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos compartidos
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del sistema
       cMaeAct                              // Maestro habilitado
       cPatSis                              // Path del sistema
       cNomUsr                              // Nombre del usuario
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // Path del sistemas
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nLinReg := 0                   // L¡neas del registro
       LOCAL cRegPrn := ''                  // Registro de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nNroReg := 0                   // N£mero de registros

       LOCAL lTamAnc := .T.                 // .T. Tama¤o Ancho
       LOCAL aCabeza := {}                  // Definici¢n del encabezado
       LOCAL cCodIni := ''                  // C¢digos impresora iniciales
       LOCAL cCabCol := ''                  // Encabezados de columnas
       LOCAL cCodFin := ''                  // C¢digos impresora finales
       LOCAL lCentra := .T.                 // Centrar Encabezados Columna
       LOCAL nColCab := 0                   // Columna encabezado columna

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cCodMat := ''                  // C¢digo de la materia
       LOCAL lMisMat := .T.                 // .T. Mismo Materia
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACIO PARA EL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE COPIA
       nCopias := 1
       @ nFilInf+1,nColInf SAY 'NRO COPIAS:' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>CREACION DE ARCHIVO TEMPORAL DE HABILITANTES
       GraHabTem(cNomSis,cNomUsr,cPatSis+'\'+cMaeAct,;
		 cAnoUsr,1,GRU->(RECCOUNT()),TCO->nTotPerTbl)
*>>>>FIN CREACION DE ARCHIVO TEMPORAL DE HABILITANTES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.UNO','UNO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.DOS','DOS',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS TEMPORALES')
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE UNO->(RECCOUNT()) == 0
	    cError('NO HAY HABILITANTES')

       CASE DOS->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS A HABILITAR. POR FAVOR REVISAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INDEXACION DEL ARCHIVO
       SELECT DOS
       fNtxTem := FileTem+SUBS(cNomUsr,1,3)+cExtTem
       INDEX ON DOS->cCodigoMat+DOS->cCodigoGru TO &fNtxTem
       DBSETINDEX(fNtxTem)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := DOS->(RECCOUNT())



       aCabeza := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   '',;
		   'RELACION DE '+IF ('0000' $ TCO->cNotNumTbl,;
				      'RECUPERACIONES','HABILITANTES')+;
		   ' POR MATERIAS',;
		   '',;
		   nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := DRAFT_ON+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,52,40}
       aTitulo := {'GRUPO ','CODIGO','NOMBRE','OBSERVACIONES '}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

***********IMPRESION DEL TERMOMETRO
	     SET DEVICE TO SCREEN
	     Termometro(0,'IMPRIMIENDO LOS HABILITANTES COPIA No.'+;
			  STR(nNroCop,2)+'\'+STR(nCopias,2))
	     Termometro(10)
	     SET DEVICE TO PRINT
***********FIN IMPRESION DEL TERMOMETRO

***********IMPRESION DEL ENCABEZADO
	     CabezaPrn(cCodIni,aCabeza,cCabCol,nColCab,cCodFin)
***********FIN IMPRESION DEL ENCABEZADO

***********IMPRESION DEL INFORME
	     SELECT UNO
	     GO TOP
	     cCodMat := DOS->cCodigoMat
	     lMisMat := .F.

	     DO WHILE .NOT. DOS->(EOF())

*---------------ANALISIS DEL CAMBIO DE PAGINA
		  IF lPagina()
		     lMisMat := .F.
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO DE PAGINA

*---------------IMPRESION DE LAS MATERIAS A HABILITAR
		  IF !lMisMat
		     cRegPrn := cRegPrint({SUBS(DOS->cNombreMat+;
						SPACE(107),1,107)},;
					   aNroCol)

		     lPrintPrn(01,nColCab,cCodIni,aCabeza,cCabCol,;
				     nColCab,cCodFin,cRegPrn,cNomSis,;
				     cNomEmp,nLinReg,nLenPrn)
		  ENDIF
*---------------FIN IMPRESION DE LAS MATERIAS A HABILITAR

*---------------IMPRESION DE LOS HABILITANTES
		  cRegPrn := cRegPrint({DOS->cCodigoGru,;
					SUBS(DOS->cCodigoEst,3,4),;
					SPACE(01)+SUBS(DOS->cNombreEst+;
						       SPACE(51),1,51),;
					SPACE(40)},;
					aNroCol)

		  lPrintPrn(01,nColCab,cCodIni,aCabeza,cCabCol,;
				  nColCab,cCodFin,cRegPrn,cNomSis,;
				  cNomEmp,nLinReg,nLenPrn)
*---------------FIN IMPRESION DE LOS HABILITANTES

*---------------AVANCE DEL SIGUIENTE REGISTRO
		  nAvance := INT(( DOS->(RECNO()) / DOS->(RECCOUNT()) )*100)

		  IF STR(nAvance,3) $ '25 50 75100'
		     SET DEVICE TO SCREEN
		     Termometro(nAvance)
		     SET DEVICE TO PRINT
		  ENDIF

		  DOS->(DBSKIP())
*---------------FIN AVANCE DEL SIGUIENTE REGISTRO

*---------------ANALISIS DEL CAMBIO DE GRUPO
		  lMisMat := .T.
		  IF DOS->cCodigoMat # cCodMat
		     lMisMat := .F.
		     cCodMat := DOS->cCodigoMat
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO DE GRUPO

	     ENDDO
***********IMPRESION DEL INFORME

***********IMPRESION DE DERECHOS
	     DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	     @ PROW()-PROW(),00 SAY ' '
	    *Saca la ultima linea
	     SET DEVICE TO SCREEN
***********FIN IMPRESION DE DERECHOS

	  nNroCop++

       ENDDO
       CLOSE ALL
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.UNO')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.DOS')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+cExtTem)
       RETURN NIL
*>>>>IMPRESION DE N COPIAS