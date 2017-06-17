/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: MODIFICACION

**************************************************************************
* TITULO..: MODIFICACION DE NOTAS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 05/1995 MIE A
       Colombia, Bucaramanga        INICIO: 04:20 PM   MAY 05/1995 MIE

OBJETIVOS:

1- Permite modificar las notas de un estudiante

2- Graba la modificaci¢n en un archivo de modificaci¢n con el nombre
   del usuario que modifico la nota.

3- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_204(aParam1,aParam2,aParam3)

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
       LOCAL cSavLin := ''                  // Salvar l¡nea

       LOCA        i := 0                   // Contador
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aStrNot := {}                  // Estructura de las notas

       LOCA  cCabeza := ''                  // Texto de Cabecera
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL aNomMat := {}                  // Nombre de las materias
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL   nNota := 0                   // Nota de materia o  rea
       LOCAL cCamMat := ''                  // Campo de Materia
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
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
       IF !lUseDbf(.T.,cPatSis+'\'+FileEmp,'EMP',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileMaT,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE EMP->(RECCOUNT()) == 0
	    cError('NO EXISTE DATOS GRABADOS DE LA EMPRESA')

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

*>>>>LECTURA DEL GRUPO
       cCodigoTgr := cSpaField('GRU','cCodigoGru')
       @ nFilInf+1,nColInf SAY 'GRUPO:';
			   GET cCodigoTgr PICT '@9';
			   VALID lValGrupo(ROW(),COL()-4,@cCodigoTgr)
       READ
       IF EMPTY(cCodigoTgr)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL GRUPO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+'PLAN'+SUBS(cCodigoTgr,1,2)+;
		       cAnoSis+ExtFile,'PLA',NIL,lShared) .OR. ;
	  !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
		       'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
		       'NOT',NIL,lShared)

	  cError('ABRIENDO LOS ARCHIVOS DE NOTAS Y PLAN ACADEMICO '+;
		 'DEL GRUPO '+GRU->cCodigoGru+' EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN PLAN ACADEMICO PARA EL GRUPO: '+cCodigoTgr)

       CASE NOT->(RECCOUNT()) == 0
	    cError("SE BORRARON LAS NOTAS DEL GRUPO: "+cCodigoTgr,;
		   "Error Grave. TOME NOTA")
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DEL PLAN DE CUENTAS
       SELECT PLA
       SET FILTER TO SUBS(PLA->cCodigoMat,3,2) <> '00' .OR.;
		     (SUBS(PLA->cCodigoMat,3,2) == '00' .AND. PLA->cTipArePla == 'N')
*>>>>FIN FILTRACION DEL PLAN DE CUENTAS

*>>>>LOCALIZACION DE LAS MATERIAS
       SELECT NOT
       aStrNot := DBSTRUCT()
       aNomMat := {}
       FOR i:=1 TO LEN(aStrNot)

	 IF SUBS(aStrNot[i][1],2,2) == 'NT'

	    cCodigoTma := SUBS(aStrNot[i][1],4,4)
	    IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				  'DE LA MATERIA')
	       RETURN NIL
	    ENDIF

	    AADD(aNomMat,MAT->cNombreMat)
	 ENDIF

	 IF SUBS(aStrNot[i][1],2,4) == 'AREN'

	    cCodigoTma := SUBS(aStrNot[i][1],6,2)+'00'
	    IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				  'DEL AREA')
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
	    AADD(aNomMat,MAT->cNombreMat)
	 ENDIF

       ENDFOR
*>>>>FIN LOCALIZACION DE LAS MATERIAS

*>>>>MODIFICACION DE LAS NOTAS
       nNroReg := 0
       cSavPan := SAVESCREEN(00,00,24,79)
       DO WHILE .T.

**********SELECCION DE LA MATERIA
	    RESTSCREEN(00,00,24,79,cSavPan)
	    lSelCodPla(nFilInf+2,nColInf,@nNroReg)
	    IF nNroReg == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DE LA MATERIA

**********LOCALIZACION DE LA MATERIA ESCOGIDA
	    cNombreTma := 'LA MATERIA: '+PLA->cCodigoMat+' NO EXISTE'
	    IF lLocCodigo('cCodigoMat','MAT',PLA->cCodigoMat)
	       cNombreTma := MAT->cNombreMat
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA ESCOGIDA

**********ANALISIS DEL AREA ESCOGIDA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'

	       FOR i:=1 TO LEN(aStrNot)

		 IF SUBS(aStrNot[i,1],2,6) == 'AREN'+SUBS(PLA->cCodigoMat,1,2)
		    cCamMat := aStrNot[i,1]
		    EXIT
		 ENDIF

	       ENDFOR

	    ENDIF
**********FIN ANALISIS DEL AREA ESCOGIDA

**********ANALISIS DE LA MATERIA ESCOGIDA
	    IF SUBS(PLA->cCodigoMat,3,2) # '00'

	       FOR i:=1 TO LEN(aStrNot)

		 IF SUBS(aStrNot[i,1],2,6) == 'NT'+PLA->cCodigoMat
		    cCamMat := aStrNot[i,1]
		    EXIT
		 ENDIF

	       ENDFOR

	    ENDIF
**********FIN ANALISIS DE LA MATERIA ESCOGIDA

**********IMPRESION DE LOS ENCABEZADOS
	    nNroFil := nMarco(nFilPal+1)
	    cCabeza := cRegPrint({'CODIGO',;
				  'NOMBRE',;
				  'NOTA'},;
				 {06,60,4},@aNroCol)
	    @ nNroFil-2,01 SAY cCabeza
	    @ nNroFil-2,16 SAY cNombreTma+SPACE(05)+'GRUPO: '+cCodigoTgr
**********FIN IMPRESION DE LOS ENCABEZADOS

**********LECTURA DE LAS NOTAS
	    DO WHILE .T.

*--------------CAPTURA DEL CODIGO DEL ESTUDIANTE
		 cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
		 cCodigoTes := SPACE(06)
		 @ nNroFil,aNroCol[1] GET cCodigoTes PICT '999999';
				      VALID lCorrecion(@cCodigoTes)
		 READ
		 IF EMPTY(cCodigoTes)
		    EXIT
		 ENDIF
*--------------FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodigo(cCodigoTes,'ALU','DEL ESTUDIANTE')
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			       RTRIM(ALU->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
		 @ nNroFil,aNroCol[2] SAY cNombreTes
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS DEL PERIODO DEL RETIRO
		 lRetiroTes := &cMaeAct->lRetiroEst
		 IF lRetiroTes
		    IF nNroBis <= &cMaeAct->nPerRetEst
		       lRetiroTes := .F.
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DEL PERIODO DEL RETIRO

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF lRetiroTes
		    cError(ALLTRIM(cNombreTes)+' ESTA RETIRADO')
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    cError(ALLTRIM(cNombreTes)+' PERTENECE A OTRO GRUPO')
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------LOCALIZACION DEL CODIGO
		 IF !lLocCodigo('cCodigoEst','NOT',cCodigoTes)
		    cError(ALLTRIM(cNombreTes)+' NO EXISTE EN EL '+;
			   'GRUPO: '+cCodigoTgr)
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DEL CODIGO

*--------------LECTURA DE LA NOTA A MODIFICAR
		 nNota := SUBS(&cCamMat,nNroBis*4-3,4)
		 @ nNroFil,aNroCol[3] GET nNota PICT 'XXXX'
//				      VALID nNota >= 0 .AND. nNota <= 10.0
		 READ
*--------------FIN LECTURA DE LA NOTA A MODIFICAR

*--------------GRABACION DE LA NOTA
		 SELECT NOT
		 IF NOT->(lRegLock(lShared,.F.))
		    REPL &cCamMat WITH;
			 STUFF(&cCamMat,nNroBis*4-3,4,nNota)
		   *Grabaci¢n de la nota
		 ELSE
		    cError('NO SE PUEDE GRABAR LAS NOTAS')
		 ENDIF
		 DBUNLOCK()
*--------------FIN GRABACION DE LA NOTA

*--------------CONTROL DE LA FILA DE VISUALIZACION
		 nNroFil++
		 IF nNroFil > 20

		    nNroFil := nMarco(nFilInf+1)
		    @ nNroFil-2,01 SAY cCabeza

		    SET COLOR TO I
		    @ nNroFil,aNroCol[1] SAY cCodigoTes
		    SET COLOR TO
		    @ nNroFil,aNroCol[2] SAY cNombreTes
		    SET COLOR TO I
		    @ nNroFil,aNroCol[3] SAY nNota PICT '99.9'
		    SET COLOR TO
		    nNroFil++

		 ENDIF
*--------------FIN CONTROL DE LA FILA DE VISUALIZACION
***********CONTROL DE LA FILA DE VISUALIZACION

	    ENDDO
**********FIN LECTURA DE LAS NOTAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN MODIFICACION DE LAS NOTAS