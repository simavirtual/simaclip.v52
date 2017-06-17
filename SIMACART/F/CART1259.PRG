/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: PAGOS POR FORMA DE PAGO

**************************************************************************
* TITULO..: PAGOS POR FORMA DE PAGO                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 05/2010 VIE A
       Bucaramanga, Colombia	    INICIO: 07:30 AM   MAR 05/2010 VIE

OBJETIVOS:

1- Permite imprimir los pagos de acuerdo a la forma de pago.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cart1_259(aP1,aP2,aP3)

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
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-CART.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL   i,j,k := 0                   // Contador
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
     *ÀVariables de informe

       LOCAL cCodGru := ''                  // C¢digo del Grupo.
       LOCAL aRecPag := {}                  // Recibos Pago

       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL lValida := .F.                 // .T. Validar por Estudiante.

       LOCAL nOpcion := 0                   // Opci¢n de selecci¢n
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n

       LOCAL Getlist := {}                  // Variable del sistema

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)

       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL A¥O')

       CASE CAA->nMesIniCaA == 0
	    cError('NO SE HA DEFINIDO EL MES INICIAL DE LA FACTURACION')

       CASE CAA->nMesFinCaA == 0
	    cError('NO SE HA DEFINIDO EL MES FINAL DE LA FACTURACION')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de la facturaci¢n',.T.)
       RESTORE SCREEN
       IF nMesIni == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

nRegFin := nRegIni

*>>>>SELECION DEL TIPO DE INFORME
       nOpcion := 1
/*
       nOpcion := nLeeOpcion('TIPO DE INFORME?: '+;
		 '1<SIN FECHA DE CORTE> 2<CON FECHA DE CORTE?',2,'0')
*/
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECION DEL TIPO DE INFORME

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')
       lPrnFec := IF(nOpcion == 1,.F.,.T.)
       IF lPrnFec

	  RESTSCREEN(0,0,24,79,cSavPan)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	  @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(dFecPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>ANALISIS DE DECISION
       lValida := .F.
/*
       IF nRegIni == nRegFin
	  lValida := lPregunta('DESEA IMPRIMIR EL INFORME CON DETALLE '+;
			       'POR CADA ESTUDIANTE? No Si')
       ENDIF
*/
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>GESTION DOCUMENTAL DEL INFORME
       nNroIso := 1259
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<INFORMES><FACTURACION MES><PAGOS FORMA DE PAGO>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'PAGOS FORMA DE PAGO')  // T¡tulo Uno
       AADD(aTitIso,'')  // T¡tulo Dos
       AADD(aTitIso,'')  // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       aPieIso := {}
       AADD(aPieIso,'')  // Pie de p gina Uno
       AADD(aPieIso,'')  // Pie de p gina Dos
       AADD(aPieIso,'')  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'FormaPag'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       cCodGru := ''

       aCabPrn := {cNomEmp,cNomSis,;
		   'PAGOS POR FORMA DE PAGO',;
		   'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
				       SUBS(cCodGru,3,2)+;
			   ' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,32,12,16,16,16,16}
       aTitPrn := {'No','CODIGO','APELLIDOS Y NOMBRES','FECHA PAGO',;
		   'PAGO OPO','PAGO EXT','TOTAL PAGO','DESCUENTO'}

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

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

*       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
	    SET DEVICE TO SCREEN
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    FormaPag(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		     cMaeAlu,cMaeAct,cJorTxt,nMesIni,dFecPrn,;
		     lPrnFec,GRU->cCodigoGru,FilePrn,nHanXml,;
		     nOpcPrn)

	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPO

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: PAGOS POR FORMA DE PAGO OPORTUNO Y EXTEMPORANEO              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2010 JUE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   MAR 11/2010 JUE

OBJETIVOS:

1- Imprime la relaci¢n de pago por formas de pago.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FormaPag(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		  cMaeAlu,cMaeAct,cJorTxt,nMesIni,dFecPrn,;
		  lPrnFec,cCodGru,FilePrn,nHanXml,nOpcPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       nMesIni                              // Mes Inicial
       cCodGru                              // C¢digo del grupo
       dFecPrn                              // Fecha de Impresi¢n de Corte
       lPrnFec                              // .T. Imprimir por Fechas
       FilePrn                              // Archivo de impresion
       nHanXml                              // Manejador del Archivo
       nOpcPrn                              // Opci¢n de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL   i,j,k := 0                   // Contador
*       LOCAL FilePrn := ''                  // Archivo de impresion
*       LOCAL nHanXml := 0                   // Manejador del Archivo
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
*       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL aRecPag := {}                  // Recibos Pago
       LOCAL aFecPag := {}                  // Fecha de pago
       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL cObserv := ''                  // Observaci¢n
       LOCAL cNotCli := ''                  // Nota del Cliente

       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL aVlrCon := {}                  // Valores por conceptos
       LOCAL nVlrOpo := 0                   // Valor Oportuno
       LOCAL nVlrExt := 0                   // Valor Extemporaneo
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nVlrAde := 0                   // Valor por adelantado

       LOCAL nGruOpo := 0                   // Total Oportuno
       LOCAL nGruExt := 0                   // Total Extemporaneo
       LOCAL nGruDes := 0                   // Total Descuentos
       LOCAL nTotGru := 0                   // Total Grupo

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'PAGOS POR FORMA DE PAGO',;
		   'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
				       SUBS(cCodGru,3,2)+;
			   ' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,32,12,16,16,16,16}
       aTitPrn := {'No','CODIGO','APELLIDOS Y NOMBRES','FECHA PAGO',;
		   'PAGO OPO','PAGO EXT','TOTAL PAGO','DESCUENTO'}

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

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

/*
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn)
*/
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       nGruOpo := 0
       nGruExt := 0
       nGruDes := 0

       SELECT CLI
       CLI->(DBGOTOP())
       DO WHILE .NOT. CLI->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    lRetadoTes := .F.
	    IF lHayAlu
	       IF &cMaeAct->lRetiroEst
		  lRetadoTes := .T.
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********LOCALIZACION DEL PAGO
	    lHayPag := .F.
	    IF lHayAlu
	       lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********ANALISIS DE LA FECHA DE PAGO
	    lFechOk := .F.
	    IF lHayPag .AND. (PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A')

	       lFechOk := .T.
	       IF lPrnFec .AND. PAG->dFecPagPag > dFecPrn
		  lFechOk := .F.
	       ENDIF

	    ENDIF
**********FIN ANALISIS DE LA FECHA DE PAGO

**********IMPRESION DEL REGISTRO
	    IF lFechOk

	       aRegPrn := {}
	       AADD(aRegPrn,STR(CLI->(RECNO()),2))
	       AADD(aRegPrn,CLI->cCodigoEst)
	       AADD(aRegPrn,SPACE(01)+cNombreTes)

	       IF PAG->cEstadoPag == 'P'
		  nVlrMes := 0

		  nVlrOpo := PAG->nSdoAntPag+;
			     PAG->nMorAntPag+;
			     nVlrMesMtd(aVlrCon,@nVlrMes)

		  IF PAG->nMesIniPag # PAG->nMesFinPag
		     nVlrAde := nVlrMes * (PAG->nMesFinPag - PAG->nMesIniPag)
		     nVlrOpo += nVlrAde
		  ENDIF
		*ÀRecibo por adelantado

		  nVlrExt := 0
		  nVlrDes := PAG->nVlrpagPag - nVlrOpo
	       ELSE
		  nVlrOpo := 0
		  nVlrExt := PAG->nVlrpagPag
		  nVlrDes := 0
	       ENDIF

	       nGruOpo += nVlrOpo
	       nGruExt += nVlrExt
	       nTotGru += nVlrOpo+nVlrExt
	       nGruDes += nVlrDes

	       AADD(aRegPrn,cFecha(PAG->dFecPagPag))
	       AADD(aRegPrn,TRANS(nVlrOpo,"####,###,###"))
	       AADD(aRegPrn,TRANS(nVlrExt,"####,###,###"))
	       AADD(aRegPrn,TRANS(nVlrOpo+nVlrExt,"####,###,###"))
	       AADD(aRegPrn,TRANS(nVlrDes,"####,###,###"))

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
	    IF CLI->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>TOTALIZACION DEL GRUPO
       aRegPrn := {}
       AADD(aRegPrn,'')
       AADD(aRegPrn,GRU->cCodigoGru)
       AADD(aRegPrn,'')
       AADD(aRegPrn,'')
       AADD(aRegPrn,TRANS(nGruOpo,"####,###,###"))
       AADD(aRegPrn,TRANS(nGruExt,"####,###,###"))
       AADD(aRegPrn,TRANS(nTotGru,"####,###,###"))
       AADD(aRegPrn,TRANS(nGruDes,"####,###,###"))

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

       EVAL(bDerAut)
      *Derechos de Autor
       EJECT

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN TOTALIZACION DEL GRUPO

/*************************************************************************
* TITULO..: VALOR DEL MES POR METODO DE FACTURACION                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/2010 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   MAR 12/2010 VIE

OBJETIVOS:

1- Totaliza el valor de todos los conceptos facturados para un mes
   tomando los conceptos del m‚todo de facturaci¢n del virrey.

2- Retorna el total del valor del mes

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrMesMtd(aVlrCon,nVlrMes)

*>>>>DESCRIPCION DE PARAMESTROS
/*     aVlrCon                              // @Valor de los Conceptos
       nVlrMes                              // @Valor del Mes */
*>>>>FIN DESCRIPCION DE PARAMESTROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nTotMes := 0                   // Total del Mes

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL VALOR DEL MES
       nVlrMes := 0
       aVlrCon := {}
       FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

***********LOCALIZACION DEL VALOR DEL CONCEPTO
	     cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)

	     IF cCodigoTco $ PAG->cConcepPag
		nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
		nVlrCon := &('PAG->nVl2Co'+STR(nNroPos,1)+'Pag')
	     ELSE
		nVlrCon := 0
	     ENDIF

	     nVlrMes += nVlrCon
	     AADD(aVlrCon,nVlrCon)
***********FIN LOCALIZACION DEL VALOR DEL CONCEPTO

       ENDFOR
       nTotMes := nVlrMes - PAG->nVlrBecPag - PAG->nVlrDesPag -;
			    PAG->nDesGenPag - PAG->nPagParPag +;
			    PAG->nVlrRecPag + PAG->nRecGenPag
       RETURN nTotMes
*>>>>FIN CALCULO DEL VALOR DEL MES