/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : CONSULTAS
SUBMODULO...: PAGOS ESTUDIANTES

**************************************************************************
* TITULO..: MENU DE PAGOS DE ESTUDIANTES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 07:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Visualiza un men£ de pagos de estudiantes

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_304(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

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

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus  := {}
       AADD(aMenus,"1<POR CODIGO>")
       AADD(aMenus,"2<POR GRUPOS>")

       aAyuda  := {}
       AADD(aAyuda,'Imprime los pagos por c¢digo.')
       AADD(aAyuda,'Imprime los pagos por grupos.')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,;
			   NIL,NIL,nNroOpc,.F.)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       Carte_341(aParam1,aParam2,aParam3)
	      *Pagos por Estudiante.

	  CASE nNroOpc == 2
	       Carte_342(aParam1,aParam2,aParam3)
	      *Pagos por Grupos

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: PAGOS POR CODIGO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 11:30 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Imprime el Estado de Cuenta del Estudiante por c¢digo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_341(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL bMarco  := NIL                 // Code Block del Marco
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cTxtMar := ''                  // Mensaje Temporal

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

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

*>>>>IMPRESION DE LOS ENCABEZADOS
       bMarco := {||nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DEL '+;
				     'ESTUDIANTE',22,'°')}
       nNroFil := EVAL(bMarco)

       aTamCol := {06,06,02,30}
       aTitulo := {'CODIGO','CURSO ','No','NOMBRE'}
       cTxtMar := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cTxtMar
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>RECORRIDO POR CODIGO
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECCION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO CLIENTES EN '+cPatSis)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP
	    ENDIF
**********FIN SELECCION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
		 CloseDbf('CLI',FileCli,nModCry)
		 CloseDbf('PAG',FilePag,nModCry)
		 LOOP

	    CASE PAG->(RECCOUNT()) == 0
		 cError('NO EXISTEN PAGOS GRABADOS')
		 CloseDbf('CLI',FileCli,nModCry)
		 CloseDbf('PAG',FilePag,nModCry)
		 LOOP
	    ENDCASE
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********PREGUNTA DE DECISION
	    @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY STR(CLI->(RECNO()),2)
	    @ nNroFil,aNroCol[4] SAY cNombreTes
	    IF !lPregunta('DESEA CONTINUAR? Si No')
	       RESTSCREEN(nNroFil,0,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
	    nNroFil := Fila(nNroFil+1,bMarco,,cTxtMar)
**********FIN PREGUNTA DE DECISION

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodigo('cCodigoEst','CLI',cCodigoTes)
	       cError(RTRIM(cNombreTes)+' NO EXISTE EN LOS '+;
		      'CLIENTES DEL GRUPO: '+&cMaeAct->cCodigoGru)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********FILTRACION DE LOS PAGOS
	    SELECT PAG
	    SET FILTER TO PAG->cCodigoEst == cCodigoTes
	    PAG->(DBGOTOP())
	    IF PAG->(EOF())
	       SET FILTER TO
	       cError('NO EXISTEN PAGOS PARA EL CODIGO '+cCodigoTes)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LOS PAGOS

**********IMPRESION DEL ESTADO DE CUENTA
	    PrnCtaCli(cNomSis,cNomEmp,cNomUsr,cAnoUsr,cJorTxt,;
		      cCodigoTes,cNombreTes,;
		      &cMaeAct->cCodigoGru,CLI->(RECNO()))
	    SELECT PAG
	    SET FILTER TO
**********FIN IMPRESION DEL ESTADO DE CUENTA

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO POR CODIGO

/*************************************************************************
* TITULO..: IMPRESION DEL ESTADO DE CUENTA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 01:00 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Imprime el Estado de Cuenta del Cliente

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnCtaCli(cNomSis,cNomEmp,cNomUsr,cAnoUsr,;
		   cJorTxt,cCodEst,cNomEst,cCodGru,nNroLis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       cCodEst                              // C¢digo del Estudiante
       cNomUsr                              // Nombre del Usuario
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       nNroLis                              // N£mero de Lista */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nDeuAct := 0                   // Deuda Actual
       LOCAL nMorAct := 0                   // Mora Actual
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nTotPag := 0                   // Total Pagado
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Saldo de la Mora
     *ÀTemporales de Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 50+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'ESTADO DE CUENTA. A¥O: '+cAnoUsr+'.JORNADA: '+cJorTxt,;
		   cNomEst,;
		   'CODIGO: '+cCodEst+' GRUPO:'+cCodGru+'-'+STR(nNroLis,2),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {08,12,12,12,12,06,12,12,12,12,12}
       aTitulo := {'MES',;
		   'DEUDA ANT',;
		   'MORA ANT',;
		   'VALOR MES',;
		   'VLR A PAGAR',;
		   'ESTADO',;
		   'F.DE PAGO',;
		   'VLR PAGADO',;
		   'SDO ACTUAL',;
		   'FECHA OPO',;
		   'FECHA EXT'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL ESTADO DE CUENTA
       lPrnBodCta(cCodEst,aNroCol,nColCab,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DEL CUERPO DEL ESTADO DE CUENTA

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALOR DE LA FORMA DE PAGO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 04:00 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Calcula el valor pagado o el saldo actual de un solo mes de acuerdo
   a la forma de pago.

2- Se debe estar ubicado en el registro de pagos respectivo.

3- Retorna los valores respectivos.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VlrFormaPag(nVlrPag,nVlrInt,nDeuAct,nMorAct,nSdoAct,nFacMes)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrPag                              // @Valor Pagado
       nVlrInt                              // @Intereses del mes
       nDeuAct                              // @Deuda Actual
       nMorAct                              // @Mora Actual
       nSdoAct                              // @Saldo Actual
       nFacMes                              // Facturaci¢n del Mes */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lMesAct := .T.                 // Mes Actual
       LOCAL nPagMes := 0                   // Pagos del Mes

       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n

       LOCAL aRegEst := {}                  // Valor del Estudiante
       LOCAL nIntCob := 0                   // Intereses por Cobrar
       LOCAL nDeuInt := 0                   // Deuda Anterior para calcular los intereses por cobrar
       LOCAL nAboDes := 0                   // Abonos Descuentos
       LOCAL nAboMes := 0                   // Abonos del Mes
       LOCAL nAboFin := 0                   // Total Abonos de fin de mes
       LOCAL nOtrFin := 0                   // Total Abonos otros meses de fin de mes
       LOCAL cAnoUsr := ''
       LOCAL nAboOtr := 0                   // Abonos otros Meses
       LOCAL nDesFin := 0                   // Total Abonos Descuentos de fin de mes
       LOCAL nDesMes := 0                   // Total de Abonos como Descuentos
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES EL MES ACTUAL
       lMesAct := .T.
       IF PAG->nMesIniPag < LEN(RTRIM(CLI->cMesPagCli))
	  lMesAct := .F.
       ENDIF
*>>>>FIN ANALISIS SI ES EL MES ACTUAL

*>>>>LOCALIZACION DEL ABONO
       nDeuInt := 0
       nAboDes := 0
       SELECT DES
       GO TOP
       LOCATE FOR DES->cCodigoEst == CLI->cCodigoEst .AND.;
		  DES->nTipDesDes == 3

       IF DES->(FOUND())

**********TOTALIZACION DE LOS ABONOS
	    nAboMes += nVlrAbo(CLI->cCodigoEst,cAnoUsr,;
			       PAG->nMesIniPag,@nDeuInt,;
			       @nAboOtr,@nAboDes,;
			       @nAboFin,@nOtrFin,@nDesFin,;
			       lPrnFec,dFecPrn,aRegEst)
	    nDesMes += nAboDes
**********FIN TOTALIZACION DE LOS ABONOS

**********DEUDA ANTERIOR
	    nDeuAnt += PAG->nSdAbonPag
	    nMorAnt += PAG->nMoAbonPag
**********FIN DEUDA ANTERIOR

       ELSE

***********DEUDA ANTERIOR
	    nDeuAnt += PAG->nSdoAntPag
	    nMorAnt += PAG->nMorAntPag

	    IF PAG->nMesAmnPag == PAG->nMesIniPag
	       nDeuInt := nVlrMes()
	    ELSE
	       nDeuInt := PAG->nSdoAntPag+nVlrMes()
	    ENDIF
***********FIN DEUDA ANTERIOR

       ENDIF
*>>>>FIN LOCALIZACION DEL ABONO

*>>>>CALCULO DE LOS INTERESES
       nFacMes := nVlrMes()
       nVlrInt := nIntMes(nFacMes)
       nIntCob := nIntMes(nDeuInt)
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DE LA FORMA DE PAGO
       nVlrPag := 0
       nDeuAct := 0
       nMorAct := 0
       nSdoAct := 0

       DO CASE
       CASE PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'

************INTERESES POR PAGO EXTEMPORANEO
	      nVlrPag := PAG->nVlrPagPag
	      IF PAG->cEstadoPag == 'A'
		 nVlrPag += nVlrInt
		 nFacMes += nVlrInt
	      ENDIF
************FIN INTERESES POR PAGO EXTEMPORANEO

************ANALISIS DE LA AMNISTIA
	      IF PAG->nMesAmnPag # 0  // Si Hay Amnistia
		 nDeuAct := IF(lMesAct,CLI->nSdoActCli,PAG->nSdoAntPag)
		 nMorAct := IF(lMesAct,CLI->nSdoMorCli,PAG->nMorAntPag)
		 nSdoAct := nDeuAct+nMorAct
	      ENDIF
************FIN ANALISIS DE LA AMNISTIA

       CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

	    IF PAG->cEstadoPag = 'D'

	       nFacMes += nVlrInt+nIntCob

*--------------ANALISIS DEL RECIBO POR ADELANTADO
		 IF PAG->nMesIniPag == PAG->nMesFinPag
		    nPagMes := PAG->nVlrPagPag
		 ELSE
		    nPagMes := PAG->nSdoAntPag+PAG->nMorAntPag+;
			       PAG->nVlrMesPag
		 ENDIF
*--------------FIN ANALISIS DEL RECIBO POR ADELANTADO

*--------------ANALISIS DE LA AMNISTIA
		 IF PAG->nMesAmnPag == 0  // No Hay Amnistia
		    nDeuAct := nPagMes
		    nMorAct := nVlrInt
		    nSdoAct := nDeuAct+nMorAct
		 ELSE
		    IF lMesAct
		       nSdoAct := CLI->nSdoActCli
		       nMorAct := CLI->nSdoMorCli
		    ELSE
		       nSdoAct := PAG->nSdoAntPag+nPagMes
		       nMorAct := PAG->nMorAntPag+nVlrInt
		    ENDIF
		    nSdoAct := nDeuAct+nMorAct
		 ENDIF
*--------------FIN ANALISIS DE LA AMNISTIA

	    ELSE

*--------------ANALISIS DEL DEUDOR
		 nDeuAct := IF(lMesAct,CLI->nSdoActCli,PAG->nSdoAntPag)
		 nMorAct := IF(lMesAct,CLI->nSdoMorCli,PAG->nMorAntPag)
		 nSdoAct := nDeuAct+nMorAct
*--------------FIN ANALISIS DEL DEUDOR

	    ENDIF

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE LA FORMA DE PAGO

/*************************************************************************
* TITULO..: IMPRESION DEL CUERPO DEL ESTADO DE CUENTA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Imprime el Cuerpo del Estado de Cuenta del Cliente

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnBodCta(cCodEst,aNroCol,nColCab,bPagina,bDerAut,bCabeza)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       aNroCol                              // N£mero de Columna
       nColCab                              // Columna del encabezado
       bPagina                              // Block de P gina
       bCabeza                              // Block de Encabezado
       bDerAut                              // Block Derechos de Autor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n

       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nDeuAct := 0                   // Deuda Actual
       LOCAL nMorAct := 0                   // Mora Actual
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nTotPag := 0                   // Total Pagado
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL aTotCon := {}                  // Total Por Conceptos
       LOCAL aRegPag := {}                  // Registro de Pagos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS PAGOS
       aRegPag := aRegPagos(PAG->cCodigoEst)
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********ANALISIS DE LA FORMA DE PAGO
	    nVlrPag := 0
	    nVlrInt := 0
	    nDeuAct := 0
	    nMorAct := 0
	    nSdoAct := 0
	    VlrFormaPag(@nVlrPag,@nVlrInt,@nDeuAct,@nMorAct,@nSdoAct)
	    nTotPag += nVlrPag
**********FIN ANALISIS DE LA FORMA DE PAGO

**********IMPRESION DE LOS PAGOS
	    aTitulo := {cMes(PAG->nMesIniPag,3)+'-'+cMes(PAG->nMesFinPag,3),;
			TRANS(PAG->nSdoAntPag,'####,###,###'),;
			TRANS(PAG->nMorAntPag,'####,###,###'),;
			TRANS(PAG->nVlrMesPag,'####,###,###'),;
			TRANS(PAG->nVlrPagPag,'####,###,###'),;
			PAG->cEstadoPag,;
			cFecha(PAG->dFecPagPag,3),;
			TRANS(nVlrPag,'####,###,###'),;
			TRANS(nSdoAct,'####,###,###'),;
			cFecha(PAG->dPagOpoPag,3),;
			cFecha(PAG->dPagExtPag,3)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DE LOS PAGOS

**********IMPRESION DEL PAGO POR CONCEPTOS
	    aVlrCon := {}
	    lHayErr := !lVlrConRec(aVlrCon)

	    IF .NOT. EMPTY(aVlrCon)

	       PrnConVlr(01,bPagina,bDerAut,bCabeza,aVlrCon,3)
	       SumArrCon(aTotCon,aVlrCon)

	       IF nSuma(aVlrCon,3) # nVlrPag
		  lPrnReg(00,nColCab,' ERROR',bPagina,bDerAut,bCabeza)
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL PAGO POR CONCEPTOS

**********FILTRACION DE LOS DESCUENTOS,RECARGOS Y ABONOS DEL ESTUDIANTE
	    SELECT DES
	    SET FILTER TO DES->cCodigoEst == cCodEst
	    DES->(DBGOTOP())
	    IF DES->(EOF())
	       SET FILTER TO
	    ENDIF
**********FIN FILTRACION DE LOS DESCUENTOS,RECARGOS Y ABONOS DEL ESTUDIANTE

**********IMPRESION DEL LOS ABONOS
	    IF .NOT. DES->(EOF())
	       SELECT DES
	       DES->(DBGOTOP())
	       DO WHILE .NOT. DES->(EOF())

*-----------------VALIDACION DEL ABONO
		    IF !(DES->nNroMesDes == PAG->nMesIniPag .AND.; // Abono
			 DES->nTipDesDes == 3 .AND. !DES->lDesEfeDes)

			 DES->(DBSKIP())
			 LOOP

		    ENDIF
*-----------------FIN VALIDACION DEL ABONO

*-----------------IMPRESION DEL ABONO
		    aTitulo := {cMes(DES->nNroMesDes,3),;  // Mes
				SPACE(10),;                // DeuAnt
				SPACE(01),;                // MorAnt
				SPACE(01),;                // VlrMes
				SPACE(12),;                // VlrPag
				'ABONO',;                  // Estado
				cFecha(DES->dFechaDes,3),; // FecPag
				TRANS(DES->nValorDes,"####,###,###"),;
				SPACE(12),;                // SdoAct
				SPACE(12),;                // FecOpo
				SPACE(12)}                 // FecExt
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		    nTotPag += DES->nValorDes
*-----------------FIN IMPRESION DEL ABONO

*-----------------DESCRIMINACION DEL ABONO
		    aVlrCon := {}
		    lHayErr := !lVlrConAbo(aVlrCon)
		    PrnConVlr(01,bPagina,bDerAut,bCabeza,aVlrCon,3)
		    SumArrCon(aTotCon,aVlrCon)
*-----------------FIN DESCRIMINACION DEL ABONO

		  DES->(DBSKIP())

	       ENDDO
	    ENDIF
**********FIN IMPRESION DEL LOS ABONOS

	  PAG->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DE LOS PAGOS

*>>>>IMPRESION DEL TOTAL PAGADO
       @ PROW()+1,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])
       @ PROW()+1,nColTxt(aNroCol,08) SAY TRANS(nTotPag,"####,###,###")

       PrnConVlr(01,bPagina,bDerAut,bCabeza,aTotCon,3)
       RETURN !lHayErr
*>>>>FIN IMPRESION DEL TOTAL PAGADO