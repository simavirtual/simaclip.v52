/*************************************************************************
* TITULO ..: INSCRIPTOS POR CEDULAS                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2007 MAR A
       Colombia, Bucaramanga        INICIO: 03:30 PM   OCT 16/2007 MAR

OBJETIVOS:

1- Permite imprimir los inscritos por c‚dulas de los padres o acudiente

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Mtr_002_01(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		    cPatSis,cMaeAlu,cMaeAct,cJorTxt,oBrowse,;
		    cCodInf,cCodIso,aTitIso,aPieIso,aMarInf,;
		    aObsPrn,FilePrn,nOpcPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo
       cCodInf                              // C¢digo del Informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso			            // Pie del p gina del informe
       aMarInf			            // L¡neas de Espaciado
       aObsPrn			            // Observaciones del informe
       FilePrn                              // Archivo de impresion
       nOpcPrn                              // Opci¢n de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

*      LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
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
*      LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		    // Detalles informes para www */
     *ÀVariables de informe

       LOCAL nNumero := 1                   // Contador de alumnos
       LOCAL cNomEst := ''                  // Nombre del estudiante
       LOCAL cNomPad := ''                  // Nombre del Padre
       LOCAL cNomMad := ''                  // Nombre de la Madre
       LOCAL cNomAcu := ''                  // Nombre del Acudiente
       LOCAL lTodos  := .F.                 // .T.
       LOCAL lSiPrin := .F.                 // .T. Imprimir
       LOCAL lPrnPad := .F.                 // Imprimir al Padre
       LOCAL lPrnMad := .F.                 // Imprimir a la Madre
       LOCAL lPrnAcu := .F.                 // Imprimir al Acudiente

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cPrnNitTad := ''               // Imprimir Cedulas.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       SET DEVICE TO SCREEN
       lTodos := lPregunta('DESEA IMPRIMIR TODOS LOS INSCRITOS? No Si')
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := ADM->(RECCOUNT())

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,4)
       AADD(aTitPrn,'No.')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'NIVEL')

       AADD(aNroCol,40)
       AADD(aTitPrn,'APELLIDOS Y NOMBRES ')

       AADD(aNroCol,16)
       AADD(aTitPrn,'CEDULA')

       AADD(aNroCol,10)
       AADD(aTitPrn,'PARENTESCO')

       AADD(aNroCol,30)
       AADD(aTitPrn,'OBSERVACIONES')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPieIso(aPieIso))}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl',MTR->nCodXslMtr})
       AADD(aPrnWww,{'cCodInf',cCodInf})
       AADD(aPrnWww,{'cCodIso',ALLTRIM(ISO->cCodigoIso)})
       AADD(aPrnWww,{'cFecIso',ALLTRIM(ISO->cFecAprIso)})
       AADD(aPrnWww,{'cVerIso',ALLTRIM(ISO->cNroVerIso)})
       AADD(aPrnWww,{'cPieUno',aPieIso[1]})
       AADD(aPrnWww,{'cPieDos',aPieIso[2]})
       AADD(aPrnWww,{'cPieTre',aPieIso[2]})
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn,aPrnWww)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       ADM->(DBGOTOP())
       DO WHILE .NOT. ADM->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('REGISTRO No. '+ADM->(STR(RECNO(),4))+'/'+;
			  ADM->(STR(RECCOUNT(),4)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

/*
**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       ADM->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO
*/

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cNomEst := RTRIM(ADM->cApelliEst)+' '+;
			       ADM->cNombreEst+SPACE(10)

	    cNomPad := RTRIM(ADM->cApePadEst)+' '+;
			     ADM->cNomPadEst+SPACE(10)

	    cNomMad := RTRIM(ADM->cApeMadEst)+' '+;
			     ADM->cNomMadEst+SPACE(10)

	    cNomAcu := RTRIM(ADM->cApeAcuEst)+' '+;
			     ADM->cNomAcuEst+SPACE(10)

	    cPrnNitTad := SPACE(04)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INSCRITO
	    lSiPrin := .F.
	    IF ( ADM->cPrnNitAdm = SPACE(04) .AND.;
		(!EMPTY(ADM->cPadNitEst)     .OR.;
		 !EMPTY(ADM->cMadNitEst)     .OR.;
		 !EMPTY(ADM->cAcuNitEst)) )  .OR. lTodos

	       aRegPrn := {}
	       AADD(aRegPrn,IF(!lTodos,SPACE(04),STR(nNumero++,4)))
	       AADD(aRegPrn,ADM->cNumeroAdm)
	       AADD(aRegPrn,ADM->cCodigoGru)
	       AADD(aRegPrn,SUBS(cNomEst,1,40))
	       AADD(aRegPrn,SPACE(16))
	       AADD(aRegPrn,'ESTUDIANTE')
	       AADD(aRegPrn,'')

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INSCRITO

**********IMPRESION DEL CONTENIDO DEL PADRE
	    lPrnPad := SUBS(ADM->cPrnNitAdm,1,1) # '1' .AND.;
		       !EMPTY(ADM->cPadNitEst)

	    IF lPrnPad .OR. lTodos

	       aRegPrn := {}
	       AADD(aRegPrn,IF(!lTodos,STR(nNumero++,4),SPACE(04)))
	       AADD(aRegPrn,SPACE(06))
	       AADD(aRegPrn,SPACE(06))
	       AADD(aRegPrn,SUBS(cNomPad,1,40))
	       AADD(aRegPrn,ADM->cPadNitEst)
	       AADD(aRegPrn,'PADRE')
	       AADD(aRegPrn,IF(lTodos,IF(lPrnPad .OR. EMPTY(ADM->cPadNitEst),;
					'POR CONSULTAR'+SPACE(17),''),''))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	       cPrnNitTad := STUFF(cPrnNitTad,1,1,'1')
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL PADRE

**********IMPRESION DEL CONTENIDO DE LA MADRE
	    lPrnMad := SUBS(ADM->cPrnNitAdm,2,1) # '1'   .AND.;
		       !EMPTY(ADM->cMadNitEst)           .AND.;
		       ADM->cMadNitEst # ADM->cPadNitEst

	    IF lPrnMad .OR. lTodos

	       aRegPrn := {}
	       AADD(aRegPrn,IF(!lTodos,STR(nNumero++,4),SPACE(04)))
	       AADD(aRegPrn,SPACE(06))
	       AADD(aRegPrn,SPACE(06))
	       AADD(aRegPrn,SUBS(cNomMad,1,40))
	       AADD(aRegPrn,ADM->cMadNitEst)
	       AADD(aRegPrn,'MADRE')
	       AADD(aRegPrn,IF(lTodos,IF(lPrnMad .OR. EMPTY(ADM->cMadNitEst),;
				       'POR CONSULTAR'+SPACE(17),''),''))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	       cPrnNitTad := STUFF(cPrnNitTad,2,1,'1')
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DE LA MADRE

**********IMPRESION DEL CONTENIDO DEL ACUDIENTE
	    lPrnAcu := SUBS(ADM->cPrnNitAdm,3,1) # '1'   .AND.;
		       !EMPTY(ADM->cAcuNitEst)           .AND.;
		       ADM->cAcuNitEst # ADM->cPadNitEst .AND.;
		       ADM->cAcuNitEst # ADM->cMadNitEst

	    IF lPrnAcu .OR. lTodos

	       aRegPrn := {}
	       AADD(aRegPrn,IF(!lTodos,STR(nNumero++,4),SPACE(04)))
	       AADD(aRegPrn,SPACE(06))
	       AADD(aRegPrn,SPACE(06))
	       AADD(aRegPrn,SUBS(cNomAcu,1,40))
	       AADD(aRegPrn,ADM->cAcuNitEst)
	       AADD(aRegPrn,'ACUDIENTE')
	       AADD(aRegPrn,IF(lTodos,IF(lPrnAcu .OR. EMPTY(ADM->cAcuNitEst),;
				     'POR CONSULTAR'+SPACE(17),''),''))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       lSiPrin := .T.
	       cPrnNitTad := STUFF(cPrnNitTad,3,1,'1')
	    ENDIF

	    IF lSiPrin
	       lPrnReg(01,00,REPL('=',LEN(cTxtPrn)),bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL ACUDIENTE

**********GRABACION DEL CONTROL DE LA IMPRESION POR CEDULAS
	    IF !lTodos
	       IF ADM->(lRegLock(lShared,.F.))
		  IF lSiPrin
		     REPL ADM->cPrnNitAdm WITH cPrnNitTad
		  ENDIF
		  ADM->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABABO EL REGISTRO')
	       ENDIF
	       IF lShared
		  ADM->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL CONTROL DE LA IMPRESION POR CEDULAS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ADM
	    ADM->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS