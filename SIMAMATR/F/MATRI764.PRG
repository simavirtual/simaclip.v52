/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : UTILIDADES - ACTUALIZAR
SUBMODULO...: ALUMNOS

**************************************************************************
* TITULO..: ACTUALIZAR LA INFORMACION DE LOS ESTUDIANTES                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 09/2011 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 PM   FEB 09/2011 MIE


OBJETIVOS:

1- Permite actualizar la informaci¢n de los estudiantes a los cuales se
   les factura otros servicios por separado.

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_764(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar L¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL bDigChe := ''                  // Funcion Digito de Chequeo
       LOCAL cNumero := ''                  // N£mero a calcular
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


*>>>>RECORRIDO DE LOS ESTUDIANTES
       FOR i := 1 TO LEN(cMaeAlu)/3

**********SELECION DE LAS AREAS DE TRABAJO
	    cMaeAct := SUBS(cMaeAlu,i*3-2,3)


	    IF !lUseMae(lShared,PathCua+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	       !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
			    PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    fNtxAlu+cMaeAct+cAnoSis+cExtNtx,;
			    lShared)

	       cError('ABRIENDO ARCHIVOS')
	       CloseAll()
	       RETURN NIL

	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO DE LOS ESTUDIANTES
	    DO WHILE .NOT. ALU->(EOF())

*==============LINEA DE ESTADO
		 LineaEstado(cMaeAct+'º'+;
			     'CODIGO:'+ALU->cCodigoEst,cNomSis)
*==============FIN LINEA DE ESTADO


*==============BUSQUEDA DEL ESTUDIANTE
		 IF !lSekCodMae(ALU->cCodigoEst,cMaeAlu,@cMaeAct)

		    cError(ALU->cCodigoEst+' NO EXISTE EN EL MAESTRO')

		    SELECT ALU
		    ALU->(DBSKIP())
		    LOOP

		 ENDIF
*==============FIN BUSQUEDA DEL ESTUDIANTE


*==============GRABACION DEL REGISTRO
		 IF ALU->(lRegLock(lShared,.F.))

		    REPL ALU->cApelliEst WITH &cMaeAct->cApelliEst
		    REPL ALU->cNombreEst WITH &cMaeAct->cNombreEst
		    REPL ALU->cCodigoGru WITH &cMaeAct->cCodigoGru

		    ALU->(DBCOMMIT())
		    IF lShared
		       ALU->(DBUNLOCK())
		    ENDIF


		 ENDIF
*==============FIN GRABACION DEL REGISTRO

	       ALU->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO DE LOS ESTUDIANTES


       ENDFOR
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS ESTUDIANTES