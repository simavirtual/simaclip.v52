/*************************************************************************
* TITULO..: VALIDACION DEL CALCULO DE LAS AREAS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/2008 LUN A
       Bucaramanga, Colombia	    INICIO: 11:45 AM   SEP 08/2008 LUN

OBJETIVOS:

1- Imprime el informe de validaci¢n del Calculo de las Areas

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SCO_25400(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL aArchvo := xPrm(aP3,'aArchvo') // Archivos para Uso
       LOCAL PathDoc := xPrm(aP3,'PathDoc') // Path de Documentos del sima
       LOCAL cOpcPrn := xPrm(aP3,'cOpcPrn') // Opciones de Impresi¢n.
       LOCAL nCodPrn := xPrm(aP3,'nCodPrn') // C¢digo de Impresi¢n
       LOCAL oBrowse := xPrm(aP3,'oBrowse') // Browse del Archivo

       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL cCodEst := xPrm(aP3,'cCodEst') // C¢digo del Estudiante
       LOCAL cNomEst := xPrm(aP3,'cNomEst') // Nombre del Estudiante
       LOCAL cCodGru := xPrm(aP3,'cCodGru') // C¢digo del Grupo
       LOCAL nNroLis := xPrm(aP3,'nNroLis') // N£mero de Lista
       LOCAL aNotAre := xPrm(aP3,'aNotAre') // Detalles de las areas
       LOCAL aNotMat := xPrm(aP3,'aNotMat') // Detalles de las materias
       LOCAL cJvfCal := xPrm(aP3,'cJvfCal') // Juicio Valorativo Calculado
       LOCAL nMetodo := xPrm(aP3,'nMetodo') // Metodo para los calculos de los promedios. Por defecto 0
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL nCabIso := 0                   // Encabezado del Informe
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
       LOCAL lPrnCab := .T.                     // .T. Imprimir el Encabezado
       LOCAL aDetInf := {}                  // Detalles del Informe
     *ÀVariables de informe

       LOCAL lHayPrn := .F.                 // .T. Hay Archivo de Impresi¢n
       LOCAL aUseDbf := {}                  // Archivos en Uso
       LOCAL fArchvo := ''                  // Nombre del Archivo
       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL cNalias := ''                  // Alias del Archivo
     *ÀVariable de Archivo

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       FOR i := 1 TO LEN(aArchvo)
           fArchvo := aArchvo[i,1]
           fNtxArc := aArchvo[i,2]
	   cNalias := aArchvo[i,3]
	   AADD(aUseDbf,{.T.,fArchvo,cNalias,fNtxArc,lShared,nModCry})
           IF cNalias == 'PRN'
              lHayPrn := .T.
           ENDIF
       ENDFOR
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF LEN(aArchvo) # 0
	  IF !lUseDbfs(aUseDbf)
	     cError('ABRIENDO EL ARCHIVO')
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct

       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE COA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASES GRABADAS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CODIGOS DE EVALUACION DE INDICADORES')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF lHayPrn
          IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
             cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
             CloseAll()
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>FILTRACION DEL ARCHIVO
       SELECT SEL
       SET FILTER TO SEL->cCodigoEst == cCodEst
       SEL->(DBGOTOP())
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 254
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[PERIODOS][CALCULOS][VALIDAR]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'SCO25400'
       AADD(aDetInf,{'cCodInf',cCodInf})
     *ÀC¢digo del Informe

       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
       AADD(aDetInf,{'aMarInf',aMarInf})
     *ÀM rgenes del informe

       nNroDoc := 0
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'VALIDACION DEL CALCULO DE LAS AREAS') // T¡tulo Uno
       AADD(aTitIso,'A¥O: <cAnoUsr> '+;
		    'JORNADA: <cJorTxt> ')     // T¡tulo Dos
       AADD(aTitIso,'')                        // T¡tulo Tres
       AADD(aDetInf,{'aTitIso',aTitIso})
     *ÀT¡tulos del Informe por defecto

       cPiePag := xPrm(aP3,'cPieTre')
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
       AADD(aDetInf,{'aPieIso',aPieIso})
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')

       cUsrIso := xPrm(aP3,'cUsrIso')
       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF nNroInf == 0
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,.T.,,PathDoc)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,2,bInsIso,PathDoc)
       ENDIF
       SET DEVICE TO SCREEN
       IF EMPTY(nOpcPrn)
	  RETURN NIL
       ENDIF
       AADD(aDetInf,{'nOpcPrn',nOpcPrn})
       AADD(aDetInf,{'FilePrn',FilePrn})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       fDocPrn := ''
       IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
		      @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
		      @fDocPrn)
	  RETURN NIL
       ENDIF
       ReplTitIso(@aTitIso,aMezIso)
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       AADD(aDetInf,{'lTamAnc',lTamAnc})

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   aTitIso[1],;
		   aTitIso[2],;
		   aTitIso[3]}
       AADD(aDetInf,{'aCabPrn',aCabPrn})

       AADD(aDetInf,{'nNroPag',nNroPag})
       AADD(aDetInf,{'cTotPag',cTotPagina(nTotReg)})

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})

       AADD(aDetInf,{'cCodIni',cCodIni})
       AADD(aDetInf,{'cCodFin',cCodFin})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>CONTROL DE DOCUMENTOS
       nCabIso := ISO->nCabPrnIso
       AADD(aDetInf,{'nCabIso',nCabIso})

       IF nNroInf # 0
	  cCodIso := ALLTRIM(ISO->cCodigoIso)
	  cFecIso := ALLTRIM(ISO->cFecAprIso)
	  cVerIso := ALLTRIM(ISO->cNroVerIso)
       ENDIF
       AADD(aDetInf,{'cCodIso',cCodIso})
       AADD(aDetInf,{'cFecIso',cFecIso})
       AADD(aDetInf,{'cVerIso',cVerIso})
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>IMPRESION DEL INFORME
       DO CASE
       CASE UPPER(cCodInf) == 'SCO25400'

	    SCO_254_00(aP1,aP2,aP3,aDetInf)
	  *ÀInforme por defecto.

       OTHERWISE
	    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
       ENDCASE

       IF LEN(aArchvo) # 0
	  CloseAll()
       ENDIF

       SELECT SEL
       SET FILTER TO
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: CAMPOS DEL INFORME. VERSION No.00                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/2008 LUN A
       Bucaramanga, Colombia	    INICIO: 03:00 PM   SEP 08/2008 LUN

OBJETIVOS:

1- Imprime los campos del informe

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SCO_254_00(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
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
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL aArchvo := xPrm(aP3,'aArchvo') // Archivos para Uso
       LOCAL cOpcPrn := xPrm(aP3,'cOpcPrn') // Opciones de Impresi¢n.
       LOCAL nCodPrn := xPrm(aP3,'nCodPrn') // C¢digo de Impresi¢n
       LOCAL oBrowse := xPrm(aP3,'oBrowse') // Browse del Archivo

       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL cCodEst := xPrm(aP3,'cCodEst') // C¢digo del Estudiante
       LOCAL cNomEst := xPrm(aP3,'cNomEst') // Nombre del Estudiante
       LOCAL cCodGru := xPrm(aP3,'cCodGru') // C¢digo del Grupo
       LOCAL nNroLis := xPrm(aP3,'nNroLis') // N£mero de Lista
       LOCAL aNotAre := xPrm(aP3,'aNotAre') // Detalles de las areas
       LOCAL aNotMat := xPrm(aP3,'aNotMat') // Detalles de las materias
       LOCAL cJvfCal := xPrm(aP3,'cJvfCal') // Juicio Valorativo Calculado
       LOCAL nMetodo := xPrm(aP3,'nMetodo') // Metodo para los calculos de los promedios. Por defecto 0
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                       // Contadores
       LOCAL cUsrIso := ''                      // Usuario de la Iso
       LOCAL nNroInf := 0                       // N£mero del informe
       LOCAL cOpcSys := ''                      // Opci¢n del Sistema
       LOCAL cCodInf := xPrm(aDetInf,'cCodInf') // C¢digo del Informe
       LOCAL aMarInf := {}                      // L¡neas de Espaciado
       LOCAL nNroDoc := 0                       // N£mero del Documento variable
       LOCAL fDocPrn := ''                      // Archivo a imprimir
       LOCAL nCabIso := xPrm(aDetInf,'nCabIso')	// Encabezado del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso')	// C¢digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso')	// Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso')	// Versi¢n del Iso
       LOCAL aTitIso := ''                      // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                      // Pie de P gina por defecto
       LOCAL aPieIso := xPrm(aDetInf,'aPieIso')	// Textos del pie de p gina
       LOCAL nTotPie := 0                       // Total de Pie de p ginas
       LOCAL aObsIso := {}                      // Observaciones del informe
       LOCAL aMezIso := {}                      // Campos a Mesclar
       LOCAL bInsIso := NIL                     // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL FilePrn := ''                      // Archivo de Impresi¢n
       LOCAL nHanXml := -1                      // Manejador del Archivo
       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                       // N£mero de p gina
       LOCAL lTamAnc := .F.                     // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                       // L¡neas totales de control
       LOCAL nTotReg := 0                       // Total de registros
       LOCAL aCabPrn := xPrm(aDetInf,'aCabPrn')	// Encabezado del informe General
       LOCAL aCabeza := {}                      // Encabezado del informe
       LOCAL cCodIni := ''                      // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                      // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                      // Columnas de impresi¢n
       LOCAL aTitPrn := {}                      // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                      // Registros para impresi¢n
       LOCAL cCabCol := ''                      // Encabezado de Columna
       LOCAL aCabSec := {}                      // Encabezado Secundario
       LOCAL nLenPrn := 0                       // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                     // .T. Centrar el informe
       LOCAL nColCab := 0                       // Columna del encabezado
       LOCAL bPagina := NIL                     // Block de P gina
       LOCAL bCabeza := NIL                     // Block de Encabezado
       LOCAL bDerAut := NIL                     // Block Derechos de Autor
       LOCAL nLinReg := 1                       // L¡neas del registro
       LOCAL cTxtPrn := ''                      // Texto de impresi¢n
       LOCAL nOpcPrn := xPrm(aDetInf,'nOpcPrn')	// Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		        // Detalles informes para www
       LOCAL lPrnCab := .T.                     // .T. Imprimir el Encabezado
     *ÀVariables de informe

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,2)
       AADD(aTitPrn,'IH')

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,140)
       AADD(aTitPrn,'AREAS Y ASIGNATURAS')

       AADD(aNroCol,8)
       AADD(aTitPrn,'NOTA')

       cCabCol := cRegPrint(aTitPrn,aNroCol)

       AADD(aDetInf,{'aTitPrn',aTitPrn})
       AADD(aDetInf,{'aNroCol',aNroCol})
       AADD(aDetInf,{'xCabCol',cCabCol})
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>DETALLES DEL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       AADD(aDetInf,{'nColPrn',nColCab})

       aCabSec := {}
       AADD(aCabSec,'ALUMNO: '+ALLTRIM(cNomEst))
       AADD(aCabSec,'CODIGO:' +cCodEst          +SPACE(02)+;
		    'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
				SUBS(cCodGru,3,2)+SPACE(02)+;
		    'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		    'A¥O:'    +cAnoUsr          +SPACE(01)+;
		    'JORNADA:'+cJorTxt          +SPACE(01)+;
		    'P gina No.'+LTRIM(STR(nNroPag)))

       AADD(aDetInf,{'aCabSec',aCabSec})

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabPrnIso(aP1,aP2,aP3,;
			       aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}

       AADD(aDetInf,{'bPagina',bPagina})
       AADD(aDetInf,{'bCabeza',bCabeza})
       AADD(aDetInf,{'bDerAut',bDerAut})
*>>>>FIN DETALLES DEL INFORME

*>>>>DETALLES DEL ENCABEZADO
       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl',nCabIso})
       AADD(aPrnWww,{'cCodInf',cCodInf})
       AADD(aPrnWww,{'cCodIso',cCodIso})
       AADD(aPrnWww,{'cFecIso',cFecIso})
       AADD(aPrnWww,{'cVerIso',cVerIso})
       AADD(aPrnWww,{'cPieUno',aPieIso[1]})
       AADD(aPrnWww,{'cPieDos',aPieIso[2]})
       AADD(aPrnWww,{'cPieTre',aPieIso[2]})

       FilePrn := xPrm(aDetInf,'FilePrn')
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn,aPrnWww)
       AADD(aDetInf,{'nHanXml',nHanXml})

       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN DETALLES DEL ENCABEZADO

*>>>>CUERPO DEL INFORME
       DO CASE
       CASE cJvfCal == '102'  // Indice de Cumplimiento. SalleBga

	    I102_25400(aP1,aP2,aP3,aDetInf)
	   *Indice de Cumplimiento

       CASE cJvfCal == '301'  // Indicadores promocionales. Virrey

	    I102_25400(aP1,aP2,aP3,aDetInf)
	   *Indicadores Promocionales

       CASE TCO->nMetodoTbl == 0  // Calculo de Areas. Notas Numericas

	    I102_25400(aP1,aP2,aP3,aDetInf)
	   *Juicios valorativos

       CASE TCO->nMetodoTbl == 99  // Notas N£mericas antes del decreto 230

	    I102_25499(aP1,aP2,aP3,aDetInf)
	   *Notas Numericas

       OTHERWISE

	    I102_25400(aP1,aP2,aP3,aDetInf)
	  *ÀPor defecto

       ENDCASE
*>>>>FIN CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       RESTSCREEN(0,0,24,79,cSavPan)
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       IF !EMPTY(oBrowse)
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: INDICE DE CUMPLIMIENTO. VERSION No.00                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 08/2008 LUN A
       Bucaramanga, Colombia	    INICIO: 03:05 PM   SEP 08/2008 LUN

OBJETIVOS:

1- Imprime el informe para validar los indices de cumplimiento.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION I102_25400(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
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
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL aArchvo := xPrm(aP3,'aArchvo') // Archivos para Uso
       LOCAL cOpcPrn := xPrm(aP3,'cOpcPrn') // Opciones de Impresi¢n.
       LOCAL nCodPrn := xPrm(aP3,'nCodPrn') // C¢digo de Impresi¢n
       LOCAL oBrowse := xPrm(aP3,'oBrowse') // Browse del Archivo

       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL cCodEst := xPrm(aP3,'cCodEst') // C¢digo del Estudiante
       LOCAL cNomEst := xPrm(aP3,'cNomEst') // Nombre del Estudiante
       LOCAL cCodGru := xPrm(aP3,'cCodGru') // C¢digo del Grupo
       LOCAL nNroLis := xPrm(aP3,'nNroLis') // N£mero de Lista
       LOCAL aNotAre := xPrm(aP3,'aNotAre') // Detalles de las areas
       LOCAL aNotMat := xPrm(aP3,'aNotMat') // Detalles de las materias
       LOCAL cJvfCal := xPrm(aP3,'cJvfCal') // Juicio Valorativo Calculado
       LOCAL nMetodo := xPrm(aP3,'nMetodo') // Metodo para los calculos de los promedios. Por defecto 0
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                       // Contadores
       LOCAL cUsrIso := ''                      // Usuario de la Iso
       LOCAL nNroInf := 0                       // N£mero del informe
       LOCAL cOpcSys := ''                      // Opci¢n del Sistema
       LOCAL cCodInf := xPrm(aDetInf,'cCodInf') // C¢digo del Informe
       LOCAL aMarInf := {}                      // L¡neas de Espaciado
       LOCAL nNroDoc := 0                       // N£mero del Documento variable
       LOCAL fDocPrn := ''                      // Archivo a imprimir
       LOCAL nCabIso := xPrm(aDetInf,'nCabIso')	// Encabezado del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso')	// C¢digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso')	// Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso')	// Versi¢n del Iso
       LOCAL aTitIso := ''                      // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                      // Pie de P gina por defecto
       LOCAL aPieIso := xPrm(aDetInf,'aPieIso')	// Textos del pie de p gina
       LOCAL nTotPie := 0                       // Total de Pie de p ginas
       LOCAL aObsIso := {}                      // Observaciones del informe
       LOCAL aMezIso := {}                      // Campos a Mesclar
       LOCAL bInsIso := NIL                     // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL FilePrn := xPrm(aDetInf,'FilePrn')	// Archivo de impresion
       LOCAL nHanXml := xPrm(aDetInf,'nHanXml')	// Manejador del Archivo
       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                       // N£mero de p gina
       LOCAL lTamAnc := .F.                     // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                       // L¡neas totales de control
       LOCAL nTotReg := 0                       // Total de registros
       LOCAL aCabPrn := xPrm(aDetInf,'aCabPrn')	// Encabezado del informe General
       LOCAL aCabeza := {}                      // Encabezado del informe
       LOCAL cCodIni := ''                      // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                      // C¢digos de impresi¢n finales
       LOCAL aNroCol := xPrm(aDetInf,'aNroCol')	// Columnas de impresi¢n
       LOCAL aTitPrn := xPrm(aDetInf,'aTitPrn')	// T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                      // Registros para impresi¢n
       LOCAL cCabCol := ''                      // Encabezado de Columna
       LOCAL aCabSec := {}                      // Encabezado Secundario
       LOCAL nLenPrn := 0                       // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                     // .T. Centrar el informe
       LOCAL nColCab := 0                       // Columna del encabezado
       LOCAL bPagina := xPrm(aDetInf,'bPagina')	// Block de P gina
       LOCAL bCabeza := xPrm(aDetInf,'bCabeza')	// Block de Encabezado
       LOCAL bDerAut := xPrm(aDetInf,'bDerAut')	// Block Derechos de Autor
       LOCAL nLinReg := 1                       // L¡neas del registro
       LOCAL cTxtPrn := ''                      // Texto de impresi¢n
       LOCAL nOpcPrn := xPrm(aDetInf,'nOpcPrn')	// Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		        // Detalles informes para www
       LOCAL lPrnCab := .T.                     // .T. Imprimir el Encabezado
     *ÀVariables de informe

       LOCAL    k,y,x := 0                       // Contadores

       LOCAL aAreas  := {}			// Areas
       LOCAL aMaters := {}			// Materias

       LOCAL aDetAre := {}                      // Detalles del Area
       LOCAL aDetMat := {}                      // Detalles de la Materia

       LOCAL aDbfMat := {}                      // Campos de Materias
       LOCAL aDbfPla := {}                      // Campos del Plan Academico
       LOCAL aDbfNot := {}                      // Campos de Notas
       LOCAL aDbfSel := {}                      // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                      // Campos Materias Variables

       LOCAL nNroOrd := 0                       // Orden en el Boletin
       LOCAL cCodAre := ''                      // C¢digo del Area
       LOCAL cAreMat := ''                      // C¢digo del Area de la Materia

       LOCAL aMatSel := {}                      // Materias Selectivas
       LOCAL aMatVar := {}                      // Materias Variables

       LOCAL cCodigo := ''                      // C¢digo del area
       LOCAL cCodMat := ''                      // C¢digo de la Materia
       LOCAL cMatVar := ''                      // C¢digo de la Materia Variable
       LOCAL nMatVar := 0                       // 0=>Materia Fija 1=>Materia Variable por Nivel 2=>Materia Variable por Grupo. Ej: Como Ludicas
       LOCAL lMatSel := .F.                     // .T. Materia Selectiva
       LOCAL cNomMat := ''                      // Nombre del Area o Materia

       LOCAL cIntens := ''                      // Intensidad
       LOCAL cNotDef := ''                      // Nota definitiva
       LOCAL cNotRec := ''                      // Nota de la Recuperaci¢n

       LOCAL aIndNot := {}                      // Indicadores
       LOCAL cIndNot := ''                      // Indicadores

       LOCAL aNotInd := {}                      // Nota de los Indicadores
       LOCAL cNotInd := ''                      // Nota de los Indicadores
       LOCAL Getlist := {}                      // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCamNotDef := ''                   // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''                   // Campo de Notas de Recuperaci¢n
       LOCAL cCamIndNot := ''                   // Campo de Indicadores
       LOCAL cCamJntNot := ''                   // Campo notas de los Indicadores
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       AreMatEst(@aAreas,@aMaters,nNroPer)

       FOR i := 1 TO LEN(aAreas)

**********DETALLES DEL AREA
	    nNroOrd := aAreas[i,1]
	    cCodAre := aAreas[i,2]
	    aDetAre := aAreas[i,3]

	    aDbfMat := xPrm(aDetAre,'aDbfMat')
	    aDbfPla := xPrm(aDetAre,'aDbfPla')
	    aDbfNot := xPrm(aDetAre,'aDbfNot')
**********DETALLES DEL AREA

**********IMPRESION DEL ENCABEZADO
	    IF lPrnCab

	       SET DEVICE TO PRINT

	       SendCodes(PCL('Reset'))

	       EVAL(bCabeza)
	      *Impresi¢n del Encabezado

	       lPrnCab := .F.

	       SET DEVICE TO SCREEN
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********AREAS NO PROMEDIABLES
	    cCamNotDef := xPrm(aDbfNot,'cNotas')

	    IF 'AREN' $ cCamNotDef

*==============INTENSIDAD Y NOMBRE DEL AREA
		 cIntens := xPrm(aDbfPla,'cIntHor')
		 IF VAL(cIntens) == 0
		    cIntens := SPACE(02)
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cCodMat := xPrm(aDbfMat,'cCodMat')
		 IF !EMPTY(xPrm(aDbfPla,'cPr'+cCodGru))
		    cNomMat := 'Prof:'+xPrm(aDbfPla,'cPr'+cCodGru)+':'+;
			       xPrm(aDbfMat,'cNombre')
		 ELSE
		    cNomMat := xPrm(aDbfMat,'cNombre')
		 ENDIF
		 cNomMat := SUBS(cNomMat+SPACE(140),1,140)
*==============FIN INTENSIDAD Y NOMBRE DEL AREA

*==============IMPRESION DEL REGISTRO
		 aRegPrn := {}
		 AADD(aRegPrn,cIntens)
		 AADD(aRegPrn,cCodMat)
		 AADD(aRegPrn,cNomMat)

*----------------LECTURA DE LA NOTA DEL AREA
		   cCamNotDef := xPrm(aDbfNot,'cNotas')
		   cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		   FOR k := 1 TO 1 // Pendiente
		       cNotDef := SUBS(&cCamNotDef,k*4-3,4)
		       cNotRec := SUBS(&cCamNotRec,k*4-3,4)
		       AADD(aRegPrn,cNotDef+cNotRec)
		   ENDFOR
*----------------FIN LECTURA DE LA NOTA DEL AREA

		 lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*==============FIN IMPRESION DEL REGISTRO

	    ENDIF
**********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS DEL AREA
	    FOR j := 1 TO LEN(aMaters)

		cAreMat := aMaters[j,1]

		IF cCodAre == cAreMat

*==================DETALLES DE LA MATERIA
		     cAreMat := aMaters[j,1]
		     aDetMat := aMaters[j,2]

		     aDbfMat := xPrm(aDetMat,'aDbfMat')
		     aDbfPla := xPrm(aDetMat,'aDbfPla')
		     aDbfNot := xPrm(aDetMat,'aDbfNot')

		     aMatSel := xPrm(aDetMat,'aMatSel')
*==================FIN DETALLES DE LA MATERIA

*==================INTENSIDAD Y NOMBRE DEL AREA
		     cIntens := xPrm(aDbfPla,'cIntHor')
		     IF VAL(cIntens) == 0
			cIntens := SPACE(02)
		     ENDIF
		   *ÀLectura de la Intensidad horaria

		     cCodMat := xPrm(aDbfMat,'cCodMat')
		     IF !EMPTY(xPrm(aDbfPla,'cPr'+cCodGru))
			cNomMat := 'Prof:'+xPrm(aDbfPla,'cPr'+cCodGru)+':'+;
				   xPrm(aDbfMat,'cNombre')
		     ELSE
			cNomMat := xPrm(aDbfMat,'cNombre')
		     ENDIF
		     cNomMat := SUBS(cNomMat+SPACE(140),1,140)

		     IF cAreMat == cCodigo .AND. SUBS(xPrm(aDbfNot,'cCodMat'),3,2) # '00'
			cNomMat := SUBS(SPACE(02)+cNomMat,1,140)
		     ELSE
			cCodigo := cAreMat
		     ENDIF
		   *ÀIndentaci¢n de la materia
*==================FIN INTENSIDAD Y NOMBRE DEL AREA

*=================IMPRESION DEL REGISTRO
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cCodMat)
		    AADD(aRegPrn,cNomMat)
		    AADD(aRegPrn,'')

		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*=================FIN IMPRESION DEL REGISTRO

*=================IMPRESION POR PERIODOS
		    FOR k := 1 TO TCO->nTotPerTbl

*-----------------------INDICADORES DEL PERIODO
			  cNotDef := ''
			  cNotRec := ''

			  cCamNotDef := xPrm(aDbfNot,'cNotas')
			  cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			  cNotDef := SUBS(&cCamNotDef,k*4-3,4)
			  cNotRec := SUBS(&cCamNotRec,k*4-3,4)

			  cCamIndNot := xPrm(aDbfNot,'cIndica'+STR(k,1))
			  aIndNot    := aJuicio(&cCamIndNot)

			  cIndNot := ''
			  FOR y := 1 TO LEN(aIndNot)
			      cIndNot += aIndNot[y]+SPACE(01)
			  ENDFOR
			  cIndNot := SUBS(cIndNot+SPACE(140),1,140)

			  IF !EMPTY(cIndNot) .OR. !EMPTY(cNotDef)

			     aRegPrn := {}
			     AADD(aRegPrn,'')
			     AADD(aRegPrn,'P'+STR(k,1))
			     AADD(aRegPrn,cIndNot)
			     AADD(aRegPrn,cNotDef+cNotRec)

			     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				     nColCab,aTitPrn,aRegPrn,aNroCol,;
				     bPagina,bDerAut,bCabeza)

			  ENDIF
*-----------------------FIN INDICADORES DEL PERIODO

*-----------------------NOTAS DE LOS INDICADORES
			  IF lHayJnt(TCO->cEvaIndTbl)

			     cCamJntNot := xPrm(aDbfNot,'cNotInd'+STR(k,1))
			     aNotInd    := aJuicio(&cCamJntNot,.F.,4)

			     cNotInd := ''
			     FOR y := 1 TO LEN(aNotInd)
				 cNotInd += SPACE(01)+aNotInd[y]+SPACE(02)
			     ENDFOR
			     cNotInd := SUBS(cNotInd+SPACE(140),1,140)

			     IF !EMPTY(cNotInd)

				aRegPrn := {}
				AADD(aRegPrn,'')
				AADD(aRegPrn,'P'+STR(k,1))
				AADD(aRegPrn,cNotInd)
				AADD(aRegPrn,'')

				lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					nColCab,aTitPrn,aRegPrn,aNroCol,;
					bPagina,bDerAut,bCabeza)

			     ENDIF

			  ENDIF
*-----------------------FIN NOTAS DE LOS INDICADORES

		    ENDFOR
*=================FIN IMPRESION POR PERIODOS

*=================IMPRESION MATERIAS VARIABLES
		    IF LEN(aMatSel) # 0

*----------------------MATERIAS SELECTIVAS
			 aDbfSel := xPrm(aMatSel,'aDbfSel')
			 aMatVar := xPrm(aMatSel,'aMatVar')

			 FOR k := 1 TO TCO->nTotPerTbl

				   x := xPrm(aMatVar,STR(k,1))
			     aDbfVar := xPrm(aMatVar,'aDbfVa'+STR(k,1))

			     IF LEN(aDbfVar) # 0

				cNomMat := xPrm(aDbfVar,'cNombre')
				cNomMat := SPACE(04)+'P'+STR(x,1)+':'+cNomMat
				cNomMat := SUBS(cNomMat+SPACE(140),1,140)

				aRegPrn := {}
				AADD(aRegPrn,'')  // Intensidad
				AADD(aRegPrn,xPrm(aDbfVar,'cCodMat'))
				AADD(aRegPrn,cNomMat)
				AADD(aRegPrn,'')  // P1

				lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					nColCab,aTitPrn,aRegPrn,aNroCol,;
					bPagina,bDerAut,bCabeza)

			     ENDIF

			 ENDFOR
*----------------------FIN MATERIAS SELECTIVAS

		    ENDIF
*=================FIN IMPRESION MATERIAS VARIABLES


	       ENDIF
	     *ÀIF cCodAre == cAreMat

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS DEL AREA

       ENDFOR
*>>>>FIN RECORRIDO POR AREAS

/*************************************************************************
* TITULO..: RESUMEN DEL CAMPO DE NOTAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 28/2012 MAR A
       Bucaramanga, Colombia	    INICIO: 11:45 PM   AGO 28/2012 MAR

OBJETIVOS:

1- Imprime el informe con las notas actuales que figuran en las tablas

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION I102_25499(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
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
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL aArchvo := xPrm(aP3,'aArchvo') // Archivos para Uso
       LOCAL cOpcPrn := xPrm(aP3,'cOpcPrn') // Opciones de Impresi¢n.
       LOCAL nCodPrn := xPrm(aP3,'nCodPrn') // C¢digo de Impresi¢n
       LOCAL oBrowse := xPrm(aP3,'oBrowse') // Browse del Archivo

       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL cCodEst := xPrm(aP3,'cCodEst') // C¢digo del Estudiante
       LOCAL cNomEst := xPrm(aP3,'cNomEst') // Nombre del Estudiante
       LOCAL cCodGru := xPrm(aP3,'cCodGru') // C¢digo del Grupo
       LOCAL nNroLis := xPrm(aP3,'nNroLis') // N£mero de Lista
       LOCAL aNotAre := xPrm(aP3,'aNotAre') // Detalles de las areas
       LOCAL aNotMat := xPrm(aP3,'aNotMat') // Detalles de las materias
       LOCAL cJvfCal := xPrm(aP3,'cJvfCal') // Juicio Valorativo Calculado
       LOCAL nMetodo := xPrm(aP3,'nMetodo') // Metodo para los calculos de los promedios. Por defecto 0
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                       // Contadores
       LOCAL cUsrIso := ''                      // Usuario de la Iso
       LOCAL nNroInf := 0                       // N£mero del informe
       LOCAL cOpcSys := ''                      // Opci¢n del Sistema
       LOCAL cCodInf := xPrm(aDetInf,'cCodInf') // C¢digo del Informe
       LOCAL aMarInf := {}                      // L¡neas de Espaciado
       LOCAL nNroDoc := 0                       // N£mero del Documento variable
       LOCAL fDocPrn := ''                      // Archivo a imprimir
       LOCAL nCabIso := xPrm(aDetInf,'nCabIso')	// Encabezado del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso')	// C¢digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso')	// Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso')	// Versi¢n del Iso
       LOCAL aTitIso := ''                      // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                      // Pie de P gina por defecto
       LOCAL aPieIso := xPrm(aDetInf,'aPieIso')	// Textos del pie de p gina
       LOCAL nTotPie := 0                       // Total de Pie de p ginas
       LOCAL aObsIso := {}                      // Observaciones del informe
       LOCAL aMezIso := {}                      // Campos a Mesclar
       LOCAL bInsIso := NIL                     // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL FilePrn := xPrm(aDetInf,'FilePrn')	// Archivo de impresion
       LOCAL nHanXml := xPrm(aDetInf,'nHanXml')	// Manejador del Archivo
       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                       // N£mero de p gina
       LOCAL lTamAnc := .F.                     // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                       // L¡neas totales de control
       LOCAL nTotReg := 0                       // Total de registros
       LOCAL aCabPrn := xPrm(aDetInf,'aCabPrn')	// Encabezado del informe General
       LOCAL aCabeza := {}                      // Encabezado del informe
       LOCAL cCodIni := ''                      // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                      // C¢digos de impresi¢n finales
       LOCAL aNroCol := xPrm(aDetInf,'aNroCol')	// Columnas de impresi¢n
       LOCAL aTitPrn := xPrm(aDetInf,'aTitPrn')	// T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                      // Registros para impresi¢n
       LOCAL cCabCol := ''                      // Encabezado de Columna
       LOCAL aCabSec := {}                      // Encabezado Secundario
       LOCAL nLenPrn := 0                       // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                     // .T. Centrar el informe
       LOCAL nColCab := 0                       // Columna del encabezado
       LOCAL bPagina := xPrm(aDetInf,'bPagina')	// Block de P gina
       LOCAL bCabeza := xPrm(aDetInf,'bCabeza')	// Block de Encabezado
       LOCAL bDerAut := xPrm(aDetInf,'bDerAut')	// Block Derechos de Autor
       LOCAL nLinReg := 1                       // L¡neas del registro
       LOCAL cTxtPrn := ''                      // Texto de impresi¢n
       LOCAL nOpcPrn := xPrm(aDetInf,'nOpcPrn')	// Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		        // Detalles informes para www
       LOCAL lPrnCab := .T.                     // .T. Imprimir el Encabezado
     *ÀVariables de informe

       LOCAL    k,y,x := 0                       // Contadores

       LOCAL aAreas  := {}			// Areas
       LOCAL aMaters := {}			// Materias

       LOCAL aDetAre := {}                      // Detalles del Area
       LOCAL aDetMat := {}                      // Detalles de la Materia

       LOCAL aDbfMat := {}                      // Campos de Materias
       LOCAL aDbfPla := {}                      // Campos del Plan Academico
       LOCAL aDbfNot := {}                      // Campos de Notas
       LOCAL aDbfSel := {}                      // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                      // Campos Materias Variables

       LOCAL nNroOrd := 0                       // Orden en el Boletin
       LOCAL cCodAre := ''                      // C¢digo del Area
       LOCAL cAreMat := ''                      // C¢digo del Area de la Materia

       LOCAL aMatSel := {}                      // Materias Selectivas
       LOCAL aMatVar := {}                      // Materias Variables

       LOCAL cCodigo := ''                      // C¢digo del area
       LOCAL cCodMat := ''                      // C¢digo de la Materia
       LOCAL cMatVar := ''                      // C¢digo de la Materia Variable
       LOCAL nMatVar := 0                       // 0=>Materia Fija 1=>Materia Variable por Nivel 2=>Materia Variable por Grupo. Ej: Como Ludicas
       LOCAL lMatSel := .F.                     // .T. Materia Selectiva
       LOCAL cNomMat := ''                      // Nombre del Area o Materia

       LOCAL cIntens := ''                      // Intensidad
       LOCAL cNotDef := ''                      // Nota definitiva
       LOCAL cNotRec := ''                      // Nota de la Recuperaci¢n

       LOCAL aIndNot := {}                      // Indicadores
       LOCAL cIndNot := ''                      // Indicadores

       LOCAL aNotInd := {}                      // Nota de los Indicadores
       LOCAL cNotInd := ''                      // Nota de los Indicadores
       LOCAL Getlist := {}                      // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCamNotDef := ''                   // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''                   // Campo de Notas de Recuperaci¢n
       LOCAL cCamIndNot := ''                   // Campo de Indicadores
       LOCAL cCamJntNot := ''                   // Campo notas de los Indicadores
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       AreMatEst(@aAreas,@aMaters,nNroPer)

       FOR i := 1 TO LEN(aAreas)

**********DETALLES DEL AREA
	    nNroOrd := aAreas[i,1]
	    cCodAre := aAreas[i,2]
	    aDetAre := aAreas[i,3]

	    aDbfMat := xPrm(aDetAre,'aDbfMat')
	    aDbfPla := xPrm(aDetAre,'aDbfPla')
	    aDbfNot := xPrm(aDetAre,'aDbfNot')
**********DETALLES DEL AREA

**********IMPRESION DEL ENCABEZADO
	    IF lPrnCab

	       SET DEVICE TO PRINT

	       SendCodes(PCL('Reset'))

	       EVAL(bCabeza)
	      *Impresi¢n del Encabezado

	       lPrnCab := .F.

	       SET DEVICE TO SCREEN
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********AREAS NO PROMEDIABLES
	    cCamNotDef := xPrm(aDbfNot,'cNotas')

	    IF 'AREN' $ cCamNotDef

*==============INTENSIDAD Y NOMBRE DEL AREA
		 cIntens := xPrm(aDbfPla,'cIntHor')
		 IF VAL(cIntens) == 0
		    cIntens := SPACE(02)
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cCodMat := xPrm(aDbfMat,'cCodMat')
		 IF !EMPTY(xPrm(aDbfPla,'cPr'+cCodGru))
		    cNomMat := 'Prof:'+xPrm(aDbfPla,'cPr'+cCodGru)+':'+;
			       xPrm(aDbfMat,'cNombre')
		 ELSE
		    cNomMat := xPrm(aDbfMat,'cNombre')
		 ENDIF
		 cNomMat := SUBS(cNomMat+SPACE(140),1,140)
*==============FIN INTENSIDAD Y NOMBRE DEL AREA

*==============IMPRESION DEL REGISTRO
		 aRegPrn := {}
		 AADD(aRegPrn,cIntens)
		 AADD(aRegPrn,cCodMat)
		 AADD(aRegPrn,cNomMat)

*----------------LECTURA DE LA NOTA DEL AREA
		   cCamNotDef := xPrm(aDbfNot,'cNotas')
		   cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		   FOR k := 1 TO 1 // Pendiente
		       cNotDef := SUBS(&cCamNotDef,k*4-3,4)
		       cNotRec := SUBS(&cCamNotRec,k*4-3,4)
		       AADD(aRegPrn,cNotDef+cNotRec)
		   ENDFOR
*----------------FIN LECTURA DE LA NOTA DEL AREA

		 lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*==============FIN IMPRESION DEL REGISTRO

	    ENDIF
**********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS DEL AREA
	    FOR j := 1 TO LEN(aMaters)

		cAreMat := aMaters[j,1]

		IF cCodAre == cAreMat

*==================DETALLES DE LA MATERIA
		     cAreMat := aMaters[j,1]
		     aDetMat := aMaters[j,2]

		     aDbfMat := xPrm(aDetMat,'aDbfMat')
		     aDbfPla := xPrm(aDetMat,'aDbfPla')
		     aDbfNot := xPrm(aDetMat,'aDbfNot')

		     aMatSel := xPrm(aDetMat,'aMatSel')
*==================FIN DETALLES DE LA MATERIA

*==================INTENSIDAD Y NOMBRE DEL AREA
		     cIntens := xPrm(aDbfPla,'cIntHor')
		     IF VAL(cIntens) == 0
			cIntens := SPACE(02)
		     ENDIF
		   *ÀLectura de la Intensidad horaria

		     cCodMat := xPrm(aDbfMat,'cCodMat')
		     IF !EMPTY(xPrm(aDbfPla,'cPr'+cCodGru))
			cNomMat := 'Prof:'+xPrm(aDbfPla,'cPr'+cCodGru)+':'+;
				   xPrm(aDbfMat,'cNombre')
		     ELSE
			cNomMat := xPrm(aDbfMat,'cNombre')
		     ENDIF
		     cNomMat := SUBS(cNomMat+SPACE(140),1,140)

		     IF cAreMat == cCodigo .AND. SUBS(xPrm(aDbfNot,'cCodMat'),3,2) # '00'
			cNomMat := SUBS(SPACE(02)+cNomMat,1,140)
		     ELSE
			cCodigo := cAreMat
		     ENDIF
		   *ÀIndentaci¢n de la materia
*==================FIN INTENSIDAD Y NOMBRE DEL AREA

*=================IMPRESION DEL REGISTRO
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cCodMat)
		    AADD(aRegPrn,cNomMat)
		    AADD(aRegPrn,'')

		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*=================FIN IMPRESION DEL REGISTRO

*=================IMPRESION POR PERIODOS
		    FOR k := 1 TO TCO->nTotPerTbl

*-----------------------INDICADORES DEL PERIODO
			  cNotDef := ''
			  cNotRec := ''

			  cCamNotDef := xPrm(aDbfNot,'cNotas')
			  cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			  cNotDef := SUBS(&cCamNotDef,k*4-3,4)
			  cNotRec := SUBS(&cCamNotRec,k*4-3,4)

			  cCamIndNot := xPrm(aDbfNot,'cIndica'+STR(k,1))
			  aIndNot    := aJuicio(&cCamIndNot)

			  cIndNot := ''
			  FOR y := 1 TO LEN(aIndNot)
			      cIndNot += aIndNot[y]+SPACE(01)
			  ENDFOR
			  cIndNot := SUBS(cIndNot+SPACE(140),1,140)

			  IF !EMPTY(cIndNot) .OR. !EMPTY(cNotDef)

			     aRegPrn := {}
			     AADD(aRegPrn,'')
			     AADD(aRegPrn,'P'+STR(k,1))
			     AADD(aRegPrn,cIndNot)
			     AADD(aRegPrn,cNotDef+cNotRec)

			     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				     nColCab,aTitPrn,aRegPrn,aNroCol,;
				     bPagina,bDerAut,bCabeza)

			  ENDIF
*-----------------------FIN INDICADORES DEL PERIODO

*-----------------------NOTAS DE LOS INDICADORES
			  IF lHayJnt(TCO->cEvaIndTbl)

			     cCamJntNot := xPrm(aDbfNot,'cNotInd'+STR(k,1))
			     aNotInd    := aJuicio(&cCamJntNot,.F.,4)

			     cNotInd := ''
			     FOR y := 1 TO LEN(aNotInd)
				 cNotInd += SPACE(01)+aNotInd[y]+SPACE(02)
			     ENDFOR
			     cNotInd := SUBS(cNotInd+SPACE(140),1,140)

			     IF !EMPTY(cNotInd)

				aRegPrn := {}
				AADD(aRegPrn,'')
				AADD(aRegPrn,'P'+STR(k,1))
				AADD(aRegPrn,cNotInd)
				AADD(aRegPrn,'')

				lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					nColCab,aTitPrn,aRegPrn,aNroCol,;
					bPagina,bDerAut,bCabeza)

			     ENDIF

			  ENDIF
*-----------------------FIN NOTAS DE LOS INDICADORES

		    ENDFOR
*=================FIN IMPRESION POR PERIODOS

*=================IMPRESION MATERIAS VARIABLES
		    IF LEN(aMatSel) # 0

*----------------------MATERIAS SELECTIVAS
			 aDbfSel := xPrm(aMatSel,'aDbfSel')
			 aMatVar := xPrm(aMatSel,'aMatVar')


			 FOR k := 1 TO TCO->nTotPerTbl

				   x := xPrm(aMatVar,STR(k,1),0)

			     aDbfVar := xPrm(aMatVar,'aDbfVa'+STR(k,1))

			     IF LEN(aDbfVar) # 0

				cNomMat := xPrm(aDbfVar,'cNombre')
				cNomMat := SPACE(04)+'P'+STR(x,1)+':'+cNomMat
				cNomMat := SUBS(cNomMat+SPACE(140),1,140)

				aRegPrn := {}
				AADD(aRegPrn,'')  // Intensidad
				AADD(aRegPrn,xPrm(aDbfVar,'cCodMat'))
				AADD(aRegPrn,cNomMat)
				AADD(aRegPrn,'')  // P1

				lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					nColCab,aTitPrn,aRegPrn,aNroCol,;
					bPagina,bDerAut,bCabeza)

			     ENDIF

			 ENDFOR
*----------------------FIN MATERIAS SELECTIVAS

		    ENDIF
*=================FIN IMPRESION MATERIAS VARIABLES


	       ENDIF
	     *ÀIF cCodAre == cAreMat

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS DEL AREA

       ENDFOR
*>>>>FIN RECORRIDO POR AREAS


