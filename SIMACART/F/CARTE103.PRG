/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: POR ADELANTADO         MODULO No. 102

**************************************************************************
* TITULO..: FACTURACION RECIBOS POR ADELANTADO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 13/1994 VIE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   MAY 13/1994 VIE

OBJETIVOS:

1- Imprime el un recibo de pago con meses por adelantado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_103(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
       #DEFINE  TAMPA22 CHR(27)+'C'+CHR(22) // P gina de 22 l¡neas
       #DEFINE  TAMPA34 CHR(27)+'C'+CHR(34) // P gina de 34 l¡neas
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar Linea
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

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lGrabar := .F.                 // .T. Grabar el pago
       LOCAL lExiste := .F.                 // Existe el estudiante

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
       LOCAL nSdoFav := 0                   // Saldo a Favor
       LOCAL nFavDes := 0                   // Saldo a Favor a Descontar.
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL aConcep := {}                  // Conceptos por cobrar

       LOCAL nIntPen := 0                   // Intereses de pension
       LOCAL nIntDeu := 0                   // Intereses para el no pago
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
       LOCAL nMesFinTpa := 0                // Mes Final del pago
       LOCAL cEstadoTpa := ''               // Estado del pago
       LOCAL nVlrMesTpa := 0                // Valor recibo para un mes
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})

       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCoE,'COE',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(CAR->cCodFacCar)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA DEFINIDO EL CODIGO DE LA EMPRESA')

       CASE EMPTY(SCO->cCodEanCon)
	    cError('NO SE HA DEFINIDO EL CODIGO EAN13 PARA EL RECAUDO')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

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
		   nMesIniTpa,nMesFinTpa,cAnoUsr)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nMesIniTpa,;
				nMesFinTpa,cAnoUsr)})

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN PREGUNTA DE DECISION

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       cSavLin := SAVESCREEN(nFilInf+1,nColInf+09,nFilInf+1,79)
       DO WHILE .T.

**********CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR
	    SET DEVICE TO SCREEN
	    RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	    IF SCO->lHayNroCon
	       cNroFac := STR(SCO->nNroFacCon+1,9)
	       lCorrecion(@cNroFac,.T.)

	       @ nFilInf+1,nColInf+7 SAY 'RECIBO No.'
	       SET COLOR TO G*
	       @ nFilInf+1,nColInf+18 SAY SCO->cCodEmpCon+'-'+cNroFac
	       SET COLOR TO
	    ENDIF
**********FIN CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			  RTRIM(&cNalias->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********VALIDACION DE LOS CONCEPTOS INDIVIDUALES
	    IF lHayConCoE(cCodigoTes,ALLTRIM(CAA->cConPenCaA)+;
			  ALLTRIM(&cNalias->cConcepEst))
	       cError('PARA IMPRRIMIR EL RECIBO DEBE HACERLO POR FACTURAR CONCEPTOS')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS CONCEPTOS INDIVIDUALES

**********LECTURA Y VALIDACION DE LA FECHA DEL ABONO
	    nSdoFav := 0
	    cSavlin := SAVESCREEN(nFilInf+1,nColInf+09,nFilInf+1,79)
/*	    IF lPregunta('DESEA APLICAR UN SALDO A FAVOR? No Si')
	       @nFilInf+1,nColInf+09 SAY "SALDO A FAVOR:";
				     GET nSdoFav PICT '9999999'
	       READ
	    ENDIF */
**********FIN LECTURA Y VALIDACION DE LA FECHA DEL ABONO

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cNalias->cCodigoGru+cAnoSis+ExtFile
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
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********CAPTURA DE LOS MESES A FACTURAR
	    nMesIniTpa := 0 ; nMesFinTpa := 0
	    MesIniFin(nFilInf+2,IF(nColInf+49>80,31,nColInf),;
		      @nMesIniTpa,@nMesFinTpa)

	    IF nMesIniTpa == 0 .OR. nMesFinTpa == 0
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN CAPTURA DE LOS MESES A FACTURAR

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cNalias->lRetiroEst
	       cError(cNombreTes+' DEL GRUPO '+&cNalias->cCodigoGru+;
		     ' ESTA RETIRADO')

	       IF nMesIniTpa > &cNalias->nUltRecEst
		  cError('EL ULTIMO RECIBO AUTORIZADO PARA IMPRIMIR ES EL '+;
			 'DEL MES DE '+cMes(&cNalias->nUltRecEst))
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
	       cError('NO SE IMPRIME EL RECIBO. DECIDIO NO CONTINUAR')
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

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
**********FIN ANTIGUEDAD DEL SALDO PENDIENTE

**********ANALISIS PARA LA IMPRESION DEL RECIBO
	    nRegPag := 0
	    IF !lDobleFac(CLI->cCodigoEst,nMesIniTpa,nMesFinTpa,;
			  CLI->cMesPagCli,@nRegPag,cNombreTes,;
			  &cNalias->nUltRecEst)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(nFilInf+1,nColInf+09,nFilInf+1,79,cSavLin)
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
			' A '+cMes(nMesFinTpa,3)+;
			'ºGRUPO: '+&cNalias->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			'ºNo. '+STR(CLI->(RECCOUNT()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********LOCALIZACION DEL CONVENIO. PENDIENTE
	    nIntPen := CAA->nIntPenCaA
	    nIntDeu := CAA->nIntDeuCaA
**********FIN LOCALIZACION DEL CONVENIO. PENDIENTE

**********ACTIVACION DE LA IMPRESORA
	    IF nNroInf == 0
	       FilePrn := 'reci'+ALLTRIM(STR(nMesIniTpa,2))+;
				 ALLTRIM(STR(nMesFinTpa,2))
	       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcRecCar,.T.,.T.)
	    ELSE
	       FilePrn := 'reci'+ALLTRIM(STR(nMesIniTpa,2))+;
				 ALLTRIM(STR(nMesFinTpa,2))
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

**********LECTURA DE LOS CONTRATANTES
	    aDocNit := {}

	    IF !EMPTY(&cNalias->cNitCo1Est)
	       AADD(aDocNit,{&cNalias->cNitCo1Est,;
			     &cNalias->cTipCo1Est})
	    ENDIF

	    IF !EMPTY(&cNalias->cNitCo2Est)
	       AADD(aDocNit,{&cNalias->cNitCo2Est,;
			     &cNalias->cTipCo2Est})
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
				     &cNalias->cPadNitEst,;
				     &cNalias->cMadNitEst)

	       DO CASE
	       CASE nTipPer == 1     // Padre

		    IF i == 1
		       nParameSet(aRecFac,'cNitCn1',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn1',ALLTRIM(&cNalias->cNomPadEst)+' '+;
						    ALLTRIM(&cNalias->cApePadEst))
		    ELSE
		       nParameSet(aRecFac,'cNitCn2',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn2',ALLTRIM(&cNalias->cNomPadEst)+' '+;
						    ALLTRIM(&cNalias->cApePadEst))

		    ENDIF

	       CASE nTipPer == 2     // Madre

		    IF i == 1
		       nParameSet(aRecFac,'cNitCn1',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn1',ALLTRIM(&cNalias->cNomMadEst)+' '+;
						    ALLTRIM(&cNalias->cApeMadEst))
		    ELSE
		       nParameSet(aRecFac,'cNitCn2',aDocNit[i,1])
		       nParameSet(aRecFac,'cNomCn2',ALLTRIM(&cNalias->cNomMadEst)+' '+;
						    ALLTRIM(&cNalias->cApeMadEst))
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

**********DIRECTORIOS
	    PathAct := cPathAct()

	    PathRfa := cPatSis+'\RECIBOS\'+cMes(nMesIniTpa,3)
	    Mdir(PathRfa,PathAct)
	  *ÀDirectorio para el mes de los recibos facturados
**********FIN DIRECTORIOS

**********VALIDACION DEL ARCHIVO
	    fRecFac := 'RECI'+cMes(nMesIniTpa,3)+ExtFile
	    IF !FILE(PathRfa+'\'+fRecFac)
	       CreaDbfRfa(lShared,nModCry,PathRfa,fRecFac)
	    ENDIF
	    nActStrRfa(lShared,nModCry,PathRfa,fRecFac)
**********FIN VALIDACION DEL ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathRfa+'\'+fRecFac,'RFA',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO '+fRecFac)
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

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

**********VALIDACION DEL RECIBO No. 11. Bethlemitas. Barranca
	    cConcep := ALLTRIM(CAA->cConPenCaA)+&cNalias->cConcepEst
	    IF CAA->nRecNroCaA == 11

	       IF LEN(ALLTRIM(cConcep))/2 > 3
		  cError('NO SE PUEDEN FACTURAR MAS DE 3 CONCEPTOS')
		  LOOP
	       ENDIF

	       cConcep := SUBS(cConcep+SPACE(06),1,6)
	    ELSE
	       cConcep := SUBS(cConcep,1,14)
	    ENDIF
**********FIN VALIDACION DEL RECIBO No. 11. Bethlemitas. Barranca

**********IMPRISION DEL RECIBO DE PAGO

	    lHayBec := .F.

	    DO CASE
	    CASE CAA->nRecNroCaA == 1

		 nVlrTot := nRecibo01(aRecFac,;
				      lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cJorTxt,xPrm(aP3,'cCodIso'),@nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,CAA->lPrePrnCaA,;
				      lPrnGru,@nVlrCo1,@nVlrCo2,@nVlrCo3,;
				      @nVlrCo4,@nVlrCo5,@nVlrCo6,@nVlrCo7,;
				      @nVlrCo8,@nVl2Co1,@nVl2Co2,@nVl2Co3,;
				      @nVl2Co4,@nVl2Co5,@nVl2Co6,@nVl2Co7,;
				      @nVl2Co8,@lHayBec,@nVlrBec,@nDescue,;
				      @nPagPar,@nRecarg,@nDesGen,@nRecGen,;
				      @cConGen,@nFavDes,nSdoFav)
	       *Recibo dise¤o Colegio la Salle.

	    CASE CAA->nRecNroCaA == 2

		 nVlrTot := nRecibo02(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cMaeAct,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,;
				      @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				      @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				      @lHayBec,@nVlrBec,@nDescue,@nPagPar,;
				      @nRecarg,@nDesGen,@nRecGen,@cConGen,;
				      @nFavDes,nSdoFav)
	       *Recibo dise¤ado para los Colegios:
	       *La Merced,Las Bethlemitas

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4

		 nVlrTot := nRecibo03(lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cNalias,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
			   *Recibo dise¤o Colegio la Salle con Colilla

	    CASE CAA->nRecNroCaA == 5

		 nVlrTot := nCarRec05(aP1,aP2,aP3,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,;
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
				      cNomUsr,cAnoUsr,cNalias,cJorTxt,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo c¢digo de Barras la Kiosera

	    CASE CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9

		 nVlrTot := nRecibo08(aRecFac,nDiaMor,;
				      lShared,cEmpPal,cNitEmp,cNomEmp,;
				      cNomUsr,cAnoUsr,cNalias,cJorTxt,;
				      xPrm(aP3,'cCodIso'),@nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,@cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,@nVlrCo1,;
				      @nVlrCo2,@nVlrCo3,@nVlrCo4,@nVlrCo5,;
				      @nVlrCo6,@nVlrCo7,@nVlrCo8,@lHayBec,;
				      @nVlrBec,@nDescue,@nPagPar,@nRecarg,;
				      @nDesGen,@nRecGen,@cConGen,@nFavDes,;
				      nSdoFav,CAA->nRecNroCaA)
		*Recibo c¢digo de Barras la Kiosera. La Salle

	    CASE CAA->nRecNroCaA == 11

		 nVlrTot := nCarRec11(aP1,aP2,aP3,;
				      @nNroFac,;
				      &cNalias->cCodigoEst,cNombreTes,;
				      &cNalias->cCodigoGru,CLI->(RECNO()),;
				      BAN->cNombreBan,BAN->cNroCtaBan,;
				      BAN->cLugarBan,cConcep,;
				      nIntPen,;
				      IF(CAA->lPagExtCaA,CAA->dOpoPenCaA,;
							 CAA->dFecRecCaA),;
				      CAA->dExtPenCaA,CAA->lPagExtCaA,;
				      CAA->cMensajCaA,@nVlrMesTpa,;
				      nMesIniTpa,nMesFinTpa,lPrnGru,;
				      @nVlrCo1,@nVlrCo2,@nVlrCo3,@nVlrCo4,;
				      @nVlrCo5,@nVlrCo6,@nVlrCo7,@nVlrCo8,;
				      @lHayBec,@nVlrBec,@nDescue,@nPagPar,;
				      @nRecarg,@nDesGen,@nRecGen,@cConGen,;
				      @nFavDes,nSdoFav)
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

*--------------GRABA LA FORMA DE PAGO POR DEFECTO
		 REPL CLI->cNrocopCli WITH STUFF(CLI->cNroCopCli,;
				      nMesIniTpa*2-1,2,cCopias(nMesIniTpa))

		 REPL CLI->cMesPagCli WITH STUFF(CLI->cMespagCli,;
				      nMesIniTpa,1,cEstadoTpa)
*--------------FIN GRABA LA FORMA DE PAGO POR DEFECTO

*--------------BORRA CONTROL DE MESES ADELANTADOS POR ANULACION DEL RECIBO
		 IF nRegPag # 0  //Ya existe un recibo

		    PAG->(DBGOTO(nRegPag))
		   *Se ubica en registro del recibo a anular

		    FOR i := IF(PAG->nMesIniPag==12,12,PAG->nMesIniPag+1);
			TO PAG->nMesFinPag
			REPL CLI->cMesPagCli;
			     WITH STUFF(CLI->cMesPagCli,i,1,SPACE(01))
		    NEXT
		  *ÀBorra control de los meses adelantados

		 ENDIF
*--------------FIN BORRA CONTROL DE MESES ADELANTADOS POR ANULACION DEL RECIBO

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

**********BORRAR CONTROL DE LOS MESES POR ADELANTADO
	    IF nRegPag # 0

	       PAG->(DBGOTO(nRegPag))
	      *Se ubica en registro del recibo a anular

	       cMesPagCoE(lShared,;
			  CLI->cCodigoEst,;
			  PAG->cConcepPag,;
			  PAG->nMesIniPag,;
			  PAG->cIniFinPag,;
			  ' ')
	      *ÀBorra control de los meses adelantados

	   ENDIF
**********FIN BORRAR CONTROL DE LOS MESES POR ADELANTADO

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

	       ENDIF

	       REPL PAG->nMesIniPag WITH nMesIniTpa
	       REPL PAG->nMesFinPag WITH nMesFinTpa
	       REPL PAG->nMesAmnPag WITH CAA->nMesAmnCaA //m
	       REPL PAG->cAtrasoPag WITH cAtrasos()
	       REPL PAG->nSdoAntPag WITH CLI->nSdoActCli
	       REPL PAG->nMorAntPag WITH CLI->nSdoMorCli
	       REPL PAG->nSdoAnoPag WITH CLI->nSdoAnoCli
	       REPL PAG->nMorAnoPag WITH CLI->nMorAnoCli

	       REPL PAG->nVlrCo1Pag WITH nVlrCo1
	       REPL PAG->nVlrCo2Pag WITH nVlrCo2
	       REPL PAG->nVlrCo3Pag WITH nVlrCo3
	       REPL PAG->nVlrCo4Pag WITH nVlrCo4
	       REPL PAG->nVlrCo5Pag WITH nVlrCo5
	       REPL PAG->nVlrCo6Pag WITH nVlrCo6
	       REPL PAG->nVlrCo7Pag WITH nVlrCo7
	       REPL PAG->nVlrCo8Pag WITH nVlrCo8

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
	       REPL PAG->nVlrpagPag WITH nVlrTot
	       REPL PAG->nSdoFavPag WITH nSdoFav
	       REPL PAG->nFavDesPag WITH nFavDes
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
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
	    EJECT
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
	    CloseDbf('RFA')
**********FIN GRABACION DE LOS DETALLES DEL PAGO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION

