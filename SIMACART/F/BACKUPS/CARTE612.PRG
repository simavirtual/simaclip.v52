/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: TODOS LOS CONCEPTOS

**************************************************************************
* TITULO..: TODOS LOS CONCEPTOS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 29/2004 LUN A
       Bucaramanga, Colombia	    INICIO: 11:45 PM   JUL 29/2004 LUN

OBJETIVOS:

1- Permite imprimir todos los estudiantes con conceptos individuales.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_612(aP1,aP2,aP3)

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
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nRegIni := 0                  // Registro inicial del grupo
       LOCAL nRegFin := 0                  // Registro Final del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       IF !lCreallGru(lShared,cAnoUsr,cMaeAlu,PathUno+'\'+cPatSis,FileTem)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})


       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared,nModCry})

*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoUsr)

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoUsr)

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoUsr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>IMPRESION DEL INFORME
       aP2 := {}
       AADD(aP2,{'FilePag',FilePag})
       AADD(aP2,{'FileCli',FileCli})
       AADD(aP2,{'ExtFile',ExtFile})
       AADD(aP2,{'cPiePag',SCA->cPiePagCar})
       AADD(aP2,{'cOpcPrn',SCA->cOpcPrnCar})
       AADD(aP2,{'nRegFin',nRegFin})
       AADD(aP2,{'nRegIni',nRegIni})
       AADD(aP2,{'nRegFin',nRegFin})

       SCA_61200(aP1,aP2,aP3)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: ESTUDIANTES CON CONCEPTOS INDIVIDUALES.MVC:INFORME           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2008 VIE A
       Colombia, Bucaramanga        INICIO:  01:30 PM  JUN 20/2008 VIE

OBJETIVOS:

1- Imprime los estudiantes con conceptos individuales.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SCA_61200(aP1,aP2,aP3)

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

*>>>>PARAMETROS ESPECIFICOS
       LOCAL FileCli := xPrm(aP2,'FileCli') // Archivo de Clientes
       LOCAL FilePag := xPrm(aP2,'FilePag') // Archivo de Pagos
       LOCAL ExtFile := xPrm(aP2,'ExtFile') // Extensi¢n del Archivo
       LOCAL nGruIni := xPrm(aP2,'nRegIni') // Registro inicial del grupo
       LOCAL nGruFin := xPrm(aP2,'nRegFin') // Registro Final del grupo
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
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
       LOCAL cOpcPrn := ''                  // Opciones de impresi¢n
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
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL aTotReg := {}                  // Total Registros
     *ÀVariables de informe

       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima
       LOCAL nOpcion := 0                   // Opcion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 612
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '[OTROS][TODOS LOS CONCEPTOS][TODOS LOS CONCEPTOS]'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'CAR61200'
     *ÀC¢digo del Informe

       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
     *ÀMargenes del Informe

       nNroDoc := 0
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'ESTUDIANTES CON CONCEPTOS INDIVIDUALES.')  // T¡tulo Uno

       AADD(aTitIso,'A¥O: <cAnoUsr>. JORNADA: <cJorTxt>')       // T¡tulo Dos

       AADD(aTitIso,'')                                         // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := xPrm(aP2,'cPiePag')
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
       ENDIF
     *ÀPie de p gina

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       IF nNroInf # 0
	  cCodIso := ALLTRIM(ISO->cCodigoIso)
	  cFecIso := ALLTRIM(ISO->cFecAprIso)
	  cVerIso := ALLTRIM(ISO->cNroVerIso)
       ENDIF
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>ANALISIS DE DECISION
       nOpcion := nLeeOpcion('ENTRE LA OPCION '+;
			     '1<INCONSISTENCIAS> '+;
			     '2<INFORME> 3<ABANDONAR>?',3,'0')
       IF EMPTY(nOpcion)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       cOpcPrn := xPrm(aP2,'cOpcPrn')

       IF nNroInf == 0
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,.T.,PathDoc)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,2,bInsIso,;
				 PathDoc)
       ENDIF
       IF EMPTY(nOpcPrn)
	  RETURN NIL
       ENDIF
       SET DEVICE TO SCREEN
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
       DO CASE
       CASE UPPER(cCodInf) == 'CAR61200'

	    AADD(aNroCol,06)
	    AADD(aTitPrn,'CODIGO')

	    AADD(aNroCol,06)
	    AADD(aTitPrn,'GRUPO')

	    AADD(aNroCol,30)
	    AADD(aTitPrn,'NOMBRE')

	    AADD(aNroCol,16)
	    AADD(aTitPrn,'CONCEPTO')

	    AADD(aNroCol,04)
	    AADD(aTitPrn,'MES')

	    AADD(aNroCol,04)
	    AADD(aTitPrn,'MES')

	    AADD(aNroCol,14)
	    AADD(aTitPrn,'POR CONCEPTOS')

	    AADD(aNroCol,12)
	    AADD(aTitPrn,'FACTURADOS')

	    AADD(aNroCol,40)
	    AADD(aTitPrn,'OBSERVACIONES')
       OTHERWISE
	    cError('CODIGO DEL INFORME:'+cCodInf+' INCONSISTENTE')
	    RETURN NIL
       ENDCASE
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       aCabSec := NIL
       DO CASE
       CASE cCodInf == 'CAR61200'
       ENDCASE

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

       SET DEVICE TO SCREEN
       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl',SCA->nCodXslCar})
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

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nGruIni))
       DO WHILE GRU->(RECNO()) <= nGruFin

**********FILTRACION DEL ARCHIVO DE ALUMNOS
	    cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
	    SELECT &cMaeAct
	    DO CASE
	    CASE cMaeAct == 'JAR'
		 SELECT JAR
		 SET FILTER TO JAR->cCodigoGru == GRU->cCodigoGru

	    CASE cMaeAct == 'PRI'
		 SELECT PRI
		 SET FILTER TO PRI->cCodigoGru == GRU->cCodigoGru

	    CASE cMaeAct == 'BTO'
		 SELECT BTO
		 SET FILTER TO BTO->cCodigoGru == GRU->cCodigoGru
	    ENDCASE

	    DBGOTOP()
	    IF EOF()
	       SET FILTER TO
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO DE ALUMNOS

**********RECORRIDO POR ESTUDIANTES
	    SELECT &cMaeAct
	    DBGOTOP()
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('ºGRUPO: '+GRU->cCodigoGru+;
			     'ºCODIGO: '+&cMaeAct->cCodigoEst,'')
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------PREPARACION DE LAS VARIABLES DE ARCHIVOS
		 FileCli := cPatSis+'\CLIENTES\CL'+;
			    &cMaeAct->cCodigoGru+cAnoSis+ExtFile
		 FilePag := cPatSis+'\PAGOS\PA'+;
			    &cMaeAct->cCodigoGru+cAnoSis+ExtFile
*--------------FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		    !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		    cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		    SELECT &cMaeAct
		    DBSKIP()
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------LOGICA DEL INFORME
		 nParameSet(aP1,'cMaeAct',cMaeAct)

		 aP3 := {}
		 AADD(aP3,{'cCodInf',cCodInf})
		 AADD(aP3,{'nOpcion',nOpcion})
		 AADD(aP3,{'cCodEst',&cMaeAct->cCodigoEst})

		 aTotReg := SCA_612MVC(aP1,aP2,aP3)
*--------------FIN LOGICA DEL INFORME

*--------------IMPRESION DEL REGISTRO
		 FOR i := 1 TO LEN(aTotReg)

		     aRegPrn := aTotReg[i]

		     SET DEVICE TO PRINT
		     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
			     nColCab,aTitPrn,aRegPrn,aNroCol,;
			     bPagina,bDerAut,bCabeza)
		     SET DEVICE TO SCREEN

		 ENDFOR
*--------------FIN IMPRESION DEL REGISTRO

	       SELECT &cMaeAct
	       DBSKIP()

	    ENDDO
**********FIN RECORRIDO POR ESTUDIANTES

**********INCREMENTO DEL SIGUIENTE GRUPO
	    SELECT GRU
	    GRU->(DBSKIP())

	    IF nGruIni == nGruFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO
       SELECT &cMaeAct
       SET FILTER TO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>IMPRESION DERECHOS
       SET DEVICE TO SCREEN
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: ESTUDIANTES CON CONCEPTOS INDIVIDUALES.MVC:MODELO            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2008 VIE A
       Colombia, Bucaramanga        INICIO:  02:00 PM  JUN 20/2008 VIE

OBJETIVOS:

1- Calcula los estudiantes con conceptos individuales.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SCA_612MVC(aP1,aP2,aP3)

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

*>>>>PARAMETROS ESPECIFICOS
       LOCAL cCodInf := xPrm(aP3,'cCodInf') // C¢digo del Informe
       LOCAL nOpcion := xPrm(aP3,'nOpcion') // Opci¢n

       LOCAL cCodEst := xPrm(aP3,'cCodEst') // C¢digo del Estudiante
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nHayErr := 0                   // 0 = Hay Error

       LOCAL     i,k := 0                   // Contadores
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL aTotReg := {}                  // Total Registros
     *ÀVariables de informe

       LOCAL cNomEst := ''                  // Nombre del Estudiante
       LOCAL cApeEst := ''                  // Apellido del Estudiante
       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL lRetEst := .F.                 // .T. Estudiante Retirado
       LOCAL cConcep := ''                  // Conceptos del Estudiante

       LOCAL cCodCon := ''                  // C¢digo del Concepto
       LOCAL cNomCon := ''                  // Nombre del Concepto
       LOCAL nMesIni := ''                  // Mes Inicial por facturar
       LOCAL nMesFin := ''                  // Mes Final por facturar
       LOCAL cMesCoE := ''                  // Meses pagados
       LOCAL cMesPag := ''                  // Meses pagados
       LOCAL cObserv := ''                  // Observaci¢n

       LOCAL aConcep := {}                  // Conceptos del Estudiante
       LOCAL aEstCon := {}                  // Estudiantes con Conceptos

       LOCAL aConce1 := {}                  // Conceptos del Estudiante
       LOCAL aEstCo1 := {}                  // Estudiantes con Conceptos

       LOCAL aTotCon := {}                  // Total Conceptos
       LOCAL aConEst := {}                  // Conceptos de los Estudiantes

       LOCAL aTotFac := {}                  // Total Conceptos Facturados
       LOCAL aConFac := {}                  // Conceptos facturados

       LOCAL aTotCoE := {}                  // Conceptos del Estudiante
       LOCAL aEstCoE := {}                  // Conceptos del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONCEPTOS DEL ESTUDIANTE
       SELECT &cMaeAct
       aConcep := aConcepEst(cMaeAct)
       IF LEN(aConcep) == 0
	  RETURN aTotReg
       ENDIF
*>>>>FIN CONCEPTOS DEL ESTUDIANTE

*>>>>LECTURA DE LOS CONCEPTOS DEL ESTUDIANTE
       cCodEst := xPrm(aConcep,'cCodEst')
       cNomEst := xPrm(aConcep,'cNomEst')
       cApeEst := xPrm(aConcep,'cApeEst')
       cCodGru := xPrm(aConcep,'cCodGru')
       lRetEst := xPrm(aConcep,'lRetEst')
       cConcep := xPrm(aConcep,'cConcep')

       aTotCon := xPrm(aConcep,'aTotCon')
       aTotFac := xPrm(aConcep,'aTotFac')
       aTotCoE := xPrm(aConcep,'aTotCoE')
*>>>>FIN LECTURA DE LOS CONCEPTOS DEL ESTUDIANTE

*>>>>CONCEPTOS INDIVIDUALES
       aConce1 := {}
       aEstCo1 := {}
       FOR i := 1 TO LEN(aTotCon)

	   aConce1 := aTotCon[i]
	   cCodCon := xPrm(aConce1,'cCodCon')

	   IF !lLocatePrm(aEstCo1,'cCodCon',cCodCon)
	      AADD(aEstCo1,{'cCodCon',cCodCon})
	   ENDIF

       ENDFOR
*>>>>FIN CONCEPTOS INDIVIDUALES

*>>>>FACTURACION POR CONCEPTOS
       FOR i := 1 TO LEN(aTotCoE)

	   aConce1 := aTotCoE[i]
	   cCodCon := xPrm(aConce1,'cCodCon')

	   IF !lLocatePrm(aEstCo1,'cCodCon',cCodCon)
	      AADD(aEstCo1,{'cCodCon',cCodCon})
	   ENDIF

       ENDFOR
*>>>>FIN FACTURACION POR CONCEPTOS

*>>>>CONCEPTOS FACTURADOS
       FOR i := 1 TO LEN(aTotFac)

	   aConce1 := aTotFac[i]
	   cCodCon := xPrm(aConce1,'cCodCon')

	   IF !lLocatePrm(aEstCo1,'cCodCon',cCodCon)
	      AADD(aEstCo1,{'cCodCon',cCodCon})
	   ENDIF

       ENDFOR
*>>>>FIN CONCEPTOS FACTURADOS

*>>>>IMPRESION DEL REGISTRO
       aRegPrn := {}
       DO CASE
       CASE UPPER(cCodInf) == 'CAR61200'
	    AADD(aRegPrn,cCodEst)
	    AADD(aRegPrn,cCodGru)
	    AADD(aRegPrn,cNomEst)
	    AADD(aRegPrn,cConcep)       // Concepto
	    AADD(aRegPrn,'')            // Mes
	    AADD(aRegPrn,'')            // Mes
	    AADD(aRegPrn,'')            // Por Conceptos
	    AADD(aRegPrn,'')            // Facturados
	    AADD(aRegPrn,'')            // Observaciones
       ENDCASE
*>>>>FIN IMPRESION DEL REGISTRO

*>>>>RECORRIDO DE LOS CONCEPTOS
       FOR i := 1 TO LEN(aEstCo1)

	   cCodCon := aEstCo1[i,2]

***********CONCEPTOS FACTURADOS
	     k := nLocArrPrm(aTotFac,'cCodCon',cCodCon)
	     IF k == 0
		cNomCon := ''
		cMesPag := ''
	     ELSE
		aConFac := aTotFac[k]
		cNomCon := xPrm(aConFac,'cNomCon')
		cMesPag := xPrm(aConFac,'cMesPag')
	     ENDIF
***********FIN CONCEPTOS FACTURADOS

***********FACTURACION POR CONCEPTOS
	     k := nLocArrPrm(aTotCoE,'cCodCon',cCodCon)
	     IF k == 0
		nMesIni := 0
		nMesFin := 0
		cMesCoE := ''
	     ELSE
		aEstCoE := aTotCoE[k]
		cNomCon := xPrm(aEstCoE,'cNomCon')
		nMesIni := xPrm(aEstCoE,'nIniCoE')
		nMesFin := xPrm(aEstCoE,'nFinCoE')
		cMesCoE := xPrm(aEstCoE,'cPagCoE')
	     ENDIF
***********FIN FACTURACION POR CONCEPTOS

************VALIDACION
	      cObserv := ''
	      DO CASE
	      CASE EMPTY(cMesPag)
		   cObserv := 'POR FACTURAR'

	      CASE !EMPTY(cMesCoE) .AND. cMesCoE # cMesPag

		   FOR k := 1 TO 12
		       IF SUBS(cMesCoE,k,1) # SUBS(cMesPag,k,1)
			  IF SUBS(cMesCoE,k,1) # 'F'
			     cObserv := 'DIFERENCIAS EN LA FORMA DE PAGO'
			  ENDIF
		       ENDIF
		   ENDFOR

	      ENDCASE
	      IF nOpcion == 1 .AND. EMPTY(cObserv)
		 LOOP
	      ENDIF
************FIN VALIDACION

*************REGISTRO. DETALLES DEL ESTUDIANTE
	       IF LEN(aRegPrn) # 0
		  AADD(aTotReg,aRegPrn)
	       ENDIF
*************FIN REGISTRO. DETALLES DEL ESTUDIANTE

************IMPRESION DEL REGISTRO
	      aRegPrn := {}
	      DO CASE
	      CASE UPPER(cCodInf) == 'CAR61200'
		   AADD(aRegPrn,cCodCon)       // C¢digo Estudiante
		   AADD(aRegPrn,'')            // C¢digo Grupo
		   AADD(aRegPrn,cNomCon)       // Nombre del Estudiante
		   AADD(aRegPrn,'')            // Concepto
		   AADD(aRegPrn,IF(nMesIni==0,'',cMes(nMesIni,3)))
		   AADD(aRegPrn,IF(nMesFin==0,'',cMes(nMesFin,3)))
		   AADD(aRegPrn,cMesCoE)
		   AADD(aRegPrn,cMesPag)
		   AADD(aRegPrn,cObserv)       // Observaciones
	      ENDCASE
	      AADD(aTotReg,aRegPrn)
	      aRegPrn := {}
************FIN IMPRESION DEL REGISTRO

       ENDFOR
       RETURN aTotReg
*>>>>FIN RECORRIDO DE LOS CONCEPTOS

