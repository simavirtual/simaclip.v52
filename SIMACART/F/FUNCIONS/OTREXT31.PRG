/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: BANCO
OPCIONES....: <EXTRACTO BANCARIO><F9><POR CONCEPTOS><VALIDACION>

**************************************************************************
* TITULO..: VALIDACION DE LOS CONCEPTOS POR DESCRIMINAR                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/2008 MAR A
       Bucaramanga, Colombia        INICIO: 04:00 PM   MAY 06/2008 MAR

OBJETIVOS:

1- Permite descriminar los pagos del extracto por conceptos

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt31(aP1,aP2,aP3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

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
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nOpcPrn := 0                   // Opci¢n de la impresi¢n
     *ÀVariables de informe

       LOCAL aTotErr := {}                  // Registros inconsistentes
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN MOVIMIENTOS GRABADOS')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DE LAS TRANSCIONES
       aTotErr := aValTraExt(aP1,aP2,aP3,cNroMes)
       IF LEN(aTotErr) == 0
	  cError('NO EXISTEN INCONSISTENCIAS')
	  RETURN NIL
       ENDIF

       cError('EXISTEN INCONSISTENCIAS',;
	      'ATENCION','PREPARE LA IMPRESORA')
*>>>>FIN VALIDACION DE LAS TRANSCIONES

*>>>>GESTION DOCUMENTAL DEL INFORME
       aP3 := {}
       AADD(aP3,{'nNroInf',0})
     *ÀN£mero de identificaci¢n del informe

       AADD(aP3,{'cOpcSys',''})
     *ÀOpci¢n del sistema del informe

       AADD(aP3,{'cCodInf',''})
     *ÀC¢digo del Informe

       aMarInf := {}
       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
       AADD(aP3,{'aMarInf',aMarInf})
     *ÀMargenes del Informe

       AADD(aP3,{'nNroDoc',0})
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aP3,{'aMezIso',aMezIso})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		    'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		    '. A¥O: <cAnoUsr>'))                  // T¡tulo Uno
       AADD(aTitIso,'MOVIMIENTOS POR CONCEPTOS')          // T¡tulo Dos
       AADD(aTitIso,'INCONSISTENCIAS')                    // T¡tulo Tres
       AADD(aP3,{'aTitIso',aTitIso})
     *ÀT¡tulos del Informe por defecto

       AADD(aP3,{'cPiePag',CAR->cPiePagCar})
     *ÀPie de p gina por defecto

       aPieIso := {}
       AADD(aPieIso,'')  // Pie de p gina Uno
       AADD(aPieIso,'')  // Pie de p gina Dos
       AADD(aPieIso,'')  // Pie de p gina Tres
       AADD(aP3,{'aPieIso',aPieIso})
     *ÀPies de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aP3,{'aObsIso',aObsIso})
     *ÀObservaciones

       AADD(aP3,{'cUsrIso',CAR->cUsrIsoCar})
     *ÀUsuario del Iso

       AADD(aP3,{'oBrowse',oBrowse})
     *ÀBrowse del Archivo
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       AADD(aP3,{'FilePrn','errext'})
       AADD(aP3,{'cOpcPrn',CAR->cOpcPrnCar})
       AADD(aP3,{'nCodXsl',CAR->nCodXslCar})
       AADD(aP3,{'nOpcPrn',nOpcPrn})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,12)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,06)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,80)
       AADD(aTitPrn,'OBSERVACION')

       AADD(aP3,{'aNroCol',aNroCol})
       AADD(aP3,{'aTitPrn',aTitPrn})

       aCabSec := {}
       AADD(aP3,{'aCabSec',aCabSec})
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL INFORME
       AADD(aP3,{'aTotReg',aTotErr})
       InfPrn00(aP1,aP2,aP3)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: VALIDACION DE LAS TRANSACIONES DEL EXTRACTO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 20/2008 MAR A
       Bucaramanga, Colombia        INICIO: 10:00 AM   MAY 20/2008 MAR

OBJETIVOS:

1- Permite validar las transaciones del extracto para determinar que
   registros no se pueden descriminar por conceptos.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aValTraExt(aP1,aP2,aP3,cNroMes)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       cNroMes                              // Mes del Extracto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayAlu := .F.                 // .T. Hay Estudiante
       LOCAL nHayErr := 0                   // Hay Error

       LOCAL aTotErr := {}                  // Registros inconsistentes
       LOCAL aRegErr := {}                  // Registro Error
       LOCAL aValErr := {1,3}               // Campos a Validar

       LOCAL nMesIni := 0                   // Mes Inicial del Pago
       LOCAL nMesFin := 0                   // Mes Final del Pago

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR TRANSACIONES
       SELECT TRA
       TRA->(DBGOTOP())
       DO WHILE .NOT. TRA->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REFERENCIA: '+TRA->cCodRefTra+'º'+;
			'MOVIMIENTOS: '+STR(TRA->(RECNO()),5)+'/'+;
					STR(TRA->(RECCOUNT()),5),;
					cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DEL RECIBO
	       nMesIni := VAL(SUBS(TRA->cCodRefTra,7,2))
	       nMesFin := VAL(SUBS(TRA->cCodRefTra,9,2))
	    cCodigoTes := SUBS(TRA->cCodRefTra,1,6)
**********FIN ANALISIS DEL RECIBO

**********BUSQUEDA DEL ESTUDIANTE
	    nHayErr := 0
	    lHayAlu := .F.
	    IF TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2 .OR.;
	       TRA->nCodigoCmv == 3 .OR. TRA->nCodigoCmv == 4

	       lHayAlu := lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct,.F.)
	       IF !lHayAlu

		  nHayErr := TRA->nCodigoCmv

		  aRegErr := {TRA->cCodRefTra,'','NO EXISTE'}
		  ValRegArr(@aTotErr,aRegErr,aValErr)

	       ENDIF

	    ENDIF
**********FIN BUSQUEDA DEL ESTUDIANTE

**********LOCALIZACION PAGO DE LA MATRICULA
	    IF EMPTY(nHayErr) .AND. TRA->nCodigoCmv == 4

	       SELECT PMT
	       PMT->(DBGOTOP())
	       LOCATE FOR PMT->cMatricPag == '1'        .AND.;
			  PMT->cCodigoEst == cCodigoTes .AND.;
			  PMT->nMesIniPag == nMesIni    .AND.;
			  PMT->nMesFinPag == nMesFin

	       IF .NOT. PMT->(FOUND())

		  aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
			      'NO EXISTE EL PAGO DE LA MATRICULA'}
		  ValRegArr(@aTotErr,aRegErr,aValErr)

		  nHayErr := TRA->nCodigoCmv

	       ENDIF

	    ENDIF
**********FIN LOCALIZACION PAGO DE LA MATRICULA

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    IF EMPTY(nHayErr) .AND.;
	       (TRA->nCodigoCmv == 1 .OR.;
		TRA->nCodigoCmv == 2 .OR.;
		TRA->nCodigoCmv == 3)

	       FileCli := cPatSis+'\CLIENTES\CL'+;
				  &cMaeAct->cCodigoGru+cAnoSis+ExtFile

	       FilePag := cPatSis+'\PAGOS\PA'+;
				  &cMaeAct->cCodigoGru+cAnoSis+ExtFile
	    ENDIF
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF EMPTY(nHayErr) .AND.;
	       (TRA->nCodigoCmv == 1 .OR.;
		TRA->nCodigoCmv == 2 .OR.;
		TRA->nCodigoCmv == 3)

	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		  aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
			      'ABRIENDO ARCHIVO DE CLIENTES Y PAGOS'}
		  ValRegArr(@aTotErr,aRegErr,aValErr)

		  CloseDbf('CLI')
		  CloseDbf('PAG')

		  nHayErr := TRA->nCodigoCmv

	       ENDIF

	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL PAGO DEL RECIBO
	    IF EMPTY(nHayErr) .AND.;
	       (TRA->nCodigoCmv == 1 .OR.;
		TRA->nCodigoCmv == 2)

	       IF .NOT. lLocCodPag(cCodigoTes,nMesIni,.F.)

		  aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
			      'NO EXISTE EN PAGOS DEL GRUPO'}
		  ValRegArr(@aTotErr,aRegErr,aValErr)

		  CloseDbf('CLI')
		  CloseDbf('PAG')

		  nHayErr := TRA->nCodigoCmv

	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL PAGO DEL RECIBO

**********LOCALIZACION DEL ABONO EN DESCUENTOS
	    IF EMPTY(nHayErr) .AND. TRA->nCodigoCmv == 3

	       SELECT DES
	       DES->(DBGOTOP())

	       LOCATE FOR DES->nTipDesDes == TRA->nCodigoCmv .AND.;
			  !DES->lDesEfeDes                   .AND.;
			  DES->cCodigoEst == cCodigoTes	 .AND.;
			  DES->nNroMesDes == nMesFin         .AND.;
			  DES->dFechaDes  == TRA->dFechaTra  .AND.;
			  DES->nValorDes  == TRA->nValorTra


	       IF .NOT. DES->(FOUND())

		  aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
			      'NO EXISTE EN DESCUENTOS EL '+;
			      'ABONO APLICADO '+TRA->cCodRefTra}
		  ValRegArr(@aTotErr,aRegErr,aValErr)

		  nHayErr := TRA->nCodigoCmv

	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL ABONO EN DESCUENTOS

**********LOCALIZACION DEL PAGO DEL ABONO
	    IF EMPTY(nHayErr) .AND. TRA->nCodigoCmv == 3

	       IF .NOT. lLocCodPag(cCodigoTes,nMesFin,.F.)

		  aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
			      'NO EXISTE EN PAGOS EL ABONO APLICADO '+;
			      TRA->cCodRefTra}
		  ValRegArr(@aTotErr,aRegErr,aValErr)

		  CloseDbf('CLI')
		  CloseDbf('PAG')

		  nHayErr := TRA->nCodigoCmv

	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL PAGO DEL ABONO

**********VALIDACION DEL ABONO
	    IF VAL(cNroMes) # MONTH(TRA->dFechaTra)

	       aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
			   'MES DEL EXTRACTO='+;
			   cMes(VAL(cNroMes),3)+' '+;
			   'MES DE LA TRANSACION='+;
			   cMes(MONTH(TRA->dFechaTra),3)+' '+;
			   'NO COINCIDEN'}
	       ValRegArr(@aTotErr,aRegErr,aValErr)

	    ENDIF
**********FIN VALIDACION DEL ABONO

	  TRA->(DBSKIP())

       ENDDO
       RETURN aTotErr
*>>>>FIN RECORRIDO POR TRANSACIONES