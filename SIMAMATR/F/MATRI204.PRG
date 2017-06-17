/* SIMA - MATRICULA ACADEMICA

MODULO      : EXAMENES
SUBMODULO...: IMPRESION              MODULO No. 203

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI204.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE LOS EXAMENES                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 08:50 PM   ENE 03/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite generar el listado de los candidatos ordenados seg£n examen

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_204(aParam1,aParam2,aParam3)

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

       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

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
       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       CASE ANO->nNroExaAno == 0
	    cError('No se ha definido el n£mero de notas para los examenes')

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

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       IF !lLeeNivels(nFilInf+1,nColInf,@cNivIni,@cNivFin,@nCopias,cMaeAlu)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>INDEXACION DEL ARCHIVO
       SELECT ADM
       fNtxTem := "EXAME"+SUBS(cNomUsr,1,3)+cNtxTem
       INDEX ON ADM->nDefExaAdm TO &fNtxTem DESCENDING EVAL ProgresoNtx()
       IF lShared
	  DBSETINDEX(fNtxTem)
       ELSE
	  SET INDEX TO (fNtxTem)
       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>IMPRESION DEL INFORME
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL MAESTRO
	    SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
	    GO TOP
	    IF EOF()
	       cError('PARA '+cNomNiv(nNroNiv)+' NO HAY INSCRITOS')
	       nNroCop := nCopias+1
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE N COPIAS
	    DO WHILE nNroCop <= nCopias

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'º'+;
			     'HASTA NIVEL: '+cNivFin+;
			     'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			     STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO


	       PrnExamen(nNroNiv,cNomEmp,cNomSis,cAnoUsr,cJorTxt)
	      *Impresion de la lista por niveles

	       nNroCop++

	    ENDDO
**********FIN IMPRESION DE N COPIAS

	  nNroNiv++
	  nNroCop := 1

       ENDDO
       CLOSE ALL
       lFileDelete(fNtxTem)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LA RELACION DE LOS EXAMENES       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 09:15 PM   ENE 03/96 MIE

OBJETIVOS:

1- Imprime la relaci¢n de los examenes de los inscriptos

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnExamen(nNroNiv,cNomEmp,cNomSis,cAnoUsr,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroNiv                              // N£mero del nivel a imprimir
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtPrn := ''                 // Texto de impresi¢n
       LOCAL nLenPrn := 0                  // Longitud de impresi¢n
       LOCAL nNumero := 1                  // Contador de alumnos
       LOCAL nNroPag := 1                  // N£mero de p gina
       LOCAL nTotReg := 0                  // Total registros a imprimir
       LOCAL cTotPag := 0                  // Total p ginas a imprimir
       LOCAL lPagina := .T.                // .T. Cambio de p gina

       LOCAL       i := 0                  // Contador
       LOCAL cLenNom := ''                 // Longitud para los nombres
       LOCAL nLenNom := 0                  // Longitud del nombre
       LOCAL aTitulo[15]                   // Titulos de las Columnas
       LOCAL aTamCol[15]                   // Tama¤o de las Columnas
       LOCAL aNroCol[15]                   // N£meros de Columnas

       LOCAL cNombreTes := ''              // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(MTR->lPrnArcMtr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>VARIABLES PARA EL ENCABEZADO DEL INFORME
       COUNT FOR VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv TO nTotReg
      *Total de registros a imprimir
*>>>>FIN VARIABLES PARA EL ENCABEZADO DEL INFORME

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP
       DO WHILE .NOT. ADM->(EOF()) .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'RELACION DE EVALUACION '+cAnoUsr+'. JORNADA: '+cJorTxt,;
			    cNomNiv(nNroNiv),;
			    ' ',;
			    nNroPag++,;
			    cTotPagina(nTotReg))
*--------------FIN ENCABEZADO DEL INFORME

*--------------IMPRESION DE LOS ENCABEZADOS DE COLUMNA
		 cLenNom = '302616'
		 FOR i := 1 TO ANO->nNroExaAno+3

		     DO CASE
		     CASE i == 1
			  aTamCol[i] := 04
			  aTitulo[i] := 'No. '
		     CASE i == 2
			  aTamCol[i] := 06
			  aTitulo[i] := 'CODIGO'
		     CASE i == 3
			     nLenNom := VAL(IIF(ANO->nNroExaAno<=7,'36',;
					SUBS(cLenNom,(ANO->nNroExaAno-7)*2-1,2)))
			  aTamCol[i] := nLenNom
			  aTitulo[i] := 'NOMBRE'
		     OTHERWISE
			  aTamCol[i] := 04
			  aTitulo[i] := IF(i == 13,'NO','NOT')+;
					IF(i<13,STR(i-3,1),STR(i-3,2))
		     ENDCASE
		 NEXT
		 aTamCol[i]   := 04
		 aTitulo[i]   := 'DEFI'
		 aTamCol[i+1] := 08
		 aTitulo[i+1] := 'OBSERV'

		 cTxtPrn := cRegPrint(aTitulo,aTamCol)
*--------------FIN IMPRESION DE LOS ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n12Stan+2
		 @ PROW(),00 SAY DRAFT_ON+ELITE
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cNombreTes = RTRIM(ADM->cApelliEst)+' '+;
			       ADM->cNombreEst+SPACE(10)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    FOR i := 1 TO ANO->nNroExaAno+3

		DO CASE
		CASE i == 1
		     aTamCol[i] := 04
		     aTitulo[i] := STR(nNumero++,4)
		CASE i == 2
		     aTamCol[i] := 06
		     aTitulo[i] := ADM->cNumeroAdm
		CASE i == 3
			nLenNom := VAL(IIF(ANO->nNroExaAno<=7,'36',;
				   SUBS(cLenNom,(ANO->nNroExaAno-7)*2-1,2)))
		     aTamCol[i] := nLenNom
		     aTitulo[i] := SUBS(cNombreTes,1,nLenNom)
		OTHERWISE
		     aTamCol[i] := 04
		     aTitulo[i] := SUBS(ADM->cNotExaAdm,(i-3)*4-3,4)
		ENDCASE
	    NEXT
	    aTamCol[i]   := 04
	    aTitulo[i]   := STR(ADM->nDefExaAdm,4,1)

	    aTamCol[i+1] := 08
	    DO CASE
	    CASE ADM->lRetiroAdm
		 aTitulo[i+1] := 'RETIRADO'

	    CASE ADM->lExamenAdm .AND. ADM->lEntrevAdm
		 aTitulo[i+1] := 'CITA'

	    CASE !ADM->lExamenAdm
		 aTitulo[i+1] := 'NO PASO '

	    CASE ADM->lExAlumAdm
		 aTitulo[i+1] := 'EXALUMNO'

	    OTHERWISE
		 aTitulo[i+1] := SPACE(08)
	    ENDCASE

	    cTxtPrn := cRegPrint(aTitulo,aTamCol)
	   *Prepara la variable de impresion

	    @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n20Stan)
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
	  DerechosPrn(cNomSis,cNomEmp,n20Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

