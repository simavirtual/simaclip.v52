/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: JUICIOS DIGITADOS

**************************************************************************
* TITULO..: JUICIOS DIGITADOS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/1995 VIE A
       Colombia, Bucaramanga        INICIO: 05:25 PM   MAY 02/1995 VIE


OBJETIVOS:

1- Permite imprimir por grupos los juicios digitados o leidos para un
   bimestre especifico.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_203(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
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

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroBis := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroBis == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

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
	  !lUseDbf(.T.,cPatSis+'\'+FileMaT,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
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
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    JuicioGrab(cNomEmp,cNomSis,cAnoUsr,;
		      nNroBis,cJorTxt,cMaeAct)
**********FIN IMPRESION DEL INFORME

	  SELECT GRU
	  SKIP

       ENDDO
       CLOSE ALL
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DE LAS NOTAS GRABADAS                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 02/95 VIE A
       Colombia, Bucaramanga        INICIO: 09:00 PM   JUN 02/95 VIE

OBJETIVOS:

1- Imprime los juicios digitados para el bimestre especificado

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION JuicioGrab(cNomEmp,cNomSis,cAnoUsr,nNroBis,cJorTxt,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroBis			            // N£mero del bimestre
       cMaeAct			            // Maestro activado
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "\EPSONFX.PRG"

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aColPrn := {}                  // Columnas de impresion
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL cTotPag := 0                   // Total p ginas a imprimir
       LOCAL lPagina := .T.                 // .T. Cambio de p gina

       LOCAL       i := 0                   // Contador
       LOCAL aStrNot := {}                  // Estructura del archivo notas
       LOCAL aCampos := {}                  // Nombres de los campos
       LOCAL cJuicio := ''                  // Juicios

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ENCABEZADOS DE COLUMNA
       aStrNot := DBSTRUCT()
       aNroCol := {02,04,20}
       aColPrn := aNroCol
       aTitulo := {'No',;
		   'COD.',;
		   'APELLIDOS Y NOMBRES '}
       FOR i:=1 TO LEN(aStrNot)

***********LOCALIZACION DE LA MATERIA
	     IF SUBS(aStrNot[i][1],2,2) == 'J'+STR(nNroBis,1)

		cCodigoTma := SUBS(aStrNot[i][1],4,4)
		IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				      'DE LA MATERIA')
		   RETURN NIL
		ENDIF
		AADD(aTitulo,SUBS(MAT->cTituloMat,1,03)+'1')
		AADD(aNroCol,04)
		AADD(aTitulo,' 2  ')
		AADD(aNroCol,04)
		AADD(aTitulo,' 3  ')
		AADD(aNroCol,04)
		AADD(aTitulo,' 4  ')
		AADD(aNroCol,04)

		AADD(aCampos,'NOT->'+aStrNot[i][1])
		AADD(aColPrn,04)
		AADD(aColPrn,04)
		AADD(aColPrn,04)
		AADD(aColPrn,04)
	      ENDIF
***********FIN LOCALIZACION DE LA MATERIA

       ENDFOR
       AADD(aTitulo,'COD.')
       AADD(aNroCol,04)
       AADD(aTitulo,"No")
       AADD(aNroCol,02)
       AADD(aColPrn,04)
       AADD(aColPrn,02)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO TOP
       DO WHILE .NOT. EOF()

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis+;
			    ' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
			    'BIMESTRE No.'+STR(nNroBis,2),;
			    'RELACION DE JUICIOS',;
			    'GRUPO: '+GRU->cCodigoGru,;
			    nNroPag++,;
			    cTotPagina(NOT->(RECCOUNT())))
*--------------FIN ENCABEZADO DEL INFORME

/*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n17Stan
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON

		 IF RECCOUNT() = 50
		    @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2;
		      SAY REPL('-',LEN(cTxtPrn))
		 ELSE
		    @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2;
		      SAY REPL('-',LEN(cTxtPrn))
		 ENDIF
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA */

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n20Wide
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 @ PROW(),00 SAY DRAFT_ON+CONDEN_ON+ELITE

		 IF RECCOUNT() = 50
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		 ELSE
		    @ PROW()+2,00 SAY REPL('-',LEN(cTxtPrn))
		 ENDIF
		 @ PROW()+1,00 SAY cTxtPrn
		 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,'ALU')
	       cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			     RTRIM(ALU->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    Printer_on()
	    aRegPrn := {STR(NOT->(RECNO()),2),;
			SUBS(NOT->cCodigoEst,3,4),;
			SPACE(01)+SUBS(cNombreTes,1,19)}
	    FOR i:=1 TO LEN(aCampos)
*		cJuicio := SUBS(&(aCampos[i]),nNroBis*16-15,16)
		cJuicio := &(aCampos[i])
		AADD(aRegPrn,SUBS(cJuicio,01,4))
		AADD(aRegPrn,SUBS(cJuicio,06,4))
		AADD(aRegPrn,SUBS(cJuicio,11,4))
		AADD(aRegPrn,SUBS(cJuicio,16,4))
	    ENDFOR
	    AADD(aRegPrn,SUBS(NOT->cCodigoEst,3,4))
	    AADD(aRegPrn,STR(NOT->(RECNO()),2))

	    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
*	    @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
	    @ PROW()+1,00 SAY cTxtPrn
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

	  SELECT NOT
	  SKIP

       ENDDO
       CLOSE NOT
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
