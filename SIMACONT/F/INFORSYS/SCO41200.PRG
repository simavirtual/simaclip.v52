/*************************************************************************
* TITULO..: INDICADORES PENDIENTES                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/2008 MIE A
       Bucaramanga, Colombia	    INICIO: 06:00 PM   OCT 15/2008 MIE

OBJETIVOS:

1- Imprime el informe de los indicadores pendientes de los estudiantes

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SCO_41200(aP1,aP2,aP3)

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

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := xPrm(aP3,'nNroInf')
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := xPrm(aP3,'cOpcSys')
     *ÀOpci¢n del sistema del informe

       cCodInf := xPrm(aP3,'cCodInf')
       AADD(aDetInf,{'cCodInf',cCodInf})
     *ÀC¢digo del Informe

       aMarInf := xPrm(aP3,'aMarInf')
       AADD(aDetInf,{'aMarInf',aMarInf})
     *ÀM rgenes del informe

       nNroDoc := xPrm(aP3,'nNroDoc')
     *ÀInforme por defecto

       aMezIso := xPrm(aP3,'aMezIso')
     *ÀCampos a sustituir

       aTitIso := xPrm(aP3,'aTitIso')
       AADD(aDetInf,{'aTitIso',aTitIso})
     *ÀT¡tulos del Informe por defecto

       aPieIso := xPrm(aP3,'aPieIso')
       AADD(aDetInf,{'aPieIso',aPieIso})
     *ÀPie de p ginas por defecto

       aObsIso := xPrm(aP3,'aObsIso')
     *ÀObservaciones

       cUsrIso := xPrm(aP3,'cUsrIso')
       bInsIso := xPrm(aP3,'bInsIso')
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       FilePrn := xPrm(aP3,'FilePrn')
       nOpcPrn := xPrm(aP3,'nOpcPrn')

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
       CASE UPPER(cCodInf) == 'SCO41200'

	    SCO_412_00(aP1,aP2,aP3,aDetInf)
	  *ÀInforme por defecto.

       OTHERWISE
	    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
       ENDCASE
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

FUNCTION SCO_412_00(aP1,aP2,aP3,aDetInf)

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
       LOCAL nNroPer := xPrm(aP3,'nNroPer') // N£mero del Periodo
       LOCAL nNroIni := xPrm(aP3,'nNroIni') // N£mero de lista inicial
       LOCAL nNroFin := xPrm(aP3,'nNroFin') // N£mero de lista final
       LOCAL cGruFin := xPrm(aP3,'cGruFin') // C¢digo del grupo final

       LOCAL lEvaInd := xPrm(aP3,'lEvaInd') // .T. Evaluar el indicador
       LOCAL lHayItv := xPrm(aP3,'lHayItv') // .T. Nota Numerica por Intervalo de Juicios valorativos
       LOCAL lRecNot := xPrm(aP3,'lRecNot') // .T. Recuperar el Juicio Valorativo
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
       LOCAL nHanXml := xPrm(aP3,'nHanXml')	// Manejador del Archivo
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

       LOCAL       k := 0                   // Contador
       LOCAL lSiorNo := .F.                 // Control de flujo

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n

       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL aNroDif := 0                   // Numero de Dificultades
       LOCAL nTotDif := 0                   // Total de dificultades
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCamIndNot := ''               // Campo de Indicadores
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,2)
       AADD(aTitPrn,'No')

       AADD(aNroCol,30)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')

       AADD(aNroCol,80)
       AADD(aTitPrn,'ASIGNATURAS CON PENDIENTES')

       FOR k := 1 TO nNroPer
	   AADD(aNroCol,02)
	   AADD(aTitPrn,'P'+STR(k,1))
       ENDFOR
       AADD(aNroCol,04)
       AADD(aTitPrn,'JUICIO')

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
       AADD(aDetInf,{'aCabSec',aCabSec})

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabPrnIso(aP1,aP2,aP3,;
			       aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||PiePagIso(aPieIso,nLenPrn)}

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

       IF nHanXml < 0
	  nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
				nOpcPrn,aCabPrn,aTitPrn,aPrnWww)
	  nParameSet(aP3,'nHanXml',nHanXml)
       ENDIF
       AADD(aDetInf,{'nHanXml',nHanXml})

       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN DETALLES DEL ENCABEZADO

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>CUERPO DEL INFORME
       SELECT NOT
       NOT->(DBGOTO(nNroIni))
       DO WHILE .NOT. NOT->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('PERIODO: '+STR(nNroPer,2)+'º'+;
			'GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+' No. '+;
			 NOT->(STR(RECNO(),2))+'/'+;
			 NOT->(STR(RECCOUNT(),2)),cNomSis)
**********FIN LINEA DE ESTADO

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
	    IF lRetiroTes
	       cNombreTes := SUBS('R:'+cNombreTes+SPACE(30),1,30)
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********RECORRIDO POR AREAS
	    lSiorNo := .F.
	    FOR i := 1 TO LEN(aNotAre)

*===============ANALISIS DE LA MATERIA NO RECUPERABLE
		  IF aNotAre[i][15]
		     LOOP
		  ENDIF
*===============FIN ANALISIS DE LA MATERIA NO RECUPERABLE

*===============AREA NO PROMEDIABLE
		  IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------------NOTA DEFINITIVA DEL AREA
		       cCamNotDef := aNotAre[i,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		       cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		       IF lHayItv
			  cNotDef := cNotDefJvf(VAL(cNotDef))
			  cNotRec := cNotDefJvf(VAL(cNotRec))
		       ENDIF

		       IF lRecNot .AND. !EMPTY(cNotRec)
			  cNotDef := cNotRec
		       ENDIF
*--------------------FIN NOTA DEFINITIVA DEL AREA

*--------------------INDICADORES POR RECUPERAR AREA
		       nNroDif := 0
		       aNroDif := {}
		       nTotDif := 0
		       cCamIndNot := aNotAre[i,6]
		       FOR k := 1 TO nNroPer

*::::::::::::::::::::::::::INDICADORES PERIODO POR RECUPERAR AREA
			     cCamIndNot := STUFF(cCamIndNot,8,1,STR(k,1))

			     cJuicio := ALLTRIM(&cCamIndNot)+SPACE(02)
			     cSiRecu := ''
			     cNoRecu := ''
			     IndRecSiNo(cJuicio,lEvaInd,@cSiRecu,@cNoRecu,.F.)

			     aJuicio := aJuicio(@cNoRecu,TCO->lNoSortTbl)

			     nNroDif := LEN(aJuicio)
			     AADD(aNroDif,nNroDif)

			     nTotDif += nNroDif
*::::::::::::::::::::::::::FIN INDICADORES PERIODO POR RECUPERAR AREA

		       ENDFOR
*--------------------FIN INDICADORES POR RECUPERAR AREA

*--------------------IMPRESION DEL ENCABEZADO
		       IF nTotDif # 0 .AND. lPrnCab

			  SET DEVICE TO PRINT

			  SendCodes(PCL('Reset'))

			  EVAL(bCabeza)
			 *Impresi¢n del Encabezado

			  lPrnCab := .F.

			  SET DEVICE TO SCREEN
		       ENDIF
*--------------------FIN IMPRESION DEL ENCABEZADO

*--------------------IMPRESION DEL REGISTRO AREA
		       IF nTotDif # 0
			  aRegPrn := {}
			  IF !lSiorNo
			     AADD(aRegPrn,NOT->cCodigoEst)
			     AADD(aRegPrn,&cMaeAct->cCodigoGru)
			     AADD(aRegPrn,STR(NOT->(RECNO()),2))
			     AADD(aRegPrn,cNombreTes)
			  ELSE
			     AADD(aRegPrn,'')
			     AADD(aRegPrn,'')
			     AADD(aRegPrn,'')
			     AADD(aRegPrn,'')
			  ENDIF
			  AADD(aRegPrn,aNotAre[i,10])
			  FOR k := 1 TO nNroPer
			      AADD(aRegPrn,STR(aNroDif[k],1))
			  ENDFOR
			  AADD(aRegPrn,cNotDef+':'+STR(nTotDif,2))

			  lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,;
				     01,nColCab,aTitPrn,aRegPrn,aNroCol,;
				     bPagina,bDerAut,bCabeza)
		       ENDIF
*--------------------FIN IMPRESION DEL REGISTRO AREA

		  ENDIF
*===============FIN AREA NO PROMEDIABLE

*===============RECORRIDO POR MATERIAS
		  FOR j := 1 TO LEN(aNotMat)

*---------------------ANALISIS DE LA MATERIA NO RECUPERABLE
			IF aNotMat[j,15]
			   LOOP
			ENDIF
*---------------------FIN ANALISIS DE LA MATERIA NO RECUPERABLE

*---------------------ANALISIS DE LA MATERIA
			IF aNotAre[i,2] == aNotMat[j,1]

*::::::::::::::::::::::::::NOTA DEFINITIVA DE LA MATERIA
			     cCamNotDef := aNotMat[j,4]
			     cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

			     cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))

			     cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
			     IF lHayItv
				cNotDef := cNotDefJvf(VAL(cNotDef))
				cNotRec := cNotDefJvf(VAL(cNotRec))
			     ENDIF

			     IF lRecNot .AND. !EMPTY(cNotRec)
				cNotDef := cNotRec
			     ENDIF
*::::::::::::::::::::::::::FIN NOTA DEFINITIVA DE LA MATERIA

*::::::::::::::::::::::::::INDICADORES POR RECUPERAR MATERIA
			     nNroDif := 0
			     aNroDif := {}
			     nTotDif := 0
			     cCamIndNot := aNotMat[j,5]
			     FOR k := 1 TO nNroPer

*................................INDICADORES PERIODO POR RECUPERAR MATERIA
				   cCamIndNot := STUFF(cCamIndNot,8,1,;
								  STR(k,1))

				   cJuicio := ALLTRIM(&cCamIndNot)+SPACE(02)
				   cSiRecu := ''
				   cNoRecu := ''
				   IndRecSiNo(cJuicio,lEvaInd,;
					      @cSiRecu,@cNoRecu,.F.)

				   aJuicio := aJuicio(@cNoRecu,;
						      TCO->lNoSortTbl)

				   nNroDif := LEN(aJuicio)
				   AADD(aNroDif,nNroDif)

				   nTotDif += nNroDif
*................................FIN INDICADORES PERIODO POR RECUPERAR MATERIA

			     ENDFOR
*::::::::::::::::::::::::::FIN INDICADORES POR RECUPERAR MATERIA

*::::::::::::::::::::::::::IMPRESION DEL ENCABEZADO
			     IF nTotDif # 0 .AND. lPrnCab

				SET DEVICE TO PRINT

				SendCodes(PCL('Reset'))

				EVAL(bCabeza)
			       *Impresi¢n del Encabezado

				lPrnCab := .F.

				SET DEVICE TO SCREEN
			     ENDIF
*::::::::::::::::::::::::::FIN IMPRESION DEL ENCABEZADO

*::::::::::::::::::::::::::IMPRESION DEL REGISTRO MATERIA
			     IF nTotDif # 0
				aRegPrn := {}
				IF !lSiorNo
				   AADD(aRegPrn,NOT->cCodigoEst)
				   AADD(aRegPrn,&cMaeAct->cCodigoGru)
				   AADD(aRegPrn,STR(NOT->(RECNO()),2))
				   AADD(aRegPrn,cNombreTes)
				   lSiorNo := .T.
				ELSE
				   AADD(aRegPrn,'')
				   AADD(aRegPrn,'')
				   AADD(aRegPrn,'')
				   AADD(aRegPrn,'')
				ENDIF
				AADD(aRegPrn,aNotMat[j,10])
				FOR k := 1 TO nNroPer
				    AADD(aRegPrn,STR(aNroDif[k],1))
				ENDFOR
				AADD(aRegPrn,cNotDef+':'+STR(nTotDif,2))

				lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,;
					   01,nColCab,aTitPrn,aRegPrn,aNroCol,;
					   bPagina,bDerAut,bCabeza)
			     ENDIF
*::::::::::::::::::::::::::FIN IMPRESION DEL REGISTRO MATERIA

			ENDIF
*---------------------FIN ANALISIS DE LA MATERIA

		  ENDFOR
*===============FIN RECORRIDO POR ASIGNATURAS

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS

	  NOT->(DBSKIP())

       ENDDO
*>>>>FIN CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       RESTSCREEN(0,0,24,79,cSavPan)
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


