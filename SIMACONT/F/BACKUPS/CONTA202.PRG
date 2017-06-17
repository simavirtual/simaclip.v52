/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: LECTURA DE NOTAS       MODULO No. 201

**************************************************************************
* TITULO..: NOTAS DIGITADAS                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 22/1995 LUN A
       Colombia, Bucaramanga        INICIO: 09:15 PM   MAY 25/1995 JUE


OBJETIVOS:

1- Permite imprimir por grupos las notas digitadas o leidas para un
   bimestre especifico.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_202(aParam1,aParam2,aParam3)

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
	    NotasGrab(cNomEmp,cNomSis,cAnoUsr,;
		      nNroBis,cJorTxt,cMaeAct)
**********FIN IMPRESION DEL INFORME

	  SELECT GRU
	  SKIP

       ENDDO
       CloseAll()
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

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 25/95 JUE A
       Colombia, Bucaramanga        INICIO: 09:00 PM   MAY 25/95 JUE

OBJETIVOS:

1- Imprime las notas digitadas para el bimestre especificado

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NotasGrab(cNomEmp,cNomSis,cAnoUsr,nNroBis,cJorTxt,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroBis			            // N£mero del bimestre
       cMaeAct			            // Maestro activado
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

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
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL aRegPrn := {}                  // Registro de impresion
       LOCAL nLenCol := ''                  // Longitud de columna
       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL lPagina := .T.                 // .T. Cambio de p gina

       LOCAL       i := 0                   // Contador
       LOCAL aStrNot := {}                  // Estructura del archivo notas
       LOCAL aCampos := {}                  // Nombres de los campos
       LOCAL cNotDef := ''                  // Nota definitiva

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := GRU->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'RELACION DE JUICIOS',;
		   'PERIODO No.'+STR(nNroBis,2)+;
		   ' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'GRUPO: '+GRU->cCodigoGru,;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aStrNot := DBSTRUCT()
       aNroCol := {02,06,30}
       aTitulo := {'No',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES '}

       FOR i:=1 TO LEN(aStrNot)

***********LOCALIZACION DE LA MATERIA
	     IF SUBS(aStrNot[i][1],2,2) == 'NT' .AND.;
		SUBS(aStrNot[i][1],6,2)  # '00' .AND.;
		SUBS(aStrNot[i][1],8,3)  # 'REC'

		cCodigoTma := SUBS(aStrNot[i][1],4,4)
		IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				      'DE LA MATERIA')
		   RETURN NIL
		ENDIF

		AADD(aTitulo,SUBS(MAT->cTituloMat,1,4))
		AADD(aNroCol,04)
		AADD(aCampos,'NOT->'+aStrNot[i][1])
	      ENDIF
***********FIN LOCALIZACION DE LA MATERIA

***********LOCALIZACION AREAS NO PROMEDIABLES
	     IF SUBS(aStrNot[i][1],2,4) == 'AREN'

		cCodigoTma := SUBS(aStrNot[i][1],6,2)+'00'
		IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				      'DE LA MATERIA')
		   RETURN NIL
		ENDIF
		AADD(aTitulo,SUBS(MAT->cTituloMat,1,4))
		AADD(aNroCol,04)
		AADD(aCampos,'NOT->'+aStrNot[i][1])
	      ENDIF
***********FIN LOCALIZACION AREAS NO PROMEDIABLES

       ENDFOR
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := IF (n17Stan > LEN(cCabCol),n17Stan,LEN(cCabCol))
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	  RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO TOP
       DO WHILE .NOT. EOF()

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,'ALU')
	       cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			     RTRIM(ALU->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := ' '+SUBS(cNombreTes+SPACE(30),1,29)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := ALU->lRetiroEst
	    IF lRetiroTes
	       IF nNroBis <= ALU->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aRegPrn := {STR(NOT->(RECNO()),2),;
			NOT->cCodigoEst,;
			cNombreTes}
	    DO CASE
	    CASE lRetiroTes
		 cTxtPrn := ' RETIRADO'
		 nLenCol := LEN(aCampos)*4+LEN(aCampos)-1

		 AADD(aRegPrn,cTxtPrn+SPACE(nLenCol-LEN(cTxtPrn)))

		 aNroCol[4] := nLenCol
		 aNroCol[6] := 02
		*Columna para el nro de lista

	    CASE NOT->lRetGruNot
		 cTxtPrn := ' PERTENECE A OTRO GRUPO'
		 nLenCol := LEN(aCampos)*4+LEN(aCampos)-1

		 AADD(aRegPrn,cTxtPrn+SPACE(nLenCol-LEN(cTxtPrn)))

		 aNroCol[4] := nLenCol
		 aNroCol[6] := 02
		*Columna para el nro de lista

	    CASE !lRetiroTes .AND. !NOT->lRetGruNot
		 FOR i:=1 TO LEN(aCampos)
		     cNotDef := SUBS(&(aCampos[i]),nNroBis*4-3,4)
		     AADD(aRegPrn,cNotDef)
		 ENDFOR
	    ENDCASE

	    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    aNroCol[4] := 04
	    aNroCol[6] := 04
	  *ÀActualiza la colunma para la nota
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

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
