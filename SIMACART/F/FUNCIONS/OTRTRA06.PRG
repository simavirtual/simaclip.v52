/*************************************************************************
* TITULO ..: IMPRESION DE PAGOS POR GRUPOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/95 JUE A
       Bucaramanga, Colombia        INICIO: 02:35 PM   JUN 15/95 JUE

OBJETIVOS:

1- Permite imprimir la relaci¢n de los pagos efectuados por grupos

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra066(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del D¡a */
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

       LOCAL nTotReg := 0                   // Total de registros
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cTitDos := ''                  // T¡tulo dos para el informe
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
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

       cMaeAct := cNivelEst(10,25,cMaeAlu)
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)

	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS GRUPOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MENSAJE PARA EL LISTADO
       cSavPan := SAVESCREEN(0,0,24,79)
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
*>>>>MENSAJE PARA EL LISTADO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',;
			 22,NIL,NIL,20,60)
       IF !lIntervGru(nNroFil,21,@nRegIni,@nRegFin)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseDbf('GRU')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

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
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       RESTSCREEN(0,0,24,79,cSavPan)
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT TRA
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       RESTSCREEN(0,0,24,79,cSavPan)
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT TRA
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    PrnTra06(cNomEmp,cNomSis,cNomUsr,cAnoUsr,cMaeAct,;
		     ALLTRIM(cTitDos)+' GRUPO:'+GRU->cCodigoGru,;
		     cNroMes,cNroDia)
	   *Impresi¢n gerencia electr¢nica por c¢digo
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    CloseDbf('CLI',FileCli,nModCry)
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseDbf('GRU')
       CloseDbf('CLI',FileCli,nModCry)
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION GERENCIA ELECTRONICA POR GRUPO       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/95 JUE A
       Bucaramanga,Colombia         INICIO: 03:00 PM   JUN 15/95 JUE

OBJETIVOS:

1- Debe estar en uso los archivos de alumnos habilitados y el archivo
   de transaciones y grupos.

2- Imprime la relaci¢n de los pagos efectuados por grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTra06(cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		  cMaeAct,cTitDos,cNroMes,cNroDia)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cTitDos                              // T¡tulo dos para el informe
       cMaeAct			            // Maestro Actual
       cNroMes                              // N£mero del mes
       cNroDia                              // N£mero del Dia */
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

       LOCAL nNumero := 0                  // N£mero de registros
       LOCAL lHayAlu := .T.                // .T. Existe alumno
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''              // Nombre del Estudiante
       LOCAL cCodigoTgr := ''              // C¢digo del grupo
       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables temporales de campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := CLI->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'MOVIMIENTOS DEL MES DE '+cMes(VAL(cNroMes))+;
		   IF(EMPTY(cNroDia),'',' DIA:'+cNroDia)+;
		   '. A¥O: '+cAnoUsr,;
		   cTitDos,;
		   'Nota: La confiabilidad depende del Cajero',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,06,40,04,12,08,12,12,06,02}
       aTitulo := {'No',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES ',;
		   'TRAN',;
		   'TOTAL PAGADO',;
		   'MESES.FA',;
		   'FECHA.PAGO',;
		   'OBSERVACION ',;
		   'CODIGO',;
		   'No'}
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
	    lHayAlu := lSekCodigo(CLI->cCodigoEst,cMaeAct)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	       cCodigoTgr := &cMaeAct->cCodigoGru
	    ELSE
	       cNombreTes := 'POR FAVOR REVISAR? '
	       cCodigoTgr := SPACE(03)
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aNroCol := {02,06,40,04,12,08,06,12,06,02}
	    aTitulo := {STR(CLI->(RECNO()),2),;
			CLI->cCodigoEst,;
			SPACE(01)+SUBS(cNombreTes,1,39),;
			SPACE(04),;
			SPACE(12),;
			SPACE(08),;
			SPACE(12),;
			SPACE(12),;
			CLI->cCodigoEst,;
			STR(CLI->(RECNO()),2)}

	    IF lSekCodigo(CLI->cCodigoEst,'TRA')

	       nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
	       nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

	       aTitulo := {STR(CLI->(RECNO()),2),;
			   CLI->cCodigoEst,;
			   SPACE(01)+SUBS(cNombreTes,1,39),;
			   SPACE(01)+TRA->cCodigoTra,;
			   TRANS(TRA->nValorTra,"#####,###.99"),;
			   cMes(nMesIniTtr,3)+;
				'/'+cMes(nMesFinTtr,3)+SPACE(01),;
			   cFecha(TRA->dFechaTra),;
			   SPACE(12),;
			   CLI->cCodigoEst,;
			   STR(CLI->(RECNO()),2)}
	    ENDIF
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

	  SELECT CLI
	  SKIP

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