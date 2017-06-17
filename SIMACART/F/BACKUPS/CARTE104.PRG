/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: FACTURACION

**************************************************************************
* TITULO..: FACTURACION DE LOS ABONOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 19/1996 MIE A
       Bucaramanga, Colombia        INICIO: 12:40 AM   JUN 19/1996 MIE

OBJETIVOS:

1- Permite imprimir un recibo con el valor de abono que se descontar
   del saldo saldo.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_104(aP1,aP2,aP3)

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
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL lHayErr := .F.                 // .T. Hay Error

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
       LOCAL nRegAnt := 0                   // Registro Anterior
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL lMesAct := .T.                 // .T. Mes Actual
       LOCAL nMesAnt := 0                   // Mes Anterior
       LOCAL nMesAct := 0                   // Mes Actual
       LOCAL dExtAct := CTOD('00/00/00')    // Fecha Extemporanea actual
       LOCAL dExtAnt := CTOD('00/00/00')    // Fecha Extemporanea anterior
       LOCAL dFecAbo := CTOD('00/00/00')    // Fecha del Abono
       LOCAL nSdoAnt := 0                   // Saldo Anterior
       LOCAL nVlrAbo := 0                   // Valor abonado
       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL cNroFac := ''                  // N£mero de la factura. Consecutivo
       LOCAL lPrnGru := .T.                 // Impresi¢n por grupos
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Saldo mora actual
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL nVlrPagTpa := 0                // Valor total por pagar
       LOCAL nNroMesTde := 0                // Mes para el descuento
       LOCAL cDescriTde := ''               // Descripci¢n del descuento
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

       CloseAll()
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nNroMesTde := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes para el registro del abono al saldo',.T.)
       RESTORE SCREEN
       IF nNroMesTde == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileDes,'DES',cPatSis+'\'+fNtxDes,lShared,nModCry})
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
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE EMPTY(CAR->cCodFacCar)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA == 10
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE CAA->nRecNroCaA == 0 .OR. CAA->nRecNroCaA > 11
	    cError('EL RECIBO No.'+STR(CAA->nRecNroCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')
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

       cOpcSys := '<ABONOS>'
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
       AADD(aTitIso,'RECIBO DE ABONO')                  // T¡tulo Uno
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
		   nNroMesTde,nNroMesTde,cAnoUsr)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nNroMesTde,;
				nNroMesTde,cAnoUsr)})

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN PREGUNTA DE DECISION

*>>>>IMPRESION DE LA LINEA DE ESTADO
       LineaEstado('FACTURACION DE '+cMes(nNroMesTde,3)+;
		   ' A '+cMes(nNroMesTde,3),cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>IMPRESION DE LOS RECIBOS DE PAGOS
       lPrnGru := .F.
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

**********CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR
	    SET DEVICE TO SCREEN
	    IF SCO->lHayNroCon
	       cNroFac := STR(SCO->nNroFacCon+1,9)
	       lCorrecion(@cNroFac,.T.)

	       @ nFilInf+1,nColInf+25 SAY 'RECIBO No.'
	       SET COLOR TO G*
	       @ nFilInf+1,nColInf+36 SAY SCO->cCodEmpCon+'-'+cNroFac
	       SET COLOR TO
	    ENDIF
**********FIN CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,;
				     cMaeAlu,@cNalias)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cNalias->cNombreEst)+' '+;
			  RTRIM(&cNalias->cApelliEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

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

**********VALIDACION DEL MES DEL ABONO
	    IF nNroMesTde # nMesUltPag(cCodigoTes)
	       cError(cMes(nNroMesTde)+' NO ES EL ULTIMO RECIBO FACTURADO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL MES DEL ABONO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodCli(cCodigoTes,.F.)
	       cError(cNombreTes+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       cError(cNombreTes+' NO PERTENCE AL GRUPO: '+;
		      &cNalias->cCodigoGru)
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********VALIDACION DE LA DEUDA
	    IF CLI->nSdoActCli+CLI->nSdoMorCli+;
	       CLI->nSdoAnoCli+CLI->nMorAnoCli  == 0
	       cError(cNombreTes+' NO TIENE DEUDAS PENDIENTES')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA DEUDA

**********MES DEL ABONO ES EL MES ACTUAL
	    nMesAnt := 0
	    nMesAct := nRecUltAnt(CLI->cCodigoEst,@nMesAnt)
	    IF nMesAct == nNroMesTde
	       lMesAct := .T.
	    ELSE
	       lMesAct := .F.
	    ENDIF
**********FIN MES DEL ABONO ES EL MES ACTUAL

**********VALIDACION DEL MES DEL ABONO
	    IF !(nMesAnt == nNroMesTde .OR. nMesAct == nNroMesTde)

	       IF nNroMesTde > nMesAct
		  cError('NO SE PUEDE ABONAR A UN MES POSTERIOR A '+;
			 cMes(nMesAct,10))
	       ELSE
		  cError('NO SE PUEDE ABONAR A UN MES ANTERIOR A '+;
			 cMes(nMesAnt,10))
	       ENDIF
	       LOOP

	    ENDIF
**********FIN VALIDACION DEL MES DEL ABONO

**********LECTURA Y VALIDACION DE LA FECHA DEL ABONO
	    cSavlin := SAVESCREEN(nFilInf+1,nColInf+09,nFilInf+1,79)
	    dFecAbo := DATE()
	    @nFilInf+1,nColInf+08 SAY "FECHA DEL ABONO:" GET dFecAbo
	    READ
**********FIN LECTURA Y VALIDACION DE LA FECHA DEL ABONO

**********LOCALIZACION DEL ANTERIOR RECIBO FACTURADO
	    nRegAnt := 0
	    SELECT PAG
	    LOCATE FOR PAG->cCodigoEst == cCodigoTes .AND.;
		       PAG->nMesIniPag == nMesAnt

	    IF !FOUND()
	       cError('NO EXISTE EL RECIBO DE '+cMes(nMesAnt,10)+;
		      ' DE '+cNombreTes)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF

	    nRegAnt := PAG->(RECNO())
	    dExtAnt := PAG->dPagExtPag
	    nSdoAnt := PAG->nSdoAntPag+PAG->nMorAntPag
**********FIN LOCALIZACION DEL ANTERIOR RECIBO FACTURADO

**********VALIDACION DE LA FORMA DE PAGO
	    IF dFecAbo > PAG->dPagExtPag .AND. PAG->cEstadoPag = '*'

	       cError('PRIMERO DEBE INDICAR LA FORMA DE PAGO '+;
		      'DEL MES DE '+cMes(nMesAnt))
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LA FORMA DE PAGO

**********LECTURA Y VALIDACION DEL SALDO PARA ABONAR
	    nSdoActTcl := 0
	    nSdoMorTcl := 0
	    IF !lMesAct .AND. dFecAbo <= PAG->dPagExtPag

	       nSdoActTcl := PAG->nSdoAntPag
	       nSdoMorTcl := PAG->nMorAntPag
	      *Saldos para abono por fecha oportuna

	       IF nSdoActTcl+nSdoMorTcl == 0
		  cError(cNombreTes+' EN '+cMes(nMesAnt,10)+;
			 ' NO QUEDO CON DEUDAS ATRASADAS')
		  RESTSCREEN(0,0,24,79,cSavPan)
		  LOOP
	       ENDIF
	     *ÀValidaci¢n del saldo

	    ENDIF
**********FIN LECTURA DEL SALDO PARA ABONAR

**********VALIDACION DEL SALDO DEL ANTERIOR MES
	    IF !lMesAct .AND. nNroMesTde # CAA->nMesAmnCaA .AND.;
	       (PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A')

	       cError(cNombreTes+' PAGO EL MES DE '+cMes(nNroMesTde,10))

	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP

	    ENDIF
**********FIN VALIDACION DEL SALDO DEL ANTERIOR MES

**********LOCALIZACION DEL ULTIMO RECIBO FACTURADO
	    nRegAct := 0
	    SELECT PAG
	    LOCATE FOR PAG->cCodigoEst == cCodigoTes .AND.;
		       PAG->nMesIniPag == nMesAct

	    IF !FOUND()
	       cError('NO EXISTE EL RECIBO DE '+cMes(nMesAct,10)+;
		      ' DE '+cNombreTes)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF
	    nRegAct := PAG->(RECNO())
	    dExtAct := PAG->dPagExtPag
**********FIN LOCALIZACION DEL ULTIMO RECIBO FACTURADO

**********VALIDACION DE LA FORMA DE PAGO
	    IF dFecAbo > PAG->dPagExtPag .AND. PAG->cEstadoPag = '*'

	       cError('PRIMERO DEBE INDICAR LA FORMA DE PAGO '+;
		      'DEL MES DE '+cMes(nMesAct))
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP

	    ENDIF
**********FIN VALIDACION DE LA FORMA DE PAGO

**********LECTURA DEL SALDO PARA EL ABONO
	    IF lMesAct
	       IF dFecAbo <= PAG->dPagExtPag
		  nSdoActTcl := PAG->nSdoAntPag
		  nSdoMorTcl := PAG->nMorAntPag
		 *Saldos para abono por fecha oportuna
	       ELSE
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
		 *Saldos para abono por fecha extemporanea
	       ENDIF
	    ELSE
	       IF dFecAbo > dExtAnt
		  nSdoActTcl := PAG->nSdoAntPag
		  nSdoMorTcl := PAG->nMorAntPag
		 *Saldos para abono por fecha extemporanea
	       ENDIF
	    ENDIF
**********FIN LECTURA DEL SALDO PARA EL ABONO

**********VALIDACION DEL SALDO
	    DO CASE
	    CASE nSdoActTcl+nSdoActTcl == 0

		 cError(cNombreTes+' EN '+cMes(nMesAct,10)+;
			' NO QUEDO CON DEUDAS ATRASADAS')
		 RESTSCREEN(0,0,24,79,cSavPan)
		 LOOP

/*
	    CASE (lMesAct  .AND. PAG->nSdoAntPag+PAG->nMorAntPag == 0) .OR.;
		 (!lMesAct .AND. nSdoAnt == 0 .AND. PAG->cEstadoPag == '*')

		 cError('NO SE ACEPTAN ABONOS PARA UN SOLO MES DE ATRASO')
		 RESTSCREEN(0,0,24,79,cSavPan)
		 LOOP  */

	    ENDCASE
**********FIN VALIDACION DEL SALDO

**********LECTURA DE LOS DETALLES DEL ABONO
	    cDescriTde := cSpaces('DES','cDescriDes')
	    cDescriTde := STUFF(cDescriTde,1,14,'ABONO AL SALDO')


	    nVlrAbo := 0

	    nVlrAbo := nVlrAbono(12,10,&cNalias->cCodigoEst,;
				 cNombreTes,&cNalias->cCodigoGru,;
				 nNroMesTde,nSdoActTcl+nSdoMorTcl,@cDescriTde)

	    IF nVlrAbo == 0
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF

	    IF !lPregunta('DESEA CONTINUAR? Si No')
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF
**********FIN LECTURA DE LOS DETALLES DEL ABONO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ABONO PARA EL MES DE '+cMes(nNroMesTde,3)+;
			'ºGRUPO: '+&cNalias->cCodigoGru+;
			'ºESTUDIANTE: '+SUBS(cNombreTes+SPACE(30),1,30)+;
			'ºNo.2',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACTIVACION DE LA IMPRESORA
	    IF nNroInf == 0
	       FilePrn := 'abono'+ALLTRIM(STR(nNroMesTde,2))
	       nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcRecCar,.T.,.T.)
	    ELSE
	       FilePrn := 'abono'+ALLTRIM(STR(nNroMesTde,2))
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

**********CONFIGURACION DEL TAMA¥O DEL PAPEL
	    DO CASE
	    CASE CAA->nRecNroCaA == 1
		 SendCodes(IF(CAA->lPrePrnCaA,LINESP1_8+TAMPA34,TAMPA22))

	    CASE CAA->nRecNroCaA == 2 .OR. CAA->nRecNroCaA == 11
		 SendCodes(TAMPA22)

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4
		 SendCodes(LINESP1_8+TAMPA34)
	    ENDCASE
**********FIN CONFIGURACION DEL TAMA¥O DEL PAPEL


**********IMPRISION DEL RECIBO DE PAGO
	    DO CASE
	    CASE CAA->nRecNroCaA == 1

		 IF RecAbo01(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,;
			     cJorTxt,cCodIso,@nNroFac,&cNalias->cCodigoEst,;
			     cNombreTes,&cNalias->cCodigoGru,CLI->(RECNO()),;
			     BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			     CAA->dExtPenCaA,CAA->dExtPenCaA,;
			     CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			     nSdoActTcl+nSdoMorTcl,CAA->lPrePrnCaA,;
			     lPrnGru) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo dise¤o Colegio la Salle.

	    CASE CAA->nRecNroCaA == 2

		 IF RecAbo02(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,;
			     cNomUsr,cAnoUsr,cJorTxt,@nNroFac,;
			     &cNalias->cCodigoEst,cNombreTes,;
			     &cNalias->cCodigoGru,CLI->(RECNO()),;
			     BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			     CAA->dExtPenCaA,CAA->dExtPenCaA,;
			     CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			     nSdoActTcl+nSdoMorTcl,CAA->lPrePrnCaA,;
			     lPrnGru) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo dise¤ado para los Colegios:
		*La Merced, Las Bethlemitas

	    CASE CAA->nRecNroCaA == 3 .OR. CAA->nRecNroCaA == 4

		 IF RecAbo03(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,;
			     cNomUsr,cAnoUsr,cJorTxt,@nNroFac,;
			     &cNalias->cCodigoEst,cNombreTes,;
			     &cNalias->cCodigoGru,CLI->(RECNO()),;
			     BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			     CAA->dExtPenCaA,CAA->dExtPenCaA,;
			     CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			     nSdoActTcl+nSdoMorTcl,lPrnGru,;
			     CAA->nRecNroCaA) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo dise¤o Colegio la Salle con Colilla

	    CASE CAA->nRecNroCaA == 5

		 IF CarAbo_05(aP1,aP2,aP3,;
			      @nNroFac,;
			      &cNalias->cCodigoEst,cNombreTes,;
			      &cNalias->cCodigoGru,CLI->(RECNO()),;
			      BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			      CAA->dExtPenCaA,CAA->dExtPenCaA,;
			      CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			      nSdoActTcl+nSdoMorTcl,lPrnGru) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo c¢digo de Barras la Kiosera con formato. Virrey.

	    CASE CAA->nRecNroCaA == 6

		 IF RecAbo05(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,;
			     cNomUsr,cAnoUsr,cJorTxt,@nNroFac,;
			     &cNalias->cCodigoEst,cNombreTes,;
			     &cNalias->cCodigoGru,CLI->(RECNO()),;
			     BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			     CAA->dExtPenCaA,CAA->dExtPenCaA,;
			     CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			     nSdoActTcl+nSdoMorTcl,lPrnGru,;
			     CAA->nRecNroCaA) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo c¢digo de Barras la Kiosera

	    CASE CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9

		 IF RecAbo06(lShared,nModCry,cEmpPal,cNitEmp,cNomEmp,;
			     cNomUsr,cAnoUsr,cJorTxt,@nNroFac,;
			     &cNalias->cCodigoEst,cNombreTes,;
			     &cNalias->cCodigoGru,CLI->(RECNO()),;
			     BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			     CAA->dExtPenCaA,CAA->dExtPenCaA,;
			     CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			     nSdoActTcl+nSdoMorTcl,lPrnGru,;
			     CAA->nRecNroCaA) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo c¢digo de Barras la Kiosera. La Salle

	    CASE CAA->nRecNroCaA == 11

		 IF RecAbo_11(aP1,aP2,aP3,;
			      @nNroFac,;
			      &cNalias->cCodigoEst,cNombreTes,;
			      &cNalias->cCodigoGru,CLI->(RECNO()),;
			      BAN->cNombreBan,BAN->cNroCtaBan,BAN->cLugarBan,;
			      CAA->dExtPenCaA,CAA->dExtPenCaA,;
			      CAA->cMensajCaA,nNroMesTde,nVlrAbo,;
			      nSdoActTcl+nSdoMorTcl,CAA->lPrePrnCaA,;
			      lPrnGru) == 'C'

		     VerPrn(nOpcPrn,FilePrn)
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
                     CloseAll(aUseDbf)
		     SET DEVICE TO SCREEN
		     RETURN NIL
		 ENDIF
		*Recibo dise¤ado para los Colegios:
		*Las Bethlemitas. Iso

	    ENDCASE

	    lPrnGru := .T.
	    EJECT
	    SET DEVICE TO SCREEN
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN IMPRISION DEL RECIBO DE PAGO

	  VerPrn(nOpcPrn,FilePrn)
	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA FACTURACION