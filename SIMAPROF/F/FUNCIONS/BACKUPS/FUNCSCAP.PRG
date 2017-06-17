/*                       SIMA - CONTABILIDAD PROFESORES
	     BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CARGAS

REQUERIMIENTOS:

- Compilar: clipper FuncsCaP /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Cargas

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/


/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 10:44 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCaP(lShared,PathCaP,FileCaP,fNtxCaP,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathCaP				    // Path del Archivo
       FileCaP				    // Nombre del Archivo
       fNtxCaP				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cUnidad := ''                  // Unidad de Disco
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfCaP := {{"cCodigoCar","Character",008,0},;
			 {"nTipCarCar","Numeric"  ,001,0},; // Tipo de Carga. 0=>Normal 1=>Variable por Grupo 2=>Variable por Nivel 3=>Variable por Niveles
			 {"cNombreMat","Character",080,0},; // 30
			 {"nNroRetCaP","Numeric"  ,002,0},;
			 {"cNroNotCaP","Character",010,0},;
			 {"cNroIndCaP","Character",010,0},;
			 {"cCriEvaCaP","Character",032,0},;
			 {"cGruNotCap","Character",040,0},;
			 {"cPorcenCaP","Character",064,0},;
			 {"cLogro1CaP","Character",100,0},; // Logros 1 Periodo
			 {"cLogro2CaP","Character",100,0},; // Logros 2 Periodo
			 {"cLogro3CaP","Character",100,0},; // Logros 3 Periodo
			 {"cLogro4CaP","Character",100,0},; // Logros 4 Periodo
			 {"cLogro5CaP","Character",100,0},; // Logros 5 Periodo
			 {"cNroDifCaP","Character",010,0},; // N£mero de Dificultades por Logro. Dos Caracteres por cada periodo.
			 {"cDific1CaP","Character",500,0},; // Difultades 1 Periodo. Para cada logro pueden tener asociado 5 Dificultades
			 {"cDific2CaP","Character",500,0},; // Difultades 2 Periodo. Para cada logro pueden tener asociado 5 Dificultades
			 {"cDific3CaP","Character",500,0},; // Difultades 3 Periodo. Para cada logro pueden tener asociado 5 Dificultades
			 {"cDific4CaP","Character",500,0},; // Difultades 4 Periodo. Para cada logro pueden tener asociado 5 Dificultades
			 {"cDific5CaP","Character",500,0},; // Difultades 5 Periodo. Para cada logro pueden tener asociado 5 Dificultades
			 {"cRecom1CaP","Character",500,0},; // Recomendaciones 1 Periodo. Para cada dificultad se puede asociar una Recomendaci¢n
			 {"cRecom2CaP","Character",500,0},; // Recomendaciones 2 Periodo. Para cada dificultad se puede asociar una Recomendaci¢n
			 {"cRecom3CaP","Character",500,0},; // Recomendaciones 3 Periodo. Para cada dificultad se puede asociar una Recomendaci¢n
			 {"cRecom4CaP","Character",500,0},; // Recomendaciones 4 Periodo. Para cada dificultad se puede asociar una Recomendaci¢n
			 {"cRecom5CaP","Character",500,0},; // Recomendaciones 5 Periodo. Para cada dificultad se puede asociar una Recomendaci¢n
			 {"cIndi01CaP","Character",050,0},;
			 {"cIndi02CaP","Character",050,0},;
			 {"cIndi03CaP","Character",050,0},;
			 {"cIndi04CaP","Character",050,0},;
			 {"cIndi05CaP","Character",050,0},;
			 {"cIndi06CaP","Character",050,0},;
			 {"cIndi07CaP","Character",050,0},;
			 {"cIndi08CaP","Character",050,0},;
			 {"cIndi09CaP","Character",050,0},;
			 {"cIndi10CaP","Character",050,0},;
			 {"cIndi11CaP","Character",050,0},;
			 {"cIndi12CaP","Character",050,0},;
			 {"cIndi13CaP","Character",050,0},;
			 {"cIndi14CaP","Character",050,0},;
			 {"cIndi15CaP","Character",050,0},;
			 {"cIndi16CaP","Character",050,0},;
			 {"cIndi17CaP","Character",050,0},;
			 {"cIndi18CaP","Character",050,0},;
			 {"cIndi19CaP","Character",050,0},;
			 {"cIndi20CaP","Character",050,0}}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCaP
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CAMBIO A LA UNIDAD DE DISKETTE
       PathAct := cPathAct()
       IF PathCaP == 'A:' .OR. PathCaP == 'B:'
	  cUnidad := DISKNAME()
	  IF !DISKCHANGE(PathCaP)
	     cError('NO SE CAMBIO A LA UNIDAD '+PathCaP)
	  ENDIF
       ENDIF
*>>>>FIN CAMBIO A LA UNIDAD DE DISKETTE

*>>>>CREACION DE LA ESTRUCTURA
       DO CASE
       CASE DIRCHANGE(PathCaP) == 0 .OR. PathCaP == 'A:' .OR. PathCaP == 'B:'
	    DBCREATE(FileCaP,aDbfCaP,"DBFNTX")

       CASE DIRCHANGE(PathCaP) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCaP)

       CASE DIRCHANGE(PathCaP) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCaP)
       ENDCASE
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>CAMBIO A LA UNIDAD DEL DISCO DURO
       IF PathCaP == 'A:' .OR. PathCaP == 'B:'
	  IF !DISKCHANGE(cUnidad)
	     cError('NO SE CAMBIO A LA UNIDAD '+cUnidad)
	  ENDIF
       ENDIF
       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CAMBIO A LA UNIDAD DEL DISCO DURO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 10:50 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCaP(lShared,PathCaP,FileCaP,fNtxCaP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathCaP			      // Path del Archivo
       FileCaP			      // Nombre del Archivo
       fNtxCaP			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCaP+'\'+FileCaP,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE PROFESOR")
       Termometro(100)

       CreaDbfCaP(lShared,PathCaP,FileCaP,fNtxCaP)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/2001 MAR A
       Colombia, Bucaramanga        INICIO: 02:45 PM   OCT 30/2001 MAR

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

FUNCTION nActStrCaP(lShared,nModCry,PathCaP,FileCaP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       FileCaP				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathCaP+'\'+FileCaP,'CAP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CARGAS DEL PROFESOR')
	  CloseDbf('CAP',PathCaP+'\'+FileCaP,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CAP->(DBSTRUCT())
       CloseDbf('CAP',PathCaP+'\'+FileCaP,nModCry)
       CreaDbfCaP(lShared,PathCaP,FileCaP,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
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
	  lCambio := .T.
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(FileCaP,1,AT('.',FileCaP))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathCaP+'\'+FileCaP,;
			 PathCaP+'\'+FileTem,;
			 {||CreaDbfCaP(lShared,PathCaP,FileTem)},nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE GRUPOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MIE 28/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:25 PM   MIE 28/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de Cargas del Profesor

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de materias

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervCaP(nNroFil,nNroCol,nRegIni,nRegFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt ='CURSO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'CURSO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT CAP
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - IF(RECCOUNT()>1,1,0)
	ENDIF
	nColInf := nColSup+LEN(CAP->cNombreMat)-17

	CAP->(DBGOTOP())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||SUBS(CAP->cCodigoCar,5,4)+' '+Materia()})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	CAP->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY SUBS(CAP->cCodigoCar,5,4)+' '+Materia()
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       CAP->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||SUBS(CAP->cCodigoCar,5,4)+' '+Materia()})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       CAP->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY SUBS(CAP->cCodigoCar,5,4)+' '+Materia()
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
       RETURN .T.
*>>>>FIN INTERCAMBIO DE REGISTROS

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCIONAR LA CARGA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MIE 28/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:25 PM   MIE 28/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de Cargas del Profesor

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de materias

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelCarga(nNroFil,nNroCol,nNroReg,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nNroReg		                    // @N£mero del registro escogido
       cTitulo                              // T¡tulo de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cTitulo := IF(cTitulo == NIL,'',cTitulo)
       @ nNroFil,nNroCol SAY cTitulo
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>SELEECION DEL GRUPO
	SELECT CAP
	nNroCol = nNroCol + LEN(cTitulo)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nColInf := nColSup+LEN(CAP->cNombreMat)-17

	CAP->(DBGOTOP())
	nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||SUBS(CAP->cCodigoCar,5,4)+' '+Materia()})
	IF nNroReg == 0
	   RETURN .F.
	ENDIF
	CAP->(DBGOTO(nNroReg))
	RETURN .T.
*>>>>FIN SELEECION DEL GRUPO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL NUMERO DE INDICADORES              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/96 LUN A
       Colombia, Bucaramanga        INICIO: 02:25 PM   MAR 25/96 LUN

OBJETIVOS:

1- Lectura y valida el n£mero del bimestre

2- Retorna .T. si se leyo el bimestre

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeNroInd(lShared,nNroFil,nNroCol,nNroPer,nTotInd)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nNroPer			            // N£mero del Periodo
       nTotInd                              // Total de Indicadores */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL nNroInd := 0                   // N£mero de indicadores
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA Y VALIDACION
       nTotInd := IF(nTotInd == NIL,20,nTotInd)
       cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
       Centrar('Entre el N£mero de Indicadores a Grabar',21)

       DO WHILE nNroInd > nTotInd .OR. nNroInd == 0

***********CAPTURA DE NUMERO
	     nNroInd := VAL(SUBS(CAP->cNroIndCaP,nNroPer*2-1,2))
	     @ nNroFil,nNroCol GET nNroInd;
			       VALID nNroInd <= nTotInd;
			       PICT '99'
	     READ
***********FIN CAPTURA DE NUMERO

       ENDDO
       RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
       RESTSCREEN(21,00,nNroFil,79,cSavLin)
*>>>>FIN CAPTURA Y VALIDACION

*>>>>GRABACION DEL REGISTRO
       SELECT CAP
       IF CAP->(lRegLock(lShared,.F.))
	  REPL CAP->cNroIndCaP WITH STUFF(CAP->cNroIndCaP,nNroPer*2-1,;
					  nNroPer*2,STR(nNroInd,2,0))
	  CAP->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL NUMERO DE INDICADORES')
       ENDIF
       IF lShared
	  CAP->(DBUNLOCK())
       ENDIF
       RETURN nNroInd
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DEL NUMERO DE DIFICULTADES             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/96 LUN A
       Colombia, Bucaramanga        INICIO: 02:25 PM   MAR 25/96 LUN

OBJETIVOS:

1- Lectura y valida el n£mero del bimestre

2- Retorna .T. si se leyo el bimestre

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeTotDif(lShared,nNroFil,nNroCol,nNroPer,nTotDif)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nNroPer			            // N£mero del Periodo
       nTotDif			            // Total de Dificultades */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL nNroDif := 0                   // N£mero de Dificultades
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA Y VALIDACION
       nTotDif := IF(nTotDif == NIL,5,nTotDif)
       cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
       Centrar('Entre el N£mero de Difilcultades asociadas a un logro',21)

       DO WHILE nNroDif > nTotDif .OR. nNroDif == 0

***********CAPTURA DE NUMERO
	     nNroDif := VAL(SUBS(CAP->cNroDifCaP,nNroPer*2-1,2))
	     @ nNroFil,nNroCol GET nNroDif;
			       VALID nNroDif <= nTotDif;
			       PICT '99'
	     READ
***********FIN CAPTURA DE NUMERO

       ENDDO
       RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
       RESTSCREEN(21,00,nNroFil,79,cSavLin)
*>>>>FIN CAPTURA Y VALIDACION

*>>>>GRABACION DEL REGISTRO
       SELECT CAP
       IF CAP->(lRegLock(lShared,.F.))
	  REPL CAP->cNroDifCaP WITH STUFF(CAP->cNroDifCaP,nNroPer*2-1,;
					  nNroPer*2,STR(nNroDif,2,0))
	  CAP->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL NUMERO DE INDICADORES')
       ENDIF
       IF lShared
	  CAP->(DBUNLOCK())
       ENDIF
       RETURN nNroDif
*>>>>FIN GRABACION DEL REGISTRO

FUNCTION Materia()
   SELECT MAT
   LOCATE FOR MAT->cCodigoMat == SUBS(CAP->cCodigoCar,1,4)
   SELECT CAP
RETURN SUBS(MAT->cNombreMat,1,80) // 20

/*
FUNCTION Materia()
   LOCAL cNomMat := ''
   SELECT MAT
   LOCATE FOR MAT->cCodigoMat == SUBS(CAP->cCodigoCar,1,4)
   SELECT CAP
   cNomMat := SUBS(MAT->cNombreMat,1,80) // 20
   IF SUBS(MAT->cCodigoMat,3,2) == '00'
      cNomMat := 'AREA '+SUBS(cNomMat,1,75)
   ENDIF
   RETURN cNomMat
*/