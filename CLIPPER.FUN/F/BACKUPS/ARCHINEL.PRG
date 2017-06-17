/*BIBLIOTECAS DE FUNCIONES PARA ARCHIVO TEXTO 1994

  AUTOR: LUIS CARLOS SALAMANCA        FECHA DE CREACION:
	 SEMINARIO DE CLIPPER

 MODIFICACION: NELSON FERNANDEZ GOMEZ

 REQUERIMIENTOS

 - Compilar: clipper arctexto /w/m

 OBJETIVOS

 - Son independientes de cualquier programa

 FUNCIONES
 - LeeTexto, nSaltaLin, cFleeLinea, nRewind, nFgoTop, nFgoBottom

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES GENERALES
       #include "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES

/*************************************************************************
* TITULO DE LA FUNCION......: LEE Y VISUALIZA UN ARCHIVO TEXTO           *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Lee y Despliega Archivo Texto en Pantalla

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeTexto(cNomArc,nFilTop,nColLef,nFilBot,nColRig,nNroLin)

*>>>>DECLARACION DE CONSTANTES
       #define pDESDE_BOF 0
       #define pDESDE_POS_ACTUAL 1
       #define pDESDE_EOF 2
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>PARAMETROS DE LA FUNCION
/*     cNomArc                 // Nombre del Archivo texto
       nFilTop                 // Fila Superior
       nColTop                 // Columna Superior
       nFilBot                 // Fila Inferior
       nColRig                 // Columna Inferior
       nNroLin		       // N£mero de Linea inicial */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nCursor  := NIL                // Cursor Actual
       LOCAL nTipCur                        // Tipo de Cursor
       LOCAL nTecPul  := 0                  // Tecla Pulsada
       LOCAL cSavPan  := ''                 // Salvar Pantalla
       LOCAL cSanPa1  := ''                 // Salvar Pantalla

       LOCAL nNroArc  := 0                  // N£mero de Archivo
       LOCAL nPointr  := 0                  // Puntero
       LOCAL ByteEof  := 0                  // Byte Final
       LOCAL cLinTxt  := ''                 // L¡nea de Texto
       LOCAL nAncLin  := 0                  // Ancho de la L¡nea
       LOCAL nNroFil  := 0                  // N£mero de Fila
       LOCAL nNroCol  := 0                  // N£mero de la Columna
       LOCAL nCopias := 1                   // N£mero de Copias
       LOCAL nNroCop := 0                   // Copias impresas

       LOCAL o        := NIL  // Objeto Texto
       LOCAL oColum   := NIL  // Columna del Objeto
       LOCAL GetList := {}                  // Variable del Sistema
       STATIC nNroPos  := 1    // N£mero de Posici¢n para mostrar la linea
*>>>>FIN DECLARACION DE VARIABLES

/*
      /#-------------------------- cLinTxt ------------------------------/

       ~~~~~ ~~~~~~~ ~~~~ ~~ ~~~~~ ~~~~~ ~~ ~ ~~~~~ ~ ~~~~~ ~ ~~~ ~~~~~
			  ^
			  |--------------------------------|
			 nNroPos
				    <- nAncLin ->
			   Porci¢n que aparece en pantalla
*/

*>>>>ESPECIFICACIONES INICIALES
       nFilTop := IF(nFilTop == NIL, 3,nFilTop)
       nColLef := IF(nColLef == NIL, 0,nColLef)
       nFilBot := IF(nFilBot == NIL, 22,nFilBot)
       nColRig := IF(nColRig == NIL, 79,nColRig)
     *ÀInicializacion de las coordenadas

       nTipCur := SETCURSOR(0)
       nNroPos := IF(nNroPos <= 0, 1,nNroPos)
       nNroLin := IF(nNroLin == NIL,1,nNroLin)
       nAncLin := nColRig - nColLef - 1
	     o := TBROWSENEW(nFilTop+1,nColLef+1,nFilBot-1,nColRig-1)
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>LECTURA Y VISUALIZACION DE ARCHIVO TEXTO
       IF (nNroArc := FOPEN(cNomArc)) > 0  //Abre el Archivo

**********CALCULO DEL TAMA¥O DEL ARCHIVO
	    cSavPan = SAVESCREEN(nFilTop,nColLef,nFilBot,nColRig)
	    DISPBOX(nFilTop,nColLef,nFilBot,nColRig, 'ÚÄ¿³ÙÄÀ³°')

	    ByteEof := FSEEK(nNroArc,0,pDESDE_EOF)
	   *Establece el byte del eof = tama¤o del archivo

	    nPointr := nFgoTop(nNroArc,@cLinTxt )
	   *Ubica y Obtiene la primera Linea
**********FIN CALCULO DEL TAMA¥O DEL ARCHIVO

**********LEER EL NUMERO DE LINEA
	    IF nNroLin > 1
	     DO WHILE --nNroLin > 0  // Leer hasta llegar nNroLin
		cLinTxt := cFleeLinea(nNroArc,@nPointr) // Lee linea
	     ENDDO
	    ENDIF
**********FIN LEER EL NUMERO DE LINEA

**********DEFINICION DEL OBJETO
	    oColum := tbColumnNew(ALLTRIM(cNomArc)+' <F9>Imprimir',;
				  {||padr(SUBSTR(cLinTxt,nNroPos),nAncLin)})
	    o:ADDCOLUMN(oColum)
	    o:SkipBlock  := {|n|nSaltaLin(n,@nPointr,nNroArc,ByteEof,@cLinTxt)}
	    o:GoTopBlock := {||nPointr := nFgoTop(nNroArc, @cLinTxt)}
	    o:GoBottomBlock := {||nPointr := nFgoBottom(nNroArc,@cLinTxt)}
**********FIN DEFINICION DEL OBJETO

**********VISUALIZACION DEL ARCHIVO
	    DO WHILE .t.

*--------------IMPRESION DEL PRIMER PANTALLAZO
		 DO WHILE !(o:STABILIZE())
		    IF (nTecPul := INKEY()) # 0
		       EXIT
		    ENDIF
		 ENDDO
*--------------FIN IMPRESION DEL PRIMER PANTALLAZO

*--------------LECTURA DE LA TECLA PULSADA
		 IF nTecPul == 0
		    nTecPul := INKEY(0)
		 ENDIF
*--------------FIN LECTURA DE LA TECLA PULSADA

*--------------ANALISI DE LA TECLA PULSADA
		 DO CASE
		 CASE nTecPul == K_ESC
		      EXIT
		 CASE nTecPul == K_UP
		      o:Up()
		 CASE nTecPul == K_PGUP
		      o:PageUp()
		 CASE nTecPul == K_DOWN
		      o:Down()
		 CASE nTecPul == K_PGDN
		      o:PageDown()
		 CASE nTecPul == K_CTRL_PGUP
		      o:GoTop()
		 CASE nTecPul == K_CTRL_PGDN
		      o:GoBottom()
		 CASE nTecPul == K_RIGHT
		      ++nNroPos
		      o:RefreshAll()
		 CASE nTecPul == K_LEFT
		      --nNroPos
		      o:RefreshAll()
		 CASE nTecPul == K_HOME
		      nNroPos -= nAncLin
		      o:RefreshAll()
		 CASE nTecPul == K_END
		      nNroPos += nAncLin
		      o:RefreshAll()
		 CASE nTecPul == K_CTRL_RIGHT
		      nNroPos += 4
		      o:RefreshAll()
		 CASE nTecPul == K_TAB
		      nNroPos += 4
		      o:RefreshAll()
		 CASE nTecPul == K_CTRL_LEFT
		      nNroPos -= 4
		      o:RefreshAll()
		 CASE nTecPul == K_SH_TAB
		      nNroPos -= 4
		      o:RefreshAll()

		 CASE nTecPul == K_F9

		     cSavPan := SAVESCREEN(0,0,24,79)
		     nCursor := SETCURSOR(1)
		     nCopias := 1
		     TitBuscar(10,@nNroFil,@nNroCol,;
			       'NUMERO DE COPIAS:','COPIAS',13)
		     @ nNroFil,nNroCol GET nCopias PICT '9'
		     READ
		     SETCURSOR(nCursor)
		     RESTSCREEN(0,0,24,79,cSavPan)

		     nNroCop := 1
		     DO WHILE nNroCop <= nCopias
			IF !SWPRUNCMD('TYPE ' +cNomArc+' > LPT1',0,"","")
			   cError(cErrorRun(SWPERRMAJ(),SWPERRMIN()))
			ENDIF
			nNroCop++
		     ENDDO

		 ENDCASE
*--------------FIN ANALISI DE LA TECLA PULSADA

	       nTecPul := 0

	    ENDDO
	    RESTSCREEN(nFilTop,nColLef,nFilBot,nColRig,cSavPan)
	    FCLOSE(nNroArc)
	   *Cierra el archivo
**********FIN VISUALIZACION DEL ARCHIVO

       ENDIF
       SETCURSOR(nTipCur)
       RETURN NIL
*>>>>FIN LECTURA Y VISUALIZACION DE ARCHIVO TEXTO


/*************************************************************************
* TITULO DE LA FUNCION......: SALTAR LINEA DE UN ARCHIVO TEXTO           *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Ejecuta el desplazamiento (Lectura de L¡neas) dentro del archivo.

 2- Se invoca por el objeto browse cada vez que se ejecuta un m‚todo
    asociado a desplazamientos verticales.

 3- El objeto env¡a al par metro "nTotLin" el n£mero de l¡neas a desplazarse.
			 +--------------------+
	  {|nTotLin| nSaltaLin( nTotLin, @nPointr, nNroArc, ByteEof, @cLinTxt ) }

 4- Los otros par metros son variables locales de la funci¢n LeeTexto
    que son exportadas atrav‚s del CodeBlock.

	       nPointer debe pasarse
              por "referencia" para que se mantenga actualizado.
   Retorna  : El n£mero de l¡neas que efectivamente se desplaz¢.

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

STATIC FUNCTION nSaltaLin(nTotLin,nPointr,nNroArc,ByteEof,cLinTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     nTotLin         // N£mero de l¡neas a desplazarse
       nPointr         // Puntero
       nNroArc         // N£mero de Archivo
       ByteEof         // Byte Final
       cLinTex         // L¡nea de Texto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroLin := 0    // N£mero de lineas desplazadas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SALTA LINEAS HACIA DELANTE
       IF nTotLin > 0
	  DO WHILE nNroLin < nTotLin

	     cLinTxt := cFleeLinea(nNroArc,@nPointr )
	     IF nPointr == ByteEof  // Eof ?
		nPointr := nRewind(nNroArc,1,nPointr)   // skip -1
		cLinTxt := cFleeLinea(nNroArc,@nPointr)
	       *Obtiene Ultima Linea y pointer
		EXIT
	     ENDIF

	     nNroLin++

	  ENDDO
       ENDIF
*>>>>FIN SALTA LINEAS HACIA DELANTE

*>>>>SALTAR LINEAS HACIA ATRAS
       IF nTotLin < 0
	  DO WHILE nNroLin > nTotLin

	     nRewind( nNroArc, 2, @nPointr )  // skip -2
	     IF nPointr == 0                 // Bof ?
		cLinTxt := cFleeLinea( nNroArc, @nPointr )
		EXIT
	     ENDIF

	     cLinTxt := cFleeLinea( nNroArc, @nPointr )
	     nNroLin--

	  ENDDO
       ENDIF
       RETURN nNroLin
*>>>>FIN SALTAR LINEAS DE TEXTO


/*************************************************************************
* TITULO DE LA FUNCION......: LEE UNA LINEA DE TEXTO DE UN ARCHIVO       *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Lee una l¡nea a partir de la posici¢n actual del pointer

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFleeLinea(nNroArc, nPointr,nLenLin,cDelimi )

*>>>>DECLARACION DE CONSTANTES
       # define MAXLINE   512
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>PARAMETROS DE LA FUNCION
/*     nNroArc             // N£mero de Archivo
       nPointr             // Apuntador
       nLenLin             // Longitud de la l¡nea
       cDelimi             // Delimitador de fin de l¡nea */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cCadena       // Buffer de lectura
       LOCAL nFinLin       // Byte del delimitador de f¡n de l¡nea EOL
       LOCAL nTBytes       // N£mero de bytes efectivamente le¡dos
       LOCAL cLinTxt := '' // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ESPECIFICACIONES INICIALES
       cDelimi := IF(cDelimi==NIL, CHR(13)+CHR(10),cDelimi )
      *Delimitador de f¡n de l¡nea por default

       IF VALTYPE(nLenLin) != 'N'
	  nLenLin = MAXLINE
       ENDIF
     *ÀEstablece Longitud de la l¡nea si no vino dada

       cCadena = SPACE(nLenLin)
      *Limpia el buffer de lectura

       nTBytes = fRead(nNroArc,@cCadena,nLenLin)
      *Lee el n£mero de bytes especificado por nLenLin sobre el buffer

       nFinLin = AT(cDelimi,cCadena)
      *Buscar delimitador de f¡n de l¡nea
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>MOVER EL PUNTERO AL INICIO DE LA SIGUIENTE LINEA
       IF nFinLin = 0
	  // Significa que:
	  //   No se encontr¢ el delimitador, o
	  //   El pointer est  en EOF, o
	  //   La l¡nea es demasiado larga.
       ELSE
	  FSEEK(nNroArc,( nTBytes*-1) + nFinLin + 1, pDESDE_POS_ACTUAL)
	 *Mueve el puntero
       ENDIF
*>>>>FIN MOVER EL PUNTERO AL INICIO DE LA SIGUIENTE LINEA

*>>>>ACTUALIZACION DEL PUNTERO
       cLinTxt := SUBSTR(cCadena, 1, nFinLin - 1)
       nPointr := FSEEK( nNroArc, 0, pDESDE_POS_ACTUAL ) // Actualiza Pointer
       RETURN cLinTxt
       # undef MAXLINE
*>>>>FIN ACTUALIZACION DEL PUNTERO


/*************************************************************************
* TITULO DE LA FUNCION......: DESPLAZAMIENTO DEL APUNTADOR HACIA ATRAS   *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Desplaza el apuntador hacia atr s las l¡neas especificadas */

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nRewind(nNroArc,nTotLin,nPointr,nLenLin )

*>>>>DECLARACION DE CONSTANTES
     #define MAXLINE   512
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>PARAMETROS DE LA FUNCION
/*     nNroArc               // N£mero del archivo
       nTotLin               // Total de L¡neas a desplazar
       nPointr               // Apuntador
       nLenLin               // Longitud de la linea */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cCadena := ''   // Buffer de Lectura
       LOCAL lLinUno := .F.  // Primera L¡nea
       LOCAL nFinLin := 0    // Byte del delimitador de f¡n de l¡nea EOL
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ESPECIFICACIONES INICIALES
       IF VALTYPE( nLenLin ) != 'N'
	  nLenLin := MAXLINE
       ENDIF
       cCadena := SPACE(nLenLin)
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>DESPLAZAMIENTO DEL APUNTADOR
       DO WHILE nTotLin > 0

**********MOVIMIENTO DEL APUNTADOR
	    cCadena := SPACE( nLenLin )
	   *Limpia el buffer
	    IF nPointr >= nLenLin + 2

*--------------RETROCEDER APUNTADOR 514 BYTES INCLUYE CR/LF
		 FSEEK(nNroArc, -( nLenLin + 2 ), pDESDE_POS_ACTUAL )
		*Lee sobre el buffer excluyendo (CR/LF)
		 fRead(nNroArc, @cCadena, nLenLin )
*--------------FIN RETROCEDEE APUNTADOR 514 BYTES INCLUYE CR/LF

	    ELSE

*-------------MUEVE APUNTADOR A BOF Y LEE PRIMERA LINEA
		FSEEK(nNroArc,-nPointr,pDESDE_POS_ACTUAL )
		fRead(nNroArc,@cCadena,nPointr-1)
	       *Si no encuentra CR/LF en cCadena => es 1era l¡nea

		cCadena := TRIM(cCadena)
		lLinUno := IF(at(CHR(13)+CHR(10), cCadena) > 0,.F.,.T.)
*-------------FIN MUEVE APUNTADOR A BOF Y LEE PRIMERA LINEA
	    ENDIF
**********FIN MOVIMIENTO DEL APUNTADOR


***********BUSQUEDA DEL ULTIMO CR/LF
	     DO WHILE (nFinLin := RAT(CHR(13)+CHR(10), cCadena)) > 0 .AND.;
							 nTotLin > 0
		nPointr = FSEEK(nNroArc, -(len(cCadena)-(nFinLin-1)),;
				pDESDE_POS_ACTUAL)
	       *Mueve el apuntador al final de la l¡nea anterior

	       cCadena = SUBSTR(cCadena, 1, nFinLin - 1)
	      *Deja en el buffer £nicamente la l¡nea

	       nTotLin--

	     ENDDO
***********FIN BUSQUEDA DEL ULTIMO CR/LF

***********RESTAURAR EL APUNTADOR
	     IF ! lLinUno
		nPointr := FSEEK(nNroArc,2,pDESDE_POS_ACTUAL)
	       *Adelanta apuntador al ppio de la l¡nea sgte saltando (CR/LF)
	     ELSE
		nPointr := FSEEK(nNroArc, 0, pDESDE_BOF )
	       *Restaura apuntador en BOF
		EXIT
	     ENDIF
***********FIN RESTAURAR EL APUNTADOR

       ENDDO
       RETURN nPointr
       # undef MAXLINE
*>>>>FIN DESPLAZAMIENTO DEL APUNTADOR


/*************************************************************************
* TITULO DE LA FUNCION......: UBICACION APUNTADOR EN PRIMERA LINEA       *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Ubica apuntador en 1era l¡nea y deja en cLinTxt la 1era l¡nea.

 2- Retorna el apuntador

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nFgoTop(nNroArc,cLinTxt)

LOCAL nPointr := 0
FSEEK( nNroArc, 0, pDESDE_BOF )          // Reubica en Bof
cLinTxt := cFleeLinea(nNroArc,@nPointr )  // Obtiene Linea y actualiza pointer

RETURN nPointr

/*************************************************************************
* TITULO DE LA FUNCION......: UBICACION APUNTADOR EN LA ULTIMA LINEA     *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Ubica apuntador en £ltima l¡nea y deja en cLinTxt la £ltima l¡nea

 2- Retorna el apuntador

* SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nFgoBottom(nNroArc,cLinTxt)

LOCAL nPointr := FSEEK(nNroArc, 0, pDESDE_EOF) // Ubica en Eof y Act Pointer
nRewind(nNroArc, 1,@nPointr )                   // Skip -2
cLinTxt := cFleeLinea(nNroArc,@nPointr)     // Obtiene Ultima Linea y pointer
RETURN nPointr

/*************************************************************************
* TITULO..: SELECCIONA UN ARCHIVO DEL DIRECTORIO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 17/2000 SAB A
       Colombia, Bucaramanga        INICIO: 05:00 PM   JUN 17/2000 SAB

OBJETIVOS:

1- Valida cualquier operaci¢n de Entrada o Salida I/O de las funciones
   de Bajo Nivel.

2- Retorna .T. si hay Error

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFHayErr(cNomArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomArc                              // Nombre del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.
       LOCAL nCodErr := 0
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL ERROR
       nCodErr := FERROR()
       DO CASE
       CASE nCodErr == 2
	    cError('El Archivo NO Existe '+cNomArc)

       CASE nCodErr == 3
	    cError('El Pate NO Existe '+cNomArc)

       CASE nCodErr == 4
	    cError('Muchos Archivos Abiertos '+cNomArc)

       CASE nCodErr == 5
	    cError('Acceso Denegado '+cNomArc)

       CASE nCodErr == 6
	    cError('Manejador Del Archivo Invalido '+cNomArc)

       CASE nCodErr == 19
	    cError('Disco Protegido '+cNomArc)

       CASE nCodErr == 21
	    cError('No Se Puede Accesar La Unidad '+cNomArc)

       CASE nCodErr == 23
	    cError('Error En El CRC De '+cNomArc)

       CASE nCodErr == 29
	    cError('Falle En La Escritura '+cNomArc)

       CASE nCodErr == 30
	    cError('Falla En La Lectura '+cNomArc)

       CASE nCodErr == 32
	    cError('Error De Acceso Compartido '+cNomArc)

       CASE nCodErr == 33
	    cError('Error De Violaci¢n De Bloqueo '+cNomArc)
       OTHERWISE
	    IF nCodErr == 0
	       lHayErr := .F.
	    ELSE
	       cError('Error I/O No.: '+ALLTRIM(STR(nCodErr,4))+'. Desconocido')
	    ENDIF
       ENDCASE
       RETURN lHayErr
*>>>>FIN ANALISIS DEL ERROR

/*************************************************************************
* TITULO..: SELECCIONA UN ARCHIVO DEL DIRECTORIO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 27/2000 MAR A
       Colombia, Bucaramanga        INICIO: 05:00 PM   JUN 27/2000 MAR

OBJETIVOS:

1- Visualiza en un Browse de los Archivos seg£n el Comodin especificado.

2- Permite seleccionar un archivo del Browse.

1- Retorna el nombre del Archivo.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFilesDir(cPatDir,cComodi,aFilDir)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPath                                // Path del Directorio
       cComodi                              // C¢modin de B£squeda
       aFilDir                              // Archivos del Directorio */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 1                         // Contador
       LOCAL nTotEle := 0                   // Total de Elementos
       LOCAL oBrowse := NIL		    // Objeto Browse
       LOCAL oColumn := NIL                 // Columna del Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS ARCHIVO DEL DIRECTORIO
       cPatDir := IF(EMPTY(cPatDir),DISKNAME()+':\'+CURDIR(),cPatDir)
       cComodi := IF(EMPTY(cComodi),'*.*',cComodi)
       aFilDir := DIRECTORY(cPatDir+'\'+cComodi)
       nTotEle := LEN(aFilDir)
       IF EMPTY(nTotEle)
	  cError('NO EXISTEN ARCHIVOS '+cComodi+' EN '+cPatDir)
	  RETURN NIL
       ENDIF
       SET CURSOR OFF
*>>>>FIN LECTURA DE LOS ARCHIVO DEL DIRECTORIO

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBrowseNew(4,01,21,78)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:SkipBlock     := {|n|nSkipArray(n,@i,nTotEle,oBrowse)}
       oBrowse:GoTopBlock    := {||i:= 1}
       oBrowse:GoBottomBlock := {||i:=nTotEle}
       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo       := {'El Objeto Original es oAr'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       oColumn         := TBColumnNew()
       oColumn:Heading := 'ARCHIVO'
       oColumn:Block   := {||cPatDir+'\'+aFilDir[i,1]}
       oColumn:Width   := LEN(cPatDir)+14
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'TAMA¥O'
       oColumn:Block   := {||aFilDir[i,2]  }
       oColumn:Width   := 20
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'FECHA'
       oColumn:Block   := {||aFilDir[i,3]  }
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'HORA'
       oColumn:Block   := {||aFilDir[i,4]  }
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'ATRIBUTO'
       oColumn:Block   := {||aFilDir[i,5]  }
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna
*>>>>FIN DEFINICION DEL OBJETO BROWSE

*>>>>BROWSE DE LOS ARCHIVOS DEL DIRECTORIO
       BrwArray(oBrowse,aFilDir,@i)
       SET CURSOR ON
       IF !EMPTY(i)
	  RETURN cPatDir+'\'+aFilDir[i,1]
       ENDIF
       RETURN NIL
*>>>>FIN BROWSE DE LOS ARCHIVOS DEL DIRECTORIO

/*************************************************************************
* TITULO..: REEPLAZO DE CARACTERES ESPECIALES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 23/2004 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 23/2004 JUE

OBJETIVOS:

1- Permite cambiar los caracteres especiales de las vocales al convertir
   un archivo de Word a formato texto.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ReplChrTxt(cTexto)

*>>>>PARAMETROS DE LA FUNCION
/*     cTexto				    // @Texto para modificar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARCION DE VARIABLES
       LOCAL      i  := 0                    // Contador
       LOCAL cTxtChr := ''                   // Caracter
*>>>>FIN DECLARCION DE VARIABLES

*>>>>MODIFICACION DEL TEXTO
       FOR i := 1 TO LEN(cTexto)

	   cTxtChr := SUBS(cTexto,i,1)
	   DO CASE
	   CASE ASC(cTxtChr) == 243  // ó
		cTexto := STUFF(cTexto,i,1,'¢')

	   CASE ASC(cTxtChr) == 225  // á
		cTexto := STUFF(cTexto,i,1,' ')

	   CASE ASC(cTxtChr) == 233  // é
		cTexto := STUFF(cTexto,i,1,'‚')

	   CASE ASC(cTxtChr) == 237  // í
		cTexto := STUFF(cTexto,i,1,'¡')

	   CASE ASC(cTxtChr) == 250  // ú
		cTexto := STUFF(cTexto,i,1,'£')

	   CASE ASC(cTxtChr) == 241  // ñ
		cTexto := STUFF(cTexto,i,1,'¤')

	   CASE ASC(cTxtChr) == 211  // Ó
		cTexto := STUFF(cTexto,i,1,'O')

	   CASE ASC(cTxtChr) == 193  // Á
		cTexto := STUFF(cTexto,i,1,'A')

	   CASE ASC(cTxtChr) == 201  // É
		cTexto := STUFF(cTexto,i,1,'E')

	   CASE ASC(cTxtChr) == 205  // É
		cTexto := STUFF(cTexto,i,1,'I')

	   CASE ASC(cTxtChr) == 186  // º
		cTexto := STUFF(cTexto,i,1,'ø')

	   ENDCASE

       ENDFOR
       RETURN NIL
*>>>>FIN MODIFICACION DEL TEXTO

/*************************************************************************
* TITULO..: EDICION DE UN ARCHIVO TEXTO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2001 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 05/2001 MIE

OBJETIVOS:

1- Permite crear o editar un archivo utiliza la tecla <F2>Grabar

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EditFile(cNomSis,fArchvo,cTitulo,cTxtHlp,cTitHlp,nFilSup,nColSup,;
		  nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       fArchvo			            // Nombre del Archivo
       cTitulo                              // T¡tulo de Ayuda
       cTxtHlp			            // Ayuda de Edicci¢n.
       cTitHlp			            // T¡tulo para la Ayuda
       nFilSup                              // Fila Superior
       nColSup                              // Columna Superior
       nFilInf                              // Fila Inferior
       nColInf                              // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARCION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cTexto := ''                   // Texto del Archivo
*>>>>FIN DECLARCION DE VARIABLES

*>>>>CREACION DEL ARCHIVO SI NO EXISTE
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !File(fArchvo)
	  IF FCREATE(fArchvo,0) == -1
	     cError('NO SE PUEDE CREAR EL ARCHIVO '+fArchvo)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO SI NO EXISTE

*>>>>DIBUJO DEL MARCO
       nFilSup := IF(EMPTY(nFilSup),3,nFilSup)
       nColSup := IF(EMPTY(nColSup),0,nColSup)
       nFilInf := IF(EMPTY(nFilInf),22,nFilInf)
       nColinf := IF(EMPTY(nColInf),79,nColInf)
       @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
       centrar(cTitulo,nFilSup,nColSup,nColInf)
*>>>>FIN DIBUJO DEL MARCO

*>>>>ACTIVACION DE LA AYUDA PARA LA EDICION
       cTxtHlp := IF(EMPTY(cTxtHlp),'',cTxtHlp)
       cTitHlp := IF(EMPTY(cTitHlp),'',cTitHlp)
       IF .NOT. EMPTY(cTxtHlp)
	  SETKEY(K_F1,{||AyudaTxt(cTxtHlp,cTitHlp,;
				  '<ESC>Abandona la Ayuda',;
				  nFilSup,nColSup,nFilInf,nColInf)})
       ENDIF
*>>>>FIN ACTIVACION DE LA AYUDA PARA LA EDICION

*>>>>EDICION DEL TEXTO DEL ARCHIVO
       cTexto := MemoRead(fArchvo)
       ReplChrTxt(@cTexto)

       cTexto := MemoEdit(cTexto,;
			  nFilSup+1,nColSup+1,nFilInf-1,nColInf-1,.T.,;
			  "MemoFunc")
       MemoWrit(fArchvo,cTexto)
       SETKEY(K_F1,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN EDICION DEL TEXTO DEL ARCHIVO

/*************************************************************************
* TITULO..: LINEA DE ESTADO PARA LA EDICION DEL ARCHIVO                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2001 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   SEP 05/2001 MIE

OBJETIVOS:

1- Visualiza el n£mero de fila y columna donde se encuentra el cursor y
   documenta la tecl <F2> para grabar el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MemoFunc(nModo,nNroLin,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       nModo                                // Modo del MemoEdit
       nNroLin                              // N£mero de la l¡nea
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #include "memoedit.ch"

       LOCAL nTecla  := 0                   // Tecla Pulsada
       LOCAL nTecPul := 0                   // Tecla Pulsada
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA LINEA DE ESTADO
       @ 23,00 SAY 'L¡nea: '+STR(nNroLin,4)+' '+;
		   'Columna: '+STR(nNroCol,4)+;
		   'º<F1>Ayudaº<F2>Graba º<CTRL>Y Borra l¡neaº'+;
		   '<ESC>Abandona'+;
		   SPACE(10) COLOR('I')
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>ANALISIS DE LA TECLA PULSADA
       IF nModo == ME_INIT
	  nTecla := ME_DEFAULT     // Continuar
       ELSE
	 nTecPul := LastKey()
	 DO CASE

	 CASE nTecPul == K_F2

	      IF lPregunta('DESEA GRABAR Y SALIR? Si No')
		 nTecla := K_CTRL_W
	      ELSE
		 nTecla := ME_DEFAULT
	      ENDIF

	 CASE nTecPul == K_ESC
	      IF lPregunta('DESEA ABANDONAR LA EDICION? Si No')
		 nTecla := K_ESC
	      ELSE
		 nTecla := ME_IGNORE
	      ENDIF

	 OTHERWISE
	      nTecla := ME_DEFAULT
	 ENDCASE
       ENDIF
       RETURN nTecla
*>>>>FIN ANALISIS DE LA TECLA PULSADA

/*************************************************************************
* TITULO..: IMPRESION DEL ARCHIVO TEXTO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2001 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 AM   SEP 05/2001 MIE

OBJETIVOS:

1- Permite imprimir un archivo texto en forma justificada.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnFileTxt(cNomArc,aMezcla,cNomSis,cNomEmp)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomArc                              // Nombre del Archivo
       aMezcla                              // Campos a mezclar con el texto*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       #DEFINE MARIZQ_10  CHR(27)+'l'+CHR(10)
       #DEFINE MARDER_75  CHR(27)+'Q'+CHR(75)
       #DEFINE JUSTIF_ON  CHR(27)+'a'+CHR(3)

       #DEFINE pDESDE_BOF 0
       #DEFINE pDESDE_POS_ACTUAL 1
       #DEFINE pDESDE_EOF 2
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL       a := 0                   // Puntero
       LOCAL       i := 0                   // Contador
       LOCAL nNroArc := 0                   // N£mero de Archivo
       LOCAL nLenLin := 1024                // Longitud de l¡nea
       LOCAL cLinTxt := ''                  // L¡nea de Texto
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
       LOCAL cLinJus := CHR(141)+CHR(10)    // Fin de l¡nea justificada
       LOCAL cEofFil := CHR(26)             // Final del Archivo.
       LOCAL cBuffer := SPACE(nLenLin)      // Buffer de Lectura
       LOCAL nBytLee := 0                   // Bytes le¡dos
       LOCAL nFinLin := 0                   // Posici¢n del fin de la l¡nea
       LOCAL nPointr := 0                   // Apuntador
       LOCAL lCodBlo := .F.                 // .T. Hay CodeBlock
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PARAMETROS PARA LA IMPRESORA
       SendCodes(GRAPHI_ON+CONDEN_OF+PROPOR_OF+PICA+DRAFT_ON)
       SendCodes(MARIZQ_10+MARDER_75)
       SendCodes(JUSTIF_ON)
*>>>>FIN PARAMETROS PARA LA IMPRESORA

*>>>>APERTURA DEL ARCHIVO
       nNroArc := FOPEN(cNomArc)
       IF nNroArc <= 0
	  cError('NO SE PUDO ABRIR EL ARCHIVO')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO

*>>>>IMPRESION DEL ARCHIVO TEXTO
       FSEEK(nNroArc,0,pDESDE_BOF)
      *Ubica el puntero en el inicio

       DO WHILE .T.

**********LECTURA DE LA LINEA
	    nBytLee = fRead(nNroArc,@cBuffer,nLenLin)
	   *Lee el Buffer de longitud de acuerdo a nLenLin

	    IF nBytLee == 1 .OR. nBytLee == 0
	       EXIT
	    ENDIF

	    IF AT(cEofFil,cBuffer) < AT(cDelimi,cBuffer)
	       nFinLin = AT(cEofFil,cBuffer)
	      *Buscar delimitador de f¡n de Archivo
	    ELSE
	       nFinLin = AT(cDelimi,cBuffer)
	      *Buscar delimitador de f¡n de l¡nea
	    ENDIF
	  *ÀPendiente por implementar ojo

	    nFinLin = AT(cDelimi,cBuffer)
	   *Buscar delimitador de f¡n de l¡nea
**********FIN LECTURA DE LA LINEA

**********MOVER EL PUNTERO AL INICIO DE LA SIGUIENTE LINEA
	    IF nFinLin = 0
	       // Significa que:
	       //   No se encontr¢ el delimitador, o
	       //   El pointer est  en EOF, o
	       //   La l¡nea es demasiado larga.
	    ELSE
	       a:=FSEEK(nNroArc,(nBytLee*-1)+nFinLin+1,pDESDE_POS_ACTUAL)
	      *Mueve el puntero
	    ENDIF
**********FIN MOVER EL PUNTERO AL INICIO DE LA SIGUIENTE LINEA

**********ACTUALIZACION DEL PUNTERO
	    cLinTxt := SUBSTR(cBuffer, 1, nFinLin - 1)
	    nPointr := FSEEK( nNroArc, 0, pDESDE_POS_ACTUAL )
	   *Actualiza Pointer
**********FIN ACTUALIZACION DEL PUNTERO

**********SUSTITUCION DEL FIN DE LINEA JUSTIFICADA
	    DO WHILE AT(cLinJus,cLinTxt) > 0
	       cLinTxt := STUFF(cLinTxt,AT(cLinJus,cLinTxt),2,'')
	    ENDDO
**********FIN SUSTITUCION DEL FIN DE LINEA JUSTIFICADA

**********SUSTITUCION DE LOS CAMPOS
	    lCodBlo := .F.
	    IF !EMPTY(aMezcla) .AND. !EMPTY(cLinTxt)

*--------------REEMPLAZO DE CADA CAMPO
		 FOR i := 1 TO LEN(aMezcla)

*::::::::::::::::::::ANALISIS DEL CAMPO A SUSTITUIR
		       lCodBlo := .F.
		       IF AT(aMezcla[i,1],cLinTxt) > 0

*.........................ANALISIS SI EXISTE UN CODEBLOCK
			    IF VALTYPE(aMezcla[i,2]) # 'B'
			       cLinTxt := STUFF(cLinTxt,AT(aMezcla[i,1],cLinTxt),;
						LEN(aMezcla[i,1]),;
						NEGRA_ON+aMezcla[i,2]+NEGRA_OF)
			    ELSE
			       lCodBlo := .T.
			       EXIT
			    ENDIF
*.........................FIN ANALISIS SI EXISTE UN CODEBLOCK

		       ENDIF
*::::::::::::::::::::FIN ANALISIS DEL CAMPO A SUSTITUIR

		 ENDFOR
*--------------FIN REEMPLAZO DE CADA CAMPO

	    ENDIF
**********FIN SUSTITUCION DE LOS CAMPOS

**********IMPRESION DEL TEXTO
	    IF lCodBlo
	       EVAL(aMezcla[i,2])
	    ELSE
	       @ PROW()+1,00 SAY cLinTxt
	    ENDIF
**********FIN IMPRESION DEL TEXTO

       ENDDO
       FCLOSE(nNroArc)
      *Cierra el archivo

       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL ARCHIVO TEXTO

/*************************************************************************
* TITULO..: GRABACION DE UN ARCHIVO DE TEXTO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 29/2002 VIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 29/2002 VIE

OBJETIVOS:

1- Crea un archivo texto con campos delimitados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FileChr(fArchvo,aVlrReg,cTxtChr,lValida)

*>>>>DESCRIPCION DE PARAMETROS
/*     fArchvo                              // Archivo a Crear
       aVlrReg                              // Valor de los Registros
       cTxtChr                              // Delimitar de Campos
       lValida                              // .T. Validar la Existencia del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampo  := ''                  // Campo del Registro
       LOCAL cTxtReg := ''                  // Texto del Registro
       LOCAL nAvance := 0                   // Control de Avance
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       lValida := IF(EMPTY(lValida),.F.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN NIL
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>GRABACION DEL REGISTRO
*       Termometro(10)
       cTxtChr := IF(EMPTY(cTxtChr),',',cTxtChr)

       FOR i := 1 TO LEN(aVlrReg)

/*
	   nAvance := INT( (i/LEN(aVlrReg))*100)
	   IF STR(nAvance,3) $ '25 50 75100'
	      Termometro(nAvance)
	   ENDIF
	 *ÀTermometro de Avance
*/

	   cTxtReg := ''
	   FOR j := 1 TO LEN(aVlrReg[i])
	       cCampo  := aVlrReg[i,j]
	       IF VALTYPE(cCampo) == 'N'
		  cCampo := STR(cCampo,16,2)
	       ENDIF
	       cTxtReg += IF(cCampo == NIL,"",ALLTRIM(cCampo))

	       IF j < LEN(aVlrReg[i])
		  cTxtReg += ","
	       ENDIF
	   ENDFOR
	   lSaveTxt(cTxtReg,nHandle,fArchvo)

       ENDFOR
*>>>>FIN GRABACION DEL REGISTRO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: GRABACION DE TEXTO                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 29/2002 VIE A
       Colombia, Bucaramanga        INICIO: 05:45 PM   MAR 29/2002 VIE

OBJETIVOS:

1- Graba un texto en un archivo binario

2- Retorna .T. Si no se presentaron problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSaveTxt(cTexTxt,nHandle,fArchvo,lMsgErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTexTxt                              // Texto a Grabar
       nHandle                              // Manejador de Archivo
       fArchvo                              // Nombre del Archivo
       lMsgErr                              // .T. Mensaje de Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lGrabar := .F.                 // .T. Grab¢ el Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DEL TEXTO
       lMsgErr := IF(EMPTY(lMsgErr),.T.,lMsgErr)
       cTexTxt += CHR(13)+CHR(10)
       IF !FWRITE(nHandle,cTexTxt) # LEN(cTexTxt) .AND. lFHayErr(fArchvo)
	  lGrabar := .F.
	  IF lMsgErr
	     cError(ALLTRIM(SUBS(cTexTxt+SPACE(20),1,20)),;
		   'EL TEXTO',;
		   'NO SE PUDO GRABAR EN '+fArchvo)
	  ENDIF
       ELSE
	  lGrabar := .T.
       ENDIF
       RETURN lGrabar
*>>>>FIN GRABACION DEL TEXTO

/*************************************************************************
* TITULO..: GRABACION DEL ARCHIVO SQL. TABLA Y REGISTROS                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2003 MAR A
       Colombia, Bucaramanga        INICIO: 03:20 PM   MAR 04/2003 MAR

OBJETIVOS:

1- Crea la Tabla y lo Registros

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FileSql(PathArc,fArchvo,FileTbl,cCamIns,aStrDbf,cNalias,lValida,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo
       fArchvo                              // Archivo a Crear
       FileTbl                              // Nombre de la Tabla
       cCamIns			            // Campos de Lectura del Insert
       aStrDbf			            // Estructura del Archivo
       cNalias                              // Alias del Archivo
       lValida                              // .T. Validar la Existencia del Archivo
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampos := ''                  // Campo del Registro
       LOCAL cTxtReg := ''                  // Texto del Registro
       LOCAL nAvance := 0                   // Control de Avance
       LOCAL nNroPos := 0                   // N£mero de Posici¢n

       LOCAL cCamKey := ''                  // Campo Llave
       LOCAL cNomCam := ''                  // Nombre del Campo
       LOCAL cTipCam := ''                  // Tipo del Campo
       LOCAL nLenCam := ''                  // Longitud del Campo
       LOCAL nNroDec := ''                  // Numero de Decimales
       LOCAL cExtras := ''                  // Campo Extra
       LOCAL cCodExt := ''                  // C¢digo Extra
       LOCAL lHayCam := .F.                 // .T. Hay Campo

       LOCAL cCamSql := ''                  // Nombre del Campo Sql
       LOCAL cTipSql := ''                  // Tipo del Campo Sql
       LOCAL cLenSql := ''                  // Ancho del Campo Sql
       LOCAL cDecSql := ''                  // Decimales del Campo Sql
       LOCAL cCamTxt := ''                  // Contenido del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       IF '.' $ fArchvo
	  fArchvo := SUBS(fArchvo,1,AT('.',fArchvo)-1)
       ENDIF
       fArchvo := PathArc+'\'+fArchvo+'.sqd'


       lValida := IF(EMPTY(lValida),.T.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN NIL
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ANALISIS DE DECISION
       nNroPos := AT('.',FileTbl)
       IF nNroPos # 0
	  FileTbl := SUBS(FileTbl,1,nNroPos-1)
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CREACION DE LA TABLA
       cCodExt := aStrDbf[1,1]
       cCodExt := SUBS(cCodExt,LEN(cCodExt)-2,3)
       cCamKey := "nIdeCod"+cCodExt
       lSaveTxt("CREATE TABLE "+LOWER(FileTbl)+' (',nHandle,fArchvo)
       lSaveTxt(SPACE(02)+cCamKey+" int(16) unsigned NOT NULL auto_increment,",nHandle,fArchvo)

       FOR i := 1 TO LEN(aStrDbf)

	   cNomCam := aStrDbf[i,1]
	   cTipCam := aStrDbf[i,2]
	   nLenCam := aStrDbf[i,3]
	   nNroDec := aStrDbf[i,4]

	   DO CASE
	   CASE UPPER(SUBS(cTipCam,1,1)) == 'C'
		IF nLenCam <= 255
		   cTipSql := "varchar("+;
			      ALLTRIM(STR(nLenCam,nLenCam,0))+;
			      ") NOT NULL default '',"
		ELSE
		    cTipSql := "blob NOT NULL,"
		    cTipSql := "blob,"
		ENDIF

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'D'
		cTipSql := "date NOT NULL default '',"

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'L'
		cTipSql := "tinyint(1) NOT NULL default 0,"

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec == 0
		cTipSql := "int("+;
			   ALLTRIM(STR(nLenCam,nLenCam,0))+;
			   ") NOT NULL default 0,"

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec # 0
		cTipSql := "float("+;
			   ALLTRIM(STR(nLenCam,nLenCam,0))+;
			   ") NOT NULL default 0,"

	   ENDCASE
	   lSaveTxt(SPACE(02)+cNomCam+' '+cTipSql,nHandle,fArchvo)
       ENDFOR
       lSaveTxt(SPACE(02)+"PRIMARY KEY "+" ("+cCamKey+")",nHandle,fArchvo)
       lSaveTxt(SPACE(02)+")TYPE=InnoDB "+;
			    "COMMENT='Estructura de la tabla "+;
			     LOWER(FileTbl)+"';",nHandle,fArchvo)
       lSaveTxt(SPACE(02)+"",nHandle,fArchvo)
*>>>>FIN CREACION DE LA TABLA

*>>>>ANALISIS DE LA GRABACION DE REGISTROS
       IF EMPTY(cNalias)

**********BROWSE DEL ARCHIVO
	    IF !EMPTY(oBrowse)
	       DBGOTOP()
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	    ENDIF
**********FIN BROWSE DEL ARCHIVO

**********CERRANDO ARCHIVOS
	    IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	       cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
	    ENDIF
	    RETURN NIL
**********FIN CERRANDO ARCHIVOS

       ENDIF
*>>>>FIN ANALISIS DE LA GRABACION DE REGISTROS

*>>>>REGISTROS DE LA TABLA
       SELECT &cNalias
       DBGOTOP()
       DO WHILE .NOT. EOF()

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('Tabla:'+FileTbl+'.'+;
			'Registro No. '+ALLTRIM(STR(RECNO()),9)+'/'+;
					ALLTRIM(STR(RECCOUNT()),9),'')
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE LOS CAMPOS
	    cCamTxt := ''
	    FOR i := 1 TO LEN(aStrDbf)

		cNomCam := aStrDbf[i,1]
		cTipCam := aStrDbf[i,2]
		nLenCam := aStrDbf[i,3]
		nNroDec := aStrDbf[i,4]

		cCodExt := ''
		IF LEN(aStrDbf[i]) == 5
		   cExtras := aStrDbf[i,5]
		   IF SUBS(cExtras,1,1) == 'X'
		      cCodExt := SUBS(cExtras,2,LEN(cExtras))
		      cExtras := ''
		   ENDIF
		ELSE
		   cExtras := ''
		ENDIF
		lHayCam := IF(EMPTY(cExtras),.T.,.F.)

		DO CASE
		CASE UPPER(SUBS(cTipCam,1,1)) == 'C'

		     IF lHayCam
			cCamTxt += "'"+ALLTRIM(&(cNalias+"->"+cNomCam))+;
				       cCodExt+"'"+;
				   IF(i==LEN(aStrDbf),"",",")

			cCampos := "'"+ALLTRIM(&(cNalias+"->"+cNomCam))+;
				       cCodExt+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ELSE
			cCamTxt += "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")

			cCampos := "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ENDIF

		CASE UPPER(SUBS(cTipCam,1,1)) == 'D'

		CASE UPPER(SUBS(cTipCam,1,1)) == 'L'

		     IF lHayCam
			cCampos := "'"+;
				   IF(&(cNalias+"->"+cNomCam),'1','0')+;
				   "'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ELSE
			cCampos := "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ENDIF

		CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec == 0

		     IF lHayCam
			cCampos := "'"+;
				   ALLTRIM(STR(&(cNalias+"->"+cNomCam),;
					       nLenCam))+;
				   "'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ELSE
			cCampos := "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ENDIF


		CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec # 0

		ENDCASE

	       DO CASE
	       CASE i == 1
		    lSaveTxt("INSERT INTO "+LOWER(FileTbl)+' '+cCamIns+' '+;
			     " VALUES ("+cCampos+" # Campo: "+cNomCam,;
			     nHandle,fArchvo)

	       CASE i == LEN(aStrDbf)
		    lSaveTxt(cCampos+");"+" # Campo: "+cNomCam,nHandle,fArchvo)

	       OTHERWISE
		    lSaveTxt(cCampos+" # Campo: "+cNomCam,nHandle,fArchvo)
	       ENDCASE

	    ENDFOR
**********FIN ANALISIS DE LOS CAMPOS

	  SELECT &cNalias
	  DBSKIP()

       ENDDO
*>>>>FIN REGISTROS DE LA TABLA

*>>>>BROWSE DEL ARCHIVO
       IF !EMPTY(oBrowse)
	  DBGOTOP()
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
*>>>>FIN BROWSE DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: GRABACION DEL ARCHIVO SQL. TABLA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2003 MAR A
       Colombia, Bucaramanga        INICIO: 03:20 PM   MAR 04/2003 MAR

OBJETIVOS:

1- Crea la Tabla y los Registros

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fSqlTbl(PathArc,fArchvo,FileTbl,aStrDbf,cNalias,lValida,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo
       fArchvo                              // Archivo a Crear
       FileTbl                              // Nombre de la Tabla
       aStrDbf			            // Estructura del Archivo
       cNalias                              // Alias del Archivo
       lValida                              // .T. Validar la Existencia del Archivo
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampos := ''                  // Campo del Registro
       LOCAL cTxtReg := ''                  // Texto del Registro
       LOCAL nAvance := 0                   // Control de Avance
       LOCAL nNroPos := 0                   // N£mero de Posici¢n

       LOCAL cCamKey := ''                  // Campo Llave
       LOCAL cNomCam := ''                  // Nombre del Campo
       LOCAL cTipCam := ''                  // Tipo del Campo
       LOCAL nLenCam := ''                  // Longitud del Campo
       LOCAL nNroDec := ''                  // Numero de Decimales
       LOCAL cExtras := ''                  // Campo Extra
       LOCAL cCodExt := ''                  // C¢digo Extra
       LOCAL lHayCam := .F.                 // .T. Hay Campo

       LOCAL cCamSql := ''                  // Nombre del Campo Sql
       LOCAL cTipSql := ''                  // Tipo del Campo Sql
       LOCAL cLenSql := ''                  // Ancho del Campo Sql
       LOCAL cDecSql := ''                  // Decimales del Campo Sql
       LOCAL cCamTxt := ''                  // Contenido del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       IF AT('.',fArchvo) # 0
	  fArchvo := SUBS(fArchvo,1,AT('.',fArchvo)-1)
       ENDIF

       IF EMPTY(cNalias)
	  fArchvo := PathArc+'\'+fArchvo+'.str'
       ELSE
	  fArchvo := PathArc+'\'+fArchvo+'.sql'
       ENDIF

       lValida := IF(EMPTY(lValida),.T.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN NIL
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ANALISIS DE DECISION
       nNroPos := AT('.',FileTbl)
       IF nNroPos # 0
	  FileTbl := SUBS(FileTbl,1,nNroPos-1)
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CREACION DE LA TABLA
	cCamKey := aStrDbf[1,1]
*       cCodExt := aStrDbf[1,1]
*       cCodExt := SUBS(cCodExt,LEN(cCodExt)-2,3)
*       cCamKey := "nIdeCod"+cCodExt

       lSaveTxt("CREATE TABLE "+LOWER(FileTbl)+' (',nHandle,fArchvo)
       lSaveTxt(SPACE(02)+cCamKey+" int(16) unsigned NOT NULL auto_increment,",nHandle,fArchvo)
       FOR i := 2 TO LEN(aStrDbf)

	   cNomCam := aStrDbf[i,1]
	   cTipCam := aStrDbf[i,2]
	   nLenCam := aStrDbf[i,3]
	   nNroDec := aStrDbf[i,4]

	   DO CASE
	   CASE UPPER(SUBS(cTipCam,1,1)) == 'C'
		IF nLenCam <= 255
		   cTipSql := "varchar("+;
			      ALLTRIM(STR(nLenCam,nLenCam,0))+;
			      ") NOT NULL default '',"
		ELSE
		    cTipSql := "blob NOT NULL,"
		    cTipSql := "blob,"
		ENDIF

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'D'
		cTipSql := "date NOT NULL default '',"

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'L'
		cTipSql := "tinyint(1) NOT NULL default 0,"

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec == 0
		cTipSql := "int("+;
			   ALLTRIM(STR(nLenCam,nLenCam,0))+;
			   ") NOT NULL default 0,"

	   CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec # 0
		cTipSql := "float("+;
			   ALLTRIM(STR(nLenCam,nLenCam,0))+;
			   ") NOT NULL default 0,"

	   ENDCASE
	   lSaveTxt(SPACE(02)+cNomCam+' '+cTipSql,nHandle,fArchvo)
       ENDFOR
       lSaveTxt(SPACE(02)+"PRIMARY KEY "+" ("+cCamKey+")",nHandle,fArchvo)
       lSaveTxt(SPACE(02)+")TYPE=InnoDB "+;
			    "COMMENT='Estructura de la tabla "+;
			     LOWER(FileTbl)+"';",nHandle,fArchvo)
       lSaveTxt(SPACE(02)+"",nHandle,fArchvo)
*>>>>FIN CREACION DE LA TABLA

*>>>>BROWSE DEL ARCHIVO
       IF !EMPTY(oBrowse)
	  SELECT &cNalias
	  DBGOTOP()
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
*>>>>FIN BROWSE DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: GRABACION DEL ARCHIVO SQL.REGISTROS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2003 MAR A
       Colombia, Bucaramanga        INICIO: 03:20 PM   MAR 04/2003 MAR

OBJETIVOS:

1- Crea la Tabla y lo Registros

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fSqlIns(PathArc,fArchvo,FileTbl,cCamIns,;
		 aStrDbf,cNalias,lValida,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo
       fArchvo                              // Archivo a Crear
       FileTbl                              // Nombre de la Tabla
       cCamIns			            // Campos de Lectura del Insert
       aStrDbf			            // Estructura del Archivo
       cNalias                              // Alias del Archivo
       lValida                              // .T. Validar la Existencia del Archivo
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampos := ''                  // Campo del Registro
       LOCAL cTxtReg := ''                  // Texto del Registro
       LOCAL nAvance := 0                   // Control de Avance
       LOCAL nNroPos := 0                   // N£mero de Posici¢n

       LOCAL cCamKey := ''                  // Campo Llave
       LOCAL cNomCam := ''                  // Nombre del Campo
       LOCAL cTipCam := ''                  // Tipo del Campo
       LOCAL nLenCam := ''                  // Longitud del Campo
       LOCAL nNroDec := ''                  // Numero de Decimales
       LOCAL cExtras := ''                  // Campo Extra
       LOCAL cCodExt := ''                  // C¢digo Extra
       LOCAL lHayCam := .F.                 // .T. Hay Campo

       LOCAL cCamSql := ''                  // Nombre del Campo Sql
       LOCAL cTipSql := ''                  // Tipo del Campo Sql
       LOCAL cLenSql := ''                  // Ancho del Campo Sql
       LOCAL cDecSql := ''                  // Decimales del Campo Sql
       LOCAL cCamTxt := ''                  // Contenido del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       fArchvo := SUBS(fArchvo,1,AT('.',fArchvo)-1)
       IF EMPTY(cNalias)
	  fArchvo := PathArc+'\'+fArchvo+'.sql'
       ELSE
	  fArchvo := PathArc+'\'+fArchvo+'.sqr'
       ENDIF

       lValida := IF(EMPTY(lValida),.T.,lValida)
       IF lValida .AND. File(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','YA EXISTE')
	  IF !lPregunta('DESEA REESCRIBIR EL ARCHIVO? No Si')
	     RETURN NIL
	  ENDIF
       ENDIF
       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ANALISIS DE DECISION
       nNroPos := AT('.',FileTbl)
       IF nNroPos # 0
	  FileTbl := SUBS(FileTbl,1,nNroPos-1)
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>REGISTROS DE LA TABLA
       SELECT &cNalias
       DBGOTOP()
       DO WHILE .NOT. EOF()

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('Tabla:'+FileTbl+'.'+;
			'Registro No. '+ALLTRIM(STR(RECNO()),9)+'/'+;
					ALLTRIM(STR(RECCOUNT()),9),'')
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE LOS CAMPOS
	    cCamTxt := ''
	    FOR i := 1 TO LEN(aStrDbf)

		cNomCam := aStrDbf[i,1]
		cTipCam := aStrDbf[i,2]
		nLenCam := aStrDbf[i,3]
		nNroDec := aStrDbf[i,4]

		cCodExt := ''
		IF LEN(aStrDbf[i]) == 5
		   cExtras := aStrDbf[i,5]
		   IF SUBS(cExtras,1,1) == 'X'
		      cCodExt := SUBS(cExtras,2,LEN(cExtras))
		      cExtras := ''
		   ENDIF
		ELSE
		   cExtras := ''
		ENDIF
		lHayCam := IF(EMPTY(cExtras) .OR.;
			      cExtras == 'PASSWORD',.T.,.F.)

		DO CASE
		CASE UPPER(SUBS(cTipCam,1,1)) == 'C'

		     IF lHayCam
			IF cExtras # 'PASSWORD'
			   cCamTxt += "'"+ALLTRIM(&(cNalias+"->"+cNomCam))+;
					  cCodExt+"'"+;
				      IF(i==LEN(aStrDbf),"",",")

			   cCampos := "'"+ALLTRIM(&(cNalias+"->"+cNomCam))+;
					  cCodExt+"'"+;
				      IF(i==LEN(aStrDbf),"",",")
			ELSE
			   cCamTxt += "PASSWORD('"+ALLTRIM(&(cNalias+"->"+cNomCam))+;
					  cCodExt+"')"+;
				      IF(i==LEN(aStrDbf),"",",")

			   cCampos := "PASSWORD('"+ALLTRIM(&(cNalias+"->"+cNomCam))+;
					  cCodExt+"')"+;
				      IF(i==LEN(aStrDbf),"",",")
			ENDIF
		     ELSE
			cCamTxt += "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")

			cCampos := "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ENDIF

		CASE UPPER(SUBS(cTipCam,1,1)) == 'D'

		CASE UPPER(SUBS(cTipCam,1,1)) == 'L'

		     IF lHayCam
			cCampos := "'"+;
				   IF(&(cNalias+"->"+cNomCam),'1','0')+;
				   "'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ELSE
			cCampos := "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ENDIF

		CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec == 0

		     IF lHayCam
			cCampos := "'"+;
				   ALLTRIM(STR(&(cNalias+"->"+cNomCam),;
					       nLenCam))+;
				   "'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ELSE
			cCampos := "'"+cExtras+"'"+;
				   IF(i==LEN(aStrDbf),"",",")
		     ENDIF


		CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec # 0

		ENDCASE

		DO CASE
		CASE i == 1
		    lSaveTxt("INSERT INTO "+LOWER(FileTbl)+' '+cCamIns+' '+;
			     " VALUES ("+cCampos+" # Campo: "+cNomCam,;
			     nHandle,fArchvo)

		CASE i == LEN(aStrDbf)
		     lSaveTxt(cCampos+");"+" # Campo: "+cNomCam,nHandle,fArchvo)

		OTHERWISE
		     lSaveTxt(cCampos+" # Campo: "+cNomCam,nHandle,fArchvo)
		ENDCASE

	    ENDFOR
**********FIN ANALISIS DE LOS CAMPOS

	  SELECT &cNalias
	  DBSKIP()

       ENDDO
*>>>>FIN REGISTROS DE LA TABLA

*>>>>BROWSE DEL ARCHIVO
       IF !EMPTY(oBrowse)
	  DBGOTOP()
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
*>>>>FIN BROWSE DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS