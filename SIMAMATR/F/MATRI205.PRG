/* SIMA - MATRICULA ACADEMICA

MODULO      : EVALUACION
SUBMODULO...: CARTELERA              MODULO No. 205

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI205.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE LOS CANDIDATOS QUE APROBARON       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   OCT030/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite generar el listado de los Estudiantes que aprobaron la Evaluaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_205(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL dFecha  := ''                  // Fecha de citaci¢n

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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

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

*>>>>ANALISIS DE LA ACTIVACION DE LOS EXAMENES
       IF !ANO->lHayExaAno
	  cError('NO ESTA HABILITADA LA OPCION PARA EXAMENES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE LA ACTIVACION DE LOS EXAMENES

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>LECTURA DEL NUMERO DE COPIAS
       dFecha := DATE()
       @ nFilInf+1,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
*>>>>FIN LECTURA DEL NUMERO DE COPIAS

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO'+'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			 STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

	  PrnSiExamx1(cNomEmp,cNomSis,cAnoUsr,cJorTxt)
	 *Impresion de la lista por niveles

	  nNroCop++

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS CANDITOS PARA ENTREVISTAS     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 10:55 PM   ENE 03/96 MIE

OBJETIVOS:

1- Imprime los c¢digos de los de candidatos a entrevistas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnSiExamx1(cNomEmp,cNomSis,cAnoUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL nNroCol := 0                  // Columna de impresion
       LOCAL nNroPag := 1                  // N£mero de p gina
       LOCAL nTotReg := 0                  // Total de registros
       LOCAL lPagina := .T.                // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCUTO DEL TOTAL DE REGISTROS A IMPRIMIR
       COUNT FOR ADM->lExamenAdm = .T. .AND. ADM->lSiCupoEst == .F. TO nTotReg
       nTotReg := nTotReg/15
*>>>>FIN CALCUTO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>VALIDACION DE LA ASIGNACION DE CITAS
       IF nTotReg == 0
	  cError('NO APARECE NINGUN ESTUDIANTE APROBANDO LA EVALUACION')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA ASIGNACION DE CITAS

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(MTR->lPrnArcMtr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP
       DO WHILE .NOT. ADM->(EOF()) .AND. nTotReg # 0

**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       ADM->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'RELACION DE ESTUDIANTES QUE APROBARON '+;
			    'LA EVALUACION. JORNADA: '+cJorTxt,;
			    '',;
			    '',;
			    nNroPag++,;
			    cTotPagina(nTotReg))
*--------------FIN ENCABEZADO DEL INFORME

*--------------IMPRESION DE LOS ENCABEZADOS DE COLUMNA
		 @ PROW(),00 SAY DRAFT_ON+PICA
		 @ PROW()+2,00 SAY 'LOS SIGUIENTES ASPIRANTES APROBRARON '+;
				   'LA EVALUACION'

		 @ PROW()+2,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF ADM->lExamenAdm .AND. !(ADM ->lSiCupoEst)
	       @ PROW(),nNroCol SAY ADM->cNumeroAdm
	       nNroCol += 5
	       IF nNroCol > 75
		  nNroCol := 0
		  @ PROW()+1,nNroCol SAY ''
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  ADM->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  DerechosPrn(cNomSis,cNomEmp,n17Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS