/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO GRUPOS

REQUERIMIENTOS:

- Compilar: clipper FuncsGru /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo grupos

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2002 DOM A
       Colombia, Bucaramanga        INICIO: 09:30 PM   JUL 07/2002 DOM

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfGru(lShared,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual      fECHA DE NACIMIENTO

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoGru","Character", 04,0}) // C¢digo del Grupo
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: APERTURA DE LOS ARCHIVOS DE GRUPOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2002 DOM A
       Colombia, Bucaramanga        INICIO: 09:35 PM   JUL 07/2002 DOM

OBJETIVOS:

1)- Pone en uso los archivos de grupos

2)- Retorna por referencia los param‚tros de la funci¢n marcados con @

3)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseGru(lShared,cPatSis,cMaeAlu,cAnoUsr,cNomUsr,FileTgr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Compartir Archivos
       cPatSis			            // Path del Sistema
       cMaeAlu                              // Maestros habilitados
       cAnoUsr                              // A¤o del Usuario
       cNomUsr                              // Nombre del Usuario
       FileTgr                              // @Archivo temporal del Grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cMaeAct := ''                  // Maestro Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE TODOS LOS GRUPOS
       IF LEN(cMaeAlu)/3 > 1

**********CREACION DE LA ESTRUCTURA TEMPORAL
	    FileTgr := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
	    CreaDbfGru(lShared,DIRNAME(),FileTgr)
**********FIN CREACION DE LA ESTRUCTURA TEMPORAL

**********AREAS DE TRABAJO
	    IF !lUseDbf(.T.,DIRNAME()+'\'+FileTgr,'FUE',NIL,lShared)
	       cError('ABRIENDO ARCHIVOS')
	       CloseAll()
	       IF !lFileDelete(FileTgr)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN .F.
	    ENDIF
**********FIN AREAS DE TRABAJO

**********INSERCION DE LOS GRUPOS
	    FOR i := 1 TO LEN(cMaeAlu)/3

*---------------AREAS DE TRABAJO
		  cMaeAct := SUBS(cMaeAlu,i*3-2,3)
		  CloseDbf('GRU')

		  IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+FileGru+;
				  cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
		     cError('ABRIENDO ARCHIVOS')
		     CloseAll()
		     IF !lFileDelete(FileTgr)
			cError('NO SE BORRO EL ARCHIVO TEMPORAL')
		     ENDIF
		     RETURN .F.
		  ENDIF
*---------------FIN AREAS DE TRABAJO

*---------------RECORRIDO DE LOS GRUPOS
		  SELECT GRU
		  GO TOP
		  DO WHILE .NOT. (GRU->(EOF()))

		     IF FUE->(lRegLock(lShared,.T.))
			REPL FUE->cCodigoGru WITH GRU->cCodigoGru
			FUE->(DBCOMMIT())
		     ELSE
			cError('NO SE GRABA LA FORMA DE PAGO')
		     ENDIF
		     IF lShared
			FUE->(DBUNLOCK())
		     ENDIF

		     SELECT GRU
		     GRU->(DBSKIP())

		  ENDDO
*---------------FIN RECORRIDO DE LOS GRUPOS

	    ENDFOR
	    CloseDbf('FUE')
	    CloseDbf('GRU')
**********FIN INSERCION DE LOS GRUPOS

**********AREAS DE TRABAJO
	    IF !lUseDbf(.T.,DIRNAME()+'\'+FileTgr,'GRU',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE GRUPOS')
	       CloseAll()
	       IF !lFileDelete(FileTgr)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN .F.
	    ENDIF
	    RETURN .T.
**********FIN AREAS DE TRABAJO

       ENDIF
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF 'JAR' $ cMaeAlu

	  PathGru := cPatSis+'\JAR\'
	  IF !lUseDbf(.T.,PathGru+FGruJar+cAnoSis+ExtFile,'GRU',NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE JARDIN EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'PRI' $ cMaeAlu

	  PathGru := cPatSis+'\PRI\'
	  IF !lUseDbf(.T.,PathGru+FGruPri+cAnoSis+ExtFile,'GRU',NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE PRIMARIA EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF

       IF 'BTO' $ cMaeAlu

	  PathGru := cPatSis+'\BTO\'
	  IF !lUseDbf(.T.,PathGru+FGruBto+cAnoSis+ExtFile,'GRU',NIL,lShared)
	     cError('ABRIENDO ARCHIVOS DE BACHILLERATO EN '+PathGru)
	     CloseAll()
	     RETURN .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE GRUPOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2002 DOM A
       Colombia, Bucaramanga        INICIO: 09:40 PM   JUL 07/2002 DOM


OBJETIVOS:

1- Debe estar en uso el archivo de grupos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de grupos.

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervGru(nNroFil,nNroCol,nRegIni,nRegFin,lIniFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final
       lIniFin                              // @ .T. Todos los Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
       LOCAL nIniReg := 0                   // Registro Inicial
       LOCAL nFinReg := 0                   // Registro Final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt ='GRADO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'GRADO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT GRU
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+3

	GRU->(DBGOTOP())
	nIniReg := GRU->(RECNO())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||GRU->cCodigoGru})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	GRU->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY GRU->cCodigoGru
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       GRU->(DBGOBOTTOM())
       nFinReg := GRU->(RECNO())

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
*>>>>FIN INTERCAMBIO DE REGISTROS

*>>>>ANALISIS DE TODOS LOS REGISTROS
       lIniFin := .F.
       IF nRegIni == nIniReg .AND. nRegFin == nFinReg
	  lIniFin := .T.
       ENDIF
       RETURN .T.
*>>>>FIN ANALISIS DE TODOS LOS REGISTROS