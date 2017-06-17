/* BIBLIOTECAS DE FUNCIONES TIPO CLASE 1994

 AUTOR: LUIS CARLOS SALAMANCA        FECHA DE CREACION:
	 SEMINARIO DE CLIPPER

 MODIFICACION: NELSON FERNANDEZ GOMEZ

 REQUERIMIENTOS

 - Compilar: clipper funcions /w/m

 OBJETIVOS

 - Son independientes de cualquier programa

 FUNCIONES
  - CtrlBrw,lEditaCampo,lReglock, nLeeReg,lCrearReg, lBorrarReg, BrwArray, nSkipArray

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES GENERALES
       #include "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES

/*************************************************************************
* TITULO DE LA FUNCION......: CONTROL DE UN OBJETO DE LA CLASE TBrowse   *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Controlar el despliegue en pantalla de un objeto de la clase TBrowse

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CtrlBrw(lShared,o,bEspecial,lSolDis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       o                                    // Objeto
       bEspecial                            // Code Block
       lSoloDis                             // Solo Display "visualizar" */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nTecPul := 0                   // Tecla Pulsada
       LOCAL cSavPan                        // Salvar Pantalla
       LOCAL bTecPul := NIL                 // Block para teclas con setkey
       LOCAL cEncabe                        // Encabezado para el marco
       LOCAL cEncPie                        // Pie para el marco

       LOCAL lModifi := .F.                 // .T. Modificar el campo
       LOCAL oObjCol := NIL                 // Objeto Columna
       LOCAL aEdicio := NIL                 // Vector de Edicion
       LOCAL nIndice := 0                   // Indice del Arreglo

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cClrBrw := ''                  // Color para el Browse
       LOCAL cClrMar := ''                  // Marco del Browse
       LOCAL cClrCab := ''                  // Encabezado del Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[6],'')),;
	       @cClrBrw,@cClrMar,@cClrCab)

       o:ColorSpec:=IF(!EMPTY(xClrSys),xClrSys[6],'')
       SetClrTo()
*>>>>FIN ANALISIS DEL COLOR

*>>>>ESPECIFICACIONES INICIALES
       SET SCOREBOARD OFF
       cSavPan := SAVESCREEN(o:nTop-1,o:nLeft-1,o:nBottom+1,o:nRight+1)
       lSolDis := IF(lSolDis = NIL,.F.,lSolDis)
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>ANALISIS DE LOS ENCABEZADOS
       cEncabe := 'Edici¢n de  Datos'
       cEncPie := 'Escape = terminar'
       cEncabe := IF(o:Cargo = NIL .OR. LEN(o:Cargo) < 1 ,cEncabe,o:Cargo[1])
       cEncPie := IF(o:Cargo = NIL .OR. LEN(o:Cargo) < 2 ,cEncPie,o:Cargo[2])
*>>>>FIN ANALISIS DE LOS ENCABEZADOS

*>>>>DIBUJO DE LOS MARCOS
       cSetColor(cClrMar)
       DISPBOX(o:nTop-1,o:nLeft-1,o:nBottom+1,o:nRight+1,'ÉÍ»º¼ÍÈº°')
       DISPBOX(o:nTop+1,o:nLeft+1,o:nTop+1,o:nRight-1,'ÉÍ»º¼ÍÈº°' )
       DISPBOX(o:nBottom-1,o:nLeft+1,o:nBottom-1,o:nRight-1, 'ÉÍ»º¼ÍÈº°')
       SetClrTo()
*>>>>FIN DIBUJO DE LOS MARCOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       cSetColor(cClrCab)
       centrar(cEncabe,o:nTop,o:nLeft+1,o:nRight-1)
       centrar(cEncPie,o:nBottom,o:nLeft+1,o:nRight-1)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>INICIALIZACION DE LAS COORDENADAS
       o:nTop    += 2
       o:nLeft   += 1
       o:nBottom -= 2
       o:nRight  -= 1
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>ANALISIS PARA VISUALIZACION
       IF !lSolDis
	o:GoTop()
       ENDIF
*>>>>FIN ANALISIS PARA VISUALIZACION

*>>>>VISUALIZACION DEL OBJETO TBrowse
       SetClrTo()
       DO WHILE .T.

**********DESPLIAGA EL PANTALLAZO DEL BROWSE
	    SET CURSOR OFF
	    DO WHILE !(o:STABILIZE())
	       IF (nTecPul := INKEY()) != 0
		  EXIT
	       ENDIF
	    ENDDO
**********FIN DESPLIAGA EL PANTALLAZO DEL BROWSE

**********EVALUACION DEL CODE BLOCK
	    IF bEspecial != NIL
	       EVAL(bEspecial,o)
	    ENDIF
**********FIN EVALUACION DEL CODE BLOCK

**********LECTURA DE TECLA PULSADA
	    IF nTecPul == 0
	       nTecPul := INKEY(0)
	    ENDIF
**********FIN LECTURA DE TECLA PULSADA

**********ANALISIS DE LA MODIFICACION DEL CAMPO
	    oObjCol := o:GETCOLUMN(o:ColPos)     // Extrae objeto columna
	    aEdicio := oObjCol:Cargo             // Especifici¢n de edici¢n
	    IF aEdicio != NIL
	       nIndice := ASCAN(aEdicio, {|eSpec|eSpec[1] == 'MODI'})
	       lModifi := aEdicio[nIndice,2]
	       IF VALTYPE(EVAL(oObjCol:Block)) == 'C'
		  lModifi := IIF(EVAL(oObjCol:Block) == '**',.F.,lModifi)
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA MODIFICACION DEL CAMPO

**********ANALSIS DE LA TECLA PULSADA
	    DO CASE
	    CASE nTecPul == K_UP
		 o:UP()                  // Fila arriba
	    CASE nTecPul == K_DOWN
		 o:DOWN()                // Fila abajo
	    CASE nTecPul == K_LEFT
		 o:LEFT()                // Columna a la izquierda
	    CASE nTecPul == K_RIGHT
		 o:RIGHT()               // Columna a la derecha
	    CASE nTecPul == K_PGUP
		 o:PAGEUP()              // Pantallazo Arriba
	    CASE nTecPul == K_PGDN
		 o:PAGEDOWN()            // Pantallazo Abajo
	    CASE nTecPul == K_CTRL_LEFT
		 o:PANLEFT()             // Pantallazo a la izquierda
	    CASE nTecPul == K_CTRL_RIGHT
		 o:PANRIGHT()            // Pantallazo a la derecha
	    CASE nTecPul == K_CTRL_PGUP
		 o:GOTOP()               // 1Er Registro
	    CASE nTecPul == K_CTRL_PGDN
		 o:GOBOTTOM()            // Ultimo Registro
	    CASE nTecPul == K_HOME
		 o:HOME()                // 1Era Columna de Pantalla
	    CASE nTecPul == K_END
		  o:END()                // Ultima columna de Pantalla
	    CASE nTecPul == K_CTRL_HOME
		 o:PANHOME()             // 1era Columna del Browse
	    CASE nTecPul == K_CTRL_END
		 o:PANEND()              // Ultima Columna del Browse
	    CASE nTecPul == K_ENTER
		 IF !lSolDis
		    IF lModifi
		       lEditaCampo(lShared,o,.F.)          // Editar Campo
		    ELSE
		       cError('NO SE PUEDE MODIFICAR ESTE CAMPO')
		    ENDIF
		 ENDIF
	    CASE nTecPul == K_INS
		 IF 'INCLUIR' $ UPPER(cEncPie)
		    IncluiReg(o)             // Incluye un Registro
		 ELSE
		    cError('NO SE PUEDE INCLUIR REGISTROS')
		 ENDIF

	    CASE nTecPul == K_DEL
		 IF 'BORRAR' $ UPPER(cEncPie)
		    lBorrarReg(lShared,o)            // Borrar Registro
		 ELSE
		    cError('NO SE PUEDE BORRAR EL REGISTRO')
		 ENDIF

	    CASE nTecPul == K_ESC
		 EXIT                    // Termina proceso
	    OTHERWISE
		IF (bTecPul := SETKEY(nTecPul,NIL)) != NIL .AND. !lSolDis
		   EVAL(bTecPul,PROCNAME(),PROCLINE(),READVAR(),o)
		   SETKEY(nTecPul,bTecPul)
		ENDIF
	   ENDCASE
**********FIN ANALSIS DE LA TECLA PULSADA

	  nTecPul := 0   // Borra valor de tecla capturado para tomar otro

       ENDDO
       SET CURSOR ON
*>>>>VISUALIZACION DEL OBJETO TBrowse

*>>>>RESTAURAR LAS COORDENADAS
       //o:RefreshAll()      // Forza refresco de pantalla pr¢xima vez
       o:nTop    -= 2
       o:nLeft   -= 1
       o:nBottom += 2
       o:nRight  += 1
       RESTSCREEN(o:nTop-1,o:nLeft-1,o:nBottom+1,o:nRight+1,cSavPan)
       RETURN NIL
*>>>>FIN RESTAURAR LAS COORDENADAS


/*************************************************************************
* TITULO DE LA FUNCION......: EDICION DE UN CAMPO DE UN OBJETO           *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Edita un campo de un objeto

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lEditaCampo(lShared,o,lCreReg)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       o                                    // Objeto
       lCreReg                              // .T. Crear un registro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList:= {}    // Utilizado por el GET
       LOCAL oObjCol         // Objeto de Columna
       LOCAL xConten         // Contenido
       LOCAL aSpeEdi         // Especificacione de Edici¢n
       LOCAL nIndice         // Indice del vector
       LOCAL cNomCam := ''   // Nombre del campo
       LOCAL cNalias := ''   // Nombre del Alias
       LOCAL cPicCam := ''   // Picture para el campo
       LOCAL bValida := NIL  // Validacion del Campo
       LOCAL lSiorNo := .F.  // Variable de decisi¢n
       LOCAL lSiMemo := .F.  // .T. Campo Memo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ESPECIFICACIONES INICIALES
       SET CURSOR ON
       oObjCol := o:GETCOLUMN(o:ColPos)      // Extrae objeto columna
       xConten := EVAL(oObjCol:Block)        // Obtiene contenido actual
       aSpeEdi := oObjCol:Cargo              // Especificaciones de edicion
       lCreReg := IF(lCreReg == NIL,.F.,lCreReg ) // Asume NO CREAR
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>ESPECIFICACIONE DE EDICION
       IF aSpeEdi != NIL
	  nIndice := ASCAN(aSpeEdi, {|eSpec|eSpec[1] == 'FIELD'})
	  cNomCam := aSpeEdi[nIndice,2]
	  nIndice := ASCAN(aSpeEdi, {|eSpec|eSpec[1] == 'ALIAS'})
	  cNalias := aSpeEdi[nIndice,2]
	  nIndice := ASCAN(aSpeEdi, {|eSpec|eSpec[1] == 'PICTURE'})
	  cPicCam := aSpeEdi[nIndice,2]
	  nIndice := ASCAN(aSpeEdi, {|eSpec|eSpec[1] == 'VALID'})
	  bValida := IF(nIndice = 0,{||.T.},aSpeEdi[nIndice,2])
       ENDIF
*>>>>FIN ESPECIFICACIONE DE EDICION

*>>>>CAPTURA Y VALIDACION DEL CAMPO
       lSiMemo := .F.
       IF aSpeEdi != NIL
	  IF SUBS(cNomCam,1,1) == 'm'
	     xConten := EditMemo(cNomCam,'EDITAR')
	     lSiMemo := .T.
	  ELSE
	     @ ROW(),COL() GET xConten PICTURE cPicCam;
				       VALID EVAL(bValida,xConten)
	     READ
	  ENDIF
       ENDIF
*>>>>FIN CAPTURA Y VALIDACION DEL CAMPO

*>>>>GRABACION DEL CAMPO
       SELECT &cNalias
       IF aSpeEdi != NIL
	  IF (lSiorNo:=LASTKEY() != K_ESC .AND. lRegLock(lShared,lCreReg))

	     IF UPDATED() .OR. lSiMemo
		FIELDPUT(FIELDPOS(cNomCam),xConten)  // Graba
	     ENDIF

	  ENDIF
	  DBUNLOCK()
       ENDIF
*>>>>FIN GRABACION DEL CAMPO

*>>>>REDISPLAY DE LA LINEA ACTUAL
       o:REFRESHCURRENT() // Forza redisplay de la l¡nea actual
       RETURN lSiorNo     // Si edit¢ => .T.
*>>>>FIN REDISPLAY DE LA LINEA ACTUAL


/*************************************************************************
* TITULO DE LA FUNCION......: LEE REGISTRO DE UN OBJETO                  *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Controla Avance de los registros adelante y atr s Reemplaza
     el "Default" que carga la funci¢n TBrowseDB() en o:SkipBlock

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeReg(nNroReg,o)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroReg       // Pendiente
       o             // Objeto   */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nCont := 0
       LOCAL nDir  := IF(nNroReg >= 0, 1, -1 )
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONTROL DE AVANCE DEL REGISTRO
       IF nNroReg = 0 .OR. RECCOUNT() = 0
	  DBSKIP( 0 )
       ELSE

	  DO WHILE ABS(nCont) < ABS(nNroReg)
	     DBSKIP(nDir)
	     IF EOF()
		EVAL(o:GoBottomBlock())
		EXIT
	     ELSE
		IF BOF()
		   EVAL(o:GoTopBlock())
		   EXIT
		ENDIF
	     ENDIF
	     nCont += nDir
	  ENDDO

       ENDIF
       RETURN nCont
*>>>>FIN CONTROL DE AVANCE DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUIR UN REGISTRO                            *
**************************************************************************

OBJETIVOS:

1- Ejecuta la funci¢n que permite incluir un registro

2- La funci¢n a ejecutar se pasa como parametro dentro del cargo del objeto

4- Returna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluiReg(o)

*>>>>PARAMETROS DE LA FUNCION
/*     o                            // Objeto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''
*>>>>DECLARACION DE VARIABLES

*>>>>INCLUCION DEL REGISTRO
       cSavPan := SAVESCREEN(0,0,24,79)
       EVAL(o:Cargo[3])
       o:FORCESTABLE()
       o:GOBOTTOM()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN INCLUCION DEL REGISTRO


/*************************************************************************
* TITULO DE LA FUNCION......: BORRA UN REGISTRO DE UN OBJETO             *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Borra registro.

 2- Se invoca desde CtrlBrw usando tecla DEL

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lBorrarReg(lShared,o)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>MARCA O DESMARCA UN REGISTRO
       LOCAL lSiorNo := .F.
       IF (lSiorNo := lRegLock(lShared,.F.) ) .AND.;
	   cError('Presione "S" para Confirmar',;
		  IF(deleted(),'RECUPERAR','BORRAR')+;
		  ' EL REGISTRO ?','Escape = No Borrar') == 'S'
	  IF(DELETED(),DBRECALL(),DBDELETE()) // Marca o Desmarca

       ENDIF
       IF DELETED()
*	  PACK
       ENDIF
       DBUNLOCK()      // Libera Registro
       o:FORCESTABLE()
       o:GOTOP()
       RETURN lSiorNo
*>>>>FIN MARCA O DESMARCA UN REGISTRO


/*************************************************************************
* TITULO DE LA FUNCION......: CONTROL BROWSE DE ARREGLOS                 *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Controla Browse de Arreglos

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BrwArray(o,aX,i)

*>>>>PARAMETROS DE LA FUNCION
/*     o               // Objeto
       aX              // Arreglo
       i               // Indice del arreglo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nTecPul
       LOCAL cEncabe                        // Encabezado para el marco
       LOCAL cEncPie                        // Pie para el marco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS ENCABEZADOS
       cEncabe := 'Edici¢n de  Datos'
       cEncPie := 'Escape = terminar'
       cEncabe := IF(o:Cargo = NIL .OR. LEN(o:Cargo) < 1 ,cEncabe,o:Cargo[1])
       cEncPie := IF(o:Cargo = NIL .OR. LEN(o:Cargo) < 2 ,cEncPie,o:Cargo[2])
*>>>>FIN ANALISIS DE LOS ENCABEZADOS

*>>>>DIBUJO DE LOS MARCOS
       DISPBOX(o:nTop-1,o:nLeft-1,o:nBottom+1,o:nRight+1,'ÉÍ»º¼ÍÈº°')
       DISPBOX(o:nTop+1,o:nLeft+1,o:nTop+1,o:nRight-1,'ÉÍ»º¼ÍÈº°' )
       DISPBOX(o:nBottom-1,o:nLeft+1,o:nBottom-1,o:nRight-1, 'ÉÍ»º¼ÍÈº°')
*>>>>FIN DIBUJO DE LOS MARCOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       centrar(cEncabe,o:nTop,o:nLeft+1,o:nRight-1)
       centrar(cEncPie,o:nBottom,o:nLeft+1,o:nRight-1)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>VISUALIZACION DEL VECTOR
       DO WHILE .T.

**********ESTABILIZACION Y LECTURA DE TECLA PULSADA
	    DO WHILE !o:STABILIZE()
	    ENDDO
	  *ÀEstabiliza el objeto

	    nTecPul := INKEY(0)
	   *Lectura de la tecla pulsada
**********FIN ESTABILIZACION Y LECTURA DE TECLA PULSADA

**********ANALISIS DE LA TECLA PULSADA
	  DO CASE
	  CASE nTecPul = K_ESC
	       i := 0
	       EXIT
	  CASE nTecPul = K_DOWN
	       o:DOWN()
	  CASE nTecPul = K_END
	       o:END()
	  CASE nTecPul = K_CTRL_PGDN
	       o:GOBOTTOM()
	  CASE nTecPul = K_CTRL_PGUP
	       o:GOTOP()
	  CASE nTecPul = K_HOME
	       o:HOME()
	  CASE nTecPul = K_LEFT
	       o:LEFT()
	  CASE nTecPul = K_PGDN
	       o:PAGEDOWN()
	  CASE nTecPul = K_PGUP
	       o:PAGEUP()
	  CASE nTecPul = K_CTRL_END
	       o:PANEND()
	  CASE nTecPul = K_CTRL_HOME
	       o:PANHOME()
	  CASE nTecPul = K_CTRL_LEFT
	       o:PANLEFT()
	  CASE nTecPul = K_CTRL_RIGHT
	       o:PANRIGHT()
	  CASE nTecPul = K_RIGHT
	       o:RIGHT()
	  CASE nTecPul = K_UP
	       o:UP()
	  CASE nTecPul = K_ENTER
	       EXIT
*	       aX[i,1] = LEFT(aX[i,1],LEN(aX[i,1])-1) +;
*			 IF(RIGHT(aX[i,1],1) = ' ', 'À',' ')
	       *Ejemplo: marcar el elemento
*	       o:REFRESHCURRENT()
	  ENDCASE
**********FIN ANALISIS DE LA TECLA PULSADA

       ENDDO while .T.
       RETURN NIL
*>>>>FIN VISUALIZACION DEL VECTOR


/*************************************************************************
* TITULO DE LA FUNCION......: AVANZA ELEMENTOS DEL BROWSE DE ARREGLOS    *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Actualiza el pointer del arreglo

 2- Retorna los elementos efectivamente saltados

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSkipArray(nNroEle,nIndice,nLenEle,o)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroEle      // Elementos a Saltar
       nIndice      // Elemento actual. Debe pasar por REFERENCIA
       nLenEle      // Nro de elementos del Arreglo
       o            // Objeto Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>ACTUALIZAR EL PUNTERO DEL ARREGLO
       IF nIndice + nNroEle < 1
	  nNroEle := 1 - nIndice
	  nIndice := 1            // Elemento 1
       ELSEIF nIndice + nNroEle > nLenEle
	  nNroEle :=  nLenEle - nIndice
	  nIndice :=  nLenEle	  // Ultimo elemnto
       ELSE
	  nIndice += nNroEle	  // Avanza/retrocede "nNroEle" elemntos
       ENDIF
       RETURN nNroEle
*>>>>FIN ACTUALIZAR EL PUNTERO DEL ARREGLO

/*************************************************************************
* TITULO DE LA FUNCION..: OBJETO CONSULTA DE ESTUDIANTES                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 29/94 MAR A
						       NOV 29/94 MAR

1- Define el objeto Browse para cualquier archivo

2- Debe estar en uso el archivo que se va a utilizar

3- Retorna el objeto para el browse

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrowse(nFilSup,nColSup,nFilInf,nColInf,;
		 cEncabe,cEncPie,aCampos,bCodIns)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cEncabe                              // Encabezado del marco
       cEncPie                              // Pie para el marco
       aCampos                              // Campos de las columnas
       bCodIns                              // CodeBlock de Inserci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oConsul := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oConsul := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oConsul:ColSep    := '³'
       oConsul:HeadSep   := 'Ä'
       oConsul:Cargo     := {cEncabe,cEncPie,bCodIns}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras


       IF LEN(aCampos) >= 1
	  oColumn := TBCOLUMNNEW(aCampos[1,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[1,1,2]))})
	  IF aCampos[1,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[1,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 2
	  oColumn := TBCOLUMNNEW(aCampos[2,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[2,1,2]))})
	  IF aCampos[2,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[2,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 3
	  oColumn := TBCOLUMNNEW(aCampos[3,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[3,1,2]))})
	  IF aCampos[3,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[3,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 4
	  oColumn := TBCOLUMNNEW(aCampos[4,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[4,1,2]))})
	  IF aCampos[4,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[4,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 5
	  oColumn := TBCOLUMNNEW(aCampos[5,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[5,1,2]))})
	  IF aCampos[5,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[5,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 6
	  oColumn := TBCOLUMNNEW(aCampos[6,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[6,1,2]))})
	  IF aCampos[6,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[6,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 7
	  oColumn := TBCOLUMNNEW(aCampos[7,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[7,1,2]))})
	  IF aCampos[7,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[7,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 8
	  oColumn := TBCOLUMNNEW(aCampos[8,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[8,1,2]))})
	  IF aCampos[8,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[8,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 9
	  oColumn := TBCOLUMNNEW(aCampos[9,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[9,1,2]))})
	  IF aCampos[9,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[9,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 10
	  oColumn := TBCOLUMNNEW(aCampos[10,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[10,1,2]))})
	  IF aCampos[10,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[10,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 11
	  oColumn := TBCOLUMNNEW(aCampos[11,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[11,1,2]))})
	  IF aCampos[11,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[11,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 12
	  oColumn := TBCOLUMNNEW(aCampos[12,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[12,1,2]))})
	  IF aCampos[12,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[12,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 13
	  oColumn := TBCOLUMNNEW(aCampos[13,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[13,1,2]))})
	  IF aCampos[13,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[13,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 14
	  oColumn := TBCOLUMNNEW(aCampos[14,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[14,1,2]))})
	  IF aCampos[14,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[14,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 15
	  oColumn := TBCOLUMNNEW(aCampos[15,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[15,1,2]))})
	  IF aCampos[15,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[15,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 16
	  oColumn := TBCOLUMNNEW(aCampos[16,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[16,1,2]))})
	  IF aCampos[16,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[16,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 17
	  oColumn := TBCOLUMNNEW(aCampos[17,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[17,1,2]))})
	  IF aCampos[17,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[17,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 18
	  oColumn := TBCOLUMNNEW(aCampos[18,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[18,1,2]))})
	  IF aCampos[18,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[18,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 19
	  oColumn := TBCOLUMNNEW(aCampos[19,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[19,1,2]))})
	  IF aCampos[19,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[19,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 20
	  oColumn := TBCOLUMNNEW(aCampos[20,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[20,1,2]))})
	  IF aCampos[20,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[20,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 21
	  oColumn := TBCOLUMNNEW(aCampos[21,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[21,1,2]))})
	  IF aCampos[21,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[21,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 22
	  oColumn := TBCOLUMNNEW(aCampos[22,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[22,1,2]))})
	  IF aCampos[22,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[22,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 23
	  oColumn := TBCOLUMNNEW(aCampos[23,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[23,1,2]))})
	  IF aCampos[23,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[23,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 24
	  oColumn := TBCOLUMNNEW(aCampos[24,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[24,1,2]))})
	  IF aCampos[24,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[24,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 25
	  oColumn := TBCOLUMNNEW(aCampos[25,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[25,1,2]))})
	  IF aCampos[25,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[25,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 26
	  oColumn := TBCOLUMNNEW(aCampos[26,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[26,1,2]))})
	  IF aCampos[26,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[26,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 27
	  oColumn := TBCOLUMNNEW(aCampos[27,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[27,1,2]))})
	  IF aCampos[27,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[27,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 28
	  oColumn := TBCOLUMNNEW(aCampos[28,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[28,1,2]))})
	  IF aCampos[28,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[28,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 29
	  oColumn := TBCOLUMNNEW(aCampos[29,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[29,1,2]))})
	  IF aCampos[29,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[29,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 30
	  oColumn := TBCOLUMNNEW(aCampos[30,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[30,1,2]))})
	  IF aCampos[30,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[30,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 31
	  oColumn := TBCOLUMNNEW(aCampos[31,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[31,1,2]))})
	  IF aCampos[31,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[31,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 32
	  oColumn := TBCOLUMNNEW(aCampos[32,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[32,1,2]))})
	  IF aCampos[32,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[32,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 33
	  oColumn := TBCOLUMNNEW(aCampos[33,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[33,1,2]))})
	  IF aCampos[33,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[33,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 34
	  oColumn := TBCOLUMNNEW(aCampos[34,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[34,1,2]))})
	  IF aCampos[34,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[34,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 35
	  oColumn := TBCOLUMNNEW(aCampos[35,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[35,1,2]))})
	  IF aCampos[35,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[35,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 36
	  oColumn := TBCOLUMNNEW(aCampos[36,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[36,1,2]))})
	  IF aCampos[36,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[36,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 37
	  oColumn := TBCOLUMNNEW(aCampos[37,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[37,1,2]))})
	  IF aCampos[37,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[37,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 38
	  oColumn := TBCOLUMNNEW(aCampos[38,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[38,1,2]))})
	  IF aCampos[38,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[38,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 39
	  oColumn := TBCOLUMNNEW(aCampos[39,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[39,1,2]))})
	  IF aCampos[39,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[39,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 40
	  oColumn := TBCOLUMNNEW(aCampos[40,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[40,1,2]))})
	  IF aCampos[40,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[40,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 41
	  oColumn := TBCOLUMNNEW(aCampos[41,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[41,1,2]))})
	  IF aCampos[41,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[41,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 42
	  oColumn := TBCOLUMNNEW(aCampos[42,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[42,1,2]))})
	  IF aCampos[42,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[42,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 43
	  oColumn := TBCOLUMNNEW(aCampos[43,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[43,1,2]))})
	  IF aCampos[43,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[43,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 44
	  oColumn := TBCOLUMNNEW(aCampos[44,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[44,1,2]))})
	  IF aCampos[44,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[44,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 45
	  oColumn := TBCOLUMNNEW(aCampos[45,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[45,1,2]))})
	  IF aCampos[45,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[45,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 46
	  oColumn := TBCOLUMNNEW(aCampos[46,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[46,1,2]))})
	  IF aCampos[46,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[46,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 47
	  oColumn := TBCOLUMNNEW(aCampos[47,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[47,1,2]))})
	  IF aCampos[47,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[47,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 48
	  oColumn := TBCOLUMNNEW(aCampos[48,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[48,1,2]))})
	  IF aCampos[48,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[48,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 49
	  oColumn := TBCOLUMNNEW(aCampos[49,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[49,1,2]))})
	  IF aCampos[49,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[49,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 50
	  oColumn := TBCOLUMNNEW(aCampos[50,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[50,1,2]))})
	  IF aCampos[50,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[50,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 51
	  oColumn := TBCOLUMNNEW(aCampos[51,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[51,1,2]))})
	  IF aCampos[51,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[51,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 52
	  oColumn := TBCOLUMNNEW(aCampos[52,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[52,1,2]))})
	  IF aCampos[52,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[52,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 53
	  oColumn := TBCOLUMNNEW(aCampos[53,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[53,1,2]))})
	  IF aCampos[53,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[53,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 54
	  oColumn := TBCOLUMNNEW(aCampos[54,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[54,1,2]))})
	  IF aCampos[54,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[54,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 55
	  oColumn := TBCOLUMNNEW(aCampos[55,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[55,1,2]))})
	  IF aCampos[55,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[55,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 56
	  oColumn := TBCOLUMNNEW(aCampos[56,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[56,1,2]))})
	  IF aCampos[56,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[56,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 57
	  oColumn := TBCOLUMNNEW(aCampos[57,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[57,1,2]))})
	  IF aCampos[57,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[57,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 58
	  oColumn := TBCOLUMNNEW(aCampos[58,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[58,1,2]))})
	  IF aCampos[58,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[58,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 59
	  oColumn := TBCOLUMNNEW(aCampos[59,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[59,1,2]))})
	  IF aCampos[59,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[59,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 60
	  oColumn := TBCOLUMNNEW(aCampos[60,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[60,1,2]))})
	  IF aCampos[60,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[60,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 61
	  oColumn := TBCOLUMNNEW(aCampos[61,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[61,1,2]))})
	  IF aCampos[61,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[61,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 62
	  oColumn := TBCOLUMNNEW(aCampos[62,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[62,1,2]))})
	  IF aCampos[62,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[62,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 63
	  oColumn := TBCOLUMNNEW(aCampos[63,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[63,1,2]))})
	  IF aCampos[63,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[63,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       IF LEN(aCampos) >= 64
	  oColumn := TBCOLUMNNEW(aCampos[64,1,1],;
		     {||FIELDGET(FIELDPOS(aCampos[64,1,2]))})
	  IF aCampos[64,2,1] == NIL
	     oColumn:Cargo := {{'MODI',.F.}}
	  ELSE
	     oColumn:Cargo := aCampos[64,2]
	  ENDIF
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n de la columna

       RETURN oConsul
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: EDICION DE UN CAMPO MEMO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 06/2001 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUN 06/2001 JUE

OBJETIVOS:

1- Permite modificar un campo memo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EditMemo(cCampo,cTitulo,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     cCampo			            // Nombre del Campo
       cTitulo                              // T¡tulo de Ayuda
       nFilSup                              // Fila Superior
       nColSup                              // Columna Superior
       nFilInf                              // Fila Inferior
       nColInf                              // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARCION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cTexto := ''                   // Texto del Archivo
*>>>>FIN DECLARCION DE VARIABLES

*>>>>DIBUJO DEL MARCO
       cSavPan := SAVESCREEN(0,0,24,79)
       nFilSup := IF(EMPTY(nFilSup),3,nFilSup)
       nColSup := IF(EMPTY(nColSup),0,nColSup)
       nFilInf := IF(EMPTY(nFilInf),22,nFilInf)
       nColinf := IF(EMPTY(nColInf),79,nColInf)
       @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
       centrar(cTitulo,nFilSup,nColSup,nColInf)
*>>>>FIN DIBUJO DEL MARCO

*>>>>EDICION DEL TEXTO DEL ARCHIVO
       cTexto := &cCampo
       cTexto := MemoEdit(cTexto,;
			  nFilSup+1,nColSup+1,nFilInf-1,nColInf-1,.T.,;
			  "MemoFunc")
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN cTexto
*>>>>FIN EDICION DEL TEXTO DEL ARCHIVO

/*************************************************************************
* TITULO..: SELECCIONAR UN ELEMENTO DE UN VECTOR                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/2007 VIE A
       Colombia,Bucaramanga         INICIO: 04:00 PM   MAY 18/2007 VIE

OBJETIVOS:

1- Selecionar un item de un vector

2- Retorna el indice del elemento seleccionado

SINTAXIS:

aVector := {'LUNES    ','MARTES',','MIERCOLES',;
	    'JUEVES','VIERNES','SABADO','DOMINGO'}
nSelArray(10,10,'DIA',9,aVector)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelArray(nNroFil,nNroCol,cTitulo,aVector)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de Impresi¢n
       nNroCol                              // Columna de Impresi¢n
       cTitulo                              // T¡tulo del Encabezdo
       aVector			            // Vector a Seleccionar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar pantalla

       LOCAL oBrwArr := NIL                 // Browse de Arreglos
       LOCAL oColumn := NIL                 // Columna del Objetos
       LOCAL nIndice := 1                   // N£mero del indice
       LOCAL nLenEle := 0                   // Elementos del Arreglo

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(0)
       nLenEle := LEN(aVector)
       nFilSup := nNroFil
       nColSup := nNroCol
       nFilInf := nFilSup+nLenEle
       IF nFilInf > 22
	  nFilInf := 22
       ENDIF
       nColInf := nFilSup+LEN(aVector[1])
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>DEFINICION DEL OBJETO BROWSE
       @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
       oBrwArr := TBrowseNew(nFilSup,nColSup,nFilInf,nColInf)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwArr:skipBlock     := {|n|nSkipArray(n,@nIndice,nLenEle,oBrwArr)}
       oBrwArr:GoTopBlock    := {||nIndice:= 1}
       oBrwArr:GoBottomBlock := {||nIndice:= nLenEle}
     *ÀEspecificaciones del Objeto

       oColumn         := TBColumnNew()
       oColumn:Heading := cTitulo
       oColumn:Block   := {||aVector[nIndice]}
       oBrwArr:addColumn(oColumn)
     *ÀDefinici¢n Columna No. 1
*>>>>FIN DEFINICION DEL OBJETO BROWSE

*>>>>BROWSE DEL ARREGLO
       BrwArray(oBrwArr, aVector, @nIndice)
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(1)
       RETURN nIndice
*>>>>FIN BROWSE DEL ARREGLO

/*************************************************************************
* TITULO..: SELECCIONAR DIA DE LA SEMANA                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/2007 VIE A
       Colombia,Bucaramanga         INICIO: 04:00 PM   MAY 18/2007 VIE

OBJETIVOS:

1- Selecionar el dia de la semana

2- Retorna el dia seleccionado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelDia(nNroFil,nNroCol,cTitulo,nDiaIni,nDiaFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de Impresi¢n
       nNroCol                              // Columna de Impresi¢n
       cTitulo                              // T¡tulo del Browse
       nDiaIni                              // Dia inicial de lectura
       nDiaFin                              // D¡a final de lectura */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aVector := {}                  // Vector del Browse
       LOCAL nNroDia := 0                   // N£mero del d¡a
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL DIA
       nDiaIni := IF(nDiaIni==NIL,1,nDiaIni)
       nDiaFin := IF(nDiaFin==NIL,7,nDiaIni)
       IF nDiaIni <= 1 .AND. nDiaFin >= 1
	  AADD(aVector,'DOMINGO  ')
       ENDIF
       IF nDiaIni <= 2 .AND. nDiaFin >= 2
	  AADD(aVector,'LUNES')
       ENDIF
       IF nDiaIni <= 3 .AND. nDiaFin >= 3
	  AADD(aVector,'MARTES')
       ENDIF
       IF nDiaIni <= 4 .AND. nDiaFin >= 4
	  AADD(aVector,'MIERCOLES')
       ENDIF
       IF nDiaIni <= 5 .AND. nDiaFin >= 5
	  AADD(aVector,'JUEVES')
       ENDIF
       IF nDiaIni <= 6 .AND. nDiaFin >= 6
	  AADD(aVector,'VIERNES')
       ENDIF
       IF nDiaIni <= 7 .AND. nDiaFin >= 7
	  AADD(aVector,'SABADO')
       ENDIF
       nNroDia := nSelArray(nNroFil,nNroCol,cTitulo,aVector)
       RETURN nNroDia
*>>>>FIN SELECCION DEL DIA