/* SIMA - CENTRAL DE RIESGOS

MODULO      : DATACREDITO
SUBMODULO...: INFOREMES

**************************************************************************
* TITULO..: IMPRESION DE CONTRATANTES                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 27/2004 MAR A
       Colombia, Bucaramanga        INICIO: 11:30 PM   MAR 27/2004 MAR

OBJETIVOS:

1- Permite imprimir los contrates de los estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_412(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL PathAct := ''                  // Path Actual

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

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

       LOCAL nNroCnt := 0                   // Contratantes
       LOCAL nTipPer := 0                   // Tipo de Persona
       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL cNomPer := ''                  // Nombre de la Persona
       LOCAL cNitPer := ''                  // Nit de la Persona
       LOCAL lSiPaso := .F.                 // Control de flujo
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FileGru+'POS'+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
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

       CASE SDA->(RECCOUNT()) == 0
	    cError('NO SE EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SDA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CONTRATANTES A IMPRIMIR
       nNroCnt := 0
       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'NUMERO DE CONTRATANTES A IMPRIMIR:'
       @ nFilInf+1,nColInf SAY 'CONTRATANTES:' GET nNroCnt PICT '9';
					       VALID nNroCnt <= 4
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(nNroCnt)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CONTRATANTES A IMPRIMIR

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ACTIVACION DE LA IMPRESORA
       IF SDA->lPrnArcDat
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'cntrntnt'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SDA->cOpcPrnDat,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU

       GRU->(DBGOTO(nRegFin))
       cGruFin = GRU->cCodigoGru

       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := PathDos+'\'+cPatSis+'\'+;
		       'CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS PARA '+;
			GRU->cCodigoGru)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT GRU
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********DEFINCION DEL ENCABEZADO
	    nNroPag := 0
	    lTamAnc := .F.

	    nTotReg := 0

	    aCabPrn := {cNomEmp,cNomSis,;
			'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
			'CONTRATANTES DE LOS ESTUDIANTES',;
			'GRUPO:'+GRU->cCodigoGru}

	    aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
			nNroPag++,;
			cTotPagina(nTotReg),lTamAnc}

	    cCodIni := PCL({'DraftOn','Elite','CondenOn'})
	    cCodFin := PCL({'NegraOf','DobGolOf'})
**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    aNroCol := {04,06,06,40,40,16}
	    aTitPrn := {'No.','CODIGO','GRUPO','NOMBRE','CONTRATANTES','CEDULA'}
	    cCabCol := cRegPrint(aTitPrn,aNroCol)
**********FIN ENCABEZADOS DE COLUMNA

***********ANALISIS PARA CENTRAR EL INFORME
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
***********FIN ANALISIS PARA CENTRAR EL INFORME

**********IMPRESION DEL ENCABEZADO
	    EVAL(bCabeza)
	   *Impresi¢n del Encabezado

	    AADD(aCabPrn,cFecPrn)
	    AADD(aCabPrn,cHorPrn)
	    AADD(aCabPrn,cDiaPrn)
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LOS CONTRANTES
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		 lRetadoTes := .F.

		 lHayAlu := lSekCodMae(CLI->cCodigoEst,;
				       cMaeAlu,@cMaeAct,.F.)

		 IF lHayAlu
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		    IF &cMaeAct->lRetiroEst
		       lRetadoTes := .T.
		    ENDIF
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
*--------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------LECTURA DE LOS CONTRATANTES
		 aDocNit := {}
		 IF lHayAlu

		    IF nNroCnt >= 1 .AND. !EMPTY(&cMaeAct->cNitCo1Est)
		       AADD(aDocNit,{&cMaeAct->cNitCo1Est,;
				     &cMaeAct->cTipCo1Est})
		    ENDIF

		    IF nNroCnt >= 2 .AND. !EMPTY(&cMaeAct->cNitCo2Est)
		       AADD(aDocNit,{&cMaeAct->cNitCo2Est,;
				     &cMaeAct->cTipCo2Est})
		    ENDIF

		    IF nNroCnt >= 3 .AND. !EMPTY(&cMaeAct->cNitCo3Est)
		       AADD(aDocNit,{&cMaeAct->cNitCo3Est,;
				     &cMaeAct->cTipCo3Est})
		    ENDIF

		    IF nNroCnt >= 4 .AND. !EMPTY(&cMaeAct->cNitCo4Est)
		       AADD(aDocNit,{&cMaeAct->cNitCo4Est,;
				     &cMaeAct->cTipCo4Est})
		    ENDIF

		 ENDIF
*--------------FIN LECTURA DE LOS CONTRATANTES

*--------------PREPARACION DEL REGISTRO DE IMPRESION
		 aRegPrn := {}
		 lSiPaso := .F.
		 AADD(aRegPrn,STR(CLI->(RECNO()),2))
		 AADD(aRegPrn,CLI->cCodigoEst)
		 AADD(aRegPrn,&cMaeAct->cCodigoGru)
		 AADD(aRegPrn,cNombreTes)
		 AADD(aRegPrn,SPACE(01))
		 AADD(aRegPrn,SPACE(01))

		 IF LEN(aDocNit) == 0
		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN PREPARACION DEL REGISTRO DE IMPRESION

*--------------ANALISIS DEL CONTRATANTE
		 FOR i:=1 TO LEN(aDocNit)

		    IF EMPTY(aDocNit[i,1])
		       LOOP
		    ENDIF

		    nTipPer := nTipPerMae(aDocNit[i,1],;
					  &cMaeAct->cPadNitEst,;
					  &cMaeAct->cMadNitEst)

		    DO CASE
		    CASE nTipPer == 1     // Padre

			 cNomPer := 'P:'+;
				    RTRIM(&cMaeAct->cApePadEst)+' '+;
				    RTRIM(&cMaeAct->cNomPadEst)

			 cNitPer := ALLTRIM(&cMaeAct->cPadNitEst)+;
				    IF(&cMaeAct->lPadFotEst,'',' FALTA F')


		    CASE nTipPer == 2     // Madre

			 cNomPer := 'M:'+;
				    RTRIM(&cMaeAct->cApeMadEst)+' '+;
				    RTRIM(&cMaeAct->cNomMadEst)

			 cNitPer := ALLTRIM(&cMaeAct->cMadNitEst)+;
				    IF(&cMaeAct->lMadFotEst,'',' FALTA F')

		    CASE nTipPer == 3     // Otra Persona

			 IF lLocNitPer(aDocNit[i,1],aDocNit[i,2])

			    cNomPer := 'O:'+cNomPer(PER->cApeUnoPer,;
						    PER->cApeDosPer,;
						    PER->cNomUnoPer,;
						    PER->cNomDosPer)
			 ELSE
			    cNomPer := 'PERSONA NO EXISTE'
			 ENDIF
			 cNitPer := ALLTRIM(PER->cDocNitPer)+;
				    IF(PER->lFotNitPer,'',' FALTA F')

		    ENDCASE
		    cNomPer := SUBS(cNomPer+SPACE(40),1,40)
		    cNitPer := SUBS(cNitPer+SPACE(16),1,16)

		    IF !lSiPaso
		       lSiPaso := .T.
		    ELSE
		       aRegPrn[1] := SPACE(01)
		       aRegPrn[2] := SPACE(01)
		       aRegPrn[3] := SPACE(01)
		       aRegPrn[4] := SPACE(01)
		    ENDIF
		    aRegPrn[5] := cNomPer
		    aRegPrn[6] := cNitPer

		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		 NEXT
*--------------FIN ANALISIS DEL CONTRATANTE

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 SELECT CLI
		 CLI->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
	    EVAL(bDerAut)
	   *Derechos de Autor
	    EJECT
**********FIN IMPRESION DE LOS CONTRANTES

**********AVANCE DEL SIGUIENTE GRUPO
	    CloseDbf('CLI',FileCli,nModCry)
	    SELECT GRU
	    GRU->(DBSKIP())

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS
