/*************************************************************************
* TITULO ..: IMPRESION POR TIPO DE TRANSACCION                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 17/99 JUE A
       Bucaramanga, Colombia        INICIO: 09:50 PM   JUN 17/99 JUE

OBJETIVOS:

1- Imprime los movimientos por tipo de transacci¢n

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra055(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del Dia */
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
       LOCAL cNalias := ''                  // Alias del Maestro

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cCodigo := ''                  // C¢digo del tipo de Transacci¢n
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN MOVIMIENTOS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF EMPTY(cNroDia)
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ELSE
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>INDEXACION DEL ARCHIVO
       IF !FILE(cPatSis+'\MODEM\'+fNtxTra)

	  SELECT TRA
	  INDEX ON TRA->cCodigoEst;
		TO &(cPatSis+'\MODEM\'+fNtxTra)

       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>LECTURA DEL CODIGO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       cCodigo := cSpaces('TRA','cCodigoTra')
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '@!';
			 VALID lValidaTmv(ROW(),COL()-1,@cCodigo)
       READ
       IF EMPTY(cCodigo)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL CODIGO

*>>>>ANALISIS DE DECISION
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE N COPIAS
       nCopias := 1
       DO WHILE nNroCop <= nCopias

	  PrnTra05(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		   cMaeAlu,cMaeAct,cNroMes,cNroDia)
	 *Impresi¢n por tipo de transacci¢n.
	  nNroCop++

       ENDDO
       SELECT TRA
       RESTSCREEN(0,0,24,79,cSavPan)
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO ..: IMPRESION DEL MOVIMIENTO POR TIPO TRANSACCION               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 12/95 LUN A
       Bucaramanga,Colombia         INICIO: 11:20 PM   JUN 12/95 LUN

OBJETIVOS:

1- Debe estar en uso los archivos de alumnos habilitados y el archivo
   de transaciones

2- Imprime la relaci¢n de los pagos efectuados por codigo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTra05(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		  cMaeAlu,cMaeAct,cNroMes,cNroDia)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       cNroMes                              // N£mero del mes
       cNroDia                              // N£mero del D¡a */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
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
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
     *ÀVariables de informe

       LOCAL cTitDos := ''                 // T¡tulo dos del informe
       LOCAL lAnoAct := .T.                // .T. A¤o Actual
       LOCAL nNumero := 0                  // N£mero de registros
       LOCAL cMesPag := ''                 // Meses de pago
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables Espec¡ficas

       LOCAL cNombreTes := ''              // Nombre del Estudiante
       LOCAL cCodigoTgr := ''              // C¢digo del grupo

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables temporales de Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'MOVIMIENTOS DEL MES DE '+cMes(VAL(cNroMes))+;
		   IF(EMPTY(cNroDia),'',' DIA:'+cNroDia)+;
		   '. A¥O: '+cAnoUsr,;
		   ALLTRIM(TMV->cNombreTmv),;
		   'Nota: La confiabilidad depende del Cajero',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,32,04,04,12,08,12,50}
       aTitulo := {'Nro.',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES ',;
		   'GRU.',;
		   'TRAN',;
		   'TOTAL PAGADO',;
		   'MESES.FA',;
		   'FECHA.PAGO',;
		   'OBSERVACION '}
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
	  FilePrn := 'MvtoTra'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.T.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT TRA
       GO TOP
       DO WHILE .NOT. EOF()

	  nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
	  nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO: '+STR(TRA->(RECNO()),5)+'/'+;
				     STR(TRA->(RECCOUNT()),5)+'º'+;
			'CODIGO: '+TRA->cCodigoEst,cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DEL CODIGO DE LA TRANSACCION
	    IF TRA->cCodigoTra # TMV->cCodigoTra
	       SELECT TRA
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO DE LA TRANSACCION

**********LOCALIZACION O BUSQUEDA DEL ESTUDIANTE
	    IF !lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       IF lLocCodigo('cCodigoEst','ADM',TRA->cCodigoEst)
		  cNombreTes := RTRIM(ADM->cApelliEst)+' '+;
				RTRIM(ADM->cNombreEst)
		  cCodigoTgr := ADM->cCodigoGru
	       ELSE
		  cNombreTes := 'POR FAVOR REVISAR? '
		  cCodigoTgr := SPACE(04)
	       ENDIF
	    ELSE
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	       cCodigoTgr := &cMaeAct->cCodigoGru
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(31),1,31)
**********FIN LOCALIZACION O BUSQUEDA DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cMesPag := STR(nMesIniTtr,2)+'/'+;
		       STR(nMesFinTtr,2)
	    cMesPag := SUBS(cMesPag,1,8)
	    aTitulo := {STR(++nNumero,4),;
			TRA->cCodigoEst,;
			SPACE(01)+cNombreTes,;
			cCodigoTgr,;
			SPACE(01)+TRA->cCodigoTra,;
			TRANS(TRA->nValorTra,"#####,###.99"),;
			cMesPag,;
			cFecha(TRA->dFechaTra),;
			SPACE(50)}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

	  SELECT TRA
	  TRA->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS