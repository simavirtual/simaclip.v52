/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: CUPOS           MODULO No. 403

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI403.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE LOS ALUMNOS CON CUPOS              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 08/96 JUE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   AGO 08/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite generar el listado de los alumnos con cupo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_403(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL dFecha  := ''                  // Fecha de citaci¢n
       LOCAL GetList := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
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
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
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
       SELECT ADM
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>LECTURA DEL NUMERO DE COPIA
       dFecha := DATE()
       @ nFilInf+1,nColInf SAY 'NRO COPIAS' GET nCopias PICT '99'
       @ nFilInf+2,nColInf SAY 'FECHA'      GET dFecha ;
					    VALID !(dFecha==CTOD('00/00/00'))
       READ
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>PREGUNTA DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO'+'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			 STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

	  PrnSiCupo1(dFecha,cNomEmp,cNomSis,cAnoUsr,cJorTxt)
	 *Impresion de los alumnos con cupo

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
* TITULO DE LA FUNCION..: IMPRESION DE LOS ALUMNOS CON CUPO              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 28/94 DOM A
						       AGO 28/94 DOM
OBJETIVOS:

1- Imprime los c¢digos de los alumnos con cupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnSiCupo1(dFecha,cNomEmp,cNomSis,cAnoUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     dFecha                               // Fecha de citaci¢n
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroCol := 0                  // Columna de impresion
       LOCAL nNroPag := 1                  // N£mero de p gina
       LOCAL nTotReg := 0                  // Total de registros
       LOCAL lPagina := .T.                // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCUTO DEL TOTAL DE REGISTROS A IMPRIMIR
       SELECT ADM
       COUNT FOR ADM->lSiCupoEst == .T. TO nTotReg
       nTotReg := nTotReg/15
*>>>>FIN CALCUTO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>VALIDACION DE LA ASIGNACION DE CUPOS
       IF nTotReg == 0
	  cError('NO SE HAN ASIGNADO CUPOS A NINGUN CANDIDATO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA ASIGNACION DE CUPOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF !PRINTER_ON(MTR->lPrnArcMtr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'RELACION DE ALUMNOS CON CUPO '+cAnoUsr+'. JORNADA: '+cJorTxt,;
			    '',;
			    '',;
			    nNroPag++,;
			    cTotPagina(nTotReg))
*--------------FIN ENCABEZADO DEL INFORME

*--------------IMPRESION DE LOS ENCABEZADOS DE COLUMNA
		 @ PROW(),00 SAY DRAFT_ON+PICA
		 @ PROW()+2,00 SAY 'LOS SIGUIENTES ASPIRANTES PUEDEN '+;
				   'PASAR A RECEPCION EN '+;
				   NEGRA_ON+cFecha(dfecha)+NEGRA_OF

		 @ PROW()+1,00 SAY 'A SOLICITAR LA ORDEN DE MATRICULA.'
		 @ PROW()+2,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF ADM->lSiCupoEst
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

	  SKIP

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