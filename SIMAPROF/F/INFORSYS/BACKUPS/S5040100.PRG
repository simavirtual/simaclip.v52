/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 25/2008 LUN A
       Colombia, Bucaramanga        INICIO:  08:30 PM  FEB 25/2008 LUN

OBJETIVOS:

1- Imprime la clasificaci¢n de los indicadores.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION S_50401_00(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		    // Detalles informes para www
     *ÀVariables de informe

       LOCAL cCodNiv := ''                  // C¢digo del Nivel
       LOCAL cCodMat := ''                  // C¢digo de la Materia
       LOCAL aCodInd := {}                  // C¢digo de indicadores
       LOCAL cCodUno := ''                  // C¢digo Clasificaci¢n Uno
       LOCAL cCodDos := ''                  // C¢digo Clasificaci¢n Dos
       LOCAL cCodTre := ''                  // C¢digo Clasificaci¢n Tres
       LOCAL aNomInd := {}                  // Nombre del Indicador
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTju := ''               // Nombre del Indicador
       LOCAL cExtra1Tju := ''               // Nombre del Indicador Extra 1
     *ÀVariable de campo
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

       AADD(aNroCol,10)
       AADD(aTitPrn,'CODIGO')
       AADD(aNroCol,108)
       AADD(aTitPrn,aObsIso[3])

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn,;
			       cCodIso,cFecIso,cVerIso)}
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
       AADD(aPrnWww,{'nCodXsl',xPrm(aP3,'nCodXsl')})
       AADD(aPrnWww,{'cCodInf',cCodInf})
       AADD(aPrnWww,{'cCodIso',cCodIso})
       AADD(aPrnWww,{'cFecIso',cFecIso})
       AADD(aPrnWww,{'cVerIso',cVerIso})
       AADD(aPrnWww,{'cPieUno',aPieIso[1]})
       AADD(aPrnWww,{'cPieDos',aPieIso[2]})
       AADD(aPrnWww,{'cPieTre',aPieIso[2]})

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn,aPrnWww)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>CLASIFICACION DE LOS INDICADORES
       SELECT CLA
       CLA->(DBGOTOP())

       aCodInd := {}
       DO WHILE .NOT. SIN->(EOF())
	  IF SUBS(SIN->cCodLogSin,1,1) == CLA->cCodigoCla
	     AADD(aCodInd,SIN->cCodLogSin)
	  ENDIF
	  SIN->(DBSKIP())
       ENDDO
*>>>>FIN CLASIFICACION DE LOS INDICADORES

*>>>>RECORRIDO CLASIFICACION No.1
       cSavPan := SAVESCREEN(0,0,24,79)
       cCodNiv := xPrm(aP3,'cCodNiv')
       cCodMat := xPrm(aP3,'cCodMat')
       FOR i := 1 TO LEN(aCodInd)

	   cCodUno := aCodInd[i]

***********IMPRESION DE LA LINEA DE ESTADO
	     SET DEVICE TO SCREEN
	     LineaEstados('ºNo. '+STR(i,4)+'/'+STR(LEN(aCodInd),4)+'º'+;
			  cCodUno,cNomSis)
	     SET DEVICE TO PRINT
***********FIN IMPRESION DE LA LINEA DE ESTADO

***********LOCALIZACION DE LA CLASIFICACION
	    SELECT SIN
	    SIN->(DBGOTOP())

	    LOCATE FOR SIN->cCodGruSin == cCodNiv+'00' .AND.;
		       SIN->cCodMatSin == cCodMat       .AND.;
		       SIN->cCodLogSin == cCodUno

	    IF .NOT. SIN->(FOUND())
	       LOOP
	    ENDIF
***********FIN LOCALIZACION DE LA CLASIFICACION

***********BUSQUEDA DEL INDICADOR
	     IF !lSekCodigo(IF(TCO->lIndNivTbl,;
			       cCodNiv+cCodMat+cCodUno,;
			       cCodMat+cCodUno),'IND','INDICADOR')
		LOOP
	     ENDIF
	     aNomInd := {}
	     AADD(aNomInd,{cCodUno,IND->cNombreJui})
	     FOR x := 1 TO IIF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)
		 IF !EMPTY(IND->cExtra1Jui)
		    AADD(aNomInd,{SPACE(04),IND->cExtra1Jui})
		 ENDIF
	     ENDFOR
***********FIN BUSQUEDA DEL INDICADOR

**********IMPRESION DEL REGISTRO
	    FOR x := 1 TO LEN(aNomInd)

		aRegPrn := {}

		AADD(aRegPrn,aNomInd[x,1])
		AADD(aRegPrn,aNomInd[x,2]+SPACE(02))

		lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDFOR
**********FIN IMPRESION DEL REGISTRO

***********RECORRIDO CLASIFICACION No.2
	     FOR j := 1 TO LEN(ALLTRIM(SIN->cCodIndSin))/4

		 cCodDos := SUBS(SIN->cCodIndSin,j*4-3,4)

*================IMPRESION DE LA LINEA DE ESTADO
		   SET DEVICE TO SCREEN
		   LineaEstados('ºNo. '+STR(i,4)+'/'+;
				STR(LEN(aCodInd),4)+'º'+;
				cCodUno+'º'+cCodDos,cNomSis)
		   SET DEVICE TO PRINT
*================FIN IMPRESION DE LA LINEA DE ESTADO

*================LOCALIZACION DE LA CLASIFICACION
		   SELECT SIN
		   SIN->(DBGOTOP())

		   LOCATE FOR SIN->cCodGruSin == cCodNiv+'00' .AND.;
			      SIN->cCodMatSin == cCodMat       .AND.;
			      SIN->cCodLogSin == cCodDos

		   IF .NOT. SIN->(FOUND())
		      LOOP
		   ENDIF
*================FIN LOCALIZACION DE LA CLASIFICACION

*================BUSQUEDA DEL INDICADOR
		   IF !lSekCodigo(IF(TCO->lIndNivTbl,;
				     cCodNiv+cCodMat+cCodDos,;
				     cCodMat+cCodDos),'IND','INDICADOR')
		      LOOP
		   ENDIF
		   aNomInd := {}
		   AADD(aNomInd,{cCodDos,IND->cNombreJui})
		   FOR x := 1 TO IIF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)
		       IF !EMPTY(IND->cExtra1Jui)
			  AADD(aNomInd,{SPACE(04),IND->cExtra1Jui})
		       ENDIF
		   ENDFOR
*================FIN BUSQUEDA DEL INDICADOR

*================IMPRESION DEL REGISTRO
		   FOR x := 1 TO LEN(aNomInd)

		       aRegPrn := {}

		       AADD(aRegPrn,SPACE(02)+aNomInd[x,1])
		       AADD(aRegPrn,SPACE(01)+aNomInd[x,2]+SPACE(01))


		       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

		   ENDFOR
*================FIN IMPRESION DEL REGISTRO

*================RECORRIDO CLASIFICACION No.3
		   FOR k := 1 TO LEN(ALLTRIM(SIN->cCodIndSin))/4

		       cCodTre := SUBS(SIN->cCodIndSin,k*4-3,4)

*----------------------IMPRESION DE LA LINEA DE ESTADO
			 SET DEVICE TO SCREEN
			 LineaEstados('ºNo. '+STR(i,4)+'/'+;
				      STR(LEN(aCodInd),4)+'º'+;
				      cCodUno+'º'+cCodDos+'º'+cCodTre,cNomSis)
			 SET DEVICE TO PRINT
*----------------------FIN IMPRESION DE LA LINEA DE ESTADO

*----------------------BUSQUEDA DEL INDICADOR
			 IF !lSekCodigo(IF(TCO->lIndNivTbl,;
					   cCodNiv+cCodMat+cCodTre,;
					   cCodMat+cCodTre),'IND','INDICADOR')
			    LOOP
			 ENDIF
			 aNomInd := {}
			 AADD(aNomInd,{cCodTre,IND->cNombreJui})
			 FOR x := 1 TO IIF(TCO->nJuiExtTbl > 1,1,TCO->nJuiExtTbl)
			     IF !EMPTY(IND->cExtra1Jui)
				AADD(aNomInd,{SPACE(04),IND->cExtra1Jui})
			     ENDIF
			 ENDFOR
*----------------------FIN BUSQUEDA DEL INDICADOR

*----------------------IMPRESION DEL REGISTRO
			 FOR x := 1 TO LEN(aNomInd)

			     aRegPrn := {}

			     AADD(aRegPrn,SPACE(04)+aNomInd[x,1])
			     AADD(aRegPrn,SPACE(02)+aNomInd[x,2])


			     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

			 ENDFOR
*----------------------FIN IMPRESION DEL REGISTRO

		   ENDFOR
*================FIN RECORRIDO CLASIFICACION No.3

*================LOCALIZACION DE LA CLASIFICACION
		   SELECT SIN
		   SIN->(DBGOTOP())

		   LOCATE FOR SIN->cCodGruSin == cCodNiv+'00' .AND.;
			      SIN->cCodMatSin == cCodMat       .AND.;
			      SIN->cCodLogSin == cCodUno

		   IF .NOT. SIN->(FOUND())
		      LOOP
		   ENDIF
*================FIN LOCALIZACION DE LA CLASIFICACION

	     ENDFOR
***********FIN RECORRIDO CLASIFICACION No.2

       ENDFOR
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO CLASIFICACION No.1

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor
       EJECT

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
