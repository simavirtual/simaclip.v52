/*BIBLIOTECAS DE FUNCIONES DE USO GENERAL 1994

 AUTOR: LUIS CARLOS SALAMANCA        FECHA DE CREACION:
	 SEMINARIO DE CLIPPER

 MODIFICACION: NELSON FERNANDEZ GOMEZ


 REQUERIMIENTOS

 - Compilar: clipper funcions /w/m

 OBJETIVOS

 - Son independientes de cualquier programa

 FUNCIONES

  - lUseDbf,lExisteArc,xCampoLic

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/


*>>>>DECLARACION DE CONSTANTES GENERALES
       #INCLUDE "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES


/*************************************************************************
* TITULO DE LA FUNCION......: VALIDACION DE UN ARCHIVO                   *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Valida la existencia de un archivo en el disco.

  2- Retorna si existe el nombre del archivo

* SINTAXIS:

  lExisteArch('AUTOEXEC.BAT')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lExisteArch(cNomArc)
LOCAL lHayErr := FILE(ALLTRIM(cNomArc))
IF !(lHayErr)
*   cError('No existe el Archivo '+ UPPER(cNomArc))
*   TONE(1200,10)
   STORE .T. TO lHayErr
ELSE
   STORE .F. TO lHayErr
ENDIF
RETURN lHayErr

/*************************************************************************
* TITULO DE LA FUNCION......: ABRIR UNA BASE DE DATOS                    *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Abre una base de datos en modo exclusivo o compartido

  2- Asigna alias para ambientes multiusuario

  3- Retorna: Si se pudo a abrir o NO el archivo

* SINTAXIS:

  AbrirDbf('CLIENTES', ïcltï, .t.)
	     abre CLIENTES.DBF en modo COMPARTIDO y asigna alias = CLT

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseDbf(lNewArea,cNomArc,cNalias,cNomNtx,;
		 lShared,nModCry,lMensaj,lReadOnly)

*>>>>PARAMETROS DE LA FUNCION
/*     lNewArea                             // Nueva area de trabajo
       cNomArc                              // Nombre del archivo .dbf
       cNalias		                    // Alias para la base de datos
       cNomNtx                              // Nombre del archivo indice
       lShared                              // Modo: .T. = Compartido .F. = Exclusivo
       nModCry			            // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       lMensaj                              // .T. Mostrar mensaje error
       lReadOnly                            // Modo: .T. = Solo Lectura .F. = Normal */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                  // .T. Hay Error
       LOCAL nNroErr := 0                    // N£mero de Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       cNomArc   := IF(cNomArc == NIL,'ERROR',cNomArc)
       cNalias   := IF(cNalias == NIL,NIL,cNalias)
       lShared   := IF(lShared == NIL,.F.,lShared)
       lMensaj   := IF(lMensaj == NIL,.T.,lMensaj)
       lReadOnly := IF(lReadOnly==NIL,.F.,lReadOnly)
       nModCry   := IF(nModCry==NIL,0,nModCry)
       nModCry   := IF(nModCry > 2,0,nModCry)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>APERTURA Y VALIDACION DEL ARCHIVO
       CloseDbf(cNalias)
       DO WHILE .T.

**********VALIDACION DE EXISTENCIA DEL ARCHIVO
	    IF lExisteArc(cNomArc)
	       IF !lMensaj
		  lHayErr := .F.
		  EXIT
	       ENDIF

	       IF CError('Presione una tecla para Reintentar',;
			 'El archivo '+UPPER(cNomArc)+' No Existe',;
			 'Escape = NO Intentar m s. ') == CHR(K_ESC)
		  lHayErr := .F.
		  EXIT
	       ELSE
		  LOOP
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE EXISTENCIA DEL ARCHIVO

**********VALIDACION DE EXISTENCIA DEL ARCHIVO INDICE
	    IF cNomNtx # NIL .AND. lExisteArc(cNomNtx)
	       IF cError('Presione una tecla para Reintentar',;
			 'El archivo Indice '+UPPER(cNomNtx)+' No Existe',;
			 'Escape = NO Intentar m s. ') == CHR(K_ESC)
		  lHayErr := .F.
		  EXIT
	       ELSE
		  LOOP
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE EXISTENCIA DEL ARCHIVO INDICE

**********ANALISIS DE LA PROTECION DE LA BASE DE DATOS
	    IF nModCry # 0

*--------------VERIFICACION DE ERRORES DE I/O
		 nNroErr := nHayProtec(cNomArc)
		 IF nNroErr == 2
		    IF cError('Presione una tecla para Reintentar',;
			      'El archivo '+cNomArc+;
			      ' No Se puede Accesar. Error en las Lecturas',;
			      'Escape = NO Intentar m s. ') == CHR(K_ESC)
		       lHayErr := .F.
		       EXIT
		    ELSE
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN VERIFICACION DE ERRORES DE I/O

*--------------VALIDACION DE LA PROTECION DEL ARCHIVO
		 IF nModCry == 2 .AND. nNroErr == 0  // DBF NO Protegida

		    IF cError('Presione una tecla para Reintentar',;
			      'El archivo '+cNomArc+;
			      ' No Se puede Accesar. Error:1',;
			      'Escape = NO Intentar m s. ') == CHR(K_ESC)
		       lHayErr := .F.
		       EXIT
		    ELSE
		       LOOP
		    ENDIF

		 ENDIF
*--------------FIN VERIFICACION DE LA PROTECION

*--------------PROTECION DE LA BASE DE DATOS
		 IF nNroErr # 0  // DBF SI Protegida
		    IF !lProtecDbf(cNomArc,'#DBFNTX&')
		       IF cError('Presione una tecla para Reintentar',;
				 'El archivo '+cNomArc+;
				 ' No Se puede Accesar. Error:2',;
				 'Escape = NO Intentar m s. ') == CHR(K_ESC)
			  lHayErr := .F.
			  EXIT
		       ELSE
			  LOOP
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN PROTECION DE LA BASE DE DATOS

	    ENDIF
**********FIN ANALISIS DE LA PROTECION DE LA BASE DE DATOS

**********APERTURA DEL ARCHIVO
	    DBUSEAREA(lNewArea,,cNomArc,cNalias,lShared,lReadOnly)
	   *Intenta abrir el archivo
**********FIN APERTURA DEL ARCHIVO

**********APERTURA DEL ARCHIVO INDICE
	    IF cNomNtx # NIL 
	       IF ALLTRIM(UPPER(ALIAS())) == ALLTRIM(UPPER(CNalias))
		  DBSETINDEX(cNomNtx)
	       ELSE
		  cError('NO SE ABRIO EL ARCHIVO '+cNomArc)
	       ENDIF
	    ENDIF
**********FIN APERTURA DEL ARCHIVO INDICE

**********VALIDACION DEL ARCHIVO
	    IF lShared

*--------------VALIDACION EN RED
		 IF (lHayErr := !(NETERR()))
		     EXIT
		 ELSE
		     IF cError('Presione una tecla para Reintentar',;
			       'El archivo '+cNomArc+' NO est  Disponible',;
			       'Escape = NO Intentar m s') == CHR(K_ESC)
			EXIT
		     ENDIF
		 ENDIF
*--------------FIN VALIDACION EN RED

	    ELSE

*--------------VALIDACION MONOUSUARIO
		 IF !ALIAS(SELECT(cNalias)) == cNalias
		    lHayErr := .F.
		    IF cError('Presione una tecla para Reintentar',;
			      'El archivo '+cNomArc+' NO se pudo Abrir',;
			      'Escape = NO Intentar m s') == CHR(K_ESC)
		       EXIT
		    ENDIF
		 ELSE
		    lHayErr := .T.
		    EXIT
		 ENDIF
*--------------FIN VALIDACION MONOUSUARIO

	    ENDIF
**********FIN VALIDACION DEL ARCHIVO

       ENDDO
       RETURN lHayErr  // Abri¢ => .T. , No abri¢ => .F.
*>>>>FIN APERTURA Y VALIDACION DEL ARCHIVO

/*************************************************************************
* TITULO..: SELECCION DE AREAS DE TRABAJO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 16/2000 VIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   JUN 16/2000 VIE

OBJETIVOS:

1- Pone en uso todos los archivos pasados como parametros

2- Retorna .T. Si todas los archivo quedaron en uso.

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseDbfs(aUseDbf)

*>>>>DECLARACION DE VARIABLES
/*     aUseDbf                              // Todos los Dbf a Abrir */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL NEWAREA  := 1
       LOCAL FILEDBF  := 2
       LOCAL ALIAS    := 3
       LOCAL FILENTX  := 4
       LOCAL SHARED   := 5
       LOCAL MODCRY   := 6
       LOCAL MENSAJ   := 7
       LOCAL READONLY := 8

       LOCAL       i := 1                   // Contador
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       FOR i := 1 TO LEN(aUseDbf)

***********VALIDACION QUE NO ESTA EN USO
	     IF !ALIAS(SELECT(aUseDbf[i,ALIAS])) == aUseDbf[i,ALIAS]

		IF !lUseDbf(aUseDbf[i,NEWAREA],;   // Nueva Area de Trabajo
			    aUseDbf[i,FILEDBF],;   // Archivo DBF
			    aUseDbf[i,ALIAS]  ,;   // Nombre del Alias
			    aUseDbf[i,FILENTX],;   // Archivo Indice
			    aUseDbf[i,SHARED],;    // Modo de Apertura
			    aUseDbf[i,MODCRY])     // Modo de Proteci¢n
		   lHayErr := .T.
		   EXIT
		ENDIF

	     ENDIF
***********FIN VALIDACION QUE NO ESTA EN USO
       ENDFOR
       RETURN !lHayErr
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: SELECCION DE AREAS DE TRABAJO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 16/2000 VIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   JUN 16/2000 VIE

OBJETIVOS:

1- Pone en uso todos los archivos pasados como parametros

2- Retorna .T. Si todas los archivo quedaron en uso.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Proteger(FileDbf,nModCry,lProtec)

*>>>>DESCRIPCION DE PARAMETROS
/*     FileDbf                              // Archivo Dbf
       nModCry                              // Modo de Protecci¢n
       @lProtec                             // @ .T. Protegido */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(nModCry) # 'N'
	  cError('PARAMETRO NO NUMERICO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>PROTECCION DE LA BASE DE DATOS
       lProtec := .F.
       nModCry := IF(nModCry == NIL,0,nModCry)
       IF nModCry # 0
	  lProtec := lProtecDbf(FileDbf,'#DBFNTX&')
       ENDIF
       RETURN NIL
*>>>>FIN PROTECCION DE LA BASE DE DATOS

/*************************************************************************
* TITULO DE LA FUNCION..: ENCRYPTACION DE UNA BASE DE DATOS              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 16/94 VIE A
						       DIC 16/94 VIE
OBJETIVOS:

1)- Encrypta una base de datos

2)- La primera vez que se ejecute la funci¢n encrypta la base de
    datos, a la segunda ejecuci¢n con el mismo Password decencrypta y
    asi sucesivamente.

2)- Retorna .T. si no hubo problemas de lo contrario .F.

SINTAXIS:

   lProtecDbf("ALUMNOS.DBF", "NELSON")

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lProtecDbf(FileDbf,cPasWor)

*>>>>PARAMETROS DE LA FUNCION
/*     FileDbf			            // Nombre del Archivo
       cPasWor                              // PassWord de Encryptaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLACION DE VARIABLES
       LOCAL lProtec := .T.                 // .T. Protegido
       LOCAL nHandle := 0                   // N£mero del Manejador del Archivo
       LOCAL   cByte := " "                 // Byte en Caracter
       LOCAL   nByte := 0                   // Byte en N£merico
       LOCAL nLenBuf := 0                   // Longitud del Buffer de Lectura
       LOCAL cCabeza := ''                  // Cabecera del Archivo
*>>>>FIN DECLACION DE VARIABLES

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(FileDbf,2)) = -1 .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>PROTECION DEL PRIMER BYTE
       IF .NOT. lProBytDbf(nHandle,FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN PROTECION DEL PRIMER BYTE

*>>>>UBICACION DEL APUNTADOR PARA LA LECTURA
       IF FSEEK(nHandle,4,0) != 4 .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN UBICACION DEL APUNTADOR PARA LA LECTURA

*>>>>LECTURA DE CABECERA DEL ARCHIVO A PROTEGER
       nLenBuf := 8
       cCabeza := SPACE(nLenBuf)
       IF FREAD(nHandle,@cCabeza,nLenBuf) != nLenBuf .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
       CRYPT(@cCabeza,cPasWor)
*>>>>FIN LECTURA DE CABECERA DEL ARCHIVO A PROTEGER

*>>>>UBICACION DEL APUNTADOR PARA LA ESCRITURA
       IF FSEEK(nHandle,4,0) != 4 .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN UBICACION DEL APUNTADOR PARA LA ESCRITURA

*>>>>PROTECCION DE LA CABECERA DEL ARCHIVO
       IF  FWRITE(nHandle,cCabeza) # LEN(cCabeza) .AND. lFHayErr(FileDbf)
	   lProtec := .F.
       ELSE
	   lProtec := .T.
       ENDIF
*>>>>FIN PROTECCION DE LA CABECERA DEL ARCHIVO

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(FileDbf)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileDbf)
       ENDIF
       RETURN lProtec
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: PROTECION DEL PRIMER BYTE DEL ARCHIVO                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 12/2000 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 PM   JUN 12/2000 LUN

OBJETIVOS:

1- Permite proteger un archivo DBF al cambiar el primer Byte del Archivo

2- Retorna .T. Protegido

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lProBytDbf(nHandle,FileDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       FileDbf                              // Archivo Dbf */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLRACION DE VARIABLES
       LOCAL lProtec := .T.                 // .T. Protegido
       LOCAL   cByte := " "                 // Byte en Caracter
       LOCAL   nByte := 0                   // Byte en N£merico
*>>>>FIN DECLRACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(FileDbf) != "C"
	  cError('MAL PASADO EL NOMBRE DEL ARCHIVO')
	  RETURN !lProtec
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>UBICACION DEL APUNTADOR INICIO DEL ARCHIVO
       IF FSEEK(nHandle,0,0) != 0 .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN UBICACION DEL APUNTADOR INICIO DEL ARCHIVO

*>>>>LECTURA DEL PRIMER BYTE
       IF FREAD(nHandle,@cByte,1) != 1 .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN LECTURA DEL PRIMER BYTE

*>>>>UBICACION DEL APUNTADOR INICIO DEL ARCHIVO
       IF FSEEK(nHandle,0,0) != 0 .AND. lFHayErr(FileDbf)
	  RETURN !lProtec
       ENDIF
*>>>>FIN UBICACION DEL APUNTADOR INICIO DEL ARCHIVO

*>>>>ANALISIS DEL PRIMER BYTE
       nByte := ASC(cByte)
       DO CASE
       CASE nByte == 3  // NO hay Protecci¢n SIN Campo Memo

************PROTECCION DEL ARCHIVO
	      IF FWRITE(nHandle,CHR(4)) # 1 .AND. lFHayErr(FileDbf)
		 lProtec := .F.
	      ENDIF

/*
IF 'CL' $ FileDbf
   cError(FileDbf,'Archivo SI Protegido')
ENDIF
*/

************FIN PROTECCION DEL ARCHIVO

       CASE nByte == 4  // SI hay Protecci¢n SIN Campo Memo

************DESPROTECCION DEL ARCHIVO
	      IF FWRITE(nHandle,CHR(3)) # 1 .AND. lFHayErr(FileDbf)
		 lProtec := .F.
	      ENDIF
/*
IF 'CL' $ FileDbf
  cError(FileDbf,'Archivo NO Protegido')
ENDIF
*/


************FIN ANALISIS DE LA DESPROTECCION DEL ARCHIVO

       CASE nByte == 131  // NO Hay Protecci¢n CON Campo Memo

************ANALISIS DE LA PROTECCION DEL ARCHIVO
	      IF FWRITE(nHandle,CHR(132) ) # 1 .AND. lFHayErr(FileDbf)
		 lProtec := .F.
	      ENDIF
*cError(FileDbf,'Archivo SI Protegido')
************FIN ANALISIS DE LA PROTECCION DEL ARCHIVO

       CASE nByte == 132  // SI hay Protecci¢n CON Campo Memo

************DESPROTECCION DEL ARCHIVO
	      IF FWRITE(nHandle,CHR(131)) # 1 .AND. lFHayErr(FileDbf)
		 lProtec := .F.
	      ENDIF
*cError(FileDbf,'Archivo NO Protegido')
************FIN DESPROTECCION DEL ARCHIVO

       OTHERWISE
	    lProtec := .F.
	    cError('ERROR EN EL PRIMER BYTE DEL ARCHIVO '+FileDbf)
       ENDCASE
       RETURN lProtec
*>>>>FIN ANALISIS DEL PRIMER BYTE

/*************************************************************************
* TITULO..: ANALISIS DE LA PROTECION DEL ARCHIVO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 12/2000 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 PM   JUN 12/2000 LUN

OBJETIVOS:

1- Permite validar si el archivo esta protegido.

2- Retorna 0=>No Protegido  1=>Protegido 2=>Se presentaron problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nHayProtec(FileDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     FileDbf                              // Archivo Dbf */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLRACION DE VARIABLES
       LOCAL nCodErr := 0                   // 0=>No Protegido 1=>Protegido 2=>Error
       LOCAL nHandle := 0                   // N£mero del Manejador del Archivo
       LOCAL   cByte := " "                 // Byte en Caracter
       LOCAL   nByte := 0                   // Byte en N£merico
*>>>>FIN DECLRACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       IF VALTYPE(FileDbf) != "C"
	  cError('MAL PASADO EL NOMBRE DEL ARCHIVO')
	  RETURN 2
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>APERTURA DEL ARCHIVO EN MODO SOLO LECTURA
       IF (nHandle := FOPEN(FileDbf,0)) = -1 .AND. lFHayErr(FileDbf)
	  RETURN 2
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO SOLO LECTURA

*>>>>UBICACION DEL APUNTADOR INICIO DEL ARCHIVO
       IF FSEEK(nHandle,0,0) != 0 .AND. lFHayErr(FileDbf)
	  RETURN 2
       ENDIF
*>>>>FIN UBICACION DEL APUNTADOR INICIO DEL ARCHIVO

*>>>>LECTURA DEL PRIMER BYTE
       IF FREAD(nHandle,@cByte,1) != 1 .AND. lFHayErr(FileDbf)
	  RETURN 2
       ENDIF
*>>>>FIN LECTURA DEL PRIMER BYTE

*>>>>ANALISIS DEL PRIMER BYTE
       nByte := ASC(cByte)
       DO CASE
       CASE nByte == 3 .OR. nByte == 131
	    nCodErr := 0                  // NO hay Protecci¢n
       CASE nByte == 4 .OR. nByte == 132
	    nCodErr := 1                  // SI hay Protecci¢n
       OTHERWISE
	    nCodErr := 2                  // Error en el primer Byte
       ENDCASE
*>>>>FIN ANALISIS DEL PRIMER BYTE

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(FileDbf)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileDbf)
       ENDIF
       RETURN nCodErr
*>>>>FIN CERRANDO ARCHIVOS

/*************************************************************************
* TITULO..: VISUALIZAR LA ESTRUCTURA DEL ARCHIVO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 12/2000 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 PM   JUN 12/2000 LUN

OBJETIVOS:

1- Permite proteger un archivo DBF al cambiar el primer Byte del Archivo

2- Retorna .T. Sin Problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerStrDbf(FileDbf,cTitulo,nLenBuf)

*>>>>DESCRIPCION DE PARAMETROS
/*     FileDbf                              // Archivo Dbf
       cTitulo                              // T¡tulo
       nLenBuf                              // Longitud del Buffer de Lectura */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLRACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nNroFil := 1
       LOCAL aNroCol := {}                  // N£mero de la Columna
       LOCAL nTotCol := 0                   // Total de Columnas
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL nHandle := 0                   // N£mero del Manejador del Archivo
       LOCAL cBuffer := ""                  // Byte en Caracter
       LOCAL aBytes  := {}                  // Bytes leidos
       LOCAL   cByte := ''                  // Byte en Caracter
       LOCAL   nByte := 0                   // Byte en N£merico
       LOCAL nCodErr := 0                   // C¢digo del Error
       LOCAL lProtec := .F.                 // Archivo Protegido
*>>>>FIN DECLRACION DE VARIABLES

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(FileDbf,2)) = -1 .AND. lFHayErr(FileDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>LECTURA DEL PRIMER BYTE
       nLenBuf := IF(EMPTY(nLenBuf),90,nLenBuf)
       cBuffer := SPACE(nLenBuf)
       IF FREAD(nHandle,@cBuffer,nLenBuf) != nLenBuf .AND. lFHayErr(FileDbf)
	  cError('ERROR EN LA LECTURA DEL BUFFER')
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL PRIMER BYTE

*>>>>CONVERSION DEL ASCII
       FOR i := 1 TO LEN(cBuffer)
	   cByte := SUBS(cBuffer,i,1)
	   nByte := ASC(cByte)
	   AADD(aBytes,{nByte,cByte})
       ENDFOR
*>>>>FIN CONVERSION DEL ASCII

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(FileDbf)
	  cError('ERROR CERRANDO EL ARCHIVO '+FileDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CERRANDO ARCHIVOS

/*
*>>>>ANALISIS SI EL ARCHIVO ESTA PROTEGIDO
       nCodErr := nHayProtec(FileDbf)
       IF nCodErr == 2
	  cError('ERROR I/O DEL ARCHIVO '+FileDbf)
	  RETURN NIL
       ENDIF
       IF nCodErr == 0
	  lProtec := .F.
       ELSE
	  lProtec := .T.
       ENDIF
*>>>>FIN ANALISIS SI EL ARCHIVO ESTA PROTEGIDO
*/

*>>>>CONSULTA DE LA ESTRUCTURA DEL ARCHIVO
       cTitulo := IF(EMPTY(cTitulo),;
			   'ARCHIVO '+IF(lProtec,'PROTEGIDO','NO PROTEGIDO'),;
			   cTitulo)
       nFilIni := nMarco(3,cTitulo)
       aNroCol := {1,12,23,34,45,56,67}
       nNroFil := nFilIni
       nTotCol := 1

       FOR i := 1 TO LEN(aBytes)
	   @ nNroFil,aNroCol[nTotCol] SAY STR(i,4)+'=>'+;
					  STR(aBytes[i,1],3)+':'+;
					  aBytes[i,2]
	   nNroFil++
	   IF nNroFil > 20
	      nNroFil := nFilIni
	      nTotCol++
	      IF nTotCol > 7
		 cPausa()
		 nFilIni := nMarco(1,'ARCHIVO '+;
				     IF(lProtec,'PROTEGIDO','NO PROTEGIDO'))
		 nNroFil := nFilIni
		 nTotCol := 1
	      ENDIF
	   ENDIF
       ENDFOR
       cPausa()
       RETURN NIL
*>>>>FIN CONSULTA DE LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: CIERRE DE UNA BASE DE DATOS                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 20/96 LUN A
       Bucaramanga,Colombia         INICIO: 03:10 PM   FEB 20/96 LUN

OBJETIVOS:

1- Cierra una base de datos que esta en uso

2- Verifica si la base de datos est  en uso

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CloseDbf(cNalias,FileDbf,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNalias                              // Alias del Archivo
       FileDbf                              // Nombre del Archivo a DesProteger
       nModCry			            // 0=>No Protecci¢n 1=>Con Proteci¢n Inicial 2=>Sin Proteci¢n Inicial */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lClose := .F.                  // .T. Cerro la Base de Datos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CIERRE DE LA BASE DE DATOS
       IF UPPER(ALIAS(SELECT(cNalias))) == UPPER(cNalias)
	  SELECT &cNalias
	  CLOSE
	  lClose := .T.
       ENDIF
*>>>>FIN CIERRE DE LA BASE DE DATOS

*>>>>PROTECION DE LA BASE DE DATOS
       IF lClose
	  nModCry := IF(EMPTY(nModCry),0,nModCry)
	  IF !EMPTY(FileDbf) .AND. nModCry # 0
	     IF nHayProtec(FileDbf) == 0  // No Esta Protegida la Dbf
		IF !lProtecDbf(FileDbf,'#DBFNTX&')
		   cError('Error:3 CIERRE DEL ARCHIVO '+FileDbf)
		ENDIF
	     ENDIF
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN PROTECION DE LA BASE DE DATOS

/*************************************************************************
* TITULO..: CIERRE DE LAS BASES DE DATOS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 16/2000 VIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   JUN 16/2000 VIE

OBJETIVOS:

1- Cierra todos los archivos pasados como parametros

2- Retorna .T. Si todas los archivo quedaron en uso.

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CloseAll(aUseDbf,lCloAll)

*>>>>DECLARACION DE VARIABLES
/*     aUseDbf                              // Todos los Archivos Dbf
       lCloAll                              // .T. Cerrar Todos los Dbf */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL NEWAREA  := 1
       LOCAL FILEDBF  := 2
       LOCAL ALIAS    := 3
       LOCAL FILENTX  := 4
       LOCAL SHARED   := 5
       LOCAL MODCRY   := 6
       LOCAL MENSAJ   := 7
       LOCAL READONLY := 8

       LOCAL       i := 1                   // Contador
*>>>>DECLARACION DE VARIABLES

*>>>>CIERRE DE LAS BASES DE DATOS
       IF !EMPTY(aUseDbf)
	  FOR i := 1 TO LEN(aUseDbf)
	      CloseDbf(aUseDbf[i,ALIAS],aUseDbf[i,FILEDBF],aUseDbf[i,MODCRY])
	  ENDFOR
       ENDIF
       lCloAll := IF(lCloAll==NIL,.T.,lCloAll)
       IF lCloAll
	  CLOSE ALL
       ENDIF
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: CIERRE DE LAS BASES DE DATOS DEL MAESTRO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2001 MAR A
       Colombia, Bucaramanga        INICIO: 03:40 PM   OCT 16/2001 MAR

OBJETIVOS:

1- Cierra los Maestros de Alumnos de acuerdo a los maestros habilitados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CloseMae(cMaeAlu)

*>>>>DECLARACION DE VARIABLES
/*     cMaeAlu                              // Maestros Habilitados */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 1                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
*>>>>DECLARACION DE VARIABLES

*>>>>CIERRE DE LAS BASES DE DATOS
       FOR i := 1 TO LEN(cMaeAlu)/3
	  cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	  IF ALIAS(SELECT(cMaeAct)) == cMaeAct
	     SELECT &cMaeAct
	     CLOSE
	  ENDIF
       NEXT
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DE LA FUNCION..: ENCONTRAR EL CODIGO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 22/95 DOM A
       Bucaramanga,Colombia         INICIO: 04:10 PM   ENE 22/95 DOM

OBJETIVOS:

1- Debe estar en uso el archivo e indixado

2- Verifica la existencia del c¢digo

3- Deja el archivo en el registro del c¢digo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSekCodigo(cCodigo,cNalias,cMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a buscar
       cNalias                              // Alias de la Base de Datos
       cMensaj                              // Mensaje de la Validaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       SELECT &cNalias
       GO TOP
       IF !(DBSEEK(cCodigo))
	  IF cMensaj <> NIL
	     cError('EL CODIGO:'+cCodigo+' '+cMensaj+' NO EXISTE')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 22/95 DOM A
       Bucaramanga,Colombia         INICIO: 04:15 PM   ENE 22/95 DOM

1- Debe estar en uso el archivo

2- Verifica la existencia del c¢digo.

3- Deja el archivo en el registro del c¢digo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodigo(cCodDbf,cNalias,cCodigo,cMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodDbf                              // Codigo de la Base de Datos
       cNalias                              // Alias del archivo
       cCodigo				    // C¢digo a localizar
       cMensaj                              // Mensaje de validaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       SELECT &cNalias
       GO TOP
       LOCATE FOR &(cCodDbf) == cCodigo
       IF .NOT. FOUND()
	  IF cMensaj <> NIL
	     cError('EL CODIGO:'+cCodigo+' '+cMensaj+' NO EXISTE')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA LOCALIZACION DEL CODIGO       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 22/95 DOM A
       Bucaramanga,Colombia         INICIO: 09:10 PM   ENE 22/95 DOM

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValLocCod(cCodDbf,cNalias,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodDbf                              // C¢digo de la Base de Datos
       cCodigo				    // C¢digo a buscar
       cNalias                              // Alias de la Base de Datos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(cCodigo)
	  IF lLocCodigo(cCodDbf,cNalias,cCodigo)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO


/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA BUSQUEDA DEL CODIGO	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 22/95 DOM A
       Bucaramanga,Colombia         INICIO: 09:15 PM   ENE 22/95 DOM

OBJETIVOS:

1- Debe estar en uso el archivo e indexado

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValSekCod(cCodDbf,cNalias,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodDbf                              // C¢digo de la Base de Datos
       cCodigo				    // C¢digo a buscar
       cNalias                              // Alias de la Base de Datos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL ALIMENTOS
       IF EMPTY(cCodigo)
	  IF lSekCodigo(cCodDbf,cNalias,cCodigo)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL ALIMENTOS

/*************************************************************************
* TITULO DE LA FUNCION..: PROGRESO PARA INDEXACION DE ARCHIVOS           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 19/94 VIE A
						       AGO 19/94 VIE
OBJETIVOS:

1- Evalua el progreso de la indexanci¢n de un archivo

3- Retorna .T.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ProgresoNtx()

*>>>>PROGRESO DE INDEXAZACION
       LOCAL cSavLin := SAVESCREEN(21,00,21,79)
       LOCAL cPorcen := LTRIM(STR((RECNO()/LASTREC()) * 100))
       Centrar("Indexando "+ALIAS()+' ...' + cPorcen + "%",21)
       RESTSCREEN(21,00,21,79,cSavLin)
       RETURN .T.
*>>>>FIN PROGRESO DE INDEXAZACION

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DE DE UN REGISTRO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/95 VIE A
       Bucaramanga,Colombia         INICIO: 12:00 PM   ENE 20/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro del archivo de acuerdo al nombre del Campo

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelRegDbf(nNroFil,nNroCol,cNalias,cCamDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       cNalias                              // Alias del archivo
       cCamDbf                              // Campo de la Base de Datos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0		    // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cNalias
       IF RECCOUNT() == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+LEN(&cNalias->&cCamDbf)
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL ALIMENTOS
       DBGOTOP()
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||&(cCamDbf)})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL ALIMENTOS

/*************************************************************************
* TITULO DE LA FUNCION..: BLOQUEO DE UN ARCHIVO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
				    INICIO: 04:12 PM   DIC 26/94 LUN
OBJETIVOS:

1- Bloque el archivo en uso en ambientes multiusuario para permitir
   la modificaci¢n.

2- Si es modificaci¢n intenta Asegurar el Registro

5- Retorna: Si se pudo a abrir o NO el archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFileLock()

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AGREGA O BLOQUEA EL REGISTRO
       DO WHILE .T.

**********BLOQUEO DEL ARCHIVO
	   lHayErr := .T.
	   IF FLOCK()
	      lHayErr := .F.
	      EXIT
	   ENDIF
**********FIN BLOQUEO DEL ARCHIVO

**********MENSAJE DE VALIDACION
	    IF cError('POR FAVOR INTENTE MAS TARDE',;
		      'SE ESTA REALIZANDO MANTENIMIENTO AL SISTEMA',;
		      'Presione la tecla <ESC> para Abandonar') == CHR(K_ESC)
	       EXIT
	    ENDIF
**********FIN MENSAJE DE VALIDACION

       ENDDO
       RETURN lHayErr
*>>>>FIN AGREGA O BLOQUEA EL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: AGREGAR O BLOQUEAR UN REGISTRO                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 01/94 MIE A
						       JUN 01/94 MIE
OBJETIVOS:

1- Agrega un nuevo registro o Bloquea uno que ya existe en ambientes
   multiusuario para permitir la modificaci¢n.

2- Por defecto asume NO CREAR

3- Si es creaci¢n eval£a Resultado de Crear Registro

4- Si es modificaci¢n intenta Asegurar el Registro

5- Retorna: Si se pudo a abrir o NO el archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lRegLock(lShared,lCrear)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       lCrear                               // Bloque o inclusi¢n de Reg */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       lShared := IF(lShared == NIL,.F.,lShared)
       lCrear  := IF(lCrear  == NIL,.F.,lCrear)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>AGREGA O BLOQUEA EL REGISTRO
       DO WHILE .T.

**********AGREGA UN REGISTRO EN BLANCO
	    IF lCrear
	       dBAPPEND()                   // Equivale a APPEND BLANK
	       IF !lShared
		  lHayErr := .T.
		  EXIT
	       ENDIF
	    ENDIF
**********FIN AGREGA UN REGISTRO EN BLANCO

**********BLOQUEA EL REGISTRO
	   IF lShared
	      IF (lHayErr := IF(lShared,LOCK(),!NETERR()))
		 EXIT
	      ENDIF
	   ENDIF
**********FIN BLOQUEA EL REGISTRO

**********MENSAJE DE VALIDACION
	    IF lShared
	       IF cError('POR FAVOR INTENTE MAS TARDE',;
			 'EL REGISTRO ESTA EN USO POR OTRO USUARIO',;
			 'Presione la tecla <ESC> para Abandonar') == CHR(K_ESC)
		  EXIT
	       ENDIF
	    ELSE
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN MENSAJE DE VALIDACION

       ENDDO
       RETURN lHayErr
*>>>>FIN AGREGA O BLOQUEA EL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION......: BROWSE SELECTIVO DE UNA BASES DE DATOS     *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

 1- Permite la consulta por paginas un archivo desde el principio
    hasta el final realizando un busqueda secuencial en otro archivo

 2- Permite la selecci¢n de un registro a trav‚s de una barra de
    selecci¢n.

 3- Realiza un TBrowse de una sola columna

 4- Retorna el n£mero del registro escogido o cero (0) si no escogi¢
    ning£n registro.

* SINTAXIS:

  nNro_Reg := nBrowseDbf(10,1,13,79,;
			 {||SUBS(codasi_cof,1,3)+' '+materia()})

  FUNCTION materia()
     FIELD CODIGO
     SELECT MAT
     LOCATE FOR CODIGO = SUBS(ARC->CODASI_COF,4,4)
     SELECT ARC
  RETURN SUBS(MAT->materia,1,20)

  1- Se debe pasar un CodeBlock con los campos o expresion para crear
     la columna

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
		    CodeBlock,nLenCam,lSavPan)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	             // Fila Superior
       nColSup	             // Columna Superior
       nFilInf	             // Fila Inferior
       nColInf	             // Columna Inferior
       CodeBlock             // CodeBlock para crear la columna
       nLenCam               // Longitud del campo
       lSavPan               // .T. Salvar pantalla */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan         // Salvar Pantalla
       LOCAL cSavPa1         // Salvar Pantalla
       LOCAL nTecPul         // Tecla pulsada
       LOCAL nNroReg         // Numero de Registro escogido

       LOCAL oColumn := NIL  // Columna del objeto
       LOCAL oBrwArc	     // Browse de ARCHIVOS
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       lSavPan := IF(lSavPan == NIL,.T.,lSavPan)
       IF lSavPan
	  cSavPan := SAVESCREEN(nFilSup-1,nColSup-1,nFilInf+1,nColInf+1)
       ENDIF

       @ nFilSup-1,nColSup-1 TO nFilInf+1,nColInf+1 DOUBLE
       oBrwArc := TBROWSEDB(nFilSup,nColSup,nFilInf,nColInf)

      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oColumn := TBCOLUMNNEW('',CodeBlock)
       oBrwArc:ADDCOLUMN(oColumn)
       IF !EMPTY(nLenCam)
	  oColumn:Width := nLenCam
       ENDIF
     *ÀDefinici¢n Columna No.1
*>>>>FIN DEFINICION DEL OBJETO BROWSE

*>>>>VISUALIZACION DEL OBJETO TBrowse
       cSavPa1 := SAVESCREEN(23,00,23,79)
       SET COLOR TO I
       Centrar('<PGUP><PGDN> Elige el registro º <ENTER> Escoge  º'+;
	       ' <ESC> Termina la Selecci¢n',23)
       SetClrTo()
       SET CURSOR OFF
       oBrwArc:GOTOP()
       DO WHILE .T.

**********DESPLIAGA EL PANTALLAZO DEL BROWSE
	    DO WHILE !(oBrwArc:STABILIZE())
	       IF (nTecPul := INKEY()) != 0
		  EXIT
	       ENDIF
	    ENDDO
**********FIN DESPLIAGA EL PANTALLAZO DEL BROWSE

**********LECTURA DE TECLA PULSADA
	    IF nTecPul == 0
	       nTecPul := INKEY(0)
	    ENDIF
**********FIN LECTURA DE TECLA PULSADA

**********ANALSIS DE LA TECLA PULSADA
	    DO CASE
	    CASE nTecPul == K_UP
		 oBrwArc:UP()                  // Fila arriba

	    CASE nTecPul == K_DOWN
		 oBrwArc:DOWN()                // Fila abajo


	    CASE nTecPul == K_PGUP
		 oBrwArc:PAGEUP()              // Pantallazo Arriba


	    CASE nTecPul == K_PGDN
		 oBrwArc:PAGEDOWN()            // Pantallazo Abajo

	    CASE nTecPul == K_HOME             // Inicio
		 oBrwArc:GOTOP()

	    CASE nTecPul == K_END              // Final
		 oBrwArc:GOBOTTOM()

	    CASE nTecPul == K_ENTER
		 nNroReg := RECNO()
		 EXIT

	    CASE nTecPul == K_ESC
		 nNroReg := 0
		 EXIT                    // Termina proceso

	    OTHERWISE
		 ??CHR(07)
	   ENDCASE
**********FIN ANALSIS DE LA TECLA PULSADA

	  nTecPul := 0   // Borra valor de tecla capturado para tomar otro

       ENDDO
       SET CURSOR ON
       IF lSavPan
	  RESTSCREEN(nFilSup-1,nColSup-1,nFilInf+1,nColInf+1,cSavPan)
       ENDIF
       RESTSCREEN(23,00,23,79,cSavPa1)
       RETURN nNroReg
*>>>>VISUALIZACION DEL OBJETO TBrowse

/*************************************************************************
* TITULO DE LA FUNCION..: CALCULO DE LOS ESPACIOS DE UN CAMPO            *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 14/94 JUE A
						       JUL 14/94 JUE
1- Debe estar en uso el archivo el archivo seg£n el nombre del Alias

2- Retorna los espacios del campo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSpaField(cNalias,cNomCam)

*>>>>PARAMETROS DE LA FUNCION
/*     cNalias                              // Nombre del Alias
       cNomCam                              // Nombre del Campo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CAMPOS
       LOCAL aStruct := {}                  // Estructura del Archivo
       LOCAL nNroCam := 0                   // N£mero del Campo
*>>>>FIN DECLARACION DE CAMPOS

*>>>>CALCULO DE LOS ESPACIOS DEL CAMPO
       SELECT &cNalias
       aStruct := DBSTRUCT()
       nNroCam := FIELDPOS(cNomCam)
       RETURN SPACE(aStruct[nNroCam][3])
*>>>>FIN CALCULO DE LOS ESPACIOS DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: CALCULO DE LOS ESPACIOS DE UN CAMPO            *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 14/94 JUE A
						       JUL 14/94 JUE
1- Debe estar en uso el archivo el archivo seg£n el nombre del Alias

2- Retorna los espacios del campo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSpaces(cNalias,cNomCam)

*>>>>PARAMETROS DE LA FUNCION
/*     cNalias                              // Nombre del Alias
       cNomCam                              // Nombre del Campo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CAMPOS
       LOCAL aStruct := {}                  // Estructura del Archivo
       LOCAL nNroCam := 0                   // N£mero del Campo
*>>>>FIN DECLARACION DE CAMPOS

*>>>>CALCULO DE LOS ESPACIOS DEL CAMPO
       SELECT &cNalias
       aStruct := DBSTRUCT()
       nNroCam := FIELDPOS(cNomCam)
       RETURN SPACE(aStruct[nNroCam][3])
*>>>>FIN CALCULO DE LOS ESPACIOS DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: CALCULO DE LA LONGITUD DEL CAMPO               *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 14/94 JUE A
						       JUL 14/94 JUE
1- Debe estar en uso el archivo el archivo seg£n el nombre del Alias

2- Retorna los espacios del campo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLenField(cNalias,cNomCam)

*>>>>PARAMETROS DE LA FUNCION
/*     cNalias                              // Nombre del Alias
       cNomCam                              // Nombre del Campo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CAMPOS
       LOCAL aStruct := {}                  // Estructura del Archivo
       LOCAL nNroCam := 0                   // N£mero del Campo
*>>>>FIN DECLARACION DE CAMPOS

*>>>>CALCULO DE LOS ESPACIOS DEL CAMPO
       SELECT &cNalias
       aStruct := DBSTRUCT()
       nNroCam := FIELDPOS(cNomCam)
       RETURN aStruct[nNroCam][3]
*>>>>FIN CALCULO DE LOS ESPACIOS DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DEL NOMBRE DE UN ARCHIVO TEMPORAL     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/96 MAR A
       Colombia, Bucaramanga        INICIO: 05:30 PM   OCT 01/96 MAR

OBJETIVOS:

1)- Crea arma o crea un nombre de archivo temporal en forma secuencial
    Ej:
       TEMP0001.TMP

2)- Retorna el nombre del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFileTempo(PathFil,cPreFij,cExtTem,lSiPath)

*>>>>PARAMETROS DE LA FUNCIONS
/*     PathFil                              // Path del Archivo
       cPreFij                              // Prefijo del nombre
       cExtTem                              // Extenci¢n del archivo
       lSiPath                              // .T. Archivo con Path  */
*>>>>FIN PARAMETROS DE LA FUNCIONS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL FileTem := ''                  // Archivo Temporal
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       cPreFij := IF(cPreFij == NIL,"TEMP",cPreFij)
       cExtTem := IF(cExtTem == NIL,".TMP",cExtTem)
       lSiPath := IF(lSiPath == NIL,.T.,lSiPath)

       IF VALTYPE(cPreFij) != "C"
	  cError('EL PREFIJO DEL ARCHIVO TEMPORAL NO ES CARACTER')
	  RETURN ''
       ENDIF

       IF LEN(cPreFij) > 4
	  cPreFij := SUBS(cPreFij,1,3)
       ENDIF
*>>>>FIN CONTROL DE PARAMETROS

*>>>>VALIDACION DE EXISTENCIA DEL TEMPORAL
       FOR i := 1 TO 9999
	   FileTem := PathFil+cPreFij+PADL(i,4,"0")+cExtTem
	   IF !FILE(FileTem) .OR. FILESIZE(FileTem) == 0
	      IF .NOT. lSiPath
		 FileTem := cPreFij+PADL(i,4,"0")+cExtTem
	      ENDIF
	      EXIT
	   ENDIF
       NEXT
       SET FIXED ON
       RETURN FileTem
*>>>>FIN VALIDACION DE EXISTENCIA DEL TEMPORAL

/*************************************************************************
* TITULO..: CREACION DEL NOMBRE DE UN ARCHIVO TEMPORAL CON EXTENSION     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 01/2003 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 PM   ABR 01/2003 MAR

OBJETIVOS:

1)- Crea arma o crea un nombre de archivo temporal en forma secuencial
    en la extension
    Ej:
       MAEBTO01.DAT =>MAEBTO01.001

2)- Retorna el nombre del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FileExtTmp(PathArc,fArchvo,lSiPath)


*>>>>PARAMETROS DE LA FUNCIONS
/*     PathArc			            // Path del Archivo
       fArchvo                              // Nombre del Archivo
       lSiPath                              // .T. Archivo con Path  */
*>>>>FIN PARAMETROS DE LA FUNCIONS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL FileTem := ''                  // Archivo Temporal
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ELIMINACION DE LA EXTENSION DEL ARCHIVO
       nNroPos := AT('.',fArchvo)
       IF nNroPos # 0
	  fArchvo := SUBS(fArchvo,1,nNroPos-1)
       ENDIF
*>>>>FIN ELIMINACION DE LA EXTENSION DEL ARCHIVO

*>>>>VALIDACION DE EXISTENCIA DEL TEMPORAL
       FOR i := 1 TO 999
	   FileTem := PathArc+fArchvo+'.'+PADL(i,3,'0')
	   IF !FILE(FileTem) .OR. FILESIZE(FileTem) == 0
	      IF .NOT. lSiPath
		 FileTem := fArchvo+'.'+PADL(i,3,'0')
	      ENDIF
	      EXIT
	   ENDIF
       NEXT
       SET FIXED ON
       RETURN FileTem
*>>>>FIN VALIDACION DE EXISTENCIA DEL TEMPORAL

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LA ESTRUCTURA DEL ARCHIVO     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/98 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   OCT 15/98 JUE

OBJETIVOS:

1)- Actualiza la Estructura de un archivo

2)- Retorna .T. si no se presentaron problemas.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION lStrucFile(lShared,FileSys,FileTem,bCodBlo,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       FileSys                              // Archivo del Sistema
       FileTem                              // Archivo Temporal
       bCodBlo                              // Code Block con la Estructura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nRegSys := 0                   // Total Registros
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA EN EL ARCHIVO TEMPORAL
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'ESTE PROCESO PUEDE DURAR VARIOS MINUTOS. GRACIAS')
       Termometro(10)

       EVAL(bCodBlo)
       IF !FILE(FileTem)
	  cError('NO SE PUDO CREAR LA ESTRUCTURA EN EL ARCHIVO TEMPORAL')
	  RETURN .F.
       ENDIF
       Termometro(40)
*>>>>FIN CREACION DE LA ESTRUCTURA EN EL ARCHIVO TEMPORAL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       nModCry := IF(nModCry == NIL,0,nModCry)
       IF !lUseDbf(.T.,FileTem,'TEM',NIL,.F.,nModCry) .OR.;
	  !lUseDbf(.T.,FileSys,'SYS',NIL,.F.,nModCry)
	  cError('ABRIENDO ARCHIVOS EN LA ACTUALIZACION DE ESTRUCTURAS')
	  CloseDbf('TEM',FileTem,nModCry)
	  CloseDbf('SYS',FileSys,nModCry)
	  RETURN .F.
       ENDIF
       nRegSys := SYS->(RECCOUNT())
       CloseDbf('SYS')
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>COPIA DE REGISTROS
       SELECT TEM
       IF TEM->(RECCOUNT()) # 0
	  ZAP
       ENDIF
     *ÀBorra los registros creados por defecto

       Termometro(50)
       SET DELETED OFF      // Procesa registros borrados
       APPEND FROM &FileSys
*>>>>FIN COPIA DE REGISTROS

*>>>>VALIDACION DE LA COPIA
       IF nRegSys # TEM->(RECCOUNT())
	  cError('NO SE ACTUALIZO EL ARCHIVO LOS REGISTROS NO CONCUERDAN',;
		 STR(nRegSys,4),STR(TEM->(RECCOUNT()),4))
	  SET DELETED ON  // Ignora registros borrados
	  RETURN .F.
       ENDIF
       SET DELETE ON
*>>>>FIN VALIDACION DE LA COPIA

*>>>>BORRADO DEL ARCHIVO DEL SISTEMA
       CloseDbf('SYS',FileSys,nModCry)
       IF !lFileDelete(FileSys)
	  cError('RESTAURE LA COPIA DE SEGURIDAD',;
		 'NO SE BORRO EL ARCHIVO '+FileSys)
	  RETURN .F.
       ENDIF
*>>>>FIN BORRADO DEL ARCHIVE DEL SISTEMA

*>>>>RENOMBRE DEL ARCHIVO TEMPORAL AL ARCHIVO PRINCIPAL
       CloseDbf('TEM',FileTem,nModCry)
       IF RENAMEFILE(FileTem,FileSys) # 0
	  cError('RESTAURE LA COPIA DE SEGURIDAD DE '+FileSys,;
		 'NO SE RENOMBRO EL ARCHIVO TEMPORAL')

	  RETURN .F.
       ENDIF

       CloseDbf('SYS',FileSys,nModCry)
       CloseDbf('TEM',FileSys,nModCry)
       Termometro(100)
       SAVESCREEN(0,0,24,79,cSavPan)
       RETURN .T.
*>>>>FIN RENOMBRE DEL ARCHIVO TEMPORAL AL ARCHIVO PRINCIPAL

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENA LOS REGISTROS DEL ARCHIVO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/99 JUE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   MAY 06/99 JUE

OBJETIVOS:

1)- Ordena los registros de una base de datos de acuerdo a un campo.

2)- Retorna .T. si no se presentaron problemas.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lOrdFile(lShared,cNomArc,cClaUno,cClaDos,cClaTre,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomArc                              // Nombre de Archivo a Ordenar
       cClaUno			            // Clave de Ordenaci¢n No. 1
       cClaDos			            // Clave de Ordenaci¢n No. 2
       cClaTre			            // Clave de Ordenaci¢n No. 3
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>COPIA DEL MAESTRO PARA EL ORDENAMIENTO
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'ORDENANDO EL ARCHIVO')
       Termometro(10)

       IF FILECOPY(cNomArc,'TEMPORAL.TEM') == 0
	  cError('NO SE PUDO HACER LA COPIA EN EL TEMPORAL')
	  RETURN .F.
       ENDIF
       Termometro(40)
       nModCry := IF(nModCry==NIL,0,nModCry)
*>>>>FIN COPIA DEL MAESTRO PARA EL ORDENAMIENTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,'TEMPORAL.TEM','TEM',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVO TEMPORAL')
	  CloseDbf('TEM','TEMPORAL.TEM',nModCry)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TEM->(RECCOUNT()) == 0
*	    cError('NO EXISTEN REGISTROS EN EL ARCHIVO TEMPORAL')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('TEM','TEMPORAL.TEM',nModCry)
	  IF !lFileDelete('TEMPORAL.TEM')
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ORDENAMIENTO DEL MAESTRO
       Termometro(50)
       DO CASE
       CASE !EMPTY(cClaUno) .AND. EMPTY(cClaDos)
	    SORT TO &cNomArc ON &cClaUno

       CASE !EMPTY(cClaUno) .AND. !EMPTY(cClaDos)
	    SORT TO &cNomArc ON &cClaUno,&cClaDos

       CASE !EMPTY(cClaUno) .AND. !EMPTY(cClaDos) .AND. !EMPTY(cClaTre)
	    SORT TO &cNomArc ON &cClaUno,&cClaDos,&cClaTre
       ENDCASE
       CloseDbf('TEM','TEMPORAL.TEM',nModCry)
*>>>>FIN ORDENAMIENTO DEL MAESTRO

*>>>>PROTECCION DEL ARCHIVO ORDENADO
       nModCry := IF(EMPTY(nModCry),0,nModCry)
       IF nModCry # 0
	  Proteger(cNomArc,nModCry)
       ENDIF
*>>>>FIN PROTECCION DEL ARCHIVO ORDENADO

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       IF !lFileDelete('TEMPORAL.TEM')
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       Termometro(100)
       SAVESCREEN(0,0,24,79,cSavPan)
       RETURN .T.
*>>>>FIN BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO..: LOCALIZACION DE UN CODIGO ESPECIFICO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 03/2002 MIE A
       Colombia, Bucaramanga        INICIO: 09:00 PM   JUL 03/2002 MIE

OBJETIVOS:

1- Debe estar en uso el archivo donde se realiza la localizaci¢n

2- Localiza el texto especificado en la tabla

3- Retorna NIL

SINTAXIS:

aCamLoc := {}
AADD(aCamLoc,{'1<POR APELLIDO>','cApelliPro','ENTRE EL APELLIDO:'})
AADD(aCamLoc,{'2<POR NOMBRE  >','cNombrePro','ENTRE EL NOMBRE:'})
AADD(aCamLoc,{'3<POR CODIGO  >','cCodigoPro','ENTRE EL CODIGO:'})

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LocCampos(oBrowse,cNalias,aCamLoc)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse				    // Browse del Archivo
       cNalias				    // Alias del Archivo
       aCamLoc                              // Campo a Localizar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL cNomCam := ''                  // Nombre del Campo

       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C¢digo del estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL METODO DE LOCALIZACION
       aMenus := {}
       FOR i := 1 TO LEN(aCamLoc)
	   AADD(aMenus,aCamLoc[i,1])
       ENDFOR

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,NIL,09,30,'BUSQUEDA',NIL,1,.F.)
       IF nNroOpc == 0
	  oBrowse:REFRESHALL()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECCION DEL METODO DE LOCALIZACION

*>>>>LECTURA DEL TEXTO A LOCALIZAR
       SET CURSOR ON
       cNomCam := aCamLoc[nNroOpc,2]
       cCodigo := cSpaces(cNalias,cNomCam)
       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol,aCamLoc[nNroOpc,3])
       @ nNroFil,nNroCol GET cCodigo PICT '@!'
       READ
*>>>>FIN LECTURA DEL TEXTO A LOCALIZAR

*>>>>LOCALIZACION DEL TEXTO
       IF lLocCodigo(aCamLoc[nNroOpc,2],cNalias,cCodigo)
	   nNroReg := RECNO()
	   GO TOP
	   oBrowse:GOTOP()
	   GO nNroReg
	   oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN LOCALIZACION DEL TEXTO

/*************************************************************************
* TITULO..: LECTURA DE UN CAMPO DE LA LICENCIA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 02/2002 LUN A
       Colombia, Bucaramanga        INICIO: 05:30 PM   SEP 02/2002 LUN

OBJETIVOS:

1- Lee un campo del texto de la licencia

2- Retorna el campo de la licencia

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xCampoLic(nPosIni,cTxtLic)

*>>>>DESCRIPCION DE PARAMETROS
/*     nPosIni                              // @Posici¢n Inicial del Campo de la Licencia
       cTxtLic                              // Texto de la Licencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL xTipCam := ''                  // Tipo del Campo
       LOCAL nLenCam := ''                  // Longitud del Campo
       LOCAL xCamLic := ''                  // Campo de Licencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL CAMPO DE LA LICENCIA
       xTipCam := SUBS(cTxtLic,nPosIni,1)
       nLenCam := ASC(SUBS(cTxtLic,nPosIni+1,1))
       xCamLic := SUBS(cTxtLic,nPosIni+2,nLenCam)
       nPosIni += 2+nLenCam

       DO CASE
       CASE xTipCam == 'C'
	    * Toma el valor asignado

       CASE xTipCam == 'N'
	    xCamLic := VAL(xCamLic)

       CASE xTipCam == 'L'
	    xCamLic := IF(xCamLic=='1',.T.,.F.)

       ENDCASE
       RETURN xCamLic
*>>>>FIN LECTURA DEL CAMPO DE LA LICENCIA

/*************************************************************************
* TITULO..: VALIDACION A¥O Y MES DE LA LICENCIA                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   SEP 03/2002 MAR

OBJETIVOS:

1- Valida el a¤o y el mes de la Licencia

2- Sale del Sistema si el a¤o es invalido.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LicAnoMes(cAnoHab,cAnoUsr,cMesHab)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoHab			      // A¤o Habilitado de la Licencia
       cAnoUsr                        // A¤o del Usuario
       cMesHab                        // Mes Habilitado de la Licencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nMesAct := 0                   // Mes Actual
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL A¥O DE LA LICENCIA
       IF !EMPTY(cAnoHab)

**********VERIFICACION DEL A¥O
	    lHayErr := .T.
	    DO CASE
	    CASE VAL(cAnoUsr) > VAL(cAnoHab) .AND.;
		 YEAR(DATE()) > VAL(cAnoHab)
/*
		 cError('EL A¥O ACTUAL:'+STR(YEAR(DATE()),4,0)+' '+;
			'NO ESTA HABILITADO')
*/

	    CASE VAL(cAnoUsr) > VAL(cAnoHab)
/*
		 cError('EL A¥O: '+cAnoUsr+' NO ESTA HABILITADO')
*/

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE
**********FIN VERIFICACION DEL A¥O

**********ANALISIS DE DECISION
	    IF lHayErr
	       CloseAll()
	       SET COLOR TO
	       CLEAR
	       QUIT
	    ENDIF
**********FIN ANALISIS DE DECISION

       ENDIF
*>>>>FIN VALIDACION DEL A¥O DE LA LICENCIA

*>>>>VALIDACION DEL MES DE LA LICENCIA
       IF !EMPTY(cMesHab)

**********VERIFICACION DEL MES
	    nMesAct := MONTH(DATE())
	    lHayErr := .T.
	    DO CASE
	    CASE SUBS(cMesHab,nMesAct,1) # '1'
		 cError('DEBE ACTUALIZAR EL SISTEMA')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE
**********FIN VERIFICACION DEL MES

**********ANALISIS DE DECISION
	    IF lHayErr
	       CloseAll()
	       SET COLOR TO
	       CLEAR
	       QUIT
	    ENDIF
**********FIN ANALISIS DE DECISION

       ENDIF
       RETURN NIL
*>>>>FIN VALIDACION DEL MES DE LA LICENCIA

/*************************************************************************
* TITULO..: LICENCIA DEL SOFTWARE                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 15/2003 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   ENE 15/2003 MIE

OBJETIVOS:

1- Pendiente

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLicencia(FileDat,cEmpPal,cNitEmp,cNomEmp,cCodEmp,cPaises,cNomDpt,;
		   cNomMun,cNomSec,lShared,nModCry,nSysOpe,cDerSys,cPwdSis,;
		   nPrueba,cAnoHab,cMesHab,cPwdHar,lPiePag,cMaeAlu,cJornad,;
		   nPerHab,cPwdIns,cDirEmp,cCodSui)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc				    // Path del Archivo
       fArchvo                              // Archivo de Licencia
       cEmpPal                              // Nombre de la Comunidad
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cCodEmp                              // C¢digo de la Empresa
       cPaises                              // Nombre del Pais
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       cNomSec                              // Nombre Secundario
       lShared                              // .T. Sistema Compartido
       nModCry                              // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       nSysOpe                              // Sistema Operativo 0=>Windows 1=>Novell 2=>Linux
       cDerSys                              // Derechos del Sistema
       cPwdSis			            // PassWord Creaci¢n usuarios
       nPrueba                              // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
       cAnoHab                              // A¤o Habilitado
       cMesHab                              // Mes Habilitado
       cPwdHar			            // Serial del HardWare
       cMaeAlu                              // Maestros habilitados
       cJornad                              // Jornadas habilitadas
       nPerHab                              // Periodo Habilitado
       cPwdIns			            // Serial de Instalaci¢n
       cDirEmp                              // Directorio para la Empresa
       cCodSui                              // @C¢digo de la Suite */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs

       LOCAL       i := 0                   // Contador
       LOCAL nLenLic := 0                   // Tama¤o de la Licencia

       LOCAL aDetLic := {}                  // Detalles de la Licencia

       LOCAL nPosIni := 0                   // Posici¢n del Campo
       LOCAL xTipCam := ''                  // Tipo de Campo
       LOCAL nLenCam := 0                   // Longitud del Campo
       LOCAL xCamLic := ''                  // Campo de Licencia

       LOCAL cTxtLic := ''                  // Texto de la Licencia
       LOCAL cCamLic := ''                  // Campo de Licencia
       LOCAL cCodLic := ''                  // C¢digo de la Licencia

       LOCAL cSuiLic := ''                  // C¢digo Suite de la Licencia
       LOCAL cSerial := ''                  // Serial de la Licencia
       LOCAL nSerial := 0                   // Serial de la Licencia

       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION DEL ARCHIVO DE LICENCIA
       cCodSui := SUBS(FileDat,AT('.DAT',FileDat)-4,4)
       IF !File(FileDat)
	  cError("SE BORRO EL ARCHIVO "+FileDat)
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN VERIFICACION DEL ARCHIVO DE LICENCIA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,FileDat,'LIC',NIL,.T.,0})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO DE DATOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE LIC->(RECCOUNT()) == 0
	    cError('NO EXISTE REGISTROS DE DATOS')

       CASE LIC->(RECCOUNT()) > 1
	    cError('EXISTEN VARIOS REGISTROS DE DATOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN lHayErr
       ENDIF
       cTxtLic := CRYPT(ALLTRIM(LIC->xyz),'IVANAN')
       CloseAll(aUseDbf)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DE LA LICENCIA
       nLenLic := ASC(SUBS(cTxtLic,1,1))
       nPosIni := 2
       FOR i := 1 TO nLenLic

	   xCamLic := xCampoLic(@nPosIni,cTxtLic)

	   DO CASE
	   CASE i == 1
		cEmpPal := xCamLic
		AADD(aDetLic,cEmpPal)

	   CASE i == 2
		cNitEmp := xCamLic
		AADD(aDetLic,cNitEmp)

	   CASE i == 3
		cNomEmp := xCamLic
		AADD(aDetLic,cNomEmp)

	   CASE i == 4
		cCodEmp := xCamLic
		AADD(aDetLic,cCodEmp)

	   CASE i == 5
		cPaises := xCamLic
		AADD(aDetLic,cPaises)

	   CASE i == 6
		cNomDpt := xCamLic
		AADD(aDetLic,cNomDpt)

	   CASE i == 7
		cNomMun := xCamLic
		AADD(aDetLic,cNomMun)

	   CASE i == 8
		cNomSec := xCamLic
		AADD(aDetLic,cNomSec)

	   CASE i == 9
		lShared := xCamLic
		AADD(aDetLic,lShared)

	   CASE i == 10
		nModCry := xCamLic
		AADD(aDetLic,nModCry)

	   CASE i == 11
		nSysOpe := xCamLic
		AADD(aDetLic,nSysOpe)

	   CASE i == 12
		cDerSys := xCamLic
		AADD(aDetLic,cDerSys)

	   CASE i == 13
		cPwdSis := xCamLic
		AADD(aDetLic,cPwdSis)

	   CASE i == 14
		nPrueba := xCamLic
		AADD(aDetLic,nPrueba)

	   CASE i == 15
		cAnoHab := xCamLic
		AADD(aDetLic,cAnoHab)

	   CASE i == 16
		cMesHab := xCamLic
		AADD(aDetLic,cMesHab)

	   CASE i == 17
		cPwdHar := xCamLic
		AADD(aDetLic,cPwdHar)

	   CASE i == 18
		lPiePag := xCamLic
		AADD(aDetLic,lPiePag)

	   CASE i == 19
		cMaeAlu := xCamLic
		AADD(aDetLic,cMaeAlu)

	   CASE i == 20
		cJornad := xCamLic
		AADD(aDetLic,cJornad)

	   CASE i == 21
		nPerHab := xCamLic
		AADD(aDetLic,nPerHab)

	   CASE i == 22
		cSuiLic := xCamLic
		AADD(aDetLic,cSuiLic)

	   CASE i == 23
		cDirEmp := xCamLic
		AADD(aDetLic,cDirEmp)

	   CASE i == 24
		cPwdIns := xCamLic

	   OTHERWISE
		lHayErr := .T.
	   ENDCASE
       ENDFOR
*>>>>FIN ACTIVACION DE LA LICENCIA

*>>>>VALIDACION DEL SERIAL
       IF !lHayErr
	  cSerial := CHR(LEN(aDetLic)+1)
	  FOR i := 1 TO LEN(aDetLic)

	      xCamLic := aDetLic[i]
	      DO CASE
	      CASE UPPER(VALTYPE(xCamLic)) == 'C'
		   cSerial += 'C'+CHR(LEN(xCamLic))+xCamLic

	      CASE UPPER(VALTYPE(xCamLic)) == 'N'
		   cSerial += 'N'+CHR(16)+STR(xCamLic,16,2)

	      CASE UPPER(VALTYPE(xCamLic)) == 'L'
		   cSerial += 'L'+CHR(1)+IF(xCamLic,'1','0')

	      ENDCASE

	  ENDFOR

	  nSerial := CHECKSUM(cSerial)
	  IF nSerial # VAL(cPwdIns)
	     lHayErr := .T.
	     cError('ERROR No. '+STR(CHECKSUM(cSerial),10))
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL SERIAL

*>>>>VALIDACION DE LA LICENCIA
       IF !lHayErr
	  lHayErr := .T.
	  DO CASE
	  CASE cSuiLic # cCodSui
	       cError('ERROR EN EL CODIGO DEL SISTEMA')
	  OTHERWISE
	       lHayErr := .F.
	  ENDCASE
       ENDIF
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LA LICENCIA

/*************************************************************************
* TITULO..: DERECHOS DEL SISTEMA                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2003 LUN A
       Colombia, Bucaramanga        INICIO: 09:30 AM   ENE 20/2003 LUN

OBJETIVOS:

1- Habilita los Derechos del Sistema

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDerechSys(cDerSys,cDerUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cDerSys                              // Derechos del Sistema
       cDerUsr                              // Derechos del Usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CERTIFICACION DE LOS DERECHOS
       FOR i := 1 TO LEN(cDerSys)

	   IF SUBS(cDerSys,i,1) == '1'
	      LOOP
	   ENDIF
	   cDerUsr := STUFF(cDerUsr,i,1,'0')

       ENDFOR
       RETURN cDerUsr
*>>>>FIN CERTIFICACION DE LOS DERECHOS

/*************************************************************************
* TITULO..: COMPARACION DE LAS ESTRUCTURA DE DATOS                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/2003 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 06/2003 JUE

OBJETIVOS:

1- Permite comparar dos estructuras de datos para verificar si son iguales

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lgualStr(aStrNew,aStrOld,FileNew,cMsgErr,cTitMar,cPieMar)

*>>>>DESCRIPCION DE PARAMETROS
/*     aStrNew                              // Estructura Nueva
       aStrOld                              // Estructura Anterior
       FileNew                              // Archivo Nuevo
       cMsgErr                              // Mensaje del error
       cTitMar                              // Titulo del marco
       cPieMar                              // Pie del marco */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
*>>>>FIN DECLARACION DE VARIABLES

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
*>>>>FIN VALIDACION DE LA ESTRUCTURA

*>>>>ANALISIS DE DECISION
       IF lCambio

	  FileNew := IF(EMPTY(FileNew),'',FileNew)
	  IF !EMPTY(FileNew)

	     cMsgErr := IF(EMPTY(cMsgErr),;
			  'El Archivo '+FileNew+' '+;
			  'su Estructura Esta DesActualizada.',FileNew)

	     cTitMar := IF(EMPTY(cTitMar),'ATENCION',cTitMar)

	     cPieMar := IF(EMPTY(cPieMar),;
			  'Para Actualizarla NO Debe Haber '+;
			  'Ning£n Usuario en la Red.',cPieMar)

	     cError(cMsgErr,cTitMar,cPieMar)
	  ENDIF

       ENDIF
       RETURN !lCambio
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA DEL FORMATO DE IMPRESION           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/2004 LUN A
       Colombia, Bucaramanga        INICIO: 01:40 AM   SEP 08/2004 LUN

OBJETIVOS:

1- Creaci¢n de la estructura de impresi¢n seg£n formato

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaFrmPrn(lShared,fArchvo,aNroCol,nOpcPrn,aCabPrn,aTitPrn,aPrnWww)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo
       aNroCol                              // N£mero de Columnas
       nOpcPrn                              // Formato de Impresi¢n
       aCabPrn                              // Encabezado del informe General
       aTitPrn                              // T¡tulos de Impresi¢n
       aPrnWww				    // Detalles informes para www */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathArc := ''                  // Path del Archivo
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PATH DEL ARCHIVO
       nNroPos := RAT('\',fArchvo)
       IF nNroPos # 0
	  PathArc := SUBS(fArchvo,1,nNroPos-1)
	  fArchvo := SUBS(fArchvo,nNroPos+1,LEN(fArchvo))
       ELSE
	  PathArc := ''
       ENDIF
*>>>>FIN PATH DEL ARCHIVO


*>>>>CREACION DEL ARCHIVO DEL FORMATO DE IMPRESION
       DO CASE
       CASE nOpcPrn == 6 .AND. ('.XLS' $ UPPER(fArchvo))  // Formato Xls
	    nHanXml := nExcelXml(PathArc+'/'+fArchvo,aCabPrn,aTitPrn,aNroCol)

       CASE nOpcPrn == 7   // Formato Dbf

	    CreaRegPrn(lShared,PathArc,fArchvo,aNroCol)


       CASE nOpcPrn == 8   // Formato Csv
	    nHanXml := nOpenCsv(PathArc+'/'+fArchvo,;
				aCabPrn,aTitPrn,NIL,aPrnWww)


/*
       CASE nOpcPrn == 8   // Formato Xml
	    nHanXml := nOpenXml(PathArc+'/'+fArchvo,;
				aCabPrn,aTitPrn,NIL,aPrnWww)
*/

       ENDCASE
       RETURN nHanXml
*>>>>FIN CREACION DEL ARCHIVO DEL FORMATO DE IMPRESION

/*************************************************************************
* TITULO..: GRABACION DEL REGISTRO DE IMPRESION SEGU FORMATO             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/2004 LUN A
       Colombia, Bucaramanga        INICIO: 02:15 AM   MAR 08/2004 LUN

OBJETIVOS:

1- Grabaci¢n del registro de impresi¢n seg£n formato.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraFrmPrn(lShared,aTitulo,nOpcPrn)

*>>>>DESCRIPCION DE PARAMENTROS
/*     lShared                              // Archivos Compartidos
       aTitulo                              // T¡tulos para impresi¢n
       nOpcPrn                              // Opci¢n de Impresi¢n  */
*>>>>FIN DESCRIPCION DE PARAMENTROS

*>>>>CREACION DEL ARCHIVO DEL FORMATO DE IMPRESION
       DO CASE
       CASE nOpcPrn == 7   // Formato Dbf
	    GraDbfPrn(lShared,aTitulo)
       ENDCASE
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO DEL FORMATO DE IMPRESION

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA DE IMPRESION                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/2004 LUN A
       Colombia, Bucaramanga        INICIO: 01:40 AM   SEP 08/2004 LUN

OBJETIVOS:

1- Creaci¢n de la estructura de impresi¢n

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaRegPrn(lShared,PathArc,fArchvo,aNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo
       aNroCol                              // N£mero de Columnas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL PathAct := ''                  // Path Actual
       LOCAL cUnidad := ''                  // Unidad
       LOCAL cUniAct := ''                  // Unidad Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       FOR i := 1 TO LEN(aNroCol)
	   AADD(aDbfStr,{'cCampo'+ALLTRIM(STR(i,3)),;
			 'Character',aNroCol[i],0})
       ENDFOR
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       cUniAct := DISKNAME()
       cUnidad := cUnidad(PathArc)

       PathAct := cPathAct()

       IF cUniAct # cUnidad
	  DISKCHANGE(cUnidad)
       ENDIF


       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       IF cUniAct # cUnidad
	  DISKCHANGE(cUniAct)
       ENDIF
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'DBP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DBF DE IMPRESION')
	  CloseDbf('DBP',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
       RETURN NIL
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO..: GRABACION DEL REGISTRO DE IMPRESION                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/2004 LUN A
       Colombia, Bucaramanga        INICIO: 02:00 AM   SEP 08/2004 LUN

OBJETIVOS:

1- Grabaci¢n del registro de impresi¢n

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraDbfPrn(lShared,aTitulo)

*>>>>DESCRIPCION DE PARAMENTROS
/*     lShared                              // Archivos Compartidos
       aTitulo                              // T¡tulos para impresi¢n  */
*>>>>FIN DESCRIPCION DE PARAMENTROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DEL REGISTRO DE IMPRESION
       IF DBP->(lRegLock(lShared,.T.))
	  FOR i := 1 TO LEN(aTitulo)
	    REPL &('DBP->cCampo'+ALLTRIM(STR(i,3))) WITH aTitulo[i]
	    DBP->(DBCOMMIT())
	  ENDFOR
       ELSE
	  cError('NO SE GRABA EL REGISTRO DBF DE IMPRESION')
       ENDIF
       IF lShared
	  DBP->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO DE IMPRESION

/*************************************************************************
* TITULO ..: PATH GENERAL                                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2004 VIE A
       Colombia, Bucaramanga        INICIO: 01:20 AM   SEP 03/2004 VIE

OBJETIVOS:

1- Arma el path General del Archivo

2- Retorna path General

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathSis(cPatDat,PathSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatDat                              // Path para Datos
       PathSis                              // Path General del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DEL PATH DE DATOS
       cPatDat := ALLTRIM(cPatDat)
       IF SUBS(cPatDat,LEN(cPatDat),1) == '\'
	  cPatDat := SUBS(cPatDat,1,LEN(cPatDat)-1)
       ENDIF
*>>>>FIN VALIDACION DEL PATH DE DATOS

*>>>>PATH GENERAL DEL SISTEMA
       cPatDat := ALLTRIM(cPatDat)
       PathSis := ALLTRIM(PathSis)

       PathSis := IF(EMPTY(cPatDat),PathSis,cPatDat+'\'+PathSis)
       RETURN PathSis
*>>>>FIN PATH GENERAL DEL SISTEMA

/*************************************************************************
* TITULO ..: PATH DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2004 VIE A
       Colombia, Bucaramanga        INICIO: 01:30 AM   SEP 03/2004 VIE

OBJETIVOS:

1- Arma el path del Sistema del Archivo

2- Retorna path General

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPatSis(cPatDat,cPatSys,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatDat                              // Path para Datos
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PATH DEL SISTEMA
       cPatDat := ALLTRIM(cPatDat)
       cPatSys := ALLTRIM(cPatSys)
       cPatSis := ALLTRIM(cPatSis)

       IF EMPTY(cPatSys)
	  cPatSis := IF(EMPTY(cPatDat),;
			cPatSis,;
			cPatDat+'\'+cPatSis)
       ELSE
	  cPatSis := IF(EMPTY(cPatDat),;
			cPatSis,;
			cPatDat+'\'+cPatSys+'\'+cPatSis)
       ENDIF

       RETURN cPatSis
*>>>>FIN PATH DEL SISTEMA

/*************************************************************************
* TITULO ..: TIPO DEL CAMPO                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 VIE A
       Colombia, Bucaramanga        INICIO: 08:15 PM   OCT 21/2004 VIE

OBJETIVOS:

2- Retorna el Tipo de Campo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFieldType(Field_Type)

*>>>>DESCRIPCION DE PARAMETROS
/*     Field_Type                           // Tipo del Campo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cTipCam := ''                  // Tipo del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       DO CASE
       CASE UPPER(Field_Type) == 'C'
	    cTipCam := 'Character'

       CASE UPPER(Field_Type) == 'N'
	    cTipCam := 'Numeric'

       CASE UPPER(Field_Type) == 'L'
	    cTipCam := 'Logical'

       CASE UPPER(Field_Type) == 'D'
	    cTipCam := 'Date'

       CASE UPPER(Field_Type) == 'M'
	    cTipCam := 'Memo'

       ENDCASE

       RETURN cTipCam
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: CONTENIDO DEL CAMPO POR LOCALIZACION                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 06/2005 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   ABR 06/2005 MIE

OBJETIVOS:

1- Deben estar en uso el archivo

2- Permite localizar el nombre del campo

3- Si el nombre se incluye en un browse se debe pasar
   el Alias del Archivo del Browse

4- Retorna el contenido del campo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLocNomCam(cCamLoc,cLalias,cCodigo,cCamLee,cNalias)

*>>>>PARAMETROS DE LA FUNCION
/*     cCamLoc                                // Campo a localizar
       cCodigo				      // C¢digo de b£squeda
       cLalias				      // Alias para localizar
       cCamLee                                // Campo a leer
       cNalias                                // Alias del Archivo  */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cConten := ''                    // Contenido del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       IF lLocCodigo(cCamLoc,cLalias,cCodigo)
	  cConten := &(cLalias+'->'+cCamLee)
       ENDIF
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cConten
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO..: A¥O DEL PATH                                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 03/2005 MIE A
       Colombia, Bucaramanga        INICIO: 11:20 PM   AGO 03/2005 MIE

OBJETIVOS:

1- Calcula el a¤o del Path

2- Retorna el a¤o del Path


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cAnoPath(cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatSis                              // Path del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cAnoUsr := ''                  // A¤o del Path
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL A¥O
       nLenTxt := LEN(cPatSis)
       cAnoUsr := SUBS(cPatSis,nLenTxt-7,4)
       RETURN cAnoUsr
*>>>>FIN CALCULO DEL A¥O

/*************************************************************************
* TITULO..: ENTIDAD DE WEBML                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 24/2005 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   NOV 24/2005 VIE

OBJETIVOS:

1- Crea un elemento del archivo xml de una entidad para la
   aplicaci¢n WebRation.

2- Return Nil


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EntidadWeb(aStrDbf,FileTbl,cNroTbl,aLinTxt,nNroAtt)

*>>>>DESCRIPCION DE PARAMENTROS
/*     aStrDbf			            // Estructura de la Tabla
       FileTbl                              // Nombre de la Tabla
       cNroTbl                              // N£mero de la Tabla
       aLinTxt                              // @L¡nea de Texto
       nNroAtt                              // @N£mero de Attributos */
*>>>>FIN DESCRIPCION DE PARAMENTROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNomCam := ''                  // Nombre del Campo
       LOCAL cTipCam := ''                  // Tipo del Campo
       LOCAL nLenCam := ''                  // Longitud del Campo
       LOCAL nNroDec := ''                  // Numero de Decimales

       LOCAL cLinTxt := ''                 // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFICION DE LA TABLA
       cLinTxt := SPACE(08)+;
		  '<ENTITY auxiliary:attributesVisible="true"'+;
			 ' duration="persistent"'+;
			 ' graphmetadata:go="ent'+cNroTbl+'_go"'+;
			 ' id="ent'+cNroTbl+'"'+;
			 ' name="'+FileTbl+'">'
       AADD(aLinTxt,cLinTxt)
*>>>>FIN DEFICION DE LA TABLA

*>>>>>DEFINICION DE LOS ATRIBUTOS
       FOR i := LEN(aStrDbf) TO 1 STEP -1

***********DETALLES DEL CAMPO
	     cNomCam := aStrDbf[i,1]
	     cTipCam := aStrDbf[i,2]
	     nLenCam := aStrDbf[i,3]
	     nNroDec := aStrDbf[i,4]
***********FIN DETALLES DEL CAMPO

***********TIPOS DEL CAMPO
	     DO CASE
	     CASE UPPER(SUBS(cTipCam,1,1)) == 'C'
		  IF nLenCam <= 255
		     cTipCam := 'String'
		  ELSE
		     cTipCam := 'BLOB'
		  ENDIF

	     CASE UPPER(SUBS(cTipCam,1,1)) == 'D'
		  cTipCam := 'Date'

	     CASE UPPER(SUBS(cTipCam,1,1)) == 'L'
		  cTipCam := 'Boolean'

	     CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec == 0
		  cTipCam := 'Number'

	     CASE UPPER(SUBS(cTipCam,1,1)) == 'N' .AND. nNroDec # 0
		  cTipCam := 'Float'
	     ENDCASE
***********FIN TIPOS DEL CAMPO

***********ATRIBUTO DEL XML
	     IF i == 1
		cNomCam := 'OID'
		cTipCam := 'OID'
	     ENDIF

	     cLinTxt := SPACE(12)+;
			'<ATTRIBUTE id="att'+ALLTRIM(STR(++nNroAtt,4))+'"'+;
				  ' name="'+cNomCam+'"'+;
				  ' type="'+cTipCam+'"/>'
	     AADD(aLinTxt,cLinTxt)
***********FIN ATRIBUTO DEL XML

       ENDFOR
       AADD(aLinTxt,SPACE(08)+'</ENTITY>')
       RETURN NIL
*>>>>>FIN DEFINICION DE LOS ATRIBUTOS

/*************************************************************************
* TITULO..: EDICION DE UN CAMPO MEMO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2006 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   AGO 09/2006 MIE

OBJETIVOS:

1- Permite crear o editar un campo memo utiliza la tecla <F2>Grabar

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EditarMemo(cNomSis,cTexto,cTitulo,cTxtHlp,cTitHlp,lModTxt,;
		    nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cTexto		                    // @Contenido del texto
       cTitulo                              // T¡tulo de Ayuda
       cTxtHlp			            // Ayuda de Edicci¢n.
       cTitHlp			            // T¡tulo para la Ayuda
       lModTxt                              // .T. Modificar el texto
       nFilSup                              // Fila Superior
       nColSup                              // Columna Superior
       nFilInf                              // Fila Inferior
       nColInf                              // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARCION DE VARIABLES
       MEMVA xClrSys			    // Color del Sistema
       LOCAL cColAnt := ''                  // Color Anterior

       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARCION DE VARIABLES

*>>>>DIBUJO DEL MARCO
       cColAnt := cSetColor(IF(!EMPTY(xClrSys),xClrSys[4],''))
       cSavPan := SAVESCREEN(0,0,24,79)
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
       lModTxt := IF(lModTxt=NIL,.T.,lModTxt)
       cTexto := MemoEdit(cTexto,;
			  nFilSup+1,nColSup+1,nFilInf-1,nColInf-1,lModTxt,;
			  "MemoFunc")
       SETKEY(K_F1,NIL)
       RESTSCREEN(0,0,24,79,cSavPan)
       cSetColor(cColAnt)
       RETURN NIL
*>>>>FIN EDICION DEL TEXTO DEL ARCHIVO

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2007 JUE A
       Colombia, Bucaramanga        INICIO:  4:33 PM   ABR 19/2007 JUE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CrearDbf(PathArc,fArchvo,aDbfStr)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aDbfStr                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathArc) == 0
            DBCREATE(fArchvo,aDbfStr,'DBFNTX')

       CASE nCd(PathArc) == -3
            cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE nCd(PathArc) == -5
            cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       nCd(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: CAMBIAR EXTENCION DEL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2008 JUE A
       Colombia, Bucaramanga        INICIO:  1:30 AM   MAY 29/2008 JUE

OBJETIVOS:

1- Cambia la Extensi¢n del Archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCambiaExt(fArchvo,FileExt)

*>>>>DESCRIPCION DE PARAMETROS
/*     fArchvo                              // Nombre del Archivo
       FileExt                              // Extensi¢n del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ELIMINACION DE LA EXTENSION DEL ARCHIVO
       nNroPos := AT('.',fArchvo)
       IF nNroPos # 0
	  fArchvo := SUBS(fArchvo,1,nNroPos-1)
       ENDIF
       fArchvo += FileExt
       RETURN fArchvo
*>>>>FIN ELIMINACION DE LA EXTENSION DEL ARCHIVO

/*************************************************************************
* TITULO..: NUMERO DE UNIDAD DE DISCO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 14/2014 MIE A
       Colombia, Bucaramanga        INICIO:  10:10 AM   MAY 14/2014 MIE

OBJETIVOS:

1- Returna la Unidad de Disco

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cUnidad(cPatDir)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatDir                              // Path del directorio */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cUnidad := ''                  // Unidad
*>>>>FIN DECLARACION DE VARIABLES

*>>>>UNIDAD DE DISCO
       IF SUBS(cPatDir,2,1) == ':'
	  cUnidad := UPPER(SUBS(cPatDir,1,1))
       ELSE
	  cUnidad := DISKNAME()
       ENDIF
       RETURN cUnidad
*>>>>FIN UNIDAD DE DISCO



