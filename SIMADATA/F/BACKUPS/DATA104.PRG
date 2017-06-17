/* SIMA - CENTRAL DE RIESGOS

MODULO      : DATACREDITO
SUBMODULO...: AUDITORIA DE LOS ESTADOS DE CUENTA

**************************************************************************
* TITULO..: AUDITORIA DE LOS ESTADOS DE CUENTA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 31/2005 MIE A
       Colombia, Bucaramanga        INICIO: 10:15 PM   AGO 31/2005 MIE

OBJETIVOS:

1- Permite validar todos los registros de la cartera.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_104(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL lPrnCab := .F.                 // .T. Imprimir el Encabezado
     *ÀVariables de informe

       LOCAL     i,j := 0                   // Contador
       LOCAL nGruIni := 0                   // Registro inicial del grupo
       LOCAL nGruFin := 0                   // Registro Final del grupo
       LOCAL aErrCta := {}                  // Errores del Estado de Cuenta
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL cCodAct := 0                   // C¢digo Actual
       LOCAL lRegIni := .T.                 // .T. Control de flujo

       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})


       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDos+'\'+cPatSis+'\'+FileDes,'DES',;
			 PathDos+'\'+cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

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
       IF !lLocCodigo('nCodigoPrn','PRN',SDA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nGruIni,@nGruFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'errctas'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'INCONSISTENCIA EN ESTADOS DE CUENTA',;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,60}
       aTitPrn := {'CODIGO','GRUPO','NOMBRE','OBSERVACION'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>VALIDACION DE LOS ESTADOS DE CUENTA
       SET DEVICE TO SCREEN
       aErrCta := aValCuenta(lShared,nModCry,cNomSis,cAnoUsr,cMaeAct,;
			     nGruIni,nGruFin,;
			     PathDos+'\'+cPatSis)
       SET DEVICE TO PRINT
*>>>>FIN VALIDACION DE LOS ESTADOS DE CUENTA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       FOR i := 1 TO LEN(aErrCta)

***********IMPRESION DEL ENCABEZADO
	     IF .NOT. lPrnCab

		SendCodes(PCL('Reset'))

		EVAL(bCabeza)
	       *Impresi¢n del Encabezado

		AADD(aCabPrn,cFecPrn)
		AADD(aCabPrn,cHorPrn)
		AADD(aCabPrn,cDiaPrn)

		nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,;
				      aCabPrn,aTitPrn)
		lPrnCab := .T.
	     ENDIF
***********FIN IMPRESION DEL ENCABEZADO

***********LINEA DE ESTADO
	     SET DEVICE TO SCREEN
	     LineaEstado('IMPRIMIENDO:'+;
			 'ºRegistro. '+STR(i,4)+'/'+;
			 STR(LEN(aErrCta),4),cNomSis)
	     SET DEVICE TO PRINT
***********FIN LINEA DE ESTADO

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    FOR j := 1 TO LEN(aErrCta[i])

*===============PREPARACION DEL REGISTRO
		  cCodAct := aErrCta[i,1]
*		  IF cCodAnt # cCodAct .OR. lRegIni
		  IF lRegIni

*--------------------REGISTRO INICIAL
		       AADD(aRegPrn,;
			    SUBS(aErrCta[i,j]+;
				 SPACE(aNroCol[j]),1,aNroCol[j]))
		       cCodAnt := cCodAct
*--------------------FIN REGISTRO INICIAL

		  ELSE

*--------------------REGISTRO REPETIDO
		       IF j == LEN(aErrCta[i])
			  AADD(aRegPrn,;
			       SUBS(aErrCta[i,j]+;
				    SPACE(aNroCol[j]),1,aNroCol[j]))
		       ELSE
			  AADD(aRegPrn,'')
		       ENDIF
*--------------------FIN REGISTRO REPETIDO

		  ENDIF
*===============FIN PREPARACION DEL REGISTRO

	    ENDFOR
*	    lRegIni := .F.
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

       ENDFOR
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF lPrnCab
	  EVAL(bDerAut)
	 *Derechos de Autor

	  VerPrn(nOpcPrn,FilePrn,nHanXml)
	  SET DEVICE TO SCREEN
       ELSE
	  SET DEVICE TO SCREEN
	  cError('ESTADOS DE CUENTA SIN PROBLEMAS')
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

