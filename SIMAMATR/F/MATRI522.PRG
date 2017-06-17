/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: FACTURAR ANTIGUOS      MODULO No. 522

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI522.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE RECIBOS POR ALUNNO. ANTIGUOS       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 05/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:40 PM   NOV 05/96 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir todos los recibos de pago de matr¡cula y de pensi¢n
   por alumno de los estudiantes nuevos con cupo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_522(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX1.PRG"              // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       #DEFINE  TAMPA22 CHR(27)+'C'+CHR(22) // P gina de 22 l¡neas
       #DEFINE  TAMPA34 CHR(27)+'C'+CHR(34) // P gina de 34 l¡neas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
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

       LOCAL cNalias := ''                  // Nombre del Alias
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior
       LOCAL nNroFac := 0                   // N£mero de la factura. Consecutivo
       LOCAL cNroFac := ''                  // N£mero de la factura. Consecutivo
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nRegPag := 0                   // Registro del pago
       LOCAL nVlrTot := 0                   // Valor total del recibo

       LOCAL lHayPag := .F.                 // .T. Hay pago o facturaci¢n
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nMesIni := 0                   // Mes Inicial del pago
       LOCAL nMesFin := 0                   // Mes Final del pago
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
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del Grado
       LOCAL nVlrMesTpa := 0                // Valor recibo para un mes
     *ÀVariables temporales de Campo
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

       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
       LOCAL cJornad := ''                  // Jornadas habilitadas
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
		       @cMaeAlu,@cMaeAct,@cJorTxt,@cJornad)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       nOpcion := nLeeOpcion('ESTUDIANTE: '+;
			     '1<ANTIGUO> '+;
			     '2<A¥OS ANTERIORES 3<ABANDONAR>?',4,'1')

       IF nOpcion == 3
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>LECTURA Y VALIDACION DEL A¥O
       IF nOpcion == 2 // A¥OS ANTERIORES

	  cSavPan := SAVESCREEN(0,0,24,79)
	  cAnoAnt := SPACE(04)
	  @ nFilInf+1,nColInf SAY 'A¥O:' GET cAnoAnt PICT '9999'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(cAnoAnt)
	     cError('SE ABANDONA EL PROCESO')
	     CloseAll()
	     RETURN NIL
	  ENDIF

	  MaeHab(lShared,nModCry,;
		 cAnoAnt+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
		 fMtrAno+cAnoAnt+ExtFile,;
		 @cMaeAlu,@cJornad,'ANO->cMaeHabAno','ANO->cJorHabAno')
       *ÀMaestros habilitados.

       ENDIF
*>>>>FIN LECTURA Y VALIDACION DEL A¥O

*>>>>SELECION DEL A¥O ANTERIOR
       IF nOpcion == 1
	  cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	  cPatAnt := cPatSis
	  cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	  cPatAnt := PathUno+'\'+cPatAnt
       ELSE
	  cAnoAnt := cAnoAnt
	  cPatAnt := cPatSis
	  cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	  cPatAnt := PathUno+'\'+cPatAnt
       ENDIF
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatAnt+'\'+cMaeAct+'\'+;
			 FileNiv+SUBS(cAnoAnt,3,2)+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileMzp,'MZP',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

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
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMaeMtr(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2))
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       aColMzp := aColFilMzp(01)

       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('No Existen Estudiantes para '+cMaeAct+' PARA '+cAnoAnt)

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE EMPTY(SCO->cCodEmpCon)
	    cError('NO SE HA ESPECIFICADO EL CODIGO DE LA EMPRESA')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS NIVELES')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ANO->nRecNroAno == 0 .OR. ANO->nRecNroAno > 11
	    cError('EL RECIBO No.'+STR(ANO->nRecNroAno,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE ANO->nRecNroAno >= 7 .AND. ANO->nRecNroAno <= 8 .AND.;
	    SCO->nCodEmpCon == 0
	    cError('EL CODIGO DE LA EMPRESA PARA FACTURAR SE DEBE DEFINIR')

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

*>>>>CAPTURA Y VALIDACION DEL RANGO DE MESES A PAGAR
       IF ANO->nTipFacAno # 1
	  cSavPan := SAVESCREEN(0,0,24,79)
	  MesIniFin(nFilInf+1,IF(nColInf+49>80,31,nColInf),@nMesIni,@nMesFin)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nMesIni == 0 .OR. nMesFin == 0
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN CAPTURA Y VALIDACION DEL RANGO DE MESES A PAGAR

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
		   nMesIni,nMesFin,cAnoUsr,TRC->cNombreTrc)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONSULTA DE LOS DETALLES PARA LA FACTURACION

*>>>>CORRECION DE LOS DETALLES PARA LA FACTURACION
       LineaEstado('<F2>CAMBIA LOS DETALLES DE LA FACTURACION',cNomSis)

       SETKEY(K_F2,{||CamDetFac(lShared,nFilPal+1,1,BAN->cNombreBan,;
				BAN->cNroCtaBan,nMesIni,nMesFin,cAnoUsr,;
				TRC->cNombreTrc)})
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SETKEY(K_F2,NIL)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SETKEY(K_F2,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CORRECION DE LOS DETALLES PARA LA FACTURACION

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ReciAluA'
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
       DO WHILE .T.

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

**********CAPTURA DEL CODIGO DEL ESTUDIANTE
	    cCodigoTes := cLeeCodEst(nFilInf+1,nColInf,cMaeAlu,@cMaeAct)
	       cNalias := cMaeAct
	    IF LASTKEY() == K_ESC .OR. VAL(cCodigoTes) == 0 .OR.;
	       EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst)
**********FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

**********VALIDACION DEL ESTUDIANTE
	    DO CASE
	    CASE !(&cNalias->lSiCupoEst)

		 cError(cNombreTes+' NO TIENE CUPO')
		 LOOP

*	    CASE &cNalias->lRetiroEst

*		 cError(cNombreTes+ ' ESTA RETIRADO')
*		 LOOP

	    CASE SUBS(&cNalias->cCodigoGru,1,2) == '11' .AND.;
		 !&cNalias->lRepiteEst

		 cError(cNombreTes+' ES BACHILLER')
		 LOOP

	    ENDCASE
**********FIN VALIDACION DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ES REPITENTE
	    IF &cNalias->lRepiteEst
	       IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
		  cCodigoTgr := '0000'
	       ELSE
		  cCodigoTgr := SUBS(&cNalias->cCodigoGru,1,2)+'00'
	       ENDIF
	    ELSE
	       IF SUBS(&cNalias->cCodigoGru,1,2) == '16'
		  cCodigoTgr := '00'
	       ELSE
		  IF SUBS(&cNalias->cCodigoGru,1,2) == '17'
		     cCodigoTgr := '01'
		  ELSE
		     cCodigoTgr := STR(VAL(SUBS(&cNalias->cCodigoGru,1,2))+1,2)
		  ENDIF
	       ENDIF
	       lCorrecion(@cCodigoTgr)
	       cCodigoTgr += '00'
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ES REPITENTE

**********LECTURA DEL GRADO PARA A¥OS ANTERIORES
	    cSavLin := SAVESCREEN(nFilInf+2,0,nFilInf+2,79)
	    IF nOpcion == 2 // A¥OS ANTERIORES

	       DO WHILE .T.
		  IF !lLeeCodNiv(nFilInf+2,nColInf,@cCodigoTni,;
			       {||lValCodNiv(cCodigoTni,cMaeAlu)})
		     LOOP
		  ENDIF
		  EXIT
	       ENDDO
	       cCodigoTgr := cCodigoTni+'00'
	    ENDIF
**********FIN LECTURA DEL GRADO PARA A¥OS ANTERIORES

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       cError('NO SE IMPRIME EL RECIBO. DECIDIO NO CONTINUAR')
	       RESTSCREEN(nFilInf+2,0,nFilInf+2,79,cSavLin)
	       LOOP
	    ENDIF
	    RESTSCREEN(nFilInf+2,0,nFilInf+2,79,cSavLin)
**********FIN PREGUNTA DE DECISION

**********VALIDACION DEL RECIBO No. 09. Bethlemitas. Barranca
	    IF ANO->nRecNroAno == 9
	       cConcep := ALLTRIM(ANO->cConMatAno)
	       IF LEN(ALLTRIM(cConcep))/2 > 3
		  LOOP
	       ENDIF
	       cConcep := SUBS(cConcep+SPACE(06),1,6)
	    ELSE
	       cConcep := ANO->cConMatAno
	    ENDIF
**********FIN VALIDACION DEL RECIBO No. 09. Bethlemitas. Barranca

**********IMPRISION DEL RECIBO DE PAGO POR MATRICULA
	    SET DEVICE TO PRINT
	    IF ANO->nTipFacAno == 1 .OR. ANO->nTipFacAno == 3

	       DO CASE
	       CASE ANO->nRecNroAno == 1

		    nVlrTot := nRecMtr01(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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

	       CASE ANO->nRecNroAno == 2

		    nVlrTot := nRecMtr02(lShared,cEmpPal,cNitEmp,;
					 cNomEmp,cNomUsr,cAnoUsr,;
					 cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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

	       CASE ANO->nRecNroAno == 3 .OR. ANO->nRecNroAno == 4

		    nVlrTot := nRecMtr03(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cNomUsr,cAnoUsr,cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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

		    nVlrTot := nRecMtr05(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cNomUsr,cAnoUsr,cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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
			 *Recibo c¢digo de Barras la Kiosera

	       CASE ANO->nRecNroAno == 7 .OR. ANO->nRecNroAno == 8

		    nVlrTot := nRecMtr07(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cNomUsr,cAnoUsr,cJorTxt,;
					 cCodIso,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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

		    nVlrTot := nRecMtr10(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cNomUsr,cAnoUsr,cJorTxt,;
					 cCodIso,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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
					 lPrnGru,ANO->nRecNroAno,aColMzp)
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
**********FIN IMPRISION DEL RECIBO DE PAGO POR MATRICULA

**********GRABACION DE LOS DETALLES DEL PAGO DE LA MATRICULA
	    IF ANO->nTipFacAno == 1 .OR. ANO->nTipFacAno == 3

	       lHayPag := lLocPagMat(&cNalias->cCodigoEst,;
				     VAL(TRC->cCodigoTrc),.F.)

	       IF PAG->(lRegLock(lShared,!lHayPag))
		  REPL PAG->cCodigoEst WITH &cNalias->cCodigoEst
		  REPL PAG->cCodigoGru WITH &cNalias->cCodigoGru
		  REPL PAG->cCodNewGru WITH cCodigoTgr
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
			 'DEL CODIGO '+&cNalias->cCodigoEst+' NO SE GRABAN')
	       ENDIF
	       IF lShared
		  PAG->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO DE LA MATRICULA

**********IMPRISION DEL RECIBO DE PAGO POR PENSION
	    IF ANO->nTipFacAno == 2 .OR. ANO->nTipFacAno == 3

	       cConcep := RTRIM(ANO->cConPenAno)+&cNalias->cConcepEst
	       cConcep := SUBS(cConcep,1,14)

	       DO CASE
	       CASE ANO->nRecNroAno == 1

		    nVlrTot := nRecMtr01(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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
					 nMesIni,nMesFin,;
					 ANO->lPrePrnAno,;
					 lPrnGru)

	       CASE ANO->nRecNroAno == 2

		    nVlrTot := nRecMtr02(lShared,cEmpPal,cNitEmp,;
					 cNomEmp,cNomUsr,cAnoUsr,;
					 cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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
					 nMesIni,nMesFin,;
					 ANO->lPrePrnAno,;
					 lPrnGru)

	       CASE ANO->nRecNroAno == 5 .OR. ANO->nRecNroAno == 6

		    nVlrTot := nRecMtr05(lShared,cEmpPal,cNitEmp,cNomEmp,;
					 cNomUsr,cAnoUsr,cJorTxt,;
					 @nNroFac,;
					 &cNalias->cCodigoEst,;
					 cNombreTes,;
					 cCodigoTgr,;
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
					 nMesIni,nMesFin,;
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
**********FIN IMPRISION DEL RECIBO DE PAGO POR PENSION

**********GRABACION DE LOS DETALLES DEL PAGO DE LA PENSION
	    IF ANO->nTipFacAno == 2 .OR. ANO->nTipFacAno == 3

	       lHayPag := lLocPagPen(&cNalias->cCodigoEst,.F.)

	       IF PAG->(lRegLock(lShared,!lHayPag))
		  REPL PAG->cCodigoEst WITH &cNalias->cCodigoEst
		  REPL PAG->cCodigoGru WITH &cNalias->cCodigoGru
		  REPL PAG->cCodNewGru WITH cCodigoTgr
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

		  REPL PAG->nIntMorPag WITH ANO->nIntPenAno
		  REPL PAG->nMesIniPag WITH nMesIni
		  REPL PAG->nMesFinPag WITH nMesFin
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
			 'DEL CODIGO '+&cNalias->cCodigoEst+' NO SE GRABAN')
	       ENDIF
	       IF lShared
		  PAG->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DE LOS DETALLES DEL PAGO DE LA PENSION

       ENDDO
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS RECIBOS DE PAGO