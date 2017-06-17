/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO PAGOS

REQUERIMIENTOS:

- Compilar: clipper FuncsPag /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Pagos

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1)- Crea la estructura del archivo Pagos

2)- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPag(lShared,nModCry,PathPag,FilePag,lIntUno,fNtxPag,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathPag				    // Path del Archivo
       FilePag				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxPag				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfPag := {{"cCodigoEst","Character",06,0},; // C¢digo del Estudiante
			 {"nNroFacCaA","Numeric"  ,12,0},; // N£mero Consecutivo de la Factura
			 {"cCodigoBan","Character",02,0},; // C¢digo del Banco
			 {"lIntPenPag","Logical"  ,01,0},; // .T. Utilizar interes por mora y no valor de recargo para lo no pagos o pagos extemporaneos
			 {"nIntMorPag","Numeric"  ,05,2},; // Interes por Mora para pago extemporaneo
			 {"nVlrMorPag","Numeric"  ,12,2},; // Valor de la mora para pago extemporaneo
			 {"nIntDeuPag","Numeric"  ,05,2},; // Interes por Mora para el no pago
			 {"nVlrDeuPag","Numeric"  ,12,2},; // Valor de la mora para el no pago
			 {"nMesIniPag","Numeric"  ,02,0},; // Mes Inicial del Pago
			 {"nMesFinPag","Numeric"  ,02,0},; // Mes Final del Pago
			 {"nMesAmnPag","Numeric"  ,02,0},; // Mes de Amnist¡a
			 {"cAtrasoPag","Character",24,0},; // Meses de Atraso
			 {"nSdoAntPag","Numeric"  ,12,2},; // Saldo Anterior
			 {"nMorAntPag","Numeric"  ,12,2},; // Valor Mora Anterior
			 {"cConSdoPag","Character",16,0},; // Conceptos en Mora
			 {"nSdoAnoPag","Numeric"  ,12,2},; // Saldo del a¤o Anterior
			 {"nMorAnoPag","Numeric"  ,12,2},; // Valor Mora del a¤o Anterior
			 {"nSdoExtPag","Numeric"  ,12,2},; // Saldo Anterior sin abonos despu‚s de fecha extemporanea.
			 {"nSdAbonPag","Numeric"  ,12,2},; // Saldo Anterior sin abonos
			 {"nMoAbonPag","Numeric"  ,12,2},; // Valor Mora Anterior sin abonos
			 {"nSdAanoPag","Numeric"  ,12,2},; // Saldo Anterior sin abonos deuda a¤o anterior
			 {"nMoAanoPag","Numeric"  ,12,2},; // Valor Mora Anterior sin abonos a¤o anterior
			 {"nVlrCo1Pag","Numeric"  ,12,2},; // Valor del Concepto No. 1
			 {"nVlrCo2Pag","Numeric"  ,12,2},; // Valor del Concepto No. 2
			 {"nVlrCo3Pag","Numeric"  ,12,2},; // Valor del Concepto No. 3
			 {"nVlrCo4Pag","Numeric"  ,12,2},; // Valor del Concepto No. 4
			 {"nVlrCo5Pag","Numeric"  ,12,2},; // Valor del Concepto No. 5
			 {"nVlrCo6Pag","Numeric"  ,12,2},; // Valor del Concepto No. 6
			 {"nVlrCo7Pag","Numeric"  ,12,2},; // Valor del Concepto No. 7
			 {"nVlrCo8Pag","Numeric"  ,12,2},; // Valor del Concepto No. 8
			 {"nVl1Co1Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 1
			 {"nVl1Co2Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 2
			 {"nVl1Co3Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 3
			 {"nVl1Co4Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 4
			 {"nVl1Co5Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 5
			 {"nVl1Co6Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 6
			 {"nVl1Co7Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 7
			 {"nVl1Co8Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 8
			 {"nVl2Co1Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 1
			 {"nVl2Co2Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 2
			 {"nVl2Co3Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 3
			 {"nVl2Co4Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 4
			 {"nVl2Co5Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 5
			 {"nVl2Co6Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 6
			 {"nVl2Co7Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 7
			 {"nVl2Co8Pag","Numeric"  ,12,2},; // Valor1 del Concepto No. 8
			 {"cIniFinPag","Character",32,0},; // Mes Inicial y final de cada concepto
			 {"nVlrMesPag","Numeric"  ,12,2},; // Valor del Mes
			 {"nVlrPagPag","Numeric"  ,12,2},; // Valor a pagar o pagado
			 {"nSdoFavPag","Numeric"  ,12,2},; // Saldo a Favor.
			 {"nFavPagPag","Numeric"  ,12,2},; // Saldo a Favor pagado.
			 {"nFavDesPag","Numeric"  ,12,2},; // Saldo a Favor Descontado
			 {"nFavAplPag","Numeric"  ,12,2},; // Saldo a Favor aplicado.
			 {"cCodigoFpg","Character",02,0},; // Forma de Forma de Pago. Ej: Por Banco,Por Caja,Tarjeta Debito,Tarjeta Cr‚dito.
			 {"cNroFpgPag","Character",20,0},; // N£mero del Documento de la forma de pago.
			 {"lConcepPag","Logical"  ,01,0},; // .T. Deudor sin conceptos
			 {"cConcepPag","Character",16,0},; // Conceptos del Pago
			 {"lHayBecPag","Logical"  ,01,0},; // .T. Pago con Beca
			 {"nPorBecPag","Numeric"  ,03,0},; // Porcentaje de la Beca
			 {"nVlrBecPag","Numeric"  ,12,2},; // Valor de la Beca
			 {"nVlrDesPag","Numeric"  ,12,2},; // Valor descuento individual
			 {"nPagParPag","Numeric"  ,12,2},; // Valor del pago parcial.
			 {"nVlrRecPag","Numeric"  ,12,2},; // Valor recargo individual
			 {"nDesGenPag","Numeric"  ,12,2},; // Valor descuento general
			 {"nRecGenPag","Numeric"  ,12,2},; // Valor recargo general
			 {"nAbonosPag","Numeric"  ,12,2},; // Total de Abonos
			 {"nAnticiPag","Numeric"  ,12,2},; // Anticipos al mes
			 {"cConGenPag","Character",02,0},; // Concepto del descuento o recargo general
			 {"dFecFacPag","Date"     ,08,0},; // Fecha de Facturaci¢n
			 {"dPagOpoPag","Date"     ,08,0},; // Fecha pago oportuno
			 {"dPagExtPag","Date"     ,08,0},; // Fecha pago extemporaneo
			 {"dFecPagPag","Date"     ,08,0},; // Fecha de pago
			 {"cEstadoPag","Character",01,0},; // Estado de pago o forma de pago
			 {"cMaiPagEst","Character",40,0},; // *E-MAIL del pago
			 {"dFecRepMor","Date"     ,08,0},; // Fecha del Reporte
			 {"nNomFacEst","Numeric"  ,01,0},; // C¢digo del Nombre de la Factura 0=>Padre 1=>Padre 2=>Madre 3=>Acudiente
			 {"nNomRepCaA","Numeric"  ,01,0},; // Nombre a Reportar. 0=>No Reportar 1=>Padre,Madre o Acudiente, 2=>Fiador Uno 3=>Fiador Dos
			 {"dFecRetMor","Date"     ,08,0},; // Fecha de Retiro del Reporte
			 {"cNovRepPag","Character",02,0},; // Novedad del Reporte. 01 Al Dia, 05 Pago Total, etc.
			 {"dFecRepPag","Date"     ,08,0},; // Fecha del Reporte
			 {"cNovAntPag","Character",02,0},; // Novedad del Reporte Anterior. 01 Al Dia, 05 Pago Total, etc.
			 {"dRepAntPag","Date"     ,08,0},; // Fecha del Reporte Anterior
			 {"cNomUsrPag","Character",10,0},; // Nombre del Usuario
			 {"dFecUsrPag","Date"     ,08,0},; // Fecha del Usuario
			 {"cHorUsrPag","Character",10,0}}  // Hora del Usuario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfPag
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathPag) == 0
	    DBCREATE(FilePag,aDbfPag,"DBFNTX")
	    Proteger(FilePag,nModCry)

       CASE DIRCHANGE(PathPag) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathPag)

       CASE DIRCHANGE(PathPag) == -5
	    cError('NO TIENE DERECHOS EN: '+PathPag)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1)- Recupera la estructura del archivo de Pagos

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPag(lShared,nModCry,PathPag,FilePag,lIntUno,fNtxPag)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathPag			      // Path del Archivo
       FilePag			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxPag			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathPag+'\'+FilePag,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE PAGOS")
       Termometro(100)
       CreaDbfPag(lShared,nModCry,PathPag,FilePag,lIntUno,fNtxPag)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 01/2003 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   ABR 01/2003 LUN

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrPag(lShared,nModCry,PathArc,fArchvo,cMsgErr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       cMsgErr                              // Mensaje de Error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       LOCAL FileBak := ''                  // Archivo Backups
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'PAG',NIL,lShared,nModCry)
	  CloseDbf('PAG',PathArc+'\'+fArchvo,nModCry)
	  cMsgErr := 'Error. Abriendo el Archivo de Pagos'
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := PAG->(DBSTRUCT())
       CloseDbf('PAG',PathArc+'\'+fArchvo,nModCry)
       CreaDbfPag(lShared,nModCry,PathArc,fArchvo,NIL,NIL,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
	  cMsgErr := 'La Estructura ESTA Actualizada'
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO BACKUPS
       IF lCambio
	  PathAct := cPathAct()
	  DO CASE
	  CASE DIRCHANGE (PathArc+'\BACKUPS') == 0
	       DIRCHANGE(PathAct)

	  CASE DIRCHANGE (PathArc+'\BACKUPS') == -5
	       cError("NO HAY DERECHOS EN EL DIRECTORIO LOGROS")
	       QUIT

	  CASE DIRCHANGE(PathArc+'\BACKUPS') == -3
	       DIRMAKE(PathArc+'\BACKUPS')
	  ENDCASE
	  DIRCHANGE(PathAct)

	  FileBak := FileExtTmp(PathArc+'\BACKUPS\',fArchvo,.F.)
	  FILECOPY(PathArc+'\'+fArchvo,PathArc+'\BACKUPS\'+FileBak)
       ENDIF
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO BACKUPS

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  nNroErr := 0
	  cMsgErr := 'Estructura SI Actualizada'
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfPag(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	     cMsgErr := 'NO se Actualizo la Estructura'
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION......: VALIDACION DE LA FACTURACION               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de pagos en el registro del estudiante

2- Retorna .T. si se puede facturar el recibo


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFacturado(cCodEst,nMesIni,nRegPag,cNomEst,nUltRec,lHayCoE)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del estudiante
       nMesIni                              // Mes inicial del pago
       nRegPag                              // @Registro del Pago = 0 -> No ha pagado
       cNomEst                              // Nombre del Estudiante.
       nUltRec                              // Ultimo Recibo Facturado
       lHayCoe                              // .T. Hay Conceptos Individuales */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lRecibo := .F.                 // .T. = Facturar
       LOCAL cMesIni := ''                  // Mes inicial del pago
       LOCAL cMsgTxt := ''                  // Texto variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION CON RESPECTO AL ULTIMO PAGO
       SELECT PAG
       SET FILTER TO PAG->cCodigoEst == cCodEst
       GO BOTTOM

       lHayCoE := IF(lHayCoE==NIL,.F.,lHayCoE)
       cMesIni := cMes(nMesIni)
       DO CASE
       CASE PAG->cEstadoPag == 'P' .AND. !EMPTY(PAG->dFecPagPag) .AND.;
	    nMesIni == PAG->nMesiniPag

	    cMsgTxt:= 'El recibo de ' +cMesIni+' figura con fecha de '+;
		      'pago del '+cFecha(PAG->dFecPagPag)

       CASE (PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag == 'A') .AND.;
	     nMesIni == PAG->nMesiniPag

	    cMsgTxt:= ' El recibo de ' +cMesIni+IF (PAG->cEstadoPag == 'D',;
		      ' NO lo pago',' lo pago Atrasado')

       CASE nMesIni < LEN(RTRIM(CLI->cMesPagCli)) .AND. !lHayCoE

	    cMsgTxt := 'No se Puede Facturar un mes anterior a '+;
			cMes(LEN(RTRIM(CLI->cMesPagCli)))

       CASE nMesIni # PAG->nMesIniPag .AND. PAG->cEstadoPag == '*' .AND.;
	    IF(CAA->nMesAmnCaA == nMesIni,.F.,CAA->nMesAmnCaA # nMesIni+1)

	    cMsgTxt:= 'Antes de Facturar '+cMesIni+' Debe Indicar '+;
		      'la Forma de Pago del Mes de '+ cMes(PAG->nMesiniPag)

       CASE nMesIni > PAG->nMesfinPag+1 .AND. PAG->nMesfinPag # 0 .AND.;
	    nUltRec == 0 .AND. !lHayCoE

	    cMsgTxt := 'Falta Facturar el Recibo del Mes de '+;
		       cMes(PAG->nMesFinPag+1)

       CASE PAG->nMesFinPag > PAG->nMesIniPag .AND. PAG->cEstadoPag == 'D' .AND.;
	    nMesIni > PAG->nMesIniPag+1

	    cMsgTxt := 'Falta Facturar el Recibo del Mes de '+;
		       cMes(PAG->nMesIniPag+1)

/*
       CASE PAG->cEstadoPag == 'P' .AND.;
	    CAA->lLeeFecCaA .AND. EMPTY(dFecPagPag)
	    cMsgTxt := 'NO HA INDICADO LA FECHA DE PAGO'
*/

       OTHERWISE
	    lRecibo := .T.
       ENDCASE
*>>>>FIN VALIDACION CON RESPECTO AL ULTIMO PAGO

*>>>>VALICACION CON RESPECTO A TODOS LOS PAGOS
       nRegPag := 0
       IF lRecibo
	  SELECT PAG
	  PAG->(DBGOTOP())
	  DO WHILE .NOT. EOF()

	     DO CASE
	     CASE nMesIni == PAG->nMesiniPag .AND. nMesIni == PAG->nMesfinPag

		  nRegPag = RECNO()
		  EXIT

	     CASE nMesIni >= PAG->nMesiniPag .AND.;
		  nMesIni <= PAG->nMesfinPag .AND.;
		  PAG->cEstadoPag # 'D' .AND. !lHayCoE

		  cMsgTxt := cMesIni+' Ya Facturado en el recibo de '+;
			     cMes(PAG->nMesiniPag)+' A '+cMes(PAG->nMesfinPag)
		  lRecibo := .F.
		  EXIT

	     ENDCASE

	     PAG->(DBSKIP())

	 ENDDO
       ENDIF

       IF cNomEst # NIL .AND. !lRecibo
	  cError(cMsgTxt,cNomEst)
       ENDIF

       SET FILTER TO
       RETURN lRecibo
*>>>>FIN VALICACION CON RESPECTO A TODOS LOS PAGOS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE FACTURACION POR ADELANTADO       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de pagos en el registro del estudiante

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna .T. si se puede facturar el recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDobleFac(cCodEst,nMesIni,nMesFin,cMesPag,nRegPag,cNomEst,nUltRec,;
		   lHayCoE)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo de Estudiante
       nMesIni                              // Mes inicial del pago
       nMesFin                              // Meses de pago
       nRegPag                              // @Registro del pago
       cNomEst                              // Nombre del Estudiante
       nUltRec                              // Ultimo Recibo Facturado
       lHayCoE                              // .T. Hay Conceptos Individuales */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lRecibo := .F.		   // .T. = Facturar
       LOCAL cMesIni := ''                 // Nombre del Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION CON RESPECTO AL ULTIMO PAGO
       SELECT PAG
       SET FILTER TO PAG->cCodigoEst == cCodEst
       GO BOTTOM

       lHayCoE := IF(lHayCoE==NIL,.F.,lHayCoE)
       cMesIni := cMes(nMesIni)
       DO CASE
       CASE PAG->cEstadoPag == 'P' .AND. !EMPTY(PAG->dFecPagPag) .AND.;
	    nMesIni == PAG->nMesIniPag

	    cError('El recibo de ' +cMesIni+' figura con fecha de '+;
		   'pago del '+cFecha(PAG->dFecPagPag),cNomEst)

       CASE (PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag == 'A') .AND.;
		 nMesIni == PAG->nMesIniPag

	    cError(' El recibo de ' +cMesIni+IF (PAG->cEstadoPag == 'D',;
		   ' NO lo pago',' lo pago Atrasado'))

       CASE nMesIni < LEN(RTRIM(CLI->cMesPagCli)) .AND. !lHayCoE

	  cError('No se Puede Facturar un mes anterior a '+;
		 cMes(LEN(RTRIM(CLI->cMesPagCli))))

       CASE nMesIni # PAG->nMesIniPag .AND. PAG->cEstadoPag == '*'

	    cError('Antes de Facturar '+cMesIni+' Debe Indicar '+;
		   'la Forma de Pago del Mes de '+ cMes(PAG->nMesIniPag))

       CASE nMesIni > PAG->nMesFinPag+1 .AND. PAG->nMesFinPag # 0 .AND.;
	    nUltRec == 0 .AND. !lHayCoE

	    cError('Falta Facturar el Recibo del Mes de '+;
		    cMes(PAG->nMesFinPag+1))

       CASE nMesIni < PAG->nMesFinPag .AND. nMesFin >= PAG->nMesFinPag+1

	    cError('LOS MESES DE '+cMes(nMesIni)+' A '+cMes(PAG->nMesFinPag)+;
		   ' YA ESTAN FACTURADOS')

       OTHERWISE
	    lRecibo := .T.
       ENDCASE
*>>>>FIN VALIDACION CON RESPECTO AL ULTIMO PAGO

*>>>>VALICACION CON RESPECTO A TODOS LOS PAGOS
       nRegPag := 0
       IF lRecibo
	  GO TOP
	  DO WHILE .NOT. EOF()

	     DO CASE
	     CASE (PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag == 'A') .AND.;
		       nMesIni == PAG->nMesIniPag

		  cError(' El recibo de ' +cMesIni+IF (PAG->cEstadoPag == 'D',;
			 ' NO lo pago',' lo pago Atrasado'))
		  lRecibo := .F.
		  EXIT

	     CASE nMesIni > PAG->nMesIniPag .AND. nMesFin <= PAG->nMesFinPag .AND.;
		  PAG->cEstadoPag # 'D' .AND. !EMPTY(PAG->dFecPagPag) .AND.;
		  !lHayCoE

		  cError('YA SE FACTURO EN EL RECIBO DE '+;
			 cMes(PAG->nMesIniPag)+' A '+cMes(PAG->nMesFinPag))
		  lRecibo := .F.
		  EXIT

	     CASE nMesIni == PAG->nMesIniPag
		  nRegPag := RECNO()
		  EXIT

	     ENDCASE
	     SKIP
	  ENDDO

	  GO TOP
	  IF nRegPag # 0
	     DO WHILE .NOT. EOF()
		IF nMesFin >= PAG->nMesIniPag .AND. nMesFin <= PAG->nMesFinPag .AND.;
		   PAG->cEstadoPag # 'D' .AND. !EMPTY(PAG->dFecPagPag)

		   IF nRegPag # RECNO()
		      cError(cMes(nMesFin)+' YA FACTURADO EN EL RECIBO DE '+;
			     cMes(PAG->nMesIniPag)+' A '+ cMes(PAG->nMesFinPag))
		      lRecibo := .F.
		      EXIT
		   ENDIF

		ENDIF
		SKIP
	     ENDDO
	  ENDIF
       ENDIF
       SET FILTER TO
       RETURN lRecibo
*>>>>FIN VALICACION CON RESPECTO A TODOS LOS PAGOS

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE PAGOS		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Permite el mantenimiento del archivo Pagos

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPag(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL oBrwPag := NIL                 // Browse de Pagos
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // Codigo del grupo
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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL GRUPO
       cCodigoTgr := cSpaces('GRU','cCodigoGru')

       IF !lLeeCodGru(nFilInf+1,nColInf,@cCodigoTgr,cMaeAct)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       CloseDbf('GRU')
*>>>>FIN LECTURA DEL GRUPO

*>>>>PREPARACION DE LAS VARIABLES DE ARCHIVOS
       FilePag := cPatSis+'\PAGOS\PA'+;
		  cCodigoTgr+cAnoSis+ExtFile
*>>>>FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FilePag,'PAG',NIL,lNoRed,nModCry)
	  cError('ABRIENDO PAGOS EN '+cPatSis)
	  CloseDbf('PAG',FilePag,nModCry)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN PAGOS REGISTRADOS')
	    CloseDbf('PAG',FilePag,nModCry)
	    CloseAll(aUseDbf)
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT PAG
       oBrwPag := oDefBrwPag(lShared,nFilPal+1,00,22,79,cCodigoTgr,cNalias)
       SETKEY(K_F5,{||BuscarPag(oBrwPag)})
       PAG->(CtrlBrw(lShared,oBrwPag))
       SETKEY(K_F5,NIL)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE PAGOS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Define el objeto Browse del archivo Pagos

SINTAXIS:

 oBrwPag := oDefBrwPag(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPag(lShared,nFilSup,nColSup,nFilInf,nColInf,cCodGru,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cCodGru                              // C¢digo del Grupo
       cMaeAct			            // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE PAGOS DEL GRUPO '+cCodGru+' >>',;
			    '<F5>Buscar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PAG
       oColumn	     := TBCOLUMNNEW('No', {||STR(PAG->(RECNO()),4)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||PAG->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL ESTUDIANTE',;
				    {||cSekNomAlu(PAG->cCodigoEst,;
						  cMaeAct,'PAG')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
*       oBrowse:Freeze:= 3
     *ÀDefinici¢n Columna

       IF CAA->lHayNroCaA
	  oColumn	     := TBCOLUMNNEW('RECIBO No',{||PAG->nNroFacCaA})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(PAG->nMesIniPag,3)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(PAG->nMesFinPag,3)})
       oColumn:Width := 10
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn	     := TBCOLUMNNEW('ATRASOS', {||PAG->cAtrasoPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn	     := TBCOLUMNNEW('SALDO ANTERIOR', {||PAG->nSdoAntPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA ANTERIOR', {||PAG->nMorAntPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SALDO A¥O ANTERIOR', {||PAG->nSdoAnoPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA A¥O ANTERIOR', {||PAG->nMorAnoPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SDOANT ABONO', {||PAG->nSdAbonPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORANT ABONO', {||PAG->nMoAbonPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SDOANT ABONO A¥O', {||PAG->nSdAanoPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORANT ABONO A¥O', {||PAG->nMoAanoPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MES', {||PAG->nVlrMesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('POR PAGAR', {||PAG->nVlrPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR', {||PAG->nSdoFavPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR PAGADO', {||PAG->nFavPagPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR DESCONTADO', {||PAG->nFavDesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR APLICADO', {||PAG->nFavAplPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ESTADO',{||cNomEstado(PAG->cEstadoPag)})
       oColumn:Width := 8
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE PAGO',{||cFecha(PAG->dFecPagPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PAGO OPO',{||cFecha(PAG->dPagOpoPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PAGO EXT',{||cFecha(PAG->dPagExtPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FACTURADO',{||cFecha(PAG->dFecFacPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INTERES%',{||PAG->nIntMorPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MORA', {||PAG->nVlrMorPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BECA',{||IF(PAG->lHayBecPag,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BECA',;
			{||STR(PAG->nPorBecPag,4,2)+'%:'+;
			   STR(PAG->nVlrBecPag,10,2)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCUENTO', {||PAG->nVlrDesPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECARGO', {||PAG->nVlrRecPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESC GRAL', {||PAG->nDesGenPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECA GRAL', {||PAG->nRecGenPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS EN MORA',{||PAG->cConSdoPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS;COBRADOS',;
			{||IF(PAG->lConcepPag,'NO','SI')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS COBRADOS',;
			{||PAG->cConcepPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 1', {||PAG->nVlrCo1Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 2', {||PAG->nVlrCo2Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 3', {||PAG->nVlrCo3Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 4', {||PAG->nVlrCo4Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 5', {||PAG->nVlrCo5Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 6', {||PAG->nVlrCo6Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 7', {||PAG->nVlrCo7Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 8', {||PAG->nVlrCo8Pag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       IF CAA->nMtdFacCaA == 1

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 1', {||PAG->nVl1Co1Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 2', {||PAG->nVl1Co2Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 3', {||PAG->nVl1Co3Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 4', {||PAG->nVl1Co4Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 5', {||PAG->nVl1Co5Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 6', {||PAG->nVl1Co6Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 7', {||PAG->nVl1Co7Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 CON No. 8', {||PAG->nVl1Co8Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 1', {||PAG->nVl2Co1Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 2', {||PAG->nVl2Co2Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 3', {||PAG->nVl2Co3Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 4', {||PAG->nVl2Co4Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 5', {||PAG->nVl2Co5Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 6', {||PAG->nVl2Co6Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 7', {||PAG->nVl2Co7Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 CON No. 8', {||PAG->nVl2Co8Pag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

       ENDIF

       oColumn	     := TBCOLUMNNEW('MES FACTURADOS POR CONCEPTOS', {||PAG->cIniFinPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BANCO',{||PAG->cCodigoBan})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna



       oColumn	     := TBCOLUMNNEW('CODIGO DEL;ESTUDIANTE',;
				    {||PAG->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||PAG->cNomUsrPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(PAG->dFecUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(PAG->cHorUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CLIENTE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso los archivos de Pagos

2- Busca el c¢digo del Cliente

3- Retorna NIL

SINTAXIS:

  BuscarPag(oBrwPag)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarPag(oBrwPag)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwPag				    // Browse de Pagos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegPag := 0                   // Registro del Pago
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTpa := ''              // C¢digo del cliente
       LOCAL nMesIniTpa := 0               // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTpa := cSpaces('PAG','cCodigoEst')
       TitBuscar(LEN(cCodigoTpa)+3,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTpa PICT '999999';
			 VALID lCorrecion(@cCodigoTpa)

       @ nNroFil,nNroCol+7 GET nMesIniTpa PICT '99' VALID ;
			   lnValMes(ROW(),COL()-2,@nMesIniTpa)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE VAL(cCodigoTpa) == 0

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT PAG
       IF lBuscar .AND. lLocCodPag(cCodigoTpa,nMesIniTpa)
	  nRegPag := RECNO()
	  GO TOP
	  oBrwPag:GOTOP()
	  GO nRegPag
	  oBrwPag:FORCESTABLE()
       ELSE
	  oBrwPag:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: NOMBRE DEL ESTADO DEL PAGO            	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Retorna la forma de pago seg£n el c¢digo de la forma de pago

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomEstado(cEstado)

*>>>>PARAMETROS DE LA FUNCION
/*     cEstado                              // C¢digo del Estado del pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cEstadoTpa := ''               // Nombre de Estado del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE cEstado == 'P'
	     cEstadoTpa := 'PAGO OPO'
       CASE cEstado == 'A'
	     cEstadoTpa := 'PAGO EXT'
       CASE cEstado == 'D'
	     cEstadoTpa := 'NO PAGO '
       CASE cEstado == '*'
	     cEstadoTpa := 'DEUDOR  '
       OTHERWISE
	     cEstadoTpa := 'ERROR   '
       ENDCASE
       RETURN cEstadoTpa
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

/*************************************************************************
* TITULO DE LA FUNCION..: OBJETO BROWSE CONSULTA DE PAGOS	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 16/95 MIE A
       Colombia,Bucaramanga         INICIO: 12:00 AM   MAR 16/95 MIE

OBJETIVOS:

1- Define el objeto Browse consulta de los detalles del Pago

SINTAXIS:

 oBrwPag := oConBrwPag(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oConBrwPag(nFilSup,nColSup,nFilInf,nColInf,lModReg)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       lModReg                              // .T. Modificaci¢n de Registros */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Pagos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<DETALLES DE LOS PAGOS>>',;
			    '<F9>Imprimir <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       lModReg := IF(EMPTY(lModReg),.F.,lModReg)
       SELECT PAG

       IF lModReg
	  oColumn := TBCOLUMNNEW('MES',{||PAG->nMesIniPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nMesIniPag'},;
			    {'PICTURE','99'}}
       ELSE
	  oColumn := TBCOLUMNNEW('MES',{||cMes(PAG->nMesIniPag,03)})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('MES',{||PAG->nMesFinPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nMesFinPag'},;
			    {'PICTURE','99'}}
       ELSE
	  oColumn := TBCOLUMNNEW('MES',{||cMes(PAG->nMesFinPag,03)})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF SCA->nSdoAnoCar # 0
	  oColumn := TBCOLUMNNEW('DEUDA A¥O;ANTERIOR',{||PAG->nSdoAnoPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF SCA->nSdoAnoCar # 0
	  oColumn := TBCOLUMNNEW('MORA A¥O;ANTERIOR',{||PAG->nMorAnoPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       oColumn	     := TBCOLUMNNEW('DEUDA;ANTERIOR',{||PAG->nSdoAntPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nSdoAntPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA;ANTERIOR',{||PAG->nMorAntPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nMorAntPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;DEL MES',{||PAG->nVlrMesPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrMesPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR;A PAGAR',{||PAG->nVlrPagPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrPagPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('ESTADO;DEL PAGO',{||PAG->cEstadoPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cEstadoPag'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn := TBCOLUMNNEW('ESTADO;DEL PAGO',{||cNomEstado(PAG->cEstadoPag)})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oColumn:Width := 8
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('FECHA;DE PAGO',;
				       {||PAG->dFecPagPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','dFecPagPag'},;
			    {'PICTURE','@!'}}
       ELSE
	   oColumn := TBCOLUMNNEW('FECHA;DE PAGO',;
				       {||cFecha(PAG->dFecPagPag)})
	   oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('FECHA PAGO;OPORTUNO',{||PAG->dPagOpoPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','dPagOpoPag'},;
			    {'PICTURE','@D'}}
       ELSE
	  oColumn	     := TBCOLUMNNEW('FECHA PAGO;OPORTUNO',;
				      {||cFecha(PAG->dPagOpoPag)})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('FECHA PAGO;EXTEMPORANEO',;
				 {||PAG->dPagExtPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','dPagExtPag'},;
			    {'PICTURE','@D'}}
       ELSE
	  oColumn := TBCOLUMNNEW('FECHA PAGO;EXTEMPORANEO',;
				 {||cFecha(PAG->dPagExtPag)})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;FACTURACION',;
				    {||cFecha(PAG->dFecFacPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn	     := TBCOLUMNNEW('FECHA DEL;REPORTE',;
				    {||cFecha(PAG->dFecRepMor)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn := TBCOLUMNNEW('CODIGO;BANCO',{||PAG->cCodigoBan})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cCodigoBan'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('NOVEDAD;DATACREDITO',{||PAG->cNovRepPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cNovRepPag'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn := TBCOLUMNNEW('NOVEDAD;DATACREDITO',{||PAG->cNovRepPag})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('FECHA DEL;REPORTE',;
				       {||PAG->dFecRepPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','dFecRepPag'},;
			    {'PICTURE','@!'}}
       ELSE
	   oColumn := TBCOLUMNNEW('FECHA DEL;REPORTE',;
				       {||cFecha(PAG->dFecRepPag)})
	   oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('NOVEDAD ANTERIOR;DATACREDITO',{||PAG->cNovAntPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cNovAntPag'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn := TBCOLUMNNEW('NOVEDAD ANTERIOR;DATACREDITO',{||PAG->cNovAntPag})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn := TBCOLUMNNEW('FECHA DEL;REPORTE ANTERIOR',;
				       {||PAG->dRepAntPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','dRepAntPag'},;
			    {'PICTURE','@!'}}
       ELSE
	   oColumn := TBCOLUMNNEW('FECHA DEL;REPORTE ANTERIOR',;
				       {||cFecha(PAG->dRepAntPag)})
	   oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOMBRE;REPORTADO',{||PAG->nNomFacEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn := TBCOLUMNNEW('FECHA RETIRO;REPORTE',{||cFecha(PAG->dFecRetMor)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO DE;REPORTADO',{||PAG->nNomRepCaA})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn	     := TBCOLUMNNEW('RECIBO No',{||PAG->nNroFacCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nNroFacCaA'},;
			 {'PICTURE','999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SALDO;A FAVOR',{||PAG->nSdoFavPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nSdoFavPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR;PAGADO',{||PAG->nFavPagPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nFavPagPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR;DESCONTADO',{||PAG->nFavDesPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nFavDesPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A FAVOR;APLICADO',{||PAG->nFavAplPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nFavAplPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO;DE PAGO',{||PAG->cCodigoFpg})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cCodigoFpg'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('DOCUMENTO DEL;TIPO DE PAGO',;
			     {||PAG->cNroFpgPag})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cNroFpgPag'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIENE;BECA',;
				   {||IF(PAG->lHayBecPag,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DE;LA BECA',;
			{||STR(PAG->nPorBecPag,3)+'%:'+;
			   STR(PAG->nVlrBecPag,10,2)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('VALOR DE;LOS ABONOS',;
				   {||PAG->nAbonosPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nAbonosPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nAbonosPag'},;
			 {'PICTURE','9999999.99'}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DE LOS;ANTICIPOS MES',;
				   {||PAG->nAnticiPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR PAGOS;PARCIALES',;
				   {||PAG->nPagParPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nPagParPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('VALOR DE LOS;DESCUENTOS',;
				   {||PAG->nVlrDesPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrDesPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR DE LOS;RECARGOS',;
				   {||PAG->nVlrRecPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrRecPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCUENTOS;GENERALES',;
				   {||PAG->nDesGenPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nDesGenPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RECARGOS;GENERALES',{||PAG->nRecGenPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nRecGenPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS;GENERALES',;
				   {||PAG->cConGenPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(PAG->nMesIniPag,03)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MES',;
			{||cMes(PAG->nMesFinPag,03)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ESTADO;DEL PAGO',{||cNomEstado(PAG->cEstadoPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 8
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF PAG->lIntPenPag
	  oColumn	:= TBCOLUMNNEW('INTERES PAGO;EXTEMPORANEO',{||PAG->nIntMorPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)

	  oColumn	:= TBCOLUMNNEW('INTERES PARA;EL NO PAGO',{||PAG->nIntDeuPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF !PAG->lIntPenPag
	  oColumn	:= TBCOLUMNNEW('VALOR MORA;EXTEMPORANEO', {||PAG->nVlrMorPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)

	  oColumn	:= TBCOLUMNNEW('VALOR MORA;PARA EL NO PAGO', {||PAG->nVlrDeuPag})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oBrowse:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS EN;'+;
				    'MORA DEL RETIRO',{||PAG->cConSdoPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cConSdoPag'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lModReg
	  oColumn	     := TBCOLUMNNEW('CONCEPTOS;NO COBRADOS',;
					    {||PAG->lConcepPag})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','lConcepPag'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn	     := TBCOLUMNNEW('CONCEPTOS;COBRADOS',;
				{||IF(PAG->lConcepPag,'NO','SI')})
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS;COBRADOS',;
			{||PAG->cConcepPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','cConcepPag'},;
			    {'PICTURE','@!'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 1;DEL CONCEPTO',;
				   {||PAG->nVlrCo1Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo1Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 2;DEL CONCEPTO',;
				   {||PAG->nVlrCo2Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo2Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 3;DEL CONCEPTO',;
				    {||PAG->nVlrCo3Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo3Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 4;DEL CONCEPTO',;
				   {||PAG->nVlrCo4Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo4Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 5;DEL CONCEPTO',;
				   {||PAG->nVlrCo5Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo5Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 6;DEL CONCEPTO',;
				   {||PAG->nVlrCo6Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo6Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 7;DEL CONCEPTO',;
				   {||PAG->nVlrCo7Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo7Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR No. 8;DEL CONCEPTO',;
				   {||PAG->nVlrCo8Pag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVlrCo8Pag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF CAA->nMtdFacCaA == 1

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 1;DEL CONCEPTO',;
				      {||PAG->nVl1Co1Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co1Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 2;DEL CONCEPTO',;
				      {||PAG->nVl1Co2Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co2Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 3;DEL CONCEPTO',;
				       {||PAG->nVl1Co3Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co3Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 4;DEL CONCEPTO',;
				      {||PAG->nVl1Co4Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co4Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 5;DEL CONCEPTO',;
				      {||PAG->nVl1Co5Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co5Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 6;DEL CONCEPTO',;
				      {||PAG->nVl1Co6Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co6Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 7;DEL CONCEPTO',;
				      {||PAG->nVl1Co7Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co7Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR1 No. 8;DEL CONCEPTO',;
				      {||PAG->nVl1Co8Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl1Co8Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 1;DEL CONCEPTO',;
				      {||PAG->nVl2Co1Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co1Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 2;DEL CONCEPTO',;
				      {||PAG->nVl2Co2Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co2Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 3;DEL CONCEPTO',;
				       {||PAG->nVl2Co3Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co3Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 4;DEL CONCEPTO',;
				      {||PAG->nVl2Co4Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co4Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 5;DEL CONCEPTO',;
				      {||PAG->nVl2Co5Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co5Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 6;DEL CONCEPTO',;
				      {||PAG->nVl2Co6Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co6Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 7;DEL CONCEPTO',;
				      {||PAG->nVl2Co7Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co7Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

	  oColumn	     := TBCOLUMNNEW('VALOR2 No. 8;DEL CONCEPTO',;
				      {||PAG->nVl2Co8Pag})
	  IF lModReg
	     oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nVl2Co8Pag'},;
			       {'PICTURE','9999999.99'}}
	  ELSE
	     oColumn:Cargo := {{'MODI',.F.}}
	  ENDIF
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna

       ENDIF

       oColumn	     := TBCOLUMNNEW('MES FACTURADOS;POR CONCEPTOS', {||PAG->cIniFinPag})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna



       oColumn	     := TBCOLUMNNEW('DEUDA ANTERIOR SIN ABONOS;DESPUES DE FECHA EXT',;
				    {||PAG->nSdoExtPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nSdoExtPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEUDA ANTERIOR;SIN ABONOS', {||PAG->nSdAbonPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nSdAbonPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA ANTERIOR;SIN ABONOS', {||PAG->nMoAbonPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nMoAbonPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEUDA ANTERIOR;SIN ABONOS A¥O', {||PAG->nSdAanoPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nSdAanoPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA ANTERIOR;SIN ABONOS A¥O', {||PAG->nMoAanoPag})
       IF lModReg
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','nMoAanoPag'},;
			    {'PICTURE','9999999.99'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ANMISTIA',;
			  {||IF(PAG->nMesAmnPag==PAG->nMesIniPag,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO DEL;ESTUDIANTE',;
				    {||PAG->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||PAG->cNomUsrPag})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PAG'},{'FIELD','cNomUsrPag'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(PAG->dFecUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


/*
       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',{||PAG->dFecUsrPag})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PAG'},{'FIELD','dFecUsrPag'},;
			 {'PICTURE','@D'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
*/

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(PAG->cHorUsrPag)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('REGISTRO',{||PAG->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MAIL DEL PAGO',{||PAG->cMaiPagEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PAG'},{'FIELD','cMaiPagEst'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: NUMERO DE MESES FACTURADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 30/98 MAR A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUN 30/98 MAR

OBJETIVOS:

1- Calcula el total de n£mero de meses facturados.

2- Retorna el total de n£mero de meses facturados.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nNroMesFac(nMesIni,nMesFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nMesIni                              // Mes Inicial de Facturaci¢n
       nMesFin                              // Mes Final de Facturaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>CALCULO DEL TOTAL DE MESES FACTURADOS
       RETURN 1+nMesFin-nMesIni
*>>>>FIN CALCULO DEL TOTAL DE MESES FACTURADOS

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZACION DEL PAGO ANTERIOR                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Valida si existe el c¢digo del estudiante en el archivo de Pagos

2- Debe estar en uso el archivo de Pagos correspondiente

3- Retorna .T. si existe el codigo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocPagAnt(cCodPag,nMesIni,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodPag			            // C¢digo del Pago
       nMesIni                              // Mes inicial del pago
       lMensaj                              // .T. Mostrar mensaje de error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT PAG
       GO TOP
       LOCATE FOR PAG->cCodigoEst == cCodPag .AND.;
		  PAG->nMesFinPag == nMesIni

       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CODIGO '+cCodPag+' DEL ESTUDIANTE '+;
		    'NO TIENE PAGO ANTERIOR PARA EL MES DE '+cMes(nMesIni,10))
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: PORCENTAJE DE LA BECA                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/2000 LUN A
       Colombia, Bucaramanga        INICIO: 04:10 PM   MAY 08/2000 LUN

OBJETIVOS:

1- Crea un vector con los detalles de cada pago hasta encontrar un abono.

2- El objetivo de este vector es permitir la Actualizaci¢n de los abonos.

3- Retorna por referencia los param‚tros marcados con @

4- Retorna .T. si se creo el vector sin problemas.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIntBeca()

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cPorBec := ''                  // Porcentaje de la Beca.
       LOCAL cCodCon := ''                  // C¢digo del Concepto
       LOCAL nNroPos := 0                   // N£mero de la Posici¢n del Concepto
       LOCAL nVlrCon := 0                   // Valor de los Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL VALOR DE LOS CONCEPTOS BECADOS
       IF PAG->lHayBecPag .AND. PAG->nPorBecPag == 0 .AND.;
	  PAG->nVlrBecPag # 0

	  FOR i := 1 TO LEN(PAG->cConcepPag)/2

**************ANALISIS SI EL CONCEPTO ESTA BECADO
		cCodCon := SUBS(PAG->cConcepPag,i*2-1,2)
		IF lLocCodigo('cCodigoCon','CON',cCodCon)
		   IF CON->lBecadoCon
		      IF cCodCon $ PAG->cConcepPag
			 nNroPos := (AT(cCodCon,PAG->cConcepPag)+1)/2
			 nVlrCon += &('PAG->nVlrCo'+STR(nNroPos,1)+'Pag')
		      ENDIF
		   ENDIF
		ENDIF
**************FIN ANALISIS SI EL CONCEPTO ESTA BECADO

	  ENDFOR
       ENDIF
*>>>>FIN CALCULO DEL VALOR DE LOS CONCEPTOS BECADOS

*>>>>CALCULO DEL PORCENTAJE DE LA BECA
       IF PAG->lHayBecPag
	  IF PAG->nPorBecPag # 0
	     cPorBec := STR(PAG->nPorBecPag,3)+'%'
	  ELSE
	     IF PAG->nVlrBecPag # 0
		cPorBec := STR((PAG->nVlrBecPag*100)/nVlrCon,5,2)+'%'
	     ENDIF
	  ENDIF
       ENDIF
       RETURN cPorBec
*>>>>FIN CALCULO DEL PORCENTAJE DE LA BECA

/*************************************************************************
* TITULO DE LA FUNCION..: INTERSES DEL MES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 10/98 LUN A
       Colombia, Bucaramanga        INICIO: 12:23 PM   AGO 10/98 LUN

OBJETIVOS:

1- Calcula el valor de los intereses del Mes

2- Debe estar ubicado en el respectivo registro del archivo pagos

3- Retorna el valor de los intereses.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION nIntMesPag(lIntPen,nDeuAnt,nVlrMes,nMesIni,nMesAmn)

*>>>>PARARAMETROS DE LA FUNCION
/*     lIntPen                              // .T. Interese por porcentaje
       nDeuAnt			            // Deuda Anterior
       nVlrMes                              // Valor del Mes
       nMesIni                              // Mes Inicial del recibo
       nMesAmn                              // Mes de Amnist¡a */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrInt := 0                   // Valor de los intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS INTERESES
       IF CAA->lIntPenCaA
	  IF nMesIni # nMesAmn
	     nVlrInt := ROUND(((nDeuAnt+nVlrMes)*PAG->nIntMorPag)/100,0)
	  ELSE
	     nVlrInt := ROUND((nVlrMes*PAG->nIntMorPag)/100,0)
	  ENDIF
       ELSE
	   nVlrInt := PAG->nVlrMorPag
       ENDIF
       RETURN ABS(nVlrInt)
*>>>>FIN CALCULO DE LOS INTERESES

/*************************************************************************
* TITULO..: INTERSES DEL MES NO PAGO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2010 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   MAR 01/2010 LUN

OBJETIVOS:

1- Calcula el valor de los intereses del Mes por NO pago

2- Debe estar ubicado en el respectivo registro del archivo pagos

3- Retorna el valor de los intereses.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION nIntMesNoP(lIntPen,nDeuAnt,nVlrMes,nMesIni,nMesAmn)

*>>>>PARARAMETROS DE LA FUNCION
/*     lIntPen                              // .T. Interese por porcentaje
       nDeuAnt			            // Deuda Anterior
       nVlrMes                              // Valor del Mes
       nMesIni                              // Mes Inicial del recibo
       nMesAmn                              // Mes de Amnist¡a */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrInt := 0                   // Valor de los intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS INTERESES
       IF CAA->lIntPenCaA
	  IF nMesIni # nMesAmn
	     nVlrInt := ROUND(((nDeuAnt+nVlrMes)*PAG->nIntDeuPag)/100,0)
	  ELSE
	     nVlrInt := ROUND((nVlrMes*PAG->nIntDeuPag)/100,0)
	  ENDIF
       ELSE
	   nVlrInt := PAG->nVlrDeuPag
       ENDIF
       RETURN ABS(nVlrInt)
*>>>>FIN CALCULO DE LOS INTERESES

/*************************************************************************
* TITULO..: VALOR DE LOS INTERESES                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:23 PM   JUN 24/99 JUE

OBJETIVOS:

1- Calcula el valor de los intereses de acuerdo a la deuda pasada
   como param‚tro.

2- Retorna el valor de los intereses.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrInt(nVlrDeu)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDeu                              // Valor de la Deuda */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrInt := 0                   // Valor de los intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS INTERESES
       IF PAG->lIntPenPag
	  nVlrInt := ROUND((nVlrDeu*PAG->nIntMorPag)/100,0)
       ELSE
	  nVlrInt := PAG->nVlrMorPag
       ENDIF
       RETURN ABS(nVlrInt)
*>>>>FIN CALCULO DE LOS INTERESES

/*************************************************************************
* TITULO..: VALOR DE LOS INTERESES DEL NO PAGO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 01/2010 LUN A
       Colombia, Bucaramanga        INICIO: 10:30 AM   MAR 01/2010 LUN

OBJETIVOS:

1- Calcula el valor de los intereses de acuerdo a la deuda pasada
   como param‚tro.

2- Retorna el valor de los intereses.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nIntNoP(nVlrDeu)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDeu                              // Valor de la Deuda */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrInt := 0                   // Valor de los intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS INTERESES
       IF PAG->lIntPenPag
	  nVlrInt := ROUND((nVlrDeu*PAG->nIntDeuPag)/100,0)
       ELSE
	  nVlrInt := PAG->nVlrDeuPag
       ENDIF
       RETURN ABS(nVlrInt)
*>>>>FIN CALCULO DE LOS INTERESES

/*************************************************************************
* TITULO..: APLICAR UN ABONO A UN ESTUDIANTE                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 23/2007 VIE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   JUN 23/2007 VIE

OBJETIVOS:

1- Permite aplicar o descontar del saldo el abono teniendo en cuenta
   el Interes por mora para un estudiante

SINTAXIS:

IF lAbono(cCodigoTes,cNombreTes,nNroMesTde,dFecAbo,nVlrAbo,;
   CLI->nSdoActCli,CLI->nSdoMorCli)

   cError('SE APLICO EL ABONO')
ELSE
   cError('NO SE APLICO EL ABONO')
ENDIF
RETURN NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lAbono(cCodEst,cNomEst,nMesAbo,dFecAbo,nVlrAbo,nDeuCli,nMorCli,;
		nDeuAbo,nMorAbo,aMesAnt,aMesAct,cMsgErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       nMesAbo                              // Mes del Abono
       dFecAbo                              // Fecha del Abono
       nVlrAbo                              // Valor del Abono
       nDeuCli                              // Deuda del Cliente
       nMorCli                              // Mora del Cliente
       nDeuAbo                              // @Deuda con abono
       nMorAbo                              // @Mora con abono
       aMesAnt                              // Registros Mes Anterior
       aMesAct                              // Registros Mes actual
       cMsgErr                              // @Mensaje de Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lPrueba := .F.                 // Activar Pruebas
       LOCAL cPrueba := ''                  // Mensaje de Prueba

       LOCAL nRegAnt := 0                   // Registro Anterior
       LOCAL nRegAct := 0                   // Registro Actual

       LOCAL nIntAct := 0                   // Interes Acumulado del Mes Actual
       LOCAL lMesAct := .F.                 // .T. Mes Actual

       LOCAL lAboOpo := 0                   // .T. Abono Oportuno .F. Abono Extemporaneo

       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nMesAnt := 0                   // Valor del Mes anterior

       LOCAL nDeuAct := 0                   // Deuda Actual
       LOCAL nMorAct := 0                   // Deuda Actual
       LOCAL nMesAct := 0                   // Valor del Mes actual


       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nSdoMor := 0                   // Saldo mora actual

       LOCAL nSaldo  := 0                   // Saldo despues de abono
       LOCAL nIntMes := 0                   // Intereses del mes

       LOCAL nAboDeu := 0                   // Deuda despues de abono
*>>>>FIN DECLARACION DE VARIABLES

*>>>>MES ACTUAL, MES ANTERIOR
       nMesAnt := 0
       nMesAct := nRecUltAnt(cCodEst,@nMesAnt)
       IF nMesAct == nMesAbo
	  lMesAct := .T.
       ELSE
	  lMesAct := .F.
       ENDIF
*>>>>FIN MES ACTUAL, MES ANTERIOR

*>>>>LOCALIZACION DEL MES ANTERIOR
       SELECT PAG
       LOCATE FOR PAG->cCodigoEst == cCodEst .AND.;
		  PAG->nMesIniPag == nMesAnt

       IF !FOUND()
	  cMsgErr := 'NO EXISTE EL RECIBO DE '+cMes(nMesAnt,10)+;
		     ' DE '+cNomEst
	  RETURN .F.
       ENDIF
       nRegAnt := PAG->(RECNO())
*>>>>FIN LOCALIZACION DEL MES ANTERIOR

*>>>>LOCALIZACION DEL MES ACTUAL
       SELECT PAG
       LOCATE FOR PAG->cCodigoEst == cCodEst .AND.;
		  PAG->nMesIniPag == nMesAct

       IF !FOUND()
	  cMsgErr := 'NO EXISTE EL RECIBO DE '+;
		     cMes(nMesAct,10)+' DE '+cNomEst
	  RETURN .F.
       ENDIF
       nRegAct := PAG->(RECNO())
*>>>>FIN LOCALIZACION DEL MES ACTUAL

*>>>>ANALISIS DEL TIPO DE ABONO
       IF lMesAct
	  PAG->(DBGOTO(nRegAct))
	  IF dFecAbo <= PAG->dPagExtPag
	     lAboOpo := .T.
	  ELSE
	     lAboOpo := .F.
	  ENDIF
       ELSE
	  PAG->(DBGOTO(nRegAnt))
	  IF dFecAbo <= PAG->dPagExtPag
	     lAboOpo := .T.
	  ELSE
	     lMesAct := .T.
	     lAboOpo := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL TIPO DE ABONO

*>>>>CALCULO DEL SALDO PARA EL ABONO
       IF lMesAct
	  PAG->(DBGOTO(nRegAct))
       ELSE
	  PAG->(DBGOTO(nRegAnt))
       ENDIF

       IF lAboOpo
	  nSdoAct := PAG->nSdoAntPag
	  nSdoMor := PAG->nMorAntPag
       ELSE
	  nSdoAct := nDeuCli
	  nSdoMor := nMorCli
       ENDIF

       IF nSdoAct+nSdoMor == 0
	  cMsgErr := cNomEst+' EN '+cMes(nMesAct,10)+;
		     ' NO QUEDO CON DEUDAS ATRASADAS'
	  RETURN .F.
       ENDIF
       nSaldo  := nSdoAct+nSdoMor-nVlrAbo
*>>>>FIN CALCULO DEL SALDO PARA EL ABONO

*>>>>APLICACION DEL ABONO OPORTUNO
       IF lAboOpo

	  nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)

**********ACTIVAR PRUEBAS
	    IF lPrueba

	       wait 'abono oportuno. saldo actual=nSdoAct+nSdoMor'
	       wait nSdoAct+nSdoMor

	       wait 'Paso No.1  Calcular el porcentaje de la proporci¢n '+;
				'de la deuda anterior y los intereses por '+;
				'cobrar.'

	       wait 'mes'
	       wait PAG->nMesIniPag

	       wait 'nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)'
	       wait nIntAct
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nSaldo := nSdoAct+nSdoMor-nVlrAbo

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'Paso No.2  Restar el abono del saldo anterior para '+;
				'calcular el nuevo saldo.'

	       wait 'nSaldo actual = nSdoAct+nSdoMor'
	       wait nSdoAct+nSdoMor

	       wait 'nSaldo := nSdoAct+nSdoMor-nVlrAbo'
	       wait nSaldo
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nDeuAnt := ROUND((nSaldo*100)/(100+nIntAct),0)

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'Paso No.3  Calcular la deuda anterior a partir del '+;
				'nuevo saldo'

	       wait 'nDeuAnt := ROUND((nSaldo*100)/(100+nIntAct),0)'
	       wait nDeuAnt
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nMorAnt := nSaldo - nDeuAnt

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'Paso No.4  Por diferencia calcular el nuevo interes '+;
				'por cobrar anterior'

	       wait 'nMorAnt := nSaldo - nDeuAnt'
	       wait nMorAnt
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nMesAnt := PAG->nVlrMesPag

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'nMesAnt := PAG->nVlrMesPag'
	       wait nMesAnt
	    ENDIF
**********FIN ACTIVAR PRUEBAS

       ENDIF
*>>>>FIN APLICACION DEL ABONO OPORTUNO

*>>>>ESTADO DE CUENTA. ABONO OPORTUNO
       IF lAboOpo

	  IF lMesAct

*************MES ACTUAL
	       nDeuAct := nDeuAnt
	       nMorAct := nMorAnt
	       nMesAct := nMesAnt

	       PAG->(DBGOTO(nRegAnt))
	       nIntMes := nIntMesNew(nDeuAct)
*************FIN MES ACTUAL

*************ACTIVAR PRUEBAS
	       IF lPrueba
		   wait 'estado de cuenta. abono oportuno'

		   wait 'nDeuAct := nDeuAnt'
		   wait nDeuAct

		   wait 'nMorAct := nMorAnt'
		   wait nMorAct

		   wait 'nMesAct := nMesAnt'
		   wait nMesAct

		   wait 'mes anterior'
		   wait PAG->nMesIniPag

		   wait 'nIntMes := nIntMesNew(nDeuAct)'
		   wait  nIntMes
	       ENDIF
*************FIN ACTIVAR PRUEBAS

*************MES ANTERIOR
	       PAG->(DBGOTO(nRegAnt))

	       nMorAnt := nMorAct - nIntMes
	     *ÀIntereses por cobrar

	       nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	       nDeuAnt := ROUND((nMorAnt*100)/nIntAct,0)

	       nMesAnt := nDeuAct - nDeuAnt
*************FIN MES ANTERIOR

*************ACTIVAR PRUEBAS
	       IF lPrueba

		   wait 'mes anterior'
		   wait PAG->nMesIniPag

		   wait 'nMorAnt := nMorAct - nIntMes'
		   wait nMorAnt

		   wait 'nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)'
		   wait nIntAct

		   wait 'nDeuAnt := ROUND((nMorAnt*100)/nIntAct,0)'
		   wait nDeuAnt

		   wait 'nMesAnt := nDeuAct - nDeuAnt'
		   wait  nMesAnt

	       ENDIF
*************FIN ACTIVAR PRUEBAS

	  ELSE

*************ACTIVAR PRUEBAS
	       IF lPrueba

		  wait 'estado de cuenta. mes anterior'

		  wait 'nDeuAnt'
		  wait nDeuAnt

		  wait 'nMorAnt'
		  wait nMorAnt

		  wait 'nMesAnt'
		  wait nMesAnt

	       ENDIF
*************FIN ACTIVAR PRUEBAS

*************MES ACTUAL
	       PAG->(DBGOTO(nRegAct))

	       nDeuAct := nDeuAnt+nMesAnt

	       nIntMes := nIntMesNew(nDeuAct)

	       nMorAct := nMorAnt+nIntMes

	       nMesAct := PAG->nVlrMesPag
*************FIN MES ACTUAL

*************ACTIVAR PRUEBAS
	       IF lPrueba

		  wait 'mes actual'
		  wait PAG->nMesIniPag

		  wait 'nDeuAct := nDeuAnt+nMesAnt'
		  wait  nDeuAct

		  wait 'nIntMes := nIntMesNew(nDeuAct)'
		  wait  nIntMes

		  wait 'nMorAct := nMorAnt+nIntMes'
		  wait  nMorAct

		  wait 'nMesAct := PAG->nVlrMesPag'
		  wait  nMesAct

	       ENDIF
*************FIN ACTIVAR PRUEBAS

	  ENDIF

       ENDIF
*>>>>FIN ESTADO DE CUENTA. ABONO OPORTUNO

*>>>>APLICACION DEL ABONO EXTEMPORANEO
       IF .NOT. lAboOpo

	  PAG->(DBGOTO(nRegAct))

	  nIntAct := ROUND((nMorCli*100)/nDeuCli,0)

**********ACTIVAR PRUEBAS
	    IF lPrueba

	       wait 'abono extemporaneo. saldo actual=nSdoAct+nSdoMor'
	       wait nSdoAct+nSdoMor

	       wait 'mes actual'
	       wait PAG->nMesIniPag

	       wait 'Paso No.1  Calcular el porcentaje de la proporci¢n '+;
				'de la deuda actual y los intereses por '+;
				'cobrar.'

	       wait 'nIntAct := ROUND((nMorCli*100)/nDeuCli,0)'
	       wait nIntAct
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nSaldo  := nSdoAct+nSdoMor-nVlrAbo

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'Paso No.2  Restar el abono del saldo anterior para '+;
				'calcular el nuevo saldo.'

	       wait 'nSaldo  := nSdoAct+nSdoMor-nVlrAbo'
	       wait nSaldo
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nAboDeu := ROUND((nSaldo*100)/(100+nIntAct),0)

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'Paso No.3  Calcular la deuda anterior a partir del '+;
				'nuevo saldo'

	       wait 'nAboDeu := ROUND((nSaldo*100)/(100+nIntAct),0)'
	       wait nAboDeu
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nMorAbo := nSaldo - nAboDeu

**********ACTIVAR PRUEBAS
	    IF lPrueba
	       wait 'Paso No.4  Por diferencia calcular el nuevo interes '+;
				'por cobrar anterior'

	       wait 'nMorAbo := nSaldo - nAboDeu'
	       wait nMorAbo
	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nIntMes := nIntMesNew(nAboDeu)

**********ACTIVAR PRUEBAS
	    IF lPrueba

	       wait 'Paso No.5  Calcular el inter‚s por cobrar el mes'

	       wait 'mes actual'
	       wait PAG->nMesIniPag

	       wait 'nIntMes := nIntMesNew(nAboDeu)'
	       wait nIntMes

	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nMorAct := nMorAbo-nIntMes

**********ACTIVAR PRUEBAS
	    IF lPrueba

	       wait 'Paso No.6  Por diferencia calcular el interes por '+;
				'cobrar anterior'

	       wait 'nMorAct := nMorAbo-nIntMes'
	       wait nMorAct

	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	  nDeuAct := ROUND((nMorAct*100)/nIntAct,0)

**********ACTIVAR PRUEBAS
	    IF lPrueba

	       wait 'Paso No.7  Calcular la deuda anterior'

	       wait 'mes actual'
	       wait PAG->nMesIniPag

	       wait 'nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)'
	       wait nIntAct

	       wait 'nDeuAct := ROUND((nMorAct*100)/nIntAct,0)'
	       wait nDeuAct

	    ENDIF
**********FIN ACTIVAR PRUEBAS

	  nMesAct := nAboDeu - nDeuAct

**********ACTIVAR PRUEBAS
	    IF lPrueba

	       wait 'Paso No.8 Calcular del valor del mes'
	       wait 'nMesAct := nAboDeu - nDeuAct'
	       wait nMesAct

	    ENDIF
**********FIN ACTIVAR PRUEBAS

**********MES ANTERIOR
	    PAG->(DBGOTO(nRegAnt))

	    nIntMes := nIntMesNew(nDeuAct)
	  *ÀIntereses del mes anterior

	    nMorAnt := nMorAct - nIntMes
	  *ÀIntereses por cobrar

*===========ACTIVAR PRUEBAS
	      IF lPrueba
		 wait 'mes anterior'
		 wait PAG->nMesIniPag

		 wait 'nIntMes := nIntMesNew(nDeuAct)'
		 wait nIntMes

		 wait 'nMorAnt := nMorAct - nIntMes'
		 wait nMorAnt
	      ENDIF
*===========FIN ACTIVAR PRUEBAS

	    nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	    nDeuAnt := ROUND((nMorAnt*100)/nIntAct,0)
	  *ÀDeuda del mes anterior

*===========ACTIVAR PRUEBAS
	      IF lPrueba
		 wait 'nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)'
		 wait nIntAct

		 wait 'nDeuAnt := ROUND((nMorAnt*100)/nIntAct,0)'
		 wait nDeuAnt
	      ENDIF
*===========FIN ACTIVAR PRUEBAS

	    nMesAnt := nDeuAct - nDeuAnt
	  *ÀValor del mes anterior

*===========ACTIVAR PRUEBAS
	      IF lPrueba
		 wait 'nMesAnt := nDeuAct - nDeuAnt'
		 wait nMesAnt
	      ENDIF
*===========FIN ACTIVAR PRUEBAS

**********FIN MES ANTERIOR

       ENDIF
*>>>>FIN APLICACION DEL ABONO EXTEMPORANEO

*>>>>REGISTROS EN PAGOS
       aMesAnt := {}
       AADD(aMesAnt,nDeuAnt)
       AADD(aMesAnt,nMorAnt)
       AADD(aMesAnt,nMesAnt)
       AADD(aMesAnt,nRegAnt)

       aMesAct := {}
       AADD(aMesAct,nDeuAct)
       AADD(aMesAct,nMorAct)
       AADD(aMesAct,nMesAct)
       AADD(aMesAct,nRegAct)
*>>>>FIN REGISTROS EN PAGOS

/*
*>>>>ANALISIS DEL VALOR DEL MES POR RETIRO
       PAG->(DBGOTO(nRegAnt))
       IF PAG->lConcepPag

	  nDeuAnt := aMesAnt[1]
	  nMorAnt := aMesAnt[2]
	  nMesAnt := aMesAnt[3]

	  nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)

	  nDeuAnt := ROUND(((nDeuAnt+nMorAnt+nMesAnt)*100)/(100+nIntAct),0)
	  nMorAnt := aMesAnt[1]+aMesAnt[2]+aMesAnt[3]-nDeuAnt
	  nMesAnt := 0

	  aMesAnt[1] := nDeuAnt
	  aMesAnt[2] := nMorAnt
	  aMesAnt[3] := nMesAnt

       ENDIF

       PAG->(DBGOTO(nRegAct))
       IF PAG->lConcepPag

	  nDeuAct := aMesAct[1]
	  nMorAct := aMesAct[2]
	  nMesAnt := aMesAct[3]

	  nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)

	  nDeuAct := ROUND(((nDeuAct+nMorAct+nMesAnt)*100)/(100+nIntAct),0)
	  nMorAct := aMesAct[1]+aMesAct[2]+aMesAct[3]-nDeuAct
	  nMesAct := 0

	  aMesAct[1] := nDeuAct
	  aMesAct[2] := nMorAct
	  aMesAct[3] := nMesAct

       ENDIF
*>>>>FIN ANALISIS DEL VALOR DEL MES POR RETIRO
*/

*>>>>SALDO ACTUAL
       PAG->(DBGOTO(nRegAct))

       nDeuAbo := aMesAct[1]+aMesAct[3]

       nIntMes := nIntMesNew(nDeuAbo)

       nMorAbo := aMesAct[2]+nIntMes
*>>>>FIN SALDO ACTUAL

*>>>>ESTADO DE CUENTA
       IF lPrueba

       wait 'DEUDA ANT   MORA ANT   VALOR MES  VLR A PAGAR'

       wait STR(aMesAnt[1],12,2)+SPACE(01)+;
	    STR(aMesAnt[2],12,2)+SPACE(01)+;
	    STR(aMesAnt[3],12,2)

       wait SPACE(01)

       wait STR(aMesAct[1],12,2)+SPACE(01)+;
	    STR(aMesAct[2],12,2)+SPACE(01)+;
	    STR(aMesAct[3],12,2)

	    wait 'nDeuAbo'
	    wait nDeuAbo

	    wait 'nMorAbo'
	    wait nMorAbo

	    wait 'saldo actual'
	    wait nDeuAbo+nMorAbo

       cPausa()

       ENDIF
       RETURN .T.
*>>>>FIN ESTADO DE CUENTA

/*************************************************************************
* TITULO..: VALOR A PAGAR                                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2007 MIE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   MAY 21/2007 MIE

OBJETIVOS:

1- Se debe estar ubicado en el registro del pago

2- Retorna el valor a Pagar o pagado


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nVlrxPagar()

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrPag := 0                   // Valor a Pagar
       LOCAL nVlrInt := 0                   // Valor de los Intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL PAGO
       nVlrPag := PAG->nVlrPagPag
       IF PAG->cEstadoPag == 'A'

	  nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				PAG->nMesIniPag,;
				CAA->nMesAmnCaA)
	  nVlrPag += nVlrInt
       ENDIF
       RETURN nVlrPag
*>>>>FIN ANALISIS DEL PAGO
