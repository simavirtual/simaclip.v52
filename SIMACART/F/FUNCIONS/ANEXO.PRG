/*************************************************************************
* TITULO ..: RETIRO DE REPORTADOS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 12/2001 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   JUN 12/2001 MAR

OBJETIVOS:

1- Imprime la Autorizaci¢n para el Retiro de la Centra de Riesgos

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Ot1Mor033(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,lIntUno,lIntDos,;
		   lIntTre,lIntCua,cMaeAlu,cMaeAct,cJorTxt,;
		   oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       #DEFINE MARIZQ_0   CHR(27)+'l'+CHR(0)
       #DEFINE MARIZQ_8   CHR(27)+'l'+CHR(16)
       #DEFINE MARDER_80  CHR(27)+'Q'+CHR(80)
       #DEFINE MARDER_75  CHR(27)+'Q'+CHR(75)
       #DEFINE JUSTIF_ON  CHR(27)+'a'+CHR(3)
       #DEFINE JUSTIF_OF  CHR(27)+'a'+CHR(0)

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL aNroLin[5]                     // Lineas de Encabezado
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL dFecRet := CTOD('00/00/00')    // Fecha de Reporte
       LOCAL nNroRet := 0                   // N£mero de Retiros del Reporte
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables Espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNomPadTes := ''               // Nombre del Padre
       LOCAL cNomMadTes := ''               // Nombre de la Madre
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS REPORTADOS
       IF !lValRep(lShared,nModCry,cNomSis,cPatSis,cAnoUsr,cMaeAlu,cMaeAct)
	  cError('DEBE ESTAR VALIDADA LA INFORMACION DE LOS REPORTADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LOS REPORTADOS

*>>>>VALIDACION DEL CONTENIDO
       lHayErr := .T.
       DO CASE
       CASE MOR->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS GRABADOS')

       CASE EMPTY(SCO->cNroNitCon)
	    cError('DEBE DEFINIR EL NUMERO DEL NIT')
       OTHERWISE
	    lHayErr := .F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ENCABEZADO DE LA CARTA
       cSavPan := SAVESCREEN(0,0,24,79)
       aNroLin[1] := cSUBS('Ciudad, Fecha de Envio',60)
       aNroLin[2] := cSUBS('Se¤ores',60)
       aNroLin[3] := cSUBS('CICES',60)
       aNroLin[4] := cSUBS('Atn.:',60)
       aNroLin[5] := cSUBS('Ciudad',60)
       SET CURSOR ON
       nNroFil := nMarco(3,'DIGITE EL ENCABEZADO DE LA CARTA')
       DO WHILE .T.
	  @ nNroFil+1,01 GET aNroLin[1] PICT '@S60'
	  @ nNroFil+2,01 GET aNroLin[2] PICT '@S60'
	  @ nNroFil+3,01 GET aNroLin[3] PICT '@S60'
	  @ nNroFil+4,01 GET aNroLin[4] PICT '@S60'
	  @ nNroFil+5,01 GET aNroLin[5] PICT '@S60'
	  READ
	  IF !lPregunta('DESEA CORREGIR? Si No')
	    EXIT
	  ENDIF
       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SET CURSOR OFF
*>>>>FIN ENCABEZADO DE LA CARTA

*>>>>ANALISIS DE DECISION
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(CAR->lPrnArcCar)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+DRAFT_ON+CONDEN_OF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL ENCABEZADO DE LA CARTA
       SendCodes(MARIZQ_8+MARDER_75)
       @ PROW()+8,00 SAY aNroLin[1]
       SendCodes(NEGRA_ON)
       FOR i := 2 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       ENDFOR
       SendCodes(NEGRA_OF)
*>>>>IMPRESION DEL ENCABEZADO DE LA CARTA

*>>>>REFERENCIA
       @ PROW()+3,00 SAY NEGRA_ON+'REF.: '+NEGRA_OF
       @ PROW()+0,07 SAY 'RETIRO DE REPORTADOS DE LA CENTRAL DE RIESGO'
*>>>>FIN REFERENCIA

*>>>>CUERPO DE LA CARTA
       @ PROW()+3,00 SAY JUSTIF_ON+'Cordial Saludo.'
       @ PROW()+3,00 SAY 'Por medio de la presente le solicito el favor '+;
	 'que a las personas que a continuaci¢n se relaciona sean retiradas '+;
	 'de la Central de Riesgo, debido a que se encuentra a '+;
	 'PAZ Y SALVO con nuestra Instituci¢n.'
       SendCodes(JUSTIF_OF+CONDEN_ON)
*>>>>FIN CUERPO DE LA CARTA

*>>>>DECLARACION DE LOS ENCABEZADOS DE COLUMNA
       cCabCol := cSUBS('DOCUMENTO',16)+' '+;
		  'TIPO '+;
		  cSUBS('APELLIDOS Y NOMBRES',50)+' '+;
		  'CODIGO '+;
		  'GRUPO '
*>>>>FIN DECLARACION DE LOS ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO. REG: '+;
			STR(MOR->(RECNO()),5)+'/'+;
			STR(MOR->(RECCOUNT()),5),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,NIL,.F.)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DE CLIENTES Y PAGOS
	    nMesIni := VAL(SUBS(CLI->cHayRepCli,1,2))
	    lLocCodigo('cCodigoEst','CLI',MOR->cCodigoEst)
            lLocCodPag(MOR->cCodigoEst,nMesIni,.F.)
**********FIN LOCALIZACION DE CLIENTES Y PAGOS

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina
	       @ PROW()+2,00 SAY NEGRA_ON+cCabCol+NEGRA_OF
	       @ PROW()+1,00 SAY ''
	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL REGISTRO
	    cTxtPrn := cSUBS(&cMaeAct->cPadNitEst,16)+' '+;
		       cSUBS(&cMaeAct->cPadTntEst,4)+' '+;
		       cSUBS(cNombreTes,50)+' '+;
		       cSUBS(&cMaeAct->cCodigoEst,6)+' '+;
		       cSUBS(&cMaeAct->cCodigoGru,6)

	    @ PROW()+1,00 SAY cTxtPrn
**********FIN IMPRESION DEL REGISTRO

**********GRABACION DEL CONTROL DEL REPORTE EN PAGOS
	    IF PAG->(lRegLock(lShared,.F.))
	       REPL PAG->dFecRetMor WITH DATE()
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL CONTROL DEL REPORTE EN PAGOS

**********GRABACION DEL CONTROL DEL REPORTE EN CLIENTES
	    nNroRet := VAL(SUBS(CLI->cHayRepCli,5,1))
	    nNroRet := IF(nNroRet>9,'9',STR(nNroRet++,1))
	    IF CLI->(lRegLock(lShared,.F.))
	       REPL CLI->cHayRepCli WITH STUFF(CLI->cHayRepCli,5,1,nNroRet)
	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL CONTROL DEL REPORTE EN CLIENTES

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

**********AVANCE DEL SIGUIENTE REGISTRO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
	    SELECT MOR
	    MOR->(DBSKIP())
	    IF MOR->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 47
	  EJECT
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>PERSONAS QUE AUTORIZAN
       SendCodes(CONDEN_ON)
       @ PROW()+3,00 SAY 'Atentamente,'
       @ PROW()+4,00 SAY CAR->cSecretCar
       @ PROW()+1,00 SAY CAR->cCarSecCar
       @ PROW()+1,00 SAY 'NIT: '+SCO->cNroNitCon
       @ PROW()+1,00 SAY 'CLAVE: '+CAR->cPswCobCar
       SendCodes(CONDEN_OF)
*>>>>FIN PERSONAS QUE AUTORIZAN

*>>>>IMPRESION DERECHOS
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       IF !EMPTY(oBrowse)
	  MOR->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

FUNCTION cSUBS(cTxtTem,nLenTxt)
RETURN SUBS(cTxtTem+SPACE(nLenTxt),1,nLenTxt)

/*************************************************************************
* TITULO ..: VALIDACION DE LOS REPORTADOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2001 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUN 20/2001 MIE

OBJETIVOS:

1- Valida que la informaci¢n de todos los reportados no tenga ningun
   problema

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValRep(lShared,nModCry,cNomSis,cPatSis,cAnoUsr,cMaeAlu,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cPatSis                              // Path del sistema
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cNroNit := ''                  // N£mero de la Cedula
       LOCAL cTipNit := ''                  // Tipo del Documento
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS REPORTADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'VALIDACION DE LOS REPORTADOS')
       Termometro(10)
       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('VALIDANDO LOS REPORTADOS. REG: '+;
			STR(MOR->(RECNO()),5)+'/'+;
			STR(MOR->(RECCOUNT()),5),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct,NIL,.F.)
	       cError('NO EXISTE EL ESTUDIANTE DE CODIGO: '+MOR->cCodigoEst)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodigo('cCodigoEst','CLI',MOR->cCodigoEst)
	       cError('EL CODIGO '+MOR->cCodigoEst+' '+;
		      'NO EXISTE EN LOS CLIENTES '+;
		      'DEL GRUPO: '+&cMaeAct->cCodigoGru)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********VALIDACION DEL MES REPORTADO
	    nMesIni := VAL(SUBS(CLI->cHayRepCli,1,2))
	    IF EMPTY(nMesIni)
	       cError('EL CODIGO '+MOR->cCodigoEst+' '+;
		      'NO TIENE DEFINIDO EL MES QUE FUE REPORTADO')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN VALIDACION DEL MES REPORTADO

**********LOCALIZACION DEL PAGO
	    IF !lLocCodPag(MOR->cCodigoEst,nMesIni,.F.)
	       cError('EL CODIGO '+MOR->cCodigoEst+' '+;
		      'NO EXISTE RECIBO DE PAGO DEL MES DE '+;
		      cMes(nMesIni))
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********VALIDACION DE LA INFORMACION REPORTADA
	    lHayErr := .F.
	    DO CASE
	    CASE EMPTY(CLI->cHayRepCli)
		 cError('EL CODIGO '+MOR->cCodigoEst+' '+;
			'NO TIENE DEFINIDO LOS DATOS DE REPORTE EN CLIENTES')

	    CASE EMPTY(PAG->dFecRepMor)
		 cError('EL CODIGO '+MOR->cCodigoEst+' '+;
			'NO TIENE DEFINIDO LA FECHA EN QUE FUE REPORTADO')
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN VALIDACION DE LA INFORMACION REPORTADA

**********VALIDACION DE LA CEDULA REPORTADA
	    cNroNit := ''
	    lHayErr := .F.
	    DO CASE
	    CASE PAG->nNomFacEst == 0 .OR. PAG->nNomFacEst == 1
		 cNroNit := &cMaeAct->cPadNitEst
		 cTipNit := &cMaeAct->cPadTntEst

	    CASE PAG->nNomFacEst == 2
		 cNroNit := &cMaeAct->cMadNitEst
		 cTipNit := &cMaeAct->cMadTntEst

	    CASE PAG->nNomFacEst == 3
		 cNroNit := &cMaeAct->cAcuNitEst
		 cTipNit := &cMaeAct->cAcuTntEst
	    ENDCASE

	    IF EMPTY(cNroNit) .OR. LEN(cNroNit) <= 5
	       cError('CODIGO: '+MOR->cCodigoEst+' '+;
		      'FAVOR REVISAR EL NUMERO DE LA CEDULA DE '+;
		      cTipNomRep(PAG->nNomFacEst))

	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF

	    IF EMPTY(cTipNit)
	       cError('CODIGO: '+MOR->cCodigoEst+' '+;
		      'NO TIENE DEFINIDO EL TIPO DE DOCUMENTO DE '+;
		      cTipNomRep(PAG->nNomFacEst))

	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       RETURN .F.
	    ENDIF
**********FIN VALIDACION DE LA CEDULA REPORTADA

**********AVANCE DEL SIGUIENTE REGISTRO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
	    SELECT MOR
	    MOR->(DBSKIP())
	    IF MOR->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN .T.
*>>>>FIN VALIDACION DE LOS REPORTADOS
