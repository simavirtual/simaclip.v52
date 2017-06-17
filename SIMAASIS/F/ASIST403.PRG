/* SIMA - CONTROL DE ASISTENCIA

MODULO      : INFORMES
SUBMODULO...: AUSENCIAS POR MES

**************************************************************************
* TITULO..: IMPRESION DE LAS AUSENCIAS POR DIA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 04/2007 MIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   JUN 04/2007 MIE

OBJETIVOS:

1- Permite Imprimir los Estudiantes con novedades de asistencia por
   materia


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_403(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
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
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL     i,j := 0                   // Contador
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

       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTta := ''               // C¢digo del Tipo de Ausencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimAsi,'SAS',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHra,'HRA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHor,'HOR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FAsiAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fTipAus,'TAU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fCtrAsi,'ASI',NIL,lShared,nModCry})

*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SELECT &cMaeAct
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO SE HA DEFINIDO LA DIVISION DE LAS HORAS')

       CASE SAS->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE TAU->(RECCOUNT()) == 0
	    cError('NO ESTAN CREADOS LOS TIPOS DE AUSENCIAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN NOVEDADES DE ASISTENCIA')

       CASE HOR->(RECCOUNT()) == 0
	    cError('NO SE HA DEFINIDO EL HORARIO DE LOS CURSOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SAS->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL TIPO DE AUSENCIA
       SELECT TAU
       TAU->(DBGOTOP())
       cCodigoTta := TAU->cCodigoTau

       cSavPan := SAVESCREEN(0,0,24,79)
       cCodigoTta := cSpaces('TAU','cCodigoTau')
       @ nFilInf+1,nColInf SAY 'NOVEDAD ';
			   GET cCodigoTta PICT '@!';
			   VALID lValTipoA(ROW(),COL()-3,@cCodigoTta)
       READ

       IF EMPTY(cCodigoTta)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('ESCOGIO '+ALLTRIM(TAU->cNombreTau)+'. '+;
		    'DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL TIPO DE AUSENCIA

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA INICIAL:' GET dFecIni PICT '@D'
       @ nFilInf+2,nColInf SAY 'FECHA FINAL  :' GET dFecFin PICT '@D'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nNroIso := 403
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<INFORMES><AUSENCIAS ASIGNATURA>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,TAU->cNombreTau)  // T¡tulo Uno
       AADD(aTitIso,'')               // T¡tulo Dos
       AADD(aTitIso,'')               // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       aPieIso := {}
       AADD(aPieIso,'')  // Pie de p gina Uno
       AADD(aPieIso,'')  // Pie de p gina Dos
       AADD(aPieIso,'')  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SAS->lPrnArcAsi
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ausdia'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SAS->cOpcPrnAsi,.T.,2,;
				 bInsIso,PathPrn)
	  IF EMPTY(nOpcPrn)
	     SET DEVICE TO SCREEN
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
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

*>>>>RECORRIDO DE LOS REGISTROS
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

	  DiaAusMat(lShared,cNomSis,cNomEmp,cAnoUsr,cMaeAct,cJorTxt,;
		    PathPrn,FilePrn,nOpcPrn,cCodIso,aTitIso,aPieIso,;
		    cCodigoTta,dFecIni,dFecFin,@nHanXml,nRegFin)


	  GRU->(DBSKIP())

       ENDDO

       SET DEVICE TO SCREEN
       IF nOpcPrn # 6
	  VerPrn(nOpcPrn,FilePrn,nHanXml)
       ENDIF
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS REGISTROS

/*************************************************************************
* TITULO..: AUSENCIAS POR MES                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2007 LUN A
       Colombia, Bucaramanga        INICIO: 01:10 PM   JUN 05/2007 LUN

OBJETIVOS:

1- Imprime las ausencias por grupo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DiaAusMat(lShared,cNomSis,cNomEmp,cAnoUsr,cMaeAct,cJorTxt,;
		   PathPrn,FilePrn,nOpcPrn,cCodIso,aTitIso,aPieIso,;
		   cTipAus,dFecIni,dFecFin,nHanXml,nRegFin)


*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cMaeAct                              // Maestro Actual
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       PathPrn                              // Path de impresi¢n
       FilePrn                              // Archivo de impresi¢n
       nOpcPrn                              // Opci¢n de Impresi¢n
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso       	                    // Textos del pie de p gina
       cTipAus                              // Tipo de Ausencia
       dFecIni                              // Fecha Inicial
       dFecFin                              // Fecha Final
       nHanXml                              // Manejador de archivo
       nRegFin                              // Registro Final del grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
*      LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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

       LOCAL     i,j := 0                   // Contadores
       LOCAL nTotDia := 0                   // Total Dia
       LOCAL aDiaAus := {}                  // D¡a de Ausencias
       LOCAL nTotAus := 0                   // Total de Ausencias

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       SELECT &cMaeAct
       SET FILTER TO cCodigoGru == GRU->cCodigoGru
       DBGOTOP()
       IF EOF()
	  cError('NO HAY ALUMNOS PARA EL GRUPO '+GRU->cCodigoGru)
	  SET FILTER TO
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   'CURSO:'+GRU->cCodigoGru+'. '+;
		   'A¥O:'+cAnoUsr+' JORNADA '+cJorTxt,;
		   'DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin)}


       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,06)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,30)
       AADD(aTitPrn,'NOMBRE DEL ESTUDIANTE')

       FOR i := 1 TO 31

	   AADD(aNroCol,02)
	   AADD(aTitPrn,STR(i,2))

       ENDFOR
       AADD(aNroCol,04)
       AADD(aTitPrn,'TOT.')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       IF nOpcPrn = 6
	  FilePrn := PathPrn+'\Dia'+GRU->cCodigoGru+'.xls'
       ENDIF
       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPieIso(aPieIso))}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>RECORRIDO POR ALUMNOS
       SELECT &cMaeAct
       DBGOTOP()
       DO WHILE .NOT. EOF()

**********NOMBRE DEL ESTUDIANTE
	    cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			  RTRIM(&cMaeAct->cApelliEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
**********FIN NOMBRE DEL ESTUDIANTE

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('ºGRUPO: '+&cMaeAct->cCodigoGru+;
			'ºESTUDIANTE: '+cNombreTes,cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********FILTRACION DEL ARCHIVO
	    cCodigoTes := &cMaeAct->cCodigoEst

	    SELECT ASI
	    SET FILTER TO ASI->cCodigoEst == cCodigoTes .AND.;
			  dFecIni <= ASI->dFecAsiCtr    .AND.;
			  dFecFin >= ASI->dFecAsiCtr

	    ASI->(DBGOTOP())

	    IF ASI->(EOF())
	       SELECT &cMaeAct
	       DBSKIP()
	       LOOP
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********RECORRIDO POR CONTROL DE ASISTENCIA
	    aDiaAus := {}
	    SELECT ASI
	    ASI->(DBGOTOP())

	    DO WHILE .NOT. ASI->(EOF())

*==============ANALISIS DE DECISION
		 IF ASI->cCodigoTau # cTipAus
		    ASI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS DE DECISION

/*
*==============ANALISIS DE DECISION
		 IF ASI->cCodigoHra # ANO->cCodHraAsA .AND.;
		    ASI->cCodigoTau # ANO->cCodTauAsA
		    ASI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS DE DECISION
*/

	       AADD(aDiaAus,{DAY(ASI->dFecAsiCtr),ASI->cCodigoHra})
	       ASI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR CONTROL DE ASISTENCIA

**********IMPRESION DEL REGISTRO
	    nTotAus := 0
	    aRegPrn := {}
	    AADD(aRegPrn,&cMaeAct->cCodigoEst)
	    AADD(aRegPrn,cNombreTes)

	    FOR i := 1 TO 31

		nTotDia := 0
		FOR j := 1 TO LEN(aDiaAus)
		    IF i == aDiaAus[j,1]
		       nTotDia++
		       nTotAus++
		    ENDIF
		ENDFOR

		IF nTotDia == 0
		   AADD(aRegPrn,SPACE(01))
		ELSE
		   AADD(aRegPrn,STR(nTotDia,2))
		ENDIF

	    ENDFOR
	    AADD(aRegPrn,STR(nTotAus,2))
	    SET DEVICE TO PRINT
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DEL REGISTRO

	  SELECT &cMaeAct
	  DBSKIP()

       ENDDO
       SELECT &cMaeAct
       SET FILTER TO
*>>>>RECORRIDO POR ALUMNOS

*>>>>IMPRESION DERECHOS
       SET DEVICE TO PRINT
       EVAL(bDerAut)
       EJECT
      *Derechos de Autor

       SET DEVICE TO SCREEN
       IF nOpcPrn == 6
	  VerPrn(nOpcPrn,FilePrn,nHanXml,;
		 IF(GRU->(RECNO()) == nRegFin,.T.,.F.))
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
