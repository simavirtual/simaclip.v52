/*                  SIMA - SISTEMA PARA INTRANET E INTERNET

MODULO      : ENTRADAS
SUBMODULO...: MENSUALIDADES

**************************************************************************
* TITULO..: PAGO DE LAS MENSUALIDADES                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 17/2005 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   AGO 17/2005 MIE

OBJETIVOS:

1- Permite el pago de las mensualidades

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pak_102(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		 cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
		 nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
		 cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodEmp			            // C¢digo de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL cCodTem := ''                  // Codigo Temporal
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL cNroFac := ''                  // N£mero de la factura
       LOCAL nBasIva := 0                   // Base del Iva
       LOCAL nVlrIva := 0                   // Valor del Iva
       LOCAL nNroCaj := 0                   // N£mero de la Caja
       LOCAL cTitulo := ''                  // T¡tulo
       LOCAL aTiempo := {}                  // Tiempo Transcurrido
       LOCAL aTimes  := {}                  // Tiempo de Parqueo
       LOCAL nTipHor := 0                   // Tipo de Hora

       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cNalias := ''                  // Alias del Archivo
       MEMVA xClrSys			    // Color del Sistema
       LOCAL cNombre := ''                  // Nombre del Proveerdor
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cPlacaTve  := ''               // N£mero de Placa
       LOCAL dFecIngTre := CTOD('00/00/00') // Fecha de Ingreso
       LOCAL cHorIngTre := ''               // Hora de Ingreso
       LOCAL dFecOutTre := CTOD('00/00/00') // Fecha de Salida
       LOCAL cHorOutTre := ''               // Hora de Salida
       LOCAL nVlrTotTre := 0                // Valor del Servicio

       LOCAL cTipVehTca := ''               // Tipo de Vehiculo
       LOCAL cNombreTca := ''               // Nombre de la Categoria
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimPak,'PAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+;
			 FilePer,'PER',;
			 PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+;
			 Ntx1Per,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+;
			 FileEmp,'EMP',;
			 PathSis(cPatDat+'\'+cPatSys,PathSis)+'\'+;
			 fNtxEmp,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileReg,'REG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileCat,'CAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileCaj,'CAJ',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileVeh,'VEH',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE PAR->nMinFraPak == 0
	    cError('NO SE HA DEFINIDO LA FRACION DE MINUTOS A COBRAR')

       CASE CAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN CATEGORIAS GRABADAS')

       CASE CAJ->(RECCOUNT()) == 0
	    cError('NO EXISTEN CAJAS REGISTRADAS')

       CASE VEH->(RECCOUNT()) == 0
	    cError('NO EXISTEN VEHICULOS REGISTRADOS')

       CASE !lTarifasOk()

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE LA CAJA
       nNroCaj := 0
       IF CAJ->(RECCOUNT()) == 1
	  CAJ->(DBGOTOP())
	  nNroCaj := CAJ->nCodigoCaj
       ENDIF

       IF nNroCaj == 0

	  @ nFilInf+1,nColInf SAY 'CAJA No.' GET nNroCaj PICT '99';
			      VALID lValCaj(ROW(),COL()-2,@nNroCaj)
	  READ
	  IF EMPTY(nNroCaj) .OR.;
	     !lPregunta('DESEA CONTINUAR? Si No')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA DE LA CAJA

*>>>>VALIDACION DEL CAJERO
       IF !(CAJ->nCodigoCaj == nNroCaj .AND.;
	    ALLTRIM(CAJ->cCajeroCaj) == ALLTRIM(cNomUsr))

	    cError('EL CAJERO '+ALLTRIM(cNomUsr)+' '+;
		   'NO ESTA A CARGO DE LA CAJA No.'+STR(CAJ->nCodigoCaj,2))

	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CAJERO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',PAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ACTIVACION DE LA IMPRESORA
       IF PAR->lPrnArcPak
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'mensual'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,PAR->cOpcRecPak,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilInf+1,NIL,NIL,'°',xClrSys[7])
       cCabeza := cRegPrint({'PLACA',;
			     'F.INICIO',;
			     'F.FINAL',;
			     'VALOR',;
			     'TIPO'},;
			    {06,20,20,12,6},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>VISUALIZACION DE LA FECHA
       cTitulo := 'ºCAJA No. '+STR(CAJ->nCodigoCaj,2)+'º'
*>>>>FIN VISUALIZACION DE LA FECHA

*>>>>INGRESOS AL PARQUEADERO
       DO WHILE .T.

**********REGISTRO DEL VEHICULO
	    IF lGrabar
	       cPlacaTve := cSpaces('REG','cPlacaVeh')
	    ENDIF
**********FIN REGISTRO DEL VEHICULO

**********LECTURA DE LA PLACA
	    @ nNroFil,aNroCol[1] GET cPlacaTve PICT '@! XXXXXX'
	    READ

	    IF EMPTY(cPlacaTve)
	       IF lPregunta('DESEA ABANDONAR? No Si')
		  EXIT
	       ELSE
		  LOOP
	       ENDIF
	    ENDIF
**********FIN LECTURA DE LA PLACA

**********LOCALIZACION DEL VEHICULO
	    IF !lLocCodigo('cPlacaVeh','VEH',cPlacaTve)
	       cError('EL VEHICULO CON PLACA '+ALLTRIM(cPlacaTve)+' '+;
		      'NO FIGURA REGISTRADO')
	       LOOP
	    ENDIF

	    IF DATE() <= VEH->dFinPakVeh
	       cError('EL VEHICULO CON PLACA '+ALLTRIM(cPlacaTve)+' '+;
		      'TIENE EL SERVICIO HASTA '+cFecha(VEH->dFinPakVeh))
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL VEHICULO

**********LOCALIZACION DEL TERCERO
	    IF !lValDoc(VEH->cDocDueVeh,VEH->cTipNitVeh,@cNalias)
	       cError('NO EXISTE LA '+IF(cNalias == 'PER',;
		      'PERSONA','EMPRESA')+' CON DOCUMENTO No.'+;
		      ALLTRIM(VEH->cDocDueVeh))
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL TERCERO

**********NOMBRE DEL CLIENTE
	    DO CASE
	    CASE cNalias == 'PER'
		 cNombre := cNomApePer()

	    CASE cNalias == 'EMP'
		 cNombre := ALLTRIM(EMP->cNombreEmp)
	    ENDCASE
**********NOMBRE DEL CLIENTE

**********LOCALIZACION DEL TIPO DE VEHICULO
	    IF !lLocCodigo('cTipVehCat','CAT',VEH->cTipVehCat)
	       cError('NO EXISTE EL TIPO DE VEHICULO:'+cTipVehTca)
	       LOOP
	    ENDIF
	    cNombreTca := ALLTRIM(CAT->cNombreCat)
**********FIN LOCALIZACION DEL TIPO DE VEHICULO

**********FECHA POR DEFECTO
	    dFecIngTre := DATE()
	    cHorIngTre := '00:00:00'

	    DO CASE
	    CASE MONTH(dFecIngTre) # 12

		 dFecOutTre := dFecha(YEAR(dFecIngTre),;
				      MONTH(dFecIngTre)+1,;
				      DAY(dFecIngTre))
	    OTHERWISE
		 dFecOutTre := DATE()+31
	    ENDCASE
	    cHorOutTre := '24:00:00'
**********FIN FECHA POR DEFECTO

**********LECTURA DE LA FECHA
	    cTxtHlp := 'POR FAVOR LA FECHA INICIAL DE INGRESO. '+;
		       'FORMATO: MM/DD/AAAA'
	    @ nNroFil,aNroCol[2] GET dFecIngTre PICT "@D";
				 WHEN {||HelpRead(cTxtHlp)}

	    cTxtHlp := 'POR FAVOR LA FECHA FINAL DE INGRESO. '+;
		       'FORMATO: MM/DD/AAAA'
	    @ nNroFil,aNroCol[3] GET dFecOutTre PICT "@D";
				 WHEN {||HelpRead(cTxtHlp)}

	    IF !PAR->lVlrMenPak
	       nVlrTotTre := 0
	       cTxtHlp := 'POR FAVOR EL VALOR DE LA MENSUALIDAD'
	       @ nNroFil,aNroCol[4] GET nVlrTotTre PICT "999999999.99";
				    VALID nVlrTotTre > 0;
				    WHEN {||HelpRead(cTxtHlp)}
	    ENDIF
	    READ
**********FIN LECTURA DE LA FECHA

**********VALIDACION DE LA FECHA
	    lHayErr := .T.
	    DO CASE
	    CASE dFecIngTre < DATE()
		 cError('LA FECHA INICIAL NO PUEDE SER INFERIOR A '+;
			cFecha(DATE()))

	    CASE dFecOutTre < dFecIngTre
		 cError('LA FECHA FINAL NO PUEDE SER ANTERIOR A LA FECHA INICIAL')

	    CASE dFecIngTre <= VEH->dFinPakVeh

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA FECHA

**********CALCULO DE LA TARIFA
	    aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				 cHorIngTre,cHorOutTre,;
				 PAR->cIniDiaPak,PAR->cFinDiaPak,;
				 PAR->cIniNocPak,PAR->cFinNocPak,;
				 @nTipHor)

	    aTimes := aTimePak(aTiempo,;
			       PAR->nMinFraPak,;
			       PAR->nMinDesPak,;
			       nTipHor,;
			       PAR->lMinDesPak)

	    IF PAR->lVlrMenPak
	       nVlrTotTre := nVlrSer(aTimes,CAT->cTipVehCat,PAR->lTotHorPak)
	     *ÀCalculo del valor del parqueo

	       @ nNroFil,aNroCol[4] SAY TRANS(REG->nVlrTotReg,'###,###,###.99');
					COLOR('I')
	    ENDIF
**********FIN CALCULO DE LA TARIFA

**********ANALISIS DE DECISION
	    lGrabar := lPregunta('DESEA REGISTRAR EL VEHICULO? Si No')
	    IF !lGrabar
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DEL NUMERO DEL RECIBO
	    SELECT PAR
	    IF PAR->(lRegLock(lShared,.F.))
	       REPL PAR->nNroFacPak WITH PAR->nNroFacPak+1
	    ENDIF

	    IF lShared
	       REG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL NUMERO DEL RECIBO

**********GRABACION DEL REGISTRO
	    SELECT REG
	    IF REG->(lRegLock(lShared,.T.))

	       REPL REG->nIdeCodReg WITH REG->(RECNO())
	       REPL REG->cPlacaVeh  WITH cPlacaTve
	       REPL REG->cTipVehCat WITH VEH->cTipVehCat

	       REPL REG->dFecIngReg WITH dFecIngTre
	       REPL REG->cHorIngReg WITH cHorIngTre

	       REPL REG->dFecOutReg WITH dFecOutTre
	       REPL REG->cHorOutReg WITH cHorOutTre

	       REPL REG->cTiempoReg WITH cTimeTxt(aTiempo)
	       REPL REG->cTieCobReg WITH cTimeTxt(aTimes)

	       REPL REG->nNroFacReg WITH PAR->nNroFacPak
	       REPL REG->nCodigoCaj WITH nNroCaj

	       REPL REG->nVlrTotReg WITH nVlrTotTre
	       IF PAR->nPorIvaPak # 0
		  nBasIva := 0
		  nVlrIva := 0
		  BasIva(nVlrTotTre,PAR->nPorIvaPak,@nBasIva,@nVlrIva)

		  REPL REG->nBasIvaReg WITH nBasIva
		  REPL REG->nPorIvaReg WITH PAR->nPorIvaPak
		  REPL REG->nVlrIvaReg WITH nVlrIva
	       ENDIF

	       REPL REG->cNomUsrReg WITH cNomUsr
	       REPL REG->dFecUsrReg WITH DATE()
	       REPL REG->cHorUsrReg WITH TIME()
	       REG->(DBCOMMIT())
	    ENDIF

	    IF lShared
	       REG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********REGISTRO EN LA CAJA
	    SELECT CAJ
	    IF CAJ->(lRegLock(lShared,.F.))
	       REPL CAJ->nVlrTotCaj WITH CAJ->nVlrTotCaj+nVlrTotTre
	       REPL CAJ->cNomUsrCaj WITH cNomUsr
	       REPL CAJ->dFecUsrCaj WITH DATE()
	       REPL CAJ->cHorUsrCaj WITH TIME()
	       CAJ->(DBCOMMIT())
	    ENDIF

	    IF lShared
	       CAJ->(DBUNLOCK())
	    ENDIF
**********FIN REGISTRO EN LA CAJA

**********REGISTRO DEL VEHICULO
	    SELECT VEH
	    IF VEH->(lRegLock(lShared,.F.))

	       REPL VEH->dIniPakVeh WITH dFecIngTre
	       REPL VEH->dFinPakVeh WITH dFecOutTre
	       REPL VEH->nNroFacReg WITH PAR->nNroFacPak

	       VEH->(DBCOMMIT())
	    ENDIF

	    IF lShared
	       VEH->(DBUNLOCK())
	    ENDIF
**********FIN REGISTRO DEL VEHICULO

**********IMPRESION DEL RECIBO
	    DO CASE
	    CASE .T.
		 lRecibo01(cEmpPal,cNomEmp,cNomSec,;
			   cNitEmp,;
			   PAR->cDirEmpPak,;
			   PAR->cTelEmpPak,;
			   STR(REG->nNroFacReg,9),;
			   REG->cPlacaVeh,;
			   cNombreTca,;
			   REG->dFecIngReg,REG->cHorIngReg,;
			   REG->dFecOutReg,REG->cHorOutReg,;
			   aTiempo,;
			   REG->nVlrTotReg,nBasIva,nVlrIva,;
			   cNomUsr,'MENSUALIDAD')

	    ENDCASE
**********FIN IMPRESION DEL RECIBO

***********CONTROL DE LA FILA DE VISUALIZACION
	     nNroFil++
	     IF nNroFil > 20

*---------------VISUALIZACION DEL ULTIMO CLIENTE
		  nNroFil := nMarco(nFilInf+1,NIL,NIL,'°',xClrSys[7])
		  @ nNroFil-2,01 SAY cCabeza

		  SET COLOR TO I
		  @ nNroFil,aNroCol[1] SAY cPlacaTve
		  SET COLOR TO

		  nNroFil++
*---------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	     ENDIF
***********CONTROL DE LA FILA DE VISUALIZACION

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseAll()
       RETURN NIL
*>>>>FIN INGRESOS AL PARQUEADERO