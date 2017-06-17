/*************************************************************************
* TITULO ..: DISE¥O DE LA CARTA DE AUTORIZACION DE RETIROS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 21/2001 JUE A
       Colombia, Bucaramanga        INICIO: 02:30 AM   JUN 21/2001 JUE

OBJETIVOS:

1- Permite imprimir la Carta de Autorizaci¢n de retiro de los Estudiantes
   que se encuentran a Paz y Salvo.

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Ot1Mor022(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroCar := 1                   // N£mero de la Carta
       LOCAL cNroCar := ''                  // N£mero de la Carta
       LOCAL cTipMor := ''                  // Tipo de Moroso
       LOCAL cNotMor := ''                  // Nota del Moroso
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL nTipEst := ''                  // Tipo de Estudiante
       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cNomFac := ''                  // Nombre de la Factura
       LOCAL lTodos  := .T.                 // .T. Imprime todas las Cartas
       LOCAL cTexto  := ''                  // Texto de la Carta

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL Getlist := {}                  // Variable del sistema
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

*>>>>DESACTIVACION DE LAS TECLAS DE FUNCION
       bCodF02 := SETKEY(K_F2)
       SETKEY(K_F2,NIL)
*>>>>FIN DESACTIVACION DE LAS TECLAS DE FUNCION

*>>>>CREACION DE LA CARTA MODELO
       FileTem := "Bases\CartaRet.Mor"
       IF !FILE(FileTem)
	  cTexto := cEnter(8)+;
		    'Ciudad, Fecha de Envio'+cEnter()+;
		    cEnter(3)+;
		    'SE¥ORES'+cEnter()+;
		    'CICES'+cEnter()+;
		    'Atn.:'+cEnter()+;
		    'Ciudad.'+cEnter()+;
		    cEnter(3)+;
		    '(REF)'+cEnter()+;
		    cEnter(3)+;
		    'Cordial Saludo.'+cEnter()+;
		    cEnter(3)+;
		    'Por medio de la presente le solicito el favor que a '+;
		    'las personas que a continuaci¢n se anexan sean '+;
		    'retiradas de la Central de Riesgo, debido a que se '+;
		    'encuentran a PAZ Y SALVO con nuestra Instituci¢n.'+;
		    cEnter(5)+;
		    'Atentamente,'+cEnter()+;
		    cEnter(5)+;
		    CAR->cSecretCar+cEnter()+;
		    CAR->cCarSecCar+cEnter()+;
		    cNomEmp+cEnter()+;
		    'NIT: '+cNitEmp+cEnter()+;
		    'CLAVE: '+CAR->cPswCobCar+cEnter()
	  MemoWrit(FileTem,cTexto)
       ENDIF
*>>>>FIN CREACION DE LA CARTA MODELO

*>>>>EDICION DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON

       EditFile(cNomSis,FileTem,;
		"Edite el Texto de la Carta de Autorizaci¢n")

       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN EDICION DE LA CARTA MODELO

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
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA
       aMezcla := {{'(FECHA)',cFecha(DATE(),10)},;
		   {'(REF)'  ,CHR(27)+'a'+CHR(0)+;
			      'REF:. RETIRO DE REPORTADOS. '+;
				     'AUTORIZACION No. '+;
				     SCO->cCodEmpCon+'-'+;
				     ALLTRIM(STR(CAR->nAutRetCar+1,8))+;
				     CHR(27)+'a'+CHR(3)}}
*>>>>FIN CAMPOS A SUSTITUIR EN EL TEXTO DE LA CARTA

*>>>>IMPRESION DE LA CARTA
       PrnFileTxt(FileTem,aMezcla)
       EJECT
*>>>>FIN IMPRESION DE LA CARTA

*>>>>GRABACION DEL NUMERO DE AUTORIZACION
       IF CAR->(lRegLock(lSiRed,.F.))
	  REPL CAR->nAutRetCar WITH CAR->nAutRetCar+1
	  CAR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO')
       ENDIF
       IF lShared
	  CAR->(DBUNLOCK())
       ENDIF

       SELECT MOR
       SETKEY(K_F2,bCodF02)
      *Activaci¢n de la Tecla de funci¢n

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN GRABACION DEL NUMERO DE AUTORIZACION