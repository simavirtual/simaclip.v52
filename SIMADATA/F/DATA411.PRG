/* SIMA - CENTRAL DE RIESGOS

MODULO      : CONTRATANTES
SUBMODULO...: POR GRADOS

**************************************************************************
* TITULO..: IMPRESION DE CONTRATANTES POR GRADOS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   AGO 05/2004 JUE

OBJETIVOS:

1- Permite imprimir los contrates de los estudiantes por grados

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_411(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL nNroCnt := 0                   // Contratantes
       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
       FIELD cApelliEst                     // Apellido del Estudiante
       FIELD cNombreEst                     // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimDat,'SDA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
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

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       IF !lLeeNivels(nFilInf+1,nColInf,@cNivIni,@cNivFin,@nCopias,cMaeAlu)
	  CloseAll()
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>INDEXACION DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'ORDENANDO POR APELLIDO')
       Termometro(50)

       SELECT &cMaeAct
       fNtxTem := cFileTempo('',SUBS(cNomUsr,1,4),cExtNtx)

       INDEX ON SUBS(cCodigoGru,1,2)+cApelliEst;
	     TO &fNtxTem
       IF lShared
	  DBSETINDEX(fNtxTem)
       ELSE
	  SET INDEX TO &fNtxTem
       ENDIF

       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN INDEXACION DEL ARCHIVO

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

*>>>>IMPRESION DEL INFORME
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL MAESTRO
	    SELECT &cMaeAct
	    SET FILTER TO VAL(SUBS(cCodigoGru,1,2)) == nNroNiv
	    DBGOTOP()
	    IF EOF()
	       SET DEVICE TO SCREEN
	       cError('PARA '+cNomNiv(nNroNiv)+;
		      ' NO HAY MATRICULADOS')
	       nNroCop := nCopias+1
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE N COPIAS
	    DO WHILE nNroCop <= nCopias

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'º'+;
			     'HASTA NIVEL: '+cNivFin+;
			     'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			     STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------IMPRESION DE LOS CONTRATANTES
		 PrnCntrApe(lShared,nOpcPrn,FilePrn,nHanXml,;
			    nNroNiv,cNomEmp,cNomSis,;
			    cNomUsr,cAnoUsr,cMaeAct,;
			    cJorTxt,nNroCnt)
		 nNroCop++
*--------------FIN IMPRESION DE LOS CONTRATANTES

	    ENDDO
**********FIN IMPRESION DE N COPIAS

	  nNroNiv++
	  nNroCop := 1

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN

       SET FILTER TO
       CloseAll()
       lFileDelete(fNtxTem)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: IMPRESION DE CONTRATANTES POR GRADOS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/2004 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   AGO 05/2004 JUE

OBJETIVOS:

1- Imprime los estudiante matr¡culados ordenados por nivel y por apellido

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnCntrApe(lShared,nOpcPrn,FilePrn,nHanXml,nNroNiv,cNomEmp,cNomSis,;
		    cNomUsr,cAnoUsr,cMaeAct,cJorTxt,nNroCnt)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nOpcPrn                              // Opci¢n de Impresi¢n
       FilePrn                              // Archivo de Impresi¢n
       nHanXml                              // Manejador del Archivo
       nNroNiv                              // N£mero de nivel a imprimir
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada Escogida
       nNroCnt                              // N£mero de Contrantes */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
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

       LOCAL       i := 1                   // Contador
       LOCAL nNroAlu := 0                   // N£mero de Alumnos
       LOCAL nTipPer := 0                   // Tipo de Persona
       LOCAL aDocNit := {}                  // Documento de los Contrantes
       LOCAL cNomPer := ''                  // Nombre de la Persona
       LOCAL cNitPer := ''                  // Nit de la Persona
       LOCAL lSiPaso := .F.                 // Control de flujo

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado

       FIELD cCodigoGru
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'CONTRATANTES DE LOS ESTUDIANTES',;
		   cNomNiv(nNroNiv)}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,06,40,40,16}
       aTitPrn := {'No.','CODIGO','GRUPO','NOMBRE','CONTRATANTES','CEDULA'}
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

*>>>>IMPRESION DEL ENCABEZADO
       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>VARIABLES PARA EL ENCABEZADO DEL INFORME
       COUNT FOR VAL(SUBS(cCodigoGru,1,2)) == nNroNiv TO nTotReg
      *Total de registros a imprimir
*>>>>FIN VARIABLES PARA EL ENCABEZADO DEL INFORME

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT &cMaeAct
       GO TOP
       DO WHILE .NOT. EOF() .AND. nTotReg # 0

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    lRetadoTes := .F.

	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    IF &cMaeAct->lRetiroEst
	       lRetadoTes := .T.
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********LECTURA DE LOS CONTRATANTES
	    aDocNit := {}

*	    IF !EMPTY(&cMaeAct->cNitCo1Est)
	       AADD(aDocNit,{&cMaeAct->cNitCo1Est,;
			     &cMaeAct->cTipCo1Est})
*	    ENDIF

*	    IF !EMPTY(&cMaeAct->cNitCo2Est)
	       AADD(aDocNit,{&cMaeAct->cNitCo2Est,;
			     &cMaeAct->cTipCo2Est})
*	    ENDIF

*	    IF !EMPTY(&cMaeAct->cNitCo3Est)
	       AADD(aDocNit,{&cMaeAct->cNitCo3Est,;
			     &cMaeAct->cTipCo3Est})
*	    ENDIF

*	    IF !EMPTY(&cMaeAct->cNitCo4Est)
	       AADD(aDocNit,{&cMaeAct->cNitCo4Est,;
			     &cMaeAct->cTipCo4Est})
*	    ENDIF
**********FIN LECTURA DE LOS CONTRATANTES

**********PREPARACION DEL REGISTRO DE IMPRESION
	    aRegPrn := {}
	    lSiPaso := .F.
	    nNroAlu++
	    AADD(aRegPrn,STR(nNroAlu,4))
	    AADD(aRegPrn,&cMaeAct->cCodigoEst)
	    AADD(aRegPrn,&cMaeAct->cCodigoGru)
	    AADD(aRegPrn,cNombreTes)
	    AADD(aRegPrn,SPACE(01))
	    AADD(aRegPrn,SPACE(01))

	    IF LEN(aDocNit) == 0
	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN PREPARACION DEL REGISTRO DE IMPRESION

**********ANALISIS DEL CONTRATANTE
*	    FOR i:=1 TO LEN(aDocNit)
	    FOR i:=1 TO nNroCnt

	       nTipPer := 0
	       IF !EMPTY(aDocNit[i,1])
		  nTipPer := nTipPerMae(aDocNit[i,1],;
					&cMaeAct->cPadNitEst,;
					&cMaeAct->cMadNitEst)
	       ENDIF

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

		       cNomPer := 'O:'+;
				  cNomPer(PER->cApeUnoPer,;
					  PER->cApeDosPer,;
					  PER->cNomUnoPer,;
					  PER->cNomDosPer)
		    ELSE
		       cNomPer := 'PERSONA NO EXISTE'
		    ENDIF
		    cNitPer := ALLTRIM(PER->cDocNitPer)+;
			       IF(PER->lFotNitPer,'',' FALTA F')

	       OTHERWISE
		    cNomPer := SPACE(01)
		    cNitPer := SPACE(01)
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
**********FIN ANALISIS DEL CONTRATANTE

	  SELECT &cMaeAct
	  DBSKIP()

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
       ENDIF
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


