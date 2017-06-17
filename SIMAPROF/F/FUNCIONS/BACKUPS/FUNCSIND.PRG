/*                       SIMA - CONTABILIDAD PROFESORES
		 BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO INDBTO

REQUERIMIENTOS:

- Compilar: clipper FuncsInd /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:17 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/96 JUE A
       Bucaramanga,Colombia         INICIO: 05:14 PM   MAR 14/96 JUE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfInd(lShared,nModCry,PathArc,fArchvo,FileNtx,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cCodigoNiv','Character',02,0}) // C¢digo del Grado
       AADD(aDbfStr,{'cCodigoJui','Character',08,0}) // C¢digo del Indicador
       AADD(aDbfStr,{'cCodLogJui','Character',08,0}) // C¢digo del Logro
       AADD(aDbfStr,{'cIdeCodJui','Character',40,0}) // C¢digo de Identificaci¢n del Indicador
       AADD(aDbfStr,{'lSiSendJui','Logical',01,0}) // .T. Indicador Trasladado .F. Indicador NO Trasladado
       AADD(aDbfStr,{'lNoTrasJui','Logical',01,0}) // .T.= SI .F.= NO. Trasladar el Indicador para el traslado de TODOS los indicadores
       AADD(aDbfStr,{'cCodigoPro','Character',06,0}) // C¢digo del Profesor
       AADD(aDbfStr,{'nNroPerJui','Numeric',02,0}) // N£mero del Periodo
       AADD(aDbfStr,{'cNombreJui','Character',106,0}) // Nombre del Indicador
       AADD(aDbfStr,{'cExtra1Jui','Character',106,0}) // Continuaci¢n del Indicador

       AADD(aDbfStr,{'cNomUsrJui','Character',10,0}) // Nombre del Usuario
       AADD(aDbfStr,{'dFecUsrJui','Date'     ,08,0}) // Fecha del Usuario
       AADD(aDbfStr,{'cHorUsrJui','Character',10,0}) // Hora del Usuario
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

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
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:17 PM   MAR 14/96 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfInd(lShared,nModCry,PathArc,fArchvo,FileNtx)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       FileNtx				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE INDICADORES")
       Termometro(100)

       CreaDbfInd(lShared,nModCry,PathArc,fArchvo,FileNtx)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/2003 DOM A
       Colombia, Bucaramanga        INICIO: 11:00 PM   FEB 02/2003 DOM

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrInd(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       CloseDbf('JUI')
*>>>>FIN DECLARACION DE VARIABLES

wait 'paso ok'

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'JUI',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE JUICIOS')
	  CloseDbf('JUI',PathArc+'\'+fArchvo,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := JUI->(DBSTRUCT())
       CloseDbf('JUI',PathArc+'\'+fArchvo,nModCry)
       CreaDbfInd(lShared,nModCry,PathArc,fArchvo,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio
	  cError('El Archivo INDICADORES su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  nNroErr := 0
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfInd(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL INDICADORE EN EL BROWSE   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 20/96 MIE A
       Bucaramanga,Colombia         INICIO: 12:45 AM   MAR 20/96 MIE

1- Busca el c¢digo del indicador dentro del Browse

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarInd(oBrwInd,cCodInd,cCodNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwInd			      // Browse de Indicadores
       cCodInd                        // C¢digo del Indicador
       cCodNiv                        // C¢digo de Nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegJui := 0                   // Registro del Juico
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo del Indicador
       LOCAL cSecInd := ''                  // Secuencial del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cSecInd := SPACE(03)
       TitBuscar(LEN(cSecInd),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cSecInd PICT '999';
			 VALID lCorrecion(@cSecInd)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cSecInd == SPACE(03)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>ASIGNACION DEL CODIGO
       IF EMPTY(cCodNiv)
	  cCodigo := cCodInd+cSecInd
       ELSE
	  cCodigo := cCodNiv+cCodInd+cSecInd
       ENDIF
*>>>>FIN ASIGNACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT IND
       IF lBuscar .AND. lSekCodigo(cCodigo,'IND')
	   nRegJui := RECNO()
	   GO TOP
	   oBrwInd:GOTOP()
	   GO nRegJui
	   oBrwInd:FORCESTABLE()
       ELSE
	  oBrwInd:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LOS CODIGOS DE LOS LOGROS           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/96 JUE A
       Colombia, Bucaramanga        INICIO: 02:40 PM   SEP 19/96 JUE

OBJETIVOS:

1)- Permite leer los c¢digo de los logros para un estudiante

2)- Permite Evaluar el logro, si esta opci¢n se encuentra habilitada

3)- Realiza la validaci¢n de logros repetidos

4)- Retorna .T. si se leyeron los logros

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeLogro(cNomSis,nNroFil,nColIni,nNroPer,lIndNiv,cEvaInd,;
		   cCodGru,cCodNiv,nNroInd,nNroLog,cLogros,cNotInd,;
		   lHayNot,lNotNum,cNotDef,cValNot,cSavLin,cColAct)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del sistema
       nNroFil                              // @N£mero de la fila
       nColIni                              // Columna Inicial
       nNroPer                              // N£mero del Periodo
       lIndNiv                              // .T. Indicadores de Nivel
       cEvaInd			            //*Evaluar el indicador
       cCodGru                              // C¢digo del Grupo
       cCodNiv                              // C¢digo de Nivel
       nNroInd                              // N£mero de Indicadores
       nNroLog                              // N£mero de logros
       cLogros                              // @Logros a leer
       cNotInd                              //* @Notas de Indicadores
       lHayNot                              // .T. Leer Nota Definitiva
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       cNotDef                              // @Nota Definitiva
       cValNot                              // Validaci¢n de la Nota
       cSavLin                              // Salvar l¡nea
       cColAct                              // Color Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL       j := 0                   // Indice de lectura
       LOCAL  lSalir := .F.                 // .T. Abandonar la Grabaci¢n
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nTotLee := 0                   // Total de lecturas
       LOCAL nPosLog := 0                   // Posici¢n del logro
       LOCAL cPictur := ''                  // Picture de lectura
       LOCAL aLogros[nNroInd]               // Logros a leer
       LOCAL nLenInd := 6                   // Longitud del C¢digo
       LOCAL nLenNtI := 8                   // Longitud del C¢digo de la Nota de la Recuperaci¢n del Indicador

       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cCodRec := ''                  // C¢digo de Recuperaci¢n

       LOCAL cNotas  := ''                  // Nota del Indicador y de la Recuperaci¢n
       LOCAL cNotLog := ''                  // Nota del Logro
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n del logro

       LOCAL Getlist := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA COLUMNA INICIAL
       nNroCol := nColIni
*      IF nNroLog # 0 .AND. nNroLog # 1 .AND. nNroInd > 10
       IF nNroLog # 0 .AND. nNroLog # 1
	  nNroCol := nColIni+((nNroLog-1)*6)
       ENDIF
*>>>>FIN ANALISIS DE LA COLUMNA INICIAL

*>>>>LECTURA DE LOS LOGROS ALMACENADOS
       FOR i:=1 TO nNroInd

	   cCodLog := cCodLogN(cLogros,i,nLenInd,cEvaInd,@cCodEva,@cCodRec)
	  *Lectura del C¢digo

	   DO CASE
	   CASE cEvaInd == '0'
		aLogros[i] := cCodLog+cCodEva+cCodRec

	   CASE cEvaInd == '1'
		aLogros[i] := cCodLog+cCodEva+cCodRec

	   CASE cEvaInd == '2'
		aLogros[i] := cCodLog+cCodEva+cCodRec
	   ENDCASE

       NEXT
     *ÀLee los logros almacenados
*>>>>FIN LECTURA DE LOS LOGROS ALMACENADOS

*>>>>ANALISIS PARA GRABAR LA NOTA DEFINTIVA
       nTotLee := IF(nNroLog == 0,nNroInd,1)
       IF lHayNot
	  IF lNotNum
	     AADD(aLogros,VAL(cNotDef))
	  ELSE
	     AADD(aLogros,cNotDef)
	  ENDIF
	  nTotLee++
       ENDIF
*>>>>FIN ANALISIS PARA GRABAR LA NOTA DEFINTIVA

*>>>>LECTURA DE LOS LOGROS
       FOR i := 1 TO nTotLee

***********SELECCION DEL PICTURE
	     IF i # nTotLee .OR. !lHayNot

*---------------PICTURE PARA LOS LOGROS
		  nPosLog := IF(nNroLog==0,i,nNroLog)
		  DO CASE
		  CASE cEvaInd == '0'
		       cPictur := 'X999'

		  CASE cEvaInd == '1'
		       cPictur := 'X999X'

		  CASE cEvaInd == '2'
		       cPictur := '99.9'
		  ENDCASE
*---------------FIN PICTURE PARA LOS LOGROS

	     ELSE

*---------------ASIGNACION DE LA FILA DE LECTURA
		  IF nNroInd > 10
		     nNroCol := nColIni+60
		  ELSE
		     IF nNroLog # 0
			nNroCol := nColIni+(nNroInd*6)
		     ENDIF
		  ENDIF
		  nPosLog := nNroInd+1
*---------------FIN ASIGNACION DE LA FILA DE LECTURA

*---------------PICTURE PARA LA NOTA DEFINITIVA
		  IF lNotNum
		     cPictur := '99.9'
		  ELSE
		     cPictur := 'A'
		  ENDIF
*---------------FIN PICTURE PARA LA NOTA DEFINITIVA

	     ENDIF
***********FIN SELECCION DEL PICTURE

***********LECTURA DEL CODIGO DEL LOGRO
	     @ nNroFil,nNroCol GET aLogros[nPosLog] PICT cPictur;
		       VALID {|oLeeGet|lIndicador(nNroPer,lIndNiv,cEvaInd,;
						  cCodNiv,lHayNot,lNotNum,;
						  cValNot,nNroLog,aLogros,;
						  oLeeGet,@lSalir,cSavLin)};
		       WHEN {|oLeeGet|HelpLogro(cNomSis,cEvaInd,;
						oLeeGet,nNroLog,cCodGru)}
***********FIN LECTURA DEL CODIGO DEL LOGRO

***********CALCULO DE LA FILA Y COLUMA PROXIMA LECTURA
	     nNroCol += 6
	     DO CASE
	     CASE nNroLog == 0
		  IF i == 10 .AND. nNroInd > 10
		     nNroFil++
		     nNroCol := nColIni
		  ENDIF
	     OTHERWISE
		  IF i+1 == nTotLee .AND. nNroInd > 10
		     nNroFil++
		     nNroCol := nColIni
		  ENDIF
	     ENDCASE
***********FIN CALCULO DE LA FILA Y COLUMA PROXIMA LECTURA

       NEXT
       READ
*>>>>FIN LECTURA DE LOS LOGROS

*>>>>ANALISIS DE LA SALIDA DEL LOGROS
       IF !lSalir

**********ASIGNACION DE LAS LECTURAS
	    FOR i := 1 TO nNroInd

		cCodInd := SUBS(cLogros,nPosIni(i,nLenInd),nLenInd)
		cCodLog := SUBS(cCodInd,5,1)
		cCodEva := SUBS(cCodInd,5,1)
		cCodRec := SUBS(cCodInd,6,1)

		cNotas  := SUBS(cNotInd,nPosIni(i,nLenNtI),nLenNtI)
		cNotLog := SUBS(cNotInd,1,4)
		cNotRec := SUBS(cNotInd,5,4)

		DO CASE
		CASE cEvaInd == '0'
		     cCodLog := SUBS(aLogros[i],1,4)

		CASE cEvaInd == '1'
		     cCodLog := SUBS(aLogros[i],1,4)
		     cCodEva := SUBS(aLogros[i],5,1)

		CASE cEvaInd == '2'
		     cNotLog := SUBS(aLogros[i],1,4)
		ENDCASE

		cCodInd := cCodLog+cCodEva+cCodRec
		cLogros := STUFF(cLogros,nPosIni(i,nLenInd),nLenInd,cCodInd)

		cNotInd := STUFF(cNotInd,nPosIni(i,8),8,cNotLog+cNotRec)

	    NEXT
	  *ÀAsignaci¢n de los logros

	    IF lHayNot
	       IF lNotNum
		  cNotDef := STR(aLogros[nNroInd+1],4,1)
	       ELSE
		  cNotDef := UPPER(SUBS(aLogros[nNroInd+1],1,1))+SPACE(03)
	       ENDIF
	    ENDIF
	  *ÀAsignaci¢n de la nota Definitiva
**********FIN ASIGNACION DE LAS LECTURAS

       ENDIF
       RETURN !lSalir
*>>>>FIN ANALISIS DE LA SALIDA DEL LOGROS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL LOGRO                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   SEP 19/96 JUE

OBJETIVOS:

1)- Verifica la salida de la grabaci¢n de los logros

2)- Valida la duplicaci¢n de logros aplicados

3)- Valida la existencia de la clase de indicador, el indicador,
    el c¢digo de Evaluaci¢n.

4)- Retorna .T. si no se presentaron problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/
                              
FUNCTION lIndicador(nNroPer,lIndNiv,cEvaInd,cCodNiv,lHayNot,;
		    lNotNum,cValNot,nNroLog,aLogros,oLeeGet,;
		    lSalir,cSavLin,cLogros,lCambia,lLeeRec,;
		    lEvaInd)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroPer                              // N£mero del Periodo
       lIndNiv                              // .T. Indicador de Nivel
       cEvaInd			            // *Evaluador del Indicador
       cCodNiv                              // C¢digo de Nivel
       lHayNot                              // .T. Hay Nota para leer
       lNotNum                              // .T. Nota Numerica .F. Nota Cualitativa
       cValNot                              // Validaci¢n de la Nota
       nNroLog                              // N£mero de logro
       aLogros                              // Logros leidos
       oLeeGet                              // Objeto de Lectura
       lSalir                               // @.T. Terminar la grabaci¢n
       cSavLin                              // Salvar la l¡nea
       cLogros                              // Logros a Leer
       lCambia                              // .T. Cambia el Indicador de Acuerdo a la Evaluaci¢n
       lLeeRec                              // .T. Leer Recuperaci¢n
       lEvaInd                              // .T. Evaluar el indicador */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nCodLog := 0                   // C¢digo del logro Numerico
       LOCAL nValNot := 0                   // Validaci¢n de la Nota

       LOCAL cCodInd := ''                  // C¢digo del Indicador
       LOCAL cCodEva := ''                  // C¢digo de Evaluaci¢n

       LOCAL xCodLog := ''                  // Logro o Nota leida
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL nPosLog := 0                   // Posici¢n del Logro
       LOCAL nPosUno := 0                   // Posici¢n Uno de B£squeda
       LOCAL nPosDos := 0                   // Posici¢n Dos de B£squeda
       LOCAL cDificu := ''                  // Dificultades asociadas
       LOCAL nNroDif := 0                   // N£mero de la Dificultad

       LOCAL cCodigoTcl := ''               // C¢digo de la Clase
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCodigoTev := ''               // C¢digo de Evaluaci¢n
       LOCAL cNombreTju := ''               // Nombre del Juicio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL CODIGO
       DO CASE
       CASE cEvaInd == '0'
	       xCodLog := oLeeGet:VarGet()
	    cCodigoTev := SPACE(01)

       CASE cEvaInd == '1'

	    xCodLog := oLeeGet:VarGet()
	    IF LEN(xCodLog) == 1
	       cCodigoTev := xCodLog
	    ELSE
	       cCodigoTev := SUBS(xCodLog,5,1)
	    ENDIF

       CASE cEvaInd == '2'
	       xCodLog := oLeeGet:VarGet()
	    cCodigoTev := cNotDefJvf(xCodLog)
	       xCodLog := STR(xCodLog,4,1)

       ENDCASE
*>>>>FIN LECTURA DEL CODIGO

*>>>>ANALISIS DE LA NOTA DEFINITIVA
       IF LEN(aLogros) # oLeeGet:Subscript[1]
	  cCodInd := SUBS(xCodLog,1,4)
       ELSE
	  cCodInd := SPACE(04)
       ENDIF
*>>>>FIN ANALISIS DE LA NOTA DEFINITIVA

*>>>>ANALISIS PARA LA SALIDA
       lSalir := .F.

       IF !EMPTY(cLogros)
	  nPosLog := oLeeGet:Subscript[1]
	  cCodInd := SUBS(cLogros,nPosLog*6-5,4)
       ENDIF

//       IF oLeeGet:Subscript[1] == 1 .OR. nNroLog # 0       // No permite recuperar solo la nota
	 IF oLeeGet:Subscript[1] == 1 .AND. LEN(aLogros) > 1 // Para permitir recuperar solo la nota

	  DO CASE
	  CASE cEvaInd == '0' .AND. 'X' $ xCodLog
	       lSalir := .T.
	       KEYBOARD CHR(27)
	      * <ESC> para abandonar la edici¢n
	       RETURN .T.

	  CASE cEvaInd == '1' .AND. 'X' $ xCodLog
	       lSalir := .T.
	       KEYBOARD CHR(27)
	      * <ESC> para abandonar la edici¢n
	       RETURN .T.

	  CASE cEvaInd == '2' .AND. VAL(xCodLog) == 11
	       lSalir := .T.
	       KEYBOARD CHR(27)
	      * <ESC> para abandonar la edici¢n
	       RETURN .T.

	  ENDCASE

       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA

*>>>>VALIDACION DEL CONTINIDO DEL LOGRO
       RESTSCREEN(21,0,22,79,cSavLin)
       IF cEvaInd == '0' .AND. EMPTY(xCodLog)
	  RETURN .T.
       ENDIF
*>>>>FIN VALIDACION DEL CONTINIDO DEL LOGRO

*>>>>VALIDACION DE LA NOTA DEFINITIVA
       IF lHayNot .AND. (oLeeGet:Picture == '99.9' .OR.;
			 oLeeGet:Picture == 'A')

	  IF lNotNum

*------------ANALISIS DE DECISION
	       DO CASE
	       CASE VALTYPE(xCodLog) == 'C'
		    nCodLog := VAL(xCodLog)

	       CASE VALTYPE(xCodLog) == 'N'
		    nCodLog := xCodLog
	       OTHERWISE
		    cError('ERROR DE xCodLog')
	       ENDCASE

	       DO CASE
	       CASE VALTYPE(cValNot) == 'C'
		    nValNot := VAL(ALLTRIM(cValNot))

	       CASE VALTYPE(cValNot) == 'N'
		    nValNot := cValNot

	       OTHERWISE
		    cError('ERROR DE cValNot')
	       ENDCASE
*------------FIN ANALISIS DE DECISION

*------------VALIDACION NOTA NUMERICA
	       IF nCodLog > nValNot
		  cError('NOTA POR FUERA DE RANGO:'+STR(nValNot,5,2))
		  RETURN .F.
	       ELSE
		  RETURN .T.
	       ENDIF
*------------FIN VALIDACION NOTA NUMERICA

	  ELSE

*------------VALIDACION NOTA CUALITATIVA
	       IF !(SUBS(xCodLog,1,1) $ cValNot) .AND. cEvaInd # '2'
		  cError('NOTA CUALITATIVA NO PERMITIDA')
		  RETURN .F.
	       ENDIF
*------------FIN VALIDACION NOTA CUALITATIVA

	  ENDIF

       ENDIF
*>>>>FIN VALIDACION DE LA NOTA DEFINITIVA

*>>>>VALIDACION DE LOGROS REPETIDOS
       lLeeRec := IF(lLeeRec==NIL,.F.,lLeeRec) // Modificado
       lEvaInd := IF(lEvaInd==NIL,.F.,lEvaInd) // Modificado
       IF (cEvaInd == '0' .OR. cEvaInd == '1') .AND. !EMPTY(xCodLog) .AND.;
	  !lEvaInd  // Modificado

	  nPosUno := ASCAN(aLogros,SUBS(xCodLog,1,4))
	  nPosDos := ASCAN(aLogros,SUBS(xCodLog,1,4),nPosUno+1)

	  IF !(nPosUno # 0 .AND. nPosDos == 0)
	     cError('YA APLICO EL CODIGO: '+SUBS(xCodLog,1,4))
	     RETURN .F.
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LOGROS REPETIDOS

*>>>>LOCALIZACION DE LA CLASE DE INDICADOR
       cCodigoTcl := UPPER(SUBS(cCodInd,1,1))

       IF !EMPTY(cCodigoTcl)

	  IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,'DE LA CLASE')

	     IF EMPTY(CLA->cCodigoMat)
		cCodigoTni := cCodNiv
		cCodigoTma := MAT->cCodigoMat
	     ELSE
		cCodigoTni := SPACE(02)
		cCodigoTma := CLA->cCodigoMat
	     ENDIF
	   *ÀAsignaci¢n del nivel para usar indicador nivel o materia

	  ELSE
	      cError('LA CLASE DE INDICADOR: '+cCodigoTcl+' NO EXISTE')
	      RETURN .F.
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA CLASE DE INDICADOR

*>>>>BUSQUEDA DEL LOGRO
       IF !EMPTY(cCodigoTcl)

	  IF !EMPTY(SUBS(xCodLog,1,4))
	     IF !lSekCodigo(IF(lIndNiv,;
			       cCodigoTni+cCodigoTma+cCodInd,;
			       cCodigoTma+cCodInd),'IND')
		cError('Indicador: '+cCodInd+' No Existe')
		RETURN .F.
	     ENDIF
	     cNombreTju := ALLTRIM(IND->cNombreJui)
	     cNombreTju := IF(LEN(cNombreTju) < 75,cNombreTju,;
			      SUBS(cNombreTju,1,75)+'...')
	     Centrar(cNombreTju,21,01)
	  ENDIF

       ENDIF
*>>>>FIN BUSQUEDA DEL LOGRO

*>>>>VALIDACION DE LA NOTA DE LA CLASE
       lLeeRec := IF(lLeeRec == NIL,.F.,lLeeRec)
       DO CASE
       CASE cEvaInd == '2' .AND. !lLeeRec

	    IF !(VAL(xCodLog) >= CLA->nNotIniCla .AND.;
		VAL(xCodLog) <= CLA->nNotFinCla)

	       cError('NOTA INVALIDA PARA LA CLASE DE INDICADOR')
	       RETURN .F.

	    ENDIF

       CASE cEvaInd == '2' .AND. lLeeRec

	    IF !(VAL(xCodLog) >= CLA->nNtIRecCla .AND.;
		VAL(xCodLog)  <= CLA->nNtFRecCla)

	       cError('NOTA INVALIDA PARA LA CLASE DE INDICADOR')
	       RETURN .F.

	    ENDIF

       ENDCASE
*>>>>FIN VALIDACION DE LA NOTA DE LA CLASE

/*
*>>>>SIMAMULACION DEL BORRADO EL LOGRO
       lCambia := IF(EMPTY(lCambia),.F.,lCambia)
       IF lCambia
	  IF UPPER(SUBS(xCodLog,5,1)) == '.'
	     @ oLeeGet:Row,oLeeGet:Col-4 SAY SPACE(04) COLOR("I")
	     RETURN .T.
	  ENDIF
       ENDIF
*>>>>FIN SIMAMULACION DEL BORRADO EL LOGRO
*/

*>>>>LOCALIZACION DEL CODIGO DE EVALUACION
       IF !EMPTY(cCodigoTev) .AND. !EMPTY(cLogros)

	  IF !lLocCodigo('cCodigoEva','EVA',cCodigoTev)

	     cError('EL CODIGO DE EVALUACION: '+cCodigoTev+' NO EXISTE')

	     KEYBOARD CHR(6)
	    * <END> para ir al final del campo

	     RETURN .F.
	  ENDIF
	  Centrar(ALLTRIM(EVA->cNombreEva),22)
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO DE EVALUACION

/*
*>>>>CONSULTA DEL REEMPLAZO DEL INDICADOR
       IF lCambia
	  IF !EVA->lAproboEva

	     cDificu := SUBS(&('CAP->cDific'+STR(nNroPer,1,0)+'CaP'),;
				oLeeGet:Subscript[1]*25-24,25)
	    *Lectura de la dificultadad asociada al logro

	     nNroDif := IF(EMPTY(EVA->nNroDifEva),1,EVA->nNroDifEva)
	     cCodLog := SUBS(cDificu,nNroDif*5-4,4)
	     IF !EMPTY(cCodLog)
		@ oLeeGet:Row,oLeeGet:Col-4 SAY cCodLog
	     ENDIF
	  ELSE
	     cCodLog := SUBS(&('CAP->cLogro'+STR(nNroPer,1,0)+'CaP'),;
			     oLeeGet:Subscript[1]*5-4,4)
	     @ oLeeGet:Row,oLeeGet:Col-4 SAY cCodLog COLOR("I")
	  ENDIF
       ENDIF
*/
       RETURN .T.
*>>>>FIN CONSULTA DEL REEMPLAZO DEL INDICADOR

/*************************************************************************
* TITULO DE LA FUNCION..: AYUDA PARA LA LECTURA DEL CODIGO DEL LOGRO     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   SEP 19/96 JUE

OBJETIVOS:

1)- Verifica la salida de la grabaci¢n de los logros

2)- Valida la duplicaci¢n de logros aplicados

3)- Valida la existencia de la clase de indicador, el indicador,
    el c¢digo de Evaluaci¢n.

4)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HelpLogro(cNomSis,cEvaInd,oLeeGet,nNroLog,cCodGru,lCambia)

*>>>>DESCRIPCION DE PARAMETRO
/*     cNomSis                              // Nombre del Sistema
       cEvaInd                              // Evaluaci¢n del Indicador
       oLeeGet                              // Objeto de lectura
       cCodGru                              // C¢digo del Grupo
       lCambia                              // .T. Cambia */
*>>>>FIN DESCRIPCION DE PARAMETRO

*>>>>VISUALIZACION DE LA AYUDA
       lCambia := IF(EMPTY(lCambia),.F.,lCambia)
       IF nNroLog == 0
	  IF oLeeGet:Subscript[1] == 1
	     LineaEstado('GRUPO: '+cCodGru+;
		      '. TECLEE '+;
		      IF(cEvaInd=='2','11','X')+' PARA TERMINAR',cNomSis)
	  ELSE
	     IF lCambia
		 LineaEstado('GRUPO: '+cCodGru+;
			     '. TECLEE EL CODIGO DEL LOGRO. '+;
			     '<ESC>ABANDONA <.>BORRA EL LOGRO',cNomSis)
	     ELSE
		 LineaEstado('GRUPO: '+cCodGru+;
			     '. TECLEE EL CODIGO DEL LOGRO. '+;
			     '<ESC> ABANDONA',cNomSis)
	     ENDIF
	  ENDIF
       ELSE
	  LineaEstado('GRUPO: '+cCodGru+;
		      '. TECLEE X PARA TERMINAR',cNomSis)
       ENDIF
       RETURN .T.
*>>>>FIN VISUALIZACION DE LA AYUDA

/*************************************************************************
* TITULO DE LA FUNCION..: VISULIZACION DE LOS LOGROS DEL ESTUDIANTE      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/96 DOM A
       Colombia, Bucaramanga        INICIO: 05:20 PM   OCT 06/96 DOM

OBJETIVOS:

1- Visualiza las notas o logros de los del estudiante

2- Retorna Nil


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/
	 
FUNCTION DisplayLog(nNroFil,nColIni,cEvaInd,cLogros,cNotInd,;
		    nNroInd,lHayNot,cNotDef,cNroFal)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // @N£mero de la fila
       nColIni                              // Columba Inicial
       cEvaInd			            // Evaluar el Indicador
       cLogros                              // Logros del Estudiante
       cNotInd                              // Nota de Indicadores
       nNroInd                              // N£mero de Indicadores
       lHayNot                              // .T. Hay Nota Definitiva
       cNotDef                              // Nota Definitiva
       cNroFal                              // N£mero de Fallas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL nSiPaso := 0                   // Control de flujo
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL nColDef := 0                   // Columna de la Definitiva
       LOCAL nLenInd := 6                   // Longitud del C¢digo del Indicador
       LOCAL nLenNtI := 8                   // Longitud del C¢digo de la Nota de la Recuperaci¢n del Indicador
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL cCodEva := ''                  // C¢digo de la Evaluaci¢n
       LOCAL cPicInd := ''                  // Picture del Indicador
       LOCAL cPicEva := ''                  // Picture de la Evaluaci¢n
       LOCAL nMaxInd := 0                   // M ximo de Indicadores a visualizar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS LOGROS
       lHayNot := IF(lHayNot == NIL,.F.,lHayNot)
       nNroCol := nColIni
       FOR i := 1 TO nNroInd

************IMPRESION DEL LOGRO
	      DO CASE
	      CASE cEvaInd == '0'

		   cCodLog := cCodLogN(cLogros,i,nLenInd,cEvaInd,@cCodEva)
		   cPicInd := 'AAAA'
		   cPicEva := ''

		   @ nNroFil,nNroCol SAY cCodLog PICT cPicInd COLOR('I')

	      CASE cEvaInd == '1'

		   cCodLog := cCodLogN(cLogros,i,nLenInd,cEvaInd,@cCodEva)
		   cCodEva := SUBS(cCodLog,5,1)
		   cPicInd := 'AAAA'
		   cPicEva := 'A'

		   @ nNroFil,nNroCol SAY cCodLog PICT cPicInd
		   @ nNroFil,nNroCol+LEN(cCodLog)+1 SAY cCodEva PICT cPicEva COLOR('I')

	      CASE cEvaInd == '2'

		   cCodLog := cCodLogN(cLogros,i,nLenInd,cEvaInd)
		   cCodLogN(cNotInd,i,nLenNtI,cEvaInd,@cCodEva)
		   cPicInd := 'AAAA'
		   cPicEva := '99.9'

		   @ nNroFil,nNroCol SAY cCodLog PICT cPicInd
		   @ nNroFil,nNroCol+LEN(cCodLog) SAY cCodEva PICT cPicEva COLOR('I')

	      ENDCASE
************FIN IMPRESION DEL LOGRO

************CALCULO DE LA COLUMNA
	      DO CASE
	      CASE cEvaInd == '0'
		   nNroCol += 6  // 4:Indicador+1:Nota+1:Espacio
		   nMaxInd := 10

	      CASE cEvaInd == '1'
		   nNroCol += 6  // 4:Indicador+1:Nota+1:Espacio
		   nMaxInd := 10

	      CASE cEvaInd == '2'
		   nNroCol += 9  // 4:Indicador+4:Nota
		   nMaxInd := 4  // Indicadores

	      ENDCASE
************FIN CALCULO DE LA COLUMNA

************ANALISIS DEL CAMBIO DE LA FILA
	      IF ++j == nMaxInd .AND. nNroInd > nMaxInd

		 nSiPaso++
		 IF nMaxInd*nSiPaso # nNroInd
		    nNroFil++
		 ENDIF

		 nColDef := nNroCol
		 nNroCol := nColIni
		 j := 0

	      ELSE
		 IF nSiPaso == 0
		    nColDef := nNroCol
		 ENDIF
	      ENDIF
************FIN ANALISIS DEL CAMBIO DE LA FILA

       NEXT
*>>>>FIN IMPRESION DE LOS LOGROS

*>>>>IMPRESION DE LA NOTA DEFINITIVA Y EL NUMERO DE FALLAS
       nNroCol := IF(nNroInd>10,nColIni+60,nNroCol)
       IF lHayNot .OR. cEvaInd == '2'

	  @ nNroFil,nColDef SAY cNotDef PICT 'AAAA' COLOR("I")

	  IF cNroFal # NIL
	     @ nNroFil,nNroCol+5 SAY cNroFal PICT 'AA' COLOR("I")
	  ENDIF
       ELSE
	  IF cNroFal # NIL
	     @ nNroFil,nNroCol SAY cNroFal PICT 'AA' COLOR("I")
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LA NOTA DEFINITIVA Y EL NUMERO DE FALLAS

/*************************************************************************
* TITULO..: CODIGO DEL LOGRO                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/2002 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   MAY 03/2002 VIE

OBJETIVOS:

1- Calcula el c¢digo del indicador de acuerdo a si esta evaluado o no

2- Retorna el c¢digo del Indicador

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodLog(cCodigo,cEvaInd,cCodEva,cCodRec)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo				    // C¢digo del Indicador
       cEvaInd			            // Indicador Evaluado
       cCodEva                              // @C¢digo de la Evaluaci¢n
       cCodRec                              // @C¢digo de Recuperaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodInd := ''                  // C¢digo del Logro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DEL CODIGO
       DO CASE
       CASE cEvaInd == '0' .AND. LEN(cCodigo) == 6
	    cCodInd := SUBS(cCodigo,1,4)
	    cCodEva := SUBS(cCodigo,5,1)
	    cCodRec := SUBS(cCodigo,6,1)

       CASE cEvaInd == '1' .AND. LEN(cCodigo) == 6
	    cCodInd := SUBS(cCodigo,1,4)
	    cCodEva := SUBS(cCodigo,5,1)
	    cCodRec := SUBS(cCodigo,6,1)

       CASE cEvaInd == '2'

	    DO CASE
	    CASE LEN(cCodigo) == 6
		 cCodInd := SUBS(cCodigo,1,4)
		 cCodEva := SUBS(cCodigo,5,1)
		 cCodRec := SUBS(cCodigo,6,1)

	    CASE LEN(cCodigo) == 8
		 cCodInd := ''
		 cCodEva := SUBS(cCodigo,1,4)
		 cCodRec := SUBS(cCodigo,5,4)
	    ENDCASE

       ENDCASE
       RETURN cCodInd
*>>>>FIN LECTURA DEL INDICADOR

/*************************************************************************
* TITULO..: CODIGO DEL LOGRO n                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/2002 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAY 03/2002 VIE

OBJETIVOS:

1- Calcula el N c¢digo del logro de acuerdo a la posici¢n en la secuencia
   de logros.

2- Retorna el c¢digo del Indicador

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodLogN(cCodigo,nPosLog,nLenCod,cEvaInd,cCodEva,cCodRec)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo				    // Cadena de C¢digos
       nPosLog                              // Posici¢n del Logro
       nLenCod                              // Longitud del c¢digo del Logro
       cEvaInd			            // *Evaluar el Indicador
       cCodEva                              // @C¢digo de la Evaluaci¢n
       cCodRec                              // @C¢digo de Recuperaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL xCodigo := ''                  // C¢digo del Logro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL CODIGO DEL LOGRO
       xCodigo := SUBS(cCodigo,nPosIni(nPosLog,nLenCod),nLenCod)
      *Lectura de la estructura del C¢digo

       xCodigo := cCodLog(xCodigo,cEvaInd,@cCodEva,@cCodRec)
      *Lectura del C¢digo de acuerdo a si esta evaluado o no.

       RETURN xCodigo
*>>>>FIN CALCULO DEL CODIGO DEL LOGRO


