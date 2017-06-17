/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : FACTURACION
SUBMODULO...: OTRA FACTURACION - CONSIGNACION

**************************************************************************
* TITULO..: CONSIGNACION                                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 05/2007 LUN A
       Bucaramanga, Colombia        INICIO: 11:30 AM   FEB 05/2007 LUN

OBJETIVOS:

1- Permite imprimir recibos para realizar consignaciones por diferentes
   pagos.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_181(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nNroFac := 0                   // N£mero de la factura
       LOCAL nVlrTot := 0                   // Valor total a consignar
       LOCAL dFecOpo := CTOD('00/00/00')    // Fecha de la Consignaci¢n Opo
       LOCAL dFecExt := CTOD('00/00/00')    // Fecha de la Consignaci¢n Ext

       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL aConRec := {}                  // Conceptos del recibo

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aP1,aP2,aP3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+FileRec,'REC',;
			 PathUno+'\'+PathSis+'\'+fNtxRec,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCar,'SCA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lShared,nModCry})
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
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nOtrRecCaA == 0 .OR. CAA->nOtrRecCaA > 8
	    cError('EL RECIBO No.'+STR(CAA->nOtrRecCaA,2)+;
		   ' NO ESTA DISPONIBLE. POR FAVOR CAMBIELO')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS DE MOVIMIENTOS GRABADOS')

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

*>>>>VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO
       IF CAA->cCodigoBan == cSpaces('BAN','cCodigoBan')
	  cError('A CONTINUACION ESCOJA EL BANCO',;
		 'NO SE HA DEFINIDO EL BANCO DONDE SE DEBE PAGAR')
	  CambiaBan(lShared,nFilInf+1,nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO PARA EL PAGO

*>>>>LOCALIZACION DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',CAA->cCodigoBan)
	  CloseAll(aUseDbf)
	  cError('EL BANCO '+CAA->cCodigoBan+' NO EXISTE')
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL BANCO

*>>>>FILTRACION DEL ARCHIVO
       SELECT CMV
       SET FILTER TO CMV->lConsigCmv

       CMV->(DBGOTOP())
       IF CMV->(EOF())
	  SET FILTER TO
	  cError('NO EXISTEN CONCEPTOS MARCADOS PARA CONSIGNAR')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'consigna'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcRecCar,.F.,.F.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR INGRESE LOS DATOS DE LOS RECIBOS PARA '+;
				   'LAS CONSIGNACIONES',22,'°')
       aTamCol := {12,12,12,10,40}
       aTitulo := {'VALOR','F.OPO','F.EXT','REFERENCIA','CONCEPTO'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil++,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>RECIBOS DE CONSIGNACION
       DO WHILE .T.

**********VALOR DE LA CONSIGNACION
	    nVlrTot := 0
	    dFecOpo := DATE()
	    @ nNroFil,aNroCol[1] GET nVlrTot PICT '99999999'
	    READ
	    IF nVlrTot == 0
	       EXIT
	    ENDIF
**********FIN VALOR DE LA CONSIGNACION

**********FECHAS DE PLAZO
	    cSavLin := SAVESCREEN(22,00,22,79)
	    centrar('Digite las Fechas en el Formato: MM/DD/AAAA',22)

	    dFecOpo := DATE()
	    @ nNroFil,aNroCol[2] GET dFecOpo PICT '@!D';
				 VALID !EMPTY(dFecOpo)

	    dFecExt := dFecOpo
	    @ nNroFil,aNroCol[3] GET dFecExt PICT '@!D';
				 VALID !EMPTY(dFecExt)
	    READ
	    RESTSCREEN(22,00,22,79,cSavLin)
**********FIN FECHAS DE PLAZO


**********CONCEPTO DE LA CONSIGNACION
	    IF nSelCodCmv(nNroFil,aNroCol[4]) == 0
	       LOOP
	    ENDIF
	    @ nNroFil,aNroCol[5] SAY ALLTRIM(CMV->cNombreCmv)
**********FIN CONCEPTO DE LA CONSIGNACION

**********LECTURA DE LA REFERENCIA
	    cCodRef := SUBS(CMV->cCodRefTra,1,10)
	    IF EMPTY(cCodRef)

	       @ nNroFil,aNroCol[4] GET cCodRef PICT '9999999999';
				    VALID !EMPTY(cCodRef)
	       READ

	    ENDIF

	    IF !lPregunta('DESEA IMPRIMIR LA CONSIGNACION? Si No')
	       LOOP
	    ENDIF

	    cCodEmp := STR(SCO->nCodEmpCon,2)
	    lCorrecion(@cCodEmp,.T.)
**********FIN LECTURA DE LA REFERENCIA

**********VALOR DE LOS CONCEPTOS
	    aConRec := {}
	    AADD(aConRec,{ALLTRIM(CMV->cNombreCmv),;   // 1. CONCEPTO
			  '',;                         // 2. MORA
			  '',;                         // 3. VALOR MES
			  TRANS(nVlrTot,'9,999,999')}) // 4. TOTAL
**********FIN VALOR DE LOS CONCEPTOS

**********PARAMETROS DEL RECIBO
	    aP3 := {}

	    AADD(aP3,{'cCodEan',SCO->cCodEanCon})
	    AADD(aP3,{'cCodFac',''})

	    AADD(aP3,{'cCodIso',''})

	    AADD(aP3,{'cCodEst',''})
	    AADD(aP3,{'cCodGru',''})
	    AADD(aP3,{'cNomEst','CONSIGNACION'})
	    AADD(aP3,{'nMesIni',0})
	    AADD(aP3,{'nMesFin',0})

	    AADD(aP3,{'cRefRec',cCodRef})

	    AADD(aP3,{'cNomBan',BAN->cNombreBan})
	    AADD(aP3,{'cCtaBan',BAN->cNroCtaBan})
	    AADD(aP3,{'aConRec',aConRec})

	    AADD(aP3,{'dFecOpo',dFecOpo})
	    AADD(aP3,{'dFecExt',dFecExt})

	    AADD(aP3,{'nVlrOpo',nVlrTot})
	    AADD(aP3,{'nVlrExt',nVlrTot})

	    AADD(aP3,{'cTxtUno',ALLTRIM(CAA->cTxtUnoCaA)})
	    AADD(aP3,{'cTxtDos',ALLTRIM(CAA->cTxtDosCaA)})
**********FIN PARAMETROS DEL RECIBO


**********IMPRESION DE LA CONSIGNACION
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE CAA->nRecNroCaA == 8 .OR. CAA->nRecNroCaA == 9

		 nRecOtr08(aP1,aP2,aP3)
		*Recibo c¢digo de Barras la Kiosera. La Salle Formato


/*
		 nRecOtr02(lShared,cEmpPal,cNitEmp,cNomEmp,cNomUsr,cAnoUsr,;
			   @nNroFac,BAN->cNombreBan,BAN->cNroCtaBan,;
			   BAN->cLugarBan,dFecOpo,dFecExt,ALLTRIM(cCodRef),;
			   ALLTRIM(CMV->cNombreCmv),nVlrTot)
*/

	    ENDCASE
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DE LA CONSIGNACION

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR INGRESE LOS DATOS '+;
					     'DE LOS RECIBOS PARA LAS '+;
					     'CONSIGNACIONES',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECIBOS DE CONSIGNACION

