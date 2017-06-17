/*************************************************************************
* TITULO ..: IMPRESION DE PAGOS POR OFICINA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2007 MIE A
       Bucaramanga, Colombia        INICIO: 03:55 PM   SEP 03/2007 MIE

OBJETIVOS:

1- Permite imprimir la relaci¢n de los pagos efectuados por oficina
   del estudiante.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra099(aParam1,aParam2,aParam3,;
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

       LOCAL nTotReg := 0                   // Total de registros
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cTitDos := ''                  // T¡tulo dos para el informe
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna

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

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

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
	    RETURN NIL
       ENDCASE
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

/*
*>>>>INDEXACION DEL ARCHIVO
       IF !FILE(cPatSis+'\MODEM\'+fNtxTra)

	  SELECT TRA
	  INDEX ON TRA->cCodigoEst;
		TO &(cPatSis+'\MODEM\'+fNtxTra)

       ENDIF
*>>>>FIN INDEXACION DEL ARCHIVO
*/

/*
*>>>>MENSAJE PARA EL LISTADO
       IF EMPTY(cNroDia)
	  SET CURSOR ON
	  cTitDos := SPACE(40)
	  TitBuscar(LEN(cTitDos),@nNroFil,@nNroCol,;
		    'DIGITE EL TITULO PARA EL INFORME:',;
		    'POR FAVOR')
	  DO WHILE .T.
	     @ nNroFil,nNroCol GET cTitDos PICT '@!'
	     READ
	     IF EMPTY(cTitDos)
		LOOP
	     ENDIF

	     IF !lPregunta('DESEA CORREGIR? No Si')
		EXIT
	     ENDIF
	  ENDDO
	  SET CURSOR OFF
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDIF
*>>>>MENSAJE PARA EL LISTADO
*/

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE N COPIAS
       nCopias := 1
       DO WHILE nNroCop <= nCopias

	  PrnTra09(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		   cPatSis,cMaeAlu,cTitDos,cMaeAct,;
		   cNroMes,cNroDia)
	 *Impresi¢n gerencia electr¢nica por c¢digo

	  nNroCop++

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION GERENCIA ELECTRONICA POR CODIGO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2007 MIE A
       Bucaramanga, Colombia        INICIO: 04:00 PM   SEP 03/2007 MIE

OBJETIVOS:

1- Debe estar en uso los archivos de alumnos habilitados y el archivo
   de transaciones

2- Imprime la relaci¢n de los pagos efectuados por oficina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTra09(cNomEmp,cNomSis,cNomUsr,cAnoUsr,cPatSis,;
		  cMaeAlu,cTitulo,cMaeAct,cNroMes,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del Sistema
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       cTitulo                              // T¡tulo dos para el informe
       cMaeAct                              // Maestro Actual
       cNroMes                              // N£mero del mes
       cNroDia                              // N£mero del D¡a */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
*       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima

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
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registros de Impresion
     *ÀVariables de informe

       LOCAL cTitDos := ''                 // T¡tulo dos del informe
       LOCAL lAnoAct := .T.                // .T. A¤o Actual
       LOCAL nNumero := 0                  // N£mero de registros
       LOCAL cMesPag := ''                 // Meses de pago
       LOCAL nVlrCre := 0                  // Valor Credito
       LOCAL nVlrDeb := 0                  // Valor Debito
       LOCAL nTotCre := 0                  // Total Creditos
       LOCAL nTotDeb := 0                  // Total Debitos
       LOCAL Getlist := {}                 // Variable del sistema
     *ÀVariables Espec¡ficas

       LOCAL cNombreTes := ''              // Nombre del Estudiante
       LOCAL cObservTtr := ''              // Observaci¢n de la Transaci¢n

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables temporales de Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       cTitDos := 'REGISTROS POR CLASIFICAR'

       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'MOVIMIENTOS DEL MES DE '+cMes(VAL(cNroMes))+;
		   IF(EMPTY(cNroDia),'',' DIA:'+cNroDia)+;
		   '. A¥O: '+cAnoUsr,;
		   cTitDos,;
		   'Nota: La confiabilidad depende del Banco',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,12,04,12,12,12,12,12,40}
       aTitulo := {'Nro.',;
		   'REFERENCIA',;
		   'TRAN',;
		   'CREDITOS',;
		   'DEBITOS',;
		   'FECHA.PAGO',;
		   'OFICINA',;
		   'DOCUMENTO',;
		   'OBSERVACION '}
       cCabCol := cRegPrint(aTitulo,aNroCol)
       aCamXml := aTitulo
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
	  FilePrn := IF(VAL(cNroMes)==13,'MESXMV','DIAX')+cNroMes+cNroDia
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.T.,,,PathDoc)
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

**********ANALISIS DE DECISION
	    IF TRA->nCodigoCmv # 0
	       SELECT TRA
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS DE LA OBSERVACION
	    cObservTtr := TRA->cObservTra
	    IF TRA->nValidaTra # 0
		 cObservTtr := ALLTRIM(cObservTtr)+' PROCESADO'
	    ENDIF
	    cObservTtr := SUBS(cObservTtr+SPACE(40),1,40)
**********FIN ANALISIS DE LA OBSERVACION

**********ANALISIS DE LOS MESES FACTURADOS
	    cMesPag := ''
	    IF nMesIniTtr >= 1 .AND. nMesIniTtr <= 12 .AND.;
	       nMesFinTtr >= 1 .AND. nMesFinTtr <= 12

	       cMesPag := cMes(nMesIniTtr,3)+'-'+;
			  cMes(nMesIniTtr,3)

	    ELSE
	       cMesPag := STR(nMesIniTtr,2)+'-'+;
			  STR(nMesFinTtr,2)
	    ENDIF
	    cMesPag := SUBS(cMesPag,1,8)
**********FIN ANALISIS DE LOS MESES FACTURADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    cNombreTes := cNomEstTra(TRA->cCodigoEst,cMaeAlu,36)
	    cNombreTes := SUBS(cNombreTes+SPACE(35),1,35)

	       nVlrCre := nValorTra(1)
	       nVlrDeb := nValorTra(2)

	       nTotCre += nVlrCre
	       nTotDeb += nVlrDeb

	    aTitulo := {STR(++nNumero,4),;
			TRA->cCodRefTra,;
			SPACE(01)+TRA->cCodigoTra,;
			TRANS(nVlrCre,"#####,###.99"),;
			TRANS(nVlrDeb,"#####,###.99"),;
			cFecha(TRA->dFechaTra),;
			SUBS(TRA->Registro,BAN->nPosOfiBan,BAN->nLenOfiBan),;
			SUBS(TRA->Registro,BAN->nPosTalBan,BAN->nLenTalBan),;
			cObservTtr}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    AADD(aTitulo,'') // Campo Url
	    AADD(aRegXml,aTitulo)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

	  SELECT TRA
	  TRA->(DBSKIP())

       ENDDO
       aTitulo := {'','',REPL('*',46),'','','','',REPL('*',40)}
       AADD(aTitulo,'') // Campo Url
       AADD(aRegXml,aTitulo)
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DE TOTALES
       cTxtPrn := REPL('-',aNroCol[04])
       lPrnReg(01,nColTxt(aNroCol,04),cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := REPL('-',aNroCol[05])
       lPrnReg(00,nColTxt(aNroCol,05),cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := 'TOTALES ...'
       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := TRANS(nTotCre,"####,###,###")
       lPrnReg(00,nColTxt(aNroCol,04),cTxtPrn,bPagina,bDerAut,bCabeza)

       cTxtPrn := TRANS(nTotDeb,"####,###,###")
       lPrnReg(00,nColTxt(aNroCol,05),cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DERECHOS

*>>>>EXPORTACION AL ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{PAGOS}{BANCO}'+;
	    IF(EMPTY(cNroDia),'{MOVIMIENTO FACTURACION}',;
			      '{MOVIMIENTO DIARIO}'))
      *Nombre del Sistema

       AADD(aCabXml,'MOVIMIENTOS DEL MES DE '+cMes(VAL(cNroMes))+;
		    IF(EMPTY(cNroDia),'',' DIA:'+cNroDia)+;
		    '. A¥O: '+cAnoUsr)
      *Titulo No. 1

       AADD(aCabXml,cTitDos)
      *Titulo No. 2

       AADD(aCabXml,'Nota: La confiabilidad depende del Banco')
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       FileXml(cPatSis+'\FILEWWW\FACT'+cMes(VAL(cNroMes),3)+'\'+;
	       IF(EMPTY(cNroDia),;
		  'MVT'+cMes(VAL(cNroMes),3)+cNroDia+cAnoSis,;
		  'MV'+cNroMes+cNroDia+cAnoSis)+'.XML',;
	       aRegXml,aCamXml,aCabXml)
     *ÀCreaci¢n del Archivo

       RETURN NIL
*>>>>FIN EXPORTACION AL ARCHIVO