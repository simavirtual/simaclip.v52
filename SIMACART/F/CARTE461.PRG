/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAZ Y SALVOS
SUBMODULO...: POR GRUPOS             MODULO No. 461

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE405.PRG                                    *
* TITULO DEL PROGRAMA..: PAZ Y SALVOS POR GRUPOS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/97 VIE A
       Bucaramanga, Colombia        INICIO: 11:30 AM   OCT 31/97 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los paz y salvo de los estudiantes que no tienen deudas
   pendientes.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_461(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG" // Impresora EPSON FX
       #DEFINE  PAGINA22 CHR(27)+'C'+CHR(22)// P gina de 22 l¡neas
       #DEFINE  PAGINA33 CHR(27)+'C'+CHR(33)// P gina de 33 l¡neas

       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
     *ÀVariables Gestion Documental

       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL     i,j := 0                   // Contadores
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nNroFil := 0                   // N£mero Fila
       LOCAL aNroCol := {}                  // N£mero Columna
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL lMatric := .F.                 // .T. Matricula .F. PreMatricula

       LOCAL nOpcion := 0                   // N£mero de Opci¢n
       LOCAL aFirmas := {}                  // Firmas para Paz y Salvo
       LOCAL dFecPaz := CTOD("00/00/00")    // Fecha del Paz y Salvo

       LOCAL Getlist := {}                  // Variable del sistema
       LOCAL cNombreTes := ''               // Nombre del Estudiante
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
       cSavPan := SAVESCREEN(0,0,24,79)

       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)   .OR.;
	  !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)   .OR.;
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

       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->nRecPazCaA == 0
	    cError('NO SE HA DEFINIDO EL TIPO DE RECIBO PARA EL PAZ Y SALVO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 4621
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<INFORMES><PAZ Y SALVOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'PAZ Y SALVO')                      // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCA->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>LECTURA DE LA DEPENDENCIAS QUE FIRMAN EL PAZ Y SALVO
       IF CAA->nRecPazCaA == 1
	  nNroFil := nMarco(nFilInf+1)
	  @ nNroFil-2,01 SAY 'INGRESE LAS DEPENDENCIAS '+;
			     'QUE FIRMAN EL PAZ Y SALVO'

	  aFirmas := {SPACE(22),SPACE(22),SPACE(22),;
		      SPACE(22),SPACE(22),SPACE(22),;
		      SPACE(22),SPACE(22),SPACE(22)}
	  aNroCol := {01,27,53}

	  DO WHILE .T.

	     FOR i := 1 TO 9
		DO CASE
		CASE i > 0 .AND. i <= 3
		     @ nNroFil+0,aNroCol[i]   GET aFirmas[i]

		CASE i > 3 .AND. i <= 6
		     @ nNroFil+3,aNroCol[i-3] GET aFirmas[i]

		CASE i > 6 .AND. i <= 9
		     @ nNroFil+6,aNroCol[i-6] GET aFirmas[i]
		ENDCASE
	     NEXT

	     READ

	     IF !lPregunta('DESEA CORREGIR? No Si')
		EXIT
	     ENDIF

	  ENDDO
       ENDIF
*>>>>FIN LECTURA DE LA DEPENDENCIAS QUE FIRMAN EL PAZ Y SALVO

*>>>>LECTURA DE LA OPCION DE IMPRESION
       nOpcion := nLeeOpcion('ENTRE LA OPCION DE IMPRESION: '+;
		  '1<SIN DEUDAS> 2<MOROSOS> 3<TODOS>?',3,'0')

       lMatric := !lPregunta('DESEA IMPRIMIR PAZ Y SALVOS '+;
			     'PARA LA PREMATRICULA? No Si')

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA OPCION DE IMPRESION

*>>>>LECTURA DE LA FECHA DEL PAZ Y SALVO
       dFecPaz := DATE()
       @ nFilInf+1,nColInf SAY 'FECHA: ' GET dFecPaz
       READ
       dFecPaz := IF(EMPTY(dFecPaz),DATE(),dFecPaz)
*>>>>FIN LECTURA DE LA FECHA DEL PAZ Y SALVO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'PazGru'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.F.,bInsIso)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(INICIALIZA+PROPOR_OF)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
*	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>ESPECIFICACIONES PARA LA IMPRESORA
       DO CASE
       CASE CAA->nRecPazCaA == 1
	    SendCodes(CONDEN_OF+PICA+NEGRA_ON+DRAFT_ON+PAGINA33)

       CASE CAA->nRecPazCaA == 2
	    SendCodes(CONDEN_OF+PICA+NEGRA_ON+DRAFT_ON+PAGINA22)
       ENDCASE
*>>>>FIN ESPECIFICACIONES PARA LA IMPRESORA

*>>>>IMPRESION DE LOS PAZ Y SALVO POR CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
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
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LOS PAZ Y SALVOS
	    SELECT CLI
	    GO nNroIni
	    DO WHILE .NOT. CLI->(EOF())

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT CLI
		 IF nNroFin <> 0
		    IF CLI->(RECNO()) > nNroFin
		       VerPrn(nOpcPrn,FilePrn)
		       CloseDbf('CLI',FileCli,nModCry)
		       CloseAll(aUseDbf)
		       SET DEVICE TO SCREEN
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			    '->'+STR(CLI->(RECNO()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias)
		 IF lHayAlu
		    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				  RTRIM(&cNalias->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------IMPRESION DEL PAZ Y SALVO
		 DO CASE
		 CASE nOpcion == 1 .AND. CLI->nSdoActCli == 0

		      DO CASE
		      CASE CAA->nRecPazCaA == 1
			   PazSalvo01(cNomEmp,cNomSec,cNomSis,cAnoUsr,;
				      cJorTxt,cMaeAct,CLI->cCodigoEst,;
				      cNombreTes,GRU->cCodigoGru,;
				      STR(CLI->(RECNO()),2),;
				      aFirmas,dFecPaz,CLI->nSdoActCli,;
				      CAA->cMensajCaA,lMatric,;
				      cCodIso,aTitIso,aPieIso)
			   EJECT

		      CASE CAA->nRecPazCaA == 2
			   PazSalvo02(cNomEmp,cNomSec,cNomSis,cAnoUsr,;
				      cJorTxt,cMaeAct,CLI->cCodigoEst,;
				      cNombreTes,GRU->cCodigoGru,;
				      STR(CLI->(RECNO()),2),;
				      aFirmas,dFecPaz,CLI->nSdoActCli,;
				      lMatric)
			   EJECT
		      ENDCASE

		 CASE nOpcion == 2 .AND. CLI->nSdoActCli > 0

		      DO CASE
		      CASE CAA->nRecPazCaA == 1
			   PazSalvo01(cNomEmp,cNomSec,cNomSis,cAnoUsr,;
				      cJorTxt,cMaeAct,CLI->cCodigoEst,;
				      cNombreTes,GRU->cCodigoGru,;
				      STR(CLI->(RECNO()),2),;
				      aFirmas,dFecPaz,CLI->nSdoActCli,;
				      CAA->cMensajCaA,lMatric,;
				      cCodIso,aTitIso,aPieIso)
			   EJECT

		      CASE CAA->nRecPazCaA == 2
			   PazSalvo02(cNomEmp,cNomSec,cNomSis,cAnoUsr,;
				      cJorTxt,cMaeAct,CLI->cCodigoEst,;
				      cNombreTes,GRU->cCodigoGru,;
				      STR(CLI->(RECNO()),2),;
				      aFirmas,dFecPaz,CLI->nSdoActCli,;
				      lMatric)
			   EJECT
		      ENDCASE

		 CASE nOpcion == 3

		      DO CASE
		      CASE CAA->nRecPazCaA == 1
			   PazSalvo01(cNomEmp,cNomSec,cNomSis,cAnoUsr,;
				      cJorTxt,cMaeAct,CLI->cCodigoEst,;
				      cNombreTes,GRU->cCodigoGru,;
				      STR(CLI->(RECNO()),2),;
				      aFirmas,dFecPaz,CLI->nSdoActCli,;
				      CAA->cMensajCaA,lMatric,;
				      cCodIso,aTitIso,aPieIso)
			   EJECT

		      CASE CAA->nRecPazCaA == 2
			   PazSalvo02(cNomEmp,cNomSec,cNomSis,cAnoUsr,;
				      cJorTxt,cMaeAct,CLI->cCodigoEst,;
				      cNombreTes,GRU->cCodigoGru,;
				      STR(CLI->(RECNO()),2),;
				      aFirmas,dFecPaz,CLI->nSdoActCli,;
				      lMatric)
			   EJECT
		      ENDCASE

		 ENDCASE
*--------------FIN IMPRESION DEL PAZ Y SALVO

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DE LOS PAZ Y SALVOS

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LOS PAZ Y SALVO POR CADA GRUPO
