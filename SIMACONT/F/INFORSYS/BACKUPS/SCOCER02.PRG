/*************************************************************************
* TITULO..: CERTIFICADOS DE NOTAS No.2                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 23/2009 LUN A
       Colombia, Bucaramanga        INICIO: 11:30 AM   FEB 23/2009 LUN

OBJETIVOS:

1- Permite imprimir el certificado de notas con juicio valorativo, nota
   n£merica y letras.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CertiNot02(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cIniJor := xPrm(aP1,'cIniJor') // Iniciales de la jornada
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>PARAMETROS ESPECIFICOS
       LOCAL cCodEst := xPrm(aP2,'cCodEst') // C¢digo del Estudiante
       LOCAL lRetEst := xPrm(aP2,'lRetEst') // .T. Estudiante Retirado
       LOCAL cNomEst := xPrm(aP2,'cNomEst') // Nombre del Estudiante

       LOCAL aAnoCer := xPrm(aP2,'aAnoCer') // A¤os del Certificado
       LOCAL lPrnAre := xPrm(aP2,'lPrnAre') // Imprimir el Area
       LOCAL nMarIzq := xPrm(aP2,'nMarIzq') // Margen Izquierdo
       LOCAL nTipCer := xPrm(aP2,'nTipCer') // Tipo de Certificado
       LOCAL nOpcCer := xPrm(aP2,'nOpcCer') // Opci¢n de impresi¢n de los Certificados
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nColPrn := 0                   // Columna de Impresi¢n
       LOCAL nObsCer := 0                   // Margen Inferior de la Observaci¢n para el Certificado

       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cMateri := ''                  // Nombre de la Materia
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL   cNota := ''                  // Nota de area o materia
       LOCAL cNotTxt := ''                  // Nota en Texto
       LOCAL cIntens := ''                  // Intensidad horaria
       LOCAL nFalAno := 0                   // Total fallas del a¤o.
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cFolios := ''                  // Folios del libro final
       LOCAL lHayEst := .F.                 // .T. Hay Estudiante
       LOCAL lNegAre := .F.                 // .T. Imprimir Negrilla
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL nTotPer := 0                   // Total Periodos
       LOCAL cTitAre := ''                  // T¡tulo del Area
       LOCAL cCamFal := ''                  // Campo de Fallas
       LOCAL lHayNpR := .F.                 // .T. Se presento a la Recuperaci¢n
       LOCAL aTxtNpr := {}                  // Texto para la no presentaci¢n de la Recuperaci¢n.
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LAS NOTAS DE CADA A¥O
       nTipCer := IF(EMPTY(nTipCer),1,nTipCer)
       nColPrn := nMarIzq
       FOR k := 1 TO LEN(aAnoCer)

***********VALIDACION DE LOS A¥OS DISPONIBLES
	     lHayEst := .F.
	     IF aAnoCer[k] < SCO->nAnoIniCon .OR.;
		aAnoCer[k] > SCO->nAnoFinCon
		cError('EL A¥O '+STR(aAnoCer[k],4)+' NO ESTA DISPONIBLE',;
		       'INICIAL:'+STR(SCO->nAnoIniCon,4)+;
		       ' FINAL:'+STR(SCO->nAnoFinCon,4))
		LOOP
	     ENDIF
***********FIN VALIDACION DE LOS A¥OS DISPONIBLES

***********INICIALIZACION PARA EL A¥O
	     CloseDbf('JAR')
	     CloseDbf('PRI')
	     CloseDbf('BTO')
	     cAnoSis := SUBS(STR(aAnoCer[k],4),3,2)
	     cPatSis := STR(aAnoCer[k],4)+'.'+cIniJor
***********FIN INICIALIZACION PARA EL A¥O

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis)
		CloseDbf('JAR')
		CloseDbf('PRI')
		CloseDbf('BTO')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********BUSQUEDA DEL ESTUDIANTE
	     lHayEst := lSekCodMae(cCodEst,cMaeAlu,@cMaeAct)
	     IF !lHayEst
		LOOP
	     ENDIF
***********FIN BUSQUEDA DEL ESTUDIANTE

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbfCe(lShared,cPatSis,STR(aAnoCer[k],4),;
			   cAnoSis,cMaeAct,&cMaeAct->cCodigoGru)
		CloseDbf('JAR')
		CloseDbf('PRI')
		CloseDbf('BTO')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DEL NOMBRE DEL ESTUDIANTE
	     IF RTRIM(&cMaeAct->cNombreEst)+' '+;
		&cMaeAct->cApelliEst # cNomEst

		SET DEVICE TO SCREEN
		cError(cNomEst+' '+;
		       'NOMBRES DIFERENTES',;
		       RTRIM(&cMaeAct->cNombreEst)+' '+;
		       &cMaeAct->cApelliEst)
		SET DEVICE TO PRINT

		lHayEst := .F.
		LOOP

	     ENDIF
***********FIN VALIDACION DEL NOMBRE DEL ESTUDIANTE

***********LOCALIZACION DEL GRUPO
	     IF !lLocCodigo('cCodigoGru','GRU',&cMaeAct->cCodigoGru)
		lHayEst := .F.
		LOOP
	     ENDIF
***********FIN LOCALIZACION DEL GRUPO

***********LOCALIZACION DE LAS NOTAS
	     lHayEst := lLocCodigo('cCodigoEst','NOT',cCodEst)
	     IF !lHayEst
		LOOP
	     ENDIF
	     SET DEVICE TO PRINT
***********FIN LOCALIZACION DE LAS NOTAS

***********LECTURA DE LOS NOTAS DEL ESTUDIANTE
	     SELECT NOT
	     aNotAre := {}
	     aNotMat := {}
	     nTotPer := TCO->nTotPerTbl
	     lNotNum := IF(SUBS(TCO->cNotNumTbl,nTotPer,1)='1',.T.,.F.)
	     DetAreas(@aNotAre,@aNotMat,nTotPer)
***********FIN LECTURA DE LOS NOTAS DEL ESTUDIANTE

***********REEMPLAZO DE LAS ASIGNATURAS VARIABLES // Adicionado
	     IF SEL->(RECCOUNT()) # 0
		lDetAreEst(@aNotAre,@aNotMat,nTotPer,NOT->cCodigoEst)
	     ENDIF
***********FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

***********CONTEO DEL TOTAL DE FALLAS POR AREAS
	     nFalAno := 0
	     FOR i := 1 TO LEN(aNotAre)

		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		    cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		    FOR j := 1 TO nTotPer
			nFalAno += VAL(SUBS(&cCamFal,j*2-1,2))
		    NEXT
		 ENDIF

	     NEXT
***********FIN CONTEO DEL TOTAL DE FALLAS POR AREAS

***********CONTEO DEL TOTAL DE FALLAS POR MATERIAS
	     FOR i := 1 TO LEN(aNotMat)
		 cCamFal := aNotMat[i,6]
		 FOR j := 1 TO nTotPer
		     nFalAno += VAL(SUBS(&cCamFal,j*2-1,2))
		 NEXT
	     NEXT
***********FIN CONTEO DEL TOTAL DE FALLAS POR MATERIAS

***********IMPRESION DE LOS DETALLES DEL A¥O
	     SendCodes(PCL('Pica'))
	     @PROW()+2,nColPrn SAY 'A¥O: '+STR(aAnoCer[k],4)+' '+;
				   'SECCION: '+cJorTxt+' '+;
				   IF(EMPTY(&cMaeAct->cFolFinEst),'',;
				      'FOLIO: '+&cMaeAct->cFolFinEst)

	     @PROW()+1,nColPrn SAY 'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
				   'DE '+ALLTRIM(GRU->cNivEduGru)


	     DO CASE
	     CASE nTipCer == 1
		  IF lPrnAre
		     cTitAre := 'AREAS Y ASIGNATURAS'+SPACE(17)
		  ELSE
		     cTitAre := 'AREA/ASIGNATURAS'+;
				IF(PRN->TipoPrn == 'M',SPACE(30),SPACE(23))
		  ENDIF

	     CASE nTipCer == 2
		  IF lPrnAre
		     cTitAre := 'AREAS Y ASIGNATURAS'+SPACE(17)
		  ELSE
		     cTitAre := 'AREA/ASIGNATURAS'+;
				IF(PRN->TipoPrn == 'M',SPACE(26),SPACE(23))
		  ENDIF
	     ENDCASE

	     DO CASE
	     CASE nTipCer == 1
		  cTitAre := SUBS(cTitAre,1,82)+;
			     IF(EMPTY(ANO->cHorClaCoA),'','*')+'I.H.S'+;
			     IF(PRN->TipoPrn == 'M',SPACE(02),SPACE(01))+;
			     'JUICIO VALORATIVO'

	     CASE nTipCer == 2
		  cTitAre := SUBS(cTitAre,1,82)+;
			     IF(EMPTY(ANO->cHorClaCoA),'','*')+'H/SEMANALES'+;
			     IF(PRN->TipoPrn == 'M',SPACE(03),SPACE(02))+;
			     'VALORACION'
	     ENDCASE
	     cTitAre := IF(EMPTY(TCO->cTitAreTbl),cTitAre,TCO->cTitAreTbl)

	     @PROW()+2,nColPrn SAY ALLTRIM(cTitAre)
	     SendCodes(PCL('CondenOn'))
	     nColPrn := SCO->nNo2IzqCon
***********FIN IMPRESION DE LOS DETALLES DEL A¥O

***********IMPRESION DE LAS NOTAS
	     nTotPer := TCO->nTotPerTbl
	     lNegAre := TCO->lNegAreTbl
	     lNegAre := .T.
	     FOR i := 1 TO LEN(aNotAre)

*---------------IMPRESION DEL NOMBRE DEL AREA
		  IF lPrnAre .AND. SUBS(aNotAre[i][4],7,4) == 'AREP' .AND.;
		     aNotAre[i,9]
		     cNomAre := RTRIM(aNotAre[i,10])
		     IF lNegAre
			cNomAre := PCL({"NegraOn"})+cNomAre+PCL({"NegraOf"})
		     ENDIF
		     @PROW()+1,nColPrn SAY cNomAre
		  ENDIF
*---------------FIN IMPRESION DEL NOMBRE DEL AREA

*---------------IMPRESION DE LAS NOTAS DEL AREA
		  IF SUBS(aNotAre[i][4],7,4) == 'AREN' .AND.;
		     aNotAre[i,9]  // El area se imprime en el certificado

*::::::::::::::::::::LECTURA DEL NOMBRE DEL AREA
		      DO CASE
		      CASE nTipCer == 1
			   cNomAre := RTRIM(aNotAre[i,10])+;
				      REPL('.',80-LEN(RTRIM(aNotAre[i,10])))

		      CASE nTipCer == 2
			   cNomAre := RTRIM(aNotAre[i,10])+;
				      REPL(' ',80-LEN(RTRIM(aNotAre[i,10])))
		      ENDCASE

		      IF lNegAre
			 cNomAre := PCL({"NegraOn"})+cNomAre+PCL({"NegraOf"})
		      ENDIF
*::::::::::::::::::::FIN LECTURA DEL NOMBRE DEL AREA

*::::::::::::::::::::LECTURA NOTA DEL AREA
		       cNota := SUBS(&(aNotAre[i,4]),nTotPer*4-3,4)
		       IF VAL(cNota) # 0

			  cNotTxt := cNota+' '+cNroToTxt(VAL(cNota))

			  cNota := cNotDefJvf(VAL(cNota))
			  cNota := cNombreJvf(ALLTRIM(cNota))

		       ELSE
			  cNota := cNombreJvf(ALLTRIM(cNota))
			  cNotTxt := ''
		       ENDIF
		       cIntens := IF(EMPTY(aNotAre[i,16]),aNotAre[i,11],aNotAre[i,16])
		      *Intensidad Horaria
*::::::::::::::::::::FIN LECTURA NOTA DEL AREA

*::::::::::::::::::::IMPRESION DEL REGISTRO
		       DO CASE
		       CASE nTipCer == 1
			    @PROW()+1,nColPrn SAY cNomAre+;
						  SPACE(02)+cIntens+' '+;
						  SPACE(07)+cNota+;
						  cNotTxt
		       CASE nTipCer == 2
			    @PROW()+1,nColPrn SAY cNomAre+;
						  SPACE(02)+cIntens+;
						  SPACE(12)+cNota
		       ENDCASE
*::::::::::::::::::::FIN IMPRESION DEL REGISTRO

*::::::::::::::::::::ANALISIS PARA EL CAMBIO DE PAGINA
		       IF PRN->TipoPrn == 'M' .AND.;
			  PROW() > SCO->nInfCerCon
			  @PROW()+1,nColPrn SAY 'SIGUE..x'
			  EJECT
			  @PROW()+TCO->nLinEspTbl,nColPrn SAY '...CONTINUA '+;
					 'A¥O: '+STR(aAnoCer[k],4)+' '+;
					 'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
					 'DE '+ALLTRIM(GRU->cNivEduGru)
			  @PROW(),nColPrn SAY ''
		       ENDIF
*::::::::::::::::::::FIN ANALISIS PARA EL CAMBIO DE PAGINA

		  ENDIF
*---------------FIN IMPRESION DE LAS NOTAS DEL AREA

*---------------IMPRESION DE LAS NOTAS DE LA MATERIA
		  FOR j := 1 TO LEN(aNotMat)

*::::::::::::::::::::VALIDACION DE IMPRESION
		       IF !aNotMat[j,9] // La materia se imprime en el certificado
			  LOOP
		       ENDIF
*::::::::::::::::::::FIN VALIDACION DE IMPRESION

*::::::::::::::::::::VALIDACION DE LA IMPRESION
		       cCodigoTma := SUBS(aNotMat[j,5],9,4)
		       DO CASE
		       CASE nOpcCer == 1 // Solo Areas

			    IF SUBS(cCodigoTma,3,2) # '00'
			       LOOP
			    ENDIF
			  *ÀDescarta las asignaturas

		       CASE nOpcCer == 2 // Solo Asignaturas

			    IF SUBS(cCodigoTma,3,2) == '00'
			       LOOP
			    ENDIF
			  *ÀDescarta las Areas

		       ENDCASE
*::::::::::::::::::::FIN VALIDACION DE LA IMPRESION

*::::::::::::::::::::IMPRESION DE LA MATERIA CORRESPONDIENTE AL AREA
		       IF aNotAre[i,2] == aNotMat[j,1]

*.........................MATERIA VARIABLE
			    cMateri := RTRIM(aNotMat[j,10])
			    IF SUBS(aNotMat[j,5],9,4) # SUBS(aNotMat[j,11],3,4)
			       IF aNotMat[j,22] // Materia Fija de la Materia Variable. .T.=> Entra en el certificado de notas
				  cMateri := RTRIM(aNotMat[j,2])
			       ENDIF
			    ENDIF
*.........................FIN MATERIA VARIABLE

*.........................LECTURA DE NOMBRE DE LA MATERIA
			   IF lPrnAre
			      DO CASE
			      CASE nTipCer == 1
				   cNomMat := SPACE(02)+cMateri+;
					      REPL('.',78-LEN(cMateri))

			      CASE nTipCer == 2
				   cNomMat := SPACE(02)+cMateri+;
					      REPL(' ',78-LEN(cMateri))
			      ENDCASE
			   ELSE
			      DO CASE
			      CASE nTipCer == 1
				   cNomMat := cMateri+;
					      REPL('.',80-LEN(cMateri))
			      CASE nTipCer == 2
				   cNomMat := cMateri+;
					      REPL(' ',80-LEN(cMateri))
			      ENDCASE

			      IF !EMPTY(TCO->cSpaBolTbl)
				 IF aNotMat[j,1] == cCodAre .AND.;
				    SUBS(aNotMat[j,5],11,2) # '00'
				    IF aNotAre[i,9]
				       cNomMat := SUBS(SPACE(02)+cNomMat,1,80)
				    ELSE
				       cNomMat := SUBS(cNomMat,1,80)
				    ENDIF
				 ELSE
				    cCodAre := aNotMat[j,1]
				 ENDIF
			      ENDIF
			    *ÀIndentaci¢n de la materia

			   ENDIF
			   IF lNegAre
			      cNomMat := PCL({"NegraOn"})+cNomMat+PCL({"NegraOf"})
			   ENDIF
*.........................FIN LECTURA DE NOMBRE DE LA MATERIA

*.........................LECTURA NOTA DE LA MATERIA
			    cNota := SUBS(&(aNotMat[j,4]),nTotPer*4-3,4)
			    IF VAL(cNota) # 0

			       cNotTxt := cNota+' '+cNroToTxt(VAL(cNota))

			       cNota := cNotDefJvf(VAL(cNota))
			       cNota := cNombreJvf(ALLTRIM(cNota))

			    ELSE
			       cNota := cNombreJvf(ALLTRIM(cNota))
			       cNotTxt := ''
			    ENDIF
			    cIntens := IF(EMPTY(aNotMat[j,16]),aNotMat[j,3],aNotMat[j,16])
			   *Intensidad Horaria
*.........................FIN LECTURA NOTA DE LA MATERIA

*.........................IMPRESION DEL REGISTRO
			    DO CASE
			    CASE nTipCer == 1
				 @PROW()+1,nColPrn SAY cNomMat+;
						       SPACE(02)+cIntens+;
						       SPACE(08)+cNota+;
						       cNotTxt
			    CASE nTipCer == 2
				 @PROW()+1,nColPrn SAY cNomMat+;
						       SPACE(02)+cIntens+;
						       SPACE(12)+cNota
			    ENDCASE
*.........................FIN IMPRESION DEL REGISTRO

*.........................ANALISIS PARA EL CAMBIO DE PAGINA
			    IF PRN->TipoPrn == 'M' .AND.;
			       PROW() > SCO->nInfCerCon
			       @PROW()+1,nColPrn SAY 'SIGUE..x'
			       EJECT
			       @PROW()+TCO->nLinEspTbl,nColPrn SAY '...CONTINUA '+;
					      'A¥O: '+STR(aAnoCer[k],4)+' '+;
					      'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
					      'DE '+ALLTRIM(GRU->cNivEduGru)
			       @PROW(),nColPrn SAY ''
			    ENDIF
*.........................FIN ANALISIS PARA EL CAMBIO DE PAGINA

		       ENDIF
*::::::::::::::::::::FIN IMPRESION DE LA MATERIA CORRESPONDIENTE AL AREA

		  ENDFOR
*---------------FIN IMPRESION DE LAS NOTAS DE LA MATERIA

*---------------ANALISIS PARA EL CAMBIO DE PAGINA
		  IF PRN->TipoPrn == 'M' .AND.;
		     PROW() > SCO->nInfCerCon
		     EJECT
		     lPagina := .T.
		  ELSE
		     lPagina := .F.
		  ENDIF
*---------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	     ENDFOR
***********IMPRESION DE LAS NOTAS

***********ANALISIS PARA EL CAMBIO DE PAGINA
	     nObsCer := IF(SCO->nObsCerCon==0,46,SCO->nObsCerCon)
	     IF PRN->TipoPrn == 'M' .AND. PROW() > nObsCer
		SET DEVICE TO PRINT
		@ PROW()+1,nColPrn SAY 'SIGUE...xx'
		EJECT
		@PROW()+TCO->nLinEspTbl,nColPrn SAY '...CONTINUA '+;
			       'A¥O: '+STR(aAnoCer[k],4)+' '+;
			       'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
			       'DE '+ALLTRIM(GRU->cNivEduGru)
		@PROW(),nColPrn SAY ''
	     ENDIF
***********FIN ANALISIS PARA EL CAMBIO DE PAGINA

***********IMPRESION DE LA OBSERVACION
	     SET DEVICE TO PRINT
	     IF lHayEst
		cEstado := ''
		cEstado := IF(lRetEst,'NO TERMINO. SE RETIRO EN '+;
				      cFecha(&cMaeAct->dFecRetEst),;
			      cAproboJui(NOT->nAproboNot))
		cEstado := ALLTRIM(cEstado)

		IF EMPTY(ANO->cHorClaCoA)
		   @ PROW()+1,nColPrn SAY ''
		   aNroLin := aDivLin('OBSERVACION FINAL: '+cEstado,110)
		   FOR i := 1 TO LEN(aNroLin)
		       @ PROW()+1,nColPrn SAY aNroLin[i]
		   NEXT
		ELSE
		   @ PROW()+1,nColPrn SAY '* '+ANO->cHorClaCoA
		   aNroLin := aDivLin('OBSERVACION FINAL: '+cEstado,110)
		   FOR i := 1 TO LEN(aNroLin)
		       @ PROW()+1,nColPrn SAY aNroLin[i]
		   NEXT
		ENDIF
	     ENDIF
***********FIN IMPRESION DE LA OBSERVACION

***********LECTURA DE LAS RECUPERACIONES
	     IF lHayEst
		lMatVar := .T.
		aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				      aNotMat,nTotPer,lNotNum,;
				      lMatVar)
	     ENDIF
***********FIN LECTURA DE LAS RECUPERACIONES

***********IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
	     IF lHayEst .AND. !EMPTY(aMatHab)
		@ PROW()+1,nColPrn SAY ''
		cTxtPrn := IF(EMPTY(aMatHab[1,6]),;
			      'ACTIVIDADES DE RECUPERACION DE:',;
			      aMatHab[1,6])

		FOR i := 1 TO LEN(aMatHab)

		    DO CASE
		    CASE nOpcCer == 1 // Solo Areas

			 IF SUBS(aMatHab[i,1],3,2) # '00'
			    LOOP
			 ENDIF
		       *ÀDescarta las asignaturas

		    CASE nOpcCer == 2 // Solo Asignaturas

			 IF SUBS(aMatHab[i,1],3,2) == '00'
			    LOOP
			 ENDIF
		       *ÀDescarta las Areas

		    ENDCASE

		    cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
		    IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		       cTxtPrn += 'PENDIENTE. '

		    ELSE
		       IF ALLTRIM(cTxtNota(aMatHab[i,4])) == '*NO SE PRESENTO'
			  cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+'. '
			  lHayNpR := .T.
		       ELSE
			  cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
				     ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
				     ' DE '+aMatHab[i,2]+'. '
		       ENDIF
		    ENDIF
		NEXT
		aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
		FOR i := 1 TO LEN(aNroLin)
		    @ PROW()+1,nColPrn SAY aNroLin[i]
		NEXT

		IF lHayNpR .AND. !EMPTY(ANO->cTxtNpRCoA)
		   aTxtNpr := aDivLin('*'+ALLTRIM(ANO->cTxtNpRCoA),110)
		   FOR i := 1 TO LEN(aTxtNpR)
		       @ PROW()+1,nColPrn SAY aTxtNpR[i]
		   NEXT
		ENDIF
	     ENDIF
***********FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

***********IMPRESION DE LA OBSERVACION
	     IF lHayEst .AND. !EMPTY(&cMaeAct->cObsLibEst)
		aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
		FOR i := 1 TO LEN(aNroLin)
		    @ PROW()+1,nColPrn SAY aNroLin[i]
		NEXT
	     ENDIF
	   *ÀObservaci¢n General.
***********FIN IMPRESION DE LA OBSERVACION

       ENDFOR
       SendCodes(PCL({"CondenOf"}))
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DE CADA A¥O