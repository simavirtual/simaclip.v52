/*************************************************************************
* TITULO ..: CANCELACION DE LOS RECIBOS PAGADOS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/95 JUE A
       Bucaramanga, Colombia        INICIO: 02:35 PM   JUN 15/95 JUE

OBJETIVOS:

1- Lee el archivo transferido del modem y actualiza el saldo de solo los
   recibos que aparecen pagados.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra011(aP1,aP2,aP3,;
		   cNroMes,oBrowse,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cNroDia                              // N£mero del D¡a */
*>>>>FIN PARAMETROS DE LA FUNCION

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
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna
       LOCAL nTotReg := 0                   // Total Registros
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL nCodPag := 0                   // C¢digo del Pago.
       LOCAL nLenRef := 0                   // Longitud de la Referencia
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables temporales de Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DOCUMENTACION DE VARIABLES
/*     nCodPag. C¢digo del pago:
       0 => C¢digo de pago a no procesar
       1 => Recibo de matr¡culas
       2 => Recibo de servicios educativos */
*>>>>FIN DOCUMENTACION DE VARIABLES

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF EMPTY(cNroDia)
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ELSE
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
       ENDCASE
       nTotReg := TRA->(RECCOUNT())
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE LOS ENCABEZADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(nFilPal+1)
       cCabeza := cRegPrint({'CODIGO',;
			     'NOMBRE',;
			     'SALDO ACTUAL',;
			     'VALOR A PAGAR ',;
			     'TOTAL PAGADO  ',;
			     'FORMA '},;
			    {06,18,12,12,14,06},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>SELECION DEL PATH
       IF .NOT. EMPTY(ANO->cAnoAluAno)
	  cAnoUsr := ANO->cAnoAluAno
	  cPatSis := cAnoUsr+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
*>>>>FIN SELECION DEL PATH

*>>>>CANCELACION DE LOS RECIBOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

	  nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
	  nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

**********IMPRESION DE LA LINEA DE ESTADO
	    nNroReg++
	    LineaEstado('REFERENCIA: '+TRA->cCodigoEst+;
			STR(nMesIniTtr,2)+;
			STR(nMesFinTtr,2)+;
			'ºREGISTRO: '+STR(nNroReg,5)+'/'+;
			  STR(nTotReg,5),cNomSis)
**********IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE LOS PAGOS A PROCESAR
	    nCodPag := 0

	    cCodRef := SUBS(TRA->cCodRefTra+;
			    SPACE(BAN->nLenRefBan),1,BAN->nLenRefBan)

	    DO CASE
	    CASE LEN(cCodRef) == BAN->nLenRefBan .AND.;
		 nMesIniTtr == 13

		 nCodPag := 1  // Pago de Matricula

	    CASE LEN(cCodRef) == BAN->nLenRefBan .AND.;
		 (nMesIniTtr >= 1 .AND. nMesIniTtr <= 12) .AND.;
		 (nMesFinTtr >= 1 .AND. nMesFinTtr <= 12)

		 nCodPag := 2  // Pago de Servicios Educativos

	    CASE LEN(cCodRef) == BAN->nLenRefBan .AND.;
		 nMesIniTtr == 14 .AND.;
		 nMesFinTtr >= 1  .AND.;
		 nMesFinTtr <= 12
		 ObservTra(lShared,'ABONO')

	    OTHERWISE

*----------------LOCALIZACION DE CONSIGNACIONES POR OTROS CONCEPTOS
		   SELECT CMV
		   CMV->(DBGOTOP())
		   LOCATE FOR ALLTRIM(SUBS(CMV->cCodRefTra,1,;
			      BAN->nLenRefBan)) == ALLTRIM(cCodRef)
		   IF FOUND()
		      ObservTra(lShared,LOWER(CMV->cNombreCmv))
		   ELSE
		      ObservTra(lShared,'?')
		   ENDIF
*----------------LOCALIZACION DE CONSIGNACIONES POR OTROS CONCEPTOS

/*

*----------------GRABACION DEL CONCEPTO DEL MOVIMIENTO
		   IF TRA->nCodigoCmv == 0
		      IF TRA->(lRegLock(lShared,.F.))

			 REPL TRA->nCodigoCmv WITH nCodigoCmv(MONTH(TRA->dFechaTra),;
							      cCodRef,;
							      BAN->nLenRefBan)
			 TRA->(DBCOMMIT())
		      ELSE
			 cError('NO SE GRABA EL REGISTRO')
		      ENDIF
		      IF lShared
			 TRA->(DBUNLOCK())
		      ENDIF
		   ENDIF
*----------------FIN GRABACION DEL CONCEPTO DEL MOVIMIENTO

*/

	    ENDCASE
	    SELECT TRA
	    IF nCodPag == 0
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE LOS PAGOS A PROCESAR



**********PROCESAMIENTO DE LOS CODIGOS DE PAGO
	    DO CASE
	    CASE nCodPag == 1  // Matr¡cula
		 CodPag01(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,;
			  cMaeAct,cNroMes,oBrowse,;
			  xPrm(aP1,'cModem'),cSavPan,;
			  @nNroFil,aNroCol)

	    CASE nCodPag == 2  // Recibos
	    ENDCASE
**********FIN PROCESAMIENTO DE LOS CODIGOS DE PAGO

**********CONTROL DE LA FILA DE VISUALIZACION
	    IF nNroFil > 20

*--------------VISUALIZACION DEL ULTIMO CLIENTE
		 nNroFil := nMarco(nFilPal+1)
		 @ nNroFil-2,01 SAY cCabeza
		 nNroFil++
*--------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	    ENDIF
**********FIN CONTROL DE LA FILA DE VISUALIZACION

	  SELECT TRA
	  TRA->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN CANCELACION DE LOS RECIBOS

/*************************************************************************
* TITULO ..: CANCELACION DE LOS RECIBOS DE MATRICULA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2000 MAR A
       Colombia, Bucaramanga        INICIO: 03:50 PM   NOV 28/2000 MAR

OBJETIVOS:

1- Cancela los recibos de pago de la matr¡cula

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CodPag01(lShared,nModCry,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cNroMes,oBrowse,cModem,cSavPan,nNroFil,aNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cSavPan                              // Salvar Pantalla
       nNroFil                              // N£mero de la Fila
       aNroCol                              // Numeros de Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL       i := 0                   // Contador
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL aRegAct := {}                  // Registro Actual
       LOCAL nMesFin := 0                   // Mes Final de la Matr¡cula
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL nSdoActTcl := 0                // Saldo del cliente
       LOCAL nSdoMorTcl := 0                // Saldo de la mora
       LOCAL cEstadoTpa := ''               // Forma de pago

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION O BUSQUEDA DEL ESTUDIANTE
       cMaeAct := 'ADM'
       IF !lLocCodigo('cCodigoEst','ADM',TRA->cCodigoEst)
	  IF !lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	     RETURN NIL
	  ENDIF
       ENDIF
       ObservTra(lShared,'MATRICULA')
       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
		     RTRIM(&cMaeAct->cNombreEst)
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
*>>>>FIN LOCALIZACION O BUSQUEDA DEL ESTUDIANTE

*>>>>LOCALIZACION DEL PAGO
       nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
       nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

       nMesFin := nMesFinTtr
       SELECT PMT
       GO TOP
       LOCATE FOR PMT->cCodigoEst == TRA->cCodigoEst .AND.;
		  PMT->nMesIniPag == 13              .AND.;
		  PMT->nMesFinPag == nMesFin         .AND.;
		  PMT->cMatricPag == '1'

       IF .NOT. FOUND()

	  ObservTra(lShared,'No se le genero recibo de MATRICULA')

	  cError('NO SE LE GENERO RECIBO DE MATRICULA A '+cNombreTes+;
		 'CODIGO: '+TRA->cCodigoEst)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO

/*
*>>>>LOCALIZACION DEL PAGO
       IF !lSekCodigo(TRA->cCodigoEst+'1','PMT')

	  ObservTra(lShared,'NO SE LE GENERO RECIBO DE MATRICULA')

	  cError('NO SE LE GENERO RECIBO DE MATRICULA A '+cNombreTes+;
		 'CODIGO: '+TRA->cCodigoEst)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL PAGO
*/

*>>>>ANALISIS DEL PAGO
       nVlrTra := 0
       aRegAct := {}
       DO WHILE PMT->cCodigoEst == TRA->cCodigoEst .AND.;
		nMesIniTtr == 13 .AND. nMesFinTtr == nMesFin

	  nVlrTra += TRA->nValorTra
	  AADD(aRegAct,TRA->(RECNO()))
	  TRA->(DBSKIP())

       ENDDO
       IF EMPTY(aRegAct)
	  cError('EN EL VECTOR DE LOS PAGOS')
	  IF !lPregunta('DESEA CONTINUAR? No Si')

	     RETURN NIL
	  ENDIF
       ENDIF
       SELECT TRA
       GO aRegAct[1]
*>>>>FIN ANALISIS DEL PAGO

*>>>>CALCULO DE LOS INTERESES
       IF PMT->lIntPenPag
	  nVlrInt := ROUND((ABS(PMT->nVlrMesPag)*PMT->nIntmorPag)/100,0)
       ELSE
	  nVlrInt := PMT->nVlrMorPag
       ENDIF
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DEL PAGO DEL RECIBO
       nForPag := 3
       IF TRA->dFechaTra > PMT->dPagOpoPag
	  IF nVlrTra == PMT->nVlrPagPag+nVlrInt
	     nForPag := 2
	  ENDIF
       ELSE
	  IF nVlrTra == PMT->nVlrPagPag
	     nForPag := 1
	  ENDIF
       ENDIF
      *1<PAGO OPO> 2<PAG EXT> 3<NO PAGO>
*>>>>FIN ANALISIS DEL PAGO DEL RECIBO

*>>>>LOCALIZACION DEL TIPO DE MOVIMIENTO
       IF !lLocCodigo('cCodigoTra','TMV',TRA->cCodigoTra)

	  ObservTra(lShared,'No Existe la Transaci¢n '+TMV->cCodigoTra)
	  cError('NO EXISTE LA TRANSACION '+TMV->cCodigoTra)

	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL TIPO DE MOVIMIENTO

*>>>>VALIDACION FINAL
       lHayErr := .T.
       DO CASE
       CASE nForPag # 3 .AND. !TMV->lSumarTra

	    ObservTra(lShared,'* '+ALLTRIM(TMV->cNombreTmv))
	    cError(ALLTRIM(TMV->cNombreTmv))

       CASE PMT->nVlrpagPag == 0
	    ObservTra(lShared,'No Tuvo que Cancelar Ning£n Valor')

       CASE nForPag == 3
	    IF EMPTY(TRA->nValidaTra)
	       ObservTra(lShared,'* NO le Coincide el Valor Pagado')
	       cError('NO LE COINCIDE EL VALOR PAGADO')
	    ENDIF
       OTHERWISE
	   lHayErr := .F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION FINAL

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE nForPag       == 1
	     cEstadoTpa := 'PAGO OPO'
	     cForPag      := 'P'

       CASE nForPag       == 2
	     cEstadoTpa := 'PAGO EXT'
	     cForPag      := 'A'
       ENDCASE
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

*>>>>GRABACION DE LA FORMA DE PAGO
       SELECT PMT
       IF PMT->(lRegLock(lSiRed,.F.))
	  REPL PMT->dFecPagPag WITH TRA->dFechaTra
	  REPL PMT->cEstadoPag WITH cForPag
	  REPL PMT->cNomUsrPag WITH cModem
	  REPL PMT->dFecUsrPag WITH DATE()
	  REPL PMT->cHorUsrPag WITH TIME()
       ELSE
	  cError('NO SE GRABA LA FORMA DE PAGO')
       ENDIF
*>>>>FIN GRABACION DE LA FORMA DE PAGO

*>>>>GRABACION DE LA VALIDACION DEL REGISTRO
       SELECT TRA
       FOR i := 1 TO LEN(aRegAct)
	   GO aRegAct[i]
	   IF TRA->(lRegLock(lShared,.F.))
	      IF TRA->nValidaTra < 100
		 REPL TRA->nValidaTra WITH ++TRA->nValidaTra
	      ENDIF
	   ELSE
	      cError('NO SE GRABA LA FORMA DE PAGO')
	   ENDIF
       ENDFOR
       GO aRegAct[1]
      *Registro Actual
*>>>>FIN GRABACION DE LA VALIDACION DEL REGISTRO

*>>>>IMPRESION DE LOS DETALLES DEL PAGO
       cNombreTes := SUBS(cNombreTes+SPACE(40),1,18)
       @ nNroFil,aNroCol[1] SAY PMT->cCodigoEst
       @ nNroFil,aNroCol[2] SAY cNombreTes
       @ nNroFil,aNroCol[3] SAY 'MATRICULA'
       @ nNroFil,aNroCol[4] SAY PMT->nVlrPagPag+;
			    IF(cForPag == 'A',nVlrInt,0) PICT "$###,###.99"
       @ nNroFil,aNroCol[5] SAY nVlrTra                  PICT "$###,###.99"
       SET COLOR TO I
       @ nNroFil,aNroCol[6] SAY cEstadoTpa
       SET COLOR TO
       nNroFil++
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DETALLES DEL PAGO
