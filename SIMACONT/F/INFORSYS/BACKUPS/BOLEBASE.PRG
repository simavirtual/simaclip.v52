/*************************************************************************
* TITULO..: BOLETIN INDICE DE CUMPLIMIENTO                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 17/2008 VIE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   OCT 17/2008 VIE

OBJETIVOS:

1- Imprime el boletin para un estudiante.

2- Dise¤ado especialmente para los indices de cumplimiento del Colegio
   la Salle Bucaramanga.

3- Boletin de tipo especifico:

   - Si no tiene juicio valorativo en el periodo imprime el primero que
     encuentre de periodos anteriores, si no encuentra lo imprime en
     Blanco.

   - Imprime los juicios valorativos de forma no estandar, es decir ubicados
     de acuerdo al requerimiento del Colegio.

4- Imprime la juicios valorativos, items de evaluaci¢n, control de las
   recuperaciones, etc.

5- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ScoBol_97(aP1,aP2,aP3)

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
       LOCAL cGerent := xPrm(aP2,'cGerent') // Nombre del Gerente o Rector Actual
       LOCAL cCarGer := xPrm(aP2,'cCarGer') // Nombre del Cargo

       LOCAL lOficio := xPrm(aP2,'lOficio') // Tama¤o del Papel. Carta o Oficio
       LOCAL cTxtTop := xPrm(aP2,'cTxtTop') // Texto Top del Boletin o libro
       LOCAL cTitTop := xPrm(aP2,'cTitTop') // Titulo Top del Boletin o libro
       LOCAL nLinEsp := xPrm(aP2,'nLinEsp') // N£mero de l¡neas del encabezado del boletin
       LOCAL lPrnEmp := xPrm(aP2,'lPrnEmp') // .T. Imprimir la Empresa en el Boletin
       LOCAL cNroFol := xPrm(aP2,'cNroFol') // N£mero del folio

       LOCAL nColEnc := xPrm(aP2,'nColEnc') // N£mero de Columnas para el encabezado del Boletin
       LOCAL nColBol := xPrm(aP2,'nColBol') // N£mero de Columnas para el cuerpo del Boletin
       LOCAL nTotLin := xPrm(aP2,'nTotLin') // L¡neas por p gina

       LOCAL cMsgBol := xPrm(aP2,'cMsgBol') // Mensaje para el boletin
       LOCAL cCfgBol := xPrm(aP2,'cCfgBol') // Otra Configuraci¢n Boletin
       LOCAL cTotAus := xPrm(aP2,'cTotAus') // Total de Ausencias
       LOCAL lNegAre := xPrm(aP2,'lNegAre') // .T. Imprimir en negrilla el  rea

       LOCAL nTotPer := xPrm(aP2,'nTotPer') // Total Periodos
       LOCAL nNroPer := xPrm(aP2,'nNroPer') // N£mero del Periodo
       LOCAL nRecPer := xPrm(aP2,'nRecPer') // 0=>No Recuperar 1=>Recuperar sin Borrar 2=>Recuperar Borrando

       LOCAL cTitReN := xPrm(aP2,'cTitReN') // T¡tulo Indicadores NO Recuperados
       LOCAL cTitReS := xPrm(aP2,'cTitReS') // T¡tulo Indicadores SI Recuperados

       LOCAL cTitRec := xPrm(aP2,'cTitRec') // Titulo para las Recuperaciones
       LOCAL cObsBol := xPrm(aP2,'cObsBol') // Observaci¢n del Boletin
       LOCAL aFirmas := xPrm(aP2,'aFirmas') // Firmas del libro

       LOCAL cCodGru := xPrm(aP2,'cCodGru') // C¢digo del Grupo
       LOCAL cNomPro := xPrm(aP2,'cNomPro') // Nombre del profesor
       LOCAL cTitDos := xPrm(aP2,'cTitDos') // Profesor Titular Dos

       LOCAL cCodEst := xPrm(aP2,'cCodEst') // C¢digo del Estudiante
       LOCAL cNomEst := xPrm(aP2,'cNomEst') // Nombre del Estudiante
       LOCAL nNroLis := xPrm(aP2,'nNroLis') // N£mero de Lista
       LOCAL nAprNot := xPrm(aP2,'nAprNot') // N£mero de Aprobaci¢n

       LOCAL aNotAre := xPrm(aP2,'aNotAre') // Detalles de las areas
       LOCAL aNotMat := xPrm(aP2,'aNotMat') // Detalles de las materias

       LOCAL cClaInd := xPrm(aP2,'cClaInd') // Iniciales de la Clase de Indicadores
       LOCAL lIndNiv := xPrm(aP2,'lIndNiv') // .T. Indicadores por nivel
       LOCAL cEvaInd := xPrm(aP2,'cEvaInd') // .T. Evaluar el indicador

       LOCAL lPrnCod := xPrm(aP2,'lPrnCod') // .T. Imprimir el C¢digo .F. Imprimir la Descripci¢n del Juicio
       LOCAL lNotNum := xPrm(aP2,'lNotNum') // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lPrnVar := xPrm(aP2,'lPrnVar') // Imprimir la Materia Variable
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
       LOCAL nHanXml := xPrm(aP3,'nHanXml')	// Manejador del Archivo
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

       LOCAL    k,y,x := 0                  // Contadores

       LOCAL nNroPos := 0                   // N£mero de la posici¢n

       LOCAL lEvaInd := .F.                 // Evaluar el Indicador

       LOCAL aAreas  := {}		    // Areas
       LOCAL aMaters := {}		    // Materias

       LOCAL aDetAre := {}                  // Detalles del Area
       LOCAL aDetMat := {}                  // Detalles de la Materia

       LOCAL aDbfMat := {}                  // Campos de Materias
       LOCAL aDbfPla := {}                  // Campos del Plan Academico
       LOCAL aDbfNot := {}                  // Campos de Notas
       LOCAL aDbfSel := {}                  // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                  // Campos Materias Variables

       LOCAL nNroOrd := 0                   // Orden en el Boletin
       LOCAL cCodAre := ''                  // C¢digo del Area
       LOCAL cAreMat := ''                  // C¢digo del Area de la Materia

       LOCAL aMatSel := {}                  // Materias Selectivas
       LOCAL aMatVar := {}                  // Materias Variables

       LOCAL cCodigo := ''                  // C¢digo del area
       LOCAL cCodMat := ''                  // C¢digo de la Materia
       LOCAL cMatVar := ''                  // C¢digo de la Materia Variable
       LOCAL nMatVar := 0                   // 0=>Materia Fija 1=>Materia Variable por Nivel 2=>Materia Variable por Grupo. Ej: Como Ludicas
       LOCAL lMatSel := .F.                 // .T. Materia Selectiva
       LOCAL cNomMat := ''                  // Nombre del Area o Materia
       LOCAL lModali := .F.                 // .T. Modalidad .F. No Modalidad

       LOCAL cIntens := ''                  // Intensidad
       LOCAL cNroAus := ''                  // N£mero de Ausencias
       LOCAL lNoPrnM := .F.                 // No Imprimir la Materia en el Boletin. Ej: 1:No Imprime  0:Si Imprime P1,P2,P3,P4,P5,LF

       LOCAL cNotDef := ''                  // Nota definitiva
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n

       LOCAL aIndNot := {}                  // Indicadores
       LOCAL cIndNot := ''                  // Indicadores
       LOCAL cIteEva := ''                  // Items de Evaluaci¢n

       LOCAL aIndMat := {}                  // Indicadores del periodo
       LOCAL aIndReN := {}                  // Indicadores NO Recuperados
       LOCAL aIndReS := {}                  // Indicadores SI Recuperados
       LOCAL aIndPer := {}                  // Indicadores del periodo
       LOCAL aSiRecu := {}                  // Indicadores Si Recuperados
       LOCAL aNoRecu := {}                  // Indicadores NO Recuperados
       LOCAL aNoIndp := {}                  // Indicadores NO Recuperados por periodo
       LOCAL aSiIndp := {}                  // Indicadores NO Recuperados por periodo

       LOCAL aIndica := {}                  // Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodEva := ''                  // C¢digo de Evaluaci¢n
       LOCAL cEvaRec := ''                  // C¢digo de la Recuperaci¢n
       LOCAL cNomEva := ''                  // Nombre de la Evaluaci¢n
       LOCAL cNomRec := ''                  // Nombre de la Evaluaci¢n de la Recuperaci¢n.
       LOCAL cNomInd := ''                  // Nombre del Indicador

       LOCAL aNotInd := {}                  // Nota de los Indicadores
       LOCAL cNotInd := ''                  // Nota de los Indicadores

       LOCAL cChrLin := ''                  // Caracter separador de l¡nea
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL cNroLin := ''                  // N£mero de l¡neas
       LOCAL aCabBol := {}                  // Encabezado del Boletin

       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL nLenPag := 0                   // l¡neas por p gina

       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nLinObs := 0                   // L¡neas de Observaci¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCamIndNot := ''               // Campo de Indicadores
       LOCAL cCamJntNot := ''               // Campo notas de los Indicadores
       LOCAL cCamFalNot := ''               // Campo de las Ausencias
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.
     *ÀVariables de Campo
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

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
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

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,2)
       AADD(aTitPrn,'IH')

       AADD(aNroCol,108)
       AADD(aTitPrn,cMsgBol)

       AADD(aNroCol,18)
       AADD(aTitPrn,'JUICIO')

       AADD(aNroCol,04)
       AADD(aTitPrn,'AUS.')

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

       bPagina := {||lPagina(nLinReg,lOficio,@nLenPag)}

       aCabBol := {}

       AADD(aCabBol,{'nNroPer',nNroPer})
       AADD(aCabBol,{'nColEnc',nColEnc})
       AADD(aCabBol,{'nColBol',nColBol})
       AADD(aCabBol,{'nLinEsp',nLinEsp})
       AADD(aCabBol,{'lPrnEmp',lPrnEmp})
       AADD(aCabBol,{'cNroFol',cNroFol})
       AADD(aCabBol,{'cTxtTop',cTxtTop})
       AADD(aCabBol,{'cTitTop',cTitTop})
       AADD(aCabBol,{'cCodEst',cCodEst})
       AADD(aCabBol,{'cNomEst',cNomEst})
       AADD(aCabBol,{'cCodGru',cCodGru})
       AADD(aCabBol,{'nNroLis',nNroLis})
     *ÀDetalles Encabezado Boletin

       bCabeza := {||CabPrnBol(aP1,aP2,aP3,;
			       aDetInf,aCabBol,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

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

*>>>>LINEAS POR PAGINA
       IF nTotLin # 0
	  nLenPag := nTotLin
       ENDIF
*>>>>FIN LINEAS POR PAGINA

*>>>>CONFIGURACION DEL NIVEL
       lEvaInd := IF(cEvaInd == '0',.F.,.T.)
       cTitReN := ALLTRIM(cTitReN)
       cTitReS := ALLTRIM(cTitReS)
*>>>>FIN CONFIGURACION DEL NIVEL

*>>>>RECORRIDO POR AREAS
       AreMatEst(@aAreas,@aMaters,nNroPer)

       FOR i := 1 TO LEN(aAreas)

**********IMPRESION DEL ENCABEZADO
	    IF lPrnCab

	       SET DEVICE TO PRINT

	       SendCodes(PCL({'Reset','ProporOf'}))
	       IF lOficio
		  SendCodes(PCL('Oficio'))
	       ENDIF

	       EVAL(bCabeza)
	      *Impresi¢n del Encabezado

	       lPrnCab := .F.

	       SET DEVICE TO SCREEN
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********DETALLES DEL AREA
	    nNroOrd := aAreas[i,1]
	    cCodAre := aAreas[i,2]
	    aDetAre := aAreas[i,3]

	    aDbfMat := xPrm(aDetAre,'aDbfMat')
	    aDbfPla := xPrm(aDetAre,'aDbfPla')
	    aDbfNot := xPrm(aDetAre,'aDbfNot')
**********DETALLES DEL AREA

**********CAMPOS DE ARCHIVOS
	    cCodMat := xPrm(aDbfMat,'cCodMat')
	    cNomMat := xPrm(aDbfMat,'cNombre')
	    lModali := xPrm(aDbfMat,'lModali')
	  *ÀCampos Materias

	    cIntens := xPrm(aDbfPla,'cIntHor')
	  *ÀCampos Plan Academico

	    cCamNotDef := xPrm(aDbfNot,'cNotas')
	    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
	    cCamIndNot := xPrm(aDbfNot,'cIndica'+STR(nNroPer,1))
	    cCamFalNot := xPrm(aDbfNot,'cFallas')
	  *ÀCampos Notas

	    lNoPrnM := xPrm(aDetAre,'lNoPrnM')
	  *ÀVarios
**********FIN CAMPOS DE ARCHIVOS

**********AREAS NO PROMEDIABLES
	    IF 'AREN' $ cCamNotDef

*==============ANALISIS DE LA IMPRESION DEL AREA
		 IF lNoPrnM  // .T. No Imprimir
		    LOOP
		 ENDIF
*==============FIN ANALISIS DE LA IMPRESION DEL AREA

*==============ANALISIS DE LA IMPRESION DE LA MODALIDAD
		 cIteEva := &cCamIndNot
		 IF lModali  // .T. Modalidad
		    IF EMPTY(cIteEva)
		       LOOP
		    ENDIF
		    cIteEva := ''
		 ENDIF
*==============FINN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*==============NOTA DEFINITIVA DEL AREA
		 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		 cNotDef := ALLTRIM(cNotDef)
		*Nota de la materia

		 IF VAL(cNotDef) > 0
		    cNotDef := cNotDefJvf(VAL(cNotDef))
		 ENDIF
*==============FIN NOTA DEFINITIVA DEL AREA

*==============INTENSIDAD Y NOMBRE DEL AREA
		 IF VAL(cIntens) == 0
		    cIntens := SPACE(02)
		 ENDIF
	       *ÀLectura de la Intensidad horaria

		 cNomMat := SUBS(cNomMat+SPACE(108),1,108)
		 IF lNegAre
		    cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		 ENDIF
*==============FIN INTENSIDAD Y NOMBRE DEL AREA

*==============CONTEO DE AUSENCIAS AREA
		 cNroAus := 0
		 IF SUBS(cTotAus,nNroPer,1) == '1'
		    FOR k := 1 TO nNroPer
		       cNroAus += VAL(SUBS(&cCamFalNot,k*2-1,2))
		    NEXT
		 ELSE
		    cNroAus := VAL(SUBS(&cCamFalNot,nNroPer*2-1,2))
		 ENDIF
		 cNroAus := IF(EMPTY(cNroAus),SPACE(04),STR(cNroAus,4,0))
*==============FIN CONTEO DE AUSENCIAS AREA

*==============IMPRESION DEL AREA
		 aRegPrn := {}
		 AADD(aRegPrn,cIntens)
		 AADD(aRegPrn,cNomMat)
		 AADD(aRegPrn,IF(lPrnCod,cNotDef,cTxtNota(cNotDef)))
		 AADD(aRegPrn,cNroAus)

		 lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*==============FIN IMPRESION DEL AREA

*=============ITEMS DEL AREA
		aIndMat := aIndicaMat(nNroPer,;
				      SUBS(cCodGru,1,2),;
				      cCodMat,;
				      lIndNiv,cIteEva,cNotInd,;
				      cEvaInd,'IND')
*=============FIN ITEMS DEL AREA

*=============ITEMS DEL PERIODO AREA
		FOR y := 1 TO LEN(aIndMat)

		    aIndica := aIndMat[y]
		    cCodInd := xPrm(aIndica,'cCodInd')
		    cCodEva := xPrm(aIndica,'cCodEva')
		    cEvaRec := xPrm(aIndica,'cEvaRec')
		    cNomEva := xPrm(aIndica,'cNomEva')
		    cNomInd := xPrm(aIndica,'cNomInd')

		    aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*-------------------IMPRESION ITEMS DEL AREA
		      FOR k := 1 TO LEN(aNroLin)

			  aRegPrn := {}
			  AADD(aRegPrn,cClaInd(cClaInd,SUBS(cCodInd,1,1)))
			*ÀIntensidad

			  cNroLin := aNroLin[k]
			  cNroLin := SUBS(cNroLin+SPACE(106),1,106)
			  IF k == 1
			     AADD(aRegPrn,'- '+cNroLin)
			  ELSE
			     AADD(aRegPrn,SPACE(02)+cNroLin)
			  ENDIF
			*ÀItem de Evaluaci¢n

			  IF lEvaInd
			     IF k == 1
				AADD(aRegPrn,cNomEva)
			     ELSE
				AADD(aRegPrn,SPACE(01))
			     ENDIF
			  ENDIF
			*ÀJuicio

			  AADD(aRegPrn,SPACE(01))
			*ÀAusencias

			  lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				     nColBol,aTitPrn,aRegPrn,aNroCol,;
				     bPagina,bDerAut,bCabeza)

		      ENDFOR
*-------------------FIN IMPRESION ITEMS DEL AREA

		ENDFOR
*=============FIN ITEMS DEL PERIODO AREA

*=============ANALISIS RECUPERACIONES PERIODOS ANTERIORES. AREA
		aNoIndp := {}
		aSiIndp := {}

		FOR x := 1 TO nNroPer

		    cCamIndNot := xPrm(aDbfNot,'cIndica'+STR(x,1))
		    cIteEva := &cCamIndNot

		    aIndPer := aIndicaMat(x,;
					  SUBS(cCodGru,1,2),;
					  cCodMat,;
					  lIndNiv,cIteEva,cNotInd,;
					  cEvaInd,'IND')

		    aSiRecu := {}
		    aNoRecu := {}
		    IndicaSiNo(aIndPer,@aSiRecu,@aNoRecu)

		    IF LEN(aNoRecu) # 0 .AND. x < nNroPer
		       AADD(aNoIndp,{x,aNoRecu})
		    ENDIF

		    IF LEN(aSiRecu) # 0
		       AADD(aSiIndp,{x,aSiRecu})
		    ENDIF
		ENDFOR
*=============FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. AREA

*============IMPRESION ITEMS SI RECUPERADOS. AREA
	       IF EMPTY(SUBS(cCfgBol,4,1)) .AND. LEN(aSiIndp) # 0

		  FOR x := 1 TO LEN(aSiIndp)

*---------------------TITULO SI RECUPERACIONES. AREA
			cTitReS := ALLTRIM(xPrm(aP2,'cTitReS'))
			IF EMPTY(cTitReS)
			   cTitReS := '** INDICADORES RECUPERADOS '+;
				      'PERIODO NO.# **'
			ENDIF
			cTitReS := PCL("NegraOn")+;
				   cTitReS+SPACE(108-LEN(cTitReS))+;
				   PCL("NegraOf")

			nNroPos := AT('NO.#',cTitReS)
			IF nNroPos # 0
			   cTitReS := STUFF(cTitReS,;
					    nNroPos,4,'No.'+;
					    STR(aSiIndp[x,1],1))
			ENDIF

			aRegPrn := {}
			AADD(aRegPrn,SPACE(01))  // IH
			AADD(aRegPrn,cTitReS)    // Materia
			AADD(aRegPrn,SPACE(01))  // Juicio
			AADD(aRegPrn,SPACE(01))  // Aus

			lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				   nColBol,aTitPrn,aRegPrn,aNroCol,;
				   bPagina,bDerAut,bCabeza)
*---------------------FIN TITULO SI RECUPERACIONES. AREA

*---------------------ITEMS SI RECUPERADOS. AREA
			aIndReS := aSiIndp[x,2]
			FOR y := 1 TO LEN(aIndReS)

			    aIndica := aIndReS[y]
			    cCodInd := xPrm(aIndica,'cCodInd')
			    cCodEva := xPrm(aIndica,'cCodEva')
			    cEvaRec := xPrm(aIndica,'cEvaRec')
			    cNomEva := xPrm(aIndica,'cNomEva')
			    cNomRec := xPrm(aIndica,'cNomRec')
			    cNomInd := xPrm(aIndica,'cNomInd')

			    aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*:::::::::::::::::::::::::::IMPRESION ITEMS. AREA
			      FOR k := 1 TO LEN(aNroLin)

				  aRegPrn := {}
				  AADD(aRegPrn,SPACE(01))
				*ÀIntensidad

				  cNroLin := aNroLin[k]
				  cNroLin := SUBS(cNroLin+SPACE(106),1,106)
				  IF k == 1
				     AADD(aRegPrn,'- '+cNroLin)
				  ELSE
				     AADD(aRegPrn,SPACE(02)+cNroLin)
				  ENDIF
				*ÀItem de Evaluaci¢n

				  IF lEvaInd
				     IF k == 1
					AADD(aRegPrn,cNomRec)
				     ELSE
					AADD(aRegPrn,SPACE(01))
				     ENDIF
				  ENDIF
				*ÀJuicio

				  AADD(aRegPrn,SPACE(01))
				*ÀAusencias

				  lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					     nColBol,aTitPrn,aRegPrn,aNroCol,;
					     bPagina,bDerAut,bCabeza)

			      ENDFOR
*:::::::::::::::::::::::::::FIN IMPRESION ITEMS. AREA

			ENDFOR
*---------------------FIN ITEMS SI RECUPERADOS. AREA

		  ENDFOR

	       ENDIF
*============FIN IMPRESION ITEMS SI RECUPERADOS. AREA

*=============IMPRESION ITEMS NO RECUPERADOS. AREA
		IF EMPTY(SUBS(cCfgBol,5,1)) .AND. LEN(aNoIndp) # 0

		   FOR x := 1 TO LEN(aNoIndp)

*----------------------TITULO NO RECUPERACIONES AREA
			 cTitReN := ALLTRIM(xPrm(aP2,'cTitReN'))
			 IF EMPTY(cTitReN)
			    cTitReN := '** INDICADORES POR RECUPERAR '+;
				       'PERIODO NO.# **'
			 ENDIF
			 cTitReN := PCL("NegraOn")+;
				    cTitReN+SPACE(108-LEN(cTitReN))+;
				    PCL("NegraOf")

			 nNroPos := AT('NO.#',cTitReN)
			 IF nNroPos # 0
			    cTitReN := STUFF(cTitReN,;
					     nNroPos,4,'No.'+;
					     STR(aNoIndp[x,1],1))
			 ENDIF

			 aRegPrn := {}
			 AADD(aRegPrn,SPACE(01))  // IH
			 AADD(aRegPrn,cTitReN)    // Materia
			 AADD(aRegPrn,SPACE(01))  // Juicio
			 AADD(aRegPrn,SPACE(01))  // Aus

			 lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				    nColBol,aTitPrn,aRegPrn,aNroCol,;
				    bPagina,bDerAut,bCabeza)
*----------------------FIN TITULO NO RECUPERACIONES. AREA

*----------------------ITEMS NO RECUPERADOS. AREA
			 aIndReN := aNoIndp[x,2]
			 FOR y := 1 TO LEN(aIndReN)

			     aIndica := aIndReN[y]
			     cCodInd := xPrm(aIndica,'cCodInd')
			     cCodEva := xPrm(aIndica,'cCodEva')
			     cEvaRec := xPrm(aIndica,'cEvaRec')
			     cNomEva := xPrm(aIndica,'cNomEva')
			     cNomInd := xPrm(aIndica,'cNomInd')

			     aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*::::::::::::::::::::::::::::IMPRESION ITEMS. AREA
			       FOR k := 1 TO LEN(aNroLin)

				   aRegPrn := {}
				   AADD(aRegPrn,SPACE(01))
				 *ÀIntensidad

				   cNroLin := aNroLin[k]
				   cNroLin := SUBS(cNroLin+SPACE(106),1,106)
				   IF k == 1
				      AADD(aRegPrn,'- '+cNroLin)
				   ELSE
				      AADD(aRegPrn,SPACE(02)+cNroLin)
				   ENDIF
				 *ÀItem de Evaluaci¢n

				   IF lEvaInd
				      IF k == 1
					 AADD(aRegPrn,cNomEva)
				      ELSE
					 AADD(aRegPrn,SPACE(01))
				      ENDIF
				   ENDIF
				 *ÀJuicio

				   AADD(aRegPrn,SPACE(01))
				 *ÀAusencias

				   lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					      nColBol,aTitPrn,aRegPrn,aNroCol,;
					      bPagina,bDerAut,bCabeza)

			       ENDFOR
*::::::::::::::::::::::::::::FIN IMPRESION ITEMS. AREA

			 ENDFOR
*----------------------FIN ITEMS NO RECUPERADOS. AREA

		   ENDFOR

		ENDIF
*=============FIN IMPRESION ITEMS NO RECUPERADOS. AREA

*=============LINEA SEPARADORA AREA
		 cChrLin := SUBS(cCfgBol,2,1)
		 IF !EMPTY(cChrLin)

		    aRegPrn := {}
		    AADD(aRegPrn,REPL(cChrLin,002))  // IH
		    AADD(aRegPrn,REPL(cChrLin,108))  // Materia
		    AADD(aRegPrn,REPL(cChrLin,018))  // Juicio
		    AADD(aRegPrn,REPL(cChrLin,004))  // Aus

		    lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			       bCabeza)
		 ENDIF
*=============FIN LINEA SEPARADORA AREA

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

*==================CAMPOS DE ARCHIVOS
		     cCodMat := xPrm(aDbfMat,'cCodMat')
		     cNomMat := xPrm(aDbfMat,'cNombre')
		     lModali := xPrm(aDbfMat,'lModali')
		   *ÀCampos Materias

		     cIntens := xPrm(aDbfPla,'cIntHor')
		   *ÀCampos Plan Academico

		     cCamNotDef := xPrm(aDbfNot,'cNotas')
		     cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
		     cCamIndNot := xPrm(aDbfNot,'cIndica'+STR(nNroPer,1))
		     cCamFalNot := xPrm(aDbfNot,'cFallas')
		   *ÀCampos Notas

		     lNoPrnM := xPrm(aDetMat,'lNoPrnM')
		   *ÀVarios
*==================FIN CAMPOS DE ARCHIVOS

*==================ANALISIS DE LA IMPRESION DE LA MATERIA
		     IF lNoPrnM  // .T. No Imprimir
			LOOP
		     ENDIF
*==================FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*==================ANALISIS MATERIA SELECTIVA
		     IF LEN(aMatSel) # 0

			aDbfSel := xPrm(aMatSel,'aDbfSel')
			aMatVar := xPrm(aMatSel,'aMatVar')
			aDbfVar := xPrm(aMatVar,'aDbfVa'+STR(nNroPer,1))

*-----------------------MATERIA SELECTIVA DEL PERIODO
			  IF LEN(aDbfVar) # 0
			     cCodMat := xPrm(aDbfVar,'cCodMat')
			   *ÀReemplaza por la materia Selectiva

			     IF xPrm(aDbfVar,'lPrnVar')
				cNomMat := xPrm(aDbfVar,'cNombre')
			     ENDIF
			  ENDIF
*-----------------------FIN MATERIA SELECTIVA DEL PERIODO

		     ENDIF
*==================FIN ANALISIS MATERIA SELECTIVA

*=================ANALISIS DE LA IMPRESION DE LA MODALIDAD
		    cIteEva := &cCamIndNot
		    IF lModali  // .T. Modalidad
		       IF EMPTY(cIteEva)
			  LOOP
		       ENDIF
		    ENDIF
*=================FIN ANALISIS DE LA IMPRESION DE LA MODALIDAD

*=================NOTA DEFINITIVA DE LA MATERIA
		    cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		    cNotDef := ALLTRIM(cNotDef)
		   *Nota de la materia

		    IF VAL(cNotDef) > 0
		       cNotDef := cNotDefJvf(VAL(cNotDef))
		    ENDIF
*=================FIN NOTA DEFINITIVA DE LA MATERIA

*==================INTENSIDAD Y NOMBRE DE LA MATERIA
		     IF VAL(cIntens) == 0
			cIntens := SPACE(02)
		     ENDIF
		   *ÀLectura de la Intensidad horaria

		     cNomMat := SUBS(cNomMat+SPACE(108),1,108)
		     IF lNegAre
			cNomMat := PCL("NegraOn")+cNomMat+PCL("NegraOf")
		     ENDIF
*==================FIN INTENSIDAD Y NOMBRE DE LA MATERIA

*==================CONTEO DE AUSENCIAS MATERIA
		     cNroAus := 0
		     IF SUBS(cTotAus,nNroPer,1) == '1'
			FOR k := 1 TO nNroPer
			   cNroAus += VAL(SUBS(&cCamFalNot,k*2-1,2))
			NEXT
		     ELSE
			cNroAus := VAL(SUBS(&cCamFalNot,nNroPer*2-1,2))
		     ENDIF
		     cNroAus := IF(EMPTY(cNroAus),SPACE(04),STR(cNroAus,4,0))
*==================FIN CONTEO DE AUSENCIAS MATERIA

*=================IMPRESION DE LA MATERIA
		    aRegPrn := {}
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNomMat)
		    AADD(aRegPrn,IF(lPrnCod,cNotDef,cTxtNota(cNotDef)))
		    AADD(aRegPrn,cNroAus)

		    lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*=================FIN IMPRESION DE LA MATERIA

*=================ITEMS DE LA MATERIA
		    aIndMat := aIndicaMat(nNroPer,;
					  SUBS(cCodGru,1,2),;
					  cCodMat,;
					  lIndNiv,cIteEva,cNotInd,;
					  cEvaInd,'IND')
*=================FIN ITEMS DE LA MATERIA

*=================ITEMS DEL PERIODO MATERIA
		    FOR y := 1 TO LEN(aIndMat)

			aIndica := aIndMat[y]
			cCodInd := xPrm(aIndica,'cCodInd')
			cCodEva := xPrm(aIndica,'cCodEva')
			cEvaRec := xPrm(aIndica,'cEvaRec')
			cNomEva := xPrm(aIndica,'cNomEva')
			cNomInd := xPrm(aIndica,'cNomInd')

			aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*------------------------IMPRESION ITEMS MATERIA
			   FOR k := 1 TO LEN(aNroLin)

			       aRegPrn := {}
			       AADD(aRegPrn,cClaInd(cClaInd,SUBS(cCodInd,1,1)))
			     *ÀIntensidad

			       cNroLin := aNroLin[k]
			       cNroLin := SUBS(cNroLin+SPACE(106),1,106)
			       IF k == 1
				  AADD(aRegPrn,'- '+cNroLin)
			       ELSE
				  AADD(aRegPrn,SPACE(02)+cNroLin)
			       ENDIF
			     *ÀItem de Evaluaci¢n

			       IF lEvaInd
				  IF k == 1
				     AADD(aRegPrn,cNomEva)
				  ELSE
				     AADD(aRegPrn,SPACE(01))
				  ENDIF
			       ENDIF
			     *ÀJuicio

			       AADD(aRegPrn,SPACE(01))
			     *ÀAusencias

			       lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					  nColBol,aTitPrn,aRegPrn,aNroCol,;
					  bPagina,bDerAut,bCabeza)

			   ENDFOR
*------------------------FIN IMPRESION ITEMS MATERIA

		    ENDFOR
*=================FIN ITEMS DEL PERIODO MATERIA

*=================ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA
		    aNoIndp := {}
		    aSiIndp := {}

		    FOR x := 1 TO nNroPer

			cCamIndNot := xPrm(aDbfNot,'cIndica'+STR(x,1))
			cIteEva := &cCamIndNot

*-----------------------ANALISIS MATERIA SELECTIVA
			  IF LEN(aMatSel) # 0

*::::::::::::::::::::::::::::MATERIA SELECTIVA DEL PERIODO
			       aDbfSel := xPrm(aMatSel,'aDbfSel')
			       aMatVar := xPrm(aMatSel,'aMatVar')
			       aDbfVar := xPrm(aMatVar,'aDbfVa'+STR(x,1))
			       IF LEN(aDbfVar) # 0
				  cCodMat := xPrm(aDbfVar,'cCodMat')
			       ENDIF
*::::::::::::::::::::::::::::FIN MATERIA SELECTIVA DEL PERIODO

			  ENDIF
*-----------------------FIN ANALISIS MATERIA SELECTIVA

*-----------------------INDICADORES DEL PERIODO ANTERIOR. MATERIA
			  aIndPer := aIndicaMat(x,;
						SUBS(cCodGru,1,2),;
						cCodMat,;
						lIndNiv,cIteEva,cNotInd,;
						cEvaInd,'IND')
*-----------------------FIN INDICADORES DEL PERIODO ANTERIOR. MATERIA

*-----------------------INDICADORES PERIODO ANTERIOR. MATERIA
			  aSiRecu := {}
			  aNoRecu := {}
			  IndicaSiNo(aIndPer,@aSiRecu,@aNoRecu)

			  IF LEN(aNoRecu) # 0 .AND. x < nNroPer
			     AADD(aNoIndp,{x,aNoRecu})
			  ENDIF

			  IF LEN(aSiRecu) # 0
			     AADD(aSiIndp,{x,aSiRecu})
			  ENDIF
*-----------------------FIN INDICADORES PERIODO ANTERIOR. MATERIA

		    ENDFOR
*=================FIN ANALISIS RECUPERACIONES PERIODOS ANTERIORES. MATERIA

*=================IMPRESION ITEMS SI RECUPERADOS. MATERIA
		    IF EMPTY(SUBS(cCfgBol,4,1)) .AND. LEN(aSiIndp) # 0

		       FOR x := 1 TO LEN(aSiIndp)

*--------------------------TITULO SI RECUPERACIONES. MATERIA
			     cTitReS := ALLTRIM(xPrm(aP2,'cTitReS'))
			     IF EMPTY(cTitReS)
				cTitReS := '** INDICADORES RECUPERADOS '+;
					   'PERIODO NO.# **'
			     ENDIF
			     cTitReS := PCL("NegraOn")+;
					cTitReS+SPACE(108-LEN(cTitReS))+;
					PCL("NegraOf")

			     nNroPos := AT('NO.#',cTitReS)
			     IF nNroPos # 0
				cTitReS := STUFF(cTitReS,;
						 nNroPos,4,'No.'+;
						 STR(aSiIndp[x,1],1))
			     ENDIF

			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(01))  // IH
			     AADD(aRegPrn,cTitReS)    // Materia
			     AADD(aRegPrn,SPACE(01))  // Juicio
			     AADD(aRegPrn,SPACE(01))  // Aus

			     lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					nColBol,aTitPrn,aRegPrn,aNroCol,;
					bPagina,bDerAut,bCabeza)
*--------------------------FIN TITULO SI RECUPERACIONES. MATERIA

*--------------------------ITEMS SI RECUPERADOS MATERIA
			      aIndReS := aSiIndp[x,2]
			      FOR y := 1 TO LEN(aIndReS)

				  aIndica := aIndReS[y]
				  cCodInd := xPrm(aIndica,'cCodInd')
				  cCodEva := xPrm(aIndica,'cCodEva')
				  cEvaRec := xPrm(aIndica,'cEvaRec')
				  cNomEva := xPrm(aIndica,'cNomEva')
				  cNomRec := xPrm(aIndica,'cNomRec')

				  cNomInd := xPrm(aIndica,'cNomInd')

				  aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*:::::::::::::::::::::::::::::::::IMPRESION ITEMS MATERIA
				    FOR k := 1 TO LEN(aNroLin)

					aRegPrn := {}
					AADD(aRegPrn,SPACE(01))
				      *ÀIntensidad

					cNroLin := aNroLin[k]
					cNroLin := SUBS(cNroLin+SPACE(106),1,106)
					IF k == 1
					   AADD(aRegPrn,'- '+cNroLin)
					ELSE
					   AADD(aRegPrn,SPACE(02)+cNroLin)
					ENDIF
				      *ÀItem de Evaluaci¢n

					IF lEvaInd
					   IF k == 1
					      AADD(aRegPrn,cNomRec)
					   ELSE
					      AADD(aRegPrn,SPACE(01))
					   ENDIF
					ENDIF
				      *ÀJuicio

					AADD(aRegPrn,SPACE(01))
				      *ÀAusencias

					lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
						   nColBol,aTitPrn,aRegPrn,aNroCol,;
						   bPagina,bDerAut,bCabeza)

				    ENDFOR
*:::::::::::::::::::::::::::::::::FIN IMPRESION ITEMS MATERIA

			     ENDFOR
*--------------------------FIN ITEMS SI RECUPERADOS MATERIA

		       ENDFOR

		    ENDIF
*=================FIN IMPRESION ITEMS SI RECUPERADOS. MATERIA

*=================IMPRESION ITEMS NO RECUPERADOS. MATERIA
		    IF EMPTY(SUBS(cCfgBol,5,1)) .AND. LEN(aNoIndp) # 0

		       FOR x := 1 TO LEN(aNoIndp)

*--------------------------TITULO NO RECUPERACIONES. MATERIA
			     cTitReN := ALLTRIM(xPrm(aP2,'cTitReN'))
			     IF EMPTY(cTitReN)
				cTitReN := '** INDICADORES POR RECUPERAR '+;
					   'PERIODO NO.# **'
			     ENDIF
			     cTitReN := PCL("NegraOn")+;
					cTitReN+SPACE(108-LEN(cTitReN))+;
					PCL("NegraOf")

			     nNroPos := AT('NO.#',cTitReN)
			     IF nNroPos # 0
				cTitReN := STUFF(cTitReN,;
						 nNroPos,4,'No.'+;
						 STR(aNoIndp[x,1],1))
			     ENDIF

			     aRegPrn := {}
			     AADD(aRegPrn,SPACE(01))  // IH
			     AADD(aRegPrn,cTitReN)    // Materia
			     AADD(aRegPrn,SPACE(01))  // Juicio
			     AADD(aRegPrn,SPACE(01))  // Aus

			     lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
					nColBol,aTitPrn,aRegPrn,aNroCol,;
					bPagina,bDerAut,bCabeza)
*--------------------------FIN TITULO NO RECUPERACIONES. MATERIA

*--------------------------ITEMS NO RECUPERADOS MATERIA
			      aIndReN := aNoIndp[x,2]
			      FOR y := 1 TO LEN(aIndReN)

				  aIndica := aIndReN[y]
				  cCodInd := xPrm(aIndica,'cCodInd')
				  cCodEva := xPrm(aIndica,'cCodEva')
				  cEvaRec := xPrm(aIndica,'cEvaRec')
				  cNomEva := xPrm(aIndica,'cNomEva')
				  cNomInd := xPrm(aIndica,'cNomInd')

				  aNroLin := aDivLin(ALLTRIM(cNomInd),106)

*:::::::::::::::::::::::::::::::::IMPRESION ITEMS MATERIA
				    FOR k := 1 TO LEN(aNroLin)

					aRegPrn := {}
					AADD(aRegPrn,SPACE(01))
				      *ÀIntensidad

					cNroLin := aNroLin[k]
					cNroLin := SUBS(cNroLin+SPACE(106),1,106)
					IF k == 1
					   AADD(aRegPrn,'- '+cNroLin)
					ELSE
					   AADD(aRegPrn,SPACE(02)+cNroLin)
					ENDIF
				      *ÀItem de Evaluaci¢n

					IF lEvaInd
					   IF k == 1
					      AADD(aRegPrn,cNomEva)
					   ELSE
					      AADD(aRegPrn,SPACE(01))
					   ENDIF
					ENDIF
				      *ÀJuicio

					AADD(aRegPrn,SPACE(01))
				      *ÀAusencias

					lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
						   nColBol,aTitPrn,aRegPrn,aNroCol,;
						   bPagina,bDerAut,bCabeza)

				    ENDFOR
*:::::::::::::::::::::::::::::::::FIN IMPRESION ITEMS MATERIA

			     ENDFOR
*--------------------------ITEMS NO RECUPERADOS MATERIA

		       ENDFOR

		    ENDIF
*=================FIN IMPRESION ITEMS NO RECUPERADOS. MATERIA

*=================LINEA SEPARADORA MATERIA
		    cChrLin := SUBS(cCfgBol,2,1)
		    IF !EMPTY(cChrLin)

		       aRegPrn := {}
		       AADD(aRegPrn,REPL(cChrLin,002))  // IH
		       AADD(aRegPrn,REPL(cChrLin,108))  // Materia
		       AADD(aRegPrn,REPL(cChrLin,018))  // Juicio
		       AADD(aRegPrn,REPL(cChrLin,004))  // Aus

		       lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				  nColBol,aTitPrn,aRegPrn,aNroCol,;
				  bPagina,bDerAut,bCabeza)
		    ENDIF
*=================FIN LINEA SEPARADORA MATERIA

	       ENDIF
	     *ÀIF cCodAre == cAreMat

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS DEL AREA

       ENDFOR
*>>>>FIN RECORRIDO POR AREAS

*>>>>LINEAS TOTALES DE IMPRESION
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
*>>>>FIN LINEAS TOTALES DE IMPRESION

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > (nLenPag - nTotImp) .OR. PROW() = 0

**********SALTO DE PAGINA
	    IF PROW() <> 0
	       IF PROW() <= nLenPag
		  EVAL(bDerAut)
	       ENDIF
	    ENDIF
**********FIN SALTO DE PAGINA

**********IMPRESION DEL ENCABEZADO
	    SET DEVICE TO PRINT

	    SendCodes(PCL({'Reset','ProporOf'}))
	    IF lOficio
	       SendCodes(PCL('Oficio'))
	    ENDIF

	    EVAL(bCabeza)
	   *Impresi¢n del Encabezado

	    SET DEVICE TO SCREEN
**********FIN IMPRESION DEL ENCABEZADO

       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroPer == nTotPer
	  cEstado := cAproboJui(nAprNot,;
				SUBS(cCodGru,1,2),;
				     @cTxtObsTap)
	  cEstado := ALLTRIM(cEstado)
       ENDIF

       aNroLin := aDivLin(ALLTRIM('OBSERVACION: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)

	   lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
		      aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		      bCabeza,aNroLin[i])

       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       aMatHab := {}
       IF nNroPer == nTotPer .AND. EMPTY(SUBS(cCfgBol,6,1))
	  aMatHab := aMatHabPla(nAprNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lPrnVar)
	 *Materias de las Recuperaciones
       ENDIF

       IF nNroPer == nTotPer .AND. !EMPTY(aMatHab)

	  lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
		     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		     bCabeza,SPACE(01))
	*ÀAvanca una linea

	  cTxtPrn := IF(EMPTY(cTitRec),;
		       'ACTIVIDADES DE RECUPERACION DE',;
			ALLTRIM(cTitRec))

	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 IF EMPTY(ALLTRIM(aMatHab[i,3]))
		    cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+'. '
		 ELSE
		    cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			       ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			       ' DE '+aMatHab[i,2]+'. '
		 ENDIF
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)

	  FOR i := 1 TO LEN(aNroLin)

	      lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			 bCabeza,aNroLin[i])

	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(cTxtObsTap)
	  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),110)
	  FOR i := 1 TO LEN(aNroLin)

	      lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			 bCabeza,aNroLin[i])

	  NEXT
       ENDIF
     *ÀObservaci¢n de Recuperacion.

       IF !EMPTY(cObsBol)
	  aNroLin := aDivLin(ALLTRIM(cObsBol),110)
	  FOR i := 1 TO LEN(aNroLin)

	      IF i == 1
		 lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			    bCabeza,SPACE(01))
	      ENDIF
	    *ÀAvanca una linea

	      lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColBol,;
			 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			 bCabeza,aNroLin[i])

	  NEXT
       ENDIF
     *ÀObservaci¢n General del Boletin

       nLinObs := IF(EMPTY(VAL(SUBS(cCfgBol,1,1))),2,;
		     VAL(SUBS(cCfgBol,1,1)))

       nLenLin := LEN(cCabCol)
       FOR i := 1 TO nLinObs

	   lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,02,nColBol,;
		      aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		      bCabeza,REPL('-',nLenLin))

       ENDFOR
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>FIRMANTES DEL BOLETIN
       IF LEN(aFirmas) == 0

	  aFirmas := {}
	  DO CASE
	  CASE EMPTY(SUBS(cCfgBol,7,1)) .OR.;
	       SUBS(cCfgBol,7,1) == '1'

	       cTxtPrn := 'Dir. '+cNomPro

	       lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,02,;
			  (nLenPrn-LEN(cTxtPrn))/2,;
			  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			  bCabeza,REPL('-',LEN(cTxtPrn)+4))
	     *ÀLinea para la firma

	       lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
			  ((nLenPrn-LEN(cTxtPrn))/2)+2,;
			  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			  bCabeza,cTxtPrn)
	     *ÀTitular el profesor

	  CASE SUBS(cCfgBol,7,1) == '2'
	       aFirmas := {{ALLTRIM(cGerent),NIL,ALLTRIM(cCarGer)},;
			   {cNomPro,NIL,'Dir.'}}
	       Firmas(PCL('n17Stan'),4,aFirmas)

	  CASE SUBS(cCfgBol,7,1) == '3'

	       aFirmas := {{cNomPro,NIL,'Dir.'},;
			   {cTitDos,NIL,'Dir.'}}
	       Firmas(PCL('n17Stan'),4,aFirmas)

	  OTHERWISE

	       cTxtPrn := 'Dir. '+cNomPro

	       lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,02,;
			  (nLenPrn-LEN(cTxtPrn))/2,;
			  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			  bCabeza,REPL('-',LEN(cTxtPrn)+4))
	     *ÀLinea para la firma

	       lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,;
			  ((nLenPrn-LEN(cTxtPrn))/2)+2,;
			  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
			  bCabeza,cTxtPrn)
	     *ÀTitular el profesor

	  ENDCASE

       ELSE
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.,nColBol)
       ENDIF
*>>>>FIN FIRMANTES DEL BOLETIN

*>>>>IMPRESION DERECHOS
       RESTSCREEN(0,0,24,79,cSavPan)
       EVAL(bDerAut)
      *Derechos de Autor
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS