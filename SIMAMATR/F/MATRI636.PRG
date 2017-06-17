/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MATRICULAS - INFORMES
SUBMODULO...: OBSERVADOR                             MODULO No. 636

**************************************************************************
* TITULO..: HOJA DEL OBSERVADOR                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 29/2001 LUN A
       Bucaramanga, Colombia	    INICIO: 03:20 PM   ENE 29/2001 LUN

OBJETIVOS:

1- Permite imprimir la hoja del Observador

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_636(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
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
       IF  !lParam0101(aParams,;
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS DE LOS '+;
				   'ESTUDIANTES',22,'°')
       nNroCol := 1
       aTamCol := {06,40,06}
       aTitulo := {'CODIGO','NOMBRE','CURSO '}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_On(MTR->lPrnArcMtr)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS HOJAS DEL OBSERVADOR
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    SET DEVICE TO SCREEN
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAct,@cMaeAct)

	    IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LA HOJA DEL OBSERVADOR
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE SCO->nHojObsCon == 0
		 HojObs00(cAnoUsr,cMaeAct)
		*Hoja del Observador por Defecto

	    ENDCASE
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DE LA HOJA DEL OBSERVADOR

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
				   'DE LOS ESTUDIANTES',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO..: HOJA DEL OBSERVADOR No. 00                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/2000 MAR A
       Colombia, Bucaramanga        INICIO: 03:40 PM   ENE 30/2000 MAR

1- Imprime la Hoja del Observador.

2- Es la Hoja del Observador por defecto del sistema.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojObs00(cAnoUsr,cMaeAct)

*>>>>DECLARACION DE VARIABLES
       LOCAL cEdaEst := ''                  // Edad del Estudiante
       LOCAL cMsgTxt := ''                  // Texto Variable
       LOCAL cNombre := ''                  // Nombre
       LOCAL cCodGru := ''                  // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA HOJA DEL OBSERVADOR
       SETPRC(0,0)

       @ PROW()+11,40 SAY &cMaeAct->cCodigoEst
       @ PROW(),100 SAY cAnoUsr
       @ PROW()+02,36 SAY RTRIM(&cMaeAct->cApelliEst)+' '+;
		       RTRIM(&cMaeAct->cNombreEst)

       cCodGru := cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))+'-'+;
		  SUBS(&cMaeAct->cCodigoGru,3,2)

       cEdaEst := STR((DATE()-&cMaeAct->dFecNacEst)/360,4,0)

       @ PROW()+2,20 SAY cCamPrn(cCodGru,14)+;
			 SPACE(04)+cEdaEst+SPACE(30)+;
			 cFecha(&cMaeAct->dFecNacEst)+SPACE(25)+;
			 &cMaeAct->cGrupRhEst

       cNombre := ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
		  ALLTRIM(&cMaeAct->cApePadEst)
       @ PROW()+2,31 SAY cCamPrn(cNombre,36)+SPACE(07)+;
			 cCamPrn(&cMaeAct->cProPadEst,16)+SPACE(25)+;
			 ALLTRIM(&cMaeAct->cTelPadEst)

       cNombre := ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
		  ALLTRIM(&cMaeAct->cApeMadEst)
       @ PROW()+2,33 SAY cCamPrn(cNombre,28)+SPACE(14)+;
			 cCamPrn(&cMaeAct->cProMadEst,16)+SPACE(25)+;
			 ALLTRIM(&cMaeAct->cTelMadEst)


       cNombre := ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
		  ALLTRIM(&cMaeAct->cApeAcuEst)
       @ PROW()+2,34 SAY cCamPrn(cNombre,36)+SPACE(14)+;
			 cCamPrn(&cMaeAct->cParAcuEst,24)+SPACE(10)+;
			 ALLTRIM(&cMaeAct->cTe1AcuEst)

       @ PROW()+2,46 SAY cCamPrn(ALLTRIM(&cMaeAct->cDireccEst)+' '+;
			 ALLTRIM(&cMaeAct->cBarrioEst),65)+SPACE(07)+;
			 ALLTRIM(&cMaeAct->cTelefnEst)

       @ PROW(),0 SAY ''
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL OBSERVADOR

