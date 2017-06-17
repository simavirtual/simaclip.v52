/*************************************************************************
* TITULO..: INGRESOS POR DIA A LA CAFETERIA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/2008 MAR A
       Colombia, Bucaramanga        INICIO:  04:00 AM  SEP 02/2008 MAR

OBJETIVOS:

1- Configura la estructura general del informe

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CaF_00500(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nTipIni := xPrm(aP3,'nTipIni') // Registro Inicial
       LOCAL nTipFin := xPrm(aP3,'nTipFin') // Registro Final
       LOCAL lPorNom := xPrm(aP3,'lPorNom') // .T. Detallado por Nombres
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
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
       LOCAL aDetInf := {}                  // Detalles del Informe
     *ÀVariables de informe

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 5
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[INFORMES][CONSUMOS DIARIOS]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'CaF00500'
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
       AADD(aTitIso,'INGRESOS POR DIA A LA CAFETERIA')  // T¡tulo Uno
       AADD(aTitIso,'A¥O: <cAnoUsr> '+;
		    'JORNADA: <cJorTxt> ')              // T¡tulo Dos
       AADD(aTitIso,'MES DE '+cMes(nMesIni))            // T¡tulo Tres
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
	  FilePrn := 'Inf'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAF->cOpcPrnCaF,.T.,.T.)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAF->cOpcPrnCaF,.T.,2,bInsIso)
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
       lTamAnc := .T.
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
       CASE UPPER(cCodInf) == 'CAF00500'

	    CaF_005_00(aP1,aP2,aP3,;
		       aDetInf,oBrowse)
	  *ÀInforme por defecto.

       OTHERWISE
	    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
       ENDCASE
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: CAMPOS DEL INFORME. VERSION No.00                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/2008 MAR A
       Colombia, Bucaramanga        INICIO:  04:15 AM  SEP 02/2008 MAR

OBJETIVOS:

1- Imprime los campos del informe

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CaF_005_00(aP1,aP2,aP3,aDetInf,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nTipIni := xPrm(aP3,'nTipIni') // Registro Inicial
       LOCAL nTipFin := xPrm(aP3,'nTipFin') // Registro Final
       LOCAL lPorNom := xPrm(aP3,'lPorNom') // .T. Detallado por Nombres
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

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
     *ÀVariables de informe

       LOCAL nLenCol := 4                       // Longitud de la Columna
       LOCAL aTotMes[31]                        // Total Ingresos del Mes
     *ÀVariables espec¡ficas

       LOCAL Getlist := {}                      // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTpe := ''                   // Nombre del personal
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,30)
       AADD(aTitPrn,'TIPOS DE INGRESOS')
       FOR i := 1 TO 31
	   AADD(aTitPrn,STR(i,4))
	   AADD(aNroCol,2)
       ENDFOR
       AADD(aTitPrn,'TOTAL MES')
       AADD(aNroCol,12)

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

       aCabSec := NIL
       AADD(aDetInf,{'aCabSec',aCabSec})

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabPrnIso(aP1,aP2,aP3,;
			       aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}

       AADD(aDetInf,{'bPagina',bPagina})
       AADD(aDetInf,{'bCabeza',bCabeza})
       AADD(aDetInf,{'bDerAut',bDerAut})
*>>>>FIN DETALLES DEL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

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
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       AFILL(aTotMes,0)
       AADD(aDetInf,{'aTotMes',aTotMes})

       SELECT TIP
       GO nTipIni
       DO WHILE TIP->(RECNO()) <= nTipFin

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('TIPO:'+TIP->cNombreTip+;
			'ºNo. '+TIP->(STR(RECNO(),2))+'/'+;
				TIP->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL REGISTRO
	    IF TIP->cCodigoTip == '1' .OR. lPorNom

	       aRegPrn := {}
	       AADD(aRegPrn,TIP->cNombreTip)
	       AADD(aRegPrn,SPACE(154))
	       AADD(aRegPrn,SPACE(12))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DEL REGISTRO
	    DO CASE
	    CASE TIP->cCodigoTip == '1' .AND. !TIP->lBoletaTip

		 Est_005_00(aP1,aP2,aP3,aDetInf)
		*Ingresos diarios de los Estudiantes

	    CASE TIP->cCodigoTip == '2' .AND. !TIP->lBoletaTip

		 Pro_005_00(aP1,aP2,aP3,aDetInf)
		*Ingresos diarios de los profesores

	    CASE TIP->cCodigoTip # '1' .AND. TIP->cCodigoTip # '2' .AND.;
		 !TIP->lBoletaTip

		 Per_005_00(aP1,aP2,aP3,aDetInf)
		*Ingresos diarios del personal


	    CASE TIP->cCodigoTip # '1' .AND. TIP->cCodigoTip # '2' .AND.;
		 TIP->lBoletaTip

		 Bol_005_00(aP1,aP2,aP3,aDetInf)
		*Ingresos diarios por boletas


	    ENDCASE
**********FIN IMPRESION DEL REGISTRO

	  SELECT TIP
	  TIP->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DEL TOTAL
       aTotMes := xPrm(aDetInf,'aTotMes')

       aRegPrn := {}
       AADD(aRegPrn,'GRAN TOTAL')
       FOR i := 1 TO 31

	   AADD(aRegPrn,IF(EMPTY(aTotMes[i]),SPACE(nLenCol),;
				 STR(aTotMes[i],nLenCol)))
       ENDFOR
       AADD(aRegPrn,STR(nSuma(aTotMes),10,0))

       cTxtPrn := cRegPrint(aRegPrn,aNroCol)
       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
	       REPL('=',LEN(cTxtPrn)))

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
	       REPL('=',LEN(cTxtPrn)))
*>>>>IMPRESION DEL RESUMEN

*>>>>IMPRESION DERECHOS
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
* TITULO..: INGRESOS DIARIO DE LOS ESTUDIANTES                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2008 MIE A
       Colombia, Bucaramanga        INICIO:  09:00 AM  SEP 03/2008 MIE

OBJETIVOS:

1- Los ingresos diarios a la cafeteria de los estudiantes

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Est_005_00(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nTipIni := xPrm(aP3,'nTipIni') // Registro Inicial
       LOCAL nTipFin := xPrm(aP3,'nTipFin') // Registro Final
       LOCAL lPorNom := xPrm(aP3,'lPorNom') // .T. Detallado por Nombres
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := xPrm(aDetInf,'nNroPag')	// N£mero de p gina
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
     *ÀVariables de informe

       LOCAL aTotMes := xPrm(aDetInf,'aTotMes') // Total Ingresos del Mes

       LOCAL       i := 0                       // Contador

       LOCAL nRegIni := 0                       // Registro Inicial
       LOCAL nRegFin := 0                       // Registro Final
       LOCAL cGruFin := ''                      // Grupo final de impresi¢n

       LOCAL nLenCol := 4                       // Longitud de la Columna

       LOCAL cNivAnt := ''                      // Nivel Anterior
       LOCAL cNivAct := ''                      // Nivel Actual

       LOCAL cCampos := ''                      // Campos
       LOCAL nIngDia := 0                       // Ingresos del dia
       LOCAL aMesEst[31]                        // Ingresos por Estudiante al mes
       LOCAL aMesGru[31]                        // Ingresos por Grupo al mes
       LOCAL aMesNiv[31]                        // Ingresos por Grado al mes

       LOCAL cNombreTes := ''                   // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>INGRESOS DIARIOS POR GRUPOS
       FilePrn := xPrm(aDetInf,'FilePrn')
       nHanXml := xPrm(aDetInf,'nHanXml')

       AFILL(aMesNiv,0)
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := PathDos+'\'+cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cErrorPrn('ABRIENDO EL ARCHIVO DE CLIENTES')
	       CloseDbf('CLI')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0

		 cErrorPrn('NO EXISTEN CLIENTES CREADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********RECORRIDO DE SOLO UN GRUPO
	    SELECT CLI
	    CLI->(DBGOTOP())
	    AFILL(aMesGru,0)
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO DE CARTERA: '+GRU->cCodigoGru+;
			     'ºNo. '+CLI->(STR(RECNO(),2))+'/'+;
				     CLI->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct)
		    cErrorPrn('EL CODIGO:'+CLI->cCodigoEst+' NO EXISTE EN '+;
			      'CLIENTES DEL GRUPO:'+GRU->cCodigoGru)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------CONTEO DE LOS INGRESOS DIARIOS
		 AFILL(aMesEst,0)
		 cCampos := cMaeAct+'->cRes'+cMes(nMesIni,3)+'Est'
		 FOR i := 1 TO 31
		     nIngDia := VAL(SUBS(&cCampos,i,1))
		     aMesEst[i] := nIngDia
		     aMesGru[i] += nIngDia
		     aMesNiv[i] += nIngDia
		     aTotMes[i] += nIngDia
		 ENDFOR
*--------------FIN CONTEO DE LOS INGRESOS DIARIOS

*--------------IMPRESION DEL REGISTRO DEL ESTUDIANTE
		 IF lPorNom

		    aRegPrn := {}
		    AADD(aRegPrn,cNombreTes)
		    FOR i := 1 TO 31
			AADD(aRegPrn,SUBS(&cCampos,i,1)+SPACE(03))
		    ENDFOR
		    AADD(aRegPrn,CLI->cCodigoEst+'='+STR(nSuma(aMesEst),;
							 nLenCol))
		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO DEL ESTUDIANTE

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 SELECT CLI
		 CLI->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN RECORRIDO DE SOLO UN GRUPO

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    AADD(aRegPrn,SPACE(02)+;
			 SUBS('  GRUPO:'+GRU->cCodigoGru+SPACE(28),1,28))
	    FOR i := 1 TO 31
		AADD(aRegPrn,IF(EMPTY(aMesGru[i]),SPACE(nLenCol),;
				      STR(aMesGru[i],nLenCol)))
	    ENDFOR
	    AADD(aRegPrn,STR(nSuma(aMesGru),10,0))

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    cNivAnt := SUBS(GRU->cCodigoGru,1,2)
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct .AND. nSuma(aMesNiv) # 0

	       aRegPrn := {}
	       AADD(aRegPrn,SPACE(02)+;
			    SUBS('TOTAL GRADO:'+cNivAnt+SPACE(28),1,28))
	       FOR i := 1 TO 31
		   AADD(aRegPrn,IF(EMPTY(aMesNiv[i]),;
				   SPACE(nLenCol),;
				   STR(aMesNiv[i],nLenCol)))
	       ENDFOR
	       AADD(aRegPrn,STR(nSuma(aMesNiv),10,0))

	       cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
		       REPL('-',LEN(cTxtPrn)))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
		       REPL('-',LEN(cTxtPrn)))

	       AFILL(aMesNiv,0)
	       cNivAnt := cNivAct

	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
       nParameSet(aDetInf,'aTotMes',aTotMes)
       RETURN NIL
*>>>>FIN INGRESOS DIARIOS POR GRUPOS

/*************************************************************************
* TITULO..: INGRESO DIARIO DE LOS PROFESORES                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2008 JUE A
       Colombia, Bucaramanga        INICIO:  10:00 AM  SEP 04/2008 JUE

OBJETIVOS:

1- Los ingresos diarios a la cafeteria de los profesores

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pro_005_00(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nTipIni := xPrm(aP3,'nTipIni') // Registro Inicial
       LOCAL nTipFin := xPrm(aP3,'nTipFin') // Registro Final
       LOCAL lPorNom := xPrm(aP3,'lPorNom') // .T. Detallado por Nombres
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := xPrm(aDetInf,'nNroPag')	// N£mero de p gina
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
     *ÀVariables de informe

       LOCAL aTotMes := xPrm(aDetInf,'aTotMes') // Total Ingresos del Mes

       LOCAL       i := 0                       // Contador
       LOCAL nLenCol := 4                       // Longitud de la Columna

       LOCAL cCampos := ''                  // Campos
       LOCAL nIngDia := 0                   // Ingresos del dia
       LOCAL aMesPro[31]                    // Ingresos por Profesor
       LOCAL aTotPro[31]                    // Total Ingresos por Profesor

       LOCAL cNombreTpr := ''               // Nombre del Profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INGRESOS DIARIOS POR PROFESOR
       FilePrn := xPrm(aDetInf,'FilePrn')
       nHanXml := xPrm(aDetInf,'nHanXml')

       AFILL(aTotPro,0)
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT PRO
       PRO->(DBGOTOP())
       DO WHILE .NOT. PRO->(EOF())

**********CONTEO DE LOS INGRESOS DIARIOS
	    AFILL(aMesPro,0)
	    cCampos := 'PRO->cRes'+cMes(nMesIni,3)+'Pro'
	    FOR i := 1 TO 31
		nIngDia := VAL(SUBS(&cCampos,i,1))
		aMesPro[i] := nIngDia
		aTotPro[i] += nIngDia
		aTotMes[i] += nIngDia
	    ENDFOR
**********FIN CONTEO DE LOS INGRESOS DIARIOS

**********IMPRESION DEL REGISTRO DEL PROFESOR
	    cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
			  RTRIM(PRO->cNombrePro)
	    cNombreTpr := SUBS(cNombreTpr+SPACE(30),1,30)
	    IF lPorNom
	       aRegPrn := {}
	       AADD(aRegPrn,cNombreTpr)
	       FOR i := 1 TO 31
		   AADD(aRegPrn,SUBS(&cCampos,i,1)+SPACE(03))
	       ENDFOR
	       AADD(aRegPrn,PRO->cCodigoPro+'='+STR(nSuma(aMesPro),;
						    nLenCol))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO DEL PROFESOR

	  SELECT PRO
	  PRO->(DBSKIP())

       ENDDO
       nParameSet(aDetInf,'aTotMes',aTotMes)
*>>>>FIN INGRESOS DIARIOS POR PROFESOR

*>>>>IMPRESION DEL REGISTRO
       aRegPrn	:= {}
       AADD(aRegPrn,TIP->cNombreTip)
       FOR i := 1 TO 31
	   AADD(aRegPrn,IF(EMPTY(aTotPro[i]),SPACE(nLenCol),;
				 STR(aTotPro[i],nLenCol)))
       ENDFOR
       AADD(aRegPrn,STR(nSuma(aTotPro),10,0))

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       RETURN NIL
*>>>>FIN IMPRESION DEL REGISTRO

/*************************************************************************
* TITULO..: INGRESO DIARIO DEL PERSONAL                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2008 JUE A
       Colombia, Bucaramanga        INICIO:  10:30 AM  SEP 04/2008 JUE

OBJETIVOS:

1- Los ingresos diarios a la cafeteria de los profesores

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Per_005_00(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nTipIni := xPrm(aP3,'nTipIni') // Registro Inicial
       LOCAL nTipFin := xPrm(aP3,'nTipFin') // Registro Final
       LOCAL lPorNom := xPrm(aP3,'lPorNom') // .T. Detallado por Nombres
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := xPrm(aDetInf,'nNroPag')	// N£mero de p gina
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
     *ÀVariables de informe

       LOCAL aTotMes := xPrm(aDetInf,'aTotMes') // Total Ingresos del Mes

       LOCAL       i := 0                       // Contador
       LOCAL nLenCol := 4                       // Longitud de la Columna

       LOCAL cCampos := ''                  // Campos
       LOCAL nIngDia := 0                   // Ingresos del dia
       LOCAL aMesPer[31]                    // Ingresos por Personal
       LOCAL aTotPer[31]                    // Total Ingresos por Personal

       LOCAL cNombreTpe := ''               // Nombre del Personal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INGRESOS DIARIOS POR PROFESOR
       FilePrn := xPrm(aDetInf,'FilePrn')
       nHanXml := xPrm(aDetInf,'nHanXml')

       AFILL(aTotPer,0)
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT PER
       PER->(DBGOTOP())
       DO WHILE .NOT. PER->(EOF())

**********VALIDACION DEL TIPO
	    IF PER->cCodigoTip # TIP->cCodigoTip
	       SELECT PER
	       PER->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL TIPO

**********CONTEO DE LOS INGRESOS DIARIOS
	    AFILL(aMesPer,0)
	    cCampos := 'PER->cRes'+cMes(nMesIni,3)+'Per'
	    FOR i := 1 TO 31
		nIngDia := VAL(SUBS(&cCampos,i,1))
		aMesPer[i] := nIngDia
		aTotPer[i] += nIngDia
		aTotMes[i] += nIngDia
	    ENDFOR
**********FIN CONTEO DE LOS INGRESOS DIARIOS

**********IMPRESION DEL REGISTRO DEL PERSONAL
	    cNombreTpe := RTRIM(PER->cApelliPer)+' '+;
			  RTRIM(PER->cNombrePer)
	    cNombreTpe := SUBS(cNombreTpe+SPACE(30),1,30)
	    IF lPorNom
	       aRegPrn := {}
	       AADD(aRegPrn,cNombreTpe)
	       FOR i := 1 TO 31
		   AADD(aRegPrn,SUBS(&cCampos,i,1)+SPACE(03))
	       ENDFOR
	       AADD(aRegPrn,PER->cCodigoPer+'='+STR(nSuma(aMesPer),;
						    nLenCol))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO DEL PERSONAL

	  SELECT PER
	  PER->(DBSKIP())

       ENDDO
       nParameSet(aDetInf,'aTotMes',aTotMes)
*>>>>FIN INGRESOS DIARIOS POR PROFESOR

*>>>>IMPRESION DEL REGISTRO
       aRegPrn := {}
       AADD(aRegPrn,TIP->cNombreTip)
       FOR i := 1 TO 31
	   AADD(aRegPrn,IF(EMPTY(aTotPer[i]),SPACE(nLenCol),;
				 STR(aTotPer[i],nLenCol)))
       ENDFOR
       AADD(aRegPrn,STR(nSuma(aTotPer),10,0))

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       RETURN NIL
*>>>>FIN IMPRESION DEL REGISTRO

/*************************************************************************
* TITULO..: INGRESO DIARIO DEL PERSONAL                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/2008 JUE A
       Colombia, Bucaramanga        INICIO:  11:00 AM  SEP 04/2008 JUE

OBJETIVOS:

1- Los ingresos diarios a la cafeteria de los profesores

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Bol_005_00(aP1,aP2,aP3,aDetInf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

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

*>>>>DECLARACION PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP3,'nMesIni') // Mes Inicial
       LOCAL nTipIni := xPrm(aP3,'nTipIni') // Registro Inicial
       LOCAL nTipFin := xPrm(aP3,'nTipFin') // Registro Final
       LOCAL lPorNom := xPrm(aP3,'lPorNom') // .T. Detallado por Nombres
*>>>>FIN DECLARACION PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nRegPrn := 0                       // Registro de Impresi¢n
       LOCAL cFecPrn := ''                      // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                      // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                      // @D¡a de Impresi¢n
       LOCAL nNroPag := xPrm(aDetInf,'nNroPag')	// N£mero de p gina
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
     *ÀVariables de informe

       LOCAL aTotMes := xPrm(aDetInf,'aTotMes') // Total Ingresos del Mes

       LOCAL       i := 0                       // Contador
       LOCAL nLenCol := 4                       // Longitud de la Columna

       LOCAL cCampos := ''                  // Campos
       LOCAL nIngDia := 0                   // Ingresos del dia
       LOCAL aMesBol[31]                    // Ingresos por Personal
       LOCAL aTotBol[31]                    // Total Ingresos por Personal

       LOCAL cNombreTpe := ''               // Nombre del Personal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INGRESOS DIARIOS POR PROFESOR
       FilePrn := xPrm(aDetInf,'FilePrn')
       nHanXml := xPrm(aDetInf,'nHanXml')

       AFILL(aTotBol,0)
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT VBO
       VBO->(DBGOTOP())
       DO WHILE .NOT. VBO->(EOF())

**********VALIDACION DEL TIPO
	    IF VBO->cCodigoTip # TIP->cCodigoTip
	       SELECT VBO
	       VBO->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL TIPO

**********CONTEO DE LOS INGRESOS DIARIOS
	    AFILL(aMesBol,0)
	    nIngDia := DAY(VBO->dFecVenBol)
	    IF !EMPTY(VBO->dFecVenBol)
	       aMesBol[nIngDia] := 1
	       aTotBol[nIngDia] += 1
	       aTotMes[nIngDia] += 1
	    ENDIF
**********FIN CONTEO DE LOS INGRESOS DIARIOS

**********IMPRESION DEL REGISTRO POR BOLETAS
	    IF lPorNom
	       aRegPrn := {}
	       AADD(aRegPrn,'BOLETA No. '+VBO->cCodigoBol)
	       FOR i := 1 TO 31
		   AADD(aRegPrn,SPACE(04))
	       ENDFOR
	       AADD(aRegPrn,VBO->cCodigoBol+'='+STR(nSuma(aMesBol),;
						    nLenCol))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO POR BOLETAS

	  SELECT VBO
	  VBO->(DBSKIP())

       ENDDO
       nParameSet(aDetInf,'aTotMes',aTotMes)
*>>>>FIN INGRESOS DIARIOS POR PROFESOR

*>>>>IMPRESION DEL REGISTRO
       aRegPrn := {}
       AADD(aRegPrn,TIP->cNombreTip)
       FOR i := 1 TO 31
	   AADD(aRegPrn,IF(EMPTY(aTotBol[i]),SPACE(nLenCol),;
				 STR(aTotBol[i],nLenCol)))
       ENDFOR
       AADD(aRegPrn,STR(nSuma(aTotBol),10,0))

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       RETURN NIL
*>>>>FIN IMPRESION DEL REGISTRO