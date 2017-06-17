/* SIMA - CONTROL DE ASISTENCIA

MODULO      : INFORMES
SUBMODULO...: AUSENCIAS                                MODULO No. 401

**************************************************************************
* TITULO..: IMPRESION DE LAS NOVEDADES DE ASISTENCIA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 30/2004 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 30/2004 MIE

OBJETIVOS:

1- Permite Imprimir los Estudiantes con novedades de asistencia


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL lSiPaso := .F.                 // Control de Flujo

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreThr := ''               // Descripci¢n de la Hora
       LOCAL cNombreTta := ''               // Nombre del Tipo de Ausencia

       FIELD cCodigoGru                     // C¢digo del Grupo
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

       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHra,'HRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cIntUno+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})

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

       CASE TAU->(RECCOUNT()) == 0
	    cError('NO ESTAN CREADOS LOS TIPOS DE AUSENCIAS')

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN NOVEDADES DE ASISTENCIA')

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

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'ESTUDIANTES CON NOVEDADES DE ASISTENCIA',;
		   'DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,20,20,12,40}
       aTitPrn := {'CODIGO','GRUPO','NOMBRE',;
		   'NOVEDAD','DIA/HORA','FECHA','OBSERVACION'}
       cCabCol := cRegPrint(aTitPrn,aNroCol)
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
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SAS->lPrnArcAsi
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'novasit'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SAS->cOpcPrnAsi,.F.,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DE LOS REGISTROS
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********FILTRACION DEL ARCHIVO
	    SELECT &cMaeAct
	    SET FILTER TO cCodigoGru == GRU->cCodigoGru
	    GO TOP
	    IF EOF()
	       cError('NO HAY ALUMNOS PARA EL GRUPO '+GRU->cCodigoGru)
	       SET FILTER TO
	       EXIT
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********RECORRIDO DEL MAESTRO POR GRUPOS
	    SELECT &cMaeAct
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------NOMBRE DEL ESTUDIANTE
		 cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			       RTRIM(&cMaeAct->cApelliEst)
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
*--------------FIN NOMBRE DEL ESTUDIANTE

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('ºGRUPO: '+&cMaeAct->cCodigoGru+;
			     'ºESTUDIANTE: '+cNombreTes,cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------FILTRACION DEL ARCHIVO
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
*--------------FIN FILTRACION DEL ARCHIVO

*--------------RECORRIDO DE LAS NOVEDADES
		 aRegPrn := {}
		 AADD(aRegPrn,&cMaeAct->cCodigoEst)
		 AADD(aRegPrn,&cMaeAct->cCodigoGru)
		 AADD(aRegPrn,cNombreTes)
		 lSiPaso := .F.

		 SELECT ASI
		 ASI->(DBGOTOP())
		 DO WHILE .NOT. ASI->(EOF())

*...................LOCALIZACION DE LA HORA
		      cNombreThr := ASI->cCodigoHra
		      IF lLocCodigo('cCodigoHra','HRA',ASI->cCodigoHra)
			 cNombreThr := HRA->cNombreHra
		      ENDIF
*...................FIN LOCALIZACION DE LA HORA

*...................LOCALIZACION DEL TIPO DE AUSENCIA
		      cNombreTta := ASI->cCodigoTau
		      IF lLocCodigo('cCodigoTau','TAU',ASI->cCodigoTau)
			 cNombreTta := TAU->cNombreTau
		      ENDIF
*...................FIN LOCALIZACION DEL TIPO DE AUSENCIA

*...................IMPRESION DEL REGISTRO
		      IF !lSiPaso
			 AADD(aRegPrn,cNombreTta)
			 AADD(aRegPrn,cNombreThr)
			 AADD(aRegPrn,cFecha(ASI->dFecAsiCtr))
			 AADD(aRegPrn,SUBS(ASI->cObservCtr,1,40))
			 lSiPaso := .T.
		      ELSE
			 aRegPrn[1] := SPACE(01)
			 aRegPrn[2] := SPACE(01)
			 aRegPrn[3] := SPACE(01)
			 aRegPrn[4] := cNombreTta
			 aRegPrn[5] := cNombreThr
			 aRegPrn[6] := cFecha(ASI->dFecAsiCtr)
			 aRegPrn[7] := SUBS(ASI->cObservCtr,1,40)
		      ENDIF

		      lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			      aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*...................FIN IMPRESION DEL REGISTRO

		    ASI->(DBSKIP())
		 ENDDO
*--------------FIN RECORRIDO DE LAS NOVEDADES

	       SELECT &cMaeAct
	       DBSKIP()

	    ENDDO
**********RECORRIDO DEL MAESTRO POR GRUPOS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT GRU
	    GRU->(DBSKIP())
	    IF GRU->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
