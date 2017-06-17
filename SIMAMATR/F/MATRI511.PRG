/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: FACTURAR NUEVOS        MODULO No. 511

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI511.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE RECIBOS POR GRUPOS. ALUMNOS NUEVOS *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/96 VIE A
       Colombia, Bucaramanga        INICIO: 03:45 PM   AGO 09/96 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir todos los recibos de pago de matr¡cula y de pensi¢n
   por grupos de los estudiantes nuevos con cupo.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_511(aParam1,aParam2,aParam3,;
		   lCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lCodEst                              // .T. C¢digo Generado por el Sistema .F. C¢digo Generado Externamente */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
       #DEFINE  TAMPA22 CHR(27)+'C'+CHR(22) // P gina de 22 l¡neas
       #DEFINE  TAMPA34 CHR(27)+'C'+CHR(34) // P gina de 34 l¡neas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀGestion Documental

       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL cNroFac := ''                  // N£mero de la factura. Consecutivo
       LOCAL lHayPag := .F.                 // .T. Hay pago o facturaci¢n
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL nVlrTot := 0                   // Valor total del recibo

       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nMesIni := 0                   // Mes Inicial del pago
       LOCAL nNroRec := 0                   // N£mero de Recibos
       LOCAL cConcep := ''                  // Conceptos por cobrar
       LOCAL aVlrCon := ''                  // Valor de los Conceptos
       LOCAL lPrnGru := .T.                 // Impresi¢n por grupos
       LOCAL aColMzp := {}                  // Columnas y filas
       LOCAL nDescue := 0                   // Valor del Descuento
       LOCAL nPagPar := 0                   // Valor Pago Parcial
       LOCAL nRecarg := 0                   // Valor del Recargo
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del candidato
       LOCAL nVlrMesTpa := 0                // Valor recibo para un mes
     *ÀVariables temporales de campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0101(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES


*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileMzp,'MZP',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FilePag,'PAG',;
			 cPatSis+'\'+fNtxPag,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTrc,'TRC',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       aColMzp := aColFilMzp(01)

       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ADM->(RECCOUNT()) == 0
	    cError('NO EXISTEN INSCRITOS GRABADOS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ANO->nRecNroAno == 0 .OR. ANO->nRecNroAno > 11
	    cError('EL RECIBO No.'+STR(ANO->nRecNroAno,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE ANO->nRecNroAno >= 7 .AND. ANO->nRecNroAno <= 8 .AND.;
	    SCO->nCodEmpCon == 0
	    cError('EL CODIGO DE LA EMPRESA PARA FACTURAR SE DEBE DEFINIR')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS NIVELES')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO')

       CASE TRC->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LOS TIPOS DE RECIBO A FACTURAR')

       CASE ANO->nRecNroAno == 11 .AND. LEN(aColMzp) == 0
	    cError('NO EXISTEN COLUMNAS Y FILAS PARA LA IMPRESION')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VERIFICACION DE INSCRIPCIONES ABIERTAS
       IF !ANO->lHayInsAno
	  cError('Estan Cerradas las Inscripciones para '+cAnoUsr,;
		 '!Atenci¢n!')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VERIFICACION DE INSCRIPCIONES ABIERTAS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 501
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<RECIBOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'')                                 // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

*      cPiePag := ALLTRIM(SCO->cPiePagCon)
       cPiePag := ''
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>VERIFICACION IMPRESION DE RECIBOS DE PAGO
       IF !ANO->lPrnRecAno
	  cError('NO esta Habilitada la Opci¢n de Impresi¢n de Recibos '+;
		 'para el '+cAnoUsr,'!Atenci¢n!')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VERIFICACION IMPRESION DE RECIBOS DE PAGO

*>>>>CAPTURA DEL MES A PAGAR
       IF ANO->nTipFacAno # 1
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nMesIni == 0
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO
       IF ANO->cCodBanAno == cSpaces('BAN','cCodigoBan')
	  cError('A CONTINUACION ESCOJA EL BANCO',;
		 'NO SE HA DEFINIDO EL BANCO DONDE SE DEBE PAGAR')
	  CambiaBan(lShared,nFilInf+1,nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO

*>>>>LECTURA DE LOS DETALLES DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',ANO->cCodBanAno)
	  cError('NO SE DEFINIO EL BANCO DONDE SE DEBE PAGAR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LOS DETALLES DEL BANCO

*>>>>VALIDACION DEL TIPO DE RECIBO
       IF ANO->cCodTrcAno == cSpaces('TRC','cCodigoTrc')
	  cError('A CONTINUACION ESCOJA EL TIPO DE RECIBO',;
		 'NO SE HA DEFINIDO EL TIPO DE RECIBO A FACTURAR')
	  CambiaTrc(lShared,nFilInf+1,nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL TIPO DE RECIBO

*>>>>LOCALIZACION DEL TIPO DE RECIBO
       IF !lLocCodigo('cCodigoTrc','TRC',ANO->cCodTrcAno)
	  cError('NO SE DEFINIO EL TIPO DE RECIBOS A FACTURAR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL TIPO DE RECIBO

*>>>>CONSULTA DE LOS DETALLES PARA LA FACTURACION
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,BAN->cNroctaBan,;
		   nMesIni,nMesIni,cAnoUsr,TRC->cNombreTrc)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nMesIni,nMesIni,cAnoUsr,;
				TRC->cNombreTrc)})

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CORRECION DE LOS DETALLES PARA LA FACTURACION

*>>>>CAPTURA DE LOS NIVELES POR INTERVALO
       IF !lInterNiv(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NIVELES POR INTERVALO

*>>>>CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR
       IF SCO->lHayNroCon
	  cNroFac := STR(SCO->nNroFacCon+1,9)
	  lCorrecion(@cNroFac,.T.)

*	  @ nFilInf+1,nColInf+19 SAY 'RECIBO No.'
	  SET COLOR TO G*
*	  @ nFilInf+1,nColInf+29 SAY SCO->cCodEmpCon+'-'+cNroFac
	  @ nFilInf+1,nColInf+18 SAY SCO->cCodEmpCon+'-'+cNroFac
	  SET COLOR TO
       ENDIF
*>>>>FIN CONSULTA DEL NUMERO DEL RECIBO A IMPRIMIR

*>>>>PREGUNTA DE DECISION
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  cError('NO SE IMPRIME. DECIDIO NO CONTINUAR')
	  RETURN NIL
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ReciGruN'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.F.,bInsIso)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
*	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>ANALISIS DE DECISION
       IF ANO->nRecNroAno < 5 .OR. ANO->nRecNroAno == 9
	  SendCodes(INICIALIZA+PROPOR_OF+CONDEN_ON+DRAFT_ON)
       ENDIF

       DO CASE
       CASE ANO->nRecNroAno == 1
	    SendCodes(IF(ANO->lPrePrnAno,LINESP1_8+TAMPA34,TAMPA22))

       CASE ANO->nRecNroAno == 2 .OR. ANO->nRecNroAno == 9
	    SendCodes(TAMPA22)

       CASE ANO->nRecNroAno == 3 .OR. ANO->nRecNroAno == 4
	    SendCodes(LINESP1_8+TAMPA34)
       ENDCASE
       lPrnGru := .F.
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE LOS RECIBOS DE PAGO
       SELECT NIV
       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********FILTRACION DEL MAESTRO
	    SELECT ADM
	    SET FILTER TO SUBS(ADM->cCodigoGru,1,2) == NIV->cCodigoNiv
	    GO TOP
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE LOS RECIBOS DE PAGO DEL NIVEL
	    DO WHILE .NOT. EOF()

*--------------ANALISIS SI EL ESTUDIANTE TIENE CUPO
		 IF !(ADM->lSiCupoEst)
		    ADM->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(ADM->cApelliEst)+' '+;
			       RTRIM(ADM->cNombreEst)
*--------------FIN ANALISIS SI EL ESTUDIANTE TIENE CUPO

*--------------ASIGNACION DEL CODIGO PARA LOS ALUMNOS NUEVOS
		 IF lCodEst
		    IF !EMPTY(ADM->cCodigoEst)
		       cCodigoTes := ADM->cCodigoEst
		    ELSE
		       IF VAL(cAnoUsr) < 2000
			  cCodigoTes := cAnoSis+ADM->cNumeroAdm
		       ELSE
			  cCodigoTes := SUBS(cAnoUsr,1,1)+cAnoSis+;
					SUBS(ADM->cNumeroAdm,2,3)
		       ENDIF
		    ENDIF
		 ELSE
		    cCodigoTes := ADM->cCodigoEst
		    IF EMPTY(cCodigoTes)
		       SKIP
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN ASIGNACION DEL CODIGO PARA LOS ALUMNOS NUEVOS

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('IMPRIMIENDO EL NIVEL: '+NIV->cCodigoNiv+;
			     'ºESTUDIANTE: '+cNombreTes,cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------VALIDACION DEL RECIBO No. 09. Bethlemitas. Barranca
		 IF ANO->nRecNroAno == 9
		    cConcep := ALLTRIM(ANO->cConMatAno)
		    IF LEN(ALLTRIM(cConcep))/2 > 3
		       ADM->(DBSKIP())
		       LOOP
		    ENDIF
		    cConcep := SUBS(cConcep+SPACE(06),1,6)
		 ELSE
		    cConcep := ANO->cConMatAno
		 ENDIF
*--------------FIN VALIDACION DEL RECIBO No. 11. Bethlemitas. Barranca


*--------------IMPRISION DEL RECIBO DE PAGO POR MATRICULA
		 IF ANO->nTipFacAno == 1 .OR. ANO->nTipFacAno == 3

		    DO CASE
		    CASE ANO->nRecNroAno == 1
			 nVlrTot := nRecMtr01(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      ANO->lPrePrnAno,;
					      lPrnGru)
			 *Recibo de la Salle

		    CASE ANO->nRecNroAno == 2
			 nVlrTot := nRecMtr02(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      ANO->lPrePrnAno,;
					      lPrnGru)
			 *Recibo de la Merced y Belemas

		    CASE ANO->nRecNroAno == 3 .OR. ANO->nRecNroAno == 4

			 nVlrTot := nRecMtr03(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      lPrnGru,ANO->nRecNroAno)
			 *Recibo de la Salle con colilla

		    CASE ANO->nRecNroAno == 5 .OR. ANO->nRecNroAno == 6
			 nVlrTot := nRecMtr05(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      lPrnGru,ANO->nRecNroAno,;
					      @nDescue,@nPagPar,@nRecarg)
			 *Recibo c¢digo de Barras la Kiosera. Presentacion

		    CASE ANO->nRecNroAno == 7 .OR. ANO->nRecNroAno == 8
			 nVlrTot := nRecMtr07(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      cCodIso,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      lPrnGru,ANO->nRecNroAno,;
					      @nDescue,@nPagPar,@nRecarg)
			 *Recibo c¢digo de Barras la Kiosera. La Salle

		    CASE ANO->nRecNroAno == 9
			 nVlrTot := nRecMtr09(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      ANO->lPrePrnAno,;
					      lPrnGru)
			 *Bethlemitas. Iso

		    CASE ANO->nRecNroAno == 10 .OR. ANO->nRecNroAno == 11
			 nVlrTot := nRecMtr10(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      cCodIso,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntMatAno,;
					      ANO->dOpoMatAno,;
					      ANO->dExtMatAno,;
					      ANO->lExtMatAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      13,VAL(TRC->cCodigoTrc),;
					      lPrnGru,ANO->nRecNroAno,;
					      aColMzp)
			 *C¢digo de Barras la Kiosera. La Salle - Descuento


		    ENDCASE

		    IF VALTYPE(nVlrTot) == 'C'
		       cError('Hay Problemas en los valores o los Nombres',;
			      'Por Favor Revise las Tarifas o Conceptos')
		       CloseAll(aUseDbf)
		       SET DEVICE TO SCREEN
		       RETURN NIL
		    ENDIF
		    EJECT
		 ENDIF
*--------------FIN IMPRISION DEL RECIBO DE PAGO POR MATRICULA

*--------------GRABACION DE LOS DETALLES DEL PAGO DE LA MATRICULA
		 IF ANO->nTipFacAno == 1 .OR. ANO->nTipFacAno == 3

		    lHayPag := lLocPagMat(cCodigoTes,;
					  VAL(TRC->cCodigoTrc),.F.)

		    IF PAG->(lRegLock(lShared,!lHayPag))
		       REPL PAG->cCodigoEst WITH cCodigoTes
		       REPL PAG->cCodigoGru WITH ADM->cCodigoGru
		       REPL PAG->cCodNewGru WITH ADM->cCodigoGru
		       REPL PAG->cMatricPag WITH '1'
		       REPL PAG->nNroFacAno WITH nNroFac
		       REPL PAG->cCodigoBan WITH ANO->cCodBanAno

		       IF ANO->lIntMatAno
			  REPL PAG->lIntPenPag WITH .T.  //m
			  REPL PAG->nIntMorPag WITH ANO->nIntMatAno
			  REPL PAG->nVlrMorPag WITH 0
		       ELSE
			  REPL PAG->lIntPenPag WITH .F.  //m
			  REPL PAG->nVlrMorPag WITH IF(nVlrTot==0,0,ANO->nMorMatAno)
			  REPL PAG->nIntMorPag WITH 0
		       ENDIF

		       REPL PAG->nMesIniPag WITH 13
		       REPL PAG->nMesFinPag WITH VAL(TRC->cCodigoTrc)
		       REPL PAG->nVlrMesPag WITH nVlrMesTpa
		       REPL PAG->nVlrpagPag WITH nVlrTot
		       REPL PAG->cConcepPag WITH cConcep
		       FOR i := 1 TO LEN(aVlrCon)
			   REPL &('PAG->nVlrCo'+STR(i,1)+'Pag');
				WITH aVlrCon[i]
		       ENDFOR
		       REPL PAG->nVlrDesPag WITH nDescue
		       REPL PAG->nPagParPag WITH nPagPar
		       REPL PAG->nVlrRecPag WITH nRecarg
		       REPL PAG->dFecFacPag WITH DATE()
		       REPL PAG->dPagopoPag WITH ANO->dOpoMatAno
		       REPL PAG->dPagextPag WITH ANO->dExtMatAno
		       REPL PAG->dFecPagPag WITH CTOD("00/00/00")
		       REPL PAG->cEstadoPag WITH 'P'
		       REPL PAG->cNomUsrPag WITH cNomUsr
		       REPL PAG->dFecUsrPag WITH DATE()
		       REPL PAG->cHorUsrPag WITH TIME()
		       PAG->(DBCOMMIT())
		    ELSE
		       cError('LOS DETALLES DEL PAGO DE MATRICULA '+;
			      'DEL CODIGO '+ADM->cNumeroAdm+' NO SE GRABAN')
		    ENDIF
		    IF lShared
		       PAG->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DE LOS DETALLES DEL PAGO DE LA MATRICULA

*--------------IMPRISION DEL RECIBO DE PAGO POR PENSION
		 IF ANO->nTipFacAno == 2 .OR. ANO->nTipFacAno == 3

		    cConcep := RTRIM(ANO->cConPenAno)+ADM->cConcepEst
		    cConcep := SUBS(cConcep,1,14)

		    DO CASE
		    CASE ANO->nRecNroAno == 1
			 nVlrTot := nRecMtr01(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntPenAno,;
					      ANO->dOpoPenAno,;
					      ANO->dExtPenAno,;
					      ANO->lExtPenAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      nMesIni,nMesIni,;
					      ANO->lPrePrnAno,;
					      lPrnGru)

		    CASE ANO->nRecNroAno == 2
			 nVlrTot := nRecMtr02(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntPenAno,;
					      ANO->dOpoPenAno,;
					      ANO->dExtPenAno,;
					      ANO->lExtPenAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      nMesIni,nMesIni,;
					      ANO->lPrePrnAno,;
					      lPrnGru)

		    CASE ANO->nRecNroAno == 3 .OR. ANO->nRecNroAno == 4
			 nVlrTot := nRecMtr03(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntPenAno,;
					      ANO->dOpoPenAno,;
					      ANO->dExtPenAno,;
					      ANO->lExtPenAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      nMesIni,nMesIni,;
					      lPrnGru)
			 *Recibo de la Salle con colilla

		    CASE ANO->nRecNroAno == 5 .OR. ANO->nRecNroAno == 6
			 nVlrTot := nRecMtr05(lShared,cEmpPal,cNitEmp,;
					      cNomEmp,cNomUsr,cAnoUsr,;
					      cJorTxt,;
					      @nNroFac,;
					      cCodigoTes,;
					      cNombreTes,;
					      ADM->cCodigoGru,;
					      BAN->cNombreBan,;
					      BAN->cNroCtaBan,;
					      BAN->cLugarBan,;
					      cConcep,;
					      ANO->nIntPenAno,;
					      ANO->dOpoPenAno,;
					      ANO->dExtPenAno,;
					      ANO->lExtPenAno,;
					      ANO->cMensajAno,;
					      @nVlrMesTpa,;
					      @aVlrCon,;
					      nMesIni,nMesIni,;
					      lPrnGru,NIL,;
					      @nDescue,@nPagPar,@nRecarg)
			 *Recibo c¢digo de Barras la Kiosera

		    ENDCASE

		    IF VALTYPE(nVlrTot) == 'C'
		       cError('Hay Problemas en los valores o los Nombres',;
			      'Por Favor Revise las Tarifas o Conceptos')
		       CloseAll(aUseDbf)
		       SET DEVICE TO SCREEN
		       RETURN NIL
		    ENDIF
		    EJECT
		 ENDIF
		 lPrnGru := .T.
*--------------FIN IMPRISION DEL RECIBO DE PAGO POR PENSION

*--------------GRABACION DE LOS DETALLES DEL PAGO DE LA PENSION
		 IF ANO->nTipFacAno == 2 .OR. ANO->nTipFacAno == 3

		    lHayPag := lLocPagPen(cCodigoTes,.F.)

		    IF PAG->(lRegLock(lShared,!lHayPag))
		       REPL PAG->cCodigoEst WITH cCodigoTes
		       REPL PAG->cCodigoGru WITH ADM->cCodigoGru
		       REPL PAG->cCodNewGru WITH ADM->cCodigoGru
		       REPL PAG->cMatricPag WITH '0'
		       REPL PAG->nNroFacAno WITH nNroFac
		       REPL PAG->cCodigoBan WITH ANO->cCodBanAno

		       IF ANO->lIntPenAno
			  REPL PAG->lIntPenPag WITH .T.  //m
			  REPL PAG->nIntMorPag WITH ANO->nIntPenAno
			  REPL PAG->nVlrMorPag WITH 0
		       ELSE
			  REPL PAG->lIntPenPag WITH .F.  //m
			  REPL PAG->nVlrMorPag WITH IF(nVlrTot==0,0,ANO->nMorPenAno)
			  REPL PAG->nIntMorPag WITH 0
		       ENDIF

		       REPL PAG->nMesIniPag WITH nMesIni
		       REPL PAG->nMesFinPag WITH nMesIni
		       REPL PAG->nVlrMesPag WITH nVlrMesTpa
		       REPL PAG->nVlrpagPag WITH nVlrTot
		       REPL PAG->cConcepPag WITH cConcep
		       FOR i := 1 TO LEN(aVlrCon)
			   REPL &('PAG->nVlrCo'+STR(i,1)+'Pag');
				WITH aVlrCon[i]
		       ENDFOR
		       REPL PAG->nVlrDesPag WITH nDescue
		       REPL PAG->nPagParPag WITH nPagPar
		       REPL PAG->nVlrRecPag WITH nRecarg
		       REPL PAG->dFecFacPag WITH DATE()
		       REPL PAG->dPagopoPag WITH ANO->dOpoPenAno
		       REPL PAG->dPagextPag WITH ANO->dExtPenAno
		       REPL PAG->dFecPagPag WITH CTOD("00/00/00")
		       REPL PAG->cEstadoPag WITH 'P'
		       REPL PAG->cNomUsrPag WITH cNomUsr
		       REPL PAG->dFecUsrPag WITH DATE()
		       REPL PAG->cHorUsrPag WITH TIME()
		       PAG->(DBCOMMIT())
		    ELSE
		       cError('LOS DETALLES DEL PAGO DE PENSION '+;
			      'DEL CODIGO '+ADM->cNumeroAdm+' NO SE GRABAN')
		    ENDIF
		    IF lShared
		       PAG->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DE LOS DETALLES DEL PAGO DE LA PENSION

	       SELECT ADM
	       SKIP

	    ENDDO
**********IMPRESION DE LOS RECIBOS DE PAGO DEL NIVEL

	  SELECT NIV
	  SKIP

       ENDDO
       SET FILTER TO
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS RECIBOS DE PAGO

