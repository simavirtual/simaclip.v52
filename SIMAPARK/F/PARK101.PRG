/*                  SIMA - SISTEMA PARA INTRANET E INTERNET

MODULO      : ENTRADAS
SUBMODULO...: REGISTRO

**************************************************************************
* TITULO..: REGISTROS DEL PARQUEADERO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 28/2005 VIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   JUL 28/2005 VIE

OBJETIVOS:

1- Realiza los registros de los ingresos y salidas del parqueadero

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pak_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       #DEFINE ANO 1                        // A¤os
       #DEFINE MES 2                        // Meses
       #DEFINE DIA 3                        // Dias
       #DEFINE HOD 4                        // Horas Diurnas
       #DEFINE MDI 5                        // Minutos Diurnos
       #DEFINE HON 6                        // Horas Nocturnas
       #DEFINE MNO 7                        // Minutos Nocturnos
       #DEFINE SEG 8                        // Segundos

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL cCodTem := ''                  // Codigo Temporal
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL cNroFac := ''                  // N£mero de la factura
       LOCAL nBasIva := 0                   // Base del Iva
       LOCAL nVlrIva := 0                   // Valor del Iva
       LOCAL nNroCaj := 0                   // N£mero de la Caja
       LOCAL cTitulo := ''                  // T¡tulo
       LOCAL aTiempo := {}                  // Tiempo Transcurrido
       LOCAL aTimes1 := {}                  // Tiempo Transcurrido 1
       LOCAL aTimes2 := {}                  // Tiempo Transcurrido 2
       LOCAL aTimes  := {}                  // Tiempo de Parqueo
       LOCAL nTipHor := 0                   // Tipo de Hora
       LOCAL lHayVeh := .F.                 // .T. Hay Vehiculo
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL lLeeCat := .F.                 // .T. Leer Categor¡a
       LOCAL lHayDes := .F.                 // .T. Hay Descuento

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cPlacaTve  := ''               // N£mero de Placa
       LOCAL dFecIngTre := CTOD('00/00/00') // Fecha de Ingreso
       LOCAL cHorIngTre := ''               // Hora de Ingreso
       LOCAL dFecOutTre := CTOD('00/00/00') // Fecha de Salida
       LOCAL cHorOutTre := ''               // Hora de Salida
       LOCAL nVlrTotTre := 0                // Valor del Servicio
       LOCAL cObservTre := ''               // Observaci¢n

       LOCAL cTipVehTca := ''               // Tipo de Vehiculo
       LOCAL cNombreTca := ''               // Nombre de la Categoria
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimPak,'PAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileVeh,'VEH',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileReg,'REG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileCat,'CAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 FileCaj,'CAJ',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
			 fDesPak,'DES',NIL,lShared,nModCry})
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

       CASE PAR->nRoundPak # 0 .AND.;
	    PAR->nRoundPak # 100 .AND.;
	    PAR->nRoundPak # 1000
	    cError('NO SE ACEPTAN VALORES DE REDONDEO DIFERENTES A 100 0 1000')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE PAR->nMinFraPak == 0
	    cError('NO SE HA DEFINIDO LA FRACION DE MINUTOS A COBRAR')

       CASE CAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN CATEGORIAS GRABADAS')

       CASE CAJ->(RECCOUNT()) == 0
	    cError('NO EXISTEN CAJAS REGISTRADAS')

       CASE !lTarifasOk()
	    cError('VERIFICAR LAS TARIFAS')


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
	  FilePrn := 'parqueo'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,PAR->cOpcRecPak,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       lLeeCat := IF(CAT->(RECCOUNT()) > 2,.T.,lLeeCat)

       nNroFil := nMarco(nFilInf+1,NIL,NIL,'°',xClrSys[7])
       cCabeza := cRegPrint({'PLACA',;
			     'ENTRADA',;
			     'SALIDA',;
			     'VALOR',;
			     'TIPO'},;
			    {06,20,20,12,6},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>VISUALIZACION DE LA FECHA
       cTitulo := 'ºCAJA No. '+STR(CAJ->nCodigoCaj,2)+'º'

       IF PAR->lPruebaPak
	  FecHorSys(cNomSis,cTitulo)
	  SETKEY(K_F10,{||LeerFecHora(cNomSis,cTitulo)})
	  cError('LA TECLA <F10> PERMITE MODIFICAR',;
		 'POR FAVOR REVISE LA FECHA Y HORA')
       ENDIF
*>>>>FIN VISUALIZACION DE LA FECHA

*>>>>INGRESOS AL PARQUEADERO
       DO WHILE .T.

**********REGISTRO DEL VEHICULO
	    cObservTre := ''
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

**********LOCALIZACIN DEL REGISTRO
	    SELECT REG
	    REG->(DBGOTOP())

	    lInsReg := .F.   // Vehiculo guardado
	    LOCATE FOR REG->cPlacaVeh == cPlacaTve .AND.;
		       REG->dFecOutReg == CTOD('00/00/00')

	    IF .NOT. FOUND()
	       lInsReg := .T.  // Vehiculo no esta.
	    ENDIF
**********FIN LOCALIZACIN DEL REGISTRO

**********LECTURA DEL TIPO DE VEHICULO
	    IF PAR->nLeeCatPak # 0

	       IF lInsReg
		  nSelCat(nNroFil,aNroCol[2]-1)
		  cTipVehTca := CAT->cTipVehCat
	       ELSE
		  cTipVehTca := REG->cTipVehCat
	       ENDIF

	    ENDIF
**********FIN LECTURA DEL TIPO DE VEHICULO

**********ANALISIS DEL TIPO DE VEHICULO
	    IF PAR->nLeeCatPak == 0

	       IF LEN(ALLTRIM(cPlacaTve)) >= 5

*=================VALIDACION DE LA PLACA
		    IF ISDIGIT(SUBS(cPlacaTve,1,1)) .OR.;
		       ISDIGIT(SUBS(cPlacaTve,2,1))
		       cError('LOS DOS PRIMEROS DIGITOS DEBEN SER LETRAS')
		       LOOP
		    ENDIF
*=================FIN VALIDACION DE LA PLACA

*=================ANALISIS DE LA CATEGORIA
		    cCodTem := SUBS(cPlacaTve,LEN(ALLTRIM(cPlacaTve))-2,3)
		    IF ISDIGIT(SUBS(cCodTem,1,1)) .AND.;
		       ISDIGIT(SUBS(cCodTem,2,1)) .AND.;
		       ISDIGIT(SUBS(cCodTem,3,1))
		       cTipVehTca := '02'
		    ELSE
		       cTipVehTca := '01'
		    ENDIF
*=================FIN ANALISIS DE LA CATEGORIA

	       ELSE
		   cTipVehTca := '03'  // Cicla
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL TIPO DE VEHICULO

**********LOCALIZACION DEL TIPO DE VEHICULO
	    IF !lLocCodigo('cTipVehCat','CAT',cTipVehTca)
	       cError('NO EXISTE EL TIPO DE VEHICULO:'+cTipVehTca)
	       LOOP
	    ENDIF
	    cNombreTca := ALLTRIM(CAT->cNombreCat)
**********FIN LOCALIZACION DEL TIPO DE VEHICULO

**********ANALISIS DE DECISION
	    IF lInsReg
	       dFecIngTre := DATE()
	       cHorIngTre := TIME()
	    ELSE
	       dFecIngTre := REG->dFecIngReg
	       cHorIngTre := REG->cHorIngReg
	       dFecOutTre := DATE()
	       cHorOutTre := TIME()
	    ENDIF

	    @ nNroFil,aNroCol[2] SAY cFecha(dFecIngTre,3)+' '+cHoraSys(cHorIngTre)
	    IF !lInsReg
		@ nNroFil,aNroCol[3] SAY cFecha(dFecOutTre,3)+' '+cHoraSys(cHorOutTre)
	    ENDIF
	    @ nNroFil,aNroCol[5] SAY cNombreTca
**********FIN ANALISIS DE DECISION

**********ANALISIS DE DECISION
	    lGrabar := lPregunta('DESEA REGISTRAR EL '+;
				 ALLTRIM(cNombreTca)+'? Si No')
	    IF !lGrabar
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********CALCULO DEL TIEMPO TRANSCURRIDO
	    lHayPag := .F.
	    lHayVeh := lLocCodigo('cPlacaVeh','VEH',cPlacaTve)

	    DO CASE
	    CASE !lInsReg .AND. !lHayVeh

		 cObservTre := ''
		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀNO hay Mensualidad

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre < VEH->dIniPakVeh .AND.;
		 dFecOutTre < VEH->dFinPakVeh

		 cObservTre := ''
		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀPor fuera de la Mensualidad

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre > VEH->dIniPakVeh .AND.;
		 dFecIngTre > VEH->dFinPakVeh .AND.;
		 dFecOutTre > VEH->dFinPakVeh

		 cObservTre := 'SERVICIO VENCIO: '+cFecha(VEH->dFinPakVeh)
		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Vencida.

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre >= VEH->dIniPakVeh .AND.;
		 dFecOutTre <= VEH->dFinPakVeh

		 lHayPag := .T.
		 cObservTre := 'SERVICIO HASTA '+cFecha(VEH->dFinPakVeh)

		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Total.


	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre <  VEH->dIniPakVeh .AND.;
		 dFecOutTre <= VEH->dFinPakVeh // Pago Parcial Caso No. 2

		 cObservTre := 'SERVICIO DE '+cFecha(VEH->dIniPakVeh)+' A '+;
			       cFecha(VEH->dFinPakVeh)

		 aTiempo := aHoraDias(dFecIngTre,VEH->dIniPakVeh-1,;
				      cHorIngTre,'24:00:00',;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora Inicial por cobrar

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre >= VEH->dIniPakVeh .AND.;
		 dFecIngTre <= VEH->dFinPakVeh .AND.;
		 dFecOutTre >  VEH->dFinPakVeh // Pago Parcial Caso No. 3

		 cObservTre := 'SERVICIO DE '+cFecha(VEH->dIniPakVeh)+' A '+;
			       cFecha(VEH->dFinPakVeh)

		 aTiempo := aHoraDias(VEH->dFinPakVeh+1,dFecOutTre,;
				      '00:00:00',cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora final por cobrar


	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre < VEH->dIniPakVeh  .AND.;
		 dFecOutTre > VEH->dFinPakVeh  // Pago Parcial Caso No. 4

		 cObservTre := 'SERVICIO DE '+cFecha(VEH->dIniPakVeh)+' A '+;
			       cFecha(VEH->dFinPakVeh)

		 aTimes1 := aHoraDias(dFecIngTre,VEH->dIniPakVeh-1,;
				      cHorIngTre,'24:00:00',;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora inicial por cobrar

		 aTimes2 := aHoraDias(VEH->dFinPakVeh+1,dFecOutTre,;
				      '00:00:00',cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora final por cobrar

		 aTiempo := aTimes1
		 FOR i := 1 TO LEN(aTimes2)
		     aTiempo[i] += aTimes2[i]
		 ENDFOR
	       *ÀAcumulaci¢n de los tiempos

	    ENDCASE
**********FIN CALCULO DEL TIEMPO TRANSCURRIDO

**********GRABACION DEL CONTROL DEL TIEMPO
	   IF EMPTY(PAR->dFecSysPak)   .OR.;
	      EMPTY(PAR->cHorSysPak)   .OR.;
		  (DATE()       >=  PAR->dFecSysPak .AND.;
	       nHoraSeg(TIME()) > nHoraSeg(PAR->cHorSysPak))

	       IF PAR->(lRegLock(lShared,.F.))
		  REPL PAR->dFecSysPak WITH DATE()
		  REPL PAR->cHorSysPak WITH TIME()
	       ENDIF

	       IF lShared
		  REG->(DBUNLOCK())
	       ENDIF
	   ENDIF
**********FIN GRABACION DEL CONTROL DEL TIEMPO

**********GRABACION DEL NUMERO DEL RECIBO
	    IF !lInsReg .AND. !lHayPag
	       SELECT PAR
	       IF PAR->(lRegLock(lShared,.F.))
		  REPL PAR->nNroFacPak WITH PAR->nNroFacPak+1
	       ENDIF

	       IF lShared
		  REG->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL NUMERO DEL RECIBO

**********LOCALIZACION DEL DESCUENTO
	    lHayDes := .F.
	    IF !lInsReg

	       SELECT DES
	       DES->(DBGOTOP())

	       LOCATE FOR DES->cTipVehCat == cTipVehTca .AND.;
			  DES->nNroHorDes == aTiempo[HOD]+aTiempo[HON]

	       IF DES->(FOUND())
		  lHayDes := DES->lDesMinDes
	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL DESCUENTO

**********CALCULO DEL TIEMPO DEL PARQUEO
	    IF !lInsReg

	       aTimes := aTimePak(aTiempo,;
				  PAR->nMinFraPak,;
				  PAR->nMinDesPak,;
				  nTipHor,;
				  PAR->lMinDesPak,lHayDes)
	    ENDIF
**********FIN CALCULO DEL TIEMPO DEL PARQUEO

**********CALCULO DE VALOR DEL SERVICIO
	    nVlrTotTre := 0
	    IF !lInsReg .AND. !lHayPag

/*
	       IF PAR->lTarMinPak
		  nVlrTotTre := nVlrSerMin(aTiempo,;
					   CAT->cTipVehCat,;
					   PAR->lTotHorPak)
	       ELSE
		  nVlrTotTre := nVlrSerFra(aTimes,;
					   CAT->cTipVehCat,;
					   PAR->lTotHorPak)
	       ENDIF
*/

	       nVlrTotTre := nVlrSerFra(aTimes,;
					CAT->cTipVehCat,;
					PAR->lTotHorPak)
	     *ÀCalculo del valor del parqueo

	       IF PAR->nRoundPak # 0
		  nVlrTotTre := nVlrRound(nVlrTotTre,PAR->nRoundPak)
	       ENDIF

	       IF PAR->nPorIvaPak # 0
		  nBasIva := 0
		  nVlrIva := 0
		  BasIva(nVlrTotTre,PAR->nPorIvaPak,@nBasIva,@nVlrIva)
	       ENDIF

	    ENDIF
**********FIN CALCULO DE VALOR DEL SERVICIO

**********GRABACION DEL REGISTRO
	    SELECT REG
	    IF REG->(lRegLock(lShared,lInsReg))

	       IF lInsReg

		  REPL REG->nIdeCodReg WITH REG->(RECNO())
		  REPL REG->cPlacaVeh  WITH cPlacaTve
		  REPL REG->cTipVehCat WITH CAT->cTipVehCat
		  REPL REG->dFecIngReg WITH dFecIngTre
		  REPL REG->cHorIngReg WITH cHorIngTre
		  REPL REG->dFecUsrReg WITH DATE()
		  REPL REG->cHorUsrReg WITH TIME()

	       ELSE

		  REPL REG->nNroFacReg WITH PAR->nNroFacPak
		  IF PAR->nPorIvaPak # 0 .AND. !lHayPag
		     REPL REG->nBasIvaReg WITH nBasIva
		     REPL REG->nPorIvaReg WITH PAR->nPorIvaPak
		     REPL REG->nVlrIvaReg WITH nVlrIva
		  ENDIF

		  REPL REG->nCodigoCaj WITH nNroCaj
		  REPL REG->dFecOutReg WITH dFecOutTre
		  REPL REG->cHorOutReg WITH cHorOutTre
		  REPL REG->nVlrTotReg WITH nVlrTotTre
		  REPL REG->cTiempoReg WITH cTimeTxt(aTiempo)
		  REPL REG->cTieCobReg WITH cTimeTxt(aTimes)

		  IF DATE()          <  PAR->dFecSysPak .OR.;
		    (DATE()          =  PAR->dFecSysPak .AND.;
		     nHoraSeg(TIME()) <   nHoraSeg(PAR->cHorSysPak))

		     REPL REG->dFecUsrReg WITH PAR->dFecSysPak
		     REPL REG->cHorUsrReg WITH PAR->cHorSysPak

		  ELSE

		     REPL REG->dFecUsrReg WITH DATE()
		     REPL REG->cHorUsrReg WITH TIME()
		  ENDIF


	       ENDIF
	       REPL REG->cObservReg WITH cObservTre
	       REPL REG->cNomUsrReg WITH cNomUsr

	       REG->(DBCOMMIT())
	    ENDIF

	    IF lShared
	       REG->(DBUNLOCK())
	    ENDIF

	    IF !lInsReg
	       @ nNroFil,aNroCol[4] SAY TRANS(nVlrTotTre,"####,###,###");
					COLOR ('I*')
	       *Abrir la Caja
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********REGISTRO EN LA CAJA
	    IF .NOT. lInsReg

	       SELECT REG
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

	    ENDIF
**********FIN REGISTRO EN LA CAJA

**********ANALISIS DE DECISION
	    IF lHayPag
	       cError('EL VEHICULO CON PLACA '+cPlacaTve+' '+;
		      'TIENE SERVICIO HASTA '+cFecha(VEH->dFinPakVeh))
	    ENDIF
**********FIN ANALISIS DE DECISION

**********IMPRESION DEL RECIBO
	    DO CASE
	    CASE !lHayPag
		 lRecibo01(cEmpPal,cNomEmp,cNomSec,;
			   cNitEmp,;
			   PAR->cDirEmpPak,;
			   PAR->cTelEmpPak,;
			   IF(lInsReg,'',STR(REG->nNroFacReg,9)),;
			   REG->cPlacaVeh,;
			   cNombreTca,;
			   REG->dFecIngReg,REG->cHorIngReg,;
			   REG->dFecOutReg,REG->cHorOutReg,;
			   aTiempo,;
			   REG->nVlrTotReg,nBasIva,nVlrIva,;
			   cNomUsr,cObservTre)

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

		  SET COLOR TO I
		  @ nNroFil,aNroCol[2] SAY cFecha(REG->dFecIngReg,3)+' '+;
					   cHoraSys(REG->cHorIngReg)
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

/*************************************************************************
* TITULO..: RECIBO DE PAGO                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 17/2005 DOM A
       Colombia, Bucaramanga        INICIO: 04:45 PM   ABR 17/2005 DOM

OBJETIVOS:

1- Imprime el recibo de pago

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lRecibo01(cEmpPal,cNomEmp,cNomSec,cNitEmp,cDirEmp,cTelEmp,;
		   cNroFac,cPlaca,cTipVeh,dFecEnt,cHorEnt,dFecOut,;
		   cHorOut,aTiempo,nVlrSer,nBasIva,nVlrIva,cCajero,;
		   cTxtObs)

*>>>>DESCRIPCION DE PARAMETROS
/*     cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre Secundario
       cNitEmp                              // Nit de la Empresa
       cDirEmp                              // Direccion
       cTelEmp                              // Telefono
       cNroFac                              // N£mero de la Factura
       cPlaca                               // Placa del Vehiculo
       cTipVeh                              // Tipo del Vehiculo
       dFecEnt                              // Fecha de Entrada
       cHorEnt                              // Hora de Entrada
       dFecOut                              // Fecha de Salida
       cHorOut			            // Hora de Salida
       aTiempo                              // Tiempo
       nVlrSer                              // Valor del Servicio
       nBasIva                              // @Valor Base del Iva
       nVlrIva                              // @Valor del Iva
       cCajero                              // Nombre del Cajero
       cTxtObs                              // Texto de Observaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL       i := 0                   // Contador
       LOCAL nDiaSer := 0                   // Dias de Servicio
       LOCAL nSecOut := 0                   // N£mero de Segundos
       LOCAL nSecEnt := 0
       LOCAL nNroSec := 0
       LOCAL nNroMIn := 0
       LOCAL nNroHor := 0                   // Horas del Servicio
       LOCAL cFecEnt := ''
       LOCAL cChrPrn := ''                  // Caracteres de Impresi¢n
       LOCAL aTimes  := {}                  // Total Tiempo
       LOCAL cTiempo := ''                  // Tiempo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       SendCodes(PCL({'Pica','CondenOn'}))
       SETPRC(0,0)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>TOTAL DE TIEMPO
       IF .NOT. EMPTY(dFecOut)
	   aTimes := {}
	   AADD(aTimes,aTiempo[ANO])
	   AADD(aTimes,aTiempo[MES])
	   AADD(aTimes,aTiempo[DIA])
	   AADD(aTimes,aTiempo[HOD]+aTiempo[HON])
	   AADD(aTimes,aTiempo[MDI]+aTiempo[MNO])
	   AADD(aTimes,aTiempo[SEG])

	   IF aTimes[5] >= 60
	      nNroHor := INT(aTimes[5]/60)
	      nNroMin := aTimes[5] - nNroHor*60
	      aTimes[4] += nNroHor
	      aTimes[5] := nNroMin
	   ENDIF
	 *ÀMinutos a Horas

	   cTiempo := cTimeTxt(aTimes)
       ENDIF
*>>>>FIN TOTAL DE TIEMPO

*>>>>EMPRESA PRINCIPAL
       aNroLin := aDivLin(cEmpPal,40)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       NEXT
*>>>>FIN EMPRESA PRINCIPAL

*>>>>EMPRESA SECUNDARIA
       aNroLin := aDivLin(cNomEmp,40)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       NEXT
*>>>>FIN EMPRESA SECUNDARIA

*>>>>IMPRESION DEL ENCABEZADO
       @ PROW()+1,00 SAY 'Nit. '+cNitEmp

       IF !EMPTY(cDirEmp) .OR. !EMPTY(cTelEmp)
	  @ PROW()+1,00 SAY ALLTRIM(cDirEmp)+SPACE(04)+'Tel: '+cTelEmp
       ENDIF

       IF PAR->nPorIvaPak == 0
	  @ PROW()+1,00 SAY 'REGIMEN SIMPLIFICADO'
       ELSE
	  @ PROW()+1,00 SAY 'REGIMEN COMUN'
       ENDIF

       IF PAR->nPorIvaPak == 0
	  IF EMPTY(cNroFac)
	     @ PROW()+1,00 SAY 'CAJERO: '+ALLTRIM(cCajero)
	  ELSE
	     @ PROW()+1,00 SAY 'CAJERO: '+ALLTRIM(cCajero)+SPACE(06)+;
			       'RECIBO No. '+ALLTRIM(cNroFac)
	  ENDIF
       ELSE
	  IF EMPTY(cNroFac)
	     @ PROW()+1,00 SAY 'CAJERO: '+ALLTRIM(cCajero)
	  ELSE
	     @ PROW()+1,00 SAY 'CAJERO: '+ALLTRIM(cCajero)+SPACE(06)+;
			       'FACTURA No. '+ALLTRIM(cNroFac)
	  ENDIF
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>DATOS DEL VEHICULO
       @ PROW()+1,00 SAY 'PLACA: '+cPlaca+SPACE(02)+;
			 'VEHICULO: '+cTipVeh


       @ PROW()+1,00 SAY 'ENTRADA: '+cFecha(dFecEnt,3)+SPACE(02)+;
			 'HORA: '+cHoraSys(cHorEnt)

       IF .NOT. EMPTY(dFecOut)
	  @ PROW()+1,00 SAY 'SALIDA : '+cFecha(dFecOut,3)+SPACE(02)+;
			    'HORA: '+cHoraSys(cHorOut)
	  @ PROW()+1,00 SAY 'AA:MM:DD '+SUBS(cTiempo,1,8)
	  @ PROW()+1,00 SAY 'HH:MM:SS '+SUBS(cTiempo,10,8)

	  IF PAR->nPorIvaPak == 0
	     @ PROW()+1,00 SAY 'TOTAL.$: '+ALLTRIM(TRANS(nVlrSer,"####,###,###"))
	  ELSE
	     @ PROW()+1,00 SAY 'TOTAL.$: '+;
			       ALLTRIM(TRANS(nVlrSer,"####,###,###"))
	     @ PROW()+1,00 SAY 'BASE.$: '+;
			       ALLTRIM(TRANS(nBasIva,"####,###,###"))+' '+;
			       'IVA.$: '+;
			       ALLTRIM(TRANS(nVlrIva,"####,###,###"))

	  ENDIF
       ENDIF
       IF !EMPTY(cTxtObs)
	  @ PROW()+1,00 SAY cTxtObs
       ENDIF

       IF !EMPTY(PAR->cRegDiaPak)
	  @ PROW()+1,00 SAY PAR->cRegDiaPak
       ENDIF

       IF !EMPTY(PAR->cMsgTxtPak)
	  @ PROW()+1,00 SAY PAR->cMsgTxtPak
       ENDIF

       FOR i := 1 TO PAR->nLinPrnPak
	   @ PROW()+1,00 SAY ''
       ENDFOR
     *ÀEspacios para el fin de la tira

       IF !EMPTY(PAR->cBrkPrnPak)
	  cChrPrn := ALLTRIM(PAR->cBrkPrnPak)
	  SendCodes(&cChrPrn)
       ENDIF
     *ÀCorte del papel

       IF !EMPTY(PAR->cOpeCajPak) .AND. !EMPTY(dFecOut)
	  cChrPrn := ALLTRIM(PAR->cOpeCajPak)
	  SendCodes(&cChrPrn)
	  @ PROW()+1,00 SAY ''
       ENDIF
     *ÀAbrir la caja

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN DATOS DEL VEHICULO

/*************************************************************************
* TITULO..: TIEMPO DE PARQUEO                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 01/2005 LUN A
       Colombia, Bucaramanga        INICIO: 06:00 PM   AGO 01/2005 LUN

OBJETIVOS:

1- Calculo del tiempo del parqueo.

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aTimePak(aTiempo,nMinDiv,nMinDes,nTipHor,lMinDes,lHayDes)

*>>>>DESCRIPCION DE PARAMETROS
/*     aTiempo                             // Tiempo Transcurrido
       nMinDiv			           // Minutos para dividir
       nMinDes                             // Minutod de Descuento
       nTipHor                             // Tipo de Horario
       lMinDes                             // .F. => NO cobra la primera Fracci¢n .T. => SI cobra la primera Fracci¢n
       lHayDes                             // .T. Hay Descuento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #DEFINE FDI 6                       // N£mero de Fraciones Diurnas
       #DEFINE FNO 7                       // N£mero de Fraciones Nocturnas

       LOCAL       i := 0                  // Contador
       LOCAL  aTimes := {}                 // Tiempo
       LOCAL nFraDiu := 0                  // N£mero de fraciones Diurnas
       LOCAL nFraNoc := 0                  // N£mero de fraciones Nocturnas

       LOCAL nTotSeg := 0                   // Total segundos transcurridos
       LOCAL nNroAno := 0                   // N£mero de A¤os
       LOCAL nNroMes := 0                   // N£mero de Meses
       LOCAL nNroDia := 0                   // N£mero de Dias
       LOCAL nNroHor := 0                   // N£mero de Horas
       LOCAL nMinDiu := 0                   // N£mero de Minutos Diurnos
       LOCAL nMinNoc := 0                   // N£mero de Minutos Nocturnos
       LOCAL nSegDiu := 0                   // N£mero de Segundos Diurnos
       LOCAL nSegNoc := 0                   // N£mero de Segundos Nocturnos

       LOCAL nHorDiu := 0                   // Horas Diurnas
       LOCAL nHorNoc := 0                   // Horas Nocturnas

       LOCAL nSegDes := 0                   // Segundos de Descuento

       LOCAL nBakMDI := 0                   // Backups Minutos Diurnos
       LOCAL nBakMNO := 0                   // Backups Minutos Nocturnos
       LOCAL nBakSeg := 0                   // Backups Segundos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL DESCUENTO
       nBakMDI := aTiempo[MDI]
       nBakMNO := aTiempo[MNO]
       nBakSeg := aTiempo[SEG]

       lHayDes := IF(lHayDes==NIL,.F.,lHayDes)
       IF lHayDes
	  aTiempo[MDI] := 0
	  aTiempo[MNO] := 0
	  aTiempo[SEG] := 0
       ENDIF
*>>>>FIN ANALISIS DEL DESCUENTO

*>>>>TIEMPO TRANSCURRIDO EN SEGUNDOS
      nTotSeg := aTiempo[ANO]*31622400
      nTotSeg += aTiempo[MES]*2592000
      nTotSeg += aTiempo[DIA]*86400
      nTotSeg += aTiempo[HOD]*3600
      nTotSeg += aTiempo[HON]*3600
      nTotSeg += aTiempo[MDI]*60
      nTotSeg += aTiempo[MNO]*60
      nTotSeg += aTiempo[SEG]
*>>>>FIN TIEMPO TRANSCURRIDO EN SEGUNDOS

*>>>>LECTURA DEL TIEMPO DE PARQUEO
       aTimes := {}
       AADD(aTimes,aTiempo[ANO])
       AADD(aTimes,aTiempo[MES])
       AADD(aTimes,aTiempo[DIA])
       AADD(aTimes,aTiempo[HOD])
       AADD(aTimes,aTiempo[HON])
*>>>>FIN LECTURA DEL TIEMPO DE PARQUEO

*>>>>CALCULO DE LAS FRACCIONES
       nFraDiu := INT(aTiempo[MDI]/nMinDiv)
       nMinDiu := aTiempo[MDI] - (nFraDiu*nMinDiv)
       nSegDiu := nMinDiu*60+aTiempo[SEG]

       nFraNoc := INT(aTiempo[MNO]/nMinDiv)
       nMinNoc := aTiempo[MNO] - (nFraNoc*nMinDiv)
       nSegNoc := nMinNoc*60+aTiempo[SEG]
*>>>>FIN CALCULO DE LAS FRACCIONES

*>>>>INCREMENTO DE LAS FRACCIONES
       nSegDes := PAR->nMinDesPak*60
       IF (nSegDiu+nSegNoc) > nSegDes .OR. (lMinDes .AND. nTotSeg < nSegDes)

	  DO CASE
	  CASE nTipHor==2 .OR. nTipHor==3 .OR. nTipHor==4   // Diurno
	       nFraDiu++

	  CASE nTipHor==1 .OR. nTipHor==5 .OR. nTipHor==6   // Nocturno
	       nFraNoc++
	  ENDCASE
       ENDIF
*>>>>FIN INCREMENTO DE LAS FRACCIONES

*>>>>ANALISIS DE DECISION
       AADD(aTimes,nFraDiu)
       IF aTimes[FDI]*nMinDiv == 60
	  aTimes[4] += 1  // HOD
	  aTimes[FDI] := 0
       ENDIF

       AADD(aTimes,nFraNoc)
       IF aTimes[FNO]*nMinDiv == 60
	  aTimes[5] += 1  // HON
	  aTimes[FNO] := 0
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CALCULO DE LOS DIAS
       IF aTimes[4] >= 12 .AND. aTimes[5] >= 12   // HOD y HON

	  nNroDia := INT((aTimes[4]+aTimes[5])/24)

	  nHorDiu := aTimes[4] - nNroDia*12
	  nHorNoc := aTimes[5] - nNroDia*12

	  aTimes[3] += nNroDia
	  aTimes[4] := nHorDiu
	  aTimes[5] := nHorNoc
       ENDIF
*>>>>FIN CALCULO DE LOS DIAS

*>>>>CALCULO DE LOS MESES
       IF aTimes[DIA] >= 30

	  nNroMes := INT(aTimes[DIA]/30)
	  nNroDia := aTimes[DIA] - nNroMes*30

	  aTimes[MES] += nNroMes
	  aTimes[DIA] := nNroDia
       ENDIF
*>>>>FIN CALCULO DE LOS MESES

*>>>>CALCULO DE LOS A¥OS
       IF aTimes[MES] >= 12

	  nNroAno := INT(aTimes[MES]/12)
	  nNroMes := aTimes[MES] - nNroAno*12

	  aTimes[ANO] += nNroAno
	  aTimes[MES] := nNroMes
       ENDIF
*>>>>FIN CALCULO DE LOS A¥OS

*>>>>ANALISIS DEL DESCUENTO
       IF lHayDes
	  aTiempo[MDI] := nBakMDI
	  aTiempo[MNO] := nBakMNO
	  aTiempo[SEG] := nBakSeg
       ENDIF
       RETURN aTimes
*>>>>FIN ANALISIS DEL DESCUENTO

/*************************************************************************
* TITULO ..: VALOR DEL SERVICIO POR HORAS POR FRACCION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 17/2005 DOM A
       Colombia, Bucaramanga        INICIO: 11:00 PM   ABR 17/2005 DOM

OBJETIVOS:

1- Calcula el valor del servicio del parqueadero

2- Retorna el valor del servicio

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrSerFra(aTiempo,cTipVeh,lTotHor)

*>>>>DESCRIPICON DE PARAMETROS
/*     aTiempo                              // Tiempo de Parqueo
       cTipVeh                              // Tipo de Vehiculo
       lTotHor                              // .F. => Cobra sumatoria horas diurnas y nocturnas .T. => Cobra por total de horas Ej: 13 horas */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNumero := 0                   // N£mero de unidades de Tiempo
       LOCAL nVlrSer := 0                   // Valor del Servicio

       LOCAL nNroAno := 0                   // N£mero de A¤os
       LOCAL nNroMes := 0                   // N£mero de Meses
       LOCAL nNroDia := 0                   // N£mero de D¡as
       LOCAL nHorDiu := 0                   // Horas Diurnas
       LOCAL nHorNoc := 0                   // Horas Nocturnas
       LOCAL nTotHor := 0                   // Total de Horas
       LOCAL nFraDiu := 0                   // Fraccion Diurnas
       LOCAL nFraNoc := 0                   // Fracci¢n Nocturnas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LIQUIDACION POR CATEGORIAS
       IF lValorCat()

	  nNroAno := aTiempo[1]
	  nNroMes := aTiempo[2]
	  nNroDia := aTiempo[3]
	  nHorDiu := aTiempo[4]
	  nHorNoc := aTiempo[5]
	  nFraDiu := aTiempo[6]
	  nFraNoc := aTiempo[7]

	  nVlrSer := nNroAno*CAT->nVlrAnoCat+;
		     nNroMes*CAT->nVlrMesCat+;
		     nNroDia*CAT->nVlrDiaCat+;
		     nHorDiu*CAT->nVlrHDiCat+;
		     nHorNoc*CAT->nVlrHNoCat+;
		     nFraDiu*CAT->nVlrFDiCat+;
		     nFraNoc*CAT->nVlrFNoCat

       ENDIF
*>>>>FIN LIQUIDACION POR CATEGORIAS

*>>>>LIQUIDACION POR TARIFAS
       IF lValorTar()

	  FOR i := 1 TO LEN(aTiempo)

**************LECTURA DEL TIEMPO
		nNumero := aTiempo[i]
		IF nNumero == 0
		   LOOP
		ENDIF
**************FIN LECTURA DEL TIEMPO

**************LOCALIZACION DE LA TARIFA
		SELECT TAR
		TAR->(DBGOTOP())
		LOCATE FOR TAR->nCodigoTar == nNumero .AND.;
			   TAR->cTipVehCat == cTipVeh
**************FIN LOCALIZACION DE LA TARIFA

**************LIQUIDACION DEL SERVICIO
		IF FOUND()

		   DO CASE
		   CASE i == 1  // A¤os

			nVlrSer += TAR->nVlrAnoTar

		   CASE i == 2  // Meses

			nVlrSer += TAR->nVlrMesTar

		   CASE i == 3  // Dias

			nVlrSer += TAR->nVlrDiaTar

		   CASE i == 4  // Horas Diurnas

			IF lTotHor
			   nTotHor += nNumero
			ELSE
			   nVlrSer += TAR->nVlrHDiTar
			ENDIF

		   CASE i == 5  // Horas Nocturnas

			IF lTotHor
			   nTotHor += nNumero
			ELSE
			   nVlrSer += TAR->nVlrHNoTar
			ENDIF

		   CASE i == 6 // Fracciones Diurnas

			nVlrSer += TAR->nVlrFDiTar

		   CASE i == 7 // Fraciones Nocturnas

			nVlrSer += TAR->nVlrFNoTar

		   ENDCASE

		ENDIF
**************FIN LIQUIDACION DEL SERVICIO

	  ENDFOR

       ENDIF
*>>>>FIN LIQUIDACION POR TARIFAS

*>>>>LIQUIDACION DEL TOTAL DE HORAS
       IF lTotHor .AND. lValorTar()

**********LOCALIZACION DE LA TARIFA
	    SELECT TAR
	    TAR->(DBGOTOP())
	    LOCATE FOR TAR->nCodigoTar == nTotHor .AND.;
		       TAR->cTipVehCat == cTipVeh
**********FIN LOCALIZACION DE LA TARIFA

**********LIQUIDACION DEL SERVICIO
	    IF FOUND()
	       nVlrSer += TAR->nVlrHorTar
	    ENDIF
**********FIN LIQUIDACION DEL SERVICIO

       ENDIF
       RETURN nVlrSer
*>>>>FIN LIQUIDACION DEL TOTAL DE HORAS

/*************************************************************************
* TITULO ..: VALOR DEL SERVICIO POR HORAS POR MINUTOS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2009 DOM A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 19/2009 DOM

OBJETIVOS:

1- Calcula el valor del servicio del parqueadero por minutos

2- Retorna el valor del servicio

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrSerMin(aTiempo,cTipVeh,lTotHor)

*>>>>DESCRIPICON DE PARAMETROS
/*     aTiempo                              // Tiempo de Parqueo
       cTipVeh                              // Tipo de Vehiculo
       lTotHor                              // .F. => Cobra sumatoria horas diurnas y nocturnas .T. => Cobra por total de horas Ej: 13 horas */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNumero := 0                   // N£mero de unidades de Tiempo
       LOCAL nVlrSer := 0                   // Valor del Servicio

       LOCAL nNroAno := 0                   // N£mero de A¤os
       LOCAL nNroMes := 0                   // N£mero de Meses
       LOCAL nNroDia := 0                   // N£mero de D¡as
       LOCAL nNroSeg := 0                   // N£mero de Segundos
       LOCAL nMinDiu := 0                   // M¡nutos Diurnos
       LOCAL nMinNoc := 0                   // M¡nutos Nocturnos
       LOCAL nHorDiu := 0                   // Horas Diurnas
       LOCAL nHorNoc := 0                   // Horas Nocturnas
       LOCAL nTotHor := 0                   // Total de Horas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LIQUIDACION POR CATEGORIAS
       IF lValorCat()

	  nNroAno := aTiempo[ANO]
	  nNroMes := aTiempo[MES]
	  nNroDia := aTiempo[DIA]
	  nHorDiu := aTiempo[HOD]
	  nHorNoc := aTiempo[HON]
	  nMinDiu := aTiempo[MDI]
	  nMinNoc := aTiempo[MNO]
	  nNroSeg := aTiempo[SEG]

	  nVlrSer := nNroAno*CAT->nVlrAnoCat+;
		     nNroMes*CAT->nVlrMesCat+;
		     nNroDia*CAT->nVlrDiaCat+;
		     nHorDiu*CAT->nVlrHDiCat+;
		     nHorNoc*CAT->nVlrHNoCat+;
		     nMinDiu*CAT->nVlrMDiCat+;
		     nMinNoc*CAT->nVlrMNoCat+;
		     nNroSeg*CAT->nVlrSegCat

       ENDIF
*>>>>FIN LIQUIDACION POR CATEGORIAS

*>>>>LIQUIDACION POR TARIFAS
       IF lValorTar()

	  FOR i := 1 TO LEN(aTiempo)

**************LECTURA DEL TIEMPO
		nNumero := aTiempo[i]
		IF nNumero == 0
		   LOOP
		ENDIF
**************FIN LECTURA DEL TIEMPO

**************LOCALIZACION DE LA TARIFA
		SELECT TAR
		TAR->(DBGOTOP())
		LOCATE FOR TAR->nCodigoTar == nNumero .AND.;
			   TAR->cTipVehCat == cTipVeh
**************FIN LOCALIZACION DE LA TARIFA

**************LIQUIDACION DEL SERVICIO
		IF FOUND()

		   DO CASE
		   CASE i == 1  // A¤os

			nVlrSer += TAR->nVlrAnoTar

		   CASE i == 2  // Meses

			nVlrSer += TAR->nVlrMesTar

		   CASE i == 3  // Dias

			nVlrSer += TAR->nVlrDiaTar

		   CASE i == 4  // Horas Diurnas

			IF lTotHor
			   nTotHor += nNumero
			ELSE
			   nVlrSer += TAR->nVlrHDiTar
			ENDIF

		   CASE i == 5  // Minutos Diurnos

			nVlrSer += TAR->nVlrMDiTar

		   CASE i == 6 // Horas Nocturnas

			IF lTotHor
			   nTotHor += nNumero
			ELSE
			   nVlrSer += TAR->nVlrHNoTar
			ENDIF

		   CASE i == 7 // Minutos Nocturnos

			nVlrSer += TAR->nVlrMNoTar

		   CASE i == 8 // Segundos

			nVlrSer += TAR->nVlrSegTar

		   ENDCASE

		ENDIF
**************FIN LIQUIDACION DEL SERVICIO

	  ENDFOR

       ENDIF
*>>>>FIN LIQUIDACION POR TARIFAS

*>>>>LIQUIDACION DEL TOTAL DE HORAS
       IF lTotHor .AND. lValorTar()

**********LOCALIZACION DE LA TARIFA
	    SELECT TAR
	    TAR->(DBGOTOP())
	    LOCATE FOR TAR->nCodigoTar == nTotHor .AND.;
		       TAR->cTipVehCat == cTipVeh
**********FIN LOCALIZACION DE LA TARIFA

**********LIQUIDACION DEL SERVICIO
	    IF FOUND()
	       nVlrSer += TAR->nVlrHorTar
	    ENDIF
**********FIN LIQUIDACION DEL SERVICIO

       ENDIF
       RETURN nVlrSer
*>>>>FIN LIQUIDACION DEL TOTAL DE HORAS

/*************************************************************************
* TITULO..: REDONDEO DEL VALOR                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 30/2009 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   JUN 30/2009 MAR

OBJETIVOS:

1- Permite redondear un valor

3- Retorna el valor redondeado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrRound(nValor,nNroDiv,nTipo)

*>>>>DESCRIPCION DE PARAMETROS
/*     nValor                               // Valor a redondear
       nNroDiv                              // Divisor
       nTipo                                // Tipo de Redondeo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrMod := 0                   // Valor del Modulo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL REDONDEO
       nVlrMod := MOD(nValor,nNroDiv)

       DO CASE
       CASE nNroDiv == 100

	    IF nVlrMod <= 50
	       nValor := nValor - nVlrMod
	    ELSE
	       nValor := (nValor - nVlrMod)+50
	    ENDIF

       CASE nNroDiv == 1000

	    IF nVlrMod <= 500
	       nValor := nValor - nVlrMod
	    ELSE
	       nValor := nValor+(1000 - nVlrMod)
	    ENDIF

       ENDCASE
       RETURN nValor
*>>>>FIN CALCULO DEL REDONDEO



