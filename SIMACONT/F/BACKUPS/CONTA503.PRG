/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: GRABACION DE OBSERVACIONES

**************************************************************************
* TITULO..: GRABACION Y CORRECION DE OBSERVACIONES PARA EL LIBRO         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 04/2000 MAR A
       Colombia, Bucaramanga        INICIO: 12:15 PM   ABR 04/2000 MAR

OBJETIVOS:

1- Permite grabar y corregir las observaciones del libro.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_503(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea

       LOCAL       i := 0                   // Contador
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cObsLibTes := ''               // Observaci¢n para el libro
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
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELEC &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE LA OBSEVACIONES FINALES '+;
				   'PARA EL LIBRO FINAL',22,'°')
       cMsgTxt := cRegPrint({'CODIGO',;
			     'NOMBRE'},;
			     {06,46},@aNroCol)
       @ nNroFil++,01 SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>LECTURA DE LAS NOTAS DE LAS HABILITACIONES
       DO WHILE .T.

**********CAPTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := SPACE(06)
	    @ nNroFil,aNroCol[1] GET cCodigoTes PICT '999999';
				 VALID lCorrecion(@cCodigoTes)
	    READ
	    IF EMPTY(cCodigoTes)
	       IF lPregunta('DESEA ABANDONAR LA LECTURA? No Si')
		  EXIT
	       ELSE
		  LOOP
	       ENDIF
	    ENDIF
**********FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodigo(cCodigoTes,cMaeAct,'DEL ESTUDIANTE')
	       LOOP
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
	    @ nNroFil,aNroCol[2] SAY ALLTRIM(cNombreTes)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********LECTURA DE LA OBSERVACION PARA EL LIBRO
	    ++nNroFil
	    DO WHILE .T.
	       cObsLibTes := &cMaeAct->cObsLibEst
	       @ nNroFil,aNroCol[2] GET cObsLibTes  PICT "@!S70"
	       READ
	       IF lPregunta('DESEA GRABAR LA OBSERVACION? Si No')
		  EXIT
	       ELSE
		  LOOP
	       ENDIF
	    ENDDO
**********FIN LECTURA DE LA OBSERVACION PARA EL LIBRO

***********CONTROL DE LA FILA DE VISUALIZACION
	     nNroFil++
	     IF nNroFil > 20

		nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE LA OBSEVACIONES FINALES '+;
					    'PARA EL LIBRO FINAL',22,'°')

		@ nNroFil++,01 SAY cMsgTxt

		SET COLOR TO I
		@ nNroFil,aNroCol[1] SAY cCodigoTes
		SET COLOR TO
		@ nNroFil,aNroCol[2] SAY ALLTRIM(cNombreTes)
		SET COLOR TO I
		@ ++nNroFil,aNroCol[2] SAY cObsLibTes PICT '@S70'
		SET COLOR TO
		nNroFil++

	     ENDIF
***********FIN CONTROL DE LA FILA DE VISUALIZACION

**********GRABACION DE LA HABILITACIONES
	    SELECT &cMaeAct
	    IF lRegLock(lShared,.F.)
	       REPL &cMaeAct->cObsLibEst WITH cObsLibTes
	    ELSE
	       cError('NO SE PUEDE GRABAR LA HABILITACION')
	    ENDIF
	    DBCOMMIT()
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DE LA HABILITACIONES

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN LECTURA DE LAS NOTAS DE LAS HABILITACIONES