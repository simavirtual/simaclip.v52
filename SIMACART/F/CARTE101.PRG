/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: UN SOLO RECIBO         MODULO No. 101

**************************************************************************
* TITULO..: FACTURACION DE UN SOLO RECIBO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/1994 JUE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   MAY 12/1994 JUE

OBJETIVOS:

1- Imprime un solo recibo de pago de un estudiante.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_101(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			      // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"              // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
       #DEFINE  TAMPA22 CHR(27)+'C'+CHR(22) // P gina de 22 l¡neas
       #DEFINE  TAMPA34 CHR(27)+'C'+CHR(34) // P gina de 34 l¡neas
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathRfa := ''                  // Path Recibos facturados
       LOCAL fRecFac := 'RECI'              // Ej: RECIENE.DAT

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

       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀVariables de informe

       LOCAL nCodPaz := 0                   // C¢digo del Paz y Salvo
       LOCAL cCampos := ''                  // Variable de Campo
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL lGrabar := .F.                 // .T. Grabar el pago

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL nVlrTot := 0                   // Valor total del recibo
       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL cNroFac := ''                  // N£mero de la factura. Consecutivo
       LOCAL lPrnGru := .T.                 // Impresi¢n por grupos
       LOCAL nVlrCo1 := 0                   // Valor del Concepto No. 1
       LOCAL nVlrCo2 := 0                   // Valor del Concepto No. 2
       LOCAL nVlrCo3 := 0                   // Valor del Concepto No. 3
       LOCAL nVlrCo4 := 0                   // Valor del Concepto No. 4
       LOCAL nVlrCo5 := 0                   // Valor del Concepto No. 5
       LOCAL nVlrCo6 := 0                   // Valor del Concepto No. 6
       LOCAL nVlrCo7 := 0                   // Valor del Concepto No. 7
       LOCAL nVlrCo8 := 0                   // Valor del Concepto No. 8
       LOCAL nVl2Co1 := 0                   // Valor2 del Concepto No. 1
       LOCAL nVl2Co2 := 0                   // Valor2 del Concepto No. 2
       LOCAL nVl2Co3 := 0                   // Valor2 del Concepto No. 3
       LOCAL nVl2Co4 := 0                   // Valor2 del Concepto No. 4
       LOCAL nVl2Co5 := 0                   // Valor2 del Concepto No. 5
       LOCAL nVl2Co6 := 0                   // Valor2 del Concepto No. 6
       LOCAL nVl2Co7 := 0                   // Valor2 del Concepto No. 7
       LOCAL nVl2Co8 := 0                   // Valor2 del Concepto No. 8
       LOCAL lHayBec := .F.                 // .T. Se aplico la beca
       LOCAL nVlrBec := 0                   // Valor de la Beca
       LOCAL nDescue := 0                   // Valor del Descuento
       LOCAL nPagPar := 0                   // Valor Pago Parcial
       LOCAL nRecarg := 0                   // Valor del Recargo
       LOCAL nDesGen := 0                   // Descuento General
       LOCAL nRecGen := 0                   // Recargo General
       LOCAL cConGen := ''                  // Concepto General
       LOCAL lDesGen := .F.                 // .T. Autorizar Descuento General
       LOCAL nVlrGen := 0                   // Descuento o Recargo General
       LOCAL cMsgTxt := ''                  // Texto temporal
       LOCAL cConcep := ''                  // Conceptos por cobrar
       LOCAL nFavDes := 0                   // Saldo a Favor Descontado.
       LOCAL nSdoFav := 0                   // Saldo a Favor

       LOCAL aConcep := {}                  // Conceptos por cobrar
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL lHayCoE := .F.                 // .T. Hay Concptos Individuales

       LOCAL nIntPen := 0                   // Intereses de pension
       LOCAL nIntDeu := 0                   // Intereses para el no pago
       LOCAL lPrnRec := .T.                 // .T. Imprimir el Recibo
       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL nTipPer := 0                   // Tipo de Persona
       LOCAL aRecFac := {}                  // Recibo Facturado
       LOCAL aConAlu := {}                  // Conceptos por Estudiante
       LOCAL nDiaMor := 0                   // Dias en Mora
       LOCAL nMesSdo := 0                   // Mes del saldo

       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL cEstadoTpa := ''               // Estado del pago
       LOCAL nVlrMesTpa := 0                // Valor recibo para un mes
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
       LOCAL nLicAct := xPrm(aP1,'nLicAct') // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
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

       CloseAll()
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTORE SCREEN
       IF nMesIniTpa == 0
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>DIRECTORIOS
       PathAct := cPathAct()

       PathRfa := cPatSis+'\RECIBOS\'+cMes(nMesIniTpa,3)
       Mdir(PathRfa,PathAct)
     *ÀDirectorio para el mes de los recibos facturados
*>>>>FIN DIRECTORIOS

*>>>>VALIDACION DEL ARCHIVO
       fRecFac := 'RECI'+cMes(nMesIniTpa,3)+ExtFile
       IF !FILE(PathRfa+'\'+fRecFac)
	  CreaDbfRfa(lShared,nModCry,PathRfa,fRecFac)
       ENDIF
       nActStrRfa(lShared,nModCry,PathRfa,fRecFac)
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})


       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 fPazEst+cAnoSis+ExtFile,'PAZ',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})


       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileBan,'BAN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCvn,'CVN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathRfa+'\'+fRecFac,'RFA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE EMPTY(SCO->cCodEanCon)
	    cError('NO SE HA DEFINIDO EL CODIGO EAN13 PARA EL RECAUDO')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE EMPTY(CAR->cCodFacCar)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nMesIniCaA == 0
	    cError('SE DEBE DEFINIR EL MES INICIAL DE LA FACTURACION')
	    
       CASE CAA->nMesFinCaA == 0
	    cError('SE DEBE DEFINIR EL MES FINAL DE LA FACTURACION')

       CASE nMesIniTpa < CAA->nMesIniCaA
	    cError('EL MES INICIAL NO DEBE SER MENOR A '+cMes(nMesIniTpa))

       CASE nMesIniTpa > CAA->nMesFinCaA
	    cError('EL MES FINAL NO DEBE SER MAYOR A '+cMes(nMesIniTpa))

       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA == 10
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA > 11
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE CAA->nDesGenCaA # 0 .AND. CAA->nRecGenCaA # 0
	    cError('NO SE PUEDE APLICAR DESCUENTOS Y RECARGOS A LA VEZ')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LOCALIZACION ITEM DEL PAZ Y SALVO
       nCodPaz := 0
       IF lLocCodigo('nNroTipPaz','PAZ',1)
	  nCodPaz := PAZ->nCodigoPaz
       ENDIF
       IF EMPTY(nCodPaz)
	  cError('NO ESTA HABILITADO EL ITEM DE LOS PAZ Y SALVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION ITEM DEL PAZ Y SALVO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 101
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<RECIBOS>'
     *ÀOpci¢n del sistema del informe

       cCodInf := 'CARRECIB'
       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID

       nNroDoc := 0
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'RECIBO DE PAGO')                   // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(CAR->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')

       cUsrIso := CAR->cUsrIsoCar
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

*>>>>ANALISIS DE DECISION DEL DESCUENTO GENERAL
       IF !EMPTY(CAA->nDesGenCaA) .OR. !EMPTY(CAA->nRecGenCaA)

**********ANALISIS DE DESCUENTO O RECARGO
	    DO CASE
	    CASE !EMPTY(CAA->nDesGenCaA)
		 cMsgTxt := 'DESCUENTO'
		 nVlrGen := CAA->nDesGenCaA

	    CASE !EMPTY(CAA->nRecGenCaA)
		 cMsgTxt := 'RECARGO'
		 nVlrGen := CAA->nRecGenCaA
	    ENDCASE
**********FIN ANALISIS DE DESCUENTO O RECARGO

**********PREGUNTA DE DECISION
	    lDesGen := .T.
	    IF !lPregunta('VA APLICAR UN '+cMsgTxt+' GENERAL DE '+;
			  TRANS(nVlrGen,'$999999.99')+' PESOS? Si No')

	       IF CAA->(lRegLock(lShared,.F.))
		  REPL CAA->nDesGenCaA WITH 0
		  REPL CAA->nRecGenCaA WITH 0
		  REPL CAA->cConGenCaA WITH ''
	       ENDIF
	     *ÀBorrado de los datos del descuento o recargo general

	       lDesGen:= .F.
	    ENDIF

	    IF !lPregunta('DESEA CONTINUAR? Si No')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN PREGUNTA DE DECISION

       ENDIF
*>>>>FIN ANALISIS DE DECISION DEL DESCUENTO GENERAL

*>>>>VALIDACION DEL CONCEPTO GENERAL
       IF lDesGen
	  IF !lLocCodigo('cCodigoCon','CON',CAA->cConGenCaA)
	     cError('NO EXISTE EL CONCEPTO GENERAL '+CAA->cConGenCaA)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL CONCEPTO GENERAL

*>>>>VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO
       IF CAA->cCodigoBan == cSpaces('BAN','cCodigoBan')
	  cError('A CONTINUACION ESCOJA EL BANCO',;
		 'NO SE HA DEFINIDO EL BANCO DONDE SE DEBE PAGAR')
	  CambiaBan(lShared,nFilInf+1,nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO

*>>>>LECTURA DE LOS DETALLES DEL BANCO
       IF !lLocCodBan(CAA->cCodigoBan)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LOS DETALLES DEL BANCO

*>>>>CONSULTA DE LOS DETALLES PARA LA FACTURACION
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,BAN->cNroctaBan,;
		   nMesIniTpa,nMesIniTpa,cAnoUsr)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nMesIniTpa,;
				nMesIniTpa,cAnoUsr)})

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN PREGUNTA DE DECISION

*>>>>IMPRESION DE LA LINEA DE ESTADO
       LineaEstado('FACTURACION DE '+cMes(nMesIniTpa,3)+;
		   ' A '+cMes(nMesIniTpa,3),cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>VALIDACION DEL NUMERO DE LA FACTURA
       IF (CAA->nRecNroCaA == 5 .OR. CAA->nRecNroCaA == 6 .OR.;
	   CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9) .AND.;
	  !SCO->lHayNroCon
	  cError('NO ESTA ACTIVADA EL NUMERO DE LA FACTURACION')
	  IF !lPregunta('DESEA IMPRIMIR EL RECIBO SIN EL '+;
			'NUMERO DE FACTURACION?No Si')
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL NUMERO DE LA FACTURA

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       FileCli := ''
       FilePag := ''
       DO WHILE .T.

**********CIERRE DE ARCHIVOS
	    IF SELECT('CLI') # 0
	       CloseDbf('CLI',FileCli,nModCry)
	    ENDIF

	    IF SELECT('PAG') # 0
	       CloseDbf('PAG',FilePag,nModCry)
	    ENDIF
**********FIN CIERRE DE ARCHIVOS

/*

**********CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR
	    SET DEVICE TO SCREEN
	    IF SCO->lHayNroCon
	       cNroFac := STR(SCO->nNroFacCon+1,9)
	       lCorrecion(@cNroFac,.T.)

	       @ nFilInf+1,nColInf+7 SAY 'RECIBO No.'
	       SET COLOR TO G*
	       @ nFilInf+1,nColInf+18 SAY SCO->cCodEmpCon+'-'+cNroFac
	       SET COLOR TO
	    ENDIF
**********FIN CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR

*/

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,;
				     cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********LECTURA DE LOS CONTRATANTES
	    aDocNit := {}

	    IF !EMPTY(&cMaeAct->cNitCo1Est)
	       AADD(aDocNit,{&cMaeAct->cNitCo1Est,;
			     &cMaeAct->cTipCo1Est})
	    ENDIF

	    IF !EMPTY(&cMaeAct->cNitCo2Est)
	       AADD(aDocNit,{&cMaeAct->cNitCo2Est,;
			     &cMaeAct->cTipCo2Est})
	    ENDIF
**********FIN LECTURA DE LOS CONTRATANTES

**********ANALISIS DEL CONTRATANTE
	    aRecFac := {}
	    AADD(aRecFac,{'cCodEmp',SCO->cCodEmpCon})
	    AADD(aRecFac,{'cCodFac',CAR->cCodFacCar})

	    AADD(aRecFac,{'cTxtUno',CAA->cTxtUnoCaA})
	    AADD(aRecFac,{'cTxtDos',CAA->cTxtDosCaA})
	    AADD(aRecFac,{'cCodeQr',CAA->cCodeQrCaA})

	    AADD(aRecFac,{'cNitCn1',' '})
	    AADD(aRecFac,{'cNomCn1',' '})
	    AADD(aRecFac,{'cNitCn2',' '})
	    AADD(aRecFac,{'cNomCn2',' '})


	    FOR i:=1 TO LEN(aDocNit)

	       IF EMPTY(aDocNit[i,1])
		  LOOP
	       ENDIF

	       nTipPer := nTipPerMae(aDocNit[i,1],;
				     &cMaeAct->cPadNitEst,;
				     &cMaeAct->cMadNitEst)

	       DO CASE
	       CASE nTipPer == 1     // Padre

		    IF i == 1
		       nParameSet(aRecFac,'cNitCn1',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn1',ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
						    ALLTRIM(&cMaeAct->cApePadEst))
		    ELSE
		       nParameSet(aRecFac,'cNitCn2',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn2',ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
						    ALLTRIM(&cMaeAct->cApePadEst))

		    ENDIF

	       CASE nTipPer == 2     // Madre

		    IF i == 1
		       nParameSet(aRecFac,'cNitCn1',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn1',ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
						    ALLTRIM(&cMaeAct->cApeMadEst))
		    ELSE
		       nParameSet(aRecFac,'cNitCn2',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn2',ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
						    ALLTRIM(&cMaeAct->cApeMadEst))
		    ENDIF
                                            


	       CASE nTipPer == 3     // Otra Persona

		    IF lLocNitPer(aDocNit[i,1],aDocNit[i,2])

		       IF i == 1
			  nParameSet(aRecFac,'cNitCn1',aDocNit[i,1])
			  nParameSet(aRecFac,'cNomCn1',cNomPer(PER->cApeUnoPer,;
							       PER->cApeDosPer,;
							       PER->cNomUnoPer,;
							       PER->cNomDosPer))

		       ELSE
			  nParameSet(aRecFac,'cNitCn2',aDocNit[i,1])
			  nParameSet(aRecFac,'cNomCn2',cNomPer(PER->cApeUnoPer,;
							       PER->cApeDosPer,;
							       PER->cNomUnoPer,;
							       PER->cNomDosPer))
		       ENDIF

		    ELSE

		       IF i == 1
			  nParameSet(aRecFac,'cNitCn1',aDocNit[i,1])
			  nParameSet(aRecFac,'cNomCn1','PERSONA NO EXISTE')
		       ELSE
			  nParameSet(aRecFac,'cNitCn2',aDocNit[i,1])
			  nParameSet(aRecFac,'cNomCn2','PERSONA NO EXISTE')
		       ENDIF

		    ENDIF

	       ENDCASE

	    NEXT
**********FIN ANALISIS DEL CONTRATANTE


**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(RTRIM(cNombreTes)+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cMaeAct->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cMaeAct->lRetiroEst .AND.;
	       CLI->nSdoActCli+CLI->nSdoMorCli == 0

	       cError(cNombreTes+' DEL GRUPO '+&cMaeAct->cCodigoGru+;
		     ' ESTA RETIRADO')

	       IF nMesIniTpa > &cMaeAct->nUltRecEst
		  cError('EL ULTIMO RECIBO AUTORIZADO PARA IMPRIMIR ES EL '+;
			 'DEL MES DE '+cMes(&cMaeAct->nUltRecEst))
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       cError('NO SE IMPRIME EL RECIBO. DECIDIO NO CONTINUAR')
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       cError(cNombreTes+' NO PERTENCE AL GRUPO: '+&cMaeAct->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********GRABACION DEL CONTROL CONCEPTOS INDIVIDUALES
	    lHayCoE := lHayConCoE(cCodigoTes,ALLTRIM(CAA->cConPenCaA)+;
					     ALLTRIM(&cMaeAct->cConcepEst)+;
					     ALLTRIM(CLI->cConSdoCli))

	    IF lHayCoE
	       SaveConCoE(lShared,cNomUsr,cCodigoTes,;
			  nMesIniTpa,CAA->nMesFinCaA,;
			  ALLTRIM(CAA->cConPenCaA),;
			  CLI->cMesPagCli)
	     *ÀConceptos Generales

	       SaveConCoE(lShared,cNomUsr,cCodigoTes,;
			  nMesIniTpa,CAA->nMesFinCaA,;
			  ALLTRIM(&cMaeAct->cConcepEst),;
			  '')
	     *ÀConceptos Individuales

	    ENDIF
**********FIN GRABACION DEL CONTROL CONCEPTOS INDIVIDUALES

**********ANTIGUEDAD DEL SALDO PENDIENTE
	    aConAlu := {}
	    nDiaMor := 0
	    nMesSdo := 0
	    IF CLI->nSdoActCli+CLI->nSdoMorCli > 0

	       IF lLocCodPag(CLI->cCodigoEst,;
			     nMesUltPag(CLI->cCodigoEst),.F.)

		  lVlrConSdo(CLI->nSdoActCli,0,aConAlu,@nDiaMor,@nMesSdo)

	       ENDIF

	    ENDIF
**********FIN ANTIGUEDAD DEL SALDO

**********ANALISIS PARA LA IMPRESION DEL RECIBO
	    nRegPag := 0
	    IF !lFacturado(CLI->cCodigoEst,nMesIniTpa,@nRegPag,;
			   cNombreTes+' DEL GRUPO: '+&cMaeAct->cCodigoGru,;
			   &cMaeAct->nUltRecEst,lHayCoE)
	       LOOP
	    ENDIF
	    SELECT CLI
**********FIN ANALISIS PARA LA IMPRESION DEL RECIBO

**********ANALISIS PARA REPETIR EL RECIBO
	    IF nRegPag # 0
	       PAG->(DBGOTO(nRegPag))
	       IF .NOT. EMPTY(PAG->cIniFinPag)
		  cError('PARA REPETIR EL RECIBO DEBE HACERLO POR FACTURAR CONCEPTOS')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA REPETIR EL RECIBO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('DE '+cMes(nMesIniTpa,3)+;
			' A '+cMes(nMesIniTpa,3)+;
			'ºGRUPO: '+&cMaeAct->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			'ºNo. '+STR(CLI->(RECNO()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO


**********INICIALIZACION DE LOS CONCEPTOS
	    IF lHayCoE
	       aConcep := aConEst(CLI->cCodigoEst,;
				  CAA->cConPenCaA,;
				  &cMaeAct->cConcepEst,;
				  &cMaeAct->cCodigoGru,;
				  nMesIniTpa,;
				  nMesIniTpa,;
				  &cMaeAct->nUltRecEst)


	    ENDIF
**********FIN INICIALIZACION DE LOS CONCEPTOS


**********VALIDACION DEL MES
	    IF lHayCoE

	       FOR i := 1 TO LEN(aConcep)

		   nMesIni := aConcep[i,2]
		   nMesFin := aConcep[i,3]
		   IF nMesIniTpa # nMesIni
		      aConcep[i,2] := 0
		      aConcep[i,3] := 0
		      cError('Para '+ALLTRIM(aConcep[i,5])+;
			     ' NO se permite facturar un '+;
			     'mes diferente de '+cMes(nMesIni,3))
		      LOOP
		   ENDIF

	       NEXT
	       cConcep := cConcep(aConcep)
	       cConcep := SUBS(cConcep+SPACE(14),1,14)


	       IF EMPTY(cConcep) .AND.;
		  CLI->nSdoActCli+CLI->nSdoMorCli == 0
		  cError('NO TIENE CONCEPTOS POR FACTURAR')
		  LOOP
	       ENDIF

	    ENDIF
**********FIN VALIDACION DEL MES

**********CONCEPTOS A FACTURAR SIN CONTROL DE INDIVIDUALES
	    IF !lHayCoE
	       cConcep := ALLTRIM(CAA->cConPenCaA)+;
			  ALLTRIM(&cMaeAct->cConcepEst)+SPACE(14)
	       cConcep := SUBS(cConcep,1,14)
	    ENDIF
**********FIN CONCEPTOS A FACTURAR SIN CONTROL DE INDIVIDUALES

**********ELIMINACION DE CONCEPTOS
	    IF &cMaeAct->lRetiroEst .AND.;
	       CLI->nSdoActCli+CLI->nSdoMorCli # 0
	       cConcep := SPACE(14)
	    ENDIF
**********FIN ELIMINACION DE CONCEPTOS

**********VALIDACION DEL RECIBO No. 11. Bethlemitas. Barranca
	    IF CAA->nRecNroCaA == 11

	       IF LEN(ALLTRIM(cConcep))/2 > 3
		  cError('NO SE PUEDEN FACTURAR MAS DE 3 CONCEPTOS')
		  LOOP
	       ENDIF

	       cConcep := SUBS(cConcep+SPACE(06),1,6)

	    ENDIF
**********FIN VALIDACION DEL RECIBO No. 11. Bethlemitas. Barranca

**********LOCALIZACION DEL CONVENIO
	    nIntPen := CAA->nIntPenCaA
	    nIntDeu := CAA->nIntDeuCaA
	    lPrnRec := .T.
	    IF CVN->(RECCOUNT()) # 0

	       IF lLocCodigo('cCodigoEst','CVN',CLI->cCodigoEst)

		  IF !CVN->lHayIntCvn
		     nIntPen := 0
		     nIntDeu := 0
		  ENDIF

		  lPrnRec := CVN->lPrnRecCvn

	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL CONVENIO

**********ACTIVACION DE LA IMPRESORA
	    IF nNroInf == 0
	       FilePrn := 'recibo'+ALLTRIM(STR(nMesIniTpa,2))
	       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcRecCar,.T.,.T.)
	    ELSE
	       FilePrn := 'recibo'+ALLTRIM(STR(nMesIniTpa,2))
	       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcRecCar,.T.,2,bInsIso)
	    ENDIF
	    IF EMPTY(nOpcPrn)
	       CloseAll()
	       RETURN NIL
	    ENDIF
**********FIN ACTIVACION DE LA IMPRESORA

**********SUSTITUCION DE TEXTO
	    fDocPrn := ''
	    IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
			   @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
			   @fDocPrn)
	       CloseAll()
	       RETURN NIL
	    ENDIF
	    ReplTitIso(@aTitIso,aMezIso)
**********FIN SUSTITUCION DE TEXTO

**********PARAMETROS DEL INFORME
	    aP3 := {}
	    AADD(aP3,{'nCodXsl',CAR->nCodXslCar})
	    AADD(aP3,{'nOpcPrn',nOpcPrn})
	    AADD(aP3,{'FilePrn',FilePrn})

	    AADD(aP3,{'nLenPrn',nLenPrn})
	    AADD(aP3,{'nNroInf',nNroInf})
	    AADD(aP3,{'cOpcSys',cOpcSys})
	    AADD(aP3,{'cCodInf',cCodInf})
	    AADD(aP3,{'aMarInf',aMarInf})
	    AADD(aP3,{'nNroDoc',nNroDoc})
	    AADD(aP3,{'aTitIso',aTitIso})
	    AADD(aP3,{'aPieIso',aPieIso})
	    AADD(aP3,{'aObsIso',aObsIso})
	    AADD(aP3,{'cUsrIso',cUsrIso})
	    AADD(aP3,{'cCodIso',cCodIso})
	    AADD(aP3,{'cFecIso',cFecIso})
	    AADD(aP3,{'cVerIso',cVerIso})
**********FIN PARAMETROS DEL INFORME

**********INICIALIZACION
	    IF CAA->nRecNroCaA < 5 .OR. CAA->nRecNroCaA == 11
	       SendCodes(INICIALIZA+PROPOR_OF+DRAFT_ON)
	    ENDIF
**********FIN INICIALIZACION

**********IMPRESION DEL RECIBO A ARCHIVO
	    IF !lPrnRec
	       cMesIni := STR(nMesIniTpa,2)
	       lCorrecion(@cMesIni)
	       SET PRINTER TO &('PRINTER\'+CLI->cCodigoEst+cMesIni+'.rec')
	    ENDIF
**********FIN IMPRESION DEL RECIBO A ARCHIVO

**********CONFIGURACION DEL TAMA¥O DEL PAPEL
	    DO CASE
	    CASE CAA->nRecNroCaA == 1
		 SendCodes(IF(CAA->lPrePrnCaA,LINESP1_8+TAMPA34,TAMPA22))
		 SendCodes(CONDEN_ON)

	    CASE CAA->nRecNroCaA == 2 .OR. CAA->nRecNroCaA == 11
		 SendCodes(TAMPA22)
		 SendCodes(CONDEN_ON)

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4
		 SendCodes(LINESP1_8+TAMPA34)
		 SendCodes(CONDEN_ON)
	    ENDCASE
	    lPrnGru := .F.
**********FIN CONFIGURACION DEL TAMA¥O DEL PAPEL

**********IMPRISION DEL RECIBO DE PAGO
	    lHayBec := .F.

	    DO CASE
	    CASE CAA->nRecNroCaA == 1

		 nVlrTot := nRecibo01(aRecFac,;
				      lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cJorTxt,xPrm(aP3,'cCodIso'),@nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,CAA->lPrePrnCaA,;
				      lPrnGru,@nVlrCo1,@nVlrCo2,@nVlrCo3,;
				      @nVlrCo4,@nVlrCo5,@nVlrCo6,@nVlrCo7,;
				      @nVlrCo8,@nVl2Co1,@nVl2Co2,@nVl2Co3,;
				      @nVl2Co4,@nVl2Co5,@nVl2Co6,@nVl2Co7,;
				      @nVlrCo8,@lHayBec,@nVlrBec,@nDescue,;
				      @nPagPar,@nRecarg,@nDesGen,@nRecGen,;
				      @cConGen,@nFavDes)
		*Recibo dise¤o Colegio la Salle.

	    CASE CAA->nRecNroCaA == 2

		 nVlrTot := nRecibo02(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes)
		*Recibo dise¤o Colegio la Merced y Bethlemitas



	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4

		 nVlrTot := nRecibo03(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo dise¤o Colegio la Salle con Colilla

	    CASE CAA->nRecNroCaA == 5

		 nVlrTot := nCarRec05(aP1,aP2,aP3,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,;
				      @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				      @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				      @nVl2Co1,@nVl2Co2,@nVl2Co3,@nVl2Co4,;
				      @nVl2Co5,@nVl2Co6,@nVl2Co7,@nVl2Co8,;
				      @lHayBec,@nVlrBec,@nDescue,@nPagPar,;
				      @nRecarg,@nDesGen,@nRecGen,@cConGen,;
				      @nFavDes,nSdoFav)
		*Recibo c¢digo de Barras la Kiosera con formato. Virrey.

	    CASE CAA->nRecNroCaA == 6

		 nVlrTot := nRecibo05(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo c¢digo de Barras la Kiosera. La Presentaci¢n.

	    CASE CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9

		 nVlrTot := nRecibo08(aRecFac,nDiaMor,;
				      lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      xPrm(aP3,'cCodIso'),@nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,@cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo c¢digo de Barras la Kiosera. La Salle

	    CASE CAA->nRecNroCaA == 11

		 nVlrTot := nCarRec11(aP1,aP2,aP3,;
				      @nNroFac,;
				      &cMaeAct->cCodigoEst,cNombreTes,;
				      &cMaeAct->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,NIL,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes)
		*Recibo Bethlemitas. Iso

	    ENDCASE

	    IF VALTYPE(nVlrTot) == 'C'

	       cError('Hay Problemas en los valores o los Nombres',;
		      'Por Favor Revise las Tarifas o Conceptos')
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL

	    ENDIF
	    lPrnGru := .T.
**********FIN IMPRISION DEL RECIBO DE PAGO

**********ANALISIS DEL SALDO PARA EL ESTADO DEL PAGO
	    IF CLI->nSdoActCli = 0
	       cEstadoTpa := 'P'
	    ELSE
	       cEstadoTpa := '*'
	      *Marca por deuda pendiente
	    ENDIF
**********FIN ANALISIS DEL SALDO PARA EL ESTADO DEL PAGO

**********GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES
	    IF CLI->(lRegLock(lShared,.F.))
	       REPL CLI->cNrocopCli WITH STUFF(CLI->cNroCopCli,;
				    nMesIniTpa*2-1,2,cCopias(nMesIniTpa))

	       REPL CLI->cMesPagCli WITH STUFF(CLI->cMespagCli,;
					 nMesIniTpa,1,cEstadoTpa)
	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO EN CLIENTES

**********ANALISIS PARA LA GRABACION DEL PAGO
	    SELECT PAG
	    IF nRegPag # 0
	       GO nRegPag
	       lGrabar := PAG->(lRegLock(lShared,.F.))
	    ELSE
	       lGrabar := PAG->(lRegLock(lShared,.T.))
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION DEL PAGO

**********GRABACION DE LOS DETALLES DEL PAGO
	    IF lGrabar
	       REPL PAG->cCodigoEst WITH CLI->cCodigoEst
	       REPL PAG->nNroFacCaA WITH nNroFac
	       IF BAN->(RECCOUNT()) == 1
		  REPL PAG->cCodigoBan WITH CAA->cCodigoBan
	       ENDIF

	       IF CAA->lIntPenCaA

		  REPL PAG->lIntPenPag WITH .T.

		  REPL PAG->nIntMorPag WITH nIntPen
		  REPL PAG->nIntDeuPag WITH nIntDeu

		  REPL PAG->nVlrMorPag WITH 0
		  REPL PAG->nVlrDeuPag WITH 0

	       ELSE

		  REPL PAG->lIntPenPag WITH .F.

		  REPL PAG->nVlrMorPag WITH IF(nVlrTot==0,0,CAA->nVlrMorCaA)
		  IF CAA->nVlrDeuCaA == 0
		     REPL PAG->nVlrDeuPag WITH PAG->nVlrMorPag
		  ELSE
		     REPL PAG->nVlrDeuPag WITH IF(nVlrTot==0,0,;
						  CAA->nVlrDeuCaA)
		  ENDIF

		  REPL PAG->nIntMorPag WITH 0
		  REPL PAG->nIntDeuPag WITH 0

	       ENDIF
	       REPL PAG->nMesIniPag WITH nMesIniTpa
	       REPL PAG->nMesFinPag WITH nMesIniTpa
	       REPL PAG->nMesAmnPag WITH CAA->nMesAmnCaA
	       REPL PAG->cAtrasoPag WITH cAtrasos()
	       REPL PAG->nSdoAntPag WITH CLI->nSdoActCli
	       REPL PAG->nMorAntPag WITH CLI->nSdoMorCli
	       REPL PAG->cConSdoPag WITH CLI->cConSdoCli
	       REPL PAG->nSdoAnoPag WITH CLI->nSdoAnoCli
	       REPL PAG->nMorAnoPag WITH CLI->nMorAnoCli
*	       REPL PAG->nSdAbonPag WITH CLI->nSdAbonCli
*	       REPL PAG->nMoAbonPag WITH CLI->nMoAbonCli

	       REPL PAG->nVlrCo1Pag WITH nVlrCo1
	       REPL PAG->nVlrCo2Pag WITH nVlrCo2
	       REPL PAG->nVlrCo3Pag WITH nVlrCo3
	       REPL PAG->nVlrCo4Pag WITH nVlrCo4
	       REPL PAG->nVlrCo5Pag WITH nVlrCo5
	       REPL PAG->nVlrCo6Pag WITH nVlrCo6
	       REPL PAG->nVlrCo7Pag WITH nVlrCo7
	       REPL PAG->nVlrCo8Pag WITH nVlrCo8

	       REPL PAG->nVl1Co1Pag WITH nVlrCo1
	       REPL PAG->nVl1Co2Pag WITH nVlrCo2
	       REPL PAG->nVl1Co3Pag WITH nVlrCo3
	       REPL PAG->nVl1Co4Pag WITH nVlrCo4
	       REPL PAG->nVl1Co5Pag WITH nVlrCo5
	       REPL PAG->nVl1Co6Pag WITH nVlrCo6
	       REPL PAG->nVl1Co7Pag WITH nVlrCo7
	       REPL PAG->nVl1Co8Pag WITH nVlrCo8

	       REPL PAG->nVl2Co1Pag WITH nVl2Co1
	       REPL PAG->nVl2Co2Pag WITH nVl2Co2
	       REPL PAG->nVl2Co3Pag WITH nVl2Co3
	       REPL PAG->nVl2Co4Pag WITH nVl2Co4
	       REPL PAG->nVl2Co5Pag WITH nVl2Co5
	       REPL PAG->nVl2Co6Pag WITH nVl2Co6
	       REPL PAG->nVl2Co7Pag WITH nVl2Co7
	       REPL PAG->nVl2Co8Pag WITH nVl2Co8

	       REPL PAG->cIniFinPag WITH ''
	       REPL PAG->nVlrMesPag WITH nVlrMesTpa
	       REPL PAG->nVlrPagPag WITH nVlrTot
	       REPL PAG->nSdoFavPag WITH 0
	       REPL PAG->nFavDesPag WITH nFavDes
	       REPL PAG->lConcepPag WITH IF(EMPTY(cConcep),.T.,.F.)
	       REPL PAG->cConcepPag WITH cConcep
	       REPL PAG->lHayBecPag WITH lHayBec
	       REPL PAG->nPorBecPag WITH CLI->nPorBecCli
	       REPL PAG->nVlrBecPag WITH nVlrBec
	       REPL PAG->nVlrDesPag WITH nDescue
	       REPL PAG->nPagParPag WITH nPagPar
	       REPL PAG->nVlrRecPag WITH nRecarg
	       REPL PAG->nDesGenPag WITH nDesGen
	       REPL PAG->nRecGenPag WITH nRecGen
	       REPL PAG->cConGenPag WITH cConGen
	       REPL PAG->dFecFacPag WITH DATE()
	       REPL PAG->dPagopoPag WITH CAA->dOpoPenCaA
	       REPL PAG->dPagextPag WITH CAA->dExtPenCaA
	       REPL PAG->dFecPagPag WITH CTOD("00/00/00")
	       REPL PAG->cEstadoPag WITH cEstadoTpa
	       REPL PAG->cNomUsrPag WITH cNomUsr
	       REPL PAG->dFecUsrPag WITH DATE()
	       REPL PAG->cHorUsrPag WITH TIME()
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO')
	    ENDIF
	    EJECT
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO

***********GRABACION DE LA FORMA DE PAGO
	     cMesPagCoE(lShared,;
			CLI->cCodigoEst,;
			ALLTRIM(PAG->cConcepPag)+;
			ALLTRIM(CLI->cConSdoCli),;
			PAG->nMesIniPag,;
			PAG->cIniFinPag,;
			IF(cEstadoTpa=='P','F',cEstadoTpa))
***********FIN GRABACION DE LA FORMA DE PAGO

***********GRABACION DEL ULTIMO RECIBO FACTURADO
	    IF &cMaeAct->lRetiroEst .AND.;
	       CLI->nSdoActCli+CLI->nSdoMorCli # 0     .AND.;
	       &cMaeAct->cCodigoEst == CLI->cCodigoEst

	       SELECT &cMaeAct
	       IF lRegLock(lShared,.F.)
		  REPL nUltRecEst WITH nMesIniTpa

		  DBCOMMIT()
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  DBUNLOCK()
	       ENDIF

	     ENDIF
***********FIN GRABACION DEL ULTIMO RECIBO FACTURADO

**********GRABACION DEL PAZ Y SALVO
	    SELECT &cMaeAct
	    IF lRegLock(lShared,.F.)
	       cCampos := cMaeAct+'->cPazSdoEst'
	       REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,'*')
	       DBCOMMIT()
	    ELSE
	       cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	    ENDIF
	    IF lShared
	       DBUNLOCK()
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

**********VALIDACION DEL ESTADO DE CUENTA
	    SET DEVICE TO SCREEN
/*
	    IF LEN(aValCtaEst(cCodigoTes,.F.)) # 0
	       cError('ESTADO DE CUENTA CON PROBLEMAS',;
		      'POR FAVOR REVISAR')
	    ENDIF
*/
**********FIN VALIDACION DEL ESTADO DE CUENTA

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)
	  VerPrn(nOpcPrn,FilePrn)

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION


/*************************************************************************
* TITULO..: GRABACION DE UN REGISTRO          	                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2000 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   AGO 14/2000 MIE

OBJETIVOS:

1- Graba un registro con los detalles del recibo de pago facturado

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SaveRegRfa(aRecFac)

*>>>>DESCRIPCION DE PARAMETROS
/*     aRecFac                              // Recibos Facturados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lInsReg := .F.                 // .T. Insertar Registros

       LOCAL lShared := xPrm(aRecFac,'lShared')

       LOCAL cCodEmp := xPrm(aRecFac,'cCodEmp')
       LOCAL cCodFac := xPrm(aRecFac,'cCodFac')


       LOCAL cCodEst := xPrm(aRecFac,'cCodEst')
       LOCAL nMesIni := xPrm(aRecFac,'nMesIni')
       LOCAL nMesFin := xPrm(aRecFac,'nMesFin')
       LOCAL cEmpPal := xPrm(aRecFac,'cEmpPal')
       LOCAL cNroNit := xPrm(aRecFac,'cNroNit')
       LOCAL cNomEmp := xPrm(aRecFac,'cNomEmp')
       LOCAL cNroFac := xPrm(aRecFac,'cNroFac')
       LOCAL cNomBan := xPrm(aRecFac,'cNomBan')
       LOCAL cNroCta := xPrm(aRecFac,'cNroCta')
       LOCAL cCodEan := xPrm(aRecFac,'cCodEan')
       LOCAL cNombre := xPrm(aRecFac,'cNombre')
       LOCAL cCodRef := xPrm(aRecFac,'cCodRef')
       LOCAL cCodGru := xPrm(aRecFac,'cCodGru')
       LOCAL cFecFac := xPrm(aRecFac,'cFecFac')
       LOCAL cPagOpo := xPrm(aRecFac,'cPagOpo')
       LOCAL cPagExt := xPrm(aRecFac,'cPagExt')
       LOCAL cPerFac := xPrm(aRecFac,'cPerFac')

       LOCAL cNomCo1 := xPrm(aRecFac,'cNomCo1')
       LOCAL cVlrMo1 := xPrm(aRecFac,'cVlrMo1')
       LOCAL cVlrMe1 := xPrm(aRecFac,'cVlrMe1')
       LOCAL cVlrTo1 := xPrm(aRecFac,'cVlrTo1')
       LOCAL cNomCo2 := xPrm(aRecFac,'cNomCo2')
       LOCAL cVlrMo2 := xPrm(aRecFac,'cVlrMo2')
       LOCAL cVlrMe2 := xPrm(aRecFac,'cVlrMe2')
       LOCAL cVlrTo2 := xPrm(aRecFac,'cVlrTo2')
       LOCAL cNomCo3 := xPrm(aRecFac,'cNomCo3')
       LOCAL cVlrMo3 := xPrm(aRecFac,'cVlrMo3')
       LOCAL cVlrMe3 := xPrm(aRecFac,'cVlrMe3')
       LOCAL cVlrTo3 := xPrm(aRecFac,'cVlrTo3')
       LOCAL cNomCo4 := xPrm(aRecFac,'cNomCo4')
       LOCAL cVlrMo4 := xPrm(aRecFac,'cVlrMo4')
       LOCAL cVlrMe4 := xPrm(aRecFac,'cVlrMe4')
       LOCAL cVlrTo4 := xPrm(aRecFac,'cVlrTo4')
       LOCAL cNomCo5 := xPrm(aRecFac,'cNomCo5')
       LOCAL cVlrMo5 := xPrm(aRecFac,'cVlrMo5')
       LOCAL cVlrMe5 := xPrm(aRecFac,'cVlrMe5')
       LOCAL cVlrTo5 := xPrm(aRecFac,'cVlrTo5')
       LOCAL cNomCo6 := xPrm(aRecFac,'cNomCo6')
       LOCAL cVlrMo6 := xPrm(aRecFac,'cVlrMo6')
       LOCAL cVlrMe6 := xPrm(aRecFac,'cVlrMe6')
       LOCAL cVlrTo6 := xPrm(aRecFac,'cVlrTo6')
       LOCAL cNomCo7 := xPrm(aRecFac,'cNomCo7')
       LOCAL cVlrMo7 := xPrm(aRecFac,'cVlrMo7')
       LOCAL cVlrMe7 := xPrm(aRecFac,'cVlrMe7')
       LOCAL cVlrTo7 := xPrm(aRecFac,'cVlrTo7')
       LOCAL cNomCo8 := xPrm(aRecFac,'cNomCo8')
       LOCAL cVlrMo8 := xPrm(aRecFac,'cVlrMo8')
       LOCAL cVlrMe8 := xPrm(aRecFac,'cVlrMe8')
       LOCAL cVlrTo8 := xPrm(aRecFac,'cVlrTo8')
       LOCAL cNomCo9 := xPrm(aRecFac,'cNomCo9')
       LOCAL cVlrMo9 := xPrm(aRecFac,'cVlrMo9')
       LOCAL cVlrMe9 := xPrm(aRecFac,'cVlrMe9')
       LOCAL cVlrTo9 := xPrm(aRecFac,'cVlrTo9')

       LOCAL cVlrOpo := xPrm(aRecFac,'cVlrOpo')
       LOCAL cVlrExt := xPrm(aRecFac,'cVlrExt')
       LOCAL cBarOpo := xPrm(aRecFac,'cBarOpo')
       LOCAL cBarExt := xPrm(aRecFac,'cBarExt')
       LOCAL cTxtUno := xPrm(aRecFac,'cTxtUno')
       LOCAL cTxtDos := xPrm(aRecFac,'cTxtDos')
       LOCAL cCodeQr :=	xPrm(aRecFac,'cCodeQr')

       LOCAL cNitCn1 :=	xPrm(aRecFac,'cNitCn1')
       LOCAL cNomCn1 :=	xPrm(aRecFac,'cNomCn1')
       LOCAL cNitCn2 :=	xPrm(aRecFac,'cNitCn2')
       LOCAL cNomCn2 :=	xPrm(aRecFac,'cNomCn2')

       LOCAL cNomUsr := xPrm(aRecFac,'cNomUsr')
       LOCAL dFecUsr := xPrm(aRecFac,'dFecUsr')
       LOCAL cHorUsr := xPrm(aRecFac,'cHorUsr')
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL RECIBO
       SELECT RFA
       LOCATE FOR RFA->cCodigoEst == cCodEst .AND.;
		  RFA->nMesIniPag == nMesIni

       IF RFA->(FOUND())
	  lInsReg := .F.
       ELSE
	  lInsReg := .T.
       ENDIF
*>>>>FIN LOCALIZACION DEL RECIBO


*>>>>GRABACION DEL REGISTRO
       SELECT RFA
       IF RFA->(lRegLock(lShared,lInsReg))

	  REPL RFA->nIdeCodRfa WITH RFA->(RECNO())

	  REPL RFA->cCodEmpCon WITH cCodEmp
	  REPL RFA->cCodFacCar WITH cCodFac

	  REPL RFA->cCodigoEst WITH cCodEst
	  REPL RFA->nMesIniPag WITH nMesIni
	  REPL RFA->nMesFinPag WITH nMesFin

	  REPL RFA->cEmpPalRec WITH cEmpPal
	  REPL RFA->cNomEmpRec WITH cNomEmp
	  REPL RFA->cNroNitRec WITH cNroNit

	  REPL RFA->cNroFacCaA WITH cNroFac
	  REPL RFA->cNomBanRec WITH cNomBan
	  REPL RFA->cNroCtaBan WITH cNroCta
	  REPL RFA->cCodEanRec WITH cCodEan

	  REPL RFA->cNombreRec WITH cNombre
	  REPL RFA->cCodRefRec WITH cCodRef
	  REPL RFA->cCodigoGru WITH cCodGru
	  REPL RFA->cFecFacPag WITH cFecFac
	  REPL RFA->cPagOpoPag WITH cPagOpo
	  REPL RFA->cPagExtPag WITH cPagExt
	  REPL RFA->cPerFacRec WITH cPerFac

	  REPL RFA->cNomCo1Rec WITH cNomCo1
	  REPL RFA->cVlrMo1Rec WITH cVlrMo1
	  REPL RFA->cVlrMe1Rec WITH cVlrMe1
	  REPL RFA->cVlrTo1Rec WITH cVlrTo1
	  REPL RFA->cNomCo2Rec WITH cNomCo2
	  REPL RFA->cVlrMo2Rec WITH cVlrMo2
	  REPL RFA->cVlrMe2Rec WITH cVlrMe2
	  REPL RFA->cVlrTo2Rec WITH cVlrTo2
	  REPL RFA->cNomCo3Rec WITH cNomCo3
	  REPL RFA->cVlrMo3Rec WITH cVlrMo3
	  REPL RFA->cVlrMe3Rec WITH cVlrMe3
	  REPL RFA->cVlrTo3Rec WITH cVlrTo3
	  REPL RFA->cNomCo4Rec WITH cNomCo4
	  REPL RFA->cVlrMo4Rec WITH cVlrMo4
	  REPL RFA->cVlrMe4Rec WITH cVlrMe4
	  REPL RFA->cVlrTo4Rec WITH cVlrTo4
	  REPL RFA->cNomCo5Rec WITH cNomCo5
	  REPL RFA->cVlrMo5Rec WITH cVlrMo5
	  REPL RFA->cVlrMe5Rec WITH cVlrMe5
	  REPL RFA->cVlrTo5Rec WITH cVlrTo5
	  REPL RFA->cNomCo6Rec WITH cNomCo6
	  REPL RFA->cVlrMo6Rec WITH cVlrMo6
	  REPL RFA->cVlrMe6Rec WITH cVlrMe6
	  REPL RFA->cVlrTo6Rec WITH cVlrTo6
	  REPL RFA->cNomCo7Rec WITH cNomCo7
	  REPL RFA->cVlrMo7Rec WITH cVlrMo7
	  REPL RFA->cVlrMe7Rec WITH cVlrMe7
	  REPL RFA->cVlrTo7Rec WITH cVlrTo7
	  REPL RFA->cNomCo8Rec WITH cNomCo8
	  REPL RFA->cVlrMo8Rec WITH cVlrMo8
	  REPL RFA->cVlrMe8Rec WITH cVlrMe8
	  REPL RFA->cVlrTo8Rec WITH cVlrTo8
	  REPL RFA->cNomCo9Rec WITH cNomCo9
	  REPL RFA->cVlrMo9Rec WITH cVlrMo9
	  REPL RFA->cVlrMe9Rec WITH cVlrMe9
	  REPL RFA->cVlrTo9Rec WITH cVlrTo9

	  REPL RFA->cVlrOpoRec WITH cVlrOpo
	  REPL RFA->cVlrExtRec WITH cVlrExt
	  REPL RFA->cBarOpoRec WITH cBarOpo
	  REPL RFA->cBarExtRec WITH cBarExt
	  REPL RFA->cTxtUnoRec WITH cTxtUno
	  REPL RFA->cTxtDosRec WITH cTxtDos

	  REPL RFA->cCodeQrRec WITH cCodeQr
	  REPL RFA->cNitCn1Rec WITH cNitCn1
	  REPL RFA->cNomCn1Rec WITH cNomCn1
	  REPL RFA->cNitCn2Rec WITH cNitCn2
	  REPL RFA->cNomCn2Rec WITH cNomCn2

	  REPL RFA->cNomUsrRfa WITH cNomUsr
	  REPL RFA->dFecUsrRfa WITH dFecUsr
	  REPL RFA->cHorUsrRfa WITH cHorUsr


	  RFA->(DBCOMMIT())
       ENDIF
       IF lShared
	  RFA->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO