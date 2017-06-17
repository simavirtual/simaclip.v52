/* SIMA - MATRICULA ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: UTILIDADES             MODULO No. 704

**************************************************************************
* TITULO..: CREACION DE LA TABLA DE PAGOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/96 MAR A
       Colombia, Bucaramanga        INICIO: 01:30 PM   AGO 13/96 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite crear la tabla de tarifas a cobrar a los diferentes niveles
   de acuerdo a los conceptos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_794(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lGrabar := .F.                 // Grabar el registro

       LOCAL cNivIni := ''                  // Nivel Inicial
       LOCAL cNivFin := ''                  // Nivel Final
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final

       LOCAL cCodigoTco := ''               // C¢digo del concepto
       LOCAL nValorTta  := ''               // Valor del Concepto

       LOCAL GetList := {}                  // Variable del sistema
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
       SET EXCLUSIVE OFF

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL


*>>>>SELECION DE LAS AREAS DE TRABAJO
       lShared := .F.
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		      FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		      FileTar,'TAR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		      FileCon,'CON',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS DE TABLA DE PAGOS')
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE NIV->(RECCOUNT()) == 0
	    cError('NO ESTAN DEFINIDOS LOS NIVELES DE LOS CURSOS')
	    RETURN NIL

       CASE CON->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS CONCEPTOS A COBRAR')
	    RETURN NIL

       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DETALLES DE LA '+;
				 'DE LAS TARIFAS',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
		  cNivIni := cSpaces('TAR','cCodigoGru')
		  cNivFin := cSpaces('TAR','cCodigoGru')
	       cCodigoTco := cSpaces('TAR','cCodigoCon')
	       nValorTta  := 0
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL CONCEPTO:';
				GET cCodigoTco PICT '@!';
				VALID lValConcep(ROW(),COL()-2,@cCodigoTco)

	    @ nNroFil+1,nNroCol SAY 'VALOR DEL CONCEPTO :';
				GET nValorTta  PICT '9999999.99'

	    @ nNroFil+3,nNroCol SAY 'NIVEL INICIAL      :';
				GET cNivIni PICT '99';
			     VALID lValNivel(ROW(),COL()-2,@cNivIni,@nRegIni)

	    @ nNroFil+4,nNroCol SAY 'NIVEL FINAL        :';
				GET cNivFin PICT '99';
			     VALID lValNivel(ROW(),COL()-2,@cNivFin,@nRegFin)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cCodigoTco == cSpaces('TAR','cCodigoCon') .OR.;
		    cNivIni == cSpaces('TAR','cCodigoGru') .OR.;
		    cNivFin == cSpaces('TAR','cCodigoGru') .OR.;
		  nValorTta == 0

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE ASIGNAN TARIFAS')

	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR LAS TARIFAS PARA LOS GRUPOS '+;
			    'ESCOGIDOS? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DE LAS TARIFAS
       SELECT NIV
       GO nRegIni
       DO WHILE RECNO() <= nRegFin .AND. lGrabar

**********ANALISIS PARA LA GRABACION
	    SELECT TAR
	    GO TOP
	    IF lLocCodTar(NIV->cCodigoNiv+'00'+cCodigoTco,.F.)
	       lGrabar := .T.
	    ELSE
	       lGrabar := TAR->(lRegLock(lShared,.T.))
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION

**********GRABACION DE LA TARIFA PARA EL GRUPO
	    IF lGrabar
	       REPL TAR->cCodigoGru WITH NIV->cCodigoNiv+'00'
	       REPL TAR->cCodigoCon WITH cCodigoTco
	       REPL TAR->nValorTar  WITH nValorTta
	    ENDIF
**********FIN GRABACION DE LA TARIFA PARA EL GRUPO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    SELECT NIV
	    SKIP

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
*>>>>FIN GRABACION DE LAS TARIFAS

*>>>>ORDENADACION DEL ARCHIVO TARIFAS
       SET EXCLUSIVE ON
       SELECT TAR
       SORT ON TAR->cCodigoGru TO TEM
       ZAP
       APPEND FROM TEM
       ERASE TEM.DBF

       CLOSE ALL
       RETURN NIL
*>>>>GRABACION DE LAS TARIFAS