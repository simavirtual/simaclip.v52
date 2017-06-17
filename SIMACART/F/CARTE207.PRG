/*SISTEMA DE CARTERA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: CONCILIACION                             MODULO No. 208

**************************************************************************
* TITULO..: CONCILIACION DE LA CARTERA                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 02/99 MAR A
       Bucaramanga, Colombia	    INICIO: 12:50 PM   MAR 02/99 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir la carta con la cifras de la Conciliaci¢n de la
   Cartera.


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_207(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cFecha  := ''                  // Fecha de la orden.
       LOCAL cTxtRef := ''                  // Referencia

       LOCAL cNomRem := ''                  // Nombre del Remitente
       LOCAL cNomDes := ''                  // Nombre del Destinatario.

       LOCAL cDescri := ''                  // Descripci¢n de la Salida.
       LOCAL cMotivo := ''                  // Motivo de la Salida.
       LOCAL cDestin := ''                  // Destino
       LOCAL nCopias := 1                   // N£mero de Copias
       LOCAL nNroCop := 0                   // Copias impresas

       LOCAL nMesIni := 0                   // Mes inicial del pago
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna

       LOCAL nOtrAbo := 0                   // Otros Abonos
       LOCAL nVlrCon := 0                   // Valor Conceptos
       LOCAL nAntici := 0                   // Anticipos
       LOCAL nRecarg := 0                   // Recargos
       LOCAL nVlrBec := 0                   // Valor Becas
       LOCAL nVlrDes := 0                   // Valor Descuentos
       LOCAL nIntPag := 0                   // Intereses Pagados
       LOCAL nIntCob := 0                   // Intereses por Cobrar
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nVlrPag := 0                   // Valor del Pago
       LOCAL nVlrAbo := 0                   // Valor del Abono
       LOCAL nAboDes := 0                   // Abono Descuento
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

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
       aParams := aParams(aParam1,aParam2,aParam3)
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
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
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DEL SISTEMA.')

       CASE EMPTY(CAR->cSecretCar)
	    cError('NO SE HA ESPECIFICADO EL NOMBRE DEL RESPONSABLE DE LA CARTERA')

       CASE EMPTY(CAR->cCarSecCar)
	    cError('NO SE HA ESPECIFICADO EL CARGO DEL RESPONSABLE DE LA CARTERA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Conciliaci¢n de la Cartera',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>TOTAL CONCEPTOS
       nSdoAct := 0
       nVlrCon := 0
       SETCURSOR(1)                         // Activaci¢n del cursor
       nNroFil := nMarco(nFilPal+1,'DATOS PARA CONCILIAR LA CARTERA')

       @ nNroFil+00,01 SAY 'TOTAL CONCEPTOS          $' GET nVlrCon PICT '999999999999'
       READ

       nSdoAct := nVlrCon
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL CONCEPTOS

*>>>>TOTAL ANTICIPOS
       nAntici := 0
       @ nNroFil+01,01 SAY '+TOTAL ANTICIPOS         $' GET nAntici PICT '999999999999'
       READ
       nSdoAct += nAntici
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL ANTICIPOS

*>>>>TOTAL RECARGOS
       nRecarg := 0
       @ nNroFil+02,01 SAY '+TOTAL RECARGOS          $' GET nRecarg PICT '999999999999'
       READ
       nSdoAct += nRecarg
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL RECARGOS

*>>>>TOTAL BECAS
       nVlrBec := 0
       @ nNroFil+03,01 SAY '-TOTAL BECAS             $' GET nVlrBec PICT '999999999999'
       READ
       nSdoAct -= nVlrBec
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL BECAS

*>>>>TOTAL DESCUENTOS
       nVlrDes := 0
       @ nNroFil+04,01 SAY '-TOTAL DESCUENTOS        $' GET nVlrDes PICT '999999999999'
       READ
       nSdoAct -= nVlrDes
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL DESCUENTOS

*>>>>TOTAL INTERESES PAGADOS DEL MES
       nIntPag := 0
       @ nNroFil+05,01 SAY '+TOTAL INT PAGO MES      $' GET nIntPag PICT '999999999999'
       READ
       nSdoAct += nIntPag
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL INTERESES PAGADOS DEL MES

*>>>>TOTAL INTERESES POR COBRAR DEL MES
       nIntCob := 0
       @ nNroFil+06,01 SAY '+TOTAL INT x COBRAR      $' GET nIntCob PICT '999999999999'
       READ
       nSdoAct += nIntCob
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL INTERESES POR COBRAR DEL MES

*>>>>TOTAL DEUDA ANTERIOR
       nDeuAnt := 0
       @ nNroFil+07,01 SAY '+TOTAL DEUDA ANTERIOR    $' GET nDeuAnt PICT '999999999999'
       READ
       nSdoAct += nDeuAnt
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL DEUDA ANTERIOR

*>>>>TOTAL MORA ANTERIOR
       nMorAnt := 0
       @ nNroFil+08,01 SAY '+TOTAL MORA  ANTERIOR    $' GET nMorAnt PICT '999999999999'
       READ
       nSdoAct += nMorAnt
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL MORA ANTERIOR

*>>>>TOTAL PAGOS
       nVlrPag := 0
       @ nNroFil+09,01 SAY '-TOTAL PAGOS             $' GET nVlrPag PICT '999999999999'
       READ
       nSdoAct -= nVlrPag
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL PAGOS

*>>>>TOTAL ABONOS
       nVlrAbo := 0
       @ nNroFil+10,01 SAY '-TOTAL ABONOS DEL MES    $' GET nVlrAbo PICT '999999999999'
       READ
       nSdoAct -= nVlrAbo
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL ABONOS

*>>>>TOTAL ABONOS
       nAboDes := 0
       @ nNroFil+11,01 SAY '-TOTAL ABONOS DESCUENTOS $' GET nAboDes PICT '999999999999'
       READ
       nSdoAct -= nAboDes
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL ABONOS

*>>>>TOTAL OTROS ABONOS
       nOtrAbo := 0
       @ nNroFil+12,01 SAY '-ABONOS OTROS MESES      $' GET nOtrAbo PICT '999999999999'
       READ
       nSdoAct -= nOtrAbo
       @ nNroFil+00,43 SAY 'SALDO ACTUAL ='+TRANS(nSdoAct,'$999,999,999,999')
     *ÀCalculo del Saldo Actual
*>>>>FIN TOTAL OTROS ABONOS

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA IMPRIMIR EL INFORME? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>DETALLES DEL INFORME
       cFecha  := SPACE(50)
       cNomRem := SPACE(60)
       cNomDes := SPACE(60)
       nCopias := 1

       @ nNroFil+12,01 SAY 'FECHA :' GET cFecha  PICT '@S60'
       @ nNroFil+13,01 SAY 'DE    :' GET cNomRem PICT '@!S60'
       @ nNroFil+14,01 SAY 'PARA  :' GET cNomDes PICT '@!S60'
       @ nNroFil+15,01 SAY 'COPIAS:' GET nCopias PICT '99'
       READ
       nCopias := IF(EMPTY(nCopias),1,nCopias)
*>>>>FIN DETALLES DEL INFORME

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'conci'+cMes(nMesIni,3)
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
//       @ PROW(),00 SAY INICIALIZA
       SendCodes(PCL('Reset'))
//       SendCodes(PCL({'DraftOn','Elite','CondenOn'}))
       SendCodes(PCL({'DraftOn','Elite'}))
//       SendCodes(GRAPHI_ON+NEGRA_OF+CONDEN_OF+PROPOR_OF+PICA+DRAFT_ON)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LA ORDEN DE SALIDA
       nNroCop := 1
       DO WHILE nNroCop <= nCopias

**********IMPRESION DE LA ORDEN DE SALIDA
	    PrnInfCar(nMesIni,cAnoUsr,cFecha ,cNomRem,cNomDes,;
		      nVlrCon,nAntici,nRecarg,nVlrBec,nVlrDes,;
		      nIntPag,nIntCob,nDeuAnt,nMorAnt,nVlrPag,;
		      nVlrAbo,nAboDes,nOtrAbo,nSdoAct)
**********FIN IMPRESION DE LA ORDEN DE SALIDA

	  nNroCop++
	  EJECT

       ENDDO
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LA ORDEN DE SALIDA

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: ORDEN DE SALIDA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 03/99 MIE A
       Bucaramanga, Colombia	    INICIO: 10:00 AM   MAR 03/99 MIE

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnInfCar(nMesIni,cAnoUsr,cFecha ,cNomRem,cNomDes,;
		   nVlrCon,nAntici,nRecarg,nVlrBec,nVlrDes,;
		   nIntPag,nIntCob,nDeuAnt,nMorAnt,nVlrPag,;
		   nVlrAbo,nAboDes,nOtrAbo,nSdoAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cFecha                               // Fecha de la orden.
       cNomRem                              // Nombre del Remitente
       cNomDes                              // Nombre del Destinatario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #DEFINE MARIZQ_0   CHR(27)+'l'+CHR(0)
       #DEFINE MARIZQ_8   CHR(27)+'l'+CHR(8)
       #DEFINE MARDER_80  CHR(27)+'Q'+CHR(80)
       #DEFINE MARDER_75  CHR(27)+'Q'+CHR(75)
       #DEFINE JUSTIF_ON  CHR(27)+'a'+CHR(3)
       #DEFINE JUSTIF_OF  CHR(27)+'a'+CHR(0)

       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nVlrFac := 0                   // Total Facturaci¢n
       LOCAL nTotFac := 0                   // Gran total

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FECHA DE IMPRESION
//       SendCodes(MARIZQ_8+MARDER_75)
       @ PROW()+4,00 SAY cFecha
*>>>>FIN FECHA DE IMPRESION

*>>>>NOMBRE DEL REMITENTE
       @ PROW()+4,00 SAY PCL('NegraOn')+'DE  : '+PCL('NegraOf')
       @ PROW()+0,07 SAY cNomRem
*>>>>FIN NOMBRE DEL REMITENTE

*>>>>NOMBRE DEL DESTINATARIO
       @ PROW()+1,00 SAY PCL('NegraOn')+'PARA: '+PCL('NegraOf')
       @ PROW()+0,07 SAY cNomDes
*>>>>FIN NOMBRE DEL DESTINATARIO

*>>>>REFERENCIA
       @ PROW()+3,00 SAY PCL('NegraOn')+'REF.: '+PCL('NegraOf')
       @ PROW()+0,07 SAY 'CONCILIACION DE LA CARTERA.'+;
			 ' MES DE '+cMes(nMesIni)+;
			 ' DE '+cAnoUsr
*>>>>FIN REFERENCIA

*>>>>DATOS DE LA CONCILIACION
       SendCodes(PCL('CondenOn'))

       nVlrFac := nVlrCon+nAntici+nRecarg-nVlrBec-nVlrDes
       nTotFac := nVlrFac+nIntPag+nIntCob

       @ PROW()+2,00 SAY SPACE(40)+'RELACION DE INFORMES DE SOPORTE ANEXADOS:'
       @ PROW()+1,00 SAY ' TOTAL CONCEPTOS   '+TRANS(nVlrCon,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nVlrCon),;
				     'NO SE FACTURARON CONCEPTOS',;
				     'FACTURACION DEL MES')

       @ PROW()+1,00 SAY '+ANTICIPOS         '+TRANS(nAntici,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nAntici),;
				     'NO HUBO ANTICIPOS',;
				     'FACTURACION DEL MES')

       @ PROW()+1,00 SAY '+RECARGOS          '+TRANS(nRecarg,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nRecarg),;
				     'NO HUBO RECARGOS',;
				     'RELACION DE ABONOS,DESCUENTOS,RECARGOS')

       @ PROW()+1,00 SAY '-DESCUENTOS        '+TRANS(nVlrDes,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nVlrDes),;
				     'NO HUBO DESCUENTOS',;
				     'RELACION DE ABONOS,DESCUENTOS,RECARGOS')

       @ PROW()+1,00 SAY '-BECAS             '+TRANS(nVlrBec,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nVlrBec),;
				     'NO HUBO BECAS',;
				     'RELACION DE ESTUDIANTES BECADOS POR PENSION')

       @ PROW()+1,00 SAY SPACE(19)+REPL('=',16)
       @ PROW()+1,00 SAY '=FACTURACION       '+TRANS(nVlrFac,"$999,999,999,999")

       @ PROW()+1,00 SAY '+INT PAGOS MES     '+TRANS(nIntPag,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nIntPag),;
				     'TODOS PAGARON OPORTUNAMENTE',;
				     'FACTURACION DEL MES')

       @ PROW()+1,00 SAY '+INT x COBRAR MES  '+TRANS(nIntCob,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nIntCob),;
				     'NO HUBO INTERESES POR COBRAR DEL MES',;
				     'FACTURACION DEL MES')
       @ PROW()+1,00 SAY SPACE(19)+REPL('=',16)
       @ PROW()+1,00 SAY '=GRAN TOTAL        '+TRANS(nTotFac,"$999,999,999,999")

       @ PROW()+1,00 SAY '+DEUDA ANTERIOR    '+TRANS(nDeuAnt,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nDeuAnt),;
				     'NO SE PRESENTO DEUDA ANTERIOR',;
				     'FACTURACION DEL MES. MES ANTERIOR')

       @ PROW()+1,00 SAY '+MORA ANTERIOR     '+TRANS(nMorAnt,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nMorAnt),;
				     'NO SE PRESENTO MORA ANTERIOR',;
				     'FACTURACION DEL MES. MES ANTERIOR')

       @ PROW()+1,00 SAY '-TOTAL PAGOS       '+TRANS(nVlrPag,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nVlrPag),;
				     'NADIE PAGO',;
				     'PAGOS DEL MES')

       @ PROW()+1,00 SAY '-ABONOS DEL MES    '+TRANS(nVlrAbo,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nVlrAbo),;
				     'NO HUBO ABONOS',;
				     'RELACION DE ABONOS,DESCUENTOS,RECARGOS')

       @ PROW()+1,00 SAY '-ABONOS DESCUENTOS '+TRANS(nAboDes,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nAboDes),;
				     'NO HUBO ABONOS',;
				     'RELACION DE ABONOS,DESCUENTOS,RECARGOS')

       @ PROW()+1,00 SAY '-ABONOS OTROS MESES'+TRANS(nOtrAbo,"$999,999,999,999")+;
			 SPACE(01)+IF(EMPTY(nOtrAbo),;
			 ' => NO HUBO ABONOS DE OTROS MESES','')

       @ PROW()+1,00 SAY SPACE(19)+REPL('=',16)
       @ PROW()+1,00 SAY '=SALDO ACTUAL      '+TRANS(nSdoAct,"$999,999,999,999")+;
			 ' => '+SPACE(01)+IF(EMPTY(nSdoAct),;
				     'TODOS PAGARON',;
				     'ESTUDIANTES MOROSOS')
*>>>>FIN DATOS DE LA CONCILIACION

*>>>>RESUMEN DE INFORMES ANEXADOS
       @ PROW()+2,00 SAY PCL('NegraOn')+'RESUMEN DE INFORMES ANEXADOS:'+PCL('NegraOf')

       @ PROW()+2,00 SAY PCL('JFull')+;
			 '- FACTURACION DEL MES. Con soporte en el informe '+;
			 'RELACION PAGOS FACTURADOS de cada grupo, que a su '+;
			 'vez esta soportado por cada recibo'
       @ PROW()+1,00 SAY SPACE(02)+'de pago y de los informes de los pagos reportados por el '+;
			 'Banco o Coorporaci¢n.'

       @ PROW()+2,00 SAY '- RELACION ABONOS,DESCUENTOS Y RECARGOS. '+;
			 'Los Abonos estan soportados por cada recibo y '+;
			 'los Descuentos y Recargos con los formatos'
       @ PROW()+1,00 SAY SPACE(02)+'de autorizaci¢n'

       @ PROW()+2,00 SAY '- RELACION DE ESTUDIANTES BECADOS. '+;
			 'Soportados con sus respectivas autorizaciones.'

       @ PROW()+2,00 SAY '- FACTURACION DEL MES. MES ANTERIOR. '+;
			 'Como soporte de la Deuda e Intereses pendientes '+;
			 'del mes anterior. '

       @ PROW()+2,00 SAY '- PAGOS DEL MES. Con soporte en el informe '+;
			 'RELACION PAGOS FACTURADOS de cada grupo.'

       @ PROW()+2,00 SAY '- ESTUDIANTES MOROSOS. Con soporte en el informe '+;
			 'de RELACION PAGOS FACTURADOS de cada grupo. '

       @ PROW()+2,00 SAY 'NOTA: Los informes anexados todos son de fecha '+;
			 cFecha(DATE())+'.'

//       SendCodes(PCL('CondenOf'))
       SendCodes(PCL({'DraftOn','Elite'}))
*>>>>RESUMEN DE INFORMES ANEXADOS

*>>>>PERSONAS QUE AUTORIZAN
       @ PROW()+3,00 SAY 'Atentamente,'
       @ PROW()+4,00 SAY CAR->cSecretCar
       @ PROW()+1,00 SAY CAR->cCarSecCar
*       @ PROW()+1,00 SAY JUSTIF_OF+MARIZQ_0+MARDER_80
       RETURN NIL
*>>>>FIN PERSONAS QUE AUTORIZAN