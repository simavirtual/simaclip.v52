/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: HABILITACIONES         MODULO No. 515

**************************************************************************
* TITULO..: LIBRO DE ACTAS DE HABILITACION                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/95 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   OCT 30/95 LUN


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Imprime el libro de acta de habilitaciones

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_515(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nNroRec := 0                   // N£mero de recibos
       LOCAL nNroPag := 1                   // N£mero de p gina

       LOCAL aDetHab := {}                  // Detalles habilitantes

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
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
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

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

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

*>>>>CREACION DE ARCHIVO TEMPORAL DE HABILITANTES
       GraHabTem(cNomSis,cNomUsr,cPatSis,cAnoSis,nRegIni,nRegFin)
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_OF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL TERMOMETRO
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO LAS ACTAS DE HABILITACION')
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL INFORME
       SELECT DOS
       GO TOP
       aDetHab := {}
       DO WHILE .NOT. UNO->(EOF())

**********LECTURA DE LOS DETALLES DE LA HABILITACION
	    AADD(aDetHab,{UNO->cAreUnoUno,;
			  cFecha(UNO->dFecUnoUno)+' ',;
			  UNO->cActUnoUno,;
			  UNO->cNotUnoUno})
	    AADD(aDetHab,{UNO->cAreDosUno,;
			  cFecha(UNO->dFecDosUno)+' ',;
			  UNO->cActDosUno,;
			  UNO->cNotDosUno})
**********FIN LECTURA DE LOS DETALLES DE LA HABILITACION


**********IMPRESION DEL ACTA DE HABILITACION
	    ActaHab(cNomEmp,cNomSis,cMaeAct,SUBS(UNO->cCodigoEst,3,4),;
		    UNO->cNombreEst,UNO->cDocNitEst,UNO->cLugNitEst,;
		    UNO->cCodigoGru,cAnoUsr,cJorTxt,aDetHab,nNroPag++)

	    aDetHab := {}
**********FIN IMPRESION DEL ACTA DE HABILITACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(( UNO->(RECNO()) / UNO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    UNO->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CLOSE ALL
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.UNO')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.DOS')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+cExtTem)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO DE LA FUNCION..: ACTA DE HABILUTACION DE UN ESTUDIANTE          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/95 LUN A
       Colombia, Bucaramanga        INICIO: 01:43 PM   OCT 30/95 LUN

OBJETIVOS:

1)- Imprime el acta de habilitaci¢n de un estudiante.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActaHab(cNomSis,cNomEmp,cMaeAct,cCodEst,cNomEst,cNitEst,;
		 cLugNit,cCodGru,cAnoUsr,cJorTxt,aDetHab,nNroPag)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del sistema
       cNomEmp                              // Nombre de la empresa
       cMaeAct                              // Maestro Actual
       cCodEst                              // C¢digo del estudiante
       cNomEst                              // Nombre del estudiante
       cNitEst                              // Documento de identidad
       cLugNit                              // Lugar del documento
       cCodGru                              // C¢digo del grupo
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       aDetHab                              // Detalles de la habiltaci¢n
       nNroPag                              // N£mero de p gina o folio */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL ACTA DE HABILITACION
       nNroCol := 0
       @ PROW(),00 SAY DOBANC_ON
       cTxtPrn := 'LIBRO DE HABILITACIONES'
       @ PROW()+9,((n10Stan/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF
     *ÀImpresi¢n del t¡tulo

       cTxtPrn := cMaeAct+' JORNADA '+cJorTxt+' DE '+cAnoUsr
       @ PROW()+2,((n10Stan)-LEN(cTxtPrn))/2 SAY cTxtPrn
     *ÀImpresi¢n jornada

       @ PROW()+3,nNroCol SAY 'ALUMNO: '+SUBS(cNomEst+SPACE(50),1,50)+;
			      'CODIGO: '+cCodEst

       @ PROW()+1,nNroCol SAY 'C.C. o T.I No. '+cNitEst+' DE '+cLugNit

       @ PROW()+3,nNroCol SAY 'Del curso: '+cCodGru+' present¢ examen(es) de:'

       aNroCol := {30,10,04,04,14,16}
       aTitulo := {'AREAS ','FECHA ','ACTA','NOTA','LETRAS','FIRMA EXAMINADOR'}
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       @ PROW()+2,nNroCol SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,nNroCol SAY cTxtPrn
       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

       FOR i:=1 TO LEN(aDetHab)
	   aTitulo := {aDetHab[i,1],aDetHab[i,2],aDetHab[i,3],;
		       aDetHab[i,4],SPACE(14),SPACE(16)}
	   @ PROW()+1,nNroCol SAY cRegPrint(aTitulo,aNroCol)
       ENDFOR
       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

       @ PROW()+2,nNroCol SAY 'OBSERVACIONES: '
       FOR i := PROW() TO 50
	   @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
       ENDFOR

       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL ACTA DE HABILITACION

