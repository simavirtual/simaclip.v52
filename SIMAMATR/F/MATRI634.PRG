/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: LISTAS DE CLASE     MODULO No. 634

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE609.PRG                                    *
* TITULO DEL PROGRAMA..: MENU PARA LISTAS DE CLASE                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/99 MAR A
       Bucaramanga, Colombia	    INICIO: 04:29 PM   FEB 16/99 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza el men£ para la impresi¢n de las listas de clase

2- Ejecuta las diferentes funciones para las listas de clase

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_634(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       FIELD cCodigoGru                     // C¢digo del Grupo
       FIELD cNombreEst                     // Nombre del Estudiante
       FIELD cApelliEst                     // Apellido del Estudiante

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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)

       cNalias := cMaeAct
*>>>>FIN SELECCION DEL NIVEL

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<POR GRUPOS >',;
		   '2<POR NIVELES>'}
       aAyuda := {'Imprime las listas de clase provisionales por grupos',;
		  'Imprime las listas de clase provisionales por niveles'}

       SAVE SCREEN
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTORE SCREEN
       IF nNroOpc == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES MATRICULADOS')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>VALIDACION DEL ARCHIVO
       fNtxTem := SUBS(cNomUsr,1,3)+FileTem+cExtNtx
       IF FILE(FileTem)
	  cError(cNomUsr+;
		 ' ESTA IMPRIMIENDO. NO PUEDE UTILIZAR EL MISMO USUARIO')
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>INDEXACION DEL ARCHIVO
       SELECT &cNalias
       SAVE SCREEN
       Termometro(0,'ORDENANDO POR APELLIDO')
       Termometro(50)
       INDEX ON cCodigoGru+;
		cApelliEst+;
		cNombreEst TO &fNtxTem
       Termometro(100)
       RESTORE SCREEN
       IF lShared
	  DBSETINDEX(fNtxTem)
       ELSE
	  SET INDEX TO &fNtxTem
       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Matr_6341(aParam1,aParam2,aParam3)
	   *Listas de Clase por grupos

       CASE nNroOpc == 2

	    Matr_6342(aParam1,aParam2,aParam3)
	   *Listas de clase por niveles

       ENDCASE
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       CloseAll()
       IF !lFileDelete(fNtxTem)
	  cError('NO SE BORRO EL ARCHIVO INDICE TEMPORAL')
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LA LISTA DE CLASE                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/94 MAR A
						       DIC 06/94 MAR
OBJETIVOS:

1- Imprime imprime una lista de clase para el grupo determinado

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Listas_2(cCodGru,cNomEmp,cNomSis,cAnoUsr,cMaeAct,cJorTxt)

*>>>>PARAMATROS DE LA FUNCION
/*     cCodGru                              // C¢digo del grupo
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoSys                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 12                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL aNivels := {}                  // Nombre de los Niveles
       LOCAL cNombreTes := ''                  // Nombre del estudiante
       LOCAL       i := 1                   // Contador

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(MTR->lPrnArcMtr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+DRAFT_ON+PICA+CONDEN_ON
       @ PROW()+3,64 SAY 'LISTA PROVISIONAL'+SPACE(04)+;
			 cAnoUsr+SPACE(16)+cCodGru
       @ PROW()+2,40 SAY ''
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT &cMaeAct
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)

	    IF &cMaeAct->lRetiroEst
	       @ PROW()+1,03 SAY cNombreTes+SPACE(02)+'R E T I R A D O'
	    ELSE
	       @ PROW()+1,03 SAY cNombreTes
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

	  SKIP

       ENDDO
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

