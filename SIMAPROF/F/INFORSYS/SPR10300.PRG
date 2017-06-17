/*************************************************************************
* TITULO..: RESUMEN DE INDICADORES DEL PROFESOR                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2008 MIE A
       Colombia, Bucaramanga        INICIO:  08:00 AM  ABR 02/2008 MIE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SPR_10300(aP1,aP2,aP3,;
		   nNroPer,cCodMat,cNomPro,cCodGru,;
		   cNomMat,lIndNiv,cEvaInd,lEvaInd,;
		   lHayNot,lNotNum,lPrnLin)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nNroPer                              // N£mero del Periodo
       cCodMat                              // C¢digo de la Materia
       cNomMat                              // Nombre de la Materia
       cNomPro                              // Nombre del Profesor
       cCodGru                              // C¢digo del Grupo
       cNomMat                              // Nombre de la Materia
       lIndNiv                              // .T. Indicadores de Nivel
       cEvaInd			            // Evaluar el Indicador
       lHayNot                              // .T. Hay nota definitiva
       lNotNum                              // .T. Nota N£merica .F. Nota Cualitativa
       lPrnLin                              // .T. L¡nea Separadora */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL i,j,k,x := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL FilePrn := ''                  // Archivo de impresion
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
       LOCAL aPrnWww := {}		    // Detalles informes para www
       LOCAL lSiorNo := .F.                 // Control de Flujo
       STATI nHanXml := 0                   // Manejador del Archivo
       STATI lHanXml := .F.                 // Manejador del Archivo
     *ÀVariables de informe

       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cLogros := ''                  // Logros
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cNotInd := ''                  // Notas de los Indicadores

       LOCAL lSiPaso := .F.                 // Control de Flujo
       LOCAL aIndMat := {}                  // Indicadores del periodo
       LOCAL aIndPer := {}                  // Indicadores del periodo
       LOCAL aSiRecu := {}                  // Indicadores Si Recuperados
       LOCAL aNoRecu := {}                  // Indicadores NO Recuperados
       LOCAL aNoIndp := {}                  // Indicadores NO Recuperados por periodo
       LOCAL lSiCabe := .F.                 // .T. Imprimir encabezado

       LOCAL aIndica := {}                  // Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodEva := ''                  // C¢digo de Evaluaci¢n
       LOCAL cEvaRec := ''                  // C¢digo de la Recuperaci¢n
       LOCAL cNomEva := ''                  // Nombre de la Evaluaci¢n
       LOCAL cNomInd := ''                  // Nombre del Indicador

       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroLin := ''                  // N£mero de l¡neas
       LOCAL nTotExt := 0                   // Total de Estudiantes
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL lRetiroTno := .F.              // .T. Retiro del Estudiante
     *ÀVariable de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := xPrm(aP3,'nLenPrn')

       nNroInf := xPrm(aP3,'nNroInf')
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := xPrm(aP3,'cOpcSys')
     *ÀOpci¢n del sistema del informe

       cCodInf := xPrm(aP3,'cCodInf')
       aMarInf := xPrm(aP3,'aMarInf')
       nNroDoc := xPrm(aP3,'nNroDoc')
     *ÀInforme por defecto

       aTitIso := xPrm(aP3,'aTitIso')
     *ÀT¡tulos del Informe por defecto

       aPieIso := xPrm(aP3,'aPieIso')
     *ÀPie de p ginas por defecto

       aObsIso := xPrm(aP3,'aObsIso')

       cUsrIso := xPrm(aP3,'cUsrIso')
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       cCodIso := xPrm(aP3,'cCodIso')
       cFecIso := xPrm(aP3,'cFecIso')
       cVerIso := xPrm(aP3,'cVerIso')
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>ACTIVACION DE LA IMPRESORA
       FilePrn := xPrm(aP3,'FilePrn')
       nOpcPrn := xPrm(aP3,'nOpcPrn')
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   aTitIso[1],;
		   aTitIso[2],;
		   aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,04)
       AADD(aTitPrn,'No.')

       AADD(aNroCol,10)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,114)
       IF CLA->(EOF())
	  AADD(aTitPrn,'RESUMEN DE INDICADORES')
       ELSE
	  AADD(aTitPrn,'RESUMEN DE '+ALLTRIM(CLA->cNombreCla))
       ENDIF

       IF lEvaInd
	  AADD(aNroCol,16)
	  AADD(aTitPrn,'EVALUACION')
       ENDIF

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := {'PROFESOR: '+ALLTRIM(cNomPro)}
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn,;
			       cCodIso,cFecIso,cVerIso)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl',xPrm(aP3,'nCodXsl')})
       AADD(aPrnWww,{'cCodInf',cCodInf})
       AADD(aPrnWww,{'cCodIso',cCodIso})
       AADD(aPrnWww,{'cFecIso',cFecIso})
       AADD(aPrnWww,{'cVerIso',cVerIso})
       AADD(aPrnWww,{'cPieUno',aPieIso[1]})
       AADD(aPrnWww,{'cPieDos',aPieIso[2]})
       AADD(aPrnWww,{'cPieTre',aPieIso[2]})
*>>>>FIN IMPRESION DEL ENCABEZADO

/*
   Opci¢n temporal solicitada por Juan Pablo
   para imprimir el encabezado asi no haya
   estudiantes.
*/

/*
lSiCabe := .T.
SET DEVICE TO PRINT
EVAL(bCabeza)
*Impresi¢n del Encabezado
SET DEVICE TO SCREEN
*/



*>>>>LOCALIZACION DE LA MATERIA
       IF !lLocCodigo('cCodigoMat','MAT',cCodMat)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºGRUPO:'+cCodGru+'º'+;
			'REG:'+NOP->(STR(RECNO(),4))+'/'+;
				     NOP->(STR(RECCOUNT(),4))+'º'+;
			cNomMat,cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOP->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := &cMaeAct->cCodigoGru+':'+cNombreTes
	    cNombreTes := SUBS(cNombreTes+SPACE(112),1,112)
	    lRetiroTno := NOP->lRetiroNoP
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********IMPRESION DE LAS NOTAS DEL ESTUDIANTE
	    cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
	    cCamNtI := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
	    cLogros := &cCamInd
	    cNotInd := &cCamNtI

	    IF !(lRetiroTno .AND. CAP->nTipCarCar # 0 .AND. EMPTY(cLogros))

	       DO CASE
	       CASE (!lRetiroTes .AND. !lRetiroTno) .OR. !EMPTY(cLogros)

*===================INDICADORES DEL PERIODO
		      aIndMat := FSPR_10301(aIndicaMat(nNroPer,;
					    SUBS(cCodGru,1,2),;
					    cCodMat,;
					    lIndNiv,cLogros,cNotInd,;
					    cEvaInd,'IND'))
*===================FIN INDICADORES DEL PERIODO

*===================INDICADORES POR RECUPERAR
		      aNoIndp := {}
		      FOR i := 1 TO nNroPer-1

			 cCamInd := 'NOP->cIndic'+STR(i,1,0)+'NoP'
			 cCamNtI := 'NOP->cIndnt'+STR(i,1,0)+'NoP'

			 cLogros := &cCamInd
			 cNotInd := &cCamNtI

			 aIndPer := FSPR_10301(aIndicaMat(i,;
					       SUBS(cCodGru,1,2),;
					       cCodMat,;
					       lIndNiv,cLogros,cNotInd,;
					       cEvaInd,'IND'))
		       *ÀSeleccionar indicadores periodo anterior

			 aSiRecu := {}
			 aNoRecu := {}
			 IndicaSiNo(aIndPer,@aSiRecu,@aNoRecu)

			 IF LEN(aNoRecu) # 0
			    AADD(aNoIndp,{i,aNoRecu})
			 ENDIF

		      ENDFOR
*===================FIN INDICADORES POR RECUPERAR

*===================IMPRESION DEL ENCABEZADO
		      IF !lSiorNo .AND.;
			 (LEN(aIndMat) # 0 .OR. LEN(aNoIndp) # 0)

			 SET DEVICE TO PRINT
			 SendCodes(PCL('Reset'))

			 EVAL(bCabeza)
			*Impresi¢n del Encabezado
			 SET DEVICE TO SCREEN

			 IF !lHanXml
			    nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
						  nOpcPrn,aCabPrn,aTitPrn,;
						  aPrnWww)
			    lHanXml := .T.
			 ENDIF

			 lSiorNo := .T.
		      ENDIF
*===================FIN IMPRESION DEL ENCABEZADO

*===================IMPRESION DETALLES DEL ESTUDIANTE
		      IF LEN(aIndMat) # 0 .OR. LEN(aNoIndp) # 0

			 aRegPrn := {}

			 AADD(aRegPrn,STR(++nTotExt,2))
			 AADD(aRegPrn,cCodigoTes+'-'+STR(NOP->(RECNO()),2))
			 AADD(aRegPrn,cNombreTes)
			 IF lEvaInd
			    AADD(aRegPrn,SPACE(01))
			 ENDIF

			 SET DEVICE TO PRINT
			 lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				 bCabeza)
			 SET DEVICE TO SCREEN

		      ENDIF
*===================FIN IMPRESION DETALLES DEL ESTUDIANTE

*===================INDICADORES DEL PERIODO
		      FOR i := 1 TO LEN(aIndMat)

			 aIndica := aIndMat[i]
			 cCodInd := xPrm(aIndica,'cCodInd')
			 cCodEva := xPrm(aIndica,'cCodEva')
			 cEvaRec := xPrm(aIndica,'cEvaRec')
			 cNomEva := xPrm(aIndica,'cNomEva')
			 cNomInd := xPrm(aIndica,'cNomInd')

			 aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*------------------------IMPRESION INDICADORES DEL PERIODO
			   FOR k := 1 TO LEN(aNroLin)

			       aRegPrn := {}
			       AADD(aRegPrn,SPACE(01))
			       AADD(aRegPrn,SPACE(01))

			       cNroLin := aNroLin[k]
			       cNroLin := SUBS(cNroLin+SPACE(106),1,106)
			       IF k == 1
				  AADD(aRegPrn,cCodInd+cCodEva+cEvaRec+;
					       '->'+cNroLin)
			       ELSE
				  AADD(aRegPrn,SPACE(06)+cNroLin)
			       ENDIF

			       IF lEvaInd
				  IF k == 1
				     AADD(aRegPrn,cNomEva)
				  ELSE
				     AADD(aRegPrn,SPACE(01))
				  ENDIF
			       ENDIF

			       SET DEVICE TO PRINT
			       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				       nColCab,aTitPrn,aRegPrn,aNroCol,;
				       bPagina,bDerAut,bCabeza)
			       SET DEVICE TO SCREEN

			   ENDFOR
*------------------------FIN IMPRESION INDICADORES DEL PERIODO

		       ENDFOR
*===================FIN INDICADORES DEL PERIODO

*===================INDICADORES POR RECUPERAR PERIODOS
		      FOR i := 1 TO LEN(aNoIndp)

*-------------------------IMPRESION DEL PERIODO DE LOS INDICADORES
			    aRegPrn := {}

			    AADD(aRegPrn,SPACE(01))
			    AADD(aRegPrn,SPACE(01))

			    cTxtPrn := 'Periodo No.'+STR(aNoIndp[i,1],1)
			    cTxtPrn := SUBS(cTxtPrn+SPACE(114),1,114)
			    AADD(aRegPrn,cTxtPrn)

			    IF lEvaInd
			       AADD(aRegPrn,SPACE(01))
			    ENDIF

			    SET DEVICE TO PRINT
			    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				    bCabeza)
			    SET DEVICE TO SCREEN
*-------------------------IMPRESION DEL PERIODO DE LOS INDICADORES

*-------------------------INDICADORES POR RECUPERAR
			    aIndMat := aNoIndp[i,2]

			    FOR j := 1 TO LEN(aIndMat)

				aIndica := aIndMat[j]
				cCodInd := xPrm(aIndica,'cCodInd')

				cCodEva := xPrm(aIndica,'cCodEva')
				cEvaRec := xPrm(aIndica,'cEvaRec')
				cNomEva := xPrm(aIndica,'cNomEva')
				cNomInd := xPrm(aIndica,'cNomInd')

*:::::::::::::::::::::::::::::::IMPRESION INDICADORES DEL PERIODO
				  aNroLin := aDivLin(ALLTRIM(cNomInd),106)

				  FOR k := 1 TO LEN(aNroLin)

				      aRegPrn := {}
				      AADD(aRegPrn,SPACE(01))
				      AADD(aRegPrn,SPACE(01))

				      cNroLin := aNroLin[k]
				      cNroLin := SUBS(cNroLin+;
						      SPACE(106),1,106)
				      IF k == 1
					 AADD(aRegPrn,cCodInd+cCodEva+cEvaRec+;
						      '->'+cNroLin)
				      ELSE
					 AADD(aRegPrn,SPACE(06)+cNroLin)
				      ENDIF

				      IF lEvaInd
					 IF k == 1
					    AADD(aRegPrn,cNomEva)
					 ELSE
					    AADD(aRegPrn,SPACE(01))
					 ENDIF
				      ENDIF

				      SET DEVICE TO PRINT
				      lPrnOpc(lShared,nOpcPrn,FilePrn,;
					      nHanXml,01,nColCab,aTitPrn,;
					      aRegPrn,aNroCol,bPagina,;
					      bDerAut,bCabeza)
				      SET DEVICE TO SCREEN

				  ENDFOR
*:::::::::::::::::::::::::::::::FIN INDICADORES POR RECUPERAR

			    ENDFOR
*-------------------------FIN INDICADORES POR RECUPERAR

		      ENDFOR
*===================FIN INDICADORES POR RECUPERAR PERIODOS

*===================LINEA SEPARADORA
		      IF lPrnLin .AND.;
			 (LEN(aIndMat) # 0 .OR. LEN(aNoIndp) # 0)

			 aRegPrn := {}

			 AADD(aRegPrn,REPL('=',aNroCol[1]))
			 AADD(aRegPrn,REPL('=',aNroCol[2]))
			 AADD(aRegPrn,REPL('=',aNroCol[3]))
			 IF lEvaInd
			    AADD(aRegPrn,REPL('=',aNroCol[4]))
			 ENDIF

			 SET DEVICE TO PRINT
			 lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				 bCabeza)
			 SET DEVICE TO SCREEN

		      ENDIF
*===================FIN LINEA SEPARADORA

	       ENDCASE

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL ESTUDIANTE

	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF lSiorNo .OR. lSiCabe
	  SET DEVICE TO PRINT
	  EVAL(bDerAut)
	  EJECT
	 *Derechos de Autor
	  SET DEVICE TO SCREEN
       ENDIF
       RETURN nHanXml
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: SELECCIONAR LOS INDICADORES                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2008 MIE A
       Colombia, Bucaramanga        INICIO:  03:00 AM  ABR 02/2008 MIE

OBJETIVOS:

1- Permite seleccionar los indicadicadores

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FSPR_10301(aIndMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     aIndMat                              // Indicadores de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL aIndica := {}                  // Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodEva := ''                  // C¢digo de Evaluaci¢n del indicador
       LOCAL cEvaRec := ''                  // C¢digo de la Recuperaci¢n
       LOCAL aIndSel := {}                  // Indicadores Seleccionados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCIONAR INDICADORES
       FOR i := 1 TO LEN(aIndMat)

	   aIndica := aIndMat[i]
	   cCodInd := xPrm(aIndica,'cCodInd')
	   cCodEva := xPrm(aIndica,'cNotEva')

***********VALIDACION CLASE DEL INDICADOR
	     IF .NOT. CLA->(EOF())
		IF SUBS(CLA->cCodigoCla,1,1) # SUBS(cCodInd,1,1)
		   LOOP
		ENDIF
	     ENDIF
***********FIN VALIDACION CLASE DEL INDICADOR

***********VALIDACION CODIGO DE EVALUACION
	     IF .NOT. EVA->(EOF())
		IF EVA->cCodigoEva # cCodEva
		   LOOP
		ENDIF
	     ENDIF
***********FIN VALIDACION CODIGO DE EVALUACION

	   AADD(aIndSel,aIndMat[i])

       ENDFOR
       RETURN aIndSel
*>>>>FIN SELECCIONAR INDICADORES