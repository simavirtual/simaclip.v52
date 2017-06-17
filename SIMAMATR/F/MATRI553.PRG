/* SIMA - MATRICULA ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: PAGOS        MODULO No. 503

**************************************************************************
* TITULO..: PAGOS POR ALUMNOS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   DIC 03/96 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza el men£ para la impresi¢n de la relaci¢n de pagos

2- Ejecuta las funciones para la impresi¢n de la relaci¢n de pagos

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_553(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus	                    // Vector de declaracion de men£
       LOCAL aAyuda                         // Vector de ayudas para el men£
       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas

       LOCAL cMatricTpa := ''               // '1'->Matr¡cula '0'->Pensi¢n
       FIELD cCodigoGru                     // C¢digo del grupo
       FIELD cApelliEst                     // Apellido del Estudiante
     *ÀVariables de Campos
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePag,'PAG',cPatSis+'\'+fNtxPag,lShared)
	  cError('ABRIENDO LOS ARCHIVOS MAESTRO Y NIVELES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO APARECEN MATRICULAS REGISTRADAS')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CONCEPTOS GRABADOS')

       CASE PAG->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS PAGOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>TIPO DE CONCEPTO PENSION O MATRICULA
       cMatricTpa := '0'
       IF nLeeOpcion('ESCOJA EL CONCEPTO: '+;
		     '1<MATRICULA> 2<PENSION>?',2,'1') == 1
	  cMatricTpa := '1'
       ENDIF
*>>>>FIN TIPO DE CONCEPTO PENSION O MATRICULA

*>>>>FILTRACION DE LOS PAGOS
       SELECT PAG
       IF cMatricTpa == '1'
	  SET FILTER TO PAG->cMatricPag == '1'
       ELSE
	  SET FILTER TO PAG->cMatricPag == '0'
       ENDIF
       GO TOP
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn = SUBS(MTR->cSerFacMtr,1,1)+'pago'+cMaeAct
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>INDEXACION DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'ORDENANDO POR APELLIDO')
       Termometro(50)
       SELECT &cMaeAct
       fNtxTem := cFileTempo('',SUBS(cNomUsr,1,4),cExtNtx)
       INDEX ON cCodigoGru+cApelliEst;
	     TO &fNtxTem
       IF lShared
	  DBSETINDEX(fNtxTem)
       ELSE
	  SET INDEX TO &fNtxTem
       ENDIF
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<POR GRUPOS >',;
		   '2<POR NIVELES>'}
       aAyuda := {'Imprime la relaci¢n de pagos por grupos',;
		  'Imprime la relaci¢n de pagos por niveles'}

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Matr_5531(aParam1,aParam2,aParam3,;
		      cMatricTpa)
	   *Relaci¢n de pagos por grupos

       CASE nNroOpc == 2
	    Matr_5532(aParam1,aParam2,aParam3,;
		      cMatricTpa)
	   *Relaci¢n de pagos por niveles

       ENDCASE

       VerPrn(nOpcPrn,FilePrn)

       CloseAll()
       lFileDelete(fNtxTem)
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: RELACION DE PAGOS POR ALUMNOS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/95 JUE A
       Bucaramanga, Colombia	    INICIO: 11:55 AM   ENE 25/95 JUE

OBJETIVOS:

1- Deben estar en uso los archivos de Nuevos,Pagos y Conceptos

2- Imprime la relaci¢n de pagos efectuados por pension o matr¡cula

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagosAlu(cNomEmp,cNomSis,cAnoUsr,cMatric,cJorTxt,;
		  cCodGru,cMaeAct,nTotReg,dFecIni,dFecFin)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cMatric                              // 1->Matr¡cula 0->Pensi¢n
       cJorTxt                              // Jornada escogida
       cCodGru                              // C¢digo del grupo
       cMaeAlu                              // Maestros habilitados
       nTotReg                              // Total registros a imprimir
       dFecIni                              // Fecha de Inicial
       dFecFin                              // Fecha de Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       #INCLUDE "CAMPOS\ARC-MATRR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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
     *ÀVariables de informe

       LOCAL       i := 1                   // Contador
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL cTipDes := ''                  // Tipo de descuento
       LOCAL nIntMor := 0                   // Intereses por mora
       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nTotMes := 0                   // Total Facturaci¢n del mes
       LOCAL nTotDeu := 0                   // Total deuda sin intereses
       LOCAL nTotInt := 0                   // Total de intereses
       LOCAL nSdoInt := 0                   // Intereses por cobrar
       LOCAL nTotPag := 0                   // Total de pagos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lFechOk := .T.                 // Fecha de Acuedo al intervalo
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL cConcepTpa := ''               // Conceptos pagados
       LOCAL cEstadoTpa := ''               // Estado del pago
     *ÀVariables temporales de campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL INTERVALO DE FECHAS
       IF ANO->lLeeFecAno .AND. !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)
	  cTxtPrn := ' DE '+cFecha(dFecIni,03)+ ' A '+cFecha(dFecFin,03)
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg += nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'RELACION DE PAGOS FACTURADOS'+cTxtPrn,;
		   'CORRESPONDIENTE A '+IF(cMatric == '1','MATRICULA',;
					'PENSION')+' DE '+cAnoUsr,;
		   'GRUPO: '+cConverNiv(SUBS(cCodGru,1,2))+;
					SUBS(cCodGru,3,2)+;
			   ' JORNADA: '+cJorTxt,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,24,16,12,12,10,12,IF(cMatric == '1',12,8),10,14,06}
       aTitulo := {'No',;
		   'APELLIDOS Y NOMBRES ',;
		   'CONCEPTOS       ',;
		   'SALDO ACTUAL',;
		   'VALOR MES ',;
		   'INTxCOBMes',;
		   'TOTAL DEUDA ',;
		   IF(cMatric == '1','F.FACTUR','MESES.FA'),;
		   'INT PAGMes',;
		   'PAGOS ',;
		   'CODIGO'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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

*>>>>IMPRESION DEL TERMOMETRO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT &cMaeAct
       GO TOP
       DO WHILE .NOT. EOF()

**********ANALISIS DE LA FECHA DE PAGO
	    lHayPag := lSekCodigo(&cMaeAct->cCodigoEst+cMatric,'PAG')
	   *B£squeda del pago

	    lFechOk := .T.
	    IF lHayPag .AND. ANO->lLeeFecAno
	       IF !EMPTY(PAG->dFecpagPag) .AND.;
		  !EMPTY(dFecIni) .AND. !EMPTY(dFecFin)

		  IF PAG->dFecpagPag < dFecIni .OR.;
		     PAG->dFecpagPag > dFecFin
		     lFechOk := .F.
		  ENDIF
	       ELSE
		  IF !EMPTY(PAG->dFecpagPag)
		     lFechOk := .T.
		  ELSE
		     lFechOk := .F.
		  ENDIF
	       ENDIF
	    ENDIF
**********ANALISIS DE LA FECHA DE PAGO

**********ANALISIS DE LA FORMA DE PAGO
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(23),1,23)

	    IF lHayPag
	       DO CASE
	       CASE PAG->cEstadoPag = 'P'
		    IF ANO->lLeeFecAno
		       cEstadoTpa = IF(EMPTY(PAG->dFecPagPag),;
					 '??',;
					 cFecha(PAG->dFecPagPag)+':O')
		    ELSE
		       cEstadoTpa := SPACE(10)
		    ENDIF

	       CASE PAG->cEstadoPag = 'A'
		    IF ANO->lLeeFecAno
		       cEstadoTpa = IF(EMPTY(PAG->dFecPagPag),;
					 '????',;
					 cFecha(PAG->dFecPagPag)+':E')
		    ELSE
		       cEstadoTpa := 'PAGO EXT'
		    ENDIF

	       CASE PAG->cEstadoPag = 'D'
		    cEstadoTpa = IF(ANO->lLeeFecAno,;
					 SPACE(10),'NO PAGO ')

	       OTHERWISE
		    cEstadoTpa = 'ERROR   '
	       ENDCASE

	    ENDIF
**********FIN ANALISIS DE LA FORMA DE PAGO

**********CALCULO DE LOS INTERESES
	    IF PAG->lIntPenPag
	       nVlrInt  := ROUND((PAG->nVlrMesPag*PAG->nIntmorPag)/100,0)
	    ELSE
	       nVlrInt := PAG->nVlrMorPag
	    ENDIF
	    IF lHayPag
               nTotMes += PAG->nVlrMesPag
	    ENDIF
**********FIN CALCULO DE LOS INTERESES

**********CALCULO DE LOS INTERESES ACUMULACION DE PAGOS
	    nSdoAct := 0
	    nIntMor := 0
	    nIntPag := 0
	    IF lHayPag .AND. lFechOk

	       DO CASE
	       CASE PAG->cEstadoPag == 'P' .OR.;
		    PAG->cEstadoPag == 'A'

		    nTotPag += PAG->nVlrPagPag
		    IF PAG->cEstadoPag == 'A'
		       nIntPag := nVlrInt
		       nTotInt += nIntPag
		    ENDIF

	       CASE PAG->cEstadoPag == 'D'
		    nIntMor = nVlrInt
		    nSdoInt += nIntMor
		    nTotDeu += PAG->nVlrPagPag
		    nSdoAct := PAG->nVlrPagPag+nVlrInt
		    nTotSdo += nSdoAct
	       ENDCASE
	    ENDIF
**********FIN CALCULO DE LOS INTERESES

**********LECTURA DEL NOMBRE DEL CONCEPTO
	    DO CASE
	    CASE &cMaeAct->lRetiroEst
		 cConcepTpa := 'R E T I R A D O '

	    CASE !(&cMaeAct->lRetiroEst) .AND. !lHayPag
		 cConcepTpa := 'NO SE FACTURO '

	    CASE !lHayPag
		 cConcepTpa := SPACE(16)

	    CASE lHayPag .AND. lFechOk
		 cConcepTpa := PAG->cConcepPag
		 IF LEN(RTRIM(cConcepTpa)) == 2
		    IF lLocCodigo('cCodigoCon','CON',;
				  SUBS(PAG->cConcepPag,1,2))
		       cConcepTpa := CON->cNombreCon
		    ELSE
		       cConcepTpa := 'NO EXISTE '+SUBS(PAG->cConcepPag,1,2)
		    ENDIF
		 ENDIF

	    CASE lHayPag .AND. !lFechOk
		 cConcepTpa := 'FUERA DE FECHA'
	    ENDCASE
**********FIN LECTURA DEL NOMBRE DEL CONCEPTO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aNroCol := {02,24,16,12,12,10,12,08,10,12,06}
	    aTitulo := {STR(i,2),;
			SPACE(01)+cNombreTes,;
			cConcepTpa,;
			TRANS(nSdoAct,"####,###,###"),;
			IF(lHayPag,;
			   TRANS(PAG->nVlrMesPag,"####,###,###"),SPACE(12)),;
			IF(lHayPag,;
			   TRANS(nIntMor,"@Z ##,###,###"),SPACE(10)),;
			IF(lHayPag .AND. nSdoAct # 0,;
			       TRANS(PAG->nVlrPagPag,"####,###,###"),SPACE(12)),;
			IF(cMatric = '0',;
			   IF(lHayPag,cMes(PAG->nMesIniPag,3),SPACE(03))+'/'+;
			   IF(lHayPag,cMes(PAG->nMesFinPag,3),SPACE(03)),;
			   cFecha(PAG->dFecFacPag)),;
			IF(lHayPag,;
			   TRANS(nIntPag,"@Z ##,###,###"),SPACE(10)),;
			IF(lHayPag,cEstadoTpa,SPACE(12)),;
			&cMaeAct->cCodigoEst}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    SET DEVICE TO SCREEN
	    i++
	    Avance(i,nTotReg)
	    SET DEVICE TO PRINT
	    SELECT &cMaeAct
	    DBSKIP()
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       @ PROW()  ,nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       @ PROW()  ,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,09) SAY REPL('-',aNroCol[09])
       @ PROW()  ,nColTxt(aNroCol,10) SAY REPL('-',aNroCol[10])

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,04) SAY TRANS(nTotSdo,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotMes,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nSdoInt,"##,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotDeu,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,09) SAY TRANS(nTotInt,"##,###,###")
       @ PROW()  ,nColTxt(aNroCol,10) SAY TRANS(nTotPag,"####,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS