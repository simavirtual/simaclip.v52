/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: BOLETINES              MODULO No. 206

**************************************************************************
* NOMBRE DEL PROGRAMA..: CONTA206.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DE BOLETINES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/95 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   JUN 05/95 LUN


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los boletines de los estudiantes


2- Retorna Nil

SINTAXIS:

  Conta_206(nFilInf,aColSup[nOpcion],nFilPal,;
	    cNomEmp,cNomSis,cAnoUsr,cMaeAlu,cMaeAct,;
	    cPatSis,cPatInt,lIntUno,cNomUsr,cJorTxt)
 *Boletines

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\INS-CONT.PRG"       // Detalles de Instalaci¢n
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cTipSis := ''                  // Tipo de Sistema

       LOCAL nOpcion := 1                   // Opci¢n del SubMen£
       LOCAL nOpcPal := 0                   // Opci¢n principal
       LOCAL nFilSup := 0                   // Fila Superior del men£
       LOCAL xColSup := NIL                 // Columna(s) para el men£
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cDerech := ''                  // Derechos del usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL nColAno := NIL                 // Columna del A¤o
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cPatSis := ''                  // Path del sistema

       LOCAL cJorTxt := ''                  // Jornada escogida
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cIniJor := ''                  // Iniciales de la jornada
       LOCAL cNivTxt := ''                  // Maestro escogido
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior para el men£
       LOCAL cTitInf := ''                  // T¡tulo Inferior para el men£
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£

       LOCAL GetList := {}                  // Variable para el sistema
*>>>>FIN DECLARACION DE VARIABLES

       LOCAL       k := 0                   // Contador
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado

lShared := .F.
*>>>>DISE¥O PUBLICITARIO
       CLEAR
       @ 00,00,24,80 BOX CHR(176)+CHR(176)+CHR(176)+CHR(176)+CHR(176)+;
			 CHR(176)+CHR(176)+CHR(176)+CHR(176)
*>>>>FIN DISE¥O PUBLICITARIO

*>>>>LECTURA DEL USUARIO
       cSavPan := SAVESCREEN(0,0,24,79)
       cDerech := cUsuario(lShared,PathSis,FileAaa,@cNomUsr,cPasSis)
       IF cDerech == NIL .OR. !('1' $ SUBS(cDerech,1,100))
	  CLOSE ALL
	  QUIT
       ENDIF
*      cDerech := REPL('1',111)
*>>>>FIN LECTURA DEL USUARIO

*>>>>LECTURA DEL A¥O DE LA APLICACION
       cAnoUsr := STR(YEAR(DATE()),4)
       nFilInf := 2
       nColInf := 30
       @14,34 SAY "A¥O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN LECTURA DEL A¥O DE LA APLICACION

*>>>>LECTURA DE LAS JORNADAS DE ESTUDIO
       cMaeAct := cNivelEst(16,30,cMaeAlu,@cNivTxt)
       cIniJor := cJornada(16,30,cJornad,@cJorTxt)
       cPatSis := cAnoUsr+'.'+cIniJor
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LAS JORNADAS DE ESTUDIO

*>>>>SELECCION DEL PATH DEL SISTEMA
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatSis := cPatSis+'\JAR'
       CASE 'PRI' $ cMaeAct
	    cPatSis := cPatSis+'\PRI'
       CASE 'BTO' $ cMaeAct
	    cPatSis := cPatSis+'\BTO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('NOT')
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('TRANSFIRIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********COPIA DE LOS ARCHIVOS
	    ZAP
**********FIN COPIA DE LOS ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('FUE')
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\BACKUPS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'FUE',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF

**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT NOT
	    aStrNot := DBSTRUCT()
	    GO TOP
	    SELECT FUE
	    aStrFue := DBSTRUCT()
	    GO TOP
ALTD()
	    DO WHILE .NOT. FUE->(EOF())

*--------------GRABACION DEL REGISTRO
		 SELECT NOT
		 IF NOT->(lRegLock(lShared,.T.))

		    FOR i:=1 to LEN(aStrFue)
			IF aStrNot[i,1] == aStrFue[i,1] .AND.;
			   aStrNot[i,2] == aStrFue[i,2]
			   REPL NOT->&(aStrFue[i,1]) WITH FUE->&(aStrFue[i,1])
			ELSE
			   DO CASE
			   CASE aStrNot[i,2] # aStrFue[i,2]
				?'TIPO DIFERENTE '+aStrNot[i,1]
			   CASE aStrNot[i,1] # aStrFue[i,1]
				?'NOMBRE DIFERENTE '+aStrNot[i,1]
			   OTHERWISE
				cError('DESCONICIDO EN '+STR(i))
			   ENDCASE
			ENDIF
		    ENDFOR

		    NOT->(DBCOMMIT())

		 ELSE
			 cError('NO SE PUEDE GRABA EL REGISTRO')
		 ENDIF
		 IF lShared
		    NOT->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DEL REGISTRO

	       NOT->(DBSKIP())
	       FUE->(DBSKIP())
	       SELECT FUE

	    ENDDO
**********FIN IMPRESION DEL CUERPO DEL INFORME


	  SELECT GRU
	  SKIP

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL NIVEL DE ESTUDIOS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/95 LUN A
       Bucaramanga, Colombia        INICIO: 06:00 PM   MAY 08/95 LUN

OBJETIVOS:

1)- Retorna por referencia los param‚tros de la funci¢n marcados con @

2)- Permite activar el nivel de estudios Jardin, Primaria o Bachillerato

3)- Retorna las tres iniciales del nivel de estudios

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNivelEst(nNroFil,nNroCol,cMaeAlu,cNivTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       cMaeAlu				    // Maestros habilitados
       cNivTxt				    // @Texto del nivel escogido */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL       i := 1                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LA JORNADA
       IF 'JAR' $ cMaeAlu
	  AADD(aMenus,i)
	  aMenus[i++] := 'JARDIN'
       ENDIF

       IF 'PRI' $ cMaeAlu
	  AADD(aMenus,i)
	  aMenus[i++] := 'PRIMARIA'
       ENDIF

       IF 'BTO' $ cMaeAlu
	  AADD(aMenus,i)
	  aMenus[i++] := 'BACHILLERATO'
       ENDIF

       IF LEN(cMaeAlu) <> 1
	  SAVE SCREEN
	  DO WHILE .T.
	     nNroOpc := nMenu(aMenus,NIL,nNroFil,nNroCol,'NIVEL',NIL,1,.F.)
	     IF nNroOpc <> 0
		EXIT
	     ENDIF
	  ENDDO
	  RESTORE SCREEN
       ENDIF

       cNivTxt := aMenus[nNroOpc]
       RETURN IF(aMenus[nNroOpc] == 'BACHILLERATO','BTO',;
	      SUBS(aMenus[nNroOpc],1,3))
*>>>>FIN SELECCION DE LA JORNADA

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DE LA JORNADA DE ESTUDIO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 12/94 JUE A
       Bucaramanga, Colombia        INICIO: 06:00 PM   ENE 12/94 JUE

OBJETIVOS:

1)- Retorna por referencia los param‚tros de la funci¢n marcados con @

2)- Permite escoger la jornada de estudio

3)- Retorna las tres iniciales de la jornada

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJornada(nNroFil,nNroCol,cJornad,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       cJornad			            // Jornadas de estudio
       cJorTxt			            // @Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL       i := 1                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LA JORNADA
       IF 'D' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'DIURNA'
       ENDIF

       IF 'N' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'NOCTURNA'
       ENDIF

       IF 'M' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'MA¥ANA'
       ENDIF

       IF 'T' $ cJornad
	  AADD(aMenus,i)
	  aMenus[i++] := 'TARDE'
       ENDIF

       IF LEN(cJornad) <> 1
	  SAVE SCREEN
	  DO WHILE .T.
	     nNroOpc := nMenu(aMenus,NIL,nNroFil,nNroCol,'JORNADAS',NIL,1,.F.)
	     IF nNroOpc <> 0
		EXIT
	     ENDIF
	  ENDDO
	  RESTORE SCREEN
       ENDIF
       cJorTxt := aMenus[nNroOpc]
       RETURN SUBS(aMenus[nNroOpc],1,3)
*>>>>FIN SELECCION DE LA JORNADA

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE GRUPOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 27/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de grupos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de grupos.

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervGru(nNroFil,nNroCol,nRegIni,nRegFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt = 'GRUPO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'GRUPO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT GRU
	nNroCol = nNroCol + LEN(cMsgTxt)+1
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nColInf := nColSup+3

	GRU->(DBGOTOP())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||GRU->cCodigoGru})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	GRU->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY GRU->cCodigoGru
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       GRU->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||GRU->cCodigoGru})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       GRU->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY GRU->cCodigoGru
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
       RETURN .T.
*>>>>FIN INTERCAMBIO DE REGISTROS
